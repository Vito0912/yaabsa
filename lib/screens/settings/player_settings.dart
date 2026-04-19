import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/screens/settings/widgets/shake_settings_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({super.key});

  static const String routeName = '/settings/player';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Player Settings',
      children: [
        SettingDropdown<String>(
          label: 'Timeline mode',
          description: 'Choose whether the seek bar tracks a chapter, the full audiobook, or both.',
          values: PlayerSeekBarMode.values.map((mode) => mode.name).toList(),
          valueLabels: PlayerSeekBarMode.values.map((mode) => mode.label).toList(),
          settingKey: SettingKeys.playerSeekBarMode,
        ),
        SettingSlider<int>(
          label: 'Fast forward interval',
          description: 'How many seconds to skip when jumping forward.',
          values: const [5, 10, 15, 20, 30, 45, 60],
          valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
          settingKey: SettingKeys.fastForwardInterval,
        ),
        SettingSlider<int>(
          label: 'Rewind interval',
          description: 'How many seconds to skip when rewinding.',
          values: const [5, 10, 15, 20, 30, 45, 60],
          valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
          settingKey: SettingKeys.rewindInterval,
        ),
        const ShakeSettingsSection(),
      ],
    );
  }
}
