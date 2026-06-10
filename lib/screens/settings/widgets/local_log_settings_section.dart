import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

class LocalLogSettingsSection extends StatelessWidget {
  const LocalLogSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsNavigationSection(
      title: 'Logging Settings',
      topPadding: 0,
      settings: [
        SettingDropdown<String>(
          label: 'Log Level',
          description: 'Choose the minimum severity level of logs to capture',
          values: InfoLevel.values.map((e) => e.toString()).toList(),
          valueLabels: InfoLevel.values.map((e) => e.name).toList(),
          valueDescriptions: const [
            'Detailed troubleshooting logs',
            'Informational events about operations',
            'Warnings for potentially problematic events',
            'Critical errors and failures',
          ],
          settingKey: SettingKeys.appLogLevel,
        ),
      ],
    );
  }
}
