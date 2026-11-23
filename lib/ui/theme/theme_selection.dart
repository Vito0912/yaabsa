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
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.amoled:
        return 'AMOLED';
      case AppThemeMode.system:
        return 'System';
    }
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
    switch (this) {
      case AppThemePreset.yaabsa:
        return 'Yaabsa';
      case AppThemePreset.ember:
        return 'Ember';
      case AppThemePreset.moss:
        return 'Moss';
      case AppThemePreset.cobalt:
        return 'Cobalt';
      case AppThemePreset.rose:
        return 'Rose';
      case AppThemePreset.custom:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case AppThemePreset.yaabsa:
        return 'Balanced teal accent with soft contrast.';
      case AppThemePreset.ember:
        return 'Warm orange highlights and energetic surfaces.';
      case AppThemePreset.moss:
        return 'Natural green tones with a calmer look.';
      case AppThemePreset.cobalt:
        return 'Cool blue accents with a crisp interface feel.';
      case AppThemePreset.rose:
        return 'Rosy highlights with a softer modern touch.';
      case AppThemePreset.custom:
        return 'Build your own color profile.';
    }
  }
}
