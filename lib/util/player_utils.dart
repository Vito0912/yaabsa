import 'dart:io';

import 'package:buchshelfly/api/library_items/device_info.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PlayerUtils {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<DeviceInfo> getDeviceInfo() async {
    String? deviceId;
    String? manufacturer;
    String? model;

    if (Platform.isAndroid) {
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
      throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}',
      );
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
    ];
  }
}
