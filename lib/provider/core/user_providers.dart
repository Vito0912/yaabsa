import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/routes/interceptors/bearer_auth_interceptor.dart';
import 'package:yaabsa/api/routes/interceptors/o_auth_interceptor.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/interceptors/auth_refresh_interceptor.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../util/interceptors/abs_interceptor.dart' show ABSInterceptor;

part 'user_providers.g.dart';

@Riverpod(keepAlive: true)
Stream<String?> activeUserId(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchGlobalSetting('activeUserId').map((e) => e?.value);
}

@Riverpod(keepAlive: true)
Stream<User?> currentUser(Ref ref) async* {
  final db = ref.watch(appDatabaseProvider);
  final activeUserIdStream = db.watchGlobalSetting('activeUserId').map((e) => e?.value);

  await for (final userId in activeUserIdStream) {
    if (userId == null) {
      logger('Active user ID is null, yielding null User.', tag: 'currentUserProvider');
      yield null;
      continue;
    }
    logger('Active user ID changed to: $userId. Fetching local user.', tag: 'currentUserProvider');
    final user = await db.getStoredUser(userId);

    if (user == null || user.server == null) {
      logger('User or user server is null, cannot proceed with server sync.', tag: 'currentUserProvider');
      yield user;
      continue;
    }

    // Serve cached user immediately, then refresh auth/session in the background path.
    yield user;

    final refreshedUser = await _refreshCurrentUserFromServer(db: db, user: user);
    if (refreshedUser != null &&
        refreshedUser.id == userId &&
        _shouldEmitRefreshedUser(previous: user, next: refreshedUser)) {
      yield refreshedUser;
    }
  }
}

bool _shouldEmitRefreshedUser({required User previous, required User next}) {
  if (previous.id != next.id) {
    return true;
  }

  final previousServer = previous.server;
  final nextServer = next.server;
  if (previousServer?.url != nextServer?.url) {
    return true;
  }

  final previousHeaders = previousServer?.headers;
  final nextHeaders = nextServer?.headers;
  if (!_stringMapEquals(previousHeaders, nextHeaders)) {
    return true;
  }

  if (previous.preferredAuthToken != next.preferredAuthToken) {
    return true;
  }

  return false;
}

bool _stringMapEquals(Map<String, dynamic>? a, Map<String, dynamic>? b) {
  if (identical(a, b)) {
    return true;
  }
  if (a == null || b == null || a.length != b.length) {
    return false;
  }

  for (final entry in a.entries) {
    if (b[entry.key] != entry.value) {
      return false;
    }
  }
  return true;
}

Future<User?> _refreshCurrentUserFromServer({required AppDatabase db, required User user}) async {
  ABSApi tmp = ABSApi(
    dio: Dio(BaseOptions(baseUrl: user.server!.url, headers: user.server!.headers)),
    basePathOverride: user.server!.url,
  );

  if (user.preferredAuthToken != null) {
    tmp.setBearerAuth('BearerAuth', user.preferredAuthToken!);
  }

  try {
    final result = await tmp.getMeApi().checkLogin();
    final serverUser = result.data?.user;
    if (serverUser == null) {
      return null;
    }

    logger('Fetched user from server: ${serverUser.username}. Updating local database.', tag: 'currentUserProvider');
    serverUser.server = user.server; // Preserve local server info
    await db.addOrUpdateStoredUser(serverUser);
    return serverUser;
  } catch (e, s) {
    logger(
      'Error fetching user from server: $e. Stack: $s. Keeping local user.',
      tag: 'currentUserProvider',
      level: InfoLevel.warning,
    );
    // Check if 401 Unauthorized
    if (e is DioException && e.response?.statusCode == 401) {
      if (user.refreshToken != null && user.refreshToken!.isNotEmpty) {
        try {
          final refreshResponse = await tmp.getMeApi().refreshAuth(refreshToken: user.refreshToken);
          final refreshedLogin = refreshResponse.data;

          if (refreshedLogin != null) {
            final refreshedUser = refreshedLogin.user.copyWith(server: user.server, isActive: true);
            await db.addOrUpdateStoredUser(refreshedUser);
            return refreshedUser;
          }
        } catch (refreshError) {
          logger('Refresh after 401 failed: $refreshError', tag: 'currentUserProvider', level: InfoLevel.warning);
        }
      }

      logger(
        '401 Unauthorized and refresh unavailable/failed. Removing user ${user.username}.',
        tag: 'currentUserProvider',
        level: InfoLevel.warning,
      );

      await db.deleteStoredUser(user.id);
      final remainingUsers = await db.getAllStoredUsers();
      if (remainingUsers.isNotEmpty) {
        await db.setActiveUserId(remainingUsers.first.id);
      } else {
        await db.clearActiveUserId();
      }
    }

    return null;
  }
}

/// Provider for the list of all stored users.
@Riverpod(keepAlive: true)
Stream<List<User>> allStoredUsers(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final stream = db.watchAllStoredUsers();
  return stream;
}

@Riverpod(keepAlive: true)
ABSApi? absApi(Ref ref) {
  final currentUser = ref.watch(currentUserProvider).value;

  if (currentUser == null) return null;

  String? basePathOverride;
  String? token;

  if (currentUser.server != null) {
    basePathOverride = currentUser.server!.url;
  }
  token = currentUser.preferredAuthToken;

  List<Interceptor> interceptors = [
    BearerAuthInterceptor(),
    OAuthInterceptor(),
    AuthRefreshInterceptor(ref),
    ABSInterceptor(ref),
    CacheInterceptor(ref),
  ];

  final api = ABSApi(
    dio: Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 3),
        receiveTimeout: const Duration(seconds: 20),
        baseUrl: basePathOverride ?? ABSApi.basePath,
        headers: currentUser.server?.headers,
      ),
    ),
    interceptors: interceptors,
    basePathOverride: basePathOverride,
    user: currentUser,
  );

  if (token != null) {
    logger('Setting BearerAuth token for user ${currentUser.username}.', tag: 'absApiProvider', level: InfoLevel.debug);
    api.setBearerAuth('BearerAuth', token);
  }

  return api;
}
