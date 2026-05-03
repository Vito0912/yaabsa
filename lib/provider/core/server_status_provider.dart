import 'dart:async';

import 'package:yaabsa/api/me/server.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/network/dio_factory.dart';
import 'package:yaabsa/util/network/request_headers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'server_status_provider.g.dart';

const Duration _connectedInterval = Duration(minutes: 10);
const Duration _disconnectedInterval = Duration(minutes: 1);
bool _isSyncReplayInProgress = false;

@Riverpod(keepAlive: true)
Stream<bool> serverStatus(Ref ref) async* {
  final controller = StreamController<bool>();
  Timer? timer;
  final connectivity = Connectivity();
  late final Future<void> Function() checkStatus;

  void scheduleNextCheck(bool connected) {
    timer?.cancel();
    timer = Timer(connected ? _connectedInterval : _disconnectedInterval, () {
      unawaited(checkStatus());
    });
  }

  void markUnreachable(String reason) {
    final wasReachable = ref.read(serverReachabilityProvider);
    if (wasReachable) {
      logger('Server marked unreachable via $reason', tag: 'ServerStatusProvider', level: InfoLevel.debug);
      ref.read(serverReachabilityProvider.notifier).setUnreachable();
    }
    scheduleNextCheck(false);
  }

  void markReachable(String reason) {
    final wasReachable = ref.read(serverReachabilityProvider);
    if (!wasReachable) {
      logger('Server marked reachable via $reason', tag: 'ServerStatusProvider', level: InfoLevel.debug);
      ref.read(serverReachabilityProvider.notifier).setReachable();
    }
    scheduleNextCheck(true);
  }

  checkStatus = () async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      markUnreachable('connectivity.none');
      return;
    }

    final currentUser = ref.read(currentUserProvider).value;
    final server = currentUser?.server;
    if (currentUser == null || server == null) {
      markUnreachable('current_user_or_server.null');
      return;
    }

    final localUrl = server.localUrl;
    if (localUrl != null) {
      final localReachable = await _isServerReachable(
        baseUrl: localUrl,
        headers: server.headers,
        bearerToken: currentUser.preferredAuthToken,
      );
      if (localReachable) {
        await _setActiveConnection(
          ref: ref,
          currentUser: currentUser,
          nextConnection: ServerConnection.local,
          reason: 'ping.local.success',
        );
        markReachable('ping.local.success');
        return;
      }
    }

    final externalReachable = await _isServerReachable(
      baseUrl: server.externalUrl,
      headers: server.headers,
      bearerToken: currentUser.preferredAuthToken,
    );

    if (externalReachable) {
      await _setActiveConnection(
        ref: ref,
        currentUser: currentUser,
        nextConnection: ServerConnection.external,
        reason: localUrl == null ? 'ping.external.success' : 'ping.external.fallback_success',
      );
      markReachable(localUrl == null ? 'ping.external.success' : 'ping.external.fallback_success');
      return;
    }

    markUnreachable(localUrl == null ? 'ping.external.failed' : 'ping.local_and_external.failed');
  };

  unawaited(checkStatus());

  final connectivitySubscription = connectivity.onConnectivityChanged.listen((_) {
    timer?.cancel();
    unawaited(checkStatus());
  });

  ref.listen(currentUserProvider, (previous, next) {
    timer?.cancel();
    unawaited(checkStatus());
  });

  ref.listen<bool>(serverReachabilityProvider, (previous, next) {
    if (previous == next || controller.isClosed) {
      return;
    }

    scheduleNextCheck(next);
    controller.add(next);
    if (next) {
      final reconnected = previous == false;
      unawaited(_onServerReachable(ref, reconnected: reconnected));
    }
  });

  ref.onDispose(() {
    timer?.cancel();
    unawaited(controller.close());
    unawaited(connectivitySubscription.cancel());
  });

  yield ref.read(serverReachabilityProvider);
  yield* controller.stream;
}

Future<void> _onServerReachable(Ref ref, {required bool reconnected}) async {
  if (_isSyncReplayInProgress) {
    logger(
      'Sync replay already running, skipping duplicate trigger.',
      tag: 'ServerStatusProvider',
      level: InfoLevel.debug,
    );
    return;
  }

  _isSyncReplayInProgress = true;

  try {
    logger(
      reconnected ? 'Reconnected to server' : 'Server reachable, checking offline sync backlog',
      tag: 'ServerStatusProvider',
      level: InfoLevel.debug,
    );

    final AppDatabase db = ref.read(appDatabaseProvider);
    final sessionRepository = ref.read(sessionRepositoryProvider);
    final users = await db.getAllStoredUsers();
    final userIds = users.map((user) => user.id).toSet();

    final offlineSync = await db.getAllSyncs();
    if (offlineSync.isEmpty) {
      logger('No offline syncs found', tag: 'ServerStatusProvider', level: InfoLevel.debug);
      return;
    }

    final sortedSyncs = [...offlineSync]..sort((left, right) => left.lastUpdated.compareTo(right.lastUpdated));

    for (final sync in sortedSyncs) {
      if (!userIds.contains(sync.userId)) {
        logger(
          'Deleting sync ${sync.sessionId} because user ${sync.userId} no longer exists.',
          tag: 'ServerStatusProvider',
          level: InfoLevel.debug,
        );
        await db.deleteSync(sync.sessionId);
        continue;
      }

      final synced = await sessionRepository.replayStoredSync(sync);
      if (synced) {
        await db.deleteSync(sync.sessionId);
        logger('Sync completed successfully for session ID: ${sync.sessionId}', tag: 'ServerStatusProvider');
      }
    }
  } finally {
    _isSyncReplayInProgress = false;
  }
}

Future<bool> _isServerReachable({
  required String baseUrl,
  required Map<String, String>? headers,
  required String? bearerToken,
}) async {
  final requestHeaders = buildRequestHeaders(serverHeaders: headers, bearerToken: bearerToken);
  final dio = createNativeDio(
    options: BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 3),
      receiveTimeout: const Duration(seconds: 3),
      headers: requestHeaders.isEmpty ? null : requestHeaders,
    ),
  );

  try {
    await dio.get('/ping');
    return true;
  } on DioException {
    return false;
  } catch (_) {
    return false;
  } finally {
    dio.close(force: true);
  }
}

Future<void> _setActiveConnection({
  required Ref ref,
  required User currentUser,
  required ServerConnection nextConnection,
  required String reason,
}) async {
  final server = currentUser.server;
  if (server == null) {
    return;
  }

  final previousConnection = server.activeConnection;
  server.setConnection(nextConnection);

  if (previousConnection == server.activeConnection) {
    return;
  }

  logger(
    'Switching server connection ${previousConnection.name} -> ${server.activeConnection.name} '
    'for user ${currentUser.username} via $reason',
    tag: 'ServerStatusProvider',
    level: InfoLevel.debug,
  );

  try {
    final activeApi = ref.read(absApiProvider);
    if (activeApi != null) {
      activeApi.dio.options.baseUrl = server.url;
    }

    await ref.read(appDatabaseProvider).addOrUpdateStoredUser(currentUser);
  } catch (e, s) {
    logger(
      'Failed to persist server connection switch for user ${currentUser.id}: $e\n$s',
      tag: 'ServerStatusProvider',
      level: InfoLevel.warning,
    );
  }
}
