import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_category.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/generated/l10n.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/theme_settings.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter/material.dart';

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  static const String routeName = '/settings/appearance';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: S.current.screensSettingsAppearanceSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: S.current.screensSettingsAppearanceSettingsDisplay,
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.palette_outlined,
              title: S.current.screensSettingsAppearanceSettingsTheme,
              subtitle: S.current.screensSettingsAppearanceSettingsThemeSubtitle,
              onTap: () => context.push(ThemeSettings.routeName),
            ),
          ],
        ),
        SettingsCategory(
          title: S.current.screensSettingsAppearanceSettingsGeneral,
          description: S.current.screensSettingsAppearanceSettingsGeneralDescription,
          icon: Icons.tune_rounded,
        ),
        SettingDropdown(
          label: S.current.screensSettingsAppearanceSettingsLanguage,
          values: ['en-US', 'de-DE'],
          valueLabels: [
            S.current.screensSettingsAppearanceSettingsEnglish,
            S.current.screensSettingsAppearanceSettingsGerman,
          ],
          settingKey: SettingKeys.language,
        ),
        SettingDropdown(
          label: S.current.screensSettingsAppearanceSettingsLogLevel,
          values: InfoLevel.values.map((e) => e.toString()).toList(),
          valueLabels: InfoLevel.values.map((e) => e.name).toList(),
          settingKey: SettingKeys.appLogLevel,
        ),
      ],
    );
  }
}
