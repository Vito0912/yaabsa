import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/logger.dart';

class AuthRefreshInterceptor extends Interceptor {
  AuthRefreshInterceptor(this.ref);

  static const String _retryExtraKey = 'auth_retry_attempted';
  static const String _skipRefreshExtraKey = 'skip_auth_refresh';

  final Ref ref;
  Completer<User?>? _refreshCompleter;

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401 || _shouldSkip(err.requestOptions)) {
      return handler.next(err);
    }

    try {
      final refreshedUser = await _refreshSession();
      final newToken = refreshedUser?.preferredAuthToken;
      if (refreshedUser == null || newToken == null || newToken.isEmpty) {
        return handler.next(err);
      }

      final retryResponse = await _retryRequest(
        originalRequest: err.requestOptions,
        user: refreshedUser,
        token: newToken,
      );
      return handler.resolve(retryResponse);
    } on DioException catch (e) {
      return handler.next(e);
    } catch (_) {
      return handler.next(err);
    }
  }

  bool _shouldSkip(RequestOptions requestOptions) {
    if (requestOptions.extra[_retryExtraKey] == true || requestOptions.extra[_skipRefreshExtraKey] == true) {
      return true;
    }

    final path = requestOptions.path.toLowerCase();
    return path.endsWith('/login') ||
        path.endsWith('/auth/refresh') ||
        path.endsWith('/logout') ||
        path.endsWith('/status') ||
        path.endsWith('/ping');
  }

  Future<User?> _refreshSession() async {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<User?>();
    _refreshCompleter = completer;

    () async {
      try {
        final db = ref.read(appDatabaseProvider);
        final activeUserId = (await db.getGlobalSetting('activeUserId'))?.value;
        if (activeUserId == null || activeUserId.isEmpty) {
          completer.complete(null);
          return;
        }

        final activeUser = await db.getStoredUser(activeUserId);
        if (activeUser == null || activeUser.server == null) {
          completer.complete(null);
          return;
        }

        final refreshToken = activeUser.refreshToken;
        if (refreshToken == null || refreshToken.isEmpty) {
          completer.complete(null);
          return;
        }

        final refreshApi = ABSApi(
          dio: Dio(
            BaseOptions(
              baseUrl: activeUser.server!.url,
              connectTimeout: const Duration(seconds: 3),
              receiveTimeout: const Duration(seconds: 20),
              headers: activeUser.server!.headers,
            ),
          ),
          basePathOverride: activeUser.server!.url,
        );

        final loginResponse = await refreshApi.getMeApi().refreshAuth(
          refreshToken: refreshToken,
          extra: {_skipRefreshExtraKey: true},
        );
        final refreshedLogin = loginResponse.data;
        if (refreshedLogin == null) {
          completer.complete(null);
          return;
        }

        final refreshedUser = refreshedLogin.user.copyWith(server: activeUser.server, isActive: true);

        await db.addOrUpdateStoredUser(refreshedUser);
        logger(
          'Successfully refreshed access token for user ${refreshedUser.username}',
          tag: 'AuthRefreshInterceptor',
          level: InfoLevel.debug,
        );
        completer.complete(refreshedUser);
      } catch (e, s) {
        logger('Failed to refresh auth token: $e', tag: 'AuthRefreshInterceptor', level: InfoLevel.warning);
        logger('Refresh stack trace: $s', tag: 'AuthRefreshInterceptor', level: InfoLevel.debug);
        completer.complete(null);
      } finally {
        _refreshCompleter = null;
      }
    }();

    return completer.future;
  }

  Future<Response<dynamic>> _retryRequest({
    required RequestOptions originalRequest,
    required User user,
    required String token,
  }) async {
    final retryDio = Dio(
      BaseOptions(
        baseUrl: user.server!.url,
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 20),
        headers: user.server!.headers,
      ),
    );

    final headers = <String, dynamic>{...originalRequest.headers};
    headers['Authorization'] = 'Bearer $token';

    final options = Options(
      method: originalRequest.method,
      headers: headers,
      sendTimeout: originalRequest.sendTimeout,
      receiveTimeout: originalRequest.receiveTimeout,
      extra: <String, dynamic>{...originalRequest.extra, _retryExtraKey: true},
      contentType: originalRequest.contentType,
      responseType: originalRequest.responseType,
      followRedirects: originalRequest.followRedirects,
      validateStatus: originalRequest.validateStatus,
      receiveDataWhenStatusError: originalRequest.receiveDataWhenStatusError,
      listFormat: originalRequest.listFormat,
    );

    return retryDio.request<dynamic>(
      originalRequest.path,
      data: originalRequest.data,
      queryParameters: originalRequest.queryParameters,
      cancelToken: originalRequest.cancelToken,
      options: options,
      onReceiveProgress: originalRequest.onReceiveProgress,
      onSendProgress: originalRequest.onSendProgress,
    );
  }
}
