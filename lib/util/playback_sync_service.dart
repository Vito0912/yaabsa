import 'dart:async';

import 'package:buchshelfly/provider/player/session_provider.dart';
import 'package:buchshelfly/util/bg_audio_handler.dart';
import 'package:buchshelfly/util/logger.dart';
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
    _syncTimer = Timer.periodic(const Duration(seconds: 1), (_) {
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
      return false;
    }

    logger(
      'Syncing playback: currentPositionSeconds: $currentPositionSeconds, timeListenedInSeconds: $listenedTime',
      tag: 'PlaybackSyncService',
      level: InfoLevel.debug,
    );

    return await _ref.read(sessionRepositoryProvider).syncOpenSession(currentPositionSeconds, listenedTime);
  }

  Future<void> flush() async {
    await _stopSync();
    _currentSegmentStartTime = null;
  }
}
