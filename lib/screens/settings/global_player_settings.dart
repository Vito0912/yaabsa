import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';

class GlobalPlayerSettings extends StatelessWidget {
  const GlobalPlayerSettings({super.key});

  static const String routeName = '/settings/global-player';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Global Player Settings')),
      body: Column(
        children: [
          SettingSlider<int>(
            label: 'Max buffer size',
            tooltip:
                'Maximum size of the buffer in bytes. This is just a hint for the player and may not be respected by the OS. No more than 5 minutes should be cac.',
            icon: Icons.info_outline,
            values: const [512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024],
            valueLabels: const ['512 KB', '1 MB', '2 MB', '5 MB', '10 MB'],
            settingKey: SettingKeys.bufferSize,
          ),
          SettingSwitch(label: 'Lock Media Notification', settingKey: SettingKeys.lockMediaNotification),
        ],
      ),
    );
  }
}
