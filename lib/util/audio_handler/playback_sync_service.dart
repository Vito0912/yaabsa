import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/core/server_reachability_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/audio_handler/listening_session_clock.dart';
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
  Timer? _midnightTimer;
  bool _disposed = false;
  ProviderSubscription<bool>? _reachabilitySubscription;
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
    _reachabilitySubscription = _ref.listen<bool>(serverReachabilityProvider, (previous, next) {
      if (previous == false && next && !_disposed) {
        unawaited(_enqueueSync(force: true));
      }
    });

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
          _midnightTimer?.cancel();
          _midnightTimer = null;
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
    _scheduleMidnight();
    final intervalSeconds = _resolvedSyncIntervalSeconds();
    if ((_syncTimer?.isActive ?? false) && _effectiveSyncIntervalSeconds == intervalSeconds) {
      return;
    }

    _syncTimer?.cancel();
    _effectiveSyncIntervalSeconds = intervalSeconds;
    _syncTimer = Timer.periodic(Duration(seconds: intervalSeconds), (_) {
      _scheduleMidnight();
      final binding = _activeSegmentBinding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
      final positionSnapshot = _position();
      unawaited(_enqueueSync(positionOverride: positionSnapshot, binding: binding));
    });

    unawaited(_enqueueSync());

    logger('Playback sync timer running every ${intervalSeconds}s', tag: 'PlaybackSyncService', level: InfoLevel.debug);
  }

  double _consumeListenedTime(DateTime now) {
    final segmentStart = _currentSegmentStartTime;
    if (segmentStart == null) {
      return 0;
    }

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
    DateTime? segmentStart,
    DateTime? recordedAt,
  }) async {
    var result = false;

    _syncQueue = _syncQueue.catchError((_) {}).then((_) async {
      result = await _syncCapturedSegment(
        binding: binding,
        position: position,
        listenedTime: listenedTime,
        force: force,
        segmentStart: segmentStart,
        recordedAt: recordedAt ?? DateTime.now(),
      );
    });

    await _syncQueue;
    return result;
  }

  Future<bool> _enqueueSync({Duration? positionOverride, bool force = false, PlaybackSessionBinding? binding}) async {
    final capturedBinding = binding ?? _ref.read(sessionRepositoryProvider).currentSessionBinding;
    final capturedPosition = positionOverride ?? _position();
    final segmentStart = _currentSegmentStartTime;
    final recordedAt = DateTime.now();
    final listenedTime = _consumeListenedTime(recordedAt);
    return _enqueuePreparedSync(
      binding: capturedBinding,
      position: capturedPosition,
      listenedTime: listenedTime,
      segmentStart: segmentStart,
      recordedAt: recordedAt,
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
    _midnightTimer?.cancel();
    _midnightTimer = null;
    final segmentStart = _currentSegmentStartTime;
    final recordedAt = DateTime.now();
    final listenedTime = _consumeListenedTime(recordedAt);
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
      segmentStart: segmentStart,
      recordedAt: recordedAt,
      force: true,
    );
    if (synced && segmentGeneration == _segmentGeneration) {
      _hasPlaybackSinceLastFlush = false;
    }
    return synced;
  }

  ListeningSessionClock _sessionClock() =>
      ListeningSessionClock(_ref.read(currentUserProvider).value?.setting?.timeZone);

  bool get _restartAtMidnight =>
      _ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.restartListeningSessionAtMidnight);

  void _scheduleMidnight() {
    _midnightTimer?.cancel();
    if (_disposed || !_restartAtMidnight) return;
    final now = DateTime.now();
    _midnightTimer = Timer(_sessionClock().nextMidnight(now).difference(now), () {
      unawaited(_enqueueSync(force: true));
      _scheduleMidnight();
    });
  }

  Future<bool> restartSession() async {
    final binding = _ref.read(sessionRepositoryProvider).currentSessionBinding;
    final position = _position();
    if (binding == null || !await _enqueueSync(positionOverride: position, binding: binding, force: true)) return false;
    var restarted = false;
    _syncQueue = _syncQueue.catchError((_) {}).then((_) {
      final repository = _ref.read(sessionRepositoryProvider);
      if (_disposed || !repository.isCurrentSessionBinding(binding)) return;
      final now = DateTime.now();
      restarted = repository.restartListeningSession(
        startedAt: now,
        calendarDate: _sessionClock().calendarDate(now),
        position: position.inMicroseconds / Duration.microsecondsPerSecond,
      );
    });
    await _syncQueue;
    return restarted;
  }

  Future<bool> _syncCapturedSegment({
    required PlaybackSessionBinding? binding,
    required Duration position,
    required double listenedTime,
    required bool force,
    required DateTime? segmentStart,
    required DateTime recordedAt,
  }) async {
    if (binding == null) return false;
    final repository = _ref.read(sessionRepositoryProvider);
    var target = repository.isCurrentSessionBinding(binding) ? repository.currentSessionBinding! : binding;
    var remaining = listenedTime;
    var start = segmentStart;
    final clock = _sessionClock();
    if (_restartAtMidnight) {
      while (repository.isCurrentSessionBinding(target) && repository.recordingStartedAt != null) {
        final boundary = clock.nextMidnight(repository.recordingStartedAt!);
        if (boundary.isAfter(recordedAt)) break;
        final earlier = start != null && start.isBefore(boundary);
        final before = earlier
            ? (boundary.difference(start).inMicroseconds / Duration.microsecondsPerSecond)
                  .clamp(0.0, remaining)
                  .toDouble()
            : 0.0;
        if (!await _dispatchSync(
          binding: target,
          position: position,
          listenedTime: before,
          force: true,
          recordedAt: boundary.subtract(const Duration(milliseconds: 1)),
        )) {
          return false;
        }
        if (!repository.isCurrentSessionBinding(target)) return false;
        final rotatedAt = earlier ? boundary : recordedAt;
        repository.restartListeningSession(
          startedAt: rotatedAt,
          calendarDate: clock.calendarDate(rotatedAt),
          position: position.inMicroseconds / Duration.microsecondsPerSecond,
        );
        target = repository.currentSessionBinding!;
        remaining -= before;
        if (earlier) start = boundary;
      }
    }
    return _dispatchSync(
      binding: target,
      position: position,
      listenedTime: remaining,
      force: force,
      recordedAt: recordedAt,
    );
  }

  Future<bool> _dispatchSync({
    required PlaybackSessionBinding? binding,
    required Duration position,
    required double listenedTime,
    required bool force,
    DateTime? recordedAt,
  }) async {
    if (_disposed || binding == null) {
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
        .syncSessionBinding(
          binding,
          currentPositionSeconds,
          listenedTime,
          canReachServer: canReachServer,
          recordedAt: recordedAt,
        );
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
    _disposed = true;
    _reachabilitySubscription?.close();
    _reachabilitySubscription = null;
    _syncTimer?.cancel();
    _syncTimer = null;
    _midnightTimer?.cancel();
    _midnightTimer = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _syncQueue.catchError((_) {});
    _currentSegmentStartTime = null;
    _activeSegmentBinding = null;
    _hasPlaybackSinceLastFlush = false;
  }
}
