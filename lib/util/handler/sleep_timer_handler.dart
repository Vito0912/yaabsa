// lib/provider/sleep_timer_handler.dart
import 'dart:async';
import 'dart:math' as math;

import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sleep_timer_handler.g.dart';

enum SleepTimerState { inactive, running, paused }

const Duration _sleepTimerTickInterval = Duration(seconds: 1);
const Duration _sleepTimerUiUpdateInterval = Duration(milliseconds: 500);
const Duration _sleepTimerFadeOutDuration = Duration(seconds: 30);
const double _sleepTimerFadeCurveExponent = 1.8;

class SleepTimerData {
  final Duration remainingTime;
  final SleepTimerState state;
  final Duration? totalDuration;

  const SleepTimerData({required this.remainingTime, required this.state, this.totalDuration});

  bool get isActive => state != SleepTimerState.inactive;
  bool get isRunning => state == SleepTimerState.running;

  SleepTimerData copyWith({Duration? remainingTime, SleepTimerState? state, Duration? totalDuration}) {
    return SleepTimerData(
      remainingTime: remainingTime ?? this.remainingTime,
      state: state ?? this.state,
      totalDuration: totalDuration ?? this.totalDuration,
    );
  }
}

@riverpod
class SleepTimerHandler extends _$SleepTimerHandler {
  Timer? _timer;
  DateTime? _countdownStartTime;
  Duration? _countdownRunDuration;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _wasPlaybackRunning = false;
  bool _pauseTriggeredByPlayback = false;
  double? _fadeBaseVolume;

