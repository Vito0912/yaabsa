import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/socket/abs_socket_client.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/common/collection_provider.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/common/playlist_provider.dart';
import 'package:yaabsa/provider/core/server_tasks_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_shelf_refresh.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

part 'socket_provider.g.dart';

bool _isBackgroundLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
      return false;
    case AppLifecycleState.inactive:
    case AppLifecycleState.hidden:
    case AppLifecycleState.paused:
    case AppLifecycleState.detached:
      return true;
  }
}

bool _isKeepSocketConnectedInBackground(String? settingValue) {
  final defaultEnabled = defaultSettings[SettingKeys.keepWebsocketConnectionInBackground] as bool? ?? false;
  return SettingsParser.decodeValue<bool>(settingValue, defaultEnabled);
}

String _socketConnectionFingerprint({required String serverUrl, required String token, Map<String, String>? headers}) {
  final normalizedHeaders = headers == null
      ? ''
      : (headers.entries.toList()..sort((a, b) => a.key.compareTo(b.key)))
            .map((entry) => '${entry.key}:${entry.value}')
            .join('|');
  return '$serverUrl|$token|$normalizedHeaders';
}

class SocketBatchQuickMatchComplete {
  const SocketBatchQuickMatchComplete({
    required this.success,
    required this.updates,
    required this.unmatched,
    required this.timestamp,
  });

  final bool success;
  final int updates;
  final int unmatched;
  final DateTime timestamp;
}

final socketBatchQuickMatchCompleteProvider =
    NotifierProvider<SocketBatchQuickMatchCompleteNotifier, SocketBatchQuickMatchComplete?>(
      SocketBatchQuickMatchCompleteNotifier.new,
    );

class SocketBatchQuickMatchCompleteNotifier extends Notifier<SocketBatchQuickMatchComplete?> {
  @override
  SocketBatchQuickMatchComplete? build() => null;

  void setEvent({required bool success, required int updates, required int unmatched}) {
    state = SocketBatchQuickMatchComplete(
      success: success,
      updates: updates,
      unmatched: unmatched,
      timestamp: DateTime.now(),
    );
  }
}

