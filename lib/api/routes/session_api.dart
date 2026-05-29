import 'package:yaabsa/api/admin/admin_listening_sessions_page.dart';
import 'package:yaabsa/api/admin/open_sessions_response.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/session/request/sync_session_request.dart';
import 'package:dio/dio.dart';

class SessionApi {
  final Dio _dio;

  SessionApi(this._dio);

  Future<Response<AdminListeningSessionsPage>> getSessions({
    int page = 0,
    int itemsPerPage = 50,
    String? sortBy,
    bool desc = true,
    String? userId,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'itemsPerPage': itemsPerPage,
      'desc': desc ? 1 : 0,
      if (sortBy != null && sortBy.trim().isNotEmpty) 'sort': sortBy,
      if (userId != null && userId.trim().isNotEmpty) 'user': userId,
    };

    return ABSApi.makeApiGetRequest(
      route: '/api/sessions',
      fromJson: (data) => AdminListeningSessionsPage.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: queryParams,
    );
  }

  Future<Response<OpenSessionsResponse>> getOpenSessions({
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/sessions/open',
      fromJson: (data) => OpenSessionsResponse.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: const <String, dynamic>{},
    );
  }

  Future<bool> deleteSessionById(
    String sessionId, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiDeleteRequest(
      route: '/api/sessions/$sessionId',
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );
  }

  Future<Response<PlaybackSession>> getSessionById(
    String id, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    return ABSApi.makeApiGetRequest(
      route: '/api/session/$id',
      fromJson: (data) => PlaybackSession.fromJson(data as Map<String, dynamic>),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      queryParams: const <String, dynamic>{},
    );
  }

  Future<bool> closeOpenSession(
    String id, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final response = await ABSApi.makeApiPostRequest<bool>(
      route: '/api/session/$id/close',
      fromJson: null,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      returnData: true,
      bodyData: const <String, dynamic>{},
    );

    final statusCode = response.statusCode;
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  Future<bool> syncOpenSession(
    String sessionId, {
    required SyncSessionRequest request,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    await ABSApi.makeApiPostRequest(
      route: '/api/session/$sessionId/sync',
      fromJson: null,
      bodyData: request.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    return true;
  }

  Future<bool> syncLocalSession(
    PlaybackSession request, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    await ABSApi.makeApiPostRequest(
      route: '/api/session/local',
      fromJson: null,
      bodyData: request.toJson(),
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
    );

    return true;
  }
}
