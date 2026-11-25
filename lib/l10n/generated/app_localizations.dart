import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  /// Label for a button in dialogs and sheets that abandons the current action and dismisses the popup
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Label for a button in dialogs, sheets, and panels that dismisses the popup or panel
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// Label for a button that stores current edits in settings, metadata forms, or an editor
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Label for an action that permanently deletes a selected item
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Label for a button that repeats a failed operation
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get actionRetry;

  /// Label for a button that acknowledges a message and dismisses its dialog
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// Title at the top of the appearance settings page
  ///
  /// In en, this message translates to:
  /// **'Appearance settings'**
  String get settingsAppearanceTitle;

  /// Heading for display-related options in appearance settings
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplayTitle;

  /// Label for the theme settings destination in the appearance settings page
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeSettingsTitle;

  /// Subtitle explaining the theme options available from appearance settings
  ///
  /// In en, this message translates to:
  /// **'Theme mode, preset palette, and custom accent color'**
  String get themeSettingsSubtitle;

  /// Label for the navigation settings destination in the appearance settings page
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigationSettingsTitle;

  /// Subtitle explaining the navigation options available from appearance settings
  ///
  /// In en, this message translates to:
  /// **'Configure displayed tabs, their order, and the default view'**
  String get navigationSettingsSubtitle;

  /// Heading for remaining options in appearance settings
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get settingsOtherTitle;

  /// Label for language choices in app or server settings and language fields in forms
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get fieldLanguage;

  /// Label for an optional note field in an editor or annotation form
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get fieldNote;

  /// Option that follows the device default in a preference selector
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get optionSystemDefault;

  /// Label for selecting a model in settings or a media service
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get fieldModel;

  /// Label for selecting a voice in reader speech settings
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get fieldVoice;

  /// Label for entering a voice identifier in speech settings
  ///
  /// In en, this message translates to:
  /// **'Voice ID'**
  String get fieldVoiceId;

  /// Label for revealing a hidden value in a form field
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get actionShow;

  /// Label for concealing a visible value in a form field
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// Native language name displayed in the language selector for English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get localeEnglishName;

  /// Display name for German in the app language selector
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get localeGermanName;

  /// Status shown on the startup screen while the audio service is starting
  ///
  /// In en, this message translates to:
  /// **'Starting audio service…'**
  String get startupAudioServiceStatus;

  /// Title shown on the startup error screen when app initialization fails
  ///
  /// In en, this message translates to:
  /// **'Unable to start yaabsa'**
  String get startupUnableToStartTitle;

  /// Message shown on the startup error screen when the audio service fails
  ///
  /// In en, this message translates to:
  /// **'The audio service could not start. Close and restart the app'**
  String get startupAudioServiceError;

  /// Abbreviation for a file size measured in bytes
  ///
  /// In en, this message translates to:
  /// **'B'**
  String get byteUnitBytes;

  /// Abbreviation for a file size measured in kilobytes
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get byteUnitKilobytes;

  /// Abbreviation for a file size measured in megabytes
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get byteUnitMegabytes;

  /// Abbreviation for a file size measured in gigabytes
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get byteUnitGigabytes;

  /// Abbreviation for a file size measured in terabytes
  ///
  /// In en, this message translates to:
  /// **'TB'**
  String get byteUnitTerabytes;

  /// Formatted file size with its byte unit
  ///
  /// In en, this message translates to:
  /// **'{value} {unit}'**
  String byteSize(String value, String unit);

  /// Transferred and total data sizes shown as a progress ratio
  ///
  /// In en, this message translates to:
  /// **'{transferred} / {total}'**
  String byteTransferProgress(String transferred, String total);

  /// Displays an hour count as part of a readable duration in a subtitle or status
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} hr} other{{count} hr}}'**
  String durationHours(int count);

  /// Displays a minute count in readable durations and listening time thresholds
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} min} other{{count} min}}'**
  String durationMinutes(int count);

  /// Displays a second count as part of a readable duration in a subtitle or status
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} sec} other{{count} sec}}'**
  String durationSeconds(int count);

  /// Displays hours and remaining minutes as a readable duration in a subtitle or status
  ///
  /// In en, this message translates to:
  /// **'{hours, plural, one{{hours} hr} other{{hours} hr}} {minutes, plural, one{{minutes} min} other{{minutes} min}}'**
  String durationHoursMinutes(int hours, int minutes);

  /// Count of books shown for series, collections, playlists, and library items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book} other{{count} books}}'**
  String bookCount(int count);

  /// Count of series displayed in an author or series list
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 series} other{{count} series}}'**
  String seriesCount(int count);

  /// Empty state shown when an author has no books
  ///
  /// In en, this message translates to:
  /// **'No books found for this author'**
  String get statusNoBooksForAuthor;

  /// Displays an audio track count in library cards, details, subtitles, and browse results
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 track} other{{count} tracks}}'**
  String trackCount(int count);

  /// Displays a podcast episode count in library cards, details, subtitles, and browse results
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 episode} other{{count} episodes}}'**
  String episodeCount(int count);

  /// Label for library items in statistics, subtitle preferences, and cache rules
  ///
  /// In en, this message translates to:
  /// **'Library items'**
  String get libraryItems;

  /// Label for the series destination, subtitle choice, and automatic download source
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get navSeries;

  /// Label for the authors destination in library navigation and the authors option in subtitle settings
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get navAuthors;

  /// Option that lets the app choose a value automatically in settings
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get optionAutomatic;

  /// Option for hiding a value or item from view
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get optionHidden;

  /// Option that lets the user choose which subtitle details appear under library content
  ///
  /// In en, this message translates to:
  /// **'Choose fields'**
  String get librarySubtitleModeChooseFields;

  /// Explanation of automatic subtitle field selection in subtitle settings
  ///
  /// In en, this message translates to:
  /// **'Shows information based on the current sort'**
  String get librarySubtitleModeAutomaticDescription;

  /// Explanation of the hidden subtitle option in subtitle settings
  ///
  /// In en, this message translates to:
  /// **'Hides subtitle information'**
  String get librarySubtitleModeHiddenDescription;

  /// Explanation of custom subtitle field selection in subtitle settings
  ///
  /// In en, this message translates to:
  /// **'Choose up to three details to show below library items, series, or authors'**
  String get librarySubtitleModeChooseFieldsDescription;

  /// Label for an author field in editors, filters, sort options, and library subtitles
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get fieldAuthor;

  /// Label for a duration field in editors, filters, sort options, and library subtitles
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get fieldDuration;

  /// Label for a file size field in editors, filters, sort options, and library subtitles
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get fieldSize;

  /// Label for a track count field in editors, filters, and library subtitles
  ///
  /// In en, this message translates to:
  /// **'Tracks'**
  String get fieldTracks;

  /// Field option for showing when a library item, series, or author was added
  ///
  /// In en, this message translates to:
  /// **'Added date'**
  String get fieldAddedDate;

  /// Field option for showing a book's publication year in library subtitles
  ///
  /// In en, this message translates to:
  /// **'Published year'**
  String get fieldPublishedYear;

  /// Label for a narrator field in editors, filters, and library subtitles
  ///
  /// In en, this message translates to:
  /// **'Narrator'**
  String get fieldNarrator;

  /// Field option for showing when a media file was created in library subtitles
  ///
  /// In en, this message translates to:
  /// **'File birth date'**
  String get fieldFileBirthDate;

  /// Field option for showing when a media file was last modified in library subtitles
  ///
  /// In en, this message translates to:
  /// **'File modified date'**
  String get fieldFileModifiedDate;

  /// Label for a book count field in series and author subtitles
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get fieldBooks;

  /// Field option for showing the combined duration of a series in its subtitle
  ///
  /// In en, this message translates to:
  /// **'Total duration'**
  String get fieldTotalDuration;

  /// Field option for showing when an author or series was last updated
  ///
  /// In en, this message translates to:
  /// **'Updated date'**
  String get fieldUpdatedDate;

  /// Prefix for the date a library item, series, or author was added
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get dateAdded;

  /// Prefix for the date a media file was last modified
  ///
  /// In en, this message translates to:
  /// **'Modified'**
  String get dateModified;

  /// Prefix for the date a series or author was last updated
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get dateUpdated;

  /// Date heading for events and activity that happened today
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// Date heading for events and activity that happened yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// Heading for playback controls in the desktop tray menu and name of the Android playback notification channel
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playbackTitle;

  /// Label for a playback control in the player, tray menu, and media controls that pauses audio
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get playbackPause;

  /// Label for a playback control in the player, tray menu, and media controls that starts or resumes audio
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playbackPlay;

  /// Label for a playback control in the player, tray menu, and media controls that stops audio
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get playbackStop;

  /// Label for a playback control in the player, tray menu, and media controls that advances the queue
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get playbackNext;

  /// Label for a playback control in the player, tray menu, and media controls that returns to the previous queue item
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get playbackPrevious;

  /// Label for a playback control in the player and tray menu that seeks forward
  ///
  /// In en, this message translates to:
  /// **'Fast forward'**
  String get playbackFastForward;

  /// Label for a playback control in the player and tray menu that seeks backward
  ///
  /// In en, this message translates to:
  /// **'Rewind'**
  String get playbackRewind;

  /// Label for an action in the tray menu that resumes the most recently played item
  ///
  /// In en, this message translates to:
  /// **'Play last played'**
  String get playbackPlayLastPlayed;

  /// Label for the desktop tray action that closes yaabsa
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get trayQuitApp;

  /// Status shown in automotive settings when the Android Automotive integration is inactive
  ///
  /// In en, this message translates to:
  /// **'Android Automotive integration is inactive'**
  String get aaosInactiveStatus;

  /// Status shown when Android Automotive features are opened on another platform
  ///
  /// In en, this message translates to:
  /// **'Android Automotive is only available on Android'**
  String get aaosAndroidOnlyStatus;

  /// Status shown when the app detects an Android Automotive OS device
  ///
  /// In en, this message translates to:
  /// **'Android Automotive OS detected'**
  String get aaosDetectedStatus;

  /// Status shown when the app does not detect an Android Automotive OS device
  ///
  /// In en, this message translates to:
  /// **'Android Automotive OS not detected on this device'**
  String get aaosNotDetectedStatus;

  /// Description shown when downloads use the default storage location
  ///
  /// In en, this message translates to:
  /// **'Default location'**
  String get downloadLocationDefault;

  /// Description shown when download storage location selection is unavailable on Web
  ///
  /// In en, this message translates to:
  /// **'Not supported on Web'**
  String get downloadLocationUnsupportedWeb;

  /// Description of the system Downloads folder used for downloaded media
  ///
  /// In en, this message translates to:
  /// **'System Downloads ({path})'**
  String downloadLocationSystemDownloads(String path);

  /// Description of the app documents folder used when the system Downloads folder is unavailable
  ///
  /// In en, this message translates to:
  /// **'App documents folder (fallback)'**
  String get downloadLocationDocumentsFallback;

  /// Description of the private app storage folder used for downloads on Android
  ///
  /// In en, this message translates to:
  /// **'App documents folder (private app storage)'**
  String get downloadLocationPrivateDocuments;

  /// Description of the operating system sandboxed app documents folder used for downloads
  ///
  /// In en, this message translates to:
  /// **'App documents folder (sandboxed by OS)'**
  String get downloadLocationSandboxedDocuments;

  /// Description of the app documents folder used for downloaded media
  ///
  /// In en, this message translates to:
  /// **'App documents folder'**
  String get downloadLocationAppDocuments;

  /// Error message shown when a download is requested in the Web app
  ///
  /// In en, this message translates to:
  /// **'Downloads are not supported on Web'**
  String get downloadNotSupportedWeb;

  /// Error message shown when a previously selected Android download folder is unavailable
  ///
  /// In en, this message translates to:
  /// **'The selected Android folder is no longer accessible. Choose it again'**
  String get downloadLocationUnavailableAndroid;

  /// Error message shown when a custom download location is not a local folder
  ///
  /// In en, this message translates to:
  /// **'The download location must be a local folder on this platform'**
  String get downloadLocationMustBeLocal;

  /// Fallback heading for changelog entries without a section heading
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get changelogUpdates;

  /// Tooltip for a play history button that starts playback from the selected event
  ///
  /// In en, this message translates to:
  /// **'Play from here'**
  String get playbackPlayFromHere;

  /// Label for a shelf of media with unfinished playback, its browse destination, and an automatic download source
  ///
  /// In en, this message translates to:
  /// **'Continue listening'**
  String get shelfContinueListening;

  /// Label for the destination that lets users choose a media library
  ///
  /// In en, this message translates to:
  /// **'Libraries'**
  String get navLibraries;

  /// Label for the destination that lists downloaded media
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get navDownloads;

  /// Label for a control that opens more results or actions
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get actionMore;

  /// Fallback title for a downloaded media item with no available title
  ///
  /// In en, this message translates to:
  /// **'Downloaded media'**
  String get downloadedMedia;

  /// Fallback title for a podcast episode with no available title
  ///
  /// In en, this message translates to:
  /// **'Untitled episode'**
  String get untitledEpisode;

  /// Message below a browse item that can be selected to retry loading
  ///
  /// In en, this message translates to:
  /// **'Unable to load. Select to retry'**
  String get statusUnableToLoadRetry;

  /// Subtitle warning that a media section may take time to load
  ///
  /// In en, this message translates to:
  /// **'This can take a while to load'**
  String get statusMayTakeTimeToLoad;

  /// Status shown while the app prepares content for browsing
  ///
  /// In en, this message translates to:
  /// **'Loading content'**
  String get statusLoadingContent;

  /// Status shown while the app prepares the user's library
  ///
  /// In en, this message translates to:
  /// **'Loading your library'**
  String get statusLoadingLibrary;

  /// Error shown when a browse request arrives before content is ready
  ///
  /// In en, this message translates to:
  /// **'Android Automotive browse is not ready'**
  String get errorBrowseNotReady;

  /// Error shown when a user must sign in before browsing content
  ///
  /// In en, this message translates to:
  /// **'Authentication required'**
  String get errorAuthenticationRequired;

  /// Message shown when no account is signed in and content cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'No content is available while signed out'**
  String get errorNoContentSignedOut;

  /// Hint directing a signed-out user to sign in through app settings
  ///
  /// In en, this message translates to:
  /// **'Sign in through settings'**
  String get authSignInThroughSettings;

  /// Error shown when a browse request arrives without an Android Auto connection
  ///
  /// In en, this message translates to:
  /// **'Connect to Android Auto to browse'**
  String get errorAndroidAutoConnectionRequired;

  /// Displays an item count in browse results, lists, and selection summaries
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item} other{{count} items}}'**
  String itemCount(int count);

  /// Option that includes every available result in a filter or browse list
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// Label for a shelf showing recently added media
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get shelfRecentlyAdded;

  /// Label for a shelf or automatic download source showing the latest podcast episodes
  ///
  /// In en, this message translates to:
  /// **'Latest episodes'**
  String get shelfLatestEpisodes;

  /// Label for the destination that lists saved collections and the matching automatic download source
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get navCollections;

  /// Label for the destination that lists saved playlists and the matching automatic download source
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get navPlaylists;

  /// Label for a destination that helps users find media
  ///
  /// In en, this message translates to:
  /// **'Discovery'**
  String get navDiscovery;

  /// Label for a shelf or automatic download source showing series with unfinished items
  ///
  /// In en, this message translates to:
  /// **'Continue series'**
  String get shelfContinueSeries;

  /// Label for the destination that lists narrators
  ///
  /// In en, this message translates to:
  /// **'Narrators'**
  String get navNarrators;

  /// Title for a paged Android Auto collection or playlist browse item
  ///
  /// In en, this message translates to:
  /// **'{listName} {start} to {end}'**
  String listRangeTitle(String listName, int start, int end);

  /// Prefix identifying media that is available as a download
  ///
  /// In en, this message translates to:
  /// **'Downloaded'**
  String get statusDownloaded;

  /// Label for the reader speech action, its settings destination, and media narrated from book text
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get readerReadAloud;

  /// Subtitle for an audiobook being played as synchronized book narration
  ///
  /// In en, this message translates to:
  /// **'Book narration'**
  String get readerBookNarration;

  /// Label for a playback control that seeks to the next chapter
  ///
  /// In en, this message translates to:
  /// **'Next chapter'**
  String get playbackNextChapter;

  /// Label for a playback control that seeks to the previous chapter
  ///
  /// In en, this message translates to:
  /// **'Previous chapter'**
  String get playbackPreviousChapter;

  /// Displays a formatted transfer rate in a download or upload status
  ///
  /// In en, this message translates to:
  /// **'{rate}/s'**
  String transferRatePerSecond(String rate);

  /// Displays an hour count in compact remaining time or duration text
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String durationCompactHours(int count);

  /// Displays a minute count in compact remaining time or duration text
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String durationCompactMinutes(int count);

  /// Displays a second count in compact remaining time or duration text
  ///
  /// In en, this message translates to:
  /// **'{count}s'**
  String durationCompactSeconds(int count);

  /// Displays hours and minutes in compact remaining time or duration text
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationCompactHoursMinutes(int hours, int minutes);

  /// Displays minutes and seconds in compact remaining time or duration text
  ///
  /// In en, this message translates to:
  /// **'{minutes}m {seconds}s'**
  String durationCompactMinutesSeconds(int minutes, int seconds);

  /// Subtitle for narrated text that includes an estimated remaining time
  ///
  /// In en, this message translates to:
  /// **'Read aloud · {time} remaining'**
  String readerReadAloudEstimatedTime(String time);

  /// Label for the home destination that shows personalized media shelves
  ///
  /// In en, this message translates to:
  /// **'Shelf'**
  String get homeShelf;

  /// Label identifying a book that can be listened to
  ///
  /// In en, this message translates to:
  /// **'Audiobook'**
  String get mediaTypeAudiobook;

  /// Label identifying podcast media and the podcast source option for automatic downloads
  ///
  /// In en, this message translates to:
  /// **'Podcast'**
  String get mediaTypePodcast;

  /// Label for a shelf or automatic download source of books with unfinished reading progress
  ///
  /// In en, this message translates to:
  /// **'Continue reading'**
  String get shelfContinueReading;

  /// Label for a shelf of media pinned by the user
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get shelfPinned;

  /// Label for a shelf of media the user has listened to before
  ///
  /// In en, this message translates to:
  /// **'Listen again'**
  String get shelfListenAgain;

  /// Label for a shelf that helps users find media
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get shelfDiscover;

  /// Label for a shelf of recently added series
  ///
  /// In en, this message translates to:
  /// **'Recently added series'**
  String get shelfRecentlyAddedSeries;

  /// Label for a shelf of recently added authors
  ///
  /// In en, this message translates to:
  /// **'Recently added authors'**
  String get shelfRecentlyAddedAuthors;

  /// Option that stops audio when the sleep timer expires
  ///
  /// In en, this message translates to:
  /// **'Stop playback'**
  String get sleepTimerStopPlayback;

  /// Option that shows chapter markers on the player seek bar
  ///
  /// In en, this message translates to:
  /// **'Only chapters'**
  String get seekBarMarkersChapters;

  /// Option that shows bookmark markers on the player seek bar
  ///
  /// In en, this message translates to:
  /// **'Only bookmarks'**
  String get seekBarMarkersBookmarks;

  /// Option that shows bookmark and chapter markers on the player seek bar
  ///
  /// In en, this message translates to:
  /// **'Bookmarks and chapters'**
  String get seekBarMarkersBoth;

  /// Option that shows elapsed playback time in the Android live update
  ///
  /// In en, this message translates to:
  /// **'Show current time'**
  String get liveUpdateCurrentTime;

  /// Option that shows remaining playback time in the Android live update
  ///
  /// In en, this message translates to:
  /// **'Show remaining time'**
  String get liveUpdateRemainingTime;

  /// Option that shows the sleep timer in the Android live update
  ///
  /// In en, this message translates to:
  /// **'Show sleep timer'**
  String get liveUpdateSleepTimer;

  /// Option that shows playback progress as a percentage in the Android live update
  ///
  /// In en, this message translates to:
  /// **'Show progress percentage'**
  String get liveUpdateProgressPercentage;

  /// Name of the built-in speech engine in the voice selector
  ///
  /// In en, this message translates to:
  /// **'Device voices'**
  String get readerDeviceVoices;

  /// Validation message shown when a request header is missing its name or value
  ///
  /// In en, this message translates to:
  /// **'Header name and value are required'**
  String get validationRequestHeadersRequired;

  /// Validation message shown when a request header contains invalid characters
  ///
  /// In en, this message translates to:
  /// **'Enter a valid header name and value'**
  String get validationRequestHeadersInvalid;

  /// Label for a button that adds an item to a list or collection
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// Label for the destination that displays media from the selected library and the library section in settings
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// Status shown when every requested file finishes downloading
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get statusDownloadComplete;

  /// Status shown when a download is canceled
  ///
  /// In en, this message translates to:
  /// **'Download canceled'**
  String get statusDownloadCanceled;

  /// Status shown when a download cannot be completed
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get statusDownloadFailed;

  /// Status shown when a download is paused
  ///
  /// In en, this message translates to:
  /// **'Download paused'**
  String get statusDownloadPaused;

  /// Error shown when background downloads cannot continue without notification permission
  ///
  /// In en, this message translates to:
  /// **'Allow notifications to download files in the background'**
  String get errorNotificationsPermissionRequired;

  /// Error shown when the user requests a download in the web app
  ///
  /// In en, this message translates to:
  /// **'Downloads are not supported on the web'**
  String get errorDownloadsUnavailableWeb;

  /// Error shown when a download is requested without a signed-in account
  ///
  /// In en, this message translates to:
  /// **'Sign in before downloading media'**
  String get errorUserRequired;

  /// Error shown when the selected media cannot be loaded for download
  ///
  /// In en, this message translates to:
  /// **'The selected media is no longer available'**
  String get errorDownloadMediaNotFound;

  /// Error shown when the server reports that media files cannot be downloaded
  ///
  /// In en, this message translates to:
  /// **'The media files are unavailable on the server'**
  String get errorDownloadMediaUnavailable;

  /// Error shown when a podcast download is requested without selecting an episode
  ///
  /// In en, this message translates to:
  /// **'Choose a podcast episode to download'**
  String get errorPodcastEpisodeRequired;

  /// Error shown when download setup has no usable server configuration
  ///
  /// In en, this message translates to:
  /// **'The server is not available for downloads'**
  String get errorServerUnavailable;

  /// Error shown when a download cannot be added to the queue
  ///
  /// In en, this message translates to:
  /// **'Could not add the download to the queue. Check your connection and try again'**
  String get errorDownloadQueueUnavailable;

  /// Error shown when only some files in a download batch could be queued
  ///
  /// In en, this message translates to:
  /// **'Could not add all files to the download queue. Try again'**
  String get errorDownloadQueueIncomplete;

  /// Validation message shown when a custom audio download has no selected files
  ///
  /// In en, this message translates to:
  /// **'Choose at least one audio file'**
  String get errorAudioFileCountRequired;

  /// Error shown when the selected Android folder cannot be prepared for a download
  ///
  /// In en, this message translates to:
  /// **'Could not prepare the selected Android folder for download. Select the folder again and try again'**
  String get errorSafFolderUnavailable;

  /// Error shown when the selected media has no files available to download
  ///
  /// In en, this message translates to:
  /// **'No downloadable files were found'**
  String get errorNoDownloadableFiles;

  /// Title of a notification while media files are downloading
  ///
  /// In en, this message translates to:
  /// **'Downloading {displayName}'**
  String downloadNotificationRunningTitle(String displayName);

  /// Body of a notification showing progress for a single file download
  ///
  /// In en, this message translates to:
  /// **'{progress} ({timeRemaining} · {networkSpeed}) · {filename}'**
  String downloadNotificationSingleRunningBody(
    String progress,
    String timeRemaining,
    String networkSpeed,
    String filename,
  );

  /// Body of a notification showing progress for a multi-file download
  ///
  /// In en, this message translates to:
  /// **'{numFinished} of {numTotal} · Progress {progress}'**
  String downloadNotificationBatchRunningBody(String numFinished, String numTotal, String progress);

  /// Body of a notification after all files finish downloading
  ///
  /// In en, this message translates to:
  /// **'{displayName} ({filename})\nAll files downloaded'**
  String downloadNotificationCompleteBody(String displayName, String filename);

  /// Body of a notification after a download is canceled
  ///
  /// In en, this message translates to:
  /// **'{displayName} ({filename})\nDownload canceled'**
  String downloadNotificationCanceledBody(String displayName, String filename);

  /// Body of a notification after a download fails
  ///
  /// In en, this message translates to:
  /// **'{displayName} ({filename})\nDownload failed'**
  String downloadNotificationFailedBody(String displayName, String filename);

  /// Body of a notification after a download is paused
  ///
  /// In en, this message translates to:
  /// **'{displayName}\nProgress {progress} · Speed {networkSpeed}'**
  String downloadNotificationPausedBody(String displayName, String progress, String networkSpeed);

  /// Body of a notification after a multi-file download finishes
  ///
  /// In en, this message translates to:
  /// **'{displayName}\nAll files downloaded'**
  String downloadNotificationBatchCompleteBody(String displayName);

  /// Body of a notification after a multi-file download is canceled
  ///
  /// In en, this message translates to:
  /// **'{displayName}\nDownload canceled'**
  String downloadNotificationBatchCanceledBody(String displayName);

  /// Body of a notification after a multi-file download fails
  ///
  /// In en, this message translates to:
  /// **'{displayName}\nDownload failed'**
  String downloadNotificationBatchFailedBody(String displayName);

  /// Body of a notification after a multi-file download is paused
  ///
  /// In en, this message translates to:
  /// **'{displayName}\nProgress {progress}'**
  String downloadNotificationBatchPausedBody(String displayName, String progress);

  /// Option that downloads every audio file for an audiobook
  ///
  /// In en, this message translates to:
  /// **'All files'**
  String get audioFileModeAll;

  /// Option that downloads the current audio file and later files
  ///
  /// In en, this message translates to:
  /// **'All files starting from current'**
  String get audioFileModeFromCurrent;

  /// Error shown when the active account changes while a download is being prepared
  ///
  /// In en, this message translates to:
  /// **'Your signed-in account changed. Try the download again'**
  String get errorDownloadSessionChanged;

  /// Error shown when the server reports a problem with files selected for download
  ///
  /// In en, this message translates to:
  /// **'Media files are unavailable on the server. {issue}'**
  String errorDownloadMediaIssue(String issue);

  /// Option for the lowest background playback keep-alive level
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get playbackKeepAliveQuiet;

  /// Option for the middle background playback keep-alive level
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get playbackKeepAliveMedium;

  /// Option for the highest background playback keep-alive level
  ///
  /// In en, this message translates to:
  /// **'Stronger'**
  String get playbackKeepAliveStronger;

  /// Label for a button that finishes the current step and closes the view
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// Label for a button that applies the selected value
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get actionSet;

  /// Label for an action that clears every selected item
  ///
  /// In en, this message translates to:
  /// **'Unselect all'**
  String get actionUnselectAll;

  /// Label for an action that deletes the currently selected entries
  ///
  /// In en, this message translates to:
  /// **'Delete selected'**
  String get actionDeleteSelected;

  /// Label for an action that reloads the current content
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// Label for an action that opens the selected item or destination
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get actionOpen;

  /// Label for a control that returns to the previous screen
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// Label for an action that hides a warning
  ///
  /// In en, this message translates to:
  /// **'Dismiss warning'**
  String get actionDismissWarning;

  /// Label for an action that opens release details
  ///
  /// In en, this message translates to:
  /// **'View release'**
  String get actionViewRelease;

  /// Label for an action that postpones an update
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get actionLater;

  /// Label for a name field in forms, editors, tables, or settings
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// Label for a description field in an editor or settings form
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get fieldDescription;

  /// Label for an hours input in a duration picker
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get fieldHours;

  /// Label for a minutes input in duration and sleep timer controls
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get fieldMinutes;

  /// Label for a seconds input in a duration picker
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get fieldSeconds;

  /// Label for the account associated with an activity or session
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get fieldUser;

  /// Label for the device associated with an activity or session
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get fieldDevice;

  /// Label for a calendar date in a session or activity list
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// Label for a time of day or elapsed time in an activity list
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get fieldTime;

  /// Label for completion progress in a list or status view
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get fieldProgress;

  /// Hint indicating that a form field does not need a value
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get inputOptional;

  /// Displays the number of selected entries in lists, tables, dialogs, and selection toolbars
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected} other{{count} selected}}'**
  String selectedCount(int count);

  /// Displays a listening session count in a list, filter, or status
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session} other{{count} sessions}}'**
  String sessionCount(int count);

  /// Snackbar confirming that an open listening session was closed
  ///
  /// In en, this message translates to:
  /// **'Session closed'**
  String get sessionCloseSuccess;

  /// Snackbar shown when an open listening session could not be closed
  ///
  /// In en, this message translates to:
  /// **'Could not close session'**
  String get sessionCloseFailure;

  /// Empty state shown when the admin session list has no shared sessions
  ///
  /// In en, this message translates to:
  /// **'No shared sessions found'**
  String get sessionNoSharedSessions;

  /// Message shown when a user must sign in before opening session management
  ///
  /// In en, this message translates to:
  /// **'No active user. Sign in to manage sessions'**
  String get sessionSignInRequired;

  /// Label for filtering the admin session list by user
  ///
  /// In en, this message translates to:
  /// **'Filter by user'**
  String get sessionFilterUser;

  /// Heading for currently open listening sessions in the admin session list
  ///
  /// In en, this message translates to:
  /// **'Open sessions'**
  String get headingOpenSessions;

  /// Heading for shared listening sessions in the admin session list
  ///
  /// In en, this message translates to:
  /// **'Shared sessions'**
  String get headingSharedSessions;

  /// Empty state shown when a selectable list has no options
  ///
  /// In en, this message translates to:
  /// **'No options available'**
  String get statusNoOptionsAvailable;

  /// Confirmation shown after one or more listening sessions are deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 session deleted} other{{count} sessions deleted}}'**
  String sessionDeleteSuccess(int count);

  /// Error shown when one or more listening sessions cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Could not delete 1 session. Check logs for details} other{Could not delete {count} sessions. Check logs for details}}'**
  String sessionDeleteFailure(int count);

  /// Confirmation prompt asking whether to permanently delete one or more listening sessions
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete this session? This cannot be undone} other{Delete {count} selected sessions? This cannot be undone}}'**
  String sessionDeletePrompt(int count);

  /// Title of a confirmation dialog for deleting selected listening sessions
  ///
  /// In en, this message translates to:
  /// **'Delete selected sessions'**
  String get sessionDeleteTitle;

  /// Label for a filter that narrows listening sessions to an episode
  ///
  /// In en, this message translates to:
  /// **'Filter by episode'**
  String get sessionFilterEpisode;

  /// Option that includes sessions for every episode
  ///
  /// In en, this message translates to:
  /// **'All episodes'**
  String get sessionAllEpisodes;

  /// Error shown when user information cannot be loaded for session history
  ///
  /// In en, this message translates to:
  /// **'Could not load the user'**
  String get errorCouldNotLoadUser;

  /// Label for a control that selects how many list entries appear on each page
  ///
  /// In en, this message translates to:
  /// **'Per page'**
  String get paginationPerPage;

  /// Displays the total number of entries across all pages
  ///
  /// In en, this message translates to:
  /// **'Total {count}'**
  String paginationTotal(int count);

  /// Displays the current page number and page count in paginated lists or the reader
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages}'**
  String paginationPage(int page, int pages);

  /// Tooltip for a control that opens the previous page of a list
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get paginationPreviousPage;

  /// Tooltip for a control that opens the next page in a reader, paginated list, or media control page
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get paginationNextPage;

  /// Title of the dialog that lists recent app changes
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogTitle;

  /// Title of the startup dialog that lists recent app changes
  ///
  /// In en, this message translates to:
  /// **'What’s new'**
  String get changelogWhatsNew;

  /// Label showing the version associated with a changelog release
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String changelogVersion(String version);

  /// Label for a button that opens the app sponsorship page
  ///
  /// In en, this message translates to:
  /// **'Sponsors'**
  String get changelogSponsors;

  /// Error shown when release notes cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load the changelog'**
  String get changelogErrorLoad;

  /// Empty state shown when a release has no available notes
  ///
  /// In en, this message translates to:
  /// **'No release notes are available for this version yet'**
  String get changelogNoReleaseNotes;

  /// Label for an option that disables future changelog prompts
  ///
  /// In en, this message translates to:
  /// **'Don’t show again'**
  String get changelogDontShowAgain;

  /// Error shown when the changelog display preference cannot be saved
  ///
  /// In en, this message translates to:
  /// **'Could not save your preference. Try again'**
  String get changelogErrorSavePreference;

  /// Error shown when the sponsorship page cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open GitHub Sponsors. Try again'**
  String get changelogErrorSponsorOpen;

  /// Error shown when a screen requires a server connection that is unavailable
  ///
  /// In en, this message translates to:
  /// **'No server connection available'**
  String get errorConnectionUnavailable;

  /// Message shown when a non-administrator opens server library statistics
  ///
  /// In en, this message translates to:
  /// **'Library-wide statistics are only available to administrators'**
  String get errorAdminLibraryStatistics;

  /// Prompt shown when a signed-out user opens server library statistics
  ///
  /// In en, this message translates to:
  /// **'An active admin account is required'**
  String get promptSignInToViewLibraryStatistics;

  /// Error shown when library lists cannot be refreshed
  ///
  /// In en, this message translates to:
  /// **'Could not refresh lists. Retry'**
  String get errorRefreshLists;

  /// Label for a search field that filters available books
  ///
  /// In en, this message translates to:
  /// **'Search books'**
  String get searchBooks;

  /// Hint listing the book details that can be used in search
  ///
  /// In en, this message translates to:
  /// **'Title, author, or series'**
  String get searchBooksTitleAuthorSeries;

  /// Option that removes an entry from the server while keeping its media files
  ///
  /// In en, this message translates to:
  /// **'Delete from Audiobookshelf only'**
  String get deleteFromServerOnlyTitle;

  /// Explanation of deleting a server entry while retaining its media files
  ///
  /// In en, this message translates to:
  /// **'Removes the entry from the server and keeps its media files on disk. It may return after a library rescan'**
  String get deleteFromServerOnlySubtitle;

  /// Option that removes an entry from the server and deletes its media files
  ///
  /// In en, this message translates to:
  /// **'Delete from Audiobookshelf and file system'**
  String get deleteFromServerAndFilesTitle;

  /// Explanation of deleting a server entry and its media files
  ///
  /// In en, this message translates to:
  /// **'Permanently removes the entry and its media files'**
  String get deleteFromServerAndFilesSubtitle;

  /// Message shown when PDF reading is requested on an unsupported platform
  ///
  /// In en, this message translates to:
  /// **'PDF reading is currently supported only on Linux'**
  String get errorPdfReadingLinuxOnly;

  /// Tooltip for a control that moves to the folder containing the current folder
  ///
  /// In en, this message translates to:
  /// **'Parent folder'**
  String get filesystemParentFolder;

  /// Label for a button that selects the currently open folder
  ///
  /// In en, this message translates to:
  /// **'Use current folder'**
  String get filesystemUseCurrentFolder;

  /// Title of a dialog announcing an available app update
  ///
  /// In en, this message translates to:
  /// **'New yaabsa release'**
  String get appUpdateAvailableTitle;

  /// Message showing the available app version and the currently installed version
  ///
  /// In en, this message translates to:
  /// **'Version {latestVersion} is available. You are using {currentVersion}'**
  String appUpdateAvailableMessage(String latestVersion, String currentVersion);

  /// Title of a dialog announcing an available Audiobookshelf server update
  ///
  /// In en, this message translates to:
  /// **'Server update available'**
  String get serverUpdateAvailableTitle;

  /// Message showing an available Audiobookshelf server version
  ///
  /// In en, this message translates to:
  /// **'A new update, version {version}, is available for your Audiobookshelf server'**
  String serverUpdateAvailableMessage(String version);

  /// Title of a confirmation dialog for deleting one listening session
  ///
  /// In en, this message translates to:
  /// **'Delete session'**
  String get sessionDeleteSingleTitle;

  /// Title of a confirmation dialog for deleting a shared listening session
  ///
  /// In en, this message translates to:
  /// **'Delete shared session'**
  String get sessionDeleteSharedTitle;

  /// Confirmation prompt asking whether to permanently delete a shared listening session
  ///
  /// In en, this message translates to:
  /// **'Delete this shared session permanently? This cannot be undone'**
  String get sessionDeleteSharedPrompt;

  /// Title of a dialog showing details for a shared listening session
  ///
  /// In en, this message translates to:
  /// **'Shared session'**
  String get sessionSharedTitle;

  /// Label for an action that closes an active listening session
  ///
  /// In en, this message translates to:
  /// **'Close session'**
  String get sessionCloseAction;

  /// Label for the identifier of a listening session
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get fieldSessionId;

  /// Fallback title shown when a listening session has no media title
  ///
  /// In en, this message translates to:
  /// **'Unknown item'**
  String get unknownMediaItem;

  /// Empty state shown when a session list has no results
  ///
  /// In en, this message translates to:
  /// **'No listening sessions found'**
  String get sessionNoResults;

  /// Empty state shown when a user has no active listening sessions
  ///
  /// In en, this message translates to:
  /// **'No open sessions found'**
  String get sessionNoOpenSessions;

  /// Label for an action that opens the list of downloaded media
  ///
  /// In en, this message translates to:
  /// **'Open downloads'**
  String get actionOpenDownloads;

  /// Empty state shown in the selected books panel
  ///
  /// In en, this message translates to:
  /// **'No books selected'**
  String get booksNoneSelected;

  /// Title of a confirmation dialog for deleting one or more audiobooks
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete audiobook?} other{Delete audiobooks?}}'**
  String deleteAudiobookTitle(int count);

  /// Warning shown before one or more audiobooks are deleted from Audiobookshelf
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This action will remove the audiobook from Audiobookshelf and cannot be undone} other{This action will remove {count} audiobooks from Audiobookshelf and cannot be undone}}'**
  String deleteAudiobookWarning(int count);

  /// Prompt asking the user to choose what to remove when deleting an audiobook
  ///
  /// In en, this message translates to:
  /// **'Choose a deletion option'**
  String get deleteModePrompt;

  /// Message explaining that selected non-audiobook items will not be deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 selected item is not an audiobook and will be skipped} other{{count} selected items are not audiobooks and will be skipped}}'**
  String deleteSkippedNonAudiobooks(int count);

  /// Label for the top level of the current file system folder picker
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get filesystemRoot;

  /// Empty state shown when the current location has no folders to select
  ///
  /// In en, this message translates to:
  /// **'No folders are available'**
  String get filesystemNoDirectories;

  /// Title of a dialog for selecting a folder on the server
  ///
  /// In en, this message translates to:
  /// **'Browse server folders'**
  String get browseServerFolders;

  /// Title shown when a screen cannot load its content
  ///
  /// In en, this message translates to:
  /// **'Unable to load content'**
  String get errorUnableToLoadContent;

  /// Guidance shown when content fails to load from the server
  ///
  /// In en, this message translates to:
  /// **'Try again. If the issue continues, check your server connection'**
  String get errorRetryCheckConnection;

  /// Message shown when a section requires an active server connection
  ///
  /// In en, this message translates to:
  /// **'This section needs an active server connection. Reconnect and try again'**
  String get errorSectionRequiresServerConnection;

  /// Label for a button that loads the next group of list entries
  ///
  /// In en, this message translates to:
  /// **'Load more'**
  String get actionLoadMore;

  /// Label for a button that retries loading more list entries
  ///
  /// In en, this message translates to:
  /// **'Could not load more. Retry'**
  String get errorLoadMoreRetry;

  /// Label for a title field in media details, editors, and tables
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// Compact label announcing an available server update
  ///
  /// In en, this message translates to:
  /// **'Update {version}'**
  String serverUpdateAvailableShort(String version);

  /// Error shown when a settings backup exceeds the maximum import size
  ///
  /// In en, this message translates to:
  /// **'The settings backup is too large'**
  String get errorSettingsBackupTooLarge;

  /// Error shown when the selected file is not a yaabsa settings backup
  ///
  /// In en, this message translates to:
  /// **'Choose a yaabsa settings backup'**
  String get errorChooseSettingsBackup;

  /// Error shown when a settings backup uses an unsupported format version
  ///
  /// In en, this message translates to:
  /// **'This settings backup version is not supported'**
  String get errorSettingsBackupVersion;

  /// Error shown when account settings in a backup are invalid
  ///
  /// In en, this message translates to:
  /// **'The settings backup has an invalid account settings section'**
  String get errorSettingsBackupAccounts;

  /// Error shown when a settings section is missing from a backup
  ///
  /// In en, this message translates to:
  /// **'The settings backup is missing a settings section'**
  String get errorSettingsBackupMissingSection;

  /// Error shown when a backup contains a setting value that cannot be restored
  ///
  /// In en, this message translates to:
  /// **'The settings backup contains an invalid value'**
  String get errorSettingsBackupInvalidValue;

  /// Validation message shown when sign-in is submitted without both credentials
  ///
  /// In en, this message translates to:
  /// **'Enter a username and password'**
  String get errorCredentialsRequired;

  /// Error shown when sign-in does not return an authenticated account session
  ///
  /// In en, this message translates to:
  /// **'The server did not return a valid account session'**
  String get errorAccountSessionInvalid;

  /// Error shown on the watch when media cannot continue playing
  ///
  /// In en, this message translates to:
  /// **'Playback failed. Check your connection or use a download'**
  String get errorWearPlaybackFailed;

  /// Error shown when the selected item has no playable audio
  ///
  /// In en, this message translates to:
  /// **'This item cannot be played'**
  String get errorMediaCannotPlay;

  /// Category that lists every audiobook in a library
  ///
  /// In en, this message translates to:
  /// **'All audiobooks'**
  String get filterAllAudiobooks;

  /// Label for a cache rule covering the libraries list response
  ///
  /// In en, this message translates to:
  /// **'Libraries list'**
  String get cacheLibrariesList;

  /// Label for a cache rule covering individual library details
  ///
  /// In en, this message translates to:
  /// **'Library details'**
  String get cacheLibraryDetails;

  /// Label for a cache rule covering individual media item details
  ///
  /// In en, this message translates to:
  /// **'Item details'**
  String get cacheItemDetails;

  /// Label for a cache rule covering nested media item resources
  ///
  /// In en, this message translates to:
  /// **'Item resource'**
  String get cacheItemResource;

  /// Label for a cache rule covering available library filters
  ///
  /// In en, this message translates to:
  /// **'Library filters'**
  String get cacheLibraryFilterData;

  /// Label for a cache rule covering series within a library
  ///
  /// In en, this message translates to:
  /// **'Library series'**
  String get cacheLibrarySeries;

  /// Label for a cache rule covering the signed-in user profile
  ///
  /// In en, this message translates to:
  /// **'Current user profile'**
  String get cacheCurrentUserProfile;

  /// Error shown when ElevenLabs does not accept the saved API key
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs rejected the API key. Check it in Read aloud settings'**
  String get errorElevenLabsApiKeyRejected;

  /// Error shown when the API key cannot list speech models
  ///
  /// In en, this message translates to:
  /// **'This key cannot list models. Enable Models read permission or use an available model'**
  String get errorElevenLabsModelsReadPermission;

  /// Error shown when the API key cannot list speech voices
  ///
  /// In en, this message translates to:
  /// **'This key cannot list voices. Enable Voices read permission or enter a voice ID'**
  String get errorElevenLabsVoicesReadPermission;

  /// Error shown when the API key cannot generate speech
  ///
  /// In en, this message translates to:
  /// **'Enable Text to speech permission for this ElevenLabs key'**
  String get errorElevenLabsSpeechPermission;

  /// Error shown when the ElevenLabs account has run out of speech credits
  ///
  /// In en, this message translates to:
  /// **'Your ElevenLabs account has no speech credits available'**
  String get errorElevenLabsNoCredits;

  /// Error shown when ElevenLabs reports a billing issue
  ///
  /// In en, this message translates to:
  /// **'Check your ElevenLabs billing and available speech credits'**
  String get errorElevenLabsBillingIssue;

  /// Error shown when the selected voice or model is unavailable
  ///
  /// In en, this message translates to:
  /// **'The selected ElevenLabs voice or model was not found'**
  String get errorElevenLabsVoiceOrModelNotFound;

  /// Error shown when text is longer than the selected speech model allows
  ///
  /// In en, this message translates to:
  /// **'This text exceeds the selected ElevenLabs model character limit'**
  String get errorElevenLabsCharacterLimit;

  /// Error shown when a voice or model is unavailable on the current subscription
  ///
  /// In en, this message translates to:
  /// **'The selected ElevenLabs voice or model requires a different plan'**
  String get errorElevenLabsPlanRequired;

  /// Error shown when ElevenLabs does not authorize an API request
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs could not authorize this request. Check the API key and its permissions'**
  String get errorElevenLabsUnauthorized;

  /// Error shown when the account cannot perform a requested operation
  ///
  /// In en, this message translates to:
  /// **'Your ElevenLabs key or account does not allow this operation'**
  String get errorElevenLabsNotAllowed;

  /// Error shown when ElevenLabs temporarily limits API requests
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs is busy or rate limited. Try again shortly'**
  String get errorElevenLabsRateLimited;

  /// Error shown when ElevenLabs cannot use the selected speech settings
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs rejected the speech settings. Check the model, language, and voice ID'**
  String get errorElevenLabsSpeechSettingsRejected;

  /// Error shown when the app cannot reach the ElevenLabs service
  ///
  /// In en, this message translates to:
  /// **'Could not reach ElevenLabs. Check your connection and try again'**
  String get errorElevenLabsUnavailable;

  /// Error shown when the app cannot read the saved speech provider key
  ///
  /// In en, this message translates to:
  /// **'Could not access secure storage. Unlock your keyring and try again'**
  String get errorSecureStorageUnavailable;

  /// Error shown when no ElevenLabs API key is configured
  ///
  /// In en, this message translates to:
  /// **'Add your ElevenLabs API key in Read aloud settings'**
  String get errorElevenLabsApiKeyMissing;

  /// Error shown when the response from ElevenLabs contains an invalid model list
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs returned an invalid model list'**
  String get errorElevenLabsModelListInvalid;

  /// Error shown when the response from ElevenLabs contains an invalid voice list
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs returned an invalid voice list'**
  String get errorElevenLabsVoiceListInvalid;

  /// Error shown when voice results from ElevenLabs have invalid page information
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs returned invalid voice pagination'**
  String get errorElevenLabsVoicePageInvalid;

  /// Error shown when speech settings do not specify an ElevenLabs voice
  ///
  /// In en, this message translates to:
  /// **'Choose an ElevenLabs voice or enter its voice ID in Read aloud settings'**
  String get errorElevenLabsVoiceRequired;

  /// Validation error shown when the preferred speech language code is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid preferred language code in Read aloud settings'**
  String get errorReaderLanguageCodeInvalid;

  /// Error shown when the selected ElevenLabs model is unsupported
  ///
  /// In en, this message translates to:
  /// **'Choose an ElevenLabs v2 or v4 model'**
  String get errorElevenLabsModelRequired;

  /// Error shown when ElevenLabs does not return an identifier for generated speech
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs did not return a request ID for the combined speech'**
  String get errorElevenLabsRequestIdMissing;

  /// Error shown when ElevenLabs returns no audio for a speech request
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs returned no speech audio'**
  String get errorElevenLabsSpeechAudioMissing;

  /// Error shown when generated speech audio cannot be read
  ///
  /// In en, this message translates to:
  /// **'ElevenLabs returned invalid speech audio'**
  String get errorElevenLabsSpeechAudioInvalid;

  /// Error shown when the app cannot play audio created by the reader speech engine
  ///
  /// In en, this message translates to:
  /// **'Could not play the narrated audio'**
  String get errorReaderSpeechAudioUnavailable;

  /// Error shown when the configured reader speech provider cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'The selected speech provider is unavailable'**
  String get errorReaderSpeechProviderUnavailable;

  /// Error shown when the built-in device speech engine cannot start
  ///
  /// In en, this message translates to:
  /// **'The device could not start speech'**
  String get errorDeviceSpeechUnavailable;

  /// Error shown when a second cast connection is started while one is in progress
  ///
  /// In en, this message translates to:
  /// **'A cast connection is already being prepared'**
  String get errorCastConnectionBusy;

  /// Error shown when the current item has no audio that can be sent to a receiver
  ///
  /// In en, this message translates to:
  /// **'There is no audio available to cast'**
  String get errorCastNoAudio;

  /// Error shown when the current media changes during cast setup
  ///
  /// In en, this message translates to:
  /// **'Playback changed while connecting to the receiver'**
  String get errorCastPlaybackChanged;

  /// Status shown when a cast connection or playback request is canceled
  ///
  /// In en, this message translates to:
  /// **'Cast playback was canceled'**
  String get errorCastCancelled;

  /// Error shown when the active audio track cannot be resolved for casting
  ///
  /// In en, this message translates to:
  /// **'Unable to determine the current track'**
  String get errorCastTrackUnknown;

  /// Error shown when casting requires a server connection that is unavailable
  ///
  /// In en, this message translates to:
  /// **'Connect to the server before casting this item'**
  String get errorCastServerConnectionRequired;

  /// Error shown when the server cannot prepare an audio stream for a receiver
  ///
  /// In en, this message translates to:
  /// **'Could not prepare an audio stream for casting'**
  String get errorCastStreamUnavailable;

  /// Error shown when the server response contains no playable audio track
  ///
  /// In en, this message translates to:
  /// **'The server did not provide a playable audio track'**
  String get errorCastTrackUnavailable;

  /// Error shown when the server response contains no playable audio address
  ///
  /// In en, this message translates to:
  /// **'The server did not provide a playable audio address'**
  String get errorCastPlayableUrlUnavailable;

  /// Error shown when a cast action requires a connected receiver
  ///
  /// In en, this message translates to:
  /// **'No cast device is connected'**
  String get errorCastNoDeviceConnected;

  /// Error shown when a previously discovered cast device is no longer available
  ///
  /// In en, this message translates to:
  /// **'This cast device is no longer available'**
  String get errorCastDeviceGone;

  /// Error shown when Chromecast cannot be used on the current device
  ///
  /// In en, this message translates to:
  /// **'Chromecast is unavailable on this device'**
  String get errorChromecastUnavailable;

  /// Error shown when the selected Chromecast is no longer available
  ///
  /// In en, this message translates to:
  /// **'This Chromecast is no longer available'**
  String get errorChromecastGone;

  /// Error shown when a receiver cannot load the selected audio
  ///
  /// In en, this message translates to:
  /// **'The receiver could not load this audio'**
  String get errorCastReceiverLoadFailed;

  /// Error shown when a receiver does not confirm that audio loaded
  ///
  /// In en, this message translates to:
  /// **'The receiver did not confirm loading this audio'**
  String get errorCastReceiverLoadUnconfirmed;

  /// Error shown when a receiver cannot seek within the selected audio
  ///
  /// In en, this message translates to:
  /// **'The receiver could not seek to the requested position'**
  String get errorCastSeekFailed;

  /// Error shown when a receiver does not begin playing the selected audio
  ///
  /// In en, this message translates to:
  /// **'The receiver did not start playback. Check its audio support and output'**
  String get errorCastPlaybackStartFailed;

  /// Error shown when playback stops advancing on a receiver
  ///
  /// In en, this message translates to:
  /// **'The receiver stopped advancing playback. Check its audio support and output'**
  String get errorCastPlaybackStalled;

  /// Error shown when a receiver reports that playback failed
  ///
  /// In en, this message translates to:
  /// **'The receiver reported a playback error'**
  String get errorCastReceiverReportedError;

  /// Error shown when a receiver does not support the selected audio
  ///
  /// In en, this message translates to:
  /// **'The receiver could not play this audio'**
  String get errorCastReceiverCannotPlay;

  /// Error shown when a receiver stops responding during playback
  ///
  /// In en, this message translates to:
  /// **'The receiver stopped responding'**
  String get errorCastReceiverUnresponsive;

  /// Error shown when volume cannot be changed on the selected receiver
  ///
  /// In en, this message translates to:
  /// **'This receiver does not support volume control'**
  String get errorCastVolumeUnsupported;

  /// Error shown when playback speed cannot be changed on the selected receiver
  ///
  /// In en, this message translates to:
  /// **'Playback speed is unavailable on this receiver'**
  String get errorCastSpeedUnavailable;

  /// Action for selecting every available entry or field in a list, dialog, or editor
  ///
  /// In en, this message translates to:
  /// **'Select all'**
  String get actionSelectAll;

  /// Label for an action that clears every selected item or filter
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get actionClearAll;

  /// Label for an action that applies a selected value or change
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// Label for an action that disconnects a connected device
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get actionDisconnect;

  /// Label for an action that resumes paused playback or work
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get actionResume;

  /// Label for an audio volume value or control
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get fieldVolume;

  /// Label for a year selection or value
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get fieldYear;

  /// Label for a group of files
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get fieldFiles;

  /// Label for the time spent listening
  ///
  /// In en, this message translates to:
  /// **'Listening time'**
  String get fieldListeningTime;

  /// Label for total listening time
  ///
  /// In en, this message translates to:
  /// **'Total listening'**
  String get fieldTotalListening;

  /// Label for listening sessions
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get fieldSessions;

  /// Label for the average listening session duration
  ///
  /// In en, this message translates to:
  /// **'Average session'**
  String get fieldAverageSession;

  /// Label for the median listening session duration
  ///
  /// In en, this message translates to:
  /// **'Median session'**
  String get fieldMedianSession;

  /// Label for the longest listening session duration
  ///
  /// In en, this message translates to:
  /// **'Longest session'**
  String get fieldLongestSession;

  /// Label for the longest run of consecutive active days
  ///
  /// In en, this message translates to:
  /// **'Longest streak'**
  String get fieldLongestStreak;

  /// Label for time spent listening to books
  ///
  /// In en, this message translates to:
  /// **'Book listening'**
  String get fieldBookListening;

  /// Label for time spent listening to podcasts
  ///
  /// In en, this message translates to:
  /// **'Podcast listening'**
  String get fieldPodcastListening;

  /// Label for the number of distinct library items
  ///
  /// In en, this message translates to:
  /// **'Unique items'**
  String get fieldUniqueItems;

  /// Label for the number of distinct authors
  ///
  /// In en, this message translates to:
  /// **'Unique authors'**
  String get fieldUniqueAuthors;

  /// Label for the weekday with the most listening
  ///
  /// In en, this message translates to:
  /// **'Favorite weekday'**
  String get fieldFavoriteWeekday;

  /// Label for the hour with the most listening
  ///
  /// In en, this message translates to:
  /// **'Favorite hour'**
  String get fieldFavoriteHour;

  /// Label for the earliest listening session
  ///
  /// In en, this message translates to:
  /// **'First session'**
  String get fieldFirstSession;

  /// Label for the most recent listening session
  ///
  /// In en, this message translates to:
  /// **'Latest session'**
  String get fieldLatestSession;

  /// Label for the average listening time on an active day
  ///
  /// In en, this message translates to:
  /// **'Average active day'**
  String get fieldAverageActiveDay;

  /// Label for the month with the most listening
  ///
  /// In en, this message translates to:
  /// **'Peak month'**
  String get fieldPeakMonth;

  /// Label for the number of completed books
  ///
  /// In en, this message translates to:
  /// **'Books finished'**
  String get fieldBooksFinished;

  /// Label for the number of books played
  ///
  /// In en, this message translates to:
  /// **'Books listened'**
  String get fieldBooksListened;

  /// Label for days with listening activity
  ///
  /// In en, this message translates to:
  /// **'Active days'**
  String get fieldActiveDays;

  /// Count of authors shown in a library or statistics view
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 author} other{{count} authors}}'**
  String authorCount(int count);

  /// Count of days shown in a duration or activity summary
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String dayCount(int count);

  /// Count of files shown in a download or upload view
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file} other{{count} files}}'**
  String fileCount(int count);

  /// Heading for the library items with the most listening time
  ///
  /// In en, this message translates to:
  /// **'Top items'**
  String get headingTopItems;

  /// Heading for authors with the most listening time
  ///
  /// In en, this message translates to:
  /// **'Top authors'**
  String get headingTopAuthors;

  /// Heading for genres with the most listening time
  ///
  /// In en, this message translates to:
  /// **'Top genres'**
  String get headingTopGenres;

  /// Heading for narrators with the most listening time
  ///
  /// In en, this message translates to:
  /// **'Top narrators'**
  String get headingTopNarrators;

  /// Heading for listening totals grouped by weekday
  ///
  /// In en, this message translates to:
  /// **'Weekday breakdown'**
  String get headingWeekdayBreakdown;

  /// Heading for listening totals grouped by hour of day
  ///
  /// In en, this message translates to:
  /// **'Busiest hours'**
  String get headingBusiestHours;

  /// Heading for months with the most listening time
  ///
  /// In en, this message translates to:
  /// **'Top months'**
  String get headingTopMonths;

  /// Heading for a summary of how regularly the user listens
  ///
  /// In en, this message translates to:
  /// **'Listening consistency'**
  String get headingListeningConsistency;

  /// Heading for the annual listening recap card
  ///
  /// In en, this message translates to:
  /// **'{year} rewind'**
  String headingYearRewind(int year);

  /// Label for a listening summary covering a recent number of days
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Last day} other{Last {count} days}}'**
  String statsLastDays(int count);

  /// Label for the average listening time per day in a chart
  ///
  /// In en, this message translates to:
  /// **'Daily average'**
  String get statsDailyAverage;

  /// Label for the combined runtime of every item in a library
  ///
  /// In en, this message translates to:
  /// **'Overall runtime'**
  String get statsOverallRuntime;

  /// Label for the combined file size of every item in a library
  ///
  /// In en, this message translates to:
  /// **'Total size'**
  String get statsTotalSize;

  /// Heading for summary metrics about the selected library
  ///
  /// In en, this message translates to:
  /// **'Library overview'**
  String get statsLibraryOverview;

  /// Heading for the items with the greatest runtime in a library
  ///
  /// In en, this message translates to:
  /// **'Longest items'**
  String get statsLongestItems;

  /// Heading for the items with the greatest file size in a library
  ///
  /// In en, this message translates to:
  /// **'Largest items'**
  String get statsLargestItems;

  /// Empty state shown when library statistics have no genre information
  ///
  /// In en, this message translates to:
  /// **'No genre information is available'**
  String get statsNoGenreInformation;

  /// Empty state shown when library statistics have no author information
  ///
  /// In en, this message translates to:
  /// **'No author information is available'**
  String get statsNoAuthorInformation;

  /// Empty state shown when library statistics have no item duration information
  ///
  /// In en, this message translates to:
  /// **'No item duration information is available'**
  String get statsNoItemDurationInformation;

  /// Empty state shown when library statistics have no item size information
  ///
  /// In en, this message translates to:
  /// **'No item size information is available'**
  String get statsNoItemSizeInformation;

  /// Error shown when statistics for the selected library cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load library statistics'**
  String get statsLibraryLoadError;

  /// Label for the day with the most listening in a chart
  ///
  /// In en, this message translates to:
  /// **'Peak day'**
  String get statsPeakDay;

  /// Message shown when listening totals cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Listening totals unavailable'**
  String get statsListeningUnavailable;

  /// Message shown when listening activity cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load listening activity'**
  String get statsActivityUnavailable;

  /// Message shown when advanced listening analytics are unavailable
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics could not be calculated'**
  String get statsAdvancedUnavailable;

  /// Message shown when the selected year has no listening summary
  ///
  /// In en, this message translates to:
  /// **'No year-in-review data is available for this year'**
  String get statsYearUnavailable;

  /// Message shown when there is no listening activity grouped by weekday
  ///
  /// In en, this message translates to:
  /// **'No weekday listening data is available'**
  String get statsNoWeekdayData;

  /// Message shown when there are no recent listening sessions
  ///
  /// In en, this message translates to:
  /// **'No recent sessions are available'**
  String get statsNoRecentSessions;

  /// Message shown when the selected year has no author ranking
  ///
  /// In en, this message translates to:
  /// **'No top authors are available for this year'**
  String get statsNoTopAuthorsYear;

  /// Message shown when the selected year has no genre ranking
  ///
  /// In en, this message translates to:
  /// **'No top genres are available for this year'**
  String get statsNoTopGenresYear;

  /// Name of Monday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// Name of Tuesday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// Name of Wednesday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// Name of Thursday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// Name of Friday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// Name of Saturday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// Name of Sunday in a weekday chart or date label
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// Heading for preset sleep timer choices
  ///
  /// In en, this message translates to:
  /// **'Quick start'**
  String get sleepTimerQuickStart;

  /// Label for a sleep timer preset that ends after the current chapter
  ///
  /// In en, this message translates to:
  /// **'End of chapter'**
  String get sleepTimerEndOfChapter;

  /// Label for extending a chapter-based sleep timer by one chapter
  ///
  /// In en, this message translates to:
  /// **'Add chapter'**
  String get sleepTimerAddChapter;

  /// Label for extending a sleep timer by a number of minutes
  ///
  /// In en, this message translates to:
  /// **'Add {count} min'**
  String sleepTimerAddMinutes(int count);

  /// Status showing how many chapters remain on a sleep timer
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter remaining} other{{count} chapters remaining}}'**
  String sleepTimerChaptersRemaining(int count);

  /// Message shown when a chapter-based sleep timer cannot start
  ///
  /// In en, this message translates to:
  /// **'No chapter is available at the current position'**
  String get sleepTimerNoChapterAvailable;

  /// Validation message for a number that must be positive
  ///
  /// In en, this message translates to:
  /// **'Enter a number greater than zero'**
  String get validationPositiveNumberRequired;

  /// Label for a manually entered playback speed
  ///
  /// In en, this message translates to:
  /// **'Custom value'**
  String get speedCustomValue;

  /// Example range for supported playback speed values
  ///
  /// In en, this message translates to:
  /// **'{minimum}–{maximum}'**
  String speedRangeHint(double minimum, double maximum);

  /// Accessibility label shown while playback is starting
  ///
  /// In en, this message translates to:
  /// **'Loading playback'**
  String get playbackSpeedLoading;

  /// Label for playback speed in controls, settings, and action selection
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get playbackSpeed;

  /// Tooltip for the current audio volume
  ///
  /// In en, this message translates to:
  /// **'Volume {volume}%'**
  String playerVolumeTooltip(int volume);

  /// Heading or tooltip for opening the list of available cast receivers
  ///
  /// In en, this message translates to:
  /// **'Cast devices'**
  String get castDevices;

  /// Label for refreshing the list of available cast receivers
  ///
  /// In en, this message translates to:
  /// **'Search again'**
  String get playerSearchAgain;

  /// Message shown when bookmarking is only available in the reader
  ///
  /// In en, this message translates to:
  /// **'Use the reader to bookmark a passage'**
  String get playerBookmarkInReader;

  /// Message shown when there is no active media to bookmark
  ///
  /// In en, this message translates to:
  /// **'No active media to bookmark'**
  String get playerNoMediaToBookmark;

  /// Tooltip for returning playback to the sleep timer start position
  ///
  /// In en, this message translates to:
  /// **'Return to sleep timer start'**
  String get playerSleepTimerStart;

  /// Label for fetching metadata automatically during upload
  ///
  /// In en, this message translates to:
  /// **'Auto-fetch metadata'**
  String get uploadAutoFetchMetadata;

  /// Label for accepting fetched metadata automatically during upload
  ///
  /// In en, this message translates to:
  /// **'Auto-accept metadata'**
  String get uploadAutoAcceptMetadata;

  /// Label for suggesting matching series and authors during upload
  ///
  /// In en, this message translates to:
  /// **'Autocomplete series and authors'**
  String get uploadAutocompleteEntities;

  /// Message shown when an upload option requires an administrator
  ///
  /// In en, this message translates to:
  /// **'Requires admin role'**
  String get uploadRequiresAdmin;

  /// Heading for applying metadata to multiple queued uploads
  ///
  /// In en, this message translates to:
  /// **'Bulk update queue metadata'**
  String get uploadBulkMetadata;

  /// Label for applying an author to multiple queued uploads
  ///
  /// In en, this message translates to:
  /// **'Apply author'**
  String get uploadApplyAuthor;

  /// Label for applying a series to multiple queued uploads
  ///
  /// In en, this message translates to:
  /// **'Apply series'**
  String get uploadApplySeries;

  /// Status shown when metadata lookup returns no matching item
  ///
  /// In en, this message translates to:
  /// **'No metadata result was found for this item'**
  String get uploadNoMetadataResult;

  /// Status shown when metadata lookup fails
  ///
  /// In en, this message translates to:
  /// **'Metadata lookup failed'**
  String get uploadMetadataLookupFailed;

  /// Status shown when an upload has no active API session
  ///
  /// In en, this message translates to:
  /// **'No API session is available'**
  String get uploadNoApiSession;

  /// Status shown when an upload is canceled
  ///
  /// In en, this message translates to:
  /// **'Upload canceled'**
  String get uploadCanceled;

  /// Status shown while checking the selected upload destination
  ///
  /// In en, this message translates to:
  /// **'Checking destination path…'**
  String get uploadCheckingDestination;

  /// Message shown when there are no files queued for upload
  ///
  /// In en, this message translates to:
  /// **'Your queue is empty'**
  String get uploadQueueEmpty;

  /// Dialog title shown when an upload destination has path issues
  ///
  /// In en, this message translates to:
  /// **'Path check issues found'**
  String get uploadPathIssuesTitle;

  /// Confirmation prompt shown before continuing with upload path issues
  ///
  /// In en, this message translates to:
  /// **'Some items have destination conflicts or path check errors. Continue anyway?'**
  String get uploadPathIssuesPrompt;

  /// Label for canceling active uploads
  ///
  /// In en, this message translates to:
  /// **'Cancel uploads'**
  String get uploadCancelUploads;

  /// Label for starting a queued upload
  ///
  /// In en, this message translates to:
  /// **'Start upload'**
  String get uploadStart;

  /// Label for requesting metadata for an upload item
  ///
  /// In en, this message translates to:
  /// **'Fetch metadata'**
  String get uploadFetchMetadata;

  /// Label for the number of different library items played
  ///
  /// In en, this message translates to:
  /// **'Items listened'**
  String get fieldItemsListened;

  /// Label for the lower end of an activity scale
  ///
  /// In en, this message translates to:
  /// **'Less'**
  String get rangeLess;

  /// Label for the higher end of an activity scale
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get rangeMore;

  /// Label describing a total across a recent date range
  ///
  /// In en, this message translates to:
  /// **'Total over the last {count} days'**
  String statsTotalOverDays(int count);

  /// Date range shown below a listening activity chart
  ///
  /// In en, this message translates to:
  /// **'{start} to {end}'**
  String statsDateRange(DateTime start, DateTime end);

  /// Chart tooltip showing a date and its listening time
  ///
  /// In en, this message translates to:
  /// **'{date} · {duration}'**
  String statsDateAndListeningTime(DateTime date, String duration);

  /// Message shown when the selected year has no narrator ranking
  ///
  /// In en, this message translates to:
  /// **'No top narrators are available for this year'**
  String get statsNoTopNarratorsYear;

  /// Status shown while advanced listening analytics are loading
  ///
  /// In en, this message translates to:
  /// **'Loading advanced analytics…'**
  String get statsLoadingAnalytics;

  /// Status showing progress while advanced listening analytics are loading
  ///
  /// In en, this message translates to:
  /// **'Loading advanced analytics · {pages} · {sessions}'**
  String statsLoadingAnalyticsProgress(String pages, String sessions);

  /// Duration expressed as a compact number of days
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String durationCompactDays(int count);

  /// Duration expressed as compact days and remaining hours
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h'**
  String durationCompactDaysHours(int days, int hours);

  /// Duration expressed as a compact number of years
  ///
  /// In en, this message translates to:
  /// **'{count}y'**
  String durationCompactYears(int count);

  /// Label for a selected date range
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get fieldRange;

  /// Summary label and value for the month with the most listening
  ///
  /// In en, this message translates to:
  /// **'{label}: {value}'**
  String statsPeakMonthValue(String label, String value);

  /// Message shown when year-in-review statistics cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load year-in-review stats'**
  String get statsYearLoadError;

  /// Fallback label shown when an author name is missing
  ///
  /// In en, this message translates to:
  /// **'Unknown author'**
  String get unknownAuthor;

  /// Fallback label shown when a genre name is missing
  ///
  /// In en, this message translates to:
  /// **'Unknown genre'**
  String get unknownGenre;

  /// Label for the current run of consecutive active days
  ///
  /// In en, this message translates to:
  /// **'Listening streak'**
  String get fieldCurrentStreak;

  /// Plural label for books with audio playback
  ///
  /// In en, this message translates to:
  /// **'Audiobooks'**
  String get mediaTypeAudiobooks;

  /// Plural label for podcast libraries and podcast listening in statistics
  ///
  /// In en, this message translates to:
  /// **'Podcasts'**
  String get mediaTypePodcasts;

  /// Label for pages in a paginated result
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get fieldPages;

  /// Progress summary showing how much of a paginated collection has loaded
  ///
  /// In en, this message translates to:
  /// **'{loaded} of {total} {unit}'**
  String progressCountLoaded(String loaded, String total, String unit);

  /// Status shown when a value cannot be determined
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// Label for a playback control that configures when playback should stop
  ///
  /// In en, this message translates to:
  /// **'Sleep timer'**
  String get playbackSleepTimer;

  /// Achievement name shown in listening statistics after logging at least 1 hour of total listening time
  ///
  /// In en, this message translates to:
  /// **'First hour'**
  String get statsAchievementFirstHour;

  /// Achievement name shown in listening statistics after logging at least 10 hours of total listening time
  ///
  /// In en, this message translates to:
  /// **'All day listener'**
  String get statsAchievementAllDayListener;

  /// Achievement name shown in listening statistics after logging at least 100 hours of total listening time
  ///
  /// In en, this message translates to:
  /// **'Century club'**
  String get statsAchievementCenturyClub;

  /// Achievement name shown in listening statistics after logging at least 500 hours of total listening time
  ///
  /// In en, this message translates to:
  /// **'Time traveler'**
  String get statsAchievementTimeTraveler;

  /// Achievement name shown in listening statistics after logging at least 1,000 hours of total listening time
  ///
  /// In en, this message translates to:
  /// **'Listening legend'**
  String get statsAchievementListeningLegend;

  /// Achievement name shown in listening statistics after logging at least 2,000 hours of total listening time
  ///
  /// In en, this message translates to:
  /// **'Master of time'**
  String get statsAchievementMasterOfTime;

  /// Achievement name shown in listening statistics when listening activity has been recorded for 1 or more library items
  ///
  /// In en, this message translates to:
  /// **'First discovery'**
  String get statsAchievementFirstDiscovery;

  /// Achievement name shown in listening statistics when listening activity has been recorded for 10 or more library items
  ///
  /// In en, this message translates to:
  /// **'Curious listener'**
  String get statsAchievementCuriousListener;

  /// Achievement name shown in listening statistics when listening activity has been recorded for 50 or more library items
  ///
  /// In en, this message translates to:
  /// **'Shelf explorer'**
  String get statsAchievementShelfExplorer;

  /// Achievement name shown in listening statistics when listening activity has been recorded for 100 or more library items
  ///
  /// In en, this message translates to:
  /// **'Library regular'**
  String get statsAchievementLibraryRegular;

  /// Achievement name shown in listening statistics when listening activity has been recorded for 250 or more library items
  ///
  /// In en, this message translates to:
  /// **'Catalog conqueror'**
  String get statsAchievementCatalogConqueror;

  /// Achievement name shown in listening statistics when listening activity has been recorded for 500 or more library items
  ///
  /// In en, this message translates to:
  /// **'World of stories'**
  String get statsAchievementWorldOfStories;

  /// Achievement name shown in listening statistics after recording listening activity on 1 or more different days
  ///
  /// In en, this message translates to:
  /// **'Day one'**
  String get statsAchievementDayOne;

  /// Achievement name shown in listening statistics after recording listening activity on 7 or more different days
  ///
  /// In en, this message translates to:
  /// **'A week of stories'**
  String get statsAchievementWeekOfStories;

  /// Achievement name shown in listening statistics after recording listening activity on 30 or more different days
  ///
  /// In en, this message translates to:
  /// **'Monthly habit'**
  String get statsAchievementMonthlyHabit;

  /// Achievement name shown in listening statistics after recording listening activity on 100 or more different days
  ///
  /// In en, this message translates to:
  /// **'Dedicated listener'**
  String get statsAchievementDedicatedListener;

  /// Achievement name shown in listening statistics after recording listening activity on 365 or more different days
  ///
  /// In en, this message translates to:
  /// **'Year-round listener'**
  String get statsAchievementYearRoundListener;

  /// Achievement name shown in listening statistics after recording listening activity on 1,000 or more different days
  ///
  /// In en, this message translates to:
  /// **'Everyday explorer'**
  String get statsAchievementEverydayExplorer;

  /// Achievement name shown in listening statistics after a longest streak of 2 or more consecutive days with listening activity
  ///
  /// In en, this message translates to:
  /// **'Back for more'**
  String get statsAchievementBackForMore;

  /// Achievement name shown in listening statistics after a longest streak of 3 or more consecutive days with listening activity
  ///
  /// In en, this message translates to:
  /// **'On a roll'**
  String get statsAchievementOnARoll;

  /// Achievement name shown in listening statistics after a longest streak of 7 or more consecutive days with listening activity
  ///
  /// In en, this message translates to:
  /// **'Perfect week'**
  String get statsAchievementPerfectWeek;

  /// Achievement name shown in listening statistics after a longest streak of 14 or more consecutive days with listening activity
  ///
  /// In en, this message translates to:
  /// **'Fortnight focus'**
  String get statsAchievementFortnightFocus;

  /// Achievement name shown in listening statistics after a longest streak of 30 or more consecutive days with listening activity
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get statsAchievementUnstoppable;

  /// Achievement name shown in listening statistics after a longest streak of 100 or more consecutive days with listening activity
  ///
  /// In en, this message translates to:
  /// **'Story marathon'**
  String get statsAchievementStoryMarathon;

  /// Achievement name shown in listening statistics when 1 or more listening sessions have been recorded
  ///
  /// In en, this message translates to:
  /// **'Press play'**
  String get statsAchievementPressPlay;

  /// Achievement name shown in listening statistics when 10 or more listening sessions have been recorded
  ///
  /// In en, this message translates to:
  /// **'Getting comfortable'**
  String get statsAchievementGettingComfortable;

  /// Achievement name shown in listening statistics when 50 or more listening sessions have been recorded
  ///
  /// In en, this message translates to:
  /// **'Regular listener'**
  String get statsAchievementRegularListener;

  /// Achievement name shown in listening statistics when 250 or more listening sessions have been recorded
  ///
  /// In en, this message translates to:
  /// **'Session specialist'**
  String get statsAchievementSessionSpecialist;

  /// Achievement name shown in listening statistics when 1,000 or more listening sessions have been recorded
  ///
  /// In en, this message translates to:
  /// **'Always listening'**
  String get statsAchievementAlwaysListening;

  /// Achievement name shown in listening statistics when 5,000 or more listening sessions have been recorded
  ///
  /// In en, this message translates to:
  /// **'Playback master'**
  String get statsAchievementPlaybackMaster;

  /// Achievement name shown in listening statistics after listening to works by 1 or more different authors
  ///
  /// In en, this message translates to:
  /// **'New voice'**
  String get statsAchievementNewVoice;

  /// Achievement name shown in listening statistics after listening to works by 5 or more different authors
  ///
  /// In en, this message translates to:
  /// **'Author sampler'**
  String get statsAchievementAuthorSampler;

  /// Achievement name shown in listening statistics after listening to works by 20 or more different authors
  ///
  /// In en, this message translates to:
  /// **'Literary wanderer'**
  String get statsAchievementLiteraryWanderer;

  /// Achievement name shown in listening statistics after listening to works by 50 or more different authors
  ///
  /// In en, this message translates to:
  /// **'Voice collector'**
  String get statsAchievementVoiceCollector;

  /// Achievement name shown in listening statistics after listening to works by 100 or more different authors
  ///
  /// In en, this message translates to:
  /// **'Author authority'**
  String get statsAchievementAuthorAuthority;

  /// Achievement name shown in listening statistics after listening to works by 250 or more different authors
  ///
  /// In en, this message translates to:
  /// **'Pantheon of voices'**
  String get statsAchievementPantheonOfVoices;

  /// Achievement name shown in listening statistics after recording a single session lasting at least 15 minutes
  ///
  /// In en, this message translates to:
  /// **'Settling in'**
  String get statsAchievementSettlingIn;

  /// Achievement name shown in listening statistics after recording a single session lasting at least 30 minutes
  ///
  /// In en, this message translates to:
  /// **'Half-hour hero'**
  String get statsAchievementHalfHourHero;

  /// Achievement name shown in listening statistics after recording a single session lasting at least 1 hour
  ///
  /// In en, this message translates to:
  /// **'Deep listener'**
  String get statsAchievementDeepListener;

  /// Achievement name shown in listening statistics after recording a single session lasting at least 2 hours
  ///
  /// In en, this message translates to:
  /// **'Lost in a story'**
  String get statsAchievementLostInAStory;

  /// Achievement name shown in listening statistics after recording a single session lasting at least 4 hours
  ///
  /// In en, this message translates to:
  /// **'Epic session'**
  String get statsAchievementEpicSession;

  /// Achievement name shown in listening statistics after recording a single session lasting at least 8 hours
  ///
  /// In en, this message translates to:
  /// **'Endurance legend'**
  String get statsAchievementEnduranceLegend;

  /// Achievement name shown in listening statistics when the average listening session reaches at least 5 minutes
  ///
  /// In en, this message translates to:
  /// **'Quick chapter'**
  String get statsAchievementQuickChapter;

  /// Achievement name shown in listening statistics when the average listening session reaches at least 15 minutes
  ///
  /// In en, this message translates to:
  /// **'Focused listener'**
  String get statsAchievementFocusedListener;

  /// Achievement name shown in listening statistics when the average listening session reaches at least 30 minutes
  ///
  /// In en, this message translates to:
  /// **'In the zone'**
  String get statsAchievementInTheZone;

  /// Achievement name shown in listening statistics when the average listening session reaches at least 1 hour
  ///
  /// In en, this message translates to:
  /// **'Longform lover'**
  String get statsAchievementLongformLover;

  /// Achievement name shown in listening statistics when the average listening session reaches at least 2 hours
  ///
  /// In en, this message translates to:
  /// **'Immersive listener'**
  String get statsAchievementImmersiveListener;

  /// Achievement name shown in listening statistics after recording at least 1 hour of book listening time
  ///
  /// In en, this message translates to:
  /// **'Book beginner'**
  String get statsAchievementBookBeginner;

  /// Achievement name shown in listening statistics after recording at least 10 hours of book listening time
  ///
  /// In en, this message translates to:
  /// **'Chapter chaser'**
  String get statsAchievementChapterChaser;

  /// Achievement name shown in listening statistics after recording at least 50 hours of book listening time
  ///
  /// In en, this message translates to:
  /// **'Bookworm'**
  String get statsAchievementBookworm;

  /// Achievement name shown in listening statistics after recording at least 100 hours of book listening time
  ///
  /// In en, this message translates to:
  /// **'Audio bibliophile'**
  String get statsAchievementAudioBibliophile;

  /// Achievement name shown in listening statistics after recording at least 500 hours of book listening time
  ///
  /// In en, this message translates to:
  /// **'Living library'**
  String get statsAchievementLivingLibrary;

  /// Achievement name shown in listening statistics after recording at least 1,000 hours of book listening time
  ///
  /// In en, this message translates to:
  /// **'Keeper of stories'**
  String get statsAchievementKeeperOfStories;

  /// Achievement name shown in listening statistics after recording at least 1 hour of podcast listening time
  ///
  /// In en, this message translates to:
  /// **'First episode'**
  String get statsAchievementFirstEpisode;

  /// Achievement name shown in listening statistics after recording at least 5 hours of podcast listening time
  ///
  /// In en, this message translates to:
  /// **'Podcast curious'**
  String get statsAchievementPodcastCurious;

  /// Achievement name shown in listening statistics after recording at least 20 hours of podcast listening time
  ///
  /// In en, this message translates to:
  /// **'Episode explorer'**
  String get statsAchievementEpisodeExplorer;

  /// Achievement name shown in listening statistics after recording at least 50 hours of podcast listening time
  ///
  /// In en, this message translates to:
  /// **'Feed follower'**
  String get statsAchievementFeedFollower;

  /// Achievement name shown in listening statistics after recording at least 100 hours of podcast listening time
  ///
  /// In en, this message translates to:
  /// **'Podcast pro'**
  String get statsAchievementPodcastPro;

  /// Achievement name shown in listening statistics after recording at least 500 hours of podcast listening time
  ///
  /// In en, this message translates to:
  /// **'Airwave archivist'**
  String get statsAchievementAirwaveArchivist;

  /// Achievement name shown in listening statistics when the first-to-latest session date range spans 1 or more calendar days, counting both dates
  ///
  /// In en, this message translates to:
  /// **'Journey begins'**
  String get statsAchievementJourneyBegins;

  /// Achievement name shown in listening statistics when the first-to-latest session date range spans 7 or more calendar days, counting both dates
  ///
  /// In en, this message translates to:
  /// **'One week in'**
  String get statsAchievementOneWeekIn;

  /// Achievement name shown in listening statistics when the first-to-latest session date range spans 30 or more calendar days, counting both dates
  ///
  /// In en, this message translates to:
  /// **'A month of stories'**
  String get statsAchievementMonthOfStories;

  /// Achievement name shown in listening statistics when the first-to-latest session date range spans 180 or more calendar days, counting both dates
  ///
  /// In en, this message translates to:
  /// **'Seasoned listener'**
  String get statsAchievementSeasonedListener;

  /// Achievement name shown in listening statistics when the first-to-latest session date range spans 365 or more calendar days, counting both dates
  ///
  /// In en, this message translates to:
  /// **'Anniversary'**
  String get statsAchievementAnniversary;

  /// Achievement name shown in listening statistics when the first-to-latest session date range spans 1,000 or more calendar days, counting both dates
  ///
  /// In en, this message translates to:
  /// **'Longtime companion'**
  String get statsAchievementLongtimeCompanion;

  /// Label for the number of different library items the user has explored
  ///
  /// In en, this message translates to:
  /// **'Items explored'**
  String get fieldItemsExplored;

  /// Label for the number of authors the user has listened to
  ///
  /// In en, this message translates to:
  /// **'Authors discovered'**
  String get fieldAuthorsDiscovered;

  /// Label for the time since the first recorded listening session
  ///
  /// In en, this message translates to:
  /// **'Listening journey'**
  String get fieldListeningJourney;

  /// Status shown when the user has not reached an achievement level
  ///
  /// In en, this message translates to:
  /// **'Not unlocked yet'**
  String get statsAchievementNotUnlocked;

  /// Status shown after the user reaches the highest achievement level
  ///
  /// In en, this message translates to:
  /// **'Highest milestone reached'**
  String get statsAchievementHighestReached;

  /// Label showing the next achievement and the value needed to reach it
  ///
  /// In en, this message translates to:
  /// **'Next: {label} · {value}'**
  String statsAchievementNext(String label, String value);

  /// Status shown while listening session history is loading
  ///
  /// In en, this message translates to:
  /// **'Loading session history…'**
  String get statsLoadingSessionHistory;

  /// Status showing progress while detailed achievement data is loading
  ///
  /// In en, this message translates to:
  /// **'Unlocking detailed achievements · {sessions}'**
  String statsUnlockingAchievements(String sessions);

  /// Label for retrying the detailed achievement calculation
  ///
  /// In en, this message translates to:
  /// **'Retry detailed achievements'**
  String get statsRetryAchievements;

  /// Label for accepting a suggested value
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get actionAccept;

  /// Label for rejecting a suggested value
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get actionReject;

  /// Label for a series metadata field
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get fieldSeries;

  /// Label for choosing a destination folder in a library
  ///
  /// In en, this message translates to:
  /// **'Library folder'**
  String get fieldLibraryFolder;

  /// Label for choosing a provider for metadata lookup
  ///
  /// In en, this message translates to:
  /// **'Metadata provider'**
  String get fieldMetadataProvider;

  /// Status shown when an item is ready for the next step
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get statusReady;

  /// Status shown while a value or path is being checked
  ///
  /// In en, this message translates to:
  /// **'Checking'**
  String get statusChecking;

  /// Label for an item warning or the warning severity in local log settings
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get statusWarning;

  /// Status shown while files are being uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get statusUploading;

  /// Status shown after a file has been uploaded
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get statusUploaded;

  /// Status shown while a setting, preference, or metadata edit is being saved
  ///
  /// In en, this message translates to:
  /// **'Saving'**
  String get statusSaving;

  /// Status shown while selected changes are being applied
  ///
  /// In en, this message translates to:
  /// **'Applying…'**
  String get statusApplying;

  /// Status shown when an operation fails
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// Status shown when an operation is canceled
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get statusCanceled;

  /// Tooltip for removing a named item from a list
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String removeNamedItem(String name);

  /// Heading for metadata suggested for an upload item
  ///
  /// In en, this message translates to:
  /// **'Suggested metadata'**
  String get uploadSuggestedMetadata;

  /// Instruction for adding files or folders to the upload queue
  ///
  /// In en, this message translates to:
  /// **'Drop files or folders here, or choose them below'**
  String get uploadDropFilesOrFolder;

  /// Instruction for adding files to the upload queue
  ///
  /// In en, this message translates to:
  /// **'Drop files here, or choose them below'**
  String get uploadDropFiles;

  /// Instruction for selecting files or a folder for upload
  ///
  /// In en, this message translates to:
  /// **'Choose files or a folder below'**
  String get uploadChooseFilesOrFolder;

  /// Instruction for selecting files for upload
  ///
  /// In en, this message translates to:
  /// **'Choose files below'**
  String get uploadChooseFilesBelow;

  /// Message shown when the selected input contains no supported upload files
  ///
  /// In en, this message translates to:
  /// **'No supported files were found in the selected input'**
  String get uploadUnsupportedFiles;

  /// Message shown when an upload needs a destination folder
  ///
  /// In en, this message translates to:
  /// **'Select a library folder before starting upload'**
  String get uploadSelectLibraryFolder;

  /// Message shown when the account has no active upload session
  ///
  /// In en, this message translates to:
  /// **'No active authenticated API session'**
  String get uploadNoActiveSession;

  /// Message shown when the upload queue has no eligible files
  ///
  /// In en, this message translates to:
  /// **'Nothing is queued for upload'**
  String get uploadNothingQueued;

  /// Status shown when an upload attempt is being retried
  ///
  /// In en, this message translates to:
  /// **'Retrying upload ({attempt}/{maximum})…'**
  String uploadRetryStarted(int attempt, int maximum);

  /// Status shown while an upload is in progress
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploading;

  /// Status shown after file transfer while the server processes the upload
  ///
  /// In en, this message translates to:
  /// **'Upload complete. Waiting for server processing…'**
  String get uploadWaitingForServer;

  /// Status shown when a file upload fails
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get uploadFailed;

  /// Status shown when an upload is retried after a network interruption
  ///
  /// In en, this message translates to:
  /// **'Network interruption detected. Retrying ({attempt}/{maximum})…'**
  String uploadRetryNetwork(int attempt, int maximum);

  /// Status shown when an upload is retried after a recoverable issue
  ///
  /// In en, this message translates to:
  /// **'Upload issue detected. Retrying ({attempt}/{maximum})…'**
  String uploadRetryIssue(int attempt, int maximum);

  /// Message shown when the user cancels after reviewing upload path conflicts
  ///
  /// In en, this message translates to:
  /// **'Upload canceled after path conflict review'**
  String get uploadCanceledAfterConflictReview;

  /// Message shown when uploaded files could not be added to the library until the book is rescanned
  ///
  /// In en, this message translates to:
  /// **'Files uploaded, but the book scan failed. Please rescan this book'**
  String get uploadFilesUploadedScanFailed;

  /// Heading for uploading files to a selected library
  ///
  /// In en, this message translates to:
  /// **'Upload to {library}'**
  String uploadTargetLibrary(String library);

  /// Heading for adding files to an existing library item
  ///
  /// In en, this message translates to:
  /// **'Add files to {item}'**
  String uploadAddFilesToItem(String item);

  /// Item identity shown when checking upload path conflicts
  ///
  /// In en, this message translates to:
  /// **'{title} · {author} · {series}'**
  String uploadItemIdentity(String title, String author, String series);

  /// Path conflict message for a file already present on the target book
  ///
  /// In en, this message translates to:
  /// **'{file} (a file with this name already exists in this book)'**
  String uploadExistingFileConflict(String file);

  /// Path conflict message when the destination path already exists
  ///
  /// In en, this message translates to:
  /// **'{item} (destination path exists)'**
  String uploadExistingDestination(String item);

  /// Path conflict message when an existing destination has a known title
  ///
  /// In en, this message translates to:
  /// **'{item} (destination exists as “{title}”)'**
  String uploadExistingDestinationAs(String item, String title);

  /// Path conflict message when the destination path could not be checked
  ///
  /// In en, this message translates to:
  /// **'{item} (path check failed)'**
  String uploadPathCheckFailed(String item);

  /// Summary of successful and unsuccessful upload items
  ///
  /// In en, this message translates to:
  /// **'Upload finished · {succeeded} succeeded · {failed} failed or canceled'**
  String uploadFinishedSummary(int succeeded, int failed);

  /// Hint text for searching the settings list
  ///
  /// In en, this message translates to:
  /// **'Search settings'**
  String get settingsSearchHint;

  /// Label for detaching an item from a list, collection, or layout without deleting it
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// Label for adding every visible item to the playback queue
  ///
  /// In en, this message translates to:
  /// **'Queue all items'**
  String get actionQueueAll;

  /// Label for removing an item from the playback queue
  ///
  /// In en, this message translates to:
  /// **'Remove from queue'**
  String get actionRemoveFromQueue;

  /// Accessibility label shown when a settings control cannot load its current value
  ///
  /// In en, this message translates to:
  /// **'Unable to load {label}'**
  String settingsControlLoadFailed(String label);

  /// Displays a localized playback speed with its multiplier symbol
  ///
  /// In en, this message translates to:
  /// **'{speed}×'**
  String playbackSpeedMultiplier(double speed);

  /// Label for an account username field
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get fieldUsername;

  /// Label for a password field
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// Label for an API key field
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get fieldApiKey;

  /// Label for the address of the Audiobookshelf server
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get fieldServerAddress;

  /// Label for the value of a setting or custom header
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get fieldValue;

  /// Label for the name of a custom request header
  ///
  /// In en, this message translates to:
  /// **'Header name'**
  String get fieldHeaderName;

  /// Label for importing settings, credentials, or other data
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get actionImport;

  /// Label for exporting settings, logs, or other data
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// Label or tooltip for copying text, a link, or another value to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get actionCopy;

  /// Label for changing a saved value
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get actionChange;

  /// Label for signing in to an account
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get actionSignIn;

  /// Label for opening a QR code scanner
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get actionScanQrCode;

  /// Label for closing the QR code scanner
  ///
  /// In en, this message translates to:
  /// **'Close scanner'**
  String get actionCloseScanner;

  /// Heading for less frequently used controls in settings and feature forms
  ///
  /// In en, this message translates to:
  /// **'Advanced options'**
  String get headingAdvancedOptions;

  /// Status shown after text has been copied
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get statusCopied;

  /// Status shown while checking the server address
  ///
  /// In en, this message translates to:
  /// **'Checking server…'**
  String get statusCheckingServer;

  /// Status shown while the account is being authenticated
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get statusSigningIn;

  /// Status shown when the app is connected to a service or device
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get statusConnected;

  /// Dialog title shown when a guest account cannot update its password
  ///
  /// In en, this message translates to:
  /// **'Guest password cannot be changed'**
  String get authGuestPasswordCannotChange;

  /// Status shown after a Wear OS watch connects
  ///
  /// In en, this message translates to:
  /// **'Watch connected successfully'**
  String get authWatchConnected;

  /// Message shown while an OpenID Connect sign in is handed to the browser
  ///
  /// In en, this message translates to:
  /// **'Continue in your browser to complete the OpenID Connect sign in'**
  String get authOpenIdRedirect;

  /// Heading shown when signing in to pair a watch
  ///
  /// In en, this message translates to:
  /// **'Sign in to connect your Wear OS watch'**
  String get authSignInWear;

  /// Heading shown when signing in to a server
  ///
  /// In en, this message translates to:
  /// **'Sign in to your Audiobookshelf server'**
  String get authSignInServer;

  /// Example address shown in the server address field
  ///
  /// In en, this message translates to:
  /// **'https://your-audiobookshelf.example'**
  String get authServerAddressHint;

  /// Warning shown when custom headers are sent over an unencrypted connection
  ///
  /// In en, this message translates to:
  /// **'Your custom headers will be sent without encryption over HTTP, so other people on the network can read them. Use HTTPS if your server supports it'**
  String get authHttpHeadersWarning;

  /// Notice about web support with a link to the project discussion
  ///
  /// In en, this message translates to:
  /// **'Web support is limited. Share issues in the yaabsa discussion at {url}'**
  String authWebSupportNote(String url);

  /// Message shown when the server offers no supported authentication method
  ///
  /// In en, this message translates to:
  /// **'No supported authentication method is enabled on this server'**
  String get authNoSupportedMethod;

  /// Label for signing in with an API key
  ///
  /// In en, this message translates to:
  /// **'Connect with API key'**
  String get authConnectWithApiKey;

  /// Description of API key sign in
  ///
  /// In en, this message translates to:
  /// **'Use an API key instead of a username and password'**
  String get authApiKeyHelp;

  /// Dialog title for importing an account authentication code
  ///
  /// In en, this message translates to:
  /// **'Import authentication code'**
  String get authImportCodeTitle;

  /// Hint for entering an authentication code
  ///
  /// In en, this message translates to:
  /// **'Paste the authentication code here'**
  String get authCodeHint;

  /// Message shown when the QR scanner cannot access the camera
  ///
  /// In en, this message translates to:
  /// **'Camera access is unavailable. Allow camera access in device settings or paste the code instead'**
  String get authCameraUnavailable;

  /// Heading shown while scanning an authentication code
  ///
  /// In en, this message translates to:
  /// **'Scan authentication code'**
  String get authScanCodeTitle;

  /// Instruction shown in the QR code scanner
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code'**
  String get authScanCodeInstruction;

  /// Dialog title for replacing a one-time password
  ///
  /// In en, this message translates to:
  /// **'Change your initial password'**
  String get authChangeInitialPasswordTitle;

  /// Warning shown before changing a one-time password
  ///
  /// In en, this message translates to:
  /// **'For your security, the initial password from this authentication code can only be used once'**
  String get authInitialPasswordWarning;

  /// Label for confirming a new password
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get authConfirmPassword;

  /// Validation message shown when the new password is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a new password'**
  String get authInitialPasswordRequired;

  /// Validation message shown when password fields differ
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// Validation message shown when the server address is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid server address'**
  String get validationServerAddressRequired;

  /// Message shown when the server does not allow username and password sign in
  ///
  /// In en, this message translates to:
  /// **'Local sign in is disabled on this server. Use OpenID Connect instead'**
  String get errorLocalLoginDisabled;

  /// Validation message shown when the API key field is empty
  ///
  /// In en, this message translates to:
  /// **'Enter an API key'**
  String get validationApiKeyRequired;

  /// Message shown when API key authentication returns incomplete account data
  ///
  /// In en, this message translates to:
  /// **'API key sign in returned an invalid response'**
  String get errorApiKeyInvalidResponse;

  /// Message shown when an imported code has no initial password
  ///
  /// In en, this message translates to:
  /// **'The initial password is unavailable. Enter the account password manually'**
  String get errorInitialPasswordUnavailable;

  /// Message shown after canceling sign in for a guest account
  ///
  /// In en, this message translates to:
  /// **'Sign in was canceled because the guest password cannot be changed'**
  String get errorGuestPasswordNotRotated;

  /// Message shown when a one-time password must be replaced
  ///
  /// In en, this message translates to:
  /// **'Change the password after using an authentication code'**
  String get errorPasswordChangeRequired;

  /// Confirmation message shown before signing in with a guest password that cannot be changed
  ///
  /// In en, this message translates to:
  /// **'Audiobookshelf does not allow guest users to change passwords. The initial password will remain valid after this sign in. Continue only if you accept this risk'**
  String get authGuestPasswordWarning;

  /// Message shown when watch pairing cannot obtain an account token
  ///
  /// In en, this message translates to:
  /// **'The server did not return a sign in token for the watch'**
  String get errorWatchTokenMissing;

  /// Message shown when account details cannot be sent during watch pairing
  ///
  /// In en, this message translates to:
  /// **'Could not send sign in details to the watch. Make sure it is waiting and try again'**
  String get errorWatchCredentialSendFailed;

  /// Message shown when the server does not allow OpenID Connect sign in
  ///
  /// In en, this message translates to:
  /// **'OpenID Connect is not enabled on this server'**
  String get errorOpenIdDisabled;

  /// Message shown when OpenID Connect sign in cannot start
  ///
  /// In en, this message translates to:
  /// **'Could not start OpenID Connect sign in: {error}'**
  String errorOpenIdStartFailed(String error);

  /// Validation message shown when a custom request header name is duplicated
  ///
  /// In en, this message translates to:
  /// **'A header with this name already exists'**
  String get authHeaderNameDuplicate;

  /// Label for continuing after a confirmation prompt
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// Label for changing an existing value or item
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// Heading for manually configured request headers in connection settings and sign in options
  ///
  /// In en, this message translates to:
  /// **'Custom headers'**
  String get headingCustomHeaders;

  /// Label for enabling API key authentication
  ///
  /// In en, this message translates to:
  /// **'Use API key'**
  String get authUseApiKey;

  /// Label for an authentication code field and the title of a dialog that generates or shares a code
  ///
  /// In en, this message translates to:
  /// **'Authentication code'**
  String get fieldAuthenticationCode;

  /// Message shown when a screen, including server library statistics, needs a library selection
  ///
  /// In en, this message translates to:
  /// **'No library selected. Select one in the library switcher'**
  String get errorNoLibrarySelected;

  /// Message shown when a book-only library section is opened for another media type
  ///
  /// In en, this message translates to:
  /// **'This section is available only for book libraries'**
  String get errorBookLibrariesOnly;

  /// Message shown when a named section or content list cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load {content}'**
  String errorLoadingNamedContent(String content);

  /// Empty state shown when a search returns no results
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get searchNoResults;

  /// Empty state shown when a search returns no matching results in search pages or settings search
  ///
  /// In en, this message translates to:
  /// **'No results found for “{query}”'**
  String searchNoResultsFor(String query);

  /// Heading above results matching a search query
  ///
  /// In en, this message translates to:
  /// **'Search results for “{query}”'**
  String searchResultsFor(String query);

  /// Heading above a list of matching search results
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// Search result label combining an entity name and its item count
  ///
  /// In en, this message translates to:
  /// **'{name} · {count}'**
  String searchResultCount(String name, String count);

  /// Label for user-defined media tags
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get fieldTags;

  /// Label for media genres
  ///
  /// In en, this message translates to:
  /// **'Genres'**
  String get fieldGenres;

  /// Label for one saved collection
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get fieldCollection;

  /// Label for one saved playlist
  ///
  /// In en, this message translates to:
  /// **'Playlist'**
  String get fieldPlaylist;

  /// Label for changing which books belong to a collection or playlist
  ///
  /// In en, this message translates to:
  /// **'Edit books'**
  String get actionEditBooks;

  /// Label for changing the name or description of an item
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get actionEditDetails;

  /// Label for creating a new playlist
  ///
  /// In en, this message translates to:
  /// **'Create playlist'**
  String get actionCreatePlaylist;

  /// Label for creating a new collection
  ///
  /// In en, this message translates to:
  /// **'Create collection'**
  String get actionCreateCollection;

  /// Dialog title for editing a named collection or playlist
  ///
  /// In en, this message translates to:
  /// **'Edit {entityType}'**
  String editNamedEntity(String entityType);

  /// Confirmation message for permanently deleting a named entity
  ///
  /// In en, this message translates to:
  /// **'“{name}” will be permanently removed'**
  String deleteNamedEntityMessage(String name);

  /// Message shown when user-specific screens or operations require a signed-in account
  ///
  /// In en, this message translates to:
  /// **'No active user'**
  String get errorNoActiveUser;

  /// Heading shown when no downloaded media is available
  ///
  /// In en, this message translates to:
  /// **'Your offline library starts here'**
  String get offlineLibraryEmptyTitle;

  /// Message explaining how to add content to the offline library
  ///
  /// In en, this message translates to:
  /// **'Download a book or episode to listen offline'**
  String get offlineLibraryEmptyMessage;

  /// Empty state shown when the selected download filter has no items
  ///
  /// In en, this message translates to:
  /// **'No downloads in this view'**
  String get statusNoDownloadsInView;

  /// Message shown when a podcast has no playable episodes
  ///
  /// In en, this message translates to:
  /// **'This podcast has no playable episodes'**
  String get statusPodcastNoPlayableEpisodes;

  /// Message shown when a podcast cannot be added because it already exists
  ///
  /// In en, this message translates to:
  /// **'This podcast is already in your library'**
  String get errorPodcastAlreadyInLibrary;

  /// Message shown when a podcast search result has no feed address
  ///
  /// In en, this message translates to:
  /// **'This result has no RSS feed URL. Paste the feed URL directly'**
  String get errorPodcastFeedUrlMissing;

  /// Message shown when a podcast feed cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not read this RSS feed. Check the URL and try again'**
  String get errorPodcastFeedUnreadable;

  /// Status shown while a podcast is being added
  ///
  /// In en, this message translates to:
  /// **'Creating podcast…'**
  String get statusCreatingPodcast;

  /// Status shown after a podcast is added to a library
  ///
  /// In en, this message translates to:
  /// **'Added podcast to {library}'**
  String statusPodcastAdded(String library);

  /// Error shown when the server cannot add a podcast to the library
  ///
  /// In en, this message translates to:
  /// **'Could not create podcast'**
  String get errorPodcastCreateFailed;

  /// Message shown when podcast browsing is opened for a different library type
  ///
  /// In en, this message translates to:
  /// **'Switch to a podcast library to use this section'**
  String get errorPodcastLibraryRequired;

  /// Message shown when an administrator account is needed
  ///
  /// In en, this message translates to:
  /// **'This action requires an admin account'**
  String get errorAdminRequired;

  /// Heading for adding podcasts to a library
  ///
  /// In en, this message translates to:
  /// **'Add podcasts'**
  String get podcastAddTitle;

  /// Hint for searching podcasts or entering a feed address
  ///
  /// In en, this message translates to:
  /// **'Search podcasts or paste an RSS URL'**
  String get podcastSearchHint;

  /// Message shown before a podcast search returns results
  ///
  /// In en, this message translates to:
  /// **'No search results yet'**
  String get statusNoSearchResultsYet;

  /// Heading for the current listening summary
  ///
  /// In en, this message translates to:
  /// **'Your listening'**
  String get headingYourListening;

  /// Heading for recent listening pace
  ///
  /// In en, this message translates to:
  /// **'Recent pace'**
  String get headingRecentPace;

  /// Heading for listening activity and fallback title for an unknown playback history event
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get headingActivity;

  /// Heading for listening activity by weekday
  ///
  /// In en, this message translates to:
  /// **'Weekday rhythm'**
  String get headingWeekdayRhythm;

  /// Heading for a short list of recent listening sessions
  ///
  /// In en, this message translates to:
  /// **'Recent sessions'**
  String get headingRecentSessions;

  /// Label for opening the full list of entries
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get actionViewAll;

  /// Heading for listening milestones
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get headingAchievements;

  /// Dialog title asking whether to calculate advanced listening analytics
  ///
  /// In en, this message translates to:
  /// **'Load advanced analytics?'**
  String get statsLoadAdvancedPrompt;

  /// Label for loading content or data
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get actionLoad;

  /// Label for starting advanced listening analytics
  ///
  /// In en, this message translates to:
  /// **'Load advanced analytics'**
  String get statsLoadAdvancedAnalytics;

  /// Empty state shown when a book library has no series
  ///
  /// In en, this message translates to:
  /// **'No series found in this library'**
  String get statusNoSeriesInLibrary;

  /// Empty state shown when a book library has no authors
  ///
  /// In en, this message translates to:
  /// **'No authors found in this library'**
  String get statusNoAuthorsInLibrary;

  /// Empty state shown when a book library has no narrators
  ///
  /// In en, this message translates to:
  /// **'No narrators found in this library'**
  String get statusNoNarratorsInLibrary;

  /// Empty state shown when a series contains no books
  ///
  /// In en, this message translates to:
  /// **'No books found in this series'**
  String get statusNoBooksInSeries;

  /// Empty state shown when there are no recent unfinished podcast episodes
  ///
  /// In en, this message translates to:
  /// **'No incomplete recent episodes found'**
  String get statusNoRecentEpisodes;

  /// Message shown when playlist details cannot be retrieved
  ///
  /// In en, this message translates to:
  /// **'Playlist details could not be loaded'**
  String get errorPlaylistUnavailable;

  /// Message shown when a playlist no longer exists
  ///
  /// In en, this message translates to:
  /// **'Playlist is no longer available'**
  String get errorPlaylistMissing;

  /// Message shown when collection details cannot be retrieved
  ///
  /// In en, this message translates to:
  /// **'Collection details could not be loaded'**
  String get errorCollectionUnavailable;

  /// Message shown when a collection no longer exists
  ///
  /// In en, this message translates to:
  /// **'Collection is no longer available'**
  String get errorCollectionMissing;

  /// Tooltip for starting a random item from a collection, playlist, or podcast
  ///
  /// In en, this message translates to:
  /// **'Play random'**
  String get actionPlayRandomItem;

  /// Tooltip for sorting a list by the selected value
  ///
  /// In en, this message translates to:
  /// **'Sort by {value}'**
  String actionSortBy(String value);

  /// Empty state shown when there are no personalized home sections
  ///
  /// In en, this message translates to:
  /// **'No personalized sections are available yet'**
  String get statusNoPersonalizedSections;

  /// Message shown when content cannot load without a server connection
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh once your connection returns'**
  String get errorRefreshWhenConnected;

  /// Message shown when refreshing may recover an empty home view
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh and try again'**
  String get errorRefreshAndTryAgain;

  /// Message shown when visible items cannot be added to the playback queue
  ///
  /// In en, this message translates to:
  /// **'Could not add visible items to the playback queue'**
  String get errorQueueVisibleItems;

  /// Label for a button that removes the current query or clears a selected value
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get actionClear;

  /// Label for removing all items from an upload or playback queue
  ///
  /// In en, this message translates to:
  /// **'Clear queue'**
  String get actionClearQueue;

  /// Label for a control that reveals a collapsed navigation or content area
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get actionExpand;

  /// Label for a control that hides an expanded navigation or content area
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get actionCollapse;

  /// Label for an action that starts adding media files to a library
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get actionUpload;

  /// Tooltip for a control that opens the media upload interface
  ///
  /// In en, this message translates to:
  /// **'Open uploader'**
  String get actionOpenUploader;

  /// Hint for a search field that filters the current library
  ///
  /// In en, this message translates to:
  /// **'Search this library'**
  String get searchInLibrary;

  /// Label for confirming changes to books assigned to a collection or playlist
  ///
  /// In en, this message translates to:
  /// **'Save books'**
  String get actionSaveBooks;

  /// Confirmation shown after a named managed list is updated
  ///
  /// In en, this message translates to:
  /// **'{entityType} updated'**
  String statusNamedEntityUpdated(String entityType);

  /// Confirmation shown after the book selection for a managed list is saved
  ///
  /// In en, this message translates to:
  /// **'{entityType} books updated'**
  String statusNamedBooksUpdated(String entityType);

  /// Confirmation shown after a named managed list is deleted
  ///
  /// In en, this message translates to:
  /// **'{entityType} deleted'**
  String statusNamedEntityDeleted(String entityType);

  /// Error shown when saving managed list details fails
  ///
  /// In en, this message translates to:
  /// **'Could not update {entityType}'**
  String errorNamedEntityUpdateFailed(String entityType);

  /// Error shown when saving a managed list book selection fails
  ///
  /// In en, this message translates to:
  /// **'Could not update {entityType} books'**
  String errorNamedBooksUpdateFailed(String entityType);

  /// Error shown when deleting a managed list fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete {entityType}'**
  String errorNamedEntityDeleteFailed(String entityType);

  /// Label for creating a managed list without selecting items first
  ///
  /// In en, this message translates to:
  /// **'Create empty'**
  String get actionCreateEmpty;

  /// Empty state shown when a library has no collections or playlists
  ///
  /// In en, this message translates to:
  /// **'No lists yet'**
  String get statusNoManagedLists;

  /// Guidance shown when a library has no collections or playlists
  ///
  /// In en, this message translates to:
  /// **'Create a list to keep items together for later'**
  String get promptCreateManagedList;

  /// Confirmation title shown before deleting a collection or playlist
  ///
  /// In en, this message translates to:
  /// **'Delete this list?'**
  String get headingDeleteManagedList;

  /// Empty state shown when a collection or playlist has no available items
  ///
  /// In en, this message translates to:
  /// **'No items in this list'**
  String get statusNoItemsInManagedList;

  /// Guidance shown when a collection or playlist has no available items
  ///
  /// In en, this message translates to:
  /// **'Add items to this list to see them here'**
  String get promptAddItemsToManagedList;

  /// Explanation shown when a collection or playlist is no longer available
  ///
  /// In en, this message translates to:
  /// **'It may have been removed from the library'**
  String get statusListMayBeRemoved;

  /// Status shown when one or more playlist entries cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load {count, plural, =1{1 item} other{{count} items}}'**
  String errorLibraryItemsNotLoaded(int count);

  /// Confirmation shown after a named managed list is created
  ///
  /// In en, this message translates to:
  /// **'{entityType} created'**
  String statusNamedEntityCreated(String entityType);

  /// Label for confirming the creation of a new item or list
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get actionCreate;

  /// Error shown when creating a named managed list fails
  ///
  /// In en, this message translates to:
  /// **'Could not create {entityType}'**
  String errorNamedEntityCreateFailed(String entityType);

  /// Label for selecting one or more items
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get actionSelect;

  /// Confirmation prompt shown before downloaded media is removed from local storage
  ///
  /// In en, this message translates to:
  /// **'Delete {count, plural, =1{this download from local storage and remove it from Downloads?} other{{count} downloads from local storage and remove them from Downloads?}}'**
  String downloadDeletePrompt(int count);

  /// Summary shown after downloaded items and files are deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted {items, plural, =1{1 item} other{{items} items}}, removed {files, plural, =1{1 file} other{{files} files}}'**
  String downloadDeleteSummary(int items, int files);

  /// Message shown when one or more downloaded files could not be removed
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file could not be removed} other{{count} files could not be removed}}'**
  String downloadDeleteFilesFailed(int count);

  /// Message shown when one or more downloaded items could not be deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item failed to delete} other{{count} items failed to delete}}'**
  String downloadDeleteItemsFailed(int count);

  /// Filter label showing how many downloads are incomplete
  ///
  /// In en, this message translates to:
  /// **'Partial · {count}'**
  String statusPartialDownloads(int count);

  /// Filter label showing how many downloads are available offline
  ///
  /// In en, this message translates to:
  /// **'Offline · {count}'**
  String statusOfflineDownloads(int count);

  /// Error shown when a podcast search request cannot be completed
  ///
  /// In en, this message translates to:
  /// **'Podcast search failed'**
  String get errorPodcastSearchFailed;

  /// Guidance shown when podcast search cannot run because the library has no folders
  ///
  /// In en, this message translates to:
  /// **'Add a folder to this library in server settings before searching'**
  String get statusPodcastLibraryNoFolders;

  /// Guidance shown before podcast search results are available
  ///
  /// In en, this message translates to:
  /// **'Search by podcast name or paste an RSS feed URL to add one'**
  String get podcastSearchEmptyPrompt;

  /// Message shown when a user without administrator access opens podcast setup
  ///
  /// In en, this message translates to:
  /// **'An admin account is required to add podcasts'**
  String get errorAdminAccountRequired;

  /// Label for a button that starts a search query
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// Banner message shown while the app displays cached data during an unstable server connection
  ///
  /// In en, this message translates to:
  /// **'Server connection is unstable. Showing the latest available data'**
  String get statusConnectionUnstableUsingCachedData;

  /// Label for a button or tooltip that opens library filtering options
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get actionFilter;

  /// Empty state shown when a library contains no items matching the current view
  ///
  /// In en, this message translates to:
  /// **'No items found in this library'**
  String get statusNoItemsInLibrary;

  /// Empty state shown when the library issues filter finds no problems
  ///
  /// In en, this message translates to:
  /// **'No missing or incomplete items found'**
  String get statusNoMissingOrIncompleteItems;

  /// Heading for listening session lists, including the admin library session section
  ///
  /// In en, this message translates to:
  /// **'Listening sessions'**
  String get headingListeningSessions;

  /// Heading for the yearly listening recap section
  ///
  /// In en, this message translates to:
  /// **'Year in rewind'**
  String get headingYearInRewind;

  /// Heading for detailed listening analytics
  ///
  /// In en, this message translates to:
  /// **'Advanced analytics'**
  String get headingAdvancedAnalytics;

  /// Explanation shown before loading detailed listening analytics
  ///
  /// In en, this message translates to:
  /// **'Loads all listening sessions and may take longer for large accounts'**
  String get statsAdvancedLoadDescription;

  /// Label for starting a local download
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get actionDownload;

  /// Label for ending the current account session
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// Name of the app shown in app-specific page headings
  ///
  /// In en, this message translates to:
  /// **'yaabsa'**
  String get appName;

  /// Heading shown when welcoming a user to the app
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get headingWelcome;

  /// Heading or subtitle for the media currently in playback
  ///
  /// In en, this message translates to:
  /// **'Now playing'**
  String get playbackNowPlaying;

  /// Empty state shown in the player when no media is loaded
  ///
  /// In en, this message translates to:
  /// **'Choose something from your libraries or downloads to start playback'**
  String get playerEmptyPrompt;

  /// Label for the playback rewind interval setting
  ///
  /// In en, this message translates to:
  /// **'Rewind interval'**
  String get fieldRewindInterval;

  /// Label for the playback fast forward interval setting
  ///
  /// In en, this message translates to:
  /// **'Fast forward interval'**
  String get fieldFastForwardInterval;

  /// Label for showing cover art as the watch player background
  ///
  /// In en, this message translates to:
  /// **'Cover background'**
  String get wearCoverBackground;

  /// Label for showing media details in the watch ambient display
  ///
  /// In en, this message translates to:
  /// **'Ambient title and author'**
  String get wearAmbientTitleAndAuthor;

  /// Label for showing cover art in the watch media browser
  ///
  /// In en, this message translates to:
  /// **'Cover grid'**
  String get wearCoverGrid;

  /// Label for the watch browser scrolling style
  ///
  /// In en, this message translates to:
  /// **'Flat scrolling'**
  String get wearFlatScrolling;

  /// Label for showing progress in the watch media browser
  ///
  /// In en, this message translates to:
  /// **'Item progress'**
  String get wearItemProgress;

  /// Status label showing that a setting or feature is enabled
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get statusOn;

  /// Label showing that a setting or optional playback feature is disabled
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get statusOff;

  /// Label for canceling an active download and showing its progress
  ///
  /// In en, this message translates to:
  /// **'Cancel download · {percent}'**
  String actionCancelDownloadProgress(String percent);

  /// Empty state shown when a browse section has no items
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get statusNoItems;

  /// Accessibility label describing the current page in a paged watch interface
  ///
  /// In en, this message translates to:
  /// **'{section}, page {page} of {pages}'**
  String accessibilityPageAnnouncement(String section, int page, int pages);

  /// Label for opening the Android Automotive media app
  ///
  /// In en, this message translates to:
  /// **'Open media center'**
  String get aaosOpenMediaCenter;

  /// Error shown when watch pairing cannot find a phone
  ///
  /// In en, this message translates to:
  /// **'No phone connected. Connect your watch to your phone and try again'**
  String get wearPairingNoPhoneConnected;

  /// Error shown when watch pairing receives no response
  ///
  /// In en, this message translates to:
  /// **'No response from phone. Check your phone for a pairing notification'**
  String get wearPairingNoPhoneResponse;

  /// Subtitle shown when connecting the watch app to Audiobookshelf
  ///
  /// In en, this message translates to:
  /// **'Connect to Audiobookshelf'**
  String get wearPairingSubtitle;

  /// Instruction shown when watch setup must continue on the phone
  ///
  /// In en, this message translates to:
  /// **'Sign in on your phone to continue'**
  String get wearPairingSignInOnPhone;

  /// Heading shown when adding a custom request header
  ///
  /// In en, this message translates to:
  /// **'Server header'**
  String get headingServerHeader;

  /// Status shown while the current account session is ending
  ///
  /// In en, this message translates to:
  /// **'Signing out'**
  String get statusSigningOut;

  /// Status shown while a media item is being opened
  ///
  /// In en, this message translates to:
  /// **'Opening…'**
  String get statusOpening;

  /// Confirmation message shown before signing out of the watch app
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to stream on this watch'**
  String get wearSignOutWarning;

  /// Status label shown when an item or task has finished
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get statusFinished;

  /// Message shown when the server rejects the submitted account credentials
  ///
  /// In en, this message translates to:
  /// **'The server rejected these sign in details. Check your username and password'**
  String get errorCredentialsRejected;

  /// Message shown when the server certificate cannot be trusted
  ///
  /// In en, this message translates to:
  /// **'The server certificate could not be verified'**
  String get errorCertificateUnverified;

  /// Message shown when a server address does not host Audiobookshelf
  ///
  /// In en, this message translates to:
  /// **'This address is not an Audiobookshelf server'**
  String get errorServerNotAudiobookshelf;

  /// Fallback title shown while the selected book title is unavailable
  ///
  /// In en, this message translates to:
  /// **'Your book'**
  String get readerBookTitleFallback;

  /// Status shown while local ebook files are prepared for reading
  ///
  /// In en, this message translates to:
  /// **'Loading ebook files…'**
  String get readerLoadingEbookFiles;

  /// Error shown when ebook files cannot be loaded without an account token
  ///
  /// In en, this message translates to:
  /// **'Missing authentication token for ebook loading'**
  String get errorMissingEbookToken;

  /// Empty state shown in the reader contents panel
  ///
  /// In en, this message translates to:
  /// **'This book has no table of contents'**
  String get statusNoTableOfContents;

  /// Tab label for the reader table of contents
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get readerContentsTab;

  /// Tab label for saved reader bookmarks and passages
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get readerSavedTab;

  /// Label for opening the reader contents and saved notes panel
  ///
  /// In en, this message translates to:
  /// **'Contents and notes'**
  String get readerContentsAndNotes;

  /// Heading shown when there are no saved passages in the reader
  ///
  /// In en, this message translates to:
  /// **'Keep the passages you love'**
  String get readerSavedPassagesTitle;

  /// Guidance shown when there are no saved passages in the reader
  ///
  /// In en, this message translates to:
  /// **'Select text to highlight it or add a note'**
  String get readerSavedPassagesPrompt;

  /// Label for a saved reader bookmark
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get readerBookmark;

  /// Label for saving the current reader page as a bookmark
  ///
  /// In en, this message translates to:
  /// **'Bookmark this page'**
  String get actionBookmarkThisPage;

  /// Label for removing a saved bookmark
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get actionRemoveBookmark;

  /// Label for removing a saved highlight or note
  ///
  /// In en, this message translates to:
  /// **'Remove saved passage'**
  String get actionRemoveSavedPassage;

  /// Tooltip for permanently deleting a saved reader annotation
  ///
  /// In en, this message translates to:
  /// **'Delete annotation'**
  String get actionDeleteAnnotation;

  /// Tooltip for editing a saved reader annotation
  ///
  /// In en, this message translates to:
  /// **'Edit annotation'**
  String get actionEditAnnotation;

  /// Label for highlighting selected text in the reader
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get actionHighlightText;

  /// Label for underlining selected text in the reader
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get actionUnderlineText;

  /// Label describing text saved with an underline annotation
  ///
  /// In en, this message translates to:
  /// **'Underlined passage'**
  String get readerUnderlinedPassage;

  /// Label describing text saved with a highlight annotation
  ///
  /// In en, this message translates to:
  /// **'Highlighted passage'**
  String get readerHighlightedPassage;

  /// Empty note label shown when a saved passage has no note
  ///
  /// In en, this message translates to:
  /// **'No note added'**
  String get readerNoNote;

  /// Label showing a reader page number
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String readerPageNumber(int page);

  /// Fallback title shown for a reader chapter without a name
  ///
  /// In en, this message translates to:
  /// **'Untitled chapter'**
  String get untitledChapter;

  /// Tooltip for leaving the current book in the reader
  ///
  /// In en, this message translates to:
  /// **'Close book'**
  String get actionCloseBook;

  /// Label for the action and panel that opens search within the current book
  ///
  /// In en, this message translates to:
  /// **'Search in book'**
  String get actionSearchInBook;

  /// Heading for the reader appearance and layout settings
  ///
  /// In en, this message translates to:
  /// **'Reading preferences'**
  String get headingReadingPreferences;

  /// Tab label for reader typography and color settings
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get readerAppearance;

  /// Heading for page layout options in reader settings and component arrangement options in the player
  ///
  /// In en, this message translates to:
  /// **'Layout'**
  String get headingLayout;

  /// Label for choosing the reader typeface
  ///
  /// In en, this message translates to:
  /// **'Typeface'**
  String get readerFieldTypeface;

  /// Label for adjusting reader text size
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get readerFieldTextSize;

  /// Label for adjusting reader line spacing
  ///
  /// In en, this message translates to:
  /// **'Line spacing'**
  String get readerFieldLineSpacing;

  /// Label for choosing how pages are presented in the reader
  ///
  /// In en, this message translates to:
  /// **'Page layout'**
  String get readerFieldPageLayout;

  /// Label for choosing text alignment in reader and player settings
  ///
  /// In en, this message translates to:
  /// **'Text alignment'**
  String get fieldTextAlignment;

  /// Label for adjusting reader letter spacing
  ///
  /// In en, this message translates to:
  /// **'Letter spacing'**
  String get readerFieldLetterSpacing;

  /// Label for adjusting reader page margins
  ///
  /// In en, this message translates to:
  /// **'Page margins'**
  String get readerFieldPageMargins;

  /// Label for adjusting the width of reader text
  ///
  /// In en, this message translates to:
  /// **'Reading width'**
  String get readerFieldReadingWidth;

  /// Label for adjusting annotation underline thickness
  ///
  /// In en, this message translates to:
  /// **'Underline thickness'**
  String get readerFieldUnderlineThickness;

  /// Label for the current location in the book
  ///
  /// In en, this message translates to:
  /// **'Reading position'**
  String get readerFieldReadingPosition;

  /// Label for hiding the mini player while reading
  ///
  /// In en, this message translates to:
  /// **'Hide mini player when reading'**
  String get readerHideMiniPlayer;

  /// Label for including reading time in listening activity
  ///
  /// In en, this message translates to:
  /// **'Track reading time as listening'**
  String get readerTrackReadingTime;

  /// Label for choosing an annotation or reader color
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get readerFieldColor;

  /// Guidance shown before searching within a book
  ///
  /// In en, this message translates to:
  /// **'Find a passage anywhere in this book'**
  String get readerSearchEmptyPrompt;

  /// Guidance shown when a reader search query is too short
  ///
  /// In en, this message translates to:
  /// **'Type at least two characters or press Search'**
  String get readerSearchMinimumPrompt;

  /// Status showing the current reader search query
  ///
  /// In en, this message translates to:
  /// **'Looking for “{query}”'**
  String readerSearchQueryPrompt(String query);

  /// Empty state shown when reader search finds no matches
  ///
  /// In en, this message translates to:
  /// **'No matches found. Try another word or phrase'**
  String get readerNoSearchMatches;

  /// Error shown when searching the current book fails
  ///
  /// In en, this message translates to:
  /// **'Could not search this book. Try again'**
  String get readerSearchFailed;

  /// Error shown when a reader search result cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open this result. Try again'**
  String get readerSearchOpenFailed;

  /// Status shown while searching the current book
  ///
  /// In en, this message translates to:
  /// **'Searching the book…'**
  String get readerSearchLoading;

  /// Status shown when reader search has more results than the current limit
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{First result. Refine your search} other{First {count} results. Refine your search}}'**
  String readerSearchFirstResults(int count);

  /// Accessibility label announcing the number of reader search results
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result found} other{{count} results found}}'**
  String readerSearchResultCount(int count);

  /// Message shown when read aloud cannot find text in the current book
  ///
  /// In en, this message translates to:
  /// **'No readable text found'**
  String get readerNoReadableText;

  /// Confirmation shown after reader annotations are synced to the server
  ///
  /// In en, this message translates to:
  /// **'Annotations synced'**
  String get readerAnnotationsSynced;

  /// Error shown when reader annotations cannot be synced to the server
  ///
  /// In en, this message translates to:
  /// **'Could not sync annotations'**
  String get errorAnnotationsSyncFailed;

  /// Error shown when reader annotations cannot be loaded from the server
  ///
  /// In en, this message translates to:
  /// **'Could not load annotations from the server'**
  String get errorAnnotationsLoadFailed;

  /// Empty state shown when the server has no saved annotations for the current book
  ///
  /// In en, this message translates to:
  /// **'No annotations found for this item'**
  String get statusNoAnnotations;

  /// Error shown when saved annotation data cannot be read
  ///
  /// In en, this message translates to:
  /// **'Stored annotations are invalid'**
  String get errorStoredAnnotationsInvalid;

  /// Message shown when saved annotation data contains no usable entries
  ///
  /// In en, this message translates to:
  /// **'No valid annotations found for this item'**
  String get statusNoValidAnnotations;

  /// Message shown when there are no saved PDF annotations
  ///
  /// In en, this message translates to:
  /// **'No PDF annotations found for this item'**
  String get statusNoPdfAnnotations;

  /// Confirmation shown after PDF annotations are loaded
  ///
  /// In en, this message translates to:
  /// **'Loaded {count, plural, =1{1 PDF annotation} other{{count} PDF annotations}}'**
  String statusPdfAnnotationsLoaded(int count);

  /// Message shown when there are no saved EPUB annotations
  ///
  /// In en, this message translates to:
  /// **'No EPUB annotations found for this item'**
  String get statusNoEpubAnnotations;

  /// Confirmation shown after EPUB annotations are loaded
  ///
  /// In en, this message translates to:
  /// **'Loaded EPUB annotations'**
  String get statusEpubAnnotationsLoaded;

  /// Option that uses typography, spacing, or layout specified by the book
  ///
  /// In en, this message translates to:
  /// **'Book default'**
  String get optionBookDefault;

  /// Reader typeface option with serifs
  ///
  /// In en, this message translates to:
  /// **'Serif'**
  String get fontSerif;

  /// Reader typeface option without serifs
  ///
  /// In en, this message translates to:
  /// **'Sans serif'**
  String get fontSansSerif;

  /// Reader layout option that shows one page at a time
  ///
  /// In en, this message translates to:
  /// **'Single page'**
  String get pageLayoutSingle;

  /// Reader layout option that shows two pages on wide displays
  ///
  /// In en, this message translates to:
  /// **'Two pages on wide screens'**
  String get pageLayoutTwoWide;

  /// Reader layout option that scrolls through the book
  ///
  /// In en, this message translates to:
  /// **'Scroll'**
  String get pageLayoutScroll;

  /// Text alignment option that follows the reading direction in reader and player settings
  ///
  /// In en, this message translates to:
  /// **'Start aligned'**
  String get textAlignmentStart;

  /// Text alignment option that aligns text to both edges
  ///
  /// In en, this message translates to:
  /// **'Justified'**
  String get textAlignmentJustified;

  /// Small reader spacing adjustment
  ///
  /// In en, this message translates to:
  /// **'Slight'**
  String get spacingSlight;

  /// Narrow reader size or spacing option
  ///
  /// In en, this message translates to:
  /// **'Narrow'**
  String get sizeNarrow;

  /// Small reader size option
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get sizeSmall;

  /// Medium reader size option
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sizeMedium;

  /// Large reader size option
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get sizeLarge;

  /// Wide reader size option
  ///
  /// In en, this message translates to:
  /// **'Wide'**
  String get sizeWide;

  /// Widest reader spacing option
  ///
  /// In en, this message translates to:
  /// **'Extra wide'**
  String get sizeExtraWide;

  /// Compact reader width option
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get sizeCompact;

  /// Comfortable reader width option
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get sizeComfortable;

  /// Full reader width option
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get sizeFull;

  /// Light reader color theme option
  ///
  /// In en, this message translates to:
  /// **'Paper'**
  String get readerThemePaper;

  /// Sepia reader color theme option
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get readerThemeSepia;

  /// Grey reader color theme option
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get readerThemeGrey;

  /// Dark reader color theme option
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get readerThemeNight;

  /// Label for enabling a focused reading view
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get actionFocus;

  /// Accessible label for the sample reader appearance preview
  ///
  /// In en, this message translates to:
  /// **'Reading appearance preview'**
  String get readerAppearancePreviewLabel;

  /// Sample text displayed in the reader appearance preview
  ///
  /// In en, this message translates to:
  /// **'A quiet moment, a new chapter. Make the page comfortable for you'**
  String get readerAppearancePreviewText;

  /// Reader progress label showing a named page and reading progress
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {pages} · {progress}'**
  String readerPageLabelWithProgress(String page, int pages, String progress);

  /// Reader progress label showing a named page and reading progress when the total is unknown
  ///
  /// In en, this message translates to:
  /// **'Page {page} · {progress}'**
  String readerPageLabelProgress(String page, String progress);

  /// Reader progress label showing the current book location and total locations
  ///
  /// In en, this message translates to:
  /// **'Location {position} of {total} · {progress}'**
  String readerLocationProgress(int position, int total, String progress);

  /// Label shown in the reader progress control when no chapter title is available
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get readerReading;

  /// Hint for the optional note field on a reader annotation
  ///
  /// In en, this message translates to:
  /// **'Add an optional note'**
  String get readerAnnotationNoteHint;

  /// Accessible label for an annotation color choice
  ///
  /// In en, this message translates to:
  /// **'Annotation color {color}'**
  String readerAnnotationColorLabel(String color);

  /// Heading for the reader color choices
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get readerColors;

  /// Confirmation shown after saving the current reader page as a bookmark
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get readerBookmarkAdded;

  /// Message shown when a reader annotation action has no selected text
  ///
  /// In en, this message translates to:
  /// **'Select some text first'**
  String get readerSelectTextFirst;

  /// Name of a saved reader annotation that highlights a passage
  ///
  /// In en, this message translates to:
  /// **'Highlight'**
  String get readerAnnotationHighlight;

  /// Name of a saved reader annotation that underlines a passage
  ///
  /// In en, this message translates to:
  /// **'Underline'**
  String get readerAnnotationUnderline;

  /// Compact label for an underline thickness value in pixels
  ///
  /// In en, this message translates to:
  /// **'{pixels} px'**
  String readerUnderlineThicknessPixels(String pixels);

  /// Hint in the reader search field
  ///
  /// In en, this message translates to:
  /// **'Find a word or phrase'**
  String get readerSearchHint;

  /// Accessible label for a reader page color choice
  ///
  /// In en, this message translates to:
  /// **'{color} page color'**
  String readerPageColorOption(String color);

  /// Name of an annotation followed by its underline thickness
  ///
  /// In en, this message translates to:
  /// **'{type} ({thickness})'**
  String readerAnnotationTitleWithThickness(String type, String thickness);

  /// Heading for reader display, layout, and speech preferences
  ///
  /// In en, this message translates to:
  /// **'Reader settings'**
  String get readerSettingsTitle;

  /// Section heading for reader preferences that connect reading with audio playback
  ///
  /// In en, this message translates to:
  /// **'Player integration'**
  String get readerPlayerIntegration;

  /// Short explanation for the reader typeface setting
  ///
  /// In en, this message translates to:
  /// **'Choose a font for the book text'**
  String get readerChooseFontDescription;

  /// Short explanation for the reader text size setting
  ///
  /// In en, this message translates to:
  /// **'Adjust the size of the book text'**
  String get readerAdjustTextSizeDescription;

  /// Short explanation for the reader line spacing setting
  ///
  /// In en, this message translates to:
  /// **'Adjust the space between lines'**
  String get readerAdjustLineSpacingDescription;

  /// Short explanation for the reader text alignment setting
  ///
  /// In en, this message translates to:
  /// **'Choose how book text is aligned'**
  String get readerChooseTextAlignmentDescription;

  /// Short explanation for the reader letter spacing setting
  ///
  /// In en, this message translates to:
  /// **'Adjust the space between letters'**
  String get readerAdjustLetterSpacingDescription;

  /// Short explanation for the reader page layout setting
  ///
  /// In en, this message translates to:
  /// **'Choose how pages move while reading'**
  String get readerChoosePageLayoutDescription;

  /// Short explanation for hiding the audio mini player during reading
  ///
  /// In en, this message translates to:
  /// **'Hides the audio mini player while reading'**
  String get readerHideMiniPlayerDescription;

  /// Short explanation for including reading time in listening statistics
  ///
  /// In en, this message translates to:
  /// **'Includes reading time in listening statistics'**
  String get readerTrackReadingTimeDescription;

  /// Label for choosing the service that reads book text aloud
  ///
  /// In en, this message translates to:
  /// **'Speech provider'**
  String get readerSpeechProvider;

  /// Short explanation for selecting the reader speech service
  ///
  /// In en, this message translates to:
  /// **'Choose which service reads the book aloud'**
  String get readerSpeechProviderDescription;

  /// Label for the speed of text-to-speech playback
  ///
  /// In en, this message translates to:
  /// **'Speech rate'**
  String get readerSpeechRate;

  /// Short explanation for the text-to-speech rate setting
  ///
  /// In en, this message translates to:
  /// **'Adjust the speed of spoken text'**
  String get readerSpeechRateDescription;

  /// Label for the language used to read book text aloud
  ///
  /// In en, this message translates to:
  /// **'Speech language'**
  String get readerSpeechLanguage;

  /// Short explanation for the text-to-speech language setting
  ///
  /// In en, this message translates to:
  /// **'Choose the language for spoken text'**
  String get readerSpeechLanguageDescription;

  /// Short explanation for the text-to-speech voice setting
  ///
  /// In en, this message translates to:
  /// **'Choose a voice for spoken text'**
  String get readerSpeechVoiceDescription;

  /// Error shown when the selected speech service has no available voices
  ///
  /// In en, this message translates to:
  /// **'No speech voices are available. Check your device speech settings'**
  String get readerSpeechVoicesUnavailable;

  /// Helper text explaining where the speech provider API key is stored
  ///
  /// In en, this message translates to:
  /// **'Stored securely on this device'**
  String get readerSpeechApiKeyStored;

  /// Error shown when reader speech preferences cannot be saved
  ///
  /// In en, this message translates to:
  /// **'Could not save speech preferences'**
  String get readerSpeechSaveFailed;

  /// Confirmation shown after reader speech preferences are saved
  ///
  /// In en, this message translates to:
  /// **'Speech preferences saved'**
  String get readerSpeechPreferencesSaved;

  /// Helper text for the text-to-speech voice identifier field
  ///
  /// In en, this message translates to:
  /// **'Use a voice available to your account'**
  String get readerSpeechVoiceIdDescription;

  /// Label for the preferred language used to generate speech
  ///
  /// In en, this message translates to:
  /// **'Preferred language'**
  String get readerSpeechPreferredLanguage;

  /// Example language codes for the speech language field
  ///
  /// In en, this message translates to:
  /// **'en, de, fr'**
  String get readerSpeechLanguageHint;

  /// Helper text explaining automatic speech language detection
  ///
  /// In en, this message translates to:
  /// **'Leave empty to detect the language from the text'**
  String get readerSpeechDetectLanguage;

  /// Helper text shown when the selected speech model detects language automatically
  ///
  /// In en, this message translates to:
  /// **'This model detects the language from the text'**
  String get readerSpeechDetectsLanguage;

  /// Tooltip for opening the list of supported speech languages
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get readerSpeechLanguageChoose;

  /// Placeholder option prompting the user to choose a speech voice
  ///
  /// In en, this message translates to:
  /// **'Choose a voice'**
  String get readerSpeechVoiceChoose;

  /// Speech voice name followed by its local or network source
  ///
  /// In en, this message translates to:
  /// **'{voice} ({type})'**
  String readerSpeechVoiceType(String voice, String type);

  /// Label for a speech voice available on the device
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get readerSpeechLocalVoice;

  /// Label for a speech voice that requires a network connection
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get readerSpeechNetworkVoice;

  /// Fallback name for a speech voice that has no display name
  ///
  /// In en, this message translates to:
  /// **'Voice {number}'**
  String readerSpeechNumberedVoice(int number);

  /// Short explanation for selecting a text-to-speech model
  ///
  /// In en, this message translates to:
  /// **'Choose a speech model'**
  String get readerSpeechModelDescription;

  /// Validation error shown when a speech voice identifier has an invalid format
  ///
  /// In en, this message translates to:
  /// **'Enter a valid voice ID'**
  String get readerSpeechVoiceInvalid;

  /// Validation error shown when a preferred speech language code has an invalid format
  ///
  /// In en, this message translates to:
  /// **'Enter a language code such as en or de'**
  String get readerSpeechLanguageCodeExample;

  /// Validation error shown when a speech model does not support the preferred language
  ///
  /// In en, this message translates to:
  /// **'This model does not support that language'**
  String get readerSpeechLanguageUnsupported;

  /// Error shown when an annotation cannot be edited or removed
  ///
  /// In en, this message translates to:
  /// **'Could not update the annotation'**
  String get errorAnnotationUpdateFailed;

  /// Error shown when the reader cannot prepare audiobook narration from an ebook
  ///
  /// In en, this message translates to:
  /// **'Could not prepare book narration'**
  String get errorReaderNarrationUnavailable;

  /// Tooltip for a button that opens additional actions for an item
  ///
  /// In en, this message translates to:
  /// **'More actions'**
  String get actionMoreActions;

  /// Label for starting a metadata quick match and the dialog that configures it
  ///
  /// In en, this message translates to:
  /// **'Quick match'**
  String get actionQuickMatch;

  /// Label for choosing metadata providers and matching an item manually
  ///
  /// In en, this message translates to:
  /// **'Manual match'**
  String get actionManualMatch;

  /// Label for marking a book or episode as finished
  ///
  /// In en, this message translates to:
  /// **'Mark as finished'**
  String get actionMarkAsFinished;

  /// Label for clearing the finished state from a book or episode
  ///
  /// In en, this message translates to:
  /// **'Mark as unfinished'**
  String get actionMarkAsUnfinished;

  /// Label for setting a book or episode listening position
  ///
  /// In en, this message translates to:
  /// **'Set progress'**
  String get actionSetProgress;

  /// Label for adding a book or episode to a playlist
  ///
  /// In en, this message translates to:
  /// **'Add to playlist'**
  String get actionAddToPlaylist;

  /// Label for adding a book to a collection
  ///
  /// In en, this message translates to:
  /// **'Add to collection'**
  String get actionAddToCollection;

  /// Label for pinning an item to the home shelf
  ///
  /// In en, this message translates to:
  /// **'Pin to shelf'**
  String get actionPinToShelf;

  /// Label for removing an item from the pinned home shelf
  ///
  /// In en, this message translates to:
  /// **'Unpin from shelf'**
  String get actionUnpinFromShelf;

  /// Label for opening playlist membership controls
  ///
  /// In en, this message translates to:
  /// **'Manage playlists'**
  String get actionManagePlaylists;

  /// Label for opening collection membership controls
  ///
  /// In en, this message translates to:
  /// **'Manage collections'**
  String get actionManageCollections;

  /// Label for opening the listening history of a media item
  ///
  /// In en, this message translates to:
  /// **'Play history'**
  String get navPlayHistory;

  /// Label for opening an ebook in the reader
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get actionRead;

  /// Label for the publisher metadata field in item details and filters
  ///
  /// In en, this message translates to:
  /// **'Publisher'**
  String get fieldPublisher;

  /// Label for a podcast episode publication date
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get fieldPublished;

  /// Label for chapter details and a playback mode that follows the current chapter
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get fieldChapter;

  /// Heading for audio files attached to a media item
  ///
  /// In en, this message translates to:
  /// **'Audio files'**
  String get fieldAudioFiles;

  /// Heading for ebook files attached to a media item
  ///
  /// In en, this message translates to:
  /// **'Ebook files'**
  String get fieldEbookFiles;

  /// Heading for all files attached to a media item
  ///
  /// In en, this message translates to:
  /// **'Library files'**
  String get fieldLibraryFiles;

  /// Heading for an item detail section followed by its item count
  ///
  /// In en, this message translates to:
  /// **'{section} ({count})'**
  String itemSectionTitleWithCount(String section, int count);

  /// Heading for the details section of an audiobook
  ///
  /// In en, this message translates to:
  /// **'Book details'**
  String get headingBookDetails;

  /// Heading for the book description section
  ///
  /// In en, this message translates to:
  /// **'About this book'**
  String get headingAboutThisBook;

  /// Label for collapsing expanded text
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get actionShowLess;

  /// Label for expanding a shortened text preview
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get actionReadMore;

  /// Message that offers a retry when named item relationships cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load {items}. Retry'**
  String errorLoadNamedItemsRetry(String items);

  /// Message that offers a retry when some named item relationships could not be checked
  ///
  /// In en, this message translates to:
  /// **'Some {items} could not be checked. Retry'**
  String statusNamedItemsUnknown(String items);

  /// Empty state for a named item relationship with no entries
  ///
  /// In en, this message translates to:
  /// **'No {items}'**
  String statusNoNamedItems(String items);

  /// Empty state shown when a search and its filters return no items
  ///
  /// In en, this message translates to:
  /// **'No items match your search or filters'**
  String get statusNoSearchMatches;

  /// Lowercase plural noun for collections in sentence templates
  ///
  /// In en, this message translates to:
  /// **'collections'**
  String get entityCollections;

  /// Lowercase plural noun for playlists in sentence templates
  ///
  /// In en, this message translates to:
  /// **'playlists'**
  String get entityPlaylists;

  /// Confirmation shown after a download is added to the queue
  ///
  /// In en, this message translates to:
  /// **'Download added to queue'**
  String get statusDownloadQueued;

  /// Error shown when a media download cannot be started
  ///
  /// In en, this message translates to:
  /// **'Could not start download'**
  String get errorDownloadStartFailed;

  /// Progress message shown while removing downloaded media files
  ///
  /// In en, this message translates to:
  /// **'Deleting downloaded files…'**
  String get statusDeletingDownloadedFiles;

  /// Summary shown after deleting downloaded files, including files that could not be removed
  ///
  /// In en, this message translates to:
  /// **'{deleted, plural, =0{No files deleted} =1{1 file deleted} other{{deleted} files deleted}}{failed, plural, =0{} =1{ · 1 file could not be removed} other{ · {failed} files could not be removed}}'**
  String downloadFilesDeleteSummary(int deleted, int failed);

  /// Error shown when a downloaded item cannot be removed
  ///
  /// In en, this message translates to:
  /// **'Could not delete download'**
  String get errorDeleteDownload;

  /// Error shown when an item cannot be pinned or unpinned
  ///
  /// In en, this message translates to:
  /// **'Could not update the pinned shelf'**
  String get errorUpdatePinned;

  /// Error shown when new episodes cannot be read from a podcast feed
  ///
  /// In en, this message translates to:
  /// **'Could not load podcast feed'**
  String get errorPodcastFeedLoad;

  /// Message shown when a podcast feed has no episodes with audio files
  ///
  /// In en, this message translates to:
  /// **'No downloadable episodes were found in the feed'**
  String get statusNoDownloadableEpisodes;

  /// Progress message shown while adding podcast episode downloads to the queue
  ///
  /// In en, this message translates to:
  /// **'Queuing episode downloads…'**
  String get statusQueuingEpisodeDownloads;

  /// Confirmation shown after podcast episode downloads are started
  ///
  /// In en, this message translates to:
  /// **'Started downloading {count, plural, =1{1 episode} other{{count} episodes}}'**
  String statusPodcastEpisodesStarted(int count);

  /// Title of the podcast episode download options dialog
  ///
  /// In en, this message translates to:
  /// **'Download episodes'**
  String get headingDownloadEpisodes;

  /// Label for downloading podcast episodes that have not been started
  ///
  /// In en, this message translates to:
  /// **'Download not started episodes'**
  String get actionDownloadNotStartedEpisodes;

  /// Label for downloading podcast episodes that are not finished
  ///
  /// In en, this message translates to:
  /// **'Download unfinished episodes'**
  String get actionDownloadUnfinishedEpisodes;

  /// Label for canceling active podcast episode downloads
  ///
  /// In en, this message translates to:
  /// **'Cancel active downloads'**
  String get actionCancelActiveDownloads;

  /// Confirmation shown after active downloads are canceled
  ///
  /// In en, this message translates to:
  /// **'Canceled {count, plural, =1{1 download} other{{count} downloads}}'**
  String statusDownloadsCanceled(int count);

  /// Message shown when selected podcast episodes are already downloaded or active
  ///
  /// In en, this message translates to:
  /// **'No new episodes to download in the selection'**
  String get statusNoNewSelectedEpisodes;

  /// Message shown when a podcast item has no metadata to display
  ///
  /// In en, this message translates to:
  /// **'Podcast metadata is unavailable'**
  String get statusPodcastMetadataUnavailable;

  /// Title shown when an item cannot be found in the library
  ///
  /// In en, this message translates to:
  /// **'Item not found'**
  String get errorItemNotFound;

  /// Message explaining why an item may no longer be available
  ///
  /// In en, this message translates to:
  /// **'This item may have been moved or deleted'**
  String get statusItemMayHaveMovedOrBeenDeleted;

  /// Placeholder shown when a podcast episode has no description
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get statusNoDescriptionAvailable;

  /// Label for searching the podcast feed for episodes not yet in the library
  ///
  /// In en, this message translates to:
  /// **'Find episodes'**
  String get actionFindEpisodes;

  /// Action for clearing a selection in a list, table, dialog, or metadata preview
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get actionClearSelection;

  /// Label for downloading the selected podcast episodes
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Download episodes} =1{Download episode} other{Download {count} episodes}}'**
  String actionDownloadEpisodes(int count);

  /// Tooltip for downloading selected podcast episodes
  ///
  /// In en, this message translates to:
  /// **'Download selected episodes'**
  String get actionDownloadSelectedEpisodes;

  /// Tooltip for opening podcast episode download options
  ///
  /// In en, this message translates to:
  /// **'Download options'**
  String get actionDownloadOptions;

  /// Hint shown in a field for searching podcast episodes
  ///
  /// In en, this message translates to:
  /// **'Search episodes'**
  String get hintSearchEpisodes;

  /// Heading above a list of podcast episodes
  ///
  /// In en, this message translates to:
  /// **'Episodes'**
  String get headingEpisodes;

  /// Title of a podcast episode details page
  ///
  /// In en, this message translates to:
  /// **'Episode'**
  String get headingEpisode;

  /// Count shown when a filtered podcast episode list displays only some episodes
  ///
  /// In en, this message translates to:
  /// **'{visible, plural, =1{1 of {total} episodes} other{{visible} of {total} episodes}}'**
  String statusEpisodeResultsSubset(int visible, int total);

  /// Confirmation shown after selected library or podcast episode downloads are added to the queue
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No downloads added to the queue} =1{Download added to the queue} other{{count} downloads added to the queue}}'**
  String statusDownloadsQueued(int count);

  /// Count of active downloads shown in podcast download options
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 download active} other{{count} downloads active}}'**
  String statusActiveDownloadCount(int count);

  /// Message shown when every episode in a podcast feed is already downloaded
  ///
  /// In en, this message translates to:
  /// **'All episodes are already downloaded'**
  String get statusAllEpisodesDownloaded;

  /// Sort option that places the newest podcast episodes at the top
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewestFirst;

  /// Sort option that places the oldest podcast episodes at the top
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldestFirst;

  /// Sort option that orders episode titles alphabetically from A to Z
  ///
  /// In en, this message translates to:
  /// **'Title A-Z'**
  String get sortTitleAscending;

  /// Sort option that orders episode titles alphabetically from Z to A
  ///
  /// In en, this message translates to:
  /// **'Title Z-A'**
  String get sortTitleDescending;

  /// Status indicating that a book or episode has been fully listened to
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get statusComplete;

  /// Status indicating that listening to a book or episode has started but is not complete
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get statusInProgress;

  /// Status indicating that a book or episode has not been fully listened to
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get statusIncomplete;

  /// Status label identifying the podcast episode that is playing now
  ///
  /// In en, this message translates to:
  /// **'Currently playing'**
  String get statusCurrentlyPlaying;

  /// Status shown while a media file is downloading
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get statusDownloading;

  /// Status shown while an item or feature is loading
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get statusLoading;

  /// Label for restarting playback from the beginning of a finished item
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get actionReplay;

  /// Label for adding a podcast episode to the playback queue
  ///
  /// In en, this message translates to:
  /// **'Add to queue'**
  String get actionAddToQueue;

  /// Action label or confirmation title for removing downloaded media from the device
  ///
  /// In en, this message translates to:
  /// **'Delete download'**
  String get actionDeleteDownload;

  /// Compact label and value pair used in settings and media details
  ///
  /// In en, this message translates to:
  /// **'{field} · {value}'**
  String metadataFieldValue(String field, String value);

  /// Podcast summary combining the episode count and total duration
  ///
  /// In en, this message translates to:
  /// **'{count} · {duration}'**
  String podcastEpisodeCountAndDuration(String count, String duration);

  /// Option for choosing a user-defined value or configuration
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get optionCustom;

  /// Option for choosing no value or action
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get optionNone;

  /// Label for opening or editing saved playback bookmarks
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get navBookmarks;

  /// Label for opening the simplified player interface for use in a car
  ///
  /// In en, this message translates to:
  /// **'Car mode'**
  String get navCarMode;

  /// Label for opening audio equalizer settings
  ///
  /// In en, this message translates to:
  /// **'Equalizer'**
  String get navEqualizer;

  /// Heading for the list of items queued for playback
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get headingQueue;

  /// Heading for a compact panel of frequently used settings
  ///
  /// In en, this message translates to:
  /// **'Quick settings'**
  String get headingQuickSettings;

  /// Option for a layout that adjusts to the screen size
  ///
  /// In en, this message translates to:
  /// **'Adaptive'**
  String get optionAdaptive;

  /// Option for a layout preset with fewer visible controls
  ///
  /// In en, this message translates to:
  /// **'Minimalistic'**
  String get optionMinimalistic;

  /// Label for choosing the size of the player cover image
  ///
  /// In en, this message translates to:
  /// **'Cover size'**
  String get fieldCoverSize;

  /// Label for using colors from the current cover in the player
  ///
  /// In en, this message translates to:
  /// **'Immersive player colors'**
  String get fieldImmersivePlayerColors;

  /// Label for choosing whether the player timeline tracks a chapter or the full item
  ///
  /// In en, this message translates to:
  /// **'Timeline mode'**
  String get fieldTimelineMode;

  /// Screen size category for a mobile device
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get deviceMobile;

  /// Screen size category for a tablet device
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get deviceTablet;

  /// Screen size category for a desktop display
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get deviceDesktop;

  /// Text alignment option that places content in the center
  ///
  /// In en, this message translates to:
  /// **'Center'**
  String get alignmentCenter;

  /// Text alignment option that aligns content with the reading direction end
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get alignmentEnd;

  /// Cover fitting option that scales the image to the available height
  ///
  /// In en, this message translates to:
  /// **'Fill height'**
  String get playerCoverFitHeight;

  /// Cover fitting option that scales the image to the available width
  ///
  /// In en, this message translates to:
  /// **'Fill width'**
  String get playerCoverFitWidth;

  /// Cover fitting option that fills the available player area
  ///
  /// In en, this message translates to:
  /// **'Fill box'**
  String get playerCoverFitBox;

  /// Option for showing seek times beside the player seek bar
  ///
  /// In en, this message translates to:
  /// **'Inline'**
  String get playerSeekTimeInline;

  /// Option for showing seek times below the player seek bar
  ///
  /// In en, this message translates to:
  /// **'Below seek bar'**
  String get playerSeekTimeBelowSeekBar;

  /// Option for showing seek times below the player app bar
  ///
  /// In en, this message translates to:
  /// **'Under app bar'**
  String get playerSeekTimeUnderAppBar;

  /// Name of the cover component in the custom player layout
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get playerComponentCover;

  /// Name of the media information component in the custom player layout
  ///
  /// In en, this message translates to:
  /// **'Media info'**
  String get playerComponentMediaInfo;

  /// Name of the seek bar component in the custom player layout
  ///
  /// In en, this message translates to:
  /// **'Seek bar'**
  String get playerComponentSeekBar;

  /// Name of the playback controls component in the custom player layout
  ///
  /// In en, this message translates to:
  /// **'Controls'**
  String get playerComponentControls;

  /// Name of the utility buttons component in the custom player layout
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get playerComponentUtilities;

  /// Name of the subtitles component in the custom player layout
  ///
  /// In en, this message translates to:
  /// **'Subtitles'**
  String get playerComponentSubtitles;

  /// Option for hiding an empty player component
  ///
  /// In en, this message translates to:
  /// **'Hide widget'**
  String get optionHideWidget;

  /// Option for showing a short message in an empty player component
  ///
  /// In en, this message translates to:
  /// **'Compact message'**
  String get optionCompactMessage;

  /// Option for showing the full empty state in a player component
  ///
  /// In en, this message translates to:
  /// **'Full placeholder'**
  String get optionFullPlaceholder;

  /// Label for moving playback by a configured time interval
  ///
  /// In en, this message translates to:
  /// **'Jump'**
  String get actionJump;

  /// Label for moving playback to the next or previous chapter
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get actionSkip;

  /// Option for showing both time jump and chapter skip controls
  ///
  /// In en, this message translates to:
  /// **'Jump and skip'**
  String get actionJumpAndSkip;

  /// Title shown while arranging the player layout for a screen size
  ///
  /// In en, this message translates to:
  /// **'Edit {screenSize} layout'**
  String playerLayoutEditTitle(String screenSize);

  /// Error shown when a player component cannot be added because the layout grid is full
  ///
  /// In en, this message translates to:
  /// **'No free grid space available for {component}'**
  String errorPlayerLayoutNoFreeSpace(String component);

  /// Confirmation shown after copying the custom player layout configuration
  ///
  /// In en, this message translates to:
  /// **'Layout config copied to clipboard'**
  String get statusPlayerLayoutConfigCopied;

  /// Status shown while the next item in the playback queue is loading
  ///
  /// In en, this message translates to:
  /// **'Loading next item…'**
  String get statusLoadingNextItem;

  /// Tooltip for opening controls to arrange the player layout
  ///
  /// In en, this message translates to:
  /// **'Edit player layout'**
  String get actionEditPlayerLayout;

  /// Tooltip for minimizing the full player and returning to the previous view
  ///
  /// In en, this message translates to:
  /// **'Minimize player'**
  String get actionMinimizePlayer;

  /// Status shown when player layout components may overlap
  ///
  /// In en, this message translates to:
  /// **'Overlap unlocked'**
  String get statusPlayerOverlapUnlocked;

  /// Status shown when player layout components cannot overlap
  ///
  /// In en, this message translates to:
  /// **'Overlap locked'**
  String get statusPlayerOverlapLocked;

  /// Title of a confirmation dialog asking whether to clear a queue
  ///
  /// In en, this message translates to:
  /// **'Clear queue?'**
  String get confirmClearQueue;

  /// Message in a confirmation dialog describing which playback queue items will be removed
  ///
  /// In en, this message translates to:
  /// **'Remove all queued, auto-queued, and scheduled items?'**
  String get confirmClearPlaybackQueue;

  /// Fallback title shown when the player uses a custom layout
  ///
  /// In en, this message translates to:
  /// **'Custom player'**
  String get statusCustomPlayer;

  /// Label for restoring a setting or layout to its default state
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get actionReset;

  /// Label for restarting the active listening session during player debugging
  ///
  /// In en, this message translates to:
  /// **'Restart listening session'**
  String get actionRestartListeningSession;

  /// Status indicating that an item or control is currently shown
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get statusVisible;

  /// Label for enabling a card background around a player component
  ///
  /// In en, this message translates to:
  /// **'Use card style'**
  String get settingUseCardStyle;

  /// Label for showing an optional metadata field in a view
  ///
  /// In en, this message translates to:
  /// **'Show {field}'**
  String settingShowField(String field);

  /// Label for the size scale of a player component
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get fieldScale;

  /// Label for the text size scale of player metadata
  ///
  /// In en, this message translates to:
  /// **'Font scale'**
  String get fieldFontScale;

  /// Label for the height of the player seek bar
  ///
  /// In en, this message translates to:
  /// **'Seek bar height'**
  String get fieldSeekBarHeight;

  /// Label for the size of time labels in the player
  ///
  /// In en, this message translates to:
  /// **'Time font size'**
  String get fieldTimeFontSize;

  /// Label for choosing how a cover image fills the player area
  ///
  /// In en, this message translates to:
  /// **'Cover fit mode'**
  String get fieldCoverFitMode;

  /// Label for choosing where player time labels appear
  ///
  /// In en, this message translates to:
  /// **'Time labels position'**
  String get fieldTimeLabelsPosition;

  /// Label for choosing what appears when a view has no content
  ///
  /// In en, this message translates to:
  /// **'Empty state'**
  String get fieldEmptyState;

  /// Player component scale value with two decimal places
  ///
  /// In en, this message translates to:
  /// **'{value}×'**
  String settingScaleValue(double value);

  /// Heading for settings that belong to a named component or feature
  ///
  /// In en, this message translates to:
  /// **'{name} settings'**
  String headingNamedSettings(String name);

  /// Empty state shown when every component is hidden from the custom player layout
  ///
  /// In en, this message translates to:
  /// **'No components are visible for this layout'**
  String get statusNoPlayerComponentsVisible;

  /// Spatial direction used in a player layout movement tooltip
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get directionLeft;

  /// Spatial direction used in a player layout movement tooltip
  ///
  /// In en, this message translates to:
  /// **'right'**
  String get directionRight;

  /// Spatial direction used in a player layout movement tooltip
  ///
  /// In en, this message translates to:
  /// **'up'**
  String get directionUp;

  /// Spatial direction used in a player layout movement tooltip
  ///
  /// In en, this message translates to:
  /// **'down'**
  String get directionDown;

  /// Tooltip for moving a component in a player layout
  ///
  /// In en, this message translates to:
  /// **'Move {direction}'**
  String actionMoveDirection(String direction);

  /// Tooltip for reducing the width of a player layout component
  ///
  /// In en, this message translates to:
  /// **'Narrower'**
  String get actionNarrower;

  /// Tooltip for increasing the width of a player layout component
  ///
  /// In en, this message translates to:
  /// **'Wider'**
  String get actionWider;

  /// Tooltip for reducing the height of a player layout component
  ///
  /// In en, this message translates to:
  /// **'Shorter'**
  String get actionShorter;

  /// Tooltip for increasing the height of a player layout component
  ///
  /// In en, this message translates to:
  /// **'Taller'**
  String get actionTaller;

  /// Empty state shown when the current audiobook has no chapters
  ///
  /// In en, this message translates to:
  /// **'No chapters available'**
  String get statusNoChaptersAvailable;

  /// Empty state shown when the playback queue has no items
  ///
  /// In en, this message translates to:
  /// **'Queue is empty'**
  String get statusQueueEmpty;

  /// Message shown when continuous subtitle reading is unavailable because subtitles are disabled
  ///
  /// In en, this message translates to:
  /// **'Subtitles are disabled in player settings'**
  String get statusSubtitlesDisabled;

  /// Prompt shown when continuous subtitle reading is open without active media
  ///
  /// In en, this message translates to:
  /// **'Start playback to use continuous subtitle reading mode'**
  String get hintStartPlaybackForSubtitleReading;

  /// Empty state shown when the current title has no subtitle track
  ///
  /// In en, this message translates to:
  /// **'No subtitles available for this title'**
  String get statusNoSubtitlesAvailable;

  /// Status shown while the current playback position has no subtitle cue
  ///
  /// In en, this message translates to:
  /// **'Waiting for subtitle cue'**
  String get statusWaitingForSubtitleCue;

  /// Heading for playback activity stored on the current device
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get headingOnThisDevice;

  /// Count of activity events shown in playback history
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 event} other{{count} events}}'**
  String eventCount(int count);

  /// Prompt shown when playback activity is unavailable without an active account
  ///
  /// In en, this message translates to:
  /// **'Sign in to view playback activity'**
  String get hintSignInToViewActivity;

  /// Empty state shown when no playback activity has been recorded
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get statusNoPlaybackActivityYet;

  /// Supporting text shown below the empty playback activity state
  ///
  /// In en, this message translates to:
  /// **'Playback, sleep timer, and sync activity will appear here'**
  String get hintPlaybackActivityWillAppear;

  /// Empty state shown when play history is unavailable
  ///
  /// In en, this message translates to:
  /// **'Nothing to show yet'**
  String get statusNothingToShowYet;

  /// Supporting text shown when play history has no active item
  ///
  /// In en, this message translates to:
  /// **'Start playing an audiobook or podcast, then open its history again'**
  String get hintOpenHistoryAfterPlayback;

  /// Message shown when playback cannot resume from a selected history event
  ///
  /// In en, this message translates to:
  /// **'Could not start playback from this position'**
  String get errorStartPlaybackFromPosition;

  /// Tooltip for changing the playback queue to a shuffled order
  ///
  /// In en, this message translates to:
  /// **'Shuffle queue'**
  String get playbackShuffleQueue;

  /// Tooltip for rewinding by the configured number of seconds
  ///
  /// In en, this message translates to:
  /// **'{seconds, plural, =1{Rewind 1 second} other{Rewind {seconds} seconds}}'**
  String playbackRewindInterval(int seconds);

  /// Tooltip for moving forward by the configured number of seconds
  ///
  /// In en, this message translates to:
  /// **'{seconds, plural, =1{Forward 1 second} other{Forward {seconds} seconds}}'**
  String playbackForwardInterval(int seconds);

  /// Tooltip showing whether repeat playback is enabled
  ///
  /// In en, this message translates to:
  /// **'Repeat {status}'**
  String playbackRepeatStatus(String status);

  /// Label for adding a bookmark at the current playback position
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get actionAddBookmark;

  /// Button label shown while a bookmark is being saved
  ///
  /// In en, this message translates to:
  /// **'Adding'**
  String get statusAddingBookmark;

  /// Message shown when the current playback position is too close to the beginning for a bookmark
  ///
  /// In en, this message translates to:
  /// **'Play a little further before creating a bookmark'**
  String get errorBookmarkPlaybackRequired;

  /// Message shown when a bookmark cannot be created
  ///
  /// In en, this message translates to:
  /// **'Could not create bookmark'**
  String get errorBookmarkCreateFailed;

  /// Confirmation shown after a bookmark is added at a playback position
  ///
  /// In en, this message translates to:
  /// **'Bookmark added at {position}'**
  String statusBookmarkAddedAt(String position);

  /// Message shown when a bookmark update fails
  ///
  /// In en, this message translates to:
  /// **'Could not update bookmark'**
  String get errorBookmarkUpdateFailed;

  /// Confirmation shown after a bookmark note is updated
  ///
  /// In en, this message translates to:
  /// **'Bookmark updated'**
  String get statusBookmarkUpdated;

  /// Message shown when a bookmark cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'Could not delete bookmark'**
  String get errorBookmarkDeleteFailed;

  /// Confirmation shown after a bookmark is deleted
  ///
  /// In en, this message translates to:
  /// **'Bookmark deleted'**
  String get statusBookmarkDeleted;

  /// Confirmation prompt asking whether to permanently delete a bookmark at a playback position
  ///
  /// In en, this message translates to:
  /// **'Remove the bookmark at {position}? This cannot be undone'**
  String confirmDeleteBookmarkAt(String position);

  /// Confirmation title asking whether to delete one or more selected bookmarks
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 bookmark?} other{Delete {count} bookmarks?}}'**
  String confirmDeleteBookmarks(int count);

  /// Confirmation shown after one or more selected bookmarks are deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 bookmark deleted} other{{count} bookmarks deleted}}'**
  String statusBookmarksDeleted(int count);

  /// Empty state shown when the current item has no bookmarks
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get statusNoBookmarksYet;

  /// Fallback label for a bookmark that has no note
  ///
  /// In en, this message translates to:
  /// **'Untitled bookmark'**
  String get untitledBookmark;

  /// Hint shown in the field for entering a bookmark note
  ///
  /// In en, this message translates to:
  /// **'What do you want to remember?'**
  String get hintBookmarkNote;

  /// Supporting text shown when the current item has no bookmarks
  ///
  /// In en, this message translates to:
  /// **'Save a note at the current playback position to find it again later'**
  String get hintSaveBookmarkToFindAgain;

  /// Title for a group of related progress changes in local playback history
  ///
  /// In en, this message translates to:
  /// **'Progress updates'**
  String get historyEventProgressUpdates;

  /// Title for a history event that starts audio playback
  ///
  /// In en, this message translates to:
  /// **'Playback started'**
  String get historyEventPlaybackStarted;

  /// Title for a history event that stops audio playback
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get historyEventStopped;

  /// Title for a history event that seeks to another position
  ///
  /// In en, this message translates to:
  /// **'Position changed'**
  String get historyEventPositionChanged;

  /// Title for a history event that skips forward in the current item
  ///
  /// In en, this message translates to:
  /// **'Skipped forward'**
  String get historyEventSkippedForward;

  /// Title for a history event that skips backward in the current item
  ///
  /// In en, this message translates to:
  /// **'Skipped back'**
  String get historyEventSkippedBack;

  /// Title for a history event that changes playback speed
  ///
  /// In en, this message translates to:
  /// **'Speed changed'**
  String get historyEventSpeedChanged;

  /// Title for a history event that starts the sleep timer
  ///
  /// In en, this message translates to:
  /// **'Sleep timer started'**
  String get historyEventSleepTimerStarted;

  /// Title for a history event that automatically starts the sleep timer
  ///
  /// In en, this message translates to:
  /// **'Sleep timer auto-started'**
  String get historyEventSleepTimerAutoStarted;

  /// Title for a history event that extends the sleep timer
  ///
  /// In en, this message translates to:
  /// **'Sleep timer extended'**
  String get historyEventSleepTimerExtended;

  /// Title for a history event that stops the sleep timer
  ///
  /// In en, this message translates to:
  /// **'Sleep timer stopped'**
  String get historyEventSleepTimerStopped;

  /// Title for a history event that ends the sleep timer
  ///
  /// In en, this message translates to:
  /// **'Sleep timer ended'**
  String get historyEventSleepTimerEnded;

  /// Title for a history event that syncs playback progress with the server
  ///
  /// In en, this message translates to:
  /// **'Progress synced'**
  String get historyEventProgressSynced;

  /// Title for a history event that saves progress while offline
  ///
  /// In en, this message translates to:
  /// **'Offline progress saved'**
  String get historyEventOfflineProgressSaved;

  /// Title for a history event that syncs progress saved while offline
  ///
  /// In en, this message translates to:
  /// **'Offline progress synced'**
  String get historyEventOfflineProgressSynced;

  /// Description of a playback history event that pauses at a position
  ///
  /// In en, this message translates to:
  /// **'Paused at {position}'**
  String historyPausedAt(String position);

  /// Description of a playback history event that stops at a position
  ///
  /// In en, this message translates to:
  /// **'Stopped at {position}'**
  String historyStoppedAt(String position);

  /// Description showing the playback position reached by a history event
  ///
  /// In en, this message translates to:
  /// **'To {position}'**
  String historyToPosition(String position);

  /// Description showing the chapter reached by a history event
  ///
  /// In en, this message translates to:
  /// **'To {chapter}'**
  String historyToChapter(String chapter);

  /// Description showing the starting and ending positions of a seek event
  ///
  /// In en, this message translates to:
  /// **'From {start} to {end}'**
  String historyPositionRange(String start, String end);

  /// Description showing the previous and new playback speeds
  ///
  /// In en, this message translates to:
  /// **'{previousSpeed}× to {speed}×'**
  String historySpeedRange(double previousSpeed, double speed);

  /// Description of the duration or chapter count set on a sleep timer
  ///
  /// In en, this message translates to:
  /// **'For {value}'**
  String historyForValue(String value);

  /// Description showing the duration remaining on a sleep timer
  ///
  /// In en, this message translates to:
  /// **'{duration} left'**
  String historyDurationLeft(String duration);

  /// Description showing that a sleep timer resumed without a known duration
  ///
  /// In en, this message translates to:
  /// **'Resumed'**
  String get historySleepTimerResumed;

  /// Description showing that a sleep timer started without a known duration
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get historySleepTimerStarted;

  /// Description showing that a sleep timer started automatically without a known duration
  ///
  /// In en, this message translates to:
  /// **'Auto-started'**
  String get historySleepTimerAutoStarted;

  /// Description showing a sleep timer extension and the remaining time or chapters
  ///
  /// In en, this message translates to:
  /// **'+{additional} · {remaining} left'**
  String historySleepTimerExtended(String additional, String remaining);

  /// Description showing what happened to playback when a sleep timer stopped
  ///
  /// In en, this message translates to:
  /// **'{action, select, pause{Paused with {remaining} left} reset{Reset with {remaining} left} other{Stopped with {remaining} left}}'**
  String historySleepTimerRemaining(String action, String remaining);

  /// Description showing that a sleep timer stopped without a known remaining time
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get historySleepTimerStopped;

  /// Description showing whether the sleep timer paused or stopped playback
  ///
  /// In en, this message translates to:
  /// **'{action, select, pause{Paused playback} other{Stopped playback}}'**
  String historyPlaybackEndedByTimer(String action);

  /// Description of a playback progress sync or save at a position
  ///
  /// In en, this message translates to:
  /// **'{action} at {position}'**
  String historyProgressAtPosition(String action, String position);

  /// History detail joining an event time with its description
  ///
  /// In en, this message translates to:
  /// **'{time} · {description}'**
  String historyTimeAndDescription(String time, String description);

  /// Count of chapters shown in player controls, chapter lists, and timer activity
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter} other{{count} chapters}}'**
  String chapterCount(int count);

  /// Status indicating that changes were synchronized with the server
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get statusSynced;

  /// Status indicating that changes were saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get statusSaved;

  /// Option that follows the full book timeline in the player or playback notification
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get playbackFullTimeline;

  /// Subtitle showing a cast protocol and its connection status
  ///
  /// In en, this message translates to:
  /// **'{protocol} · {status}'**
  String castProtocolStatus(String protocol, String status);

  /// Status shown while searching the local network for cast receivers
  ///
  /// In en, this message translates to:
  /// **'Searching for devices on your network'**
  String get statusSearchingCastDevices;

  /// Message shown when no cast receivers are found on the local network
  ///
  /// In en, this message translates to:
  /// **'No devices found. Check that your receiver is on the same network'**
  String get statusNoCastDevicesFound;

  /// Error shown when playback cannot be stopped on a cast receiver
  ///
  /// In en, this message translates to:
  /// **'Unable to stop playback on the receiver'**
  String get errorCastStopFailed;

  /// Error shown when discovery of cast receivers fails
  ///
  /// In en, this message translates to:
  /// **'Could not search for cast devices'**
  String get errorCastDiscoveryFailed;

  /// Message shown when the current media does not support playback speed changes
  ///
  /// In en, this message translates to:
  /// **'Playback speed is unavailable for this playback'**
  String get errorPlaybackSpeedUnavailable;

  /// Label for settings backup in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Settings backup'**
  String get settingsBackupTitle;

  /// Supporting text explaining settings backup in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Import or export app preferences and player layouts'**
  String get settingsBackupDescription;

  /// Label for refresh progress on resume in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Refresh progress on resume'**
  String get settingRefreshProgressOnResume;

  /// Supporting text explaining refresh progress on resume in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Update book and episode progress when the app returns to the foreground'**
  String get settingRefreshProgressOnResumeDescription;

  /// Label for disable fdk aac decoder in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Disable FDK AAC decoder'**
  String get settingDisableFdkAacDecoder;

  /// Supporting text explaining disable fdk aac decoder in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Avoid crashes in the FDK AAC decoder. Restart the app to apply'**
  String get settingDisableFdkAacDecoderDescription;

  /// Label for server management in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Server management'**
  String get settingServerManagement;

  /// Supporting text explaining server management in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Configure visibility for collections, editing, deletion, and uploading'**
  String get settingServerManagementDescription;

  /// Supporting text explaining timeline mode in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose whether the seek bar tracks a chapter, the full audiobook, or both'**
  String get settingTimelineModeDescription;

  /// Supporting text explaining cover size in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Set the artwork size in the adaptive player'**
  String get settingCoverSizeDescription;

  /// Supporting text explaining immersive player colors in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Use artwork colors in player backgrounds'**
  String get settingImmersivePlayerColorsDescription;

  /// Label for timeline markers in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Timeline markers'**
  String get settingTimelineMarkers;

  /// Supporting text explaining timeline markers in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose whether the full timeline shows chapter markers, bookmark markers, both, or none'**
  String get settingTimelineMarkersDescription;

  /// Supporting text explaining fast forward interval in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'How many seconds to skip when jumping forward'**
  String get settingFastForwardIntervalDescription;

  /// Supporting text explaining rewind interval in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'How many seconds to skip when rewinding'**
  String get settingRewindIntervalDescription;

  /// Label for remember playback speed per book in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Remember playback speed per book'**
  String get settingRememberPlaybackSpeedPerBook;

  /// Supporting text explaining remember playback speed per book in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Each book remembers its own speed and new books start with your last used speed'**
  String get settingRememberPlaybackSpeedPerBookDescription;

  /// Label for auto queue in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto queue'**
  String get settingAutoQueue;

  /// Supporting text explaining auto queue in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Automatically queue upcoming books when playback starts'**
  String get settingAutoQueueDescription;

  /// Label for auto queue everywhere in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto queue everywhere'**
  String get settingAutoQueueEverywhere;

  /// Supporting text explaining auto queue everywhere in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto queue books from the first linked series even when starting playback outside a series view'**
  String get settingAutoQueueEverywhereDescription;

  /// Label for smart rewind in settings search results, its settings page, and the settings category breadcrumb
  ///
  /// In en, this message translates to:
  /// **'Smart rewind'**
  String get settingSmartRewind;

  /// Supporting text explaining smart rewind in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'When resuming after a pause, rewind by an amount based on pause duration'**
  String get settingSmartRewindDescription;

  /// Label for short-pause threshold in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Short-pause threshold'**
  String get settingShortPauseThreshold;

  /// Supporting text explaining short-pause threshold in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'If paused up to this amount, the short smart rewind value is used'**
  String get settingShortPauseThresholdDescription;

  /// Label for long-pause threshold in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Long-pause threshold'**
  String get settingLongPauseThreshold;

  /// Supporting text explaining long-pause threshold in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'If paused longer than the short threshold and up to this amount, the medium smart rewind value is used'**
  String get settingLongPauseThresholdDescription;

  /// Label for short rewind amount in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Short rewind amount'**
  String get settingShortRewindAmount;

  /// Supporting text explaining short rewind amount in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Rewind amount used for short pauses'**
  String get settingShortRewindAmountDescription;

  /// Label for medium rewind amount in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Medium rewind amount'**
  String get settingMediumRewindAmount;

  /// Supporting text explaining medium rewind amount in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Rewind amount used for medium pauses'**
  String get settingMediumRewindAmountDescription;

  /// Label for long rewind amount in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Long rewind amount'**
  String get settingLongRewindAmount;

  /// Supporting text explaining long rewind amount in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Rewind amount used for long pauses'**
  String get settingLongRewindAmountDescription;

  /// Label for sleep timer end action in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Sleep timer end action'**
  String get settingSleepTimerEndAction;

  /// Supporting text explaining sleep timer end action in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose whether playback is stopped or paused when the sleep timer expires'**
  String get settingSleepTimerEndActionDescription;

  /// Label for sleep timer end rewind in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Sleep timer end rewind'**
  String get settingSleepTimerEndRewind;

  /// Supporting text explaining sleep timer end rewind in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'After sleep timer stops playback, rewind this much when the same item is played again'**
  String get settingSleepTimerEndRewindDescription;

  /// Label for fade audio in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Fade audio'**
  String get settingFadeAudio;

  /// Supporting text explaining fade audio in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Gradually lower playback volume before the sleep timer ends'**
  String get settingFadeAudioDescription;

  /// Label for show sleep timer marker in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Show sleep timer marker'**
  String get settingShowSleepTimerMarker;

  /// Supporting text explaining show sleep timer marker in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Show the sleep timer on the player timeline after it ends'**
  String get settingShowSleepTimerMarkerDescription;

  /// Label for auto-restart timer on playback start in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto-restart timer on playback start'**
  String get settingAutoRestartTimerOnPlaybackStart;

  /// Supporting text explaining auto-restart timer on playback start in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Automatically start a new sleep timer using your last duration on playback start'**
  String get settingAutoRestartTimerOnPlaybackStartDescription;

  /// Label for only auto-restart during a time range in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Only auto-restart during a time range'**
  String get settingAutoRestartDuringTimeRange;

  /// Supporting text explaining only auto-restart during a time range in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Limit automatic sleep timer restart to specific hours'**
  String get settingAutoRestartDuringTimeRangeDescription;

  /// Label for auto-restart range start in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto-restart range start'**
  String get settingAutoRestartRangeStart;

  /// Supporting text explaining auto-restart range start in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Sleep timer auto-restart becomes active at this time'**
  String get settingAutoRestartRangeStartDescription;

  /// Label for auto-restart range end in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto-restart range end'**
  String get settingAutoRestartRangeEnd;

  /// Supporting text explaining auto-restart range end in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Sleep timer auto-restart remains active until this time'**
  String get settingAutoRestartRangeEndDescription;

  /// Label for enable subtitles in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Enable subtitles'**
  String get settingEnableSubtitles;

  /// Supporting text explaining enable subtitles in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Show subtitle tracks (.srt and .vtt) during playback when available'**
  String get settingEnableSubtitlesDescription;

  /// Label for highlight speaker labels in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Highlight speaker labels'**
  String get settingHighlightSpeakerLabels;

  /// Supporting text explaining highlight speaker labels in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Highlight speaker names in subtitles'**
  String get settingHighlightSpeakerLabelsDescription;

  /// Label for enable read along in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Enable read along'**
  String get settingEnableReadAlong;

  /// Supporting text explaining enable read along in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Highlight currently spoken words in subtitles'**
  String get settingEnableReadAlongDescription;

  /// Label for shake to reset sleep timer in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shake to reset sleep timer'**
  String get settingShakeToResetSleepTimer;

  /// Supporting text explaining shake to reset sleep timer in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shake to reset an active sleep timer back to its full duration'**
  String get settingShakeToResetSleepTimerDescription;

  /// Label for shake to rewind in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shake to rewind'**
  String get settingShakeToRewind;

  /// Supporting text explaining shake to rewind in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shake while playing to rewind by the configured rewind interval'**
  String get settingShakeToRewindDescription;

  /// Label for shake sensitivity in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shake sensitivity'**
  String get settingShakeSensitivity;

  /// Supporting text explaining shake sensitivity in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Lower values trigger more easily, higher values require a stronger shake'**
  String get settingShakeSensitivityDescription;

  /// Label for shake vibration feedback in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shake vibration feedback'**
  String get settingShakeVibrationFeedback;

  /// Supporting text explaining shake vibration feedback in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Vibrate when a shake action is triggered'**
  String get settingShakeVibrationFeedbackDescription;

  /// Label for shelf sections in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Shelf sections'**
  String get settingShelfSections;

  /// Supporting text explaining shelf sections in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose which shelf sections are visible and their order'**
  String get settingShelfSectionsDescription;

  /// Label for library grid scale in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Library grid scale'**
  String get settingLibraryGridScale;

  /// Supporting text explaining library grid scale in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Scales library item cards in all grid views'**
  String get settingLibraryGridScaleDescription;

  /// Label for collapse series in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Collapse series'**
  String get settingCollapseSeries;

  /// Supporting text explaining collapse series in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Collapse books in series into a single entry'**
  String get settingCollapseSeriesDescription;

  /// Label for view subtitles in settings search results, its settings page, and the settings category breadcrumb
  ///
  /// In en, this message translates to:
  /// **'View subtitles'**
  String get settingViewSubtitles;

  /// Supporting text explaining view subtitles in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Configure supporting information shown below library, series, and author cards'**
  String get settingViewSubtitlesDescription;

  /// Label for show shelf play button in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Show shelf play button'**
  String get settingShowShelfPlayButton;

  /// Supporting text explaining show shelf play button in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Add a play all control to the Continue listening and Newest shelves'**
  String get settingShowShelfPlayButtonDescription;

  /// Label for show shuffle button in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Show shuffle button'**
  String get settingShowShuffleButton;

  /// Supporting text explaining show shuffle button in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Add a shuffle control to collections, playlists, and podcasts'**
  String get settingShowShuffleButtonDescription;

  /// Label for check server updates in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Check server updates'**
  String get settingCheckServerUpdates;

  /// Supporting text explaining check server updates in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Check Audiobookshelf releases on GitHub for server updates'**
  String get settingCheckServerUpdatesDescription;

  /// Label for download location in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Download location'**
  String get settingDownloadLocation;

  /// Supporting text explaining download location in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose where downloaded media is stored'**
  String get settingDownloadLocationDescription;

  /// Label for download only on wi-fi in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Download only on Wi-Fi'**
  String get settingDownloadOnlyOnWiFi;

  /// Supporting text explaining download only on wi-fi in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Limit regular and smart downloads to Wi-Fi'**
  String get settingDownloadOnlyOnWiFiDescription;

  /// Label for maximum parallel downloads in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Maximum parallel downloads'**
  String get settingMaximumParallelDownloads;

  /// Supporting text explaining maximum parallel downloads in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Limit the number of files downloaded at the same time'**
  String get settingMaximumParallelDownloadsDescription;

  /// Label for smart downloads in settings search results and title of its settings page
  ///
  /// In en, this message translates to:
  /// **'Smart downloads'**
  String get settingSmartDownloads;

  /// Supporting text explaining smart downloads in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Automatically download and remove items according to download rules'**
  String get settingSmartDownloadsDescription;

  /// Supporting text explaining language in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Configure app display language'**
  String get settingLanguageDescription;

  /// Label for max buffer size in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Max buffer size'**
  String get settingMaxBufferSize;

  /// Supporting text explaining max buffer size in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Maximum size of the audio buffer in bytes (hint for the OS)'**
  String get settingMaxBufferSizeDescription;

  /// Label for keep screen on in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get settingKeepScreenOn;

  /// Supporting text explaining keep screen on in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Prevent screen from turning off during playback'**
  String get settingKeepScreenOnDescription;

  /// Label for lock media notification in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Lock media notification'**
  String get settingLockMediaNotification;

  /// Supporting text explaining lock media notification in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Keep media controls visible in system notification panel'**
  String get settingLockMediaNotificationDescription;

  /// Label for media notification type in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Media notification type'**
  String get settingMediaNotificationType;

  /// Supporting text explaining media notification type in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose whether notification progress tracks the full book or current chapter'**
  String get settingMediaNotificationTypeDescription;

  /// Label for media notification actions in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Media notification actions'**
  String get settingMediaNotificationActions;

  /// Supporting text explaining media notification actions in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Customize the actions available in the media notification'**
  String get settingMediaNotificationActionsDescription;

  /// Label for auto-play last played on app start in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Auto-play last played on app start'**
  String get settingAutoPlayLastPlayedOnAppStart;

  /// Supporting text explaining auto-play last played on app start in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Resume the last played item on app launch if it is not finished'**
  String get settingAutoPlayLastPlayedOnAppStartDescription;

  /// Label for always show mini player in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Always show mini player'**
  String get settingAlwaysShowMiniPlayer;

  /// Supporting text explaining always show mini player in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Keep the mini player visible for your most recently played item'**
  String get settingAlwaysShowMiniPlayerDescription;

  /// Label for keep websocket active in background in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Keep WebSocket active in background'**
  String get settingKeepWebSocketActiveInBackground;

  /// Supporting text explaining keep websocket active in background in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Keep the app connected in the background to sync updates, which may increase battery use'**
  String get settingKeepWebSocketActiveInBackgroundDescription;

  /// Label for enable caching in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Enable caching'**
  String get settingEnableCaching;

  /// Supporting text explaining enable caching in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Enable response caching for API requests'**
  String get settingEnableCachingDescription;

  /// Label for speedup mode in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Speedup mode'**
  String get settingSpeedupMode;

  /// Supporting text explaining speedup mode in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Combine caching with background refreshes to load faster'**
  String get settingSpeedupModeDescription;

  /// Supporting text explaining remove authors without books in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Add a button in the author section to delete authors without books'**
  String get settingRemoveAuthorsWithoutBooksDescription;

  /// Label or dialog title for the server tool that recreates metadata files for selected libraries
  ///
  /// In en, this message translates to:
  /// **'Force metadata refresh'**
  String get settingForceMetadataRefresh;

  /// Supporting text explaining force metadata refresh in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Recreates metadata files for items in the selected libraries'**
  String get settingForceMetadataRefreshDescription;

  /// Label for match audiobook chapters in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Match audiobook chapters'**
  String get settingMatchAudiobookChapters;

  /// Supporting text explaining match audiobook chapters in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Add quick and bulk chapter matching tools'**
  String get settingMatchAudiobookChaptersDescription;

  /// Label for split genres/tags in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Split genres/tags'**
  String get settingSplitGenresAndTags;

  /// Supporting text explaining split genres/tags in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Add a control for separating combined genre and tag values in server settings'**
  String get settingSplitGenresAndTagsDescription;

  /// Label for log level in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Log level'**
  String get settingLogLevel;

  /// Supporting text explaining log level in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose the minimum severity level of logs to capture'**
  String get settingLogLevelDescription;

  /// Label for reader theme in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Reader theme'**
  String get settingReaderTheme;

  /// Supporting text explaining reader theme in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Background and text color theme of the reader'**
  String get settingReaderThemeDescription;

  /// Supporting text explaining reader font size in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Adjust the size of the reader text'**
  String get settingReaderFontSizeDescription;

  /// Supporting text explaining reader line spacing in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Adjust the line spacing of the reader text'**
  String get settingReaderLineSpacingDescription;

  /// Supporting text explaining reader layout mode in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Choose between paginated columns or vertical infinite scroll'**
  String get settingReaderLayoutModeDescription;

  /// Label for start session when reading in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Start session when reading'**
  String get settingStartSessionWhenReading;

  /// Supporting text explaining start session when reading in settings search results and on its settings page
  ///
  /// In en, this message translates to:
  /// **'Track reading time on the server when using direct play'**
  String get settingStartSessionWhenReadingDescription;

  /// Name of the application settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Application settings'**
  String get settingsCategoryApplicationSettings;

  /// Name of the player settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get settingsCategoryPlayer;

  /// Name of the server management settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get settingsCategoryManagement;

  /// Name of the global player settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Global player'**
  String get settingsCategoryGlobalPlayer;

  /// Name of the caching settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Caching'**
  String get settingsCategoryCaching;

  /// Name of the tools settings category and title of the tools settings page
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get settingsCategoryTools;

  /// Title of the application log page and name of its settings category in search results
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get settingsCategoryLogs;

  /// Name of the player compatibility settings category
  ///
  /// In en, this message translates to:
  /// **'Compatibility'**
  String get settingsCategoryCompatibility;

  /// Heading for general settings sections and the general player settings category
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsCategoryGeneral;

  /// Name of the shake controls settings category
  ///
  /// In en, this message translates to:
  /// **'Shake controls'**
  String get settingsCategoryShakeControls;

  /// Name of the appearance settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsCategoryAppearance;

  /// Name of the reader settings category in settings search results
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get settingsCategoryReader;

  /// Breadcrumb showing the root settings destination and its category path
  ///
  /// In en, this message translates to:
  /// **'{subsection, select, none{{root} › {section}} other{{root} › {section} › {subsection}}}'**
  String settingsCategoryPath(String root, String section, String subsection);

  /// Heading for the account currently active on this device
  ///
  /// In en, this message translates to:
  /// **'Active account'**
  String get settingsActiveAccount;

  /// Message shown when an account has no server address configured
  ///
  /// In en, this message translates to:
  /// **'This account has no configured server address'**
  String get settingsNoServerAddress;

  /// Tooltip for opening authentication code settings for the active account
  ///
  /// In en, this message translates to:
  /// **'Create authentication code'**
  String get settingsCreateAuthenticationCode;

  /// Tooltip for opening connection settings for the active account and title of that settings page
  ///
  /// In en, this message translates to:
  /// **'Server connection'**
  String get settingsServerConnection;

  /// Label for opening account management
  ///
  /// In en, this message translates to:
  /// **'Manage accounts'**
  String get settingsManageAccounts;

  /// Label for adding an account to this device
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get settingsAddAccount;

  /// Heading above preferences available for a signed-in user
  ///
  /// In en, this message translates to:
  /// **'Preferences for {username}'**
  String settingsAccountPreferences(String username);

  /// Label for opening player preferences for the signed-in user
  ///
  /// In en, this message translates to:
  /// **'Player settings'**
  String get settingsPlayerSettings;

  /// Heading for the account currently active on this device
  ///
  /// In en, this message translates to:
  /// **'Current account'**
  String get settingsCurrentAccount;

  /// Heading for saved accounts that are not currently active
  ///
  /// In en, this message translates to:
  /// **'Other accounts'**
  String get settingsOtherAccounts;

  /// Empty state shown when no other saved accounts are available
  ///
  /// In en, this message translates to:
  /// **'No other accounts available'**
  String get settingsNoOtherAccounts;

  /// Confirmation message shown before signing out of a saved account
  ///
  /// In en, this message translates to:
  /// **'Sign out from {username} on this device?'**
  String settingsSignOutPrompt(String username);

  /// Confirmation dialog title before removing a saved account from this device
  ///
  /// In en, this message translates to:
  /// **'Remove account?'**
  String get settingsRemoveAccountTitle;

  /// Confirmation message explaining that a saved account will be removed from this device
  ///
  /// In en, this message translates to:
  /// **'Remove the saved account for {username} from this device?'**
  String settingsRemoveAccountPrompt(String username);

  /// Snackbar confirming that a saved account was removed from this device
  ///
  /// In en, this message translates to:
  /// **'Removed the account for {username}'**
  String settingsAccountRemoved(String username);

  /// Snackbar shown when a saved account could not be removed
  ///
  /// In en, this message translates to:
  /// **'Could not remove the account for {username}'**
  String settingsAccountRemovalFailed(String username);

  /// Snackbar confirming that the active account changed
  ///
  /// In en, this message translates to:
  /// **'Switched to {username}'**
  String settingsAccountSwitched(String username);

  /// Tooltip for making a saved account active on this device
  ///
  /// In en, this message translates to:
  /// **'Switch to this user'**
  String get settingsSwitchToUser;

  /// Snackbar shown when an external support link cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open {name}'**
  String settingsOpenLinkFailed(String name);

  /// Name used for the project source link in settings
  ///
  /// In en, this message translates to:
  /// **'GitHub repository'**
  String get settingsGitHubRepository;

  /// Name used for the bug reporting link in settings
  ///
  /// In en, this message translates to:
  /// **'issue tracker'**
  String get settingsIssueTracker;

  /// Name used for the project sponsorship link in settings
  ///
  /// In en, this message translates to:
  /// **'GitHub Sponsors page'**
  String get settingsGitHubSponsors;

  /// Heading for project information and support links
  ///
  /// In en, this message translates to:
  /// **'About and support'**
  String get settingsAboutSupport;

  /// Label for opening the yaabsa project page on GitHub
  ///
  /// In en, this message translates to:
  /// **'View on GitHub'**
  String get settingsViewOnGitHub;

  /// Label for opening the project issue tracker
  ///
  /// In en, this message translates to:
  /// **'Report a bug or request a feature'**
  String get settingsReportIssue;

  /// Label for opening the project sponsorship page
  ///
  /// In en, this message translates to:
  /// **'Sponsor'**
  String get settingsSponsor;

  /// Supporting text for the project sponsorship link
  ///
  /// In en, this message translates to:
  /// **'Help cover active costs and support development'**
  String get settingsSponsorDescription;

  /// Label for opening app version and license information
  ///
  /// In en, this message translates to:
  /// **'Information and attribution'**
  String get settingsInformationTitle;

  /// Supporting text for app information and license details
  ///
  /// In en, this message translates to:
  /// **'App version, licenses, and other information'**
  String get settingsInformationDescription;

  /// Heading for car playback integration settings
  ///
  /// In en, this message translates to:
  /// **'Car integration'**
  String get settingsCarIntegration;

  /// Label for Android Automotive integration settings
  ///
  /// In en, this message translates to:
  /// **'Android Automotive'**
  String get settingsAndroidAutomotive;

  /// Label for Android Auto integration settings
  ///
  /// In en, this message translates to:
  /// **'Android Auto'**
  String get settingsAndroidAuto;

  /// Label for CarPlay integration settings
  ///
  /// In en, this message translates to:
  /// **'CarPlay'**
  String get settingsCarPlay;

  /// Validation message shown when a podcast release date uses an invalid format
  ///
  /// In en, this message translates to:
  /// **'Enter a valid release date in YYYY-MM-DD format'**
  String get validationReleaseDateFormat;

  /// Validation message shown when a podcast feed address is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid HTTP or HTTPS feed URL'**
  String get validationFeedUrl;

  /// Snackbar shown when the metadata editor has no changes to save
  ///
  /// In en, this message translates to:
  /// **'No changes to save'**
  String get statusNoChangesToSave;

  /// Snackbar shown when the series number prompt cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open the series number prompt. Try again'**
  String get errorSeriesSequencePromptUnavailable;

  /// Title of the prompt for entering a book's number in a series
  ///
  /// In en, this message translates to:
  /// **'Series number'**
  String get fieldSeriesNumber;

  /// Label for entering a book's position within a series
  ///
  /// In en, this message translates to:
  /// **'Sequence'**
  String get fieldSequence;

  /// Example shown for valid book sequence values within a series
  ///
  /// In en, this message translates to:
  /// **'For example 1, 2.5, or 03 with no spaces'**
  String get hintSeriesSequence;

  /// Label for a button that saves changes and closes the editor
  ///
  /// In en, this message translates to:
  /// **'Save and close'**
  String get actionSaveAndClose;

  /// Label for an item's subtitle in a metadata form
  ///
  /// In en, this message translates to:
  /// **'Subtitle'**
  String get fieldSubtitle;

  /// Label for a podcast's release date field
  ///
  /// In en, this message translates to:
  /// **'Release date'**
  String get fieldReleaseDate;

  /// Label for an item's ISBN field
  ///
  /// In en, this message translates to:
  /// **'ISBN'**
  String get fieldIsbn;

  /// Label for an item's ASIN field
  ///
  /// In en, this message translates to:
  /// **'ASIN'**
  String get fieldAsin;

  /// Label for a podcast RSS feed address field
  ///
  /// In en, this message translates to:
  /// **'Feed URL'**
  String get fieldFeedUrl;

  /// Label for a podcast's iTunes identifier field
  ///
  /// In en, this message translates to:
  /// **'iTunes ID'**
  String get fieldItunesId;

  /// Heading above editable media metadata fields, including creation forms
  ///
  /// In en, this message translates to:
  /// **'Metadata'**
  String get headingMetadata;

  /// Label for the authors field in an item metadata form
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get fieldAuthors;

  /// Label for the narrators field in an item metadata form
  ///
  /// In en, this message translates to:
  /// **'Narrators'**
  String get fieldNarrators;

  /// Hint text for adding a series to an audiobook
  ///
  /// In en, this message translates to:
  /// **'Add series'**
  String get hintAddSeries;

  /// Label for the explicit content setting in an item metadata form
  ///
  /// In en, this message translates to:
  /// **'Explicit'**
  String get fieldExplicit;

  /// Label for the abridged setting in an audiobook metadata form
  ///
  /// In en, this message translates to:
  /// **'Abridged'**
  String get fieldAbridged;

  /// Hint text for entering formatted item description text
  ///
  /// In en, this message translates to:
  /// **'Write a formatted description'**
  String get fieldDescriptionHint;

  /// Date pattern shown for podcast release dates accepted in ISO format
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get dateFormatIso;

  /// Example address shown in the podcast RSS feed field
  ///
  /// In en, this message translates to:
  /// **'https://example.com/feed.xml'**
  String get hintPodcastFeedUrlExample;

  /// Label for choosing the podcast publication format
  ///
  /// In en, this message translates to:
  /// **'Podcast type'**
  String get fieldPodcastType;

  /// Option for a podcast that publishes standalone episodes
  ///
  /// In en, this message translates to:
  /// **'Episodic'**
  String get podcastTypeEpisodic;

  /// Option for a podcast that publishes episodes in a sequence
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get podcastTypeSerial;

  /// Empty state shown when an item has no audio tracks for M4B encoding
  ///
  /// In en, this message translates to:
  /// **'No audio tracks are available for M4B encoding'**
  String get statusNoAudioTracksAvailable;

  /// Heading for the audio conversion controls
  ///
  /// In en, this message translates to:
  /// **'M4B encoder'**
  String get headingM4bEncoder;

  /// Compact option for choosing preset audio encoder settings
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get optionPresets;

  /// Compact option for entering custom audio encoder settings
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get optionAdvanced;

  /// Label for choosing or entering an audio codec
  ///
  /// In en, this message translates to:
  /// **'Codec'**
  String get fieldCodec;

  /// Label for choosing or entering an audio bitrate
  ///
  /// In en, this message translates to:
  /// **'Bitrate'**
  String get fieldBitrate;

  /// Label for choosing or entering an audio channel count
  ///
  /// In en, this message translates to:
  /// **'Channels'**
  String get fieldChannels;

  /// Heading above the source audio tracks available for conversion
  ///
  /// In en, this message translates to:
  /// **'Audio tracks'**
  String get fieldAudioTracks;

  /// Audio channel mode with one channel
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get channelMono;

  /// Audio channel mode with two channels
  ///
  /// In en, this message translates to:
  /// **'Stereo'**
  String get channelStereo;

  /// Status shown while the audio conversion job is being submitted
  ///
  /// In en, this message translates to:
  /// **'Submitting…'**
  String get statusSubmitting;

  /// Status shown while the audio conversion job is running
  ///
  /// In en, this message translates to:
  /// **'Running…'**
  String get statusRunning;

  /// Label for starting audio conversion
  ///
  /// In en, this message translates to:
  /// **'Start encoding'**
  String get actionStartEncoding;

  /// Status shown while an audio conversion job is being canceled
  ///
  /// In en, this message translates to:
  /// **'Canceling…'**
  String get statusCanceling;

  /// Progress label shown while an audio conversion job is running
  ///
  /// In en, this message translates to:
  /// **'Progress {progress}'**
  String encoderProgress(String progress);

  /// Audio bitrate expressed in kilobits per second
  ///
  /// In en, this message translates to:
  /// **'{bitrate} kbps'**
  String encoderBitrateKbps(int bitrate);

  /// Audio channel count shown with the source track details
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 channel} other{{count} channels}}'**
  String encoderChannelCount(int count);

  /// Summary shown when source audio tracks use different codecs
  ///
  /// In en, this message translates to:
  /// **'Mixed codecs'**
  String get encoderMixedCodecs;

  /// Summary shown when source audio tracks use different bitrates
  ///
  /// In en, this message translates to:
  /// **'Mixed bitrates'**
  String get encoderMixedBitrates;

  /// Summary shown when source audio tracks use different channel counts
  ///
  /// In en, this message translates to:
  /// **'Mixed channels'**
  String get encoderMixedChannels;

  /// Summary of the codec, bitrate, and channel count used by the source audio tracks
  ///
  /// In en, this message translates to:
  /// **'Current encoding {codec} · {bitrate} · {channels}'**
  String encoderCurrentEncoding(String codec, String bitrate, String channels);

  /// Metadata summary shown for a source audio track
  ///
  /// In en, this message translates to:
  /// **'{codec} · {bitrate} · {channels} · {duration} · {size}'**
  String audioTrackMetadata(String codec, String bitrate, String channels, String duration, String size);

  /// Navigation label for the details section of an item
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get navDetails;

  /// Label for chapter navigation and headings above chapter lists in item details, playback, or settings
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get navChapters;

  /// Navigation label for an item matching section
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get navMatch;

  /// Navigation label for an item metadata embedding section
  ///
  /// In en, this message translates to:
  /// **'Embedding'**
  String get navEmbedding;

  /// Navigation label for an audio encoding section
  ///
  /// In en, this message translates to:
  /// **'Encoder'**
  String get navEncoder;

  /// Error shown when a server request fails with an HTTP status code
  ///
  /// In en, this message translates to:
  /// **'Request failed with status {statusCode}'**
  String errorRequestFailed(int statusCode);

  /// Error shown when an application operation fails and includes a server or system message
  ///
  /// In en, this message translates to:
  /// **'{operation} failed. {details}'**
  String errorOperationFailed(String operation, String details);

  /// Operation name used when reporting a metadata load failure
  ///
  /// In en, this message translates to:
  /// **'Loading metadata'**
  String get operationLoadMetadata;

  /// Operation name used when reporting a metadata embedding failure
  ///
  /// In en, this message translates to:
  /// **'Starting metadata embedding'**
  String get operationStartEmbedding;

  /// Operation name used when reporting an audio encoding failure
  ///
  /// In en, this message translates to:
  /// **'Starting M4B encoding'**
  String get operationStartEncoding;

  /// Operation name used when reporting an encoding cancellation failure
  ///
  /// In en, this message translates to:
  /// **'Canceling encoding'**
  String get operationCancelEncoding;

  /// Operation name used when reporting an item details save failure
  ///
  /// In en, this message translates to:
  /// **'Saving item details'**
  String get operationSaveItemDetails;

  /// Operation name used when reporting a chapter lookup failure
  ///
  /// In en, this message translates to:
  /// **'Looking up chapters'**
  String get operationLookupChapters;

  /// Operation name used when reporting a chapter save failure
  ///
  /// In en, this message translates to:
  /// **'Saving chapters'**
  String get operationSaveChapters;

  /// Operation name used when reporting a chapter reload failure
  ///
  /// In en, this message translates to:
  /// **'Reloading chapters'**
  String get operationReloadChapters;

  /// Empty state shown when an item has no audio tracks for metadata embedding
  ///
  /// In en, this message translates to:
  /// **'No audio tracks are available for metadata embedding'**
  String get statusNoAudioTracksForEmbedding;

  /// Heading above metadata fields that will be written to audio files
  ///
  /// In en, this message translates to:
  /// **'Metadata to embed'**
  String get headingMetadataToEmbed;

  /// Heading above chapter markers that will be written to audio files
  ///
  /// In en, this message translates to:
  /// **'Chapters to embed'**
  String get headingChaptersToEmbed;

  /// Option to save copies of audio files before embedding metadata
  ///
  /// In en, this message translates to:
  /// **'Back up audio files before embedding'**
  String get settingBackupAudioFilesBeforeEmbedding;

  /// Option to replace existing chapter markers when embedding metadata
  ///
  /// In en, this message translates to:
  /// **'Force chapter embedding'**
  String get settingForceChapterEmbedding;

  /// Explains the purpose of replacing existing chapter markers during embedding
  ///
  /// In en, this message translates to:
  /// **'Replace existing chapter markers when embedding metadata'**
  String get settingForceChapterEmbeddingDescription;

  /// Label for reloading metadata from an audio item
  ///
  /// In en, this message translates to:
  /// **'Refresh metadata'**
  String get actionRefreshMetadata;

  /// Status shown while a task waits to start
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get statusQueued;

  /// Label for starting metadata embedding in audio files
  ///
  /// In en, this message translates to:
  /// **'Start embedding'**
  String get actionStartEmbedding;

  /// Message shown when the server does not return metadata for an audio item
  ///
  /// In en, this message translates to:
  /// **'The server did not return metadata'**
  String get errorMetadataObjectMissing;

  /// Heading shown while editing a library item
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get headingEditItem;

  /// Label for navigating to the previous item in an editor list
  ///
  /// In en, this message translates to:
  /// **'Previous item'**
  String get actionPreviousItem;

  /// Label for navigating to the next item in an editor list
  ///
  /// In en, this message translates to:
  /// **'Next item'**
  String get actionNextItem;

  /// Confirmation title shown when leaving the chapter editor with unsaved changes
  ///
  /// In en, this message translates to:
  /// **'Save chapter changes?'**
  String get confirmSaveChapterChanges;

  /// Message shown when the chapter editor has unsaved changes
  ///
  /// In en, this message translates to:
  /// **'Your chapter edits have not been saved'**
  String get warningChapterEditsNotSaved;

  /// Label for keeping unsaved chapter changes open
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get actionKeepEditing;

  /// Label for discarding unsaved edits in an editor
  ///
  /// In en, this message translates to:
  /// **'Discard edits'**
  String get actionDiscardEdits;

  /// Label for adding one or more chapter markers
  ///
  /// In en, this message translates to:
  /// **'Add chapters'**
  String get actionAddChapters;

  /// Hint explaining how to insert chapter numbers into generated titles
  ///
  /// In en, this message translates to:
  /// **'Use \'{n}\' for chapter numbers'**
  String get hintChapterTitlePattern;

  /// Example title template used when creating multiple chapter rows
  ///
  /// In en, this message translates to:
  /// **'Chapter \'{n}\''**
  String get chapterTitlePatternExample;

  /// Validation message shown when a required title field is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get errorEnterTitle;

  /// Label for a chapter count entered in a sleep timer or chapter editor
  ///
  /// In en, this message translates to:
  /// **'Number of chapters'**
  String get fieldChapterCount;

  /// Validation message shown when a chapter count is outside the allowed range
  ///
  /// In en, this message translates to:
  /// **'Enter a number from 1 to 5000'**
  String get errorChapterCountRange;

  /// Label for the starting time of a chapter
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get fieldStartTime;

  /// Label for a chapter row using its position in the list
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String fieldChapterNumber(int number);

  /// Hint showing accepted formats for a chapter start time
  ///
  /// In en, this message translates to:
  /// **'HH:MM:SS or seconds'**
  String get hintChapterTimeFormat;

  /// Validation message shown when a chapter start time is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid start time'**
  String get errorValidChapterStart;

  /// Label for the time interval between generated chapters
  ///
  /// In en, this message translates to:
  /// **'Seconds between chapters'**
  String get fieldChapterIntervalSeconds;

  /// Validation message shown when a chapter interval is not positive
  ///
  /// In en, this message translates to:
  /// **'Enter a positive interval'**
  String get errorPositiveInterval;

  /// Dialog title for shifting chapter start times
  ///
  /// In en, this message translates to:
  /// **'Shift chapter times'**
  String get headingShiftChapterTimes;

  /// Prompt shown when shifting selected chapter times
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Shift 1 selected chapter} other{Shift {count} selected chapters}}. The chapter at zero stays in place'**
  String promptShiftSelectedChapters(int count);

  /// Prompt shown when shifting all chapter times
  ///
  /// In en, this message translates to:
  /// **'Shift all chapters after the chapter at zero'**
  String get promptShiftAllChapters;

  /// Example of a positive or negative chapter time shift in seconds
  ///
  /// In en, this message translates to:
  /// **'-10 or 10'**
  String get hintChapterTimeShift;

  /// Validation message shown when a chapter time shift is zero or invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a positive or negative number of seconds'**
  String get errorChapterTimeShiftRequired;

  /// Status shown when a chapter lookup returns no results
  ///
  /// In en, this message translates to:
  /// **'No chapters were found for this ASIN and region'**
  String get statusNoChaptersFoundForSearch;

  /// Error shown when chapter data returned by the lookup cannot be read
  ///
  /// In en, this message translates to:
  /// **'The chapter lookup returned invalid data'**
  String get errorInvalidChapterLookupData;

  /// Summary of found chapters and the current book chapter count
  ///
  /// In en, this message translates to:
  /// **'{foundCount, plural, =1{1 chapter found} other{{foundCount} chapters found}} · Current book {bookCount, plural, =1{1 chapter} other{{bookCount} chapters}}'**
  String chapterLookupSummary(int foundCount, int bookCount);

  /// Comparison between found chapter duration and current book duration
  ///
  /// In en, this message translates to:
  /// **'Found duration {foundDuration}. Book duration {bookDuration}'**
  String chapterDurationComparison(String foundDuration, String bookDuration);

  /// Option to use found chapter titles while keeping existing times
  ///
  /// In en, this message translates to:
  /// **'Apply titles only'**
  String get optionApplyChapterTitlesOnly;

  /// Explains that applying chapter titles does not change existing times
  ///
  /// In en, this message translates to:
  /// **'Keep existing chapter times'**
  String get descriptionKeepChapterTimes;

  /// Label for applying found chapter data to the current draft
  ///
  /// In en, this message translates to:
  /// **'Apply to draft'**
  String get actionApplyToDraft;

  /// Message shown before replacing chapter changes that have not been saved
  ///
  /// In en, this message translates to:
  /// **'This replaces the current chapter draft. Changes take effect when you save'**
  String get warningReplaceChapterDraft;

  /// Confirmation title shown before creating chapters from source audio tracks
  ///
  /// In en, this message translates to:
  /// **'Create chapters from audio tracks?'**
  String get confirmCreateChaptersFromTracks;

  /// Confirmation title shown before replacing unsaved chapter changes
  ///
  /// In en, this message translates to:
  /// **'Replace unsaved chapter edits?'**
  String get confirmReplaceUnsavedChapterEdits;

  /// Confirmation title shown before discarding chapter changes
  ///
  /// In en, this message translates to:
  /// **'Discard chapter edits?'**
  String get confirmDiscardChapterEdits;

  /// Message shown before restoring chapter data from the server
  ///
  /// In en, this message translates to:
  /// **'Restore the chapters currently stored on the server'**
  String get promptRestoreChapterDraft;

  /// Label for confirming that existing content should be replaced
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get actionReplace;

  /// Confirmation shown after chapter changes are saved
  ///
  /// In en, this message translates to:
  /// **'Chapters saved'**
  String get statusChaptersSaved;

  /// Message shown when chapter data changed on the server during editing
  ///
  /// In en, this message translates to:
  /// **'Chapters or audio tracks changed on the server. Reload before saving'**
  String get statusChapterSaveConflict;

  /// Status showing how many chapter rows need attention before saving
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 chapter needs attention} other{{count} chapters need attention}}'**
  String statusChapterErrors(int count);

  /// Status shown when editor changes have not been saved
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get statusUnsavedChanges;

  /// Label for opening chapter editing tools
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get actionChapterTools;

  /// Label for searching an external source for chapter markers
  ///
  /// In en, this message translates to:
  /// **'Find chapters'**
  String get actionFindChapters;

  /// Label for selecting a geographic region
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get fieldRegion;

  /// Status shown while a search request is in progress, including in podcast result tooltips
  ///
  /// In en, this message translates to:
  /// **'Searching…'**
  String get statusSearching;

  /// Label for shifting chapter start times
  ///
  /// In en, this message translates to:
  /// **'Shift times'**
  String get actionShiftTimes;

  /// Label for creating chapter markers from audio tracks
  ///
  /// In en, this message translates to:
  /// **'Use audio tracks'**
  String get actionUseAudioTracks;

  /// Hint for filtering chapter rows by title or number
  ///
  /// In en, this message translates to:
  /// **'Find a chapter by title or number'**
  String get hintSearchChapters;

  /// Accessibility label for selecting every visible chapter row
  ///
  /// In en, this message translates to:
  /// **'Select all visible chapters'**
  String get a11ySelectAllVisibleChapters;

  /// Tooltip status indicating that a chapter row has unsaved changes
  ///
  /// In en, this message translates to:
  /// **'Edited'**
  String get statusEdited;

  /// Hint for entering a chapter title
  ///
  /// In en, this message translates to:
  /// **'Chapter title'**
  String get hintChapterTitle;

  /// Tooltip explaining that chapter preview plays up to 20 seconds and pauses normal playback
  ///
  /// In en, this message translates to:
  /// **'Preview up to 20 seconds. Pauses playback'**
  String get tooltipChapterPreview;

  /// Tooltip label for stopping a chapter preview
  ///
  /// In en, this message translates to:
  /// **'Stop preview'**
  String get actionStopPreview;

  /// Error shown when a chapter preview cannot be played
  ///
  /// In en, this message translates to:
  /// **'Could not preview this chapter'**
  String get errorChapterPreviewUnavailable;

  /// Validation message shown when chapter times cannot be checked against the book duration
  ///
  /// In en, this message translates to:
  /// **'Book duration is unavailable'**
  String get errorBookDurationUnavailable;

  /// Validation message shown when the first chapter does not start at zero
  ///
  /// In en, this message translates to:
  /// **'The first chapter must start at zero'**
  String get errorFirstChapterMustStartAtZero;

  /// Validation message shown when a chapter starts outside the book duration
  ///
  /// In en, this message translates to:
  /// **'Start must be within the book'**
  String get errorChapterStartOutsideBook;

  /// Validation message shown when chapter start times are not in ascending order
  ///
  /// In en, this message translates to:
  /// **'Start times must be in ascending order'**
  String get errorChapterStartsNotAscending;

  /// Tooltip for the menu of actions available on a chapter row
  ///
  /// In en, this message translates to:
  /// **'Chapter actions'**
  String get tooltipChapterActions;

  /// Label for inserting a new chapter after the current row
  ///
  /// In en, this message translates to:
  /// **'Insert chapter below'**
  String get actionInsertChapterBelow;

  /// Label for removing a chapter row from the current draft
  ///
  /// In en, this message translates to:
  /// **'Remove chapter'**
  String get actionRemoveChapter;

  /// Label for removing selected chapter rows from the current draft
  ///
  /// In en, this message translates to:
  /// **'Remove selected'**
  String get actionRemoveSelected;

  /// Accessibility label for selecting a chapter row
  ///
  /// In en, this message translates to:
  /// **'Select chapter {number}'**
  String a11ySelectChapter(int number);

  /// Title of a confirmation dialog shown before changing the active account during playback
  ///
  /// In en, this message translates to:
  /// **'Switch user'**
  String get headingSwitchUser;

  /// Confirmation prompt explaining what happens to unsynced playback progress when changing accounts
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to switch users? Playback progress will be saved locally and synced with the server after the app restarts'**
  String get promptSwitchUserDuringPlayback;

  /// Label for confirming a change from one active account to another
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get actionSwitch;

  /// Label for adding a server user or account and the dialog for creating a user
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get actionAddUser;

  /// Tooltip for opening the account switcher to change or add an account
  ///
  /// In en, this message translates to:
  /// **'Manage users'**
  String get actionManageUsers;

  /// Fallback label shown in the account switcher when no account is active
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get labelUsers;

  /// Error shown when the saved accounts cannot be loaded for the account switcher
  ///
  /// In en, this message translates to:
  /// **'Could not load users'**
  String get errorCouldNotLoadUsers;

  /// Label for starting an available tool or task
  ///
  /// In en, this message translates to:
  /// **'Run'**
  String get actionRun;

  /// Message shown when a server tool or administration page needs an active API connection
  ///
  /// In en, this message translates to:
  /// **'No active API client'**
  String get errorNoActiveApiClient;

  /// Validation message shown when a server tool requires one or more selected libraries
  ///
  /// In en, this message translates to:
  /// **'Select at least one library'**
  String get errorSelectAtLeastOneLibrary;

  /// Name of the operation that retrieves available libraries for server tools
  ///
  /// In en, this message translates to:
  /// **'Loading libraries'**
  String get operationLoadLibraries;

  /// Summary shown after the metadata refresh tool finishes processing libraries and items
  ///
  /// In en, this message translates to:
  /// **'Processed {libraries, plural, =1{1 library} other{{libraries} libraries}} and tagged {tagged, plural, =1{1 item} other{{tagged} items}}. The server reported {updated, plural, =1{1 updated item} other{{updated} updated items}}'**
  String adminMetadataRefreshSummary(int libraries, int tagged, int updated);

  /// Title of the settings page for choosing visible library tabs and their default view
  ///
  /// In en, this message translates to:
  /// **'Library views'**
  String get settingLibraryViews;

  /// Message shown when user-specific settings need an active account
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage user settings'**
  String get promptSignInToManageSettings;

  /// Empty state shown when the server has no libraries available
  ///
  /// In en, this message translates to:
  /// **'No libraries found'**
  String get statusNoLibrariesFound;

  /// Name of the operation that retrieves user settings
  ///
  /// In en, this message translates to:
  /// **'Loading settings'**
  String get operationLoadSettings;

  /// Name of the operation that retrieves the active user
  ///
  /// In en, this message translates to:
  /// **'Loading the user'**
  String get operationLoadUser;

  /// Name of the operation that saves subtitle preferences for a library view
  ///
  /// In en, this message translates to:
  /// **'Saving subtitles for {view}'**
  String operationSaveSubtitlesForView(String view);

  /// Name of the default library type in the library order settings
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get libraryTypeDefault;

  /// Name of the music library type in the library order settings
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get libraryTypeMusic;

  /// Tooltip for changing a library between its available types
  ///
  /// In en, this message translates to:
  /// **'Change type to {type}'**
  String actionChangeLibraryType(String type);

  /// Field group label for choosing subtitle details in library, series, and author settings
  ///
  /// In en, this message translates to:
  /// **'Choose which information is displayed under {view}'**
  String librarySubtitleChooseInfo(String view);

  /// Validation message shown when a custom subtitle selection exceeds its field limit
  ///
  /// In en, this message translates to:
  /// **'Select up to {count, plural, =1{1 field} other{{count} fields}} for custom subtitles'**
  String validationMaxSubtitleFields(int count);

  /// Label for copying unformatted text to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy raw'**
  String get actionCopyRaw;

  /// Label for copying Markdown-formatted content to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copy Markdown'**
  String get actionCopyMarkdown;

  /// Label for exporting the current application logs to a file
  ///
  /// In en, this message translates to:
  /// **'Export logs'**
  String get actionExportLogs;

  /// Tooltip for moving a scrollable list to its beginning
  ///
  /// In en, this message translates to:
  /// **'Scroll to top'**
  String get actionScrollToTop;

  /// Tooltip for moving a scrollable list to its end
  ///
  /// In en, this message translates to:
  /// **'Scroll to bottom'**
  String get actionScrollToBottom;

  /// Empty state or message shown when there are no logs to display, copy, or export
  ///
  /// In en, this message translates to:
  /// **'No logs available'**
  String get statusNoLogsAvailable;

  /// Confirmation shown after application logs are copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Logs copied to clipboard'**
  String get statusLogsCopied;

  /// Confirmation shown after application logs are saved to a file
  ///
  /// In en, this message translates to:
  /// **'Logs exported to {path}'**
  String statusLogsExportedToPath(String path);

  /// Status shown while a file is being exported
  ///
  /// In en, this message translates to:
  /// **'Exporting…'**
  String get statusExporting;

  /// Supporting message shown in the empty application log view
  ///
  /// In en, this message translates to:
  /// **'Logs will appear here as they are generated'**
  String get messageLogsAppearHere;

  /// Number of log entries shown in the application log view
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 entry} other{{count} entries}}'**
  String logEntryCount(int count);

  /// Summary heading included with Markdown-formatted logs copied for sharing
  ///
  /// In en, this message translates to:
  /// **'Logs ({count, plural, =1{1 entry} other{{count} entries}})'**
  String logExportSummary(int count);

  /// Name of the operation that writes application logs to a file
  ///
  /// In en, this message translates to:
  /// **'Exporting logs'**
  String get operationExportLogs;

  /// Label for selecting an available item or location
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get actionChoose;

  /// Label for choosing a folder in a file picker, download settings sheet, or upload flow
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get actionChooseFolder;

  /// Label for selecting files in a file picker or upload flow
  ///
  /// In en, this message translates to:
  /// **'Choose files'**
  String get actionChooseFiles;

  /// Label for restoring the default location in a file or download settings picker
  ///
  /// In en, this message translates to:
  /// **'Use default location'**
  String get actionUseDefaultLocation;

  /// Heading for settings that control which media files are downloaded and when
  ///
  /// In en, this message translates to:
  /// **'Download behavior'**
  String get headingDownloadBehavior;

  /// Label for choosing which media files are downloaded by default
  ///
  /// In en, this message translates to:
  /// **'Download preference'**
  String get settingDownloadPreference;

  /// Supporting text for the default media types selected during downloads
  ///
  /// In en, this message translates to:
  /// **'Choose which media files to download by default'**
  String get settingDownloadPreferenceDescription;

  /// Option that prompts the user to choose media files for each download
  ///
  /// In en, this message translates to:
  /// **'Ask every time'**
  String get optionAskEveryTime;

  /// Option that downloads audiobook audio files without ebook files
  ///
  /// In en, this message translates to:
  /// **'Audiobook only'**
  String get optionAudiobookOnly;

  /// Option that downloads ebook files without audiobook audio files
  ///
  /// In en, this message translates to:
  /// **'Ebook only'**
  String get optionEbookOnly;

  /// Label for downloading every audio file without asking for a selection in settings or the download dialog
  ///
  /// In en, this message translates to:
  /// **'Always download all audio files'**
  String get settingDownloadAllAudioFiles;

  /// Supporting text for downloading every audio file when a book is selected
  ///
  /// In en, this message translates to:
  /// **'Skip audio file selection when downloading books'**
  String get settingDownloadAllAudioFilesDescription;

  /// Confirmation shown after saving a custom download folder
  ///
  /// In en, this message translates to:
  /// **'Download location updated'**
  String get statusDownloadLocationUpdated;

  /// Confirmation shown after restoring the default download folder
  ///
  /// In en, this message translates to:
  /// **'Using default download location'**
  String get statusUsingDefaultDownloadLocation;

  /// Name of the operation that saves a user's download folder preference
  ///
  /// In en, this message translates to:
  /// **'Saving download location'**
  String get operationSaveDownloadLocation;

  /// Heading for settings that control visibility of permission-gated tools
  ///
  /// In en, this message translates to:
  /// **'Permission visibility'**
  String get headingPermissionVisibility;

  /// Label for showing or hiding collection management controls when permitted by the server
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get permissionCollections;

  /// Supporting text for the collection controls visibility setting
  ///
  /// In en, this message translates to:
  /// **'Show controls for creating and editing collections and playlists'**
  String get permissionCollectionsDescription;

  /// Label for showing or hiding item editing tools when permitted by the server
  ///
  /// In en, this message translates to:
  /// **'Edit items'**
  String get permissionEditItems;

  /// Supporting text for the item editing visibility setting
  ///
  /// In en, this message translates to:
  /// **'Show item editing tools such as bulk edit'**
  String get permissionEditItemsDescription;

  /// Label for showing or hiding item deletion controls when permitted by the server
  ///
  /// In en, this message translates to:
  /// **'Delete items'**
  String get permissionDeleteItems;

  /// Supporting text for the item deletion visibility setting
  ///
  /// In en, this message translates to:
  /// **'Show controls for deleting items'**
  String get permissionDeleteItemsDescription;

  /// Label for showing or hiding the chapter editor when permitted by the server
  ///
  /// In en, this message translates to:
  /// **'Edit chapters'**
  String get permissionEditChapters;

  /// Supporting text for the chapter editing visibility setting
  ///
  /// In en, this message translates to:
  /// **'Show the chapter editor'**
  String get permissionEditChaptersDescription;

  /// Supporting text for the upload visibility setting
  ///
  /// In en, this message translates to:
  /// **'Show tools for uploading new items'**
  String get permissionUploadDescription;

  /// Label for showing or hiding metadata matching tools in item editing
  ///
  /// In en, this message translates to:
  /// **'Allow matches and quick matches'**
  String get permissionMatches;

  /// Supporting text for the metadata matching visibility setting
  ///
  /// In en, this message translates to:
  /// **'Show manual match, quick match, and preview tools'**
  String get permissionMatchesDescription;

  /// Reason shown when a tool visibility setting is disabled without item editing permission
  ///
  /// In en, this message translates to:
  /// **'Requires permission to edit items'**
  String get permissionRequiresEditItems;

  /// Reason shown when item deletion visibility is disabled without delete permission
  ///
  /// In en, this message translates to:
  /// **'Requires permission to delete items'**
  String get permissionRequiresDeleteItems;

  /// Reason shown when upload visibility is disabled without upload permission
  ///
  /// In en, this message translates to:
  /// **'Requires permission to upload'**
  String get permissionRequiresUpload;

  /// Instruction shown when one setting depends on another being enabled
  ///
  /// In en, this message translates to:
  /// **'Enable \"{setting}\" first'**
  String promptEnableSettingFirst(String setting);

  /// Heading for the external and local server address fields
  ///
  /// In en, this message translates to:
  /// **'Server endpoints'**
  String get headingServerEndpoints;

  /// Heading for the username and password fields used to update an account
  ///
  /// In en, this message translates to:
  /// **'Account credentials'**
  String get headingAccountCredentials;

  /// Label for the server address used when the device is outside the local network
  ///
  /// In en, this message translates to:
  /// **'External server URL'**
  String get fieldExternalServerUrl;

  /// Label for the server address used when the device is on the local network
  ///
  /// In en, this message translates to:
  /// **'Local server URL'**
  String get fieldLocalServerUrl;

  /// Example local server address hint that can be left empty
  ///
  /// In en, this message translates to:
  /// **'Optional · http://192.168.1.25:13378'**
  String get hintLocalServerUrl;

  /// Validation message shown when the external server address is not a valid URL
  ///
  /// In en, this message translates to:
  /// **'Enter a valid external server URL'**
  String get validationInvalidExternalServerUrl;

  /// Validation message shown when a non-empty local server address is not a valid URL
  ///
  /// In en, this message translates to:
  /// **'Enter a valid local server URL or leave it blank'**
  String get validationInvalidLocalServerUrl;

  /// Validation message shown when a sign-in or user form has an empty username field
  ///
  /// In en, this message translates to:
  /// **'Enter a username'**
  String get validationUsernameRequired;

  /// Validation message shown when an account update needs a password
  ///
  /// In en, this message translates to:
  /// **'Enter your password to update your username or credentials'**
  String get validationPasswordRequiredForCredentialUpdate;

  /// Confirmation shown after the server address or account credentials are saved
  ///
  /// In en, this message translates to:
  /// **'Server settings saved'**
  String get statusServerSettingsSaved;

  /// Supporting text explaining how local and external server addresses are selected
  ///
  /// In en, this message translates to:
  /// **'When a local address is available, the app prefers it and falls back to the external address when needed'**
  String get messageLocalServerPreferred;

  /// Hint explaining when the password field is needed
  ///
  /// In en, this message translates to:
  /// **'Only needed when changing credentials'**
  String get hintPasswordCredentialUpdate;

  /// Supporting text explaining how to keep the current account credentials
  ///
  /// In en, this message translates to:
  /// **'Leave the password empty to keep your current credentials'**
  String get messageEmptyPasswordKeepsCredentials;

  /// Tooltip for revealing a password entered in a secure text field
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get actionShowPassword;

  /// Tooltip for hiding a password entered in a secure text field
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get actionHidePassword;

  /// Error shown when credential validation succeeds without returning account information
  ///
  /// In en, this message translates to:
  /// **'The server did not return account data'**
  String get errorCredentialValidationNoData;

  /// Error shown when new credentials belong to another account already stored on the device
  ///
  /// In en, this message translates to:
  /// **'These credentials belong to a different account. Use Add account instead'**
  String get errorCredentialsForDifferentAccount;

  /// Name of the operation that saves server addresses and account credentials
  ///
  /// In en, this message translates to:
  /// **'Saving server settings'**
  String get operationSaveServerSettings;

  /// Fallback error detail shown when an operation fails without a specific reason
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errorUnknown;

  /// Name of the operation that updates automatic downloads from their rules
  ///
  /// In en, this message translates to:
  /// **'Reconciling smart downloads'**
  String get operationReconcileSmartDownloads;

  /// Label for immediately updating automatic downloads from their rules
  ///
  /// In en, this message translates to:
  /// **'Reconcile now'**
  String get actionReconcileSmartDownloads;

  /// Heading above profiles that automatically manage downloaded media
  ///
  /// In en, this message translates to:
  /// **'Download rules'**
  String get headingDownloadRules;

  /// Empty state shown when no automatic download profiles have been created
  ///
  /// In en, this message translates to:
  /// **'No automatic download rules yet'**
  String get statusNoDownloadRules;

  /// Number of enabled automatic download rules shown in the profile list
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No active rules} =1{1 active rule} other{{count} active rules}}'**
  String smartDownloadRuleCount(int count);

  /// Summary of the source and item limits for an automatic download profile
  ///
  /// In en, this message translates to:
  /// **'{sources, plural, =0{No sources} =1{1 source} other{{sources} sources}} · {items, plural, =1{1 item} other{{items} items}} per source'**
  String smartDownloadProfileSummary(int sources, int items);

  /// Title of a confirmation dialog for removing a saved profile
  ///
  /// In en, this message translates to:
  /// **'Remove profile?'**
  String get headingRemoveProfile;

  /// Confirmation prompt explaining which managed downloads are deleted when a profile is removed
  ///
  /// In en, this message translates to:
  /// **'Remove “{name}” and delete its managed downloads? Downloads shared with another rule will be kept'**
  String smartDownloadRemoveProfilePrompt(String name);

  /// Title of a dialog for creating a saved profile
  ///
  /// In en, this message translates to:
  /// **'New profile'**
  String get headingNewProfile;

  /// Title of a dialog for changing a saved profile
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get headingEditProfile;

  /// Label for the maximum number of items retained from each selected source
  ///
  /// In en, this message translates to:
  /// **'Item count per source (1–150)'**
  String get fieldItemsPerSource;

  /// Label for excluding items older than a chosen number of days
  ///
  /// In en, this message translates to:
  /// **'Maximum age in days (optional)'**
  String get fieldMaximumAgeDays;

  /// Label for an optional limit on storage used by an automatic download profile
  ///
  /// In en, this message translates to:
  /// **'Storage budget ({unit}, optional)'**
  String fieldStorageBudget(String unit);

  /// Label for how long completed books remain managed by an automatic download profile
  ///
  /// In en, this message translates to:
  /// **'Keep finished books for hours'**
  String get fieldKeepFinishedBooksForHours;

  /// Label for selecting the media types included by an automatic download profile
  ///
  /// In en, this message translates to:
  /// **'Download types'**
  String get fieldDownloadTypes;

  /// Option that downloads audiobook files and podcast episodes
  ///
  /// In en, this message translates to:
  /// **'Audiobooks and episodes'**
  String get optionAudiobooksAndEpisodes;

  /// State label shown when a setting or profile is enabled
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get statusEnabled;

  /// Heading above the sources included in an automatic download profile
  ///
  /// In en, this message translates to:
  /// **'Selected sources'**
  String get headingSelectedSources;

  /// Fallback name for a selected automatic download source
  ///
  /// In en, this message translates to:
  /// **'{source} source'**
  String smartDownloadSourceName(String source);

  /// Source option that selects items based on their listening progress
  ///
  /// In en, this message translates to:
  /// **'Download after listening'**
  String get smartDownloadAfterListening;

  /// Suggested name for a newly created automatic download profile
  ///
  /// In en, this message translates to:
  /// **'Offline queue'**
  String get smartDownloadDefaultProfileName;

  /// Title of the settings page for library layout, shelves, subtitles, and update behavior
  ///
  /// In en, this message translates to:
  /// **'Library settings'**
  String get headingLibrarySettings;

  /// Label for checking for yaabsa releases when the app starts
  ///
  /// In en, this message translates to:
  /// **'Check for app updates'**
  String get settingCheckForAppUpdates;

  /// Supporting text explaining that update checks contact GitHub
  ///
  /// In en, this message translates to:
  /// **'Check for newer yaabsa releases when the app starts. This contacts GitHub'**
  String get settingCheckForAppUpdatesDescription;

  /// Introductory text on the tools settings page explaining the purpose and default state of optional tools
  ///
  /// In en, this message translates to:
  /// **'These optional tools extend server features and are disabled by default'**
  String get messageAdditionalToolsInfo;

  /// Heading above links to settings pages for additional tools
  ///
  /// In en, this message translates to:
  /// **'Tool subpages'**
  String get headingToolSubpages;

  /// Title of the tool page for changing path, tag, and genre values
  ///
  /// In en, this message translates to:
  /// **'Path, tag, and genre update'**
  String get headingPathTagGenreUpdate;

  /// Heading above optional tools that are still being evaluated
  ///
  /// In en, this message translates to:
  /// **'Experimental tools'**
  String get headingExperimentalTools;

  /// Title of the page linking to server administration settings
  ///
  /// In en, this message translates to:
  /// **'Admin server settings'**
  String get headingAdminServerSettings;

  /// Heading above administrative settings for a server
  ///
  /// In en, this message translates to:
  /// **'Settings for {server}'**
  String adminSettingsForServer(String server);

  /// Fallback label when the current account has no server address
  ///
  /// In en, this message translates to:
  /// **'Unknown server'**
  String get statusUnknownServer;

  /// Navigation label for server configuration settings
  ///
  /// In en, this message translates to:
  /// **'Server configuration'**
  String get navServerConfiguration;

  /// Navigation label for server backup settings
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get navBackups;

  /// Navigation label for managing server API keys
  ///
  /// In en, this message translates to:
  /// **'API keys'**
  String get navApiKeys;

  /// Navigation label for managing server RSS feeds
  ///
  /// In en, this message translates to:
  /// **'RSS feeds'**
  String get navRssFeeds;

  /// Navigation label for server e-mail and e-reader settings
  ///
  /// In en, this message translates to:
  /// **'E-mail / e-reader'**
  String get navEmailEReader;

  /// Navigation label and section heading for server authentication settings
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get navAuthentication;

  /// Navigation label for server item metadata tools
  ///
  /// In en, this message translates to:
  /// **'Item metadata utilities'**
  String get navItemMetadataUtils;

  /// Navigation label for server library statistics
  ///
  /// In en, this message translates to:
  /// **'Library statistics'**
  String get navLibraryStats;

  /// Supporting text for the general caching settings page link
  ///
  /// In en, this message translates to:
  /// **'Configure response caching and speedup mode'**
  String get messageCachingGeneral;

  /// Supporting text for the route cache rules page link
  ///
  /// In en, this message translates to:
  /// **'Choose cache behavior for server API routes'**
  String get messageCacheRouteRules;

  /// Navigation label and heading for cache rules that control API route behavior
  ///
  /// In en, this message translates to:
  /// **'Route rules'**
  String get navCacheRouteRules;

  /// Disabled reason shown when cache options require caching to be enabled
  ///
  /// In en, this message translates to:
  /// **'Enable caching to change these options'**
  String get permissionCachingRequired;

  /// Warning shown for an aggressive cache rule that may behave differently across devices
  ///
  /// In en, this message translates to:
  /// **'Enabling this may cause unexpected behavior across multiple devices'**
  String get warningCacheMayAffectMultipleDevices;

  /// Heading above sorting preferences for browsing a media library
  ///
  /// In en, this message translates to:
  /// **'Browse settings'**
  String get headingBrowseSettings;

  /// Page title for settings specific to a car integration
  ///
  /// In en, this message translates to:
  /// **'{integration} settings'**
  String headingIntegrationSettings(String integration);

  /// Page title for a media section's settings within a car integration
  ///
  /// In en, this message translates to:
  /// **'{integration} {section} settings'**
  String headingIntegrationSectionSettings(String integration, String section);

  /// Navigation label for podcast library settings in car integrations
  ///
  /// In en, this message translates to:
  /// **'Podcast library'**
  String get navPodcastLibrary;

  /// Label for grouping long car integration lists alphabetically
  ///
  /// In en, this message translates to:
  /// **'Group long lists by first letter'**
  String get settingGroupListsByFirstLetter;

  /// Supporting text explaining alphabetical grouping in a car integration
  ///
  /// In en, this message translates to:
  /// **'Group entries alphabetically for easier browsing in long {integration} lists'**
  String settingGroupListsByFirstLetterDescription(String integration);

  /// Supporting text explaining the selected sort order for car integration browsing
  ///
  /// In en, this message translates to:
  /// **'Choose how {contentType} items are sorted while browsing in {integration}'**
  String settingBrowseSortDescription(String contentType, String integration);

  /// Label for sorting a list in descending order
  ///
  /// In en, this message translates to:
  /// **'Sort descending'**
  String get settingSortDescending;

  /// Supporting text explaining descending sort order for a media list
  ///
  /// In en, this message translates to:
  /// **'Sort {contentType} lists in descending order'**
  String settingSortDescendingDescription(String contentType);

  /// Label for a field that selects how a list is sorted
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get fieldSortBy;

  /// Sort option that orders items by when they were added
  ///
  /// In en, this message translates to:
  /// **'Date added'**
  String get sortDateAdded;

  /// Name of the operation that stores sort preferences
  ///
  /// In en, this message translates to:
  /// **'Saving sort order'**
  String get operationSaveSortOrder;

  /// Heading above controls that import or export application settings
  ///
  /// In en, this message translates to:
  /// **'Transfer settings'**
  String get headingTransferSettings;

  /// Confirmation dialog title shown before restoring settings from a backup
  ///
  /// In en, this message translates to:
  /// **'Import settings?'**
  String get settingsBackupImportPrompt;

  /// Confirmation message describing which saved settings will be restored and how matching accounts are handled
  ///
  /// In en, this message translates to:
  /// **'{appSettings, plural, =0{No app settings} =1{1 app setting} other{{appSettings} app settings}} and {userSettings, plural, =0{no account settings} =1{1 account setting} other{{userSettings} account settings}} will be restored.\n\nAccount settings will be restored only for saved accounts with matching user IDs.{skippedAccounts, plural, =0{} =1{\n\n1 saved account without matching user settings will be skipped.} other{\n\n{skippedAccounts} saved accounts without matching user settings will be skipped.}}\n\nMatching settings will be replaced. Other settings will be kept.\n\nRestart yaabsa after importing to apply all changes.'**
  String settingsImportConfirmation(int appSettings, int userSettings, int skippedAccounts);

  /// Confirmation message shown after a settings backup is exported
  ///
  /// In en, this message translates to:
  /// **'Settings exported'**
  String get statusSettingsExported;

  /// Confirmation message shown after settings are imported and the app should be restarted
  ///
  /// In en, this message translates to:
  /// **'Settings imported. Restart the app to apply all changes'**
  String get statusSettingsImportedRestart;

  /// Message shown when a backup contains no settings for the saved user accounts
  ///
  /// In en, this message translates to:
  /// **'No settings to import for saved accounts with matching user IDs'**
  String get statusNoMatchingSettingsToImport;

  /// Name of the operation that imports or exports settings
  ///
  /// In en, this message translates to:
  /// **'Transferring settings'**
  String get operationTransferSettings;

  /// Page title for managing server user accounts
  ///
  /// In en, this message translates to:
  /// **'Manage users'**
  String get headingManageUsers;

  /// Supporting text for general player settings that link to timeline and queue controls
  ///
  /// In en, this message translates to:
  /// **'Set timeline behavior, seek intervals, and automatic queueing'**
  String get messagePlayerGeneralSettings;

  /// Supporting text for settings that control rewind behavior after pauses
  ///
  /// In en, this message translates to:
  /// **'Choose how playback rewinds after pauses'**
  String get messageSmartRewindSettings;

  /// Supporting text for sleep timer settings that control timer completion and restart
  ///
  /// In en, this message translates to:
  /// **'Set timer end behavior and optional automatic restart'**
  String get messageSleepTimerSettings;

  /// Supporting text for opening audio equalizer controls
  ///
  /// In en, this message translates to:
  /// **'Adjust audio frequency bands'**
  String get messageEqualizerSettings;

  /// Supporting text for player settings that control subtitle display and reading support
  ///
  /// In en, this message translates to:
  /// **'Configure subtitles and reading support'**
  String get messageSubtitleSettings;

  /// Supporting text for settings that control shake gestures
  ///
  /// In en, this message translates to:
  /// **'Configure shake gestures and sensitivity'**
  String get messageShakeControlsSettings;

  /// Availability note shown when a feature needs device motion sensors
  ///
  /// In en, this message translates to:
  /// **'Available on devices with motion sensors'**
  String get statusMotionSensorsRequired;

  /// Status message shown when the current device cannot use shake controls
  ///
  /// In en, this message translates to:
  /// **'Shake controls are not available on this device'**
  String get statusShakeControlsUnavailable;

  /// Heading for player settings related to accessibility and device features
  ///
  /// In en, this message translates to:
  /// **'Accessibility and device'**
  String get settingsCategoryAccessibilityDevice;

  /// Heading above player settings for audio buffering and keeping the screen on
  ///
  /// In en, this message translates to:
  /// **'Buffer and screen'**
  String get settingsCategoryBufferAndScreen;

  /// Heading above settings for the system media notification and its playback controls
  ///
  /// In en, this message translates to:
  /// **'Media notification'**
  String get settingsCategoryMediaNotifications;

  /// Heading above settings for playback startup and background activity
  ///
  /// In en, this message translates to:
  /// **'Startup and background'**
  String get settingsCategoryStartupAndBackground;

  /// Heading above player compatibility settings for audio decoding
  ///
  /// In en, this message translates to:
  /// **'Audio decoding'**
  String get settingsCategoryAudioDecoding;

  /// Supporting text for a media notification option that shows full audiobook progress
  ///
  /// In en, this message translates to:
  /// **'Show full audiobook progress and details'**
  String get optionFullAudiobookProgressDescription;

  /// Supporting text for a media notification option that shows current chapter progress
  ///
  /// In en, this message translates to:
  /// **'Show currently playing chapter progress and details'**
  String get optionCurrentChapterProgressDescription;

  /// Label for enabling index-based seeking for MP3 files in player compatibility settings
  ///
  /// In en, this message translates to:
  /// **'Enable MP3 index seeking'**
  String get settingEnableMp3IndexSeeking;

  /// Supporting text explaining the effect and restart requirement of MP3 index seeking
  ///
  /// In en, this message translates to:
  /// **'Improve seeking compatibility for MP3 files. Seeking may be slower and use more data. Restart the app to apply'**
  String get settingEnableMp3IndexSeekingDescription;

  /// Disabled reason explaining that another setting must be enabled before an option can be changed
  ///
  /// In en, this message translates to:
  /// **'Enable {setting} to change this option'**
  String permissionEnableSettingToChangeOption(String setting);

  /// Disabled reason shown when a control depends on device motion sensors
  ///
  /// In en, this message translates to:
  /// **'Requires a device with motion sensors'**
  String get permissionMotionSensorsRequired;

  /// Status shown while checking whether the device supports vibration feedback
  ///
  /// In en, this message translates to:
  /// **'Checking vibration support'**
  String get statusCheckingVibrationSupport;

  /// Disabled reason shown when device vibration feedback is unavailable
  ///
  /// In en, this message translates to:
  /// **'This device does not support vibration feedback'**
  String get statusVibrationUnavailable;

  /// Slider value showing the shake sensitivity in gravitational acceleration units
  ///
  /// In en, this message translates to:
  /// **'{value} g'**
  String settingShakeSensitivityValue(double value);

  /// Heading above settings that control what happens when a sleep timer expires
  ///
  /// In en, this message translates to:
  /// **'Expiry behavior'**
  String get settingsCategoryTimerExpiry;

  /// Heading above settings for restarting a sleep timer during playback
  ///
  /// In en, this message translates to:
  /// **'Auto restart options'**
  String get settingsCategoryAutoRestart;

  /// Label for choosing whether an automatic timer uses minutes or chapter count
  ///
  /// In en, this message translates to:
  /// **'Timer mode'**
  String get fieldTimerMode;

  /// Supporting text explaining when chapter-based sleep timers can start
  ///
  /// In en, this message translates to:
  /// **'Chapter timers only start for items with chapters'**
  String get settingTimerModeDescription;

  /// Disabled reason shown when a sleep timer option depends on automatic restart
  ///
  /// In en, this message translates to:
  /// **'Enable automatic restart to configure this option'**
  String get permissionAutomaticRestartRequired;

  /// Disabled reason shown when a sleep timer time range must be enabled before its values can be changed
  ///
  /// In en, this message translates to:
  /// **'Enable automatic restart and select a time range to configure this option'**
  String get permissionTimerRangeRequired;

  /// Label for a button that turns on a setting or feature
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get actionEnable;

  /// Heading above settings for player timeline behavior and markers
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get settingsCategoryTimeline;

  /// Supporting text for a timeline option that tracks only the current chapter
  ///
  /// In en, this message translates to:
  /// **'Track the current chapter'**
  String get optionChapterTimelineDescription;

  /// Supporting text for a timeline option that tracks the full audiobook
  ///
  /// In en, this message translates to:
  /// **'Track the full audiobook'**
  String get optionFullAudiobookTimelineDescription;

  /// Supporting text for a timeline option that shows chapter and full audiobook progress
  ///
  /// In en, this message translates to:
  /// **'Track the chapter and full audiobook'**
  String get optionCombinedTimelineDescription;

  /// Supporting text for a timeline option that shows chapter markers
  ///
  /// In en, this message translates to:
  /// **'Show chapter markers'**
  String get optionChapterMarkersDescription;

  /// Supporting text for a timeline option that shows bookmark markers
  ///
  /// In en, this message translates to:
  /// **'Show bookmark markers'**
  String get optionBookmarkMarkersDescription;

  /// Supporting text for a timeline option that shows both chapter and bookmark markers
  ///
  /// In en, this message translates to:
  /// **'Show chapter and bookmark markers'**
  String get optionChapterAndBookmarkMarkersDescription;

  /// Supporting text for a timeline option that hides all markers
  ///
  /// In en, this message translates to:
  /// **'Hide timeline markers'**
  String get optionNoTimelineMarkersDescription;

  /// Heading above settings for controls shown on the player screen
  ///
  /// In en, this message translates to:
  /// **'On-screen controls'**
  String get settingsCategoryOnScreenControls;

  /// Label for choosing transport controls shown on the full player
  ///
  /// In en, this message translates to:
  /// **'Full player transport buttons'**
  String get settingFullPlayerTransportButtons;

  /// Name of the full player used when describing player-specific controls
  ///
  /// In en, this message translates to:
  /// **'full player'**
  String get playerTypeFull;

  /// Name of the mini player used when describing player-specific controls
  ///
  /// In en, this message translates to:
  /// **'mini player'**
  String get playerTypeMini;

  /// Supporting text explaining the available transport button modes
  ///
  /// In en, this message translates to:
  /// **'Choose whether the {playerType} shows timed jumps, item and chapter skips, or both'**
  String settingTransportModeDescription(String playerType);

  /// Title for selecting actions available on the full player
  ///
  /// In en, this message translates to:
  /// **'Full player actions'**
  String get settingFullPlayerActions;

  /// Supporting text for choosing the full player actions
  ///
  /// In en, this message translates to:
  /// **'Choose the actions available in the full player'**
  String get settingFullPlayerActionsDescription;

  /// Label for selecting the action shown on the left side of the player
  ///
  /// In en, this message translates to:
  /// **'Left quick action'**
  String get settingLeftQuickAction;

  /// Supporting text for choosing the left quick action on the minimalistic player
  ///
  /// In en, this message translates to:
  /// **'Choose the action shown at the lower left of the minimalistic player'**
  String get settingLeftQuickActionDescription;

  /// Label for selecting the action shown on the right side of the player
  ///
  /// In en, this message translates to:
  /// **'Right quick action'**
  String get settingRightQuickAction;

  /// Supporting text for choosing the right quick action on the minimalistic player
  ///
  /// In en, this message translates to:
  /// **'Choose the action shown at the lower right of the minimalistic player'**
  String get settingRightQuickActionDescription;

  /// Label for choosing transport controls shown on the mini player
  ///
  /// In en, this message translates to:
  /// **'Mini player transport buttons'**
  String get settingMiniPlayerTransportButtons;

  /// Title for selecting actions available from the mini player menu
  ///
  /// In en, this message translates to:
  /// **'Mini player actions'**
  String get settingMiniPlayerActions;

  /// Supporting text for choosing actions in the mini player menu
  ///
  /// In en, this message translates to:
  /// **'Choose the actions available from the mini player menu'**
  String get settingMiniPlayerActionsDescription;

  /// Heading above settings for the player fast forward and rewind intervals
  ///
  /// In en, this message translates to:
  /// **'Skip intervals'**
  String get settingsCategorySkipIntervals;

  /// Heading above settings for playback behavior and automatic queueing
  ///
  /// In en, this message translates to:
  /// **'Playback behavior'**
  String get settingsCategoryPlaybackBehavior;

  /// Label for starting playback from saved local progress
  ///
  /// In en, this message translates to:
  /// **'Start from local progress'**
  String get settingStartPlaybackFromLocalProgress;

  /// Supporting text explaining that playback can start before server progress loads
  ///
  /// In en, this message translates to:
  /// **'Start playback without waiting for server progress'**
  String get settingStartPlaybackFromLocalProgressDescription;

  /// Label for starting a new listening session at midnight
  ///
  /// In en, this message translates to:
  /// **'Restart listening session at midnight'**
  String get settingRestartListeningSessionAtMidnight;

  /// Label for using external media next and previous controls to seek
  ///
  /// In en, this message translates to:
  /// **'Seek with media skip controls'**
  String get settingSeekWithMediaSkipControls;

  /// Supporting text explaining how external media skip controls behave when seeking is enabled
  ///
  /// In en, this message translates to:
  /// **'Use external media next and previous controls to seek by the configured intervals'**
  String get settingSeekWithMediaSkipControlsDescription;

  /// Confirmation dialog title shown before changing external media skip behavior
  ///
  /// In en, this message translates to:
  /// **'Use media skip controls to seek?'**
  String get confirmSeekWithMediaSkipControlsTitle;

  /// Confirmation message describing how external media controls behave when seeking is enabled
  ///
  /// In en, this message translates to:
  /// **'This changes how yaabsa handles external media controls, such as Bluetooth headset buttons and media keyboard shortcuts. Next and previous controls will seek by the configured intervals instead of skipping chapters or queue items.\n\nButtons in yaabsa keep their normal skip behavior. This setting affects external media controls only.'**
  String get confirmSeekWithMediaSkipControls;

  /// Label for playing quiet background audio to help keep connected devices active
  ///
  /// In en, this message translates to:
  /// **'Prevent word clipping'**
  String get settingPreventWordClipping;

  /// Supporting text explaining how background audio helps connected playback devices
  ///
  /// In en, this message translates to:
  /// **'Play quiet background audio to help connected devices stay active'**
  String get settingPreventWordClippingDescription;

  /// Label for automatically skipping silent gaps during playback
  ///
  /// In en, this message translates to:
  /// **'Skip silence'**
  String get settingSkipSilence;

  /// Supporting text explaining silence skipping during playback
  ///
  /// In en, this message translates to:
  /// **'Automatically skip silent gaps during playback'**
  String get settingSkipSilenceDescription;

  /// Label for choosing when loop and shuffle controls appear in the player
  ///
  /// In en, this message translates to:
  /// **'Show loop and shuffle controls'**
  String get settingShowPlayerLoopShuffle;

  /// Option that limits a setting or feature to music libraries
  ///
  /// In en, this message translates to:
  /// **'Music only'**
  String get optionMusicOnly;

  /// Supporting text for hiding loop and shuffle controls in the player
  ///
  /// In en, this message translates to:
  /// **'Never show loop and shuffle controls'**
  String get optionLoopShuffleHiddenDescription;

  /// Supporting text for showing loop and shuffle controls only in music libraries
  ///
  /// In en, this message translates to:
  /// **'Show loop and shuffle controls only for music libraries'**
  String get optionLoopShuffleMusicOnlyDescription;

  /// Supporting text for always showing loop and shuffle controls in the player
  ///
  /// In en, this message translates to:
  /// **'Always show loop and shuffle controls'**
  String get optionLoopShuffleAlwaysDescription;

  /// Heading above settings for resuming playback when a Bluetooth device connects
  ///
  /// In en, this message translates to:
  /// **'Auto resume'**
  String get settingsCategoryAutoResume;

  /// Label for automatically resuming playback when connecting a Bluetooth audio device
  ///
  /// In en, this message translates to:
  /// **'Auto resume on Bluetooth'**
  String get settingAutoResumeOnBluetooth;

  /// Supporting text explaining automatic playback resume on Bluetooth connection
  ///
  /// In en, this message translates to:
  /// **'Automatically resume playback when a Bluetooth audio device connects'**
  String get settingAutoResumeOnBluetoothDescription;

  /// Label for limiting Bluetooth playback resume to selected devices
  ///
  /// In en, this message translates to:
  /// **'Only selected Bluetooth devices'**
  String get settingOnlySelectedBluetoothDevices;

  /// Supporting text for selecting paired Bluetooth devices that can resume playback
  ///
  /// In en, this message translates to:
  /// **'Choose which paired Bluetooth devices can resume playback'**
  String get settingOnlySelectedBluetoothDevicesDescription;

  /// Label for the list of Bluetooth audio devices available for automatic playback resume
  ///
  /// In en, this message translates to:
  /// **'Bluetooth audio devices'**
  String get fieldBluetoothAudioDevices;

  /// Empty state shown when no paired Bluetooth audio devices can be selected
  ///
  /// In en, this message translates to:
  /// **'No paired Bluetooth audio devices found'**
  String get statusNoBluetoothAudioDevices;

  /// Status shown while paired Bluetooth audio devices are being loaded
  ///
  /// In en, this message translates to:
  /// **'Loading paired Bluetooth audio devices'**
  String get statusLoadingBluetoothAudioDevices;

  /// Error shown when Bluetooth permission is missing while loading audio devices
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permission is required to list audio devices'**
  String get errorBluetoothPermissionRequired;

  /// Heading above settings for the player layout, preset, cover size, and colors
  ///
  /// In en, this message translates to:
  /// **'Player appearance'**
  String get settingsCategoryPlayerAppearance;

  /// Label for choosing how the full player arranges its components
  ///
  /// In en, this message translates to:
  /// **'Full player layout'**
  String get settingFullPlayerLayout;

  /// Supporting text explaining full player layout choices
  ///
  /// In en, this message translates to:
  /// **'Choose how the full player arranges its components'**
  String get settingFullPlayerLayoutDescription;

  /// Supporting text for adapting the player layout to the available screen space
  ///
  /// In en, this message translates to:
  /// **'Adapt the selected preset to the available screen space'**
  String get optionAdaptiveLayoutDescription;

  /// Supporting text for using a saved custom player component layout
  ///
  /// In en, this message translates to:
  /// **'Use the saved component grid'**
  String get optionCustomLayoutDescription;

  /// Label for choosing controls shown by the adaptive player layout
  ///
  /// In en, this message translates to:
  /// **'Adaptive preset'**
  String get settingAdaptivePreset;

  /// Supporting text explaining the adaptive player presets
  ///
  /// In en, this message translates to:
  /// **'Choose the controls shown by the adaptive player'**
  String get settingAdaptivePresetDescription;

  /// Supporting text for the adaptive player preset that shows the full action bar
  ///
  /// In en, this message translates to:
  /// **'Show configured actions in a bottom action bar on mobile'**
  String get optionAdaptivePresetFullDescription;

  /// Supporting text for the minimalistic adaptive player preset
  ///
  /// In en, this message translates to:
  /// **'Show two quick actions'**
  String get optionAdaptivePresetMinimalisticDescription;

  /// Supporting text for matching artwork size to the selected adaptive preset
  ///
  /// In en, this message translates to:
  /// **'Use the size associated with the selected preset'**
  String get optionCoverSizeAutomaticDescription;

  /// Supporting text for using compact artwork in the adaptive player
  ///
  /// In en, this message translates to:
  /// **'Use the smaller artwork size'**
  String get optionCoverSizeCompactDescription;

  /// Supporting text for using large artwork in the adaptive player
  ///
  /// In en, this message translates to:
  /// **'Use the larger artwork size'**
  String get optionCoverSizeLargeDescription;

  /// Heading above settings for player behavior during calls and other audio interruptions
  ///
  /// In en, this message translates to:
  /// **'Audio interruptions'**
  String get settingsCategoryAudioInterruptions;

  /// Label for choosing whether playback pauses or lowers volume during an interruption
  ///
  /// In en, this message translates to:
  /// **'During interruptions'**
  String get settingInterruptionBehavior;

  /// Supporting text explaining player behavior during audio interruptions
  ///
  /// In en, this message translates to:
  /// **'Choose whether playback pauses or lowers its volume during calls or notifications'**
  String get settingInterruptionBehaviorDescription;

  /// Label for lowering playback volume during an interruption
  ///
  /// In en, this message translates to:
  /// **'Lower volume'**
  String get playbackLowerVolume;

  /// Supporting text for lowering playback volume during an audio interruption
  ///
  /// In en, this message translates to:
  /// **'Lower playback volume'**
  String get optionLowerPlaybackVolumeDescription;

  /// Summary below an action list title showing its description and how many actions are enabled
  ///
  /// In en, this message translates to:
  /// **'{description}\n{count, plural, =1{1 action shown} other{{count} actions shown}}'**
  String playerActionSelectionSummary(String description, int count);

  /// Instructions shown above a list for selecting and ordering player actions
  ///
  /// In en, this message translates to:
  /// **'Choose visible actions and drag them into the preferred order'**
  String get hintChooseAndOrderActions;

  /// Hint shown beside a drag handle for reordering an action
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get hintDragToReorder;

  /// Title of the settings page for arranging media notification controls
  ///
  /// In en, this message translates to:
  /// **'Media notification layout'**
  String get settingMediaNotificationLayout;

  /// Supporting text for a media control that cycles through playback speeds
  ///
  /// In en, this message translates to:
  /// **'Cycle through available playback speeds'**
  String get playbackSpeedCycleDescription;

  /// Supporting text for a media control that stops playback and closes its notification
  ///
  /// In en, this message translates to:
  /// **'Stop playback and close the notification'**
  String get playbackStopNotificationDescription;

  /// Supporting text for a media control that skips to the next chapter
  ///
  /// In en, this message translates to:
  /// **'Skip to the next chapter'**
  String get playbackNextChapterDescription;

  /// Supporting text for a media control that returns to the previous chapter
  ///
  /// In en, this message translates to:
  /// **'Go back to the previous chapter'**
  String get playbackPreviousChapterDescription;

  /// Label for a control that moves to another page of media notification actions
  ///
  /// In en, this message translates to:
  /// **'Switch page'**
  String get actionSwitchPage;

  /// Supporting text explaining that a control opens the next page of notification actions
  ///
  /// In en, this message translates to:
  /// **'Switch to the next page of notification controls'**
  String get actionSwitchPageDescription;

  /// Bottom sheet title for choosing an action for a media notification button slot
  ///
  /// In en, this message translates to:
  /// **'Select an action for slot {slot}'**
  String notificationSelectActionForSlot(int slot);

  /// Message shown for a media notification button slot without an assigned action
  ///
  /// In en, this message translates to:
  /// **'Empty. Tap to assign an action'**
  String get statusEmptyActionSlot;

  /// Note that media notification controls can appear differently across Android devices
  ///
  /// In en, this message translates to:
  /// **'This layout may look different across Android versions and devices'**
  String get statusNotificationLayoutMayVary;

  /// Warning title shown when multiple notification pages need a page switching control
  ///
  /// In en, this message translates to:
  /// **'Add a switch page action'**
  String get warningSwitchPageActionRequiredTitle;

  /// Warning explaining that a page switching action is needed when notification controls use multiple pages
  ///
  /// In en, this message translates to:
  /// **'With multiple pages, add a {action} button so you can move between them'**
  String warningSwitchPageActionRequired(String action);

  /// Heading above controls for selecting and managing media notification pages
  ///
  /// In en, this message translates to:
  /// **'Notification pages'**
  String get headingNotificationPages;

  /// Label for adding another page of media notification controls
  ///
  /// In en, this message translates to:
  /// **'Add page'**
  String get actionAddPage;

  /// Label for selecting a numbered page of media notification controls
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String notificationPageNumber(int number);

  /// Heading above controls for arranging buttons on a notification page
  ///
  /// In en, this message translates to:
  /// **'Arrange buttons on page {number}'**
  String notificationArrangeButtonsPage(int number);

  /// Label for a numbered media notification button slot
  ///
  /// In en, this message translates to:
  /// **'Slot {number}'**
  String notificationSlotNumber(int number);

  /// Display label for the debug logging level in settings
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get logLevelDebug;

  /// Display label for the informational logging level in settings
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get logLevelInfo;

  /// Display label for the error logging level in settings
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get logLevelError;

  /// Supporting text explaining that debug level includes detailed troubleshooting logs
  ///
  /// In en, this message translates to:
  /// **'Detailed troubleshooting logs'**
  String get logLevelDebugDescription;

  /// Supporting text explaining that info level includes operation events
  ///
  /// In en, this message translates to:
  /// **'Informational events about operations'**
  String get logLevelInfoDescription;

  /// Supporting text explaining that warning level includes potentially problematic events
  ///
  /// In en, this message translates to:
  /// **'Warnings for potentially problematic events'**
  String get logLevelWarningDescription;

  /// Supporting text explaining that error level includes critical errors and failures
  ///
  /// In en, this message translates to:
  /// **'Critical errors and failures'**
  String get logLevelErrorDescription;

  /// Label for enabling audio equalizer processing
  ///
  /// In en, this message translates to:
  /// **'Enable equalizer'**
  String get settingEnableEqualizer;

  /// Message shown when the current platform does not support the equalizer
  ///
  /// In en, this message translates to:
  /// **'Equalizer is not available on this device'**
  String get errorEqualizerUnavailableOnDevice;

  /// Status shown when the equalizer setting is turned off
  ///
  /// In en, this message translates to:
  /// **'Equalizer is disabled'**
  String get statusEqualizerDisabled;

  /// Prompt shown when equalizer controls are hidden until the setting is enabled
  ///
  /// In en, this message translates to:
  /// **'Enable the equalizer above to adjust its bands during playback'**
  String get promptEnableEqualizerToAdjustBands;

  /// Status shown when the equalizer cannot be applied to the current audio session
  ///
  /// In en, this message translates to:
  /// **'Equalizer unavailable'**
  String get statusEqualizerUnavailable;

  /// Explanation shown when equalizer settings cannot be applied but playback continues
  ///
  /// In en, this message translates to:
  /// **'This device could not apply the equalizer to the current audio session. Playback will continue without it and the equalizer will be retried during a later session.'**
  String get messageEqualizerWillRetry;

  /// Empty state shown when equalizer settings need active playback
  ///
  /// In en, this message translates to:
  /// **'No active playback session'**
  String get statusNoActivePlaybackSession;

  /// Prompt shown when no active playback session is available for equalizer adjustment
  ///
  /// In en, this message translates to:
  /// **'Start playing an item to configure the equalizer band gains'**
  String get promptStartPlaybackToConfigureEqualizer;

  /// Name of the operation that retrieves audio equalizer settings
  ///
  /// In en, this message translates to:
  /// **'Loading equalizer parameters'**
  String get operationLoadEqualizerParameters;

  /// Empty state shown when the audio device exposes no equalizer bands
  ///
  /// In en, this message translates to:
  /// **'No equalizer bands found'**
  String get statusNoEqualizerBands;

  /// Label for choosing a predefined equalizer profile
  ///
  /// In en, this message translates to:
  /// **'Equalizer preset'**
  String get settingEqualizerPreset;

  /// Name of the equalizer preset that applies no gain changes
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get equalizerPresetFlat;

  /// Name of the equalizer preset tuned for spoken audio
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get equalizerPresetNarration;

  /// Name of the equalizer preset for classical music
  ///
  /// In en, this message translates to:
  /// **'Classical'**
  String get equalizerPresetClassical;

  /// Name of the equalizer preset for dance music
  ///
  /// In en, this message translates to:
  /// **'Dance'**
  String get equalizerPresetDance;

  /// Name of the equalizer preset for heavy metal music
  ///
  /// In en, this message translates to:
  /// **'Heavy metal'**
  String get equalizerPresetHeavyMetal;

  /// Name of the equalizer preset for rock music
  ///
  /// In en, this message translates to:
  /// **'Rock'**
  String get equalizerPresetRock;

  /// Title of a dialog for adding an automatic download source
  ///
  /// In en, this message translates to:
  /// **'Add source'**
  String get headingAddSource;

  /// Label for selecting one library
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get fieldLibrary;

  /// Label for choosing the kind of source used by an automatic download rule
  ///
  /// In en, this message translates to:
  /// **'Source type'**
  String get fieldSourceType;

  /// Label for selecting the listening condition that triggers an automatic download
  ///
  /// In en, this message translates to:
  /// **'Download when'**
  String get fieldDownloadTrigger;

  /// Label for the listened percentage of a book
  ///
  /// In en, this message translates to:
  /// **'Book progress (%)'**
  String get fieldBookProgress;

  /// Label for the number of minutes listened before an automatic download
  ///
  /// In en, this message translates to:
  /// **'Minutes listened'**
  String get fieldMinutesListened;

  /// Validation message for a whole number that must fall within a range
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from {minimum} to {maximum}'**
  String errorWholeNumberRange(int minimum, int maximum);

  /// Supporting text explaining that the listening trigger uses playback on the current device
  ///
  /// In en, this message translates to:
  /// **'Counts only playback on this device'**
  String get smartDownloadCurrentDeviceListeningDescription;

  /// Error shown when automatic download sources cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load all sources. Retry'**
  String get errorLoadSmartDownloadSources;

  /// Hint for finding a podcast or series source
  ///
  /// In en, this message translates to:
  /// **'Search sources'**
  String get searchSources;

  /// Error shown when a source search fails
  ///
  /// In en, this message translates to:
  /// **'Source search failed. Try a different search term'**
  String get errorSearchSources;

  /// Book progress threshold shown in an automatic download source name
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String smartDownloadProgressThreshold(int percent);

  /// Title of the download type dialog for one selected book
  ///
  /// In en, this message translates to:
  /// **'Download book'**
  String get headingDownloadBook;

  /// Title of the download type dialog for multiple selected books
  ///
  /// In en, this message translates to:
  /// **'Download selected books'**
  String get headingDownloadSelectedBooks;

  /// Option to download both audio and ebook files
  ///
  /// In en, this message translates to:
  /// **'Audiobook and ebook'**
  String get optionAudiobookAndEbook;

  /// Option to reuse the selected download type in future dialogs
  ///
  /// In en, this message translates to:
  /// **'Remember my choice'**
  String get optionRememberDownloadChoice;

  /// Title of a dialog for choosing which audiobook files to download
  ///
  /// In en, this message translates to:
  /// **'Download audio files'**
  String get headingDownloadAudioFiles;

  /// Description of the option to download every audio file in an audiobook
  ///
  /// In en, this message translates to:
  /// **'Download the entire audiobook'**
  String get downloadAllAudioFilesDescription;

  /// Description of the option to download a chosen number of audio files
  ///
  /// In en, this message translates to:
  /// **'Choose how many files to download from the current file'**
  String get downloadCustomAudioFilesDescription;

  /// Description of the option to download audio files starting at the current file
  ///
  /// In en, this message translates to:
  /// **'Download earlier files after the last file'**
  String get downloadFromCurrentAudioFileDescription;

  /// Label for the number of audio files to download
  ///
  /// In en, this message translates to:
  /// **'Number of files'**
  String get fieldAudioFileCount;

  /// Helper text explaining that a chosen audio file count includes the current file
  ///
  /// In en, this message translates to:
  /// **'Includes the current file'**
  String get downloadAudioFileCountIncludesCurrent;

  /// Heading for the panel that lists background task activity
  ///
  /// In en, this message translates to:
  /// **'Task activity'**
  String get headingTaskActivity;

  /// Action for clearing completed entries from the task activity panel
  ///
  /// In en, this message translates to:
  /// **'Clear completed activity'**
  String get actionClearCompleted;

  /// Status showing the number of background tasks currently running
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No tasks are currently running} =1{1 task running} other{{count} tasks running}}'**
  String taskRunningCount(int count);

  /// Empty state shown before any background task has been recorded
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get statusNoTasksYet;

  /// Task title shown while metadata is being embedded in audio files
  ///
  /// In en, this message translates to:
  /// **'Embedding metadata'**
  String get taskEmbeddingMetadata;

  /// Task title shown while an audiobook is being encoded as M4B
  ///
  /// In en, this message translates to:
  /// **'Encoding M4B'**
  String get taskEncodingM4b;

  /// Task title shown while a library scan is running
  ///
  /// In en, this message translates to:
  /// **'Scanning library'**
  String get taskScanningLibrary;

  /// Task title shown while metadata is being matched for library items
  ///
  /// In en, this message translates to:
  /// **'Matching library items'**
  String get taskMatchingLibraryItems;

  /// Task title shown while a single library item is being scanned
  ///
  /// In en, this message translates to:
  /// **'Scanning item'**
  String get taskScanningItem;

  /// Fallback title for a background task without a display name
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get taskGeneric;

  /// Number of items added in a library scan summary
  ///
  /// In en, this message translates to:
  /// **'Added {count}'**
  String taskScanAddedCount(int count);

  /// Number of items updated in a library scan summary
  ///
  /// In en, this message translates to:
  /// **'Updated {count}'**
  String taskScanUpdatedCount(int count);

  /// Number of missing items in a library scan summary
  ///
  /// In en, this message translates to:
  /// **'Missing {count}'**
  String taskScanMissingCount(int count);

  /// Elapsed duration shown in a library scan summary
  ///
  /// In en, this message translates to:
  /// **'Elapsed {duration}'**
  String taskScanElapsed(String duration);

  /// Number of files remaining in the active download queue
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file remaining} other{{count} files remaining}}'**
  String downloadRemainingFileCount(int count);

  /// Error shown when the active download queue cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load active downloads'**
  String get errorCouldNotLoadActiveDownloads;

  /// Empty state shown when no downloads are currently active
  ///
  /// In en, this message translates to:
  /// **'No active downloads'**
  String get statusNoActiveDownloads;

  /// Heading for the list of active downloads
  ///
  /// In en, this message translates to:
  /// **'Downloads in progress'**
  String get headingDownloadsInProgress;

  /// Action for canceling an active download
  ///
  /// In en, this message translates to:
  /// **'Cancel download'**
  String get actionCancelDownload;

  /// Status shown after a named download is canceled
  ///
  /// In en, this message translates to:
  /// **'Canceled {name}'**
  String statusDownloadCanceledNamed(String name);

  /// Error shown when a named download cannot be canceled
  ///
  /// In en, this message translates to:
  /// **'Could not cancel {name}'**
  String errorCancelDownloadNamed(String name);

  /// Error shown when an active download cannot be canceled
  ///
  /// In en, this message translates to:
  /// **'Could not cancel download'**
  String get errorCancelDownload;

  /// Status label combined with a localized progress percentage
  ///
  /// In en, this message translates to:
  /// **'{status} · {progress}'**
  String statusWithProgress(String status, String progress);

  /// Title of an error dialog for a failed download operation
  ///
  /// In en, this message translates to:
  /// **'Download error'**
  String get headingDownloadError;

  /// Status shown while an operation is waiting to retry
  ///
  /// In en, this message translates to:
  /// **'Retrying'**
  String get statusRetrying;

  /// Status shown when playback, a download, or another task is paused, including playback history events
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get statusPaused;

  /// Status shown when the requested item or file cannot be found
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get statusNotFound;

  /// Navigation label for the listening statistics destination
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get navStats;

  /// Label for the app settings destination in navigation and settings page titles
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Label for the issues destination and a filter that shows library items with issues
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get navIssues;

  /// Title of a confirmation shown when leaving an active upload page
  ///
  /// In en, this message translates to:
  /// **'Leave upload page?'**
  String get headingLeaveUploadPage;

  /// Confirmation explaining that leaving the upload page cancels active uploads
  ///
  /// In en, this message translates to:
  /// **'Leaving this page now cancels active uploads. Continue?'**
  String get promptLeaveUploadPageDuringUpload;

  /// Action that dismisses a prompt and keeps the current page open
  ///
  /// In en, this message translates to:
  /// **'Stay here'**
  String get actionStayHere;

  /// Action that leaves the current page
  ///
  /// In en, this message translates to:
  /// **'Leave page'**
  String get actionLeavePage;

  /// Error shown when the Android Auto media center cannot open
  ///
  /// In en, this message translates to:
  /// **'Unable to open the media center. Try Open Car Library in Settings'**
  String get errorUnableToOpenMediaCenter;

  /// Heading for server date, time, and language preferences
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get settingsCategoryRegional;

  /// Heading for server library scanning preferences
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get settingsCategoryScanner;

  /// Heading for server security preferences
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsCategorySecurity;

  /// Label for storing cover images in library item folders
  ///
  /// In en, this message translates to:
  /// **'Store covers with item'**
  String get settingStoreCoversWithItem;

  /// Description of the server setting for storing cover images with library items
  ///
  /// In en, this message translates to:
  /// **'Store cover images in each library item folder. Only one cover file is kept'**
  String get settingStoreCoversWithItemDescription;

  /// Label for storing metadata files in library item folders
  ///
  /// In en, this message translates to:
  /// **'Store metadata with item'**
  String get settingStoreMetadataWithItem;

  /// Description of the server setting for storing metadata with library items
  ///
  /// In en, this message translates to:
  /// **'Store metadata files in each library item folder'**
  String get settingStoreMetadataWithItemDescription;

  /// Label for omitting configured prefixes from title sorting
  ///
  /// In en, this message translates to:
  /// **'Ignore prefixes when sorting'**
  String get settingIgnorePrefixesWhenSorting;

  /// Description of the server setting that ignores prefixes when sorting
  ///
  /// In en, this message translates to:
  /// **'Ignore configured prefixes, such as the, when sorting item titles'**
  String get settingIgnorePrefixesWhenSortingDescription;

  /// Label for the list of prefixes omitted from title sorting
  ///
  /// In en, this message translates to:
  /// **'Prefixes to ignore (case insensitive)'**
  String get fieldPrefixesToIgnore;

  /// Validation error shown when the sorting prefix list is empty
  ///
  /// In en, this message translates to:
  /// **'At least one sorting prefix is required'**
  String get errorSortingPrefixRequired;

  /// Label for choosing how the server formats dates
  ///
  /// In en, this message translates to:
  /// **'Date format'**
  String get fieldDateFormat;

  /// Label for choosing how the server formats times
  ///
  /// In en, this message translates to:
  /// **'Time format'**
  String get fieldTimeFormat;

  /// Option for displaying time with a 12-hour clock
  ///
  /// In en, this message translates to:
  /// **'12-hour (AM/PM)'**
  String get optionTimeFormat12Hour;

  /// Option for displaying time with a 24-hour clock
  ///
  /// In en, this message translates to:
  /// **'24-hour'**
  String get optionTimeFormat24Hour;

  /// Name of a language available in the server language preference
  ///
  /// In en, this message translates to:
  /// **'{languageCode, select, ar {Arabic} be {Belarusian} bg {Bulgarian} bn {Bengali} ca {Catalan} cs {Czech} da {Danish} de {German} en_us {English} es {Spanish} et {Estonian} fi {Finnish} fr {French} he {Hebrew} hr {Croatian} it {Italian} ja {Japanese} lt {Lithuanian} hu {Hungarian} ko {Korean} nl {Dutch} no {Norwegian} pl {Polish} pt_br {Portuguese (Brazil)} ru {Russian} sk {Slovak} sl {Slovenian} sv {Swedish} tr {Turkish} uk {Ukrainian} vi_vn {Vietnamese} zh_cn {Chinese (Simplified)} zh_tw {Chinese (Traditional)} other {{languageCode}}}'**
  String serverLanguageName(String languageCode);

  /// Label for extracting subtitles from audiobook folder names
  ///
  /// In en, this message translates to:
  /// **'Parse subtitles'**
  String get settingParseSubtitles;

  /// Description of how subtitle text is recognized in audiobook folder names
  ///
  /// In en, this message translates to:
  /// **'Read subtitle text from folder names separated by \" - \"'**
  String get settingParseSubtitlesDescription;

  /// Label for searching online for missing covers
  ///
  /// In en, this message translates to:
  /// **'Find covers'**
  String get settingFindCovers;

  /// Description of the server option for finding missing covers
  ///
  /// In en, this message translates to:
  /// **'Search online for missing covers. This can extend scan time'**
  String get settingFindCoversDescription;

  /// Label for replacing existing details with matched metadata
  ///
  /// In en, this message translates to:
  /// **'Prefer matched metadata'**
  String get settingPreferMatchedMetadata;

  /// Description of how matched metadata is applied during quick match
  ///
  /// In en, this message translates to:
  /// **'Use matched metadata to replace existing details during quick match'**
  String get settingPreferMatchedMetadataDescription;

  /// Label for watching library folders for file changes
  ///
  /// In en, this message translates to:
  /// **'Automatically scan libraries for changes'**
  String get settingScanLibrariesAutomatically;

  /// Description of automatic library scanning and its restart requirement
  ///
  /// In en, this message translates to:
  /// **'Add or update items after file changes. Requires a server restart'**
  String get settingScanLibrariesAutomaticallyDescription;

  /// Label for the browser origins allowed to access the server
  ///
  /// In en, this message translates to:
  /// **'Allowed CORS origins'**
  String get fieldAllowedCorsOrigins;

  /// Validation error shown when a CORS origin is blank
  ///
  /// In en, this message translates to:
  /// **'Origin cannot be empty'**
  String get errorOriginRequired;

  /// Validation error shown when a CORS origin has no scheme or host
  ///
  /// In en, this message translates to:
  /// **'Origin must include a scheme and host'**
  String get errorOriginSchemeAndHostRequired;

  /// Validation error shown when a CORS origin uses an unsupported scheme
  ///
  /// In en, this message translates to:
  /// **'Only HTTP and HTTPS origins are supported'**
  String get errorOriginHttpHttpsOnly;

  /// Validation error shown when a CORS origin includes extra URL components
  ///
  /// In en, this message translates to:
  /// **'Origin must not include a path, query, fragment, or credentials'**
  String get errorOriginNoPathQueryFragmentOrCredentials;

  /// Label for a file name or path in a table
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get fieldFile;

  /// Label for the date and time an entry was created
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get fieldCreated;

  /// Action for restoring a saved state or backup
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// Heading for server backup storage, schedule, and retention settings
  ///
  /// In en, this message translates to:
  /// **'Backup configuration'**
  String get headingBackupConfiguration;

  /// Summary of the server backup options in the configuration section
  ///
  /// In en, this message translates to:
  /// **'Storage path, schedule, and retention'**
  String get messageBackupConfiguration;

  /// Status shown when the server backup location is not available
  ///
  /// In en, this message translates to:
  /// **'Backup location unavailable'**
  String get statusBackupLocationUnavailable;

  /// Status shown when the backup location is configured outside the app
  ///
  /// In en, this message translates to:
  /// **'Backup location is managed by the server environment'**
  String get statusBackupLocationEnvironmentManaged;

  /// Label for the folder where server backups are stored
  ///
  /// In en, this message translates to:
  /// **'Backup location path'**
  String get fieldBackupLocationPath;

  /// Label for enabling scheduled server backups
  ///
  /// In en, this message translates to:
  /// **'Enable automatic backups'**
  String get settingAutomaticBackupsEnabled;

  /// Label for the schedule expression used for automatic backups
  ///
  /// In en, this message translates to:
  /// **'Cron expression'**
  String get fieldCronExpression;

  /// Label for the number of recent backups retained by the server
  ///
  /// In en, this message translates to:
  /// **'Backups to keep'**
  String get fieldBackupsToKeep;

  /// Label for the maximum size of a server backup
  ///
  /// In en, this message translates to:
  /// **'Maximum backup size ({unit})'**
  String fieldMaximumBackupSize(String unit);

  /// Helper text explaining that a zero backup size limit means unlimited
  ///
  /// In en, this message translates to:
  /// **'Use 0 for unlimited size'**
  String get messageZeroBackupSizeUnlimited;

  /// Validation error shown when the backup path is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a backup path'**
  String get errorBackupPathRequired;

  /// Validation error shown when automatic backups are enabled without a schedule
  ///
  /// In en, this message translates to:
  /// **'Enter a cron expression when automatic backups are enabled'**
  String get errorCronRequired;

  /// Validation error shown when a cron expression has an incorrect number of fields
  ///
  /// In en, this message translates to:
  /// **'Enter a cron expression with five fields'**
  String get errorCronFieldCount;

  /// Validation error shown when the retained backup count is blank
  ///
  /// In en, this message translates to:
  /// **'Enter the number of backups to keep'**
  String get errorBackupsToKeepRequired;

  /// Validation error shown when the maximum backup size is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a maximum backup size'**
  String get errorMaximumBackupSizeRequired;

  /// Validation message for a whole number that must meet a minimum value
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number of at least {minimum}'**
  String errorWholeNumberMinimum(int minimum);

  /// Error shown when the server backup list cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load backups'**
  String get errorLoadBackups;

  /// Status shown after the server backup location is updated
  ///
  /// In en, this message translates to:
  /// **'Backup location updated'**
  String get statusBackupLocationUpdated;

  /// Error shown when the server backup location cannot be updated
  ///
  /// In en, this message translates to:
  /// **'Could not update the backup location'**
  String get errorUpdateBackupLocation;

  /// Status shown after server backup settings are updated
  ///
  /// In en, this message translates to:
  /// **'Backup settings updated'**
  String get statusBackupSettingsUpdated;

  /// Error shown when server backup settings cannot be updated
  ///
  /// In en, this message translates to:
  /// **'Could not update backup settings'**
  String get errorUpdateBackupSettings;

  /// Status shown after a server backup is created
  ///
  /// In en, this message translates to:
  /// **'Backup created successfully'**
  String get statusBackupCreated;

  /// Error shown when the server cannot create a backup
  ///
  /// In en, this message translates to:
  /// **'Could not create backup'**
  String get errorCreateBackup;

  /// Title for the file picker used to choose a server backup archive
  ///
  /// In en, this message translates to:
  /// **'Select backup archive'**
  String get actionSelectBackupArchive;

  /// Error shown when the selected backup file has no accessible local path
  ///
  /// In en, this message translates to:
  /// **'The selected backup file is not available on this device'**
  String get errorBackupFileUnavailable;

  /// Status shown after a server backup file is uploaded
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded successfully'**
  String get statusBackupUploaded;

  /// Error shown when a server backup cannot be uploaded
  ///
  /// In en, this message translates to:
  /// **'Could not upload backup'**
  String get errorUploadBackup;

  /// Error shown when the backup download link cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Could not open the backup download'**
  String get errorOpenBackupDownload;

  /// Error shown when a backup uses a server format that cannot be restored
  ///
  /// In en, this message translates to:
  /// **'This backup uses an unsupported legacy server format'**
  String get errorLegacyBackupUnsupported;

  /// Title of a confirmation shown before restoring a server backup
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get headingRestoreBackup;

  /// Confirmation prompt explaining what restoring a backup replaces
  ///
  /// In en, this message translates to:
  /// **'Restore backup from {date}? This replaces the current server database and metadata cache'**
  String promptRestoreBackup(String date);

  /// Status shown after a server begins restoring a backup
  ///
  /// In en, this message translates to:
  /// **'Backup restore started. Reload the app after the server finishes applying it'**
  String get statusBackupRestoreStarted;

  /// Error shown when the server cannot restore a backup
  ///
  /// In en, this message translates to:
  /// **'Could not restore backup'**
  String get errorRestoreBackup;

  /// Title of a confirmation shown before deleting a server backup
  ///
  /// In en, this message translates to:
  /// **'Delete backup?'**
  String get headingDeleteBackup;

  /// Confirmation prompt explaining the permanent deletion of a backup
  ///
  /// In en, this message translates to:
  /// **'Delete backup from {date}? This action cannot be undone'**
  String promptDeleteBackup(String date);

  /// Status shown after a server backup is deleted
  ///
  /// In en, this message translates to:
  /// **'Backup deleted'**
  String get statusBackupDeleted;

  /// Error shown when a server backup cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'Could not delete backup'**
  String get errorDeleteBackup;

  /// Action for uploading a server backup archive
  ///
  /// In en, this message translates to:
  /// **'Upload backup'**
  String get actionUploadBackup;

  /// Action for creating a server backup
  ///
  /// In en, this message translates to:
  /// **'Create backup'**
  String get actionCreateBackup;

  /// Empty state shown when the server has no saved backups
  ///
  /// In en, this message translates to:
  /// **'No backups found'**
  String get statusNoBackupsFound;

  /// Empty state guidance for creating or uploading a server backup
  ///
  /// In en, this message translates to:
  /// **'Create or upload a backup to protect your Audiobookshelf metadata and database'**
  String get messageBackupProtection;

  /// Prompt shown when an administrator signs in to access server settings
  ///
  /// In en, this message translates to:
  /// **'Sign in with an admin account to continue'**
  String get promptSignInForAdminAccess;

  /// Label for the user who owns a key or saved resource
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get fieldOwner;

  /// Label for the current state of an item in a table
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get fieldStatus;

  /// Label for the date when a key or access grant expires
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get fieldExpires;

  /// Status shown when a key or resource is active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// Status shown when a key or resource is inactive
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// Status shown when a key or access grant has expired
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// Status or option label for a key that has no expiration date
  ///
  /// In en, this message translates to:
  /// **'Never expires'**
  String get statusNeverExpires;

  /// Empty state shown when no API keys match the current view
  ///
  /// In en, this message translates to:
  /// **'No API keys found'**
  String get statusNoApiKeysFound;

  /// Empty state guidance explaining why a server API key may be useful
  ///
  /// In en, this message translates to:
  /// **'Create an API key to allow server integrations and automation clients'**
  String get messageApiKeyPurpose;

  /// Validation error shown when a required name field is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get errorNameRequired;

  /// Validation error shown when a key owner is not selected
  ///
  /// In en, this message translates to:
  /// **'Select an owner'**
  String get errorOwnerRequired;

  /// Validation error shown when expiration is enabled without a number of days
  ///
  /// In en, this message translates to:
  /// **'Enter the expiration in days or disable expiration'**
  String get errorExpirationDaysRequired;

  /// Title of a dialog for creating a server API key
  ///
  /// In en, this message translates to:
  /// **'Create API key'**
  String get headingCreateApiKey;

  /// Example name shown in the API key name field
  ///
  /// In en, this message translates to:
  /// **'Example: Home Assistant integration'**
  String get hintExampleApiKeyName;

  /// Hint for choosing the user who owns a server API key
  ///
  /// In en, this message translates to:
  /// **'Select key owner'**
  String get hintSelectApiKeyOwner;

  /// Label for enabling or disabling an API key
  ///
  /// In en, this message translates to:
  /// **'API key is active'**
  String get settingApiKeyActive;

  /// Description of the effect of disabling an API key
  ///
  /// In en, this message translates to:
  /// **'Inactive keys cannot authenticate API requests'**
  String get settingApiKeyActiveDescription;

  /// Description of how to set an API key expiration
  ///
  /// In en, this message translates to:
  /// **'Turn off to set an expiration in days'**
  String get settingApiKeyNeverExpiresDescription;

  /// Label for the number of days before an API key expires
  ///
  /// In en, this message translates to:
  /// **'Expires in days'**
  String get fieldExpirationDays;

  /// Example value shown in the API key expiration field
  ///
  /// In en, this message translates to:
  /// **'Example: 30'**
  String get hintExampleExpirationDays;

  /// Title of a dialog for changing a server API key
  ///
  /// In en, this message translates to:
  /// **'Edit API key'**
  String get headingEditApiKey;

  /// Label showing the current owner of an API key
  ///
  /// In en, this message translates to:
  /// **'Current owner: {owner}'**
  String apiKeyCurrentOwner(String owner);

  /// Label showing the expiration date of an API key
  ///
  /// In en, this message translates to:
  /// **'Expires: {date}'**
  String apiKeyExpiresAt(String date);

  /// Error shown when server API keys cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load API keys'**
  String get errorLoadApiKeys;

  /// Title shown after a server API key has been created
  ///
  /// In en, this message translates to:
  /// **'API key created'**
  String get headingApiKeyCreated;

  /// Warning that a newly created API key is only displayed once
  ///
  /// In en, this message translates to:
  /// **'Copy this API key now. For security reasons, it is only shown once'**
  String get messageApiKeyShownOnce;

  /// Status shown after an API key is copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'API key copied'**
  String get statusApiKeyCopied;

  /// Message shown when no users can be assigned ownership of an API key
  ///
  /// In en, this message translates to:
  /// **'No eligible users are available to own an API key'**
  String get errorNoEligibleApiKeyOwners;

  /// Message shown when the server has no user accounts
  ///
  /// In en, this message translates to:
  /// **'No server users are available yet'**
  String get statusNoServerUsers;

  /// Status shown after a server API key is created
  ///
  /// In en, this message translates to:
  /// **'API key created successfully'**
  String get statusApiKeyCreated;

  /// Error shown when the server cannot create an API key
  ///
  /// In en, this message translates to:
  /// **'Could not create API key'**
  String get errorCreateApiKey;

  /// Error shown when an administrator tries to edit a root-owned API key
  ///
  /// In en, this message translates to:
  /// **'Only root users can edit API keys owned by root'**
  String get errorRootOwnedApiKeyEditRestricted;

  /// Status shown after a server API key is updated
  ///
  /// In en, this message translates to:
  /// **'API key updated successfully'**
  String get statusApiKeyUpdated;

  /// Error shown when the server cannot update an API key
  ///
  /// In en, this message translates to:
  /// **'Could not update API key'**
  String get errorUpdateApiKey;

  /// Title of a confirmation shown before deleting one API key
  ///
  /// In en, this message translates to:
  /// **'Delete API key?'**
  String get headingDeleteApiKey;

  /// Confirmation prompt naming the API key that will be deleted
  ///
  /// In en, this message translates to:
  /// **'Delete API key \"{name}\"? This action cannot be undone'**
  String promptDeleteApiKey(String name);

  /// Error shown when the server cannot delete an API key
  ///
  /// In en, this message translates to:
  /// **'Could not delete API key'**
  String get errorDeleteApiKey;

  /// Title of a confirmation shown before deleting selected API keys
  ///
  /// In en, this message translates to:
  /// **'Delete selected API keys?'**
  String get headingDeleteSelectedApiKeys;

  /// Confirmation prompt showing how many selected API keys will be deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Delete 1 selected API key? This action cannot be undone} other{Delete {count} selected API keys? This action cannot be undone}}'**
  String promptDeleteSelectedApiKeys(int count);

  /// Status showing how many API keys were deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 API key deleted} other{{count} API keys deleted}}'**
  String statusApiKeysDeleted(int count);

  /// Error showing how many API keys could not be deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Could not delete 1 API key. Check the logs for details} other{Could not delete {count} API keys. Check the logs for details}}'**
  String errorDeleteApiKeysFailed(int count);

  /// Label for a search field that filters server API keys
  ///
  /// In en, this message translates to:
  /// **'Search API keys'**
  String get searchApiKeys;

  /// Hint listing the API key details used for a compact search
  ///
  /// In en, this message translates to:
  /// **'Filter by name or owner'**
  String get filterApiKeysByNameOrOwner;

  /// Hint listing the API key details used for a full search
  ///
  /// In en, this message translates to:
  /// **'Filter by name, owner, or status'**
  String get filterApiKeysByNameOwnerOrStatus;

  /// Action for adding a server API key
  ///
  /// In en, this message translates to:
  /// **'Add API key'**
  String get actionAddApiKey;

  /// Heading for the server permissions assigned to a user
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get headingUserPermissions;

  /// Permission allowing a user to download media
  ///
  /// In en, this message translates to:
  /// **'Can download'**
  String get permissionDownload;

  /// Permission allowing a user to update server content
  ///
  /// In en, this message translates to:
  /// **'Can update'**
  String get permissionUpdate;

  /// Permission allowing a user to delete server content
  ///
  /// In en, this message translates to:
  /// **'Can delete'**
  String get permissionDelete;

  /// Permission allowing a user to upload media
  ///
  /// In en, this message translates to:
  /// **'Can upload'**
  String get permissionUpload;

  /// Permission allowing a user to create e-reader devices
  ///
  /// In en, this message translates to:
  /// **'Can create e-reader devices'**
  String get permissionCreateEreaderDevices;

  /// Permission allowing a user to access explicit media
  ///
  /// In en, this message translates to:
  /// **'Can access explicit content'**
  String get permissionAccessExplicitContent;

  /// Label for the role or category of a user
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// Label for a user's email address
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// Label for the date a user last connected to the server
  ///
  /// In en, this message translates to:
  /// **'Last seen'**
  String get fieldLastSeen;

  /// Display name for a server account role
  ///
  /// In en, this message translates to:
  /// **'{role, select, admin {Admin} root {Root} user {User} guest {Guest} other {{role}}}'**
  String userRoleName(String role);

  /// Status shown when a server user account is disabled
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get statusDisabled;

  /// Fallback shown when a server account has no email address
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get statusNoEmail;

  /// Label showing when a server user account was created
  ///
  /// In en, this message translates to:
  /// **'Created: {date}'**
  String adminUserCreatedDate(String date);

  /// Label showing when a server user last connected
  ///
  /// In en, this message translates to:
  /// **'Last seen: {date}'**
  String adminUserLastSeenDate(String date);

  /// Action for creating a sign-in code for a server user
  ///
  /// In en, this message translates to:
  /// **'Create authentication code'**
  String get actionCreateAuthenticationCode;

  /// Action for disconnecting a server user from OpenID sign-in
  ///
  /// In en, this message translates to:
  /// **'Unlink OpenID'**
  String get actionUnlinkOpenId;

  /// Action for enabling a server user account
  ///
  /// In en, this message translates to:
  /// **'Enable user'**
  String get actionEnableUser;

  /// Action for disabling a server user account
  ///
  /// In en, this message translates to:
  /// **'Disable user'**
  String get actionDisableUser;

  /// Tooltip for changing whether a server user account is enabled
  ///
  /// In en, this message translates to:
  /// **'Enable or disable user'**
  String get actionEnableOrDisableUser;

  /// Tooltip explaining when the server last-seen value changes and what it may not include
  ///
  /// In en, this message translates to:
  /// **'Last seen updates when a user connects through WebSocket. It may not include offline listening sync or third-party clients that do not use WebSocket'**
  String get messageLastSeenDetails;

  /// Empty state shown when a user search returns no matches
  ///
  /// In en, this message translates to:
  /// **'No users match your current search'**
  String get statusNoUsersMatchSearch;

  /// Empty state shown when the server has no user accounts
  ///
  /// In en, this message translates to:
  /// **'No users found on this server'**
  String get statusNoUsersFound;

  /// Empty state guidance for a user search with no matching accounts
  ///
  /// In en, this message translates to:
  /// **'Try a different username, role, or email filter'**
  String get messageTryDifferentUserFilter;

  /// Empty state guidance for creating server users
  ///
  /// In en, this message translates to:
  /// **'Create users to manage access and permissions'**
  String get messageCreateUsersForAccess;

  /// Validation error shown when an email address is invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get errorEmailInvalid;

  /// Validation error shown when a new user has no password
  ///
  /// In en, this message translates to:
  /// **'Enter a password when creating a user'**
  String get errorPasswordRequiredForNewUser;

  /// Message shown when a root account role cannot be edited
  ///
  /// In en, this message translates to:
  /// **'The root account type cannot be changed'**
  String get errorRootAccountTypeLocked;

  /// Label for choosing a server account role
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get fieldAccountType;

  /// Display name for the reserved root account role
  ///
  /// In en, this message translates to:
  /// **'{role} (reserved)'**
  String userRoleReservedName(String role);

  /// Label for enabling or disabling a server user account
  ///
  /// In en, this message translates to:
  /// **'User is active'**
  String get settingUserActive;

  /// Status explaining that the root server account cannot be disabled
  ///
  /// In en, this message translates to:
  /// **'Root account is always active'**
  String get statusRootAccountAlwaysActive;

  /// Description of the effect of disabling a server user account
  ///
  /// In en, this message translates to:
  /// **'Disabled users cannot log in or access content'**
  String get settingUserActiveDescription;

  /// Label for changing a user's password
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// Helper text explaining that a blank new password keeps the current password
  ///
  /// In en, this message translates to:
  /// **'Leave empty to keep the current password'**
  String get promptLeavePasswordEmptyToKeepCurrent;

  /// Title of a dialog for changing a server user
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get headingEditUser;

  /// Heading for the libraries and tags a server user can access
  ///
  /// In en, this message translates to:
  /// **'Library and tag access'**
  String get headingLibraryAndTagAccess;

  /// Permission allowing a user to access every library
  ///
  /// In en, this message translates to:
  /// **'Can access all libraries'**
  String get permissionAccessAllLibraries;

  /// Permission allowing a user to access items with every tag
  ///
  /// In en, this message translates to:
  /// **'Can access all tags'**
  String get permissionAccessAllTags;

  /// Empty state shown when the server has no tags to assign
  ///
  /// In en, this message translates to:
  /// **'No tags available'**
  String get statusNoTagsFound;

  /// Label for treating selected tags as blocked instead of allowed
  ///
  /// In en, this message translates to:
  /// **'Invert selected tags'**
  String get settingInvertSelectedTags;

  /// Description of how inverted tag selection affects a user's access
  ///
  /// In en, this message translates to:
  /// **'Selected tags are blocked instead of allowed'**
  String get settingInvertSelectedTagsDescription;

  /// Error shown when a server user's OpenID connection cannot be removed
  ///
  /// In en, this message translates to:
  /// **'Could not unlink OpenID'**
  String get errorUnlinkOpenId;

  /// Status shown after a server user's OpenID connection is removed
  ///
  /// In en, this message translates to:
  /// **'OpenID link removed'**
  String get statusOpenIdLinkRemoved;

  /// Action for sharing content or a file with another app or person
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// Action for sharing an authentication code as a QR code image
  ///
  /// In en, this message translates to:
  /// **'Share QR code'**
  String get actionShareQrCode;

  /// Action for removing the server key used to protect authentication codes
  ///
  /// In en, this message translates to:
  /// **'Delete authentication code'**
  String get actionDeleteAuthenticationCodeKey;

  /// Title of a confirmation dialog for creating the server key used by authentication codes
  ///
  /// In en, this message translates to:
  /// **'Create authentication code key?'**
  String get titleCreateAuthenticationCodeKey;

  /// Explanation in a confirmation dialog describing where the authentication code key is stored, who can retrieve it, and what it protects
  ///
  /// In en, this message translates to:
  /// **'yaabsa stores a server-specific encryption key in the login message. The key is hidden from browsers, but anyone who can read the public login message can retrieve it. Authentication codes that include protected sign-in data use this key so the username and password cannot be recovered from a leaked code without the key. Rotating the key invalidates existing codes that include protected data.'**
  String get messageCreateAuthenticationCodeKey;

  /// Error shown when the server removes the key while saving authentication settings
  ///
  /// In en, this message translates to:
  /// **'Audiobookshelf did not preserve the authentication code key. No authentication code was created'**
  String get errorAuthenticationCodeKeyNotPreserved;

  /// Status shown after creating the server key for authentication codes
  ///
  /// In en, this message translates to:
  /// **'Authentication code key created'**
  String get statusAuthenticationCodeKeyCreated;

  /// Error shown when an authentication code cannot be created because the active account has no server address
  ///
  /// In en, this message translates to:
  /// **'The active account has no configured server address'**
  String get errorActiveAccountNoServerAddress;

  /// Title of a confirmation dialog for deleting the server key used by authentication codes
  ///
  /// In en, this message translates to:
  /// **'Delete authentication code key?'**
  String get titleDeleteAuthenticationCodeKey;

  /// Explanation in a confirmation dialog describing the effect of deleting the server authentication code key
  ///
  /// In en, this message translates to:
  /// **'Authentication codes use one server-wide key. Deleting it invalidates every authentication code. Existing signed-in accounts are not affected'**
  String get messageDeleteAuthenticationCodeKey;

  /// Status shown when no server key exists to delete
  ///
  /// In en, this message translates to:
  /// **'No authentication code key is configured'**
  String get statusNoAuthenticationCodeKeyConfigured;

  /// Status shown after deleting the server key and invalidating existing authentication codes
  ///
  /// In en, this message translates to:
  /// **'Authentication code key deleted. Existing authentication codes are no longer valid'**
  String get statusAuthenticationCodeKeyDeleted;

  /// Error shown when the server refuses to unlink a user's OpenID sign-in
  ///
  /// In en, this message translates to:
  /// **'Could not unlink OpenID for {username}'**
  String errorUnlinkOpenIdUser(String username);

  /// Status shown after creating a server user account
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get statusUserCreated;

  /// Status shown after saving changes to a server user account
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get statusUserUpdated;

  /// Status shown after enabling a server user account
  ///
  /// In en, this message translates to:
  /// **'User enabled'**
  String get statusUserEnabled;

  /// Status shown after disabling a server user account
  ///
  /// In en, this message translates to:
  /// **'User disabled'**
  String get statusUserDisabled;

  /// Error shown when an administrator tries to delete their currently signed-in account
  ///
  /// In en, this message translates to:
  /// **'You cannot delete the currently signed-in user'**
  String get errorCannotDeleteCurrentUser;

  /// Title of a confirmation dialog for deleting a server user account
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get titleDeleteUser;

  /// Confirmation prompt shown before deleting a server user account
  ///
  /// In en, this message translates to:
  /// **'Delete user \"{username}\"? This cannot be undone'**
  String promptDeleteUser(String username);

  /// Error shown when the server reports that a user account could not be deleted
  ///
  /// In en, this message translates to:
  /// **'Could not delete user {username}'**
  String errorDeleteUserFailed(String username);

  /// Status shown after deleting a server user account
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get statusUserDeleted;

  /// Label for the field used to search server user accounts
  ///
  /// In en, this message translates to:
  /// **'Search users'**
  String get labelSearchUsers;

  /// Hint explaining which account details can be used to filter the user list
  ///
  /// In en, this message translates to:
  /// **'Filter by username, role, or email'**
  String get hintFilterUsers;

  /// Operation name used when reporting an error while loading server users
  ///
  /// In en, this message translates to:
  /// **'Loading users'**
  String get operationLoadUsers;

  /// Operation name used when reporting an error while creating the server authentication code key
  ///
  /// In en, this message translates to:
  /// **'Creating the authentication code key'**
  String get operationCreateAuthenticationCode;

  /// Operation name used when reporting an error while deleting the server authentication code key
  ///
  /// In en, this message translates to:
  /// **'Deleting the authentication code key'**
  String get operationDeleteAuthenticationCode;

  /// Operation name used when reporting an error while unlinking a user's OpenID sign-in
  ///
  /// In en, this message translates to:
  /// **'Unlinking OpenID'**
  String get operationUnlinkOpenId;

  /// Operation name used when reporting an error while creating a server user
  ///
  /// In en, this message translates to:
  /// **'Creating the user'**
  String get operationCreateUser;

  /// Operation name used when reporting an error while editing a server user
  ///
  /// In en, this message translates to:
  /// **'Updating the user'**
  String get operationUpdateUser;

  /// Operation name used when reporting an error while enabling or disabling a server user
  ///
  /// In en, this message translates to:
  /// **'Updating the user status'**
  String get operationUpdateUserStatus;

  /// Operation name used when reporting an error while deleting a server user
  ///
  /// In en, this message translates to:
  /// **'Deleting the user'**
  String get operationDeleteUser;

  /// Introduction in the authentication code dialog explaining what the generated code contains
  ///
  /// In en, this message translates to:
  /// **'Create an authentication code with the server details needed to sign in'**
  String get messageShareAuthenticationCode;

  /// Location label shown beside a server URL that is reachable from outside the local network
  ///
  /// In en, this message translates to:
  /// **'external'**
  String get serverLocationExternal;

  /// Location label shown beside a server URL that is reachable on the local network
  ///
  /// In en, this message translates to:
  /// **'local'**
  String get serverLocationLocal;

  /// Server address with a short label indicating whether it is external or local
  ///
  /// In en, this message translates to:
  /// **'{url} ({location})'**
  String serverUrlLocation(String url, String location);

  /// Switch label for adding the newly assigned password to an authentication code
  ///
  /// In en, this message translates to:
  /// **'Include set password'**
  String get optionIncludeSetPassword;

  /// Description explaining how a newly assigned password in an authentication code is handled
  ///
  /// In en, this message translates to:
  /// **'The user can sign in without typing the password and must choose a new password immediately'**
  String get descriptionIncludedSetPassword;

  /// Switch label for adding configured request headers to an authentication code
  ///
  /// In en, this message translates to:
  /// **'Include custom headers'**
  String get optionIncludeCustomHeaders;

  /// Description showing how many saved request headers will be added to an authentication code
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 saved header will be included} other{{count} saved headers will be included}}'**
  String messageSavedHeadersIncluded(int count);

  /// Validation message shown when the password risk acknowledgement has not been selected
  ///
  /// In en, this message translates to:
  /// **'Acknowledge the password-sharing risk before continuing'**
  String get errorAcknowledgePasswordSharingRisk;

  /// Validation message shown when the custom-header risk acknowledgement has not been selected
  ///
  /// In en, this message translates to:
  /// **'Acknowledge the custom-header risk before continuing'**
  String get errorAcknowledgeCustomHeadersRisk;

  /// Error shown when protected sign-in data is requested but the server authentication code key is unavailable
  ///
  /// In en, this message translates to:
  /// **'A server key is required to include protected sign-in data. Ask an administrator to enable it first'**
  String get errorAuthenticationCodeKeyRequired;

  /// Operation name used when reporting an error while generating an authentication code
  ///
  /// In en, this message translates to:
  /// **'Generating the authentication code'**
  String get operationGenerateAuthenticationCode;

  /// Error shown when the platform cannot share the authentication code QR image
  ///
  /// In en, this message translates to:
  /// **'QR code sharing is unavailable on this platform'**
  String get errorQrCodeSharingUnavailable;

  /// Title shown by the system share sheet when sharing an authentication code
  ///
  /// In en, this message translates to:
  /// **'yaabsa authentication code'**
  String get shareAuthenticationCodeTitle;

  /// Status shown after copying an authentication code to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Authentication code copied'**
  String get statusAuthenticationCodeCopied;

  /// Acknowledgement required before including a temporary password in an authentication code
  ///
  /// In en, this message translates to:
  /// **'I understand that anyone who gets this code can use the temporary password until it is changed or the authentication code key is rotated'**
  String get messagePasswordSharingAcknowledgement;

  /// Acknowledgement required before including custom request headers in an authentication code
  ///
  /// In en, this message translates to:
  /// **'I understand that custom headers may contain secrets or grant server access'**
  String get messageCustomHeadersAcknowledgement;

  /// Instructions shown after generating an authentication code for transferring it to another device
  ///
  /// In en, this message translates to:
  /// **'Scan this code in yaabsa on the other device, or copy the raw authentication code and use Import authentication code on the sign-in screen'**
  String get messageUseAuthenticationCode;

  /// Title in the system share sheet and accessibility label for an authentication code QR image
  ///
  /// In en, this message translates to:
  /// **'yaabsa authentication code QR code'**
  String get semanticsAuthenticationCodeQrCode;

  /// Status shown on a button while an authentication code is being generated
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get statusGenerating;

  /// Error shown when the server does not provide its current logging level
  ///
  /// In en, this message translates to:
  /// **'The server did not return the current log level'**
  String get errorServerLogLevelUnavailable;

  /// Operation name used when reporting an error while loading server logs
  ///
  /// In en, this message translates to:
  /// **'Loading server logs'**
  String get operationLoadServerLogs;

  /// Operation name used when reporting an error while changing the server log level
  ///
  /// In en, this message translates to:
  /// **'Updating the server log level'**
  String get operationUpdateServerLogLevel;

  /// Label for the field that filters the server log list
  ///
  /// In en, this message translates to:
  /// **'Search logs'**
  String get fieldSearchLogs;

  /// Label for choosing the minimum severity displayed in server logs
  ///
  /// In en, this message translates to:
  /// **'Server log level'**
  String get fieldServerLogLevel;

  /// Label for keeping local or server log lists positioned at their newest entries
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll'**
  String get settingLogAutoScroll;

  /// Empty state shown when no server log entries match the current search
  ///
  /// In en, this message translates to:
  /// **'No logs match the current search'**
  String get statusNoLogsMatchSearch;

  /// Localized name of a server log severity level
  ///
  /// In en, this message translates to:
  /// **'{level, select, trace{Trace} debug{Debug} info{Information} warn{Warning} error{Error} other{Unknown}}'**
  String logLevelName(String level);

  /// Validation error shown when a setting requires a positive integer
  ///
  /// In en, this message translates to:
  /// **'Enter a positive whole number'**
  String get errorPositiveWholeNumberRequired;

  /// Label for the server management upload mode control
  ///
  /// In en, this message translates to:
  /// **'Upload mode'**
  String get headingUploadMode;

  /// Explanation shown when the signed-in user lacks permission to upload items
  ///
  /// In en, this message translates to:
  /// **'Upload permission is required'**
  String get messageUploadPermissionRequired;

  /// Explanation shown when upload actions must be enabled before opening upload mode
  ///
  /// In en, this message translates to:
  /// **'Enable upload actions first'**
  String get messageEnableUploadActionsFirst;

  /// Explanation shown when a library must be selected before opening upload mode
  ///
  /// In en, this message translates to:
  /// **'Select a library before opening upload mode'**
  String get messageSelectLibraryBeforeUpload;

  /// Label for choosing the appearance of Android playback notifications
  ///
  /// In en, this message translates to:
  /// **'Live updates'**
  String get settingLiveUpdates;

  /// Description of the live playback notification setting
  ///
  /// In en, this message translates to:
  /// **'Show playback progress in the Android status bar'**
  String get settingLiveUpdatesDescription;

  /// Label for selecting the libraries affected by an administrative tool
  ///
  /// In en, this message translates to:
  /// **'Target libraries'**
  String get fieldTargetLibraries;

  /// Empty state shown when the server has no genres to manage
  ///
  /// In en, this message translates to:
  /// **'No genres available'**
  String get statusNoGenresFound;

  /// Operation name used when reporting an error while loading item metadata tools
  ///
  /// In en, this message translates to:
  /// **'Loading item metadata tools'**
  String get operationLoadMetadataUtilities;

  /// Error shown when a custom metadata provider could not be deleted
  ///
  /// In en, this message translates to:
  /// **'Could not delete the custom metadata provider'**
  String get errorDeleteCustomMetadataProviderFailed;

  /// Tab heading for managing custom metadata sources used by the server
  ///
  /// In en, this message translates to:
  /// **'Custom metadata providers'**
  String get headingCustomMetadataProviders;

  /// Title of a dialog for adding a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Add custom metadata provider'**
  String get headingAddCustomMetadataProvider;

  /// Title of a dialog for changing a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Edit custom metadata provider'**
  String get headingEditCustomMetadataProvider;

  /// Status shown after adding a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Added provider \"{name}\"'**
  String statusCustomMetadataProviderAdded(String name);

  /// Status shown after changing a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Updated provider \"{name}\"'**
  String statusCustomMetadataProviderUpdated(String name);

  /// Title of a confirmation dialog for deleting a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Delete provider?'**
  String get titleDeleteCustomMetadataProvider;

  /// Confirmation message shown before deleting a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Delete custom metadata provider \"{name}\"?'**
  String promptDeleteCustomMetadataProvider(String name);

  /// Status shown after deleting a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Deleted provider \"{name}\"'**
  String statusCustomMetadataProviderDeleted(String name);

  /// Empty state shown when no custom metadata sources are configured
  ///
  /// In en, this message translates to:
  /// **'No custom metadata providers found'**
  String get statusNoCustomMetadataProviders;

  /// Status indicating that a custom metadata source has an authentication header
  ///
  /// In en, this message translates to:
  /// **'Authentication header configured'**
  String get statusAuthHeaderConfigured;

  /// Label for a web address field
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get fieldUrl;

  /// Label for an optional authentication header sent to a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Authentication header value'**
  String get fieldAuthHeaderValue;

  /// Validation error shown when a required custom metadata source or podcast feed URL is missing or invalid
  ///
  /// In en, this message translates to:
  /// **'Enter a valid HTTP or HTTPS URL'**
  String get validationHttpUrlRequired;

  /// Operation name used when reporting an error while adding a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Creating the custom metadata provider'**
  String get operationCreateCustomMetadataProvider;

  /// Operation name used when reporting an error while changing a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Updating the custom metadata provider'**
  String get operationUpdateCustomMetadataProvider;

  /// Operation name used when reporting an error while deleting a custom metadata source
  ///
  /// In en, this message translates to:
  /// **'Deleting the custom metadata provider'**
  String get operationDeleteCustomMetadataProvider;

  /// Title of a dialog for renaming a tag, genre, or other metadata term
  ///
  /// In en, this message translates to:
  /// **'{termType, select, tag{Rename tag} genre{Rename genre} other{Rename term}}'**
  String metadataTermRenameTitle(String termType);

  /// Validation error shown when a metadata term name is unchanged
  ///
  /// In en, this message translates to:
  /// **'Enter a different name'**
  String get errorNameMustChange;

  /// Status showing how many library items were updated after changing a metadata term
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items updated} =1{1 item updated} other{{count} items updated}}'**
  String statusMetadataItemsUpdated(int count);

  /// Status showing how many items were updated when metadata values were merged
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No items updated. Existing values were merged} =1{1 item updated. Existing values were merged} other{{count} items updated. Existing values were merged}}'**
  String statusMetadataItemsMerged(int count);

  /// Title of a confirmation dialog for deleting a tag, genre, or other metadata term
  ///
  /// In en, this message translates to:
  /// **'{termType, select, tag{Delete tag?} genre{Delete genre?} other{Delete term?}}'**
  String metadataTermDeleteTitle(String termType);

  /// Confirmation message shown before removing a metadata term from every library item
  ///
  /// In en, this message translates to:
  /// **'Remove \"{term}\" from all items?'**
  String promptRemoveMetadataTermFromItems(String term);

  /// Fallback error shown when a metadata term could not be renamed
  ///
  /// In en, this message translates to:
  /// **'{termType, select, tag{Could not rename the tag} genre{Could not rename the genre} other{Could not rename the term}}'**
  String errorMetadataTermRenameFailed(String termType);

  /// Fallback error shown when a metadata term could not be deleted
  ///
  /// In en, this message translates to:
  /// **'{termType, select, tag{Could not delete the tag} genre{Could not delete the genre} other{Could not delete the term}}'**
  String errorMetadataTermDeleteFailed(String termType);

  /// Action label and dialog title for splitting combined tag or genre values
  ///
  /// In en, this message translates to:
  /// **'{termType, select, tag{Split tags} genre{Split genres} other{Split terms}}'**
  String metadataSplitTerms(String termType);

  /// Description of how the metadata splitting tool changes tags or genres in selected libraries
  ///
  /// In en, this message translates to:
  /// **'{termType, select, tag{Split combined tag values using the delimiter below and update affected items in the selected libraries} genre{Split combined genre values using the delimiter below and update affected items in the selected libraries} other{Split combined metadata values using the delimiter below and update affected items in the selected libraries}}'**
  String messageSplitMetadataTerms(String termType);

  /// Label for the character used to separate combined metadata values
  ///
  /// In en, this message translates to:
  /// **'Delimiter'**
  String get fieldDelimiter;

  /// Helper text showing how the selected delimiter separates combined metadata values
  ///
  /// In en, this message translates to:
  /// **'Use {delimiter} to split combined values such as Fantasy and Sci-Fi'**
  String messageDelimiterExample(String delimiter);

  /// Validation error shown when the metadata splitting delimiter is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a delimiter'**
  String get errorDelimiterRequired;

  /// Operation name used when reporting an error while splitting tags or genres
  ///
  /// In en, this message translates to:
  /// **'Splitting metadata values'**
  String get operationSplitMetadataTerms;

  /// Result shown after splitting metadata values and updating items across selected libraries
  ///
  /// In en, this message translates to:
  /// **'Split {terms, plural, =0{no composite {termType, select, tag{tag} genre{genre} other{metadata}} values} =1{1 composite {termType, select, tag{tag} genre{genre} other{metadata}} value} other{{terms} composite {termType, select, tag{tag} genre{genre} other{metadata}} values}}, touched {items, plural, =0{no items} =1{1 item} other{{items} items}}, and applied {updates, plural, =0{no updates} =1{1 update} other{{updates} updates}} across {libraries, plural, =0{no libraries} =1{1 library} other{{libraries} libraries}}'**
  String statusMetadataTermsSplit(String termType, int terms, int items, int updates, int libraries);

  /// Summary shown when a multi-select setting has no chosen values
  ///
  /// In en, this message translates to:
  /// **'None selected'**
  String get statusNoneSelected;

  /// Error shown when a settings dropdown has missing or mismatched options
  ///
  /// In en, this message translates to:
  /// **'The options for {label} are invalid'**
  String errorDropdownConfiguration(String label);

  /// Error shown when a settings dropdown default does not match its configured value type
  ///
  /// In en, this message translates to:
  /// **'The default value for {settingKey} has type {type}, which does not match its available options'**
  String errorDropdownDefaultTypeMismatch(String settingKey, String type);

  /// Heading for configuring the order and visibility of audiobook or podcast home tabs
  ///
  /// In en, this message translates to:
  /// **'{mediaType, select, book{Audiobook home tabs} podcast{Podcast home tabs} other{Home tabs}}'**
  String headingHomeNavigationPreferences(String mediaType);

  /// Heading for configuring visible personalized sections on audiobook or podcast home screens
  ///
  /// In en, this message translates to:
  /// **'{mediaType, select, book{Audiobook home sections} podcast{Podcast home sections} other{Home sections}}'**
  String headingPersonalizedShelfPreferences(String mediaType);

  /// Status shown after restoring a settings section to its default values
  ///
  /// In en, this message translates to:
  /// **'{section} reset to defaults'**
  String statusPreferencesReset(String section);

  /// Error shown when trying to hide the last visible home view
  ///
  /// In en, this message translates to:
  /// **'At least one home view must stay enabled'**
  String get errorKeepOneHomeViewEnabled;

  /// Tooltip identifying the current default home view
  ///
  /// In en, this message translates to:
  /// **'Default view'**
  String get statusDefaultView;

  /// Action for making an enabled home view the default destination
  ///
  /// In en, this message translates to:
  /// **'Set as default view'**
  String get actionSetAsDefaultView;

  /// Tooltip explaining that a hidden home view must be enabled before it can be made the default
  ///
  /// In en, this message translates to:
  /// **'Enable this view to set it as default'**
  String get hintEnableViewToSetDefault;

  /// Operation name used when reporting an error while saving settings
  ///
  /// In en, this message translates to:
  /// **'Saving settings'**
  String get operationSaveSettings;

  /// Display name for a theme brightness mode
  ///
  /// In en, this message translates to:
  /// **'{mode, select, light{Light} dark{Dark} amoled{AMOLED} system{System} other{System}}'**
  String themeModeName(String mode);

  /// Display name for a built-in or custom application theme preset
  ///
  /// In en, this message translates to:
  /// **'{preset, select, yaabsa{yaabsa} ember{Ember} moss{Moss} cobalt{Cobalt} rose{Rose} custom{Custom} other{Custom}}'**
  String themePresetName(String preset);

  /// Description of the colors and appearance associated with an application theme preset
  ///
  /// In en, this message translates to:
  /// **'{preset, select, yaabsa{Balanced teal accents with soft contrast} ember{Warm orange highlights and bright surfaces} moss{Natural green tones with a calm look} cobalt{Cool blue accents with crisp contrast} rose{Soft rose highlights} custom{Build a color profile using your preferred accent color} other{Choose a theme color profile}}'**
  String themePresetDescription(String preset);

  /// Heading for choosing light, dark, AMOLED, or system theme behavior
  ///
  /// In en, this message translates to:
  /// **'Theme mode'**
  String get headingThemeMode;

  /// Heading above the available application color themes
  ///
  /// In en, this message translates to:
  /// **'Theme presets'**
  String get headingThemePresets;

  /// Heading for controls that set a custom application theme color
  ///
  /// In en, this message translates to:
  /// **'Custom theme'**
  String get headingCustomTheme;

  /// Label showing the hexadecimal value of the custom theme accent color
  ///
  /// In en, this message translates to:
  /// **'{hex} accent'**
  String themeAccentColorValue(String hex);

  /// Red, green, and blue channel values for a custom theme color
  ///
  /// In en, this message translates to:
  /// **'R {red}, G {green}, B {blue}'**
  String themeRgbValues(int red, int green, int blue);

  /// Label for adjusting the red channel of a custom theme color
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorChannelRed;

  /// Label for adjusting the green channel of a custom theme color
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorChannelGreen;

  /// Label for adjusting the blue channel of a custom theme color
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorChannelBlue;

  /// Heading for selecting a preset custom theme color swatch
  ///
  /// In en, this message translates to:
  /// **'Quick colors'**
  String get headingQuickColors;

  /// Empty state shown when no custom request headers have been added
  ///
  /// In en, this message translates to:
  /// **'No custom headers are configured'**
  String get statusNoCustomHeadersConfigured;

  /// Warning shown in a custom header editor explaining when headers are sent and why their values need care
  ///
  /// In en, this message translates to:
  /// **'These headers are sent with requests to this server. Header values may contain secrets, so share them only with trusted people'**
  String get messageCustomHeadersSentWithRequests;

  /// Action for adding a request header to a server connection
  ///
  /// In en, this message translates to:
  /// **'Add custom header'**
  String get actionAddCustomHeader;

  /// Title of a dialog for adding a custom request header
  ///
  /// In en, this message translates to:
  /// **'Add header'**
  String get titleAddCustomHeader;

  /// Title of a dialog for changing a custom request header
  ///
  /// In en, this message translates to:
  /// **'Edit header'**
  String get titleEditCustomHeader;

  /// Heading for configuring the server email transport connection
  ///
  /// In en, this message translates to:
  /// **'SMTP settings'**
  String get headingSmtpSettings;

  /// Introduction to the server email settings form
  ///
  /// In en, this message translates to:
  /// **'Configure server email delivery and send a test message to check the connection'**
  String get messageConfigureSmtpEmailDelivery;

  /// Label for the hostname of the server that sends email
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get fieldHost;

  /// Label for the network port used by the server email connection
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get fieldPort;

  /// Label for the sender email address used for outgoing server email
  ///
  /// In en, this message translates to:
  /// **'From address'**
  String get fieldFromAddress;

  /// Label for the recipient address used to send a test email
  ///
  /// In en, this message translates to:
  /// **'Test address'**
  String get fieldTestAddress;

  /// Switch label for enabling encryption on the server email connection
  ///
  /// In en, this message translates to:
  /// **'Use a secure SMTP connection'**
  String get settingSecureSmtpConnection;

  /// Switch label for rejecting server certificates that cannot be verified
  ///
  /// In en, this message translates to:
  /// **'Reject unauthorized certificates'**
  String get settingRejectUnauthorizedCertificates;

  /// Description explaining when certificate verification may need to be disabled
  ///
  /// In en, this message translates to:
  /// **'Disable only when the SMTP server uses a self-signed certificate'**
  String get settingRejectUnauthorizedCertificatesDescription;

  /// Action for sending a test email through the configured server connection
  ///
  /// In en, this message translates to:
  /// **'Send test'**
  String get actionSendTestEmail;

  /// Name of the user access rule for a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'{availability, select, adminOrUp{Admin and up} userOrUp{User and up} guestOrUp{Guest and up} specificUsers{Specific users} other{Admin and up}}'**
  String emailDeviceAvailabilityName(String availability);

  /// Access rule followed by the number of users allowed to use an email destination
  ///
  /// In en, this message translates to:
  /// **'{access} ({count})'**
  String emailDeviceAccessWithUserCount(String access, int count);

  /// Label for the name assigned to an e-reader email destination
  ///
  /// In en, this message translates to:
  /// **'Device name'**
  String get fieldDeviceName;

  /// Example name shown in the e-reader destination name field
  ///
  /// In en, this message translates to:
  /// **'Kindle'**
  String get exampleEreaderDeviceName;

  /// Label for the email address assigned to an e-reader destination
  ///
  /// In en, this message translates to:
  /// **'Device email'**
  String get fieldDeviceEmail;

  /// Example address shown in the e-reader destination email field
  ///
  /// In en, this message translates to:
  /// **'kindle@kindle.com'**
  String get exampleEreaderDeviceEmail;

  /// Label for choosing which server users can send email to an e-reader destination
  ///
  /// In en, this message translates to:
  /// **'Accessible by'**
  String get fieldAccessibleBy;

  /// Heading for selecting specific server users who can use an e-reader destination
  ///
  /// In en, this message translates to:
  /// **'Allowed users'**
  String get fieldAllowedUsers;

  /// Empty state shown when no server users can be selected for an email destination
  ///
  /// In en, this message translates to:
  /// **'No users available'**
  String get statusNoUsersAvailable;

  /// Validation error shown when an e-reader destination name is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a device name'**
  String get errorDeviceNameRequired;

  /// Validation error shown when an e-reader destination name is already in use
  ///
  /// In en, this message translates to:
  /// **'A device with this name already exists'**
  String get errorDeviceNameAlreadyExists;

  /// Validation error shown when an e-reader destination email address is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a device email address'**
  String get errorDeviceEmailRequired;

  /// Validation error shown when an e-reader destination email address is malformed
  ///
  /// In en, this message translates to:
  /// **'Enter a valid device email address'**
  String get errorDeviceEmailInvalid;

  /// Validation error shown when specific-user access is selected without choosing a user
  ///
  /// In en, this message translates to:
  /// **'Select at least one user for specific access'**
  String get errorSelectAtLeastOneUserForSpecificAccess;

  /// Title of a dialog for changing a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'Edit e-reader device'**
  String get headingEditEreaderDevice;

  /// Title of a dialog for creating a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'Add e-reader device'**
  String get headingAddEreaderDevice;

  /// Empty state shown when the server has no configured e-reader destinations
  ///
  /// In en, this message translates to:
  /// **'No e-reader devices found'**
  String get statusNoEreaderDevicesFound;

  /// Empty state guidance for adding an e-reader destination
  ///
  /// In en, this message translates to:
  /// **'Add a destination to enable send-to-device email delivery'**
  String get messageAddEreaderDeviceDestination;

  /// Title of a confirmation dialog for deleting a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'Delete e-reader device'**
  String get titleDeleteEreaderDevice;

  /// Confirmation message shown before removing an e-reader destination
  ///
  /// In en, this message translates to:
  /// **'Delete {name}? This removes the destination from send-to-device email delivery'**
  String promptDeleteEreaderDevice(String name);

  /// Status shown after saving the server email transport settings
  ///
  /// In en, this message translates to:
  /// **'Email settings saved'**
  String get statusEmailSettingsSaved;

  /// Status shown after the server sends a test email successfully
  ///
  /// In en, this message translates to:
  /// **'Test email sent'**
  String get statusTestEmailSent;

  /// Error shown when the server does not send a test email successfully
  ///
  /// In en, this message translates to:
  /// **'Could not send the test email'**
  String get errorEmailTestSendFailed;

  /// Status shown after adding a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'E-reader device added'**
  String get statusEreaderDeviceAdded;

  /// Status shown after saving changes to a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'E-reader device updated'**
  String get statusEreaderDeviceUpdated;

  /// Status shown after deleting a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'E-reader device deleted'**
  String get statusEreaderDeviceDeleted;

  /// Operation name used when reporting an error while loading server email settings
  ///
  /// In en, this message translates to:
  /// **'Loading server email settings'**
  String get operationLoadEmailSettings;

  /// Operation name used when reporting an error while saving server email settings
  ///
  /// In en, this message translates to:
  /// **'Saving server email settings'**
  String get operationSaveEmailSettings;

  /// Operation name used when reporting an error while sending a test email
  ///
  /// In en, this message translates to:
  /// **'Sending a test email'**
  String get operationSendTestEmail;

  /// Operation name used when reporting an error while adding a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'Adding the e-reader device'**
  String get operationAddEreaderDevice;

  /// Operation name used when reporting an error while changing a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'Updating the e-reader device'**
  String get operationUpdateEreaderDevice;

  /// Operation name used when reporting an error while deleting a send-to-device email destination
  ///
  /// In en, this message translates to:
  /// **'Deleting the e-reader device'**
  String get operationDeleteEreaderDevice;

  /// Validation error shown when the server email hostname is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a host'**
  String get errorEmailHostRequired;

  /// Validation error shown when the server email port is blank
  ///
  /// In en, this message translates to:
  /// **'Enter a port'**
  String get errorEmailPortRequired;

  /// Validation error shown when the server email port is not a number
  ///
  /// In en, this message translates to:
  /// **'Enter a valid port number'**
  String get errorEmailPortMustBeNumber;

  /// Validation error showing the allowed range for a server email port
  ///
  /// In en, this message translates to:
  /// **'Enter a port between {minimum} and {maximum}'**
  String errorEmailPortRange(int minimum, int maximum);

  /// Validation error shown when an optional server email address is malformed
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address for {field}'**
  String errorEmailFieldInvalid(String field);

  /// Heading for the folders assigned to a library
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get headingFolders;

  /// Empty state shown before any folders have been assigned to a library
  ///
  /// In en, this message translates to:
  /// **'No folders added yet'**
  String get statusNoFoldersAdded;

  /// Status identifying a folder that already exists on the server
  ///
  /// In en, this message translates to:
  /// **'Existing folder'**
  String get statusExistingFolder;

  /// Label for entering a server folder path to add to a library
  ///
  /// In en, this message translates to:
  /// **'Add folder path'**
  String get fieldAddFolderPath;

  /// Action for adding a server folder path to a library
  ///
  /// In en, this message translates to:
  /// **'Add folder'**
  String get actionAddFolder;

  /// Label for a field that searches the server library list
  ///
  /// In en, this message translates to:
  /// **'Search libraries'**
  String get fieldSearchLibraries;

  /// Hint listing the library details that can be searched
  ///
  /// In en, this message translates to:
  /// **'Filter by name, provider, media type, or path'**
  String get hintSearchLibraries;

  /// Summary of the number of server libraries
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No libraries} =1{1 library} other{{count} libraries}}'**
  String statusLibraryCount(int count);

  /// Summary of matching libraries and the total number of server libraries
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total, plural, =1{1 library} other{{total} libraries}}'**
  String statusLibraryFilteredCount(int filtered, int total);

  /// Progress status shown while saving the order of server libraries
  ///
  /// In en, this message translates to:
  /// **'Saving order…'**
  String get statusSavingLibraryOrder;

  /// Status shown after creating a server library
  ///
  /// In en, this message translates to:
  /// **'Library created successfully'**
  String get statusLibraryCreated;

  /// Status shown after updating a server library
  ///
  /// In en, this message translates to:
  /// **'Library updated successfully'**
  String get statusLibraryUpdated;

  /// Status shown after deleting a server library
  ///
  /// In en, this message translates to:
  /// **'Library deleted'**
  String get statusLibraryDeleted;

  /// Status shown after saving the server library order
  ///
  /// In en, this message translates to:
  /// **'Library order updated'**
  String get statusLibraryOrderUpdated;

  /// Status shown after starting a scan of a server library
  ///
  /// In en, this message translates to:
  /// **'Library scan started'**
  String get statusLibraryScanStarted;

  /// Status shown after starting a forced rescan of a server library
  ///
  /// In en, this message translates to:
  /// **'Force rescan started'**
  String get statusLibraryForceRescanStarted;

  /// Status shown after starting the match-all metadata job for a server library
  ///
  /// In en, this message translates to:
  /// **'Started match-all metadata job'**
  String get statusMatchAllMetadataStarted;

  /// Fallback error shown when loading server libraries fails
  ///
  /// In en, this message translates to:
  /// **'Could not load libraries'**
  String get errorLoadLibrariesFailed;

  /// Fallback error shown when creating a server library fails
  ///
  /// In en, this message translates to:
  /// **'Could not create library'**
  String get errorCreateLibraryFailed;

  /// Fallback error shown when updating a server library fails
  ///
  /// In en, this message translates to:
  /// **'Could not update library'**
  String get errorUpdateLibraryFailed;

  /// Fallback error shown when deleting a server library fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete library'**
  String get errorDeleteLibraryFailed;

  /// Fallback error shown when starting a server library scan fails
  ///
  /// In en, this message translates to:
  /// **'Could not start library scan'**
  String get errorStartLibraryScanFailed;

  /// Fallback error shown when saving the server library order fails
  ///
  /// In en, this message translates to:
  /// **'Could not save library order'**
  String get errorSaveLibraryOrderFailed;

  /// Fallback error shown when starting a library match-all metadata job fails
  ///
  /// In en, this message translates to:
  /// **'Could not start the match-all metadata job'**
  String get errorStartMatchAllMetadataFailed;

  /// Confirmation dialog title shown before deleting a server library
  ///
  /// In en, this message translates to:
  /// **'Delete library?'**
  String get headingDeleteLibrary;

  /// Confirmation message shown before deleting a server library
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This action cannot be undone'**
  String promptDeleteLibrary(String name);

  /// Action for starting a scan of a server library
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get actionScan;

  /// Action for scanning a server library and forcing metadata refresh
  ///
  /// In en, this message translates to:
  /// **'Force rescan'**
  String get actionForceRescan;

  /// Label for starting or configuring metadata matching for every book in a library
  ///
  /// In en, this message translates to:
  /// **'Match all books'**
  String get actionMatchAllBooks;

  /// Tooltip for the menu of actions available for a server library
  ///
  /// In en, this message translates to:
  /// **'Library actions'**
  String get headingLibraryActions;

  /// Empty state shown when the server has no libraries
  ///
  /// In en, this message translates to:
  /// **'No libraries available on this server'**
  String get statusNoLibrariesAvailable;

  /// Empty state shown when no server libraries match the current search
  ///
  /// In en, this message translates to:
  /// **'No libraries match your search query'**
  String get statusNoLibrariesMatchSearch;

  /// Guidance shown when the server has no libraries
  ///
  /// In en, this message translates to:
  /// **'Create a library to add books or podcasts'**
  String get messageCreateLibraryToAddContent;

  /// Guidance shown when the current library search has no results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search query'**
  String get hintAdjustSearchQuery;

  /// Error shown when loading the signed-in user for an admin settings page fails
  ///
  /// In en, this message translates to:
  /// **'Could not load user data: {error}'**
  String errorLoadAdminUserData(String error);

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUnitedStates;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUnitedKingdom;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryItaly;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJapan;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAustralia;

  /// Country name shown as a podcast search region option
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCanada;

  /// Metadata precedence source for information inferred from folder names
  ///
  /// In en, this message translates to:
  /// **'Folder structure'**
  String get metadataSourceFolderStructure;

  /// Metadata precedence source for tags stored in audio and ebook files
  ///
  /// In en, this message translates to:
  /// **'Audio and ebook metadata'**
  String get metadataSourceAudioAndEbookMetadata;

  /// Metadata precedence source for NFO files
  ///
  /// In en, this message translates to:
  /// **'NFO file'**
  String get metadataSourceNfoFile;

  /// Metadata precedence source for desc.txt and reader.txt files
  ///
  /// In en, this message translates to:
  /// **'desc.txt and reader.txt'**
  String get metadataSourceDescriptionFiles;

  /// Metadata precedence source for OPF files
  ///
  /// In en, this message translates to:
  /// **'OPF file'**
  String get metadataSourceOpfFile;

  /// Metadata precedence source for the Audiobookshelf metadata file
  ///
  /// In en, this message translates to:
  /// **'Audiobookshelf metadata file'**
  String get metadataSourceAudiobookshelfFile;

  /// Validation error shown when adding a duplicate library folder path
  ///
  /// In en, this message translates to:
  /// **'This folder path has already been added'**
  String get errorLibraryFolderPathAlreadyExists;

  /// Validation error shown when one library folder path contains another
  ///
  /// In en, this message translates to:
  /// **'Nested folder paths are not allowed'**
  String get errorNestedFolderPathsNotAllowed;

  /// Validation error shown when the library name is empty
  ///
  /// In en, this message translates to:
  /// **'Enter a library name'**
  String get errorLibraryNameRequired;

  /// Validation error shown when a library has no folder paths
  ///
  /// In en, this message translates to:
  /// **'Add at least one folder path'**
  String get errorAddAtLeastOneFolderPath;

  /// Validation error shown when a library folder path is empty
  ///
  /// In en, this message translates to:
  /// **'Folder paths cannot be empty'**
  String get errorFolderPathsCannotBeEmpty;

  /// Validation error shown when library folder paths are duplicated
  ///
  /// In en, this message translates to:
  /// **'Duplicate folder paths are not allowed'**
  String get errorDuplicateFolderPathsNotAllowed;

  /// Validation error shown when scheduled library scans have no cron expression
  ///
  /// In en, this message translates to:
  /// **'Enter a cron expression when scheduled scans are enabled'**
  String get errorCronRequiredWhenLibrarySchedulingEnabled;

  /// Validation error shown when a completion percentage is outside the allowed range
  ///
  /// In en, this message translates to:
  /// **'Enter a value between {minimum} and {maximum}'**
  String errorPercentBetweenZeroAndHundred(int minimum, int maximum);

  /// Dialog title for selecting a folder to add to a library
  ///
  /// In en, this message translates to:
  /// **'Select library folder'**
  String get titleSelectLibraryFolder;

  /// Status shown when no library metadata files with the requested extension were found
  ///
  /// In en, this message translates to:
  /// **'No .{extension} metadata files were found'**
  String statusNoLibraryMetadataFilesFound(String extension);

  /// Status shown when library metadata files with the requested extension were not removed
  ///
  /// In en, this message translates to:
  /// **'No .{extension} metadata files were removed'**
  String statusNoLibraryMetadataFilesRemoved(String extension);

  /// Status showing how many library metadata files were removed
  ///
  /// In en, this message translates to:
  /// **'Removed {count, plural, =1{1 .{extension} metadata file} other{{count} .{extension} metadata files}}'**
  String statusLibraryMetadataFilesRemoved(int count, String extension);

  /// Error shown when removing library metadata files fails
  ///
  /// In en, this message translates to:
  /// **'Could not remove .{extension} metadata files: {error}'**
  String errorRemoveLibraryMetadataFilesFailed(String extension, String error);

  /// Error shown when starting a library match-all metadata job fails
  ///
  /// In en, this message translates to:
  /// **'Could not start the match-all metadata job: {error}'**
  String errorMatchAllMetadataFailed(String error);

  /// Hint for choosing the provider used to match library metadata
  ///
  /// In en, this message translates to:
  /// **'Select a metadata provider'**
  String get hintSelectMetadataProvider;

  /// Label for selecting whether a library contains audiobooks or podcasts
  ///
  /// In en, this message translates to:
  /// **'Media type'**
  String get fieldMediaType;

  /// Hint explaining why the media type field is disabled while editing a library
  ///
  /// In en, this message translates to:
  /// **'The media type cannot be changed after the library is created'**
  String get hintMediaTypeCannotBeChanged;

  /// Example library name shown in the library name field
  ///
  /// In en, this message translates to:
  /// **'My audiobooks'**
  String get hintLibraryNameExample;

  /// Label for selecting the icon used by a library
  ///
  /// In en, this message translates to:
  /// **'Library icon'**
  String get fieldLibraryIcon;

  /// Hint for choosing a library icon
  ///
  /// In en, this message translates to:
  /// **'Select a library icon'**
  String get hintSelectLibraryIcon;

  /// Heading for settings that control how library items are handled
  ///
  /// In en, this message translates to:
  /// **'Library behavior'**
  String get headingLibraryBehavior;

  /// Setting that displays book covers with a square aspect ratio
  ///
  /// In en, this message translates to:
  /// **'Use square book covers'**
  String get settingUseSquareBookCovers;

  /// Setting that limits a book library to audiobook items
  ///
  /// In en, this message translates to:
  /// **'Audiobooks only'**
  String get settingAudiobooksOnly;

  /// Setting that hides series containing a single book
  ///
  /// In en, this message translates to:
  /// **'Hide single-book series'**
  String get settingHideSingleBookSeries;

  /// Setting that excludes the first book in a series from continue listening
  ///
  /// In en, this message translates to:
  /// **'Only show later books in continue series'**
  String get settingOnlyShowLaterBooksInContinueSeries;

  /// Setting that allows scripts embedded in ebook content to run
  ///
  /// In en, this message translates to:
  /// **'Allow scripted ebook content'**
  String get settingAllowScriptedEbookContent;

  /// Heading for choosing when an audiobook is marked as finished
  ///
  /// In en, this message translates to:
  /// **'Mark as finished threshold'**
  String get headingMarkAsFinishedThreshold;

  /// Option for setting the remaining time threshold in seconds
  ///
  /// In en, this message translates to:
  /// **'Time remaining in seconds'**
  String get optionTimeRemainingSeconds;

  /// Option for setting the completion percentage threshold
  ///
  /// In en, this message translates to:
  /// **'Percent complete'**
  String get optionPercentComplete;

  /// Label for choosing the type of audiobook completion threshold
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get fieldMode;

  /// Label for entering an audiobook completion percentage threshold
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get fieldPercent;

  /// Label for choosing the region used for podcast searches
  ///
  /// In en, this message translates to:
  /// **'Podcast search region'**
  String get fieldPodcastSearchRegion;

  /// Message shown when scanner settings are opened for a podcast library
  ///
  /// In en, this message translates to:
  /// **'Scanner settings are available for audiobook libraries'**
  String get messageScannerSettingsBookLibrariesOnly;

  /// Setting that watches library folders for file changes
  ///
  /// In en, this message translates to:
  /// **'Enable folder watcher'**
  String get settingEnableFolderWatcher;

  /// Supporting text for the library folder watcher setting
  ///
  /// In en, this message translates to:
  /// **'Turn this off if the server cannot reliably watch file changes'**
  String get settingEnableFolderWatcherDescription;

  /// Setting that skips metadata matching for books with an ASIN
  ///
  /// In en, this message translates to:
  /// **'Skip matching books with ASIN'**
  String get settingSkipMatchingBooksWithAsin;

  /// Setting that skips metadata matching for books with an ISBN
  ///
  /// In en, this message translates to:
  /// **'Skip matching books with ISBN'**
  String get settingSkipMatchingBooksWithIsbn;

  /// Setting that runs library scans on a schedule
  ///
  /// In en, this message translates to:
  /// **'Enable scheduled scans'**
  String get settingEnableScheduledScans;

  /// Supporting text with an example for scheduled library scans
  ///
  /// In en, this message translates to:
  /// **'Use cron syntax. Example: {example} runs weekly on Monday at 00:00'**
  String settingScheduledScansDescription(String example);

  /// Hint explaining how to clear a saved cron expression
  ///
  /// In en, this message translates to:
  /// **'Turn off scheduling to clear the cron expression'**
  String get hintDisableSchedulingToClearCron;

  /// Message shown when library tools are unavailable before the library is created
  ///
  /// In en, this message translates to:
  /// **'Create the library first to access its tools'**
  String get messageCreateLibraryBeforeUsingTools;

  /// Heading for removing generated metadata files from library folders
  ///
  /// In en, this message translates to:
  /// **'Metadata file cleanup'**
  String get headingLibraryMetadataFileCleanup;

  /// Explanation of the library metadata cleanup actions
  ///
  /// In en, this message translates to:
  /// **'Remove generated metadata files from library folders'**
  String get messageRemoveGeneratedLibraryMetadataFiles;

  /// Action for removing a generated library metadata file
  ///
  /// In en, this message translates to:
  /// **'Remove {fileName}'**
  String actionRemoveMetadataFile(String fileName);

  /// Explanation of the match-all metadata action for a library
  ///
  /// In en, this message translates to:
  /// **'Run the server match-all process for this library'**
  String get messageRunMatchAllMetadataForLibrary;

  /// Action for starting the match-all metadata process for a library
  ///
  /// In en, this message translates to:
  /// **'Start match-all'**
  String get actionStartMatchAll;

  /// Tab label for configuring scheduled library scans
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get settingsCategorySchedule;

  /// Priority label shown when one metadata source is the only enabled source
  ///
  /// In en, this message translates to:
  /// **'Only active source'**
  String get statusOnlyActiveMetadataSource;

  /// Priority label shown for the first enabled metadata source
  ///
  /// In en, this message translates to:
  /// **'Highest priority'**
  String get statusHighestMetadataPriority;

  /// Priority label shown for the last enabled metadata source
  ///
  /// In en, this message translates to:
  /// **'Lowest priority'**
  String get statusLowestMetadataPriority;

  /// Priority position shown for an enabled metadata source
  ///
  /// In en, this message translates to:
  /// **'Priority {position} of {count}'**
  String statusMetadataPriority(int position, int count);

  /// Heading for ordering the sources used to populate library metadata
  ///
  /// In en, this message translates to:
  /// **'Metadata precedence'**
  String get headingMetadataPrecedence;

  /// Empty state shown when no metadata sources can be configured
  ///
  /// In en, this message translates to:
  /// **'No metadata sources available'**
  String get statusNoMetadataSourcesAvailable;

  /// Entity type label for an RSS feed linked to one library item
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get entityItem;

  /// Table column label for an RSS feed title and description
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get fieldRssFeed;

  /// Table column label for the type of entity linked to an RSS feed
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get fieldEntity;

  /// Label for searching the server RSS feed list
  ///
  /// In en, this message translates to:
  /// **'Search RSS feeds'**
  String get fieldSearchRssFeeds;

  /// Hint listing the RSS feed details that can be searched
  ///
  /// In en, this message translates to:
  /// **'Filter by title, URL, author, or entity'**
  String get hintSearchRssFeeds;

  /// Summary of the number of server RSS feeds
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No feeds} =1{1 feed} other{{count} feeds}}'**
  String statusRssFeedCount(int count);

  /// Summary of matching RSS feeds and the total number of feeds
  ///
  /// In en, this message translates to:
  /// **'{filtered} of {total, plural, =1{1 feed} other{{total} feeds}}'**
  String statusRssFeedFilteredCount(int filtered, int total);

  /// Summary showing the linked entity type and episode count for an RSS feed
  ///
  /// In en, this message translates to:
  /// **'{entity} • {count, plural, =0{No episodes} =1{1 episode} other{{count} episodes}}'**
  String statusRssFeedEntitySummary(String entity, int count);

  /// Confirmation dialog title shown before closing a server RSS feed
  ///
  /// In en, this message translates to:
  /// **'Close RSS feed?'**
  String get headingCloseRssFeed;

  /// Confirmation message shown before closing a server RSS feed
  ///
  /// In en, this message translates to:
  /// **'Close \"{name}\"?'**
  String promptCloseRssFeed(String name);

  /// Action for closing a server RSS feed
  ///
  /// In en, this message translates to:
  /// **'Close feed'**
  String get actionCloseRssFeed;

  /// Status shown after closing a server RSS feed
  ///
  /// In en, this message translates to:
  /// **'RSS feed closed'**
  String get statusRssFeedClosed;

  /// Fallback error shown when closing a server RSS feed fails
  ///
  /// In en, this message translates to:
  /// **'Could not close RSS feed'**
  String get errorCloseRssFeedFailed;

  /// Fallback error shown when loading server RSS feeds fails
  ///
  /// In en, this message translates to:
  /// **'Could not load RSS feeds'**
  String get errorLoadRssFeedsFailed;

  /// Empty state shown when the server has no RSS feeds
  ///
  /// In en, this message translates to:
  /// **'No RSS feeds found'**
  String get statusNoRssFeedsFound;

  /// Empty state shown when no server RSS feeds match the current search
  ///
  /// In en, this message translates to:
  /// **'No RSS feeds match your search'**
  String get statusNoRssFeedsMatchSearch;

  /// Guidance shown when the server has no RSS feeds
  ///
  /// In en, this message translates to:
  /// **'Feeds will appear here'**
  String get messageRssFeedsAppearHere;

  /// Guidance shown when the current RSS feed search has no results
  ///
  /// In en, this message translates to:
  /// **'Try a different title, URL, author, or entity'**
  String get hintAdjustRssFeedSearch;

  /// Dialog title for viewing details of a server RSS feed
  ///
  /// In en, this message translates to:
  /// **'RSS feed details'**
  String get headingRssFeedDetails;

  /// Label for the name of the owner of an RSS feed
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get fieldOwnerName;

  /// Label for the email address of the owner of an RSS feed
  ///
  /// In en, this message translates to:
  /// **'Owner email'**
  String get fieldOwnerEmail;

  /// Status shown after copying an RSS feed URL
  ///
  /// In en, this message translates to:
  /// **'Feed URL copied'**
  String get statusRssFeedUrlCopied;

  /// Action for copying the URL of an RSS feed
  ///
  /// In en, this message translates to:
  /// **'Copy feed URL'**
  String get actionCopyFeedUrl;

  /// Message shown when an RSS feed requests search engine indexing be prevented
  ///
  /// In en, this message translates to:
  /// **'This feed is marked to prevent indexing'**
  String get messageRssFeedPreventIndexing;

  /// Label showing the season and episode number for an RSS episode
  ///
  /// In en, this message translates to:
  /// **'Season {season}, episode {episode}'**
  String labelEpisodeSeasonAndNumber(String season, String episode);

  /// Label showing the episode number for an RSS episode without a season number
  ///
  /// In en, this message translates to:
  /// **'Episode {episode}'**
  String labelEpisodeNumber(String episode);

  /// Empty state shown when an RSS feed has no episodes
  ///
  /// In en, this message translates to:
  /// **'No episodes in this feed'**
  String get statusNoEpisodesInRssFeed;

  /// Guidance shown when an RSS feed has no available episodes
  ///
  /// In en, this message translates to:
  /// **'Episodes will appear here when available'**
  String get messageRssEpisodesAppearHere;

  /// Filter section heading for available languages
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get headingLanguages;

  /// Heading for the filter section and active filter label for books missing selected metadata fields
  ///
  /// In en, this message translates to:
  /// **'Missing metadata'**
  String get headingMissingMetadata;

  /// Filter section heading for special library states
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get headingSpecialFilters;

  /// Filter option for podcast items with open feeds
  ///
  /// In en, this message translates to:
  /// **'Open feeds'**
  String get filterOpenFeeds;

  /// Progress filter for items that have not been started
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get statusNotStarted;

  /// Progress filter for items that have not been finished
  ///
  /// In en, this message translates to:
  /// **'Not finished'**
  String get statusNotFinished;

  /// Filter option for books with a single audio track
  ///
  /// In en, this message translates to:
  /// **'Single track'**
  String get filterSingleTrack;

  /// Filter option for books with more than one audio track
  ///
  /// In en, this message translates to:
  /// **'Multiple tracks'**
  String get filterMultipleTracks;

  /// Filter option and active filter label for books that do not belong to a series
  ///
  /// In en, this message translates to:
  /// **'No series'**
  String get statusNoSeriesFilterOption;

  /// Empty state shown when the library has no filter values
  ///
  /// In en, this message translates to:
  /// **'No filter options available'**
  String get statusNoFilterOptionsAvailable;

  /// Explanation shown when the library has no filter values
  ///
  /// In en, this message translates to:
  /// **'This library does not have any filter values yet'**
  String get messageNoLibraryFilterValues;

  /// Summary showing the currently selected library filter option
  ///
  /// In en, this message translates to:
  /// **'Selected: {option}'**
  String statusSelectedFilterOption(String option);

  /// Summary showing how many options are available in a filter section
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 option} other{{count} options}}'**
  String statusFilterOptionCount(int count);

  /// Label for searching the options in a library filter section
  ///
  /// In en, this message translates to:
  /// **'Search options'**
  String get fieldSearchOptions;

  /// Hint for searching within a library filter section
  ///
  /// In en, this message translates to:
  /// **'Search this section'**
  String get hintSearchWithinOptions;

  /// Empty state shown when no filter options match the search
  ///
  /// In en, this message translates to:
  /// **'No matching options'**
  String get statusNoMatchingOptions;

  /// Action for choosing the order of a list
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get actionSort;

  /// Accessible label for ascending sort order
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get sortAscending;

  /// Accessible label for descending sort order
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get sortDescending;

  /// Error shown when downloading a file from an item fails
  ///
  /// In en, this message translates to:
  /// **'Could not download file: {error}'**
  String errorDownloadFileFailed(String error);

  /// Confirmation message shown before removing a file from offline storage
  ///
  /// In en, this message translates to:
  /// **'Remove {name} from offline storage?'**
  String promptDeleteDownloadedFile(String name);

  /// Error shown when a downloaded file cannot be removed from offline storage
  ///
  /// In en, this message translates to:
  /// **'Could not delete this file'**
  String get errorDeleteDownloadedFileFailed;

  /// Error shown when deleting a downloaded file fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete file: {error}'**
  String errorDeleteDownloadedFileDetails(String error);

  /// Error shown when canceling a download fails
  ///
  /// In en, this message translates to:
  /// **'Could not cancel download: {error}'**
  String errorCancelDownloadDetails(String error);

  /// Error shown when the files for a download could not be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load this download'**
  String get errorLoadDownloadFilesFailed;

  /// Status shown when a download is no longer available on this device
  ///
  /// In en, this message translates to:
  /// **'This download has been removed'**
  String get statusDownloadNoLongerAvailable;

  /// Summary showing how many files are available offline out of the total
  ///
  /// In en, this message translates to:
  /// **'{downloaded} of {total, plural, =1{1 file offline} other{{total} files offline}}'**
  String downloadedFileCountSummary(int downloaded, int total);

  /// Action for downloading files that are not yet available offline
  ///
  /// In en, this message translates to:
  /// **'Download missing files'**
  String get actionDownloadMissingFiles;

  /// Action for trying again after download files fail to load
  ///
  /// In en, this message translates to:
  /// **'Retry loading files'**
  String get actionRetryLoadingFiles;

  /// Status shown for a file that is not downloaded
  ///
  /// In en, this message translates to:
  /// **'Not downloaded'**
  String get statusNotDownloaded;

  /// Status shown when a downloaded item can be played offline
  ///
  /// In en, this message translates to:
  /// **'Available offline'**
  String get statusAvailableOffline;

  /// Status shown for content saved on this device for offline use
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get statusOffline;

  /// Status showing how many files are available offline
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file offline} other{{count} files offline}}'**
  String downloadOfflineFileCount(int count);

  /// Tooltip for opening the file manager for an item with a partial download
  ///
  /// In en, this message translates to:
  /// **'{downloaded} of {total, plural, =1{1 file} other{{total} files}} offline. Manage files'**
  String downloadedFilesPartialTooltip(int downloaded, int total);

  /// Tooltip for the menu of actions available for a download
  ///
  /// In en, this message translates to:
  /// **'Download actions'**
  String get headingDownloadActions;

  /// Badge identifying an item downloaded by a smart download rule
  ///
  /// In en, this message translates to:
  /// **'Smart download'**
  String get statusSmartDownload;

  /// Fallback error shown when options for a picker fail to load
  ///
  /// In en, this message translates to:
  /// **'Could not load options'**
  String get errorLoadOptionsFailed;

  /// Status shown after saving collection membership changes
  ///
  /// In en, this message translates to:
  /// **'Collections updated'**
  String get statusCollectionsUpdated;

  /// Status shown after saving playlist membership changes
  ///
  /// In en, this message translates to:
  /// **'Playlists updated'**
  String get statusPlaylistsUpdated;

  /// Reason shown when an entry cannot be edited because its full list is not loaded
  ///
  /// In en, this message translates to:
  /// **'The full list is unavailable'**
  String get errorFullListUnavailable;

  /// Reason shown when a playlist owned by another user cannot be edited
  ///
  /// In en, this message translates to:
  /// **'Only your own playlists can be edited'**
  String get errorOnlyOwnPlaylistsCanBeEdited;

  /// Confirmation dialog title shown before removing the last book from playlists
  ///
  /// In en, this message translates to:
  /// **'Delete empty playlists?'**
  String get headingDeleteEmptyPlaylists;

  /// Warning shown before removing a book that would leave playlists empty
  ///
  /// In en, this message translates to:
  /// **'Removing this book will leave these playlists empty. Audiobookshelf will delete them:\n\n{names}'**
  String promptRemovingBookMayDeleteEmptyPlaylists(String names);

  /// Error shown when a collection or playlist list fails to load
  ///
  /// In en, this message translates to:
  /// **'Could not load {lists}'**
  String errorLoadNamedListFailed(String lists);

  /// Empty state shown when a library has no collections or playlists
  ///
  /// In en, this message translates to:
  /// **'No {lists} found in this library'**
  String statusNoNamedListsFound(String lists);

  /// Dialog title for managing collection or playlist membership
  ///
  /// In en, this message translates to:
  /// **'Manage {lists}'**
  String headingManageNamedLists(String lists);

  /// Warning shown when a collection or playlist changes while it is being edited
  ///
  /// In en, this message translates to:
  /// **'This list changed. Review the updates before saving'**
  String get statusNamedListChangedReviewUpdates;

  /// Message shown when the current user cannot edit collection or playlist membership
  ///
  /// In en, this message translates to:
  /// **'Editing is not allowed'**
  String get errorEditingListNotAllowed;

  /// Action for reviewing changes received while editing a collection or playlist
  ///
  /// In en, this message translates to:
  /// **'Review updates'**
  String get actionReviewUpdates;

  /// Action for reloading collection or playlist entries whose full data is unavailable
  ///
  /// In en, this message translates to:
  /// **'Retry unavailable lists'**
  String get actionRetryUnavailableLists;

  /// Error shown when an item that is not an audiobook is passed to the audiobook delete action
  ///
  /// In en, this message translates to:
  /// **'Only audiobooks can be deleted from this action'**
  String get errorOnlyAudiobooksCanBeDeletedHere;

  /// Status shown after deleting an audiobook and its files from the server and file system
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{title}\" from Audiobookshelf and file system'**
  String statusAudiobookDeletedFromServerAndFileSystem(String title);

  /// Status shown after deleting an audiobook from the server while keeping its files
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{title}\" from Audiobookshelf'**
  String statusAudiobookDeletedFromServer(String title);

  /// Fallback error shown when deleting an audiobook fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete audiobook'**
  String get errorDeleteAudiobookFailed;

  /// Error shown when none of the selected items can be deleted as audiobooks
  ///
  /// In en, this message translates to:
  /// **'No selected audiobooks can be deleted. Select audiobook items and try again'**
  String get errorNoSelectedAudiobooksCanBeDeleted;

  /// Status shown after deleting selected audiobooks and their files from the server and file system
  ///
  /// In en, this message translates to:
  /// **'Deleted {count, plural, =1{1 audiobook} other{{count} audiobooks}} from Audiobookshelf and file system'**
  String statusSelectedAudiobooksDeletedFromServerAndFileSystem(int count);

  /// Status shown after deleting selected audiobooks from the server while keeping their files
  ///
  /// In en, this message translates to:
  /// **'Deleted {count, plural, =1{1 audiobook} other{{count} audiobooks}} from Audiobookshelf'**
  String statusSelectedAudiobooksDeletedFromServer(int count);

  /// Fallback error shown when deleting selected audiobooks fails
  ///
  /// In en, this message translates to:
  /// **'Could not delete selected audiobooks'**
  String get errorDeleteSelectedAudiobooksFailed;

  /// Message shown when progress is changed for a non-audiobook library item
  ///
  /// In en, this message translates to:
  /// **'Progress updates are currently available for audiobooks only'**
  String get errorProgressUpdatesAudiobooksOnly;

  /// Message shown when episode progress is changed for a non-podcast item
  ///
  /// In en, this message translates to:
  /// **'Progress updates are currently available for podcast episodes only'**
  String get errorProgressUpdatesPodcastEpisodesOnly;

  /// Status shown after marking an audiobook or episode as finished
  ///
  /// In en, this message translates to:
  /// **'Marked \"{name}\" as finished'**
  String statusNamedProgressMarkedFinished(String name);

  /// Status shown after clearing progress for an audiobook or episode
  ///
  /// In en, this message translates to:
  /// **'Cleared progress for \"{name}\"'**
  String statusNamedProgressCleared(String name);

  /// Error shown when marking an audiobook or episode as finished fails
  ///
  /// In en, this message translates to:
  /// **'Could not mark \"{name}\" as finished'**
  String errorMarkNamedProgressFinishedFailed(String name);

  /// Error shown when clearing progress for an audiobook or episode fails
  ///
  /// In en, this message translates to:
  /// **'Could not clear progress for \"{name}\"'**
  String errorClearNamedProgressFailed(String name);

  /// Status shown after updating playback progress for an audiobook or episode
  ///
  /// In en, this message translates to:
  /// **'Progress updated for \"{name}\"'**
  String statusNamedProgressUpdated(String name);

  /// Fallback error shown when updating audiobook or episode progress fails
  ///
  /// In en, this message translates to:
  /// **'Could not update progress'**
  String get errorUpdateProgressFailed;

  /// Status showing how many selected items were marked as finished
  ///
  /// In en, this message translates to:
  /// **'Marked {count, plural, =1{1 selected item} other{{count} selected items}} as finished'**
  String statusSelectedItemsMarkedFinished(int count);

  /// Status showing how many selected items were marked as unfinished
  ///
  /// In en, this message translates to:
  /// **'Marked {count, plural, =1{1 selected item} other{{count} selected items}} as unfinished'**
  String statusSelectedItemsMarkedUnfinished(int count);

  /// Fallback error shown when marking selected items as finished fails
  ///
  /// In en, this message translates to:
  /// **'Could not mark selected items as finished'**
  String get errorMarkSelectedItemsFinishedFailed;

  /// Fallback error shown when marking selected items as unfinished fails
  ///
  /// In en, this message translates to:
  /// **'Could not mark selected items as unfinished'**
  String get errorMarkSelectedItemsUnfinishedFailed;

  /// Error shown when updating the pinned shelf fails
  ///
  /// In en, this message translates to:
  /// **'Could not update Pinned: {error}'**
  String errorUpdatePinnedShelfFailed(String error);

  /// Message shown when series details fail to load
  ///
  /// In en, this message translates to:
  /// **'Series details could not be loaded'**
  String get errorLoadSeriesDetailsFailed;

  /// Action for opening the library selector
  ///
  /// In en, this message translates to:
  /// **'Select library'**
  String get actionSelectLibrary;

  /// Label shown when no library is selected
  ///
  /// In en, this message translates to:
  /// **'No library'**
  String get statusNoLibrarySelected;

  /// Heading for audiobook metadata details
  ///
  /// In en, this message translates to:
  /// **'Book information'**
  String get headingBookInformation;

  /// Playback progress detail shown when less than one minute remains
  ///
  /// In en, this message translates to:
  /// **'Less than 1 minute left'**
  String get statusLessThanOneMinuteLeft;

  /// Screen reader label for audiobook listening progress
  ///
  /// In en, this message translates to:
  /// **'Listening progress {progress}'**
  String labelListeningProgress(String progress);

  /// Heading for listening and completion statistics for a book
  ///
  /// In en, this message translates to:
  /// **'Book stats'**
  String get headingBookStats;

  /// Error shown when book listening statistics fail to load
  ///
  /// In en, this message translates to:
  /// **'Could not load book stats'**
  String get statsBookLoadError;

  /// Label for the number of times playback of a book has started
  ///
  /// In en, this message translates to:
  /// **'Times started'**
  String get fieldTimesStarted;

  /// Label for the date when playback of a book first started
  ///
  /// In en, this message translates to:
  /// **'First started'**
  String get fieldFirstStarted;

  /// Label for the date when playback of a book most recently started
  ///
  /// In en, this message translates to:
  /// **'Last started'**
  String get fieldLastStarted;

  /// Heading for previous completion dates of a book
  ///
  /// In en, this message translates to:
  /// **'Finish history'**
  String get headingFinishHistory;

  /// Status shown when a value is not available
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get statusNotAvailable;

  /// Label showing the current audiobook completion percentage
  ///
  /// In en, this message translates to:
  /// **'Current progress: {progress}'**
  String statusCurrentProgress(String progress);

  /// Label for the server path of a media file
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get fieldFilePath;

  /// Label for the container format of an audio file
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get fieldFormat;

  /// Label for the time base reported for an audio file
  ///
  /// In en, this message translates to:
  /// **'Time base'**
  String get fieldTimeBase;

  /// Label for cover art embedded in an audio file
  ///
  /// In en, this message translates to:
  /// **'Embedded cover'**
  String get fieldEmbeddedCover;

  /// Heading for metadata tags stored in an audio file
  ///
  /// In en, this message translates to:
  /// **'Metadata tags'**
  String get headingMetadataTags;

  /// Heading for technical audio file data returned by FFprobe
  ///
  /// In en, this message translates to:
  /// **'FFprobe data'**
  String get headingFfprobeData;

  /// Action for loading technical audio file data from FFprobe
  ///
  /// In en, this message translates to:
  /// **'Load FFprobe data'**
  String get actionLoadFfprobeData;

  /// Action for copying technical audio file data from FFprobe
  ///
  /// In en, this message translates to:
  /// **'Copy FFprobe data'**
  String get actionCopyFfprobeData;

  /// Fallback error shown when FFprobe data cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load FFprobe data'**
  String get errorLoadFfprobeDataFailed;

  /// Title for the system dialog used to choose where to save a downloaded file
  ///
  /// In en, this message translates to:
  /// **'Save file'**
  String get titleSaveFile;

  /// Fallback error shown when downloading or saving a server file fails
  ///
  /// In en, this message translates to:
  /// **'Could not download or save the file'**
  String get errorDownloadOrSaveFileFailed;

  /// Dialog title shown while saving a server file to the device
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get headingDownloadFile;

  /// Progress status shown while a downloaded file is being saved
  ///
  /// In en, this message translates to:
  /// **'Saving file…'**
  String get statusSavingFile;

  /// Guidance shown while choosing a destination for a downloaded file
  ///
  /// In en, this message translates to:
  /// **'Choose where to save the file'**
  String get hintChooseFileSaveLocation;

  /// Progress summary showing downloaded bytes out of the total file size
  ///
  /// In en, this message translates to:
  /// **'{received} of {total}'**
  String statusDownloadedBytes(String received, String total);

  /// Confirmation dialog title shown before removing a downloaded file or permanently deleting a server file
  ///
  /// In en, this message translates to:
  /// **'Delete file?'**
  String get headingDeleteFile;

  /// Confirmation message shown before permanently deleting a file from the server
  ///
  /// In en, this message translates to:
  /// **'Permanently delete \"{filename}\" from the server? This cannot be undone'**
  String promptDeleteServerFilePermanently(String filename);

  /// Status shown after saving a downloaded file to the device
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get statusFileSaved;

  /// Status shown after deleting a file from the server
  ///
  /// In en, this message translates to:
  /// **'File deleted'**
  String get statusFileDeleted;

  /// Error shown when a source media file cannot be deleted from the server
  ///
  /// In en, this message translates to:
  /// **'Could not delete the server file'**
  String get errorDeleteServerFileFailed;

  /// Error shown when a file download or delete action fails
  ///
  /// In en, this message translates to:
  /// **'Could not complete the file action: {error}'**
  String errorCompleteFileActionFailed(String error);

  /// Tooltip for the menu of actions available for a media file
  ///
  /// In en, this message translates to:
  /// **'File actions'**
  String get headingFileActions;

  /// Action for opening additional information about a media file
  ///
  /// In en, this message translates to:
  /// **'More info'**
  String get actionMoreInfo;

  /// Action for adding files to a library item
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get actionAddFiles;

  /// Label for selecting one or more providers for metadata matching
  ///
  /// In en, this message translates to:
  /// **'Metadata providers'**
  String get fieldMetadataProviders;

  /// Hint for the title field used when searching metadata providers
  ///
  /// In en, this message translates to:
  /// **'Search title'**
  String get hintSearchTitle;

  /// Error shown when metadata providers are unavailable for a matching tool
  ///
  /// In en, this message translates to:
  /// **'Could not load metadata providers'**
  String get errorLoadMetadataProvidersFailed;

  /// Empty state shown when no metadata providers can be selected
  ///
  /// In en, this message translates to:
  /// **'No metadata providers available'**
  String get statusNoMetadataProvidersAvailable;

  /// Heading for the list of metadata results that may match an item
  ///
  /// In en, this message translates to:
  /// **'Match candidates'**
  String get headingMatchCandidates;

  /// Status shown before a metadata search returns any matching results
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get statusNoMatchResultsYet;

  /// Count of metadata results shown in a manual match pane
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result} other{{count} results}}'**
  String matchResultCount(int count);

  /// Empty state guidance for loading metadata candidates
  ///
  /// In en, this message translates to:
  /// **'Run a search to load metadata match results'**
  String get hintRunMetadataMatchSearch;

  /// Action for choosing which metadata providers to search
  ///
  /// In en, this message translates to:
  /// **'Select providers'**
  String get actionSelectProviders;

  /// Heading for the compact summary shown when manual match filters are collapsed
  ///
  /// In en, this message translates to:
  /// **'Search filters collapsed'**
  String get headingSearchFiltersCollapsed;

  /// Hint for reopening collapsed metadata search filters
  ///
  /// In en, this message translates to:
  /// **'Tap to edit search filters'**
  String get hintTapToEditSearchFilters;

  /// Count of metadata providers selected for a search
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 provider} other{{count} providers}}'**
  String metadataProviderCount(int count);

  /// Summary pairing a metadata field label with a search value or result identifier
  ///
  /// In en, this message translates to:
  /// **'{field}: {value}'**
  String matchSearchFieldSummary(String field, String value);

  /// Dialog title for choosing metadata options before matching one book
  ///
  /// In en, this message translates to:
  /// **'Quick match this book'**
  String get headingQuickMatchBook;

  /// Action for starting a metadata quick match
  ///
  /// In en, this message translates to:
  /// **'Run quick match'**
  String get actionRunQuickMatch;

  /// Error shown when a metadata quick match fails
  ///
  /// In en, this message translates to:
  /// **'Could not run quick match: {error}'**
  String errorQuickMatchFailed(String error);

  /// Status shown after a quick match updates item metadata
  ///
  /// In en, this message translates to:
  /// **'Quick match updated this item'**
  String get statusQuickMatchUpdated;

  /// Status shown when a quick match finishes without updating item metadata
  ///
  /// In en, this message translates to:
  /// **'Quick match finished with no metadata changes'**
  String get statusQuickMatchNoChanges;

  /// Validation message shown when a manual metadata search has no title
  ///
  /// In en, this message translates to:
  /// **'Enter a title before searching'**
  String get errorManualMatchTitleRequired;

  /// Validation message shown when no metadata provider is selected for manual matching
  ///
  /// In en, this message translates to:
  /// **'Select at least one provider'**
  String get errorManualMatchProviderRequired;

  /// Status shown after a manual metadata search returns no candidates
  ///
  /// In en, this message translates to:
  /// **'No match results found'**
  String get errorManualMatchResultsNotFound;

  /// Validation message shown when no metadata fields are selected for an update
  ///
  /// In en, this message translates to:
  /// **'Select at least one field to apply'**
  String get errorManualMatchFieldRequired;

  /// Error shown when a selected metadata result has no values that can be applied
  ///
  /// In en, this message translates to:
  /// **'No writable values were selected from this match result'**
  String get errorManualMatchNoWritableFields;

  /// Error shown when saving manually matched metadata fails
  ///
  /// In en, this message translates to:
  /// **'Could not save the manual match: {error}'**
  String errorManualMatchSaveFailed(String error);

  /// Status shown after manually matched metadata is saved
  ///
  /// In en, this message translates to:
  /// **'Item metadata updated from manual match'**
  String get statusManualMatchUpdated;

  /// Heading for the pane where fields from a selected match result can be applied
  ///
  /// In en, this message translates to:
  /// **'Selection'**
  String get headingManualMatchSelection;

  /// Empty state guidance shown before choosing a metadata match result
  ///
  /// In en, this message translates to:
  /// **'Select a match result to choose which metadata fields to apply'**
  String get hintSelectManualMatchResult;

  /// Heading for the pane that applies selected fields from a metadata match
  ///
  /// In en, this message translates to:
  /// **'Apply fields'**
  String get headingApplyMatchedFields;

  /// Hint for entering another value in a metadata list field
  ///
  /// In en, this message translates to:
  /// **'Add value'**
  String get hintAddValue;

  /// Option indicating that a metadata setting is enabled
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get optionYes;

  /// Option indicating that a metadata setting is disabled
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get optionNo;

  /// Label for the cover image field in a manual match editor
  ///
  /// In en, this message translates to:
  /// **'Cover image'**
  String get fieldCoverImage;

  /// Option for replacing existing list metadata with matched values
  ///
  /// In en, this message translates to:
  /// **'Overwrite'**
  String get optionOverwrite;

  /// Option for adding matched values to existing list metadata
  ///
  /// In en, this message translates to:
  /// **'Add to current'**
  String get optionAddToCurrent;

  /// Status shown when a metadata field has no current or suggested value
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get statusNotSet;

  /// Fallback title shown when a metadata match result has no title
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get statusUntitled;

  /// Summary showing the current value of a metadata field in the match editor
  ///
  /// In en, this message translates to:
  /// **'Current: {value}'**
  String matchCurrentValueSummary(String value);

  /// Label for the cover image currently stored on an item
  ///
  /// In en, this message translates to:
  /// **'Current cover'**
  String get fieldCurrentCover;

  /// Label for the cover image selected from a metadata match
  ///
  /// In en, this message translates to:
  /// **'Selected cover'**
  String get fieldSelectedCover;

  /// Dialog title for choosing metadata options before matching selected books
  ///
  /// In en, this message translates to:
  /// **'Quick match selected books'**
  String get headingQuickMatchSelectedBooks;

  /// Action for reviewing proposed metadata changes before applying them
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get actionPreview;

  /// Action for beginning a selected operation
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get actionStart;

  /// Progress status shown while metadata providers are loading
  ///
  /// In en, this message translates to:
  /// **'Loading metadata providers…'**
  String get statusLoadingMetadataProviders;

  /// Empty state shown when no metadata provider supports the selected media type
  ///
  /// In en, this message translates to:
  /// **'No metadata providers are available for this media type'**
  String get statusNoProvidersForMediaType;

  /// Option for replacing existing item metadata with values from a match
  ///
  /// In en, this message translates to:
  /// **'Overwrite current metadata'**
  String get settingOverwriteCurrentMetadata;

  /// Supporting text for replacing item metadata with values from a match
  ///
  /// In en, this message translates to:
  /// **'Replace existing title, author, description, and related fields'**
  String get settingOverwriteCurrentMetadataDescription;

  /// Option for replacing an item's current cover with a matched image
  ///
  /// In en, this message translates to:
  /// **'Overwrite cover image'**
  String get settingOverwriteCoverImage;

  /// Supporting text for replacing an item's cover with a matched image
  ///
  /// In en, this message translates to:
  /// **'Replace current cover artwork when a match provides one'**
  String get settingOverwriteCoverImageDescription;

  /// Hint explaining that quick match accepts one provider while preview supports multiple providers
  ///
  /// In en, this message translates to:
  /// **'Quick match supports one provider. Use Preview to run multiple providers'**
  String get hintQuickMatchSingleProviderOnly;

  /// Dialog heading for reviewing proposed item metadata changes
  ///
  /// In en, this message translates to:
  /// **'Preview changes'**
  String get headingPreviewChanges;

  /// Summary of how many metadata fields would change in a quick match preview
  ///
  /// In en, this message translates to:
  /// **'{changed} of {total} fields changed'**
  String quickMatchChangeSummary(int changed, int total);

  /// Action for applying the selected quick match changes
  ///
  /// In en, this message translates to:
  /// **'Apply {count}'**
  String actionApplyQuickMatchChanges(int count);

  /// Progress status shown while metadata match results are being searched
  ///
  /// In en, this message translates to:
  /// **'Searching matches…'**
  String get statusSearchingMatches;

  /// Progress status showing completed metadata searches out of the total
  ///
  /// In en, this message translates to:
  /// **'Searching matches… ({completed} of {total} completed)'**
  String statusSearchingMatchesProgress(int completed, int total);

  /// Error shown when a metadata preview cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Could not load preview: {error}'**
  String errorQuickMatchPreviewLoadFailed(String error);

  /// Status shown when a metadata provider did not return a match
  ///
  /// In en, this message translates to:
  /// **'No match'**
  String get statusNoMatch;

  /// Explanation shown when a metadata provider returns no result for an item
  ///
  /// In en, this message translates to:
  /// **'No metadata result was returned for this item with the selected provider'**
  String get statusNoMatchResultForItem;

  /// Error shown when searching metadata providers fails
  ///
  /// In en, this message translates to:
  /// **'Metadata search failed: {error}'**
  String errorMetadataSearchFailed(String error);

  /// Status shown when a metadata match would not change any fields
  ///
  /// In en, this message translates to:
  /// **'No metadata field changes detected for this item'**
  String get statusNoMetadataFieldChanges;

  /// Column heading for current values in a metadata comparison
  ///
  /// In en, this message translates to:
  /// **'Before'**
  String get headingBeforeValue;

  /// Column heading for suggested values in a metadata comparison
  ///
  /// In en, this message translates to:
  /// **'After'**
  String get headingAfterValue;

  /// Validation message shown when no changed items are selected for quick match
  ///
  /// In en, this message translates to:
  /// **'Select at least one matched item with changes to apply'**
  String get errorSelectQuickMatchItems;

  /// Status showing how many items were updated by quick match
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Updated 1 item} other{Updated {count} items}}'**
  String statusQuickMatchItemsUpdated(int count);

  /// Status showing how many selected items had no metadata changes
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item had no changes} other{{count} items had no changes}}'**
  String statusQuickMatchItemsUnchanged(int count);

  /// Status showing how many selected items failed to update
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 item failed} other{{count} items failed}}'**
  String statusQuickMatchItemsFailed(int count);

  /// Error shown when the current item metadata cannot be loaded for matching
  ///
  /// In en, this message translates to:
  /// **'Could not load current item metadata'**
  String get errorLoadCurrentItemMetadataFailed;

  /// Error shown when an item has no title to search with a metadata provider
  ///
  /// In en, this message translates to:
  /// **'No title available for search'**
  String get errorItemTitleUnavailableForSearch;

  /// Status shown when all selected metadata providers return no result
  ///
  /// In en, this message translates to:
  /// **'No results found with any provider'**
  String get statusNoMetadataMatchesFromProviders;

  /// Status shown after a metadata quick match request is sent for selected books
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Metadata change request sent for 1 book} other{Metadata change request sent for {count} books}}'**
  String statusQuickMatchBatchStarted(int count);

  /// Error shown when a metadata quick match request cannot be started
  ///
  /// In en, this message translates to:
  /// **'Could not start the metadata change request'**
  String get errorStartQuickMatchBatchFailed;

  /// Error shown when a metadata quick match request for selected books fails
  ///
  /// In en, this message translates to:
  /// **'Could not quick match selected books: {error}'**
  String errorQuickMatchBatchFailed(String error);

  /// Label for the author cleanup action in settings and library tools
  ///
  /// In en, this message translates to:
  /// **'Remove authors without books'**
  String get actionRemoveAuthorsWithoutBooks;

  /// Progress label shown while checking whether authors have books
  ///
  /// In en, this message translates to:
  /// **'Checking authors…'**
  String get statusCheckingAuthors;

  /// Progress title shown while scanning library authors
  ///
  /// In en, this message translates to:
  /// **'Scanning authors'**
  String get statusScanningAuthors;

  /// Progress message shown before loading library authors
  ///
  /// In en, this message translates to:
  /// **'Preparing to load authors…'**
  String get statusPreparingToLoadAuthors;

  /// Progress title shown while deleting authors without books
  ///
  /// In en, this message translates to:
  /// **'Deleting authors'**
  String get statusDeletingAuthors;

  /// Progress message showing the author currently being deleted
  ///
  /// In en, this message translates to:
  /// **'Deleting {name} ({completed} of {total})'**
  String statusDeletingAuthorProgress(String name, int completed, int total);

  /// Progress message shown while loading a page of library authors
  ///
  /// In en, this message translates to:
  /// **'Loading page {page} with {pageSize} authors per page…'**
  String statusLoadingAuthorsPage(int page, int pageSize);

  /// Progress message summarizing scanned authors and authors with no books
  ///
  /// In en, this message translates to:
  /// **'{scanned, plural, =1{Scanned 1 author} other{Scanned {scanned} authors}} and found {empty, plural, =0{no authors without books} =1{1 author without books} other{{empty} authors without books}}'**
  String statusScannedAuthorsAndFoundEmptyAuthors(int scanned, int empty);

  /// Dialog title shown when every author in the library has books
  ///
  /// In en, this message translates to:
  /// **'No authors to remove'**
  String get headingNoAuthorsToRemove;

  /// Message shown when no authors qualify for removal
  ///
  /// In en, this message translates to:
  /// **'No authors without books were found'**
  String get statusNoAuthorsWithoutBooks;

  /// Confirmation dialog title showing how many authors without books will be deleted
  ///
  /// In en, this message translates to:
  /// **'Delete {count, plural, =1{1 author} other{{count} authors}}?'**
  String headingDeleteAuthorsWithoutBooks(int count);

  /// Confirmation message explaining that authors without books will be permanently removed
  ///
  /// In en, this message translates to:
  /// **'These authors have no books and will be removed permanently'**
  String get confirmDeleteAuthorsWithoutBooks;

  /// Confirmation action showing how many authors will be deleted
  ///
  /// In en, this message translates to:
  /// **'Delete {count}'**
  String actionDeleteAuthorsCount(int count);

  /// Status shown after authors without books are deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted {count, plural, =1{1 author} other{{count} authors}} without books'**
  String statusDeletedAuthorsWithoutBooks(int count);

  /// Error summary showing authors that could not be deleted
  ///
  /// In en, this message translates to:
  /// **'Could not delete {count, plural, =1{1 author} other{{count} authors}}: {names}'**
  String errorDeleteAuthorsWithoutBooksFailed(int count, String names);

  /// Short author list summary with a count of additional names
  ///
  /// In en, this message translates to:
  /// **'{names} and {count} more'**
  String authorNamesWithMoreCount(String names, int count);

  /// Error shown when the author cleanup operation fails
  ///
  /// In en, this message translates to:
  /// **'Could not remove authors without books: {error}'**
  String errorRemoveAuthorsWithoutBooksFailed(String error);

  /// Progress count showing completed work out of a total
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total}'**
  String progressPosition(int completed, int total);

  /// Label for an action that reverses a recent change
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// Label for the elapsed playback time field when setting an item's progress
  ///
  /// In en, this message translates to:
  /// **'Elapsed time'**
  String get fieldElapsedTime;

  /// Hint below the elapsed time field showing the full book duration
  ///
  /// In en, this message translates to:
  /// **'Book length {duration}'**
  String hintBookLength(String duration);

  /// Validation message for an invalid elapsed time value
  ///
  /// In en, this message translates to:
  /// **'Enter time as hours:minutes:seconds'**
  String get validationEnterTimeFormat;

  /// Validation message when entered elapsed time is longer than the book
  ///
  /// In en, this message translates to:
  /// **'Time cannot exceed {duration}'**
  String validationTimeExceedsDuration(String duration);

  /// Validation message when the progress percentage is not a number
  ///
  /// In en, this message translates to:
  /// **'Enter a percentage'**
  String get validationPercentageRequired;

  /// Validation message when the progress percentage is above the maximum
  ///
  /// In en, this message translates to:
  /// **'Percentage cannot exceed 100'**
  String get validationPercentageExceedsMaximum;

  /// Button label showing the date when listening to an item started
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String labelStartedDate(String date);

  /// Button label showing the date when listening to an item finished
  ///
  /// In en, this message translates to:
  /// **'Finished {date}'**
  String labelFinishedDate(String date);

  /// Label for a button that marks an item as finished while editing its progress
  ///
  /// In en, this message translates to:
  /// **'Set finished'**
  String get actionSetFinished;

  /// Status shown after an item is added to the pinned shelf
  ///
  /// In en, this message translates to:
  /// **'Added to the pinned shelf'**
  String get statusPinnedShelfAdded;

  /// Status shown after an item is removed from the pinned shelf
  ///
  /// In en, this message translates to:
  /// **'Removed from the pinned shelf'**
  String get statusPinnedShelfRemoved;

  /// Error shown when reversing a change to the pinned shelf fails
  ///
  /// In en, this message translates to:
  /// **'Could not undo the pinned shelf change: {error}'**
  String errorUndoPinnedShelfChangeFailed(String error);

  /// Tooltip for downloading the currently selected library items
  ///
  /// In en, this message translates to:
  /// **'Download selected items'**
  String get actionDownloadSelectedItems;

  /// Tooltip for deleting the currently selected audiobooks
  ///
  /// In en, this message translates to:
  /// **'Delete selected audiobooks'**
  String get actionDeleteSelectedAudiobooks;

  /// Tooltip explaining that no selected audiobook can be deleted
  ///
  /// In en, this message translates to:
  /// **'No selected audiobooks can be deleted'**
  String get statusNoSelectedAudiobooksCanBeDeleted;

  /// Status shown when a batch metadata change request completes with updated books
  ///
  /// In en, this message translates to:
  /// **'Metadata change request completed with {count, plural, =1{1 book updated} other{{count} books updated}}'**
  String statusQuickMatchBatchCompleted(int count);

  /// Status shown when a batch metadata change request completes without updating books
  ///
  /// In en, this message translates to:
  /// **'Metadata change request completed without updates'**
  String get statusQuickMatchBatchCompletedWithoutUpdates;

  /// Title shown above the playlist picker when adding selected podcast episodes
  ///
  /// In en, this message translates to:
  /// **'Add episodes to playlist'**
  String get headingAddEpisodesToPlaylist;

  /// Status showing how many selected library items were added to a playlist
  ///
  /// In en, this message translates to:
  /// **'Added {count, plural, =1{1 selected item} other{{count} selected items}} to \"{target}\"'**
  String statusItemsAddedToPlaylist(int count, String target);

  /// Status showing how many selected episodes were added to a playlist
  ///
  /// In en, this message translates to:
  /// **'Added {count, plural, =1{1 episode} other{{count} episodes}} to \"{target}\"'**
  String statusEpisodesAddedToPlaylist(int count, String target);

  /// Error shown when selected library items cannot be added to a playlist
  ///
  /// In en, this message translates to:
  /// **'Could not add selected items to playlist'**
  String get errorAddItemsToPlaylistFailed;

  /// Error shown when selected books cannot be added to a playlist
  ///
  /// In en, this message translates to:
  /// **'Could not add books to playlist'**
  String get errorAddBooksToPlaylistFailed;

  /// Error shown when selected podcast episodes cannot be added to a playlist
  ///
  /// In en, this message translates to:
  /// **'Could not add episodes to playlist'**
  String get errorAddEpisodesToPlaylistFailed;

  /// Error shown when selected books cannot be added to a collection
  ///
  /// In en, this message translates to:
  /// **'Could not add books to collection'**
  String get errorAddBooksToCollectionFailed;

  /// Empty state shown when the playlist picker has no playlists the user can edit
  ///
  /// In en, this message translates to:
  /// **'No editable playlists found'**
  String get statusNoEditablePlaylistsFound;

  /// Error shown when playlists cannot be loaded for the playlist picker
  ///
  /// In en, this message translates to:
  /// **'Could not load playlists'**
  String get errorLoadPlaylistsFailed;

  /// Empty state shown when no collections are available in the collection picker
  ///
  /// In en, this message translates to:
  /// **'No collections found'**
  String get statusNoCollectionsFound;

  /// Error shown when collections cannot be loaded for the collection picker
  ///
  /// In en, this message translates to:
  /// **'Could not load collections'**
  String get errorLoadCollectionsFailed;

  /// Compact label showing the selected library filter group and value
  ///
  /// In en, this message translates to:
  /// **'{group} · {value}'**
  String statusActiveFilter(String group, String value);

  /// Compact label showing a selected special library filter
  ///
  /// In en, this message translates to:
  /// **'Special · {value}'**
  String statusSpecialFilter(String value);

  /// Heading for storage settings in a form
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get headingStorage;

  /// Label for the RSS feed address field and tooltip for the feed column in podcast search results
  ///
  /// In en, this message translates to:
  /// **'RSS feed URL'**
  String get fieldRssFeedUrl;

  /// Form field label marked as required
  ///
  /// In en, this message translates to:
  /// **'{label} *'**
  String fieldRequired(String label);

  /// Hint in the podcast genres field for adding a genre
  ///
  /// In en, this message translates to:
  /// **'Add genre'**
  String get hintAddGenre;

  /// Label for the podcast setting that marks its content as explicit
  ///
  /// In en, this message translates to:
  /// **'Explicit content'**
  String get settingPodcastExplicitContent;

  /// Label for automatically downloading new episodes from a podcast
  ///
  /// In en, this message translates to:
  /// **'Auto download new episodes'**
  String get settingPodcastAutoDownloadEpisodes;

  /// Label for creating a podcast after entering its metadata and storage details
  ///
  /// In en, this message translates to:
  /// **'Create podcast'**
  String get actionCreatePodcast;

  /// Validation message shown when a target library folder is required
  ///
  /// In en, this message translates to:
  /// **'Choose a target library folder'**
  String get validationLibraryFolderRequired;

  /// Validation message shown when a required title field is empty
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get validationTitleRequired;

  /// Validation message shown when a required RSS feed URL is empty
  ///
  /// In en, this message translates to:
  /// **'RSS feed URL is required'**
  String get validationRssFeedUrlRequired;

  /// Fallback title shown when a podcast search result has no title
  ///
  /// In en, this message translates to:
  /// **'Untitled podcast'**
  String get statusUntitledPodcast;

  /// Tooltip describing the podcast title and metadata column in search results
  ///
  /// In en, this message translates to:
  /// **'Podcast title and metadata'**
  String get hintPodcastTitleAndMetadata;

  /// Status shown when a podcast search result does not include an RSS feed address
  ///
  /// In en, this message translates to:
  /// **'Missing RSS feed URL'**
  String get statusMissingRssFeedUrl;

  /// Label for adding a podcast and the dialog that creates a podcast library item
  ///
  /// In en, this message translates to:
  /// **'Add podcast'**
  String get actionAddPodcast;

  /// Status shown for a podcast search result that is already in the library
  ///
  /// In en, this message translates to:
  /// **'Already in library'**
  String get statusAlreadyInLibrary;

  /// Empty state shown before a podcast search returns any results
  ///
  /// In en, this message translates to:
  /// **'No podcast search results yet'**
  String get statusNoPodcastSearchResultsYet;

  /// Guidance shown in the empty podcast search results area
  ///
  /// In en, this message translates to:
  /// **'Search by title or creator, or paste an RSS feed URL to start'**
  String get hintSearchOrPasteRssFeed;

  /// Tooltip for clearing the current search query
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get actionClearSearch;

  /// Tooltip for lowering the current playback volume
  ///
  /// In en, this message translates to:
  /// **'Decrease volume'**
  String get actionDecreaseVolume;

  /// Tooltip for raising the current playback volume
  ///
  /// In en, this message translates to:
  /// **'Increase volume'**
  String get actionIncreaseVolume;

  /// Tooltip for opening settings that affect playback
  ///
  /// In en, this message translates to:
  /// **'Playback settings'**
  String get playbackSettings;

  /// Label for the server connected to an account
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get fieldServer;

  /// Status shown when no server address is available for the account
  ///
  /// In en, this message translates to:
  /// **'Server address unavailable'**
  String get statusServerAddressUnavailable;

  /// Status shown when the account server can be reached
  ///
  /// In en, this message translates to:
  /// **'Server available'**
  String get statusServerAvailable;

  /// Status shown when the account server cannot be reached
  ///
  /// In en, this message translates to:
  /// **'Server unavailable'**
  String get statusServerUnavailable;

  /// Role label shown below the signed-in username on the account screen
  ///
  /// In en, this message translates to:
  /// **'{role, select, admin {Administrator} guest {Guest} listener {Listener} other {Listener}}'**
  String accountRoleLabel(String role);

  /// Heading for settings that add a custom message to the server login page
  ///
  /// In en, this message translates to:
  /// **'Custom login message'**
  String get headingCustomLoginMessage;

  /// Label for the custom message displayed on the server login page
  ///
  /// In en, this message translates to:
  /// **'Login message'**
  String get fieldLoginMessage;

  /// Setting that controls whether the custom login message is shown
  ///
  /// In en, this message translates to:
  /// **'Show custom login message'**
  String get settingShowCustomLoginMessage;

  /// Setting that enables username and password sign-in on the server
  ///
  /// In en, this message translates to:
  /// **'Enable local authentication'**
  String get settingEnableLocalAuthentication;

  /// Setting that enables OpenID Connect sign-in on the server
  ///
  /// In en, this message translates to:
  /// **'Enable OpenID authentication'**
  String get settingEnableOpenIdAuthentication;

  /// Label for the OpenID Connect issuer address field
  ///
  /// In en, this message translates to:
  /// **'Issuer URL'**
  String get fieldIssuerUrl;

  /// Label for the OpenID Connect authorization endpoint field
  ///
  /// In en, this message translates to:
  /// **'Authorization URL'**
  String get fieldAuthorizationUrl;

  /// Label for the OpenID Connect token endpoint field
  ///
  /// In en, this message translates to:
  /// **'Token URL'**
  String get fieldTokenUrl;

  /// Label for the OpenID Connect user information endpoint field
  ///
  /// In en, this message translates to:
  /// **'User info URL'**
  String get fieldUserInfoUrl;

  /// Label for the JSON Web Key Set endpoint field
  ///
  /// In en, this message translates to:
  /// **'JWKS URL'**
  String get fieldJwksUrl;

  /// Label for the OpenID Connect logout endpoint field
  ///
  /// In en, this message translates to:
  /// **'Logout URL'**
  String get fieldLogoutUrl;

  /// Label for the OpenID Connect client identifier field
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get fieldClientId;

  /// Label for the OpenID Connect client secret field
  ///
  /// In en, this message translates to:
  /// **'Client secret'**
  String get fieldClientSecret;

  /// Tooltip for revealing a hidden client secret
  ///
  /// In en, this message translates to:
  /// **'Show secret'**
  String get actionShowSecret;

  /// Tooltip for hiding a visible client secret
  ///
  /// In en, this message translates to:
  /// **'Hide secret'**
  String get actionHideSecret;

  /// Label for the signing algorithm used by OpenID tokens
  ///
  /// In en, this message translates to:
  /// **'Signing algorithm'**
  String get fieldSigningAlgorithm;

  /// Label for the allowed redirect addresses used by mobile sign-in
  ///
  /// In en, this message translates to:
  /// **'Mobile redirect URIs'**
  String get fieldMobileRedirectUris;

  /// Hint explaining how to enter mobile redirect addresses
  ///
  /// In en, this message translates to:
  /// **'Add one URI per entry. Use * only as a standalone entry'**
  String get hintMobileRedirectUris;

  /// Label for the server subfolder used in web sign-in redirects
  ///
  /// In en, this message translates to:
  /// **'Web redirect subfolder'**
  String get fieldWebRedirectSubfolder;

  /// Label for the callback address used by web sign-in
  ///
  /// In en, this message translates to:
  /// **'Web callback URL'**
  String get fieldWebCallbackUrl;

  /// Label for the callback address used by mobile sign-in
  ///
  /// In en, this message translates to:
  /// **'Mobile callback URL'**
  String get fieldMobileCallbackUrl;

  /// Label for custom text displayed on the OpenID sign-in button
  ///
  /// In en, this message translates to:
  /// **'OpenID button text'**
  String get fieldOpenIdButtonText;

  /// Label for selecting how OpenID sign-in matches existing server users
  ///
  /// In en, this message translates to:
  /// **'Match existing users by'**
  String get fieldExistingUserMatchMethod;

  /// Option that prevents OpenID sign-in from matching an existing user
  ///
  /// In en, this message translates to:
  /// **'Do not match'**
  String get optionDoNotMatchExistingUsers;

  /// Option that matches an OpenID account to an existing user by email
  ///
  /// In en, this message translates to:
  /// **'Match by email'**
  String get optionMatchExistingUsersByEmail;

  /// Option that matches an OpenID account to an existing user by username
  ///
  /// In en, this message translates to:
  /// **'Match by username'**
  String get optionMatchExistingUsersByUsername;

  /// Setting that automatically opens OpenID sign-in on the login page
  ///
  /// In en, this message translates to:
  /// **'Auto-launch OpenID login'**
  String get settingAutoLaunchOpenIdLogin;

  /// Explanation of the automatic OpenID sign-in redirect setting
  ///
  /// In en, this message translates to:
  /// **'Automatically redirect users to OpenID sign-in on the login page'**
  String get settingAutoLaunchOpenIdLoginDescription;

  /// Setting that creates a local server account for a new OpenID user
  ///
  /// In en, this message translates to:
  /// **'Auto-register OpenID users'**
  String get settingAutoRegisterOpenIdUsers;

  /// Explanation of the automatic local account creation setting for OpenID users
  ///
  /// In en, this message translates to:
  /// **'Create local users automatically when OpenID users sign in for the first time'**
  String get settingAutoRegisterOpenIdUsersDescription;

  /// Label for the OpenID claim that supplies a user's group
  ///
  /// In en, this message translates to:
  /// **'Group claim'**
  String get fieldGroupClaim;

  /// Label for the OpenID claim that supplies advanced server permissions
  ///
  /// In en, this message translates to:
  /// **'Advanced permission claim'**
  String get fieldAdvancedPermissionClaim;

  /// Action that fills OpenID settings from the issuer configuration
  ///
  /// In en, this message translates to:
  /// **'Auto-populate'**
  String get actionAutoPopulateOpenIdConfiguration;

  /// Validation error shown when local and OpenID authentication are both disabled
  ///
  /// In en, this message translates to:
  /// **'At least one authentication method must be enabled'**
  String get errorAuthenticationMethodsRequired;

  /// Validation message shown when a required authentication settings field is empty
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String validationFieldRequired(String field);

  /// Validation message shown when an authentication settings field has an invalid value
  ///
  /// In en, this message translates to:
  /// **'{field} is invalid'**
  String validationFieldInvalid(String field);

  /// Validation message shown when a wildcard is combined with other redirect addresses
  ///
  /// In en, this message translates to:
  /// **'The asterisk (*) must be the only redirect URI when used'**
  String get validationWildcardMustBeOnlyRedirectUri;

  /// Validation message shown when a mobile redirect address is malformed
  ///
  /// In en, this message translates to:
  /// **'Mobile redirect URI {uri} is invalid'**
  String validationMobileRedirectUriInvalid(String uri);

  /// Validation message shown when a redirect subfolder does not start with a slash
  ///
  /// In en, this message translates to:
  /// **'Subfolder must start with /'**
  String get validationSubfolderMustStartWithSlash;

  /// Validation message shown when the root slash is selected as a redirect subfolder
  ///
  /// In en, this message translates to:
  /// **'Subfolder cannot be only /'**
  String get validationSubfolderCannotBeOnlySlash;

  /// Validation message shown when a redirect subfolder ends with a slash
  ///
  /// In en, this message translates to:
  /// **'Subfolder must not end with /'**
  String get validationSubfolderMustNotEndWithSlash;

  /// Validation message shown when a redirect subfolder contains spaces
  ///
  /// In en, this message translates to:
  /// **'Subfolder cannot contain spaces'**
  String get validationSubfolderCannotContainSpaces;

  /// Confirmation dialog title shown before disabling username and password sign-in
  ///
  /// In en, this message translates to:
  /// **'Disable local authentication?'**
  String get headingDisableLocalAuthentication;

  /// Warning shown before disabling local authentication, explaining the recovery risk and recommending a backup admin account
  ///
  /// In en, this message translates to:
  /// **'If local authentication is disabled and OpenID is misconfigured or broken, access can only be restored through a manual database edit. It is highly recommended to keep a backup admin account and local authentication enabled.'**
  String get confirmDisableLocalAuthentication;

  /// Confirmation action for disabling username and password sign-in
  ///
  /// In en, this message translates to:
  /// **'Disable local authentication'**
  String get actionDisableLocalAuthentication;

  /// Confirmation dialog title shown before replacing the server authentication code key
  ///
  /// In en, this message translates to:
  /// **'Rotate authentication code key?'**
  String get headingRotateAuthenticationCodeKey;

  /// Warning shown before rotating the server key for authentication codes
  ///
  /// In en, this message translates to:
  /// **'Authentication codes created with the previous key will stop working. Existing signed-in accounts are not affected'**
  String get confirmRotateAuthenticationCodeKey;

  /// Confirmation action for replacing the server authentication code key
  ///
  /// In en, this message translates to:
  /// **'Rotate authentication code key'**
  String get actionRotateAuthenticationCodeKey;

  /// Error shown when server authentication settings cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load authentication settings'**
  String get errorLoadAuthenticationSettingsFailed;

  /// Error shown when the server authentication code key cannot be rotated
  ///
  /// In en, this message translates to:
  /// **'Failed to rotate authentication code key'**
  String get errorRotateAuthenticationCodeKeyFailed;

  /// Error shown when the server authentication code key disappears before it can be rotated
  ///
  /// In en, this message translates to:
  /// **'Authentication code key is no longer available. Refresh the settings and try again'**
  String get errorAuthenticationCodeKeyUnavailable;

  /// Error shown when the server does not retain a newly rotated authentication code key
  ///
  /// In en, this message translates to:
  /// **'The server did not preserve the new authentication code key'**
  String get errorAuthenticationCodeKeyRotationNotPreserved;

  /// Status shown after the server authentication code key is replaced
  ///
  /// In en, this message translates to:
  /// **'Authentication code key rotated. Codes created with the previous key are now invalid'**
  String get statusAuthenticationCodeKeyRotated;

  /// Status shown after authentication settings are saved to the server
  ///
  /// In en, this message translates to:
  /// **'Authentication settings saved'**
  String get statusAuthenticationSettingsSaved;

  /// Status shown after OpenID settings are filled from issuer metadata
  ///
  /// In en, this message translates to:
  /// **'OpenID fields populated from issuer configuration'**
  String get statusOpenIdFieldsPopulated;

  /// Error shown when authentication settings cannot be saved to the server
  ///
  /// In en, this message translates to:
  /// **'Failed to save authentication settings'**
  String get errorSaveAuthenticationSettingsFailed;

  /// Error shown when OpenID settings cannot be filled from issuer metadata
  ///
  /// In en, this message translates to:
  /// **'Failed to auto-populate OpenID configuration'**
  String get errorAutoPopulateOpenIdConfigurationFailed;

  /// Error shown when OpenID settings are incomplete and local authentication cannot be disabled
  ///
  /// In en, this message translates to:
  /// **'Configure OpenID before disabling local authentication'**
  String get errorConfigureOpenIdBeforeDisablingLocalAuthentication;

  /// Message shown when a signed-out user opens server authentication settings
  ///
  /// In en, this message translates to:
  /// **'No active user. Sign in to manage authentication settings'**
  String get statusNoActiveUserForAuthenticationSettings;

  /// Message shown when a non-admin user opens server authentication settings
  ///
  /// In en, this message translates to:
  /// **'This page requires an admin account'**
  String get statusAdminRequiredForAuthenticationSettings;

  /// Label for saving server authentication settings
  ///
  /// In en, this message translates to:
  /// **'Save authentication settings'**
  String get actionSaveAuthenticationSettings;

  /// Hint shown with authentication settings that may require a server restart
  ///
  /// In en, this message translates to:
  /// **'OpenID changes may require a server restart to fully apply'**
  String get hintOpenIdChangesMayRequireRestart;

  /// Status shown after a labeled value is copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied {label}'**
  String statusCopiedValue(String label);

  /// Error shown when the current user's settings cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Failed to load user settings ({error})'**
  String errorLoadUserAuthenticationSettingsFailed(String error);

  /// Confirmation shown after selected podcast episode downloads are added to the queue
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No episode downloads added to the queue} =1{Episode download added to the queue} other{{count} episode downloads added to the queue}}'**
  String statusEpisodeDownloadsQueued(int count);

  /// Label for immediately deleting listened items managed by smart downloads
  ///
  /// In en, this message translates to:
  /// **'Delete listened items now'**
  String get actionDeleteListenedDownloads;

  /// Status shown when no listened smart downloads are ready for deletion
  ///
  /// In en, this message translates to:
  /// **'No listened smart downloads were ready to delete'**
  String get statusNoListenedDownloadsToDelete;

  /// Status showing how many listened smart downloads were deleted
  ///
  /// In en, this message translates to:
  /// **'Deleted {count, plural, =1{1 listened smart download} other{{count} listened smart downloads}}'**
  String statusDeletedListenedDownloads(int count);

  /// Error shown when listened smart downloads cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'Failed to delete listened smart downloads ({error})'**
  String errorDeleteListenedDownloadsFailed(String error);

  /// Tooltip showing how many books are in a collapsed series card
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 book in the series} other{{count} books in the series}}'**
  String seriesBookCount(int count);

  /// Localized decimal number displayed without a unit or label
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String numberValue(int value);

  /// Compact count showing selected options out of all available options
  ///
  /// In en, this message translates to:
  /// **'{selected}/{total}'**
  String selectionPosition(int selected, int total);

  /// Localized percentage label shown over item progress indicators
  ///
  /// In en, this message translates to:
  /// **'{value}'**
  String progressPercent(double value);

  /// Accessibility label announced while an icon action is processing
  ///
  /// In en, this message translates to:
  /// **'Loading {action}'**
  String statusLoadingAction(String action);

  /// Status shown while a PDF document is loading without a measurable progress value
  ///
  /// In en, this message translates to:
  /// **'Loading PDF…'**
  String get statusLoadingPdf;

  /// Status shown while a PDF document is loading with a progress percentage
  ///
  /// In en, this message translates to:
  /// **'Loading PDF… {progress}'**
  String statusLoadingPdfProgress(String progress);

  /// Equalizer band frequency displayed in hertz
  ///
  /// In en, this message translates to:
  /// **'{value} Hz'**
  String equalizerFrequencyHertz(int value);

  /// Equalizer band frequency displayed in kilohertz
  ///
  /// In en, this message translates to:
  /// **'{value} kHz'**
  String equalizerFrequencyKilohertz(double value);

  /// Equalizer gain value displayed in decibels
  ///
  /// In en, this message translates to:
  /// **'{sign}{value} dB'**
  String equalizerGain(String sign, double value);

  /// Warning shown when non-book files are excluded from an upload grouped as a book
  ///
  /// In en, this message translates to:
  /// **'Non-book sidecar files were ignored while grouping this upload'**
  String get uploadIgnoredNonBookSidecarFiles;

  /// Status showing how many selected books were added to a playlist or collection
  ///
  /// In en, this message translates to:
  /// **'Added {count, plural, =1{1 book} other{{count} books}} to \"{target}\"'**
  String statusBooksAddedToTarget(int count, String target);

  /// Label for the account destination on a watch or a heading above server account details
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// Status shown when saving a change does not alter the existing values
  ///
  /// In en, this message translates to:
  /// **'No updates were necessary'**
  String get statusNoChangesWereNecessary;

  /// Option that pauses playback after a sleep timer expires or an audio interruption occurs
  ///
  /// In en, this message translates to:
  /// **'Pause playback'**
  String get optionPausePlayback;

  /// Option for selecting both available player timelines or media types
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get optionBoth;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
