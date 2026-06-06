import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
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
        SettingSlider<int>(
          label: 'Max buffer size',
          tooltip:
              'Maximum size of the buffer in bytes. This is just a hint for the player and may not be respected by the OS. No more than 5 minutes should be cac.',
          icon: Icons.info_outline,
          values: const [512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024],
          valueLabels: const ['512 KB', '1 MB', '2 MB', '5 MB', '10 MB'],
          settingKey: SettingKeys.bufferSize,
        ),
        SettingSwitchTile(label: 'Lock Media Notification', settingKey: SettingKeys.lockMediaNotification),
        SettingDropdown<String>(
          label: 'Media notification type',
          values: MediaNotificationType.values.map((m) => m.name).toList(),
          valueLabels: MediaNotificationType.values.map((m) => m.label).toList(),
          settingKey: SettingKeys.mediaNotificationType,
        ),
        SettingSwitchTile(
          label: 'Show notification More button',
          subtitle: 'When enabled, a More button will be shown, giving more quick actions',
          settingKey: SettingKeys.showNotificationMoreButton,
        ),
        SettingSwitchTile(
          label: 'Auto-play last played on app start',
          subtitle: 'When enabled and nothing is currently playing, app launch will resume the last played item if it is not finished.',
          settingKey: SettingKeys.autoPlayLastPlayedOnLaunch,
        ),
        SettingSwitchTile(
          label: 'Always show mini player',
          subtitle: 'Keeps the mini player visible for your most recently played item',
          settingKey: SettingKeys.showLastPlayedMiniPlayerAlways,
        ),
        SettingSwitchTile(
          label: 'Keep websocket active in background',
          subtitle: 'If enabled, the websocket stays connected while the app is in background so updates and tasks can sync when you return. This may increase battery usage. It does not affect playback progress updates when starting playback.',
          settingKey: SettingKeys.keepWebsocketConnectionInBackground,
        ),
        SettingSwitchTile(label: 'Keep Screen On', settingKey: SettingKeys.keepScreenOn),
      ],
    );
  }
}
