import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/generated/l10n.dart';
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
      title: S.current.screensSettingsPlayerPlayerSettingsGeneralTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingDropdown<String>(
          label: S.current.screensSettingsPlayerPlayerSettingsGeneralTimelineMode,
          description: S.current.screensSettingsPlayerPlayerSettingsGeneralTimelineModeDescription,
          values: PlayerSeekBarMode.values.map((mode) => mode.name).toList(),
          valueLabels: PlayerSeekBarMode.values.map((mode) => mode.label).toList(),
          settingKey: SettingKeys.playerSeekBarMode,
        ),
        SettingDropdown<String>(
          label: S.current.screensSettingsPlayerPlayerSettingsGeneralTimelineMarkers,
          description: S.current.screensSettingsPlayerPlayerSettingsGeneralTimelineMarkersDescription,
          values: SeekBarMarkerMode.values.map((mode) => mode.name).toList(),
          valueLabels: SeekBarMarkerMode.values.map((mode) => mode.label).toList(),
          settingKey: SettingKeys.playerSeekBarMarkerMode,
        ),
        SettingSlider<int>(
          label: S.current.screensSettingsPlayerPlayerSettingsGeneralFastForwardInterval,
          description: S.current.screensSettingsPlayerPlayerSettingsGeneralFastForwardIntervalDescription,
          values: const [5, 10, 15, 20, 30, 45, 60],
          valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
          settingKey: SettingKeys.fastForwardInterval,
        ),
        SettingSlider<int>(
          label: S.current.screensSettingsPlayerPlayerSettingsGeneralRewindInterval,
          description: S.current.screensSettingsPlayerPlayerSettingsGeneralRewindIntervalDescription,
          values: const [5, 10, 15, 20, 30, 45, 60],
          valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
          settingKey: SettingKeys.rewindInterval,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerPlayerSettingsGeneralAutoQueue,
          description: S.current.screensSettingsPlayerPlayerSettingsGeneralAutoQueueDescription,
          settingKey: SettingKeys.autoQueue,
        ),
        SettingSwitch(
          label: S.current.screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViews,
          description:
              S.current.screensSettingsPlayerPlayerSettingsGeneralAutoQueueFirstSeriesOutsideSourceViewsDescription,
          disabledReason: S.current.screensSettingsPlayerPlayerSettingsGeneralEnableAutoQueueDisabledReason,
          settingKey: SettingKeys.autoQueueIncludeSeriesOutsideContext,
          enabled: autoQueueEnabled,
        ),
      ],
    );
  }
}
