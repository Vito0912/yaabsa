import 'package:drift/drift.dart' show DatabaseConnection;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:yaabsa/util/settings_backup.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;
  late SettingsManager manager;

  Future<void> saveUser(String id) async {
    await db.into(db.storedUsers).insert(StoredUsersCompanion.insert(id: id, userDataJson: '{}'));
  }

  setUp(() async {
    db = AppDatabase.connect(DatabaseConnection(NativeDatabase.memory()));
    await db.setGlobalSetting(SettingKeys.appThemeMode, 'dark');
    await saveUser('destination');
    await saveUser('other');
    container = ProviderContainer(overrides: [appDatabaseProvider.overrideWithValue(db)]);
    manager = container.read(settingsManagerProvider.notifier);
    container.listen(settingsManagerProvider, (previous, next) {});
    await container.read(settingsManagerProvider.future);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('exports global settings and every user grouped by ID without an active account', () async {
    await db.setGlobalSetting(SettingKeys.appThemeMode, 'light');
    await db.setUserSetting('destination', SettingKeys.rewindInterval, '20');
    await db.setUserSetting('other', SettingKeys.rewindInterval, '50');

    final backup = SettingsBackup.decode(await manager.exportSettings());

    expect(backup.global, {SettingKeys.appThemeMode: 'light'});
    expect(backup.users, {
      'destination': {SettingKeys.rewindInterval: '20'},
      'other': {SettingKeys.rewindInterval: '50'},
    });
    expect(await db.getGlobalSetting('activeUserId'), isNull);
  });

  test('restores each matching account including inactive accounts and preserves other settings', () async {
    await db.setUserSetting('destination', SettingKeys.rewindInterval, '5');
    await db.setUserSetting('destination', SettingKeys.fastForwardInterval, '40');
    await db.setUserSetting('other', SettingKeys.rewindInterval, '50');
    await db.setGlobalSetting('activeUserId', 'destination');
    final backup = SettingsBackup.decode(
      SettingsBackup.encode(
        global: {SettingKeys.appThemeMode: 'light'},
        users: {
          'destination': {SettingKeys.rewindInterval: '25'},
          'other': {SettingKeys.rewindInterval: '15'},
          'unknown': {SettingKeys.rewindInterval: '99'},
        },
      ),
    );

    await manager.importSettings(global: backup.global, users: backup.users);

    expect((await db.getGlobalSetting(SettingKeys.appThemeMode))?.value, 'light');
    expect(manager.getGlobalSetting<String>(SettingKeys.appThemeMode), 'light');
    expect(manager.getUserSetting<int>('destination', SettingKeys.rewindInterval), 25);
    expect(manager.getUserSetting<int>('other', SettingKeys.rewindInterval), 15);
    expect((await db.getUserSetting('destination', SettingKeys.fastForwardInterval))?.value, '40');
    expect((await db.getUserSetting('other', SettingKeys.rewindInterval))?.value, '15');
    expect(await db.getUserSetting('unknown', SettingKeys.rewindInterval), isNull);
    expect((await db.getGlobalSetting('activeUserId'))?.value, 'destination');
  });

  test('does not copy unmatched settings to the active account', () async {
    await db.setGlobalSetting('activeUserId', 'destination');
    await db.setUserSetting('destination', SettingKeys.rewindInterval, '5');
    await db.setUserSetting('unknown', SettingKeys.rewindInterval, '7');

    await manager.importSettings(
      global: {SettingKeys.keepScreenOn: 'true'},
      users: {
        'unknown': {SettingKeys.rewindInterval: '99'},
      },
    );

    expect((await db.getGlobalSetting(SettingKeys.keepScreenOn))?.value, 'true');
    expect((await db.getUserSetting('destination', SettingKeys.rewindInterval))?.value, '5');
    expect((await db.getUserSetting('unknown', SettingKeys.rewindInterval))?.value, '7');
  });

  test('imports matching settings when the saved account has no settings yet', () async {
    await manager.importSettings(
      global: {},
      users: {
        'destination': {SettingKeys.rewindInterval: '25'},
      },
    );

    expect((await db.getUserSetting('destination', SettingKeys.rewindInterval))?.value, '25');
  });

  test('with no saved accounts imports only global preferences', () async {
    await db.delete(db.storedUsers).go();

    await manager.importSettings(
      global: {SettingKeys.keepScreenOn: 'true'},
      users: {
        'destination': {SettingKeys.rewindInterval: '25'},
      },
    );

    expect((await db.getGlobalSetting(SettingKeys.keepScreenOn))?.value, 'true');
    expect(await db.getAllUserSettings(), isEmpty);
  });

  test('rechecks saved user IDs at import time after the preview', () async {
    final users = {
      'destination': {SettingKeys.rewindInterval: '25'},
    };
    expect(await manager.matchingBackupUsers(users), users);
    await db.delete(db.storedUsers).go();

    await manager.importSettings(global: {}, users: users);

    expect(await db.getAllUserSettings(), isEmpty);
  });

  test('failed import rolls back database writes and leaves cache unchanged', () async {
    await db.customStatement(
      "CREATE TRIGGER fail_import BEFORE INSERT ON user_settings BEGIN SELECT RAISE(ABORT, 'failed'); END",
    );

    await expectLater(
      manager.importSettings(
        global: {SettingKeys.appThemeMode: 'light'},
        users: {
          'destination': {SettingKeys.rewindInterval: '25'},
        },
      ),
      throwsA(isA<Exception>()),
    );

    expect((await db.getGlobalSetting(SettingKeys.appThemeMode))?.value, 'dark');
    expect(manager.getGlobalSetting<String>(SettingKeys.appThemeMode), 'dark');
    expect(await db.getAllUserSettings(), isEmpty);
  });
}
