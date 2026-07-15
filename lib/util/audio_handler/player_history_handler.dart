import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:drift/drift.dart';

enum PlayerHistoryType { sync, syncOffline, play, pause, stop, seek, localSync }

class PlayerHistoryHandler {
  static final Map<String, DateTime> _lastWriteByKey = <String, DateTime>{};

  static Duration _minimumIntervalForType(PlayerHistoryType type) {
    switch (type) {
      case PlayerHistoryType.sync:
      case PlayerHistoryType.syncOffline:
      case PlayerHistoryType.localSync:
        return const Duration(seconds: 9);
      case PlayerHistoryType.seek:
        return const Duration(seconds: 2);
      case PlayerHistoryType.play:
      case PlayerHistoryType.pause:
      case PlayerHistoryType.stop:
        return const Duration(seconds: 1);
    }
  }

  static bool _shouldSkipWrite({
    required String userId,
    required InternalMedia media,
    required PlayerHistoryType type,
  }) {
    final now = DateTime.now();
    final key = '$userId|${media.itemId}|${media.episodeId ?? ''}|${type.name}';
    final lastWrittenAt = _lastWriteByKey[key];
    final minimumInterval = _minimumIntervalForType(type);

    if (lastWrittenAt != null && now.difference(lastWrittenAt) < minimumInterval) {
      return true;
    }

    _lastWriteByKey[key] = now;
    return false;
  }

  static Future<void> addPlayerHistory(PlayerHistoryType type) async {
    // Player history is tied to the phone audio handler; entrypoints without
    // it (e.g. the Wear OS app) skip history collection.
    if (!isAudioHandlerInitialized || audioHandler.currentMediaItem == null) {
      return;
    }
    final InternalMedia currentMedia = audioHandler.currentMediaItem!;
    final userId = containerRef.read(currentUserProvider).value?.id;

    if (userId == null || userId.isEmpty) {
      return;
    }

    if (_shouldSkipWrite(userId: userId, media: currentMedia, type: type)) {
      return;
    }

    final db = containerRef.read(appDatabaseProvider);
    await db.addPlayerHistory(
      PlayerHistoryCompanion(
        itemId: Value(currentMedia.itemId),
        userId: Value(userId),
        episodeId: currentMedia.episodeId != null ? Value(currentMedia.episodeId) : const Value.absent(),
        currentTime: Value(audioHandler.position.inSecondsPrecise),
        type: Value(type.name),
      ),
    );
  }
}