  @override
  SleepTimerData build() {
    _attachPlaybackStateListener();

    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
      _countdownStartTime = null;
      _countdownRunDuration = null;

      _playerStateSubscription?.cancel();
      _playerStateSubscription = null;

      unawaited(_restoreFadeVolumeIfNeeded());
    });

    return const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);
  }

  void _attachPlaybackStateListener() {
    try {
      _wasPlaybackRunning = audioHandler.playerControlState.playing;
      _playerStateSubscription = audioHandler.playerControlStateStream.listen(_handlePlayerStateChanged);
    } catch (e) {
      logger('Failed to attach sleep timer playback listener: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    }
  }

  void _handlePlayerStateChanged(PlayerState playerState) {
    final isRunning = playerState.playing;
    final wasRunning = _wasPlaybackRunning;
    _wasPlaybackRunning = isRunning;

    if (wasRunning && !isRunning && state.isRunning) {
      pause(triggeredByPlaybackPause: true);
      return;
    }

    if (!wasRunning && isRunning) {
      if (_pauseTriggeredByPlayback && state.state == SleepTimerState.paused) {
        resume();
        return;
      }

      unawaited(_tryAutoRestartSleepTimerOnPlaybackStart());
    }
  }

  bool _isFadeOutEnabled() {
    return ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.sleepTimerFadeOutEnabled);
  }

  Duration _remainingForCurrentRun() {
    final countdownStartTime = _countdownStartTime;
    final countdownRunDuration = _countdownRunDuration;
    if (countdownStartTime == null || countdownRunDuration == null) {
      return state.remainingTime;
    }

    final elapsed = DateTime.now().difference(countdownStartTime);
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

  Future<void> _restoreFadeVolumeIfNeeded() async {
    final fadeBaseVolume = _fadeBaseVolume;
    if (fadeBaseVolume == null) {
      return;
    }

    _fadeBaseVolume = null;
    await _setPlayerVolumeSafely(fadeBaseVolume, reason: 'sleep timer fade volume restore');
  }

  void _applyFadeOutIfNeeded(Duration remaining) {
    if (!_isFadeOutEnabled() || remaining > _sleepTimerFadeOutDuration) {
      unawaited(_restoreFadeVolumeIfNeeded());
      return;
    }

    _fadeBaseVolume ??= audioHandler.player.volume;
    final fadeBaseVolume = _fadeBaseVolume;
    if (fadeBaseVolume == null || fadeBaseVolume <= 0) {
      return;
    }

    final progress = remaining.inMilliseconds / _sleepTimerFadeOutDuration.inMilliseconds;
    final clampedProgress = progress.clamp(0.0, 1.0);
    final curvedProgress = math.pow(clampedProgress, _sleepTimerFadeCurveExponent).toDouble();
    final targetVolume = (fadeBaseVolume * curvedProgress).clamp(0.0, fadeBaseVolume).toDouble();

    unawaited(_setPlayerVolumeSafely(targetVolume, reason: 'sleep timer fade out'));
  }

  int _normalizeMinutesOfDay(int value) {
    final modulo = value % (24 * 60);
    return modulo < 0 ? modulo + (24 * 60) : modulo;
  }

  bool _isWithinAutoRestartTimeRange() {
    final settingManager = ref.read(settingsManagerProvider.notifier);
    final useTimeRange = settingManager.getGlobalSetting<bool>(SettingKeys.sleepTimerAutoRestartUseTimeRange);
    if (!useTimeRange) {
      return true;
    }

    final startMinutesRaw = settingManager.getGlobalSetting<int>(SettingKeys.sleepTimerAutoRestartRangeStartMinutes);
    final endMinutesRaw = settingManager.getGlobalSetting<int>(SettingKeys.sleepTimerAutoRestartRangeEndMinutes);
    final startMinutes = _normalizeMinutesOfDay(startMinutesRaw);
    final endMinutes = _normalizeMinutesOfDay(endMinutesRaw);

    final now = DateTime.now();
    final nowMinutes = now.hour * 60 + now.minute;

    if (startMinutes == endMinutes) {
      return true;
    }

    if (startMinutes < endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }

    return nowMinutes >= startMinutes || nowMinutes < endMinutes;
  }

  Future<void> _setAutoRestartSuppressed(bool value) async {
    try {
      await ref
          .read(settingsManagerProvider.notifier)
          .setGlobalSetting<bool>(SettingKeys.sleepTimerAutoRestartSuppressed, value);
    } catch (e) {
      logger('Failed to update sleep timer auto-restart suppression: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    }
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

  Future<void> _tryAutoRestartSleepTimerOnPlaybackStart() async {
    if (state.isActive) {
      return;
    }

    final settingManager = ref.read(settingsManagerProvider.notifier);
    final autoRestartEnabled = settingManager.getGlobalSetting<bool>(SettingKeys.sleepTimerAutoRestartEnabled);
    if (!autoRestartEnabled) {
      return;
    }

    final autoRestartSuppressed = settingManager.getGlobalSetting<bool>(SettingKeys.sleepTimerAutoRestartSuppressed);
    if (autoRestartSuppressed) {
      logger('Sleep timer auto-restart is suppressed after manual stop', tag: 'SleepTimer', level: InfoLevel.debug);
      return;
    }

    if (!_isWithinAutoRestartTimeRange()) {
      logger(
        'Sleep timer auto-restart skipped outside configured time range',
        tag: 'SleepTimer',
        level: InfoLevel.debug,
      );
      return;
    }

    final rememberedMinutes = settingManager.getGlobalSetting<int>(SettingKeys.sleepTimerLastDurationMinutes);
    final safeMinutes = rememberedMinutes < 1 ? 30 : rememberedMinutes;

    logger('Auto-restarting sleep timer for $safeMinutes minutes', tag: 'SleepTimer', level: InfoLevel.info);
    start(Duration(minutes: safeMinutes));
  }

  void start(Duration duration) {
    if (duration <= Duration.zero) {
      return;
    }

    if (state.isActive) {
      stop(suppressAutoRestart: false);
    }

    _pauseTriggeredByPlayback = false;

    unawaited(_restoreFadeVolumeIfNeeded());

    unawaited(_setAutoRestartSuppressed(false));
    unawaited(_persistLastDuration(duration));

    logger('Sleep timer started for ${duration.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    state = SleepTimerData(remainingTime: duration, state: SleepTimerState.running, totalDuration: duration);

    _startTimer(duration);
  }

  void stop({bool suppressAutoRestart = true}) {
    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _pauseTriggeredByPlayback = false;

    unawaited(_restoreFadeVolumeIfNeeded());

    if (suppressAutoRestart) {
      unawaited(_setAutoRestartSuppressed(true));
    }

    logger('Sleep timer stopped', tag: 'SleepTimer', level: InfoLevel.info);

    state = const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);
  }

  void pause({bool triggeredByPlaybackPause = false}) {
    if (!state.isRunning) return;

    final remainingTime = _remainingForCurrentRun();

    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _pauseTriggeredByPlayback = triggeredByPlaybackPause;

    unawaited(_restoreFadeVolumeIfNeeded());

    logger('Sleep timer paused', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(remainingTime: remainingTime, state: SleepTimerState.paused);
  }

  void resume() {
    if (state.state != SleepTimerState.paused || state.remainingTime <= Duration.zero) {
      return;
    }

    _pauseTriggeredByPlayback = false;

    unawaited(_setAutoRestartSuppressed(false));

    logger('Sleep timer resumed', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(state: SleepTimerState.running);
    _startTimer(state.remainingTime);
  }

  void extend(Duration additionalTime) {
    if (!state.isActive || additionalTime <= Duration.zero) return;

    final isRunning = state.isRunning;
    final baseRemainingTime = isRunning ? _remainingForCurrentRun() : state.remainingTime;
    final newRemainingTime = baseRemainingTime + additionalTime;
    final newTotalDuration = (state.totalDuration ?? baseRemainingTime) + additionalTime;

    logger('Sleep timer extended by ${additionalTime.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    state = state.copyWith(remainingTime: newRemainingTime, totalDuration: newTotalDuration);

    if (isRunning) {
      _startTimer(newRemainingTime);
      _applyFadeOutIfNeeded(newRemainingTime);
    }

    unawaited(_persistLastDuration(newTotalDuration));
  }

  void reset() {
    if (!state.isActive) return;

    final totalDuration = state.totalDuration ?? state.remainingTime;
    if (totalDuration <= Duration.zero) return;

    logger('Sleep timer reset to ${totalDuration.inMinutes} minutes', tag: 'SleepTimer', level: InfoLevel.info);

    _pauseTriggeredByPlayback = false;
    unawaited(_restoreFadeVolumeIfNeeded());

    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;

    if (state.state == SleepTimerState.paused) {
      state = state.copyWith(remainingTime: totalDuration, totalDuration: totalDuration);
      return;
    }

    state = SleepTimerData(remainingTime: totalDuration, state: SleepTimerState.running, totalDuration: totalDuration);

    _startTimer(totalDuration);
    unawaited(_setAutoRestartSuppressed(false));
    unawaited(_persistLastDuration(totalDuration));
  }

  void _startTimer(Duration duration) {
    _timer?.cancel();
    _countdownStartTime = DateTime.now();
    _countdownRunDuration = duration;

    _timer = Timer.periodic(_sleepTimerTickInterval, (timer) {
      final remaining = _remainingForCurrentRun();

      if (remaining <= Duration.zero) {
        _onTimerExpired();
        timer.cancel();
      } else {
        _applyFadeOutIfNeeded(remaining);

        if ((state.remainingTime - remaining).abs() >= _sleepTimerUiUpdateInterval) {
          state = state.copyWith(remainingTime: remaining);
        }
      }
    });
  }

  void _onTimerExpired() {
    final actionSetting = ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<String>(SettingKeys.sleepTimerExpireAction);
    final action = SleepTimerExpireAction.fromSettingValue(actionSetting);

    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _pauseTriggeredByPlayback = false;

    state = const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);

    unawaited(_executeExpireAction(action));
  }

  Future<void> _executeExpireAction(SleepTimerExpireAction action) async {
    try {
      if (action == SleepTimerExpireAction.pause) {
        logger('Sleep timer expired, pausing playback', tag: 'SleepTimer', level: InfoLevel.info);
        await audioHandler.applySleepTimerAutoRewindNow();
        await audioHandler.pause();
      } else {
        logger('Sleep timer expired, stopping playback', tag: 'SleepTimer', level: InfoLevel.info);
        await audioHandler.applySleepTimerAutoRewindNow();
        await audioHandler.stop();
      }
    } catch (e) {
      logger('Failed to run sleep timer expiry action: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    } finally {
      await _restoreFadeVolumeIfNeeded();
    }
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
