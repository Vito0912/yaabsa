// lib/provider/sleep_timer_handler.dart
import 'dart:async';

import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:yaabsa/models/internal_media.dart';

import 'sleep_timer_data.dart';
import 'chapter_sleep_timer.dart';
import 'sleep_timer_fade.dart';
import 'sleep_timer_auto_config.dart';

export 'sleep_timer_data.dart';

part 'sleep_timer_handler.g.dart';
part 'sleep_timer_markers.dart';
part 'sleep_timer_chapters.dart';
part 'sleep_timer_automatic.dart';
part 'sleep_timer_expiry.dart';

@riverpod
class SleepTimerHandler extends _$SleepTimerHandler {
  SleepTimerData get _data => state;
  set _data(SleepTimerData value) => state = value;
  SettingsManager get _settings => ref.read(settingsManagerProvider.notifier);
  SessionRepository get _sessionRepository => ref.read(sessionRepositoryProvider);

  DateTime get currentTime => DateTime.now();
  Future<void> recordHistory(PlayerHistoryType type, {Map<String, Object?> details = const {}}) =>
      PlayerHistoryHandler.addPlayerHistory(type, details: details);

  Timer? _timer;
  DateTime? _countdownStartTime;
  Duration? _countdownRunDuration;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _wasPlaybackRunning = false;
  bool _autoStartPending = false;
  String? _lastMediaKey;
  bool _pauseTriggeredByPlayback = false;
  late SleepTimerFade _fade;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<InternalMedia?>? _mediaSubscription;
  ChapterSleepTimer? _chapterTimer;
  String? _chapterMediaKey;
  PlaybackSessionBinding? _chapterBinding;
  int _chapterNavigationGeneration = 0;
  String? _completedChapterMediaKey;
  Future<void>? _expiry;
  bool _disposed = false;
  int _runRevision = 0;
  Timer? _markerPinHideTimer;
  Timer? _markerRangeHideTimer;

  @override
  SleepTimerData build() {
    _disposed = false;
    _fade = SleepTimerFade(
      readVolume: () => audioHandler.volume,
      writeVolume: (volume) => _setPlayerVolumeSafely(volume, reason: 'sleep timer fade'),
    );
    scheduleMicrotask(attachPlaybackListeners);

    ref.onDispose(() {
      _disposed = true;
      _positionSubscription?.cancel();
      _mediaSubscription?.cancel();
      _timer?.cancel();
      _timer = null;
      _countdownStartTime = null;
      _countdownRunDuration = null;
      _markerPinHideTimer?.cancel();
      _markerPinHideTimer = null;
      _markerRangeHideTimer?.cancel();
      _markerRangeHideTimer = null;

      _playerStateSubscription?.cancel();
      _playerStateSubscription = null;

      unawaited(_restoreFadeVolumeIfNeeded());
    });

    final markerRawValue = ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<String>(SettingKeys.sleepTimerMarker, defaultValue: '');
    final marker = SleepTimerMarker.fromRawJson(markerRawValue);
    final hasEnded = marker?.endPosition != null;
    return SleepTimerData(
      remainingTime: Duration.zero,
      state: SleepTimerState.inactive,
      marker: marker,
      showMarkerPin: hasEnded,
      showMarkerRange: hasEnded,
    );
  }

  void attachPlaybackListeners() {
    if (_disposed || _playerStateSubscription != null || !isAudioHandlerInitialized) return;
    unawaited(initializeAutoMinutes());
    _wasPlaybackRunning = false;
    _playerStateSubscription = audioHandler.playerControlStateStream.listen(_handlePlayerStateChanged);
    _positionSubscription = audioHandler.positionStream.listen((position) {
      if (!audioHandler.sleepTimerSeekInProgress) _updateChapterPosition(position);
    });
    _mediaSubscription = audioHandler.mediaItemStream.listen((media) {
      if (_disposed) return;
      final key = _mediaKey(media);
      final changed = key != _lastMediaKey;
      _lastMediaKey = key;
      if (_chapterTimer != null && _mediaKey(media) != _chapterMediaKey) {
        stop(recordHistory: false);
      }
      if (changed && media != null) _autoStartPending = true;
      if (_autoStartPending) _tryAutoRestartSleepTimerOnPlaybackStart();
    });
    _handlePlayerStateChanged(audioHandler.playerControlState);
  }

