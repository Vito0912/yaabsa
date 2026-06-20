import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
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
    final isAndroid = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

    return SettingsPageScaffold(
      title: 'Player - General',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: 'Timeline',
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: 'Timeline mode',
              description: 'Choose whether the seek bar tracks a chapter, the full audiobook, or both',
              values: PlayerSeekBarMode.values.map((mode) => mode.name).toList(),
              valueLabels: PlayerSeekBarMode.values.map((mode) => mode.label).toList(),
              valueDescriptions: const [
                'Track currently playing chapter',
                'Track full audiobook timeline',
                'Track chapter and full audiobook timeline',
              ],
              settingKey: SettingKeys.playerSeekBarMode,
            ),
            SettingDropdown<String>(
              label: 'Timeline markers',
              description: 'Choose whether the full timeline displays chapter markers, bookmark markers, both, or none',
              values: SeekBarMarkerMode.values.map((mode) => mode.name).toList(),
              valueLabels: SeekBarMarkerMode.values.map((mode) => mode.label).toList(),
              valueDescriptions: const [
                'Display chapter tick marks',
                'Display bookmark markers',
                'Display chapters and bookmarks',
                'Hide all timeline markers',
              ],
              settingKey: SettingKeys.playerSeekBarMarkerMode,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Skip Intervals',
          settings: [
            SettingSlider<int>(
              label: 'Fast forward interval',
              description: 'How many seconds to skip when jumping forward',
              values: const [5, 10, 15, 20, 30, 45, 60],
              valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
              settingKey: SettingKeys.fastForwardInterval,
            ),
            SettingSlider<int>(
              label: 'Rewind interval',
              description: 'How many seconds to skip when rewinding',
              values: const [5, 10, 15, 20, 30, 45, 60],
              valueLabels: const ['5 s', '10 s', '15 s', '20 s', '30 s', '45 s', '60 s'],
              settingKey: SettingKeys.rewindInterval,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Playback Behavior',
          settings: [
            const SettingSwitchTile(
              label: 'Remember playback speed per book',
              subtitle: 'Each book remembers its own speed and new books start with your last used speed',
              settingKey: SettingKeys.playbackSpeedPerBook,
            ),
            if (isAndroid)
              const SettingSwitchTile(
                label: 'Skip silence',
                subtitle: 'Automatically skip silent gaps during playback',
                settingKey: SettingKeys.skipSilence,
              ),
            const SettingSwitchTile(
              label: 'Auto queue',
              subtitle:
                  'Automatically queue upcoming books when playback starts from library, series, playlist, or collection views',
              settingKey: SettingKeys.autoQueue,
            ),
            SettingSwitchTile(
              label: 'Auto queue everywhere',
              subtitle:
                  'Auto queue books from the first linked series even when starting playback outside a series view, including via car, Bluetooth, or voice',
              disabledReason: 'Enable Auto queue to use this option',
              settingKey: SettingKeys.autoQueueIncludeSeriesOutsideContext,
              enabled: autoQueueEnabled,
            ),
            SettingDropdown<String>(
              label: 'Show Loop & Shuffle controls',
              values: const ['off', 'music_only', 'on'],
              valueLabels: const ['Off', 'Music Only', 'On'],
              valueDescriptions: const [
                'Never show loop and shuffle controls',
                'Only show loop and shuffle for music libraries',
                'Always show loop and shuffle controls',
              ],
              settingKey: SettingKeys.showPlayerLoopShuffle,
            ),
          ],
        ),
      ],
    );
  }
}
