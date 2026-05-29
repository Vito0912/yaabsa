import 'package:yaabsa/api/library/author_details.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_authors.dart';
import 'package:yaabsa/api/library/library_items.dart';
import 'package:yaabsa/api/library/personalized_library.dart';
import 'package:yaabsa/api/library/request/create_library_request.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library/request/reorder_library_entry_request.dart';
import 'package:yaabsa/api/library/request/update_library_request.dart';
import 'package:yaabsa/api/library/response/library_details_response.dart';
import 'package:yaabsa/api/library/response/library_response.dart';
import 'package:yaabsa/api/library/response/remove_library_metadata_response.dart';
import 'package:yaabsa/api/library/search_library.dart';
import 'package:yaabsa/api/library/series_items.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
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

  Future<Response<Library>> createLibrary(
    CreateLibraryRequest request, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/libraries',
      fromJson: (data) => Library.fromJson(data as Map<String, dynamic>),
      bodyData: Map<String, dynamic>.from(request.toJson())..removeWhere((key, value) => value == null),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Library>> updateLibrary(
    String libraryId,
    UpdateLibraryRequest request, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/libraries/$libraryId',
      fromJson: (data) => Library.fromJson(data as Map<String, dynamic>),
      bodyData: Map<String, dynamic>.from(request.toJson())..removeWhere((key, value) => value == null),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<LibraryResponse>> reorderLibraries(
    List<ReorderLibraryEntryRequest> entries, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/libraries/order',
      fromJson: (data) => LibraryResponse.fromJson(data),
      bodyData: entries.map((entry) => entry.toJson()).toList(growable: false),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<bool> scanLibrary(
    String libraryId, {
    bool forceRescan = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final response = await ABSApi.makeApiPostRequest<bool>(
      route: '/api/libraries/$libraryId/scan?force=${forceRescan ? 1 : 0}',
      fromJson: null,
      bodyData: const <String, dynamic>{},
      returnData: true,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    return response.data ?? false;
  }

  Future<bool> matchAllBooks(
    String libraryId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final response = await ABSApi.makeApiGetRequest<bool>(
      route: '/api/libraries/$libraryId/matchall',
      fromJson: (_) => true,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );

    return response.data ?? false;
  }

  Future<Response<RemoveLibraryMetadataResponse>> removeLibraryMetadata(
    String libraryId, {
    required String extension,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/libraries/$libraryId/remove-metadata?ext=${Uri.encodeQueryComponent(extension)}',
      fromJson: (data) => RemoveLibraryMetadataResponse.fromJson(data),
      bodyData: const <String, dynamic>{},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Library>> deleteLibrary(
    String libraryId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequestWithResponse(
      route: '/api/libraries/$libraryId',
      fromJson: (data) => Library.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
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

  Future<Response<LibraryDetailsResponse>> getLibraryDetails(
    String libraryId, {
    String? include,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final queryParams = <String, dynamic>{};
    if (include != null && include.isNotEmpty) {
      queryParams['include'] = include;
    }

    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId',
      fromJson: (data) => LibraryDetailsResponse.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: queryParams,
    );
  }

  Future<Response<LibraryDetailsResponse>> getLibraryFilterData(
    String libraryId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return getLibraryDetails(
      libraryId,
      include: 'filterdata',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
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
    int? limit = 50,
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
      queryParams: {'q': search, 'limit': limit ?? 50},
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

  Future<Response<LibraryAuthors>> getLibraryAuthors(
    String libraryId,
    LibraryItemsRequest request, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId/authors',
      fromJson: (data) => LibraryAuthors.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: request.toJson(),
    );
  }

  Future<Response<AuthorDetails>> getAuthorById(
    String authorId, {
    String? include,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final queryParams = <String, dynamic>{};
    if (include != null && include.isNotEmpty) {
      queryParams['include'] = include;
    }

    return ABSApi.makeApiGetRequest(
      route: '/api/authors/$authorId',
      fromJson: (data) => AuthorDetails.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: queryParams,
    );
  }

  Future<bool> deleteAuthor(
    String authorId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/authors/$authorId',
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<Series>> getSeriesById(
    String seriesId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/series/$seriesId',
      fromJson: (data) => Series.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<PersonalizedLibrary>> getPersonalized(
    String libraryId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/libraries/$libraryId/personalized',
      fromJson: (data) => PersonalizedLibrary.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {'include': 'rssfeed,numEpisodesIncomplete,share'},
    );
  }
}
