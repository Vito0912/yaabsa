import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettingsGeneral extends ConsumerWidget {
  const PlayerSettingsGeneral({super.key});

  static const String routeName = '/settings/player/general';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoQueueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.autoQueue)).asData?.value;
    final autoQueueDefault = defaultSettings[SettingKeys.autoQueue] as bool? ?? true;
    final autoQueueEnabled = SettingsParser.decodeValue<bool>(autoQueueSetting, autoQueueDefault);

    return SettingsPageScaffold(
      title: 'Player - General',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingDropdown<String>(
          label: 'Timeline mode',
          description: 'Choose whether the seek bar tracks a chapter, the full audiobook, or both.',
          values: PlayerSeekBarMode.values.map((mode) => mode.name).toList(),
          valueLabels: PlayerSeekBarMode.values.map((mode) => mode.label).toList(),
          settingKey: SettingKeys.playerSeekBarMode,
        ),
        SettingDropdown<String>(
          label: 'Timeline markers',
          description: 'Choose whether the full timeline displays chapter markers, bookmark markers, both, or none.',
          values: SeekBarMarkerMode.values.map((mode) => mode.name).toList(),
          valueLabels: SeekBarMarkerMode.values.map((mode) => mode.label).toList(),
          settingKey: SettingKeys.playerSeekBarMarkerMode,
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
          label: 'Remember playback speed per book',
          description:
              'When enabled, each book remembers its own playback speed. First-time books start with your last used speed.',
          settingKey: SettingKeys.playbackSpeedPerBook,
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
      ],
    );
  }
}
