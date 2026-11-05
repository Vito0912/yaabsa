import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/settings_backup.dart';

void main() {
  test('round trips player, notification, theme and account preferences', () {
    final global = {
      SettingKeys.appThemeMode: 'AppThemeMode.light',
      SettingKeys.mediaNotificationPages: '[["rewind","speed"]]',
      SettingKeys.playerLayoutConfig: '{"version":1,"layout":[]}',
    };
    final user = {
      SettingKeys.rewindInterval: '25',
      SettingKeys.playbackSpeed: '1.25',
      SettingKeys.homeBookViewPreferences: '{"order":["library","shelf"]}',
      SettingKeys.toolsMatchAudiobookChapters: 'true',
      SettingKeys.pinnedShelfEntries: '{"library-1":[]}',
      'libraries_order': '["library-2","library-1"]',
      'music_library_library-1': 'true',
    };

    final backup = SettingsBackup.decode(SettingsBackup.encode(global: global, users: {'user-1': user}));

    expect(backup.global, global);
    expect(backup.users, {'user-1': user});
  });

  test('excludes credentials, runtime state and device-specific settings in both scopes', () {
    final values = {
      for (final key in SettingsBackup.excludedKeys) key: 'private',
      'activeUserId': 'private',
      'selectedLibraryId': 'private',
      'custom_headers': 'private',
      'accessToken': 'private',
      SettingKeys.keepScreenOn: 'true',
    };
    final exported = SettingsBackup.encode(global: values, users: {'user-1': values});
    expect(exported, isNot(contains('private')));

    final imported = SettingsBackup.decode(_document(global: values, users: {'user-1': values}));
    expect(imported.global, {SettingKeys.keepScreenOn: 'true'});
    expect(imported.users, {
      'user-1': {SettingKeys.keepScreenOn: 'true'},
    });
  });

  test('ignores unknown future settings and preserves known settings', () {
    final backup = SettingsBackup.decode(
      _document(
        global: {
          'future_setting': {'new': 'format'},
          SettingKeys.volume: '0.5',
        },
      ),
    );

    expect(backup.global, {SettingKeys.volume: '0.5'});
  });

  test('rejects malformed documents and unsupported versions', () {
    for (final source in [
      'not json',
      '[]',
      '{}',
      '{"format":"yaabsa-settings","version":2,"global":{},"users":{}}',
      '{"format":"yaabsa-settings","version":1,"global":{}}',
      '{"format":"yaabsa-settings","version":1,"global":[],"users":{}}',
    ]) {
      expect(() => SettingsBackup.decode(source), throwsFormatException);
    }
  });

  test('preserves the settings and IDs of multiple accounts', () {
    final users = {
      'user-1': {SettingKeys.rewindInterval: '10'},
      'user-2': {SettingKeys.rewindInterval: '30'},
    };

    final backup = SettingsBackup.decode(SettingsBackup.encode(global: {}, users: users));

    expect(backup.users, users);
  });

  test('rejects account settings without valid user IDs or settings maps', () {
    for (final users in <Map<String, Object?>>[
      {'': {}},
      {' ': {}},
      {'user-1': []},
      {'user-1': null},
      {
        'user-1': {SettingKeys.rewindInterval: 'invalid'},
      },
    ]) {
      expect(() => SettingsBackup.decode(_document(users: users)), throwsFormatException);
    }
  });

  test('rejects incorrect types, non-finite numbers and malformed structured values', () {
    for (final entry in <String, Object?>{
      SettingKeys.keepScreenOn: 'yes',
      SettingKeys.rewindInterval: '2.5',
      SettingKeys.volume: 'NaN',
      SettingKeys.playbackSpeed: 'Infinity',
      SettingKeys.appThemeMode: null,
      SettingKeys.libraryGridScale: 2,
      SettingKeys.mediaNotificationPages: '{}',
      SettingKeys.homeBookViewPreferences: '{broken',
      SettingKeys.equalizerBandGains: '[]',
      'libraries_order': '[1]',
      'music_library_library-1': 'invalid',
    }.entries) {
      expect(
        () => SettingsBackup.decode(_document(global: {entry.key: entry.value})),
        throwsFormatException,
        reason: entry.key,
      );
    }
  });

  test('rejects oversized backups', () {
    expect(() => SettingsBackup.decode(' ' * (SettingsBackup.maxBytes + 1)), throwsFormatException);
  });
}

String _document({Map<String, Object?> global = const {}, Map<String, Object?> users = const {}}) {
  return jsonEncode({'format': 'yaabsa-settings', 'version': 1, 'global': global, 'users': users});
}
