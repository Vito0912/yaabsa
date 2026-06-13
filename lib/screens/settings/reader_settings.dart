import 'package:flutter/material.dart';
import 'package:yaabsa/components/settings/settings_dropdown.dart';
import 'package:yaabsa/components/settings/settings_navigation_section.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/components/settings/settings_switch_tile.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/util/setting_key.dart';

class ReaderSettings extends StatelessWidget {
  const ReaderSettings({super.key});

  static const String routeName = '/settings/reader';

  @override
  Widget build(BuildContext context) {
    return SettingsPageScaffold(
      title: 'Reader Settings',
      embedded: true,
      showEmbeddedBackButton: true,
      children: [
        SettingsNavigationSection(
          title: 'Display & Theme',
          topPadding: 0,
          settings: [
            SettingDropdown<String>(
              label: 'Reader Theme',
              description: 'Choose the background and text color theme of the reader',
              values: ['light', 'sepia', 'grey', 'dark'],
              valueLabels: ['Light', 'Sepia', 'Grey', 'Dark'],
              settingKey: SettingKeys.readerTheme,
            ),
            SettingSlider<double>(
              label: 'Font Size',
              description: 'Adjust the size of the reader text',
              values: [0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5],
              valueLabels: ['60%', '80%', '100%', '120%', '140%', '160%', '180%', '200%', '220%', '250%'],
              settingKey: SettingKeys.readerFontSizeMultiplier,
            ),
            SettingSlider<double>(
              label: 'Line Spacing',
              description: 'Adjust the line spacing of the reader text',
              values: [1.0, 1.2, 1.5, 1.8, 2.0, 2.5, 3.0],
              valueLabels: ['1.0', '1.2', '1.5', '1.8', '2.0', '2.5', '3.0'],
              settingKey: SettingKeys.readerLineHeight,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Layout',
          settings: [
            SettingDropdown<String>(
              label: 'Layout Mode',
              description: 'Choose between paginated columns or vertical infinite scroll',
              values: ['paginated_1', 'paginated_2', 'scrolled'],
              valueLabels: ['Single Column', 'Two Columns', 'Infinite Scroll'],
              settingKey: SettingKeys.readerLayout,
            ),
          ],
        ),
        SettingsNavigationSection(
          title: 'Player Integration',
          settings: [
            SettingSwitchTile(
              label: 'Hide mini player when reading',
              subtitle: 'Hides the bottom audio mini player in the book reader',
              settingKey: SettingKeys.readerHideMiniPlayer,
            ),
            SettingSwitchTile(
              label: 'Track reading time as listening',
              subtitle:
                  'This will count the time spent in the reader towards your listening stats. It might confuse other clients',
              settingKey: SettingKeys.readerStartSession,
            ),
          ],
        ),
      ],
    );
  }
}
