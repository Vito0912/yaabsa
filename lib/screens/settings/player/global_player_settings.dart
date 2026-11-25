import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/android_live_updates_setting.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/player/player_settings_notification.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/l10n.dart';

class GlobalPlayerSettings extends StatelessWidget {
  const GlobalPlayerSettings({super.key});

  static const String routeName = '/settings/global-player';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.settingsCategoryGlobalPlayer,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryBufferAndScreen,
          topPadding: 0,
          settings: [
            if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows)
              SettingSlider<int>(
                label: context.l10n.settingMaxBufferSize,
                description: context.l10n.settingMaxBufferSizeDescription,
                values: [512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024],
                valueLabels: [
                  formatBytes(512 * 1024, localizations: context.l10n),
                  formatBytes(1024 * 1024, localizations: context.l10n),
                  formatBytes(2 * 1024 * 1024, localizations: context.l10n),
                  formatBytes(5 * 1024 * 1024, localizations: context.l10n),
                  formatBytes(10 * 1024 * 1024, localizations: context.l10n),
                ],
                settingKey: SettingKeys.bufferSize,
              ),
            SettingSwitchTile(
              label: context.l10n.settingKeepScreenOn,
              subtitle: context.l10n.settingKeepScreenOnDescription,
              settingKey: SettingKeys.keepScreenOn,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryMediaNotifications,
          settings: [
            SettingSwitchTile(
              label: context.l10n.settingLockMediaNotification,
              subtitle: context.l10n.settingLockMediaNotificationDescription,
              settingKey: SettingKeys.lockMediaNotification,
            ),
            SettingDropdown<String>(
              label: context.l10n.settingMediaNotificationType,
              description: context.l10n.settingMediaNotificationTypeDescription,
              values: MediaNotificationType.values.map((m) => m.name).toList(),
              valueLabels: MediaNotificationType.values.map((m) => m.label).toList(),
              valueDescriptions: [
                context.l10n.optionFullAudiobookProgressDescription,
                context.l10n.optionCurrentChapterProgressDescription,
              ],
              settingKey: SettingKeys.mediaNotificationType,
            ),
            const AndroidLiveUpdatesSetting(),
          ],
          items: [
            if (defaultTargetPlatform == TargetPlatform.android)
              SettingsNavigationItem(
                icon: Icons.dashboard_customize_rounded,
                title: context.l10n.settingMediaNotificationActions,
                subtitle: context.l10n.settingMediaNotificationActionsDescription,
                onTap: () => context.push(PlayerSettingsNotification.routeName),
              ),
          ],
        ),
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryStartupAndBackground,
          settings: [
            SettingSwitchTile(
              label: context.l10n.settingAutoPlayLastPlayedOnAppStart,
              subtitle: context.l10n.settingAutoPlayLastPlayedOnAppStartDescription,
              settingKey: SettingKeys.autoPlayLastPlayedOnLaunch,
            ),
            SettingSwitchTile(
              label: context.l10n.settingAlwaysShowMiniPlayer,
              subtitle: context.l10n.settingAlwaysShowMiniPlayerDescription,
              settingKey: SettingKeys.showLastPlayedMiniPlayerAlways,
            ),
            SettingSwitchTile(
              label: context.l10n.settingKeepWebSocketActiveInBackground,
              subtitle: context.l10n.settingKeepWebSocketActiveInBackgroundDescription,
              settingKey: SettingKeys.keepWebsocketConnectionInBackground,
            ),
          ],
        ),
      ],
    );
  }
}
