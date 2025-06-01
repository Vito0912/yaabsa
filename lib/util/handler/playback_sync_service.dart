import 'dart:async';

import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/handler/bg_audio_handler.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class PlaybackSyncService {
  final BGAudioHandler _handler;
  final ProviderContainer _ref;
  Timer? _syncTimer;

  DateTime? _currentSegmentStartTime;

  PlaybackSyncService(this._handler, this._ref) {
    _currentSegmentStartTime = null;

    logger('PlaybackSyncService initialized', tag: 'PlaybackSyncService', level: InfoLevel.debug);

    _handler.player.playerStateStream.distinct().listen((playerState) {
      final bool isEffectivelyPlaying = playerState.playing && playerState.processingState == ProcessingState.ready;

      if (isEffectivelyPlaying) {
        _currentSegmentStartTime ??= DateTime.now();
        _startSync();
      } else {
        if (_currentSegmentStartTime != null) {
          _stopSync();
        } else {
          _syncTimer?.cancel();
          _syncTimer = null;
        }
      }
    });
  }

  Future<void> _startSync() async {
    if (_syncTimer?.isActive ?? false) {
      return;
    }
    final User? user = _ref.read(currentUserProvider).value;
    final syncInterval = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<int>(user?.id, SettingKeys.syncInterval);

    _syncTimer = Timer.periodic(Duration(seconds: syncInterval), (_) {
      _sync();
    });
  }

  Future<void> _stopSync() async {
    _syncTimer?.cancel();
    _syncTimer = null;
    await _sync();
  }

  Future<bool> _sync() async {
    final Duration currentPositionDuration = _handler.position;
    final double currentPositionSeconds = currentPositionDuration.inMicroseconds / Duration.microsecondsPerSecond;
    double listenedTime = 0;

    if (_currentSegmentStartTime != null) {
      final DateTime now = DateTime.now();
      final Duration elapsedSinceLastMark = now.difference(_currentSegmentStartTime!);
      listenedTime = elapsedSinceLastMark.inMicroseconds / Duration.microsecondsPerSecond;

      if (_syncTimer?.isActive ?? false) {
        _currentSegmentStartTime = now;
      } else {
        _currentSegmentStartTime = null;
      }
    }

    // When seeking, this could produce many requests
    if (listenedTime < 0.3) {
      logger(
        'Syncing skipped: listenedTime is too small: $listenedTime',
        tag: 'PlaybackSyncService',
        level: InfoLevel.warning,
      );
      return false;
    }

    logger(
      'Syncing playback: currentPositionSeconds: $currentPositionSeconds, timeListenedInSeconds: $listenedTime',
      tag: 'PlaybackSyncService',
      level: InfoLevel.debug,
    );

    return await _ref.read(sessionRepositoryProvider).syncOpenSession(currentPositionSeconds, listenedTime);
  }

  Future<bool> flush() async {
    await _stopSync();
    _currentSegmentStartTime = null;
    return true;
  }
}
