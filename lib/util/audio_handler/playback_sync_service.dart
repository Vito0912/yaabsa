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
  StreamSubscription<PlayerState>? _playerStateSubscription;
  ProviderSubscription<bool>? _reachabilitySubscription;
  Future<void> _syncQueue = Future<void>.value();
  int? _effectiveSyncIntervalSeconds;

  static const int _minimumSyncIntervalSeconds = 5;
  static const int _minimumIosSyncIntervalSeconds = 20;

  DateTime? _currentSegmentStartTime;
  bool _hasPlaybackSinceLastFlush = false;

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
        if (_ref.read(sessionRepositoryProvider).currentSession != null) {
          _hasPlaybackSinceLastFlush = true;
        }
        _currentSegmentStartTime ??= DateTime.now();
        unawaited(_startSync());
      } else {
        if (_currentSegmentStartTime != null) {
          unawaited(_stopSync());
        } else {
          _syncTimer?.cancel();
          _syncTimer = null;
          _midnightTimer?.cancel();
          _midnightTimer = null;
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
      unawaited(_enqueueSync());
    });

    unawaited(_enqueueSync());

    logger('Playback sync timer running every ${intervalSeconds}s', tag: 'PlaybackSyncService', level: InfoLevel.debug);
  }

  Future<bool> _enqueueSync({Duration? positionOverride, bool force = false}) async {
    var result = false;

    _syncQueue = _syncQueue.catchError((_) {}).then((_) async {
      result = await _sync(positionOverride: positionOverride, force: force);
    });

    await _syncQueue;
    return result;
  }

  Future<bool> _stopSync({Duration? positionOverride, bool sessionClosing = false}) async {
    _syncTimer?.cancel();
    _syncTimer = null;
    _midnightTimer?.cancel();
    _midnightTimer = null;

    if (sessionClosing) {
      await _syncQueue.catchError((_) {});
      if (!_hasPlaybackSinceLastFlush) {
        return false;
      }
    }

    final synced = await _enqueueSync(positionOverride: positionOverride, force: true);
    if (synced) {
      _hasPlaybackSinceLastFlush = false;
    }
    return synced;
  }

  ListeningSessionClock _sessionClock() {
    return ListeningSessionClock(_ref.read(currentUserProvider).value?.setting?.timeZone);
  }

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
    var restarted = false;
    _syncQueue = _syncQueue.catchError((_) {}).then((_) async {
      if (_disposed) return;
      final repository = _ref.read(sessionRepositoryProvider);
      if (repository.currentSession == null) return;
      if (!await _sync(force: true)) return;
      final now = DateTime.now();
      restarted = repository.restartListeningSession(
        startedAt: now,
        calendarDate: _sessionClock().calendarDate(now),
        position: _position().inMicroseconds / Duration.microsecondsPerSecond,
      );
    });
    await _syncQueue;
    return restarted;
  }

  Future<bool> _sync({Duration? positionOverride, bool force = false}) async {
    if (_disposed) return false;
    final repository = _ref.read(sessionRepositoryProvider);
    final clock = _sessionClock();
    final now = DateTime.now();
    if (_restartAtMidnight) {
      while (repository.currentSession != null && repository.recordingStartedAt != null) {
        final boundary = clock.nextMidnight(repository.recordingStartedAt!);
        if (boundary.isAfter(now)) break;
        final sessionId = repository.currentSession!.id;
        final segmentStart = _currentSegmentStartTime;
        final hasEarlierPlayback = segmentStart != null && segmentStart.isBefore(boundary);
        final rotatedAt = hasEarlierPlayback ? boundary : now;
        final synced = await _syncSegment(
          positionOverride: positionOverride,
          force: true,
          until: boundary,
          recordedAt: boundary.subtract(const Duration(milliseconds: 1)),
          continueSegment: true,
        );
        if (!synced || _disposed || repository.currentSession?.id != sessionId) return false;
        repository.restartListeningSession(
          startedAt: rotatedAt,
          calendarDate: clock.calendarDate(rotatedAt),
          position: (positionOverride ?? _position()).inMicroseconds / Duration.microsecondsPerSecond,
        );
      }
    }
    return _syncSegment(positionOverride: positionOverride, force: force);
  }

  Future<bool> _syncSegment({
    Duration? positionOverride,
    bool force = false,
    DateTime? until,
    DateTime? recordedAt,
    bool continueSegment = false,
  }) async {
    final currentSession = _ref.read(sessionRepositoryProvider).currentSession;
    if (currentSession == null) {
      _currentSegmentStartTime = null;
      _hasPlaybackSinceLastFlush = false;
      return false;
    }

    final syncUntil = until ?? DateTime.now();
    final Duration currentPositionDuration = positionOverride ?? _position();
    final double currentPositionSeconds = currentPositionDuration.inMicroseconds / Duration.microsecondsPerSecond;
    double listenedTime = 0;

    if (_currentSegmentStartTime != null) {
      final DateTime now = syncUntil;
      final Duration elapsedSinceLastMark = now.difference(_currentSegmentStartTime!);
      listenedTime = elapsedSinceLastMark.inMicroseconds.clamp(0, double.maxFinite) / Duration.microsecondsPerSecond;
    }

    if (!force && listenedTime < 0.3) {
      logger(
        'Syncing skipped: listenedTime is too small: $listenedTime',
        tag: 'PlaybackSyncService',
        level: InfoLevel.warning,
      );
      return false;
    }

    if (_currentSegmentStartTime != null) {
      final mark = syncUntil;
      if (continueSegment || (_syncTimer?.isActive ?? false)) {
        if (mark.isAfter(_currentSegmentStartTime!)) _currentSegmentStartTime = mark;
      } else {
        _currentSegmentStartTime = null;
      }
    }

    logger(
      'Syncing playback: currentPositionSeconds: $currentPositionSeconds, timeListenedInSeconds: $listenedTime',
      tag: 'PlaybackSyncService',
      level: InfoLevel.debug,
    );

    final bool canReachServer = _ref.read(serverReachabilityProvider);

    return await _ref
        .read(sessionRepositoryProvider)
        .syncOpenSession(currentPositionSeconds, listenedTime, canReachServer: canReachServer, recordedAt: recordedAt);
  }

  Future<bool> flush({Duration? positionOverride, bool sessionClosing = false}) async {
    final synced = await _stopSync(positionOverride: positionOverride, sessionClosing: sessionClosing);
    if (sessionClosing) {
      _hasPlaybackSinceLastFlush = false;
    }
    _currentSegmentStartTime = null;
    return synced;
  }

  void markProgressDirty() {
    _hasPlaybackSinceLastFlush = true;
  }

  Future<void> dispose() async {
    _disposed = true;
    _reachabilitySubscription?.close();
    _reachabilitySubscription = null;
    _midnightTimer?.cancel();
    _midnightTimer = null;
    _syncTimer?.cancel();
    _syncTimer = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _syncQueue.catchError((_) {});
    _currentSegmentStartTime = null;
    _hasPlaybackSinceLastFlush = false;
  }
}
