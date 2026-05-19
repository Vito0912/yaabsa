import 'package:flutter/material.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/player/widgets/subtitle_settings_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class PlayerSettingsSubtitles extends StatelessWidget {
  const PlayerSettingsSubtitles({super.key});

  static const String routeName = '/settings/player/subtitles';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsPlayerPlayerSettingsSubtitlesTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: const [SubtitleSettingsSection()],
    );
  }
}
