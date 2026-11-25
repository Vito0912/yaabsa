import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerSettingsCompatibility extends StatelessWidget {
  const PlayerSettingsCompatibility({super.key});

  static const String routeName = '/settings/player/compatibility';
  static bool get _supportsFdkAacDecoder => !kIsWeb && defaultTargetPlatform == TargetPlatform.linux;
  static bool get _supportsIndexSeeking => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isSupported => _supportsFdkAacDecoder || _supportsIndexSeeking;

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.settingsCategoryCompatibility,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [
        SettingsNavigationSection(
          title: context.l10n.settingsCategoryAudioDecoding,
          topPadding: 0,
          settings: [
            if (_supportsFdkAacDecoder)
              SettingSwitchTile(
                label: context.l10n.settingDisableFdkAacDecoder,
                subtitle: context.l10n.settingDisableFdkAacDecoderDescription,
                settingKey: SettingKeys.disableFdkAacDecoder,
              ),
            if (_supportsIndexSeeking)
              SettingSwitchTile(
                label: context.l10n.settingEnableMp3IndexSeeking,
                subtitle: context.l10n.settingEnableMp3IndexSeekingDescription,
                settingKey: SettingKeys.enableIndexSeeking,
              ),
          ],
        ),
      ],
    );
  }
}
