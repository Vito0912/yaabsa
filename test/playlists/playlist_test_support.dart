import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/playlist_item.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/me/permissions.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

const testBook = LibraryItem(
  id: 'book',
  ino: 'ino',
  libraryId: 'library',
  mediaType: 'book',
  media: null,
  libraryFiles: null,
);
const otherBook = LibraryItem(id: 'other', ino: 'other', media: null, libraryFiles: null);

const bookEntry = PlaylistItem(itemId: 'book');
const otherEntry = PlaylistItem(itemId: 'other');

Playlist playlist(
  String id, {
  List<PlaylistItem>? items = const [],
  String libraryId = 'library',
  String? userId = 'user',
  int revision = 1,
}) =>
    Playlist(id: id, libraryId: libraryId, userId: userId, name: id, items: items, lastUpdate: revision, createdAt: 0);

User playlistUser(String id) => User(
  id: id,
  username: id,
  email: null,
  type: 'user',
  token: null,
  permissions: const Permissions(
    download: false,
    update: false,
    delete: false,
    upload: false,
    accessAllLibraries: true,
    accessAllTags: true,
    accessExplicitContent: true,
  ),
);

class PlaylistTestServer {
  PlaylistTestServer(this.playlists) {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          requests.add(request);
          try {
            if (request.method == 'GET') {
              if (failReads) throw Exception('Offline');
              Object payload = {'playlists': playlists};
              if (request.path.startsWith('/api/libraries/')) {
                final libraryId = request.path.split('/')[3];
                final page = int.parse('${request.uri.queryParameters['page']}');
                final limit = int.parse('${request.uri.queryParameters['limit']}');
                final matching = playlists.where((entry) => entry.libraryId == libraryId).toList();
                payload = {
                  'results': matching.skip(page * limit).take(limit).toList(),
                  'total': matching.length,
                  'page': page,
                  'limit': limit,
                };
              }
              final data = jsonDecode(jsonEncode(payload));
              await beforeRead?.call();
              handler.resolve(Response(requestOptions: request, statusCode: 200, data: data));
              return;
            }
            await beforeMutation?.call();
            final id = request.path.split('/')[3];
            if (failIds.contains(id)) throw Exception('Mutation failed');
            final index = playlists.indexWhere((entry) => entry.id == id);
            final current = playlists[index];
            final changes = (request.data['items'] as List)
                .map(
                  (item) =>
                      PlaylistItem(itemId: item['libraryItemId'] as String, episodeId: item['episodeId'] as String?),
                )
                .toList();
            final entries = [...?current.items];
            if (request.path.endsWith('/add')) {
              for (final change in changes) {
                if (!entries.any((entry) => entry.itemId == change.itemId && entry.episodeId == change.episodeId)) {
                  entries.add(change);
                }
              }
            } else {
              entries.removeWhere(
                (entry) =>
                    changes.any((change) => entry.itemId == change.itemId && entry.episodeId == change.episodeId),
              );
            }
            final updated = current.copyWith(items: entries, lastUpdate: current.lastUpdate + 1);
            if (request.path.endsWith('/remove') && entries.isEmpty) {
              playlists.removeAt(index);
            } else {
              playlists[index] = updated;
            }
            handler.resolve(Response(requestOptions: request, statusCode: 200, data: jsonDecode(jsonEncode(updated))));
          } catch (error) {
            handler.reject(DioException(requestOptions: request, error: error));
          }
        },
      ),
    );
    api = ABSApi(dio: dio, interceptors: []);
  }

  List<Playlist> playlists;
  final requests = <RequestOptions>[];
  final failIds = <String>{};
  bool failReads = false;
  Future<void> Function()? beforeMutation;
  Future<void> Function()? beforeRead;
  late final ABSApi api;

  Future<ProviderContainer> container({bool allowed = true, String userId = 'user'}) async {
    final container = ProviderContainer(
      overrides: [
        absApiProvider.overrideWithValue(api),
        currentUserProvider.overrideWith((ref) => Stream.value(allowed ? playlistUser(userId) : null)),
      ],
    );
    container.listen(currentUserProvider, (_, _) {});
    await container.read(currentUserProvider.future).timeout(const Duration(seconds: 5));
    return container;
  }
}
