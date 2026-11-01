import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
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

Collection collection(
  String id, {
  List<LibraryItem>? books = const [],
  String libraryId = 'library',
  int revision = 1,
}) {
  return Collection(id: id, libraryId: libraryId, name: id, items: books, lastUpdate: revision, createdAt: 0);
}

class CollectionTestServer {
  CollectionTestServer(this.collections) {
    final dio = Dio(BaseOptions(baseUrl: 'https://test.invalid'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (request, handler) async {
          requests.add(request);
          try {
            if (request.method == 'GET') {
              if (failReads) throw Exception('Offline');
              Object payload = {'collections': collections};
              if (request.path.startsWith('/api/libraries/')) {
                final libraryId = request.path.split('/')[3];
                final page = int.parse('${request.uri.queryParameters['page']}');
                final limit = int.parse('${request.uri.queryParameters['limit']}');
                final matching = collections.where((entry) => entry.libraryId == libraryId).toList();
                payload = {
                  'results': matching.skip(page * limit).take(limit).toList(),
                  'total': matching.length,
                  'page': page,
                  'limit': limit,
                };
              }
              if (request.path.startsWith('/api/collections/')) {
                final id = request.path.split('/')[3];
                final status = readStatusById[id];
                if (status != null) {
                  throw DioException(
                    requestOptions: request,
                    response: Response(requestOptions: request, statusCode: status),
                  );
                }
                payload = collections.firstWhere((entry) => entry.id == id);
              }
              final data = jsonDecode(jsonEncode(payload));
              await beforeRead?.call();
              handler.resolve(Response(requestOptions: request, statusCode: 200, data: data));
              return;
            }
            await beforeMutation?.call();
            if (request.method == 'POST' && request.path == '/api/collections') {
              final created = collection(
                'created-${collections.length}',
                libraryId: request.data['libraryId'] as String,
                books: (request.data['books'] as List).map((id) => testBook.copyWith(id: id as String)).toList(),
              ).copyWith(name: request.data['name'] as String);
              collections.add(created);
              handler.resolve(
                Response(requestOptions: request, statusCode: 200, data: jsonDecode(jsonEncode(created))),
              );
              return;
            }
            final id = request.path.split('/')[3];
            if (failIds.contains(id)) throw Exception('Mutation failed');
            final index = collections.indexWhere((entry) => entry.id == id);
            final current = collections[index];
            final ids = (request.data['books'] as List).cast<String>().toSet();
            final books = [...?current.items];
            if (request.path.endsWith('/add')) {
              final existingIds = books.map((book) => book.id).toSet();
              books.addAll(ids.where((id) => !existingIds.contains(id)).map((id) => testBook.copyWith(id: id)));
            } else {
              books.removeWhere((book) => ids.contains(book.id));
            }
            final updated = current.copyWith(
              items: books,
              numBooks: current.numBooks == null ? null : books.length,
              lastUpdate: current.lastUpdate + 1,
            );
            collections[index] = updated;
            handler.resolve(Response(requestOptions: request, statusCode: 200, data: jsonDecode(jsonEncode(updated))));
          } catch (error) {
            handler.reject(error is DioException ? error : DioException(requestOptions: request, error: error));
          }
        },
      ),
    );
    api = ABSApi(dio: dio, interceptors: []);
  }

  List<Collection> collections;
  final requests = <RequestOptions>[];
  final failIds = <String>{};
  final readStatusById = <String, int>{};
  bool failReads = false;
  Future<void> Function()? beforeMutation;
  Future<void> Function()? beforeRead;
  late final ABSApi api;

  ProviderContainer container({bool allowed = true}) => ProviderContainer(
    retry: (_, _) => null,
    overrides: [
      absApiProvider.overrideWithValue(api),
      collectionMembershipEditingAllowedProvider.overrideWithValue(allowed),
    ],
  );
}
