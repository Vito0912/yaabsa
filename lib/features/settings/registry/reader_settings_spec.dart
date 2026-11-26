import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/features/settings/model/setting_definition.dart';
import 'package:yaabsa/features/settings/model/setting_definitions.dart';
import 'package:yaabsa/features/settings/model/settings_availability.dart';
import 'package:yaabsa/features/settings/model/settings_spec.dart';
import 'package:yaabsa/features/settings/registry/settings_routes.dart';
import 'package:yaabsa/screens/reader/widgets/reader_appearance_controls.dart';
import 'package:yaabsa/screens/settings/reader_tts_settings.dart';

List<SettingsPageSpec> buildReaderSettingsPages() {
  return <SettingsPageSpec>[_buildReaderPage(), _buildReaderTtsPage()];
}

SettingsPageSpec _buildReaderPage() {
  return SettingsPageSpec(
    id: 'reader',
    route: SettingsRoutes.reader,
    scope: SettingScope.app,
    icon: Icons.menu_book_outlined,
    title: (ctx) => ctx.l10n.readerSettingsTitle,
    subtitle: (ctx) => ctx.l10n.settingsReaderDescription,
    availability: (ctx) {
      if (ctx.isAaos) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    sections: [
      SettingsSectionSpec(
        id: 'reader.display',
        title: (ctx) => ctx.l10n.settingsDisplayTitle,
        entries: [
          SettingsCustomEntry(
            id: 'reader_appearance_preview',
            title: (ctx) => ctx.l10n.readerAppearancePreviewLabel,
            searchable: false,
            builder: (context, ref, ctx) => const ReaderAppearancePreview(),
          ),
          SettingsCustomEntry(
            id: 'reader_theme',
            title: (ctx) => ctx.l10n.settingReaderTheme,
            description: (ctx) => ctx.l10n.settingReaderThemeDescription,
            keywords: (l10n) => <String>[l10n.readerColors, 'reader', 'theme', 'dark', 'sepia', 'ebook'],
            builder: (context, ref, ctx) => const ReaderPageColorPicker(),
          ),
          SettingsChoiceEntry<String>(
            id: 'reader_font_family',
            title: (ctx) => ctx.l10n.readerFieldTypeface,
            description: (ctx) => ctx.l10n.readerChooseFontDescription,
            keywords: (l10n) => <String>['font', 'typeface', 'serif', 'sans', 'ebook'],
            definition: AppSettingDefs.readerFontFamily,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'publisher', label: ctx.l10n.optionBookDefault),
              SettingsChoiceOption(value: 'serif', label: ctx.l10n.fontSerif),
              SettingsChoiceOption(value: 'sans', label: ctx.l10n.fontSansSerif),
            ],
          ),
          SettingsSliderEntry<double>(
            id: 'reader_font_size',
            title: (ctx) => ctx.l10n.readerFieldTextSize,
            description: (ctx) => ctx.l10n.settingReaderFontSizeDescription,
            keywords: (l10n) => <String>['font size', 'text size', 'zoom', 'ebook'],
            definition: AppSettingDefs.readerFontSizeMultiplier,
            values: const <double>[0.6, 0.8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.5],
            labelForValue: (ctx, value) {
              final formatter = NumberFormat.percentPattern(ctx.l10n.localeName)..maximumFractionDigits = 0;
              return formatter.format(value);
            },
          ),
          SettingsSliderEntry<double>(
            id: 'reader_line_height',
            title: (ctx) => ctx.l10n.readerFieldLineSpacing,
            description: (ctx) => ctx.l10n.settingReaderLineSpacingDescription,
            keywords: (l10n) => <String>['line height', 'spacing', 'ebook'],
            definition: AppSettingDefs.readerLineHeight,
            values: const <double>[1.0, 1.2, 1.5, 1.8, 2.0, 2.5, 3.0],
            labelForValue: (ctx, value) {
              final formatter = NumberFormat.decimalPattern(ctx.l10n.localeName)
                ..minimumFractionDigits = 1
                ..maximumFractionDigits = 1;
              return formatter.format(value);
            },
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'reader.layout',
        title: (ctx) => ctx.l10n.headingLayout,
        entries: [
          SettingsSliderEntry<double>(
            id: 'reader_page_margin',
            title: (ctx) => ctx.l10n.readerFieldPageMargins,
            definition: AppSettingDefs.readerPageMargin,
            values: const <double>[16.0, 24.0, 32.0, 48.0, 64.0],
            labelForValue: (ctx, value) {
              return switch (value) {
                16.0 => ctx.l10n.sizeNarrow,
                24.0 => ctx.l10n.sizeSmall,
                32.0 => ctx.l10n.sizeMedium,
                48.0 => ctx.l10n.sizeLarge,
                _ => ctx.l10n.sizeWide,
              };
            },
          ),
          SettingsSliderEntry<double>(
            id: 'reader_page_width',
            title: (ctx) => ctx.l10n.readerFieldReadingWidth,
            definition: AppSettingDefs.readerPageWidth,
            values: const <double>[480.0, 600.0, 720.0, 840.0, 960.0],
            labelForValue: (ctx, value) {
              return switch (value) {
                480.0 => ctx.l10n.sizeNarrow,
                600.0 => ctx.l10n.sizeCompact,
                720.0 => ctx.l10n.sizeComfortable,
                840.0 => ctx.l10n.sizeWide,
                _ => ctx.l10n.sizeFull,
              };
            },
          ),
          SettingsChoiceEntry<String>(
            id: 'reader_text_alignment',
            title: (ctx) => ctx.l10n.fieldTextAlignment,
            description: (ctx) => ctx.l10n.readerChooseTextAlignmentDescription,
            definition: AppSettingDefs.readerTextAlignment,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'publisher', label: ctx.l10n.optionBookDefault),
              SettingsChoiceOption(value: 'start', label: ctx.l10n.textAlignmentStart),
              SettingsChoiceOption(value: 'justify', label: ctx.l10n.textAlignmentJustified),
            ],
          ),
          SettingsSliderEntry<double>(
            id: 'reader_letter_spacing',
            title: (ctx) => ctx.l10n.readerFieldLetterSpacing,
            description: (ctx) => ctx.l10n.readerAdjustLetterSpacingDescription,
            definition: AppSettingDefs.readerLetterSpacing,
            values: const <double>[0.0, 0.02, 0.04, 0.08, 0.12],
            labelForValue: (ctx, value) {
              return switch (value) {
                0.0 => ctx.l10n.optionBookDefault,
                0.02 => ctx.l10n.spacingSlight,
                0.04 => ctx.l10n.sizeMedium,
                0.08 => ctx.l10n.sizeWide,
                _ => ctx.l10n.sizeExtraWide,
              };
            },
          ),
          SettingsChoiceEntry<String>(
            id: 'reader_layout',
            title: (ctx) => ctx.l10n.readerFieldPageLayout,
            description: (ctx) => ctx.l10n.settingReaderLayoutModeDescription,
            keywords: (l10n) => <String>['layout', 'scroll', 'paginated', 'ebook'],
            definition: AppSettingDefs.readerLayout,
            optionsBuilder: (ctx) => <SettingsChoiceOption<String>>[
              SettingsChoiceOption(value: 'paginated_1', label: ctx.l10n.pageLayoutSingle),
              SettingsChoiceOption(value: 'paginated_2', label: ctx.l10n.pageLayoutTwoWide),
              SettingsChoiceOption(value: 'scrolled', label: ctx.l10n.pageLayoutScroll),
            ],
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'reader.tts',
        title: (ctx) => ctx.l10n.readerReadAloud,
        entries: [
          SettingsNavEntry(
            id: 'reader_tts_nav',
            title: (ctx) => ctx.l10n.readerReadAloud,
            description: (ctx) => ctx.l10n.readerSpeechProviderDescription,
            icon: Icons.record_voice_over_outlined,
            targetRoute: SettingsRoutes.readerTts,
            targetPageId: 'reader.tts',
          ),
        ],
      ),
      SettingsSectionSpec(
        id: 'reader.player_integration',
        title: (ctx) => ctx.l10n.readerPlayerIntegration,
        entries: [
          SettingsToggleEntry(
            id: 'reader_hide_mini_player',
            title: (ctx) => ctx.l10n.readerHideMiniPlayer,
            description: (ctx) => ctx.l10n.readerHideMiniPlayerDescription,
            keywords: (l10n) => <String>['mini player', 'reader'],
            definition: AppSettingDefs.readerHideMiniPlayer,
          ),
          SettingsToggleEntry(
            id: 'reader_start_session',
            title: (ctx) => ctx.l10n.settingStartSessionWhenReading,
            description: (ctx) => ctx.l10n.settingStartSessionWhenReadingDescription,
            keywords: (l10n) => <String>['session', 'reading', 'progress'],
            definition: AppSettingDefs.readerStartSession,
          ),
        ],
      ),
    ],
  );
}

SettingsPageSpec _buildReaderTtsPage() {
  return SettingsPageSpec(
    id: 'reader.tts',
    parentId: 'reader',
    route: SettingsRoutes.readerTts,
    scope: SettingScope.app,
    icon: Icons.record_voice_over_outlined,
    title: (ctx) => ctx.l10n.readerReadAloud,
    subtitle: (ctx) => ctx.l10n.readerSpeechProviderDescription,
    availability: (ctx) {
      if (ctx.isAaos) {
        return const SettingsAvailability.hidden();
      }

      return const SettingsAvailability.available();
    },
    customPageBuilder: (context, {focusEntryId}) => const ReaderTtsSettings(),
    searchableMetadata: [
      SettingsSearchMetadata(
        id: 'reader_speech_provider_meta',
        title: (ctx) => ctx.l10n.readerSpeechProvider,
        description: (ctx) => ctx.l10n.readerSpeechProviderDescription,
        keywords: (l10n) => <String>[
          l10n.readerReadAloud,
          l10n.fieldVoice,
          'tts',
          'voice',
          'read aloud',
          'speech',
          'elevenlabs',
        ],
      ),
      SettingsSearchMetadata(
        id: 'reader_speech_rate_meta',
        title: (ctx) => ctx.l10n.readerSpeechRate,
        description: (ctx) => ctx.l10n.readerSpeechRateDescription,
        keywords: (l10n) => <String>[l10n.readerReadAloud, l10n.playbackSpeed, 'tts', 'speed', 'voice'],
      ),
      SettingsSearchMetadata(
        id: 'reader_speech_voice_meta',
        title: (ctx) => ctx.l10n.fieldVoice,
        description: (ctx) => ctx.l10n.readerSpeechVoiceDescription,
        keywords: (l10n) => <String>[l10n.readerReadAloud, l10n.readerSpeechLanguage, 'tts', 'voice', 'narrator'],
      ),
    ],
  );
}
