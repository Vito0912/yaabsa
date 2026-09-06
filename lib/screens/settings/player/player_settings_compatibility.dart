import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class PlayerSettingsCompatibility extends StatelessWidget {
  const PlayerSettingsCompatibility({super.key});

  static const String routeName = '/settings/player/compatibility';
  static bool get isSupported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.linux || defaultTargetPlatform == TargetPlatform.windows);

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Player - Compatibility',
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: 'Audio Decoding',
          topPadding: 0,
          settings: [
            if (isSupported)
              SettingSwitchTile(
                label: 'Disable FDK AAC decoder',
                subtitle:
                    'Enable if AAC playback crashes with your installed codecs. '
                    'Uses other available decoders or server transcoding. '
                    'Applies to system and bundled codecs. Restart the app to apply.',
                settingKey: SettingKeys.disableFdkAacDecoder,
              ),
          ],
        ),
      ],
    );
  }
}
