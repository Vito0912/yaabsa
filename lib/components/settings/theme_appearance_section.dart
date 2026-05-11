import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/settings/settings_category.dart';
import 'package:yaabsa/components/settings/theme_color_channel_slider.dart';
import 'package:yaabsa/components/settings/theme_preset_option_card.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/app_theme.dart';
import 'package:yaabsa/util/setting_key.dart';

class ThemeAppearanceSection extends ConsumerWidget {
  const ThemeAppearanceSection({super.key});

  static const List<Color> quickCustomColors = [
    Color(0xFF0F766E),
    Color(0xFF2563EB),
    Color(0xFFB45309),
    Color(0xFF7C3AED),
    Color(0xFFBE123C),
    Color(0xFF3F6212),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appThemeModeSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeMode)).asData?.value;
    final appThemePresetSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemePreset)).asData?.value;
    final customRedSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomRed)).asData?.value;
    final customGreenSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomGreen)).asData?.value;
    final customBlueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomBlue)).asData?.value;

    final appThemeMode = AppThemeMode.fromSettingValue(appThemeModeSetting);
    final appThemePreset = AppThemePreset.fromSettingValue(appThemePresetSetting);

    final defaultRed = defaultSettings[SettingKeys.appThemeCustomRed] as int? ?? 15;
    final defaultGreen = defaultSettings[SettingKeys.appThemeCustomGreen] as int? ?? 118;
    final defaultBlue = defaultSettings[SettingKeys.appThemeCustomBlue] as int? ?? 110;

    final customRed = parseColorChannel(customRedSetting, defaultRed);
    final customGreen = parseColorChannel(customGreenSetting, defaultGreen);
    final customBlue = parseColorChannel(customBlueSetting, defaultBlue);

    final customSeedColor = Color.fromARGB(0xFF, customRed, customGreen, customBlue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsCategory(title: 'Theme', icon: Icons.palette_outlined, topPadding: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Theme Mode',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AppThemeMode.values
                        .map(
                          (mode) => ChoiceChip(
                            label: Text(mode.label),
                            avatar: Icon(switch (mode) {
                              AppThemeMode.light => Icons.light_mode_rounded,
                              AppThemeMode.dark => Icons.dark_mode_rounded,
                              AppThemeMode.amoled => Icons.brightness_2_rounded,
                              AppThemeMode.system => Icons.brightness_auto_rounded,
                            }, size: 18),
                            selected: appThemeMode == mode,
                            onSelected: (selected) {
                              if (!selected) {
                                return;
                              }

                              unawaited(
                                ref
                                    .read(settingsManagerProvider.notifier)
                                    .setGlobalSetting<String>(SettingKeys.appThemeMode, mode.toString()),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Text(
            'THEME PRESETS',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final int columns = width >= 660
                  ? 3
                  : width >= 320
                  ? 2
                  : 1;
              final double spacing = 12;
              final double totalSpacing = spacing * (columns - 1);
              final double cardWidth = (constraints.maxWidth - totalSpacing) / columns;

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: AppThemePreset.values
                    .map(
                      (preset) => SizedBox(
                        width: cardWidth,
                        child: ThemePresetOptionCard(
                          title: preset.label,
                          description: preset.description,
                          selected: appThemePreset == preset,
                          accentColor: appThemeSeedColor(preset: preset, customSeedColor: customSeedColor),
                          onTap: () {
                            unawaited(
                              ref
                                  .read(settingsManagerProvider.notifier)
                                  .setGlobalSetting<String>(SettingKeys.appThemePreset, preset.toString()),
                            );
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        if (appThemePreset == AppThemePreset.custom)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Custom Theme',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: customSeedColor.withValues(alpha: 0.17),
                        border: Border.all(color: customSeedColor.withValues(alpha: 0.45)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: customSeedColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Accent ${toHex(customSeedColor)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            'R$customRed G$customGreen B$customBlue',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ThemeColorChannelSlider(
                      label: 'Red',
                      value: customRed,
                      activeColor: const Color(0xFFDC2626),
                      onChanged: (value) {
                        unawaited(
                          ref
                              .read(settingsManagerProvider.notifier)
                              .setGlobalSetting<int>(SettingKeys.appThemeCustomRed, value),
                        );
                      },
                    ),
                    ThemeColorChannelSlider(
                      label: 'Green',
                      value: customGreen,
                      activeColor: const Color(0xFF16A34A),
                      onChanged: (value) {
                        unawaited(
                          ref
                              .read(settingsManagerProvider.notifier)
                              .setGlobalSetting<int>(SettingKeys.appThemeCustomGreen, value),
                        );
                      },
                    ),
                    ThemeColorChannelSlider(
                      label: 'Blue',
                      value: customBlue,
                      activeColor: const Color(0xFF2563EB),
                      onChanged: (value) {
                        unawaited(
                          ref
                              .read(settingsManagerProvider.notifier)
                              .setGlobalSetting<int>(SettingKeys.appThemeCustomBlue, value),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quick Colors',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: quickCustomColors
                          .map(
                            (color) => Tooltip(
                              message: toHex(color),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(999),
                                onTap: () {
                                  final settings = ref.read(settingsManagerProvider.notifier);
                                  unawaited(
                                    settings.setGlobalSetting<int>(SettingKeys.appThemeCustomRed, colorRed(color)),
                                  );
                                  unawaited(
                                    settings.setGlobalSetting<int>(SettingKeys.appThemeCustomGreen, colorGreen(color)),
                                  );
                                  unawaited(
                                    settings.setGlobalSetting<int>(SettingKeys.appThemeCustomBlue, colorBlue(color)),
                                  );
                                },
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                        color: color.withValues(alpha: 0.28),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  int parseColorChannel(String? settingValue, int fallback) {
    final parsed = int.tryParse(settingValue ?? '');
    return (parsed ?? fallback).clamp(0, 255).toInt();
  }

  String toHex(Color color) {
    final red = colorRed(color).toRadixString(16).padLeft(2, '0').toUpperCase();
    final green = colorGreen(color).toRadixString(16).padLeft(2, '0').toUpperCase();
    final blue = colorBlue(color).toRadixString(16).padLeft(2, '0').toUpperCase();
    return '#$red$green$blue';
  }

  int colorRed(Color color) => (color.toARGB32() >> 16) & 0xFF;

  int colorGreen(Color color) => (color.toARGB32() >> 8) & 0xFF;

  int colorBlue(Color color) => color.toARGB32() & 0xFF;
}
