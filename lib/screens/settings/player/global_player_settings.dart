import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/player/player_settings_notification.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class GlobalPlayerSettings extends StatelessWidget {
  const GlobalPlayerSettings({super.key});

  static const String routeName = '/settings/global-player';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Global Player Settings',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: 'Buffer & Screen',
          topPadding: 0,
          settings: [
            const SettingSlider<int>(
              label: 'Max buffer size',
              description: 'Maximum size of the audio buffer in bytes (hint for the OS)',
              values: [512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024],
              valueLabels: ['512 KB', '1 MB', '2 MB', '5 MB', '10 MB'],
              settingKey: SettingKeys.bufferSize,
            ),
            const SettingSwitchTile(
              label: 'Keep Screen On',
              subtitle: 'Prevent screen from turning off during playback',
              settingKey: SettingKeys.keepScreenOn,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Media Notification',
          settings: [
            const SettingSwitchTile(
              label: 'Lock Media Notification',
              subtitle: 'Keep media controls visible in system notification panel',
              settingKey: SettingKeys.lockMediaNotification,
            ),
            SettingDropdown<String>(
              label: 'Media notification type',
              description: 'Choose whether notification progress tracks the full book or current chapter',
              values: MediaNotificationType.values.map((m) => m.name).toList(),
              valueLabels: MediaNotificationType.values.map((m) => m.label).toList(),
              valueDescriptions: const [
                'Show full audiobook progress and details',
                'Show currently playing chapter progress and details',
              ],
              settingKey: SettingKeys.mediaNotificationType,
            ),
          ],
          items: [
            SettingsNavigationItem(
              icon: Icons.dashboard_customize_rounded,
              title: 'Media Notification Actions',
              subtitle: 'Customize the actions available in the media notification',
              onTap: () => context.push(PlayerSettingsNotification.routeName),
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Startup & Background',
          settings: [
            const SettingSwitchTile(
              label: 'Auto-play last played on app start',
              subtitle: 'Resume the last played item on app launch if it is not finished',
              settingKey: SettingKeys.autoPlayLastPlayedOnLaunch,
            ),
            const SettingSwitchTile(
              label: 'Always show mini player',
              subtitle: 'Keep the mini player visible for your most recently played item',
              settingKey: SettingKeys.showLastPlayedMiniPlayerAlways,
            ),
            const SettingSwitchTile(
              label: 'Keep websocket active in background',
              subtitle: 'Keep websocket connected in the background to sync updates (may increase battery usage)',
              settingKey: SettingKeys.keepWebsocketConnectionInBackground,
            ),
          ],
        ),
      ],
    );
  }
}
