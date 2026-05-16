import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/socket/abs_socket_client.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/server_tasks_provider.dart';
import 'package:yaabsa/provider/core/server_status_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/library/personalized_shelf_refresh.dart';
import 'package:yaabsa/util/logger.dart';

part 'socket_provider.g.dart';

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
  );

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
      return;
    }

    if (!serverReachable) {
      logger(
        'Skipping socket connect for user ${user!.username} because server is offline/unreachable.',
        tag: 'SocketProvider',
        level: InfoLevel.debug,
      );
      socketClient.disconnect();
      return;
    }

    logger(
      'Connecting Audiobookshelf socket for user ${user!.username}',
      tag: 'SocketProvider',
      level: InfoLevel.debug,
    );
    socketClient.connect(serverUrl: serverUrl, apiToken: token, headers: serverHeaders);
  }

  ref.listen<AsyncValue<User?>>(currentUserProvider, (previous, next) {
    if (previous?.value?.id != next.value?.id) {
      serverTasksNotifier.reset();
    }

    final canReachServer = ref.read(serverStatusProvider).value ?? false;
    updateSocketForUser(next.value, serverReachable: canReachServer);
    unawaited(hydrateServerTasksForUser(next.value, serverReachable: canReachServer));
  });

  ref.listen<AsyncValue<bool>>(serverStatusProvider, (previous, next) {
    final currentUser = ref.read(currentUserProvider).value;
    final canReachServer = next.value ?? false;
    updateSocketForUser(currentUser, serverReachable: canReachServer);
    unawaited(hydrateServerTasksForUser(currentUser, serverReachable: canReachServer));
  });

  final initialUser = ref.read(currentUserProvider).value;
  final initialServerReachable = ref.read(serverStatusProvider).value ?? false;
  updateSocketForUser(initialUser, serverReachable: initialServerReachable);
  unawaited(Future<void>(() => hydrateServerTasksForUser(initialUser, serverReachable: initialServerReachable)));

  ref.onDispose(socketClient.dispose);

  return socketClient;
}
