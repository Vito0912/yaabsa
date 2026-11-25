import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/tools_settings.dart';
import 'package:yaabsa/util/l10n.dart';

class PathTagGenreUpdateSettings extends StatelessWidget {
  const PathTagGenreUpdateSettings({super.key});

  static const String routeName = '/settings/tools/path-tag-genre-update';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.headingPathTagGenreUpdate,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: ToolsSettings.routeName,
      children: [],
    );
  }
}
