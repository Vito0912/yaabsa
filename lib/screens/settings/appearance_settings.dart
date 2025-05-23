import 'package:buchshelfly/components/settings/settings_dropdown.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:flutter/material.dart';

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  static const String routeName = '/settings/appearance';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Player Settings')),
      body: Column(
        children: [
          SettingDropdown(
            label: 'Design',
            values: [AppThemeMode.dark.toString(), AppThemeMode.light.toString(), AppThemeMode.system.toString()],
            valueLabels: ['Dark', 'Light', 'System'],
            settingKey: SettingKeys.appThemeMode,
          ),
          SettingDropdown(
            label: 'Language',
            values: ['en-US', 'de-DE'],
            valueLabels: ['English', 'Deutsch'],
            settingKey: SettingKeys.language,
          ),
          SettingDropdown(
            label: 'Log Level',
            values: InfoLevel.values.map((e) => e.toString()).toList(),
            valueLabels: InfoLevel.values.map((e) => e.name).toList(),
            settingKey: SettingKeys.appLogLevel,
          ),
        ],
      ),
    );
  }
}
