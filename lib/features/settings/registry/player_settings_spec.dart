import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/android_live_updates_setting.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/player_device_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/player_general_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/player_timer_settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/settings/player/player_settings_notification.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/setting_key.dart';

List<SettingsPageSpec> buildPlayerSettingsPages() {
  return <SettingsPageSpec>[
    _buildPlayerHubPage(),
    buildPlayerGeneralPage(),
    _buildPlayerStartupBackgroundPage(),
    _buildPlayerNotificationsPage(),
    _buildPlayerNotificationActionsPage(),
    buildPlayerSmartRewindPage(),
    buildPlayerSleepTimerPage(),
    buildPlayerSubtitlesPage(),
    buildPlayerEqualizerPage(),
    buildPlayerShakeControlsPage(),
    buildPlayerCompatibilityPage(),
  ];
}

SettingsPageSpec _buildPlayerHubPage() {
  return SettingsPageSpec(
    id: 'player',
    route: SettingsRoutes.player,
    scope: SettingScope.app,
    icon: Icons.play_circle_outline_rounded,
    title: (ctx) => ctx.l10n.settingsCategoryPlayer,
    subtitle: (ctx) => ctx.l10n.settingsPlayerSettings,
    sections: [
      SettingsSectionSpec(
        id: 'player.hub.playback',
        title: (ctx) => ctx.l10n.playbackTitle,
        entries: [
          SettingsNavEntry(
            id: 'player_general_nav',
            title: (ctx) => ctx.l10n.settingsCategoryGeneral,
            description: (ctx) => ctx.l10n.messagePlayerGeneralSettings,
            icon: Icons.tune_rounded,
            targetRoute: SettingsRoutes.playerGeneral,
            targetPageId: 'player.general',
          ),
          SettingsNavEntry(
            id: 'player_startup_background_nav',
            title: (ctx) => ctx.l10n.settingsStartupAndBackgroundTitle,
            description: (ctx) => ctx.l10n.settingsStartupAndBackgroundDescription,
            icon: Icons.memory_rounded,
            targetRoute: SettingsRoutes.playerStartupBackground,
            targetPageId: 'player.startup_background',
          ),
          SettingsNavEntry(
            id: 'player_notifications_nav',
            title: (ctx) => ctx.l10n.settingsCategoryMediaNotifications,
            description: (ctx) => ctx.l10n.settingsMediaNotificationsDescription,
            icon: Icons.notifications_active_outlined,
            targetRoute: SettingsRoutes.playerNotifications,
            targetPageId: 'player.notifications',
          ),
          SettingsNavEntry(
            id: 'player_smart_rewind_nav',
            title: (ctx) => ctx.l10n.settingSmartRewind,
            description: (ctx) => ctx.l10n.messageSmartRewindSettings,
            icon: Icons.replay_rounded,
            targetRoute: SettingsRoutes.playerSmartRewind,
            targetPageId: 'player.smart_rewind',
          ),
          SettingsNavEntry(
            id: 'player_sleep_timer_nav',
            title: (ctx) => ctx.l10n.playbackSleepTimer,
            description: (ctx) => ctx.l10n.messageSleepTimerSettings,
            icon: Icons.bedtime_outlined,
            targetRoute: SettingsRoutes.playerSleepTimer,
            targetPageId: 'player.sleep_timer',
          ),
          SettingsNavEntry(
            id: 'player_equalizer_nav',
            title: (ctx) => ctx.l10n.navEqualizer,
            description: (ctx) => ctx.l10n.messageEqualizerSettings,
            icon: Icons.equalizer_rounded,
            targetRoute: SettingsRoutes.playerEqualizer,
            targetPageId: 'player.equalizer',
            availability: (ctx) {
              if (ctx.isAndroid) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'player.hub.accessibility_device',
        title: (ctx) => ctx.l10n.settingsCategoryAccessibilityDevice,
        entries: [
          SettingsNavEntry(
            id: 'player_subtitles_nav',
            title: (ctx) => ctx.l10n.playerComponentSubtitles,
            description: (ctx) => ctx.l10n.messageSubtitleSettings,
            icon: Icons.subtitles_outlined,
            targetRoute: SettingsRoutes.playerSubtitles,
            targetPageId: 'player.subtitles',
            scopeOverride: SettingScope.account,
            availability: (ctx) {
              if (ctx.isSignedIn) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
          SettingsNavEntry(
            id: 'player_shake_controls_nav',
            title: (ctx) => ctx.l10n.settingsCategoryShakeControls,
            description: (ctx) {
              if (ctx.supportsShakeActions) {
                return ctx.l10n.messageShakeControlsSettings;
              }

              return ctx.l10n.statusMotionSensorsRequired;
            },
            icon: Icons.vibration_rounded,
            targetRoute: SettingsRoutes.playerShakeControls,
            targetPageId: 'player.shake_controls',
            availability: (ctx) {
              if (ctx.supportsShakeActions) {
                return const SettingsAvailability.available();
              }

              return SettingsAvailability.disabled(ctx.l10n.statusShakeControlsUnavailable);
            },
          ),
          SettingsNavEntry(
            id: 'player_compatibility_nav',
            title: (ctx) => ctx.l10n.settingsCategoryCompatibility,
            description: (ctx) => ctx.l10n.settingsCompatibilityDescription,
            icon: Icons.build_outlined,
            targetRoute: SettingsRoutes.playerCompatibility,
            targetPageId: 'player.compatibility',
            availability: (ctx) {
              if (ctx.isLinux || ctx.isAndroid) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildPlayerStartupBackgroundPage() {
  const bufferValues = <int>[512 * 1024, 1024 * 1024, 2 * 1024 * 1024, 5 * 1024 * 1024, 10 * 1024 * 1024];

  return SettingsPageSpec(
    id: 'player.startup_background',
    parentId: 'player',
    route: SettingsRoutes.playerStartupBackground,
    scope: SettingScope.app,
    icon: Icons.memory_rounded,
    title: (ctx) => ctx.l10n.settingsStartupAndBackgroundTitle,
    subtitle: (ctx) => ctx.l10n.settingsStartupAndBackgroundDescription,
    sections: [
      SettingsSectionSpec(
        id: 'player.startup_background.buffer_screen',
        title: (ctx) => ctx.l10n.settingsCategoryBufferAndScreen,
        entries: [
          SettingsSliderEntry<int>(
            id: 'buffer_size',
            title: (ctx) => ctx.l10n.settingMaxBufferSize,
            description: (ctx) => ctx.l10n.settingMaxBufferSizeDescription,
            keywords: (l10n) => <String>['buffer', 'streaming', 'memory'],
            definition: AppSettingDefs.bufferSize,
            values: bufferValues,
            labelForValue: (ctx, bytes) => formatBytes(bytes, localizations: ctx.l10n),
            availability: (ctx) {
              if (!ctx.isWeb && ctx.isWindows) {
                return const SettingsAvailability.hidden();
              }

              return const SettingsAvailability.available();
            },
          ),
          SettingsToggleEntry(
            id: 'keep_screen_on',
            title: (ctx) => ctx.l10n.settingKeepScreenOn,
            description: (ctx) => ctx.l10n.settingKeepScreenOnDescription,
            keywords: (l10n) => <String>['screen', 'awake', 'display'],
            definition: AppSettingDefs.keepScreenOn,
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'player.startup_background.launch',
        title: (ctx) => ctx.l10n.settingsCategoryStartupAndBackground,
        entries: [
          SettingsToggleEntry(
            id: 'auto_play_last_played',
            title: (ctx) => ctx.l10n.settingAutoPlayLastPlayedOnAppStart,
            description: (ctx) => ctx.l10n.settingAutoPlayLastPlayedOnAppStartDescription,
            keywords: (l10n) => <String>['autoplay', 'startup', 'launch', 'resume'],
            definition: AppSettingDefs.autoPlayLastPlayedOnLaunch,
          ),
          SettingsToggleEntry(
            id: 'always_show_mini_player',
            title: (ctx) => ctx.l10n.settingAlwaysShowMiniPlayer,
            description: (ctx) => ctx.l10n.settingAlwaysShowMiniPlayerDescription,
            keywords: (l10n) => <String>['mini player', 'startup', 'last played'],
            definition: AppSettingDefs.showLastPlayedMiniPlayerAlways,
          ),
          SettingsToggleEntry(
            id: 'keep_websocket_in_background',
            title: (ctx) => ctx.l10n.settingKeepWebSocketActiveInBackground,
            description: (ctx) => ctx.l10n.settingKeepWebSocketActiveInBackgroundDescription,
            keywords: (l10n) => <String>['websocket', 'socket', 'background', 'sync'],
            definition: AppSettingDefs.keepWebsocketConnectionInBackground,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildPlayerNotificationsPage() {
  return SettingsPageSpec(
    id: 'player.notifications',
    parentId: 'player',
    route: SettingsRoutes.playerNotifications,
    scope: SettingScope.app,
    icon: Icons.notifications_active_outlined,
    title: (ctx) => ctx.l10n.settingsCategoryMediaNotifications,
    subtitle: (ctx) => ctx.l10n.settingsMediaNotificationsDescription,
    sections: [
      SettingsSectionSpec(
        id: 'player.notifications.main',
        title: (ctx) => ctx.l10n.settingsCategoryMediaNotifications,
        entries: [
          SettingsToggleEntry(
            id: 'lock_media_notification',
            title: (ctx) => ctx.l10n.settingLockMediaNotification,
            description: (ctx) => ctx.l10n.settingLockMediaNotificationDescription,
            keywords: (l10n) => <String>['notification', 'lock', 'media controls'],
            definition: AppSettingDefs.lockMediaNotification,
          ),
          SettingsChoiceEntry<String>(
            id: 'media_notification_type',
            title: (ctx) => ctx.l10n.settingMediaNotificationType,
            description: (ctx) => ctx.l10n.settingMediaNotificationTypeDescription,
            keywords: (l10n) => <String>['notification', 'progress', 'chapter', 'media controls'],
            definition: AppSettingDefs.mediaNotificationType,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(
                value: MediaNotificationType.full.name,
                label: MediaNotificationType.full.label,
                description: ctx.l10n.optionFullAudiobookProgressDescription,
              ),
              SettingsChoiceOption(
                value: MediaNotificationType.chapter.name,
                label: MediaNotificationType.chapter.label,
                description: ctx.l10n.optionCurrentChapterProgressDescription,
              ),
            ],
          ),
          SettingsCustomEntry(
            id: 'android_live_updates',
            title: (ctx) => ctx.l10n.settingLiveUpdates,
            description: (ctx) => ctx.l10n.settingLiveUpdatesDescription,
            keywords: (l10n) => <String>['live updates', 'notification', 'android'],
            availability: (ctx) {
              if (ctx.isAndroid) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
            builder: (context, ref, ctx) => const AndroidLiveUpdatesSetting(),
          ),
          SettingsNavEntry(
            id: 'media_notification_actions_nav',
            title: (ctx) => ctx.l10n.settingMediaNotificationActions,
            description: (ctx) => ctx.l10n.settingMediaNotificationActionsDescription,
            icon: Icons.dashboard_customize_rounded,
            targetRoute: SettingsRoutes.playerNotificationActions,
            targetPageId: 'player.notifications.actions',
            availability: (ctx) {
              if (ctx.isAndroid) {
                return const SettingsAvailability.available();
              }

              return const SettingsAvailability.hidden();
            },
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildPlayerNotificationActionsPage() {
  return SettingsPageSpec(
    id: 'player.notifications.actions',
    parentId: 'player.notifications',
    route: SettingsRoutes.playerNotificationActions,
    scope: SettingScope.app,
    icon: Icons.dashboard_customize_rounded,
    title: (ctx) => ctx.l10n.settingMediaNotificationActions,
    subtitle: (ctx) => ctx.l10n.settingMediaNotificationActionsDescription,
    availability: (ctx) {
      if (ctx.isAndroid) {
        return const SettingsAvailability.available();
      }

      return const SettingsAvailability.hidden();
    },
    customPageBuilder: (context, {focusEntryId}) => const PlayerSettingsNotification(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'media_notification_actions_meta',
        title: (ctx) => ctx.l10n.settingMediaNotificationActions,
        description: (ctx) => ctx.l10n.settingMediaNotificationActionsDescription,
        keywords: (l10n) => <String>['notification', 'actions', 'buttons', 'media controls'],
      ),
    ],
  );
}
