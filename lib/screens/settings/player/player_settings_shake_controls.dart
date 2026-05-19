import 'package:flutter/material.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/player/widgets/shake_settings_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/device_capabilities.dart';

class PlayerSettingsShakeControls extends StatelessWidget {
  const PlayerSettingsShakeControls({super.key});

  static const String routeName = '/settings/player/shake-controls';

  @override
  Widget build(BuildContext context) {
    final supportsShakeActions = DeviceCapabilities.supportsShakeActions;

    return SettingsPageScaffold(
      title: S.current.screensSettingsPlayerPlayerSettingsShakeControlsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        if (!supportsShakeActions)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              S.current.screensSettingsPlayerPlayerSettingsShakeControlsUnavailableOnThisDevice,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        const ShakeSettingsSection(),
      ],
    );
  }
}
