import 'package:buchshelfly/api/library/library_items.dart';
import 'package:buchshelfly/api/library/request/library_items_request.dart';
import 'package:buchshelfly/api/library/response/library_response.dart';
import 'package:buchshelfly/api/library/search_library.dart';
import 'package:buchshelfly/api/library/series_items.dart';
import 'package:buchshelfly/api/library/stats/library_stats.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:dio/dio.dart';

class LibraryApi {
  final Dio _dio;

  LibraryApi(this._dio);

  Future<Response<LibraryResponse>> getLibraries({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries',
      fromJson: (data) => LibraryResponse.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<LibraryStats>> getLibraryStats(
    String libraryId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId/stats',
      fromJson: (data) => LibraryStats.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<LibraryItems>> getLibraryItems(
    String libraryId,
    LibraryItemsRequest request, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId/items',
      fromJson: (data) => LibraryItems.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: request.toJson(),
    );
  }

  Future<Response<SearchLibrary>> getSearchLibrary(
    String libraryId,
    String search, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId/search',
      fromJson: (data) => SearchLibrary.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {'q': search, 'limit': 50},
    );
  }

  Future<Response<SeriesItems>> getLibrarySeries(
    String libraryId,
    LibraryItemsRequest request, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId/series',
      fromJson: (data) => SeriesItems.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: request.toJson(),
    );
  }
}
