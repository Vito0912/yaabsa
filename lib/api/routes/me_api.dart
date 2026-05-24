import 'dart:convert';

import 'package:yaabsa/api/library/stats/listening_sessions_page.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/api/library/stats/year_in_review_stats.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/login.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/me/status.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/me/user_message_consents.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';

class MeApi {
  final Dio _dio;

  MeApi(this._dio);

  ListeningSessionsPage _parseListeningSessionsPage(
    dynamic data, {
    required String route,
    required int page,
    required int itemsPerPage,
  }) {
    try {
      if (data is Map<String, dynamic>) {
        return ListeningSessionsPage.fromJson(data);
      }
      if (data is Map) {
        return ListeningSessionsPage.fromJson(Map<String, dynamic>.from(data));
      }
      throw FormatException('Expected JSON object but received ${data.runtimeType}');
    } catch (error, stackTrace) {
      logger(
        'Failed to parse $route response for page=$page itemsPerPage=$itemsPerPage: '
        '$error\nPayload: ${jsonEncode(data)}\n$stackTrace',
        tag: 'MeApi',
        level: InfoLevel.error,
      );
      rethrow;
    }
  }

  Future<Response<Login>> login({
    required LoginRequest loginRequest,
    bool returnTokens = false,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final requestHeaders = <String, dynamic>{...?headers};
    if (returnTokens) {
      requestHeaders['x-return-tokens'] = 'true';
    }

    return ABSApi.makeApiPostRequest(
      route: '/login',
      fromJson: (data) => Login.fromJson(data),
      bodyData: loginRequest.toJson(),
      cancelToken: cancelToken,
      headers: requestHeaders,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<Login>> checkLogin({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/authorize',
      fromJson: (data) => Login.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      bodyData: {},
    );
  }

  Future<Response<Login>> refreshAuth({
    String? refreshToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final requestHeaders = <String, dynamic>{...?headers};
    final requestExtra = <String, dynamic>{'skip_auth_refresh': true, ...?extra};
    if (refreshToken != null && refreshToken.isNotEmpty) {
      requestHeaders['x-refresh-token'] = refreshToken;
    }

    return ABSApi.makeApiPostRequest(
      route: '/auth/refresh',
      fromJson: (data) => Login.fromJson(data),
      bodyData: const {},
      cancelToken: cancelToken,
      headers: requestHeaders,
      extra: requestExtra,
      dio: _dio,
    );
  }

  Future<Response<Map<String, dynamic>>> logout({
    String? refreshToken,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final requestHeaders = <String, dynamic>{...?headers};
    final requestExtra = <String, dynamic>{'skip_auth_refresh': true, ...?extra};
    if (refreshToken != null && refreshToken.isNotEmpty) {
      requestHeaders['x-refresh-token'] = refreshToken;
    }

    return ABSApi.makeApiPostRequest(
      route: '/logout',
      fromJson: (data) => data,
      bodyData: const {},
      cancelToken: cancelToken,
      headers: requestHeaders,
      extra: requestExtra,
      dio: _dio,
      returnData: const <String, dynamic>{},
    );
  }

  Future<Response<Bookmark>> createBookmark(
    String itemId, {
    required CreateBookmarkRequest createBookmarkRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/api/me/item/$itemId/bookmark',
      fromJson: (data) => Bookmark.fromJson(data),
      bodyData: createBookmarkRequest.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<bool> deleteBookmark(
    String itemId,
    int time, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/me/item/$itemId/bookmark/$time',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<User>> getUser({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/me',
      fromJson: (data) => User.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<UserMessageConsents>> getUserMessageConsents({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/me/user-message-consents',
      fromJson: (data) => UserMessageConsents.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<UserMessageConsents>> addUserMessageConsent(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final route = '/api/me/user-message-consents/$userId';

    return ABSApi.makeApiPostRequest(
      route: route,
      fromJson: (data) => UserMessageConsents.fromJson(data as Map<String, dynamic>),
      bodyData: const <String, dynamic>{},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<UserMessageConsents>> removeUserMessageConsent(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final deleted = await ABSApi.makeApiDeleteRequest(
      route: '/api/me/user-message-consents/$userId',
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );

    if (!deleted) {
      throw StateError('Failed to remove user message consent for $userId');
    }

    return getUserMessageConsents(cancelToken: cancelToken, headers: headers, extra: extra);
  }

  Future<Response<UserMessageConsents>> blockUserMessageConsent(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final route = '/api/me/user-message-consents/$userId/block';

    return ABSApi.makeApiPostRequest(
      route: route,
      fromJson: (data) => UserMessageConsents.fromJson(data as Map<String, dynamic>),
      bodyData: const <String, dynamic>{},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<UserMessageConsents>> unblockUserMessageConsent(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final deleted = await ABSApi.makeApiDeleteRequest(
      route: '/api/me/user-message-consents/$userId/block',
      dio: _dio,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
    );

    if (!deleted) {
      throw StateError('Failed to unblock user message consent for $userId');
    }

    return getUserMessageConsents(cancelToken: cancelToken, headers: headers, extra: extra);
  }

  Future<Response<UserListeningStats>> getListeningStats(
    String userId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/users/$userId/listening-stats',
      fromJson: (data) => UserListeningStats.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<UserListeningStats>> getMeListeningStats({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/me/listening-stats',
      fromJson: (data) => UserListeningStats.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<ListeningSessionsPage>> getMeListeningSessions({
    int page = 0,
    int itemsPerPage = 10,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/me/listening-sessions',
      fromJson: (data) => _parseListeningSessionsPage(
        data,
        route: '/api/me/listening-sessions',
        page: page,
        itemsPerPage: itemsPerPage,
      ),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {'page': page, 'itemsPerPage': itemsPerPage},
    );
  }

  Future<Response<ListeningSessionsPage>> getUserListeningSessions(
    String userId, {
    int page = 0,
    int itemsPerPage = 10,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/users/$userId/listening-sessions',
      fromJson: (data) => _parseListeningSessionsPage(
        data,
        route: '/api/users/$userId/listening-sessions',
        page: page,
        itemsPerPage: itemsPerPage,
      ),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {'page': page, 'itemsPerPage': itemsPerPage},
    );
  }

  Future<Response<ListeningSessionsPage>> getMeItemListeningSessions(
    String libraryItemId, {
    String? episodeId,
    int page = 0,
    int itemsPerPage = 10,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    var route = '/api/me/item/listening-sessions/$libraryItemId';
    if (episodeId != null && episodeId.trim().isNotEmpty) {
      route = '/api/me/item/listening-sessions/$libraryItemId/$episodeId';
    }

    return ABSApi.makeApiGetRequest(
      route: route,
      fromJson: (data) => _parseListeningSessionsPage(data, route: route, page: page, itemsPerPage: itemsPerPage),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {'page': page, 'itemsPerPage': itemsPerPage},
    );
  }

  Future<Response<YearInReviewStats>> getMeStatsForYear(
    int year, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/me/stats/year/$year',
      fromJson: (data) => YearInReviewStats.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<YearInReviewStats>> getAdminStatsForYear(
    int year, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/stats/year/$year',
      fromJson: (data) => YearInReviewStats.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<MediaProgress>> getProgress(
    String itemId, {
    String? episodeId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    var route = '/api/me/progress/$itemId';
    if (episodeId != null) {
      route = '/api/me/progress/$itemId/$episodeId';
    }

    return ABSApi.makeApiGetRequest(
      route: route,
      fromJson: (data) => MediaProgress.fromJson(data),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response> getPing({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/ping',
      fromJson: (data) => null,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<Response<ServerStatus>> getStatus({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/status',
      fromJson: (data) => ServerStatus.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: {},
    );
  }

  Future<void> createUpdateMediaProgress(
    String itemId,
    MediaProgress progress, {
    String? episodeId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    var route = '/api/me/progress/$itemId';
    if (episodeId != null) {
      route = '/api/me/progress/$itemId/$episodeId';
    }

    await ABSApi.makeApiPatchRequest(
      route: route,
      fromJson: null,
      bodyData: progress.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<void> patchMediaProgress(
    String itemId, {
    String? episodeId,
    required Map<String, dynamic> updatePayload,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    var route = '/api/me/progress/$itemId';
    if (episodeId != null) {
      route = '/api/me/progress/$itemId/$episodeId';
    }

    await ABSApi.makeApiPatchRequest(
      route: route,
      fromJson: null,
      bodyData: updatePayload,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<void> batchUpdateMediaProgress(
    List<Map<String, dynamic>> updatePayloads, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    if (updatePayloads.isEmpty) {
      return;
    }

    final options = Options(
      method: 'PATCH',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'BearerAuth'},
        ],
        ...?extra,
      },
      contentType: 'application/json',
    );

    await _dio.request<Object>(
      '/api/me/progress/batch/update',
      data: updatePayloads,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<void> updateBookProgress(
    String itemId, {
    required double progress,
    required String epubCfi,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    var route = '/api/me/progress/$itemId';

    await ABSApi.makeApiPatchRequest(
      route: route,
      fromJson: null,
      bodyData: {'ebookLocation': epubCfi, 'ebookProgress': progress},
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }
}
