import 'package:yaabsa/ui/theme/app_theme.dart';
export 'package:yaabsa/ui/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';

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
