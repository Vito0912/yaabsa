import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      title: 'Player Settings',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: 'Playback',
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.tune_rounded,
              title: 'General',
              subtitle: 'Timeline mode, seek intervals, and auto queue behavior.',
              onTap: () => context.push(PlayerSettingsGeneral.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.replay_rounded,
              title: 'Smart rewind',
              subtitle: 'Control how much playback rewinds after pauses.',
              onTap: () => context.push(PlayerSettingsSmartRewind.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.bedtime_outlined,
              title: 'Sleep timer',
              subtitle: 'Choose timer end behavior and optional automatic restart.',
              onTap: () => context.push(PlayerSettingsSleepTimer.routeName),
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Accessibility & Device',
          items: [
            SettingsNavigationItem(
              icon: Icons.subtitles_outlined,
              title: 'Subtitles',
              subtitle: 'Enable subtitles and reading support behavior.',
              onTap: () => context.push(PlayerSettingsSubtitles.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.vibration_rounded,
              title: 'Shake controls',
              subtitle: supportsShakeActions
                  ? 'Configure shake gestures and sensitivity.'
                  : 'Available on devices with motion sensors.',
              disabledReason: supportsShakeActions ? null : 'This device does not support shake controls.',
              enabled: supportsShakeActions,
              onTap: supportsShakeActions ? () => context.push(PlayerSettingsShakeControls.routeName) : null,
            ),
          ],
        ),
      ],
    );
  }
}
