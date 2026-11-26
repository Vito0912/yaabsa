// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionClose => 'Close';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionRetry => 'Retry';

  @override
  String get actionOk => 'OK';

  @override
  String get settingsAppearanceTitle => 'Appearance settings';

  @override
  String get settingsDisplayTitle => 'Display';

  @override
  String get themeSettingsTitle => 'Theme';

  @override
  String get themeSettingsSubtitle => 'Theme mode, preset palette, and custom accent color';

  @override
  String get navigationSettingsTitle => 'Navigation';

  @override
  String get navigationSettingsSubtitle => 'Configure displayed tabs, their order, and the default view';

  @override
  String get settingsOtherTitle => 'Other';

  @override
  String get fieldLanguage => 'Language';

  @override
  String get fieldNote => 'Note';

  @override
  String get optionSystemDefault => 'System default';

  @override
  String get fieldModel => 'Model';

  @override
  String get fieldVoice => 'Voice';

  @override
  String get fieldVoiceId => 'Voice ID';

  @override
  String get actionShow => 'Show';

  @override
  String get actionHide => 'Hide';

  @override
  String get localeEnglishName => 'English';

  @override
  String get localeGermanName => 'German';

  @override
  String get startupAudioServiceStatus => 'Starting audio service…';

  @override
  String get startupUnableToStartTitle => 'Unable to start yaabsa';

  @override
  String get startupAudioServiceError => 'The audio service could not start. Close and restart the app';

  @override
  String get byteUnitBytes => 'B';

  @override
  String get byteUnitKilobytes => 'KB';

  @override
  String get byteUnitMegabytes => 'MB';

  @override
  String get byteUnitGigabytes => 'GB';

  @override
  String get byteUnitTerabytes => 'TB';

  @override
  String byteSize(String value, String unit) {
    return '$value $unit';
  }

  @override
  String byteTransferProgress(String transferred, String total) {
    return '$transferred / $total';
  }

  @override
  String durationHours(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString hr', one: '$countString hr');
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString min',
      one: '$countString min',
    );
    return '$_temp0';
  }

  @override
  String durationSeconds(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString sec',
      one: '$countString sec',
    );
    return '$_temp0';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    final intl.NumberFormat hoursNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);
    final intl.NumberFormat minutesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    String _temp0 = intl.Intl.pluralLogic(hours, locale: localeName, other: '$hoursString hr', one: '$hoursString hr');
    String _temp1 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutesString min',
      one: '$minutesString min',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String bookCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString books', one: '1 book');
    return '$_temp0';
  }

  @override
  String seriesCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString series', one: '1 series');
    return '$_temp0';
  }

  @override
  String get statusNoBooksForAuthor => 'No books found for this author';

  @override
  String trackCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString tracks', one: '1 track');
    return '$_temp0';
  }

  @override
  String episodeCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString episodes', one: '1 episode');
    return '$_temp0';
  }

  @override
  String get libraryItems => 'Library items';

  @override
  String get navSeries => 'Series';

  @override
  String get navAuthors => 'Authors';

  @override
  String get optionAutomatic => 'Automatic';

  @override
  String get optionHidden => 'Hidden';

  @override
  String get librarySubtitleModeChooseFields => 'Choose fields';

  @override
  String get librarySubtitleModeAutomaticDescription => 'Shows information based on the current sort';

  @override
  String get librarySubtitleModeHiddenDescription => 'Hides subtitle information';

  @override
  String get librarySubtitleModeChooseFieldsDescription =>
      'Choose up to three details to show below library items, series, or authors';

  @override
  String get fieldAuthor => 'Author';

  @override
  String get fieldDuration => 'Duration';

  @override
  String get fieldSize => 'Size';

  @override
  String get fieldTracks => 'Tracks';

  @override
  String get fieldAddedDate => 'Added date';

  @override
  String get fieldPublishedYear => 'Published year';

  @override
  String get fieldNarrator => 'Narrator';

  @override
  String get fieldFileBirthDate => 'File birth date';

  @override
  String get fieldFileModifiedDate => 'File modified date';

  @override
  String get fieldBooks => 'Books';

  @override
  String get fieldTotalDuration => 'Total duration';

  @override
  String get fieldUpdatedDate => 'Updated date';

  @override
  String get dateAdded => 'Added';

  @override
  String get dateModified => 'Modified';

  @override
  String get dateUpdated => 'Updated';

  @override
  String get dateToday => 'Today';

  @override
  String get dateYesterday => 'Yesterday';

  @override
  String get playbackTitle => 'Playback';

  @override
  String get playbackPause => 'Pause';

  @override
  String get playbackPlay => 'Play';

  @override
  String get playbackStop => 'Stop';

  @override
  String get playbackNext => 'Next';

  @override
  String get playbackPrevious => 'Previous';

  @override
  String get playbackFastForward => 'Fast forward';

  @override
  String get playbackRewind => 'Rewind';

  @override
  String get playbackPlayLastPlayed => 'Play last played';

  @override
  String get trayQuitApp => 'Exit app';

  @override
  String get aaosInactiveStatus => 'Android Automotive integration is inactive';

  @override
  String get aaosAndroidOnlyStatus => 'Android Automotive is only available on Android';

  @override
  String get aaosDetectedStatus => 'Android Automotive OS detected';

  @override
  String get aaosNotDetectedStatus => 'Android Automotive OS not detected on this device';

  @override
  String get downloadLocationDefault => 'Default location';

  @override
  String get downloadLocationUnsupportedWeb => 'Not supported on Web';

  @override
  String downloadLocationSystemDownloads(String path) {
    return 'System Downloads ($path)';
  }

  @override
  String get downloadLocationDocumentsFallback => 'App documents folder (fallback)';

  @override
  String get downloadLocationPrivateDocuments => 'App documents folder (private app storage)';

  @override
  String get downloadLocationSandboxedDocuments => 'App documents folder (sandboxed by OS)';

  @override
  String get downloadLocationAppDocuments => 'App documents folder';

  @override
  String get downloadNotSupportedWeb => 'Downloads are not supported on Web';

  @override
  String get downloadLocationUnavailableAndroid =>
      'The selected Android folder is no longer accessible. Choose it again';

  @override
  String get downloadLocationMustBeLocal => 'The download location must be a local folder on this platform';

  @override
  String get changelogUpdates => 'Updates';

  @override
  String get playbackPlayFromHere => 'Play from here';

  @override
  String get shelfContinueListening => 'Continue listening';

  @override
  String get navLibraries => 'Libraries';

  @override
  String get navDownloads => 'Downloads';

  @override
  String get actionMore => 'More';

  @override
  String get downloadedMedia => 'Downloaded media';

  @override
  String get untitledEpisode => 'Untitled episode';

  @override
  String get statusUnableToLoadRetry => 'Unable to load. Select to retry';

  @override
  String get statusMayTakeTimeToLoad => 'This can take a while to load';

  @override
  String get statusLoadingContent => 'Loading content';

  @override
  String get statusLoadingLibrary => 'Loading your library';

  @override
  String get errorBrowseNotReady => 'Android Automotive browse is not ready';

  @override
  String get errorAuthenticationRequired => 'Authentication required';

  @override
  String get errorNoContentSignedOut => 'No content is available while signed out';

  @override
  String get authSignInThroughSettings => 'Sign in through settings';

  @override
  String get errorAndroidAutoConnectionRequired => 'Connect to Android Auto to browse';

  @override
  String itemCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString items', one: '1 item');
    return '$_temp0';
  }

  @override
  String get filterAll => 'All';

  @override
  String get shelfRecentlyAdded => 'Recently added';

  @override
  String get shelfLatestEpisodes => 'Latest episodes';

  @override
  String get navCollections => 'Collections';

  @override
  String get navPlaylists => 'Playlists';

  @override
  String get navDiscovery => 'Discovery';

  @override
  String get shelfContinueSeries => 'Continue series';

  @override
  String get navNarrators => 'Narrators';

  @override
  String listRangeTitle(String listName, int start, int end) {
    final intl.NumberFormat startNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String startString = startNumberFormat.format(start);
    final intl.NumberFormat endNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String endString = endNumberFormat.format(end);

    return '$listName $startString to $endString';
  }

  @override
  String get statusDownloaded => 'Downloaded';

  @override
  String get readerReadAloud => 'Read aloud';

  @override
  String get readerBookNarration => 'Book narration';

  @override
  String get playbackNextChapter => 'Next chapter';

  @override
  String get playbackPreviousChapter => 'Previous chapter';

  @override
  String transferRatePerSecond(String rate) {
    return '$rate/s';
  }

  @override
  String durationCompactHours(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '${countString}h';
  }

  @override
  String durationCompactMinutes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '${countString}m';
  }

  @override
  String durationCompactSeconds(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '${countString}s';
  }

  @override
  String durationCompactHoursMinutes(int hours, int minutes) {
    final intl.NumberFormat hoursNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);
    final intl.NumberFormat minutesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '${hoursString}h ${minutesString}m';
  }

  @override
  String durationCompactMinutesSeconds(int minutes, int seconds) {
    final intl.NumberFormat minutesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);
    final intl.NumberFormat secondsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return '${minutesString}m ${secondsString}s';
  }

  @override
  String readerReadAloudEstimatedTime(String time) {
    return 'Read aloud · $time remaining';
  }

  @override
  String get homeShelf => 'Shelf';

  @override
  String get mediaTypeAudiobook => 'Audiobook';

  @override
  String get mediaTypePodcast => 'Podcast';

  @override
  String get shelfContinueReading => 'Continue reading';

  @override
  String get shelfPinned => 'Pinned';

  @override
  String get shelfListenAgain => 'Listen again';

  @override
  String get shelfDiscover => 'Discover';

  @override
  String get shelfRecentlyAddedSeries => 'Recently added series';

  @override
  String get shelfRecentlyAddedAuthors => 'Recently added authors';

  @override
  String get sleepTimerStopPlayback => 'Stop playback';

  @override
  String get seekBarMarkersChapters => 'Only chapters';

  @override
  String get seekBarMarkersBookmarks => 'Only bookmarks';

  @override
  String get seekBarMarkersBoth => 'Bookmarks and chapters';

  @override
  String get liveUpdateCurrentTime => 'Show current time';

  @override
  String get liveUpdateRemainingTime => 'Show remaining time';

  @override
  String get liveUpdateSleepTimer => 'Show sleep timer';

  @override
  String get liveUpdateProgressPercentage => 'Show progress percentage';

  @override
  String get readerDeviceVoices => 'Device voices';

  @override
  String get validationRequestHeadersRequired => 'Header name and value are required';

  @override
  String get validationRequestHeadersInvalid => 'Enter a valid header name and value';

  @override
  String get actionAdd => 'Add';

  @override
  String get navLibrary => 'Library';

  @override
  String get statusDownloadComplete => 'Download complete';

  @override
  String get statusDownloadCanceled => 'Download canceled';

  @override
  String get statusDownloadFailed => 'Download failed';

  @override
  String get statusDownloadPaused => 'Download paused';

  @override
  String get errorNotificationsPermissionRequired => 'Allow notifications to download files in the background';

  @override
  String get errorDownloadsUnavailableWeb => 'Downloads are not supported on the web';

  @override
  String get errorUserRequired => 'Sign in before downloading media';

  @override
  String get errorDownloadMediaNotFound => 'The selected media is no longer available';

  @override
  String get errorDownloadMediaUnavailable => 'The media files are unavailable on the server';

  @override
  String get errorPodcastEpisodeRequired => 'Choose a podcast episode to download';

  @override
  String get errorServerUnavailable => 'The server is not available for downloads';

  @override
  String get errorDownloadQueueUnavailable =>
      'Could not add the download to the queue. Check your connection and try again';

  @override
  String get errorDownloadQueueIncomplete => 'Could not add all files to the download queue. Try again';

  @override
  String get errorAudioFileCountRequired => 'Choose at least one audio file';

  @override
  String get errorSafFolderUnavailable =>
      'Could not prepare the selected Android folder for download. Select the folder again and try again';

  @override
  String get errorNoDownloadableFiles => 'No downloadable files were found';

  @override
  String downloadNotificationRunningTitle(String displayName) {
    return 'Downloading $displayName';
  }

  @override
  String downloadNotificationSingleRunningBody(
    String progress,
    String timeRemaining,
    String networkSpeed,
    String filename,
  ) {
    return '$progress ($timeRemaining · $networkSpeed) · $filename';
  }

  @override
  String downloadNotificationBatchRunningBody(String numFinished, String numTotal, String progress) {
    return '$numFinished of $numTotal · Progress $progress';
  }

  @override
  String downloadNotificationCompleteBody(String displayName, String filename) {
    return '$displayName ($filename)\nAll files downloaded';
  }

  @override
  String downloadNotificationCanceledBody(String displayName, String filename) {
    return '$displayName ($filename)\nDownload canceled';
  }

  @override
  String downloadNotificationFailedBody(String displayName, String filename) {
    return '$displayName ($filename)\nDownload failed';
  }

  @override
  String downloadNotificationPausedBody(String displayName, String progress, String networkSpeed) {
    return '$displayName\nProgress $progress · Speed $networkSpeed';
  }

  @override
  String downloadNotificationBatchCompleteBody(String displayName) {
    return '$displayName\nAll files downloaded';
  }

  @override
  String downloadNotificationBatchCanceledBody(String displayName) {
    return '$displayName\nDownload canceled';
  }

  @override
  String downloadNotificationBatchFailedBody(String displayName) {
    return '$displayName\nDownload failed';
  }

  @override
  String downloadNotificationBatchPausedBody(String displayName, String progress) {
    return '$displayName\nProgress $progress';
  }

  @override
  String get audioFileModeAll => 'All files';

  @override
  String get audioFileModeFromCurrent => 'All files starting from current';

  @override
  String get errorDownloadSessionChanged => 'Your signed-in account changed. Try the download again';

  @override
  String errorDownloadMediaIssue(String issue) {
    return 'Media files are unavailable on the server. $issue';
  }

  @override
  String get playbackKeepAliveQuiet => 'Quiet';

  @override
  String get playbackKeepAliveMedium => 'Medium';

  @override
  String get playbackKeepAliveStronger => 'Stronger';

  @override
  String get actionDone => 'Done';

  @override
  String get actionSet => 'Set';

  @override
  String get actionUnselectAll => 'Unselect all';

  @override
  String get actionDeleteSelected => 'Delete selected';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get actionOpen => 'Open';

  @override
  String get actionBack => 'Back';

  @override
  String get actionDismissWarning => 'Dismiss warning';

  @override
  String get actionViewRelease => 'View release';

  @override
  String get actionLater => 'Later';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDescription => 'Description';

  @override
  String get fieldHours => 'Hours';

  @override
  String get fieldMinutes => 'Minutes';

  @override
  String get fieldSeconds => 'Seconds';

  @override
  String get fieldUser => 'User';

  @override
  String get fieldDevice => 'Device';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldTime => 'Time';

  @override
  String get fieldProgress => 'Progress';

  @override
  String get inputOptional => 'Optional';

  @override
  String selectedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString selected', one: '1 selected');
    return '$_temp0';
  }

  @override
  String sessionCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString sessions', one: '1 session');
    return '$_temp0';
  }

  @override
  String get sessionCloseSuccess => 'Session closed';

  @override
  String get sessionCloseFailure => 'Could not close session';

  @override
  String get sessionNoSharedSessions => 'No shared sessions found';

  @override
  String get sessionSignInRequired => 'No active user. Sign in to manage sessions';

  @override
  String get sessionFilterUser => 'Filter by user';

  @override
  String get headingOpenSessions => 'Open sessions';

  @override
  String get headingSharedSessions => 'Shared sessions';

  @override
  String get statusNoOptionsAvailable => 'No options available';

  @override
  String sessionDeleteSuccess(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString sessions deleted',
      one: '1 session deleted',
    );
    return '$_temp0';
  }

  @override
  String sessionDeleteFailure(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Could not delete $countString sessions. Check logs for details',
      one: 'Could not delete 1 session. Check logs for details',
    );
    return '$_temp0';
  }

  @override
  String sessionDeletePrompt(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $countString selected sessions? This cannot be undone',
      one: 'Delete this session? This cannot be undone',
    );
    return '$_temp0';
  }

  @override
  String get sessionDeleteTitle => 'Delete selected sessions';

  @override
  String get sessionFilterEpisode => 'Filter by episode';

  @override
  String get sessionAllEpisodes => 'All episodes';

  @override
  String get errorCouldNotLoadUser => 'Could not load the user';

  @override
  String get paginationPerPage => 'Per page';

  @override
  String paginationTotal(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Total $countString';
  }

  @override
  String paginationPage(int page, int pages) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);
    final intl.NumberFormat pagesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pagesString = pagesNumberFormat.format(pages);

    return 'Page $pageString of $pagesString';
  }

  @override
  String get paginationPreviousPage => 'Previous page';

  @override
  String get paginationNextPage => 'Next page';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get changelogWhatsNew => 'What’s new';

  @override
  String changelogVersion(String version) {
    return 'Version $version';
  }

  @override
  String get changelogSponsors => 'Sponsors';

  @override
  String get changelogErrorLoad => 'Could not load the changelog';

  @override
  String get changelogNoReleaseNotes => 'No release notes are available for this version yet';

  @override
  String get changelogDontShowAgain => 'Don’t show again';

  @override
  String get changelogErrorSavePreference => 'Could not save your preference. Try again';

  @override
  String get changelogErrorSponsorOpen => 'Could not open GitHub Sponsors. Try again';

  @override
  String get errorConnectionUnavailable => 'No server connection available';

  @override
  String get errorAdminLibraryStatistics => 'Library-wide statistics are only available to administrators';

  @override
  String get promptSignInToViewLibraryStatistics => 'An active admin account is required';

  @override
  String get errorRefreshLists => 'Could not refresh lists. Retry';

  @override
  String get searchBooks => 'Search books';

  @override
  String get searchBooksTitleAuthorSeries => 'Title, author, or series';

  @override
  String get deleteFromServerOnlyTitle => 'Delete from Audiobookshelf only';

  @override
  String get deleteFromServerOnlySubtitle =>
      'Removes the entry from the server and keeps its media files on disk. It may return after a library rescan';

  @override
  String get deleteFromServerAndFilesTitle => 'Delete from Audiobookshelf and file system';

  @override
  String get deleteFromServerAndFilesSubtitle => 'Permanently removes the entry and its media files';

  @override
  String get errorPdfReadingLinuxOnly => 'PDF reading is currently supported only on Linux';

  @override
  String get filesystemParentFolder => 'Parent folder';

  @override
  String get filesystemUseCurrentFolder => 'Use current folder';

  @override
  String get appUpdateAvailableTitle => 'New yaabsa release';

  @override
  String appUpdateAvailableMessage(String latestVersion, String currentVersion) {
    return 'Version $latestVersion is available. You are using $currentVersion';
  }

  @override
  String get serverUpdateAvailableTitle => 'Server update available';

  @override
  String serverUpdateAvailableMessage(String version) {
    return 'A new update, version $version, is available for your Audiobookshelf server';
  }

  @override
  String get sessionDeleteSingleTitle => 'Delete session';

  @override
  String get sessionDeleteSharedTitle => 'Delete shared session';

  @override
  String get sessionDeleteSharedPrompt => 'Delete this shared session permanently? This cannot be undone';

  @override
  String get sessionSharedTitle => 'Shared session';

  @override
  String get sessionCloseAction => 'Close session';

  @override
  String get fieldSessionId => 'Session ID';

  @override
  String get unknownMediaItem => 'Unknown item';

  @override
  String get sessionNoResults => 'No listening sessions found';

  @override
  String get sessionNoOpenSessions => 'No open sessions found';

  @override
  String get actionOpenDownloads => 'Open downloads';

  @override
  String get booksNoneSelected => 'No books selected';

  @override
  String deleteAudiobookTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete audiobooks?',
      one: 'Delete audiobook?',
    );
    return '$_temp0';
  }

  @override
  String deleteAudiobookWarning(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'This action will remove $countString audiobooks from Audiobookshelf and cannot be undone',
      one: 'This action will remove the audiobook from Audiobookshelf and cannot be undone',
    );
    return '$_temp0';
  }

  @override
  String get deleteModePrompt => 'Choose a deletion option';

  @override
  String deleteSkippedNonAudiobooks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selected items are not audiobooks and will be skipped',
      one: '1 selected item is not an audiobook and will be skipped',
    );
    return '$_temp0';
  }

  @override
  String get filesystemRoot => 'Root';

  @override
  String get filesystemNoDirectories => 'No folders are available';

  @override
  String get browseServerFolders => 'Browse server folders';

  @override
  String get errorUnableToLoadContent => 'Unable to load content';

  @override
  String get errorRetryCheckConnection => 'Try again. If the issue continues, check your server connection';

  @override
  String get errorSectionRequiresServerConnection =>
      'This section needs an active server connection. Reconnect and try again';

  @override
  String get actionLoadMore => 'Load more';

  @override
  String get errorLoadMoreRetry => 'Could not load more. Retry';

  @override
  String get fieldTitle => 'Title';

  @override
  String serverUpdateAvailableShort(String version) {
    return 'Update $version';
  }

  @override
  String get errorSettingsBackupTooLarge => 'The settings backup is too large';

  @override
  String get errorChooseSettingsBackup => 'Choose a yaabsa settings backup';

  @override
  String get errorSettingsBackupVersion => 'This settings backup version is not supported';

  @override
  String get errorSettingsBackupAccounts => 'The settings backup has an invalid account settings section';

  @override
  String get errorSettingsBackupMissingSection => 'The settings backup is missing a settings section';

  @override
  String get errorSettingsBackupInvalidValue => 'The settings backup contains an invalid value';

  @override
  String get errorCredentialsRequired => 'Enter a username and password';

  @override
  String get errorAccountSessionInvalid => 'The server did not return a valid account session';

  @override
  String get errorWearPlaybackFailed => 'Playback failed. Check your connection or use a download';

  @override
  String get errorMediaCannotPlay => 'This item cannot be played';

  @override
  String get filterAllAudiobooks => 'All audiobooks';

  @override
  String get cacheLibrariesList => 'Libraries list';

  @override
  String get cacheLibraryDetails => 'Library details';

  @override
  String get cacheItemDetails => 'Item details';

  @override
  String get cacheItemResource => 'Item resource';

  @override
  String get cacheLibraryFilterData => 'Library filters';

  @override
  String get cacheLibrarySeries => 'Library series';

  @override
  String get cacheCurrentUserProfile => 'Current user profile';

  @override
  String get errorElevenLabsApiKeyRejected => 'ElevenLabs rejected the API key. Check it in Read aloud settings';

  @override
  String get errorElevenLabsModelsReadPermission =>
      'This key cannot list models. Enable Models read permission or use an available model';

  @override
  String get errorElevenLabsVoicesReadPermission =>
      'This key cannot list voices. Enable Voices read permission or enter a voice ID';

  @override
  String get errorElevenLabsSpeechPermission => 'Enable Text to speech permission for this ElevenLabs key';

  @override
  String get errorElevenLabsNoCredits => 'Your ElevenLabs account has no speech credits available';

  @override
  String get errorElevenLabsBillingIssue => 'Check your ElevenLabs billing and available speech credits';

  @override
  String get errorElevenLabsVoiceOrModelNotFound => 'The selected ElevenLabs voice or model was not found';

  @override
  String get errorElevenLabsCharacterLimit => 'This text exceeds the selected ElevenLabs model character limit';

  @override
  String get errorElevenLabsPlanRequired => 'The selected ElevenLabs voice or model requires a different plan';

  @override
  String get errorElevenLabsUnauthorized =>
      'ElevenLabs could not authorize this request. Check the API key and its permissions';

  @override
  String get errorElevenLabsNotAllowed => 'Your ElevenLabs key or account does not allow this operation';

  @override
  String get errorElevenLabsRateLimited => 'ElevenLabs is busy or rate limited. Try again shortly';

  @override
  String get errorElevenLabsSpeechSettingsRejected =>
      'ElevenLabs rejected the speech settings. Check the model, language, and voice ID';

  @override
  String get errorElevenLabsUnavailable => 'Could not reach ElevenLabs. Check your connection and try again';

  @override
  String get errorSecureStorageUnavailable => 'Could not access secure storage. Unlock your keyring and try again';

  @override
  String get errorElevenLabsApiKeyMissing => 'Add your ElevenLabs API key in Read aloud settings';

  @override
  String get errorElevenLabsModelListInvalid => 'ElevenLabs returned an invalid model list';

  @override
  String get errorElevenLabsVoiceListInvalid => 'ElevenLabs returned an invalid voice list';

  @override
  String get errorElevenLabsVoicePageInvalid => 'ElevenLabs returned invalid voice pagination';

  @override
  String get errorElevenLabsVoiceRequired => 'Choose an ElevenLabs voice or enter its voice ID in Read aloud settings';

  @override
  String get errorReaderLanguageCodeInvalid => 'Enter a valid preferred language code in Read aloud settings';

  @override
  String get errorElevenLabsModelRequired => 'Choose an ElevenLabs v2 or v4 model';

  @override
  String get errorElevenLabsRequestIdMissing => 'ElevenLabs did not return a request ID for the combined speech';

  @override
  String get errorElevenLabsSpeechAudioMissing => 'ElevenLabs returned no speech audio';

  @override
  String get errorElevenLabsSpeechAudioInvalid => 'ElevenLabs returned invalid speech audio';

  @override
  String get errorReaderSpeechAudioUnavailable => 'Could not play the narrated audio';

  @override
  String get errorReaderSpeechProviderUnavailable => 'The selected speech provider is unavailable';

  @override
  String get errorDeviceSpeechUnavailable => 'The device could not start speech';

  @override
  String get errorCastConnectionBusy => 'A cast connection is already being prepared';

  @override
  String get errorCastNoAudio => 'There is no audio available to cast';

  @override
  String get errorCastPlaybackChanged => 'Playback changed while connecting to the receiver';

  @override
  String get errorCastCancelled => 'Cast playback was canceled';

  @override
  String get errorCastTrackUnknown => 'Unable to determine the current track';

  @override
  String get errorCastServerConnectionRequired => 'Connect to the server before casting this item';

  @override
  String get errorCastStreamUnavailable => 'Could not prepare an audio stream for casting';

  @override
  String get errorCastTrackUnavailable => 'The server did not provide a playable audio track';

  @override
  String get errorCastPlayableUrlUnavailable => 'The server did not provide a playable audio address';

  @override
  String get errorCastNoDeviceConnected => 'No cast device is connected';

  @override
  String get errorCastDeviceGone => 'This cast device is no longer available';

  @override
  String get errorChromecastUnavailable => 'Chromecast is unavailable on this device';

  @override
  String get errorChromecastGone => 'This Chromecast is no longer available';

  @override
  String get errorCastReceiverLoadFailed => 'The receiver could not load this audio';

  @override
  String get errorCastReceiverLoadUnconfirmed => 'The receiver did not confirm loading this audio';

  @override
  String get errorCastSeekFailed => 'The receiver could not seek to the requested position';

  @override
  String get errorCastPlaybackStartFailed => 'The receiver did not start playback. Check its audio support and output';

  @override
  String get errorCastPlaybackStalled => 'The receiver stopped advancing playback. Check its audio support and output';

  @override
  String get errorCastReceiverReportedError => 'The receiver reported a playback error';

  @override
  String get errorCastReceiverCannotPlay => 'The receiver could not play this audio';

  @override
  String get errorCastReceiverUnresponsive => 'The receiver stopped responding';

  @override
  String get errorCastVolumeUnsupported => 'This receiver does not support volume control';

  @override
  String get errorCastSpeedUnavailable => 'Playback speed is unavailable on this receiver';

  @override
  String get actionSelectAll => 'Select all';

  @override
  String get actionClearAll => 'Clear all';

  @override
  String get actionApply => 'Apply';

  @override
  String get actionDisconnect => 'Disconnect';

  @override
  String get actionResume => 'Resume';

  @override
  String get fieldVolume => 'Volume';

  @override
  String get fieldYear => 'Year';

  @override
  String get fieldFiles => 'Files';

  @override
  String get fieldListeningTime => 'Listening time';

  @override
  String get fieldTotalListening => 'Total listening';

  @override
  String get fieldSessions => 'Sessions';

  @override
  String get fieldAverageSession => 'Average session';

  @override
  String get fieldMedianSession => 'Median session';

  @override
  String get fieldLongestSession => 'Longest session';

  @override
  String get fieldLongestStreak => 'Longest streak';

  @override
  String get fieldBookListening => 'Book listening';

  @override
  String get fieldPodcastListening => 'Podcast listening';

  @override
  String get fieldUniqueItems => 'Unique items';

  @override
  String get fieldUniqueAuthors => 'Unique authors';

  @override
  String get fieldFavoriteWeekday => 'Favorite weekday';

  @override
  String get fieldFavoriteHour => 'Favorite hour';

  @override
  String get fieldFirstSession => 'First session';

  @override
  String get fieldLatestSession => 'Latest session';

  @override
  String get fieldAverageActiveDay => 'Average active day';

  @override
  String get fieldPeakMonth => 'Peak month';

  @override
  String get fieldBooksFinished => 'Books finished';

  @override
  String get fieldBooksListened => 'Books listened';

  @override
  String get fieldActiveDays => 'Active days';

  @override
  String authorCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString authors', one: '1 author');
    return '$_temp0';
  }

  @override
  String dayCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString days', one: '1 day');
    return '$_temp0';
  }

  @override
  String fileCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString files', one: '1 file');
    return '$_temp0';
  }

  @override
  String get headingTopItems => 'Top items';

  @override
  String get headingTopAuthors => 'Top authors';

  @override
  String get headingTopGenres => 'Top genres';

  @override
  String get headingTopNarrators => 'Top narrators';

  @override
  String get headingWeekdayBreakdown => 'Weekday breakdown';

  @override
  String get headingBusiestHours => 'Busiest hours';

  @override
  String get headingTopMonths => 'Top months';

  @override
  String get headingListeningConsistency => 'Listening consistency';

  @override
  String headingYearRewind(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String yearString = yearNumberFormat.format(year);

    return '$yearString rewind';
  }

  @override
  String statsLastDays(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'Last $countString days', one: 'Last day');
    return '$_temp0';
  }

  @override
  String get statsDailyAverage => 'Daily average';

  @override
  String get statsOverallRuntime => 'Overall runtime';

  @override
  String get statsTotalSize => 'Total size';

  @override
  String get statsLibraryOverview => 'Library overview';

  @override
  String get statsLongestItems => 'Longest items';

  @override
  String get statsLargestItems => 'Largest items';

  @override
  String get statsNoGenreInformation => 'No genre information is available';

  @override
  String get statsNoAuthorInformation => 'No author information is available';

  @override
  String get statsNoItemDurationInformation => 'No item duration information is available';

  @override
  String get statsNoItemSizeInformation => 'No item size information is available';

  @override
  String get statsLibraryLoadError => 'Could not load library statistics';

  @override
  String get statsPeakDay => 'Peak day';

  @override
  String get statsListeningUnavailable => 'Listening totals unavailable';

  @override
  String get statsActivityUnavailable => 'Could not load listening activity';

  @override
  String get statsAdvancedUnavailable => 'Advanced analytics could not be calculated';

  @override
  String get statsYearUnavailable => 'No year-in-review data is available for this year';

  @override
  String get statsNoWeekdayData => 'No weekday listening data is available';

  @override
  String get statsNoRecentSessions => 'No recent sessions are available';

  @override
  String get statsNoTopAuthorsYear => 'No top authors are available for this year';

  @override
  String get statsNoTopGenresYear => 'No top genres are available for this year';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get sleepTimerQuickStart => 'Quick start';

  @override
  String get sleepTimerEndOfChapter => 'End of chapter';

  @override
  String get sleepTimerAddChapter => 'Add chapter';

  @override
  String sleepTimerAddMinutes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Add $countString min';
  }

  @override
  String sleepTimerChaptersRemaining(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString chapters remaining',
      one: '1 chapter remaining',
    );
    return '$_temp0';
  }

  @override
  String get sleepTimerNoChapterAvailable => 'No chapter is available at the current position';

  @override
  String get validationPositiveNumberRequired => 'Enter a number greater than zero';

  @override
  String get speedCustomValue => 'Custom value';

  @override
  String speedRangeHint(double minimum, double maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return '$minimumString–$maximumString';
  }

  @override
  String get playbackSpeedLoading => 'Loading playback';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String playerVolumeTooltip(int volume) {
    final intl.NumberFormat volumeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String volumeString = volumeNumberFormat.format(volume);

    return 'Volume $volumeString%';
  }

  @override
  String get castDevices => 'Cast devices';

  @override
  String get playerSearchAgain => 'Search again';

  @override
  String get playerBookmarkInReader => 'Use the reader to bookmark a passage';

  @override
  String get playerNoMediaToBookmark => 'No active media to bookmark';

  @override
  String get playerSleepTimerStart => 'Return to sleep timer start';

  @override
  String get uploadAutoFetchMetadata => 'Auto-fetch metadata';

  @override
  String get uploadAutoAcceptMetadata => 'Auto-accept metadata';

  @override
  String get uploadAutocompleteEntities => 'Autocomplete series and authors';

  @override
  String get uploadRequiresAdmin => 'Requires admin role';

  @override
  String get uploadBulkMetadata => 'Bulk update queue metadata';

  @override
  String get uploadApplyAuthor => 'Apply author';

  @override
  String get uploadApplySeries => 'Apply series';

  @override
  String get uploadNoMetadataResult => 'No metadata result was found for this item';

  @override
  String get uploadMetadataLookupFailed => 'Metadata lookup failed';

  @override
  String get uploadNoApiSession => 'No API session is available';

  @override
  String get uploadCanceled => 'Upload canceled';

  @override
  String get uploadCheckingDestination => 'Checking destination path…';

  @override
  String get uploadQueueEmpty => 'Your queue is empty';

  @override
  String get uploadPathIssuesTitle => 'Path check issues found';

  @override
  String get uploadPathIssuesPrompt => 'Some items have destination conflicts or path check errors. Continue anyway?';

  @override
  String get uploadCancelUploads => 'Cancel uploads';

  @override
  String get uploadStart => 'Start upload';

  @override
  String get uploadFetchMetadata => 'Fetch metadata';

  @override
  String get fieldItemsListened => 'Items listened';

  @override
  String get rangeLess => 'Less';

  @override
  String get rangeMore => 'More';

  @override
  String statsTotalOverDays(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Total over the last $countString days';
  }

  @override
  String statsDateRange(DateTime start, DateTime end) {
    final intl.DateFormat startDateFormat = intl.DateFormat.yMMMd(localeName);
    final String startString = startDateFormat.format(start);
    final intl.DateFormat endDateFormat = intl.DateFormat.yMMMd(localeName);
    final String endString = endDateFormat.format(end);

    return '$startString to $endString';
  }

  @override
  String statsDateAndListeningTime(DateTime date, String duration) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString · $duration';
  }

  @override
  String get statsNoTopNarratorsYear => 'No top narrators are available for this year';

  @override
  String get statsLoadingAnalytics => 'Loading advanced analytics…';

  @override
  String statsLoadingAnalyticsProgress(String pages, String sessions) {
    return 'Loading advanced analytics · $pages · $sessions';
  }

  @override
  String durationCompactDays(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '${countString}d';
  }

  @override
  String durationCompactDaysHours(int days, int hours) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);
    final intl.NumberFormat hoursNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return '${daysString}d ${hoursString}h';
  }

  @override
  String durationCompactYears(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '${countString}y';
  }

  @override
  String get fieldRange => 'Range';

  @override
  String statsPeakMonthValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get statsYearLoadError => 'Could not load year-in-review stats';

  @override
  String get unknownAuthor => 'Unknown author';

  @override
  String get unknownGenre => 'Unknown genre';

  @override
  String get fieldCurrentStreak => 'Listening streak';

  @override
  String get mediaTypeAudiobooks => 'Audiobooks';

  @override
  String get mediaTypePodcasts => 'Podcasts';

  @override
  String get fieldPages => 'Pages';

  @override
  String progressCountLoaded(String loaded, String total, String unit) {
    return '$loaded of $total $unit';
  }

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get playbackSleepTimer => 'Sleep timer';

  @override
  String get statsAchievementFirstHour => 'First hour';

  @override
  String get statsAchievementAllDayListener => 'All day listener';

  @override
  String get statsAchievementCenturyClub => 'Century club';

  @override
  String get statsAchievementTimeTraveler => 'Time traveler';

  @override
  String get statsAchievementListeningLegend => 'Listening legend';

  @override
  String get statsAchievementMasterOfTime => 'Master of time';

  @override
  String get statsAchievementFirstDiscovery => 'First discovery';

  @override
  String get statsAchievementCuriousListener => 'Curious listener';

  @override
  String get statsAchievementShelfExplorer => 'Shelf explorer';

  @override
  String get statsAchievementLibraryRegular => 'Library regular';

  @override
  String get statsAchievementCatalogConqueror => 'Catalog conqueror';

  @override
  String get statsAchievementWorldOfStories => 'World of stories';

  @override
  String get statsAchievementDayOne => 'Day one';

  @override
  String get statsAchievementWeekOfStories => 'A week of stories';

  @override
  String get statsAchievementMonthlyHabit => 'Monthly habit';

  @override
  String get statsAchievementDedicatedListener => 'Dedicated listener';

  @override
  String get statsAchievementYearRoundListener => 'Year-round listener';

  @override
  String get statsAchievementEverydayExplorer => 'Everyday explorer';

  @override
  String get statsAchievementBackForMore => 'Back for more';

  @override
  String get statsAchievementOnARoll => 'On a roll';

  @override
  String get statsAchievementPerfectWeek => 'Perfect week';

  @override
  String get statsAchievementFortnightFocus => 'Fortnight focus';

  @override
  String get statsAchievementUnstoppable => 'Unstoppable';

  @override
  String get statsAchievementStoryMarathon => 'Story marathon';

  @override
  String get statsAchievementPressPlay => 'Press play';

  @override
  String get statsAchievementGettingComfortable => 'Getting comfortable';

  @override
  String get statsAchievementRegularListener => 'Regular listener';

  @override
  String get statsAchievementSessionSpecialist => 'Session specialist';

  @override
  String get statsAchievementAlwaysListening => 'Always listening';

  @override
  String get statsAchievementPlaybackMaster => 'Playback master';

  @override
  String get statsAchievementNewVoice => 'New voice';

  @override
  String get statsAchievementAuthorSampler => 'Author sampler';

  @override
  String get statsAchievementLiteraryWanderer => 'Literary wanderer';

  @override
  String get statsAchievementVoiceCollector => 'Voice collector';

  @override
  String get statsAchievementAuthorAuthority => 'Author authority';

  @override
  String get statsAchievementPantheonOfVoices => 'Pantheon of voices';

  @override
  String get statsAchievementSettlingIn => 'Settling in';

  @override
  String get statsAchievementHalfHourHero => 'Half-hour hero';

  @override
  String get statsAchievementDeepListener => 'Deep listener';

  @override
  String get statsAchievementLostInAStory => 'Lost in a story';

  @override
  String get statsAchievementEpicSession => 'Epic session';

  @override
  String get statsAchievementEnduranceLegend => 'Endurance legend';

  @override
  String get statsAchievementQuickChapter => 'Quick chapter';

  @override
  String get statsAchievementFocusedListener => 'Focused listener';

  @override
  String get statsAchievementInTheZone => 'In the zone';

  @override
  String get statsAchievementLongformLover => 'Longform lover';

  @override
  String get statsAchievementImmersiveListener => 'Immersive listener';

  @override
  String get statsAchievementBookBeginner => 'Book beginner';

  @override
  String get statsAchievementChapterChaser => 'Chapter chaser';

  @override
  String get statsAchievementBookworm => 'Bookworm';

  @override
  String get statsAchievementAudioBibliophile => 'Audio bibliophile';

  @override
  String get statsAchievementLivingLibrary => 'Living library';

  @override
  String get statsAchievementKeeperOfStories => 'Keeper of stories';

  @override
  String get statsAchievementFirstEpisode => 'First episode';

  @override
  String get statsAchievementPodcastCurious => 'Podcast curious';

  @override
  String get statsAchievementEpisodeExplorer => 'Episode explorer';

  @override
  String get statsAchievementFeedFollower => 'Feed follower';

  @override
  String get statsAchievementPodcastPro => 'Podcast pro';

  @override
  String get statsAchievementAirwaveArchivist => 'Airwave archivist';

  @override
  String get statsAchievementJourneyBegins => 'Journey begins';

  @override
  String get statsAchievementOneWeekIn => 'One week in';

  @override
  String get statsAchievementMonthOfStories => 'A month of stories';

  @override
  String get statsAchievementSeasonedListener => 'Seasoned listener';

  @override
  String get statsAchievementAnniversary => 'Anniversary';

  @override
  String get statsAchievementLongtimeCompanion => 'Longtime companion';

  @override
  String get fieldItemsExplored => 'Items explored';

  @override
  String get fieldAuthorsDiscovered => 'Authors discovered';

  @override
  String get fieldListeningJourney => 'Listening journey';

  @override
  String get statsAchievementNotUnlocked => 'Not unlocked yet';

  @override
  String get statsAchievementHighestReached => 'Highest milestone reached';

  @override
  String statsAchievementNext(String label, String value) {
    return 'Next: $label · $value';
  }

  @override
  String get statsLoadingSessionHistory => 'Loading session history…';

  @override
  String statsUnlockingAchievements(String sessions) {
    return 'Unlocking detailed achievements · $sessions';
  }

  @override
  String get statsRetryAchievements => 'Retry detailed achievements';

  @override
  String get actionAccept => 'Accept';

  @override
  String get actionReject => 'Reject';

  @override
  String get fieldSeries => 'Series';

  @override
  String get fieldLibraryFolder => 'Library folder';

  @override
  String get fieldMetadataProvider => 'Metadata provider';

  @override
  String get statusReady => 'Ready';

  @override
  String get statusChecking => 'Checking';

  @override
  String get statusWarning => 'Warning';

  @override
  String get statusUploading => 'Uploading';

  @override
  String get statusUploaded => 'Uploaded';

  @override
  String get statusSaving => 'Saving';

  @override
  String get statusApplying => 'Applying…';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusCanceled => 'Canceled';

  @override
  String removeNamedItem(String name) {
    return 'Remove $name';
  }

  @override
  String get uploadSuggestedMetadata => 'Suggested metadata';

  @override
  String get uploadDropFilesOrFolder => 'Drop files or folders here, or choose them below';

  @override
  String get uploadDropFiles => 'Drop files here, or choose them below';

  @override
  String get uploadChooseFilesOrFolder => 'Choose files or a folder below';

  @override
  String get uploadChooseFilesBelow => 'Choose files below';

  @override
  String get uploadUnsupportedFiles => 'No supported files were found in the selected input';

  @override
  String get uploadSelectLibraryFolder => 'Select a library folder before starting upload';

  @override
  String get uploadNoActiveSession => 'No active authenticated API session';

  @override
  String get uploadNothingQueued => 'Nothing is queued for upload';

  @override
  String uploadRetryStarted(int attempt, int maximum) {
    final intl.NumberFormat attemptNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String attemptString = attemptNumberFormat.format(attempt);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Retrying upload ($attemptString/$maximumString)…';
  }

  @override
  String get uploading => 'Uploading…';

  @override
  String get uploadWaitingForServer => 'Upload complete. Waiting for server processing…';

  @override
  String get uploadFailed => 'Upload failed';

  @override
  String uploadRetryNetwork(int attempt, int maximum) {
    final intl.NumberFormat attemptNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String attemptString = attemptNumberFormat.format(attempt);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Network interruption detected. Retrying ($attemptString/$maximumString)…';
  }

  @override
  String uploadRetryIssue(int attempt, int maximum) {
    final intl.NumberFormat attemptNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String attemptString = attemptNumberFormat.format(attempt);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Upload issue detected. Retrying ($attemptString/$maximumString)…';
  }

  @override
  String get uploadCanceledAfterConflictReview => 'Upload canceled after path conflict review';

  @override
  String get uploadFilesUploadedScanFailed => 'Files uploaded, but the book scan failed. Please rescan this book';

  @override
  String uploadTargetLibrary(String library) {
    return 'Upload to $library';
  }

  @override
  String uploadAddFilesToItem(String item) {
    return 'Add files to $item';
  }

  @override
  String uploadItemIdentity(String title, String author, String series) {
    return '$title · $author · $series';
  }

  @override
  String uploadExistingFileConflict(String file) {
    return '$file (a file with this name already exists in this book)';
  }

  @override
  String uploadExistingDestination(String item) {
    return '$item (destination path exists)';
  }

  @override
  String uploadExistingDestinationAs(String item, String title) {
    return '$item (destination exists as “$title”)';
  }

  @override
  String uploadPathCheckFailed(String item) {
    return '$item (path check failed)';
  }

  @override
  String uploadFinishedSummary(int succeeded, int failed) {
    final intl.NumberFormat succeededNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String succeededString = succeededNumberFormat.format(succeeded);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);

    return 'Upload finished · $succeededString succeeded · $failedString failed or canceled';
  }

  @override
  String get settingsSearchHint => 'Search settings';

  @override
  String get actionRemove => 'Remove';

  @override
  String get actionQueueAll => 'Queue all items';

  @override
  String get actionRemoveFromQueue => 'Remove from queue';

  @override
  String settingsControlLoadFailed(String label) {
    return 'Unable to load $label';
  }

  @override
  String playbackSpeedMultiplier(double speed) {
    final intl.NumberFormat speedNumberFormat = intl.NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 1,
    );
    final String speedString = speedNumberFormat.format(speed);

    return '$speedString×';
  }

  @override
  String get fieldUsername => 'Username';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldApiKey => 'API key';

  @override
  String get fieldServerAddress => 'Server address';

  @override
  String get fieldValue => 'Value';

  @override
  String get fieldHeaderName => 'Header name';

  @override
  String get actionImport => 'Import';

  @override
  String get actionExport => 'Export';

  @override
  String get actionCopy => 'Copy';

  @override
  String get actionChange => 'Change';

  @override
  String get actionSignIn => 'Sign in';

  @override
  String get actionScanQrCode => 'Scan QR code';

  @override
  String get actionCloseScanner => 'Close scanner';

  @override
  String get headingAdvancedOptions => 'Advanced options';

  @override
  String get statusCopied => 'Copied';

  @override
  String get statusCheckingServer => 'Checking server…';

  @override
  String get statusSigningIn => 'Signing in…';

  @override
  String get statusConnected => 'Connected';

  @override
  String get authGuestPasswordCannotChange => 'Guest password cannot be changed';

  @override
  String get authWatchConnected => 'Watch connected successfully';

  @override
  String get authOpenIdRedirect => 'Continue in your browser to complete the OpenID Connect sign in';

  @override
  String get authSignInWear => 'Sign in to connect your Wear OS watch';

  @override
  String get authSignInServer => 'Sign in to your Audiobookshelf server';

  @override
  String get authServerAddressHint => 'https://your-audiobookshelf.example';

  @override
  String get authHttpHeadersWarning =>
      'Your custom headers will be sent without encryption over HTTP, so other people on the network can read them. Use HTTPS if your server supports it';

  @override
  String authWebSupportNote(String url) {
    return 'Web support is limited. Share issues in the yaabsa discussion at $url';
  }

  @override
  String get authNoSupportedMethod => 'No supported authentication method is enabled on this server';

  @override
  String get authConnectWithApiKey => 'Connect with API key';

  @override
  String get authApiKeyHelp => 'Use an API key instead of a username and password';

  @override
  String get authImportCodeTitle => 'Import authentication code';

  @override
  String get authCodeHint => 'Paste the authentication code here';

  @override
  String get authCameraUnavailable =>
      'Camera access is unavailable. Allow camera access in device settings or paste the code instead';

  @override
  String get authScanCodeTitle => 'Scan authentication code';

  @override
  String get authScanCodeInstruction => 'Point the camera at the QR code';

  @override
  String get authChangeInitialPasswordTitle => 'Change your initial password';

  @override
  String get authInitialPasswordWarning =>
      'For your security, the initial password from this authentication code can only be used once';

  @override
  String get authConfirmPassword => 'Confirm new password';

  @override
  String get authInitialPasswordRequired => 'Enter a new password';

  @override
  String get authPasswordsDoNotMatch => 'Passwords do not match';

  @override
  String get validationServerAddressRequired => 'Enter a valid server address';

  @override
  String get errorLocalLoginDisabled => 'Local sign in is disabled on this server. Use OpenID Connect instead';

  @override
  String get validationApiKeyRequired => 'Enter an API key';

  @override
  String get errorApiKeyInvalidResponse => 'API key sign in returned an invalid response';

  @override
  String get errorInitialPasswordUnavailable =>
      'The initial password is unavailable. Enter the account password manually';

  @override
  String get errorGuestPasswordNotRotated => 'Sign in was canceled because the guest password cannot be changed';

  @override
  String get errorPasswordChangeRequired => 'Change the password after using an authentication code';

  @override
  String get authGuestPasswordWarning =>
      'Audiobookshelf does not allow guest users to change passwords. The initial password will remain valid after this sign in. Continue only if you accept this risk';

  @override
  String get errorWatchTokenMissing => 'The server did not return a sign in token for the watch';

  @override
  String get errorWatchCredentialSendFailed =>
      'Could not send sign in details to the watch. Make sure it is waiting and try again';

  @override
  String get errorOpenIdDisabled => 'OpenID Connect is not enabled on this server';

  @override
  String errorOpenIdStartFailed(String error) {
    return 'Could not start OpenID Connect sign in: $error';
  }

  @override
  String get authHeaderNameDuplicate => 'A header with this name already exists';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionEdit => 'Edit';

  @override
  String get headingCustomHeaders => 'Custom headers';

  @override
  String get authUseApiKey => 'Use API key';

  @override
  String get fieldAuthenticationCode => 'Authentication code';

  @override
  String get errorNoLibrarySelected => 'No library selected. Select one in the library switcher';

  @override
  String get errorBookLibrariesOnly => 'This section is available only for book libraries';

  @override
  String errorLoadingNamedContent(String content) {
    return 'Could not load $content';
  }

  @override
  String get searchNoResults => 'No results found';

  @override
  String searchNoResultsFor(String query) {
    return 'No results found for “$query”';
  }

  @override
  String searchResultsFor(String query) {
    return 'Search results for “$query”';
  }

  @override
  String get searchResults => 'Search results';

  @override
  String searchResultCount(String name, String count) {
    return '$name · $count';
  }

  @override
  String get fieldTags => 'Tags';

  @override
  String get fieldGenres => 'Genres';

  @override
  String get fieldCollection => 'Collection';

  @override
  String get fieldPlaylist => 'Playlist';

  @override
  String get actionEditBooks => 'Edit books';

  @override
  String get actionEditDetails => 'Edit details';

  @override
  String get actionCreatePlaylist => 'Create playlist';

  @override
  String get actionCreateCollection => 'Create collection';

  @override
  String editNamedEntity(String entityType) {
    return 'Edit $entityType';
  }

  @override
  String deleteNamedEntityMessage(String name) {
    return '“$name” will be permanently removed';
  }

  @override
  String get errorNoActiveUser => 'No active user';

  @override
  String get offlineLibraryEmptyTitle => 'Your offline library starts here';

  @override
  String get offlineLibraryEmptyMessage => 'Download a book or episode to listen offline';

  @override
  String get statusNoDownloadsInView => 'No downloads in this view';

  @override
  String get statusPodcastNoPlayableEpisodes => 'This podcast has no playable episodes';

  @override
  String get errorPodcastAlreadyInLibrary => 'This podcast is already in your library';

  @override
  String get errorPodcastFeedUrlMissing => 'This result has no RSS feed URL. Paste the feed URL directly';

  @override
  String get errorPodcastFeedUnreadable => 'Could not read this RSS feed. Check the URL and try again';

  @override
  String get statusCreatingPodcast => 'Creating podcast…';

  @override
  String statusPodcastAdded(String library) {
    return 'Added podcast to $library';
  }

  @override
  String get errorPodcastCreateFailed => 'Could not create podcast';

  @override
  String get errorPodcastLibraryRequired => 'Switch to a podcast library to use this section';

  @override
  String get errorAdminRequired => 'This action requires an admin account';

  @override
  String get podcastAddTitle => 'Add podcasts';

  @override
  String get podcastSearchHint => 'Search podcasts or paste an RSS URL';

  @override
  String get statusNoSearchResultsYet => 'No search results yet';

  @override
  String get headingYourListening => 'Your listening';

  @override
  String get headingRecentPace => 'Recent pace';

  @override
  String get headingActivity => 'Activity';

  @override
  String get headingWeekdayRhythm => 'Weekday rhythm';

  @override
  String get headingRecentSessions => 'Recent sessions';

  @override
  String get actionViewAll => 'View all';

  @override
  String get headingAchievements => 'Achievements';

  @override
  String get statsLoadAdvancedPrompt => 'Load advanced analytics?';

  @override
  String get actionLoad => 'Load';

  @override
  String get statsLoadAdvancedAnalytics => 'Load advanced analytics';

  @override
  String get statusNoSeriesInLibrary => 'No series found in this library';

  @override
  String get statusNoAuthorsInLibrary => 'No authors found in this library';

  @override
  String get statusNoNarratorsInLibrary => 'No narrators found in this library';

  @override
  String get statusNoBooksInSeries => 'No books found in this series';

  @override
  String get statusNoRecentEpisodes => 'No incomplete recent episodes found';

  @override
  String get errorPlaylistUnavailable => 'Playlist details could not be loaded';

  @override
  String get errorPlaylistMissing => 'Playlist is no longer available';

  @override
  String get errorCollectionUnavailable => 'Collection details could not be loaded';

  @override
  String get errorCollectionMissing => 'Collection is no longer available';

  @override
  String get actionPlayRandomItem => 'Play random';

  @override
  String actionSortBy(String value) {
    return 'Sort by $value';
  }

  @override
  String get statusNoPersonalizedSections => 'No personalized sections are available yet';

  @override
  String get errorRefreshWhenConnected => 'Pull down to refresh once your connection returns';

  @override
  String get errorRefreshAndTryAgain => 'Pull down to refresh and try again';

  @override
  String get errorQueueVisibleItems => 'Could not add visible items to the playback queue';

  @override
  String get actionClear => 'Clear';

  @override
  String get actionClearQueue => 'Clear queue';

  @override
  String get actionExpand => 'Expand';

  @override
  String get actionCollapse => 'Collapse';

  @override
  String get actionUpload => 'Upload';

  @override
  String get actionOpenUploader => 'Open uploader';

  @override
  String get searchInLibrary => 'Search this library';

  @override
  String get actionSaveBooks => 'Save books';

  @override
  String statusNamedEntityUpdated(String entityType) {
    return '$entityType updated';
  }

  @override
  String statusNamedBooksUpdated(String entityType) {
    return '$entityType books updated';
  }

  @override
  String statusNamedEntityDeleted(String entityType) {
    return '$entityType deleted';
  }

  @override
  String errorNamedEntityUpdateFailed(String entityType) {
    return 'Could not update $entityType';
  }

  @override
  String errorNamedBooksUpdateFailed(String entityType) {
    return 'Could not update $entityType books';
  }

  @override
  String errorNamedEntityDeleteFailed(String entityType) {
    return 'Could not delete $entityType';
  }

  @override
  String get actionCreateEmpty => 'Create empty';

  @override
  String get statusNoManagedLists => 'No lists yet';

  @override
  String get promptCreateManagedList => 'Create a list to keep items together for later';

  @override
  String get headingDeleteManagedList => 'Delete this list?';

  @override
  String get statusNoItemsInManagedList => 'No items in this list';

  @override
  String get promptAddItemsToManagedList => 'Add items to this list to see them here';

  @override
  String get statusListMayBeRemoved => 'It may have been removed from the library';

  @override
  String errorLibraryItemsNotLoaded(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString items', one: '1 item');
    return 'Could not load $_temp0';
  }

  @override
  String statusNamedEntityCreated(String entityType) {
    return '$entityType created';
  }

  @override
  String get actionCreate => 'Create';

  @override
  String errorNamedEntityCreateFailed(String entityType) {
    return 'Could not create $entityType';
  }

  @override
  String get actionSelect => 'Select';

  @override
  String downloadDeletePrompt(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString downloads from local storage and remove them from Downloads?',
      one: 'this download from local storage and remove it from Downloads?',
    );
    return 'Delete $_temp0';
  }

  @override
  String downloadDeleteSummary(int items, int files) {
    final intl.NumberFormat itemsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String itemsString = itemsNumberFormat.format(items);
    final intl.NumberFormat filesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    String _temp0 = intl.Intl.pluralLogic(items, locale: localeName, other: '$itemsString items', one: '1 item');
    String _temp1 = intl.Intl.pluralLogic(files, locale: localeName, other: '$filesString files', one: '1 file');
    return 'Deleted $_temp0, removed $_temp1';
  }

  @override
  String downloadDeleteFilesFailed(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString files could not be removed',
      one: '1 file could not be removed',
    );
    return '$_temp0';
  }

  @override
  String downloadDeleteItemsFailed(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items failed to delete',
      one: '1 item failed to delete',
    );
    return '$_temp0';
  }

  @override
  String statusPartialDownloads(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Partial · $countString';
  }

  @override
  String statusOfflineDownloads(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Offline · $countString';
  }

  @override
  String get errorPodcastSearchFailed => 'Podcast search failed';

  @override
  String get statusPodcastLibraryNoFolders => 'Add a folder to this library in server settings before searching';

  @override
  String get podcastSearchEmptyPrompt => 'Search by podcast name or paste an RSS feed URL to add one';

  @override
  String get errorAdminAccountRequired => 'An admin account is required to add podcasts';

  @override
  String get actionSearch => 'Search';

  @override
  String get statusConnectionUnstableUsingCachedData =>
      'Server connection is unstable. Showing the latest available data';

  @override
  String get actionFilter => 'Filter';

  @override
  String get statusNoItemsInLibrary => 'No items found in this library';

  @override
  String get statusNoMissingOrIncompleteItems => 'No missing or incomplete items found';

  @override
  String get headingListeningSessions => 'Listening sessions';

  @override
  String get headingYearInRewind => 'Year in rewind';

  @override
  String get headingAdvancedAnalytics => 'Advanced analytics';

  @override
  String get statsAdvancedLoadDescription => 'Loads all listening sessions and may take longer for large accounts';

  @override
  String get actionDownload => 'Download';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get appName => 'yaabsa';

  @override
  String get headingWelcome => 'Welcome';

  @override
  String get playbackNowPlaying => 'Now playing';

  @override
  String get playerEmptyPrompt => 'Choose something from your libraries or downloads to start playback';

  @override
  String get fieldRewindInterval => 'Rewind interval';

  @override
  String get fieldFastForwardInterval => 'Fast forward interval';

  @override
  String get wearCoverBackground => 'Cover background';

  @override
  String get wearAmbientTitleAndAuthor => 'Ambient title and author';

  @override
  String get wearCoverGrid => 'Cover grid';

  @override
  String get wearFlatScrolling => 'Flat scrolling';

  @override
  String get wearItemProgress => 'Item progress';

  @override
  String get statusOn => 'On';

  @override
  String get statusOff => 'Off';

  @override
  String actionCancelDownloadProgress(String percent) {
    return 'Cancel download · $percent';
  }

  @override
  String get statusNoItems => 'No items found';

  @override
  String accessibilityPageAnnouncement(String section, int page, int pages) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);
    final intl.NumberFormat pagesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pagesString = pagesNumberFormat.format(pages);

    return '$section, page $pageString of $pagesString';
  }

  @override
  String get aaosOpenMediaCenter => 'Open media center';

  @override
  String get wearPairingNoPhoneConnected => 'No phone connected. Connect your watch to your phone and try again';

  @override
  String get wearPairingNoPhoneResponse => 'No response from phone. Check your phone for a pairing notification';

  @override
  String get wearPairingSubtitle => 'Connect to Audiobookshelf';

  @override
  String get wearPairingSignInOnPhone => 'Sign in on your phone to continue';

  @override
  String get headingServerHeader => 'Server header';

  @override
  String get statusSigningOut => 'Signing out';

  @override
  String get statusOpening => 'Opening…';

  @override
  String get wearSignOutWarning => 'You will need to sign in again to stream on this watch';

  @override
  String get statusFinished => 'Finished';

  @override
  String get errorCredentialsRejected => 'The server rejected these sign in details. Check your username and password';

  @override
  String get errorCertificateUnverified => 'The server certificate could not be verified';

  @override
  String get errorServerNotAudiobookshelf => 'This address is not an Audiobookshelf server';

  @override
  String get readerBookTitleFallback => 'Your book';

  @override
  String get readerLoadingEbookFiles => 'Loading ebook files…';

  @override
  String get errorMissingEbookToken => 'Missing authentication token for ebook loading';

  @override
  String get statusNoTableOfContents => 'This book has no table of contents';

  @override
  String get readerContentsTab => 'Contents';

  @override
  String get readerSavedTab => 'Saved';

  @override
  String get readerContentsAndNotes => 'Contents and notes';

  @override
  String get readerSavedPassagesTitle => 'Keep the passages you love';

  @override
  String get readerSavedPassagesPrompt => 'Select text to highlight it or add a note';

  @override
  String get readerBookmark => 'Bookmark';

  @override
  String get actionBookmarkThisPage => 'Bookmark this page';

  @override
  String get actionRemoveBookmark => 'Remove bookmark';

  @override
  String get actionRemoveSavedPassage => 'Remove saved passage';

  @override
  String get actionDeleteAnnotation => 'Delete annotation';

  @override
  String get actionEditAnnotation => 'Edit annotation';

  @override
  String get actionHighlightText => 'Highlight';

  @override
  String get actionUnderlineText => 'Underline';

  @override
  String get readerUnderlinedPassage => 'Underlined passage';

  @override
  String get readerHighlightedPassage => 'Highlighted passage';

  @override
  String get readerNoNote => 'No note added';

  @override
  String readerPageNumber(int page) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);

    return 'Page $pageString';
  }

  @override
  String get untitledChapter => 'Untitled chapter';

  @override
  String get actionCloseBook => 'Close book';

  @override
  String get actionSearchInBook => 'Search in book';

  @override
  String get headingReadingPreferences => 'Reading preferences';

  @override
  String get readerAppearance => 'Appearance';

  @override
  String get headingLayout => 'Layout';

  @override
  String get readerFieldTypeface => 'Typeface';

  @override
  String get readerFieldTextSize => 'Text size';

  @override
  String get readerFieldLineSpacing => 'Line spacing';

  @override
  String get readerFieldPageLayout => 'Page layout';

  @override
  String get fieldTextAlignment => 'Text alignment';

  @override
  String get readerFieldLetterSpacing => 'Letter spacing';

  @override
  String get readerFieldPageMargins => 'Page margins';

  @override
  String get readerFieldReadingWidth => 'Reading width';

  @override
  String get readerFieldUnderlineThickness => 'Underline thickness';

  @override
  String get readerFieldReadingPosition => 'Reading position';

  @override
  String get readerHideMiniPlayer => 'Hide mini player when reading';

  @override
  String get readerTrackReadingTime => 'Track reading time as listening';

  @override
  String get readerFieldColor => 'Color';

  @override
  String get readerSearchEmptyPrompt => 'Find a passage anywhere in this book';

  @override
  String get readerSearchMinimumPrompt => 'Type at least two characters or press Search';

  @override
  String readerSearchQueryPrompt(String query) {
    return 'Looking for “$query”';
  }

  @override
  String get readerNoSearchMatches => 'No matches found. Try another word or phrase';

  @override
  String get readerSearchFailed => 'Could not search this book. Try again';

  @override
  String get readerSearchOpenFailed => 'Could not open this result. Try again';

  @override
  String get readerSearchLoading => 'Searching the book…';

  @override
  String readerSearchFirstResults(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'First $countString results. Refine your search',
      one: 'First result. Refine your search',
    );
    return '$_temp0';
  }

  @override
  String readerSearchResultCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString results found',
      one: '1 result found',
    );
    return '$_temp0';
  }

  @override
  String get readerNoReadableText => 'No readable text found';

  @override
  String get readerAnnotationsSynced => 'Annotations synced';

  @override
  String get errorAnnotationsSyncFailed => 'Could not sync annotations';

  @override
  String get errorAnnotationsLoadFailed => 'Could not load annotations from the server';

  @override
  String get statusNoAnnotations => 'No annotations found for this item';

  @override
  String get errorStoredAnnotationsInvalid => 'Stored annotations are invalid';

  @override
  String get statusNoValidAnnotations => 'No valid annotations found for this item';

  @override
  String get statusNoPdfAnnotations => 'No PDF annotations found for this item';

  @override
  String statusPdfAnnotationsLoaded(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString PDF annotations',
      one: '1 PDF annotation',
    );
    return 'Loaded $_temp0';
  }

  @override
  String get statusNoEpubAnnotations => 'No EPUB annotations found for this item';

  @override
  String get statusEpubAnnotationsLoaded => 'Loaded EPUB annotations';

  @override
  String get optionBookDefault => 'Book default';

  @override
  String get fontSerif => 'Serif';

  @override
  String get fontSansSerif => 'Sans serif';

  @override
  String get pageLayoutSingle => 'Single page';

  @override
  String get pageLayoutTwoWide => 'Two pages on wide screens';

  @override
  String get pageLayoutScroll => 'Scroll';

  @override
  String get textAlignmentStart => 'Start aligned';

  @override
  String get textAlignmentJustified => 'Justified';

  @override
  String get spacingSlight => 'Slight';

  @override
  String get sizeNarrow => 'Narrow';

  @override
  String get sizeSmall => 'Small';

  @override
  String get sizeMedium => 'Medium';

  @override
  String get sizeLarge => 'Large';

  @override
  String get sizeWide => 'Wide';

  @override
  String get sizeExtraWide => 'Extra wide';

  @override
  String get sizeCompact => 'Compact';

  @override
  String get sizeComfortable => 'Comfortable';

  @override
  String get sizeFull => 'Full';

  @override
  String get readerThemePaper => 'Paper';

  @override
  String get readerThemeSepia => 'Sepia';

  @override
  String get readerThemeGrey => 'Grey';

  @override
  String get readerThemeNight => 'Night';

  @override
  String get actionFocus => 'Focus';

  @override
  String get readerAppearancePreviewLabel => 'Reading appearance preview';

  @override
  String get readerAppearancePreviewText => 'A quiet moment, a new chapter. Make the page comfortable for you';

  @override
  String readerPageLabelWithProgress(String page, int pages, String progress) {
    final intl.NumberFormat pagesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pagesString = pagesNumberFormat.format(pages);

    return 'Page $page of $pagesString · $progress';
  }

  @override
  String readerPageLabelProgress(String page, String progress) {
    return 'Page $page · $progress';
  }

  @override
  String readerLocationProgress(int position, int total, String progress) {
    final intl.NumberFormat positionNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Location $positionString of $totalString · $progress';
  }

  @override
  String get readerReading => 'Reading';

  @override
  String get readerAnnotationNoteHint => 'Add an optional note';

  @override
  String readerAnnotationColorLabel(String color) {
    return 'Annotation color $color';
  }

  @override
  String get readerColors => 'Colors';

  @override
  String get readerBookmarkAdded => 'Bookmark added';

  @override
  String get readerSelectTextFirst => 'Select some text first';

  @override
  String get readerAnnotationHighlight => 'Highlight';

  @override
  String get readerAnnotationUnderline => 'Underline';

  @override
  String readerUnderlineThicknessPixels(String pixels) {
    return '$pixels px';
  }

  @override
  String get readerSearchHint => 'Find a word or phrase';

  @override
  String readerPageColorOption(String color) {
    return '$color page color';
  }

  @override
  String readerAnnotationTitleWithThickness(String type, String thickness) {
    return '$type ($thickness)';
  }

  @override
  String get readerSettingsTitle => 'Reader settings';

  @override
  String get readerPlayerIntegration => 'Player integration';

  @override
  String get readerChooseFontDescription => 'Choose a font for the book text';

  @override
  String get readerAdjustTextSizeDescription => 'Adjust the size of the book text';

  @override
  String get readerAdjustLineSpacingDescription => 'Adjust the space between lines';

  @override
  String get readerChooseTextAlignmentDescription => 'Choose how book text is aligned';

  @override
  String get readerAdjustLetterSpacingDescription => 'Adjust the space between letters';

  @override
  String get readerChoosePageLayoutDescription => 'Choose how pages move while reading';

  @override
  String get readerHideMiniPlayerDescription => 'Hides the audio mini player while reading';

  @override
  String get readerTrackReadingTimeDescription => 'Includes reading time in listening statistics';

  @override
  String get readerSpeechProvider => 'Speech provider';

  @override
  String get readerSpeechProviderDescription => 'Choose which service reads the book aloud';

  @override
  String get readerSpeechRate => 'Speech rate';

  @override
  String get readerSpeechRateDescription => 'Adjust the speed of spoken text';

  @override
  String get readerSpeechLanguage => 'Speech language';

  @override
  String get readerSpeechLanguageDescription => 'Choose the language for spoken text';

  @override
  String get readerSpeechVoiceDescription => 'Choose a voice for spoken text';

  @override
  String get readerSpeechVoicesUnavailable => 'No speech voices are available. Check your device speech settings';

  @override
  String get readerSpeechApiKeyStored => 'Stored securely on this device';

  @override
  String get readerSpeechSaveFailed => 'Could not save speech preferences';

  @override
  String get readerSpeechPreferencesSaved => 'Speech preferences saved';

  @override
  String get readerSpeechVoiceIdDescription => 'Use a voice available to your account';

  @override
  String get readerSpeechPreferredLanguage => 'Preferred language';

  @override
  String get readerSpeechLanguageHint => 'en, de, fr';

  @override
  String get readerSpeechDetectLanguage => 'Leave empty to detect the language from the text';

  @override
  String get readerSpeechDetectsLanguage => 'This model detects the language from the text';

  @override
  String get readerSpeechLanguageChoose => 'Choose language';

  @override
  String get readerSpeechVoiceChoose => 'Choose a voice';

  @override
  String readerSpeechVoiceType(String voice, String type) {
    return '$voice ($type)';
  }

  @override
  String get readerSpeechLocalVoice => 'Local';

  @override
  String get readerSpeechNetworkVoice => 'Network';

  @override
  String readerSpeechNumberedVoice(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Voice $numberString';
  }

  @override
  String get readerSpeechModelDescription => 'Choose a speech model';

  @override
  String get readerSpeechVoiceInvalid => 'Enter a valid voice ID';

  @override
  String get readerSpeechLanguageCodeExample => 'Enter a language code such as en or de';

  @override
  String get readerSpeechLanguageUnsupported => 'This model does not support that language';

  @override
  String get errorAnnotationUpdateFailed => 'Could not update the annotation';

  @override
  String get errorReaderNarrationUnavailable => 'Could not prepare book narration';

  @override
  String get actionMoreActions => 'More actions';

  @override
  String get actionQuickMatch => 'Quick match';

  @override
  String get actionManualMatch => 'Manual match';

  @override
  String get actionMarkAsFinished => 'Mark as finished';

  @override
  String get actionMarkAsUnfinished => 'Mark as unfinished';

  @override
  String get actionSetProgress => 'Set progress';

  @override
  String get actionAddToPlaylist => 'Add to playlist';

  @override
  String get actionAddToCollection => 'Add to collection';

  @override
  String get actionPinToShelf => 'Pin to shelf';

  @override
  String get actionUnpinFromShelf => 'Unpin from shelf';

  @override
  String get actionManagePlaylists => 'Manage playlists';

  @override
  String get actionManageCollections => 'Manage collections';

  @override
  String get navPlayHistory => 'Play history';

  @override
  String get actionRead => 'Read';

  @override
  String get fieldPublisher => 'Publisher';

  @override
  String get fieldPublished => 'Published';

  @override
  String get fieldChapter => 'Chapter';

  @override
  String get fieldAudioFiles => 'Audio files';

  @override
  String get fieldEbookFiles => 'Ebook files';

  @override
  String get fieldLibraryFiles => 'Library files';

  @override
  String itemSectionTitleWithCount(String section, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$section ($countString)';
  }

  @override
  String get headingBookDetails => 'Book details';

  @override
  String get headingAboutThisBook => 'About this book';

  @override
  String get actionShowLess => 'Show less';

  @override
  String get actionReadMore => 'Read more';

  @override
  String errorLoadNamedItemsRetry(String items) {
    return 'Could not load $items. Retry';
  }

  @override
  String statusNamedItemsUnknown(String items) {
    return 'Some $items could not be checked. Retry';
  }

  @override
  String statusNoNamedItems(String items) {
    return 'No $items';
  }

  @override
  String get statusNoSearchMatches => 'No items match your search or filters';

  @override
  String get entityCollections => 'collections';

  @override
  String get entityPlaylists => 'playlists';

  @override
  String get statusDownloadQueued => 'Download added to queue';

  @override
  String get errorDownloadStartFailed => 'Could not start download';

  @override
  String get statusDeletingDownloadedFiles => 'Deleting downloaded files…';

  @override
  String downloadFilesDeleteSummary(int deleted, int failed) {
    final intl.NumberFormat deletedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String deletedString = deletedNumberFormat.format(deleted);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);

    String _temp0 = intl.Intl.pluralLogic(
      deleted,
      locale: localeName,
      other: '$deletedString files deleted',
      one: '1 file deleted',
      zero: 'No files deleted',
    );
    String _temp1 = intl.Intl.pluralLogic(
      failed,
      locale: localeName,
      other: ' · $failedString files could not be removed',
      one: ' · 1 file could not be removed',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get errorDeleteDownload => 'Could not delete download';

  @override
  String get errorUpdatePinned => 'Could not update the pinned shelf';

  @override
  String get errorPodcastFeedLoad => 'Could not load podcast feed';

  @override
  String get statusNoDownloadableEpisodes => 'No downloadable episodes were found in the feed';

  @override
  String get statusQueuingEpisodeDownloads => 'Queuing episode downloads…';

  @override
  String statusPodcastEpisodesStarted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString episodes', one: '1 episode');
    return 'Started downloading $_temp0';
  }

  @override
  String get headingDownloadEpisodes => 'Download episodes';

  @override
  String get actionDownloadNotStartedEpisodes => 'Download not started episodes';

  @override
  String get actionDownloadUnfinishedEpisodes => 'Download unfinished episodes';

  @override
  String get actionCancelActiveDownloads => 'Cancel active downloads';

  @override
  String statusDownloadsCanceled(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString downloads',
      one: '1 download',
    );
    return 'Canceled $_temp0';
  }

  @override
  String get statusNoNewSelectedEpisodes => 'No new episodes to download in the selection';

  @override
  String get statusPodcastMetadataUnavailable => 'Podcast metadata is unavailable';

  @override
  String get errorItemNotFound => 'Item not found';

  @override
  String get statusItemMayHaveMovedOrBeenDeleted => 'This item may have been moved or deleted';

  @override
  String get statusNoDescriptionAvailable => 'No description available';

  @override
  String get actionFindEpisodes => 'Find episodes';

  @override
  String get actionClearSelection => 'Clear selection';

  @override
  String actionDownloadEpisodes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Download $countString episodes',
      one: 'Download episode',
      zero: 'Download episodes',
    );
    return '$_temp0';
  }

  @override
  String get actionDownloadSelectedEpisodes => 'Download selected episodes';

  @override
  String get actionDownloadOptions => 'Download options';

  @override
  String get hintSearchEpisodes => 'Search episodes';

  @override
  String get headingEpisodes => 'Episodes';

  @override
  String get headingEpisode => 'Episode';

  @override
  String statusEpisodeResultsSubset(int visible, int total) {
    final intl.NumberFormat visibleNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String visibleString = visibleNumberFormat.format(visible);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(
      visible,
      locale: localeName,
      other: '$visibleString of $totalString episodes',
      one: '1 of $totalString episodes',
    );
    return '$_temp0';
  }

  @override
  String statusDownloadsQueued(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString downloads added to the queue',
      one: 'Download added to the queue',
      zero: 'No downloads added to the queue',
    );
    return '$_temp0';
  }

  @override
  String statusActiveDownloadCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString downloads active',
      one: '1 download active',
    );
    return '$_temp0';
  }

  @override
  String get statusAllEpisodesDownloaded => 'All episodes are already downloaded';

  @override
  String get sortNewestFirst => 'Newest first';

  @override
  String get sortOldestFirst => 'Oldest first';

  @override
  String get sortTitleAscending => 'Title A-Z';

  @override
  String get sortTitleDescending => 'Title Z-A';

  @override
  String get statusComplete => 'Complete';

  @override
  String get statusInProgress => 'In progress';

  @override
  String get statusIncomplete => 'Incomplete';

  @override
  String get statusCurrentlyPlaying => 'Currently playing';

  @override
  String get statusDownloading => 'Downloading';

  @override
  String get statusLoading => 'Loading';

  @override
  String get actionReplay => 'Replay';

  @override
  String get actionAddToQueue => 'Add to queue';

  @override
  String get actionDeleteDownload => 'Delete download';

  @override
  String metadataFieldValue(String field, String value) {
    return '$field · $value';
  }

  @override
  String podcastEpisodeCountAndDuration(String count, String duration) {
    return '$count · $duration';
  }

  @override
  String get optionCustom => 'Custom';

  @override
  String get optionNone => 'None';

  @override
  String get navBookmarks => 'Bookmarks';

  @override
  String get navCarMode => 'Car mode';

  @override
  String get navEqualizer => 'Equalizer';

  @override
  String get headingQueue => 'Queue';

  @override
  String get headingQuickSettings => 'Quick settings';

  @override
  String get optionAdaptive => 'Adaptive';

  @override
  String get optionMinimalistic => 'Minimalistic';

  @override
  String get fieldCoverSize => 'Cover size';

  @override
  String get fieldImmersivePlayerColors => 'Immersive player colors';

  @override
  String get fieldTimelineMode => 'Timeline mode';

  @override
  String get deviceMobile => 'Mobile';

  @override
  String get deviceTablet => 'Tablet';

  @override
  String get deviceDesktop => 'Desktop';

  @override
  String get alignmentCenter => 'Center';

  @override
  String get alignmentEnd => 'End';

  @override
  String get playerCoverFitHeight => 'Fill height';

  @override
  String get playerCoverFitWidth => 'Fill width';

  @override
  String get playerCoverFitBox => 'Fill box';

  @override
  String get playerSeekTimeInline => 'Inline';

  @override
  String get playerSeekTimeBelowSeekBar => 'Below seek bar';

  @override
  String get playerSeekTimeUnderAppBar => 'Under app bar';

  @override
  String get playerComponentCover => 'Cover';

  @override
  String get playerComponentMediaInfo => 'Media info';

  @override
  String get playerComponentSeekBar => 'Seek bar';

  @override
  String get playerComponentControls => 'Controls';

  @override
  String get playerComponentUtilities => 'Utilities';

  @override
  String get playerComponentSubtitles => 'Subtitles';

  @override
  String get optionHideWidget => 'Hide widget';

  @override
  String get optionCompactMessage => 'Compact message';

  @override
  String get optionFullPlaceholder => 'Full placeholder';

  @override
  String get actionJump => 'Jump';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionJumpAndSkip => 'Jump and skip';

  @override
  String playerLayoutEditTitle(String screenSize) {
    return 'Edit $screenSize layout';
  }

  @override
  String errorPlayerLayoutNoFreeSpace(String component) {
    return 'No free grid space available for $component';
  }

  @override
  String get statusPlayerLayoutConfigCopied => 'Layout config copied to clipboard';

  @override
  String get statusLoadingNextItem => 'Loading next item…';

  @override
  String get actionEditPlayerLayout => 'Edit player layout';

  @override
  String get actionMinimizePlayer => 'Minimize player';

  @override
  String get statusPlayerOverlapUnlocked => 'Overlap unlocked';

  @override
  String get statusPlayerOverlapLocked => 'Overlap locked';

  @override
  String get confirmClearQueue => 'Clear queue?';

  @override
  String get confirmClearPlaybackQueue => 'Remove all queued, auto-queued, and scheduled items?';

  @override
  String get statusCustomPlayer => 'Custom player';

  @override
  String get actionReset => 'Reset';

  @override
  String get actionRestartListeningSession => 'Restart listening session';

  @override
  String get statusVisible => 'Visible';

  @override
  String get settingUseCardStyle => 'Use card style';

  @override
  String settingShowField(String field) {
    return 'Show $field';
  }

  @override
  String get fieldScale => 'Scale';

  @override
  String get fieldFontScale => 'Font scale';

  @override
  String get fieldSeekBarHeight => 'Seek bar height';

  @override
  String get fieldTimeFontSize => 'Time font size';

  @override
  String get fieldCoverFitMode => 'Cover fit mode';

  @override
  String get fieldTimeLabelsPosition => 'Time labels position';

  @override
  String get fieldEmptyState => 'Empty state';

  @override
  String settingScaleValue(double value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 2,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString×';
  }

  @override
  String headingNamedSettings(String name) {
    return '$name settings';
  }

  @override
  String get statusNoPlayerComponentsVisible => 'No components are visible for this layout';

  @override
  String get directionLeft => 'left';

  @override
  String get directionRight => 'right';

  @override
  String get directionUp => 'up';

  @override
  String get directionDown => 'down';

  @override
  String actionMoveDirection(String direction) {
    return 'Move $direction';
  }

  @override
  String get actionNarrower => 'Narrower';

  @override
  String get actionWider => 'Wider';

  @override
  String get actionShorter => 'Shorter';

  @override
  String get actionTaller => 'Taller';

  @override
  String get statusNoChaptersAvailable => 'No chapters available';

  @override
  String get statusQueueEmpty => 'Queue is empty';

  @override
  String get statusSubtitlesDisabled => 'Subtitles are disabled in player settings';

  @override
  String get hintStartPlaybackForSubtitleReading => 'Start playback to use continuous subtitle reading mode';

  @override
  String get statusNoSubtitlesAvailable => 'No subtitles available for this title';

  @override
  String get statusWaitingForSubtitleCue => 'Waiting for subtitle cue';

  @override
  String get headingOnThisDevice => 'On this device';

  @override
  String eventCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString events', one: '1 event');
    return '$_temp0';
  }

  @override
  String get hintSignInToViewActivity => 'Sign in to view playback activity';

  @override
  String get statusNoPlaybackActivityYet => 'No activity yet';

  @override
  String get hintPlaybackActivityWillAppear => 'Playback, sleep timer, and sync activity will appear here';

  @override
  String get statusNothingToShowYet => 'Nothing to show yet';

  @override
  String get hintOpenHistoryAfterPlayback => 'Start playing an audiobook or podcast, then open its history again';

  @override
  String get errorStartPlaybackFromPosition => 'Could not start playback from this position';

  @override
  String get playbackShuffleQueue => 'Shuffle queue';

  @override
  String playbackRewindInterval(int seconds) {
    final intl.NumberFormat secondsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Rewind $secondsString seconds',
      one: 'Rewind 1 second',
    );
    return '$_temp0';
  }

  @override
  String playbackForwardInterval(int seconds) {
    final intl.NumberFormat secondsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: 'Forward $secondsString seconds',
      one: 'Forward 1 second',
    );
    return '$_temp0';
  }

  @override
  String playbackRepeatStatus(String status) {
    return 'Repeat $status';
  }

  @override
  String get actionAddBookmark => 'Add bookmark';

  @override
  String get statusAddingBookmark => 'Adding';

  @override
  String get errorBookmarkPlaybackRequired => 'Play a little further before creating a bookmark';

  @override
  String get errorBookmarkCreateFailed => 'Could not create bookmark';

  @override
  String statusBookmarkAddedAt(String position) {
    return 'Bookmark added at $position';
  }

  @override
  String get errorBookmarkUpdateFailed => 'Could not update bookmark';

  @override
  String get statusBookmarkUpdated => 'Bookmark updated';

  @override
  String get errorBookmarkDeleteFailed => 'Could not delete bookmark';

  @override
  String get statusBookmarkDeleted => 'Bookmark deleted';

  @override
  String confirmDeleteBookmarkAt(String position) {
    return 'Remove the bookmark at $position? This cannot be undone';
  }

  @override
  String confirmDeleteBookmarks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $countString bookmarks?',
      one: 'Delete 1 bookmark?',
    );
    return '$_temp0';
  }

  @override
  String statusBookmarksDeleted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString bookmarks deleted',
      one: '1 bookmark deleted',
    );
    return '$_temp0';
  }

  @override
  String get statusNoBookmarksYet => 'No bookmarks yet';

  @override
  String get untitledBookmark => 'Untitled bookmark';

  @override
  String get hintBookmarkNote => 'What do you want to remember?';

  @override
  String get hintSaveBookmarkToFindAgain => 'Save a note at the current playback position to find it again later';

  @override
  String get historyEventProgressUpdates => 'Progress updates';

  @override
  String get historyEventPlaybackStarted => 'Playback started';

  @override
  String get historyEventStopped => 'Stopped';

  @override
  String get historyEventPositionChanged => 'Position changed';

  @override
  String get historyEventSkippedForward => 'Skipped forward';

  @override
  String get historyEventSkippedBack => 'Skipped back';

  @override
  String get historyEventSpeedChanged => 'Speed changed';

  @override
  String get historyEventSleepTimerStarted => 'Sleep timer started';

  @override
  String get historyEventSleepTimerAutoStarted => 'Sleep timer auto-started';

  @override
  String get historyEventSleepTimerExtended => 'Sleep timer extended';

  @override
  String get historyEventSleepTimerStopped => 'Sleep timer stopped';

  @override
  String get historyEventSleepTimerEnded => 'Sleep timer ended';

  @override
  String get historyEventProgressSynced => 'Progress synced';

  @override
  String get historyEventOfflineProgressSaved => 'Offline progress saved';

  @override
  String get historyEventOfflineProgressSynced => 'Offline progress synced';

  @override
  String historyPausedAt(String position) {
    return 'Paused at $position';
  }

  @override
  String historyStoppedAt(String position) {
    return 'Stopped at $position';
  }

  @override
  String historyToPosition(String position) {
    return 'To $position';
  }

  @override
  String historyToChapter(String chapter) {
    return 'To $chapter';
  }

  @override
  String historyPositionRange(String start, String end) {
    return 'From $start to $end';
  }

  @override
  String historySpeedRange(double previousSpeed, double speed) {
    final intl.NumberFormat previousSpeedNumberFormat = intl.NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 2,
    );
    final String previousSpeedString = previousSpeedNumberFormat.format(previousSpeed);
    final intl.NumberFormat speedNumberFormat = intl.NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 2,
    );
    final String speedString = speedNumberFormat.format(speed);

    return '$previousSpeedString× to $speedString×';
  }

  @override
  String historyForValue(String value) {
    return 'For $value';
  }

  @override
  String historyDurationLeft(String duration) {
    return '$duration left';
  }

  @override
  String get historySleepTimerResumed => 'Resumed';

  @override
  String get historySleepTimerStarted => 'Started';

  @override
  String get historySleepTimerAutoStarted => 'Auto-started';

  @override
  String historySleepTimerExtended(String additional, String remaining) {
    return '+$additional · $remaining left';
  }

  @override
  String historySleepTimerRemaining(String action, String remaining) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'pause': 'Paused with $remaining left',
      'reset': 'Reset with $remaining left',
      'other': 'Stopped with $remaining left',
    });
    return '$_temp0';
  }

  @override
  String get historySleepTimerStopped => 'Stopped';

  @override
  String historyPlaybackEndedByTimer(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {'pause': 'Paused playback', 'other': 'Stopped playback'});
    return '$_temp0';
  }

  @override
  String historyProgressAtPosition(String action, String position) {
    return '$action at $position';
  }

  @override
  String historyTimeAndDescription(String time, String description) {
    return '$time · $description';
  }

  @override
  String chapterCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString chapters', one: '1 chapter');
    return '$_temp0';
  }

  @override
  String get statusSynced => 'Synced';

  @override
  String get statusSaved => 'Saved';

  @override
  String get playbackFullTimeline => 'Full';

  @override
  String castProtocolStatus(String protocol, String status) {
    return '$protocol · $status';
  }

  @override
  String get statusSearchingCastDevices => 'Searching for devices on your network';

  @override
  String get statusNoCastDevicesFound => 'No devices found. Check that your receiver is on the same network';

  @override
  String get errorCastStopFailed => 'Unable to stop playback on the receiver';

  @override
  String get errorCastDiscoveryFailed => 'Could not search for cast devices';

  @override
  String get errorPlaybackSpeedUnavailable => 'Playback speed is unavailable for this playback';

  @override
  String get settingsBackupTitle => 'Settings backup';

  @override
  String get settingsBackupDescription => 'Import or export app preferences and player layouts';

  @override
  String get settingRefreshProgressOnResume => 'Refresh progress on resume';

  @override
  String get settingRefreshProgressOnResumeDescription =>
      'Update book and episode progress when the app returns to the foreground';

  @override
  String get settingDisableFdkAacDecoder => 'Disable FDK AAC decoder';

  @override
  String get settingDisableFdkAacDecoderDescription => 'Avoid crashes in the FDK AAC decoder. Restart the app to apply';

  @override
  String get settingServerManagement => 'Server management';

  @override
  String get settingServerManagementDescription =>
      'Configure visibility for collections, editing, deletion, and uploading';

  @override
  String get settingTimelineModeDescription =>
      'Choose whether the seek bar tracks a chapter, the full audiobook, or both';

  @override
  String get settingCoverSizeDescription => 'Set the artwork size in the adaptive player';

  @override
  String get settingImmersivePlayerColorsDescription => 'Use artwork colors in player backgrounds';

  @override
  String get settingTimelineMarkers => 'Timeline markers';

  @override
  String get settingTimelineMarkersDescription =>
      'Choose whether the full timeline shows chapter markers, bookmark markers, both, or none';

  @override
  String get settingFastForwardIntervalDescription => 'How many seconds to skip when jumping forward';

  @override
  String get settingRewindIntervalDescription => 'How many seconds to skip when rewinding';

  @override
  String get settingRememberPlaybackSpeedPerBook => 'Remember playback speed per book';

  @override
  String get settingRememberPlaybackSpeedPerBookDescription =>
      'Each book remembers its own speed and new books start with your last used speed';

  @override
  String get settingAutoQueue => 'Auto queue';

  @override
  String get settingAutoQueueDescription => 'Automatically queue upcoming books when playback starts';

  @override
  String get settingAutoQueueEverywhere => 'Auto queue everywhere';

  @override
  String get settingAutoQueueEverywhereDescription =>
      'Auto queue books from the first linked series even when starting playback outside a series view';

  @override
  String get settingSmartRewind => 'Smart rewind';

  @override
  String get settingSmartRewindDescription =>
      'When resuming after a pause, rewind by an amount based on pause duration';

  @override
  String get settingShortPauseThreshold => 'Short-pause threshold';

  @override
  String get settingShortPauseThresholdDescription =>
      'If paused up to this amount, the short smart rewind value is used';

  @override
  String get settingLongPauseThreshold => 'Long-pause threshold';

  @override
  String get settingLongPauseThresholdDescription =>
      'If paused longer than the short threshold and up to this amount, the medium smart rewind value is used';

  @override
  String get settingShortRewindAmount => 'Short rewind amount';

  @override
  String get settingShortRewindAmountDescription => 'Rewind amount used for short pauses';

  @override
  String get settingMediumRewindAmount => 'Medium rewind amount';

  @override
  String get settingMediumRewindAmountDescription => 'Rewind amount used for medium pauses';

  @override
  String get settingLongRewindAmount => 'Long rewind amount';

  @override
  String get settingLongRewindAmountDescription => 'Rewind amount used for long pauses';

  @override
  String get settingSleepTimerEndAction => 'Sleep timer end action';

  @override
  String get settingSleepTimerEndActionDescription =>
      'Choose whether playback is stopped or paused when the sleep timer expires';

  @override
  String get settingSleepTimerEndRewind => 'Sleep timer end rewind';

  @override
  String get settingSleepTimerEndRewindDescription =>
      'After sleep timer stops playback, rewind this much when the same item is played again';

  @override
  String get settingFadeAudio => 'Fade audio';

  @override
  String get settingFadeAudioDescription => 'Gradually lower playback volume before the sleep timer ends';

  @override
  String get settingShowSleepTimerMarker => 'Show sleep timer marker';

  @override
  String get settingShowSleepTimerMarkerDescription => 'Show the sleep timer on the player timeline after it ends';

  @override
  String get settingAutoRestartTimerOnPlaybackStart => 'Auto-restart timer on playback start';

  @override
  String get settingAutoRestartTimerOnPlaybackStartDescription =>
      'Automatically start a new sleep timer using your last duration on playback start';

  @override
  String get settingAutoRestartDuringTimeRange => 'Only auto-restart during a time range';

  @override
  String get settingAutoRestartDuringTimeRangeDescription => 'Limit automatic sleep timer restart to specific hours';

  @override
  String get settingAutoRestartRangeStart => 'Auto-restart range start';

  @override
  String get settingAutoRestartRangeStartDescription => 'Sleep timer auto-restart becomes active at this time';

  @override
  String get settingAutoRestartRangeEnd => 'Auto-restart range end';

  @override
  String get settingAutoRestartRangeEndDescription => 'Sleep timer auto-restart remains active until this time';

  @override
  String get settingEnableSubtitles => 'Enable subtitles';

  @override
  String get settingEnableSubtitlesDescription => 'Show subtitle tracks (.srt and .vtt) during playback when available';

  @override
  String get settingHighlightSpeakerLabels => 'Highlight speaker labels';

  @override
  String get settingHighlightSpeakerLabelsDescription => 'Highlight speaker names in subtitles';

  @override
  String get settingEnableReadAlong => 'Enable read along';

  @override
  String get settingEnableReadAlongDescription => 'Highlight currently spoken words in subtitles';

  @override
  String get settingShakeToResetSleepTimer => 'Shake to reset sleep timer';

  @override
  String get settingShakeToResetSleepTimerDescription =>
      'Shake to reset an active sleep timer back to its full duration';

  @override
  String get settingShakeToRewind => 'Shake to rewind';

  @override
  String get settingShakeToRewindDescription => 'Shake while playing to rewind by the configured rewind interval';

  @override
  String get settingShakeSensitivity => 'Shake sensitivity';

  @override
  String get settingShakeSensitivityDescription =>
      'Lower values trigger more easily, higher values require a stronger shake';

  @override
  String get settingShakeVibrationFeedback => 'Shake vibration feedback';

  @override
  String get settingShakeVibrationFeedbackDescription => 'Vibrate when a shake action is triggered';

  @override
  String get settingShelfSections => 'Shelf sections';

  @override
  String get settingShelfSectionsDescription => 'Choose which shelf sections are visible and their order';

  @override
  String get settingLibraryGridScale => 'Library grid scale';

  @override
  String get settingLibraryGridScaleDescription => 'Scales library item cards in all grid views';

  @override
  String get settingCollapseSeries => 'Collapse series';

  @override
  String get settingCollapseSeriesDescription => 'Collapse books in series into a single entry';

  @override
  String get settingViewSubtitles => 'View subtitles';

  @override
  String get settingViewSubtitlesDescription =>
      'Configure supporting information shown below library, series, and author cards';

  @override
  String get settingShowShelfPlayButton => 'Show shelf play button';

  @override
  String get settingShowShelfPlayButtonDescription =>
      'Add a play all control to the Continue listening and Newest shelves';

  @override
  String get settingShowShuffleButton => 'Show shuffle button';

  @override
  String get settingShowShuffleButtonDescription => 'Add a shuffle control to collections, playlists, and podcasts';

  @override
  String get settingCheckServerUpdates => 'Check server updates';

  @override
  String get settingCheckServerUpdatesDescription => 'Check Audiobookshelf releases on GitHub for server updates';

  @override
  String get settingDownloadLocation => 'Download location';

  @override
  String get settingDownloadLocationDescription => 'Choose where downloaded media is stored';

  @override
  String get settingDownloadOnlyOnWiFi => 'Download only on Wi-Fi';

  @override
  String get settingDownloadOnlyOnWiFiDescription => 'Limit regular and smart downloads to Wi-Fi';

  @override
  String get settingMaximumParallelDownloads => 'Maximum parallel downloads';

  @override
  String get settingMaximumParallelDownloadsDescription => 'Limit the number of files downloaded at the same time';

  @override
  String get settingSmartDownloads => 'Smart downloads';

  @override
  String get settingSmartDownloadsDescription => 'Automatically download and remove items according to download rules';

  @override
  String get settingLanguageDescription => 'Configure app display language';

  @override
  String get settingMaxBufferSize => 'Max buffer size';

  @override
  String get settingMaxBufferSizeDescription => 'Maximum size of the audio buffer in bytes (hint for the OS)';

  @override
  String get settingKeepScreenOn => 'Keep screen on';

  @override
  String get settingKeepScreenOnDescription => 'Prevent screen from turning off during playback';

  @override
  String get settingLockMediaNotification => 'Lock media notification';

  @override
  String get settingLockMediaNotificationDescription => 'Keep media controls visible in system notification panel';

  @override
  String get settingMediaNotificationType => 'Media notification type';

  @override
  String get settingMediaNotificationTypeDescription =>
      'Choose whether notification progress tracks the full book or current chapter';

  @override
  String get settingMediaNotificationActions => 'Media notification actions';

  @override
  String get settingMediaNotificationActionsDescription => 'Customize the actions available in the media notification';

  @override
  String get settingAutoPlayLastPlayedOnAppStart => 'Auto-play last played on app start';

  @override
  String get settingAutoPlayLastPlayedOnAppStartDescription =>
      'Resume the last played item on app launch if it is not finished';

  @override
  String get settingAlwaysShowMiniPlayer => 'Always show mini player';

  @override
  String get settingAlwaysShowMiniPlayerDescription =>
      'Keep the mini player visible for your most recently played item';

  @override
  String get settingKeepWebSocketActiveInBackground => 'Keep WebSocket active in background';

  @override
  String get settingKeepWebSocketActiveInBackgroundDescription =>
      'Keep the app connected in the background to sync updates, which may increase battery use';

  @override
  String get settingEnableCaching => 'Enable caching';

  @override
  String get settingEnableCachingDescription => 'Enable response caching for API requests';

  @override
  String get settingSpeedupMode => 'Speedup mode';

  @override
  String get settingSpeedupModeDescription => 'Combine caching with background refreshes to load faster';

  @override
  String get settingRemoveAuthorsWithoutBooksDescription =>
      'Add a button in the author section to delete authors without books';

  @override
  String get settingForceMetadataRefresh => 'Force metadata refresh';

  @override
  String get settingMatchAudiobookChapters => 'Match audiobook chapters';

  @override
  String get settingSplitGenresAndTags => 'Split genres/tags';

  @override
  String get settingSplitGenresAndTagsDescription =>
      'Add a control for separating combined genre and tag values in server settings';

  @override
  String get settingLogLevel => 'Log level';

  @override
  String get settingLogLevelDescription => 'Choose the minimum severity level of logs to capture';

  @override
  String get settingReaderTheme => 'Reader theme';

  @override
  String get settingReaderThemeDescription => 'Background and text color theme of the reader';

  @override
  String get settingReaderFontSizeDescription => 'Adjust the size of the reader text';

  @override
  String get settingReaderLineSpacingDescription => 'Adjust the line spacing of the reader text';

  @override
  String get settingReaderLayoutModeDescription => 'Choose between paginated columns or vertical infinite scroll';

  @override
  String get settingStartSessionWhenReading => 'Start session when reading';

  @override
  String get settingStartSessionWhenReadingDescription => 'Track reading time on the server when using direct play';

  @override
  String get settingsCategoryApplicationSettings => 'Application settings';

  @override
  String get settingsCategoryPlayer => 'Player';

  @override
  String get settingsCategoryManagement => 'Management';

  @override
  String get settingsCategoryGlobalPlayer => 'Global player';

  @override
  String get settingsCategoryCaching => 'Caching';

  @override
  String get settingsCategoryTools => 'Tools';

  @override
  String get settingsCategoryLogs => 'Logs';

  @override
  String get settingsCategoryCompatibility => 'Compatibility';

  @override
  String get settingsCategoryGeneral => 'General';

  @override
  String get settingsCategoryShakeControls => 'Shake controls';

  @override
  String get settingsCategoryAppearance => 'Appearance';

  @override
  String get settingsCategoryReader => 'Reader';

  @override
  String settingsCategoryPath(String root, String section, String subsection) {
    String _temp0 = intl.Intl.selectLogic(subsection, {
      'none': '$root › $section',
      'other': '$root › $section › $subsection',
    });
    return '$_temp0';
  }

  @override
  String get settingsActiveAccount => 'Active account';

  @override
  String get settingsNoServerAddress => 'This account has no configured server address';

  @override
  String get settingsCreateAuthenticationCode => 'Create authentication code';

  @override
  String get settingsServerConnection => 'Server connection';

  @override
  String get settingsManageAccounts => 'Manage accounts';

  @override
  String get settingsAddAccount => 'Add account';

  @override
  String settingsAccountPreferences(String username) {
    return 'Preferences for $username';
  }

  @override
  String get settingsPlayerSettings => 'Player settings';

  @override
  String get settingsCurrentAccount => 'Current account';

  @override
  String get settingsOtherAccounts => 'Other accounts';

  @override
  String get settingsNoOtherAccounts => 'No other accounts available';

  @override
  String settingsSignOutPrompt(String username) {
    return 'Sign out from $username on this device?';
  }

  @override
  String get settingsRemoveAccountTitle => 'Remove account?';

  @override
  String settingsRemoveAccountPrompt(String username) {
    return 'Remove the saved account for $username from this device?';
  }

  @override
  String settingsAccountRemoved(String username) {
    return 'Removed the account for $username';
  }

  @override
  String settingsAccountRemovalFailed(String username) {
    return 'Could not remove the account for $username';
  }

  @override
  String settingsAccountSwitched(String username) {
    return 'Switched to $username';
  }

  @override
  String get settingsSwitchToUser => 'Switch to this user';

  @override
  String settingsOpenLinkFailed(String name) {
    return 'Could not open $name';
  }

  @override
  String get settingsGitHubRepository => 'GitHub repository';

  @override
  String get settingsIssueTracker => 'issue tracker';

  @override
  String get settingsGitHubSponsors => 'GitHub Sponsors page';

  @override
  String get settingsAboutSupport => 'About and support';

  @override
  String get settingsViewOnGitHub => 'View on GitHub';

  @override
  String get settingsReportIssue => 'Report a bug or request a feature';

  @override
  String get settingsSponsor => 'Sponsor';

  @override
  String get settingsSponsorDescription => 'Help cover active costs and support development';

  @override
  String get settingsInformationTitle => 'Information and attribution';

  @override
  String get settingsInformationDescription => 'App version, licenses, and other information';

  @override
  String get settingsCarIntegration => 'Car integration';

  @override
  String get settingsAndroidAutomotive => 'Android Automotive';

  @override
  String get settingsAndroidAuto => 'Android Auto';

  @override
  String get settingsCarPlay => 'CarPlay';

  @override
  String get validationReleaseDateFormat => 'Enter a valid release date in YYYY-MM-DD format';

  @override
  String get validationFeedUrl => 'Enter a valid HTTP or HTTPS feed URL';

  @override
  String get statusNoChangesToSave => 'No changes to save';

  @override
  String get errorSeriesSequencePromptUnavailable => 'Could not open the series number prompt. Try again';

  @override
  String get fieldSeriesNumber => 'Series number';

  @override
  String get fieldSequence => 'Sequence';

  @override
  String get hintSeriesSequence => 'For example 1, 2.5, or 03 with no spaces';

  @override
  String get actionSaveAndClose => 'Save and close';

  @override
  String get fieldSubtitle => 'Subtitle';

  @override
  String get fieldReleaseDate => 'Release date';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldAsin => 'ASIN';

  @override
  String get fieldFeedUrl => 'Feed URL';

  @override
  String get fieldItunesId => 'iTunes ID';

  @override
  String get headingMetadata => 'Metadata';

  @override
  String get fieldAuthors => 'Authors';

  @override
  String get fieldNarrators => 'Narrators';

  @override
  String get hintAddSeries => 'Add series';

  @override
  String get fieldExplicit => 'Explicit';

  @override
  String get fieldAbridged => 'Abridged';

  @override
  String get fieldDescriptionHint => 'Write a formatted description';

  @override
  String get dateFormatIso => 'YYYY-MM-DD';

  @override
  String get hintPodcastFeedUrlExample => 'https://example.com/feed.xml';

  @override
  String get fieldPodcastType => 'Podcast type';

  @override
  String get podcastTypeEpisodic => 'Episodic';

  @override
  String get podcastTypeSerial => 'Serial';

  @override
  String get statusNoAudioTracksAvailable => 'No audio tracks are available for M4B encoding';

  @override
  String get headingM4bEncoder => 'M4B encoder';

  @override
  String get optionPresets => 'Presets';

  @override
  String get optionAdvanced => 'Advanced';

  @override
  String get fieldCodec => 'Codec';

  @override
  String get fieldBitrate => 'Bitrate';

  @override
  String get fieldChannels => 'Channels';

  @override
  String get fieldAudioTracks => 'Audio tracks';

  @override
  String get channelMono => 'Mono';

  @override
  String get channelStereo => 'Stereo';

  @override
  String get statusSubmitting => 'Submitting…';

  @override
  String get statusRunning => 'Running…';

  @override
  String get actionStartEncoding => 'Start encoding';

  @override
  String get statusCanceling => 'Canceling…';

  @override
  String encoderProgress(String progress) {
    return 'Progress $progress';
  }

  @override
  String encoderBitrateKbps(int bitrate) {
    final intl.NumberFormat bitrateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String bitrateString = bitrateNumberFormat.format(bitrate);

    return '$bitrateString kbps';
  }

  @override
  String encoderChannelCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString channels', one: '1 channel');
    return '$_temp0';
  }

  @override
  String get encoderMixedCodecs => 'Mixed codecs';

  @override
  String get encoderMixedBitrates => 'Mixed bitrates';

  @override
  String get encoderMixedChannels => 'Mixed channels';

  @override
  String encoderCurrentEncoding(String codec, String bitrate, String channels) {
    return 'Current encoding $codec · $bitrate · $channels';
  }

  @override
  String audioTrackMetadata(String codec, String bitrate, String channels, String duration, String size) {
    return '$codec · $bitrate · $channels · $duration · $size';
  }

  @override
  String get navDetails => 'Details';

  @override
  String get navChapters => 'Chapters';

  @override
  String get navMatch => 'Match';

  @override
  String get navEmbedding => 'Embedding';

  @override
  String get navEncoder => 'Encoder';

  @override
  String errorRequestFailed(int statusCode) {
    final intl.NumberFormat statusCodeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String statusCodeString = statusCodeNumberFormat.format(statusCode);

    return 'Request failed with status $statusCodeString';
  }

  @override
  String errorOperationFailed(String operation, String details) {
    return '$operation failed. $details';
  }

  @override
  String get operationLoadMetadata => 'Loading metadata';

  @override
  String get operationStartEmbedding => 'Starting metadata embedding';

  @override
  String get operationStartEncoding => 'Starting M4B encoding';

  @override
  String get operationCancelEncoding => 'Canceling encoding';

  @override
  String get operationSaveItemDetails => 'Saving item details';

  @override
  String get operationLookupChapters => 'Looking up chapters';

  @override
  String get operationSaveChapters => 'Saving chapters';

  @override
  String get operationReloadChapters => 'Reloading chapters';

  @override
  String get statusNoAudioTracksForEmbedding => 'No audio tracks are available for metadata embedding';

  @override
  String get headingMetadataToEmbed => 'Metadata to embed';

  @override
  String get headingChaptersToEmbed => 'Chapters to embed';

  @override
  String get settingBackupAudioFilesBeforeEmbedding => 'Back up audio files before embedding';

  @override
  String get settingForceChapterEmbedding => 'Force chapter embedding';

  @override
  String get settingForceChapterEmbeddingDescription => 'Replace existing chapter markers when embedding metadata';

  @override
  String get actionRefreshMetadata => 'Refresh metadata';

  @override
  String get statusQueued => 'Queued';

  @override
  String get actionStartEmbedding => 'Start embedding';

  @override
  String get errorMetadataObjectMissing => 'The server did not return metadata';

  @override
  String get headingEditItem => 'Edit item';

  @override
  String get actionPreviousItem => 'Previous item';

  @override
  String get actionNextItem => 'Next item';

  @override
  String get confirmSaveChapterChanges => 'Save chapter changes?';

  @override
  String get warningChapterEditsNotSaved => 'Your chapter edits have not been saved';

  @override
  String get actionKeepEditing => 'Keep editing';

  @override
  String get actionDiscardEdits => 'Discard edits';

  @override
  String get actionAddChapters => 'Add chapters';

  @override
  String get hintChapterTitlePattern => 'Use {n} for chapter numbers';

  @override
  String get chapterTitlePatternExample => 'Chapter {n}';

  @override
  String get errorEnterTitle => 'Enter a title';

  @override
  String get fieldChapterCount => 'Number of chapters';

  @override
  String get errorChapterCountRange => 'Enter a number from 1 to 5000';

  @override
  String get fieldStartTime => 'Start';

  @override
  String fieldChapterNumber(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Chapter $numberString';
  }

  @override
  String get hintChapterTimeFormat => 'HH:MM:SS or seconds';

  @override
  String get errorValidChapterStart => 'Enter a valid start time';

  @override
  String get fieldChapterIntervalSeconds => 'Seconds between chapters';

  @override
  String get errorPositiveInterval => 'Enter a positive interval';

  @override
  String get headingShiftChapterTimes => 'Shift chapter times';

  @override
  String promptShiftSelectedChapters(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Shift $countString selected chapters',
      one: 'Shift 1 selected chapter',
    );
    return '$_temp0. The chapter at zero stays in place';
  }

  @override
  String get promptShiftAllChapters => 'Shift all chapters after the chapter at zero';

  @override
  String get hintChapterTimeShift => '-10 or 10';

  @override
  String get errorChapterTimeShiftRequired => 'Enter a positive or negative number of seconds';

  @override
  String get statusNoChaptersFoundForSearch => 'No chapters were found for this ASIN and region';

  @override
  String get errorInvalidChapterLookupData => 'The chapter lookup returned invalid data';

  @override
  String chapterLookupSummary(int foundCount, int bookCount) {
    final intl.NumberFormat foundCountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String foundCountString = foundCountNumberFormat.format(foundCount);
    final intl.NumberFormat bookCountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String bookCountString = bookCountNumberFormat.format(bookCount);

    String _temp0 = intl.Intl.pluralLogic(
      foundCount,
      locale: localeName,
      other: '$foundCountString chapters found',
      one: '1 chapter found',
    );
    String _temp1 = intl.Intl.pluralLogic(
      bookCount,
      locale: localeName,
      other: '$bookCountString chapters',
      one: '1 chapter',
    );
    return '$_temp0 · Current book $_temp1';
  }

  @override
  String chapterDurationComparison(String foundDuration, String bookDuration) {
    return 'Found duration $foundDuration. Book duration $bookDuration';
  }

  @override
  String get optionApplyChapterTitlesOnly => 'Apply titles only';

  @override
  String get descriptionKeepChapterTimes => 'Keep existing chapter times';

  @override
  String get actionApplyToDraft => 'Apply to draft';

  @override
  String get warningReplaceChapterDraft => 'This replaces the current chapter draft. Changes take effect when you save';

  @override
  String get confirmCreateChaptersFromTracks => 'Create chapters from audio tracks?';

  @override
  String get confirmReplaceUnsavedChapterEdits => 'Replace unsaved chapter edits?';

  @override
  String get confirmDiscardChapterEdits => 'Discard chapter edits?';

  @override
  String get promptRestoreChapterDraft => 'Restore the chapters currently stored on the server';

  @override
  String get actionReplace => 'Replace';

  @override
  String get statusChaptersSaved => 'Chapters saved';

  @override
  String get statusChapterSaveConflict => 'Chapters or audio tracks changed on the server. Reload before saving';

  @override
  String statusChapterErrors(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString chapters need attention',
      one: '1 chapter needs attention',
    );
    return '$_temp0';
  }

  @override
  String get statusUnsavedChanges => 'Unsaved changes';

  @override
  String get actionChapterTools => 'Tools';

  @override
  String get actionFindChapters => 'Find chapters';

  @override
  String get fieldRegion => 'Region';

  @override
  String get statusSearching => 'Searching…';

  @override
  String get actionShiftTimes => 'Shift times';

  @override
  String get actionUseAudioTracks => 'Use audio tracks';

  @override
  String get hintSearchChapters => 'Find a chapter by title or number';

  @override
  String get a11ySelectAllVisibleChapters => 'Select all visible chapters';

  @override
  String get statusEdited => 'Edited';

  @override
  String get hintChapterTitle => 'Chapter title';

  @override
  String get tooltipChapterPreview => 'Preview up to 20 seconds. Pauses playback';

  @override
  String get actionStopPreview => 'Stop preview';

  @override
  String get errorChapterPreviewUnavailable => 'Could not preview this chapter';

  @override
  String get errorBookDurationUnavailable => 'Book duration is unavailable';

  @override
  String get errorFirstChapterMustStartAtZero => 'The first chapter must start at zero';

  @override
  String get errorChapterStartOutsideBook => 'Start must be within the book';

  @override
  String get errorChapterStartsNotAscending => 'Start times must be in ascending order';

  @override
  String get tooltipChapterActions => 'Chapter actions';

  @override
  String get actionInsertChapterBelow => 'Insert chapter below';

  @override
  String get actionRemoveChapter => 'Remove chapter';

  @override
  String get actionRemoveSelected => 'Remove selected';

  @override
  String a11ySelectChapter(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Select chapter $numberString';
  }

  @override
  String get headingSwitchUser => 'Switch user';

  @override
  String get promptSwitchUserDuringPlayback =>
      'Are you sure you want to switch users? Playback progress will be saved locally and synced with the server after the app restarts';

  @override
  String get actionSwitch => 'Switch';

  @override
  String get actionAddUser => 'Add user';

  @override
  String get actionManageUsers => 'Manage users';

  @override
  String get labelUsers => 'Users';

  @override
  String get errorCouldNotLoadUsers => 'Could not load users';

  @override
  String get actionRun => 'Run';

  @override
  String get errorNoActiveApiClient => 'No active API client';

  @override
  String get errorSelectAtLeastOneLibrary => 'Select at least one library';

  @override
  String get operationLoadLibraries => 'Loading libraries';

  @override
  String adminMetadataRefreshSummary(int libraries, int tagged, int updated) {
    final intl.NumberFormat librariesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String librariesString = librariesNumberFormat.format(libraries);
    final intl.NumberFormat taggedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String taggedString = taggedNumberFormat.format(tagged);
    final intl.NumberFormat updatedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String updatedString = updatedNumberFormat.format(updated);

    String _temp0 = intl.Intl.pluralLogic(
      libraries,
      locale: localeName,
      other: '$librariesString libraries',
      one: '1 library',
    );
    String _temp1 = intl.Intl.pluralLogic(tagged, locale: localeName, other: '$taggedString items', one: '1 item');
    String _temp2 = intl.Intl.pluralLogic(
      updated,
      locale: localeName,
      other: '$updatedString updated items',
      one: '1 updated item',
    );
    return 'Processed $_temp0 and tagged $_temp1. The server reported $_temp2';
  }

  @override
  String get settingLibraryViews => 'Library views';

  @override
  String get promptSignInToManageSettings => 'Sign in to manage user settings';

  @override
  String get statusNoLibrariesFound => 'No libraries found';

  @override
  String get operationLoadSettings => 'Loading settings';

  @override
  String get operationLoadUser => 'Loading the user';

  @override
  String operationSaveSubtitlesForView(String view) {
    return 'Saving subtitles for $view';
  }

  @override
  String get libraryTypeDefault => 'Default';

  @override
  String get libraryTypeMusic => 'Music';

  @override
  String actionChangeLibraryType(String type) {
    return 'Change type to $type';
  }

  @override
  String librarySubtitleChooseInfo(String view) {
    return 'Choose which information is displayed under $view';
  }

  @override
  String validationMaxSubtitleFields(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString fields', one: '1 field');
    return 'Select up to $_temp0 for custom subtitles';
  }

  @override
  String get actionCopyRaw => 'Copy raw';

  @override
  String get actionCopyMarkdown => 'Copy Markdown';

  @override
  String get actionExportLogs => 'Export logs';

  @override
  String get actionScrollToTop => 'Scroll to top';

  @override
  String get actionScrollToBottom => 'Scroll to bottom';

  @override
  String get statusNoLogsAvailable => 'No logs available';

  @override
  String get statusLogsCopied => 'Logs copied to clipboard';

  @override
  String statusLogsExportedToPath(String path) {
    return 'Logs exported to $path';
  }

  @override
  String get statusExporting => 'Exporting…';

  @override
  String get messageLogsAppearHere => 'Logs will appear here as they are generated';

  @override
  String logEntryCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString entries', one: '1 entry');
    return '$_temp0';
  }

  @override
  String logExportSummary(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString entries', one: '1 entry');
    return 'Logs ($_temp0)';
  }

  @override
  String get operationExportLogs => 'Exporting logs';

  @override
  String get actionChoose => 'Choose';

  @override
  String get actionChooseFolder => 'Choose folder';

  @override
  String get actionChooseFiles => 'Choose files';

  @override
  String get actionUseDefaultLocation => 'Use default location';

  @override
  String get headingDownloadBehavior => 'Download behavior';

  @override
  String get settingDownloadPreference => 'Download preference';

  @override
  String get settingDownloadPreferenceDescription => 'Choose which media files to download by default';

  @override
  String get optionAskEveryTime => 'Ask every time';

  @override
  String get optionAudiobookOnly => 'Audiobook only';

  @override
  String get optionEbookOnly => 'Ebook only';

  @override
  String get settingDownloadAllAudioFiles => 'Always download all audio files';

  @override
  String get settingDownloadAllAudioFilesDescription => 'Skip audio file selection when downloading books';

  @override
  String get statusDownloadLocationUpdated => 'Download location updated';

  @override
  String get statusUsingDefaultDownloadLocation => 'Using default download location';

  @override
  String get operationSaveDownloadLocation => 'Saving download location';

  @override
  String get headingPermissionVisibility => 'Permission visibility';

  @override
  String get permissionCollections => 'Collections';

  @override
  String get permissionCollectionsDescription => 'Show controls for creating and editing collections and playlists';

  @override
  String get permissionEditItems => 'Edit items';

  @override
  String get permissionEditItemsDescription => 'Show item editing tools such as bulk edit';

  @override
  String get permissionDeleteItems => 'Delete items';

  @override
  String get permissionDeleteItemsDescription => 'Show controls for deleting items';

  @override
  String get permissionEditChapters => 'Edit chapters';

  @override
  String get permissionEditChaptersDescription => 'Show the chapter editor';

  @override
  String get permissionUploadDescription => 'Show tools for uploading new items';

  @override
  String get permissionMatches => 'Allow matches and quick matches';

  @override
  String get permissionMatchesDescription => 'Show manual match, quick match, and preview tools';

  @override
  String get permissionRequiresEditItems => 'Requires permission to edit items';

  @override
  String get permissionRequiresDeleteItems => 'Requires permission to delete items';

  @override
  String get permissionRequiresUpload => 'Requires permission to upload';

  @override
  String promptEnableSettingFirst(String setting) {
    return 'Enable \"$setting\" first';
  }

  @override
  String get headingServerEndpoints => 'Server endpoints';

  @override
  String get headingAccountCredentials => 'Account credentials';

  @override
  String get fieldExternalServerUrl => 'External server URL';

  @override
  String get fieldLocalServerUrl => 'Local server URL';

  @override
  String get hintLocalServerUrl => 'Optional · http://192.168.1.25:13378';

  @override
  String get validationInvalidExternalServerUrl => 'Enter a valid external server URL';

  @override
  String get validationInvalidLocalServerUrl => 'Enter a valid local server URL or leave it blank';

  @override
  String get validationUsernameRequired => 'Enter a username';

  @override
  String get validationPasswordRequiredForCredentialUpdate =>
      'Enter your password to update your username or credentials';

  @override
  String get statusServerSettingsSaved => 'Server settings saved';

  @override
  String get messageLocalServerPreferred =>
      'When a local address is available, the app prefers it and falls back to the external address when needed';

  @override
  String get hintPasswordCredentialUpdate => 'Only needed when changing credentials';

  @override
  String get messageEmptyPasswordKeepsCredentials => 'Leave the password empty to keep your current credentials';

  @override
  String get actionShowPassword => 'Show password';

  @override
  String get actionHidePassword => 'Hide password';

  @override
  String get errorCredentialValidationNoData => 'The server did not return account data';

  @override
  String get errorCredentialsForDifferentAccount =>
      'These credentials belong to a different account. Use Add account instead';

  @override
  String get operationSaveServerSettings => 'Saving server settings';

  @override
  String get errorUnknown => 'An unknown error occurred';

  @override
  String get operationReconcileSmartDownloads => 'Reconciling smart downloads';

  @override
  String get actionReconcileSmartDownloads => 'Reconcile now';

  @override
  String get headingDownloadRules => 'Download rules';

  @override
  String get statusNoDownloadRules => 'No automatic download rules yet';

  @override
  String smartDownloadRuleCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString active rules',
      one: '1 active rule',
      zero: 'No active rules',
    );
    return '$_temp0';
  }

  @override
  String smartDownloadProfileSummary(int sources, int items) {
    final intl.NumberFormat sourcesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String sourcesString = sourcesNumberFormat.format(sources);
    final intl.NumberFormat itemsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String itemsString = itemsNumberFormat.format(items);

    String _temp0 = intl.Intl.pluralLogic(
      sources,
      locale: localeName,
      other: '$sourcesString sources',
      one: '1 source',
      zero: 'No sources',
    );
    String _temp1 = intl.Intl.pluralLogic(items, locale: localeName, other: '$itemsString items', one: '1 item');
    return '$_temp0 · $_temp1 per source';
  }

  @override
  String get headingRemoveProfile => 'Remove profile?';

  @override
  String smartDownloadRemoveProfilePrompt(String name) {
    return 'Remove “$name” and delete its managed downloads? Downloads shared with another rule will be kept';
  }

  @override
  String get headingNewProfile => 'New profile';

  @override
  String get headingEditProfile => 'Edit profile';

  @override
  String get fieldItemsPerSource => 'Item count per source (1–150)';

  @override
  String get fieldMaximumAgeDays => 'Maximum age in days (optional)';

  @override
  String fieldStorageBudget(String unit) {
    return 'Storage budget ($unit, optional)';
  }

  @override
  String get fieldKeepFinishedBooksForHours => 'Keep finished books for hours';

  @override
  String get fieldDownloadTypes => 'Download types';

  @override
  String get optionAudiobooksAndEpisodes => 'Audiobooks and episodes';

  @override
  String get statusEnabled => 'Enabled';

  @override
  String get headingSelectedSources => 'Selected sources';

  @override
  String smartDownloadSourceName(String source) {
    return '$source source';
  }

  @override
  String get smartDownloadAfterListening => 'Download after listening';

  @override
  String get smartDownloadDefaultProfileName => 'Offline queue';

  @override
  String get headingLibrarySettings => 'Library settings';

  @override
  String get settingCheckForAppUpdates => 'Check for app updates';

  @override
  String get settingCheckForAppUpdatesDescription =>
      'Check for newer yaabsa releases when the app starts. This contacts GitHub';

  @override
  String get messageAdditionalToolsInfo => 'These optional tools extend server features and are disabled by default';

  @override
  String get headingToolSubpages => 'Tool subpages';

  @override
  String get headingPathTagGenreUpdate => 'Path, tag, and genre update';

  @override
  String get headingExperimentalTools => 'Experimental tools';

  @override
  String get headingAdminServerSettings => 'Admin server settings';

  @override
  String adminSettingsForServer(String server) {
    return 'Settings for $server';
  }

  @override
  String get statusUnknownServer => 'Unknown server';

  @override
  String get navServerConfiguration => 'Server configuration';

  @override
  String get navBackups => 'Backups';

  @override
  String get navApiKeys => 'API keys';

  @override
  String get navRssFeeds => 'RSS feeds';

  @override
  String get navEmailEReader => 'E-mail / e-reader';

  @override
  String get navAuthentication => 'Authentication';

  @override
  String get navItemMetadataUtils => 'Item metadata utilities';

  @override
  String get navLibraryStats => 'Library statistics';

  @override
  String get messageCachingGeneral => 'Configure response caching and speedup mode';

  @override
  String get messageCacheRouteRules => 'Choose cache behavior for server API routes';

  @override
  String get navCacheRouteRules => 'Route rules';

  @override
  String get permissionCachingRequired => 'Enable caching to change these options';

  @override
  String get warningCacheMayAffectMultipleDevices =>
      'Enabling this may cause unexpected behavior across multiple devices';

  @override
  String get headingBrowseSettings => 'Browse settings';

  @override
  String headingIntegrationSettings(String integration) {
    return '$integration settings';
  }

  @override
  String headingIntegrationSectionSettings(String integration, String section) {
    return '$integration $section settings';
  }

  @override
  String get navPodcastLibrary => 'Podcast library';

  @override
  String get settingGroupListsByFirstLetter => 'Group long lists by first letter';

  @override
  String settingGroupListsByFirstLetterDescription(String integration) {
    return 'Group entries alphabetically for easier browsing in long $integration lists';
  }

  @override
  String settingBrowseSortDescription(String contentType, String integration) {
    return 'Choose how $contentType items are sorted while browsing in $integration';
  }

  @override
  String get settingSortDescending => 'Sort descending';

  @override
  String settingSortDescendingDescription(String contentType) {
    return 'Sort $contentType lists in descending order';
  }

  @override
  String get fieldSortBy => 'Sort by';

  @override
  String get sortDateAdded => 'Date added';

  @override
  String get operationSaveSortOrder => 'Saving sort order';

  @override
  String get headingTransferSettings => 'Transfer settings';

  @override
  String get settingsBackupImportPrompt => 'Import settings?';

  @override
  String settingsImportConfirmation(int appSettings, int userSettings, int skippedAccounts) {
    String _temp0 = intl.Intl.pluralLogic(
      appSettings,
      locale: localeName,
      other: '$appSettings app settings',
      one: '1 app setting',
      zero: 'No app settings',
    );
    String _temp1 = intl.Intl.pluralLogic(
      userSettings,
      locale: localeName,
      other: '$userSettings account settings',
      one: '1 account setting',
      zero: 'no account settings',
    );
    String _temp2 = intl.Intl.pluralLogic(
      skippedAccounts,
      locale: localeName,
      other: '\n\n$skippedAccounts saved accounts without matching user settings will be skipped.',
      one: '\n\n1 saved account without matching user settings will be skipped.',
      zero: '',
    );
    return '$_temp0 and $_temp1 will be restored.\n\nAccount settings will be restored only for saved accounts with matching user IDs.$_temp2\n\nMatching settings will be replaced. Other settings will be kept.\n\nRestart yaabsa after importing to apply all changes.';
  }

  @override
  String get statusSettingsExported => 'Settings exported';

  @override
  String get statusSettingsImportedRestart => 'Settings imported. Restart the app to apply all changes';

  @override
  String get statusNoMatchingSettingsToImport => 'No settings to import for saved accounts with matching user IDs';

  @override
  String get operationTransferSettings => 'Transferring settings';

  @override
  String get headingManageUsers => 'Manage users';

  @override
  String get messagePlayerGeneralSettings => 'Set timeline behavior, seek intervals, and automatic queueing';

  @override
  String get messageSmartRewindSettings => 'Choose how playback rewinds after pauses';

  @override
  String get messageSleepTimerSettings => 'Set timer end behavior and optional automatic restart';

  @override
  String get messageEqualizerSettings => 'Adjust audio frequency bands';

  @override
  String get messageSubtitleSettings => 'Configure subtitles and reading support';

  @override
  String get messageShakeControlsSettings => 'Configure shake gestures and sensitivity';

  @override
  String get statusMotionSensorsRequired => 'Available on devices with motion sensors';

  @override
  String get statusShakeControlsUnavailable => 'Shake controls are not available on this device';

  @override
  String get settingsCategoryAccessibilityDevice => 'Accessibility and device';

  @override
  String get settingsCategoryBufferAndScreen => 'Buffer and screen';

  @override
  String get settingsCategoryMediaNotifications => 'Media notification';

  @override
  String get settingsCategoryStartupAndBackground => 'Startup and background';

  @override
  String get settingsCategoryAudioDecoding => 'Audio decoding';

  @override
  String get optionFullAudiobookProgressDescription => 'Show full audiobook progress and details';

  @override
  String get optionCurrentChapterProgressDescription => 'Show currently playing chapter progress and details';

  @override
  String get settingEnableMp3IndexSeeking => 'Enable MP3 index seeking';

  @override
  String get settingEnableMp3IndexSeekingDescription =>
      'Improve seeking compatibility for MP3 files. Seeking may be slower and use more data. Restart the app to apply';

  @override
  String permissionEnableSettingToChangeOption(String setting) {
    return 'Enable $setting to change this option';
  }

  @override
  String get permissionMotionSensorsRequired => 'Requires a device with motion sensors';

  @override
  String get statusCheckingVibrationSupport => 'Checking vibration support';

  @override
  String get statusVibrationUnavailable => 'This device does not support vibration feedback';

  @override
  String settingShakeSensitivityValue(double value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 1,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString g';
  }

  @override
  String get settingsCategoryTimerExpiry => 'Expiry behavior';

  @override
  String get settingsCategoryAutoRestart => 'Auto restart options';

  @override
  String get fieldTimerMode => 'Timer mode';

  @override
  String get settingTimerModeDescription => 'Chapter timers only start for items with chapters';

  @override
  String get permissionAutomaticRestartRequired => 'Enable automatic restart to configure this option';

  @override
  String get permissionTimerRangeRequired =>
      'Enable automatic restart and select a time range to configure this option';

  @override
  String get actionEnable => 'Enable';

  @override
  String get settingsCategoryTimeline => 'Timeline';

  @override
  String get optionChapterTimelineDescription => 'Track the current chapter';

  @override
  String get optionFullAudiobookTimelineDescription => 'Track the full audiobook';

  @override
  String get optionCombinedTimelineDescription => 'Track the chapter and full audiobook';

  @override
  String get optionChapterMarkersDescription => 'Show chapter markers';

  @override
  String get optionBookmarkMarkersDescription => 'Show bookmark markers';

  @override
  String get optionChapterAndBookmarkMarkersDescription => 'Show chapter and bookmark markers';

  @override
  String get optionNoTimelineMarkersDescription => 'Hide timeline markers';

  @override
  String get settingsCategoryOnScreenControls => 'On-screen controls';

  @override
  String get settingFullPlayerTransportButtons => 'Full player transport buttons';

  @override
  String get playerTypeFull => 'full player';

  @override
  String get playerTypeMini => 'mini player';

  @override
  String settingTransportModeDescription(String playerType) {
    return 'Choose whether the $playerType shows timed jumps, item and chapter skips, or both';
  }

  @override
  String get settingFullPlayerActions => 'Full player actions';

  @override
  String get settingFullPlayerActionsDescription => 'Choose the actions available in the full player';

  @override
  String get settingLeftQuickAction => 'Left quick action';

  @override
  String get settingLeftQuickActionDescription =>
      'Choose the action shown at the lower left of the minimalistic player';

  @override
  String get settingRightQuickAction => 'Right quick action';

  @override
  String get settingRightQuickActionDescription =>
      'Choose the action shown at the lower right of the minimalistic player';

  @override
  String get settingMiniPlayerTransportButtons => 'Mini player transport buttons';

  @override
  String get settingMiniPlayerActions => 'Mini player actions';

  @override
  String get settingMiniPlayerActionsDescription => 'Choose the actions available from the mini player menu';

  @override
  String get settingsCategorySkipIntervals => 'Skip intervals';

  @override
  String get settingsCategoryPlaybackBehavior => 'Playback behavior';

  @override
  String get settingStartPlaybackFromLocalProgress => 'Start from local progress';

  @override
  String get settingStartPlaybackFromLocalProgressDescription => 'Start playback without waiting for server progress';

  @override
  String get settingRestartListeningSessionAtMidnight => 'Restart listening session at midnight';

  @override
  String get settingSeekWithMediaSkipControls => 'Seek with media skip controls';

  @override
  String get settingSeekWithMediaSkipControlsDescription =>
      'Use external media next and previous controls to seek by the configured intervals';

  @override
  String get confirmSeekWithMediaSkipControlsTitle => 'Use media skip controls to seek?';

  @override
  String get confirmSeekWithMediaSkipControls =>
      'This changes how yaabsa handles external media controls, such as Bluetooth headset buttons and media keyboard shortcuts. Next and previous controls will seek by the configured intervals instead of skipping chapters or queue items.\n\nButtons in yaabsa keep their normal skip behavior. This setting affects external media controls only.';

  @override
  String get settingPreventWordClipping => 'Prevent word clipping';

  @override
  String get settingPreventWordClippingDescription =>
      'Play quiet background audio to help connected devices stay active';

  @override
  String get settingSkipSilence => 'Skip silence';

  @override
  String get settingSkipSilenceDescription => 'Automatically skip silent gaps during playback';

  @override
  String get settingShowPlayerLoopShuffle => 'Show loop and shuffle controls';

  @override
  String get optionMusicOnly => 'Music only';

  @override
  String get optionLoopShuffleHiddenDescription => 'Never show loop and shuffle controls';

  @override
  String get optionLoopShuffleMusicOnlyDescription => 'Show loop and shuffle controls only for music libraries';

  @override
  String get optionLoopShuffleAlwaysDescription => 'Always show loop and shuffle controls';

  @override
  String get settingsCategoryAutoResume => 'Auto resume';

  @override
  String get settingAutoResumeOnBluetooth => 'Auto resume on Bluetooth';

  @override
  String get settingAutoResumeOnBluetoothDescription =>
      'Automatically resume playback when a Bluetooth audio device connects';

  @override
  String get settingOnlySelectedBluetoothDevices => 'Only selected Bluetooth devices';

  @override
  String get settingOnlySelectedBluetoothDevicesDescription =>
      'Choose which paired Bluetooth devices can resume playback';

  @override
  String get fieldBluetoothAudioDevices => 'Bluetooth audio devices';

  @override
  String get statusNoBluetoothAudioDevices => 'No paired Bluetooth audio devices found';

  @override
  String get statusLoadingBluetoothAudioDevices => 'Loading paired Bluetooth audio devices';

  @override
  String get errorBluetoothPermissionRequired => 'Bluetooth permission is required to list audio devices';

  @override
  String get settingsCategoryPlayerAppearance => 'Player appearance';

  @override
  String get settingFullPlayerLayout => 'Full player layout';

  @override
  String get settingFullPlayerLayoutDescription => 'Choose how the full player arranges its components';

  @override
  String get optionAdaptiveLayoutDescription => 'Adapt the selected preset to the available screen space';

  @override
  String get optionCustomLayoutDescription => 'Use the saved component grid';

  @override
  String get settingAdaptivePreset => 'Adaptive preset';

  @override
  String get settingAdaptivePresetDescription => 'Choose the controls shown by the adaptive player';

  @override
  String get optionAdaptivePresetFullDescription => 'Show configured actions in a bottom action bar on mobile';

  @override
  String get optionAdaptivePresetMinimalisticDescription => 'Show two quick actions';

  @override
  String get optionCoverSizeAutomaticDescription => 'Use the size associated with the selected preset';

  @override
  String get optionCoverSizeCompactDescription => 'Use the smaller artwork size';

  @override
  String get optionCoverSizeLargeDescription => 'Use the larger artwork size';

  @override
  String get settingsCategoryAudioInterruptions => 'Audio interruptions';

  @override
  String get settingInterruptionBehavior => 'During interruptions';

  @override
  String get settingInterruptionBehaviorDescription =>
      'Choose whether playback pauses or lowers its volume during calls or notifications';

  @override
  String get playbackLowerVolume => 'Lower volume';

  @override
  String get optionLowerPlaybackVolumeDescription => 'Lower playback volume';

  @override
  String playerActionSelectionSummary(String description, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString actions shown',
      one: '1 action shown',
    );
    return '$description\n$_temp0';
  }

  @override
  String get hintChooseAndOrderActions => 'Choose visible actions and drag them into the preferred order';

  @override
  String get hintDragToReorder => 'Drag to reorder';

  @override
  String get settingMediaNotificationLayout => 'Media notification layout';

  @override
  String get playbackSpeedCycleDescription => 'Cycle through available playback speeds';

  @override
  String get playbackStopNotificationDescription => 'Stop playback and close the notification';

  @override
  String get playbackNextChapterDescription => 'Skip to the next chapter';

  @override
  String get playbackPreviousChapterDescription => 'Go back to the previous chapter';

  @override
  String get actionSwitchPage => 'Switch page';

  @override
  String get actionSwitchPageDescription => 'Switch to the next page of notification controls';

  @override
  String notificationSelectActionForSlot(int slot) {
    final intl.NumberFormat slotNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String slotString = slotNumberFormat.format(slot);

    return 'Select an action for slot $slotString';
  }

  @override
  String get statusEmptyActionSlot => 'Empty. Tap to assign an action';

  @override
  String get statusNotificationLayoutMayVary => 'This layout may look different across Android versions and devices';

  @override
  String get warningSwitchPageActionRequiredTitle => 'Add a switch page action';

  @override
  String warningSwitchPageActionRequired(String action) {
    return 'With multiple pages, add a $action button so you can move between them';
  }

  @override
  String get headingNotificationPages => 'Notification pages';

  @override
  String get actionAddPage => 'Add page';

  @override
  String notificationPageNumber(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Page $numberString';
  }

  @override
  String notificationArrangeButtonsPage(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Arrange buttons on page $numberString';
  }

  @override
  String notificationSlotNumber(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Slot $numberString';
  }

  @override
  String get logLevelDebug => 'Debug';

  @override
  String get logLevelInfo => 'Info';

  @override
  String get logLevelError => 'Error';

  @override
  String get logLevelDebugDescription => 'Detailed troubleshooting logs';

  @override
  String get logLevelInfoDescription => 'Informational events about operations';

  @override
  String get logLevelWarningDescription => 'Warnings for potentially problematic events';

  @override
  String get logLevelErrorDescription => 'Critical errors and failures';

  @override
  String get settingEnableEqualizer => 'Enable equalizer';

  @override
  String get errorEqualizerUnavailableOnDevice => 'Equalizer is not available on this device';

  @override
  String get statusEqualizerDisabled => 'Equalizer is disabled';

  @override
  String get promptEnableEqualizerToAdjustBands => 'Enable the equalizer above to adjust its bands during playback';

  @override
  String get statusEqualizerUnavailable => 'Equalizer unavailable';

  @override
  String get messageEqualizerWillRetry =>
      'This device could not apply the equalizer to the current audio session. Playback will continue without it and the equalizer will be retried during a later session.';

  @override
  String get statusNoActivePlaybackSession => 'No active playback session';

  @override
  String get promptStartPlaybackToConfigureEqualizer => 'Start playing an item to configure the equalizer band gains';

  @override
  String get operationLoadEqualizerParameters => 'Loading equalizer parameters';

  @override
  String get statusNoEqualizerBands => 'No equalizer bands found';

  @override
  String get settingEqualizerPreset => 'Equalizer preset';

  @override
  String get equalizerPresetFlat => 'Flat';

  @override
  String get equalizerPresetNarration => 'Narration';

  @override
  String get equalizerPresetClassical => 'Classical';

  @override
  String get equalizerPresetDance => 'Dance';

  @override
  String get equalizerPresetHeavyMetal => 'Heavy metal';

  @override
  String get equalizerPresetRock => 'Rock';

  @override
  String get headingAddSource => 'Add source';

  @override
  String get fieldLibrary => 'Library';

  @override
  String get fieldSourceType => 'Source type';

  @override
  String get fieldDownloadTrigger => 'Download when';

  @override
  String get fieldBookProgress => 'Book progress (%)';

  @override
  String get fieldMinutesListened => 'Minutes listened';

  @override
  String errorWholeNumberRange(int minimum, int maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Enter a whole number from $minimumString to $maximumString';
  }

  @override
  String get smartDownloadCurrentDeviceListeningDescription => 'Counts only playback on this device';

  @override
  String get errorLoadSmartDownloadSources => 'Could not load all sources. Retry';

  @override
  String get searchSources => 'Search sources';

  @override
  String get errorSearchSources => 'Source search failed. Try a different search term';

  @override
  String smartDownloadProgressThreshold(int percent) {
    final intl.NumberFormat percentNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$percentString%';
  }

  @override
  String get headingDownloadBook => 'Download book';

  @override
  String get headingDownloadSelectedBooks => 'Download selected books';

  @override
  String get optionAudiobookAndEbook => 'Audiobook and ebook';

  @override
  String get optionRememberDownloadChoice => 'Remember my choice';

  @override
  String get headingDownloadAudioFiles => 'Download audio files';

  @override
  String get downloadAllAudioFilesDescription => 'Download the entire audiobook';

  @override
  String get downloadCustomAudioFilesDescription => 'Choose how many files to download from the current file';

  @override
  String get downloadFromCurrentAudioFileDescription => 'Download earlier files after the last file';

  @override
  String get fieldAudioFileCount => 'Number of files';

  @override
  String get downloadAudioFileCountIncludesCurrent => 'Includes the current file';

  @override
  String get headingTaskActivity => 'Task activity';

  @override
  String get actionClearCompleted => 'Clear completed activity';

  @override
  String taskRunningCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString tasks running',
      one: '1 task running',
      zero: 'No tasks are currently running',
    );
    return '$_temp0';
  }

  @override
  String get statusNoTasksYet => 'No tasks yet';

  @override
  String get taskEmbeddingMetadata => 'Embedding metadata';

  @override
  String get taskEncodingM4b => 'Encoding M4B';

  @override
  String get taskScanningLibrary => 'Scanning library';

  @override
  String get taskMatchingLibraryItems => 'Matching library items';

  @override
  String get taskScanningItem => 'Scanning item';

  @override
  String get taskGeneric => 'Task';

  @override
  String taskScanAddedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Added $countString';
  }

  @override
  String taskScanUpdatedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Updated $countString';
  }

  @override
  String taskScanMissingCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Missing $countString';
  }

  @override
  String taskScanElapsed(String duration) {
    return 'Elapsed $duration';
  }

  @override
  String downloadRemainingFileCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString files remaining',
      one: '1 file remaining',
    );
    return '$_temp0';
  }

  @override
  String get errorCouldNotLoadActiveDownloads => 'Could not load active downloads';

  @override
  String get statusNoActiveDownloads => 'No active downloads';

  @override
  String get headingDownloadsInProgress => 'Downloads in progress';

  @override
  String get actionCancelDownload => 'Cancel download';

  @override
  String statusDownloadCanceledNamed(String name) {
    return 'Canceled $name';
  }

  @override
  String errorCancelDownloadNamed(String name) {
    return 'Could not cancel $name';
  }

  @override
  String get errorCancelDownload => 'Could not cancel download';

  @override
  String statusWithProgress(String status, String progress) {
    return '$status · $progress';
  }

  @override
  String get headingDownloadError => 'Download error';

  @override
  String get statusRetrying => 'Retrying';

  @override
  String get statusPaused => 'Paused';

  @override
  String get statusNotFound => 'Not found';

  @override
  String get navStats => 'Stats';

  @override
  String get navSettings => 'Settings';

  @override
  String get navIssues => 'Issues';

  @override
  String get headingLeaveUploadPage => 'Leave upload page?';

  @override
  String get promptLeaveUploadPageDuringUpload => 'Leaving this page now cancels active uploads. Continue?';

  @override
  String get actionStayHere => 'Stay here';

  @override
  String get actionLeavePage => 'Leave page';

  @override
  String get errorUnableToOpenMediaCenter => 'Unable to open the media center. Try Open Car Library in Settings';

  @override
  String get settingsCategoryRegional => 'Regional';

  @override
  String get settingsCategoryScanner => 'Scanner';

  @override
  String get settingsCategorySecurity => 'Security';

  @override
  String get settingStoreCoversWithItem => 'Store covers with item';

  @override
  String get settingStoreCoversWithItemDescription =>
      'Store cover images in each library item folder. Only one cover file is kept';

  @override
  String get settingStoreMetadataWithItem => 'Store metadata with item';

  @override
  String get settingStoreMetadataWithItemDescription => 'Store metadata files in each library item folder';

  @override
  String get settingIgnorePrefixesWhenSorting => 'Ignore prefixes when sorting';

  @override
  String get settingIgnorePrefixesWhenSortingDescription =>
      'Ignore configured prefixes, such as the, when sorting item titles';

  @override
  String get fieldPrefixesToIgnore => 'Prefixes to ignore (case insensitive)';

  @override
  String get errorSortingPrefixRequired => 'At least one sorting prefix is required';

  @override
  String get fieldDateFormat => 'Date format';

  @override
  String get fieldTimeFormat => 'Time format';

  @override
  String get optionTimeFormat12Hour => '12-hour (AM/PM)';

  @override
  String get optionTimeFormat24Hour => '24-hour';

  @override
  String serverLanguageName(String languageCode) {
    String _temp0 = intl.Intl.selectLogic(languageCode, {
      'ar': 'Arabic',
      'be': 'Belarusian',
      'bg': 'Bulgarian',
      'bn': 'Bengali',
      'ca': 'Catalan',
      'cs': 'Czech',
      'da': 'Danish',
      'de': 'German',
      'en_us': 'English',
      'es': 'Spanish',
      'et': 'Estonian',
      'fi': 'Finnish',
      'fr': 'French',
      'he': 'Hebrew',
      'hr': 'Croatian',
      'it': 'Italian',
      'ja': 'Japanese',
      'lt': 'Lithuanian',
      'hu': 'Hungarian',
      'ko': 'Korean',
      'nl': 'Dutch',
      'no': 'Norwegian',
      'pl': 'Polish',
      'pt_br': 'Portuguese (Brazil)',
      'ru': 'Russian',
      'sk': 'Slovak',
      'sl': 'Slovenian',
      'sv': 'Swedish',
      'tr': 'Turkish',
      'uk': 'Ukrainian',
      'vi_vn': 'Vietnamese',
      'zh_cn': 'Chinese (Simplified)',
      'zh_tw': 'Chinese (Traditional)',
      'other': '$languageCode',
    });
    return '$_temp0';
  }

  @override
  String get settingParseSubtitles => 'Parse subtitles';

  @override
  String get settingParseSubtitlesDescription => 'Read subtitle text from folder names separated by \" - \"';

  @override
  String get settingFindCovers => 'Find covers';

  @override
  String get settingFindCoversDescription => 'Search online for missing covers. This can extend scan time';

  @override
  String get settingPreferMatchedMetadata => 'Prefer matched metadata';

  @override
  String get settingPreferMatchedMetadataDescription =>
      'Use matched metadata to replace existing details during quick match';

  @override
  String get settingScanLibrariesAutomatically => 'Automatically scan libraries for changes';

  @override
  String get settingScanLibrariesAutomaticallyDescription =>
      'Add or update items after file changes. Requires a server restart';

  @override
  String get fieldAllowedCorsOrigins => 'Allowed CORS origins';

  @override
  String get errorOriginRequired => 'Origin cannot be empty';

  @override
  String get errorOriginSchemeAndHostRequired => 'Origin must include a scheme and host';

  @override
  String get errorOriginHttpHttpsOnly => 'Only HTTP and HTTPS origins are supported';

  @override
  String get errorOriginNoPathQueryFragmentOrCredentials =>
      'Origin must not include a path, query, fragment, or credentials';

  @override
  String get fieldFile => 'File';

  @override
  String get fieldCreated => 'Created';

  @override
  String get actionRestore => 'Restore';

  @override
  String get headingBackupConfiguration => 'Backup configuration';

  @override
  String get messageBackupConfiguration => 'Storage path, schedule, and retention';

  @override
  String get statusBackupLocationUnavailable => 'Backup location unavailable';

  @override
  String get statusBackupLocationEnvironmentManaged => 'Backup location is managed by the server environment';

  @override
  String get fieldBackupLocationPath => 'Backup location path';

  @override
  String get settingAutomaticBackupsEnabled => 'Enable automatic backups';

  @override
  String get fieldCronExpression => 'Cron expression';

  @override
  String get fieldBackupsToKeep => 'Backups to keep';

  @override
  String fieldMaximumBackupSize(String unit) {
    return 'Maximum backup size ($unit)';
  }

  @override
  String get messageZeroBackupSizeUnlimited => 'Use 0 for unlimited size';

  @override
  String get errorBackupPathRequired => 'Enter a backup path';

  @override
  String get errorCronRequired => 'Enter a cron expression when automatic backups are enabled';

  @override
  String get errorCronFieldCount => 'Enter a cron expression with five fields';

  @override
  String get errorBackupsToKeepRequired => 'Enter the number of backups to keep';

  @override
  String get errorMaximumBackupSizeRequired => 'Enter a maximum backup size';

  @override
  String errorWholeNumberMinimum(int minimum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);

    return 'Enter a whole number of at least $minimumString';
  }

  @override
  String get errorLoadBackups => 'Could not load backups';

  @override
  String get statusBackupLocationUpdated => 'Backup location updated';

  @override
  String get errorUpdateBackupLocation => 'Could not update the backup location';

  @override
  String get statusBackupSettingsUpdated => 'Backup settings updated';

  @override
  String get errorUpdateBackupSettings => 'Could not update backup settings';

  @override
  String get statusBackupCreated => 'Backup created successfully';

  @override
  String get errorCreateBackup => 'Could not create backup';

  @override
  String get actionSelectBackupArchive => 'Select backup archive';

  @override
  String get errorBackupFileUnavailable => 'The selected backup file is not available on this device';

  @override
  String get statusBackupUploaded => 'Backup uploaded successfully';

  @override
  String get errorUploadBackup => 'Could not upload backup';

  @override
  String get errorOpenBackupDownload => 'Could not open the backup download';

  @override
  String get errorLegacyBackupUnsupported => 'This backup uses an unsupported legacy server format';

  @override
  String get headingRestoreBackup => 'Restore backup?';

  @override
  String promptRestoreBackup(String date) {
    return 'Restore backup from $date? This replaces the current server database and metadata cache';
  }

  @override
  String get statusBackupRestoreStarted =>
      'Backup restore started. Reload the app after the server finishes applying it';

  @override
  String get errorRestoreBackup => 'Could not restore backup';

  @override
  String get headingDeleteBackup => 'Delete backup?';

  @override
  String promptDeleteBackup(String date) {
    return 'Delete backup from $date? This action cannot be undone';
  }

  @override
  String get statusBackupDeleted => 'Backup deleted';

  @override
  String get errorDeleteBackup => 'Could not delete backup';

  @override
  String get actionUploadBackup => 'Upload backup';

  @override
  String get actionCreateBackup => 'Create backup';

  @override
  String get statusNoBackupsFound => 'No backups found';

  @override
  String get messageBackupProtection =>
      'Create or upload a backup to protect your Audiobookshelf metadata and database';

  @override
  String get promptSignInForAdminAccess => 'Sign in with an admin account to continue';

  @override
  String get fieldOwner => 'Owner';

  @override
  String get fieldStatus => 'Status';

  @override
  String get fieldExpires => 'Expires';

  @override
  String get statusActive => 'Active';

  @override
  String get statusInactive => 'Inactive';

  @override
  String get statusExpired => 'Expired';

  @override
  String get statusNeverExpires => 'Never expires';

  @override
  String get statusNoApiKeysFound => 'No API keys found';

  @override
  String get messageApiKeyPurpose => 'Create an API key to allow server integrations and automation clients';

  @override
  String get errorNameRequired => 'Enter a name';

  @override
  String get errorOwnerRequired => 'Select an owner';

  @override
  String get errorExpirationDaysRequired => 'Enter the expiration in days or disable expiration';

  @override
  String get headingCreateApiKey => 'Create API key';

  @override
  String get hintExampleApiKeyName => 'Example: Home Assistant integration';

  @override
  String get hintSelectApiKeyOwner => 'Select key owner';

  @override
  String get settingApiKeyActive => 'API key is active';

  @override
  String get settingApiKeyActiveDescription => 'Inactive keys cannot authenticate API requests';

  @override
  String get settingApiKeyNeverExpiresDescription => 'Turn off to set an expiration in days';

  @override
  String get fieldExpirationDays => 'Expires in days';

  @override
  String get hintExampleExpirationDays => 'Example: 30';

  @override
  String get headingEditApiKey => 'Edit API key';

  @override
  String apiKeyCurrentOwner(String owner) {
    return 'Current owner: $owner';
  }

  @override
  String apiKeyExpiresAt(String date) {
    return 'Expires: $date';
  }

  @override
  String get errorLoadApiKeys => 'Could not load API keys';

  @override
  String get headingApiKeyCreated => 'API key created';

  @override
  String get messageApiKeyShownOnce => 'Copy this API key now. For security reasons, it is only shown once';

  @override
  String get statusApiKeyCopied => 'API key copied';

  @override
  String get errorNoEligibleApiKeyOwners => 'No eligible users are available to own an API key';

  @override
  String get statusNoServerUsers => 'No server users are available yet';

  @override
  String get statusApiKeyCreated => 'API key created successfully';

  @override
  String get errorCreateApiKey => 'Could not create API key';

  @override
  String get errorRootOwnedApiKeyEditRestricted => 'Only root users can edit API keys owned by root';

  @override
  String get statusApiKeyUpdated => 'API key updated successfully';

  @override
  String get errorUpdateApiKey => 'Could not update API key';

  @override
  String get headingDeleteApiKey => 'Delete API key?';

  @override
  String promptDeleteApiKey(String name) {
    return 'Delete API key \"$name\"? This action cannot be undone';
  }

  @override
  String get errorDeleteApiKey => 'Could not delete API key';

  @override
  String get headingDeleteSelectedApiKeys => 'Delete selected API keys?';

  @override
  String promptDeleteSelectedApiKeys(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Delete $countString selected API keys? This action cannot be undone',
      one: 'Delete 1 selected API key? This action cannot be undone',
    );
    return '$_temp0';
  }

  @override
  String statusApiKeysDeleted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString API keys deleted',
      one: '1 API key deleted',
    );
    return '$_temp0';
  }

  @override
  String errorDeleteApiKeysFailed(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Could not delete $countString API keys. Check the logs for details',
      one: 'Could not delete 1 API key. Check the logs for details',
    );
    return '$_temp0';
  }

  @override
  String get searchApiKeys => 'Search API keys';

  @override
  String get filterApiKeysByNameOrOwner => 'Filter by name or owner';

  @override
  String get filterApiKeysByNameOwnerOrStatus => 'Filter by name, owner, or status';

  @override
  String get actionAddApiKey => 'Add API key';

  @override
  String get headingUserPermissions => 'Permissions';

  @override
  String get permissionDownload => 'Can download';

  @override
  String get permissionUpdate => 'Can update';

  @override
  String get permissionDelete => 'Can delete';

  @override
  String get permissionUpload => 'Can upload';

  @override
  String get permissionCreateEreaderDevices => 'Can create e-reader devices';

  @override
  String get permissionAccessExplicitContent => 'Can access explicit content';

  @override
  String get fieldType => 'Type';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldLastSeen => 'Last seen';

  @override
  String userRoleName(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'root': 'Root',
      'user': 'User',
      'guest': 'Guest',
      'other': '$role',
    });
    return '$_temp0';
  }

  @override
  String get statusDisabled => 'Disabled';

  @override
  String get statusNoEmail => 'No email';

  @override
  String adminUserCreatedDate(String date) {
    return 'Created: $date';
  }

  @override
  String adminUserLastSeenDate(String date) {
    return 'Last seen: $date';
  }

  @override
  String get actionCreateAuthenticationCode => 'Create authentication code';

  @override
  String get actionUnlinkOpenId => 'Unlink OpenID';

  @override
  String get actionEnableUser => 'Enable user';

  @override
  String get actionDisableUser => 'Disable user';

  @override
  String get actionEnableOrDisableUser => 'Enable or disable user';

  @override
  String get messageLastSeenDetails =>
      'Last seen updates when a user connects through WebSocket. It may not include offline listening sync or third-party clients that do not use WebSocket';

  @override
  String get statusNoUsersMatchSearch => 'No users match your current search';

  @override
  String get statusNoUsersFound => 'No users found on this server';

  @override
  String get messageTryDifferentUserFilter => 'Try a different username, role, or email filter';

  @override
  String get messageCreateUsersForAccess => 'Create users to manage access and permissions';

  @override
  String get errorEmailInvalid => 'Enter a valid email address';

  @override
  String get errorPasswordRequiredForNewUser => 'Enter a password when creating a user';

  @override
  String get errorRootAccountTypeLocked => 'The root account type cannot be changed';

  @override
  String get fieldAccountType => 'Account type';

  @override
  String userRoleReservedName(String role) {
    return '$role (reserved)';
  }

  @override
  String get settingUserActive => 'User is active';

  @override
  String get statusRootAccountAlwaysActive => 'Root account is always active';

  @override
  String get settingUserActiveDescription => 'Disabled users cannot log in or access content';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get promptLeavePasswordEmptyToKeepCurrent => 'Leave empty to keep the current password';

  @override
  String get headingEditUser => 'Edit user';

  @override
  String get headingLibraryAndTagAccess => 'Library and tag access';

  @override
  String get permissionAccessAllLibraries => 'Can access all libraries';

  @override
  String get permissionAccessAllTags => 'Can access all tags';

  @override
  String get statusNoTagsFound => 'No tags available';

  @override
  String get settingInvertSelectedTags => 'Invert selected tags';

  @override
  String get settingInvertSelectedTagsDescription => 'Selected tags are blocked instead of allowed';

  @override
  String get errorUnlinkOpenId => 'Could not unlink OpenID';

  @override
  String get statusOpenIdLinkRemoved => 'OpenID link removed';

  @override
  String get actionShare => 'Share';

  @override
  String get actionShareQrCode => 'Share QR code';

  @override
  String get actionDeleteAuthenticationCodeKey => 'Delete authentication code';

  @override
  String get titleCreateAuthenticationCodeKey => 'Create authentication code key?';

  @override
  String get messageCreateAuthenticationCodeKey =>
      'yaabsa stores a server-specific encryption key in the login message. The key is hidden from browsers, but anyone who can read the public login message can retrieve it. Authentication codes that include protected sign-in data use this key so the username and password cannot be recovered from a leaked code without the key. Rotating the key invalidates existing codes that include protected data.';

  @override
  String get errorAuthenticationCodeKeyNotPreserved =>
      'Audiobookshelf did not preserve the authentication code key. No authentication code was created';

  @override
  String get statusAuthenticationCodeKeyCreated => 'Authentication code key created';

  @override
  String get errorActiveAccountNoServerAddress => 'The active account has no configured server address';

  @override
  String get titleDeleteAuthenticationCodeKey => 'Delete authentication code key?';

  @override
  String get messageDeleteAuthenticationCodeKey =>
      'Authentication codes use one server-wide key. Deleting it invalidates every authentication code. Existing signed-in accounts are not affected';

  @override
  String get statusNoAuthenticationCodeKeyConfigured => 'No authentication code key is configured';

  @override
  String get statusAuthenticationCodeKeyDeleted =>
      'Authentication code key deleted. Existing authentication codes are no longer valid';

  @override
  String errorUnlinkOpenIdUser(String username) {
    return 'Could not unlink OpenID for $username';
  }

  @override
  String get statusUserCreated => 'User created successfully';

  @override
  String get statusUserUpdated => 'User updated successfully';

  @override
  String get statusUserEnabled => 'User enabled';

  @override
  String get statusUserDisabled => 'User disabled';

  @override
  String get errorCannotDeleteCurrentUser => 'You cannot delete the currently signed-in user';

  @override
  String get titleDeleteUser => 'Delete user';

  @override
  String promptDeleteUser(String username) {
    return 'Delete user \"$username\"? This cannot be undone';
  }

  @override
  String errorDeleteUserFailed(String username) {
    return 'Could not delete user $username';
  }

  @override
  String get statusUserDeleted => 'User deleted successfully';

  @override
  String get labelSearchUsers => 'Search users';

  @override
  String get hintFilterUsers => 'Filter by username, role, or email';

  @override
  String get operationLoadUsers => 'Loading users';

  @override
  String get operationCreateAuthenticationCode => 'Creating the authentication code key';

  @override
  String get operationDeleteAuthenticationCode => 'Deleting the authentication code key';

  @override
  String get operationUnlinkOpenId => 'Unlinking OpenID';

  @override
  String get operationCreateUser => 'Creating the user';

  @override
  String get operationUpdateUser => 'Updating the user';

  @override
  String get operationUpdateUserStatus => 'Updating the user status';

  @override
  String get operationDeleteUser => 'Deleting the user';

  @override
  String get messageShareAuthenticationCode =>
      'Create an authentication code with the server details needed to sign in';

  @override
  String get serverLocationExternal => 'external';

  @override
  String get serverLocationLocal => 'local';

  @override
  String serverUrlLocation(String url, String location) {
    return '$url ($location)';
  }

  @override
  String get optionIncludeSetPassword => 'Include set password';

  @override
  String get descriptionIncludedSetPassword =>
      'The user can sign in without typing the password and must choose a new password immediately';

  @override
  String get optionIncludeCustomHeaders => 'Include custom headers';

  @override
  String messageSavedHeadersIncluded(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString saved headers will be included',
      one: '1 saved header will be included',
    );
    return '$_temp0';
  }

  @override
  String get errorAcknowledgePasswordSharingRisk => 'Acknowledge the password-sharing risk before continuing';

  @override
  String get errorAcknowledgeCustomHeadersRisk => 'Acknowledge the custom-header risk before continuing';

  @override
  String get errorAuthenticationCodeKeyRequired =>
      'A server key is required to include protected sign-in data. Ask an administrator to enable it first';

  @override
  String get operationGenerateAuthenticationCode => 'Generating the authentication code';

  @override
  String get errorQrCodeSharingUnavailable => 'QR code sharing is unavailable on this platform';

  @override
  String get shareAuthenticationCodeTitle => 'yaabsa authentication code';

  @override
  String get statusAuthenticationCodeCopied => 'Authentication code copied';

  @override
  String get messagePasswordSharingAcknowledgement =>
      'I understand that anyone who gets this code can use the temporary password until it is changed or the authentication code key is rotated';

  @override
  String get messageCustomHeadersAcknowledgement =>
      'I understand that custom headers may contain secrets or grant server access';

  @override
  String get messageUseAuthenticationCode =>
      'Scan this code in yaabsa on the other device, or copy the raw authentication code and use Import authentication code on the sign-in screen';

  @override
  String get semanticsAuthenticationCodeQrCode => 'yaabsa authentication code QR code';

  @override
  String get statusGenerating => 'Generating…';

  @override
  String get errorServerLogLevelUnavailable => 'The server did not return the current log level';

  @override
  String get operationLoadServerLogs => 'Loading server logs';

  @override
  String get operationUpdateServerLogLevel => 'Updating the server log level';

  @override
  String get fieldSearchLogs => 'Search logs';

  @override
  String get fieldServerLogLevel => 'Server log level';

  @override
  String get settingLogAutoScroll => 'Auto-scroll';

  @override
  String get statusNoLogsMatchSearch => 'No logs match the current search';

  @override
  String logLevelName(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'trace': 'Trace',
      'debug': 'Debug',
      'info': 'Information',
      'warn': 'Warning',
      'error': 'Error',
      'other': 'Unknown',
    });
    return '$_temp0';
  }

  @override
  String get errorPositiveWholeNumberRequired => 'Enter a positive whole number';

  @override
  String get headingUploadMode => 'Upload mode';

  @override
  String get messageUploadPermissionRequired => 'Upload permission is required';

  @override
  String get messageEnableUploadActionsFirst => 'Enable upload actions first';

  @override
  String get messageSelectLibraryBeforeUpload => 'Select a library before opening upload mode';

  @override
  String get settingLiveUpdates => 'Live updates';

  @override
  String get settingLiveUpdatesDescription => 'Show playback progress in the Android status bar';

  @override
  String get fieldTargetLibraries => 'Target libraries';

  @override
  String get statusNoGenresFound => 'No genres available';

  @override
  String get operationLoadMetadataUtilities => 'Loading item metadata tools';

  @override
  String get errorDeleteCustomMetadataProviderFailed => 'Could not delete the custom metadata provider';

  @override
  String get headingCustomMetadataProviders => 'Custom metadata providers';

  @override
  String get headingAddCustomMetadataProvider => 'Add custom metadata provider';

  @override
  String get headingEditCustomMetadataProvider => 'Edit custom metadata provider';

  @override
  String statusCustomMetadataProviderAdded(String name) {
    return 'Added provider \"$name\"';
  }

  @override
  String statusCustomMetadataProviderUpdated(String name) {
    return 'Updated provider \"$name\"';
  }

  @override
  String get titleDeleteCustomMetadataProvider => 'Delete provider?';

  @override
  String promptDeleteCustomMetadataProvider(String name) {
    return 'Delete custom metadata provider \"$name\"?';
  }

  @override
  String statusCustomMetadataProviderDeleted(String name) {
    return 'Deleted provider \"$name\"';
  }

  @override
  String get statusNoCustomMetadataProviders => 'No custom metadata providers found';

  @override
  String get statusAuthHeaderConfigured => 'Authentication header configured';

  @override
  String get fieldUrl => 'URL';

  @override
  String get fieldAuthHeaderValue => 'Authentication header value';

  @override
  String get validationHttpUrlRequired => 'Enter a valid HTTP or HTTPS URL';

  @override
  String get operationCreateCustomMetadataProvider => 'Creating the custom metadata provider';

  @override
  String get operationUpdateCustomMetadataProvider => 'Updating the custom metadata provider';

  @override
  String get operationDeleteCustomMetadataProvider => 'Deleting the custom metadata provider';

  @override
  String metadataTermRenameTitle(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Rename tag',
      'genre': 'Rename genre',
      'other': 'Rename term',
    });
    return '$_temp0';
  }

  @override
  String get errorNameMustChange => 'Enter a different name';

  @override
  String statusMetadataItemsUpdated(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items updated',
      one: '1 item updated',
      zero: 'No items updated',
    );
    return '$_temp0';
  }

  @override
  String statusMetadataItemsMerged(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items updated. Existing values were merged',
      one: '1 item updated. Existing values were merged',
      zero: 'No items updated. Existing values were merged',
    );
    return '$_temp0';
  }

  @override
  String metadataTermDeleteTitle(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Delete tag?',
      'genre': 'Delete genre?',
      'other': 'Delete term?',
    });
    return '$_temp0';
  }

  @override
  String promptRemoveMetadataTermFromItems(String term) {
    return 'Remove \"$term\" from all items?';
  }

  @override
  String errorMetadataTermRenameFailed(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Could not rename the tag',
      'genre': 'Could not rename the genre',
      'other': 'Could not rename the term',
    });
    return '$_temp0';
  }

  @override
  String errorMetadataTermDeleteFailed(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Could not delete the tag',
      'genre': 'Could not delete the genre',
      'other': 'Could not delete the term',
    });
    return '$_temp0';
  }

  @override
  String metadataSplitTerms(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Split tags',
      'genre': 'Split genres',
      'other': 'Split terms',
    });
    return '$_temp0';
  }

  @override
  String messageSplitMetadataTerms(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Split combined tag values using the delimiter below and update affected items in the selected libraries',
      'genre':
          'Split combined genre values using the delimiter below and update affected items in the selected libraries',
      'other': 'Split combined metadata values using the delimiter below and update affected items in the selected libraries',
    });
    return '$_temp0';
  }

  @override
  String get fieldDelimiter => 'Delimiter';

  @override
  String messageDelimiterExample(String delimiter) {
    return 'Use $delimiter to split combined values such as Fantasy and Sci-Fi';
  }

  @override
  String get errorDelimiterRequired => 'Enter a delimiter';

  @override
  String get operationSplitMetadataTerms => 'Splitting metadata values';

  @override
  String statusMetadataTermsSplit(String termType, int terms, int items, int updates, int libraries) {
    final intl.NumberFormat termsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String termsString = termsNumberFormat.format(terms);
    final intl.NumberFormat itemsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String itemsString = itemsNumberFormat.format(items);
    final intl.NumberFormat updatesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String updatesString = updatesNumberFormat.format(updates);
    final intl.NumberFormat librariesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String librariesString = librariesNumberFormat.format(libraries);

    String _temp0 = intl.Intl.selectLogic(termType, {'tag': 'tag', 'genre': 'genre', 'other': 'metadata'});
    String _temp1 = intl.Intl.selectLogic(termType, {'tag': 'tag', 'genre': 'genre', 'other': 'metadata'});
    String _temp2 = intl.Intl.selectLogic(termType, {'tag': 'tag', 'genre': 'genre', 'other': 'metadata'});
    String _temp3 = intl.Intl.pluralLogic(
      terms,
      locale: localeName,
      other: '$termsString composite $_temp0 values',
      one: '1 composite $_temp1 value',
      zero: 'no composite $_temp2 values',
    );
    String _temp4 = intl.Intl.pluralLogic(
      items,
      locale: localeName,
      other: '$itemsString items',
      one: '1 item',
      zero: 'no items',
    );
    String _temp5 = intl.Intl.pluralLogic(
      updates,
      locale: localeName,
      other: '$updatesString updates',
      one: '1 update',
      zero: 'no updates',
    );
    String _temp6 = intl.Intl.pluralLogic(
      libraries,
      locale: localeName,
      other: '$librariesString libraries',
      one: '1 library',
      zero: 'no libraries',
    );
    return 'Split $_temp3, touched $_temp4, and applied $_temp5 across $_temp6';
  }

  @override
  String get statusNoneSelected => 'None selected';

  @override
  String errorDropdownConfiguration(String label) {
    return 'The options for $label are invalid';
  }

  @override
  String errorDropdownDefaultTypeMismatch(String settingKey, String type) {
    return 'The default value for $settingKey has type $type, which does not match its available options';
  }

  @override
  String headingHomeNavigationPreferences(String mediaType) {
    String _temp0 = intl.Intl.selectLogic(mediaType, {
      'book': 'Audiobook home tabs',
      'podcast': 'Podcast home tabs',
      'other': 'Home tabs',
    });
    return '$_temp0';
  }

  @override
  String headingPersonalizedShelfPreferences(String mediaType) {
    String _temp0 = intl.Intl.selectLogic(mediaType, {
      'book': 'Audiobook home sections',
      'podcast': 'Podcast home sections',
      'other': 'Home sections',
    });
    return '$_temp0';
  }

  @override
  String statusPreferencesReset(String section) {
    return '$section reset to defaults';
  }

  @override
  String get errorKeepOneHomeViewEnabled => 'At least one home view must stay enabled';

  @override
  String get statusDefaultView => 'Default view';

  @override
  String get actionSetAsDefaultView => 'Set as default view';

  @override
  String get hintEnableViewToSetDefault => 'Enable this view to set it as default';

  @override
  String get operationSaveSettings => 'Saving settings';

  @override
  String themeModeName(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'light': 'Light',
      'dark': 'Dark',
      'amoled': 'AMOLED',
      'system': 'System',
      'other': 'System',
    });
    return '$_temp0';
  }

  @override
  String themePresetName(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'yaabsa': 'yaabsa',
      'ember': 'Ember',
      'moss': 'Moss',
      'cobalt': 'Cobalt',
      'rose': 'Rose',
      'custom': 'Custom',
      'other': 'Custom',
    });
    return '$_temp0';
  }

  @override
  String themePresetDescription(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'yaabsa': 'Balanced teal accents with soft contrast',
      'ember': 'Warm orange highlights and bright surfaces',
      'moss': 'Natural green tones with a calm look',
      'cobalt': 'Cool blue accents with crisp contrast',
      'rose': 'Soft rose highlights',
      'custom': 'Build a color profile using your preferred accent color',
      'other': 'Choose a theme color profile',
    });
    return '$_temp0';
  }

  @override
  String get headingThemeMode => 'Theme mode';

  @override
  String get headingThemePresets => 'Theme presets';

  @override
  String get headingCustomTheme => 'Custom theme';

  @override
  String themeAccentColorValue(String hex) {
    return '$hex accent';
  }

  @override
  String themeRgbValues(int red, int green, int blue) {
    final intl.NumberFormat redNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String redString = redNumberFormat.format(red);
    final intl.NumberFormat greenNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String greenString = greenNumberFormat.format(green);
    final intl.NumberFormat blueNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String blueString = blueNumberFormat.format(blue);

    return 'R $redString, G $greenString, B $blueString';
  }

  @override
  String get colorChannelRed => 'Red';

  @override
  String get colorChannelGreen => 'Green';

  @override
  String get colorChannelBlue => 'Blue';

  @override
  String get headingQuickColors => 'Quick colors';

  @override
  String get statusNoCustomHeadersConfigured => 'No custom headers are configured';

  @override
  String get messageCustomHeadersSentWithRequests =>
      'These headers are sent with requests to this server. Header values may contain secrets, so share them only with trusted people';

  @override
  String get actionAddCustomHeader => 'Add custom header';

  @override
  String get titleAddCustomHeader => 'Add header';

  @override
  String get titleEditCustomHeader => 'Edit header';

  @override
  String get headingSmtpSettings => 'SMTP settings';

  @override
  String get messageConfigureSmtpEmailDelivery =>
      'Configure server email delivery and send a test message to check the connection';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldFromAddress => 'From address';

  @override
  String get fieldTestAddress => 'Test address';

  @override
  String get settingSecureSmtpConnection => 'Use a secure SMTP connection';

  @override
  String get settingRejectUnauthorizedCertificates => 'Reject unauthorized certificates';

  @override
  String get settingRejectUnauthorizedCertificatesDescription =>
      'Disable only when the SMTP server uses a self-signed certificate';

  @override
  String get actionSendTestEmail => 'Send test';

  @override
  String emailDeviceAvailabilityName(String availability) {
    String _temp0 = intl.Intl.selectLogic(availability, {
      'adminOrUp': 'Admin and up',
      'userOrUp': 'User and up',
      'guestOrUp': 'Guest and up',
      'specificUsers': 'Specific users',
      'other': 'Admin and up',
    });
    return '$_temp0';
  }

  @override
  String emailDeviceAccessWithUserCount(String access, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$access ($countString)';
  }

  @override
  String get fieldDeviceName => 'Device name';

  @override
  String get exampleEreaderDeviceName => 'Kindle';

  @override
  String get fieldDeviceEmail => 'Device email';

  @override
  String get exampleEreaderDeviceEmail => 'kindle@kindle.com';

  @override
  String get fieldAccessibleBy => 'Accessible by';

  @override
  String get fieldAllowedUsers => 'Allowed users';

  @override
  String get statusNoUsersAvailable => 'No users available';

  @override
  String get errorDeviceNameRequired => 'Enter a device name';

  @override
  String get errorDeviceNameAlreadyExists => 'A device with this name already exists';

  @override
  String get errorDeviceEmailRequired => 'Enter a device email address';

  @override
  String get errorDeviceEmailInvalid => 'Enter a valid device email address';

  @override
  String get errorSelectAtLeastOneUserForSpecificAccess => 'Select at least one user for specific access';

  @override
  String get headingEditEreaderDevice => 'Edit e-reader device';

  @override
  String get headingAddEreaderDevice => 'Add e-reader device';

  @override
  String get statusNoEreaderDevicesFound => 'No e-reader devices found';

  @override
  String get messageAddEreaderDeviceDestination => 'Add a destination to enable send-to-device email delivery';

  @override
  String get titleDeleteEreaderDevice => 'Delete e-reader device';

  @override
  String promptDeleteEreaderDevice(String name) {
    return 'Delete $name? This removes the destination from send-to-device email delivery';
  }

  @override
  String get statusEmailSettingsSaved => 'Email settings saved';

  @override
  String get statusTestEmailSent => 'Test email sent';

  @override
  String get errorEmailTestSendFailed => 'Could not send the test email';

  @override
  String get statusEreaderDeviceAdded => 'E-reader device added';

  @override
  String get statusEreaderDeviceUpdated => 'E-reader device updated';

  @override
  String get statusEreaderDeviceDeleted => 'E-reader device deleted';

  @override
  String get operationLoadEmailSettings => 'Loading server email settings';

  @override
  String get operationSaveEmailSettings => 'Saving server email settings';

  @override
  String get operationSendTestEmail => 'Sending a test email';

  @override
  String get operationAddEreaderDevice => 'Adding the e-reader device';

  @override
  String get operationUpdateEreaderDevice => 'Updating the e-reader device';

  @override
  String get operationDeleteEreaderDevice => 'Deleting the e-reader device';

  @override
  String get errorEmailHostRequired => 'Enter a host';

  @override
  String get errorEmailPortRequired => 'Enter a port';

  @override
  String get errorEmailPortMustBeNumber => 'Enter a valid port number';

  @override
  String errorEmailPortRange(int minimum, int maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Enter a port between $minimumString and $maximumString';
  }

  @override
  String errorEmailFieldInvalid(String field) {
    return 'Enter a valid email address for $field';
  }

  @override
  String get headingFolders => 'Folders';

  @override
  String get statusNoFoldersAdded => 'No folders added yet';

  @override
  String get statusExistingFolder => 'Existing folder';

  @override
  String get fieldAddFolderPath => 'Add folder path';

  @override
  String get actionAddFolder => 'Add folder';

  @override
  String get fieldSearchLibraries => 'Search libraries';

  @override
  String get hintSearchLibraries => 'Filter by name, provider, media type, or path';

  @override
  String statusLibraryCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString libraries',
      one: '1 library',
      zero: 'No libraries',
    );
    return '$_temp0';
  }

  @override
  String statusLibraryFilteredCount(int filtered, int total) {
    final intl.NumberFormat filteredNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String filteredString = filteredNumberFormat.format(filtered);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(total, locale: localeName, other: '$totalString libraries', one: '1 library');
    return '$filteredString of $_temp0';
  }

  @override
  String get statusSavingLibraryOrder => 'Saving order…';

  @override
  String get statusLibraryCreated => 'Library created successfully';

  @override
  String get statusLibraryUpdated => 'Library updated successfully';

  @override
  String get statusLibraryDeleted => 'Library deleted';

  @override
  String get statusLibraryOrderUpdated => 'Library order updated';

  @override
  String get statusLibraryScanStarted => 'Library scan started';

  @override
  String get statusLibraryForceRescanStarted => 'Force rescan started';

  @override
  String get statusMatchAllMetadataStarted => 'Started match-all metadata job';

  @override
  String get errorLoadLibrariesFailed => 'Could not load libraries';

  @override
  String get errorCreateLibraryFailed => 'Could not create library';

  @override
  String get errorUpdateLibraryFailed => 'Could not update library';

  @override
  String get errorDeleteLibraryFailed => 'Could not delete library';

  @override
  String get errorStartLibraryScanFailed => 'Could not start library scan';

  @override
  String get errorSaveLibraryOrderFailed => 'Could not save library order';

  @override
  String get errorStartMatchAllMetadataFailed => 'Could not start the match-all metadata job';

  @override
  String get headingDeleteLibrary => 'Delete library?';

  @override
  String promptDeleteLibrary(String name) {
    return 'Delete \"$name\"? This action cannot be undone';
  }

  @override
  String get actionScan => 'Scan';

  @override
  String get actionForceRescan => 'Force rescan';

  @override
  String get actionMatchAllBooks => 'Match all books';

  @override
  String get headingLibraryActions => 'Library actions';

  @override
  String get statusNoLibrariesAvailable => 'No libraries available on this server';

  @override
  String get statusNoLibrariesMatchSearch => 'No libraries match your search query';

  @override
  String get messageCreateLibraryToAddContent => 'Create a library to add books or podcasts';

  @override
  String get hintAdjustSearchQuery => 'Try adjusting your search query';

  @override
  String errorLoadAdminUserData(String error) {
    return 'Could not load user data: $error';
  }

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryFrance => 'France';

  @override
  String get countrySpain => 'Spain';

  @override
  String get countryItaly => 'Italy';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countryCanada => 'Canada';

  @override
  String get metadataSourceFolderStructure => 'Folder structure';

  @override
  String get metadataSourceAudioAndEbookMetadata => 'Audio and ebook metadata';

  @override
  String get metadataSourceNfoFile => 'NFO file';

  @override
  String get metadataSourceDescriptionFiles => 'desc.txt and reader.txt';

  @override
  String get metadataSourceOpfFile => 'OPF file';

  @override
  String get metadataSourceAudiobookshelfFile => 'Audiobookshelf metadata file';

  @override
  String get errorLibraryFolderPathAlreadyExists => 'This folder path has already been added';

  @override
  String get errorNestedFolderPathsNotAllowed => 'Nested folder paths are not allowed';

  @override
  String get errorLibraryNameRequired => 'Enter a library name';

  @override
  String get errorAddAtLeastOneFolderPath => 'Add at least one folder path';

  @override
  String get errorFolderPathsCannotBeEmpty => 'Folder paths cannot be empty';

  @override
  String get errorDuplicateFolderPathsNotAllowed => 'Duplicate folder paths are not allowed';

  @override
  String get errorCronRequiredWhenLibrarySchedulingEnabled =>
      'Enter a cron expression when scheduled scans are enabled';

  @override
  String errorPercentBetweenZeroAndHundred(int minimum, int maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Enter a value between $minimumString and $maximumString';
  }

  @override
  String get titleSelectLibraryFolder => 'Select library folder';

  @override
  String statusNoLibraryMetadataFilesFound(String extension) {
    return 'No .$extension metadata files were found';
  }

  @override
  String statusNoLibraryMetadataFilesRemoved(String extension) {
    return 'No .$extension metadata files were removed';
  }

  @override
  String statusLibraryMetadataFilesRemoved(int count, String extension) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString .$extension metadata files',
      one: '1 .$extension metadata file',
    );
    return 'Removed $_temp0';
  }

  @override
  String errorRemoveLibraryMetadataFilesFailed(String extension, String error) {
    return 'Could not remove .$extension metadata files: $error';
  }

  @override
  String errorMatchAllMetadataFailed(String error) {
    return 'Could not start the match-all metadata job: $error';
  }

  @override
  String get hintSelectMetadataProvider => 'Select a metadata provider';

  @override
  String get fieldMediaType => 'Media type';

  @override
  String get hintMediaTypeCannotBeChanged => 'The media type cannot be changed after the library is created';

  @override
  String get hintLibraryNameExample => 'My audiobooks';

  @override
  String get fieldLibraryIcon => 'Library icon';

  @override
  String get hintSelectLibraryIcon => 'Select a library icon';

  @override
  String get headingLibraryBehavior => 'Library behavior';

  @override
  String get settingUseSquareBookCovers => 'Use square book covers';

  @override
  String get settingAudiobooksOnly => 'Audiobooks only';

  @override
  String get settingHideSingleBookSeries => 'Hide single-book series';

  @override
  String get settingOnlyShowLaterBooksInContinueSeries => 'Only show later books in continue series';

  @override
  String get settingAllowScriptedEbookContent => 'Allow scripted ebook content';

  @override
  String get headingMarkAsFinishedThreshold => 'Mark as finished threshold';

  @override
  String get optionTimeRemainingSeconds => 'Time remaining in seconds';

  @override
  String get optionPercentComplete => 'Percent complete';

  @override
  String get fieldMode => 'Mode';

  @override
  String get fieldPercent => 'Percent';

  @override
  String get fieldPodcastSearchRegion => 'Podcast search region';

  @override
  String get messageScannerSettingsBookLibrariesOnly => 'Scanner settings are available for audiobook libraries';

  @override
  String get settingEnableFolderWatcher => 'Enable folder watcher';

  @override
  String get settingEnableFolderWatcherDescription => 'Turn this off if the server cannot reliably watch file changes';

  @override
  String get settingSkipMatchingBooksWithAsin => 'Skip matching books with ASIN';

  @override
  String get settingSkipMatchingBooksWithIsbn => 'Skip matching books with ISBN';

  @override
  String get settingEnableScheduledScans => 'Enable scheduled scans';

  @override
  String settingScheduledScansDescription(String example) {
    return 'Use cron syntax. Example: $example runs weekly on Monday at 00:00';
  }

  @override
  String get hintDisableSchedulingToClearCron => 'Turn off scheduling to clear the cron expression';

  @override
  String get messageCreateLibraryBeforeUsingTools => 'Create the library first to access its tools';

  @override
  String get headingLibraryMetadataFileCleanup => 'Metadata file cleanup';

  @override
  String get messageRemoveGeneratedLibraryMetadataFiles => 'Remove generated metadata files from library folders';

  @override
  String actionRemoveMetadataFile(String fileName) {
    return 'Remove $fileName';
  }

  @override
  String get messageRunMatchAllMetadataForLibrary => 'Run the server match-all process for this library';

  @override
  String get actionStartMatchAll => 'Start match-all';

  @override
  String get settingsCategorySchedule => 'Schedule';

  @override
  String get statusOnlyActiveMetadataSource => 'Only active source';

  @override
  String get statusHighestMetadataPriority => 'Highest priority';

  @override
  String get statusLowestMetadataPriority => 'Lowest priority';

  @override
  String statusMetadataPriority(int position, int count) {
    final intl.NumberFormat positionNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Priority $positionString of $countString';
  }

  @override
  String get headingMetadataPrecedence => 'Metadata precedence';

  @override
  String get statusNoMetadataSourcesAvailable => 'No metadata sources available';

  @override
  String get entityItem => 'Item';

  @override
  String get fieldRssFeed => 'Feed';

  @override
  String get fieldEntity => 'Entity';

  @override
  String get fieldSearchRssFeeds => 'Search RSS feeds';

  @override
  String get hintSearchRssFeeds => 'Filter by title, URL, author, or entity';

  @override
  String statusRssFeedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString feeds',
      one: '1 feed',
      zero: 'No feeds',
    );
    return '$_temp0';
  }

  @override
  String statusRssFeedFilteredCount(int filtered, int total) {
    final intl.NumberFormat filteredNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String filteredString = filteredNumberFormat.format(filtered);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(total, locale: localeName, other: '$totalString feeds', one: '1 feed');
    return '$filteredString of $_temp0';
  }

  @override
  String statusRssFeedEntitySummary(String entity, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString episodes',
      one: '1 episode',
      zero: 'No episodes',
    );
    return '$entity • $_temp0';
  }

  @override
  String get headingCloseRssFeed => 'Close RSS feed?';

  @override
  String promptCloseRssFeed(String name) {
    return 'Close \"$name\"?';
  }

  @override
  String get actionCloseRssFeed => 'Close feed';

  @override
  String get statusRssFeedClosed => 'RSS feed closed';

  @override
  String get errorCloseRssFeedFailed => 'Could not close RSS feed';

  @override
  String get errorLoadRssFeedsFailed => 'Could not load RSS feeds';

  @override
  String get statusNoRssFeedsFound => 'No RSS feeds found';

  @override
  String get statusNoRssFeedsMatchSearch => 'No RSS feeds match your search';

  @override
  String get messageRssFeedsAppearHere => 'Feeds will appear here';

  @override
  String get hintAdjustRssFeedSearch => 'Try a different title, URL, author, or entity';

  @override
  String get headingRssFeedDetails => 'RSS feed details';

  @override
  String get fieldOwnerName => 'Owner name';

  @override
  String get fieldOwnerEmail => 'Owner email';

  @override
  String get statusRssFeedUrlCopied => 'Feed URL copied';

  @override
  String get actionCopyFeedUrl => 'Copy feed URL';

  @override
  String get messageRssFeedPreventIndexing => 'This feed is marked to prevent indexing';

  @override
  String labelEpisodeSeasonAndNumber(String season, String episode) {
    return 'Season $season, episode $episode';
  }

  @override
  String labelEpisodeNumber(String episode) {
    return 'Episode $episode';
  }

  @override
  String get statusNoEpisodesInRssFeed => 'No episodes in this feed';

  @override
  String get messageRssEpisodesAppearHere => 'Episodes will appear here when available';

  @override
  String get headingLanguages => 'Languages';

  @override
  String get headingMissingMetadata => 'Missing metadata';

  @override
  String get headingSpecialFilters => 'Special';

  @override
  String get filterOpenFeeds => 'Open feeds';

  @override
  String get statusNotStarted => 'Not started';

  @override
  String get statusNotFinished => 'Not finished';

  @override
  String get filterSingleTrack => 'Single track';

  @override
  String get filterMultipleTracks => 'Multiple tracks';

  @override
  String get statusNoSeriesFilterOption => 'No series';

  @override
  String get statusNoFilterOptionsAvailable => 'No filter options available';

  @override
  String get messageNoLibraryFilterValues => 'This library does not have any filter values yet';

  @override
  String statusSelectedFilterOption(String option) {
    return 'Selected: $option';
  }

  @override
  String statusFilterOptionCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString options', one: '1 option');
    return '$_temp0';
  }

  @override
  String get fieldSearchOptions => 'Search options';

  @override
  String get hintSearchWithinOptions => 'Search this section';

  @override
  String get statusNoMatchingOptions => 'No matching options';

  @override
  String get actionSort => 'Sort';

  @override
  String get sortAscending => 'Ascending';

  @override
  String get sortDescending => 'Descending';

  @override
  String errorDownloadFileFailed(String error) {
    return 'Could not download file: $error';
  }

  @override
  String promptDeleteDownloadedFile(String name) {
    return 'Remove $name from offline storage?';
  }

  @override
  String get errorDeleteDownloadedFileFailed => 'Could not delete this file';

  @override
  String errorDeleteDownloadedFileDetails(String error) {
    return 'Could not delete file: $error';
  }

  @override
  String errorCancelDownloadDetails(String error) {
    return 'Could not cancel download: $error';
  }

  @override
  String get errorLoadDownloadFilesFailed => 'Could not load this download';

  @override
  String get statusDownloadNoLongerAvailable => 'This download has been removed';

  @override
  String downloadedFileCountSummary(int downloaded, int total) {
    final intl.NumberFormat downloadedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String downloadedString = downloadedNumberFormat.format(downloaded);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$totalString files offline',
      one: '1 file offline',
    );
    return '$downloadedString of $_temp0';
  }

  @override
  String get actionDownloadMissingFiles => 'Download missing files';

  @override
  String get actionRetryLoadingFiles => 'Retry loading files';

  @override
  String get statusNotDownloaded => 'Not downloaded';

  @override
  String get statusAvailableOffline => 'Available offline';

  @override
  String get statusOffline => 'Offline';

  @override
  String downloadOfflineFileCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString files offline',
      one: '1 file offline',
    );
    return '$_temp0';
  }

  @override
  String downloadedFilesPartialTooltip(int downloaded, int total) {
    final intl.NumberFormat downloadedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String downloadedString = downloadedNumberFormat.format(downloaded);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(total, locale: localeName, other: '$totalString files', one: '1 file');
    return '$downloadedString of $_temp0 offline. Manage files';
  }

  @override
  String get headingDownloadActions => 'Download actions';

  @override
  String get statusSmartDownload => 'Smart download';

  @override
  String get errorLoadOptionsFailed => 'Could not load options';

  @override
  String get statusCollectionsUpdated => 'Collections updated';

  @override
  String get statusPlaylistsUpdated => 'Playlists updated';

  @override
  String get errorFullListUnavailable => 'The full list is unavailable';

  @override
  String get errorOnlyOwnPlaylistsCanBeEdited => 'Only your own playlists can be edited';

  @override
  String get headingDeleteEmptyPlaylists => 'Delete empty playlists?';

  @override
  String promptRemovingBookMayDeleteEmptyPlaylists(String names) {
    return 'Removing this book will leave these playlists empty. Audiobookshelf will delete them:\n\n$names';
  }

  @override
  String errorLoadNamedListFailed(String lists) {
    return 'Could not load $lists';
  }

  @override
  String statusNoNamedListsFound(String lists) {
    return 'No $lists found in this library';
  }

  @override
  String headingManageNamedLists(String lists) {
    return 'Manage $lists';
  }

  @override
  String get statusNamedListChangedReviewUpdates => 'This list changed. Review the updates before saving';

  @override
  String get errorEditingListNotAllowed => 'Editing is not allowed';

  @override
  String get actionReviewUpdates => 'Review updates';

  @override
  String get actionRetryUnavailableLists => 'Retry unavailable lists';

  @override
  String get errorOnlyAudiobooksCanBeDeletedHere => 'Only audiobooks can be deleted from this action';

  @override
  String statusAudiobookDeletedFromServerAndFileSystem(String title) {
    return 'Deleted \"$title\" from Audiobookshelf and file system';
  }

  @override
  String statusAudiobookDeletedFromServer(String title) {
    return 'Deleted \"$title\" from Audiobookshelf';
  }

  @override
  String get errorDeleteAudiobookFailed => 'Could not delete audiobook';

  @override
  String get errorNoSelectedAudiobooksCanBeDeleted =>
      'No selected audiobooks can be deleted. Select audiobook items and try again';

  @override
  String statusSelectedAudiobooksDeletedFromServerAndFileSystem(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString audiobooks',
      one: '1 audiobook',
    );
    return 'Deleted $_temp0 from Audiobookshelf and file system';
  }

  @override
  String statusSelectedAudiobooksDeletedFromServer(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString audiobooks',
      one: '1 audiobook',
    );
    return 'Deleted $_temp0 from Audiobookshelf';
  }

  @override
  String get errorDeleteSelectedAudiobooksFailed => 'Could not delete selected audiobooks';

  @override
  String get errorProgressUpdatesAudiobooksOnly => 'Progress updates are currently available for audiobooks only';

  @override
  String get errorProgressUpdatesPodcastEpisodesOnly =>
      'Progress updates are currently available for podcast episodes only';

  @override
  String statusNamedProgressMarkedFinished(String name) {
    return 'Marked \"$name\" as finished';
  }

  @override
  String statusNamedProgressCleared(String name) {
    return 'Cleared progress for \"$name\"';
  }

  @override
  String errorMarkNamedProgressFinishedFailed(String name) {
    return 'Could not mark \"$name\" as finished';
  }

  @override
  String errorClearNamedProgressFailed(String name) {
    return 'Could not clear progress for \"$name\"';
  }

  @override
  String statusNamedProgressUpdated(String name) {
    return 'Progress updated for \"$name\"';
  }

  @override
  String get errorUpdateProgressFailed => 'Could not update progress';

  @override
  String statusSelectedItemsMarkedFinished(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selected items',
      one: '1 selected item',
    );
    return 'Marked $_temp0 as finished';
  }

  @override
  String statusSelectedItemsMarkedUnfinished(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selected items',
      one: '1 selected item',
    );
    return 'Marked $_temp0 as unfinished';
  }

  @override
  String get errorMarkSelectedItemsFinishedFailed => 'Could not mark selected items as finished';

  @override
  String get errorMarkSelectedItemsUnfinishedFailed => 'Could not mark selected items as unfinished';

  @override
  String errorUpdatePinnedShelfFailed(String error) {
    return 'Could not update Pinned: $error';
  }

  @override
  String get errorLoadSeriesDetailsFailed => 'Series details could not be loaded';

  @override
  String get actionSelectLibrary => 'Select library';

  @override
  String get statusNoLibrarySelected => 'No library';

  @override
  String get headingBookInformation => 'Book information';

  @override
  String get statusLessThanOneMinuteLeft => 'Less than 1 minute left';

  @override
  String labelListeningProgress(String progress) {
    return 'Listening progress $progress';
  }

  @override
  String get headingBookStats => 'Book stats';

  @override
  String get statsBookLoadError => 'Could not load book stats';

  @override
  String get fieldTimesStarted => 'Times started';

  @override
  String get fieldFirstStarted => 'First started';

  @override
  String get fieldLastStarted => 'Last started';

  @override
  String get headingFinishHistory => 'Finish history';

  @override
  String get statusNotAvailable => 'Not available';

  @override
  String statusCurrentProgress(String progress) {
    return 'Current progress: $progress';
  }

  @override
  String get fieldFilePath => 'Path';

  @override
  String get fieldFormat => 'Format';

  @override
  String get fieldTimeBase => 'Time base';

  @override
  String get fieldEmbeddedCover => 'Embedded cover';

  @override
  String get headingMetadataTags => 'Metadata tags';

  @override
  String get headingFfprobeData => 'FFprobe data';

  @override
  String get actionLoadFfprobeData => 'Load FFprobe data';

  @override
  String get actionCopyFfprobeData => 'Copy FFprobe data';

  @override
  String get errorLoadFfprobeDataFailed => 'Could not load FFprobe data';

  @override
  String get titleSaveFile => 'Save file';

  @override
  String get errorDownloadOrSaveFileFailed => 'Could not download or save the file';

  @override
  String get headingDownloadFile => 'Download file';

  @override
  String get statusSavingFile => 'Saving file…';

  @override
  String get hintChooseFileSaveLocation => 'Choose where to save the file';

  @override
  String statusDownloadedBytes(String received, String total) {
    return '$received of $total';
  }

  @override
  String get headingDeleteFile => 'Delete file?';

  @override
  String promptDeleteServerFilePermanently(String filename) {
    return 'Permanently delete \"$filename\" from the server? This cannot be undone';
  }

  @override
  String get statusFileSaved => 'File saved';

  @override
  String get statusFileDeleted => 'File deleted';

  @override
  String get errorDeleteServerFileFailed => 'Could not delete the server file';

  @override
  String errorCompleteFileActionFailed(String error) {
    return 'Could not complete the file action: $error';
  }

  @override
  String get headingFileActions => 'File actions';

  @override
  String get actionMoreInfo => 'More info';

  @override
  String get actionAddFiles => 'Add files';

  @override
  String get fieldMetadataProviders => 'Metadata providers';

  @override
  String get hintSearchTitle => 'Search title';

  @override
  String get errorLoadMetadataProvidersFailed => 'Could not load metadata providers';

  @override
  String get statusNoMetadataProvidersAvailable => 'No metadata providers available';

  @override
  String get headingMatchCandidates => 'Match candidates';

  @override
  String get statusNoMatchResultsYet => 'No results yet';

  @override
  String matchResultCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString results', one: '1 result');
    return '$_temp0';
  }

  @override
  String get hintRunMetadataMatchSearch => 'Run a search to load metadata match results';

  @override
  String get actionSelectProviders => 'Select providers';

  @override
  String get headingSearchFiltersCollapsed => 'Search filters collapsed';

  @override
  String get hintTapToEditSearchFilters => 'Tap to edit search filters';

  @override
  String metadataProviderCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString providers',
      one: '1 provider',
    );
    return '$_temp0';
  }

  @override
  String matchSearchFieldSummary(String field, String value) {
    return '$field: $value';
  }

  @override
  String get headingQuickMatchBook => 'Quick match this book';

  @override
  String get actionRunQuickMatch => 'Run quick match';

  @override
  String errorQuickMatchFailed(String error) {
    return 'Could not run quick match: $error';
  }

  @override
  String get statusQuickMatchUpdated => 'Quick match updated this item';

  @override
  String get statusQuickMatchNoChanges => 'Quick match finished with no metadata changes';

  @override
  String get errorManualMatchTitleRequired => 'Enter a title before searching';

  @override
  String get errorManualMatchProviderRequired => 'Select at least one provider';

  @override
  String get errorManualMatchResultsNotFound => 'No match results found';

  @override
  String get errorManualMatchFieldRequired => 'Select at least one field to apply';

  @override
  String get errorManualMatchNoWritableFields => 'No writable values were selected from this match result';

  @override
  String errorManualMatchSaveFailed(String error) {
    return 'Could not save the manual match: $error';
  }

  @override
  String get statusManualMatchUpdated => 'Item metadata updated from manual match';

  @override
  String get headingManualMatchSelection => 'Selection';

  @override
  String get hintSelectManualMatchResult => 'Select a match result to choose which metadata fields to apply';

  @override
  String get headingApplyMatchedFields => 'Apply fields';

  @override
  String get hintAddValue => 'Add value';

  @override
  String get optionYes => 'Yes';

  @override
  String get optionNo => 'No';

  @override
  String get fieldCoverImage => 'Cover image';

  @override
  String get optionOverwrite => 'Overwrite';

  @override
  String get optionAddToCurrent => 'Add to current';

  @override
  String get statusNotSet => 'Not set';

  @override
  String get statusUntitled => 'Untitled';

  @override
  String matchCurrentValueSummary(String value) {
    return 'Current: $value';
  }

  @override
  String get fieldCurrentCover => 'Current cover';

  @override
  String get fieldSelectedCover => 'Selected cover';

  @override
  String get headingQuickMatchSelectedBooks => 'Quick match selected books';

  @override
  String get actionPreview => 'Preview';

  @override
  String get actionStart => 'Start';

  @override
  String get statusLoadingMetadataProviders => 'Loading metadata providers…';

  @override
  String get statusNoProvidersForMediaType => 'No metadata providers are available for this media type';

  @override
  String get settingOverwriteCurrentMetadata => 'Overwrite current metadata';

  @override
  String get settingOverwriteCurrentMetadataDescription =>
      'Replace existing title, author, description, and related fields';

  @override
  String get settingOverwriteCoverImage => 'Overwrite cover image';

  @override
  String get settingOverwriteCoverImageDescription => 'Replace current cover artwork when a match provides one';

  @override
  String get hintQuickMatchSingleProviderOnly =>
      'Quick match supports one provider. Use Preview to run multiple providers';

  @override
  String get headingPreviewChanges => 'Preview changes';

  @override
  String quickMatchChangeSummary(int changed, int total) {
    final intl.NumberFormat changedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String changedString = changedNumberFormat.format(changed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$changedString of $totalString fields changed';
  }

  @override
  String actionApplyQuickMatchChanges(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Apply $countString';
  }

  @override
  String get statusSearchingMatches => 'Searching matches…';

  @override
  String statusSearchingMatchesProgress(int completed, int total) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Searching matches… ($completedString of $totalString completed)';
  }

  @override
  String errorQuickMatchPreviewLoadFailed(String error) {
    return 'Could not load preview: $error';
  }

  @override
  String get statusNoMatch => 'No match';

  @override
  String get statusNoMatchResultForItem => 'No metadata result was returned for this item with the selected provider';

  @override
  String errorMetadataSearchFailed(String error) {
    return 'Metadata search failed: $error';
  }

  @override
  String get statusNoMetadataFieldChanges => 'No metadata field changes detected for this item';

  @override
  String get headingBeforeValue => 'Before';

  @override
  String get headingAfterValue => 'After';

  @override
  String get errorSelectQuickMatchItems => 'Select at least one matched item with changes to apply';

  @override
  String statusQuickMatchItemsUpdated(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Updated $countString items',
      one: 'Updated 1 item',
    );
    return '$_temp0';
  }

  @override
  String statusQuickMatchItemsUnchanged(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items had no changes',
      one: '1 item had no changes',
    );
    return '$_temp0';
  }

  @override
  String statusQuickMatchItemsFailed(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString items failed',
      one: '1 item failed',
    );
    return '$_temp0';
  }

  @override
  String get errorLoadCurrentItemMetadataFailed => 'Could not load current item metadata';

  @override
  String get errorItemTitleUnavailableForSearch => 'No title available for search';

  @override
  String get statusNoMetadataMatchesFromProviders => 'No results found with any provider';

  @override
  String statusQuickMatchBatchStarted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Metadata change request sent for $countString books',
      one: 'Metadata change request sent for 1 book',
    );
    return '$_temp0';
  }

  @override
  String get errorStartQuickMatchBatchFailed => 'Could not start the metadata change request';

  @override
  String errorQuickMatchBatchFailed(String error) {
    return 'Could not quick match selected books: $error';
  }

  @override
  String get actionRemoveAuthorsWithoutBooks => 'Remove authors without books';

  @override
  String get statusCheckingAuthors => 'Checking authors…';

  @override
  String get statusScanningAuthors => 'Scanning authors';

  @override
  String get statusPreparingToLoadAuthors => 'Preparing to load authors…';

  @override
  String get statusDeletingAuthors => 'Deleting authors';

  @override
  String statusDeletingAuthorProgress(String name, int completed, int total) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Deleting $name ($completedString of $totalString)';
  }

  @override
  String statusLoadingAuthorsPage(int page, int pageSize) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);
    final intl.NumberFormat pageSizeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageSizeString = pageSizeNumberFormat.format(pageSize);

    return 'Loading page $pageString with $pageSizeString authors per page…';
  }

  @override
  String statusScannedAuthorsAndFoundEmptyAuthors(int scanned, int empty) {
    final intl.NumberFormat scannedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String scannedString = scannedNumberFormat.format(scanned);
    final intl.NumberFormat emptyNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String emptyString = emptyNumberFormat.format(empty);

    String _temp0 = intl.Intl.pluralLogic(
      scanned,
      locale: localeName,
      other: 'Scanned $scannedString authors',
      one: 'Scanned 1 author',
    );
    String _temp1 = intl.Intl.pluralLogic(
      empty,
      locale: localeName,
      other: '$emptyString authors without books',
      one: '1 author without books',
      zero: 'no authors without books',
    );
    return '$_temp0 and found $_temp1';
  }

  @override
  String get headingNoAuthorsToRemove => 'No authors to remove';

  @override
  String get statusNoAuthorsWithoutBooks => 'No authors without books were found';

  @override
  String headingDeleteAuthorsWithoutBooks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString authors', one: '1 author');
    return 'Delete $_temp0?';
  }

  @override
  String get confirmDeleteAuthorsWithoutBooks => 'These authors have no books and will be removed permanently';

  @override
  String actionDeleteAuthorsCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Delete $countString';
  }

  @override
  String statusDeletedAuthorsWithoutBooks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString authors', one: '1 author');
    return 'Deleted $_temp0 without books';
  }

  @override
  String errorDeleteAuthorsWithoutBooksFailed(int count, String names) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString authors', one: '1 author');
    return 'Could not delete $_temp0: $names';
  }

  @override
  String authorNamesWithMoreCount(String names, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$names and $countString more';
  }

  @override
  String errorRemoveAuthorsWithoutBooksFailed(String error) {
    return 'Could not remove authors without books: $error';
  }

  @override
  String progressPosition(int completed, int total) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$completedString of $totalString';
  }

  @override
  String get actionUndo => 'Undo';

  @override
  String get fieldElapsedTime => 'Elapsed time';

  @override
  String hintBookLength(String duration) {
    return 'Book length $duration';
  }

  @override
  String get validationEnterTimeFormat => 'Enter time as hours:minutes:seconds';

  @override
  String validationTimeExceedsDuration(String duration) {
    return 'Time cannot exceed $duration';
  }

  @override
  String get validationPercentageRequired => 'Enter a percentage';

  @override
  String get validationPercentageExceedsMaximum => 'Percentage cannot exceed 100';

  @override
  String labelStartedDate(String date) {
    return 'Started $date';
  }

  @override
  String labelFinishedDate(String date) {
    return 'Finished $date';
  }

  @override
  String get actionSetFinished => 'Set finished';

  @override
  String get statusPinnedShelfAdded => 'Added to the pinned shelf';

  @override
  String get statusPinnedShelfRemoved => 'Removed from the pinned shelf';

  @override
  String errorUndoPinnedShelfChangeFailed(String error) {
    return 'Could not undo the pinned shelf change: $error';
  }

  @override
  String get actionDownloadSelectedItems => 'Download selected items';

  @override
  String get actionDeleteSelectedAudiobooks => 'Delete selected audiobooks';

  @override
  String get statusNoSelectedAudiobooksCanBeDeleted => 'No selected audiobooks can be deleted';

  @override
  String statusQuickMatchBatchCompleted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString books updated',
      one: '1 book updated',
    );
    return 'Metadata change request completed with $_temp0';
  }

  @override
  String get statusQuickMatchBatchCompletedWithoutUpdates => 'Metadata change request completed without updates';

  @override
  String get headingAddEpisodesToPlaylist => 'Add episodes to playlist';

  @override
  String statusItemsAddedToPlaylist(int count, String target) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString selected items',
      one: '1 selected item',
    );
    return 'Added $_temp0 to \"$target\"';
  }

  @override
  String statusEpisodesAddedToPlaylist(int count, String target) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString episodes', one: '1 episode');
    return 'Added $_temp0 to \"$target\"';
  }

  @override
  String get errorAddItemsToPlaylistFailed => 'Could not add selected items to playlist';

  @override
  String get errorAddBooksToPlaylistFailed => 'Could not add books to playlist';

  @override
  String get errorAddEpisodesToPlaylistFailed => 'Could not add episodes to playlist';

  @override
  String get errorAddBooksToCollectionFailed => 'Could not add books to collection';

  @override
  String get statusNoEditablePlaylistsFound => 'No editable playlists found';

  @override
  String get errorLoadPlaylistsFailed => 'Could not load playlists';

  @override
  String get statusNoCollectionsFound => 'No collections found';

  @override
  String get errorLoadCollectionsFailed => 'Could not load collections';

  @override
  String statusActiveFilter(String group, String value) {
    return '$group · $value';
  }

  @override
  String statusSpecialFilter(String value) {
    return 'Special · $value';
  }

  @override
  String get headingStorage => 'Storage';

  @override
  String get fieldRssFeedUrl => 'RSS feed URL';

  @override
  String fieldRequired(String label) {
    return '$label *';
  }

  @override
  String get hintAddGenre => 'Add genre';

  @override
  String get settingPodcastExplicitContent => 'Explicit content';

  @override
  String get settingPodcastAutoDownloadEpisodes => 'Auto download new episodes';

  @override
  String get actionCreatePodcast => 'Create podcast';

  @override
  String get validationLibraryFolderRequired => 'Choose a target library folder';

  @override
  String get validationTitleRequired => 'Title is required';

  @override
  String get validationRssFeedUrlRequired => 'RSS feed URL is required';

  @override
  String get statusUntitledPodcast => 'Untitled podcast';

  @override
  String get hintPodcastTitleAndMetadata => 'Podcast title and metadata';

  @override
  String get statusMissingRssFeedUrl => 'Missing RSS feed URL';

  @override
  String get actionAddPodcast => 'Add podcast';

  @override
  String get statusAlreadyInLibrary => 'Already in library';

  @override
  String get statusNoPodcastSearchResultsYet => 'No podcast search results yet';

  @override
  String get hintSearchOrPasteRssFeed => 'Search by title or creator, or paste an RSS feed URL to start';

  @override
  String get actionClearSearch => 'Clear search';

  @override
  String get actionDecreaseVolume => 'Decrease volume';

  @override
  String get actionIncreaseVolume => 'Increase volume';

  @override
  String get playbackSettings => 'Playback settings';

  @override
  String get fieldServer => 'Server';

  @override
  String get statusServerAddressUnavailable => 'Server address unavailable';

  @override
  String get statusServerAvailable => 'Server available';

  @override
  String get statusServerUnavailable => 'Server unavailable';

  @override
  String accountRoleLabel(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'guest': 'Guest',
      'listener': 'Listener',
      'other': 'Listener',
    });
    return '$_temp0';
  }

  @override
  String get headingCustomLoginMessage => 'Custom login message';

  @override
  String get fieldLoginMessage => 'Login message';

  @override
  String get settingShowCustomLoginMessage => 'Show custom login message';

  @override
  String get settingEnableLocalAuthentication => 'Enable local authentication';

  @override
  String get settingEnableOpenIdAuthentication => 'Enable OpenID authentication';

  @override
  String get fieldIssuerUrl => 'Issuer URL';

  @override
  String get fieldAuthorizationUrl => 'Authorization URL';

  @override
  String get fieldTokenUrl => 'Token URL';

  @override
  String get fieldUserInfoUrl => 'User info URL';

  @override
  String get fieldJwksUrl => 'JWKS URL';

  @override
  String get fieldLogoutUrl => 'Logout URL';

  @override
  String get fieldClientId => 'Client ID';

  @override
  String get fieldClientSecret => 'Client secret';

  @override
  String get actionShowSecret => 'Show secret';

  @override
  String get actionHideSecret => 'Hide secret';

  @override
  String get fieldSigningAlgorithm => 'Signing algorithm';

  @override
  String get fieldMobileRedirectUris => 'Mobile redirect URIs';

  @override
  String get hintMobileRedirectUris => 'Add one URI per entry. Use * only as a standalone entry';

  @override
  String get fieldWebRedirectSubfolder => 'Web redirect subfolder';

  @override
  String get fieldWebCallbackUrl => 'Web callback URL';

  @override
  String get fieldMobileCallbackUrl => 'Mobile callback URL';

  @override
  String get fieldOpenIdButtonText => 'OpenID button text';

  @override
  String get fieldExistingUserMatchMethod => 'Match existing users by';

  @override
  String get optionDoNotMatchExistingUsers => 'Do not match';

  @override
  String get optionMatchExistingUsersByEmail => 'Match by email';

  @override
  String get optionMatchExistingUsersByUsername => 'Match by username';

  @override
  String get settingAutoLaunchOpenIdLogin => 'Auto-launch OpenID login';

  @override
  String get settingAutoLaunchOpenIdLoginDescription =>
      'Automatically redirect users to OpenID sign-in on the login page';

  @override
  String get settingAutoRegisterOpenIdUsers => 'Auto-register OpenID users';

  @override
  String get settingAutoRegisterOpenIdUsersDescription =>
      'Create local users automatically when OpenID users sign in for the first time';

  @override
  String get fieldGroupClaim => 'Group claim';

  @override
  String get fieldAdvancedPermissionClaim => 'Advanced permission claim';

  @override
  String get actionAutoPopulateOpenIdConfiguration => 'Auto-populate';

  @override
  String get errorAuthenticationMethodsRequired => 'At least one authentication method must be enabled';

  @override
  String validationFieldRequired(String field) {
    return '$field is required';
  }

  @override
  String validationFieldInvalid(String field) {
    return '$field is invalid';
  }

  @override
  String get validationWildcardMustBeOnlyRedirectUri => 'The asterisk (*) must be the only redirect URI when used';

  @override
  String validationMobileRedirectUriInvalid(String uri) {
    return 'Mobile redirect URI $uri is invalid';
  }

  @override
  String get validationSubfolderMustStartWithSlash => 'Subfolder must start with /';

  @override
  String get validationSubfolderCannotBeOnlySlash => 'Subfolder cannot be only /';

  @override
  String get validationSubfolderMustNotEndWithSlash => 'Subfolder must not end with /';

  @override
  String get validationSubfolderCannotContainSpaces => 'Subfolder cannot contain spaces';

  @override
  String get headingDisableLocalAuthentication => 'Disable local authentication?';

  @override
  String get confirmDisableLocalAuthentication =>
      'If local authentication is disabled and OpenID is misconfigured or broken, access can only be restored through a manual database edit. It is highly recommended to keep a backup admin account and local authentication enabled.';

  @override
  String get actionDisableLocalAuthentication => 'Disable local authentication';

  @override
  String get headingRotateAuthenticationCodeKey => 'Rotate authentication code key?';

  @override
  String get confirmRotateAuthenticationCodeKey =>
      'Authentication codes created with the previous key will stop working. Existing signed-in accounts are not affected';

  @override
  String get actionRotateAuthenticationCodeKey => 'Rotate authentication code key';

  @override
  String get errorLoadAuthenticationSettingsFailed => 'Failed to load authentication settings';

  @override
  String get errorRotateAuthenticationCodeKeyFailed => 'Failed to rotate authentication code key';

  @override
  String get errorAuthenticationCodeKeyUnavailable =>
      'Authentication code key is no longer available. Refresh the settings and try again';

  @override
  String get errorAuthenticationCodeKeyRotationNotPreserved =>
      'The server did not preserve the new authentication code key';

  @override
  String get statusAuthenticationCodeKeyRotated =>
      'Authentication code key rotated. Codes created with the previous key are now invalid';

  @override
  String get statusAuthenticationSettingsSaved => 'Authentication settings saved';

  @override
  String get statusOpenIdFieldsPopulated => 'OpenID fields populated from issuer configuration';

  @override
  String get errorSaveAuthenticationSettingsFailed => 'Failed to save authentication settings';

  @override
  String get errorAutoPopulateOpenIdConfigurationFailed => 'Failed to auto-populate OpenID configuration';

  @override
  String get errorConfigureOpenIdBeforeDisablingLocalAuthentication =>
      'Configure OpenID before disabling local authentication';

  @override
  String get statusNoActiveUserForAuthenticationSettings => 'No active user. Sign in to manage authentication settings';

  @override
  String get statusAdminRequiredForAuthenticationSettings => 'This page requires an admin account';

  @override
  String get actionSaveAuthenticationSettings => 'Save authentication settings';

  @override
  String get hintOpenIdChangesMayRequireRestart => 'OpenID changes may require a server restart to fully apply';

  @override
  String statusCopiedValue(String label) {
    return 'Copied $label';
  }

  @override
  String errorLoadUserAuthenticationSettingsFailed(String error) {
    return 'Failed to load user settings ($error)';
  }

  @override
  String statusEpisodeDownloadsQueued(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString episode downloads added to the queue',
      one: 'Episode download added to the queue',
      zero: 'No episode downloads added to the queue',
    );
    return '$_temp0';
  }

  @override
  String get actionDeleteListenedDownloads => 'Delete listened items now';

  @override
  String get statusNoListenedDownloadsToDelete => 'No listened smart downloads were ready to delete';

  @override
  String statusDeletedListenedDownloads(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString listened smart downloads',
      one: '1 listened smart download',
    );
    return 'Deleted $_temp0';
  }

  @override
  String errorDeleteListenedDownloadsFailed(String error) {
    return 'Failed to delete listened smart downloads ($error)';
  }

  @override
  String seriesBookCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString books in the series',
      one: '1 book in the series',
    );
    return '$_temp0';
  }

  @override
  String numberValue(int value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String selectionPosition(int selected, int total) {
    final intl.NumberFormat selectedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String selectedString = selectedNumberFormat.format(selected);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$selectedString/$totalString';
  }

  @override
  String progressPercent(double value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPercentPattern(
      locale: localeName,
      decimalDigits: 1,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String statusLoadingAction(String action) {
    return 'Loading $action';
  }

  @override
  String get statusLoadingPdf => 'Loading PDF…';

  @override
  String statusLoadingPdfProgress(String progress) {
    return 'Loading PDF… $progress';
  }

  @override
  String equalizerFrequencyHertz(int value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString Hz';
  }

  @override
  String equalizerFrequencyKilohertz(double value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString kHz';
  }

  @override
  String equalizerGain(String sign, double value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.decimalPatternDigits(
      locale: localeName,
      decimalDigits: 1,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$sign$valueString dB';
  }

  @override
  String get uploadIgnoredNonBookSidecarFiles => 'Non-book sidecar files were ignored while grouping this upload';

  @override
  String statusBooksAddedToTarget(int count, String target) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString books', one: '1 book');
    return 'Added $_temp0 to \"$target\"';
  }

  @override
  String get accountLabel => 'Account';

  @override
  String get statusNoChangesWereNecessary => 'No updates were necessary';

  @override
  String get optionPausePlayback => 'Pause playback';

  @override
  String get optionBoth => 'Both';

  @override
  String get settingsScopeApp => 'App';

  @override
  String get settingsScopeAccount => 'Account';

  @override
  String get settingsScopeServer => 'Server';

  @override
  String settingsAccountScopedHeading(String username) {
    return 'Account ($username)';
  }

  @override
  String settingsServerScopedHeading(String server) {
    return 'Server ($server)';
  }

  @override
  String get settingsSectionPlaybackAndReader => 'Playback and reader';

  @override
  String get settingsSectionAppAndSystem => 'App and system';

  @override
  String get settingsServerActions => 'Server actions';

  @override
  String get settingsServerActionsDescription => 'Show or hide server action controls for this account';

  @override
  String get settingsServerConnectionDescription => 'Server addresses, local connection, and custom headers';

  @override
  String get settingsToolsDescription => 'Batch item actions and experimental server tools';

  @override
  String settingsAdminServerDescription(String server) {
    return 'Server-wide administration for $server';
  }

  @override
  String get settingsUpdatesTitle => 'Updates';

  @override
  String get settingsUpdatesDescription => 'Automatic update checks for yaabsa and your server';

  @override
  String get settingsStartupAndBackgroundTitle => 'Startup, buffer, and background';

  @override
  String get settingsStartupAndBackgroundDescription =>
      'Audio buffer, screen wake lock, startup playback, and background sync';

  @override
  String get settingsMediaNotificationsDescription =>
      'Notification progress style, lock behavior, and Android controls';

  @override
  String get settingsCompatibilityDescription => 'Platform-specific audio decoding and seeking workarounds';

  @override
  String get settingsCachingDescription => 'Offline response cache and route caching rules';

  @override
  String get settingsLogsDescription => 'Log verbosity and local diagnostic log viewer';

  @override
  String get settingsLibrarySettingsDescription => 'Library order, navigation tabs, shelf sections, and grid display';

  @override
  String get settingsLibraryOrderDescription => 'Reorder libraries and mark music libraries';

  @override
  String get settingsDownloadsDescription => 'Download location, Wi-Fi rules, and smart downloads';

  @override
  String get settingsReaderDescription => 'Typography, page layout, read aloud, and reading session tracking';

  @override
  String get settingsAppearanceDescription => 'Theme mode, preset palette, accent color, and language';

  @override
  String settingsNumberRangeError(int min, int max) {
    final intl.NumberFormat minNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minString = minNumberFormat.format(min);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maxString = maxNumberFormat.format(max);

    return 'Enter a whole number between $minString and $maxString';
  }

  @override
  String get actionDecrease => 'Decrease';

  @override
  String get actionIncrease => 'Increase';

  @override
  String get hintEmptyLibrarySelectionIncludesAll => 'Leave unselected to include all libraries';

  @override
  String get settingRenameSeries => 'Rename series';

  @override
  String get settingRenameSeriesDescription => 'Add an option to rename a series across all of its books';

  @override
  String get actionRenameSeries => 'Rename series';

  @override
  String get fieldNewSeriesName => 'New series name';

  @override
  String get errorEnterSeriesName => 'Enter a series name';

  @override
  String statusSeriesRenamed(int updated) {
    final intl.NumberFormat updatedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String updatedString = updatedNumberFormat.format(updated);

    String _temp0 = intl.Intl.pluralLogic(updated, locale: localeName, other: '$updatedString books', one: '1 book');
    return 'Renamed series across $_temp0';
  }

  @override
  String get statusSeriesRenameNoMatches => 'No books matched this series';

  @override
  String get settingDeleteLongListeningSessions => 'Delete long listening sessions';

  @override
  String get settingDeleteLongListeningSessionsDescription =>
      'Add a tool in statistics to find and delete overly long listening sessions';

  @override
  String get actionFindLongSessions => 'Find long sessions';

  @override
  String get headingLongListeningSessions => 'Long listening sessions';

  @override
  String get fieldThresholdHours => 'Threshold (hours)';

  @override
  String get errorEnterValidThresholdHours => 'Enter a threshold of 0 or more hours';

  @override
  String get optionAllUsers => 'Include all users';

  @override
  String get optionAllUsersDescription => 'Scan sessions for every user on this server';

  @override
  String get actionScanSessions => 'Scan sessions';

  @override
  String get statusScanningSessions => 'Scanning listening sessions…';

  @override
  String statusNoLongSessionsFound(String hours) {
    return 'No listening sessions exceed $hours hours';
  }

  @override
  String statusLongSessionsFoundSummary(int count, String hours, int users) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);
    final intl.NumberFormat usersNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String usersString = usersNumberFormat.format(users);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString sessions', one: '1 session');
    String _temp1 = intl.Intl.pluralLogic(users, locale: localeName, other: '$usersString users', one: '1 user');
    return 'Found $_temp0 totaling $hours hours across $_temp1';
  }

  @override
  String actionDeleteAllMatching(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Delete all ($countString)';
  }

  @override
  String get confirmDeleteLongSessionsTitle => 'Delete listening sessions?';

  @override
  String confirmDeleteLongSessionsMessage(int count, String hours) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString listening sessions',
      one: '1 listening session',
    );
    return 'Delete $_temp0 totaling $hours hours? This cannot be undone';
  }

  @override
  String statusLongSessionsDeletedSummary(int deleted, String hours) {
    final intl.NumberFormat deletedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String deletedString = deletedNumberFormat.format(deleted);

    String _temp0 = intl.Intl.pluralLogic(
      deleted,
      locale: localeName,
      other: '$deletedString sessions',
      one: '1 session',
    );
    return 'Deleted $_temp0 ($hours hours)';
  }

  @override
  String statusLongSessionsDeletePartial(int deleted, int failed, String hours) {
    final intl.NumberFormat deletedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String deletedString = deletedNumberFormat.format(deleted);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);

    return 'Deleted $deletedString and failed $failedString sessions ($hours hours removed)';
  }

  @override
  String get statusNoMetadataRefreshUpdates => 'No items needed a metadata refresh';

  @override
  String get descriptionPathTagGenreUpdate =>
      'Scan the selected library and check each item path against your rules. When a path matches a regular expression, add the rule value to the selected tag or genre field while keeping existing values. For example, .*Fiction.*:Fiction adds Fiction to the selected field when the path contains Fiction. Use dry run to review matches without changing items.';

  @override
  String get headingPathRules => 'Rules';

  @override
  String get hintPathRuleFormat => 'Format: <regex>:<value> (for example, .*Fiction.*:Fiction)';

  @override
  String get fieldPathRule => 'Rule';

  @override
  String get actionAddRule => 'Add rule';

  @override
  String get errorInvalidPathRule => 'Enter a rule in <regex>:<value> format with a valid pattern';

  @override
  String get errorAddAtLeastOneRule => 'Add at least one rule';

  @override
  String get optionDryRun => 'Dry run';

  @override
  String get optionDryRunDescription => 'Preview matching items without applying changes';

  @override
  String statusPathTagGenreDryRunSummary(int scanned, int matched) {
    final intl.NumberFormat scannedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String scannedString = scannedNumberFormat.format(scanned);
    final intl.NumberFormat matchedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String matchedString = matchedNumberFormat.format(matched);

    String _temp0 = intl.Intl.pluralLogic(scanned, locale: localeName, other: '$scannedString items', one: '1 item');
    String _temp1 = intl.Intl.pluralLogic(matched, locale: localeName, other: '$matchedString items', one: '1 item');
    return 'Dry run scanned $_temp0 and matched $_temp1';
  }

  @override
  String statusPathTagGenreAppliedSummary(int scanned, int matched, int updated) {
    final intl.NumberFormat scannedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String scannedString = scannedNumberFormat.format(scanned);
    final intl.NumberFormat matchedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String matchedString = matchedNumberFormat.format(matched);
    final intl.NumberFormat updatedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String updatedString = updatedNumberFormat.format(updated);

    String _temp0 = intl.Intl.pluralLogic(scanned, locale: localeName, other: '$scannedString items', one: '1 item');
    return 'Scanned $_temp0, matched $matchedString, and updated $updatedString';
  }

  @override
  String statusPathTagGenreNoMatches(int scanned) {
    final intl.NumberFormat scannedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String scannedString = scannedNumberFormat.format(scanned);

    String _temp0 = intl.Intl.pluralLogic(scanned, locale: localeName, other: '$scannedString items', one: '1 item');
    return 'Scanned $_temp0 with no new matches';
  }

  @override
  String get headingMatchAudiobookChapters => 'Match audiobook chapters';

  @override
  String get actionQuickMatchChapters => 'Quick match chapters';

  @override
  String get fieldChapterThreshold => 'Chapter threshold';

  @override
  String get descriptionChapterThreshold =>
      'Update chapters when missing or when the chapter count differs by more than this value';

  @override
  String get errorInvalidChapterThreshold => 'Enter a whole number of 0 or more';

  @override
  String get optionSearchForAsin => 'Search for ASIN';

  @override
  String get optionSearchForAsinDescription => 'Look up a missing ASIN using the selected metadata provider';

  @override
  String get optionUseTracksAsChapters => 'Use tracks as chapters';

  @override
  String get optionUseTracksAsChaptersDescription => 'Fall back to audio track filenames when no ASIN is available';

  @override
  String get optionDisableRateProtection => 'Disable rate protection';

  @override
  String get optionDisableRateProtectionDescription => 'Skip the 2-second delay between books';

  @override
  String statusMatchingChaptersProgress(int processed, int total) {
    final intl.NumberFormat processedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String processedString = processedNumberFormat.format(processed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Processed $processedString of $totalString books';
  }

  @override
  String get actionStopMatching => 'Stop';

  @override
  String get statusStoppingMatching => 'Stopping…';

  @override
  String statusMatchChaptersSummary(int updated, int skipped, int failed, int total) {
    final intl.NumberFormat updatedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String updatedString = updatedNumberFormat.format(updated);
    final intl.NumberFormat skippedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String skippedString = skippedNumberFormat.format(skipped);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(total, locale: localeName, other: '$totalString books', one: '1 book');
    return 'Updated $updatedString, skipped $skippedString, and failed $failedString of $_temp0';
  }

  @override
  String statusMatchChaptersCancelled(int processed, int updated, int skipped, int failed) {
    final intl.NumberFormat processedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String processedString = processedNumberFormat.format(processed);
    final intl.NumberFormat updatedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String updatedString = updatedNumberFormat.format(updated);
    final intl.NumberFormat skippedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String skippedString = skippedNumberFormat.format(skipped);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);

    return 'Stopped after processing $processedString books. Updated $updatedString, skipped $skippedString, failed $failedString';
  }

  @override
  String statusSingleBookChaptersUpdated(String title) {
    return 'Updated chapters for \"$title\"';
  }

  @override
  String statusSingleBookChaptersUnchanged(String title) {
    return 'Chapters for \"$title\" are already up to date';
  }

  @override
  String errorSingleBookChaptersFailed(String reason) {
    return 'Could not match chapters: $reason';
  }
}