@Riverpod(keepAlive: true)
ABSSocketClient absSocketClient(Ref ref) {
  final serverTasksNotifier = ref.read(serverTasksProvider.notifier);
  final container = ref.container;

  final socketClient = ABSSocketClient(
    onUserItemProgressUpdated: (event) {
      final progress = event.data;
      final key = mediaProgressKey(progress.libraryItemId, progress.episodeId);
      final existingProgress = ref.read(mediaProgressProvider).value?[key];
      final becameFinished = progress.isFinished && existingProgress?.isFinished != true;

      ref.read(mediaProgressProvider.notifier).applyRemoteProgressUpdate(progress);

      if (becameFinished) {
        unawaited(
          refreshPersonalizedShelfForCompletedItem(
            container: container,
            itemId: progress.libraryItemId,
            sourceTag: 'SocketProvider',
            reason: 'remote finished progress update',
          ),
        );
      }
    },
    onItemUpdated: (item) {
      unawaited(processLibraryItemUpdate(container: ref.container, item: item, source: 'socket.item_updated'));
    },
    onItemAdded: (item) {
      unawaited(processLibraryItemAdded(container: ref.container, item: item, source: 'socket.item_added'));
    },
    onItemRemoved: ({required itemId, libraryId, item}) {
      unawaited(
        processLibraryItemRemovedById(
          container: ref.container,
          itemId: itemId,
          libraryId: libraryId,
          item: item,
          source: 'socket.item_removed',
        ),
      );
    },
    onItemsAdded: (items) {
      unawaited(processLibraryItemsAdded(container: ref.container, items: items, source: 'socket.items_added'));
    },
    onItemsUpdated: (items) {
      unawaited(processLibraryItemsUpdated(container: ref.container, items: items, source: 'socket.items_updated'));
    },
    onBatchQuickMatchComplete: ({required success, required updates, required unmatched}) {
      ref
          .read(socketBatchQuickMatchCompleteProvider.notifier)
          .setEvent(success: success, updates: updates, unmatched: unmatched);
    },
    onTaskStarted: (task) {
      serverTasksNotifier.addOrUpdateTask(task);
    },
    onTaskFinished: (task) {
      serverTasksNotifier.addOrUpdateTask(task);
    },
    onTaskUpdated: (task) {
      serverTasksNotifier.addOrUpdateTask(task);
    },
    onMetadataEmbedQueueUpdate: ({required libraryItemId, required queued}) {
      serverTasksNotifier.setEmbedMetadataQueued(libraryItemId: libraryItemId, queued: queued);
    },
    onTrackStarted: ({required libraryItemId, required ino}) {
      serverTasksNotifier.updateTrackStarted(libraryItemId: libraryItemId, ino: ino);
    },
    onTrackProgress: ({required libraryItemId, required ino, required progress}) {
      serverTasksNotifier.updateTrackProgress(libraryItemId: libraryItemId, ino: ino, progress: progress);
    },
    onTrackFinished: ({required libraryItemId, required ino}) {
      serverTasksNotifier.updateTrackFinished(libraryItemId: libraryItemId, ino: ino);
    },
    onTaskProgress: ({required libraryItemId, required progress}) {
      serverTasksNotifier.updateTaskProgress(libraryItemId: libraryItemId, progress: progress);
    },
    onCollectionAdded: (collection) {
      unawaited(
        ref.read(collectionsProvider(collection.libraryId).notifier).refresh(withLoading: false, forceServer: true),
      );
    },
    onCollectionUpdated: (collection) {
      unawaited(
        ref.read(collectionsProvider(collection.libraryId).notifier).refresh(withLoading: false, forceServer: true),
      );
    },
    onCollectionRemoved: (collection) {
      unawaited(
        ref.read(collectionsProvider(collection.libraryId).notifier).refresh(withLoading: false, forceServer: true),
      );
    },
    onPlaylistAdded: (playlist) {
      unawaited(
        ref.read(playlistsProvider(playlist.libraryId).notifier).refresh(withLoading: false, forceServer: true),
      );
    },
    onPlaylistUpdated: (playlist) {
      unawaited(
        ref.read(playlistsProvider(playlist.libraryId).notifier).refresh(withLoading: false, forceServer: true),
      );
    },
    onPlaylistRemoved: (playlist) {
      unawaited(
        ref.read(playlistsProvider(playlist.libraryId).notifier).refresh(withLoading: false, forceServer: true),
      );
    },
  );

  User? currentUser = ref.read(currentUserProvider).value;
  bool canReachServer = ref.read(serverStatusProvider).value ?? false;
  final initialKeepSocketSetting = ref
      .read(globalSettingByKeyProvider(SettingKeys.keepWebsocketConnectionInBackground))
      .value;
  bool keepSocketConnectedInBackground = _isKeepSocketConnectedInBackground(initialKeepSocketSetting);
  bool socketSuppressedForBackground = false;
  String? activeSocketFingerprint;
  AppLifecycleState appLifecycleState = WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;

  Future<void> hydrateServerTasksForUser(User? user, {required bool serverReachable}) async {
    if (user == null) {
      serverTasksNotifier.reset();
      return;
    }

    if (!serverReachable) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      return;
    }

    try {
      final tasksResponse = await api.getAdminApi().getTasks(includeQueue: true);
      final payload = tasksResponse.data;
      if (payload == null) {
        return;
      }

      final activeUserId = ref.read(currentUserProvider).value?.id;
      if (activeUserId != user.id) {
        return;
      }

      serverTasksNotifier.hydrateFromResponse(payload);
    } catch (error, stackTrace) {
      if (error is DioException && error.response?.statusCode == 403) {
        serverTasksNotifier.reset();
        logger(
          'Skipping server task hydration for user ${user.username}: missing permissions.',
          tag: 'SocketProvider',
          level: InfoLevel.debug,
        );
        return;
      }

      logger('Failed to hydrate server tasks: $error\n$stackTrace', tag: 'SocketProvider', level: InfoLevel.warning);
    }
  }

  void updateSocketForUser(User? user, {required bool serverReachable}) {
    final serverUrl = user?.server?.url;
    final token = user?.preferredAuthToken;
    final serverHeaders = user?.server?.headers;

    if (serverUrl == null || serverUrl.isEmpty || token == null || token.isEmpty) {
      socketClient.disconnect();
      activeSocketFingerprint = null;
      return;
    }

    if (!serverReachable) {
      logger(
        'Skipping socket connect for user ${user!.username} because server is offline/unreachable.',
        tag: 'SocketProvider',
        level: InfoLevel.debug,
      );
      socketClient.disconnect();
      activeSocketFingerprint = null;
      return;
    }

    final nextSocketFingerprint = _socketConnectionFingerprint(
      serverUrl: serverUrl,
      token: token,
      headers: serverHeaders,
    );

    if (socketClient.isConnected && activeSocketFingerprint == nextSocketFingerprint) {
      return;
    }

    logger(
      'Connecting Audiobookshelf socket for user ${user!.username}',
      tag: 'SocketProvider',
      level: InfoLevel.debug,
    );
    socketClient.connect(serverUrl: serverUrl, apiToken: token, headers: serverHeaders);
    activeSocketFingerprint = nextSocketFingerprint;
  }

  void syncSocketConnection() {
    final shouldSuppressForBackground =
        !keepSocketConnectedInBackground && _isBackgroundLifecycleState(appLifecycleState);

    if (shouldSuppressForBackground) {
      if (!socketSuppressedForBackground) {
        socketClient.disconnect();
        activeSocketFingerprint = null;
        logger(
          'Disconnecting socket due to app lifecycle state $appLifecycleState',
          tag: 'SocketProvider',
          level: InfoLevel.debug,
        );
        socketSuppressedForBackground = true;
      }
      return;
    }

    socketSuppressedForBackground = false;
    updateSocketForUser(currentUser, serverReachable: canReachServer);
  }

  ref.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
    if (previous?.value?.id != next.value?.id) {
      serverTasksNotifier.reset();
    }

    currentUser = next.value;
    syncSocketConnection();
    unawaited(hydrateServerTasksForUser(currentUser, serverReachable: canReachServer));
  });

  ref.listen<AsyncValue<bool>>(serverStatusProvider, (previous, next) {
    canReachServer = next.value ?? false;
    syncSocketConnection();
    unawaited(hydrateServerTasksForUser(currentUser, serverReachable: canReachServer));
  });

  ref.listen<AsyncValue<String?>>(globalSettingByKeyProvider(SettingKeys.keepWebsocketConnectionInBackground), (
    previous,
    next,
  ) {
    keepSocketConnectedInBackground = _isKeepSocketConnectedInBackground(next.value);
    syncSocketConnection();
  });

  final lifecycleListener = AppLifecycleListener(
    onStateChange: (state) {
      appLifecycleState = state;
      syncSocketConnection();
    },
  );

  syncSocketConnection();
  unawaited(Future<void>(() => hydrateServerTasksForUser(currentUser, serverReachable: canReachServer)));

  ref.onDispose(lifecycleListener.dispose);
  ref.onDispose(socketClient.dispose);

  return socketClient;
}
