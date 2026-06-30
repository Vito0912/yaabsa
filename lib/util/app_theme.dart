import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

const Color _yaabsaSeed = Color(0xFF0F766E);
const Color _emberSeed = Color(0xFFB45309);
const Color _mossSeed = Color(0xFF3F6212);
const Color _cobaltSeed = Color(0xFF1D4ED8);
const Color _roseSeed = Color(0xFFBE185D);

/// Theme configuration resolved from the stored global settings, shared by
/// the phone and Wear OS entry points.
class AppThemeSelection {
  const AppThemeSelection({required this.mode, required this.preset, required this.customSeedColor});

  final AppThemeMode mode;
  final AppThemePreset preset;
  final Color customSeedColor;

  bool get useAmoledDark => mode == AppThemeMode.amoled;

  ThemeMode get materialThemeMode => useAmoledDark ? ThemeMode.dark : toMaterialThemeMode(mode);

  ThemeData themeData(Brightness brightness) => buildAppThemeData(
    brightness: brightness,
    preset: preset,
    customSeedColor: customSeedColor,
    useAmoledDark: useAmoledDark,
  );
}

/// Resolves the theme selection from the stored global settings and rebuilds
/// the watching widget when any of them change.
AppThemeSelection watchAppThemeSelection(WidgetRef ref) {
  final modeSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeMode)).asData?.value;
  final presetSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemePreset)).asData?.value;
  final redSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomRed)).asData?.value;
  final greenSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomGreen)).asData?.value;
  final blueSetting = ref.watch(globalSettingByKeyProvider(SettingKeys.appThemeCustomBlue)).asData?.value;

  final defaultRed = defaultSettings[SettingKeys.appThemeCustomRed] as int? ?? 15;
  final defaultGreen = defaultSettings[SettingKeys.appThemeCustomGreen] as int? ?? 118;
  final defaultBlue = defaultSettings[SettingKeys.appThemeCustomBlue] as int? ?? 110;

  return AppThemeSelection(
    mode: AppThemeMode.fromSettingValue(modeSetting),
    preset: AppThemePreset.fromSettingValue(presetSetting),
    customSeedColor: Color.fromARGB(
      0xFF,
      _parseColorChannelSetting(redSetting, defaultRed),
      _parseColorChannelSetting(greenSetting, defaultGreen),
      _parseColorChannelSetting(blueSetting, defaultBlue),
    ),
  );
}

int _parseColorChannelSetting(String? value, int fallback) {
  final parsed = int.tryParse(value ?? '');
  return (parsed ?? fallback).clamp(0, 255).toInt();
}

ThemeMode toMaterialThemeMode(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.light:
      return ThemeMode.light;
    case AppThemeMode.dark:
      return ThemeMode.dark;
    case AppThemeMode.amoled:
      return ThemeMode.dark;
    case AppThemeMode.system:
      return ThemeMode.system;
  }
}

Color appThemeSeedColor({required AppThemePreset preset, required Color customSeedColor}) {
  switch (preset) {
    case AppThemePreset.yaabsa:
      return _yaabsaSeed;
    case AppThemePreset.ember:
      return _emberSeed;
    case AppThemePreset.moss:
      return _mossSeed;
    case AppThemePreset.cobalt:
      return _cobaltSeed;
    case AppThemePreset.rose:
      return _roseSeed;
    case AppThemePreset.custom:
      return customSeedColor;
  }
}

ThemeData buildAppThemeData({
  required Brightness brightness,
  required AppThemePreset preset,
  required Color customSeedColor,
  required bool useAmoledDark,
}) {
  final seedColor = appThemeSeedColor(preset: preset, customSeedColor: customSeedColor);
  final colorScheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: brightness);

  final baseTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    switchTheme: SwitchThemeData(
      thumbIcon: WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.check, size: 16);
        }
        return const Icon(Icons.close, size: 16);
      }),
    ),
  );

  if (useAmoledDark && brightness == Brightness.dark) {
    return _buildAmoledDarkTheme(baseTheme, seedColor);
  }

  return baseTheme;
}

ThemeData _buildAmoledDarkTheme(ThemeData baseTheme, Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark).copyWith(
    surface: Colors.black,
    surfaceContainerLowest: Colors.black,
    surfaceContainerLow: const Color(0xFF040404),
    surfaceContainer: const Color(0xFF080808),
    surfaceContainerHigh: const Color(0xFF0D0D0D),
    surfaceContainerHighest: const Color(0xFF121212),
    shadow: Colors.black,
    scrim: Colors.black,
  );

  return baseTheme.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: Colors.black,
    canvasColor: Colors.black,
    cardColor: const Color(0xFF0A0A0A),
    appBarTheme: baseTheme.appBarTheme.copyWith(
      backgroundColor: Colors.black,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),
    drawerTheme: baseTheme.drawerTheme.copyWith(backgroundColor: Colors.black),
    dialogTheme: baseTheme.dialogTheme.copyWith(
      backgroundColor: const Color(0xFF101010),
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: baseTheme.bottomSheetTheme.copyWith(
      backgroundColor: const Color(0xFF070707),
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: baseTheme.navigationBarTheme.copyWith(
      backgroundColor: const Color(0xFF050505),
      surfaceTintColor: Colors.transparent,
    ),
  );
}
