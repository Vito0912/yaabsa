import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/components/settings/settings_slider.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/setting_key.dart';

class ReaderAppearancePreview extends ConsumerWidget {
  const ReaderAppearancePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    for (final key in [
      SettingKeys.readerTheme,
      SettingKeys.readerFontFamily,
      SettingKeys.readerFontSizeMultiplier,
      SettingKeys.readerLineHeight,
    ]) {
      ref.watch(globalSettingByKeyProvider(key));
    }

    final settings = ref.read(settingsManagerProvider.notifier);
    final pageTheme = settings.getGlobalSetting<String>(SettingKeys.readerTheme);
    final font = settings.getGlobalSetting<String>(SettingKeys.readerFontFamily);
    final background = switch (pageTheme) {
      'light' => const Color(0xFFFFFEFA),
      'dark' => const Color(0xFF121212),
      'grey' => const Color(0xFF2E2E2E),
      _ => const Color(0xFFF4ECD8),
    };
    final foreground = switch (pageTheme) {
      'light' => Colors.black,
      'dark' || 'grey' => const Color(0xFFE0E0E0),
      _ => const Color(0xFF5B4636),
    };

    final localizations = context.l10n;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Semantics(
        label: localizations.readerAppearancePreviewLabel,
        child: Text(
          localizations.readerAppearancePreviewText,
          style: TextStyle(
            color: foreground,
            fontSize: 16 * settings.getGlobalSetting<double>(SettingKeys.readerFontSizeMultiplier),
            height: settings.getGlobalSetting<double>(SettingKeys.readerLineHeight),
            fontFamily: font == 'sans' ? 'sans-serif' : 'serif',
          ),
        ),
      ),
    );
  }
}

class ReaderPageColorPicker extends ConsumerWidget {
  const ReaderPageColorPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(globalSettingByKeyProvider(SettingKeys.readerTheme));
    final settings = ref.read(settingsManagerProvider.notifier);
    final selected = settings.getGlobalSetting<String>(SettingKeys.readerTheme);
    final localizations = context.l10n;
    final themes = [
      ('light', localizations.readerThemePaper, const Color(0xFFFFFEFA), const Color(0xFF26231D)),
      ('sepia', localizations.readerThemeSepia, const Color(0xFFF4ECD8), const Color(0xFF5B4636)),
      ('grey', localizations.readerThemeGrey, const Color(0xFF2E2E2E), const Color(0xFFE0E0E0)),
      ('dark', localizations.readerThemeNight, const Color(0xFF121212), const Color(0xFFE0E0E0)),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final (value, label, background, foreground) in themes)
            Semantics(
              selected: selected == value,
              label: localizations.readerPageColorOption(label),
              child: Material(
                color: background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selected == value
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    width: selected == value ? 3 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => unawaited(settings.setGlobalSetting<String>(SettingKeys.readerTheme, value)),
                  child: SizedBox(
                    width: 66,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: [
                          Text(
                            'Aa',
                            style: TextStyle(fontFamily: 'serif', fontSize: 24, color: foreground),
                          ),
                          const SizedBox(height: 4),
                          Text(label, style: TextStyle(fontSize: 12, color: foreground)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ReaderChoiceSetting extends ConsumerWidget {
  const ReaderChoiceSetting({
    super.key,
    required this.label,
    required this.values,
    required this.valueLabels,
    required this.settingKey,
  });

  final String label;
  final List<String> values;
  final List<String> valueLabels;
  final String settingKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(globalSettingByKeyProvider(settingKey));
    final settings = ref.read(settingsManagerProvider.notifier);
    final selected = settings.getGlobalSetting<String>(settingKey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var index = 0; index < values.length; index++)
                ChoiceChip(
                  label: Text(valueLabels[index]),
                  selected: selected == values[index],
                  onSelected: (selected) {
                    if (selected) {
                      unawaited(settings.setGlobalSetting<String>(settingKey, values[index]));
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReaderPageGeometrySettings extends StatelessWidget {
  const ReaderPageGeometrySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = context.l10n;

    return Column(
      children: [
        SettingSlider<double>(
          label: localizations.readerFieldPageMargins,
          values: const [16.0, 24.0, 32.0, 48.0, 64.0],
          valueLabels: [
            localizations.sizeNarrow,
            localizations.sizeSmall,
            localizations.sizeMedium,
            localizations.sizeLarge,
            localizations.sizeWide,
          ],
          settingKey: SettingKeys.readerPageMargin,
        ),
        SettingSlider<double>(
          label: localizations.readerFieldReadingWidth,
          values: const [480.0, 600.0, 720.0, 840.0, 960.0],
          valueLabels: [
            localizations.sizeNarrow,
            localizations.sizeCompact,
            localizations.sizeComfortable,
            localizations.sizeWide,
            localizations.sizeFull,
          ],
          settingKey: SettingKeys.readerPageWidth,
        ),
      ],
    );
  }
}
