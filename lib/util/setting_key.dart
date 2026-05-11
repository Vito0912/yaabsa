import 'package:yaabsa/util/logger.dart';

class SettingKeys {
  // Global Settings
  static const String appThemeMode = 'app_theme_mode';
  static const String appThemePreset = 'app_theme_preset';
  static const String appThemeCustomRed = 'app_theme_custom_red';
  static const String appThemeCustomGreen = 'app_theme_custom_green';
  static const String appThemeCustomBlue = 'app_theme_custom_blue';
  static const String currentUserId = 'current_user_id';
  static const String appLogLevel = 'app_log_level';
  static const String bufferSize = 'buffer_size';
  static const String keepScreenOn = 'keep_screen_on';
  static const String lockMediaNotification = 'lock_media_notification';
  static const String showNotificationMoreButton = 'show_notification_more_button';
  static const String autoPlayLastPlayedOnLaunch = 'auto_play_last_played_on_launch';
  static const String language = 'language';
  static const String sidebarCollapsed = 'sidebar_collapsed';
  static const String autoQueue = 'auto_queue';
  static const String autoQueueIncludeSeriesOutsideContext = 'auto_queue_include_series_outside_context';
  static const String sleepTimerExpireAction = 'sleep_timer_expire_action';
  static const String sleepTimerAutoRewindMinutes = 'sleep_timer_auto_rewind_minutes';
  static const String sleepTimerAutoRestartEnabled = 'sleep_timer_auto_restart_enabled';
  static const String sleepTimerAutoRestartUseTimeRange = 'sleep_timer_auto_restart_use_time_range';
  static const String sleepTimerAutoRestartRangeStartMinutes = 'sleep_timer_auto_restart_range_start_minutes';
  static const String sleepTimerAutoRestartRangeEndMinutes = 'sleep_timer_auto_restart_range_end_minutes';
  static const String sleepTimerLastDurationMinutes = 'sleep_timer_last_duration_minutes';
  static const String sleepTimerAutoRestartSuppressed = 'sleep_timer_auto_restart_suppressed';
  static const String smartRewindEnabled = 'smart_rewind_enabled';
  static const String smartRewindShortPauseThresholdSeconds = 'smart_rewind_short_pause_threshold_seconds';
  static const String smartRewindLongPauseThresholdSeconds = 'smart_rewind_long_pause_threshold_seconds';
  static const String smartRewindShortRewindSeconds = 'smart_rewind_short_rewind_seconds';
  static const String smartRewindMediumRewindSeconds = 'smart_rewind_medium_rewind_seconds';
  static const String smartRewindLongRewindSeconds = 'smart_rewind_long_rewind_seconds';

  // User-Specific Settings
  static const String syncInterval = 'sync_interval';
  static const String syncOnlyOnWifi = 'sync_only_on_wifi';
  static const String sortSeriesAscending = 'sort_series_ascending';
  static const String collapseSeries = 'collapse_series';
  static const String downloadPath = 'download_path';
  static const String androidAutoLibrarySortDescending = 'android_auto_library_sort_descending';
  static const String androidAutoLibrarySortField = 'android_auto_library_sort_field';
  static const String androidAutoPodcastSortDescending = 'android_auto_podcast_sort_descending';
  static const String androidAutoPodcastSortField = 'android_auto_podcast_sort_field';
  static const String androidAutoGroupByLetters = 'android_auto_group_by_letters';
  static const String personalizedShelfShowPlayVisibleButton = 'personalized_shelf_show_play_visible_button';
  static const String waitForSync = 'wait_for_sync';
  static const String progressPerChapter = 'progress_per_chapter';
  static const String shakeToResetSleepTimer = 'shake_to_reset_sleep_timer';
  static const String shakeToRewind = 'shake_to_rewind';
  static const String shakeSensitivity = 'shake_sensitivity';
  static const String shakeVibrate = 'shake_vibrate';

