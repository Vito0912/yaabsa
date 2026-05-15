import 'dart:convert';

import 'package:yaabsa/api/admin/admin_listening_sessions_page.dart';
import 'package:yaabsa/api/admin/open_sessions_response.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/session/request/sync_session_request.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';

class SessionApi {
  final Dio _dio;

  SessionApi(this._dio);

  Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw FormatException('Expected JSON object but received ${data.runtimeType}');
  }

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
      if (sortBy != null && sortBy.trim().isNotEmpty) 'sortBy': sortBy,
      if (userId != null && userId.trim().isNotEmpty) 'user': userId,
    };

    return ABSApi.makeApiGetRequest(
      route: '/api/sessions',
      fromJson: (data) {
        try {
          final json = _asJsonMap(data);
          return AdminListeningSessionsPage.fromJson(json);
        } catch (error, stackTrace) {
          logger(
            'Failed to parse /api/sessions response for page=$page itemsPerPage=$itemsPerPage userId=$userId: '
            '$error\nPayload: ${jsonEncode(data)}\n$stackTrace',
            tag: 'SessionApi',
            level: InfoLevel.error,
          );
          rethrow;
        }
      },
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
      fromJson: (data) {
        try {
          final json = _asJsonMap(data);
          return OpenSessionsResponse.fromJson(json);
        } catch (error, stackTrace) {
          logger(
            'Failed to parse /api/sessions/open response: '
            '$error\nPayload: ${jsonEncode(data)}\n$stackTrace',
            tag: 'SessionApi',
            level: InfoLevel.error,
          );
          rethrow;
        }
      },
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
      fromJson: (data) {
        final dynamic wrappedSession = data['session'];
        if (wrappedSession is Map<String, dynamic>) {
          return PlaybackSession.fromJson(wrappedSession);
        }

        final dynamic wrappedData = data['data'];
        if (wrappedData is Map<String, dynamic>) {
          final dynamic nestedSession = wrappedData['session'];
          if (nestedSession is Map<String, dynamic>) {
            return PlaybackSession.fromJson(nestedSession);
          }

          if (wrappedData['id'] != null) {
            return PlaybackSession.fromJson(wrappedData);
          }
        }

        return PlaybackSession.fromJson(data);
      },
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
