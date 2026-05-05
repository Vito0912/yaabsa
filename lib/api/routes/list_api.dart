import 'package:yaabsa/api/list/collection.dart';
import 'package:yaabsa/api/list/playlist.dart';
import 'package:yaabsa/api/list/response/collection_response.dart';
import 'package:yaabsa/api/list/response/playlist_response.dart';
import 'package:dio/dio.dart';

import 'abs_api.dart';

class ListApi {
  final Dio _dio;

  ListApi(this._dio);

  Future<Response<PlaylistResponse>> getUserPlaylist({
    bool forceServer = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final requestExtra = <String, dynamic>{...?extra};
    if (forceServer) {
      requestExtra['noCache'] = true;
    }

    return ABSApi.makeApiGetRequest(
      route: '/api/playlists',
      fromJson: (data) => PlaylistResponse.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: requestExtra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<CollectionResponse>> getCollections({
    bool forceServer = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final requestExtra = <String, dynamic>{...?extra};
    if (forceServer) {
      requestExtra['noCache'] = true;
    }

    return ABSApi.makeApiGetRequest(
      route: '/api/collections',
      fromJson: (data) => CollectionResponse.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: requestExtra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<Playlist>> createPlaylist({
    required String libraryId,
    required String name,
    String? description,
    List<Map<String, dynamic>> items = const <Map<String, dynamic>>[],
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/playlists',
      fromJson: (data) => Playlist.fromJson(data),
      bodyData: {'libraryId': libraryId, 'name': name, 'description': ?description, 'items': items},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Playlist>> updatePlaylist(
    String playlistId, {
    String? name,
    String? description,
    List<Map<String, dynamic>>? items,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/playlists/$playlistId',
      fromJson: (data) => Playlist.fromJson(data),
      bodyData: {'name': ?name, 'description': ?description, 'items': ?items},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Playlist>> addItemsToPlaylist(
    String playlistId, {
    required List<Map<String, dynamic>> items,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/playlists/$playlistId/batch/add',
      fromJson: (data) => Playlist.fromJson(data),
      bodyData: {'items': items},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Playlist>> removeItemsFromPlaylist(
    String playlistId, {
    required List<Map<String, dynamic>> items,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/playlists/$playlistId/batch/remove',
      fromJson: (data) => Playlist.fromJson(data),
      bodyData: {'items': items},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<bool> deletePlaylist(
    String playlistId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/playlists/$playlistId',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Collection>> createCollection({
    required String libraryId,
    required String name,
    required List<String> bookIds,
    String? description,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/collections',
      fromJson: (data) => Collection.fromJson(data),
      bodyData: {'libraryId': libraryId, 'name': name, 'description': ?description, 'books': bookIds},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Collection>> updateCollection(
    String collectionId, {
    String? name,
    String? description,
    List<String>? books,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/collections/$collectionId',
      fromJson: (data) => Collection.fromJson(data),
      bodyData: {'name': ?name, 'description': ?description, 'books': ?books},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Collection>> addBooksToCollection(
    String collectionId, {
    required List<String> bookIds,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/collections/$collectionId/batch/add',
      fromJson: (data) => Collection.fromJson(data),
      bodyData: {'books': bookIds},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Collection>> removeBooksFromCollection(
    String collectionId, {
    required List<String> bookIds,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/collections/$collectionId/batch/remove',
      fromJson: (data) => Collection.fromJson(data),
      bodyData: {'books': bookIds},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<bool> deleteCollection(
    String collectionId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/collections/$collectionId',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }
}