  static const String fastForwardInterval = 'fast_forward_interval';
  static const String rewindInterval = 'rewind_interval';

  static const String caching = 'caching';
  static const String boostLoading = 'boost_loading';
  static const String cacheRouteLibraries = 'cache_route_libraries';
  static const String cacheRouteLibraryById = 'cache_route_library_by_id';
  static const String cacheRouteLibraryItems = 'cache_route_library_items';
  static const String cacheRouteItemById = 'cache_route_item_by_id';
  static const String cacheRouteItemChild = 'cache_route_item_child';
  static const String cacheRouteLibraryFilterData = 'cache_route_library_filter_data';
  static const String cacheRouteLibrarySeries = 'cache_route_library_series';
  static const String cacheRoutePlaylists = 'cache_route_playlists';
  static const String cacheRouteCollections = 'cache_route_collections';
  static const String cacheRouteMe = 'cache_route_me';

  static const String playbackSpeed = 'playback_speed';
  static const String volume = 'volume';
  static const String playerSeekBarMode = 'player_seek_bar_mode';
  static const String playerSeekBarMarkerMode = 'player_seek_bar_marker_mode';
  static const String playerSeekBarShowChapterMarkers = 'player_seek_bar_show_chapter_markers';
  static const String playerLayoutConfig = 'player_layout_config';
  static const String lastPlayedQueueItem = 'last_played_queue_item';

  static const String subtitlesEnabled = 'subtitles_enabled';
  static const String subtitleSpeakerHighlighting = 'subtitle_speaker_highlighting';
  static const String subtitleReadAlong = 'subtitle_read_along';
}

final defaultSettings = {
  SettingKeys.appThemeMode: AppThemeMode.dark.toString(),
  SettingKeys.appThemePreset: AppThemePreset.yaabsa.toString(),
  SettingKeys.appThemeCustomRed: 15,
  SettingKeys.appThemeCustomGreen: 118,
  SettingKeys.appThemeCustomBlue: 110,
  SettingKeys.currentUserId: null,
  SettingKeys.appLogLevel: InfoLevel.warning.toString(),
  SettingKeys.bufferSize: 5 * 1024 * 1024,
  SettingKeys.lockMediaNotification: false,
  SettingKeys.showNotificationMoreButton: false,
  SettingKeys.autoPlayLastPlayedOnLaunch: false,
  SettingKeys.keepScreenOn: false,
  SettingKeys.language: 'en-US',
  SettingKeys.sidebarCollapsed: false,
  SettingKeys.autoQueue: true,
  SettingKeys.autoQueueIncludeSeriesOutsideContext: false,
  SettingKeys.sleepTimerExpireAction: SleepTimerExpireAction.stop.name,
  SettingKeys.sleepTimerAutoRewindMinutes: 0,
  SettingKeys.sleepTimerAutoRestartEnabled: false,
  SettingKeys.sleepTimerAutoRestartUseTimeRange: false,
  SettingKeys.sleepTimerAutoRestartRangeStartMinutes: 21 * 60,
  SettingKeys.sleepTimerAutoRestartRangeEndMinutes: 7 * 60,
  SettingKeys.sleepTimerLastDurationMinutes: 30,
  SettingKeys.sleepTimerAutoRestartSuppressed: false,
  SettingKeys.smartRewindEnabled: false,
  SettingKeys.smartRewindShortPauseThresholdSeconds: 60,
  SettingKeys.smartRewindLongPauseThresholdSeconds: 900,
  SettingKeys.smartRewindShortRewindSeconds: 5,
  SettingKeys.smartRewindMediumRewindSeconds: 30,
  SettingKeys.smartRewindLongRewindSeconds: 60,

  SettingKeys.syncInterval: 10,
  SettingKeys.syncOnlyOnWifi: false,
  SettingKeys.sortSeriesAscending: false,
  SettingKeys.collapseSeries: false,
  SettingKeys.downloadPath: null,
  SettingKeys.androidAutoLibrarySortDescending: false,
  SettingKeys.androidAutoLibrarySortField: 'title',
  SettingKeys.androidAutoPodcastSortDescending: true,
  SettingKeys.androidAutoPodcastSortField: 'added',
  SettingKeys.androidAutoGroupByLetters: true,
  SettingKeys.personalizedShelfShowPlayVisibleButton: false,
  SettingKeys.waitForSync: true,
  SettingKeys.progressPerChapter: false,
  SettingKeys.shakeToResetSleepTimer: false,
  SettingKeys.shakeToRewind: false,
  SettingKeys.shakeSensitivity: 2.0,
  SettingKeys.shakeVibrate: true,
  SettingKeys.fastForwardInterval: 10,
  SettingKeys.rewindInterval: 10,

  SettingKeys.caching: true,
  SettingKeys.boostLoading: true,
  SettingKeys.cacheRouteLibraries: true,
  SettingKeys.cacheRouteLibraryById: true,
  SettingKeys.cacheRouteLibraryItems: true,
  SettingKeys.cacheRouteItemById: true,
  SettingKeys.cacheRouteItemChild: true,
  SettingKeys.cacheRouteLibraryFilterData: true,
  SettingKeys.cacheRouteLibrarySeries: true,
  SettingKeys.cacheRoutePlaylists: true,
  SettingKeys.cacheRouteCollections: true,
  SettingKeys.cacheRouteMe: false,

  SettingKeys.playbackSpeed: 1.0,
  SettingKeys.volume: 1.0,
  SettingKeys.playerSeekBarMode: PlayerSeekBarMode.full.name,
  SettingKeys.playerSeekBarMarkerMode: SeekBarMarkerMode.both.name,
  SettingKeys.playerSeekBarShowChapterMarkers: true,
  SettingKeys.playerLayoutConfig: '',
  SettingKeys.subtitlesEnabled: true,
  SettingKeys.subtitleSpeakerHighlighting: true,
  SettingKeys.subtitleReadAlong: true,
};

