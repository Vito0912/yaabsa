import 'dart:async';

import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/logger.dart';
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

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      markUnreachable('absApi.null');
      return;
    }

    try {
      await absApi.getMeApi().getPing();
      markReachable('ping.success');
    } on DioException {
      markUnreachable('ping.dio_exception');
    } catch (_) {
      markUnreachable('ping.unknown_exception');
    }
  };

  unawaited(checkStatus());

  final connectivitySubscription = connectivity.onConnectivityChanged.listen((_) {
    timer?.cancel();
    unawaited(checkStatus());
  });

  ref.listen(absApiProvider, (previous, next) {
    if (identical(previous, next) && previous?.dio.options.baseUrl == next?.dio.options.baseUrl) {
      if ((previous == null && next != null) || (previous != null && next == null)) {
      } else {
        return;
      }
    }
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
