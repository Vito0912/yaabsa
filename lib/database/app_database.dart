import 'dart:convert';
import 'dart:io';

import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

@DataClassName('GlobalSettingEntry')
class GlobalSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('UserSettingEntry')
class UserSettings extends Table {
  TextColumn get userId => text()();
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {userId, key};
}

@DataClassName('StoredUserEntry')
class StoredUsers extends Table {
  TextColumn get id => text()();
  TextColumn get userDataJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [GlobalSettings, UserSettings, StoredUsers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.connect(DatabaseConnection super.connection);

  @override
  int get schemaVersion => 1;

  // Basic setting operations
  Stream<GlobalSettingEntry?> watchGlobalSetting(String key) {
    return (select(globalSettings)..where((tbl) => tbl.key.equals(key))).watchSingleOrNull().distinct();
  }

  Future<void> setGlobalSetting(String key, String value) {
    final companion = GlobalSettingsCompanion(key: Value(key), value: Value(value));
    return into(globalSettings).insert(companion, mode: InsertMode.replace);
  }

  Future<GlobalSettingEntry?> getGlobalSetting(String key) {
    return (select(globalSettings)..where((tbl) => tbl.key.equals(key))).getSingleOrNull();
  }

  Stream<UserSettingEntry?> watchUserSetting(String userId, String key) {
    return (select(userSettings)
      ..where((tbl) => tbl.userId.equals(userId) & tbl.key.equals(key))).watchSingleOrNull().distinct();
  }

  Future<void> setUserSetting(String userId, String key, String value) {
    final companion = UserSettingsCompanion(userId: Value(userId), key: Value(key), value: Value(value));
    return into(userSettings).insert(companion, mode: InsertMode.replace);
  }

  Future<UserSettingEntry?> getUserSetting(String userId, String key) {
    return (select(userSettings)..where((tbl) => tbl.userId.equals(userId) & tbl.key.equals(key))).getSingleOrNull();
  }

  Future<Map<String, String>> getAllGlobalSettings() async {
    final entries = await select(globalSettings).get();
    return Map.fromEntries(entries.map((e) => MapEntry(e.key, e.value)));
  }

  Future<Map<String, Map<String, String>>> getAllUserSettings() async {
    final entries = await select(userSettings).get();
    final result = <String, Map<String, String>>{};
    for (final entry in entries) {
      result.putIfAbsent(entry.userId, () => {})[entry.key] = entry.value;
    }
    return result;
  }

  // User management
  Stream<List<User>> watchAllStoredUsers() {
    return select(storedUsers).watch().map((rows) {
      logger(
        'storedUsers stream emitted ${rows.length} StoredUserEntry items.',
        tag: 'AppDatabase',
        level: InfoLevel.debug,
      );
      final userList =
          rows
              .map((row) {
                try {
                  return User.fromJson(jsonDecode(row.userDataJson));
                } catch (e, s) {
                  logger(
                    'ERROR decoding User from JSON. Row ID: ${row.id}, JSON: ${row.userDataJson}. Error: $e. Stack: $s',
                    tag: 'AppDatabase',
                    level: InfoLevel.error,
                  );
                  return null;
                }
              })
              .whereType<User>()
              .toList();
      return userList;
    }).distinct();
  }

  Future<void> addOrUpdateStoredUser(User user) {
    logger(
      '[AppDatabase] addOrUpdateStoredUser called for user ID: ${user.id}, username: ${user.username}, isActive: ${user.isActive}, server: ${user.server?.url}',
      tag: 'AppDatabase',
      level: InfoLevel.debug,
    );

    final userToStore = User(
      id: user.id,
      username: user.username,
      email: user.email,
      type: user.type,
      token: user.token,
      mediaProgress: null,
      seriesHideFromContinueListening: user.seriesHideFromContinueListening,
      bookmarks: null,
      isActive: user.isActive,
      isLocked: user.isLocked,
      lastSeen: user.lastSeen,
      createdAt: user.createdAt,
      permissions: user.permissions,
      librariesAccessible: user.librariesAccessible,
      itemTagsSelected: user.itemTagsSelected,
      hasOpenIdLink: user.hasOpenIdLink,
      setting: user.setting,
      server: user.server,
    );

    final companion = StoredUsersCompanion(
      id: Value(userToStore.id),
      userDataJson: Value(jsonEncode(userToStore.toJson())),
    );

    final result = into(storedUsers).insert(companion, mode: InsertMode.replace);
    result
        .then(
          (_) => logger(
            'addOrUpdateStoredUser completed successfully for user ID: ${user.id}',
            tag: 'AppDatabase',
            level: InfoLevel.info,
          ),
        )
        .catchError(
          (e, s) => logger(
            'addOrUpdateStoredUser ERROR for user ID: ${user.id}. Error: $e. Stack: $s',
            tag: 'AppDatabase',
            level: InfoLevel.error,
          ),
        );
    return result;
  }

  Future<void> deleteStoredUser(String userId) {
    return (delete(storedUsers)..where((tbl) => tbl.id.equals(userId))).go();
  }

  Future<User?> getStoredUser(String userId) async {
    final row = await (select(storedUsers)..where((tbl) => tbl.id.equals(userId))).getSingleOrNull();
    if (row != null) {
      return User.fromJson(jsonDecode(row.userDataJson));
    }
    return null;
  }

  Future<void> setActiveUserId(String newActiveUserId) async {
    const activeUserIdKey = 'activeUserId';
    final allCurrentUsers = await select(storedUsers).get();

    await batch((b) {
      for (final userRow in allCurrentUsers) {
        final user = User.fromJson(jsonDecode(userRow.userDataJson));
        bool shouldBeActive = user.id == newActiveUserId;
        if (user.isActive != shouldBeActive) {
          final updatedUser = user.copyWith(isActive: shouldBeActive);
          b.replace(
            storedUsers,
            StoredUsersCompanion(id: Value(updatedUser.id), userDataJson: Value(jsonEncode(updatedUser.toJson()))),
          );
        }
      }
    });
    await setGlobalSetting(activeUserIdKey, newActiveUserId);
  }

  Future<void> clearActiveUserId() {
    const activeUserIdKey = 'activeUserId';
    return (delete(globalSettings)..where((tbl) => tbl.key.equals(activeUserIdKey))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  return AppDatabase();
}
