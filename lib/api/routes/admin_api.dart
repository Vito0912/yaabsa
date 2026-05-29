import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:yaabsa/api/admin/admin_api_key_response.dart';
import 'package:yaabsa/api/admin/admin_api_keys_response.dart';
import 'package:yaabsa/api/admin/admin_authentication_settings.dart';
import 'package:yaabsa/api/admin/admin_backup_list_response.dart';
import 'package:yaabsa/api/admin/admin_backups_response.dart';
import 'package:yaabsa/api/admin/admin_email_ereader_devices_response.dart';
import 'package:yaabsa/api/admin/admin_email_settings_response.dart';
import 'package:yaabsa/api/admin/admin_openid_issuer_config.dart';
import 'package:yaabsa/api/admin/admin_rss_feed.dart';
import 'package:yaabsa/api/admin/admin_user.dart';
import 'package:yaabsa/api/admin/admin_user_list_response.dart';
import 'package:yaabsa/api/admin/admin_user_upsert_request.dart';
import 'package:yaabsa/api/admin/admin_users_response.dart';
import 'package:yaabsa/api/admin/create_admin_api_key_request.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_request.dart';
import 'package:yaabsa/api/admin/create_custom_metadata_provider_response.dart';
import 'package:yaabsa/api/admin/custom_metadata_providers_response.dart';
import 'package:yaabsa/api/admin/genres_response.dart';
import 'package:yaabsa/api/admin/logger_data.dart';
import 'package:yaabsa/api/admin/metadata_term_update_response.dart';
import 'package:yaabsa/api/admin/sorting_prefixes_update_response.dart';
import 'package:yaabsa/api/admin/tags_response.dart';
import 'package:yaabsa/api/admin/update_admin_authentication_settings_request.dart';
import 'package:yaabsa/api/admin/update_admin_authentication_settings_response.dart';
import 'package:yaabsa/api/admin/update_admin_email_ereader_devices_request.dart';
import 'package:yaabsa/api/admin/update_admin_email_settings_request.dart';
import 'package:yaabsa/api/admin/update_admin_api_key_request.dart';
import 'package:yaabsa/api/admin/update_backup_path_request.dart';
import 'package:yaabsa/api/me/server_settings.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/tasks/abs_task_list_response.dart';

class AdminApi {
  AdminApi(this._dio);

  final Dio _dio;

