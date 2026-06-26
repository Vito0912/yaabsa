import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/routes/interceptors/bearer_auth_interceptor.dart';
import 'package:yaabsa/api/routes/interceptors/o_auth_interceptor.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';

class AuthRefreshInterceptor extends Interceptor {
  AuthRefreshInterceptor(this.container, {this.bearerAuthInterceptor, this.oAuthInterceptor, this.onAuthFailed});

  static const String _retryExtraKey = 'auth_retry_attempted';
  static const String _skipRefreshExtraKey = 'skip_auth_refresh';

  final ProviderContainer container;
  final BearerAuthInterceptor? bearerAuthInterceptor;
  final OAuthInterceptor? oAuthInterceptor;
  final void Function(String userId)? onAuthFailed;

  static Completer<User?>? _refreshCompleter;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_shouldSkip(options)) {
      return handler.next(options);
    }

    final authHeader = options.headers['Authorization'] as String?;
    if (authHeader != null && authHeader.startsWith('Bearer ')) {
      final token = authHeader.substring(7);
      if (isJwtExpired(token)) {
        try {
          final refreshedUser = await _refreshSession();
          final newToken = refreshedUser?.preferredAuthToken;
          if (refreshedUser == null || newToken == null || newToken.isEmpty) {
            logger(
              'Token refresh failed. Rejecting request locally.',
              tag: 'AuthRefreshInterceptor',
              level: InfoLevel.warning,
            );
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Unauthorized (Token refresh failed)',
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: options, statusCode: 401, statusMessage: 'Unauthorized'),
              ),
            );
          }

          if (bearerAuthInterceptor != null) {
            bearerAuthInterceptor!.tokens['BearerAuth'] = newToken;
          }
          if (oAuthInterceptor != null) {
            oAuthInterceptor!.tokens['BearerAuth'] = newToken;
          }

          options.headers['Authorization'] = 'Bearer $newToken';
        } catch (e) {
          logger('Token refresh error in onRequest: $e', tag: 'AuthRefreshInterceptor', level: InfoLevel.warning);
          return handler.reject(
            DioException(
              requestOptions: options,
              error: 'Unauthorized (Token refresh failed: $e)',
              type: DioExceptionType.badResponse,
              response: Response(requestOptions: options, statusCode: 401, statusMessage: 'Unauthorized'),
            ),
          );
        }
      }
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if ((statusCode != 401 && statusCode != 403) || _shouldSkip(err.requestOptions)) {
      return handler.next(err);
    }

    try {
      final refreshedUser = await _refreshSession();
      final newToken = refreshedUser?.preferredAuthToken;
      if (refreshedUser == null || newToken == null || newToken.isEmpty) {
        return handler.next(err);
      }

      if (bearerAuthInterceptor != null) {
        bearerAuthInterceptor!.tokens['BearerAuth'] = newToken;
      }
      if (oAuthInterceptor != null) {
        oAuthInterceptor!.tokens['BearerAuth'] = newToken;
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

  Future<User?> _refreshSession() {
    return refreshSession(container, onAuthFailed: onAuthFailed);
  }

  static Future<User?> refreshSession(ProviderContainer container, {void Function(String userId)? onAuthFailed}) async {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      logger(
        'Auth token refresh already in progress. Waiting for it.',
        tag: 'AuthRefreshInterceptor',
        level: InfoLevel.debug,
      );
      return inFlight.future;
    }

    logger(
      'Token is expired or invalid according to JWT. Attempting refresh from server.',
      tag: 'AuthRefreshInterceptor',
      level: InfoLevel.info,
    );

    final completer = Completer<User?>();
    _refreshCompleter = completer;

    () async {
      String? activeUserId;
      try {
        final db = container.read(appDatabaseProvider);
        activeUserId = (await db.getGlobalSetting('activeUserId'))?.value;
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
          logger('No refresh token available. Logging out.', tag: 'AuthRefreshInterceptor', level: InfoLevel.warning);
          if (onAuthFailed != null) {
            onAuthFailed(activeUserId);
          }
          completer.complete(null);
          return;
        }

        final refreshApi = ABSApi(
          dio: createNativeDio(
            options: BaseOptions(
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
          extra: const {_skipRefreshExtraKey: true},
        );
        final refreshedLogin = loginResponse.data;
        if (refreshedLogin == null) {
          logger('Refresh response data is null.', tag: 'AuthRefreshInterceptor', level: InfoLevel.warning);
          completer.complete(null);
          return;
        }

        final refreshedUser = refreshedLogin.user.copyWith(
          server: activeUser.server,
          isActive: true,
          setting: refreshedLogin.user.setting ?? refreshedLogin.serverSettings,
        );

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

        if (e is DioException) {
          final status = e.response?.statusCode;
          if (status == 401 || status == 403) {
            logger(
              'Refresh returned $status. Removing user session.',
              tag: 'AuthRefreshInterceptor',
              level: InfoLevel.warning,
            );
            if (onAuthFailed != null && activeUserId != null) {
              onAuthFailed(activeUserId);
            }
          }
        }
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
    final retryDio = createNativeDio(
      options: BaseOptions(
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

  static Map<String, dynamic>? _parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }
    try {
      var payload = parts[1];
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      final decoded = utf8.decode(base64Url.decode(payload));
      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  static bool isJwtExpired(String token) {
    final payload = _parseJwt(token);
    if (payload == null) {
      return false;
    }
    final exp = payload['exp'];
    if (exp is int) {
      final expDateTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().add(const Duration(seconds: 5)).isAfter(expDateTime);
    }
    return false;
  }
}
