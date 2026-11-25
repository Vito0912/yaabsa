import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:yaabsa/screens/settings/player/player_settings_general.dart';
import 'package:yaabsa/screens/settings/player/player_settings_compatibility.dart';
import 'package:yaabsa/screens/settings/player/player_settings_equalizer.dart';
import 'package:yaabsa/screens/settings/player/player_settings_shake_controls.dart';
import 'package:yaabsa/screens/settings/player/player_settings_sleep_timer.dart';
import 'package:yaabsa/screens/settings/player/player_settings_smart_rewind.dart';
import 'package:yaabsa/screens/settings/player/player_settings_subtitles.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/device_capabilities.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({super.key});

  static const String routeName = '/settings/player';

  @override
  Widget build(BuildContext context) {
    final supportsShakeActions = DeviceCapabilities.supportsShakeActions;

    return SettingsPageScaffold(
      title: context.l10n.settingsPlayerSettings,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: context.l10n.playbackTitle,
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.tune_rounded,
              title: context.l10n.settingsCategoryGeneral,
              subtitle: context.l10n.messagePlayerGeneralSettings,
              onTap: () => context.push(PlayerSettingsGeneral.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.replay_rounded,
              title: context.l10n.settingSmartRewind,
              subtitle: context.l10n.messageSmartRewindSettings,
              onTap: () => context.push(PlayerSettingsSmartRewind.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.bedtime_outlined,
              title: context.l10n.playbackSleepTimer,
              subtitle: context.l10n.messageSleepTimerSettings,
              onTap: () => context.push(PlayerSettingsSleepTimer.routeName),
            ),
            if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
              SettingsNavigationItem(
                icon: Icons.equalizer_rounded,
                title: context.l10n.navEqualizer,
                subtitle: context.l10n.messageEqualizerSettings,
                onTap: () => context.push(PlayerSettingsEqualizer.routeName),
              ),
          ],
        ),
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryAccessibilityDevice,
          items: [
            SettingsNavigationItem(
              icon: Icons.subtitles_outlined,
              title: context.l10n.playerComponentSubtitles,
              subtitle: context.l10n.messageSubtitleSettings,
              onTap: () => context.push(PlayerSettingsSubtitles.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.vibration_rounded,
              title: context.l10n.settingsCategoryShakeControls,
              subtitle: supportsShakeActions
                  ? context.l10n.messageShakeControlsSettings
                  : context.l10n.statusMotionSensorsRequired,
              disabledReason: supportsShakeActions ? null : context.l10n.statusShakeControlsUnavailable,
              enabled: supportsShakeActions,
              onTap: supportsShakeActions ? () => context.push(PlayerSettingsShakeControls.routeName) : null,
            ),
            if (PlayerSettingsCompatibility.isSupported)
              SettingsNavigationItem(
                icon: Icons.build_outlined,
                title: context.l10n.settingsCategoryCompatibility,
                onTap: () => context.push(PlayerSettingsCompatibility.routeName),
              ),
          ],
        ),
      ],
    );
  }
}
