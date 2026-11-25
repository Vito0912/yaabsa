import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/screens/settings/library_views_settings.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/theme_settings.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:material_ui/material_ui.dart';

class AppearanceSettings extends StatelessWidget {
  const AppearanceSettings({super.key});

  static const String routeName = '/settings/appearance';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: context.l10n.settingsAppearanceTitle,
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: context.l10n.settingsDisplayTitle,
          topPadding: 0,
          items: [
            SettingsNavigationItem(
              icon: Icons.palette_outlined,
              title: context.l10n.themeSettingsTitle,
              subtitle: context.l10n.themeSettingsSubtitle,
              onTap: () => context.push(ThemeSettings.routeName),
            ),
            SettingsNavigationItem(
              icon: Icons.tune_rounded,
              title: context.l10n.navigationSettingsTitle,
              subtitle: context.l10n.navigationSettingsSubtitle,
              onTap: () => context.push(LibraryViewsSettings.routeName),
            ),
          ],
        ),
        SettingsNavigationSection(
          title: context.l10n.settingsOtherTitle,
          settings: [
            SettingDropdown(
              label: context.l10n.fieldLanguage,
              values: ['system', ...AppLocalizations.supportedLocales.map((locale) => locale.toLanguageTag())],
              valueLabels: [
                context.l10n.optionSystemDefault,
                ...AppLocalizations.supportedLocales.map((locale) => _languageEndonym(context, locale)),
              ],
              settingKey: SettingKeys.language,
            ),
          ],
        ),
      ],
    );
  }

  String _languageEndonym(BuildContext context, Locale locale) {
    return switch (locale.languageCode) {
      'en' => context.l10n.localeEnglishName,
      'de' => context.l10n.localeGermanName,
      _ => locale.toLanguageTag(),
    };
  }
}
