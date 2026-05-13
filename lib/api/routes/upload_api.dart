import 'package:dio/dio.dart';
import 'package:yaabsa/api/filesystem/filesystem_paths_response.dart';
import 'package:yaabsa/api/filesystem/path_exists_response.dart';
import 'package:yaabsa/api/search/search_providers_response.dart';

class UploadApi {
  UploadApi(Dio dio) : _dio = dio;

  final Dio _dio;

  static const _secureExtra = [
    {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
  ];

  Future<SearchProvidersResponse?> getSearchProviders({
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<Object>(
      '/api/search/providers',
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }
    return SearchProvidersResponse.fromJson(data);
  }

  Future<FilesystemPathsResponse?> getFilesystemPaths({
    String? path,
    int level = 0,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final query = <String, dynamic>{if (path != null && path.trim().isNotEmpty) 'path': path, 'level': level};

    final response = await _dio.get<Object>(
      '/api/filesystem',
      queryParameters: query,
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }
    return FilesystemPathsResponse.fromJson(data);
  }

  Future<PathExistsResponse?> checkPathExists({
    required String directory,
    required String folderPath,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.post<Object>(
      '/api/filesystem/pathexists',
      data: {'directory': directory, 'folderPath': folderPath},
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return null;
    }
    return PathExistsResponse.fromJson(data);
  }

  Future<Response<Object>> searchMetadata({
    required String mediaType,
    required String title,
    String? author,
    String? provider,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    CancelToken? cancelToken,
  }) {
    final endpoint = mediaType == 'podcast' ? '/api/search/podcasts' : '/api/search/books';
    final query = <String, String>{
      'title': title,
      if (author != null && author.trim().isNotEmpty) 'author': author.trim(),
      if (provider != null && provider.trim().isNotEmpty) 'provider': provider.trim(),
    };

    return _dio.get<Object>(
      endpoint,
      queryParameters: query,
      cancelToken: cancelToken,
      options: Options(headers: headers, extra: {'secure': _secureExtra, ...?extra}),
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
