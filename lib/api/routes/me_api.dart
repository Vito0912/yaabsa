import 'package:buchshelfly/api/library/stats/user_listening_stats.dart';
import 'package:buchshelfly/api/me/bookmark.dart';
import 'package:buchshelfly/api/me/login.dart';
import 'package:buchshelfly/api/me/media_progress.dart';
import 'package:buchshelfly/api/me/request/create_bookmark_request.dart';
import 'package:buchshelfly/api/me/request/login_request.dart';
import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:dio/dio.dart';

class MeApi {
  final Dio _dio;

  MeApi(this._dio);

  Future<Response<Login>> login({
    required LoginRequest loginRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiPostRequest(
      route: '/login',
      fromJson: (data) => Login.fromJson(data),
      bodyData: loginRequest.toJson(),
      cancelToken: cancelToken,
      headers: headers,
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
}
