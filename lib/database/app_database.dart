import 'dart:convert';
import 'dart:io';

import 'package:buchshelfly/api/me/user.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database.g.dart';

const String _activeUserIdKey = 'activeUserId';
const String _selectedLibraryIdKey = 'selectedLibraryId';

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

class SettingsParser {
  static String encodeValue<T>(T value) {
    if (value is String) return value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is bool) return value.toString();
    return value.toString();
  }

  static T decodeValue<T>(String? stringValue, T defaultValue) {
    if (T == Object) throw ArgumentError('Cannot decode to Object type');
    if (stringValue == null) return defaultValue;

    if (T == String) return stringValue as T;
    if (T == int) return (int.tryParse(stringValue) ?? defaultValue) as T;
    if (T == double) return (double.tryParse(stringValue) ?? defaultValue) as T;
    if (T == bool) {
      if (stringValue.toLowerCase() == 'true') return true as T;
      if (stringValue.toLowerCase() == 'false') return false as T;
      return defaultValue;
    }

    return defaultValue;
  }
}

@DriftDatabase(tables: [GlobalSettings, UserSettings, StoredUsers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.connect(DatabaseConnection super.connection);

  @override
  int get schemaVersion => 1;

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

  Stream<T> watchGlobalSettingTyped<T>(String key, T defaultValue) {
    return watchGlobalSetting(key).map((setting) => SettingsParser.decodeValue<T>(setting?.value, defaultValue));
  }

  Future<T> getGlobalSettingTyped<T>(String key, T defaultValue) async {
    final setting = await getGlobalSetting(key);
    return SettingsParser.decodeValue<T>(setting?.value, defaultValue);
  }

  Future<void> setGlobalSettingTyped<T>(String key, T value) {
    return setGlobalSetting(key, SettingsParser.encodeValue(value));
  }

  Stream<T> watchUserSettingTyped<T>(String userId, String key, T defaultValue) {
    return watchUserSetting(userId, key).map((setting) => SettingsParser.decodeValue<T>(setting?.value, defaultValue));
  }

  Future<T> getUserSettingTyped<T>(String userId, String key, T defaultValue) async {
    final setting = await getUserSetting(userId, key);
    return SettingsParser.decodeValue<T>(setting?.value, defaultValue);
  }

  Future<void> setUserSettingTyped<T>(String userId, String key, T value) {
    return setUserSetting(userId, key, SettingsParser.encodeValue(value));
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

  Stream<String?> watchSelectedLibraryId(String userId) {
    return watchUserSetting(userId, _selectedLibraryIdKey).map((setting) => setting?.value).distinct();
  }

  Future<String?> getSelectedLibraryId(String userId) async {
    final setting = await getUserSetting(userId, _selectedLibraryIdKey);
    return setting?.value;
  }

  Future<void> setSelectedLibraryId(String userId, String libraryId) {
    return setUserSetting(userId, _selectedLibraryIdKey, libraryId);
  }

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
                  final user = User.fromJson(jsonDecode(row.userDataJson));
                  return user;
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

  Stream<String?> watchActiveUserId() {
    return watchGlobalSetting(_activeUserIdKey).map((setting) => setting?.value);
  }

  Future<String?> getActiveUserId() async {
    final setting = await getGlobalSetting(_activeUserIdKey);
    return setting?.value;
  }

  Future<void> setActiveUserId(String newActiveUserId) async {
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
    await setGlobalSetting(_activeUserIdKey, newActiveUserId);
  }

  Future<void> clearActiveUserId() {
    return (delete(globalSettings)..where((tbl) => tbl.key.equals(_activeUserIdKey))).go();
  }
}

class GlobalSettingsCache {
  final Map<String, dynamic> _cache = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  T? get<T>(String key) {
    final value = _cache[key];
    if (value is T) return value;
    return null;
  }

  void set<T>(String key, T? value) {
    if (value == null) {
      _cache.remove(key);
    } else {
      _cache[key] = value;
    }
  }

  void setAll(Map<String, String> settings) {
    _cache.clear();
    _cache.addAll(settings);
    _isInitialized = true;
  }

  void clear() {
    _cache.clear();
    _isInitialized = false;
  }
}

class UserSettingsCache {
  final Map<String, Map<String, dynamic>> _cache = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  T? get<T>(String userId, String key) {
    final userCache = _cache[userId];
    if (userCache == null) return null;
    final value = userCache[key];
    if (value is T) return value;
    return null;
  }

  void set<T>(String userId, String key, T? value) {
    _cache.putIfAbsent(userId, () => {});
    if (value == null) {
      _cache[userId]!.remove(key);
    } else {
      _cache[userId]![key] = value;
    }
  }

  void setAll(Map<String, Map<String, String>> settings) {
    _cache.clear();
    for (final entry in settings.entries) {
      _cache[entry.key] = Map<String, dynamic>.from(entry.value);
    }
    _isInitialized = true;
  }

  void clearUser(String userId) {
    _cache.remove(userId);
  }

  void clear() {
    _cache.clear();
    _isInitialized = false;
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

@Riverpod(keepAlive: true)
GlobalSettingsCache globalSettingsCache(Ref ref) {
  return GlobalSettingsCache();
}

@Riverpod(keepAlive: true)
UserSettingsCache userSettingsCache(Ref ref) {
  return UserSettingsCache();
}

@Riverpod(keepAlive: true)
class GlobalSettingsManager extends _$GlobalSettingsManager {
  @override
  Stream<Map<String, dynamic>> build() async* {
    final db = ref.watch(appDatabaseProvider);
    final cache = ref.watch(globalSettingsCacheProvider);

    if (!cache.isInitialized) {
      final initialSettings = await db.getAllGlobalSettings();
      cache.setAll(initialSettings);
      yield Map<String, dynamic>.from(cache._cache);
    }

    await for (final entries in db.select(db.globalSettings).watch()) {
      final settings = <String, String>{};
      for (final entry in entries) {
        settings[entry.key] = entry.value;
      }
      cache.setAll(settings);
      yield Map<String, dynamic>.from(cache._cache);
    }
  }

  T getSetting<T>(String key, {T? defaultValue}) {
    final cache = ref.read(globalSettingsCacheProvider);
    final stringValue = cache.get<String>(key);
    final T tmpDefault = (defaultValue ?? defaultSettings[key]) as T;
    return SettingsParser.decodeValue<T>(stringValue, tmpDefault);
  }

  Future<void> setSetting<T>(String key, T value) async {
    logger('setSetting called with key: $key, value: $value', tag: 'GlobalSettingsManager', level: InfoLevel.debug);
    final db = ref.read(appDatabaseProvider);
    await db.setGlobalSettingTyped(key, value);
  }

  bool get isInitialized => ref.read(globalSettingsCacheProvider).isInitialized;

  Future<void> waitForInitialization() async {
    while (!isInitialized) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}

@Riverpod(keepAlive: true)
Stream<String?> globalSettingByKey(Ref ref, String key) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchGlobalSetting(key).map((setting) => setting?.value);
}

@Riverpod(keepAlive: true)
class UserSettingsManager extends _$UserSettingsManager {
  @override
  Stream<Map<String, Map<String, dynamic>>> build() async* {
    final db = ref.watch(appDatabaseProvider);
    final cache = ref.watch(userSettingsCacheProvider);

    if (!cache.isInitialized) {
      final initialSettings = await db.getAllUserSettings();
      cache.setAll(initialSettings);
      yield Map<String, Map<String, dynamic>>.from(
        cache._cache.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v))),
      );
    }

    await for (final entries in db.select(db.userSettings).watch()) {
      final settings = <String, Map<String, String>>{};
      for (final entry in entries) {
        settings.putIfAbsent(entry.userId, () => <String, String>{})[entry.key] = entry.value;
      }
      cache.setAll(settings);
      yield Map<String, Map<String, dynamic>>.from(
        cache._cache.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v))),
      );
    }
  }

  T getSetting<T>(String? userId, String key, {T? defaultValue}) {
    final cache = ref.read(userSettingsCacheProvider);
    if (userId == null) {
      logger(
        'getSetting called with null userId. Returning default value for key: $key',
        tag: 'UserSettingsManager',
        level: InfoLevel.warning,
      );
      return defaultValue ?? defaultSettings[key] as T;
    }
    final stringValue = cache.get<String>(userId, key);
    final T tmpDefault = (defaultValue ?? defaultSettings[key]) as T;
    return SettingsParser.decodeValue<T>(stringValue, tmpDefault);
  }

  Future<void> setSetting<T>(String userId, String key, T value) async {
    final db = ref.read(appDatabaseProvider);
    await db.setUserSettingTyped(userId, key, value);
  }

  bool get isInitialized => ref.read(userSettingsCacheProvider).isInitialized;

  Future<void> waitForInitialization() async {
    while (!isInitialized) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}

@Riverpod(keepAlive: true)
Future<void> settingsInitializer(Ref ref) async {
  final globalManager = ref.watch(globalSettingsManagerProvider.notifier);
  final userManager = ref.watch(userSettingsManagerProvider.notifier);

  await Future.wait([globalManager.waitForInitialization(), userManager.waitForInitialization()]);
}
