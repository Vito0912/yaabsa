import 'package:dio/dio.dart';
import 'package:yaabsa/api/filesystem/filesystem_paths_response.dart';
import 'package:yaabsa/api/filesystem/path_exists_response.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/search/search_providers_response.dart';

class UploadApi {
  UploadApi(Dio dio) : _dio = dio;

  final Dio _dio;

  static const _secureExtra = [
    {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
  ];

  Future<Response<SearchProvidersResponse>> getSearchProviders({
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/search/providers',
      fromJson: (data) => SearchProvidersResponse.fromJson(data as Map<String, dynamic>),
      queryParams: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<FilesystemPathsResponse>> getFilesystemPaths({
    String? path,
    int level = 0,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final query = <String, dynamic>{if (path != null && path.trim().isNotEmpty) 'path': path, 'level': level};

    return ABSApi.makeApiGetRequest(
      route: '/api/filesystem',
      fromJson: (data) => FilesystemPathsResponse.fromJson(data as Map<String, dynamic>),
      queryParams: query,
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<PathExistsResponse>> checkPathExists({
    required String directory,
    required String folderPath,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/filesystem/pathexists',
      fromJson: (data) => PathExistsResponse.fromJson(data as Map<String, dynamic>),
      bodyData: {'directory': directory, 'folderPath': folderPath},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<Object>> searchMetadata({
    required String mediaType,
    required String title,
    String? author,
    String? provider,
    bool fallbackTitleOnly = false,
    String? libraryItemId,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) {
    final endpoint = mediaType == 'podcast' ? '/api/search/podcasts' : '/api/search/books';
    final query = <String, String>{
      'title': title,
      if (author != null && author.trim().isNotEmpty) 'author': author.trim(),
      if (provider != null && provider.trim().isNotEmpty) 'provider': provider.trim(),
      if (fallbackTitleOnly) 'fallbackTitleOnly': '1',
      if (libraryItemId != null && libraryItemId.trim().isNotEmpty) 'id': libraryItemId.trim(),
    };

    return ABSApi.makeApiGetRequest(
      route: endpoint,
      fromJson: (data) => data,
      queryParams: query,
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<void> uploadLibraryItem({
    required FormData formData,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) {
    return _dio.request<void>(
      '/api/upload',
      data: formData,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      options: Options(
        method: 'POST',
        contentType: 'multipart/form-data',
        headers: headers,
        extra: {'secure': _secureExtra, ...?extra},
        validateStatus: validateStatus,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
      ),
    );
  }
}
