import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/widgets/shake_settings_section.dart';
import 'package:yaabsa/screens/settings/widgets/subtitle_settings_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettings extends ConsumerWidget {
  const PlayerSettings({super.key});

  static const String routeName = '/settings/player';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoQueueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.autoQueue)).asData?.value;
    final autoQueueDefault = defaultSettings[SettingKeys.autoQueue] as bool? ?? true;
    final autoQueueEnabled = SettingsParser.decodeValue<bool>(autoQueueSetting, autoQueueDefault);

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
        SettingSwitch(
          label: 'Auto queue',
          description:
              'Automatically queue upcoming books when playback starts from library, series, playlist, or collection views.',
          settingKey: SettingKeys.autoQueue,
        ),
        SettingSwitch(
          label: 'Auto queue first series outside source views',
          description:
              'When Auto queue is enabled, also auto queue books from the first linked series even when playback starts outside a series view.',
          disabledReason: 'Enable Auto queue to use this option.',
          settingKey: SettingKeys.autoQueueIncludeSeriesOutsideContext,
          enabled: autoQueueEnabled,
        ),
        const SubtitleSettingsSection(),
        const ShakeSettingsSection(),
      ],
    );
  }
}
