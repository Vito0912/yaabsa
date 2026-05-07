enum PlayerCollectionEmptyMode { hide, compact, full }

extension PlayerCollectionEmptyModeX on PlayerCollectionEmptyMode {
  String get label {
    switch (this) {
      case PlayerCollectionEmptyMode.hide:
        return 'Hide widget';
      case PlayerCollectionEmptyMode.compact:
        return 'Compact message';
      case PlayerCollectionEmptyMode.full:
        return 'Full placeholder';
    }
  }

  static PlayerCollectionEmptyMode fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PlayerCollectionEmptyMode.full;
    }

    final normalized = value.trim().toLowerCase();
    for (final mode in PlayerCollectionEmptyMode.values) {
      if (mode.name == normalized) {
        return mode;
      }
    }

    return PlayerCollectionEmptyMode.full;
  }
}
