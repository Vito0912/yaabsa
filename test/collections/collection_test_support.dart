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
              final data = jsonDecode(jsonEncode({'collections': collections}));
              await beforeRead?.call();
              handler.resolve(Response(requestOptions: request, statusCode: 200, data: data));
              return;
            }
            await beforeMutation?.call();
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
            handler.reject(DioException(requestOptions: request, error: error));
          }
        },
      ),
    );
    api = ABSApi(dio: dio, interceptors: []);
  }

  List<Collection> collections;
  final requests = <RequestOptions>[];
  final failIds = <String>{};
  bool failReads = false;
  Future<void> Function()? beforeMutation;
  Future<void> Function()? beforeRead;
  late final ABSApi api;

  ProviderContainer container({bool allowed = true}) => ProviderContainer(
    overrides: [
      absApiProvider.overrideWithValue(api),
      collectionMembershipEditingAllowedProvider.overrideWithValue(allowed),
    ],
  );
}