  static const Map<String, dynamic> _secureExtra = <String, dynamic>{
    'secure': <Map<String, String>>[
      {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
    ],
  };

  String _encodeMetadataTerm(String value) {
    final encoded = base64.encode(utf8.encode(value));
    return Uri.encodeComponent(encoded);
  }

  Map<String, dynamic> _upsertRequestBody(AdminUserUpsertRequest payload) {
    final normalizedType = payload.type.trim().toLowerCase();
    final isSupportedType =
        normalizedType == 'admin' || normalizedType == 'user' || normalizedType == 'guest' || normalizedType == 'root';
    final resolvedType = isSupportedType ? normalizedType : 'user';

    final permissions = payload.permissions;
    final librariesAccessible = permissions.accessAllLibraries ? const <String>[] : payload.librariesAccessible;
    final itemTagsSelected = permissions.accessAllTags ? const <String>[] : payload.itemTagsSelected;

    final permissionsPayload = Map<String, dynamic>.from(permissions.toJson())
      ..remove('librariesAccessible')
      ..remove('itemTagsSelected');

    final body = <String, dynamic>{
      ...payload.toJson(),
      'username': payload.username.trim(),
      'password': payload.password?.trim(),
      'email': payload.email?.trim(),
      'type': resolvedType,
      'permissions': permissionsPayload,
      'librariesAccessible': librariesAccessible,
      'itemTagsSelected': itemTagsSelected,
    };

    body.removeWhere((key, value) => value == null);
    return body;
  }

  Future<Response<AdminUser?>> _upsertUser({
    required String method,
    required String route,
    required AdminUserUpsertRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: method,
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'application/json',
    );

    final response = await _dio.request<Object>(
      route,
      data: _upsertRequestBody(payload),
      options: options,
      cancelToken: cancelToken,
    );
    final parsedUser = AdminUser.fromApiResponse(response.data);

    return Response<AdminUser?>(
      data: parsedUser,
      headers: response.headers,
      isRedirect: response.isRedirect,
      requestOptions: response.requestOptions,
      redirects: response.redirects,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  Future<bool> _patchStatusOnly({
    required String route,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'PATCH',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'application/json',
    );

    try {
      final response = await _dio.request<Object>(route, options: options, cancelToken: cancelToken);
      final statusCode = response.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<Response<MetadataTermUpdateResponse>> _deleteMetadataTerm({
    required String route,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequestWithResponse(
      route: route,
      fromJson: (data) => MetadataTermUpdateResponse.fromJson(data as Map<String, dynamic>),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
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

  Future<Response<AbsTaskListResponse>> getTasks({
    bool includeQueue = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/tasks',
      fromJson: (data) => AbsTaskListResponse.fromJson(data as Map<String, dynamic>),
      queryParams: {'include': includeQueue ? 'queue' : null},
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

  Future<Response<AdminApiKeysResponse>> getApiKeys({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/api-keys',
      fromJson: (data) => AdminApiKeysResponse.fromJson(data as Map<String, dynamic>),
      queryParams: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminBackupsResponse>> getBackups({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/backups',
      fromJson: (data) => AdminBackupsResponse.fromJson(data as Map<String, dynamic>),
      queryParams: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminRssFeedsResponse>> getFeeds({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/feeds',
      fromJson: (data) => AdminRssFeedsResponse.fromJson(data as Map<String, dynamic>),
      queryParams: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminAuthenticationSettings>> getAuthenticationSettings({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/auth-settings',
      fromJson: (data) => AdminAuthenticationSettings.fromJson(data as Map<String, dynamic>),
      queryParams: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<UpdateAdminAuthenticationSettingsResponse>> updateAuthenticationSettings({
    required UpdateAdminAuthenticationSettingsRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/auth-settings',
      fromJson: (data) => UpdateAdminAuthenticationSettingsResponse.fromJson(data as Map<String, dynamic>),
      bodyData: Map<String, dynamic>.from(payload.toJson())..removeWhere((key, value) => value == null),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminOpenIdIssuerConfig>> getOpenIdIssuerConfiguration({
    required String issuer,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/auth/openid/config',
      fromJson: (data) => AdminOpenIdIssuerConfig.fromJson(data as Map<String, dynamic>),
      queryParams: <String, dynamic>{'issuer': issuer},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminEmailSettingsResponse>> getEmailSettings({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/emails/settings',
      fromJson: (data) => AdminEmailSettingsResponse.fromJson(data as Map<String, dynamic>),
      queryParams: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminEmailSettingsResponse>> updateEmailSettings({
    required UpdateAdminEmailSettingsRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/emails/settings',
      fromJson: (data) => AdminEmailSettingsResponse.fromJson(data as Map<String, dynamic>),
      bodyData: Map<String, dynamic>.from(payload.toJson())..removeWhere((key, value) => value == null),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<bool> sendEmailTest({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'application/json',
    );

    try {
      final response = await _dio.request<Object>(
        '/api/emails/test',
        data: const <String, dynamic>{},
        options: options,
        cancelToken: cancelToken,
      );

      final statusCode = response.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<Response<AdminEmailEreaderDevicesResponse>> updateEmailEreaderDevices({
    required UpdateAdminEmailEreaderDevicesRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/emails/ereader-devices',
      fromJson: (data) => AdminEmailEreaderDevicesResponse.fromJson(data as Map<String, dynamic>),
      bodyData: payload.toJson(),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<bool> closeFeed(
    String feedId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'application/json',
    );

    try {
      final response = await _dio.request<Object>(
        '/api/feeds/$feedId/close',
        data: const <String, dynamic>{},
        options: options,
        cancelToken: cancelToken,
      );

      final statusCode = response.statusCode;
      return statusCode != null && statusCode >= 200 && statusCode < 300;
    } catch (_) {
      return false;
    }
  }

  Future<Response<AdminBackupListResponse>> createBackup({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/backups',
      fromJson: (data) => AdminBackupListResponse.fromJson(data as Map<String, dynamic>),
      bodyData: const <String, dynamic>{},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminBackupListResponse>> deleteBackup(
    String backupId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequestWithResponse(
      route: '/api/backups/$backupId',
      fromJson: (data) => AdminBackupListResponse.fromJson(data as Map<String, dynamic>),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminBackupListResponse>> uploadBackup({
    required FormData formData,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'multipart/form-data',
    );

    final response = await _dio.request<Object>(
      '/api/backups/upload',
      data: formData,
      options: options,
      cancelToken: cancelToken,
    );

    return Response<AdminBackupListResponse>(
      data: AdminBackupListResponse.fromJson(response.data as Map<String, dynamic>),
      headers: response.headers,
      isRedirect: response.isRedirect,
      requestOptions: response.requestOptions,
      redirects: response.redirects,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
      extra: response.extra,
    );
  }

  Future<void> updateBackupPath({
    required UpdateBackupPathRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'PATCH',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'application/json',
    );

    await _dio.request<Object>('/api/backups/path', data: payload.toJson(), options: options, cancelToken: cancelToken);
  }

  Future<void> applyBackup({
    required String backupId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final options = Options(
      method: 'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{..._secureExtra, ...?extra},
      contentType: 'application/json',
    );

    await _dio.request<Object>('/api/backups/$backupId/apply', options: options, cancelToken: cancelToken);
  }

  Future<Response<AdminApiKeyResponse>> createApiKey({
    required CreateAdminApiKeyRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/api-keys',
      fromJson: (data) => AdminApiKeyResponse.fromJson(data as Map<String, dynamic>),
      bodyData: Map<String, dynamic>.from(payload.toJson())..removeWhere((key, value) => value == null),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminApiKeyResponse>> updateApiKey({
    required String apiKeyId,
    required UpdateAdminApiKeyRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/api-keys/$apiKeyId',
      fromJson: (data) => AdminApiKeyResponse.fromJson(data as Map<String, dynamic>),
      bodyData: Map<String, dynamic>.from(payload.toJson())..removeWhere((key, value) => value == null),
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<bool> deleteApiKey(
    String apiKeyId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/api-keys/$apiKeyId',
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminUserListResponse>> getUsersDetailed({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/users',
      fromJson: (data) => AdminUserListResponse.fromResponse(data),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminUser?>> getUserById(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/users/$userId',
      fromJson: (data) => AdminUser.fromApiResponse(data),
      queryParams: {},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminUser?>> createUser({
    required AdminUserUpsertRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return _upsertUser(
      method: 'POST',
      route: '/api/users',
      payload: payload,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<Response<AdminUser?>> updateUser({
    required String userId,
    required AdminUserUpsertRequest payload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return _upsertUser(
      method: 'PATCH',
      route: '/api/users/$userId',
      payload: payload,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<bool> deleteUser(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/users/$userId',
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }

  Future<bool> unlinkUserOpenId(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return _patchStatusOnly(
      route: '/api/users/$userId/openid-unlink',
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

  Future<Response<SortingPrefixesUpdateResponse>> updateSortingPrefixes({
    required List<String> sortingPrefixes,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPatchRequest(
      route: '/api/sorting-prefixes',
      fromJson: (data) => SortingPrefixesUpdateResponse.fromJson(data as Map<String, dynamic>),
      bodyData: <String, dynamic>{'sortingPrefixes': sortingPrefixes},
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );
  }
}
