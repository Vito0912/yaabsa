import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:yaabsa/api/library_items/device_info.dart';
import 'package:yaabsa/database/settings_manager.dart' show settingsManagerProvider;
import 'package:yaabsa/util/globals.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerUtils {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static const String _playbackWakelockReason = 'playback';
  static const String _uploadWakelockReason = 'upload';
  static final Set<String> _wakelockReasons = <String>{};

  static void _enableWakelockReason(String reason) {
    final wasEmpty = _wakelockReasons.isEmpty;
    if (!_wakelockReasons.add(reason)) {
      return;
    }

    if (wasEmpty) {
      WakelockPlus.enable();
      logger('Wakelock enabled ($reason)', tag: 'PlayerUtils', level: InfoLevel.debug);
    }
  }

  static void _disableWakelockReason(String reason) {
    if (!_wakelockReasons.remove(reason)) {
      return;
    }

    if (_wakelockReasons.isEmpty) {
      WakelockPlus.disable();
      logger('Wakelock disabled ($reason)', tag: 'PlayerUtils', level: InfoLevel.debug);
    }
  }

  static void enableWakelock(ProviderContainer ref) {
    final keepScreenOn = ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.keepScreenOn);
    if (keepScreenOn == true) {
      _enableWakelockReason(_playbackWakelockReason);
    }
  }

  static void disableWakelock(ProviderContainer ref) {
    _disableWakelockReason(_playbackWakelockReason);
  }

  static void enableUploadWakelock() {
    _enableWakelockReason(_uploadWakelockReason);
  }

  static void disableUploadWakelock() {
    _disableWakelockReason(_uploadWakelockReason);
  }

  static Future<DeviceInfo> getDeviceInfo() async {
    String? deviceId;
    String? manufacturer;
    String? model;

    if (kIsWeb) {
      final WebBrowserInfo webInfo = await _deviceInfoPlugin.webBrowserInfo;
      deviceId = webInfo.userAgent;
      manufacturer = webInfo.browserName.name;
      model = webInfo.platform;
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
      manufacturer = androidInfo.manufacturer;
      model = androidInfo.model;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor;
      manufacturer = 'Apple';
      model = iosInfo.utsname.machine;
    } else if (Platform.isMacOS) {
      final MacOsDeviceInfo macosInfo = await _deviceInfoPlugin.macOsInfo;
      deviceId = macosInfo.systemGUID;
      manufacturer = 'Apple';
      model = macosInfo.model;
    } else if (Platform.isWindows) {
      final WindowsDeviceInfo windowsInfo = await _deviceInfoPlugin.windowsInfo;
      deviceId = windowsInfo.productId;
      manufacturer = 'Windows';
      model = windowsInfo.productName;
    } else if (Platform.isLinux) {
      final LinuxDeviceInfo linuxInfo = await _deviceInfoPlugin.linuxInfo;
      deviceId = linuxInfo.machineId;
      manufacturer = 'Linux';
      model = linuxInfo.name;
    } else {
      throw UnsupportedError('Unsupported platform: ${Platform.operatingSystem}');
    }

    return DeviceInfo(
      deviceId: deviceId,
      clientName: appName,
      clientVersion: packageInfo.version,
      manufacturer: manufacturer,
      model: model,
    );
  }

  // TODO: Add actual mime type detection
  static Future<List<String>> getSupportedMimeTypes() async {
    return [
      'audio/aac',
      'audio/mpeg',
      'audio/ogg',
      'audio/opus',
      'audio/wav',
      'audio/webm',
      'audio/mp4',
      'audio/x-aiff',
      'audio/x-mpegurl',
      "audio/x-matroska",
    ];
  }
}
