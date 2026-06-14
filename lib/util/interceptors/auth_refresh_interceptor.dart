import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/me/login.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';

/// Connection details required to call `/auth/refresh`.
class AuthRefreshTarget {
  const AuthRefreshTarget({required this.serverUrl, required this.refreshToken, this.headers});

  final String serverUrl;
  final String refreshToken;
  final Map<String, dynamic>? headers;
}

class _RefreshOutcome {
  const _RefreshOutcome({required this.accessToken, required this.target});

  final String accessToken;
  final AuthRefreshTarget target;
}

/// Shared 401 handling: refreshes the access token via `/auth/refresh` once
/// per burst of failures and retries the original request with the new token.
/// Subclasses only define where the refresh token comes from and how the
/// rotated token pair is persisted.
abstract class BaseAuthRefreshInterceptor extends Interceptor {
  static const String _retryExtraKey = 'auth_retry_attempted';
  static const String _skipRefreshExtraKey = 'skip_auth_refresh';

  Completer<_RefreshOutcome?>? _refreshCompleter;

  /// Loads what is needed to refresh, or null if refreshing is not possible.
  Future<AuthRefreshTarget?> loadRefreshTarget();

  /// Persists the refreshed login and returns the new access token, or null
  /// if the response is unusable.
  Future<String?> persistRefreshedLogin(Login login, covariant AuthRefreshTarget target);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != 401 || _shouldSkip(err.requestOptions)) {
      return handler.next(err);
    }

    try {
      final outcome = await _refreshSession();
      if (outcome == null) {
        return handler.next(err);
      }

      final retryResponse = await _retryRequest(originalRequest: err.requestOptions, outcome: outcome);
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

  Future<_RefreshOutcome?> _refreshSession() async {
    final inFlight = _refreshCompleter;
    if (inFlight != null) {
      return inFlight.future;
    }

    final completer = Completer<_RefreshOutcome?>();
    _refreshCompleter = completer;

    () async {
      try {
        final target = await loadRefreshTarget();
        if (target == null || target.refreshToken.isEmpty) {
          completer.complete(null);
          return;
        }

        final refreshApi = ABSApi(
          dio: createNativeDio(
            options: BaseOptions(
              baseUrl: target.serverUrl,
              connectTimeout: const Duration(seconds: 3),
              receiveTimeout: const Duration(seconds: 20),
              headers: target.headers,
            ),
          ),
          basePathOverride: target.serverUrl,
        );

        final loginResponse = await refreshApi.getMeApi().refreshAuth(
          refreshToken: target.refreshToken,
          extra: {_skipRefreshExtraKey: true},
        );
        final refreshedLogin = loginResponse.data;
        if (refreshedLogin == null) {
          completer.complete(null);
          return;
        }

        final newToken = await persistRefreshedLogin(refreshedLogin, target);
        if (newToken == null || newToken.isEmpty) {
          completer.complete(null);
          return;
        }

        completer.complete(_RefreshOutcome(accessToken: newToken, target: target));
      } catch (e, s) {
        logger('Failed to refresh auth token: $e', tag: '$runtimeType', level: InfoLevel.warning);
        logger('Refresh stack trace: $s', tag: '$runtimeType', level: InfoLevel.debug);
        completer.complete(null);
      } finally {
        _refreshCompleter = null;
      }
    }();

    return completer.future;
  }

  Future<Response<dynamic>> _retryRequest({
    required RequestOptions originalRequest,
    required _RefreshOutcome outcome,
  }) async {
    final retryDio = createNativeDio(
      options: BaseOptions(
        baseUrl: outcome.target.serverUrl,
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 20),
        headers: outcome.target.headers,
      ),
    );

    final headers = <String, dynamic>{...originalRequest.headers};
    headers['Authorization'] = 'Bearer ${outcome.accessToken}';

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

class UserAuthRefreshTarget extends AuthRefreshTarget {
  const UserAuthRefreshTarget({
    required this.user,
    required super.serverUrl,
    required super.refreshToken,
    super.headers,
  });

  final User user;
}

/// Refreshes the session of the active stored user in the app database.
class AuthRefreshInterceptor extends BaseAuthRefreshInterceptor {
  AuthRefreshInterceptor(this.container);

  final ProviderContainer container;

  @override
  Future<AuthRefreshTarget?> loadRefreshTarget() async {
    final db = container.read(appDatabaseProvider);
    final activeUserId = (await db.getGlobalSetting('activeUserId'))?.value;
    if (activeUserId == null || activeUserId.isEmpty) {
      return null;
    }

    final activeUser = await db.getStoredUser(activeUserId);
    final server = activeUser?.server;
    final refreshToken = activeUser?.refreshToken;
    if (activeUser == null || server == null || refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    return UserAuthRefreshTarget(
      user: activeUser,
      serverUrl: server.url,
      refreshToken: refreshToken,
      headers: server.headers,
    );
  }

  @override
  Future<String?> persistRefreshedLogin(Login login, UserAuthRefreshTarget target) async {
    final refreshedUser = login.user.copyWith(
      server: target.user.server,
      isActive: true,
      setting: login.user.setting ?? login.serverSettings,
    );

    await container.read(appDatabaseProvider).addOrUpdateStoredUser(refreshedUser);
    logger(
      'Successfully refreshed access token for user ${refreshedUser.username}',
      tag: 'AuthRefreshInterceptor',
      level: InfoLevel.debug,
    );
    return refreshedUser.preferredAuthToken;
  }
}
