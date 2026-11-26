import 'package:yaabsa/features/settings/model/account_setting_definitions.dart';
import 'package:yaabsa/features/settings/model/app_setting_definitions.dart';
import 'package:yaabsa/features/settings/model/player_setting_definitions.dart';

export 'package:yaabsa/features/settings/model/account_setting_definitions.dart';
export 'package:yaabsa/features/settings/model/app_setting_definitions.dart';
export 'package:yaabsa/features/settings/model/player_setting_definitions.dart';

class AppSettingDefs {
  const AppSettingDefs._();

  static const libraryGridScale = AccountSettingDefs.libraryGridScale;
  static const collapseSeries = AccountSettingDefs.collapseSeries;
  static const refreshProgressOnAppResume = AccountSettingDefs.refreshProgressOnAppResume;
  static const personalizedShelfShowPlayVisibleButton = AccountSettingDefs.personalizedShelfShowPlayVisibleButton;
  static const showShuffleButton = AccountSettingDefs.showShuffleButton;

  static const androidAutoGroupByLetters = AccountSettingDefs.androidAutoGroupByLetters;
  static const androidAutoLibrarySortDescending = AccountSettingDefs.androidAutoLibrarySortDescending;
  static const androidAutoLibrarySortField = AccountSettingDefs.androidAutoLibrarySortField;
  static const androidAutoPodcastSortDescending = AccountSettingDefs.androidAutoPodcastSortDescending;
  static const androidAutoPodcastSortField = AccountSettingDefs.androidAutoPodcastSortField;

  static const serverManagementCollections = AccountSettingDefs.serverManagementCollections;
  static const serverManagementEditItems = AccountSettingDefs.serverManagementEditItems;
  static const serverManagementDeleteItems = AccountSettingDefs.serverManagementDeleteItems;
  static const serverManagementEditChapters = AccountSettingDefs.serverManagementEditChapters;
  static const serverManagementUploadItems = AccountSettingDefs.serverManagementUploadItems;
  static const serverManagementAllowMatchesQuickMatches = AccountSettingDefs.serverManagementAllowMatchesQuickMatches;
  static const toolsRemoveAuthorsWithoutBooks = AccountSettingDefs.toolsRemoveAuthorsWithoutBooks;
  static const toolsForceMetadataRefresh = AccountSettingDefs.toolsForceMetadataRefresh;
  static const toolsMatchAudiobookChapters = AccountSettingDefs.toolsMatchAudiobookChapters;
  static const toolsSplitGenresTags = AccountSettingDefs.toolsSplitGenresTags;
  static const toolsRenameSeries = AccountSettingDefs.toolsRenameSeries;
  static const toolsDeleteLongListeningSessions = AccountSettingDefs.toolsDeleteLongListeningSessions;

  static const playerSeekBarMode = PlayerSettingDefs.playerSeekBarMode;
  static const playerSeekBarMarkerMode = PlayerSettingDefs.playerSeekBarMarkerMode;
  static const fullPlayerTransportMode = PlayerSettingDefs.fullPlayerTransportMode;
  static const mobilePlayerLeftAction = PlayerSettingDefs.mobilePlayerLeftAction;
  static const mobilePlayerRightAction = PlayerSettingDefs.mobilePlayerRightAction;
  static const miniPlayerTransportMode = PlayerSettingDefs.miniPlayerTransportMode;
  static const fastForwardInterval = PlayerSettingDefs.fastForwardInterval;
  static const rewindInterval = PlayerSettingDefs.rewindInterval;
  static const playbackSpeedPerBook = PlayerSettingDefs.playbackSpeedPerBook;
  static const startPlaybackFromLocalProgress = PlayerSettingDefs.startPlaybackFromLocalProgress;
  static const restartListeningSessionAtMidnight = PlayerSettingDefs.restartListeningSessionAtMidnight;
  static const desktopSkipControlsSeek = PlayerSettingDefs.desktopSkipControlsSeek;
  static const preventWordClipping = PlayerSettingDefs.preventWordClipping;
  static const skipSilence = PlayerSettingDefs.skipSilence;
  static const autoQueue = PlayerSettingDefs.autoQueue;
  static const autoQueueIncludeSeriesOutsideContext = PlayerSettingDefs.autoQueueIncludeSeriesOutsideContext;
  static const showPlayerLoopShuffle = PlayerSettingDefs.showPlayerLoopShuffle;
  static const autoResumeOnBluetoothConnection = PlayerSettingDefs.autoResumeOnBluetoothConnection;
  static const restrictAutoResumeToSelectedBluetoothDevices =
      PlayerSettingDefs.restrictAutoResumeToSelectedBluetoothDevices;
  static const autoResumeBluetoothDeviceAddresses = PlayerSettingDefs.autoResumeBluetoothDeviceAddresses;
  static const playerLayoutMode = PlayerSettingDefs.playerLayoutMode;
  static const playerLayoutModeExplicit = PlayerSettingDefs.playerLayoutModeExplicit;
  static const playerLayoutConfig = PlayerSettingDefs.playerLayoutConfig;
  static const playerAdaptivePreset = PlayerSettingDefs.playerAdaptivePreset;
  static const playerCoverSize = PlayerSettingDefs.playerCoverSize;
  static const playerImmersiveColors = PlayerSettingDefs.playerImmersiveColors;
  static const audioAnnouncementMode = PlayerSettingDefs.audioAnnouncementMode;

