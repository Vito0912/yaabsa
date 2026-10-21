import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/screens/reader/widgets/reader_appearance_controls.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/reader_tts_settings.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/setting_key.dart';

class ReaderSettingsSheet extends StatelessWidget {
  const ReaderSettingsSheet({super.key, required this.isEpub});

  final bool isEpub;

  @override
  Widget build(BuildContext context) {
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
                  Expanded(child: Text('Reading preferences', style: Theme.of(context).textTheme.titleLarge)),
                  IconButton(
                    tooltip: 'Close preferences',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            if (isEpub)
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(text: 'Appearance'),
                  Tab(text: 'Layout'),
                  Tab(text: 'Read aloud'),
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
                          label: 'Typeface',
                          values: const ['publisher', 'serif', 'sans'],
                          valueLabels: const ['Book default', 'Serif', 'Sans serif'],
                          settingKey: SettingKeys.readerFontFamily,
                        ),
                        SettingSlider<double>(
                          label: 'Text size',
                          values: const [0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5],
                          valueLabels: const [
                            '60%',
                            '80%',
                            '100%',
                            '120%',
                            '140%',
                            '160%',
                            '180%',
                            '200%',
                            '220%',
                            '250%',
                          ],
                          settingKey: SettingKeys.readerFontSizeMultiplier,
                        ),
                        SettingSlider<double>(
                          label: 'Line spacing',
                          values: const [1.0, 1.2, 1.5, 1.8, 2.0, 2.5, 3.0],
                          valueLabels: const ['1.0', '1.2', '1.5', '1.8', '2.0', '2.5', '3.0'],
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
                          label: 'Page layout',
                          values: const ['paginated_1', 'paginated_2', 'scrolled'],
                          valueLabels: const ['Single page', 'Two pages on wide screens', 'Scroll'],
                          settingKey: SettingKeys.readerLayout,
                        ),
                        ReaderChoiceSetting(
                          label: 'Text alignment',
                          values: const ['publisher', 'start', 'justify'],
                          valueLabels: const ['Book default', 'Start aligned', 'Justified'],
                          settingKey: SettingKeys.readerTextAlignment,
                        ),
                        SettingSlider<double>(
                          label: 'Letter spacing',
                          values: const [0.0, 0.02, 0.04, 0.08, 0.12],
                          valueLabels: const ['Book default', 'Slight', 'Medium', 'Wide', 'Extra wide'],
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
    return const Column(
      children: [
        SettingSwitchTile(label: 'Hide mini player when reading', settingKey: SettingKeys.readerHideMiniPlayer),
        SettingSwitchTile(label: 'Track reading time as listening', settingKey: SettingKeys.readerStartSession),
      ],
    );
  }
}
