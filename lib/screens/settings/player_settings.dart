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
    final smartRewindSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.smartRewindEnabled)).asData?.value;
    final smartRewindDefault = defaultSettings[SettingKeys.smartRewindEnabled] as bool? ?? false;
    final smartRewindEnabled = SettingsParser.decodeValue<bool>(smartRewindSetting, smartRewindDefault);

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
          label: 'Smart rewind',
          description:
              'When playback is resumed after a pause, rewind by an amount based on how long playback was paused.',
          settingKey: SettingKeys.smartRewindEnabled,
        ),
        SettingSlider<int>(
          label: 'Smart rewind short-pause threshold',
          description: 'If paused up to this amount, the short smart rewind value is used.',
          disabledReason: 'Enable Smart rewind to configure this option.',
          values: const [15, 30, 45, 60, 90, 120, 180, 300],
          valueLabels: const ['15 s', '30 s', '45 s', '1 min', '1.5 min', '2 min', '3 min', '5 min'],
          settingKey: SettingKeys.smartRewindShortPauseThresholdSeconds,
          enabled: smartRewindEnabled,
        ),
        SettingSlider<int>(
          label: 'Smart rewind long-pause threshold',
          description:
              'If paused longer than the short threshold and up to this amount, the medium smart rewind value is used. Longer pauses use the long smart rewind value.',
          disabledReason: 'Enable Smart rewind to configure this option.',
          values: const [300, 600, 900, 1200, 1800, 2700, 3600],
          valueLabels: const ['5 min', '10 min', '15 min', '20 min', '30 min', '45 min', '60 min'],
          settingKey: SettingKeys.smartRewindLongPauseThresholdSeconds,
          enabled: smartRewindEnabled,
        ),
        SettingSlider<int>(
          label: 'Smart rewind short amount',
          description: 'Rewind amount used for short pauses.',
          disabledReason: 'Enable Smart rewind to configure this option.',
          values: const [3, 5, 10, 15, 20, 30],
          valueLabels: const ['3 s', '5 s', '10 s', '15 s', '20 s', '30 s'],
          settingKey: SettingKeys.smartRewindShortRewindSeconds,
          enabled: smartRewindEnabled,
        ),
        SettingSlider<int>(
          label: 'Smart rewind medium amount',
          description: 'Rewind amount used for medium pauses.',
          disabledReason: 'Enable Smart rewind to configure this option.',
          values: const [10, 15, 20, 30, 45, 60],
          valueLabels: const ['10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
          settingKey: SettingKeys.smartRewindMediumRewindSeconds,
          enabled: smartRewindEnabled,
        ),
        SettingSlider<int>(
          label: 'Smart rewind long amount',
          description: 'Rewind amount used for long pauses.',
          disabledReason: 'Enable Smart rewind to configure this option.',
          values: const [20, 30, 45, 60, 90, 120],
          valueLabels: const ['20 s', '30 s', '45 s', '60 s', '90 s', '120 s'],
          settingKey: SettingKeys.smartRewindLongRewindSeconds,
          enabled: smartRewindEnabled,
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
