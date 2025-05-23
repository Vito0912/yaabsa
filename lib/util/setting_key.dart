import 'package:buchshelfly/util/logger.dart';

class SettingKeys {
  // Global Settings
  static const String appThemeMode = 'app_theme_mode';
  static const String currentUserId = 'current_user_id';
  static const String appLogLevel = 'app_log_level';
  static const String bufferSize = 'buffer_size';

  // User-Specific Settings
  static const String syncInterval = 'sync_interval';
}

final defaultSettings = {
  SettingKeys.appThemeMode: AppThemeMode.system.toString(),
  SettingKeys.currentUserId: null,
  SettingKeys.appLogLevel: InfoLevel.info.toString(),
  SettingKeys.bufferSize: 5 * 1024 * 1024,

  SettingKeys.syncInterval: 10,
};

enum AppThemeMode { light, dark, system }