enum AppThemeMode {
  light,
  dark,
  amoled,
  system;

  static AppThemeMode fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppThemeMode.dark;
    }

    final normalized = value.trim().toLowerCase();

    for (final mode in AppThemeMode.values) {
      if (mode.name == normalized || 'appthememode.${mode.name}' == normalized) {
        return mode;
      }
    }

    return AppThemeMode.dark;
  }

  String get label {
    switch (this) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.amoled:
        return 'AMOLED';
      case AppThemeMode.system:
        return 'System';
    }
  }
}

enum AppThemePreset {
  yaabsa,
  ember,
  moss,
  cobalt,
  rose,
  custom;

  static AppThemePreset fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppThemePreset.yaabsa;
    }

    final normalized = value.trim().toLowerCase();

    if (normalized == 'amoled' || normalized == 'appthemepreset.amoled') {
      // Keep old stored AMOLED preset values functional by falling back to the default preset.
      return AppThemePreset.yaabsa;
    }

    for (final preset in AppThemePreset.values) {
      if (preset.name == normalized || 'appthemepreset.${preset.name}' == normalized) {
        return preset;
      }
    }

    return AppThemePreset.yaabsa;
  }

  String get label {
    switch (this) {
      case AppThemePreset.yaabsa:
        return 'Yaabsa';
      case AppThemePreset.ember:
        return 'Ember';
      case AppThemePreset.moss:
        return 'Moss';
      case AppThemePreset.cobalt:
        return 'Cobalt';
      case AppThemePreset.rose:
        return 'Rose';
      case AppThemePreset.custom:
        return 'Custom';
    }
  }

  String get description {
    switch (this) {
      case AppThemePreset.yaabsa:
        return 'Balanced teal accent with soft contrast.';
      case AppThemePreset.ember:
        return 'Warm orange highlights and energetic surfaces.';
      case AppThemePreset.moss:
        return 'Natural green tones with a calmer look.';
      case AppThemePreset.cobalt:
        return 'Cool blue accents with a crisp interface feel.';
      case AppThemePreset.rose:
        return 'Rosy highlights with a softer modern touch.';
      case AppThemePreset.custom:
        return 'Build your own color profile.';
    }
  }
}

