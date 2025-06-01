import 'package:yaabsa/util/logger.dart';

class SettingKeys {
  // Global Settings
  static const String appThemeMode = 'app_theme_mode';
  static const String currentUserId = 'current_user_id';
  static const String appLogLevel = 'app_log_level';
  static const String bufferSize = 'buffer_size';
  static const String lockMediaNotification = 'lock_media_notification';
  static const String language = 'language';

  // User-Specific Settings
  static const String syncInterval = 'sync_interval';
  static const String syncOnlyOnWifi = 'sync_only_on_wifi';
  static const String sortSeriesAscending = 'sort_series_ascending';
  static const String downloadPath = 'download_path';
  static const String waitForSync = 'wait_for_sync';
  static const String progressPerChapter = 'progress_per_chapter';
  static const String shakeToResetSleepTimer = 'shake_to_reset_sleep_timer';
  static const String shakeToRewind = 'shake_to_rewind';
  static const String shakeSensitivity = 'shake_sensitivity';
  static const String shakeVibrate = 'shake_vibrate';

  static const String fastForwardInterval = 'fast_forward_interval';
  static const String rewindInterval = 'rewind_interval';

  static const String caching = 'caching';
  static const String aggressiveCaching = 'aggressive_caching';
  static const String boostLoading = 'boost_loading';

  static const String playbackSpeed = 'playback_speed';
  static const String volume = 'volume';
}

final defaultSettings = {
  SettingKeys.appThemeMode: AppThemeMode.dark.toString(),
  SettingKeys.currentUserId: null,
  SettingKeys.appLogLevel: InfoLevel.info.toString(),
  SettingKeys.bufferSize: 5 * 1024 * 1024,
  SettingKeys.lockMediaNotification: false,
  SettingKeys.language: 'en-US',

  SettingKeys.syncInterval: 10,
  SettingKeys.syncOnlyOnWifi: false,
  SettingKeys.sortSeriesAscending: false,
  SettingKeys.downloadPath: null,
  SettingKeys.waitForSync: true,
  SettingKeys.progressPerChapter: false,
  SettingKeys.shakeToResetSleepTimer: false,
  SettingKeys.shakeToRewind: true,
  SettingKeys.shakeSensitivity: 2.0,
  SettingKeys.shakeVibrate: true,
  SettingKeys.fastForwardInterval: 10,
  SettingKeys.rewindInterval: 10,

  SettingKeys.caching: true,
  SettingKeys.aggressiveCaching: false,
  SettingKeys.boostLoading: true,

  SettingKeys.playbackSpeed: 1.0,
  SettingKeys.volume: 1.0,
};

enum AppThemeMode { light, dark, system }
