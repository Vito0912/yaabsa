import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yaabsa/util/logger.dart';

class AndroidLiveUpdates {
  static const _channel = MethodChannel('de.vito0912.yaabsa/live_updates');
  static Future<bool> get supported => _isSupported();

  static Future<bool> _isSupported() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return false;
    try {
      return await _channel.invokeMethod<bool>('isLiveUpdatesSupported') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  static Future<void> update(Map<String, Object?> snapshot) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('update', snapshot);
    } on PlatformException catch (error) {
      logger('Live Update failed: $error', tag: 'LiveUpdates', level: InfoLevel.warning);
    } on MissingPluginException {
      return;
    }
  }

  static Future<void> clear() => update(const {'mode': 'off'});
}