  static const bufferSize = PlayerSettingDefs.bufferSize;
  static final keepScreenOn = PlayerSettingDefs.keepScreenOn;
  static const autoPlayLastPlayedOnLaunch = PlayerSettingDefs.autoPlayLastPlayedOnLaunch;
  static const showLastPlayedMiniPlayerAlways = PlayerSettingDefs.showLastPlayedMiniPlayerAlways;
  static final keepWebsocketConnectionInBackground = PlayerSettingDefs.keepWebsocketConnectionInBackground;
  static const lockMediaNotification = PlayerSettingDefs.lockMediaNotification;
  static const mediaNotificationType = PlayerSettingDefs.mediaNotificationType;

  static const smartRewindEnabled = PlayerSettingDefs.smartRewindEnabled;
  static const smartRewindShortPauseThresholdSeconds = PlayerSettingDefs.smartRewindShortPauseThresholdSeconds;
  static const smartRewindLongPauseThresholdSeconds = PlayerSettingDefs.smartRewindLongPauseThresholdSeconds;
  static const smartRewindShortRewindSeconds = PlayerSettingDefs.smartRewindShortRewindSeconds;
  static const smartRewindMediumRewindSeconds = PlayerSettingDefs.smartRewindMediumRewindSeconds;
  static const smartRewindLongRewindSeconds = PlayerSettingDefs.smartRewindLongRewindSeconds;

  static const sleepTimerExpireAction = PlayerSettingDefs.sleepTimerExpireAction;
  static const sleepTimerAutoRewindMinutes = PlayerSettingDefs.sleepTimerAutoRewindMinutes;
  static const sleepTimerFadeOutEnabled = PlayerSettingDefs.sleepTimerFadeOutEnabled;
  static const sleepTimerShowMarker = PlayerSettingDefs.sleepTimerShowMarker;
  static const sleepTimerAutoRestartEnabled = PlayerSettingDefs.sleepTimerAutoRestartEnabled;
  static const sleepTimerAutoMode = PlayerSettingDefs.sleepTimerAutoMode;
  static const sleepTimerAutoMinutes = PlayerSettingDefs.sleepTimerAutoMinutes;
  static const sleepTimerAutoChapters = PlayerSettingDefs.sleepTimerAutoChapters;
  static const sleepTimerLastDurationMinutes = PlayerSettingDefs.sleepTimerLastDurationMinutes;
  static const sleepTimerAutoRestartUseTimeRange = PlayerSettingDefs.sleepTimerAutoRestartUseTimeRange;
  static const sleepTimerAutoRestartRangeStartMinutes = PlayerSettingDefs.sleepTimerAutoRestartRangeStartMinutes;
  static const sleepTimerAutoRestartRangeEndMinutes = PlayerSettingDefs.sleepTimerAutoRestartRangeEndMinutes;

  static const subtitlesEnabled = PlayerSettingDefs.subtitlesEnabled;
  static const subtitleSpeakerHighlighting = PlayerSettingDefs.subtitleSpeakerHighlighting;
  static const subtitleReadAlong = PlayerSettingDefs.subtitleReadAlong;

  static const shakeToResetSleepTimer = PlayerSettingDefs.shakeToResetSleepTimer;
  static const shakeToRewind = PlayerSettingDefs.shakeToRewind;
  static const shakeSensitivity = PlayerSettingDefs.shakeSensitivity;
  static const shakeVibrate = PlayerSettingDefs.shakeVibrate;

  static const disableFdkAacDecoder = PlayerSettingDefs.disableFdkAacDecoder;
  static const enableIndexSeeking = PlayerSettingDefs.enableIndexSeeking;

  static const readerFontFamily = AppSystemSettingDefs.readerFontFamily;
  static const readerFontSizeMultiplier = AppSystemSettingDefs.readerFontSizeMultiplier;
  static const readerLineHeight = AppSystemSettingDefs.readerLineHeight;
  static const readerPageMargin = AppSystemSettingDefs.readerPageMargin;
  static const readerPageWidth = AppSystemSettingDefs.readerPageWidth;
  static const readerTextAlignment = AppSystemSettingDefs.readerTextAlignment;
  static const readerLetterSpacing = AppSystemSettingDefs.readerLetterSpacing;
  static const readerLayout = AppSystemSettingDefs.readerLayout;
  static const readerHideMiniPlayer = AppSystemSettingDefs.readerHideMiniPlayer;
  static const readerStartSession = AppSystemSettingDefs.readerStartSession;

  static const language = AppSystemSettingDefs.language;
  static const caching = AppSystemSettingDefs.caching;
  static const boostLoading = AppSystemSettingDefs.boostLoading;
  static const checkForAppUpdates = AppSystemSettingDefs.checkForAppUpdates;
  static const checkForServerUpdates = AppSystemSettingDefs.checkForServerUpdates;
}