  void _handlePlayerStateChanged(PlayerState playerState) {
    if (_disposed) return;
    if (playerState.processingState == ProcessingState.completed && audioHandler.sleepTimerSeekInProgress) return;
    if (playerState.processingState == ProcessingState.completed &&
        state.isRunning &&
        _chapterTimer != null &&
        !audioHandler.sleepTimerSeekInProgress) {
      unawaited(_onTimerExpired());
      _wasPlaybackRunning = false;
      return;
    }
    final isRunning = playerState.playing && playerState.processingState != ProcessingState.completed;
    final wasRunning = _wasPlaybackRunning;
    _wasPlaybackRunning = isRunning;

    if (wasRunning && !isRunning && state.isRunning) {
      pause(triggeredByPlaybackPause: true);
      return;
    }

    if (!wasRunning && isRunning) {
      if (_expiry != null) return;
      _completedChapterMediaKey = null;
      _autoStartPending = true;
      if (_pauseTriggeredByPlayback && state.state == SleepTimerState.paused) {
        resume();
        _scheduleMarkerPinHide();
        return;
      }

      _scheduleMarkerPinHide();
      _tryAutoRestartSleepTimerOnPlaybackStart();
    }
    if (_autoStartPending && isRunning) _tryAutoRestartSleepTimerOnPlaybackStart();
  }

