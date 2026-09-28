import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

/// Periodically syncs the open playback session while audio is playing and
/// flushes a final sync when playback pauses or stops. Player-agnostic: it
/// only needs a control-state stream and a way to read the current position
/// on the item's global timeline.
class PlaybackSyncService {
  final ProviderContainer _ref;
  final Duration Function() _position;
  Timer? _syncTimer;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  Future<void> _syncQueue = Future<void>.value();
  int? _effectiveSyncIntervalSeconds;

  static const int _minimumSyncIntervalSeconds = 5;
  static const int _minimumIosSyncIntervalSeconds = 20;

  DateTime? _currentSegmentStartTime;
  PlaybackSessionBinding? _activeSegmentBinding;
  bool _hasPlaybackSinceLastFlush = false;
  int _segmentGeneration = 0;

  PlaybackSyncService(this._ref, {required Stream<PlayerState> playerStateStream, required this._position}) {
    _currentSegmentStartTime = null;

    logger('PlaybackSyncService initialized', tag: 'PlaybackSyncService', level: InfoLevel.debug);

    _playerStateSubscription = playerStateStream.listen((playerState) {
      final bool isEffectivelyPlaying = playerState.playing && playerState.processingState == ProcessingState.ready;

      if (isEffectivelyPlaying) {
        final currentBinding = _ref.read(sessionRepositoryProvider).currentSessionBinding;
        if (currentBinding != null) {
          _hasPlaybackSinceLastFlush = true;
          _activeSegmentBinding ??= currentBinding;
        }
        if (_currentSegmentStartTime == null) {
          _segmentGeneration += 1;
          _currentSegmentStartTime = DateTime.now();
        }
        unawaited(_startSync());
      } else {
        if (_currentSegmentStartTime != null) {
          final binding = _activeSegmentBinding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
          final positionSnapshot = _position();
          unawaited(_stopSync(positionOverride: positionSnapshot, binding: binding));
        } else {
          _syncTimer?.cancel();
          _syncTimer = null;
          _activeSegmentBinding = null;
        }
      }
    });
  }

  int _resolvedSyncIntervalSeconds() {
    final User? user = _ref.read(currentUserProvider).value;
    final configuredInterval = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<int>(user?.id, SettingKeys.syncInterval);
    final normalizedInterval = configuredInterval < _minimumSyncIntervalSeconds
        ? _minimumSyncIntervalSeconds
        : configuredInterval;

    if (!kIsWeb && Platform.isIOS && normalizedInterval < _minimumIosSyncIntervalSeconds) {
      return _minimumIosSyncIntervalSeconds;
    }

    return normalizedInterval;
  }

  Future<void> _startSync() async {
    final intervalSeconds = _resolvedSyncIntervalSeconds();
    if ((_syncTimer?.isActive ?? false) && _effectiveSyncIntervalSeconds == intervalSeconds) {
      return;
    }

    _syncTimer?.cancel();
    _effectiveSyncIntervalSeconds = intervalSeconds;
    _syncTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) {
      final binding = _activeSegmentBinding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
      final positionSnapshot = _position();
      unawaited(_enqueueSync(positionOverride: positionSnapshot, binding: binding));
    });

    logger('Playback sync timer running every ${intervalSeconds}s', tag: 'PlaybackSyncService', level: InfoLevel.debug);
  }

  double _consumeListenedTime() {
    final segmentStart = _currentSegmentStartTime;
    if (segmentStart == null) {
      return 0;
    }

    final now = DateTime.now();
    final elapsed = now.difference(segmentStart);
    if (_syncTimer?.isActive ?? false) {
      _currentSegmentStartTime = now;
    } else {
      _currentSegmentStartTime = null;
    }
    return elapsed.inMicroseconds / Duration.microsecondsPerSecond;
  }

  Future<bool> _enqueuePreparedSync({
    required PlaybackSessionBinding? binding,
    required Duration position,
    required double listenedTime,
    required bool force,
  }) async {
    var result = false;

    _syncQueue = _syncQueue.catchError((_) {}).then((_) async {
      result = await _dispatchSync(binding: binding, position: position, listenedTime: listenedTime, force: force);
    });

    await _syncQueue;
    return result;
  }

  Future<bool> _enqueueSync({Duration? positionOverride, bool force = false, PlaybackSessionBinding? binding}) async {
    final capturedBinding = binding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
    final capturedPosition = positionOverride ?? _position();
    final listenedTime = _consumeListenedTime();
    return _enqueuePreparedSync(
      binding: capturedBinding,
      position: capturedPosition,
      listenedTime: listenedTime,
      force: force,
    );
  }

  Future<bool> _stopSync({
    Duration? positionOverride,
    bool sessionClosing = false,
    PlaybackSessionBinding? binding,
    bool forcePositionSync = false,
  }) async {
    final capturedBinding =
        binding ?? _activeSegmentBinding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
    final capturedPosition = positionOverride ?? _position();
    final segmentGeneration = _segmentGeneration;
    final hadPlaybackSinceLastFlush = _hasPlaybackSinceLastFlush;

    _syncTimer?.cancel();
    _syncTimer = null;
    final listenedTime = _consumeListenedTime();
    _activeSegmentBinding = null;

    if (sessionClosing) {
      await _syncQueue.catchError((_) {});
      if (!hadPlaybackSinceLastFlush && !forcePositionSync) {
        return false;
      }
    }

    final synced = await _enqueuePreparedSync(
      binding: capturedBinding,
      position: capturedPosition,
      listenedTime: listenedTime,
      force: true,
    );
    if (synced && segmentGeneration == _segmentGeneration) {
      _hasPlaybackSinceLastFlush = false;
    }
    return synced;
  }

  Future<bool> _dispatchSync({
    required PlaybackSessionBinding? binding,
    required Duration position,
    required double listenedTime,
    required bool force,
  }) async {
    if (binding == null) {
      return false;
    }

    final double currentPositionSeconds = position.inMicroseconds / Duration.microsecondsPerSecond;

    if (!force && listenedTime < 0.3) {
      logger(
        'Syncing skipped: listenedTime is too small: $listenedTime',
        tag: 'PlaybackSyncService',
        level: InfoLevel.warning,
      );
      return false;
    }

    logger(
      'Syncing playback session ${binding.sessionId}: currentPositionSeconds: $currentPositionSeconds, '
      'timeListenedInSeconds: $listenedTime',
      tag: 'PlaybackSyncService',
      level: InfoLevel.debug,
    );

    final bool canReachServer = _ref.read(serverReachabilityProvider);
    return _ref
        .read(sessionRepositoryProvider)
        .syncSessionBinding(binding, currentPositionSeconds, listenedTime, canReachServer: canReachServer);
  }

  Future<bool> flush({
    Duration? positionOverride,
    bool sessionClosing = false,
    PlaybackSessionBinding? binding,
    bool forcePositionSync = false,
  }) async {
    final capturedBinding =
        binding ?? _activeSegmentBinding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
    final capturedPosition = positionOverride ?? _position();
    return _stopSync(
      positionOverride: capturedPosition,
      sessionClosing: sessionClosing,
      binding: capturedBinding,
      forcePositionSync: forcePositionSync,
    );
  }

  void markProgressDirty() {
    _hasPlaybackSinceLastFlush = true;
  }

  Future<void> dispose() async {
    _syncTimer?.cancel();
    _syncTimer = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    _currentSegmentStartTime = null;
    _activeSegmentBinding = null;
    _hasPlaybackSinceLastFlush = false;
  }
}
