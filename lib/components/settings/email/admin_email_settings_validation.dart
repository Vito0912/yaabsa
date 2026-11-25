import 'package:yaabsa/util/l10n.dart' show AppLocalizations;

class AdminEmailSettingsValidation {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? normalizeNullable(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? validateHost(String value, AppLocalizations l10n) {
    if (value.trim().isEmpty) {
      return l10n.errorEmailHostRequired;
    }
    return null;
  }

  static String? validatePort(String value, AppLocalizations l10n) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return l10n.errorEmailPortRequired;
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return l10n.errorEmailPortMustBeNumber;
    }

    if (parsed < 1 || parsed > 65535) {
      return l10n.errorEmailPortRange(1, 65535);
    }

    return null;
  }

  static String? validateOptionalEmail(String value, {required String fieldLabel, required AppLocalizations l10n}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return l10n.errorEmailFieldInvalid(fieldLabel);
    }

    return null;
  }

  static String? validateDeviceName(String value, AppLocalizations l10n) {
    if (value.trim().isEmpty) {
      return l10n.errorDeviceNameRequired;
    }
    return null;
  }

  static String? validateDeviceEmail(String value, AppLocalizations l10n) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return l10n.errorDeviceEmailRequired;
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return l10n.errorDeviceEmailInvalid;
    }

    return null;
  }
}
