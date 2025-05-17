// lib/features/settings/data/settings_repository.dart
import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  Stream<String?> watchStringGlobalSetting({
    required String key,
    String? defaultValue,
  }) {
    return _db.watchGlobalSetting(key).map((entry) {
      return entry?.value ?? defaultValue;
    });
  }

  Future<void> setStringGlobalSetting({
    required String key,
    required String value,
  }) {
    return _db.setGlobalSetting(key, value);
  }

  Future<String?> getStringGlobalSetting({
    required String key,
    String? defaultValue,
  }) async {
    final entry = await _db.getGlobalSetting(key);
    return entry?.value ?? defaultValue;
  }

  Stream<InfoLevel> watchLogLevelSetting() {
    return watchStringGlobalSetting(
      key: SettingKeys.appLogLevel,
      defaultValue: InfoLevel.info.name,
    ).map((value) {
      return InfoLevel.values.firstWhere(
        (e) => e.name == value,
        orElse: () => InfoLevel.info,
      );
    });
  }

  Future<void> setLogLevelSetting(InfoLevel logLevel) {
    return setStringGlobalSetting(
      key: SettingKeys.appLogLevel,
      value: logLevel.name,
    );
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(ref.watch(appDatabaseProvider));
}
