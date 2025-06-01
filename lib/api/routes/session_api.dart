import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/session/request/sync_session_request.dart';
import 'package:dio/dio.dart';

class SessionApi {
  final Dio _dio;

  SessionApi(this._dio);

  Future<bool> closeOpenSession(
    String id, {
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    ABSApi.makeApiPostRequest(
      route: '/api/session/$id/close',
      fromJson: null,
      cancelToken: cancelToken,
      headers: headers,
      extra: extra,
      dio: _dio,
      returnData: true,
      bodyData: null,
    );

    return true;
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
