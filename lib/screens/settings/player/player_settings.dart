import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/screens/settings/player/player_settings_general.dart';
import 'package:yaabsa/screens/settings/player/player_settings_shake_controls.dart';
import 'package:yaabsa/screens/settings/player/player_settings_sleep_timer.dart';
import 'package:yaabsa/screens/settings/player/player_settings_smart_rewind.dart';
import 'package:yaabsa/screens/settings/player/player_settings_subtitles.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/device_capabilities.dart';

class PlayerSettings extends StatelessWidget {
  const PlayerSettings({super.key});

  static const String routeName = '/settings/player';

  @override
  Widget build(BuildContext context) {
    final supportsShakeActions = DeviceCapabilities.supportsShakeActions;

    return SettingsPageScaffold(
      title: S.current.screensSettingsPlayerPlayerSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: S.current.screensSettingsPlayerPlayerSettingsPlayback,
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.tune_rounded,
              title: S.current.screensSettingsPlayerPlayerSettingsGeneral,
              subtitle: S.current.screensSettingsPlayerPlayerSettingsGeneralSubtitle,
              onTap: () => context.push(PlayerSettingsGeneral.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.replay_rounded,
              title: S.current.screensSettingsPlayerPlayerSettingsSmartRewind,
              subtitle: S.current.screensSettingsPlayerPlayerSettingsSmartRewindSubtitle,
              onTap: () => context.push(PlayerSettingsSmartRewind.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.bedtime_outlined,
              title: S.current.screensSettingsPlayerPlayerSettingsSleepTimer,
              subtitle: S.current.screensSettingsPlayerPlayerSettingsSleepTimerSubtitle,
              onTap: () => context.push(PlayerSettingsSleepTimer.routeName),
            ),
          ],
        ),
        SettingsNavigationSection(
          title: S.current.screensSettingsPlayerPlayerSettingsAccessibilityAndDevice,
          items: [
            SettingsNavigationItem(
              icon: Icons.subtitles_outlined,
              title: S.current.screensSettingsPlayerPlayerSettingsSubtitles,
              subtitle: S.current.screensSettingsPlayerPlayerSettingsSubtitlesSubtitle,
              onTap: () => context.push(PlayerSettingsSubtitles.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.vibration_rounded,
              title: S.current.screensSettingsPlayerPlayerSettingsShakeControls,
              subtitle: supportsShakeActions
                  ? S.current.screensSettingsPlayerPlayerSettingsShakeControlsSupportedSubtitle
                  : S.current.screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedSubtitle,
              disabledReason: supportsShakeActions
                  ? null
                  : S.current.screensSettingsPlayerPlayerSettingsShakeControlsUnsupportedReason,
              enabled: supportsShakeActions,
              onTap: supportsShakeActions ? () => context.push(PlayerSettingsShakeControls.routeName) : null,
            ),
          ],
        ),
      ],
    );
  }
}
