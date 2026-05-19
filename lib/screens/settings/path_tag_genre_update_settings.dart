import 'package:flutter/material.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/tools_settings.dart';

class PathTagGenreUpdateSettings extends StatelessWidget {
  const PathTagGenreUpdateSettings({super.key});

  static const String routeName = '/settings/tools/path-tag-genre-update';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsPathTagGenreUpdateSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      embeddedBackFallbackRoute: ToolsSettings.routeName,
      children: [],
    );
  }
}
