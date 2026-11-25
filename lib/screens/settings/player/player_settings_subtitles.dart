import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/settings/player/player_settings.dart';
import 'package:yaabsa/screens/settings/player/widgets/subtitle_settings_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class PlayerSettingsSubtitles extends StatelessWidget {
  const PlayerSettingsSubtitles({super.key});

  static const String routeName = '/settings/player/subtitles';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.playerComponentSubtitles,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: PlayerSettings.routeName,
      children: [SubtitleSettingsSection()],
    );
  }
}
