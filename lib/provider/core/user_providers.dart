import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/api/routes/interceptors/bearer_auth_interceptor.dart';
import 'package:buchshelfly/api/routes/interceptors/o_auth_interceptor.dart';
import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/util/interceptors/cache_interceptor.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../util/interceptors/abs_interceptor.dart' show ABSInterceptor;

part 'user_providers.g.dart';

@Riverpod(keepAlive: true)
Stream<String?> activeUserId(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchGlobalSetting('activeUserId').map((e) => e?.value);
}

@Riverpod(keepAlive: true)
Stream<User?> currentUser(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final activeUserIdStream = ref.watch(activeUserIdProvider.stream);

  return activeUserIdStream.asyncMap((userId) async {
    if (userId == null) {
      logger('Active user ID is null, yielding null User.', tag: 'currentUserProvider');
      return null;
    }
    logger('Active user ID changed to: $userId. Fetching user.', tag: 'currentUserProvider');
    final user = await db.getStoredUser(userId);

    if (user == null) {
      logger('User or user server is null, cannot proceed with server sync.', tag: 'currentUserProvider');
      return user;
    }

    ABSApi tmp = ABSApi(
      dio: Dio(BaseOptions(baseUrl: user.server!.url, headers: user.server!.headers)),
      basePathOverride: user.server!.url,
    );

    if (user.token != null) {
      tmp.setBearerAuth('BearerAuth', user.token!);
    }

    try {
      final result = await tmp.getMeApi().checkLogin();
      final serverUser = result.data!.user;
      logger('Fetched user from server: ${serverUser.username}. Updating local database.', tag: 'currentUserProvider');
      serverUser.server = user.server; // Preserve local server info
      await db.addOrUpdateStoredUser(serverUser);
      return serverUser; // Return the updated user from server
    } catch (e, s) {
      logger(
        'Error fetching user from server: $e. Stack: $s. Returning local user.',
        tag: 'currentUserProvider',
        level: InfoLevel.warning,
      );
      // Check if 401 Unauthorized
      if (e is DioException && e.response?.statusCode == 401) {
        logger(
          '401 Unauthorized error. User token might be invalid. Please re-login.',
          tag: 'currentUserProvider',
          level: InfoLevel.warning,
        );
        await db.deleteStoredUser(user.id);
        await db.setActiveUserId((await db.watchAllStoredUsers().first).first.id);
      }
      return user;
    }
  });
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
  token = currentUser.token;

  List<Interceptor> interceptors = [
    BearerAuthInterceptor(),
    OAuthInterceptor(),
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
