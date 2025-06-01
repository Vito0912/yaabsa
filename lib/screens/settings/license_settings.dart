import 'dart:io';

import 'package:yaabsa/util/globals.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class LicenseSettings {
  static Future<void> showLicensePage({required BuildContext context, bool useRootNavigator = false}) async {
    final CapturedThemes themes = InheritedTheme.capture(
      from: context,
      to: Navigator.of(context, rootNavigator: useRootNavigator).context,
    );

    final String deviceInfo = await _getDeviceInfo();

    Navigator.of(context, rootNavigator: useRootNavigator).push(
      MaterialPageRoute<void>(
        builder:
            (BuildContext context) => themes.wrap(
              LicensePage(
                applicationName: packageInfo.appName,
                applicationVersion: packageInfo.version,
                applicationLegalese: _buildLegalese(deviceInfo),
              ),
            ),
      ),
    );
  }

  static Future<String> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return '''
Device Information:
• Device: ${androidInfo.manufacturer} ${androidInfo.model}
• Android Version: ${androidInfo.version.release} (API ${androidInfo.version.sdkInt})
• Brand: ${androidInfo.brand}
• Hardware: ${androidInfo.hardware}
• Device ID: ${androidInfo.id}
''';
      } else if (Platform.isIOS) {
        final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return '''
Device Information:
• Device: ${iosInfo.name}
• Model: ${iosInfo.model}
• iOS Version: ${iosInfo.systemVersion}
• System Name: ${iosInfo.systemName}
• Device ID: ${iosInfo.identifierForVendor}
''';
      } else if (Platform.isLinux) {
        final LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
        return '''
Device Information:
• Platform: Linux
• Distribution: ${linuxInfo.name}
• Version: ${linuxInfo.version}
• ID: ${linuxInfo.id}
• Build ID: ${linuxInfo.buildId}
• Machine Type: ${linuxInfo.machineId}
''';
      } else if (Platform.isWindows) {
        final WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
        return '''
Device Information:
• Platform: Windows
• Computer Name: ${windowsInfo.computerName}
• Product Name: ${windowsInfo.productName}
• Display Version: ${windowsInfo.displayVersion}
• Major Version: ${windowsInfo.majorVersion}
• Minor Version: ${windowsInfo.minorVersion}
• Build Number: ${windowsInfo.buildNumber}
''';
      } else if (Platform.isMacOS) {
        final MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
        return '''
Device Information:
• Platform: macOS
• Computer Name: ${macInfo.computerName}
• Host Name: ${macInfo.hostName}
• Model: ${macInfo.model}
• Kernel Version: ${macInfo.kernelVersion}
• OS Release: ${macInfo.osRelease}
• Major Version: ${macInfo.majorVersion}
• Minor Version: ${macInfo.minorVersion}
• Patch Version: ${macInfo.patchVersion}
''';
      } else {
        return 'Device Information: Platform not supported for device info';
      }
    } catch (e) {
      return 'Device Information: Unable to retrieve device details - $e';
    }
  }

  static String _buildLegalese(String deviceInfo) {
    return '''
$deviceInfo

Legal Information:
This application is provided "as is" without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement.

© ${DateTime.now().year} Vito
See LICENSE file for more details on GitHub.
''';
  }
}
