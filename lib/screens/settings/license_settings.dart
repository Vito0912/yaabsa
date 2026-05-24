import 'dart:io';

import 'package:yaabsa/components/settings/social/compatibility_learn_more_dialog.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

class LicenseSettings {
  static Future<void> showLicensePage({required BuildContext context, bool useRootNavigator = false}) async {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final CapturedThemes themes = InheritedTheme.capture(from: context, to: navigator.context);

    navigator.push(
      MaterialPageRoute<void>(builder: (BuildContext pageContext) => themes.wrap(const _InformationAttributionPage())),
    );
  }

  static Future<void> showRawLicensePage({required BuildContext context, bool useRootNavigator = false}) async {
    final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
    final CapturedThemes themes = InheritedTheme.capture(from: context, to: navigator.context);

    final String deviceInfo = await _getDeviceInfo();
    if (!context.mounted) {
      return;
    }

    navigator.push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => themes.wrap(
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

class _InformationAttributionPage extends StatelessWidget {
  const _InformationAttributionPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Information & Attribution')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Compatibilities', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Some advanced app features require server compatibility flags.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        CompatibilityLearnMoreDialog.show(
                          context,
                          content: CompatibilityLearnMoreContent.socialDefaults(),
                        );
                      },
                      icon: const Icon(Icons.info_outline_rounded),
                      label: const Text('Learn more'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Licenses and legal', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'View open-source license texts, app version, and device information.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () => LicenseSettings.showRawLicensePage(context: context),
                      icon: const Icon(Icons.description_outlined),
                      label: const Text('Open license details'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
