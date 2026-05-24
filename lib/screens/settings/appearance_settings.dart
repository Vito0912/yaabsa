import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_category.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/theme_settings.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  static const String routeName = '/settings/appearance';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Appearance Settings',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: 'Display',
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.palette_outlined,
              title: 'Theme',
              subtitle: 'Theme mode, preset palette, and custom accent color.',
              onTap: () => context.push(ThemeSettings.routeName),
            ),
          ],
        ),
        const SettingsCategory(title: 'General', description: 'Language preferences.', icon: Icons.tune_rounded),
        SettingDropdown(
          label: 'Language',
          values: ['en-US', 'de-DE'],
          valueLabels: ['English', 'Deutsch'],
          settingKey: SettingKeys.language,
        ),
      ],
    );
  }
}
