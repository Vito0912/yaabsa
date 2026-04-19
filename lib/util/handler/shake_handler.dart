import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/util/device_capabilities.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/sleep_timer_handler.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

class ShakeRewindHandler {
  static const int _shakeDelayMs = 5000;
  static const int _resetDelayMs = 3000;
  static const int _minShakeCount = 1;
  static const Duration _samplingInterval = Duration(milliseconds: 100);

  double _shakeThreshold = 2.0;
  bool _hasVibrator = false;

  int _lastShakeTime = 0;
  int _shakeCounter = 0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  StreamSubscription? _playerStateSub;
  ProviderSubscription<SleepTimerData>? _sleepTimerSub;
  ProviderSubscription<AsyncValue<String?>>? _shakeToResetSleepTimerSub;
  ProviderSubscription<AsyncValue<String?>>? _shakeToRewindSub;
  ProviderSubscription<AsyncValue<String?>>? _shakeSensitivitySub;

  bool _active = false;
  bool _initialized = false;
  bool _disposed = false;

  ShakeRewindHandler() {
    unawaited(initialize());
  }

  Future<void> initialize() async {
    if (_initialized || _disposed) {
      return;
    }

    _initialized = true;
    _updateShakeThreshold();
    _hasVibrator = await DeviceCapabilities.supportsVibrationFeedback();

    logger('Initializing ShakeRewindHandler', tag: 'ShakeRewindHandler', level: InfoLevel.info);

    _playerStateSub = audioHandler.player.playerStateStream.listen((_) => _syncListenerState());
    _sleepTimerSub = containerRef.listen<SleepTimerData>(
      sleepTimerHandlerProvider,
      (previous, next) => _syncListenerState(),
      fireImmediately: true,
    );

    _shakeToResetSleepTimerSub = _watchSetting(SettingKeys.shakeToResetSleepTimer, _syncListenerState);
    _shakeToRewindSub = _watchSetting(SettingKeys.shakeToRewind, _syncListenerState);
    _shakeSensitivitySub = _watchSetting(SettingKeys.shakeSensitivity, _updateShakeThreshold);

    _syncListenerState();
  }

  void _start() {
    if (_active || _disposed) return;

    _active = true;
    _reset();

    _accelerometerSub = accelerometerEventStream(samplingPeriod: _samplingInterval).listen(
      _handleEvent,
      onError: (Object error, StackTrace stackTrace) {
        logger('Accelerometer listener failed: $error', tag: 'ShakeRewindHandler', level: InfoLevel.warning);
        _stop();
      },
    );
  }

  void _stop() {
    if (!_active) return;

    _active = false;
    _accelerometerSub?.cancel();
    _accelerometerSub = null;
    _reset();
  }

  void _syncListenerState() {
    if (_disposed || !_initialized) return;

    final shouldBeActive = _shouldListen;

    if (shouldBeActive && !_active) {
      _start();
      return;
    }

    if (!shouldBeActive && _active) {
      _stop();
    }
  }

  void _handleEvent(AccelerometerEvent event) async {
    if (!_active || _disposed) return;

    if (!_shouldListen) {
      _stop();
      return;
    }

    final gX = event.x / 9.80665;
    final gY = event.y / 9.80665;
    final gZ = event.z / 9.80665;
    final forceSquared = gX * gX + gY * gY + gZ * gZ;
    final thresholdSquared = _shakeThreshold * _shakeThreshold;

    if (forceSquared <= thresholdSquared) {
      return;
    }

    final now = DateTime.now().millisecondsSinceEpoch;

    if (_lastShakeTime + _shakeDelayMs > now) return;

    if (_lastShakeTime + _resetDelayMs < now) {
      _shakeCounter = 0;
    }

    _lastShakeTime = now;
    _shakeCounter++;

    if (_shakeCounter >= _minShakeCount) {
      await _triggerActionByPriority();
      _reset();
    }
  }

  Future<void> _triggerActionByPriority() async {
    if (_canResetSleepTimer) {
      logger('Shake sleep timer reset triggered', tag: 'ShakeRewindHandler', level: InfoLevel.info);
      containerRef.read(sleepTimerHandlerProvider.notifier).reset();
      await _vibrateIfEnabled();
      return;
    }

    if (_canRewind) {
      logger('Shake rewind triggered', tag: 'ShakeRewindHandler', level: InfoLevel.info);
      await audioHandler.rewind();
      await _vibrateIfEnabled();
    }
  }

  Future<void> _vibrateIfEnabled() async {
    if (!_hasVibrator || !_boolSetting(SettingKeys.shakeVibrate)) {
      return;
    }

    try {
      await Vibration.vibrate();
    } catch (error) {
      logger('Failed to trigger vibration: $error', tag: 'ShakeRewindHandler', level: InfoLevel.warning);
    }
  }

  ProviderSubscription<AsyncValue<String?>> _watchSetting(String key, void Function() onChange) {
    return containerRef.listen<AsyncValue<String?>>(
      globalSettingByKeyProvider(key),
      (previous, next) => onChange(),
      fireImmediately: false,
    );
  }

  void _updateShakeThreshold() {
    final configuredThreshold = _doubleSetting(SettingKeys.shakeSensitivity);
    _shakeThreshold = configuredThreshold < 1.0 ? 1.0 : configuredThreshold;
  }

  bool _boolSetting(String key) {
    return containerRef.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(key);
  }

  double _doubleSetting(String key) {
    return containerRef.read(settingsManagerProvider.notifier).getGlobalSetting<double>(key);
  }

  bool get _canResetSleepTimer {
    return _boolSetting(SettingKeys.shakeToResetSleepTimer) && containerRef.read(sleepTimerHandlerProvider).isActive;
  }

  bool get _canRewind {
    return _boolSetting(SettingKeys.shakeToRewind) &&
        audioHandler.currentMediaItem != null &&
        audioHandler.player.playing;
  }

  bool get _shouldListen {
    return DeviceCapabilities.supportsShakeActions && (_canResetSleepTimer || _canRewind);
  }

  void _reset() {
    _shakeCounter = 0;
    _lastShakeTime = DateTime.now().millisecondsSinceEpoch;
  }

  bool get isActive => _active;

  void dispose() {
    _disposed = true;
    _stop();
    _playerStateSub?.cancel();
    _playerStateSub = null;

    _sleepTimerSub?.close();
    _sleepTimerSub = null;

    _shakeToResetSleepTimerSub?.close();
    _shakeToResetSleepTimerSub = null;

    _shakeToRewindSub?.close();
    _shakeToRewindSub = null;

    _shakeSensitivitySub?.close();
    _shakeSensitivitySub = null;
  }
}