enum SleepTimerExpireAction {
  stop,
  pause;

  static SleepTimerExpireAction fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return SleepTimerExpireAction.stop;
    }

    final normalized = value.trim().toLowerCase();

    for (final action in SleepTimerExpireAction.values) {
      if (action.name == normalized) {
        return action;
      }
    }

    if (normalized.startsWith('sleeptimerexpireaction.')) {
      final suffix = normalized.split('.').last;
      for (final action in SleepTimerExpireAction.values) {
        if (action.name == suffix) {
          return action;
        }
      }
    }

    return SleepTimerExpireAction.stop;
  }

  String get label {
    switch (this) {
      case SleepTimerExpireAction.stop:
        return 'Stop playback';
      case SleepTimerExpireAction.pause:
        return 'Pause playback';
    }
  }
}

enum PlayerSeekBarMode {
  chapter,
  full,
  both;

  static PlayerSeekBarMode fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PlayerSeekBarMode.full;
    }

    final normalized = value.trim().toLowerCase();

    for (final mode in PlayerSeekBarMode.values) {
      if (mode.name == normalized) {
        return mode;
      }
    }

    if (normalized.startsWith('playerseekbarmode.')) {
      final suffix = normalized.split('.').last;
      for (final mode in PlayerSeekBarMode.values) {
        if (mode.name == suffix) {
          return mode;
        }
      }
    }

    for (final mode in PlayerSeekBarMode.values) {
      if (mode.label.toLowerCase() == normalized) {
        return mode;
      }
    }

    for (final mode in PlayerSeekBarMode.values) {
      if (mode.name == value) {
        return mode;
      }
    }
    return PlayerSeekBarMode.full;
  }

  String get label {
    switch (this) {
      case PlayerSeekBarMode.chapter:
        return 'Chapter';
      case PlayerSeekBarMode.full:
        return 'Full';
      case PlayerSeekBarMode.both:
        return 'Both';
    }
  }
}

enum SeekBarMarkerMode {
  none,
  chapters,
  bookmarks,
  both;

  static SeekBarMarkerMode fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return SeekBarMarkerMode.both;
    }

    final normalized = value.trim().toLowerCase();

    for (final mode in SeekBarMarkerMode.values) {
      if (mode.name == normalized) {
        return mode;
      }
    }

    if (normalized.startsWith('seekbarmarkermode.')) {
      final suffix = normalized.split('.').last;
      for (final mode in SeekBarMarkerMode.values) {
        if (mode.name == suffix) {
          return mode;
        }
      }
    }

    if (normalized == 'true') {
      return SeekBarMarkerMode.chapters;
    }
    if (normalized == 'false') {
      return SeekBarMarkerMode.none;
    }

    for (final mode in SeekBarMarkerMode.values) {
      if (mode.label.toLowerCase() == normalized) {
        return mode;
      }
    }

    return SeekBarMarkerMode.both;
  }

  bool get showChapterMarkers {
    return this == SeekBarMarkerMode.chapters || this == SeekBarMarkerMode.both;
  }

  bool get showBookmarks {
    return this == SeekBarMarkerMode.bookmarks || this == SeekBarMarkerMode.both;
  }

  String get label {
    switch (this) {
      case SeekBarMarkerMode.none:
        return 'None';
      case SeekBarMarkerMode.chapters:
        return 'Only chapters';
      case SeekBarMarkerMode.bookmarks:
        return 'Only bookmarks';
      case SeekBarMarkerMode.both:
        return 'Bookmarks and chapters';
    }
  }
}