  bool _isFadeOutEnabled() {
    return ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.sleepTimerFadeOutEnabled);
  }

  Duration _remainingForCurrentRun() {
    if (_chapterTimer != null) return _chapterTimer!.remainingTime(audioHandler.effectivePlaybackSpeed);
    final countdownStartTime = _countdownStartTime;
    final countdownRunDuration = _countdownRunDuration;
    if (countdownStartTime == null || countdownRunDuration == null) {
      return state.remainingTime;
    }

    final elapsed = currentTime.difference(countdownStartTime);
    final remaining = countdownRunDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Future<void> _setPlayerVolumeSafely(double volume, {required String reason}) async {
    try {
      await audioHandler.setVolume(volume);
    } catch (e) {
      logger('Failed to set volume during $reason: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    }
  }

  Future<void> _restoreFadeVolumeIfNeeded() => _fade.restore();

  void _applyFadeOutIfNeeded(Duration remaining) {
    _fade.apply(remaining, enabled: _isFadeOutEnabled());
  }

  Future<void> _persistLastDuration(Duration duration) async {
    final minutes = duration.inMinutes < 1 ? 1 : duration.inMinutes;
    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setGlobalSetting<int>(SettingKeys.sleepTimerLastDurationMinutes, minutes);
    } catch (e) {
      logger('Failed to persist last sleep timer duration: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    }
  }

  void start(Duration duration, {bool automatic = false}) {
    if (_expiry != null || duration <= Duration.zero) {
      return;
    }

    if (state.isActive) {
      stop(recordHistory: false);
    }

    _pauseTriggeredByPlayback = false;

    unawaited(_restoreFadeVolumeIfNeeded());

    unawaited(initializeAutoMinutes());
    unawaited(_persistLastDuration(duration));
    _runRevision++;
    _completedChapterMediaKey = null;

    logger('Sleep timer started for ${duration.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    _cancelMarkerVisibilityTimers();
    final marker = _createMarker();
    state = SleepTimerData(
      remainingTime: duration,
      state: audioHandler.playerControlState.playing ? SleepTimerState.running : SleepTimerState.paused,
      totalDuration: duration,
      marker: marker,
      showMarkerPin: false,
      showMarkerRange: false,
    );
    unawaited(_persistMarker(marker));
    if (audioHandler.playerControlState.playing) {
      _scheduleMarkerPinHide();
    }

    unawaited(
      recordHistory(
        automatic ? PlayerHistoryType.sleepTimerAutoStarted : PlayerHistoryType.sleepTimerStarted,
        details: <String, Object?>{'durationSeconds': duration.inSeconds},
      ),
    );

    _pauseTriggeredByPlayback = !audioHandler.playerControlState.playing;
    if (state.isRunning) _startTimer(duration);
  }

  void stop({bool recordHistory = true}) {
    _autoStartPending = false;
    final chapterDetails = <String, Object?>{
      if (state.isChapterTimer) 'mode': state.mode.name,
      if (state.isChapterTimer) 'remainingChapters': state.remainingChapters,
    };
    final remainingTime = state.isRunning ? _remainingForCurrentRun() : state.remainingTime;
    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _pauseTriggeredByPlayback = false;
    _cancelMarkerVisibilityTimers();

    unawaited(_restoreFadeVolumeIfNeeded());

    _runRevision++;
    _chapterTimer = null;
    _chapterMediaKey = null;
    _chapterBinding = null;

    logger('Sleep timer stopped', tag: 'SleepTimer', level: InfoLevel.info);

    state = const SleepTimerData(
      remainingTime: Duration.zero,
      state: SleepTimerState.inactive,
      showMarkerPin: false,
      showMarkerRange: false,
    );
    unawaited(_persistMarker(null));

    if (recordHistory) {
      unawaited(
        this.recordHistory(
          PlayerHistoryType.sleepTimerStopped,
          details: <String, Object?>{
            ...chapterDetails,
            'remainingSeconds': remainingTime.inSeconds,
            'source': 'manual',
          },
        ),
      );
    }
  }

  void pause({bool triggeredByPlaybackPause = false}) {
    if (!state.isRunning) return;
    if (_chapterTimer != null) {
      _updateChapterPosition(audioHandler.position);
      if (!state.isRunning) return;
    }

    final remainingTime = _remainingForCurrentRun();

    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _pauseTriggeredByPlayback = triggeredByPlaybackPause;

    unawaited(_restoreFadeVolumeIfNeeded());

    logger('Sleep timer paused', tag: 'SleepTimer', level: InfoLevel.info);

    final marker = _completeMarkerAtCurrentPosition();
    state = state.copyWith(remainingTime: remainingTime, state: SleepTimerState.paused, marker: marker);
    _showMarker(showPin: false);
    unawaited(_persistMarker(marker));
    unawaited(
      recordHistory(
        PlayerHistoryType.sleepTimerStopped,
        details: <String, Object?>{
          'remainingSeconds': remainingTime.inSeconds,
          if (state.isChapterTimer) 'mode': state.mode.name,
          if (state.isChapterTimer) 'remainingChapters': state.remainingChapters,
          'source': triggeredByPlaybackPause ? 'playback' : 'manual',
        },
      ),
    );
  }

  void resume() {
    if (state.state != SleepTimerState.paused || (!state.isChapterTimer && state.remainingTime <= Duration.zero)) {
      return;
    }

    _pauseTriggeredByPlayback = false;

    logger('Sleep timer resumed', tag: 'SleepTimer', level: InfoLevel.info);

    final marker = state.marker?.copyWith(clearEndPosition: true);
    state = state.copyWith(state: SleepTimerState.running, marker: marker, forceMarkerVisibility: false);
    _showMarker(showPin: false);
    unawaited(_persistMarker(marker));
    unawaited(
      recordHistory(
        PlayerHistoryType.sleepTimerStarted,
        details: <String, Object?>{
          'durationSeconds': state.remainingTime.inSeconds,
          'source': 'resume',
          if (state.isChapterTimer) 'mode': state.mode.name,
          if (state.isChapterTimer) 'chapters': state.remainingChapters,
        },
      ),
    );
    if (_chapterTimer != null) {
      _chapterNavigationGeneration = audioHandler.sleepTimerNavigationGeneration;
      _chapterTimer!.rebase(audioHandler.position);
      _updateChapterPosition(audioHandler.position);
    } else {
      _startTimer(state.remainingTime);
    }
  }

  void extend(Duration additionalTime) {
    if (!state.isActive || state.isChapterTimer || additionalTime <= Duration.zero) return;
    unawaited(initializeAutoMinutes());

    final isRunning = state.isRunning;
    final baseRemainingTime = isRunning ? _remainingForCurrentRun() : state.remainingTime;
    final newRemainingTime = baseRemainingTime + additionalTime;
    final newTotalDuration = (state.totalDuration ?? baseRemainingTime) + additionalTime;

    logger('Sleep timer extended by ${additionalTime.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(remainingTime: newRemainingTime, totalDuration: newTotalDuration);
    unawaited(
      recordHistory(
        PlayerHistoryType.sleepTimerExtended,
        details: <String, Object?>{
          'additionalSeconds': additionalTime.inSeconds,
          'remainingSeconds': newRemainingTime.inSeconds,
        },
      ),
    );

    if (isRunning) {
      _startTimer(newRemainingTime);
      _applyFadeOutIfNeeded(newRemainingTime);
    }

    unawaited(_persistLastDuration(newTotalDuration));
  }

  void reset() {
    if (!state.isActive) return;
    if (state.isChapterTimer) {
      extendChapter();
      return;
    }

    final totalDuration = state.totalDuration ?? state.remainingTime;
    if (totalDuration <= Duration.zero) return;

    logger('Sleep timer reset to ${totalDuration.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    unawaited(
      recordHistory(
        PlayerHistoryType.sleepTimerStopped,
        details: <String, Object?>{'remainingSeconds': totalDuration.inSeconds, 'source': 'reset'},
      ),
    );

    unawaited(_restoreFadeVolumeIfNeeded());

    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _cancelMarkerVisibilityTimers();

    final marker = state.marker?.copyWith(clearEndPosition: true);
    if (state.state == SleepTimerState.paused) {
      state = state.copyWith(
        remainingTime: totalDuration,
        totalDuration: totalDuration,
        marker: marker,
        forceMarkerVisibility: false,
      );
      _showMarker(showPin: false);
      unawaited(_persistMarker(marker));
      return;
    }

    state = SleepTimerData(
      remainingTime: totalDuration,
      state: SleepTimerState.running,
      totalDuration: totalDuration,
      marker: marker,
      forceMarkerVisibility: false,
    );
    _showMarker(showPin: false);
    unawaited(_persistMarker(marker));

    _startTimer(totalDuration);
    unawaited(_persistLastDuration(totalDuration));
  }

  void _startTimer(Duration duration) {
    _timer?.cancel();
    _countdownStartTime = currentTime;
    _countdownRunDuration = duration;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = _remainingForCurrentRun();

      if (remaining <= Duration.zero) {
        unawaited(_onTimerExpired());
        timer.cancel();
      } else {
        _applyFadeOutIfNeeded(remaining);

        if ((state.remainingTime - remaining).abs() >= const Duration(milliseconds: 500)) {
          state = state.copyWith(remainingTime: remaining);
        }
      }
    });
  }
}

@riverpod
Duration sleepTimerRemainingTime(Ref ref) {
  return ref.watch(sleepTimerHandlerProvider).remainingTime;
}

@riverpod
SleepTimerState sleepTimerState(Ref ref) {
  return ref.watch(sleepTimerHandlerProvider).state;
}

@riverpod
bool sleepTimerIsActive(Ref ref) {
  return ref.watch(sleepTimerHandlerProvider).isActive;
}
