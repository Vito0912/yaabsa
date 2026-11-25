import 'package:yaabsa/util/l10n.dart';

enum AppThemeMode {
  light,
  dark,
  amoled,
  system;

  static AppThemeMode fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppThemeMode.dark;
    }

    final normalized = value.trim().toLowerCase();

    for (final mode in AppThemeMode.values) {
      if (mode.name == normalized || 'appthememode.${mode.name}' == normalized) {
        return mode;
      }
    }

    return AppThemeMode.dark;
  }

  String get label {
    return currentAppLocalizations().themeModeName(name);
  }
}

enum AppThemePreset {
  yaabsa,
  ember,
  moss,
  cobalt,
  rose,
  custom;

  static AppThemePreset fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppThemePreset.yaabsa;
    }

    final normalized = value.trim().toLowerCase();

    if (normalized == 'amoled' || normalized == 'appthemepreset.amoled') {
      // Keep old stored AMOLED preset values functional by falling back to the default preset.
      return AppThemePreset.yaabsa;
    }

    for (final preset in AppThemePreset.values) {
      if (preset.name == normalized || 'appthemepreset.${preset.name}' == normalized) {
        return preset;
      }
    }

    return AppThemePreset.yaabsa;
  }

  String get label {
    return currentAppLocalizations().themePresetName(name);
  }

  String get description {
    return currentAppLocalizations().themePresetDescription(name);
  }
}
