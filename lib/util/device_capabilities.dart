import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:vibration/vibration.dart';

class DeviceCapabilities {
  DeviceCapabilities._();

  static bool get supportsShakeActions {
    if (kIsWeb) return false;
    return Platform.isAndroid || Platform.isIOS;
  }

  static Future<bool> supportsVibrationFeedback() async {
    if (!supportsShakeActions) {
      return false;
    }

    try {
      return await Vibration.hasVibrator() == true;
    } catch (_) {
      return false;
    }
  }
}
