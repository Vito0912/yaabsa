class SettingsRoutes {
  const SettingsRoutes._();

  static const String root = '/settings';

  // Account
  static const String library = '/settings/library';
  static const String libraryOrder = '/settings/library/order';
  static const String libraryViews = '/settings/library/views';
  static const String libraryShelf = '/settings/library/shelf';
  static const String libraryViewSubtitles = '/settings/library/view-subtitles';
  static const String downloads = '/settings/downloads';
  static const String smartDownloads = '/settings/library/smart-downloads';
  static const String androidAuto = '/settings/android-auto';
  static const String androidAutoLibrary = '/settings/android-auto/library';
  static const String androidAutoPodcastLibrary = '/settings/android-auto/podcast-library';

  // Server
  static const String serverConnection = '/settings/server-connection';
  static const String serverManagement = '/settings/server-management';
  static const String tools = '/settings/tools';
  static const String toolsPathTagGenreUpdate = '/settings/tools/path-tag-genre-update';
  static const String toolsForceMetadataRefresh = '/settings/tools/force-metadata-refresh';
  static const String toolsMatchAudiobookChapters = '/settings/tools/match-audiobook-chapters';
  static const String adminServer = '/settings/admin-server';
  static const String adminServerConfiguration = '/settings/admin-server/configuration';
  static const String adminServerLibraries = '/settings/admin-server/libraries';
  static const String adminServerLogs = '/settings/admin-server/logs';
  static const String adminServerBackups = '/settings/admin-server/backups';
  static const String adminServerUsers = '/settings/admin-server/users';
  static const String adminServerApiKeys = '/settings/admin-server/api-keys';
  static const String adminServerSessions = '/settings/admin-server/sessions';
  static const String adminServerRssFeeds = '/settings/admin-server/rss-feeds';
  static const String adminServerEmail = '/settings/admin-server/email';
  static const String adminServerAuthentication = '/settings/admin-server/authentication';
  static const String adminItemMetadataUtils = '/settings/admin-server/item-metadata-utils';
  static const String adminServerLibraryStats = '/settings/admin-server/library-stats';

  // Playback & Reader
  static const String player = '/settings/player';
  static const String playerGeneral = '/settings/player/general';
  static const String playerStartupBackground = '/settings/player/startup-background';
  static const String legacyGlobalPlayer = '/settings/global-player';
  static const String playerNotifications = '/settings/player/notifications';
  static const String playerNotificationActions = '/settings/player/notification';
  static const String playerSmartRewind = '/settings/player/smart-rewind';
  static const String playerSleepTimer = '/settings/player/sleep-timer';
  static const String playerSubtitles = '/settings/player/subtitles';
  static const String playerEqualizer = '/settings/player/equalizer';
  static const String playerShakeControls = '/settings/player/shake-controls';
  static const String playerCompatibility = '/settings/player/compatibility';
  static const String reader = '/settings/reader';
  static const String readerTts = '/settings/reader/tts';

  // App & System
  static const String appearance = '/settings/appearance';
  static const String theme = '/settings/appearance/theme';
  static const String caching = '/settings/caching';
  static const String legacyCachingGeneral = '/settings/caching/general';
  static const String cachingRoutes = '/settings/caching/routes';
  static const String backup = '/settings/backup';
  static const String updates = '/settings/updates';
  static const String logs = '/settings/logs';
  static const String about = '/settings/about';
}
