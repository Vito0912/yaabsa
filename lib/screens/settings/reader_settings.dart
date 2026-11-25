import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/reader_tts_settings.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/screens/reader/widgets/reader_appearance_controls.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/util/l10n.dart';

class ReaderSettings extends StatelessWidget {
  const ReaderSettings({super.key});

  static const String routeName = '/settings/reader';

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final percentFormatter = NumberFormat.percentPattern(locale)..maximumFractionDigits = 0;
    final decimalFormatter = NumberFormat.decimalPattern(locale)
      ..minimumFractionDigits = 1
      ..maximumFractionDigits = 1;

    return SettingsPageScaffold(
      title: localizations.readerSettingsTitle,
      embedded: true,
      showEmbeddedBackButton: Navigator.of(context).canPop(),
      children: [
        SettingsNavigationSection(
          title: localizations.settingsDisplayTitle,
          topPadding: 0,
          settings: [
            const ReaderAppearancePreview(),
            const ReaderPageColorPicker(),
            SettingDropdown<String>(
              label: localizations.readerFieldTypeface,
              description: localizations.readerChooseFontDescription,
              values: const ['publisher', 'serif', 'sans'],
              valueLabels: [localizations.optionBookDefault, localizations.fontSerif, localizations.fontSansSerif],
              settingKey: SettingKeys.readerFontFamily,
            ),
            SettingSlider<double>(
              label: localizations.readerFieldTextSize,
              description: localizations.readerAdjustTextSizeDescription,
              values: const [0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5],
              valueLabels: const [
                0.6,
                0.8,
                1.0,
                1.2,
                1.4,
                1.6,
                1.8,
                2.0,
                2.2,
                2.5,
              ].map(percentFormatter.format).toList(growable: false),
              settingKey: SettingKeys.readerFontSizeMultiplier,
            ),
            SettingSlider<double>(
              label: localizations.readerFieldLineSpacing,
              description: localizations.readerAdjustLineSpacingDescription,
              values: const [1.0, 1.2, 1.5, 1.8, 2.0, 2.5, 3.0],
              valueLabels: const [
                1.0,
                1.2,
                1.5,
                1.8,
                2.0,
                2.5,
                3.0,
              ].map(decimalFormatter.format).toList(growable: false),
              settingKey: SettingKeys.readerLineHeight,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: localizations.headingLayout,
          settings: [
            const ReaderPageGeometrySettings(),
            SettingDropdown<String>(
              label: localizations.fieldTextAlignment,
              description: localizations.readerChooseTextAlignmentDescription,
              values: const ['publisher', 'start', 'justify'],
              valueLabels: [
                localizations.optionBookDefault,
                localizations.textAlignmentStart,
                localizations.textAlignmentJustified,
              ],
              settingKey: SettingKeys.readerTextAlignment,
            ),
            SettingSlider<double>(
              label: localizations.readerFieldLetterSpacing,
              description: localizations.readerAdjustLetterSpacingDescription,
              values: const [0.0, 0.02, 0.04, 0.08, 0.12],
              valueLabels: [
                localizations.optionBookDefault,
                localizations.spacingSlight,
                localizations.sizeMedium,
                localizations.sizeWide,
                localizations.sizeExtraWide,
              ],
              settingKey: SettingKeys.readerLetterSpacing,
            ),
            SettingDropdown<String>(
              label: localizations.readerFieldPageLayout,
              description: localizations.readerChoosePageLayoutDescription,
              values: const ['paginated_1', 'paginated_2', 'scrolled'],
              valueLabels: [
                localizations.pageLayoutSingle,
                localizations.pageLayoutTwoWide,
                localizations.pageLayoutScroll,
              ],
              settingKey: SettingKeys.readerLayout,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: localizations.readerReadAloud,
          items: [
            SettingsNavigationItem(
              icon: Icons.record_voice_over_outlined,
              title: localizations.readerReadAloud,
              onTap: () {
                final isNested = Navigator.of(context) != Navigator.of(context, rootNavigator: true);

                if (isNested) {
                  Navigator.of(context).pushNamed(ReaderTtsSettings.routeName);
                } else {
                  context.push(ReaderTtsSettings.routeName);
                }
              },
            ),
          ],
        ),
        SettingsNavigationSection(
          title: localizations.readerPlayerIntegration,
          settings: [
            SettingSwitchTile(
              label: localizations.readerHideMiniPlayer,
              subtitle: localizations.readerHideMiniPlayerDescription,
              settingKey: SettingKeys.readerHideMiniPlayer,
            ),
            SettingSwitchTile(
              label: localizations.readerTrackReadingTime,
              subtitle: localizations.readerTrackReadingTimeDescription,
              settingKey: SettingKeys.readerStartSession,
            ),
          ],
        ),
      ],
    );
  }
}
