import 'dart:convert';

import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/extensions.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:drift/drift.dart';

enum PlayerHistoryType {
  sync,
  syncOffline,
  localSync,
  play,
  pause,
  stop,
  completed,
  seek,
  skipForward,
  skipBackward,
  speedChanged,
  sleepTimerStarted,
  sleepTimerAutoStarted,
  sleepTimerExtended,
  sleepTimerStopped,
  sleepTimerExpired,
  unknown,
}

enum PlayerHistoryCategory { playback, sleepTimer, sync, unknown }

extension PlayerHistoryTypeX on PlayerHistoryType {
  PlayerHistoryCategory get category {
    switch (this) {
      case PlayerHistoryType.sync:
      case PlayerHistoryType.syncOffline:
      case PlayerHistoryType.localSync:
        return PlayerHistoryCategory.sync;
      case PlayerHistoryType.sleepTimerStarted:
      case PlayerHistoryType.sleepTimerAutoStarted:
      case PlayerHistoryType.sleepTimerExtended:
      case PlayerHistoryType.sleepTimerStopped:
      case PlayerHistoryType.sleepTimerExpired:
        return PlayerHistoryCategory.sleepTimer;
      case PlayerHistoryType.play:
      case PlayerHistoryType.pause:
      case PlayerHistoryType.stop:
      case PlayerHistoryType.completed:
      case PlayerHistoryType.seek:
      case PlayerHistoryType.skipForward:
      case PlayerHistoryType.skipBackward:
      case PlayerHistoryType.speedChanged:
        return PlayerHistoryCategory.playback;
      case PlayerHistoryType.unknown:
        return PlayerHistoryCategory.unknown;
    }
  }
}

PlayerHistoryType playerHistoryTypeFromName(String name) {
  return PlayerHistoryType.values.firstWhere((type) => type.name == name, orElse: () => PlayerHistoryType.unknown);
}

Map<String, dynamic> decodePlayerHistoryDetails(String? rawDetails) {
  if (rawDetails == null || rawDetails.trim().isEmpty) {
    return const <String, dynamic>{};
  }

  try {
    final decoded = jsonDecode(rawDetails);
    return decoded is Map<String, dynamic> ? decoded : const <String, dynamic>{};
  } catch (_) {
    return const <String, dynamic>{};
  }
}

class PlayerHistoryHandler {
  static final Map<String, DateTime> _lastWriteByKey = <String, DateTime>{};

  static Duration _minimumIntervalForType(PlayerHistoryType type) {
    switch (type) {
      case PlayerHistoryType.sync:
      case PlayerHistoryType.syncOffline:
      case PlayerHistoryType.localSync:
        return const Duration(seconds: 9);
      case PlayerHistoryType.seek:
      case PlayerHistoryType.skipForward:
      case PlayerHistoryType.skipBackward:
        return const Duration(seconds: 2);
      case PlayerHistoryType.play:
      case PlayerHistoryType.pause:
      case PlayerHistoryType.stop:
      case PlayerHistoryType.completed:
      case PlayerHistoryType.speedChanged:
      case PlayerHistoryType.unknown:
        return const Duration(seconds: 1);
      case PlayerHistoryType.sleepTimerStarted:
      case PlayerHistoryType.sleepTimerAutoStarted:
      case PlayerHistoryType.sleepTimerExtended:
      case PlayerHistoryType.sleepTimerStopped:
      case PlayerHistoryType.sleepTimerExpired:
        return Duration.zero;
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

  static Future<void> addPlayerHistory(
    PlayerHistoryType type, {
    InternalMedia? media,
    Duration? position,
    Map<String, Object?> details = const <String, Object?>{},
  }) async {
    // Player history is tied to the phone audio handler; entrypoints without
    // it (e.g. the Wear OS app) skip history collection.
    if (!isAudioHandlerInitialized) {
      return;
    }
    final currentMedia = media ?? audioHandler.currentMediaItem;
    if (currentMedia == null) {
      return;
    }
    final userId = containerRef.read(currentUserProvider).value?.id;

    if (userId == null || userId.isEmpty) {
      return;
    }

    if (_shouldSkipWrite(userId: userId, media: currentMedia, type: type)) {
      return;
    }

    try {
      final db = containerRef.read(appDatabaseProvider);
      await db.addPlayerHistory(
        PlayerHistoryCompanion(
          itemId: Value(currentMedia.itemId),
          userId: Value(userId),
          episodeId: currentMedia.episodeId != null ? Value(currentMedia.episodeId) : const Value.absent(),
          currentTime: Value((position ?? audioHandler.position).inSecondsPrecise),
          type: Value(type.name),
          detailsJson: details.isEmpty ? const Value.absent() : Value(jsonEncode(details)),
        ),
      );
    } catch (error, stackTrace) {
      logger(
        'Failed to record player history event ${type.name}: $error\n$stackTrace',
        tag: 'PlayerHistory',
        level: InfoLevel.warning,
      );
    }
  }
}
