import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/login.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/api/me/request/login_request.dart';
import 'package:yaabsa/api/me/status.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:dio/dio.dart';

class MeApi {
  final Dio _dio;

  MeApi(this._dio);

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
    itemId, {
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
    itemId,
    time, {
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
