import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/theme_appearance_section.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  static const String routeName = '/settings/appearance/theme';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsThemeSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: const [ThemeAppearanceSection()],
    );
  }
}
