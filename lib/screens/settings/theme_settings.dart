import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/theme_appearance_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/l10n.dart';

class ThemeSettings extends StatelessWidget {
  const ThemeSettings({super.key});

  static const String routeName = '/settings/appearance/theme';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.themeSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [ThemeAppearanceSection()],
    );
  }
}
