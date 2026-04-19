import 'dart:io';

import 'package:vibration/vibration.dart';

class DeviceCapabilities {
  DeviceCapabilities._();

  static bool get supportsShakeActions {
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
