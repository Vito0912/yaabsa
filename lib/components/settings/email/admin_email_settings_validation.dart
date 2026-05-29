class AdminEmailSettingsValidation {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? normalizeNullable(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? validateHost(String value) {
    if (value.trim().isEmpty) {
      return 'Host is required.';
    }
    return null;
  }

  static String? validatePort(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Port is required.';
    }

    final parsed = int.tryParse(trimmed);
    if (parsed == null) {
      return 'Port must be a number.';
    }

    if (parsed < 1 || parsed > 65535) {
      return 'Port must be between 1 and 65535.';
    }

    return null;
  }

  static String? validateOptionalEmail(String value, {required String fieldLabel}) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return '$fieldLabel must be a valid email address.';
    }

    return null;
  }

  static String? validateDeviceName(String value) {
    if (value.trim().isEmpty) {
      return 'Device name is required.';
    }
    return null;
  }

  static String? validateDeviceEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Device email is required.';
    }

    if (!_emailPattern.hasMatch(trimmed)) {
      return 'Device email must be a valid email address.';
    }

    return null;
  }
}
