import 'dart:convert';

import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/util/setting_key.dart';

abstract final class SettingsBackup {
  static const maxBytes = 5 * 1024 * 1024;

  static const excludedKeys = {
    SettingKeys.currentUserId,
    SettingKeys.desktopWindowState,
    SettingKeys.downloadPath,
    SettingKeys.autoResumeBluetoothDeviceAddresses,
    SettingKeys.queueIntent,
    SettingKeys.lastPlayedQueueItem,
    SettingKeys.lastPlayedMiniPlayerSnapshot,
    SettingKeys.readerPendingProgress,
    SettingKeys.readerElevenLabsKeyRevision,
    SettingKeys.sleepTimerMarker,
    SettingKeys.sleepTimerAutoRestartSuppressed,
    SettingKeys.dismissedUpdateServerVersion,
    SettingKeys.latestServerVersion,
    SettingKeys.nextServerVersionCheckAllowed,
  };

  static bool _isPortable(String key) {
    final knownKey = defaultSettings.containsKey(key) || key == 'libraries_order' || _isMusicLibraryKey(key);
    return knownKey && !excludedKeys.contains(key);
  }

  static bool _isMusicLibraryKey(String key) {
    return key.startsWith('music_library_') && key.length > 'music_library_'.length;
  }

  static String encode({required Map<String, String> global, required Map<String, Map<String, String>> users}) {
    Map<String, String> portable(Map<String, String> values) {
      return Map.fromEntries(values.entries.where((entry) => _isPortable(entry.key)));
    }

    return const JsonEncoder.withIndent('  ').convert({
      'format': 'yaabsa-settings',
      'version': 1,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'global': portable(global),
      'users': {for (final entry in users.entries) entry.key: portable(entry.value)},
    });
  }

  static ({Map<String, String> global, Map<String, Map<String, String>> users}) decode(String source) {
    if (utf8.encode(source).length > maxBytes) {
      throw const FormatException('The settings backup is too large.');
    }

    final document = jsonDecode(source);
    if (document is! Map<String, dynamic> || document['format'] != 'yaabsa-settings') {
      throw const FormatException('Choose a Yaabsa settings backup.');
    }
    if (document['version'] != 1) {
      throw const FormatException('This settings backup version is not supported.');
    }

    final users = document['users'];
    if (users is! Map<String, dynamic> || users.keys.any((id) => id.trim().isEmpty)) {
      throw const FormatException('The settings backup has an invalid account settings section.');
    }

    return (
      global: _decodeSettings(document['global']),
      users: Map<String, Map<String, String>>.unmodifiable({
        for (final entry in users.entries) entry.key: _decodeSettings(entry.value),
      }),
    );
  }

  static Map<String, String> _decodeSettings(Object? source) {
    if (source is! Map<String, dynamic>) {
      throw const FormatException('The settings backup is missing a settings section.');
    }

    final settings = <String, String>{};
    for (final entry in source.entries) {
      if (!_isPortable(entry.key)) {
        continue;
      }

      final value = entry.value;
      if (value is! String || !_isValidValue(entry.key, value)) {
        throw FormatException('Invalid value for setting "${entry.key}".');
      }
      settings[entry.key] = value;
    }
    return Map.unmodifiable(settings);
  }

  static bool _isValidValue(String key, String value) {
    if (key == 'libraries_order') {
      try {
        final order = jsonDecode(value);
        return order is List && order.every((id) => id is String);
      } on FormatException {
        return false;
      }
    }

    final fallback = _isMusicLibraryKey(key) ? false : defaultSettings[key];
    if (fallback is bool) {
      return value == 'true' || value == 'false';
    }
    if (fallback is int) {
      return int.tryParse(value) != null;
    }
    if (fallback is double) {
      return jsonDoubleFromDynamic(value)?.isFinite ?? false;
    }
    if (fallback is String && (fallback.startsWith('{') || fallback.startsWith('['))) {
      try {
        final decoded = jsonDecode(value);
        return fallback.startsWith('{') ? decoded is Map : decoded is List;
      } on FormatException {
        return false;
      }
    }
    return true;
  }
}
