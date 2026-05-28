import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';

class LocalLogSettingsSection extends StatelessWidget {
  const LocalLogSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SettingDropdown(
          label: 'Log Level',
          values: InfoLevel.values.map((e) => e.toString()).toList(),
          valueLabels: InfoLevel.values.map((e) => e.name).toList(),
          settingKey: SettingKeys.appLogLevel,
        ),
      ],
    );
  }
}
