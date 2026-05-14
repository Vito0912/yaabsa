import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yaabsa/api/admin/admin_users_response.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_request.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_response.dart';
import 'package:yaabsa/api/admin/custom_metadata_providers_response.dart';
import 'package:yaabsa/api/admin/genres_response.dart';
import 'package:yaabsa/api/admin/logger_data.dart';
import 'package:yaabsa/api/admin/metadata_term_update_response.dart';
import 'package:yaabsa/api/admin/tags_response.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

class AdminApi {
  AdminApi(this._dio);

  final Dio _dio;

  String _encodeMetadataTerm(String value) {
    final encoded = base64.encode(utf8.encode(value));
    return Uri.encodeComponent(encoded);
  }

  Future<Response<MetadataTermUpdateResponse>> _deleteMetadataTerm({
    required String route,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'DELETE',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
    );

    final response = await _dio.request<Object>(route, options: options, cancelToken: cancelToken);

    final responseData = response.data;
    final parsed = responseData is Map<String, dynamic>
        ? responseData
        : responseData is Map
        ? Map<String, dynamic>.from(responseData)
        : const <String, dynamic>{};

    return Response<MetadataTermUpdateResponse>(
      data: MetadataTermUpdateResponse.fromJson(parsed),
      headers: response.headers,
      isRedirect: response.isRedirect,
      requestOptions: response.requestOptions,
      redirects: response.redirects,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  Future<Response<LoggerData>> getLoggerData({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/logger-data',
      fromJson: (data) => LoggerData.fromJson(data as Map<String, dynamic>),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminUsersResponse>> getUsers({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/users',
      fromJson: (data) => AdminUsersResponse.fromDynamic(data),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<TagsResponse>> getTags({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/tags',
      fromJson: (data) => TagsResponse.fromJson(data as Map<String, dynamic>),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<GenresResponse>> getGenres({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/genres',
      fromJson: (data) => GenresResponse.fromJson(data as Map<String, dynamic>),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<MetadataTermUpdateResponse>> renameTag({
    required String tag,
    required String newTag,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/tags/rename',
      fromJson: (data) => MetadataTermUpdateResponse.fromJson(data),
      bodyData: {'tag': tag, 'newTag': newTag},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<MetadataTermUpdateResponse>> deleteTag({
    required String tag,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final encodedTag = _encodeMetadataTerm(tag);
    return _deleteMetadataTerm(
      route: '/api/tags/$encodedTag',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<MetadataTermUpdateResponse>> renameGenre({
    required String genre,
    required String newGenre,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/genres/rename',
      fromJson: (data) => MetadataTermUpdateResponse.fromJson(data),
      bodyData: {'genre': genre, 'newGenre': newGenre},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<MetadataTermUpdateResponse>> deleteGenre({
    required String genre,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final encodedGenre = _encodeMetadataTerm(genre);
    return _deleteMetadataTerm(
      route: '/api/genres/$encodedGenre',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<CustomMetadataProvidersResponse>> getCustomMetadataProviders({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/custom-metadata-providers',
      fromJson: (data) => CustomMetadataProvidersResponse.fromJson(data as Map<String, dynamic>),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<CreateCustomMetadataProviderResponse>> createCustomMetadataProvider({
    required CreateCustomMetadataProviderRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/custom-metadata-providers',
      fromJson: (data) => CreateCustomMetadataProviderResponse.fromJson(data),
      bodyData: Map<String, dynamic>.from(payload.toJson())..removeWhere((key, value) => value == null),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<bool> deleteCustomMetadataProvider(
    String providerId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/custom-metadata-providers/$providerId',
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<ServerSettings?>> updateServerSettings({
    required ServerSettings settingsUpdate,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/settings',
      fromJson: (data) {
        final rawSettings = data['serverSettings'];
        if (rawSettings is Map<String, dynamic>) {
          return ServerSettings.fromJson(rawSettings);
        }
        if (rawSettings is Map) {
          return ServerSettings.fromJson(Map<String, dynamic>.from(rawSettings));
        }
        return null;
      },
      bodyData: Map<String, dynamic>.from(settingsUpdate.toJson())
        ..removeWhere((key, value) => value == null || key == 'id'),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }
}
