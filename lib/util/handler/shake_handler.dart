import 'dart:async';
import 'dart:math';

import 'package:buchshelfly/database/settings_manager.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';

class ShakeRewindHandler {
  static const int _shakeDelayMs = 5000;
  static const int _resetDelayMs = 3000;
  static const int _minShakeCount = 1;
  static const Duration _samplingInterval = Duration(milliseconds: 100);

  late final double shakeThreshold;

  int _lastShakeTime = 0;
  int _shakeCounter = 0;
  StreamSubscription<AccelerometerEvent>? _accelerometerSub;
  StreamSubscription? _playerStateSub;
  bool _active = false;

  ShakeRewindHandler() {
    shakeThreshold = containerRef
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<double>(SettingKeys.shakeSensitivity);
    initialize();
  }

  void initialize() {
    if (!containerRef.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.shakeToRewind)) {
      logger('Shake rewind is disabled', tag: 'ShakeRewindHandler', level: InfoLevel.info);
      return;
    }
    logger('Initializing ShakeRewindHandler', tag: 'ShakeRewindHandler', level: InfoLevel.info);
    _playerStateSub = audioHandler.player.playerStateStream.listen((state) {
      final shouldBeActive = state.playing && audioHandler.currentMediaItem != null;
      if (shouldBeActive && !_active) {
        _start();
      } else if (!shouldBeActive && _active) {
        _stop();
      }
    });
  }

  void _start() {
    if (!containerRef.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.shakeToRewind)) return;
    if (_active) return;
    _active = true;
    _reset();

    _accelerometerSub = accelerometerEventStream(
      samplingPeriod: _samplingInterval,
    ).listen(_handleEvent, onError: (_) => _stop());
  }

  void _stop() {
    if (!_active) return;
    _active = false;
    _accelerometerSub?.cancel();
    _accelerometerSub = null;
    _reset();
  }

  void _handleEvent(AccelerometerEvent event) async {
    if (!_active) return;

    final gX = event.x / 9.80665;
    final gY = event.y / 9.80665;
    final gZ = event.z / 9.80665;
    final force = sqrt(gX * gX + gY * gY + gZ * gZ);

    if (force > shakeThreshold) {
      final now = DateTime.now().millisecondsSinceEpoch;

      if (_lastShakeTime + _shakeDelayMs > now) return;

      if (_lastShakeTime + _resetDelayMs < now) _shakeCounter = 0;

      _lastShakeTime = now;
      _shakeCounter++;

      if (_shakeCounter >= _minShakeCount) {
        logger('Shake rewind triggered', tag: 'ShakeRewindHandler', level: InfoLevel.info);
        audioHandler.rewind();
        print('SHAKE REWIND TRIGGERED');
        print((await Vibration.hasVibrator() == true));
        print(containerRef.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.shakeVibrate));
        if ((await Vibration.hasVibrator() == true) &&
            containerRef.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.shakeVibrate)) {
          Vibration.vibrate();
        }
        _reset();
      }
    }
  }

  void _reset() {
    _shakeCounter = 0;
    _lastShakeTime = DateTime.now().millisecondsSinceEpoch;
  }

  bool get isActive => _active;

  void dispose() {
    _stop();
    _playerStateSub?.cancel();
  }
}
