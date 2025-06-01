import 'dart:async';

import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'server_status_provider.g.dart';

const Duration _connectedInterval = Duration(minutes: 10);
const Duration _disconnectedInterval = Duration(minutes: 1);

@Riverpod(keepAlive: true)
Stream<bool> serverStatus(Ref ref) {
  final controller = StreamController<bool>();
  Timer? timer;
  bool lastStatus = false;
  final connectivity = Connectivity();

  controller.add(false);

  Future<void> checkStatus() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
      return;
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
      return;
    }

    try {
      await absApi.getMeApi().getPing();
      if (!lastStatus) {
        controller.add(true);
        lastStatus = true;
        _onReconnected(ref);
      }
      timer?.cancel();
      timer = Timer.periodic(_connectedInterval, (_) => checkStatus());
    } on DioException {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
    } catch (e) {
      if (lastStatus) {
        controller.add(false);
        lastStatus = false;
      }
      timer?.cancel();
      timer = Timer.periodic(_disconnectedInterval, (_) => checkStatus());
    }
  }

  checkStatus();

  final connectivitySubscription = connectivity.onConnectivityChanged.listen((result) {
    timer?.cancel();
    checkStatus();
  });

  ref.listen(absApiProvider, (previous, next) {
    if (identical(previous, next) && previous?.dio.options.baseUrl == next?.dio.options.baseUrl) {
      if ((previous == null && next != null) || (previous != null && next == null)) {
      } else {
        return;
      }
    }
    timer?.cancel();
    checkStatus();
  });

  ref.onDispose(() {
    timer?.cancel();
    controller.close();
    connectivitySubscription.cancel();
  });

  return controller.stream;
}

Future<void> _onReconnected(Ref ref) async {
  logger('Reconnected to server', tag: 'ServerStatusProvider', level: InfoLevel.debug);
  AppDatabase db = ref.read(appDatabaseProvider);

  final offlineSync = await db.getAllSyncs();
  if (offlineSync.isEmpty) {
    logger('No offline syncs found', tag: 'ServerStatusProvider', level: InfoLevel.debug);
    return;
  }
  final users = await db.getAllStoredUsers();

  final userIds = users.map((user) => user.id).toList();
  final syncsWithoutUser = offlineSync.where((sync) => !userIds.contains(sync.userId)).toList();

  if (syncsWithoutUser.isNotEmpty) {
    logger(
      'Found ${syncsWithoutUser.length} syncs without a user. Deleting. Syncs: $syncsWithoutUser',
      tag: 'ServerStatusProvider',
    );
    for (final sync in syncsWithoutUser) {
      await db.deleteSync(sync.sessionId);
    }
  }

  final openSession = ref.read(sessionRepositoryProvider).currentSession;

  for (final sync in offlineSync) {
    if (openSession != null && sync.sessionId == openSession.id) {
      logger(
        'Skipping sync for current session: ${sync.sessionId}, because it is open. Waiting until next try',
        tag: 'ServerStatusProvider',
        level: InfoLevel.debug,
      );
      continue;
    }
    try {
      // This is a needed workaround, because we cannot get the current closed session and therefore could potentially overwrite the session
      String newSessionId = sync.sessionLocal ? sync.sessionId : Uuid().v4();
      PlaybackSession session = await ref
          .read(sessionRepositoryProvider)
          .createLocalSession(
            newSessionId,
            sync.itemId,
            sync.userId,
            DateTime.fromMillisecondsSinceEpoch(sync.lastUpdated.millisecondsSinceEpoch),
            episodeId: sync.episodeId,
            initialTimeListening: sync.timeListened,
            currentPosition: sync.currentTime,
            duration: sync.duration,
          );

      final api = ref.read(absApiProvider);
      await api!.getSessionApi().syncLocalSession(session);
      logger('Created new session with ID: $newSessionId', tag: 'ServerStatusProvider', level: InfoLevel.debug);

      await db.deleteSync(sync.sessionId);
      logger('Sync completed successfully for session ID: ${sync.sessionId}', tag: 'ServerStatusProvider');
    } catch (e) {
      logger('Failed to sync session: $e', tag: 'ServerStatusProvider', level: InfoLevel.warning);
    }
  }
}
