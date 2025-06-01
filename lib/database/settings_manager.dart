import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_manager.g.dart';

const String activeUserIdKey = 'activeUserId';
const String selectedLibraryIdKey = 'selectedLibraryId';

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
    if (T == double) {
      return (double.tryParse(stringValue) ?? defaultValue) as T;
    }
    if (T == bool) {
      if (stringValue.toLowerCase() == 'true') return true as T;
      if (stringValue.toLowerCase() == 'false') return false as T;
      return defaultValue;
    }

    return defaultValue;
  }
}

class SettingsCache {
  final Map<String, Map<String, dynamic>> _cache = {};
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  V? get<V>(String key, [String? subKey]) {
    if (subKey != null) {
      final subCache = _cache[key];
      if (subCache == null) return null;
      final value = subCache[subKey];
      return value is V ? value : null;
    } else {
      final value = _cache['global']?[key];
      return value is V ? value : null;
    }
  }

  void set<V>(String key, V? value, [String? subKey]) {
    if (subKey != null) {
      _cache.putIfAbsent(key, () => {});
      if (value == null) {
        _cache[key]!.remove(subKey);
      } else {
        _cache[key]![subKey] = value;
      }
    } else {
      _cache.putIfAbsent('global', () => {});
      if (value == null) {
        _cache['global']!.remove(key);
      } else {
        _cache['global']![key] = value;
      }
    }
  }

  void setAllGlobal(Map<String, String> settings) {
    _cache['global'] = Map<String, dynamic>.from(settings);
    _isInitialized = true;
  }

  void setAllUsers(Map<String, Map<String, String>> settings) {
    for (final entry in settings.entries) {
      _cache[entry.key] = Map<String, dynamic>.from(entry.value);
    }
    _isInitialized = true;
  }

  void clear() {
    _cache.clear();
    _isInitialized = false;
  }
}

@Riverpod(keepAlive: true)
SettingsCache settingsCache(Ref ref) {
  return SettingsCache();
}

@Riverpod(keepAlive: true)
class SettingsManager extends _$SettingsManager {
  @override
  Stream<bool> build() async* {
    final db = ref.watch(appDatabaseProvider);
    final cache = ref.watch(settingsCacheProvider);

    if (!cache.isInitialized) {
      final globalSettings = await db.getAllGlobalSettings();
      final userSettings = await db.getAllUserSettings();
      cache.setAllGlobal(globalSettings);
      cache.setAllUsers(userSettings);
      yield true;
    }

    await for (final _ in db.select(db.globalSettings).watch()) {
      final globalSettings = await db.getAllGlobalSettings();
      final userSettings = await db.getAllUserSettings();
      cache.setAllGlobal(globalSettings);
      cache.setAllUsers(userSettings);
      yield true;
    }
  }

  T getGlobalSetting<T>(String key, {T? defaultValue}) {
    final cache = ref.read(settingsCacheProvider);
    final stringValue = cache.get<String>(key);
    final T tmpDefault = (defaultValue ?? defaultSettings[key]) as T;
    return SettingsParser.decodeValue<T>(stringValue, tmpDefault);
  }

  Future<void> setGlobalSetting<T>(String key, T value) async {
    final db = ref.read(appDatabaseProvider);
    await db.setGlobalSetting(key, SettingsParser.encodeValue(value));
  }

  T getUserSetting<T>(String? userId, String key, {T? defaultValue}) {
    if (userId == null) {
      logger(
        'getUserSetting called with null userId. Returning default value for key: $key',
        tag: 'SettingsManager',
        level: InfoLevel.warning,
      );
      return defaultValue ?? defaultSettings[key] as T;
    }

    final cache = ref.read(settingsCacheProvider);
    final stringValue = cache.get<String>(userId, key);
    final T tmpDefault = (defaultValue ?? defaultSettings[key]) as T;
    return SettingsParser.decodeValue<T>(stringValue, tmpDefault);
  }

  bool get isInitialized => ref.read(settingsCacheProvider).isInitialized;

  Future<void> waitForInitialization() async {
    while (!isInitialized) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }
}

@Riverpod(keepAlive: true)
class UserSettingsWatcher extends _$UserSettingsWatcher {
  @override
  Stream<bool> build() async* {
    final db = ref.watch(appDatabaseProvider);
    final cache = ref.watch(settingsCacheProvider);

    await for (final _ in db.select(db.userSettings).watch()) {
      if (cache.isInitialized) {
        final userSettings = await db.getAllUserSettings();
        cache.setAllUsers(userSettings);
        yield true;
      }
    }
  }
}

@Riverpod(keepAlive: true)
Stream<String?> globalSettingByKey(Ref ref, String key) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchGlobalSetting(key).map((setting) => setting?.value);
}

@Riverpod(keepAlive: true)
Future<void> settingsInitializer(Ref ref) async {
  final manager = ref.watch(settingsManagerProvider.notifier);
  final userWatcher = ref.watch(userSettingsWatcherProvider.notifier);

  await manager.waitForInitialization();

  ref.watch(settingsManagerProvider);
  ref.watch(userSettingsWatcherProvider);
}
