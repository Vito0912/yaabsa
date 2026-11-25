import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/screens/reader/widgets/reader_appearance_controls.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/reader_tts_settings.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

class ReaderSettingsSheet extends StatelessWidget {
  const ReaderSettingsSheet({super.key, required this.isEpub});

  final bool isEpub;

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * (context.isMobile ? 0.82 : 0.78),
      child: DefaultTabController(
        length: isEpub ? 3 : 1,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(localizations.headingReadingPreferences, style: Theme.of(context).textTheme.titleLarge),
                  ),
                  IconButton(
                    tooltip: localizations.actionClose,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            if (isEpub)
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(text: localizations.readerAppearance),
                  Tab(text: localizations.headingLayout),
                  Tab(text: localizations.readerReadAloud),
                ],
              ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    children: [
                      const ReaderAppearancePreview(),
                      const ReaderPageColorPicker(),
                      if (isEpub) ...[
                        ReaderChoiceSetting(
                          label: localizations.readerFieldTypeface,
                          values: const ['publisher', 'serif', 'sans'],
                          valueLabels: [
                            localizations.optionBookDefault,
                            localizations.fontSerif,
                            localizations.fontSansSerif,
                          ],
                          settingKey: SettingKeys.readerFontFamily,
                        ),
                        SettingSlider<double>(
                          label: localizations.readerFieldTextSize,
                          values: const [0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5],
                          valueLabels: _formatPercentLabels(context, const [
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
                          ]),
                          settingKey: SettingKeys.readerFontSizeMultiplier,
                        ),
                        SettingSlider<double>(
                          label: localizations.readerFieldLineSpacing,
                          values: const [1.0, 1.2, 1.5, 1.8, 2.0, 2.5, 3.0],
                          valueLabels: _formatDecimalLabels(context, const [1.0, 1.2, 1.5, 1.8, 2.0, 2.5, 3.0]),
                          settingKey: SettingKeys.readerLineHeight,
                        ),
                      ],
                      if (!isEpub) const _ReaderPlayerPreferences(),
                    ],
                  ),
                  if (isEpub)
                    ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      children: [
                        ReaderChoiceSetting(
                          label: localizations.readerFieldPageLayout,
                          values: const ['paginated_1', 'paginated_2', 'scrolled'],
                          valueLabels: [
                            localizations.pageLayoutSingle,
                            localizations.pageLayoutTwoWide,
                            localizations.pageLayoutScroll,
                          ],
                          settingKey: SettingKeys.readerLayout,
                        ),
                        ReaderChoiceSetting(
                          label: localizations.fieldTextAlignment,
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
                        const ReaderPageGeometrySettings(),
                        const _ReaderPlayerPreferences(),
                      ],
                    ),
                  if (isEpub) const ReaderTtsSettings(showTitle: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReaderPlayerPreferences extends StatelessWidget {
  const _ReaderPlayerPreferences();

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Column(
      children: [
        SettingSwitchTile(label: localizations.readerHideMiniPlayer, settingKey: SettingKeys.readerHideMiniPlayer),
        SettingSwitchTile(label: localizations.readerTrackReadingTime, settingKey: SettingKeys.readerStartSession),
      ],
    );
  }
}

List<String> _formatPercentLabels(BuildContext context, List<double> values) {
  final locale = Localizations.localeOf(context).toString();
  final formatter = NumberFormat.percentPattern(locale)..maximumFractionDigits = 0;

  return values.map(formatter.format).toList(growable: false);
}

List<String> _formatDecimalLabels(BuildContext context, List<double> values) {
  final locale = Localizations.localeOf(context).toString();
  final formatter = NumberFormat.decimalPattern(locale)
    ..minimumFractionDigits = 1
    ..maximumFractionDigits = 1;

  return values.map(formatter.format).toList(growable: false);
}
