import 'package:yaabsa/util/l10n.dart';

enum PlayerCollectionEmptyMode { hide, compact, full }

extension PlayerCollectionEmptyModeX on PlayerCollectionEmptyMode {
  String label(AppLocalizations l10n) {
    switch (this) {
      case PlayerCollectionEmptyMode.hide:
        return l10n.optionHideWidget;
      case PlayerCollectionEmptyMode.compact:
        return l10n.optionCompactMessage;
      case PlayerCollectionEmptyMode.full:
        return l10n.optionFullPlaceholder;
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
