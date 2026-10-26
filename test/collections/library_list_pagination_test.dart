import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/list/response/library_list_page.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';

import 'collection_test_support.dart';
import '../playlists/playlist_test_support.dart' as playlists;

void main() {
  test('oversized server pages advance past all received entries without duplicates', () async {
    for (final kind in ['collections', 'playlists']) {
      for (final count in [121, 5101]) {
        final entries = List.generate(
          count,
          (index) => kind == 'collections' ? collection('Collection $index') : playlists.playlist('Playlist $index'),
        );
        final requests = <RequestOptions>[];
        final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
        addTearDown(dio.close);
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (request, handler) {
              requests.add(request);
              final limit = request.uri.queryParameters['limit']!;
              final page = int.parse(request.uri.queryParameters['page']!);
              final start = page * int.parse(limit);
              // Match the server's slice(start, start + limit) when limit is a query string.
              final end = int.parse('$start$limit');
              handler.resolve(
                Response(
                  requestOptions: request,
                  statusCode: 200,
                  data: jsonDecode(
                    jsonEncode({
                      'results': entries.skip(start).take(end - start).toList(),
                      'total': entries.length,
                      'limit': limit,
                      'page': '$page',
                    }),
                  ),
                ),
              );
            },
          ),
        );
        final api = ABSApi(dio: dio, interceptors: []).getListApi();
        final result = kind == 'collections'
            ? await api.getAllLibraryCollections('library')
            : await api.getAllLibraryPlaylists('library');
        expect(result, entries);
        expect(
          requests.map((request) => request.uri.queryParameters['page']),
          count == 121 ? ['0', '1'] : ['0', '1', '101'],
        );
      }
    }
  });

  test('collection pages are library scoped and complete consumers fetch every page', () async {
    final server = CollectionTestServer([
      for (var index = 0; index < 121; index++) collection('Collection $index'),
      collection('Other library', libraryId: 'elsewhere'),
    ]);
    final items = await server.api.getListApi().getAllLibraryCollections('library', forceServer: true);
    expect(items, hasLength(121));
    expect(items.every((item) => item.libraryId == 'library'), isTrue);
    expect(server.requests.map((request) => request.uri.path).toSet(), {'/api/libraries/library/collections'});
    expect(server.requests.map((request) => request.uri.queryParameters['page']), ['0', '1', '2']);
    expect(server.requests.every((request) => request.uri.queryParameters['limit'] == '50'), isTrue);
    expect(server.requests.every((request) => request.extra['noCache'] == true), isTrue);
  });

  test('playlist pages preserve server order and request options used by Android Auto', () async {
    final server = playlists.PlaylistTestServer([
      for (var index = 0; index < 103; index++) playlists.playlist('Playlist $index'),
      playlists.playlist('Other library', libraryId: 'elsewhere'),
    ]);
    final items = await server.api.getListApi().getAllLibraryPlaylists('library', extra: {'doNotCache': true});
    expect(items.map((item) => item.id), List.generate(103, (index) => 'Playlist $index'));
    expect(server.requests.map((request) => request.uri.path).toSet(), {'/api/libraries/library/playlists'});
    expect(server.requests.map((request) => request.uri.queryParameters['page']), ['0', '1', '2']);
    expect(server.requests.every((request) => request.extra['doNotCache'] == true), isTrue);
  });

  test('invalid or missing page data cannot be mistaken for an empty list', () {
    expect(
      () => LibraryListPage<String>.fromJson(
        {'total': 0},
        (json) => json['id'] as String,
        requestedPage: 0,
        requestedLimit: 50,
      ),
      throwsFormatException,
    );
    expect(
      () => LibraryListPage<String>.fromJson(
        {
          'results': [
            {'id': 'a'},
          ],
          'total': 51,
          'page': 0,
          'limit': 50,
        },
        (json) => json['id'] as String,
        requestedPage: 0,
        requestedLimit: 50,
      ),
      throwsFormatException,
    );
    final page = LibraryListPage<String>.fromJson(
      {'results': [], 'total': 0, 'page': '0', 'limit': '50'},
      (json) => json['id'] as String,
      requestedPage: 0,
      requestedLimit: 50,
    );
    expect(page.items, isEmpty);
    expect(page.hasMore, isFalse);
  });

  test('library list pages reuse existing cache preferences', () {
    for (final kind in ['collections', 'playlists']) {
      final route = cacheRouteDefinitions.singleWhere((route) => route.pathPattern == '/api/$kind');
      expect(route.matches('/api/libraries/library/$kind?page=1&limit=50'), isTrue);
      expect(route.matches('/api/$kind'), isTrue);
      expect(route.matches('/api/libraries/library/items'), isFalse);
    }
  });
}
