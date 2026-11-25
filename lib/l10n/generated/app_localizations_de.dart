// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get actionCancel => 'Abbrechen';

  @override
  String get actionClose => 'Schließen';

  @override
  String get actionSave => 'Speichern';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get actionRetry => 'Erneut versuchen';

  @override
  String get actionOk => 'OK';

  @override
  String get settingsAppearanceTitle => 'Darstellungseinstellungen';

  @override
  String get settingsDisplayTitle => 'Anzeige';

  @override
  String get themeSettingsTitle => 'Design';

  @override
  String get themeSettingsSubtitle => 'Designmodus, Farbpalette und benutzerdefinierte Akzentfarbe';

  @override
  String get navigationSettingsTitle => 'Navigation';

  @override
  String get navigationSettingsSubtitle => 'Angezeigte Tabs, ihre Reihenfolge und die Standardansicht festlegen';

  @override
  String get settingsOtherTitle => 'Weitere Einstellungen';

  @override
  String get fieldLanguage => 'Sprache';

  @override
  String get fieldNote => 'Notiz';

  @override
  String get optionSystemDefault => 'Systemstandard';

  @override
  String get fieldModel => 'Modell';

  @override
  String get fieldVoice => 'Stimme';

  @override
  String get fieldVoiceId => 'Stimmen-ID';

  @override
  String get actionShow => 'Anzeigen';

  @override
  String get actionHide => 'Ausblenden';

  @override
  String get localeEnglishName => 'Englisch';

  @override
  String get localeGermanName => 'Deutsch';

  @override
  String get startupAudioServiceStatus => 'Audiodienst wird gestartet…';

  @override
  String get startupUnableToStartTitle => 'yaabsa konnte nicht gestartet werden';

  @override
  String get startupAudioServiceError =>
      'Der Audiodienst konnte nicht gestartet werden. Schließe die App und starte sie neu';

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

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Stunden',
      one: '$countString Stunde',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Minuten',
      one: '$countString Minute',
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
      other: '$countString Sekunden',
      one: '$countString Sekunde',
    );
    return '$_temp0';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    final intl.NumberFormat hoursNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);
    final intl.NumberFormat minutesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hoursString Stunden',
      one: '$hoursString Stunde',
    );
    String _temp1 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutesString Minuten',
      one: '$minutesString Minute',
    );
    return '$_temp0 $_temp1';
  }

  @override
  String bookCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Bücher', one: '1 Buch');
    return '$_temp0';
  }

  @override
  String seriesCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Serien', one: '1 Serie');
    return '$_temp0';
  }

  @override
  String get statusNoBooksForAuthor => 'Keine Bücher für diesen Autor gefunden';

  @override
  String trackCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Tracks', one: '1 Track');
    return '$_temp0';
  }

  @override
  String episodeCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Folgen', one: '1 Folge');
    return '$_temp0';
  }

  @override
  String get libraryItems => 'Bibliothekseinträge';

  @override
  String get navSeries => 'Serien';

  @override
  String get navAuthors => 'Autoren';

  @override
  String get optionAutomatic => 'Automatisch';

  @override
  String get optionHidden => 'Ausgeblendet';

  @override
  String get librarySubtitleModeChooseFields => 'Felder auswählen';

  @override
  String get librarySubtitleModeAutomaticDescription => 'Zeigt Informationen passend zur aktuellen Sortierung';

  @override
  String get librarySubtitleModeHiddenDescription => 'Blendet Untertitelinformationen aus';

  @override
  String get librarySubtitleModeChooseFieldsDescription =>
      'Wähle bis zu drei Details aus, die unter Bibliothekseinträgen, Serien oder Autoren angezeigt werden';

  @override
  String get fieldAuthor => 'Autor';

  @override
  String get fieldDuration => 'Dauer';

  @override
  String get fieldSize => 'Größe';

  @override
  String get fieldTracks => 'Tracks';

  @override
  String get fieldAddedDate => 'Hinzugefügt am';

  @override
  String get fieldPublishedYear => 'Erscheinungsjahr';

  @override
  String get fieldNarrator => 'Sprecher';

  @override
  String get fieldFileBirthDate => 'Datei-Erstellungsdatum';

  @override
  String get fieldFileModifiedDate => 'Dateiänderungsdatum';

  @override
  String get fieldBooks => 'Bücher';

  @override
  String get fieldTotalDuration => 'Gesamtdauer';

  @override
  String get fieldUpdatedDate => 'Aktualisiert am';

  @override
  String get dateAdded => 'Hinzugefügt';

  @override
  String get dateModified => 'Geändert';

  @override
  String get dateUpdated => 'Aktualisiert';

  @override
  String get dateToday => 'Heute';

  @override
  String get dateYesterday => 'Gestern';

  @override
  String get playbackTitle => 'Wiedergabe';

  @override
  String get playbackPause => 'Pausieren';

  @override
  String get playbackPlay => 'Abspielen';

  @override
  String get playbackStop => 'Stoppen';

  @override
  String get playbackNext => 'Weiter';

  @override
  String get playbackPrevious => 'Zurück';

  @override
  String get playbackFastForward => 'Vorspulen';

  @override
  String get playbackRewind => 'Zurückspulen';

  @override
  String get playbackPlayLastPlayed => 'Zuletzt Gehörtes abspielen';

  @override
  String get trayQuitApp => 'App beenden';

  @override
  String get aaosInactiveStatus => 'Die Android-Automotive-Integration ist inaktiv';

  @override
  String get aaosAndroidOnlyStatus => 'Android Automotive ist nur unter Android verfügbar';

  @override
  String get aaosDetectedStatus => 'Android Automotive OS erkannt';

  @override
  String get aaosNotDetectedStatus => 'Android Automotive OS wurde auf diesem Gerät nicht erkannt';

  @override
  String get downloadLocationDefault => 'Standardordner';

  @override
  String get downloadLocationUnsupportedWeb => 'Im Web nicht unterstützt';

  @override
  String downloadLocationSystemDownloads(String path) {
    return 'Systemordner „Downloads“ ($path)';
  }

  @override
  String get downloadLocationDocumentsFallback => 'App-Dokumenteordner (Ersatz)';

  @override
  String get downloadLocationPrivateDocuments => 'App-Dokumenteordner (privater App-Speicher)';

  @override
  String get downloadLocationSandboxedDocuments => 'App-Dokumenteordner (vom Betriebssystem isoliert)';

  @override
  String get downloadLocationAppDocuments => 'App-Dokumenteordner';

  @override
  String get downloadNotSupportedWeb => 'Downloads werden im Web nicht unterstützt';

  @override
  String get downloadLocationUnavailableAndroid =>
      'Auf den ausgewählten Android-Ordner kann nicht mehr zugegriffen werden. Wähle ihn erneut aus';

  @override
  String get downloadLocationMustBeLocal => 'Der Downloadordner muss auf dieser Plattform lokal sein';

  @override
  String get changelogUpdates => 'Aktualisierungen';

  @override
  String get playbackPlayFromHere => 'Ab hier abspielen';

  @override
  String get shelfContinueListening => 'Weiterhören';

  @override
  String get navLibraries => 'Bibliotheken';

  @override
  String get navDownloads => 'Downloads';

  @override
  String get actionMore => 'Mehr';

  @override
  String get downloadedMedia => 'Heruntergeladene Medien';

  @override
  String get untitledEpisode => 'Folge ohne Titel';

  @override
  String get statusUnableToLoadRetry => 'Laden nicht möglich. Zum erneuten Versuchen auswählen';

  @override
  String get statusMayTakeTimeToLoad => 'Das Laden kann eine Weile dauern';

  @override
  String get statusLoadingContent => 'Inhalte werden geladen';

  @override
  String get statusLoadingLibrary => 'Deine Bibliothek wird geladen';

  @override
  String get errorBrowseNotReady => 'Die Android-Automotive-Ansicht ist noch nicht bereit';

  @override
  String get errorAuthenticationRequired => 'Authentifizierung erforderlich';

  @override
  String get errorNoContentSignedOut => 'Bei abgemeldetem Konto sind keine Inhalte verfügbar';

  @override
  String get authSignInThroughSettings => 'Über die Einstellungen anmelden';

  @override
  String get errorAndroidAutoConnectionRequired => 'Verbinde dich mit Android Auto, um Inhalte zu durchsuchen';

  @override
  String itemCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Einträge', one: '1 Eintrag');
    return '$_temp0';
  }

  @override
  String get filterAll => 'Alle';

  @override
  String get shelfRecentlyAdded => 'Kürzlich hinzugefügt';

  @override
  String get shelfLatestEpisodes => 'Neueste Folgen';

  @override
  String get navCollections => 'Sammlungen';

  @override
  String get navPlaylists => 'Wiedergabelisten';

  @override
  String get navDiscovery => 'Entdecken';

  @override
  String get shelfContinueSeries => 'Serie fortsetzen';

  @override
  String get navNarrators => 'Sprecher';

  @override
  String listRangeTitle(String listName, int start, int end) {
    final intl.NumberFormat startNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String startString = startNumberFormat.format(start);
    final intl.NumberFormat endNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String endString = endNumberFormat.format(end);

    return '$listName $startString bis $endString';
  }

  @override
  String get statusDownloaded => 'Heruntergeladen';

  @override
  String get readerReadAloud => 'Vorlesen';

  @override
  String get readerBookNarration => 'Buchvorlesung';

  @override
  String get playbackNextChapter => 'Nächstes Kapitel';

  @override
  String get playbackPreviousChapter => 'Vorheriges Kapitel';

  @override
  String transferRatePerSecond(String rate) {
    return '$rate/s';
  }

  @override
  String durationCompactHours(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString h';
  }

  @override
  String durationCompactMinutes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString min';
  }

  @override
  String durationCompactSeconds(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString s';
  }

  @override
  String durationCompactHoursMinutes(int hours, int minutes) {
    final intl.NumberFormat hoursNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);
    final intl.NumberFormat minutesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);

    return '$hoursString h $minutesString min';
  }

  @override
  String durationCompactMinutesSeconds(int minutes, int seconds) {
    final intl.NumberFormat minutesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minutesString = minutesNumberFormat.format(minutes);
    final intl.NumberFormat secondsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    return '$minutesString min $secondsString s';
  }

  @override
  String readerReadAloudEstimatedTime(String time) {
    return 'Vorlesen · noch $time';
  }

  @override
  String get homeShelf => 'Regal';

  @override
  String get mediaTypeAudiobook => 'Hörbuch';

  @override
  String get mediaTypePodcast => 'Podcast';

  @override
  String get shelfContinueReading => 'Weiterlesen';

  @override
  String get shelfPinned => 'Angeheftet';

  @override
  String get shelfListenAgain => 'Erneut anhören';

  @override
  String get shelfDiscover => 'Entdecken';

  @override
  String get shelfRecentlyAddedSeries => 'Kürzlich hinzugefügte Serien';

  @override
  String get shelfRecentlyAddedAuthors => 'Kürzlich hinzugefügte Autoren';

  @override
  String get sleepTimerStopPlayback => 'Wiedergabe beenden';

  @override
  String get seekBarMarkersChapters => 'Nur Kapitel';

  @override
  String get seekBarMarkersBookmarks => 'Nur Lesezeichen';

  @override
  String get seekBarMarkersBoth => 'Lesezeichen und Kapitel';

  @override
  String get liveUpdateCurrentTime => 'Aktuelle Zeit anzeigen';

  @override
  String get liveUpdateRemainingTime => 'Verbleibende Zeit anzeigen';

  @override
  String get liveUpdateSleepTimer => 'Sleeptimer anzeigen';

  @override
  String get liveUpdateProgressPercentage => 'Fortschritt in Prozent anzeigen';

  @override
  String get readerDeviceVoices => 'Gerätestimmen';

  @override
  String get validationRequestHeadersRequired => 'Name und Wert des Headers sind erforderlich';

  @override
  String get validationRequestHeadersInvalid => 'Gib einen gültigen Headernamen und -wert ein';

  @override
  String get actionAdd => 'Hinzufügen';

  @override
  String get navLibrary => 'Bibliothek';

  @override
  String get statusDownloadComplete => 'Download abgeschlossen';

  @override
  String get statusDownloadCanceled => 'Download abgebrochen';

  @override
  String get statusDownloadFailed => 'Download fehlgeschlagen';

  @override
  String get statusDownloadPaused => 'Download pausiert';

  @override
  String get errorNotificationsPermissionRequired =>
      'Erlaube Benachrichtigungen, damit Dateien im Hintergrund heruntergeladen werden können';

  @override
  String get errorDownloadsUnavailableWeb => 'Downloads werden im Web nicht unterstützt';

  @override
  String get errorUserRequired => 'Melde dich an, bevor du Medien herunterlädst';

  @override
  String get errorDownloadMediaNotFound => 'Das ausgewählte Medium ist nicht mehr verfügbar';

  @override
  String get errorDownloadMediaUnavailable => 'Die Mediendateien sind auf dem Server nicht verfügbar';

  @override
  String get errorPodcastEpisodeRequired => 'Wähle eine Podcastfolge zum Herunterladen aus';

  @override
  String get errorServerUnavailable => 'Der Server ist für Downloads nicht verfügbar';

  @override
  String get errorDownloadQueueUnavailable =>
      'Der Download konnte nicht zur Warteschlange hinzugefügt werden. Überprüfe deine Verbindung und versuche es erneut';

  @override
  String get errorDownloadQueueIncomplete =>
      'Nicht alle Dateien konnten zur Downloadwarteschlange hinzugefügt werden. Versuche es erneut';

  @override
  String get errorAudioFileCountRequired => 'Wähle mindestens eine Audiodatei aus';

  @override
  String get errorSafFolderUnavailable =>
      'Der ausgewählte Android-Ordner konnte nicht für den Download vorbereitet werden. Wähle den Ordner erneut aus und versuche es noch einmal';

  @override
  String get errorNoDownloadableFiles => 'Keine herunterladbaren Dateien gefunden';

  @override
  String downloadNotificationRunningTitle(String displayName) {
    return '$displayName wird heruntergeladen';
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
    return '$numFinished von $numTotal · Fortschritt $progress';
  }

  @override
  String downloadNotificationCompleteBody(String displayName, String filename) {
    return '$displayName ($filename)\nAlle Dateien heruntergeladen';
  }

  @override
  String downloadNotificationCanceledBody(String displayName, String filename) {
    return '$displayName ($filename)\nDownload abgebrochen';
  }

  @override
  String downloadNotificationFailedBody(String displayName, String filename) {
    return '$displayName ($filename)\nDownload fehlgeschlagen';
  }

  @override
  String downloadNotificationPausedBody(String displayName, String progress, String networkSpeed) {
    return '$displayName\nFortschritt $progress · Geschwindigkeit $networkSpeed';
  }

  @override
  String downloadNotificationBatchCompleteBody(String displayName) {
    return '$displayName\nAlle Dateien heruntergeladen';
  }

  @override
  String downloadNotificationBatchCanceledBody(String displayName) {
    return '$displayName\nDownload abgebrochen';
  }

  @override
  String downloadNotificationBatchFailedBody(String displayName) {
    return '$displayName\nDownload fehlgeschlagen';
  }

  @override
  String downloadNotificationBatchPausedBody(String displayName, String progress) {
    return '$displayName\nFortschritt $progress';
  }

  @override
  String get audioFileModeAll => 'Alle Dateien';

  @override
  String get audioFileModeFromCurrent => 'Alle Dateien ab der aktuellen Datei';

  @override
  String get errorDownloadSessionChanged => 'Dein angemeldetes Konto wurde gewechselt. Starte den Download erneut';

  @override
  String errorDownloadMediaIssue(String issue) {
    return 'Mediendateien sind auf dem Server nicht verfügbar. $issue';
  }

  @override
  String get playbackKeepAliveQuiet => 'Leise';

  @override
  String get playbackKeepAliveMedium => 'Mittel';

  @override
  String get playbackKeepAliveStronger => 'Stärker';

  @override
  String get actionDone => 'Fertig';

  @override
  String get actionSet => 'Festlegen';

  @override
  String get actionUnselectAll => 'Auswahl aufheben';

  @override
  String get actionDeleteSelected => 'Auswahl löschen';

  @override
  String get actionRefresh => 'Aktualisieren';

  @override
  String get actionOpen => 'Öffnen';

  @override
  String get actionBack => 'Zurück';

  @override
  String get actionDismissWarning => 'Warnung ausblenden';

  @override
  String get actionViewRelease => 'Release ansehen';

  @override
  String get actionLater => 'Später';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldDescription => 'Beschreibung';

  @override
  String get fieldHours => 'Stunden';

  @override
  String get fieldMinutes => 'Minuten';

  @override
  String get fieldSeconds => 'Sekunden';

  @override
  String get fieldUser => 'Benutzer';

  @override
  String get fieldDevice => 'Gerät';

  @override
  String get fieldDate => 'Datum';

  @override
  String get fieldTime => 'Zeit';

  @override
  String get fieldProgress => 'Fortschritt';

  @override
  String get inputOptional => 'Optional';

  @override
  String selectedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählt',
      one: '1 ausgewählt',
    );
    return '$_temp0';
  }

  @override
  String sessionCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Sitzungen', one: '1 Sitzung');
    return '$_temp0';
  }

  @override
  String get sessionCloseSuccess => 'Sitzung geschlossen';

  @override
  String get sessionCloseFailure => 'Sitzung konnte nicht geschlossen werden';

  @override
  String get sessionNoSharedSessions => 'Keine freigegebenen Sitzungen gefunden';

  @override
  String get sessionSignInRequired => 'Kein aktiver Benutzer. Melde dich an, um Sitzungen zu verwalten';

  @override
  String get sessionFilterUser => 'Nach Benutzer filtern';

  @override
  String get headingOpenSessions => 'Offene Sitzungen';

  @override
  String get headingSharedSessions => 'Freigegebene Sitzungen';

  @override
  String get statusNoOptionsAvailable => 'Keine Optionen verfügbar';

  @override
  String sessionDeleteSuccess(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Sitzungen gelöscht',
      one: '1 Sitzung gelöscht',
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
      other: '$countString Sitzungen konnten nicht gelöscht werden. Sieh in den Protokollen nach',
      one: '1 Sitzung konnte nicht gelöscht werden. Sieh in den Protokollen nach',
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
      other: '$countString ausgewählte Sitzungen löschen? Dies kann nicht rückgängig gemacht werden',
      one: 'Diese Sitzung löschen? Dies kann nicht rückgängig gemacht werden',
    );
    return '$_temp0';
  }

  @override
  String get sessionDeleteTitle => 'Ausgewählte Sitzungen löschen';

  @override
  String get sessionFilterEpisode => 'Nach Folge filtern';

  @override
  String get sessionAllEpisodes => 'Alle Folgen';

  @override
  String get errorCouldNotLoadUser => 'Benutzer konnte nicht geladen werden';

  @override
  String get paginationPerPage => 'Pro Seite';

  @override
  String paginationTotal(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Gesamt $countString';
  }

  @override
  String paginationPage(int page, int pages) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);
    final intl.NumberFormat pagesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pagesString = pagesNumberFormat.format(pages);

    return 'Seite $pageString von $pagesString';
  }

  @override
  String get paginationPreviousPage => 'Vorherige Seite';

  @override
  String get paginationNextPage => 'Nächste Seite';

  @override
  String get changelogTitle => 'Änderungsprotokoll';

  @override
  String get changelogWhatsNew => 'Neuigkeiten';

  @override
  String changelogVersion(String version) {
    return 'Version $version';
  }

  @override
  String get changelogSponsors => 'Unterstützer';

  @override
  String get changelogErrorLoad => 'Änderungsprotokoll konnte nicht geladen werden';

  @override
  String get changelogNoReleaseNotes => 'Für diese Version gibt es noch keine Versionshinweise';

  @override
  String get changelogDontShowAgain => 'Nicht erneut anzeigen';

  @override
  String get changelogErrorSavePreference => 'Einstellung konnte nicht gespeichert werden. Versuche es erneut';

  @override
  String get changelogErrorSponsorOpen => 'GitHub Sponsors konnte nicht geöffnet werden. Versuche es erneut';

  @override
  String get errorConnectionUnavailable => 'Keine Serververbindung verfügbar';

  @override
  String get errorAdminLibraryStatistics => 'Bibliotheksweite Statistiken sind nur für Administratoren verfügbar';

  @override
  String get promptSignInToViewLibraryStatistics => 'Du benötigst ein angemeldetes Administratorkonto';

  @override
  String get errorRefreshLists => 'Listen konnten nicht aktualisiert werden. Versuche es erneut';

  @override
  String get searchBooks => 'Bücher suchen';

  @override
  String get searchBooksTitleAuthorSeries => 'Titel, Autor oder Serie';

  @override
  String get deleteFromServerOnlyTitle => 'Nur aus Audiobookshelf löschen';

  @override
  String get deleteFromServerOnlySubtitle =>
      'Entfernt den Eintrag vom Server und lässt die Mediendateien auf der Festplatte. Nach einem erneuten Bibliotheksscan kann er wieder erscheinen';

  @override
  String get deleteFromServerAndFilesTitle => 'Aus Audiobookshelf und dem Dateisystem löschen';

  @override
  String get deleteFromServerAndFilesSubtitle => 'Entfernt den Eintrag und seine Mediendateien dauerhaft';

  @override
  String get errorPdfReadingLinuxOnly => 'PDFs können derzeit nur unter Linux gelesen werden';

  @override
  String get filesystemParentFolder => 'Übergeordneter Ordner';

  @override
  String get filesystemUseCurrentFolder => 'Aktuellen Ordner verwenden';

  @override
  String get appUpdateAvailableTitle => 'Neue yaabsa-Version';

  @override
  String appUpdateAvailableMessage(String latestVersion, String currentVersion) {
    return 'Version $latestVersion ist verfügbar. Du verwendest Version $currentVersion';
  }

  @override
  String get serverUpdateAvailableTitle => 'Serverupdate verfügbar';

  @override
  String serverUpdateAvailableMessage(String version) {
    return 'Ein neues Update für deinen Audiobookshelf-Server ist verfügbar: Version $version';
  }

  @override
  String get sessionDeleteSingleTitle => 'Sitzung löschen';

  @override
  String get sessionDeleteSharedTitle => 'Freigegebene Sitzung löschen';

  @override
  String get sessionDeleteSharedPrompt =>
      'Diese freigegebene Sitzung dauerhaft löschen? Dies kann nicht rückgängig gemacht werden';

  @override
  String get sessionSharedTitle => 'Freigegebene Sitzung';

  @override
  String get sessionCloseAction => 'Sitzung schließen';

  @override
  String get fieldSessionId => 'Sitzungs-ID';

  @override
  String get unknownMediaItem => 'Unbekannter Eintrag';

  @override
  String get sessionNoResults => 'Keine Hörsitzungen gefunden';

  @override
  String get sessionNoOpenSessions => 'Keine offenen Sitzungen gefunden';

  @override
  String get actionOpenDownloads => 'Downloads öffnen';

  @override
  String get booksNoneSelected => 'Keine Bücher ausgewählt';

  @override
  String deleteAudiobookTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hörbücher löschen?',
      one: 'Hörbuch löschen?',
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
      other: 'Diese Aktion entfernt $countString Hörbücher aus Audiobookshelf und kann nicht rückgängig gemacht werden',
      one: 'Diese Aktion entfernt das Hörbuch aus Audiobookshelf und kann nicht rückgängig gemacht werden',
    );
    return '$_temp0';
  }

  @override
  String get deleteModePrompt => 'Wähle eine Löschoption';

  @override
  String deleteSkippedNonAudiobooks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählte Einträge sind keine Hörbücher und werden übersprungen',
      one: '1 ausgewählter Eintrag ist kein Hörbuch und wird übersprungen',
    );
    return '$_temp0';
  }

  @override
  String get filesystemRoot => 'Stammordner';

  @override
  String get filesystemNoDirectories => 'Keine Ordner verfügbar';

  @override
  String get browseServerFolders => 'Serverordner durchsuchen';

  @override
  String get errorUnableToLoadContent => 'Inhalte konnten nicht geladen werden';

  @override
  String get errorRetryCheckConnection =>
      'Versuche es erneut. Falls das Problem weiterhin besteht, überprüfe die Serververbindung';

  @override
  String get errorSectionRequiresServerConnection =>
      'Für diesen Bereich ist eine aktive Serververbindung erforderlich. Stelle die Verbindung wieder her und versuche es erneut';

  @override
  String get actionLoadMore => 'Mehr laden';

  @override
  String get errorLoadMoreRetry => 'Weitere Inhalte konnten nicht geladen werden. Versuche es erneut';

  @override
  String get fieldTitle => 'Titel';

  @override
  String serverUpdateAvailableShort(String version) {
    return 'Update $version';
  }

  @override
  String get errorSettingsBackupTooLarge => 'Das Einstellungen-Backup ist zu groß';

  @override
  String get errorChooseSettingsBackup => 'Wähle ein yaabsa-Einstellungen-Backup aus';

  @override
  String get errorSettingsBackupVersion => 'Diese Version des Einstellungen-Backups wird nicht unterstützt';

  @override
  String get errorSettingsBackupAccounts => 'Der Kontoeinstellungen-Bereich im Backup ist ungültig';

  @override
  String get errorSettingsBackupMissingSection => 'Im Backup fehlt ein Einstellungsbereich';

  @override
  String get errorSettingsBackupInvalidValue => 'Das Backup enthält einen ungültigen Wert';

  @override
  String get errorCredentialsRequired => 'Gib einen Benutzernamen und ein Passwort ein';

  @override
  String get errorAccountSessionInvalid => 'Der Server hat keine gültige Kontositzung zurückgegeben';

  @override
  String get errorWearPlaybackFailed =>
      'Wiedergabe fehlgeschlagen. Überprüfe die Verbindung oder verwende einen Download';

  @override
  String get errorMediaCannotPlay => 'Dieser Eintrag kann nicht abgespielt werden';

  @override
  String get filterAllAudiobooks => 'Alle Hörbücher';

  @override
  String get cacheLibrariesList => 'Bibliotheksliste';

  @override
  String get cacheLibraryDetails => 'Bibliotheksdetails';

  @override
  String get cacheItemDetails => 'Details zum Eintrag';

  @override
  String get cacheItemResource => 'Ressource des Eintrags';

  @override
  String get cacheLibraryFilterData => 'Bibliotheksfilter';

  @override
  String get cacheLibrarySeries => 'Bibliotheksserien';

  @override
  String get cacheCurrentUserProfile => 'Profil des aktuellen Benutzers';

  @override
  String get errorElevenLabsApiKeyRejected =>
      'ElevenLabs hat den API-Schlüssel abgelehnt. Überprüfe ihn in den Vorleseeinstellungen';

  @override
  String get errorElevenLabsModelsReadPermission =>
      'Mit diesem Schlüssel können keine Modelle aufgelistet werden. Aktiviere die Berechtigung „Models read“ oder verwende ein verfügbares Modell';

  @override
  String get errorElevenLabsVoicesReadPermission =>
      'Mit diesem Schlüssel können keine Stimmen aufgelistet werden. Aktiviere die Berechtigung „Voices read“ oder gib eine Stimmen-ID ein';

  @override
  String get errorElevenLabsSpeechPermission =>
      'Aktiviere für diesen ElevenLabs-Schlüssel die Berechtigung „Text to speech“';

  @override
  String get errorElevenLabsNoCredits => 'Dein ElevenLabs-Konto hat kein Guthaben für Sprachausgabe';

  @override
  String get errorElevenLabsBillingIssue => 'Überprüfe deine ElevenLabs-Abrechnung und dein Guthaben für Sprachausgabe';

  @override
  String get errorElevenLabsVoiceOrModelNotFound =>
      'Die ausgewählte ElevenLabs-Stimme oder das Modell wurde nicht gefunden';

  @override
  String get errorElevenLabsCharacterLimit =>
      'Dieser Text überschreitet die Zeichenbegrenzung des ausgewählten ElevenLabs-Modells';

  @override
  String get errorElevenLabsPlanRequired =>
      'Für die ausgewählte ElevenLabs-Stimme oder das Modell ist ein anderer Tarif erforderlich';

  @override
  String get errorElevenLabsUnauthorized =>
      'ElevenLabs konnte diese Anfrage nicht autorisieren. Überprüfe den API-Schlüssel und seine Berechtigungen';

  @override
  String get errorElevenLabsNotAllowed => 'Dein ElevenLabs-Schlüssel oder -Konto erlaubt diesen Vorgang nicht';

  @override
  String get errorElevenLabsRateLimited =>
      'ElevenLabs ist ausgelastet oder begrenzt derzeit Anfragen. Versuche es gleich noch einmal';

  @override
  String get errorElevenLabsSpeechSettingsRejected =>
      'ElevenLabs hat die Spracheinstellungen abgelehnt. Überprüfe Modell, Sprache und Stimmen-ID';

  @override
  String get errorElevenLabsUnavailable =>
      'ElevenLabs ist nicht erreichbar. Überprüfe deine Verbindung und versuche es erneut';

  @override
  String get errorSecureStorageUnavailable =>
      'Auf den sicheren Speicher konnte nicht zugegriffen werden. Entsperre deinen Schlüsselbund und versuche es erneut';

  @override
  String get errorElevenLabsApiKeyMissing => 'Füge deinen ElevenLabs-API-Schlüssel in den Vorleseeinstellungen hinzu';

  @override
  String get errorElevenLabsModelListInvalid => 'ElevenLabs hat eine ungültige Modellliste zurückgegeben';

  @override
  String get errorElevenLabsVoiceListInvalid => 'ElevenLabs hat eine ungültige Stimmenliste zurückgegeben';

  @override
  String get errorElevenLabsVoicePageInvalid =>
      'ElevenLabs hat eine ungültige Seitennavigation für die Stimmenliste zurückgegeben';

  @override
  String get errorElevenLabsVoiceRequired =>
      'Wähle in den Vorleseeinstellungen eine ElevenLabs-Stimme aus oder gib ihre Stimmen-ID ein';

  @override
  String get errorReaderLanguageCodeInvalid =>
      'Gib in den Vorleseeinstellungen einen gültigen bevorzugten Sprachcode ein';

  @override
  String get errorElevenLabsModelRequired => 'Wähle ein ElevenLabs-Modell der Version 2 oder 4 aus';

  @override
  String get errorElevenLabsRequestIdMissing =>
      'ElevenLabs hat keine Anfrage-ID für die kombinierte Sprachausgabe zurückgegeben';

  @override
  String get errorElevenLabsSpeechAudioMissing => 'ElevenLabs hat keine Sprachausgabe zurückgegeben';

  @override
  String get errorElevenLabsSpeechAudioInvalid => 'ElevenLabs hat eine ungültige Sprachausgabe zurückgegeben';

  @override
  String get errorReaderSpeechAudioUnavailable => 'Die vorgelesene Audiodatei konnte nicht abgespielt werden';

  @override
  String get errorReaderSpeechProviderUnavailable => 'Der ausgewählte Sprachausgabedienst ist nicht verfügbar';

  @override
  String get errorDeviceSpeechUnavailable => 'Das Gerät konnte die Sprachausgabe nicht starten';

  @override
  String get errorCastConnectionBusy => 'Eine Cast-Verbindung wird bereits vorbereitet';

  @override
  String get errorCastNoAudio => 'Es ist kein Audio zum Übertragen verfügbar';

  @override
  String get errorCastPlaybackChanged => 'Die Wiedergabe wurde während der Verbindung zum Empfänger geändert';

  @override
  String get errorCastCancelled => 'Cast-Wiedergabe abgebrochen';

  @override
  String get errorCastTrackUnknown => 'Der aktuelle Track konnte nicht ermittelt werden';

  @override
  String get errorCastServerConnectionRequired => 'Verbinde dich mit dem Server, bevor du diesen Eintrag überträgst';

  @override
  String get errorCastStreamUnavailable => 'Für die Übertragung konnte kein Audio-Stream vorbereitet werden';

  @override
  String get errorCastTrackUnavailable => 'Der Server hat keinen abspielbaren Audio-Track bereitgestellt';

  @override
  String get errorCastPlayableUrlUnavailable => 'Der Server hat keine abspielbare Audioadresse bereitgestellt';

  @override
  String get errorCastNoDeviceConnected => 'Es ist kein Cast-Gerät verbunden';

  @override
  String get errorCastDeviceGone => 'Dieses Cast-Gerät ist nicht mehr verfügbar';

  @override
  String get errorChromecastUnavailable => 'Chromecast ist auf diesem Gerät nicht verfügbar';

  @override
  String get errorChromecastGone => 'Dieser Chromecast ist nicht mehr verfügbar';

  @override
  String get errorCastReceiverLoadFailed => 'Der Empfänger konnte dieses Audio nicht laden';

  @override
  String get errorCastReceiverLoadUnconfirmed => 'Der Empfänger hat das Laden dieses Audios nicht bestätigt';

  @override
  String get errorCastSeekFailed => 'Der Empfänger konnte nicht zur gewünschten Position springen';

  @override
  String get errorCastPlaybackStartFailed =>
      'Der Empfänger hat die Wiedergabe nicht gestartet. Überprüfe die Audio- und Ausgabefunktionen';

  @override
  String get errorCastPlaybackStalled =>
      'Die Wiedergabe auf dem Empfänger ist stehen geblieben. Überprüfe die Audio- und Ausgabefunktionen';

  @override
  String get errorCastReceiverReportedError => 'Der Empfänger hat einen Wiedergabefehler gemeldet';

  @override
  String get errorCastReceiverCannotPlay => 'Der Empfänger konnte dieses Audio nicht abspielen';

  @override
  String get errorCastReceiverUnresponsive => 'Der Empfänger reagiert nicht mehr';

  @override
  String get errorCastVolumeUnsupported => 'Dieser Empfänger unterstützt keine Lautstärkeregelung';

  @override
  String get errorCastSpeedUnavailable => 'Die Wiedergabegeschwindigkeit ist auf diesem Empfänger nicht verfügbar';

  @override
  String get actionSelectAll => 'Alles auswählen';

  @override
  String get actionClearAll => 'Alles leeren';

  @override
  String get actionApply => 'Übernehmen';

  @override
  String get actionDisconnect => 'Trennen';

  @override
  String get actionResume => 'Fortsetzen';

  @override
  String get fieldVolume => 'Lautstärke';

  @override
  String get fieldYear => 'Jahr';

  @override
  String get fieldFiles => 'Dateien';

  @override
  String get fieldListeningTime => 'Hörzeit';

  @override
  String get fieldTotalListening => 'Gesamte Hörzeit';

  @override
  String get fieldSessions => 'Sitzungen';

  @override
  String get fieldAverageSession => 'Durchschnittliche Sitzung';

  @override
  String get fieldMedianSession => 'Mittlere Sitzungsdauer';

  @override
  String get fieldLongestSession => 'Längste Sitzung';

  @override
  String get fieldLongestStreak => 'Längste Serie';

  @override
  String get fieldBookListening => 'Hörbuch-Wiedergabe';

  @override
  String get fieldPodcastListening => 'Podcast-Wiedergabe';

  @override
  String get fieldUniqueItems => 'Unterschiedliche Einträge';

  @override
  String get fieldUniqueAuthors => 'Unterschiedliche Autoren';

  @override
  String get fieldFavoriteWeekday => 'Bevorzugter Wochentag';

  @override
  String get fieldFavoriteHour => 'Bevorzugte Stunde';

  @override
  String get fieldFirstSession => 'Erste Sitzung';

  @override
  String get fieldLatestSession => 'Letzte Sitzung';

  @override
  String get fieldAverageActiveDay => 'Durchschnittlicher aktiver Tag';

  @override
  String get fieldPeakMonth => 'Stärkster Monat';

  @override
  String get fieldBooksFinished => 'Abgeschlossene Bücher';

  @override
  String get fieldBooksListened => 'Gehörte Bücher';

  @override
  String get fieldActiveDays => 'Aktive Tage';

  @override
  String authorCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Autoren', one: '1 Autor');
    return '$_temp0';
  }

  @override
  String dayCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Tage', one: '1 Tag');
    return '$_temp0';
  }

  @override
  String fileCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Dateien', one: '1 Datei');
    return '$_temp0';
  }

  @override
  String get headingTopItems => 'Häufigste Einträge';

  @override
  String get headingTopAuthors => 'Top-Autoren';

  @override
  String get headingTopGenres => 'Top-Genres';

  @override
  String get headingTopNarrators => 'Top-Sprecher';

  @override
  String get headingWeekdayBreakdown => 'Aufschlüsselung nach Wochentag';

  @override
  String get headingBusiestHours => 'Aktivste Stunden';

  @override
  String get headingTopMonths => 'Top-Monate';

  @override
  String get headingListeningConsistency => 'Hörgewohnheiten';

  @override
  String headingYearRewind(int year) {
    final intl.NumberFormat yearNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String yearString = yearNumberFormat.format(year);

    return 'Jahresrückblick $yearString';
  }

  @override
  String statsLastDays(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Letzte $countString Tage',
      one: 'Letzter Tag',
    );
    return '$_temp0';
  }

  @override
  String get statsDailyAverage => 'Tagesdurchschnitt';

  @override
  String get statsOverallRuntime => 'Gesamtlaufzeit';

  @override
  String get statsTotalSize => 'Gesamtgröße';

  @override
  String get statsLibraryOverview => 'Bibliotheksübersicht';

  @override
  String get statsLongestItems => 'Längste Einträge';

  @override
  String get statsLargestItems => 'Größte Einträge';

  @override
  String get statsNoGenreInformation => 'Keine Genreinformationen verfügbar';

  @override
  String get statsNoAuthorInformation => 'Keine Autoreninformationen verfügbar';

  @override
  String get statsNoItemDurationInformation => 'Keine Informationen zur Dauer der Einträge verfügbar';

  @override
  String get statsNoItemSizeInformation => 'Keine Informationen zur Größe der Einträge verfügbar';

  @override
  String get statsLibraryLoadError => 'Bibliotheksstatistiken konnten nicht geladen werden';

  @override
  String get statsPeakDay => 'Stärkster Tag';

  @override
  String get statsListeningUnavailable => 'Hörzeiten nicht verfügbar';

  @override
  String get statsActivityUnavailable => 'Höraktivitäten konnten nicht geladen werden';

  @override
  String get statsAdvancedUnavailable => 'Erweiterte Analysen konnten nicht berechnet werden';

  @override
  String get statsYearUnavailable => 'Für dieses Jahr sind keine Rückblickdaten verfügbar';

  @override
  String get statsNoWeekdayData => 'Für diesen Wochentag sind keine Hördaten verfügbar';

  @override
  String get statsNoRecentSessions => 'Keine aktuellen Sitzungen verfügbar';

  @override
  String get statsNoTopAuthorsYear => 'Für dieses Jahr gibt es keine Top-Autoren';

  @override
  String get statsNoTopGenresYear => 'Für dieses Jahr gibt es keine Top-Genres';

  @override
  String get weekdayMonday => 'Montag';

  @override
  String get weekdayTuesday => 'Dienstag';

  @override
  String get weekdayWednesday => 'Mittwoch';

  @override
  String get weekdayThursday => 'Donnerstag';

  @override
  String get weekdayFriday => 'Freitag';

  @override
  String get weekdaySaturday => 'Samstag';

  @override
  String get weekdaySunday => 'Sonntag';

  @override
  String get sleepTimerQuickStart => 'Schnellstart';

  @override
  String get sleepTimerEndOfChapter => 'Kapitelende';

  @override
  String get sleepTimerAddChapter => 'Kapitel hinzufügen';

  @override
  String sleepTimerAddMinutes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString Min. hinzufügen';
  }

  @override
  String sleepTimerChaptersRemaining(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $countString Kapitel',
      one: 'Noch 1 Kapitel',
    );
    return '$_temp0';
  }

  @override
  String get sleepTimerNoChapterAvailable => 'An der aktuellen Position ist kein Kapitel verfügbar';

  @override
  String get validationPositiveNumberRequired => 'Gib eine Zahl größer als null ein';

  @override
  String get speedCustomValue => 'Benutzerdefinierter Wert';

  @override
  String speedRangeHint(double minimum, double maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return '$minimumString–$maximumString';
  }

  @override
  String get playbackSpeedLoading => 'Wiedergabe wird geladen';

  @override
  String get playbackSpeed => 'Wiedergabegeschwindigkeit';

  @override
  String playerVolumeTooltip(int volume) {
    final intl.NumberFormat volumeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String volumeString = volumeNumberFormat.format(volume);

    return 'Lautstärke $volumeString%';
  }

  @override
  String get castDevices => 'Cast-Geräte';

  @override
  String get playerSearchAgain => 'Erneut suchen';

  @override
  String get playerBookmarkInReader => 'Verwende den Reader, um eine Textstelle als Lesezeichen zu speichern';

  @override
  String get playerNoMediaToBookmark => 'Kein aktives Medium, für das ein Lesezeichen gesetzt werden kann';

  @override
  String get playerSleepTimerStart => 'Zum Start des Sleeptimers zurückkehren';

  @override
  String get uploadAutoFetchMetadata => 'Metadaten automatisch abrufen';

  @override
  String get uploadAutoAcceptMetadata => 'Metadaten automatisch übernehmen';

  @override
  String get uploadAutocompleteEntities => 'Serien und Autoren automatisch vervollständigen';

  @override
  String get uploadRequiresAdmin => 'Erfordert Administratorrechte';

  @override
  String get uploadBulkMetadata => 'Metadaten der Warteschlange gesammelt aktualisieren';

  @override
  String get uploadApplyAuthor => 'Autor übernehmen';

  @override
  String get uploadApplySeries => 'Serie übernehmen';

  @override
  String get uploadNoMetadataResult => 'Für diesen Eintrag wurden keine Metadaten gefunden';

  @override
  String get uploadMetadataLookupFailed => 'Metadatensuche fehlgeschlagen';

  @override
  String get uploadNoApiSession => 'Keine API-Sitzung verfügbar';

  @override
  String get uploadCanceled => 'Upload abgebrochen';

  @override
  String get uploadCheckingDestination => 'Zielpfad wird überprüft…';

  @override
  String get uploadQueueEmpty => 'Deine Warteschlange ist leer';

  @override
  String get uploadPathIssuesTitle => 'Probleme bei der Pfadprüfung gefunden';

  @override
  String get uploadPathIssuesPrompt =>
      'Bei einigen Einträgen gibt es Zielkonflikte oder Fehler bei der Pfadprüfung. Trotzdem fortfahren?';

  @override
  String get uploadCancelUploads => 'Uploads abbrechen';

  @override
  String get uploadStart => 'Upload starten';

  @override
  String get uploadFetchMetadata => 'Metadaten abrufen';

  @override
  String get fieldItemsListened => 'Gehörte Einträge';

  @override
  String get rangeLess => 'Weniger';

  @override
  String get rangeMore => 'Mehr';

  @override
  String statsTotalOverDays(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Gesamtwert der letzten $countString Tage';
  }

  @override
  String statsDateRange(DateTime start, DateTime end) {
    final intl.DateFormat startDateFormat = intl.DateFormat.yMMMd(localeName);
    final String startString = startDateFormat.format(start);
    final intl.DateFormat endDateFormat = intl.DateFormat.yMMMd(localeName);
    final String endString = endDateFormat.format(end);

    return '$startString bis $endString';
  }

  @override
  String statsDateAndListeningTime(DateTime date, String duration) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString · $duration';
  }

  @override
  String get statsNoTopNarratorsYear => 'Für dieses Jahr gibt es keine Top-Sprecher';

  @override
  String get statsLoadingAnalytics => 'Erweiterte Analysen werden geladen…';

  @override
  String statsLoadingAnalyticsProgress(String pages, String sessions) {
    return 'Erweiterte Analysen werden geladen · $pages · $sessions';
  }

  @override
  String durationCompactDays(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString T';
  }

  @override
  String durationCompactDaysHours(int days, int hours) {
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String daysString = daysNumberFormat.format(days);
    final intl.NumberFormat hoursNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String hoursString = hoursNumberFormat.format(hours);

    return '$daysString T $hoursString Std';
  }

  @override
  String durationCompactYears(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString J';
  }

  @override
  String get fieldRange => 'Zeitraum';

  @override
  String statsPeakMonthValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get statsYearLoadError => 'Jahresrückblick konnte nicht geladen werden';

  @override
  String get unknownAuthor => 'Unbekannter Autor';

  @override
  String get unknownGenre => 'Unbekanntes Genre';

  @override
  String get fieldCurrentStreak => 'Hörserie';

  @override
  String get mediaTypeAudiobooks => 'Hörbücher';

  @override
  String get mediaTypePodcasts => 'Podcasts';

  @override
  String get fieldPages => 'Seiten';

  @override
  String progressCountLoaded(String loaded, String total, String unit) {
    return '$loaded von $total $unit';
  }

  @override
  String get statusUnknown => 'Unbekannt';

  @override
  String get playbackSleepTimer => 'Sleeptimer';

  @override
  String get statsAchievementFirstHour => 'Erste Stunde';

  @override
  String get statsAchievementAllDayListener => 'Ganztagshörer';

  @override
  String get statsAchievementCenturyClub => '100-Stunden-Club';

  @override
  String get statsAchievementTimeTraveler => 'Zeitreisender';

  @override
  String get statsAchievementListeningLegend => 'Hörlegende';

  @override
  String get statsAchievementMasterOfTime => 'Meister der Zeit';

  @override
  String get statsAchievementFirstDiscovery => 'Erste Entdeckung';

  @override
  String get statsAchievementCuriousListener => 'Neugieriger Hörer';

  @override
  String get statsAchievementShelfExplorer => 'Bücherregal-Entdecker';

  @override
  String get statsAchievementLibraryRegular => 'Stammhörer der Bibliothek';

  @override
  String get statsAchievementCatalogConqueror => 'Katalogbezwinger';

  @override
  String get statsAchievementWorldOfStories => 'Welt der Geschichten';

  @override
  String get statsAchievementDayOne => 'Erster Tag';

  @override
  String get statsAchievementWeekOfStories => 'Eine Woche voller Geschichten';

  @override
  String get statsAchievementMonthlyHabit => 'Monatliche Hörgewohnheit';

  @override
  String get statsAchievementDedicatedListener => 'Engagierter Hörer';

  @override
  String get statsAchievementYearRoundListener => 'Ganzjahreshörer';

  @override
  String get statsAchievementEverydayExplorer => 'Täglicher Entdecker';

  @override
  String get statsAchievementBackForMore => 'Wieder dabei';

  @override
  String get statsAchievementOnARoll => 'Im Hörfluss';

  @override
  String get statsAchievementPerfectWeek => 'Perfekte Woche';

  @override
  String get statsAchievementFortnightFocus => 'Zwei Wochen Fokus';

  @override
  String get statsAchievementUnstoppable => 'Unaufhaltsam';

  @override
  String get statsAchievementStoryMarathon => 'Geschichtenmarathon';

  @override
  String get statsAchievementPressPlay => 'Wiedergabe gestartet';

  @override
  String get statsAchievementGettingComfortable => 'Gut eingehört';

  @override
  String get statsAchievementRegularListener => 'Regelmäßiger Hörer';

  @override
  String get statsAchievementSessionSpecialist => 'Sitzungsprofi';

  @override
  String get statsAchievementAlwaysListening => 'Immer am Hören';

  @override
  String get statsAchievementPlaybackMaster => 'Wiedergabemeister';

  @override
  String get statsAchievementNewVoice => 'Neue Stimme';

  @override
  String get statsAchievementAuthorSampler => 'Autorensampler';

  @override
  String get statsAchievementLiteraryWanderer => 'Literarischer Wanderer';

  @override
  String get statsAchievementVoiceCollector => 'Stimmensammler';

  @override
  String get statsAchievementAuthorAuthority => 'Autorenkenner';

  @override
  String get statsAchievementPantheonOfVoices => 'Pantheon der Autoren';

  @override
  String get statsAchievementSettlingIn => 'Sich einhören';

  @override
  String get statsAchievementHalfHourHero => 'Halbstundenheld';

  @override
  String get statsAchievementDeepListener => 'Intensiver Hörer';

  @override
  String get statsAchievementLostInAStory => 'In einer Geschichte versunken';

  @override
  String get statsAchievementEpicSession => 'Epische Sitzung';

  @override
  String get statsAchievementEnduranceLegend => 'Ausdauerlegende';

  @override
  String get statsAchievementQuickChapter => 'Kurzes Kapitel';

  @override
  String get statsAchievementFocusedListener => 'Fokussierter Hörer';

  @override
  String get statsAchievementInTheZone => 'Ganz im Flow';

  @override
  String get statsAchievementLongformLover => 'Liebhaber langer Geschichten';

  @override
  String get statsAchievementImmersiveListener => 'Ganz in der Geschichte';

  @override
  String get statsAchievementBookBeginner => 'Hörbuch-Einsteiger';

  @override
  String get statsAchievementChapterChaser => 'Kapiteljäger';

  @override
  String get statsAchievementBookworm => 'Bücherwurm';

  @override
  String get statsAchievementAudioBibliophile => 'Hörbuch-Bibliophiler';

  @override
  String get statsAchievementLivingLibrary => 'Lebendige Bibliothek';

  @override
  String get statsAchievementKeeperOfStories => 'Hüter der Geschichten';

  @override
  String get statsAchievementFirstEpisode => 'Erste Folge';

  @override
  String get statsAchievementPodcastCurious => 'Podcast-Neuling';

  @override
  String get statsAchievementEpisodeExplorer => 'Folgenentdecker';

  @override
  String get statsAchievementFeedFollower => 'Feed-Follower';

  @override
  String get statsAchievementPodcastPro => 'Podcast-Profi';

  @override
  String get statsAchievementAirwaveArchivist => 'Podcast-Archivar';

  @override
  String get statsAchievementJourneyBegins => 'Die Reise beginnt';

  @override
  String get statsAchievementOneWeekIn => 'Eine Woche dabei';

  @override
  String get statsAchievementMonthOfStories => 'Ein Monat voller Geschichten';

  @override
  String get statsAchievementSeasonedListener => 'Erfahrener Hörer';

  @override
  String get statsAchievementAnniversary => 'Jahrestag';

  @override
  String get statsAchievementLongtimeCompanion => 'Langjähriger Begleiter';

  @override
  String get fieldItemsExplored => 'Erkundete Einträge';

  @override
  String get fieldAuthorsDiscovered => 'Entdeckte Autoren';

  @override
  String get fieldListeningJourney => 'Hörreise';

  @override
  String get statsAchievementNotUnlocked => 'Noch nicht freigeschaltet';

  @override
  String get statsAchievementHighestReached => 'Höchster Meilenstein erreicht';

  @override
  String statsAchievementNext(String label, String value) {
    return 'Als Nächstes: $label · $value';
  }

  @override
  String get statsLoadingSessionHistory => 'Sitzungsverlauf wird geladen…';

  @override
  String statsUnlockingAchievements(String sessions) {
    return 'Detaillierte Erfolge werden ermittelt · $sessions';
  }

  @override
  String get statsRetryAchievements => 'Detaillierte Erfolge erneut laden';

  @override
  String get actionAccept => 'Akzeptieren';

  @override
  String get actionReject => 'Ablehnen';

  @override
  String get fieldSeries => 'Serie';

  @override
  String get fieldLibraryFolder => 'Bibliotheksordner';

  @override
  String get fieldMetadataProvider => 'Metadatenanbieter';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusChecking => 'Wird überprüft';

  @override
  String get statusWarning => 'Warnung';

  @override
  String get statusUploading => 'Wird hochgeladen';

  @override
  String get statusUploaded => 'Hochgeladen';

  @override
  String get statusSaving => 'Wird gespeichert';

  @override
  String get statusApplying => 'Wird angewendet…';

  @override
  String get statusFailed => 'Fehlgeschlagen';

  @override
  String get statusCanceled => 'Abgebrochen';

  @override
  String removeNamedItem(String name) {
    return '$name entfernen';
  }

  @override
  String get uploadSuggestedMetadata => 'Vorgeschlagene Metadaten';

  @override
  String get uploadDropFilesOrFolder => 'Lege Dateien oder Ordner hier ab oder wähle sie unten aus';

  @override
  String get uploadDropFiles => 'Lege Dateien hier ab oder wähle sie unten aus';

  @override
  String get uploadChooseFilesOrFolder => 'Wähle unten Dateien oder einen Ordner aus';

  @override
  String get uploadChooseFilesBelow => 'Wähle unten Dateien aus';

  @override
  String get uploadUnsupportedFiles => 'Die ausgewählte Quelle enthält keine unterstützten Dateien';

  @override
  String get uploadSelectLibraryFolder => 'Wähle vor dem Upload einen Bibliotheksordner aus';

  @override
  String get uploadNoActiveSession => 'Keine aktive authentifizierte API-Sitzung';

  @override
  String get uploadNothingQueued => 'Keine Uploads in der Warteschlange';

  @override
  String uploadRetryStarted(int attempt, int maximum) {
    final intl.NumberFormat attemptNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String attemptString = attemptNumberFormat.format(attempt);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Upload wird erneut versucht ($attemptString/$maximumString)…';
  }

  @override
  String get uploading => 'Wird hochgeladen…';

  @override
  String get uploadWaitingForServer => 'Upload abgeschlossen. Warte auf die Verarbeitung durch den Server…';

  @override
  String get uploadFailed => 'Upload fehlgeschlagen';

  @override
  String uploadRetryNetwork(int attempt, int maximum) {
    final intl.NumberFormat attemptNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String attemptString = attemptNumberFormat.format(attempt);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Netzwerkunterbrechung erkannt. Erneuter Versuch ($attemptString/$maximumString)…';
  }

  @override
  String uploadRetryIssue(int attempt, int maximum) {
    final intl.NumberFormat attemptNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String attemptString = attemptNumberFormat.format(attempt);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Upload-Problem erkannt. Erneuter Versuch ($attemptString/$maximumString)…';
  }

  @override
  String get uploadCanceledAfterConflictReview => 'Upload nach Prüfung der Pfadkonflikte abgebrochen';

  @override
  String get uploadFilesUploadedScanFailed =>
      'Dateien hochgeladen, aber der Buchscan ist fehlgeschlagen. Scanne dieses Buch erneut';

  @override
  String uploadTargetLibrary(String library) {
    return 'In $library hochladen';
  }

  @override
  String uploadAddFilesToItem(String item) {
    return 'Dateien zu $item hinzufügen';
  }

  @override
  String uploadItemIdentity(String title, String author, String series) {
    return '$title · $author · $series';
  }

  @override
  String uploadExistingFileConflict(String file) {
    return '$file (eine Datei mit diesem Namen ist in diesem Buch bereits vorhanden)';
  }

  @override
  String uploadExistingDestination(String item) {
    return '$item (Zielpfad ist bereits vorhanden)';
  }

  @override
  String uploadExistingDestinationAs(String item, String title) {
    return '$item (Ziel ist bereits als „$title“ vorhanden)';
  }

  @override
  String uploadPathCheckFailed(String item) {
    return '$item (Pfadprüfung fehlgeschlagen)';
  }

  @override
  String uploadFinishedSummary(int succeeded, int failed) {
    final intl.NumberFormat succeededNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String succeededString = succeededNumberFormat.format(succeeded);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);

    return 'Upload abgeschlossen · $succeededString erfolgreich · $failedString fehlgeschlagen oder abgebrochen';
  }

  @override
  String get settingsSearchHint => 'Einstellungen durchsuchen';

  @override
  String get actionRemove => 'Entfernen';

  @override
  String get actionQueueAll => 'Alle Einträge einreihen';

  @override
  String get actionRemoveFromQueue => 'Aus Warteschlange entfernen';

  @override
  String settingsControlLoadFailed(String label) {
    return '$label konnte nicht geladen werden';
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
  String get fieldUsername => 'Benutzername';

  @override
  String get fieldPassword => 'Passwort';

  @override
  String get fieldApiKey => 'API-Schlüssel';

  @override
  String get fieldServerAddress => 'Serveradresse';

  @override
  String get fieldValue => 'Wert';

  @override
  String get fieldHeaderName => 'Headername';

  @override
  String get actionImport => 'Importieren';

  @override
  String get actionExport => 'Exportieren';

  @override
  String get actionCopy => 'Kopieren';

  @override
  String get actionChange => 'Ändern';

  @override
  String get actionSignIn => 'Anmelden';

  @override
  String get actionScanQrCode => 'QR-Code scannen';

  @override
  String get actionCloseScanner => 'Scanner schließen';

  @override
  String get headingAdvancedOptions => 'Erweiterte Optionen';

  @override
  String get statusCopied => 'Kopiert';

  @override
  String get statusCheckingServer => 'Server wird überprüft…';

  @override
  String get statusSigningIn => 'Anmeldung läuft…';

  @override
  String get statusConnected => 'Verbunden';

  @override
  String get authGuestPasswordCannotChange => 'Gastpasswort kann nicht geändert werden';

  @override
  String get authWatchConnected => 'Uhr erfolgreich verbunden';

  @override
  String get authOpenIdRedirect =>
      'Setze den Vorgang in deinem Browser fort, um die OpenID-Connect-Anmeldung abzuschließen';

  @override
  String get authSignInWear => 'Melde dich an, um deine Wear-OS-Uhr zu verbinden';

  @override
  String get authSignInServer => 'Melde dich bei deinem Audiobookshelf-Server an';

  @override
  String get authServerAddressHint => 'https://your-audiobookshelf.example';

  @override
  String get authHttpHeadersWarning =>
      'Deine benutzerdefinierten Header werden unverschlüsselt über HTTP gesendet und können daher von anderen Personen im Netzwerk gelesen werden. Verwende HTTPS, wenn dein Server es unterstützt';

  @override
  String authWebSupportNote(String url) {
    return 'Die Web-Unterstützung ist eingeschränkt. Melde Probleme in der yaabsa-Diskussion unter $url';
  }

  @override
  String get authNoSupportedMethod => 'Auf diesem Server ist keine unterstützte Authentifizierungsmethode aktiviert';

  @override
  String get authConnectWithApiKey => 'Mit API-Schlüssel verbinden';

  @override
  String get authApiKeyHelp => 'Verwende statt Benutzername und Passwort einen API-Schlüssel';

  @override
  String get authImportCodeTitle => 'Authentifizierungscode importieren';

  @override
  String get authCodeHint => 'Füge den Authentifizierungscode hier ein';

  @override
  String get authCameraUnavailable =>
      'Der Kamerazugriff ist nicht verfügbar. Erlaube den Kamerazugriff in den Geräteeinstellungen oder füge stattdessen den Code ein';

  @override
  String get authScanCodeTitle => 'Authentifizierungscode scannen';

  @override
  String get authScanCodeInstruction => 'Richte die Kamera auf den QR-Code';

  @override
  String get authChangeInitialPasswordTitle => 'Initiales Passwort ändern';

  @override
  String get authInitialPasswordWarning =>
      'Zu deiner Sicherheit kann das initiale Passwort aus diesem Authentifizierungscode nur einmal verwendet werden';

  @override
  String get authConfirmPassword => 'Neues Passwort bestätigen';

  @override
  String get authInitialPasswordRequired => 'Gib ein neues Passwort ein';

  @override
  String get authPasswordsDoNotMatch => 'Die Passwörter stimmen nicht überein';

  @override
  String get validationServerAddressRequired => 'Gib eine gültige Serveradresse ein';

  @override
  String get errorLocalLoginDisabled =>
      'Die lokale Anmeldung ist auf diesem Server deaktiviert. Verwende stattdessen OpenID Connect';

  @override
  String get validationApiKeyRequired => 'Gib einen API-Schlüssel ein';

  @override
  String get errorApiKeyInvalidResponse => 'Die API-Schlüssel-Anmeldung hat eine ungültige Antwort zurückgegeben';

  @override
  String get errorInitialPasswordUnavailable =>
      'Das initiale Passwort ist nicht verfügbar. Gib das Kontopasswort manuell ein';

  @override
  String get errorGuestPasswordNotRotated =>
      'Die Anmeldung wurde abgebrochen, weil das Gastpasswort nicht geändert werden kann';

  @override
  String get errorPasswordChangeRequired =>
      'Ändere das Passwort, nachdem du einen Authentifizierungscode verwendet hast';

  @override
  String get authGuestPasswordWarning =>
      'Audiobookshelf erlaubt Gastbenutzern nicht, ihr Passwort zu ändern. Das initiale Passwort bleibt nach dieser Anmeldung gültig. Fahre nur fort, wenn du dieses Risiko akzeptierst';

  @override
  String get errorWatchTokenMissing => 'Der Server hat kein Anmeldetoken für die Uhr zurückgegeben';

  @override
  String get errorWatchCredentialSendFailed =>
      'Die Anmeldedaten konnten nicht an die Uhr gesendet werden. Stelle sicher, dass sie auf die Verbindung wartet, und versuche es erneut';

  @override
  String get errorOpenIdDisabled => 'OpenID Connect ist auf diesem Server nicht aktiviert';

  @override
  String errorOpenIdStartFailed(String error) {
    return 'Die OpenID-Connect-Anmeldung konnte nicht gestartet werden: $error';
  }

  @override
  String get authHeaderNameDuplicate => 'Ein Header mit diesem Namen ist bereits vorhanden';

  @override
  String get actionContinue => 'Weiter';

  @override
  String get actionEdit => 'Bearbeiten';

  @override
  String get headingCustomHeaders => 'Benutzerdefinierte Header';

  @override
  String get authUseApiKey => 'API-Schlüssel verwenden';

  @override
  String get fieldAuthenticationCode => 'Authentifizierungscode';

  @override
  String get errorNoLibrarySelected => 'Keine Bibliothek ausgewählt. Wähle eine in der Bibliotheksauswahl aus';

  @override
  String get errorBookLibrariesOnly => 'Dieser Bereich ist nur für Buchbibliotheken verfügbar';

  @override
  String errorLoadingNamedContent(String content) {
    return '$content konnte nicht geladen werden';
  }

  @override
  String get searchNoResults => 'Keine Ergebnisse gefunden';

  @override
  String searchNoResultsFor(String query) {
    return 'Keine Ergebnisse für „$query“ gefunden';
  }

  @override
  String searchResultsFor(String query) {
    return 'Suchergebnisse für „$query“';
  }

  @override
  String get searchResults => 'Suchergebnisse';

  @override
  String searchResultCount(String name, String count) {
    return '$name · $count';
  }

  @override
  String get fieldTags => 'Tags';

  @override
  String get fieldGenres => 'Genres';

  @override
  String get fieldCollection => 'Sammlung';

  @override
  String get fieldPlaylist => 'Wiedergabeliste';

  @override
  String get actionEditBooks => 'Bücher bearbeiten';

  @override
  String get actionEditDetails => 'Details bearbeiten';

  @override
  String get actionCreatePlaylist => 'Wiedergabeliste erstellen';

  @override
  String get actionCreateCollection => 'Sammlung erstellen';

  @override
  String editNamedEntity(String entityType) {
    return '$entityType bearbeiten';
  }

  @override
  String deleteNamedEntityMessage(String name) {
    return '„$name“ wird dauerhaft entfernt';
  }

  @override
  String get errorNoActiveUser => 'Kein aktiver Benutzer';

  @override
  String get offlineLibraryEmptyTitle => 'Deine Offlinebibliothek beginnt hier';

  @override
  String get offlineLibraryEmptyMessage => 'Lade ein Buch oder eine Folge herunter, um sie offline anzuhören';

  @override
  String get statusNoDownloadsInView => 'Keine Downloads in dieser Ansicht';

  @override
  String get statusPodcastNoPlayableEpisodes => 'Dieser Podcast enthält keine abspielbaren Folgen';

  @override
  String get errorPodcastAlreadyInLibrary => 'Dieser Podcast ist bereits in deiner Bibliothek';

  @override
  String get errorPodcastFeedUrlMissing => 'Dieses Ergebnis enthält keine RSS-Feed-URL. Füge die Feed-URL direkt ein';

  @override
  String get errorPodcastFeedUnreadable =>
      'Dieser RSS-Feed konnte nicht gelesen werden. Überprüfe die URL und versuche es erneut';

  @override
  String get statusCreatingPodcast => 'Podcast wird erstellt…';

  @override
  String statusPodcastAdded(String library) {
    return 'Podcast zu $library hinzugefügt';
  }

  @override
  String get errorPodcastCreateFailed => 'Podcast konnte nicht erstellt werden';

  @override
  String get errorPodcastLibraryRequired => 'Wechsle zu einer Podcastbibliothek, um diesen Bereich zu verwenden';

  @override
  String get errorAdminRequired => 'Für diese Aktion ist ein Administratorkonto erforderlich';

  @override
  String get podcastAddTitle => 'Podcasts hinzufügen';

  @override
  String get podcastSearchHint => 'Podcasts suchen oder eine RSS-URL einfügen';

  @override
  String get statusNoSearchResultsYet => 'Noch keine Suchergebnisse';

  @override
  String get headingYourListening => 'Dein Hörverhalten';

  @override
  String get headingRecentPace => 'Aktuelles Tempo';

  @override
  String get headingActivity => 'Aktivität';

  @override
  String get headingWeekdayRhythm => 'Wochentagsrhythmus';

  @override
  String get headingRecentSessions => 'Letzte Sitzungen';

  @override
  String get actionViewAll => 'Alle anzeigen';

  @override
  String get headingAchievements => 'Erfolge';

  @override
  String get statsLoadAdvancedPrompt => 'Erweiterte Analysen laden?';

  @override
  String get actionLoad => 'Laden';

  @override
  String get statsLoadAdvancedAnalytics => 'Erweiterte Analysen laden';

  @override
  String get statusNoSeriesInLibrary => 'Keine Serien in dieser Bibliothek gefunden';

  @override
  String get statusNoAuthorsInLibrary => 'Keine Autoren in dieser Bibliothek gefunden';

  @override
  String get statusNoNarratorsInLibrary => 'Keine Sprecher in dieser Bibliothek gefunden';

  @override
  String get statusNoBooksInSeries => 'Keine Bücher in dieser Serie gefunden';

  @override
  String get statusNoRecentEpisodes => 'Keine unvollständigen aktuellen Folgen gefunden';

  @override
  String get errorPlaylistUnavailable => 'Details zur Wiedergabeliste konnten nicht geladen werden';

  @override
  String get errorPlaylistMissing => 'Die Wiedergabeliste ist nicht mehr verfügbar';

  @override
  String get errorCollectionUnavailable => 'Details zur Sammlung konnten nicht geladen werden';

  @override
  String get errorCollectionMissing => 'Die Sammlung ist nicht mehr verfügbar';

  @override
  String get actionPlayRandomItem => 'Zufällig abspielen';

  @override
  String actionSortBy(String value) {
    return 'Sortieren nach $value';
  }

  @override
  String get statusNoPersonalizedSections => 'Noch keine personalisierten Bereiche verfügbar';

  @override
  String get errorRefreshWhenConnected =>
      'Ziehe zum Aktualisieren nach unten, sobald die Verbindung wiederhergestellt ist';

  @override
  String get errorRefreshAndTryAgain => 'Ziehe zum Aktualisieren nach unten und versuche es erneut';

  @override
  String get errorQueueVisibleItems =>
      'Sichtbare Einträge konnten nicht zur Wiedergabewarteschlange hinzugefügt werden';

  @override
  String get actionClear => 'Leeren';

  @override
  String get actionClearQueue => 'Warteschlange leeren';

  @override
  String get actionExpand => 'Ausklappen';

  @override
  String get actionCollapse => 'Einklappen';

  @override
  String get actionUpload => 'Hochladen';

  @override
  String get actionOpenUploader => 'Uploader öffnen';

  @override
  String get searchInLibrary => 'Diese Bibliothek durchsuchen';

  @override
  String get actionSaveBooks => 'Bücher speichern';

  @override
  String statusNamedEntityUpdated(String entityType) {
    return '$entityType aktualisiert';
  }

  @override
  String statusNamedBooksUpdated(String entityType) {
    return 'Bücher von $entityType aktualisiert';
  }

  @override
  String statusNamedEntityDeleted(String entityType) {
    return '$entityType gelöscht';
  }

  @override
  String errorNamedEntityUpdateFailed(String entityType) {
    return '$entityType konnte nicht aktualisiert werden';
  }

  @override
  String errorNamedBooksUpdateFailed(String entityType) {
    return 'Bücher von $entityType konnten nicht aktualisiert werden';
  }

  @override
  String errorNamedEntityDeleteFailed(String entityType) {
    return '$entityType konnte nicht gelöscht werden';
  }

  @override
  String get actionCreateEmpty => 'Leere Liste erstellen';

  @override
  String get statusNoManagedLists => 'Noch keine Listen vorhanden';

  @override
  String get promptCreateManagedList => 'Erstelle eine Liste, um Einträge für später zusammenzustellen';

  @override
  String get headingDeleteManagedList => 'Diese Liste löschen?';

  @override
  String get statusNoItemsInManagedList => 'Keine Einträge in dieser Liste';

  @override
  String get promptAddItemsToManagedList => 'Füge Einträge zu dieser Liste hinzu, damit sie hier angezeigt werden';

  @override
  String get statusListMayBeRemoved => 'Die Liste wurde möglicherweise aus der Bibliothek entfernt';

  @override
  String errorLibraryItemsNotLoaded(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Einträge konnten nicht geladen werden',
      one: '1 Eintrag konnte nicht geladen werden',
    );
    return '$_temp0';
  }

  @override
  String statusNamedEntityCreated(String entityType) {
    return '$entityType erstellt';
  }

  @override
  String get actionCreate => 'Erstellen';

  @override
  String errorNamedEntityCreateFailed(String entityType) {
    return '$entityType konnte nicht erstellt werden';
  }

  @override
  String get actionSelect => 'Auswählen';

  @override
  String downloadDeletePrompt(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Downloads aus dem lokalen Speicher löschen und aus den Downloads entfernen?',
      one: 'Diesen Download aus dem lokalen Speicher löschen und aus den Downloads entfernen?',
    );
    return '$_temp0';
  }

  @override
  String downloadDeleteSummary(int items, int files) {
    final intl.NumberFormat itemsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String itemsString = itemsNumberFormat.format(items);
    final intl.NumberFormat filesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String filesString = filesNumberFormat.format(files);

    String _temp0 = intl.Intl.pluralLogic(
      items,
      locale: localeName,
      other: '$itemsString Einträge gelöscht',
      one: '1 Eintrag gelöscht',
    );
    String _temp1 = intl.Intl.pluralLogic(
      files,
      locale: localeName,
      other: '$filesString Dateien entfernt',
      one: '1 Datei entfernt',
    );
    return '$_temp0, $_temp1';
  }

  @override
  String downloadDeleteFilesFailed(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Dateien konnten nicht entfernt werden',
      one: '1 Datei konnte nicht entfernt werden',
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
      other: '$countString Einträge konnten nicht gelöscht werden',
      one: '1 Eintrag konnte nicht gelöscht werden',
    );
    return '$_temp0';
  }

  @override
  String statusPartialDownloads(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Teilweise · $countString';
  }

  @override
  String statusOfflineDownloads(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Offline · $countString';
  }

  @override
  String get errorPodcastSearchFailed => 'Podcasts konnten nicht gesucht werden';

  @override
  String get statusPodcastLibraryNoFolders =>
      'Füge dieser Bibliothek in den Servereinstellungen einen Ordner hinzu, bevor du suchst';

  @override
  String get podcastSearchEmptyPrompt => 'Suche nach einem Podcastnamen oder füge einen RSS-Feed hinzu';

  @override
  String get errorAdminAccountRequired => 'Zum Hinzufügen von Podcasts ist ein Administratorkonto erforderlich';

  @override
  String get actionSearch => 'Suchen';

  @override
  String get statusConnectionUnstableUsingCachedData =>
      'Die Serververbindung ist instabil. Die zuletzt verfügbaren Daten werden angezeigt';

  @override
  String get actionFilter => 'Filtern';

  @override
  String get statusNoItemsInLibrary => 'Keine Einträge in dieser Bibliothek gefunden';

  @override
  String get statusNoMissingOrIncompleteItems => 'Keine fehlenden oder unvollständigen Einträge gefunden';

  @override
  String get headingListeningSessions => 'Hörsitzungen';

  @override
  String get headingYearInRewind => 'Jahresrückblick';

  @override
  String get headingAdvancedAnalytics => 'Erweiterte Analysen';

  @override
  String get statsAdvancedLoadDescription => 'Lädt alle Hörsitzungen und kann bei großen Konten länger dauern';

  @override
  String get actionDownload => 'Herunterladen';

  @override
  String get actionSignOut => 'Abmelden';

  @override
  String get appName => 'yaabsa';

  @override
  String get headingWelcome => 'Willkommen';

  @override
  String get playbackNowPlaying => 'Wiedergabe läuft';

  @override
  String get playerEmptyPrompt =>
      'Wähle einen Eintrag aus deinen Bibliotheken oder Downloads aus, um die Wiedergabe zu starten';

  @override
  String get fieldRewindInterval => 'Rückspulintervall';

  @override
  String get fieldFastForwardInterval => 'Vorspulintervall';

  @override
  String get wearCoverBackground => 'Cover-Hintergrund';

  @override
  String get wearAmbientTitleAndAuthor => 'Titel und Autor im Ambient-Modus';

  @override
  String get wearCoverGrid => 'Coverraster';

  @override
  String get wearFlatScrolling => 'Gleichmäßiges Scrollen';

  @override
  String get wearItemProgress => 'Fortschritt des Eintrags';

  @override
  String get statusOn => 'Ein';

  @override
  String get statusOff => 'Aus';

  @override
  String actionCancelDownloadProgress(String percent) {
    return 'Download abbrechen · $percent';
  }

  @override
  String get statusNoItems => 'Keine Einträge gefunden';

  @override
  String accessibilityPageAnnouncement(String section, int page, int pages) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);
    final intl.NumberFormat pagesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pagesString = pagesNumberFormat.format(pages);

    return '$section, Seite $pageString von $pagesString';
  }

  @override
  String get aaosOpenMediaCenter => 'Mediencenter öffnen';

  @override
  String get wearPairingNoPhoneConnected =>
      'Kein Smartphone verbunden. Verbinde deine Uhr mit deinem Smartphone und versuche es erneut';

  @override
  String get wearPairingNoPhoneResponse =>
      'Keine Antwort vom Smartphone. Überprüfe, ob eine Kopplungsbenachrichtigung angezeigt wird';

  @override
  String get wearPairingSubtitle => 'Mit Audiobookshelf verbinden';

  @override
  String get wearPairingSignInOnPhone => 'Melde dich auf deinem Smartphone an, um fortzufahren';

  @override
  String get headingServerHeader => 'Server-Header';

  @override
  String get statusSigningOut => 'Abmeldung läuft';

  @override
  String get statusOpening => 'Wird geöffnet…';

  @override
  String get wearSignOutWarning => 'Du musst dich erneut anmelden, um auf dieser Uhr zu streamen';

  @override
  String get statusFinished => 'Abgeschlossen';

  @override
  String get errorCredentialsRejected =>
      'Der Server hat diese Anmeldedaten abgelehnt. Überprüfe Benutzername und Passwort';

  @override
  String get errorCertificateUnverified => 'Das Serverzertifikat konnte nicht verifiziert werden';

  @override
  String get errorServerNotAudiobookshelf => 'Diese Adresse gehört nicht zu einem Audiobookshelf-Server';

  @override
  String get readerBookTitleFallback => 'Dein Buch';

  @override
  String get readerLoadingEbookFiles => 'E-Book-Dateien werden geladen…';

  @override
  String get errorMissingEbookToken => 'Authentifizierungstoken zum Laden des E-Books fehlt';

  @override
  String get statusNoTableOfContents => 'Dieses Buch hat kein Inhaltsverzeichnis';

  @override
  String get readerContentsTab => 'Inhalt';

  @override
  String get readerSavedTab => 'Gespeichert';

  @override
  String get readerContentsAndNotes => 'Inhalt und Notizen';

  @override
  String get readerSavedPassagesTitle => 'Bewahre deine Lieblingsstellen auf';

  @override
  String get readerSavedPassagesPrompt => 'Wähle Text aus, um ihn hervorzuheben oder eine Notiz hinzuzufügen';

  @override
  String get readerBookmark => 'Lesezeichen';

  @override
  String get actionBookmarkThisPage => 'Diese Seite als Lesezeichen speichern';

  @override
  String get actionRemoveBookmark => 'Lesezeichen entfernen';

  @override
  String get actionRemoveSavedPassage => 'Gespeicherte Textstelle entfernen';

  @override
  String get actionDeleteAnnotation => 'Anmerkung löschen';

  @override
  String get actionEditAnnotation => 'Anmerkung bearbeiten';

  @override
  String get actionHighlightText => 'Hervorheben';

  @override
  String get actionUnderlineText => 'Unterstreichen';

  @override
  String get readerUnderlinedPassage => 'Unterstrichene Textstelle';

  @override
  String get readerHighlightedPassage => 'Hervorgehobene Textstelle';

  @override
  String get readerNoNote => 'Keine Notiz hinzugefügt';

  @override
  String readerPageNumber(int page) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);

    return 'Seite $pageString';
  }

  @override
  String get untitledChapter => 'Kapitel ohne Titel';

  @override
  String get actionCloseBook => 'Buch schließen';

  @override
  String get actionSearchInBook => 'Im Buch suchen';

  @override
  String get headingReadingPreferences => 'Leseeinstellungen';

  @override
  String get readerAppearance => 'Darstellung';

  @override
  String get headingLayout => 'Layout';

  @override
  String get readerFieldTypeface => 'Schriftart';

  @override
  String get readerFieldTextSize => 'Schriftgröße';

  @override
  String get readerFieldLineSpacing => 'Zeilenabstand';

  @override
  String get readerFieldPageLayout => 'Seitenlayout';

  @override
  String get fieldTextAlignment => 'Textausrichtung';

  @override
  String get readerFieldLetterSpacing => 'Zeichenabstand';

  @override
  String get readerFieldPageMargins => 'Seitenränder';

  @override
  String get readerFieldReadingWidth => 'Lesebreite';

  @override
  String get readerFieldUnderlineThickness => 'Dicke der Unterstreichung';

  @override
  String get readerFieldReadingPosition => 'Leseposition';

  @override
  String get readerHideMiniPlayer => 'Miniplayer beim Lesen ausblenden';

  @override
  String get readerTrackReadingTime => 'Lesezeit als Hörzeit erfassen';

  @override
  String get readerFieldColor => 'Farbe';

  @override
  String get readerSearchEmptyPrompt => 'Finde eine Textstelle in diesem Buch';

  @override
  String get readerSearchMinimumPrompt => 'Gib mindestens zwei Zeichen ein oder drücke auf Suchen';

  @override
  String readerSearchQueryPrompt(String query) {
    return 'Suche nach „$query“';
  }

  @override
  String get readerNoSearchMatches => 'Keine Treffer gefunden. Versuche ein anderes Wort oder eine andere Formulierung';

  @override
  String get readerSearchFailed => 'Dieses Buch konnte nicht durchsucht werden. Versuche es erneut';

  @override
  String get readerSearchOpenFailed => 'Dieses Ergebnis konnte nicht geöffnet werden. Versuche es erneut';

  @override
  String get readerSearchLoading => 'Buch wird durchsucht…';

  @override
  String readerSearchFirstResults(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Erste $countString Treffer. Verfeinere deine Suche',
      one: 'Erster Treffer. Verfeinere deine Suche',
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
      other: '$countString Treffer gefunden',
      one: '1 Treffer gefunden',
    );
    return '$_temp0';
  }

  @override
  String get readerNoReadableText => 'Kein lesbarer Text gefunden';

  @override
  String get readerAnnotationsSynced => 'Anmerkungen synchronisiert';

  @override
  String get errorAnnotationsSyncFailed => 'Anmerkungen konnten nicht synchronisiert werden';

  @override
  String get errorAnnotationsLoadFailed => 'Anmerkungen konnten nicht vom Server geladen werden';

  @override
  String get statusNoAnnotations => 'Keine Anmerkungen für diesen Eintrag gefunden';

  @override
  String get errorStoredAnnotationsInvalid => 'Gespeicherte Anmerkungen sind ungültig';

  @override
  String get statusNoValidAnnotations => 'Keine gültigen Anmerkungen für diesen Eintrag gefunden';

  @override
  String get statusNoPdfAnnotations => 'Keine PDF-Anmerkungen gefunden';

  @override
  String statusPdfAnnotationsLoaded(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString PDF-Anmerkungen geladen',
      one: '1 PDF-Anmerkung geladen',
    );
    return '$_temp0';
  }

  @override
  String get statusNoEpubAnnotations => 'Keine EPUB-Anmerkungen gefunden';

  @override
  String get statusEpubAnnotationsLoaded => 'EPUB-Anmerkungen geladen';

  @override
  String get optionBookDefault => 'Buchstandard';

  @override
  String get fontSerif => 'Serifenschrift';

  @override
  String get fontSansSerif => 'Serifenlos';

  @override
  String get pageLayoutSingle => 'Einzelne Seite';

  @override
  String get pageLayoutTwoWide => 'Zwei Seiten auf breiten Bildschirmen';

  @override
  String get pageLayoutScroll => 'Bildlauf';

  @override
  String get textAlignmentStart => 'Am Anfang ausgerichtet';

  @override
  String get textAlignmentJustified => 'Blocksatz';

  @override
  String get spacingSlight => 'Leicht';

  @override
  String get sizeNarrow => 'Schmal';

  @override
  String get sizeSmall => 'Klein';

  @override
  String get sizeMedium => 'Mittel';

  @override
  String get sizeLarge => 'Groß';

  @override
  String get sizeWide => 'Breit';

  @override
  String get sizeExtraWide => 'Sehr breit';

  @override
  String get sizeCompact => 'Kompakt';

  @override
  String get sizeComfortable => 'Angenehm';

  @override
  String get sizeFull => 'Voll';

  @override
  String get readerThemePaper => 'Papier';

  @override
  String get readerThemeSepia => 'Sepia';

  @override
  String get readerThemeGrey => 'Grau';

  @override
  String get readerThemeNight => 'Nacht';

  @override
  String get actionFocus => 'Fokussieren';

  @override
  String get readerAppearancePreviewLabel => 'Vorschau der Leseansicht';

  @override
  String get readerAppearancePreviewText =>
      'Ein ruhiger Moment, ein neues Kapitel. Richte die Seite so ein, wie es für dich angenehm ist';

  @override
  String readerPageLabelWithProgress(String page, int pages, String progress) {
    final intl.NumberFormat pagesNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pagesString = pagesNumberFormat.format(pages);

    return 'Seite $page von $pagesString · $progress';
  }

  @override
  String readerPageLabelProgress(String page, String progress) {
    return 'Seite $page · $progress';
  }

  @override
  String readerLocationProgress(int position, int total, String progress) {
    final intl.NumberFormat positionNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Position $positionString von $totalString · $progress';
  }

  @override
  String get readerReading => 'Lesen';

  @override
  String get readerAnnotationNoteHint => 'Optionale Notiz hinzufügen';

  @override
  String readerAnnotationColorLabel(String color) {
    return 'Farbe der Anmerkung $color';
  }

  @override
  String get readerColors => 'Farben';

  @override
  String get readerBookmarkAdded => 'Lesezeichen hinzugefügt';

  @override
  String get readerSelectTextFirst => 'Wähle zuerst Text aus';

  @override
  String get readerAnnotationHighlight => 'Hervorhebung';

  @override
  String get readerAnnotationUnderline => 'Unterstreichung';

  @override
  String readerUnderlineThicknessPixels(String pixels) {
    return '$pixels px';
  }

  @override
  String get readerSearchHint => 'Wort oder Ausdruck suchen';

  @override
  String readerPageColorOption(String color) {
    return 'Seitenfarbe $color';
  }

  @override
  String readerAnnotationTitleWithThickness(String type, String thickness) {
    return '$type ($thickness)';
  }

  @override
  String get readerSettingsTitle => 'Reader-Einstellungen';

  @override
  String get readerPlayerIntegration => 'Player-Integration';

  @override
  String get readerChooseFontDescription => 'Schriftart für den Buchtext auswählen';

  @override
  String get readerAdjustTextSizeDescription => 'Größe des Buchtexts anpassen';

  @override
  String get readerAdjustLineSpacingDescription => 'Abstand zwischen den Zeilen anpassen';

  @override
  String get readerChooseTextAlignmentDescription => 'Ausrichtung des Buchtexts auswählen';

  @override
  String get readerAdjustLetterSpacingDescription => 'Abstand zwischen den Buchstaben anpassen';

  @override
  String get readerChoosePageLayoutDescription => 'Darstellung der Seiten beim Lesen auswählen';

  @override
  String get readerHideMiniPlayerDescription => 'Blendet den Audio-Miniplayer beim Lesen aus';

  @override
  String get readerTrackReadingTimeDescription => 'Berücksichtigt Lesezeit in den Hörstatistiken';

  @override
  String get readerSpeechProvider => 'Sprachausgabedienst';

  @override
  String get readerSpeechProviderDescription => 'Wähle den Dienst aus, der das Buch vorliest';

  @override
  String get readerSpeechRate => 'Sprechtempo';

  @override
  String get readerSpeechRateDescription => 'Geschwindigkeit der Sprachausgabe anpassen';

  @override
  String get readerSpeechLanguage => 'Sprache der Sprachausgabe';

  @override
  String get readerSpeechLanguageDescription => 'Sprache für die Sprachausgabe auswählen';

  @override
  String get readerSpeechVoiceDescription => 'Stimme für die Sprachausgabe auswählen';

  @override
  String get readerSpeechVoicesUnavailable =>
      'Keine Stimmen für die Sprachausgabe verfügbar. Überprüfe die Spracheinstellungen deines Geräts';

  @override
  String get readerSpeechApiKeyStored => 'Auf diesem Gerät sicher gespeichert';

  @override
  String get readerSpeechSaveFailed => 'Einstellungen der Sprachausgabe konnten nicht gespeichert werden';

  @override
  String get readerSpeechPreferencesSaved => 'Einstellungen der Sprachausgabe gespeichert';

  @override
  String get readerSpeechVoiceIdDescription => 'Verwende eine Stimme, die für dein Konto verfügbar ist';

  @override
  String get readerSpeechPreferredLanguage => 'Bevorzugte Sprache';

  @override
  String get readerSpeechLanguageHint => 'en, de, fr';

  @override
  String get readerSpeechDetectLanguage => 'Leer lassen, damit die Sprache des Textes erkannt wird';

  @override
  String get readerSpeechDetectsLanguage => 'Dieses Modell erkennt die Sprache des Textes';

  @override
  String get readerSpeechLanguageChoose => 'Sprache auswählen';

  @override
  String get readerSpeechVoiceChoose => 'Stimme auswählen';

  @override
  String readerSpeechVoiceType(String voice, String type) {
    return '$voice ($type)';
  }

  @override
  String get readerSpeechLocalVoice => 'Lokal';

  @override
  String get readerSpeechNetworkVoice => 'Netzwerk';

  @override
  String readerSpeechNumberedVoice(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Stimme $numberString';
  }

  @override
  String get readerSpeechModelDescription => 'Sprachmodell auswählen';

  @override
  String get readerSpeechVoiceInvalid => 'Gib eine gültige Stimmen-ID ein';

  @override
  String get readerSpeechLanguageCodeExample => 'Gib einen Sprachcode wie en oder de ein';

  @override
  String get readerSpeechLanguageUnsupported => 'Dieses Modell unterstützt diese Sprache nicht';

  @override
  String get errorAnnotationUpdateFailed => 'Anmerkung konnte nicht aktualisiert werden';

  @override
  String get errorReaderNarrationUnavailable => 'Buchvorlesung konnte nicht vorbereitet werden';

  @override
  String get actionMoreActions => 'Weitere Aktionen';

  @override
  String get actionQuickMatch => 'Schnellabgleich';

  @override
  String get actionManualMatch => 'Manueller Abgleich';

  @override
  String get actionMarkAsFinished => 'Als abgeschlossen markieren';

  @override
  String get actionMarkAsUnfinished => 'Als nicht abgeschlossen markieren';

  @override
  String get actionSetProgress => 'Fortschritt festlegen';

  @override
  String get actionAddToPlaylist => 'Zur Wiedergabeliste hinzufügen';

  @override
  String get actionAddToCollection => 'Zur Sammlung hinzufügen';

  @override
  String get actionPinToShelf => 'Am Regal anheften';

  @override
  String get actionUnpinFromShelf => 'Vom Regal lösen';

  @override
  String get actionManagePlaylists => 'Wiedergabelisten verwalten';

  @override
  String get actionManageCollections => 'Sammlungen verwalten';

  @override
  String get navPlayHistory => 'Wiedergabeverlauf';

  @override
  String get actionRead => 'Lesen';

  @override
  String get fieldPublisher => 'Verlag';

  @override
  String get fieldPublished => 'Veröffentlicht';

  @override
  String get fieldChapter => 'Kapitel';

  @override
  String get fieldAudioFiles => 'Audiodateien';

  @override
  String get fieldEbookFiles => 'E-Book-Dateien';

  @override
  String get fieldLibraryFiles => 'Bibliotheksdateien';

  @override
  String itemSectionTitleWithCount(String section, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$section ($countString)';
  }

  @override
  String get headingBookDetails => 'Buchdetails';

  @override
  String get headingAboutThisBook => 'Über dieses Buch';

  @override
  String get actionShowLess => 'Weniger anzeigen';

  @override
  String get actionReadMore => 'Mehr lesen';

  @override
  String errorLoadNamedItemsRetry(String items) {
    return '$items konnten nicht geladen werden. Versuche es erneut';
  }

  @override
  String statusNamedItemsUnknown(String items) {
    return 'Einige $items konnten nicht überprüft werden. Versuche es erneut';
  }

  @override
  String statusNoNamedItems(String items) {
    return 'Keine $items';
  }

  @override
  String get statusNoSearchMatches => 'Keine Einträge entsprechen deiner Suche oder deinen Filtern';

  @override
  String get entityCollections => 'Sammlungen';

  @override
  String get entityPlaylists => 'Wiedergabelisten';

  @override
  String get statusDownloadQueued => 'Download zur Warteschlange hinzugefügt';

  @override
  String get errorDownloadStartFailed => 'Download konnte nicht gestartet werden';

  @override
  String get statusDeletingDownloadedFiles => 'Heruntergeladene Dateien werden gelöscht…';

  @override
  String downloadFilesDeleteSummary(int deleted, int failed) {
    final intl.NumberFormat deletedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String deletedString = deletedNumberFormat.format(deleted);
    final intl.NumberFormat failedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String failedString = failedNumberFormat.format(failed);

    String _temp0 = intl.Intl.pluralLogic(
      deleted,
      locale: localeName,
      other: '$deletedString Dateien gelöscht',
      one: '1 Datei gelöscht',
      zero: 'Keine Dateien gelöscht',
    );
    String _temp1 = intl.Intl.pluralLogic(
      failed,
      locale: localeName,
      other: ' · $failedString Dateien konnten nicht entfernt werden',
      one: ' · 1 Datei konnte nicht entfernt werden',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get errorDeleteDownload => 'Download konnte nicht gelöscht werden';

  @override
  String get errorUpdatePinned => 'Angeheftetes Regal konnte nicht aktualisiert werden';

  @override
  String get errorPodcastFeedLoad => 'Podcast-Feed konnte nicht geladen werden';

  @override
  String get statusNoDownloadableEpisodes => 'Im Feed wurden keine herunterladbaren Folgen gefunden';

  @override
  String get statusQueuingEpisodeDownloads => 'Folgen werden zum Download vorgemerkt…';

  @override
  String statusPodcastEpisodesStarted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Folgen', one: '1 Folge');
    return 'Download gestartet für $_temp0';
  }

  @override
  String get headingDownloadEpisodes => 'Folgen herunterladen';

  @override
  String get actionDownloadNotStartedEpisodes => 'Noch nicht gestartete Folgen herunterladen';

  @override
  String get actionDownloadUnfinishedEpisodes => 'Unvollständige Folgen herunterladen';

  @override
  String get actionCancelActiveDownloads => 'Aktive Downloads abbrechen';

  @override
  String statusDownloadsCanceled(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Downloads abgebrochen',
      one: '1 Download abgebrochen',
    );
    return '$_temp0';
  }

  @override
  String get statusNoNewSelectedEpisodes => 'In der Auswahl gibt es keine neuen Folgen zum Herunterladen';

  @override
  String get statusPodcastMetadataUnavailable => 'Podcast-Metadaten sind nicht verfügbar';

  @override
  String get errorItemNotFound => 'Eintrag nicht gefunden';

  @override
  String get statusItemMayHaveMovedOrBeenDeleted => 'Dieser Eintrag wurde möglicherweise verschoben oder gelöscht';

  @override
  String get statusNoDescriptionAvailable => 'Keine Beschreibung verfügbar';

  @override
  String get actionFindEpisodes => 'Folgen suchen';

  @override
  String get actionClearSelection => 'Auswahl aufheben';

  @override
  String actionDownloadEpisodes(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Folgen herunterladen',
      one: 'Folge herunterladen',
      zero: 'Folgen herunterladen',
    );
    return '$_temp0';
  }

  @override
  String get actionDownloadSelectedEpisodes => 'Ausgewählte Folgen herunterladen';

  @override
  String get actionDownloadOptions => 'Downloadoptionen';

  @override
  String get hintSearchEpisodes => 'Folgen suchen';

  @override
  String get headingEpisodes => 'Folgen';

  @override
  String get headingEpisode => 'Folge';

  @override
  String statusEpisodeResultsSubset(int visible, int total) {
    final intl.NumberFormat visibleNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String visibleString = visibleNumberFormat.format(visible);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(
      visible,
      locale: localeName,
      other: '$visibleString von $totalString Folgen',
      one: '1 von $totalString Folgen',
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
      other: '$countString Downloads zur Warteschlange hinzugefügt',
      one: 'Download zur Warteschlange hinzugefügt',
      zero: 'Keine Downloads zur Warteschlange hinzugefügt',
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
      other: '$countString aktive Downloads',
      one: '1 aktiver Download',
    );
    return '$_temp0';
  }

  @override
  String get statusAllEpisodesDownloaded => 'Alle Folgen sind bereits heruntergeladen';

  @override
  String get sortNewestFirst => 'Neueste zuerst';

  @override
  String get sortOldestFirst => 'Älteste zuerst';

  @override
  String get sortTitleAscending => 'Titel A–Z';

  @override
  String get sortTitleDescending => 'Titel Z–A';

  @override
  String get statusComplete => 'Abgeschlossen';

  @override
  String get statusInProgress => 'In Bearbeitung';

  @override
  String get statusIncomplete => 'Unvollständig';

  @override
  String get statusCurrentlyPlaying => 'Wird gerade abgespielt';

  @override
  String get statusDownloading => 'Wird heruntergeladen';

  @override
  String get statusLoading => 'Wird geladen';

  @override
  String get actionReplay => 'Erneut abspielen';

  @override
  String get actionAddToQueue => 'Zur Warteschlange hinzufügen';

  @override
  String get actionDeleteDownload => 'Download löschen';

  @override
  String metadataFieldValue(String field, String value) {
    return '$field · $value';
  }

  @override
  String podcastEpisodeCountAndDuration(String count, String duration) {
    return '$count · $duration';
  }

  @override
  String get optionCustom => 'Benutzerdefiniert';

  @override
  String get optionNone => 'Keine';

  @override
  String get navBookmarks => 'Lesezeichen';

  @override
  String get navCarMode => 'Auto-Modus';

  @override
  String get navEqualizer => 'Equalizer';

  @override
  String get headingQueue => 'Warteschlange';

  @override
  String get headingQuickSettings => 'Schnelleinstellungen';

  @override
  String get optionAdaptive => 'Adaptiv';

  @override
  String get optionMinimalistic => 'Minimalistisch';

  @override
  String get fieldCoverSize => 'Covergröße';

  @override
  String get fieldImmersivePlayerColors => 'Immersive Playerfarben';

  @override
  String get fieldTimelineMode => 'Zeitleistenmodus';

  @override
  String get deviceMobile => 'Mobilgerät';

  @override
  String get deviceTablet => 'Tablet';

  @override
  String get deviceDesktop => 'Desktop';

  @override
  String get alignmentCenter => 'Mitte';

  @override
  String get alignmentEnd => 'Ende';

  @override
  String get playerCoverFitHeight => 'Höhe ausfüllen';

  @override
  String get playerCoverFitWidth => 'Breite ausfüllen';

  @override
  String get playerCoverFitBox => 'Bereich ausfüllen';

  @override
  String get playerSeekTimeInline => 'Neben der Suchleiste';

  @override
  String get playerSeekTimeBelowSeekBar => 'Unter der Suchleiste';

  @override
  String get playerSeekTimeUnderAppBar => 'Unter der App-Leiste';

  @override
  String get playerComponentCover => 'Cover';

  @override
  String get playerComponentMediaInfo => 'Medieninfo';

  @override
  String get playerComponentSeekBar => 'Suchleiste';

  @override
  String get playerComponentControls => 'Steuerung';

  @override
  String get playerComponentUtilities => 'Werkzeuge';

  @override
  String get playerComponentSubtitles => 'Untertitel';

  @override
  String get optionHideWidget => 'Widget ausblenden';

  @override
  String get optionCompactMessage => 'Kompakte Nachricht';

  @override
  String get optionFullPlaceholder => 'Vollständiger Platzhalter';

  @override
  String get actionJump => 'Springen';

  @override
  String get actionSkip => 'Überspringen';

  @override
  String get actionJumpAndSkip => 'Springen und überspringen';

  @override
  String playerLayoutEditTitle(String screenSize) {
    return 'Layout für $screenSize bearbeiten';
  }

  @override
  String errorPlayerLayoutNoFreeSpace(String component) {
    return 'Kein freier Rasterplatz für $component verfügbar';
  }

  @override
  String get statusPlayerLayoutConfigCopied => 'Layoutkonfiguration in die Zwischenablage kopiert';

  @override
  String get statusLoadingNextItem => 'Nächster Eintrag wird geladen…';

  @override
  String get actionEditPlayerLayout => 'Playerlayout bearbeiten';

  @override
  String get actionMinimizePlayer => 'Player minimieren';

  @override
  String get statusPlayerOverlapUnlocked => 'Überlagerung entsperrt';

  @override
  String get statusPlayerOverlapLocked => 'Überlagerung gesperrt';

  @override
  String get confirmClearQueue => 'Warteschlange leeren?';

  @override
  String get confirmClearPlaybackQueue =>
      'Alle eingereihten, automatisch eingereihten und geplanten Einträge entfernen?';

  @override
  String get statusCustomPlayer => 'Benutzerdefinierter Player';

  @override
  String get actionReset => 'Zurücksetzen';

  @override
  String get actionRestartListeningSession => 'Hörsitzung neu starten';

  @override
  String get statusVisible => 'Sichtbar';

  @override
  String get settingUseCardStyle => 'Kartenstil verwenden';

  @override
  String settingShowField(String field) {
    return '$field anzeigen';
  }

  @override
  String get fieldScale => 'Skalierung';

  @override
  String get fieldFontScale => 'Schriftgröße';

  @override
  String get fieldSeekBarHeight => 'Höhe der Suchleiste';

  @override
  String get fieldTimeFontSize => 'Schriftgröße der Zeitangabe';

  @override
  String get fieldCoverFitMode => 'Cover-Anpassung';

  @override
  String get fieldTimeLabelsPosition => 'Position der Zeitangaben';

  @override
  String get fieldEmptyState => 'Leerer Zustand';

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
    return 'Einstellungen für $name';
  }

  @override
  String get statusNoPlayerComponentsVisible => 'In diesem Layout sind keine Komponenten sichtbar';

  @override
  String get directionLeft => 'links';

  @override
  String get directionRight => 'rechts';

  @override
  String get directionUp => 'oben';

  @override
  String get directionDown => 'unten';

  @override
  String actionMoveDirection(String direction) {
    return '$direction verschieben';
  }

  @override
  String get actionNarrower => 'Schmaler';

  @override
  String get actionWider => 'Breiter';

  @override
  String get actionShorter => 'Kürzer';

  @override
  String get actionTaller => 'Höher';

  @override
  String get statusNoChaptersAvailable => 'Keine Kapitel verfügbar';

  @override
  String get statusQueueEmpty => 'Warteschlange ist leer';

  @override
  String get statusSubtitlesDisabled => 'Untertitel sind in den Player-Einstellungen deaktiviert';

  @override
  String get hintStartPlaybackForSubtitleReading =>
      'Starte die Wiedergabe, um den fortlaufenden Untertitelmodus zu verwenden';

  @override
  String get statusNoSubtitlesAvailable => 'Für diesen Titel sind keine Untertitel verfügbar';

  @override
  String get statusWaitingForSubtitleCue => 'Warten auf die nächste Untertitelzeile';

  @override
  String get headingOnThisDevice => 'Auf diesem Gerät';

  @override
  String eventCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Ereignisse',
      one: '1 Ereignis',
    );
    return '$_temp0';
  }

  @override
  String get hintSignInToViewActivity => 'Melde dich an, um Wiedergabeaktivitäten zu sehen';

  @override
  String get statusNoPlaybackActivityYet => 'Noch keine Aktivitäten';

  @override
  String get hintPlaybackActivityWillAppear =>
      'Wiedergabe-, Sleeptimer- und Synchronisierungsaktivitäten erscheinen hier';

  @override
  String get statusNothingToShowYet => 'Noch nichts anzuzeigen';

  @override
  String get hintOpenHistoryAfterPlayback =>
      'Starte die Wiedergabe eines Hörbuchs oder Podcasts und öffne anschließend erneut den Verlauf';

  @override
  String get errorStartPlaybackFromPosition => 'Die Wiedergabe konnte an dieser Position nicht gestartet werden';

  @override
  String get playbackShuffleQueue => 'Warteschlange mischen';

  @override
  String playbackRewindInterval(int seconds) {
    final intl.NumberFormat secondsNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String secondsString = secondsNumberFormat.format(seconds);

    String _temp0 = intl.Intl.pluralLogic(
      seconds,
      locale: localeName,
      other: '$secondsString Sekunden zurückspulen',
      one: '1 Sekunde zurückspulen',
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
      other: '$secondsString Sekunden vorspulen',
      one: '1 Sekunde vorspulen',
    );
    return '$_temp0';
  }

  @override
  String playbackRepeatStatus(String status) {
    return 'Wiederholen: $status';
  }

  @override
  String get actionAddBookmark => 'Lesezeichen hinzufügen';

  @override
  String get statusAddingBookmark => 'Wird hinzugefügt';

  @override
  String get errorBookmarkPlaybackRequired =>
      'Gib die Wiedergabe erst ein Stück weiter wieder, bevor du ein Lesezeichen erstellst';

  @override
  String get errorBookmarkCreateFailed => 'Lesezeichen konnte nicht erstellt werden';

  @override
  String statusBookmarkAddedAt(String position) {
    return 'Lesezeichen bei $position hinzugefügt';
  }

  @override
  String get errorBookmarkUpdateFailed => 'Lesezeichen konnte nicht aktualisiert werden';

  @override
  String get statusBookmarkUpdated => 'Lesezeichen aktualisiert';

  @override
  String get errorBookmarkDeleteFailed => 'Lesezeichen konnte nicht gelöscht werden';

  @override
  String get statusBookmarkDeleted => 'Lesezeichen gelöscht';

  @override
  String confirmDeleteBookmarkAt(String position) {
    return 'Lesezeichen bei $position entfernen? Dies kann nicht rückgängig gemacht werden';
  }

  @override
  String confirmDeleteBookmarks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Lesezeichen löschen?',
      one: '1 Lesezeichen löschen?',
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
      other: '$countString Lesezeichen gelöscht',
      one: '1 Lesezeichen gelöscht',
    );
    return '$_temp0';
  }

  @override
  String get statusNoBookmarksYet => 'Noch keine Lesezeichen';

  @override
  String get untitledBookmark => 'Lesezeichen ohne Titel';

  @override
  String get hintBookmarkNote => 'Was möchtest du dir merken?';

  @override
  String get hintSaveBookmarkToFindAgain =>
      'Speichere eine Notiz an der aktuellen Wiedergabeposition, um sie später wiederzufinden';

  @override
  String get historyEventProgressUpdates => 'Fortschrittsaktualisierungen';

  @override
  String get historyEventPlaybackStarted => 'Wiedergabe gestartet';

  @override
  String get historyEventStopped => 'Gestoppt';

  @override
  String get historyEventPositionChanged => 'Position geändert';

  @override
  String get historyEventSkippedForward => 'Vorwärts gesprungen';

  @override
  String get historyEventSkippedBack => 'Zurückgesprungen';

  @override
  String get historyEventSpeedChanged => 'Geschwindigkeit geändert';

  @override
  String get historyEventSleepTimerStarted => 'Sleeptimer gestartet';

  @override
  String get historyEventSleepTimerAutoStarted => 'Sleeptimer automatisch gestartet';

  @override
  String get historyEventSleepTimerExtended => 'Sleeptimer verlängert';

  @override
  String get historyEventSleepTimerStopped => 'Sleeptimer gestoppt';

  @override
  String get historyEventSleepTimerEnded => 'Sleeptimer abgelaufen';

  @override
  String get historyEventProgressSynced => 'Fortschritt synchronisiert';

  @override
  String get historyEventOfflineProgressSaved => 'Offline-Fortschritt gespeichert';

  @override
  String get historyEventOfflineProgressSynced => 'Offline-Fortschritt synchronisiert';

  @override
  String historyPausedAt(String position) {
    return 'Bei $position pausiert';
  }

  @override
  String historyStoppedAt(String position) {
    return 'Bei $position gestoppt';
  }

  @override
  String historyToPosition(String position) {
    return 'Bis $position';
  }

  @override
  String historyToChapter(String chapter) {
    return 'Zu $chapter';
  }

  @override
  String historyPositionRange(String start, String end) {
    return 'Von $start bis $end';
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

    return '$previousSpeedString× auf $speedString×';
  }

  @override
  String historyForValue(String value) {
    return 'Für $value';
  }

  @override
  String historyDurationLeft(String duration) {
    return 'Noch $duration';
  }

  @override
  String get historySleepTimerResumed => 'Fortgesetzt';

  @override
  String get historySleepTimerStarted => 'Gestartet';

  @override
  String get historySleepTimerAutoStarted => 'Automatisch gestartet';

  @override
  String historySleepTimerExtended(String additional, String remaining) {
    return '+$additional · noch $remaining';
  }

  @override
  String historySleepTimerRemaining(String action, String remaining) {
    String _temp0 = intl.Intl.selectLogic(action, {
      'pause': 'Bei noch $remaining pausiert',
      'reset': 'Mit noch $remaining zurückgesetzt',
      'other': 'Bei noch $remaining gestoppt',
    });
    return '$_temp0';
  }

  @override
  String get historySleepTimerStopped => 'Gestoppt';

  @override
  String historyPlaybackEndedByTimer(String action) {
    String _temp0 = intl.Intl.selectLogic(action, {'pause': 'Wiedergabe pausiert', 'other': 'Wiedergabe gestoppt'});
    return '$_temp0';
  }

  @override
  String historyProgressAtPosition(String action, String position) {
    return '$action bei $position';
  }

  @override
  String historyTimeAndDescription(String time, String description) {
    return '$time · $description';
  }

  @override
  String chapterCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Kapitel', one: '1 Kapitel');
    return '$_temp0';
  }

  @override
  String get statusSynced => 'Synchronisiert';

  @override
  String get statusSaved => 'Gespeichert';

  @override
  String get playbackFullTimeline => 'Vollständig';

  @override
  String castProtocolStatus(String protocol, String status) {
    return '$protocol · $status';
  }

  @override
  String get statusSearchingCastDevices => 'Geräte im Netzwerk werden gesucht';

  @override
  String get statusNoCastDevicesFound =>
      'Keine Geräte gefunden. Stelle sicher, dass sich dein Empfänger im selben Netzwerk befindet';

  @override
  String get errorCastStopFailed => 'Wiedergabe auf dem Empfänger konnte nicht beendet werden';

  @override
  String get errorCastDiscoveryFailed => 'Cast-Geräte konnten nicht gesucht werden';

  @override
  String get errorPlaybackSpeedUnavailable => 'Die Wiedergabegeschwindigkeit ist für diese Wiedergabe nicht verfügbar';

  @override
  String get settingsBackupTitle => 'Einstellungen-Backup';

  @override
  String get settingsBackupDescription => 'App-Einstellungen und Playerlayouts importieren oder exportieren';

  @override
  String get settingRefreshProgressOnResume => 'Fortschritt bei Rückkehr aktualisieren';

  @override
  String get settingRefreshProgressOnResumeDescription =>
      'Buch- und Folgenfortschritt aktualisieren, wenn die App wieder in den Vordergrund kommt';

  @override
  String get settingDisableFdkAacDecoder => 'FDK-AAC-Decoder deaktivieren';

  @override
  String get settingDisableFdkAacDecoderDescription =>
      'Abstürze im FDK-AAC-Decoder vermeiden. Starte die App neu, damit die Änderung wirksam wird';

  @override
  String get settingServerManagement => 'Serververwaltung';

  @override
  String get settingServerManagementDescription =>
      'Sichtbarkeit von Sammlungen, Bearbeiten, Löschen und Hochladen festlegen';

  @override
  String get settingTimelineModeDescription =>
      'Lege fest, ob die Suchleiste einem Kapitel, dem gesamten Hörbuch oder beidem folgt';

  @override
  String get settingCoverSizeDescription => 'Größe des Covers im adaptiven Player festlegen';

  @override
  String get settingImmersivePlayerColorsDescription => 'Farben des Covers für Playerhintergründe verwenden';

  @override
  String get settingTimelineMarkers => 'Zeitleistenmarkierungen';

  @override
  String get settingTimelineMarkersDescription =>
      'Lege fest, ob die vollständige Zeitleiste Kapitelmarkierungen, Lesezeichenmarkierungen, beides oder nichts zeigt';

  @override
  String get settingFastForwardIntervalDescription => 'Anzahl der Sekunden, die beim Vorspulen übersprungen werden';

  @override
  String get settingRewindIntervalDescription => 'Anzahl der Sekunden, die beim Zurückspulen übersprungen werden';

  @override
  String get settingRememberPlaybackSpeedPerBook => 'Wiedergabegeschwindigkeit pro Buch merken';

  @override
  String get settingRememberPlaybackSpeedPerBookDescription =>
      'Jedes Buch merkt sich seine eigene Geschwindigkeit. Neue Bücher starten mit der zuletzt verwendeten Geschwindigkeit';

  @override
  String get settingAutoQueue => 'Automatisch einreihen';

  @override
  String get settingAutoQueueDescription => 'Beim Start der Wiedergabe automatisch kommende Bücher einreihen';

  @override
  String get settingAutoQueueEverywhere => 'Überall automatisch einreihen';

  @override
  String get settingAutoQueueEverywhereDescription =>
      'Bücher aus der ersten verknüpften Serie automatisch einreihen, auch wenn die Wiedergabe außerhalb einer Serienansicht gestartet wird';

  @override
  String get settingSmartRewind => 'Intelligentes Zurückspulen';

  @override
  String get settingSmartRewindDescription =>
      'Beim Fortsetzen nach einer Pause abhängig von der Pausendauer zurückspulen';

  @override
  String get settingShortPauseThreshold => 'Schwellenwert für kurze Pausen';

  @override
  String get settingShortPauseThresholdDescription =>
      'Bei Pausen bis zu diesem Wert wird der kurze Wert für intelligentes Zurückspulen verwendet';

  @override
  String get settingLongPauseThreshold => 'Schwellenwert für lange Pausen';

  @override
  String get settingLongPauseThresholdDescription =>
      'Bei Pausen über dem kurzen Schwellenwert bis zu diesem Wert wird der mittlere Wert für intelligentes Zurückspulen verwendet';

  @override
  String get settingShortRewindAmount => 'Kurzes Zurückspulen';

  @override
  String get settingShortRewindAmountDescription => 'Bei kurzen Pausen verwendete Rückspuldauer';

  @override
  String get settingMediumRewindAmount => 'Mittleres Zurückspulen';

  @override
  String get settingMediumRewindAmountDescription => 'Bei mittleren Pausen verwendete Rückspuldauer';

  @override
  String get settingLongRewindAmount => 'Langes Zurückspulen';

  @override
  String get settingLongRewindAmountDescription => 'Bei langen Pausen verwendete Rückspuldauer';

  @override
  String get settingSleepTimerEndAction => 'Aktion bei Ablauf des Sleeptimers';

  @override
  String get settingSleepTimerEndActionDescription =>
      'Lege fest, ob die Wiedergabe beim Ablauf des Sleeptimers beendet oder pausiert wird';

  @override
  String get settingSleepTimerEndRewind => 'Zurückspulen nach Ende des Sleeptimers';

  @override
  String get settingSleepTimerEndRewindDescription =>
      'Nach dem Stoppen durch den Sleeptimer beim nächsten Abspielen desselben Eintrags um diese Dauer zurückspulen';

  @override
  String get settingFadeAudio => 'Lautstärke ausblenden';

  @override
  String get settingFadeAudioDescription => 'Wiedergabelautstärke vor Ablauf des Sleeptimers allmählich senken';

  @override
  String get settingShowSleepTimerMarker => 'Sleeptimer-Markierung anzeigen';

  @override
  String get settingShowSleepTimerMarkerDescription => 'Sleeptimer nach Ablauf auf der Playerzeitleiste anzeigen';

  @override
  String get settingAutoRestartTimerOnPlaybackStart => 'Sleeptimer beim Wiedergabestart automatisch neu starten';

  @override
  String get settingAutoRestartTimerOnPlaybackStartDescription =>
      'Beim Start der Wiedergabe automatisch einen neuen Sleeptimer mit der zuletzt verwendeten Dauer starten';

  @override
  String get settingAutoRestartDuringTimeRange => 'Nur in einem Zeitraum automatisch neu starten';

  @override
  String get settingAutoRestartDuringTimeRangeDescription =>
      'Automatischen Neustart des Sleeptimers auf bestimmte Uhrzeiten beschränken';

  @override
  String get settingAutoRestartRangeStart => 'Beginn des Neustartzeitraums';

  @override
  String get settingAutoRestartRangeStartDescription =>
      'Ab dieser Uhrzeit wird der automatische Neustart des Sleeptimers aktiviert';

  @override
  String get settingAutoRestartRangeEnd => 'Ende des Neustartzeitraums';

  @override
  String get settingAutoRestartRangeEndDescription =>
      'Bis zu dieser Uhrzeit bleibt der automatische Neustart des Sleeptimers aktiv';

  @override
  String get settingEnableSubtitles => 'Untertitel aktivieren';

  @override
  String get settingEnableSubtitlesDescription =>
      'Verfügbare Untertitelspuren (.srt und .vtt) während der Wiedergabe anzeigen';

  @override
  String get settingHighlightSpeakerLabels => 'Sprechernamen hervorheben';

  @override
  String get settingHighlightSpeakerLabelsDescription => 'Sprechernamen in Untertiteln hervorheben';

  @override
  String get settingEnableReadAlong => 'Mitlesen aktivieren';

  @override
  String get settingEnableReadAlongDescription =>
      'Während der Sprachausgabe die aktuell gesprochenen Wörter in den Untertiteln hervorheben';

  @override
  String get settingShakeToResetSleepTimer => 'Schütteln, um den Sleeptimer zurückzusetzen';

  @override
  String get settingShakeToResetSleepTimerDescription =>
      'Aktiven Sleeptimer durch Schütteln auf die volle Dauer zurücksetzen';

  @override
  String get settingShakeToRewind => 'Schütteln, um zurückzuspulen';

  @override
  String get settingShakeToRewindDescription =>
      'Während der Wiedergabe schütteln, um das eingestellte Rückspulintervall zurückzuspulen';

  @override
  String get settingShakeSensitivity => 'Schüttelempfindlichkeit';

  @override
  String get settingShakeSensitivityDescription =>
      'Niedrigere Werte reagieren leichter, höhere Werte erfordern ein stärkeres Schütteln';

  @override
  String get settingShakeVibrationFeedback => 'Vibrationsfeedback beim Schütteln';

  @override
  String get settingShakeVibrationFeedbackDescription => 'Bei einer ausgelösten Schüttelaktion vibrieren';

  @override
  String get settingShelfSections => 'Regalbereiche';

  @override
  String get settingShelfSectionsDescription => 'Sichtbare Regalbereiche und ihre Reihenfolge auswählen';

  @override
  String get settingLibraryGridScale => 'Größe des Bibliotheksrasters';

  @override
  String get settingLibraryGridScaleDescription => 'Skaliert Karten in allen Rasteransichten der Bibliothek';

  @override
  String get settingCollapseSeries => 'Serien einklappen';

  @override
  String get settingCollapseSeriesDescription => 'Bücher einer Serie zu einem einzelnen Eintrag zusammenfassen';

  @override
  String get settingViewSubtitles => 'Bibliotheksuntertitel';

  @override
  String get settingViewSubtitlesDescription =>
      'Zusatzinformationen unter Bibliotheks-, Serien- und Autorenkarten festlegen';

  @override
  String get settingShowShelfPlayButton => 'Wiedergabeschaltfläche im Regal anzeigen';

  @override
  String get settingShowShelfPlayButtonDescription =>
      'Eine Schaltfläche zum Abspielen aller Einträge in den Regalen „Weiterhören“ und „Neueste“ hinzufügen';

  @override
  String get settingShowShuffleButton => 'Schaltfläche zum Mischen anzeigen';

  @override
  String get settingShowShuffleButtonDescription =>
      'Eine Schaltfläche zum Mischen von Sammlungen, Wiedergabelisten und Podcasts hinzufügen';

  @override
  String get settingCheckServerUpdates => 'Serverupdates suchen';

  @override
  String get settingCheckServerUpdatesDescription =>
      'Audiobookshelf-Veröffentlichungen auf GitHub auf Serverupdates prüfen';

  @override
  String get settingDownloadLocation => 'Downloadordner';

  @override
  String get settingDownloadLocationDescription => 'Speicherort für heruntergeladene Medien auswählen';

  @override
  String get settingDownloadOnlyOnWiFi => 'Nur über WLAN herunterladen';

  @override
  String get settingDownloadOnlyOnWiFiDescription => 'Normale und intelligente Downloads auf WLAN beschränken';

  @override
  String get settingMaximumParallelDownloads => 'Maximale parallele Downloads';

  @override
  String get settingMaximumParallelDownloadsDescription => 'Anzahl gleichzeitig heruntergeladener Dateien begrenzen';

  @override
  String get settingSmartDownloads => 'Intelligente Downloads';

  @override
  String get settingSmartDownloadsDescription =>
      'Einträge anhand von Downloadregeln automatisch herunterladen und entfernen';

  @override
  String get settingLanguageDescription => 'Anzeigesprache der App festlegen';

  @override
  String get settingMaxBufferSize => 'Maximale Puffergröße';

  @override
  String get settingMaxBufferSizeDescription =>
      'Maximalgröße des Audiopuffers in Byte als Hinweis für das Betriebssystem';

  @override
  String get settingKeepScreenOn => 'Bildschirm eingeschaltet lassen';

  @override
  String get settingKeepScreenOnDescription => 'Bildschirm während der Wiedergabe vor dem Ausschalten schützen';

  @override
  String get settingLockMediaNotification => 'Medienbenachrichtigung fixieren';

  @override
  String get settingLockMediaNotificationDescription =>
      'Mediensteuerung im Systembenachrichtigungsbereich sichtbar halten';

  @override
  String get settingMediaNotificationType => 'Typ der Medienbenachrichtigung';

  @override
  String get settingMediaNotificationTypeDescription =>
      'Lege fest, ob der Fortschritt der Benachrichtigung dem gesamten Buch oder dem aktuellen Kapitel folgt';

  @override
  String get settingMediaNotificationActions => 'Aktionen der Medienbenachrichtigung';

  @override
  String get settingMediaNotificationActionsDescription => 'Verfügbare Aktionen in der Medienbenachrichtigung anpassen';

  @override
  String get settingAutoPlayLastPlayedOnAppStart => 'Zuletzt Gehörtes beim App-Start abspielen';

  @override
  String get settingAutoPlayLastPlayedOnAppStartDescription =>
      'Zuletzt gehörten Eintrag beim App-Start fortsetzen, sofern er nicht abgeschlossen ist';

  @override
  String get settingAlwaysShowMiniPlayer => 'Miniplayer immer anzeigen';

  @override
  String get settingAlwaysShowMiniPlayerDescription =>
      'Miniplayer für den zuletzt abgespielten Eintrag sichtbar halten';

  @override
  String get settingKeepWebSocketActiveInBackground => 'WebSocket im Hintergrund aktiv halten';

  @override
  String get settingKeepWebSocketActiveInBackgroundDescription =>
      'App im Hintergrund verbunden halten, um Aktualisierungen zu synchronisieren. Dies kann den Akkuverbrauch erhöhen';

  @override
  String get settingEnableCaching => 'Zwischenspeicherung aktivieren';

  @override
  String get settingEnableCachingDescription => 'Antworten auf API-Anfragen zwischenspeichern';

  @override
  String get settingSpeedupMode => 'Beschleunigungsmodus';

  @override
  String get settingSpeedupModeDescription =>
      'Zwischenspeicherung mit Aktualisierungen im Hintergrund kombinieren, um Inhalte schneller zu laden';

  @override
  String get settingRemoveAuthorsWithoutBooksDescription =>
      'Schaltfläche im Autorenbereich hinzufügen, um Autoren ohne Bücher zu löschen';

  @override
  String get settingForceMetadataRefresh => 'Metadatenaktualisierung erzwingen';

  @override
  String get settingForceMetadataRefreshDescription =>
      'Metadatendateien für Einträge in den ausgewählten Bibliotheken neu erstellen';

  @override
  String get settingMatchAudiobookChapters => 'Hörbuchkapitel abgleichen';

  @override
  String get settingMatchAudiobookChaptersDescription =>
      'Werkzeuge zum schnellen und gesammelten Abgleich von Kapiteln hinzufügen';

  @override
  String get settingSplitGenresAndTags => 'Genres und Tags aufteilen';

  @override
  String get settingSplitGenresAndTagsDescription =>
      'Steuerung hinzufügen, um zusammengeführte Genre- und Tagwerte in den Servereinstellungen zu trennen';

  @override
  String get settingLogLevel => 'Protokollierungsstufe';

  @override
  String get settingLogLevelDescription => 'Minimale Schwere der zu erfassenden Protokolle auswählen';

  @override
  String get settingReaderTheme => 'Reader-Design';

  @override
  String get settingReaderThemeDescription => 'Hintergrund- und Textfarbdesign des Readers';

  @override
  String get settingReaderFontSizeDescription => 'Größe des Reader-Texts anpassen';

  @override
  String get settingReaderLineSpacingDescription => 'Zeilenabstand des Reader-Texts anpassen';

  @override
  String get settingReaderLayoutModeDescription =>
      'Zwischen paginierten Spalten und fortlaufendem vertikalem Bildlauf wählen';

  @override
  String get settingStartSessionWhenReading => 'Beim Lesen Sitzung starten';

  @override
  String get settingStartSessionWhenReadingDescription => 'Lesezeit bei direkter Wiedergabe auf dem Server erfassen';

  @override
  String get settingsCategoryApplicationSettings => 'App-Einstellungen';

  @override
  String get settingsCategoryPlayer => 'Player';

  @override
  String get settingsCategoryManagement => 'Verwaltung';

  @override
  String get settingsCategoryGlobalPlayer => 'Globaler Player';

  @override
  String get settingsCategoryCaching => 'Zwischenspeicherung';

  @override
  String get settingsCategoryTools => 'Werkzeuge';

  @override
  String get settingsCategoryLogs => 'Protokolle';

  @override
  String get settingsCategoryCompatibility => 'Kompatibilität';

  @override
  String get settingsCategoryGeneral => 'Allgemein';

  @override
  String get settingsCategoryShakeControls => 'Schüttelsteuerung';

  @override
  String get settingsCategoryAppearance => 'Darstellung';

  @override
  String get settingsCategoryReader => 'Lesemodus';

  @override
  String settingsCategoryPath(String root, String section, String subsection) {
    String _temp0 = intl.Intl.selectLogic(subsection, {
      'none': '$root › $section',
      'other': '$root › $section › $subsection',
    });
    return '$_temp0';
  }

  @override
  String get settingsActiveAccount => 'Aktives Konto';

  @override
  String get settingsNoServerAddress => 'Für dieses Konto ist keine Serveradresse eingerichtet';

  @override
  String get settingsCreateAuthenticationCode => 'Authentifizierungscode erstellen';

  @override
  String get settingsServerConnection => 'Serververbindung';

  @override
  String get settingsManageAccounts => 'Konten verwalten';

  @override
  String get settingsAddAccount => 'Konto hinzufügen';

  @override
  String settingsAccountPreferences(String username) {
    return 'Einstellungen für $username';
  }

  @override
  String get settingsPlayerSettings => 'Player-Einstellungen';

  @override
  String get settingsCurrentAccount => 'Aktuelles Konto';

  @override
  String get settingsOtherAccounts => 'Weitere Konten';

  @override
  String get settingsNoOtherAccounts => 'Keine weiteren Konten verfügbar';

  @override
  String settingsSignOutPrompt(String username) {
    return 'Auf diesem Gerät von $username abmelden?';
  }

  @override
  String get settingsRemoveAccountTitle => 'Konto entfernen?';

  @override
  String settingsRemoveAccountPrompt(String username) {
    return 'Gespeichertes Konto für $username von diesem Gerät entfernen?';
  }

  @override
  String settingsAccountRemoved(String username) {
    return 'Konto für $username entfernt';
  }

  @override
  String settingsAccountRemovalFailed(String username) {
    return 'Konto für $username konnte nicht entfernt werden';
  }

  @override
  String settingsAccountSwitched(String username) {
    return 'Zu $username gewechselt';
  }

  @override
  String get settingsSwitchToUser => 'Zu diesem Benutzer wechseln';

  @override
  String settingsOpenLinkFailed(String name) {
    return '$name konnte nicht geöffnet werden';
  }

  @override
  String get settingsGitHubRepository => 'GitHub-Repository';

  @override
  String get settingsIssueTracker => 'Fehlerverwaltung';

  @override
  String get settingsGitHubSponsors => 'GitHub-Sponsorenseite';

  @override
  String get settingsAboutSupport => 'Info und Unterstützung';

  @override
  String get settingsViewOnGitHub => 'Auf GitHub ansehen';

  @override
  String get settingsReportIssue => 'Fehler melden oder Funktion vorschlagen';

  @override
  String get settingsSponsor => 'Unterstützen';

  @override
  String get settingsSponsorDescription => 'Hilf, laufende Kosten zu decken und die Entwicklung zu unterstützen';

  @override
  String get settingsInformationTitle => 'Informationen und Quellenangaben';

  @override
  String get settingsInformationDescription => 'App-Version, Lizenzen und weitere Informationen';

  @override
  String get settingsCarIntegration => 'Auto-Integration';

  @override
  String get settingsAndroidAutomotive => 'Android Automotive';

  @override
  String get settingsAndroidAuto => 'Android Auto';

  @override
  String get settingsCarPlay => 'CarPlay';

  @override
  String get validationReleaseDateFormat => 'Gib ein gültiges Veröffentlichungsdatum im Format YYYY-MM-DD ein';

  @override
  String get validationFeedUrl => 'Gib eine gültige HTTP- oder HTTPS-Feed-URL ein';

  @override
  String get statusNoChangesToSave => 'Keine Änderungen zu speichern';

  @override
  String get errorSeriesSequencePromptUnavailable =>
      'Die Abfrage der Seriennummer konnte nicht geöffnet werden. Versuche es erneut';

  @override
  String get fieldSeriesNumber => 'Seriennummer';

  @override
  String get fieldSequence => 'Reihenfolge';

  @override
  String get hintSeriesSequence => 'Zum Beispiel 1, 2.5 oder 03 ohne Leerzeichen';

  @override
  String get actionSaveAndClose => 'Speichern und schließen';

  @override
  String get fieldSubtitle => 'Untertitel';

  @override
  String get fieldReleaseDate => 'Veröffentlichungsdatum';

  @override
  String get fieldIsbn => 'ISBN';

  @override
  String get fieldAsin => 'ASIN';

  @override
  String get fieldFeedUrl => 'Feed-URL';

  @override
  String get fieldItunesId => 'iTunes-ID';

  @override
  String get headingMetadata => 'Metadaten';

  @override
  String get fieldAuthors => 'Autoren';

  @override
  String get fieldNarrators => 'Sprecher';

  @override
  String get hintAddSeries => 'Serie hinzufügen';

  @override
  String get fieldExplicit => 'Explizite Inhalte';

  @override
  String get fieldAbridged => 'Gekürzt';

  @override
  String get fieldDescriptionHint => 'Formatierte Beschreibung verfassen';

  @override
  String get dateFormatIso => 'YYYY-MM-DD';

  @override
  String get hintPodcastFeedUrlExample => 'https://example.com/feed.xml';

  @override
  String get fieldPodcastType => 'Podcasttyp';

  @override
  String get podcastTypeEpisodic => 'Einzelne Folgen';

  @override
  String get podcastTypeSerial => 'Fortlaufende Serie';

  @override
  String get statusNoAudioTracksAvailable => 'Für die M4B-Kodierung sind keine Audiospuren verfügbar';

  @override
  String get headingM4bEncoder => 'M4B-Encoder';

  @override
  String get optionPresets => 'Voreinstellungen';

  @override
  String get optionAdvanced => 'Erweitert';

  @override
  String get fieldCodec => 'Codec';

  @override
  String get fieldBitrate => 'Bitrate';

  @override
  String get fieldChannels => 'Kanäle';

  @override
  String get fieldAudioTracks => 'Audiospuren';

  @override
  String get channelMono => 'Mono';

  @override
  String get channelStereo => 'Stereo';

  @override
  String get statusSubmitting => 'Wird gesendet…';

  @override
  String get statusRunning => 'Läuft…';

  @override
  String get actionStartEncoding => 'Kodierung starten';

  @override
  String get statusCanceling => 'Wird abgebrochen…';

  @override
  String encoderProgress(String progress) {
    return 'Fortschritt $progress';
  }

  @override
  String encoderBitrateKbps(int bitrate) {
    final intl.NumberFormat bitrateNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String bitrateString = bitrateNumberFormat.format(bitrate);

    return '$bitrateString kbit/s';
  }

  @override
  String encoderChannelCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Kanäle', one: '1 Kanal');
    return '$_temp0';
  }

  @override
  String get encoderMixedCodecs => 'Unterschiedliche Codecs';

  @override
  String get encoderMixedBitrates => 'Unterschiedliche Bitraten';

  @override
  String get encoderMixedChannels => 'Unterschiedliche Kanalzahlen';

  @override
  String encoderCurrentEncoding(String codec, String bitrate, String channels) {
    return 'Aktuelle Kodierung $codec · $bitrate · $channels';
  }

  @override
  String audioTrackMetadata(String codec, String bitrate, String channels, String duration, String size) {
    return '$codec · $bitrate · $channels · $duration · $size';
  }

  @override
  String get navDetails => 'Details';

  @override
  String get navChapters => 'Kapitel';

  @override
  String get navMatch => 'Abgleichen';

  @override
  String get navEmbedding => 'Einbettung';

  @override
  String get navEncoder => 'Encoder';

  @override
  String errorRequestFailed(int statusCode) {
    final intl.NumberFormat statusCodeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String statusCodeString = statusCodeNumberFormat.format(statusCode);

    return 'Anfrage mit Status $statusCodeString fehlgeschlagen';
  }

  @override
  String errorOperationFailed(String operation, String details) {
    return '$operation fehlgeschlagen. $details';
  }

  @override
  String get operationLoadMetadata => 'Metadaten werden geladen';

  @override
  String get operationStartEmbedding => 'Einbettung der Metadaten wird gestartet';

  @override
  String get operationStartEncoding => 'M4B-Kodierung wird gestartet';

  @override
  String get operationCancelEncoding => 'Kodierung wird abgebrochen';

  @override
  String get operationSaveItemDetails => 'Eintragsdetails werden gespeichert';

  @override
  String get operationLookupChapters => 'Kapitel werden gesucht';

  @override
  String get operationSaveChapters => 'Kapitel werden gespeichert';

  @override
  String get operationReloadChapters => 'Kapitel werden erneut geladen';

  @override
  String get statusNoAudioTracksForEmbedding => 'Für die Einbettung von Metadaten sind keine Audiospuren verfügbar';

  @override
  String get headingMetadataToEmbed => 'Einzubettende Metadaten';

  @override
  String get headingChaptersToEmbed => 'Einzubettende Kapitel';

  @override
  String get settingBackupAudioFilesBeforeEmbedding => 'Audiodateien vor dem Einbetten sichern';

  @override
  String get settingForceChapterEmbedding => 'Kapiteleinbettung erzwingen';

  @override
  String get settingForceChapterEmbeddingDescription =>
      'Beim Einbetten von Metadaten vorhandene Kapitelmarkierungen ersetzen';

  @override
  String get actionRefreshMetadata => 'Metadaten aktualisieren';

  @override
  String get statusQueued => 'Eingereiht';

  @override
  String get actionStartEmbedding => 'Einbettung starten';

  @override
  String get errorMetadataObjectMissing => 'Der Server hat keine Metadaten zurückgegeben';

  @override
  String get headingEditItem => 'Eintrag bearbeiten';

  @override
  String get actionPreviousItem => 'Vorheriger Eintrag';

  @override
  String get actionNextItem => 'Nächster Eintrag';

  @override
  String get confirmSaveChapterChanges => 'Kapiteländerungen speichern?';

  @override
  String get warningChapterEditsNotSaved => 'Deine Kapiteländerungen wurden noch nicht gespeichert';

  @override
  String get actionKeepEditing => 'Weiter bearbeiten';

  @override
  String get actionDiscardEdits => 'Änderungen verwerfen';

  @override
  String get actionAddChapters => 'Kapitel hinzufügen';

  @override
  String get hintChapterTitlePattern => 'Verwende {n} für Kapitelnummern';

  @override
  String get chapterTitlePatternExample => 'Kapitel {n}';

  @override
  String get errorEnterTitle => 'Gib einen Titel ein';

  @override
  String get fieldChapterCount => 'Anzahl der Kapitel';

  @override
  String get errorChapterCountRange => 'Gib eine Zahl zwischen 1 und 5000 ein';

  @override
  String get fieldStartTime => 'Startzeit';

  @override
  String fieldChapterNumber(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Kapitel $numberString';
  }

  @override
  String get hintChapterTimeFormat => 'HH:MM:SS oder Sekunden';

  @override
  String get errorValidChapterStart => 'Gib eine gültige Startzeit ein';

  @override
  String get fieldChapterIntervalSeconds => 'Sekunden zwischen Kapiteln';

  @override
  String get errorPositiveInterval => 'Gib ein positives Intervall ein';

  @override
  String get headingShiftChapterTimes => 'Kapitelzeiten verschieben';

  @override
  String promptShiftSelectedChapters(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählte Kapitel verschieben',
      one: '1 ausgewähltes Kapitel verschieben',
    );
    return '$_temp0. Das Kapitel bei null bleibt an seiner Stelle';
  }

  @override
  String get promptShiftAllChapters => 'Alle Kapitel nach dem Kapitel bei null verschieben';

  @override
  String get hintChapterTimeShift => '-10 oder 10';

  @override
  String get errorChapterTimeShiftRequired => 'Gib eine positive oder negative Anzahl von Sekunden ein';

  @override
  String get statusNoChaptersFoundForSearch => 'Für diese ASIN und Region wurden keine Kapitel gefunden';

  @override
  String get errorInvalidChapterLookupData => 'Die Kapitelsuche hat ungültige Daten zurückgegeben';

  @override
  String chapterLookupSummary(int foundCount, int bookCount) {
    final intl.NumberFormat foundCountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String foundCountString = foundCountNumberFormat.format(foundCount);
    final intl.NumberFormat bookCountNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String bookCountString = bookCountNumberFormat.format(bookCount);

    String _temp0 = intl.Intl.pluralLogic(
      foundCount,
      locale: localeName,
      other: '$foundCountString Kapitel gefunden',
      one: '1 Kapitel gefunden',
    );
    String _temp1 = intl.Intl.pluralLogic(
      bookCount,
      locale: localeName,
      other: '$bookCountString Kapitel',
      one: '1 Kapitel',
    );
    return '$_temp0 · Aktuelles Buch: $_temp1';
  }

  @override
  String chapterDurationComparison(String foundDuration, String bookDuration) {
    return 'Gefundene Dauer $foundDuration. Dauer des Buchs $bookDuration';
  }

  @override
  String get optionApplyChapterTitlesOnly => 'Nur Titel übernehmen';

  @override
  String get descriptionKeepChapterTimes => 'Vorhandene Kapitelzeiten beibehalten';

  @override
  String get actionApplyToDraft => 'Auf Entwurf anwenden';

  @override
  String get warningReplaceChapterDraft =>
      'Dadurch wird der aktuelle Kapitelentwurf ersetzt. Änderungen werden beim Speichern übernommen';

  @override
  String get confirmCreateChaptersFromTracks => 'Kapitel aus Audiospuren erstellen?';

  @override
  String get confirmReplaceUnsavedChapterEdits => 'Nicht gespeicherte Kapiteländerungen ersetzen?';

  @override
  String get confirmDiscardChapterEdits => 'Kapiteländerungen verwerfen?';

  @override
  String get promptRestoreChapterDraft => 'Die derzeit auf dem Server gespeicherten Kapitel wiederherstellen';

  @override
  String get actionReplace => 'Ersetzen';

  @override
  String get statusChaptersSaved => 'Kapitel gespeichert';

  @override
  String get statusChapterSaveConflict =>
      'Kapitel oder Audiospuren auf dem Server wurden geändert. Lade sie vor dem Speichern erneut';

  @override
  String statusChapterErrors(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bei $countString Kapiteln ist ein Eingriff erforderlich',
      one: 'Bei 1 Kapitel ist ein Eingriff erforderlich',
    );
    return '$_temp0';
  }

  @override
  String get statusUnsavedChanges => 'Nicht gespeicherte Änderungen';

  @override
  String get actionChapterTools => 'Werkzeuge';

  @override
  String get actionFindChapters => 'Kapitel suchen';

  @override
  String get fieldRegion => 'Region';

  @override
  String get statusSearching => 'Suche läuft…';

  @override
  String get actionShiftTimes => 'Zeiten verschieben';

  @override
  String get actionUseAudioTracks => 'Audiospuren verwenden';

  @override
  String get hintSearchChapters => 'Kapitel nach Titel oder Nummer suchen';

  @override
  String get a11ySelectAllVisibleChapters => 'Alle sichtbaren Kapitel auswählen';

  @override
  String get statusEdited => 'Bearbeitet';

  @override
  String get hintChapterTitle => 'Kapiteltitel';

  @override
  String get tooltipChapterPreview => 'Bis zu 20 Sekunden probehören. Pausiert die Wiedergabe';

  @override
  String get actionStopPreview => 'Vorschau beenden';

  @override
  String get errorChapterPreviewUnavailable => 'Vorschau dieses Kapitels nicht verfügbar';

  @override
  String get errorBookDurationUnavailable => 'Buchdauer nicht verfügbar';

  @override
  String get errorFirstChapterMustStartAtZero => 'Das erste Kapitel muss bei null beginnen';

  @override
  String get errorChapterStartOutsideBook => 'Der Start muss innerhalb des Buchs liegen';

  @override
  String get errorChapterStartsNotAscending => 'Die Startzeiten müssen aufsteigend sortiert sein';

  @override
  String get tooltipChapterActions => 'Kapitelaktionen';

  @override
  String get actionInsertChapterBelow => 'Kapitel darunter einfügen';

  @override
  String get actionRemoveChapter => 'Kapitel entfernen';

  @override
  String get actionRemoveSelected => 'Ausgewählte entfernen';

  @override
  String a11ySelectChapter(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Kapitel $numberString auswählen';
  }

  @override
  String get headingSwitchUser => 'Benutzer wechseln';

  @override
  String get promptSwitchUserDuringPlayback =>
      'Möchtest du wirklich den Benutzer wechseln? Der Wiedergabefortschritt wird lokal gespeichert und nach dem Neustart der App mit dem Server synchronisiert';

  @override
  String get actionSwitch => 'Wechseln';

  @override
  String get actionAddUser => 'Benutzer hinzufügen';

  @override
  String get actionManageUsers => 'Benutzer verwalten';

  @override
  String get labelUsers => 'Benutzer';

  @override
  String get errorCouldNotLoadUsers => 'Benutzer konnten nicht geladen werden';

  @override
  String get actionRun => 'Ausführen';

  @override
  String get errorNoActiveApiClient => 'Kein aktiver API-Client';

  @override
  String get errorSelectAtLeastOneLibrary => 'Wähle mindestens eine Bibliothek aus';

  @override
  String get operationLoadLibraries => 'Bibliotheken werden geladen';

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
      other: '$librariesString Bibliotheken verarbeitet',
      one: '1 Bibliothek verarbeitet',
    );
    String _temp1 = intl.Intl.pluralLogic(
      tagged,
      locale: localeName,
      other: '$taggedString Einträge markiert',
      one: '1 Eintrag markiert',
    );
    String _temp2 = intl.Intl.pluralLogic(
      updated,
      locale: localeName,
      other: '$updatedString aktualisierte Einträge',
      one: '1 aktualisierten Eintrag',
    );
    return '$_temp0 und $_temp1. Der Server meldet $_temp2';
  }

  @override
  String get settingLibraryViews => 'Bibliotheksansichten';

  @override
  String get promptSignInToManageSettings => 'Melde dich an, um Benutzereinstellungen zu verwalten';

  @override
  String get statusNoLibrariesFound => 'Keine Bibliotheken gefunden';

  @override
  String get operationLoadSettings => 'Einstellungen werden geladen';

  @override
  String get operationLoadUser => 'Benutzer wird geladen';

  @override
  String operationSaveSubtitlesForView(String view) {
    return 'Untertitel für $view werden gespeichert';
  }

  @override
  String get libraryTypeDefault => 'Standard';

  @override
  String get libraryTypeMusic => 'Musik';

  @override
  String actionChangeLibraryType(String type) {
    return 'Typ in $type ändern';
  }

  @override
  String librarySubtitleChooseInfo(String view) {
    return 'Wähle aus, welche Informationen unter $view angezeigt werden';
  }

  @override
  String validationMaxSubtitleFields(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Felder', one: '1 Feld');
    return 'Wähle für benutzerdefinierte Untertitel höchstens $_temp0 aus';
  }

  @override
  String get actionCopyRaw => 'Rohwert kopieren';

  @override
  String get actionCopyMarkdown => 'Markdown kopieren';

  @override
  String get actionExportLogs => 'Protokolle exportieren';

  @override
  String get actionScrollToTop => 'Zum Seitenanfang';

  @override
  String get actionScrollToBottom => 'Zum Seitenende';

  @override
  String get statusNoLogsAvailable => 'Keine Protokolle verfügbar';

  @override
  String get statusLogsCopied => 'Protokolle in die Zwischenablage kopiert';

  @override
  String statusLogsExportedToPath(String path) {
    return 'Protokolle nach $path exportiert';
  }

  @override
  String get statusExporting => 'Wird exportiert…';

  @override
  String get messageLogsAppearHere => 'Protokolle erscheinen hier, sobald sie erstellt werden';

  @override
  String logEntryCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Einträge', one: '1 Eintrag');
    return '$_temp0';
  }

  @override
  String logExportSummary(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Einträge', one: '1 Eintrag');
    return 'Protokolle ($_temp0)';
  }

  @override
  String get operationExportLogs => 'Protokolle werden exportiert';

  @override
  String get actionChoose => 'Auswählen';

  @override
  String get actionChooseFolder => 'Ordner auswählen';

  @override
  String get actionChooseFiles => 'Dateien auswählen';

  @override
  String get actionUseDefaultLocation => 'Standardspeicherort verwenden';

  @override
  String get headingDownloadBehavior => 'Downloadverhalten';

  @override
  String get settingDownloadPreference => 'Downloadpräferenz';

  @override
  String get settingDownloadPreferenceDescription => 'Standardmäßig herunterzuladende Mediendateien auswählen';

  @override
  String get optionAskEveryTime => 'Jedes Mal fragen';

  @override
  String get optionAudiobookOnly => 'Nur Hörbücher';

  @override
  String get optionEbookOnly => 'Nur E-Books';

  @override
  String get settingDownloadAllAudioFiles => 'Immer alle Audiodateien herunterladen';

  @override
  String get settingDownloadAllAudioFilesDescription => 'Bei Buchdownloads die Auswahl der Audiodateien überspringen';

  @override
  String get statusDownloadLocationUpdated => 'Downloadspeicherort aktualisiert';

  @override
  String get statusUsingDefaultDownloadLocation => 'Standardspeicherort für Downloads wird verwendet';

  @override
  String get operationSaveDownloadLocation => 'Downloadspeicherort wird gespeichert';

  @override
  String get headingPermissionVisibility => 'Sichtbarkeit von Berechtigungen';

  @override
  String get permissionCollections => 'Sammlungen';

  @override
  String get permissionCollectionsDescription =>
      'Steuerung zum Erstellen und Bearbeiten von Sammlungen und Wiedergabelisten anzeigen';

  @override
  String get permissionEditItems => 'Einträge bearbeiten';

  @override
  String get permissionEditItemsDescription =>
      'Werkzeuge zum Bearbeiten von Einträgen wie die Sammelbearbeitung anzeigen';

  @override
  String get permissionDeleteItems => 'Einträge löschen';

  @override
  String get permissionDeleteItemsDescription => 'Steuerung zum Löschen von Einträgen anzeigen';

  @override
  String get permissionEditChapters => 'Kapitel bearbeiten';

  @override
  String get permissionEditChaptersDescription => 'Kapiteleditor anzeigen';

  @override
  String get permissionUploadDescription => 'Werkzeuge zum Hochladen neuer Einträge anzeigen';

  @override
  String get permissionMatches => 'Abgleich und Schnellabgleich erlauben';

  @override
  String get permissionMatchesDescription => 'Werkzeuge für manuellen Abgleich, Schnellabgleich und Vorschau anzeigen';

  @override
  String get permissionRequiresEditItems => 'Erfordert die Berechtigung zum Bearbeiten von Einträgen';

  @override
  String get permissionRequiresDeleteItems => 'Erfordert die Berechtigung zum Löschen von Einträgen';

  @override
  String get permissionRequiresUpload => 'Erfordert die Berechtigung zum Hochladen';

  @override
  String promptEnableSettingFirst(String setting) {
    return 'Aktiviere zuerst „$setting“';
  }

  @override
  String get headingServerEndpoints => 'Serverendpunkte';

  @override
  String get headingAccountCredentials => 'Kontodaten';

  @override
  String get fieldExternalServerUrl => 'Externe Server-URL';

  @override
  String get fieldLocalServerUrl => 'Lokale Server-URL';

  @override
  String get hintLocalServerUrl => 'Optional · http://192.168.1.25:13378';

  @override
  String get validationInvalidExternalServerUrl => 'Gib eine gültige externe Server-URL ein';

  @override
  String get validationInvalidLocalServerUrl => 'Gib eine gültige lokale Server-URL ein oder lass das Feld leer';

  @override
  String get validationUsernameRequired => 'Gib einen Benutzernamen ein';

  @override
  String get validationPasswordRequiredForCredentialUpdate =>
      'Gib dein Passwort ein, um deinen Benutzernamen oder deine Anmeldedaten zu ändern';

  @override
  String get statusServerSettingsSaved => 'Servereinstellungen gespeichert';

  @override
  String get messageLocalServerPreferred =>
      'Wenn eine lokale Adresse verfügbar ist, wird sie bevorzugt. Bei Bedarf wechselt die App zur externen Adresse';

  @override
  String get hintPasswordCredentialUpdate => 'Nur beim Ändern der Anmeldedaten erforderlich';

  @override
  String get messageEmptyPasswordKeepsCredentials =>
      'Lass das Passwortfeld leer, um deine aktuellen Anmeldedaten beizubehalten';

  @override
  String get actionShowPassword => 'Passwort anzeigen';

  @override
  String get actionHidePassword => 'Passwort ausblenden';

  @override
  String get errorCredentialValidationNoData => 'Der Server hat keine Kontodaten zurückgegeben';

  @override
  String get errorCredentialsForDifferentAccount =>
      'Diese Anmeldedaten gehören zu einem anderen Konto. Verwende stattdessen „Konto hinzufügen“';

  @override
  String get operationSaveServerSettings => 'Servereinstellungen werden gespeichert';

  @override
  String get errorUnknown => 'Ein unbekannter Fehler ist aufgetreten';

  @override
  String get operationReconcileSmartDownloads => 'Intelligente Downloads werden abgeglichen';

  @override
  String get actionReconcileSmartDownloads => 'Jetzt abgleichen';

  @override
  String get headingDownloadRules => 'Downloadregeln';

  @override
  String get statusNoDownloadRules => 'Noch keine automatischen Downloadregeln';

  @override
  String smartDownloadRuleCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString aktive Regeln',
      one: '1 aktive Regel',
      zero: 'Keine aktiven Regeln',
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
      other: '$sourcesString Quellen',
      one: '1 Quelle',
      zero: 'Keine Quellen',
    );
    String _temp1 = intl.Intl.pluralLogic(items, locale: localeName, other: '$itemsString Einträge', one: '1 Eintrag');
    return '$_temp0 · $_temp1 pro Quelle';
  }

  @override
  String get headingRemoveProfile => 'Profil entfernen?';

  @override
  String smartDownloadRemoveProfilePrompt(String name) {
    return '„$name“ entfernen und die davon verwalteten Downloads löschen? Downloads, die mit einer anderen Regel geteilt werden, bleiben erhalten';
  }

  @override
  String get headingNewProfile => 'Neues Profil';

  @override
  String get headingEditProfile => 'Profil bearbeiten';

  @override
  String get fieldItemsPerSource => 'Einträge pro Quelle (1–150)';

  @override
  String get fieldMaximumAgeDays => 'Maximales Alter in Tagen (optional)';

  @override
  String fieldStorageBudget(String unit) {
    return 'Speicherlimit ($unit, optional)';
  }

  @override
  String get fieldKeepFinishedBooksForHours => 'Abgeschlossene Bücher für diese Anzahl Stunden behalten';

  @override
  String get fieldDownloadTypes => 'Downloadtypen';

  @override
  String get optionAudiobooksAndEpisodes => 'Hörbücher und Folgen';

  @override
  String get statusEnabled => 'Aktiviert';

  @override
  String get headingSelectedSources => 'Ausgewählte Quellen';

  @override
  String smartDownloadSourceName(String source) {
    return '$source-Quelle';
  }

  @override
  String get smartDownloadAfterListening => 'Nach dem Anhören herunterladen';

  @override
  String get smartDownloadDefaultProfileName => 'Offline-Warteschlange';

  @override
  String get headingLibrarySettings => 'Bibliothekseinstellungen';

  @override
  String get settingCheckForAppUpdates => 'Nach App-Updates suchen';

  @override
  String get settingCheckForAppUpdatesDescription =>
      'Beim Start nach neueren yaabsa-Versionen suchen. Dazu wird GitHub kontaktiert';

  @override
  String get messageAdditionalToolsInfo =>
      'Diese optionalen Werkzeuge erweitern Serverfunktionen und sind standardmäßig deaktiviert';

  @override
  String get headingToolSubpages => 'Werkzeug-Unterseiten';

  @override
  String get headingPathTagGenreUpdate => 'Pfad-, Tag- und Genreaktualisierung';

  @override
  String get headingExperimentalTools => 'Experimentelle Werkzeuge';

  @override
  String get headingAdminServerSettings => 'Servereinstellungen für Admins';

  @override
  String adminSettingsForServer(String server) {
    return 'Einstellungen für $server';
  }

  @override
  String get statusUnknownServer => 'Unbekannter Server';

  @override
  String get navServerConfiguration => 'Serverkonfiguration';

  @override
  String get navBackups => 'Sicherungen';

  @override
  String get navApiKeys => 'API-Schlüssel';

  @override
  String get navRssFeeds => 'RSS-Feeds';

  @override
  String get navEmailEReader => 'E-Mail / E-Reader';

  @override
  String get navAuthentication => 'Authentifizierung';

  @override
  String get navItemMetadataUtils => 'Metadatenwerkzeuge für Einträge';

  @override
  String get navLibraryStats => 'Bibliotheksstatistiken';

  @override
  String get messageCachingGeneral => 'Zwischenspeicherung von Antworten und Beschleunigungsmodus konfigurieren';

  @override
  String get messageCacheRouteRules => 'Zwischenspeicherungsverhalten für Server-API-Routen auswählen';

  @override
  String get navCacheRouteRules => 'Routenregeln';

  @override
  String get permissionCachingRequired => 'Aktiviere die Zwischenspeicherung, um diese Optionen zu ändern';

  @override
  String get warningCacheMayAffectMultipleDevices =>
      'Das Aktivieren kann auf mehreren Geräten zu unerwartetem Verhalten führen';

  @override
  String get headingBrowseSettings => 'Sucheinstellungen';

  @override
  String headingIntegrationSettings(String integration) {
    return 'Einstellungen für $integration';
  }

  @override
  String headingIntegrationSectionSettings(String integration, String section) {
    return '$integration $section-Einstellungen';
  }

  @override
  String get navPodcastLibrary => 'Podcastbibliothek';

  @override
  String get settingGroupListsByFirstLetter => 'Lange Listen nach Anfangsbuchstaben gruppieren';

  @override
  String settingGroupListsByFirstLetterDescription(String integration) {
    return 'Einträge in langen $integration-Listen alphabetisch gruppieren, damit sie leichter zu durchsuchen sind';
  }

  @override
  String settingBrowseSortDescription(String contentType, String integration) {
    return 'Sortierung von $contentType-Einträgen beim Durchsuchen in $integration auswählen';
  }

  @override
  String get settingSortDescending => 'Absteigend sortieren';

  @override
  String settingSortDescendingDescription(String contentType) {
    return '$contentType-Listen absteigend sortieren';
  }

  @override
  String get fieldSortBy => 'Sortieren nach';

  @override
  String get sortDateAdded => 'Hinzugefügt am';

  @override
  String get operationSaveSortOrder => 'Sortierreihenfolge wird gespeichert';

  @override
  String get headingTransferSettings => 'Einstellungen übertragen';

  @override
  String get settingsBackupImportPrompt => 'Einstellungen importieren?';

  @override
  String settingsImportConfirmation(int appSettings, int userSettings, int skippedAccounts) {
    String _temp0 = intl.Intl.pluralLogic(
      appSettings,
      locale: localeName,
      other: '$appSettings App-Einstellungen',
      one: '1 App-Einstellung',
      zero: 'Keine App-Einstellungen',
    );
    String _temp1 = intl.Intl.pluralLogic(
      userSettings,
      locale: localeName,
      other: '$userSettings Kontoeinstellungen',
      one: '1 Kontoeinstellung',
      zero: 'keine Kontoeinstellungen',
    );
    String _temp2 = intl.Intl.pluralLogic(
      skippedAccounts,
      locale: localeName,
      other: '\n\n$skippedAccounts gespeicherte Konten ohne passende Benutzereinstellungen werden übersprungen.',
      one: '\n\n1 gespeichertes Konto ohne passende Benutzereinstellungen wird übersprungen.',
      zero: '',
    );
    return '$_temp0 und $_temp1 werden wiederhergestellt.\n\nKontoeinstellungen werden nur für gespeicherte Konten mit übereinstimmenden Benutzer-IDs wiederhergestellt.$_temp2\n\nÜbereinstimmende Einstellungen werden ersetzt. Andere Einstellungen bleiben erhalten.\n\nStarte yaabsa nach dem Import neu, damit alle Änderungen übernommen werden.';
  }

  @override
  String get statusSettingsExported => 'Einstellungen exportiert';

  @override
  String get statusSettingsImportedRestart =>
      'Einstellungen importiert. Starte die App neu, damit alle Änderungen übernommen werden';

  @override
  String get statusNoMatchingSettingsToImport =>
      'Für gespeicherte Konten mit übereinstimmenden Benutzer-IDs gibt es keine Einstellungen zum Importieren';

  @override
  String get operationTransferSettings => 'Einstellungen werden übertragen';

  @override
  String get headingManageUsers => 'Benutzer verwalten';

  @override
  String get messagePlayerGeneralSettings =>
      'Verhalten der Zeitleiste, Sprungintervalle und automatisches Einreihen festlegen';

  @override
  String get messageSmartRewindSettings => 'Festlegen, wie die Wiedergabe nach Pausen zurückspult';

  @override
  String get messageSleepTimerSettings =>
      'Aktion beim Ablauf des Timers und optionalen automatischen Neustart festlegen';

  @override
  String get messageEqualizerSettings => 'Audiofrequenzbänder anpassen';

  @override
  String get messageSubtitleSettings => 'Untertitel und Leseunterstützung konfigurieren';

  @override
  String get messageShakeControlsSettings => 'Schüttelgesten und Empfindlichkeit konfigurieren';

  @override
  String get statusMotionSensorsRequired => 'Auf Geräten mit Bewegungssensoren verfügbar';

  @override
  String get statusShakeControlsUnavailable => 'Schüttelsteuerung ist auf diesem Gerät nicht verfügbar';

  @override
  String get settingsCategoryAccessibilityDevice => 'Bedienungshilfen und Gerät';

  @override
  String get settingsCategoryBufferAndScreen => 'Puffer und Bildschirm';

  @override
  String get settingsCategoryMediaNotifications => 'Medienbenachrichtigung';

  @override
  String get settingsCategoryStartupAndBackground => 'Start und Hintergrund';

  @override
  String get settingsCategoryAudioDecoding => 'Audiodekodierung';

  @override
  String get optionFullAudiobookProgressDescription => 'Fortschritt und Details des gesamten Hörbuchs anzeigen';

  @override
  String get optionCurrentChapterProgressDescription => 'Fortschritt und Details des aktuellen Kapitels anzeigen';

  @override
  String get settingEnableMp3IndexSeeking => 'MP3-Indexsuche aktivieren';

  @override
  String get settingEnableMp3IndexSeekingDescription =>
      'Kompatibilität der MP3-Suche verbessern. Die Suche kann langsamer sein und mehr Daten verbrauchen. Starte die App neu, damit die Änderung wirksam wird';

  @override
  String permissionEnableSettingToChangeOption(String setting) {
    return 'Aktiviere $setting, um diese Option zu ändern';
  }

  @override
  String get permissionMotionSensorsRequired => 'Erfordert ein Gerät mit Bewegungssensoren';

  @override
  String get statusCheckingVibrationSupport => 'Vibrationsunterstützung wird überprüft';

  @override
  String get statusVibrationUnavailable => 'Dieses Gerät unterstützt kein Vibrationsfeedback';

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
  String get settingsCategoryTimerExpiry => 'Verhalten beim Ablauf';

  @override
  String get settingsCategoryAutoRestart => 'Optionen für automatischen Neustart';

  @override
  String get fieldTimerMode => 'Timermodus';

  @override
  String get settingTimerModeDescription => 'Kapitel-Timer starten nur bei Einträgen mit Kapiteln';

  @override
  String get permissionAutomaticRestartRequired => 'Aktiviere den automatischen Neustart, um diese Option einzurichten';

  @override
  String get permissionTimerRangeRequired =>
      'Aktiviere den automatischen Neustart und wähle einen Zeitraum aus, um diese Option einzurichten';

  @override
  String get actionEnable => 'Aktivieren';

  @override
  String get settingsCategoryTimeline => 'Zeitleiste';

  @override
  String get optionChapterTimelineDescription => 'Aktuelles Kapitel verfolgen';

  @override
  String get optionFullAudiobookTimelineDescription => 'Gesamtes Hörbuch verfolgen';

  @override
  String get optionCombinedTimelineDescription => 'Kapitel und gesamtes Hörbuch verfolgen';

  @override
  String get optionChapterMarkersDescription => 'Kapitelmarkierungen anzeigen';

  @override
  String get optionBookmarkMarkersDescription => 'Lesezeichenmarkierungen anzeigen';

  @override
  String get optionChapterAndBookmarkMarkersDescription => 'Kapitel- und Lesezeichenmarkierungen anzeigen';

  @override
  String get optionNoTimelineMarkersDescription => 'Zeitleistenmarkierungen ausblenden';

  @override
  String get settingsCategoryOnScreenControls => 'Bildschirmsteuerung';

  @override
  String get settingFullPlayerTransportButtons => 'Steuerungsschaltflächen des Vollbild-Players';

  @override
  String get playerTypeFull => 'Vollbild-Player';

  @override
  String get playerTypeMini => 'Miniplayer';

  @override
  String settingTransportModeDescription(String playerType) {
    return 'Lege fest, ob der $playerType zeitbasierte Sprünge, Eintrags- und Kapitelsprünge oder beides zeigt';
  }

  @override
  String get settingFullPlayerActions => 'Aktionen des Vollbild-Players';

  @override
  String get settingFullPlayerActionsDescription => 'Aktionen für den Vollbild-Player auswählen';

  @override
  String get settingLeftQuickAction => 'Linke Schnellaktion';

  @override
  String get settingLeftQuickActionDescription => 'Aktion unten links im minimalistischen Player auswählen';

  @override
  String get settingRightQuickAction => 'Rechte Schnellaktion';

  @override
  String get settingRightQuickActionDescription => 'Aktion unten rechts im minimalistischen Player auswählen';

  @override
  String get settingMiniPlayerTransportButtons => 'Steuerungsschaltflächen des Miniplayers';

  @override
  String get settingMiniPlayerActions => 'Miniplayer-Aktionen';

  @override
  String get settingMiniPlayerActionsDescription => 'Aktionen im Miniplayer-Menü auswählen';

  @override
  String get settingsCategorySkipIntervals => 'Sprungintervalle';

  @override
  String get settingsCategoryPlaybackBehavior => 'Wiedergabeverhalten';

  @override
  String get settingStartPlaybackFromLocalProgress => 'Bei lokalem Fortschritt starten';

  @override
  String get settingStartPlaybackFromLocalProgressDescription =>
      'Wiedergabe starten, ohne auf den Serverfortschritt zu warten';

  @override
  String get settingRestartListeningSessionAtMidnight => 'Hörsitzung um Mitternacht neu starten';

  @override
  String get settingSeekWithMediaSkipControls => 'Mit Medientasten springen';

  @override
  String get settingSeekWithMediaSkipControlsDescription =>
      'Externe Mediensteuerung für Vor- und Zurückspringen in den eingestellten Intervallen verwenden';

  @override
  String get confirmSeekWithMediaSkipControlsTitle => 'Mit Medientasten springen?';

  @override
  String get confirmSeekWithMediaSkipControls =>
      'Dadurch ändert sich, wie yaabsa externe Mediensteuerungen wie Bluetooth-Kopfhörertasten und Medientastenkürzel behandelt. Mit den Tasten für Weiter und Zurück wird in den eingestellten Intervallen gesprungen, statt Kapitel oder Warteschlangeneinträge zu überspringen.\n\nSchaltflächen in yaabsa behalten ihr normales Sprungverhalten. Diese Einstellung betrifft nur externe Mediensteuerungen.';

  @override
  String get settingPreventWordClipping => 'Wortabschneiden verhindern';

  @override
  String get settingPreventWordClippingDescription =>
      'Leise Hintergrundgeräusche abspielen, damit verbundene Geräte aktiv bleiben';

  @override
  String get settingSkipSilence => 'Stille überspringen';

  @override
  String get settingSkipSilenceDescription => 'Stille Abschnitte während der Wiedergabe automatisch überspringen';

  @override
  String get settingShowPlayerLoopShuffle => 'Wiederholen und Mischen anzeigen';

  @override
  String get optionMusicOnly => 'Nur Musik';

  @override
  String get optionLoopShuffleHiddenDescription => 'Steuerung für Wiederholen und Mischen nie anzeigen';

  @override
  String get optionLoopShuffleMusicOnlyDescription =>
      'Steuerung für Wiederholen und Mischen nur bei Musikbibliotheken anzeigen';

  @override
  String get optionLoopShuffleAlwaysDescription => 'Steuerung für Wiederholen und Mischen immer anzeigen';

  @override
  String get settingsCategoryAutoResume => 'Automatisch fortsetzen';

  @override
  String get settingAutoResumeOnBluetooth => 'Bei Bluetooth-Verbindung automatisch fortsetzen';

  @override
  String get settingAutoResumeOnBluetoothDescription =>
      'Wiedergabe automatisch fortsetzen, wenn ein Bluetooth-Audiogerät verbunden wird';

  @override
  String get settingOnlySelectedBluetoothDevices => 'Nur ausgewählte Bluetooth-Geräte';

  @override
  String get settingOnlySelectedBluetoothDevicesDescription =>
      'Festlegen, welche gekoppelten Bluetooth-Geräte die Wiedergabe fortsetzen können';

  @override
  String get fieldBluetoothAudioDevices => 'Bluetooth-Audiogeräte';

  @override
  String get statusNoBluetoothAudioDevices => 'Keine gekoppelten Bluetooth-Audiogeräte gefunden';

  @override
  String get statusLoadingBluetoothAudioDevices => 'Gekoppelte Bluetooth-Audiogeräte werden geladen';

  @override
  String get errorBluetoothPermissionRequired =>
      'Zum Auflisten der Audiogeräte ist eine Bluetooth-Berechtigung erforderlich';

  @override
  String get settingsCategoryPlayerAppearance => 'Playerdarstellung';

  @override
  String get settingFullPlayerLayout => 'Layout des Vollbild-Players';

  @override
  String get settingFullPlayerLayoutDescription => 'Anordnung der Komponenten im Vollbild-Player auswählen';

  @override
  String get optionAdaptiveLayoutDescription => 'Ausgewähltes Preset an den verfügbaren Bildschirmbereich anpassen';

  @override
  String get optionCustomLayoutDescription => 'Gespeichertes Komponentengitter verwenden';

  @override
  String get settingAdaptivePreset => 'Adaptives Preset';

  @override
  String get settingAdaptivePresetDescription => 'Steuerungselemente für den adaptiven Player auswählen';

  @override
  String get optionAdaptivePresetFullDescription =>
      'Konfigurierte Aktionen auf Mobilgeräten in einer Aktionsleiste unten anzeigen';

  @override
  String get optionAdaptivePresetMinimalisticDescription => 'Zwei Schnellaktionen anzeigen';

  @override
  String get optionCoverSizeAutomaticDescription => 'Die mit dem ausgewählten Preset verknüpfte Größe verwenden';

  @override
  String get optionCoverSizeCompactDescription => 'Kleinere Covergröße verwenden';

  @override
  String get optionCoverSizeLargeDescription => 'Größere Covergröße verwenden';

  @override
  String get settingsCategoryAudioInterruptions => 'Audio-Unterbrechungen';

  @override
  String get settingInterruptionBehavior => 'Bei Unterbrechungen';

  @override
  String get settingInterruptionBehaviorDescription =>
      'Festlegen, ob die Wiedergabe bei Anrufen oder Benachrichtigungen pausiert oder leiser wird';

  @override
  String get playbackLowerVolume => 'Lautstärke verringern';

  @override
  String get optionLowerPlaybackVolumeDescription => 'Wiedergabelautstärke verringern';

  @override
  String playerActionSelectionSummary(String description, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Aktionen angezeigt',
      one: '1 Aktion angezeigt',
    );
    return '$description\n$_temp0';
  }

  @override
  String get hintChooseAndOrderActions => 'Sichtbare Aktionen auswählen und in die gewünschte Reihenfolge ziehen';

  @override
  String get hintDragToReorder => 'Zum Neuanordnen ziehen';

  @override
  String get settingMediaNotificationLayout => 'Layout der Medienbenachrichtigung';

  @override
  String get playbackSpeedCycleDescription => 'Zwischen verfügbaren Wiedergabegeschwindigkeiten wechseln';

  @override
  String get playbackStopNotificationDescription => 'Wiedergabe beenden und Benachrichtigung schließen';

  @override
  String get playbackNextChapterDescription => 'Zum nächsten Kapitel springen';

  @override
  String get playbackPreviousChapterDescription => 'Zum vorherigen Kapitel zurückgehen';

  @override
  String get actionSwitchPage => 'Seite wechseln';

  @override
  String get actionSwitchPageDescription => 'Zur nächsten Seite der Benachrichtigungssteuerung wechseln';

  @override
  String notificationSelectActionForSlot(int slot) {
    final intl.NumberFormat slotNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String slotString = slotNumberFormat.format(slot);

    return 'Aktion für Platz $slotString auswählen';
  }

  @override
  String get statusEmptyActionSlot => 'Leer. Tippe, um eine Aktion zuzuweisen';

  @override
  String get statusNotificationLayoutMayVary => 'Dieses Layout kann je nach Android-Version und Gerät anders aussehen';

  @override
  String get warningSwitchPageActionRequiredTitle => 'Aktion zum Seitenwechsel hinzufügen';

  @override
  String warningSwitchPageActionRequired(String action) {
    return 'Füge bei mehreren Seiten eine Schaltfläche „$action“ hinzu, um zwischen ihnen zu wechseln';
  }

  @override
  String get headingNotificationPages => 'Benachrichtigungsseiten';

  @override
  String get actionAddPage => 'Seite hinzufügen';

  @override
  String notificationPageNumber(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Seite $numberString';
  }

  @override
  String notificationArrangeButtonsPage(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Schaltflächen auf Seite $numberString anordnen';
  }

  @override
  String notificationSlotNumber(int number) {
    final intl.NumberFormat numberNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String numberString = numberNumberFormat.format(number);

    return 'Platz $numberString';
  }

  @override
  String get logLevelDebug => 'Debug';

  @override
  String get logLevelInfo => 'Info';

  @override
  String get logLevelError => 'Fehler';

  @override
  String get logLevelDebugDescription => 'Detaillierte Protokolle zur Fehlerbehebung';

  @override
  String get logLevelInfoDescription => 'Informative Ereignisse zu Vorgängen';

  @override
  String get logLevelWarningDescription => 'Warnungen zu möglicherweise problematischen Ereignissen';

  @override
  String get logLevelErrorDescription => 'Kritische Fehler und Ausfälle';

  @override
  String get settingEnableEqualizer => 'Equalizer aktivieren';

  @override
  String get errorEqualizerUnavailableOnDevice => 'Equalizer ist auf diesem Gerät nicht verfügbar';

  @override
  String get statusEqualizerDisabled => 'Equalizer ist deaktiviert';

  @override
  String get promptEnableEqualizerToAdjustBands =>
      'Aktiviere den Equalizer oben, um seine Frequenzbänder während der Wiedergabe anzupassen';

  @override
  String get statusEqualizerUnavailable => 'Equalizer nicht verfügbar';

  @override
  String get messageEqualizerWillRetry =>
      'Dieses Gerät konnte den Equalizer nicht auf die aktuelle Audiositzung anwenden. Die Wiedergabe wird ohne Equalizer fortgesetzt. In einer späteren Sitzung wird es erneut versucht';

  @override
  String get statusNoActivePlaybackSession => 'Keine aktive Wiedergabesitzung';

  @override
  String get promptStartPlaybackToConfigureEqualizer =>
      'Starte die Wiedergabe eines Eintrags, um die Equalizer-Verstärkung einzustellen';

  @override
  String get operationLoadEqualizerParameters => 'Equalizerparameter werden geladen';

  @override
  String get statusNoEqualizerBands => 'Keine Equalizer-Frequenzbänder gefunden';

  @override
  String get settingEqualizerPreset => 'Equalizer-Preset';

  @override
  String get equalizerPresetFlat => 'Linear';

  @override
  String get equalizerPresetNarration => 'Sprachausgabe';

  @override
  String get equalizerPresetClassical => 'Klassik';

  @override
  String get equalizerPresetDance => 'Dance';

  @override
  String get equalizerPresetHeavyMetal => 'Heavy Metal';

  @override
  String get equalizerPresetRock => 'Rock';

  @override
  String get headingAddSource => 'Quelle hinzufügen';

  @override
  String get fieldLibrary => 'Bibliothek';

  @override
  String get fieldSourceType => 'Quellentyp';

  @override
  String get fieldDownloadTrigger => 'Herunterladen, wenn';

  @override
  String get fieldBookProgress => 'Buchfortschritt (%)';

  @override
  String get fieldMinutesListened => 'Gehörte Minuten';

  @override
  String errorWholeNumberRange(int minimum, int maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Gib eine ganze Zahl zwischen $minimumString und $maximumString ein';
  }

  @override
  String get smartDownloadCurrentDeviceListeningDescription => 'Zählt nur die Wiedergabe auf diesem Gerät';

  @override
  String get errorLoadSmartDownloadSources => 'Nicht alle Quellen konnten geladen werden. Versuche es erneut';

  @override
  String get searchSources => 'Quellen suchen';

  @override
  String get errorSearchSources => 'Quellensuche fehlgeschlagen. Versuche einen anderen Suchbegriff';

  @override
  String smartDownloadProgressThreshold(int percent) {
    final intl.NumberFormat percentNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String percentString = percentNumberFormat.format(percent);

    return '$percentString%';
  }

  @override
  String get headingDownloadBook => 'Buch herunterladen';

  @override
  String get headingDownloadSelectedBooks => 'Ausgewählte Bücher herunterladen';

  @override
  String get optionAudiobookAndEbook => 'Hörbuch und E-Book';

  @override
  String get optionRememberDownloadChoice => 'Auswahl merken';

  @override
  String get headingDownloadAudioFiles => 'Audiodateien herunterladen';

  @override
  String get downloadAllAudioFilesDescription => 'Das gesamte Hörbuch herunterladen';

  @override
  String get downloadCustomAudioFilesDescription => 'Anzahl der Dateien ab der aktuellen Datei auswählen';

  @override
  String get downloadFromCurrentAudioFileDescription => 'Frühere Dateien ab der letzten Datei herunterladen';

  @override
  String get fieldAudioFileCount => 'Anzahl der Dateien';

  @override
  String get downloadAudioFileCountIncludesCurrent => 'Aktuelle Datei ist eingeschlossen';

  @override
  String get headingTaskActivity => 'Aufgabenaktivität';

  @override
  String get actionClearCompleted => 'Abgeschlossene Aktivitäten löschen';

  @override
  String taskRunningCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Aufgaben laufen',
      one: '1 Aufgabe läuft',
      zero: 'Derzeit laufen keine Aufgaben',
    );
    return '$_temp0';
  }

  @override
  String get statusNoTasksYet => 'Noch keine Aufgaben';

  @override
  String get taskEmbeddingMetadata => 'Metadaten werden eingebettet';

  @override
  String get taskEncodingM4b => 'M4B wird kodiert';

  @override
  String get taskScanningLibrary => 'Bibliothek wird gescannt';

  @override
  String get taskMatchingLibraryItems => 'Bibliothekseinträge werden abgeglichen';

  @override
  String get taskScanningItem => 'Eintrag wird gescannt';

  @override
  String get taskGeneric => 'Aufgabe';

  @override
  String taskScanAddedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString hinzugefügt';
  }

  @override
  String taskScanUpdatedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString aktualisiert';
  }

  @override
  String taskScanMissingCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString fehlen';
  }

  @override
  String taskScanElapsed(String duration) {
    return 'Vergangen: $duration';
  }

  @override
  String downloadRemainingFileCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Dateien verbleibend',
      one: '1 Datei verbleibend',
    );
    return '$_temp0';
  }

  @override
  String get errorCouldNotLoadActiveDownloads => 'Aktive Downloads konnten nicht geladen werden';

  @override
  String get statusNoActiveDownloads => 'Keine aktiven Downloads';

  @override
  String get headingDownloadsInProgress => 'Laufende Downloads';

  @override
  String get actionCancelDownload => 'Download abbrechen';

  @override
  String statusDownloadCanceledNamed(String name) {
    return '$name abgebrochen';
  }

  @override
  String errorCancelDownloadNamed(String name) {
    return '$name konnte nicht abgebrochen werden';
  }

  @override
  String get errorCancelDownload => 'Download konnte nicht abgebrochen werden';

  @override
  String statusWithProgress(String status, String progress) {
    return '$status · $progress';
  }

  @override
  String get headingDownloadError => 'Downloadfehler';

  @override
  String get statusRetrying => 'Erneuter Versuch';

  @override
  String get statusPaused => 'Pausiert';

  @override
  String get statusNotFound => 'Nicht gefunden';

  @override
  String get navStats => 'Statistiken';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get navIssues => 'Probleme';

  @override
  String get headingLeaveUploadPage => 'Uploadseite verlassen?';

  @override
  String get promptLeaveUploadPageDuringUpload =>
      'Wenn du diese Seite jetzt verlässt, werden aktive Uploads abgebrochen. Fortfahren?';

  @override
  String get actionStayHere => 'Hier bleiben';

  @override
  String get actionLeavePage => 'Seite verlassen';

  @override
  String get errorUnableToOpenMediaCenter =>
      'Das Mediencenter konnte nicht geöffnet werden. Öffne stattdessen die Auto-Bibliothek in den Einstellungen';

  @override
  String get settingsCategoryRegional => 'Regionale Einstellungen';

  @override
  String get settingsCategoryScanner => 'Scanner';

  @override
  String get settingsCategorySecurity => 'Sicherheit';

  @override
  String get settingStoreCoversWithItem => 'Cover mit dem Eintrag speichern';

  @override
  String get settingStoreCoversWithItemDescription =>
      'Coverbilder im Ordner des jeweiligen Bibliothekseintrags speichern. Es bleibt nur eine Coverdatei erhalten';

  @override
  String get settingStoreMetadataWithItem => 'Metadaten mit dem Eintrag speichern';

  @override
  String get settingStoreMetadataWithItemDescription =>
      'Metadatendateien im Ordner des jeweiligen Bibliothekseintrags speichern';

  @override
  String get settingIgnorePrefixesWhenSorting => 'Präfixe beim Sortieren ignorieren';

  @override
  String get settingIgnorePrefixesWhenSortingDescription =>
      'Eingerichtete Präfixe wie „der“ beim Sortieren von Eintragstiteln ignorieren';

  @override
  String get fieldPrefixesToIgnore => 'Zu ignorierende Präfixe (Groß- und Kleinschreibung wird ignoriert)';

  @override
  String get errorSortingPrefixRequired => 'Mindestens ein Sortierpräfix ist erforderlich';

  @override
  String get fieldDateFormat => 'Datumsformat';

  @override
  String get fieldTimeFormat => 'Zeitformat';

  @override
  String get optionTimeFormat12Hour => '12-Stunden-Format (AM/PM)';

  @override
  String get optionTimeFormat24Hour => '24-Stunden-Format';

  @override
  String serverLanguageName(String languageCode) {
    String _temp0 = intl.Intl.selectLogic(languageCode, {
      'ar': 'Arabisch',
      'be': 'Belarussisch',
      'bg': 'Bulgarisch',
      'bn': 'Bengalisch',
      'ca': 'Katalanisch',
      'cs': 'Tschechisch',
      'da': 'Dänisch',
      'de': 'Deutsch',
      'en_us': 'Englisch',
      'es': 'Spanisch',
      'et': 'Estnisch',
      'fi': 'Finnisch',
      'fr': 'Französisch',
      'he': 'Hebräisch',
      'hr': 'Kroatisch',
      'it': 'Italienisch',
      'ja': 'Japanisch',
      'lt': 'Litauisch',
      'hu': 'Ungarisch',
      'ko': 'Koreanisch',
      'nl': 'Niederländisch',
      'no': 'Norwegisch',
      'pl': 'Polnisch',
      'pt_br': 'Portugiesisch (Brasilien)',
      'ru': 'Russisch',
      'sk': 'Slowakisch',
      'sl': 'Slowenisch',
      'sv': 'Schwedisch',
      'tr': 'Türkisch',
      'uk': 'Ukrainisch',
      'vi_vn': 'Vietnamesisch',
      'zh_cn': 'Chinesisch (vereinfacht)',
      'zh_tw': 'Chinesisch (traditionell)',
      'other': '$languageCode',
    });
    return '$_temp0';
  }

  @override
  String get settingParseSubtitles => 'Untertitel analysieren';

  @override
  String get settingParseSubtitlesDescription =>
      'Untertiteltext aus Ordnernamen auslesen, die durch „ - “ getrennt sind';

  @override
  String get settingFindCovers => 'Cover suchen';

  @override
  String get settingFindCoversDescription => 'Online nach fehlenden Covern suchen. Dadurch kann der Scan länger dauern';

  @override
  String get settingPreferMatchedMetadata => 'Abgeglichene Metadaten bevorzugen';

  @override
  String get settingPreferMatchedMetadataDescription =>
      'Beim Schnellabgleich abgeglichene Metadaten verwenden, um vorhandene Details zu ersetzen';

  @override
  String get settingScanLibrariesAutomatically => 'Bibliotheken automatisch auf Änderungen prüfen';

  @override
  String get settingScanLibrariesAutomaticallyDescription =>
      'Einträge nach Dateiänderungen hinzufügen oder aktualisieren. Erfordert einen Serverneustart';

  @override
  String get fieldAllowedCorsOrigins => 'Zulässige CORS-Ursprünge';

  @override
  String get errorOriginRequired => 'Der Ursprung darf nicht leer sein';

  @override
  String get errorOriginSchemeAndHostRequired => 'Der Ursprung muss ein Schema und einen Host enthalten';

  @override
  String get errorOriginHttpHttpsOnly => 'Es werden nur HTTP- und HTTPS-Ursprünge unterstützt';

  @override
  String get errorOriginNoPathQueryFragmentOrCredentials =>
      'Der Ursprung darf keinen Pfad, keine Abfrage, kein Fragment und keine Anmeldedaten enthalten';

  @override
  String get fieldFile => 'Datei';

  @override
  String get fieldCreated => 'Erstellt';

  @override
  String get actionRestore => 'Wiederherstellen';

  @override
  String get headingBackupConfiguration => 'Backup-Konfiguration';

  @override
  String get messageBackupConfiguration => 'Speicherpfad, Zeitplan und Aufbewahrungsdauer';

  @override
  String get statusBackupLocationUnavailable => 'Backupspeicherort nicht verfügbar';

  @override
  String get statusBackupLocationEnvironmentManaged => 'Der Backupspeicherort wird von der Serverumgebung verwaltet';

  @override
  String get fieldBackupLocationPath => 'Pfad zum Backupspeicherort';

  @override
  String get settingAutomaticBackupsEnabled => 'Automatische Backups aktivieren';

  @override
  String get fieldCronExpression => 'Cron-Ausdruck';

  @override
  String get fieldBackupsToKeep => 'Aufzubewahrende Backups';

  @override
  String fieldMaximumBackupSize(String unit) {
    return 'Maximale Backupgröße ($unit)';
  }

  @override
  String get messageZeroBackupSizeUnlimited => '0 für unbegrenzte Größe verwenden';

  @override
  String get errorBackupPathRequired => 'Gib einen Backup-Pfad ein';

  @override
  String get errorCronRequired => 'Gib einen Cron-Ausdruck ein, wenn automatische Backups aktiviert sind';

  @override
  String get errorCronFieldCount => 'Gib einen Cron-Ausdruck mit fünf Feldern ein';

  @override
  String get errorBackupsToKeepRequired => 'Gib die Anzahl der aufzubewahrenden Backups ein';

  @override
  String get errorMaximumBackupSizeRequired => 'Gib eine maximale Backupgröße ein';

  @override
  String errorWholeNumberMinimum(int minimum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);

    return 'Gib eine ganze Zahl von mindestens $minimumString ein';
  }

  @override
  String get errorLoadBackups => 'Backups konnten nicht geladen werden';

  @override
  String get statusBackupLocationUpdated => 'Backupspeicherort aktualisiert';

  @override
  String get errorUpdateBackupLocation => 'Backupspeicherort konnte nicht aktualisiert werden';

  @override
  String get statusBackupSettingsUpdated => 'Backupeinstellungen aktualisiert';

  @override
  String get errorUpdateBackupSettings => 'Backupeinstellungen konnten nicht aktualisiert werden';

  @override
  String get statusBackupCreated => 'Backup erfolgreich erstellt';

  @override
  String get errorCreateBackup => 'Backup konnte nicht erstellt werden';

  @override
  String get actionSelectBackupArchive => 'Backuparchiv auswählen';

  @override
  String get errorBackupFileUnavailable => 'Die ausgewählte Backupdatei ist auf diesem Gerät nicht verfügbar';

  @override
  String get statusBackupUploaded => 'Backup erfolgreich hochgeladen';

  @override
  String get errorUploadBackup => 'Backup konnte nicht hochgeladen werden';

  @override
  String get errorOpenBackupDownload => 'Backup-Download konnte nicht geöffnet werden';

  @override
  String get errorLegacyBackupUnsupported => 'Dieses Backup verwendet ein nicht unterstütztes älteres Serverformat';

  @override
  String get headingRestoreBackup => 'Backup wiederherstellen?';

  @override
  String promptRestoreBackup(String date) {
    return 'Backup vom $date wiederherstellen? Dadurch werden die aktuelle Serverdatenbank und der Metadatencache ersetzt';
  }

  @override
  String get statusBackupRestoreStarted =>
      'Wiederherstellung des Backups gestartet. Lade die App neu, nachdem der Server den Vorgang abgeschlossen hat';

  @override
  String get errorRestoreBackup => 'Backup konnte nicht wiederhergestellt werden';

  @override
  String get headingDeleteBackup => 'Backup löschen?';

  @override
  String promptDeleteBackup(String date) {
    return 'Backup vom $date löschen? Dies kann nicht rückgängig gemacht werden';
  }

  @override
  String get statusBackupDeleted => 'Backup gelöscht';

  @override
  String get errorDeleteBackup => 'Backup konnte nicht gelöscht werden';

  @override
  String get actionUploadBackup => 'Backup hochladen';

  @override
  String get actionCreateBackup => 'Backup erstellen';

  @override
  String get statusNoBackupsFound => 'Keine Backups gefunden';

  @override
  String get messageBackupProtection =>
      'Erstelle ein Backup oder lade eines hoch, um deine Audiobookshelf-Metadaten und -Datenbank zu schützen';

  @override
  String get promptSignInForAdminAccess => 'Melde dich mit einem Administratorkonto an, um fortzufahren';

  @override
  String get fieldOwner => 'Eigentümer';

  @override
  String get fieldStatus => 'Status';

  @override
  String get fieldExpires => 'Läuft ab';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusInactive => 'Inaktiv';

  @override
  String get statusExpired => 'Abgelaufen';

  @override
  String get statusNeverExpires => 'Läuft nie ab';

  @override
  String get statusNoApiKeysFound => 'Keine API-Schlüssel gefunden';

  @override
  String get messageApiKeyPurpose => 'Erstelle einen API-Schlüssel für Serverintegrationen und Automatisierungsclients';

  @override
  String get errorNameRequired => 'Gib einen Namen ein';

  @override
  String get errorOwnerRequired => 'Wähle einen Eigentümer aus';

  @override
  String get errorExpirationDaysRequired => 'Gib die Gültigkeitsdauer in Tagen ein oder deaktiviere den Ablauf';

  @override
  String get headingCreateApiKey => 'API-Schlüssel erstellen';

  @override
  String get hintExampleApiKeyName => 'Beispiel: Home-Assistant-Integration';

  @override
  String get hintSelectApiKeyOwner => 'Eigentümer des Schlüssels auswählen';

  @override
  String get settingApiKeyActive => 'API-Schlüssel ist aktiv';

  @override
  String get settingApiKeyActiveDescription => 'Inaktive Schlüssel können API-Anfragen nicht authentifizieren';

  @override
  String get settingApiKeyNeverExpiresDescription => 'Deaktiviere die Option, um einen Ablauf in Tagen festzulegen';

  @override
  String get fieldExpirationDays => 'Läuft in Tagen ab';

  @override
  String get hintExampleExpirationDays => 'Beispiel: 30';

  @override
  String get headingEditApiKey => 'API-Schlüssel bearbeiten';

  @override
  String apiKeyCurrentOwner(String owner) {
    return 'Aktueller Eigentümer $owner';
  }

  @override
  String apiKeyExpiresAt(String date) {
    return 'Läuft ab am $date';
  }

  @override
  String get errorLoadApiKeys => 'API-Schlüssel konnten nicht geladen werden';

  @override
  String get headingApiKeyCreated => 'API-Schlüssel erstellt';

  @override
  String get messageApiKeyShownOnce =>
      'Kopiere diesen API-Schlüssel jetzt. Aus Sicherheitsgründen wird er nur einmal angezeigt';

  @override
  String get statusApiKeyCopied => 'API-Schlüssel kopiert';

  @override
  String get errorNoEligibleApiKeyOwners =>
      'Es gibt keine berechtigten Benutzer als Eigentümer für einen API-Schlüssel';

  @override
  String get statusNoServerUsers => 'Noch keine Serverbenutzer verfügbar';

  @override
  String get statusApiKeyCreated => 'API-Schlüssel erfolgreich erstellt';

  @override
  String get errorCreateApiKey => 'API-Schlüssel konnte nicht erstellt werden';

  @override
  String get errorRootOwnedApiKeyEditRestricted =>
      'Nur Root-Benutzer können API-Schlüssel bearbeiten, die Root gehören';

  @override
  String get statusApiKeyUpdated => 'API-Schlüssel erfolgreich aktualisiert';

  @override
  String get errorUpdateApiKey => 'API-Schlüssel konnte nicht aktualisiert werden';

  @override
  String get headingDeleteApiKey => 'API-Schlüssel löschen?';

  @override
  String promptDeleteApiKey(String name) {
    return 'API-Schlüssel „$name“ löschen? Dies kann nicht rückgängig gemacht werden';
  }

  @override
  String get errorDeleteApiKey => 'API-Schlüssel konnte nicht gelöscht werden';

  @override
  String get headingDeleteSelectedApiKeys => 'Ausgewählte API-Schlüssel löschen?';

  @override
  String promptDeleteSelectedApiKeys(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählte API-Schlüssel löschen? Dies kann nicht rückgängig gemacht werden',
      one: '1 ausgewählten API-Schlüssel löschen? Dies kann nicht rückgängig gemacht werden',
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
      other: '$countString API-Schlüssel gelöscht',
      one: '1 API-Schlüssel gelöscht',
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
      other: '$countString API-Schlüssel konnten nicht gelöscht werden. Sieh in den Protokollen nach',
      one: '1 API-Schlüssel konnte nicht gelöscht werden. Sieh in den Protokollen nach',
    );
    return '$_temp0';
  }

  @override
  String get searchApiKeys => 'API-Schlüssel suchen';

  @override
  String get filterApiKeysByNameOrOwner => 'Nach Name oder Eigentümer filtern';

  @override
  String get filterApiKeysByNameOwnerOrStatus => 'Nach Name, Eigentümer oder Status filtern';

  @override
  String get actionAddApiKey => 'API-Schlüssel hinzufügen';

  @override
  String get headingUserPermissions => 'Berechtigungen';

  @override
  String get permissionDownload => 'Darf herunterladen';

  @override
  String get permissionUpdate => 'Darf aktualisieren';

  @override
  String get permissionDelete => 'Darf löschen';

  @override
  String get permissionUpload => 'Darf hochladen';

  @override
  String get permissionCreateEreaderDevices => 'Darf E-Reader-Geräte erstellen';

  @override
  String get permissionAccessExplicitContent => 'Darf auf explizite Inhalte zugreifen';

  @override
  String get fieldType => 'Typ';

  @override
  String get fieldEmail => 'E-Mail';

  @override
  String get fieldLastSeen => 'Zuletzt gesehen';

  @override
  String userRoleName(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'root': 'Root',
      'user': 'Benutzer',
      'guest': 'Gast',
      'other': '$role',
    });
    return '$_temp0';
  }

  @override
  String get statusDisabled => 'Deaktiviert';

  @override
  String get statusNoEmail => 'Keine E-Mail-Adresse';

  @override
  String adminUserCreatedDate(String date) {
    return 'Erstellt am $date';
  }

  @override
  String adminUserLastSeenDate(String date) {
    return 'Zuletzt gesehen am $date';
  }

  @override
  String get actionCreateAuthenticationCode => 'Authentifizierungscode erstellen';

  @override
  String get actionUnlinkOpenId => 'OpenID-Verknüpfung aufheben';

  @override
  String get actionEnableUser => 'Benutzer aktivieren';

  @override
  String get actionDisableUser => 'Benutzer deaktivieren';

  @override
  String get actionEnableOrDisableUser => 'Benutzer aktivieren oder deaktivieren';

  @override
  String get messageLastSeenDetails =>
      'Die Anzeige „Zuletzt gesehen“ wird aktualisiert, wenn sich ein Benutzer über WebSocket verbindet. Offline-Synchronisierungen der Höraktivität und Drittanbieter-Clients ohne WebSocket werden möglicherweise nicht erfasst';

  @override
  String get statusNoUsersMatchSearch => 'Keine Benutzer entsprechen deiner aktuellen Suche';

  @override
  String get statusNoUsersFound => 'Auf diesem Server wurden keine Benutzer gefunden';

  @override
  String get messageTryDifferentUserFilter =>
      'Versuche einen anderen Filter für Benutzername, Rolle oder E-Mail-Adresse';

  @override
  String get messageCreateUsersForAccess => 'Erstelle Benutzer, um Zugriff und Berechtigungen zu verwalten';

  @override
  String get errorEmailInvalid => 'Gib eine gültige E-Mail-Adresse ein';

  @override
  String get errorPasswordRequiredForNewUser => 'Gib beim Erstellen eines Benutzers ein Passwort ein';

  @override
  String get errorRootAccountTypeLocked => 'Der Kontotyp Root kann nicht geändert werden';

  @override
  String get fieldAccountType => 'Kontotyp';

  @override
  String userRoleReservedName(String role) {
    return '$role (reserviert)';
  }

  @override
  String get settingUserActive => 'Benutzer ist aktiv';

  @override
  String get statusRootAccountAlwaysActive => 'Das Root-Konto ist immer aktiv';

  @override
  String get settingUserActiveDescription =>
      'Deaktivierte Benutzer können sich nicht anmelden und nicht auf Inhalte zugreifen';

  @override
  String get fieldNewPassword => 'Neues Passwort';

  @override
  String get promptLeavePasswordEmptyToKeepCurrent => 'Leer lassen, um das aktuelle Passwort beizubehalten';

  @override
  String get headingEditUser => 'Benutzer bearbeiten';

  @override
  String get headingLibraryAndTagAccess => 'Zugriff auf Bibliotheken und Tags';

  @override
  String get permissionAccessAllLibraries => 'Darf auf alle Bibliotheken zugreifen';

  @override
  String get permissionAccessAllTags => 'Darf auf alle Tags zugreifen';

  @override
  String get statusNoTagsFound => 'Keine Tags verfügbar';

  @override
  String get settingInvertSelectedTags => 'Ausgewählte Tags umkehren';

  @override
  String get settingInvertSelectedTagsDescription => 'Ausgewählte Tags werden gesperrt statt erlaubt';

  @override
  String get errorUnlinkOpenId => 'OpenID-Verknüpfung konnte nicht aufgehoben werden';

  @override
  String get statusOpenIdLinkRemoved => 'OpenID-Verknüpfung entfernt';

  @override
  String get actionShare => 'Teilen';

  @override
  String get actionShareQrCode => 'QR-Code teilen';

  @override
  String get actionDeleteAuthenticationCodeKey => 'Authentifizierungscode löschen';

  @override
  String get titleCreateAuthenticationCodeKey => 'Schlüssel für Authentifizierungscode erstellen?';

  @override
  String get messageCreateAuthenticationCodeKey =>
      'yaabsa speichert einen serverspezifischen Verschlüsselungsschlüssel in der Anmeldenachricht. Der Schlüssel ist für Browser verborgen, kann aber von allen abgerufen werden, die die öffentliche Anmeldenachricht lesen können. Authentifizierungscodes mit geschützten Anmeldedaten verwenden diesen Schlüssel, damit Benutzername und Passwort bei einem abgefangenen Code nicht ohne den Schlüssel wiederhergestellt werden können. Wird der Schlüssel erneuert, werden vorhandene Codes mit geschützten Daten ungültig';

  @override
  String get errorAuthenticationCodeKeyNotPreserved =>
      'Audiobookshelf hat den Schlüssel für Authentifizierungscodes nicht beibehalten. Es wurde kein Authentifizierungscode erstellt';

  @override
  String get statusAuthenticationCodeKeyCreated => 'Schlüssel für Authentifizierungscode erstellt';

  @override
  String get errorActiveAccountNoServerAddress => 'Für das aktive Konto ist keine Serveradresse eingerichtet';

  @override
  String get titleDeleteAuthenticationCodeKey => 'Schlüssel für Authentifizierungscode löschen?';

  @override
  String get messageDeleteAuthenticationCodeKey =>
      'Authentifizierungscodes verwenden einen gemeinsamen Schlüssel für den gesamten Server. Beim Löschen werden alle Authentifizierungscodes ungültig. Bereits angemeldete Konten sind nicht betroffen';

  @override
  String get statusNoAuthenticationCodeKeyConfigured => 'Kein Schlüssel für Authentifizierungscodes eingerichtet';

  @override
  String get statusAuthenticationCodeKeyDeleted =>
      'Schlüssel für Authentifizierungscode gelöscht. Vorhandene Authentifizierungscodes sind nicht mehr gültig';

  @override
  String errorUnlinkOpenIdUser(String username) {
    return 'OpenID-Verknüpfung für $username konnte nicht aufgehoben werden';
  }

  @override
  String get statusUserCreated => 'Benutzer erfolgreich erstellt';

  @override
  String get statusUserUpdated => 'Benutzer erfolgreich aktualisiert';

  @override
  String get statusUserEnabled => 'Benutzer aktiviert';

  @override
  String get statusUserDisabled => 'Benutzer deaktiviert';

  @override
  String get errorCannotDeleteCurrentUser => 'Du kannst den aktuell angemeldeten Benutzer nicht löschen';

  @override
  String get titleDeleteUser => 'Benutzer löschen';

  @override
  String promptDeleteUser(String username) {
    return 'Benutzer „$username“ löschen? Dies kann nicht rückgängig gemacht werden';
  }

  @override
  String errorDeleteUserFailed(String username) {
    return 'Benutzer $username konnte nicht gelöscht werden';
  }

  @override
  String get statusUserDeleted => 'Benutzer erfolgreich gelöscht';

  @override
  String get labelSearchUsers => 'Benutzer suchen';

  @override
  String get hintFilterUsers => 'Nach Benutzername, Rolle oder E-Mail-Adresse filtern';

  @override
  String get operationLoadUsers => 'Benutzer werden geladen';

  @override
  String get operationCreateAuthenticationCode => 'Schlüssel für Authentifizierungscode wird erstellt';

  @override
  String get operationDeleteAuthenticationCode => 'Schlüssel für Authentifizierungscode wird gelöscht';

  @override
  String get operationUnlinkOpenId => 'OpenID-Verknüpfung wird aufgehoben';

  @override
  String get operationCreateUser => 'Benutzer wird erstellt';

  @override
  String get operationUpdateUser => 'Benutzer wird aktualisiert';

  @override
  String get operationUpdateUserStatus => 'Benutzerstatus wird aktualisiert';

  @override
  String get operationDeleteUser => 'Benutzer wird gelöscht';

  @override
  String get messageShareAuthenticationCode =>
      'Erstelle einen Authentifizierungscode mit den Serverdetails, die zur Anmeldung benötigt werden';

  @override
  String get serverLocationExternal => 'extern';

  @override
  String get serverLocationLocal => 'lokal';

  @override
  String serverUrlLocation(String url, String location) {
    return '$url ($location)';
  }

  @override
  String get optionIncludeSetPassword => 'Festgelegtes Passwort einbeziehen';

  @override
  String get descriptionIncludedSetPassword =>
      'Der Benutzer kann sich anmelden, ohne das Passwort einzugeben, und muss sofort ein neues Passwort wählen';

  @override
  String get optionIncludeCustomHeaders => 'Benutzerdefinierte Header einbeziehen';

  @override
  String messageSavedHeadersIncluded(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString gespeicherte Header werden einbezogen',
      one: '1 gespeicherter Header wird einbezogen',
    );
    return '$_temp0';
  }

  @override
  String get errorAcknowledgePasswordSharingRisk => 'Bestätige vor dem Fortfahren das Risiko beim Teilen des Passworts';

  @override
  String get errorAcknowledgeCustomHeadersRisk => 'Bestätige vor dem Fortfahren das Risiko benutzerdefinierter Header';

  @override
  String get errorAuthenticationCodeKeyRequired =>
      'Zum Einbeziehen geschützter Anmeldedaten ist ein Serverschlüssel erforderlich. Bitte zuerst einen Administrator, ihn zu aktivieren';

  @override
  String get operationGenerateAuthenticationCode => 'Authentifizierungscode wird erstellt';

  @override
  String get errorQrCodeSharingUnavailable => 'Das Teilen von QR-Codes ist auf dieser Plattform nicht verfügbar';

  @override
  String get shareAuthenticationCodeTitle => 'yaabsa-Authentifizierungscode';

  @override
  String get statusAuthenticationCodeCopied => 'Authentifizierungscode kopiert';

  @override
  String get messagePasswordSharingAcknowledgement =>
      'Ich verstehe, dass jeder mit diesem Code das temporäre Passwort verwenden kann, bis es geändert oder der Schlüssel für Authentifizierungscodes erneuert wird';

  @override
  String get messageCustomHeadersAcknowledgement =>
      'Ich verstehe, dass benutzerdefinierte Header Geheimnisse enthalten oder Zugriff auf den Server gewähren können';

  @override
  String get messageUseAuthenticationCode =>
      'Scanne diesen Code auf dem anderen Gerät mit yaabsa oder kopiere den unformatierten Authentifizierungscode und wähle auf dem Anmeldebildschirm „Authentifizierungscode importieren“';

  @override
  String get semanticsAuthenticationCodeQrCode => 'QR-Code für yaabsa-Authentifizierungscode';

  @override
  String get statusGenerating => 'Wird erstellt…';

  @override
  String get errorServerLogLevelUnavailable => 'Der Server hat die aktuelle Protokollierungsstufe nicht zurückgegeben';

  @override
  String get operationLoadServerLogs => 'Serverprotokolle werden geladen';

  @override
  String get operationUpdateServerLogLevel => 'Protokollierungsstufe des Servers wird aktualisiert';

  @override
  String get fieldSearchLogs => 'Protokolle durchsuchen';

  @override
  String get fieldServerLogLevel => 'Protokollierungsstufe des Servers';

  @override
  String get settingLogAutoScroll => 'Automatisch scrollen';

  @override
  String get statusNoLogsMatchSearch => 'Keine Protokolle entsprechen der aktuellen Suche';

  @override
  String logLevelName(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'trace': 'Trace',
      'debug': 'Debug',
      'info': 'Info',
      'warn': 'Warnung',
      'error': 'Fehler',
      'other': 'Unbekannt',
    });
    return '$_temp0';
  }

  @override
  String get errorPositiveWholeNumberRequired => 'Gib eine positive ganze Zahl ein';

  @override
  String get headingUploadMode => 'Uploadmodus';

  @override
  String get messageUploadPermissionRequired => 'Uploadberechtigung erforderlich';

  @override
  String get messageEnableUploadActionsFirst => 'Aktiviere zuerst Uploadaktionen';

  @override
  String get messageSelectLibraryBeforeUpload => 'Wähle eine Bibliothek aus, bevor du den Uploadmodus öffnest';

  @override
  String get settingLiveUpdates => 'Live-Aktualisierungen';

  @override
  String get settingLiveUpdatesDescription => 'Wiedergabefortschritt in der Android-Statusleiste anzeigen';

  @override
  String get fieldTargetLibraries => 'Zielbibliotheken';

  @override
  String get statusNoGenresFound => 'Keine Genres verfügbar';

  @override
  String get operationLoadMetadataUtilities => 'Metadatenwerkzeuge für Einträge werden geladen';

  @override
  String get errorDeleteCustomMetadataProviderFailed =>
      'Benutzerdefinierter Metadatenanbieter konnte nicht gelöscht werden';

  @override
  String get headingCustomMetadataProviders => 'Benutzerdefinierte Metadatenanbieter';

  @override
  String get headingAddCustomMetadataProvider => 'Benutzerdefinierten Metadatenanbieter hinzufügen';

  @override
  String get headingEditCustomMetadataProvider => 'Benutzerdefinierten Metadatenanbieter bearbeiten';

  @override
  String statusCustomMetadataProviderAdded(String name) {
    return 'Anbieter „$name“ hinzugefügt';
  }

  @override
  String statusCustomMetadataProviderUpdated(String name) {
    return 'Anbieter „$name“ aktualisiert';
  }

  @override
  String get titleDeleteCustomMetadataProvider => 'Anbieter löschen?';

  @override
  String promptDeleteCustomMetadataProvider(String name) {
    return 'Benutzerdefinierten Metadatenanbieter „$name“ löschen?';
  }

  @override
  String statusCustomMetadataProviderDeleted(String name) {
    return 'Anbieter „$name“ gelöscht';
  }

  @override
  String get statusNoCustomMetadataProviders => 'Keine benutzerdefinierten Metadatenanbieter gefunden';

  @override
  String get statusAuthHeaderConfigured => 'Authentifizierungsheader eingerichtet';

  @override
  String get fieldUrl => 'URL';

  @override
  String get fieldAuthHeaderValue => 'Wert des Authentifizierungsheaders';

  @override
  String get validationHttpUrlRequired => 'Gib eine gültige HTTP- oder HTTPS-URL ein';

  @override
  String get operationCreateCustomMetadataProvider => 'Benutzerdefinierter Metadatenanbieter wird erstellt';

  @override
  String get operationUpdateCustomMetadataProvider => 'Benutzerdefinierter Metadatenanbieter wird aktualisiert';

  @override
  String get operationDeleteCustomMetadataProvider => 'Benutzerdefinierter Metadatenanbieter wird gelöscht';

  @override
  String metadataTermRenameTitle(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Tag umbenennen',
      'genre': 'Genre umbenennen',
      'other': 'Begriff umbenennen',
    });
    return '$_temp0';
  }

  @override
  String get errorNameMustChange => 'Gib einen anderen Namen ein';

  @override
  String statusMetadataItemsUpdated(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Einträge aktualisiert',
      one: '1 Eintrag aktualisiert',
      zero: 'Keine Einträge aktualisiert',
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
      other: '$countString Einträge aktualisiert. Vorhandene Werte wurden zusammengeführt',
      one: '1 Eintrag aktualisiert. Vorhandene Werte wurden zusammengeführt',
      zero: 'Keine Einträge aktualisiert. Vorhandene Werte wurden zusammengeführt',
    );
    return '$_temp0';
  }

  @override
  String metadataTermDeleteTitle(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Tag löschen?',
      'genre': 'Genre löschen?',
      'other': 'Begriff löschen?',
    });
    return '$_temp0';
  }

  @override
  String promptRemoveMetadataTermFromItems(String term) {
    return '„$term“ aus allen Einträgen entfernen?';
  }

  @override
  String errorMetadataTermRenameFailed(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Tag konnte nicht umbenannt werden',
      'genre': 'Genre konnte nicht umbenannt werden',
      'other': 'Begriff konnte nicht umbenannt werden',
    });
    return '$_temp0';
  }

  @override
  String errorMetadataTermDeleteFailed(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Tag konnte nicht gelöscht werden',
      'genre': 'Genre konnte nicht gelöscht werden',
      'other': 'Begriff konnte nicht gelöscht werden',
    });
    return '$_temp0';
  }

  @override
  String metadataSplitTerms(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Tags aufteilen',
      'genre': 'Genres aufteilen',
      'other': 'Begriffe aufteilen',
    });
    return '$_temp0';
  }

  @override
  String messageSplitMetadataTerms(String termType) {
    String _temp0 = intl.Intl.selectLogic(termType, {
      'tag': 'Zusammengeführte Tagwerte anhand des Trennzeichens unten aufteilen und betroffene Einträge in den ausgewählten Bibliotheken aktualisieren',
      'genre': 'Zusammengeführte Genrewerte anhand des Trennzeichens unten aufteilen und betroffene Einträge in den ausgewählten Bibliotheken aktualisieren',
      'other': 'Zusammengeführte Metadatenwerte anhand des Trennzeichens unten aufteilen und betroffene Einträge in den ausgewählten Bibliotheken aktualisieren',
    });
    return '$_temp0';
  }

  @override
  String get fieldDelimiter => 'Trennzeichen';

  @override
  String messageDelimiterExample(String delimiter) {
    return 'Verwende $delimiter, um zusammengeführte Werte wie Fantasy und Science-Fiction aufzuteilen';
  }

  @override
  String get errorDelimiterRequired => 'Gib ein Trennzeichen ein';

  @override
  String get operationSplitMetadataTerms => 'Metadatenwerte werden aufgeteilt';

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

    String _temp0 = intl.Intl.selectLogic(termType, {'tag': 'Tags', 'genre': 'Genres', 'other': 'Metadatenwerte'});
    String _temp1 = intl.Intl.selectLogic(termType, {'tag': 'Tag', 'genre': 'Genre', 'other': 'Metadatenwert'});
    String _temp2 = intl.Intl.selectLogic(termType, {'tag': 'Tags', 'genre': 'Genres', 'other': 'Metadatenwerte'});
    String _temp3 = intl.Intl.pluralLogic(
      terms,
      locale: localeName,
      other: '$termsString zusammengesetzte $_temp0 aufgeteilt',
      one: '1 zusammengesetzten $_temp1 aufgeteilt',
      zero: 'Keine zusammengesetzten $_temp2 aufgeteilt',
    );
    String _temp4 = intl.Intl.pluralLogic(
      items,
      locale: localeName,
      other: '$itemsString Einträge',
      one: '1 Eintrag',
      zero: 'keine Einträge',
    );
    String _temp5 = intl.Intl.pluralLogic(
      updates,
      locale: localeName,
      other: '$updatesString Aktualisierungen',
      one: '1 Aktualisierung',
      zero: 'keine Aktualisierungen',
    );
    String _temp6 = intl.Intl.pluralLogic(
      libraries,
      locale: localeName,
      other: '$librariesString Bibliotheken',
      one: '1 Bibliothek',
      zero: 'keinen Bibliotheken',
    );
    return '$_temp3, $_temp4 bearbeitet und $_temp5 in $_temp6 angewendet';
  }

  @override
  String get statusNoneSelected => 'Nichts ausgewählt';

  @override
  String errorDropdownConfiguration(String label) {
    return 'Die Optionen für $label sind ungültig';
  }

  @override
  String errorDropdownDefaultTypeMismatch(String settingKey, String type) {
    return 'Der Standardwert für $settingKey hat den Typ $type, der nicht zu den verfügbaren Optionen passt';
  }

  @override
  String headingHomeNavigationPreferences(String mediaType) {
    String _temp0 = intl.Intl.selectLogic(mediaType, {
      'book': 'Tabs der Hörbuch-Startseite',
      'podcast': 'Tabs der Podcast-Startseite',
      'other': 'Tabs der Startseite',
    });
    return '$_temp0';
  }

  @override
  String headingPersonalizedShelfPreferences(String mediaType) {
    String _temp0 = intl.Intl.selectLogic(mediaType, {
      'book': 'Bereiche der Hörbuch-Startseite',
      'podcast': 'Bereiche der Podcast-Startseite',
      'other': 'Bereiche der Startseite',
    });
    return '$_temp0';
  }

  @override
  String statusPreferencesReset(String section) {
    return '$section auf Standardwerte zurückgesetzt';
  }

  @override
  String get errorKeepOneHomeViewEnabled => 'Mindestens eine Startseitenansicht muss aktiviert bleiben';

  @override
  String get statusDefaultView => 'Standardansicht';

  @override
  String get actionSetAsDefaultView => 'Als Standardansicht festlegen';

  @override
  String get hintEnableViewToSetDefault => 'Aktiviere diese Ansicht, um sie als Standard festzulegen';

  @override
  String get operationSaveSettings => 'Einstellungen werden gespeichert';

  @override
  String themeModeName(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'light': 'Hell',
      'dark': 'Dunkel',
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
      'custom': 'Benutzerdefiniert',
      'other': 'Benutzerdefiniert',
    });
    return '$_temp0';
  }

  @override
  String themePresetDescription(String preset) {
    String _temp0 = intl.Intl.selectLogic(preset, {
      'yaabsa': 'Ausgewogene türkise Akzente mit sanften Kontrasten',
      'ember': 'Warme orangefarbene Akzente und helle Oberflächen',
      'moss': 'Natürliche Grüntöne mit ruhiger Wirkung',
      'cobalt': 'Kühle blaue Akzente mit klaren Kontrasten',
      'rose': 'Sanfte rosafarbene Akzente',
      'custom': 'Erstelle ein Farbprofil mit deiner bevorzugten Akzentfarbe',
      'other': 'Wähle ein Farbprofil aus',
    });
    return '$_temp0';
  }

  @override
  String get headingThemeMode => 'Designmodus';

  @override
  String get headingThemePresets => 'Designvorlagen';

  @override
  String get headingCustomTheme => 'Benutzerdefiniertes Design';

  @override
  String themeAccentColorValue(String hex) {
    return 'Akzentfarbe $hex';
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
  String get colorChannelRed => 'Rot';

  @override
  String get colorChannelGreen => 'Grün';

  @override
  String get colorChannelBlue => 'Blau';

  @override
  String get headingQuickColors => 'Schnellfarben';

  @override
  String get statusNoCustomHeadersConfigured => 'Keine benutzerdefinierten Header eingerichtet';

  @override
  String get messageCustomHeadersSentWithRequests =>
      'Diese Header werden mit Anfragen an diesen Server gesendet. Headerwerte können Geheimnisse enthalten. Teile sie daher nur mit vertrauenswürdigen Personen';

  @override
  String get actionAddCustomHeader => 'Benutzerdefinierten Header hinzufügen';

  @override
  String get titleAddCustomHeader => 'Header hinzufügen';

  @override
  String get titleEditCustomHeader => 'Header bearbeiten';

  @override
  String get headingSmtpSettings => 'SMTP-Einstellungen';

  @override
  String get messageConfigureSmtpEmailDelivery =>
      'E-Mail-Versand des Servers einrichten und eine Testnachricht senden, um die Verbindung zu überprüfen';

  @override
  String get fieldHost => 'Host';

  @override
  String get fieldPort => 'Port';

  @override
  String get fieldFromAddress => 'Absenderadresse';

  @override
  String get fieldTestAddress => 'Testadresse';

  @override
  String get settingSecureSmtpConnection => 'Sichere SMTP-Verbindung verwenden';

  @override
  String get settingRejectUnauthorizedCertificates => 'Nicht autorisierte Zertifikate ablehnen';

  @override
  String get settingRejectUnauthorizedCertificatesDescription =>
      'Nur deaktivieren, wenn der SMTP-Server ein selbstsigniertes Zertifikat verwendet';

  @override
  String get actionSendTestEmail => 'Test senden';

  @override
  String emailDeviceAvailabilityName(String availability) {
    String _temp0 = intl.Intl.selectLogic(availability, {
      'adminOrUp': 'Admin oder höher',
      'userOrUp': 'Benutzer oder höher',
      'guestOrUp': 'Gast oder höher',
      'specificUsers': 'Bestimmte Benutzer',
      'other': 'Admin oder höher',
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
  String get fieldDeviceName => 'Gerätename';

  @override
  String get exampleEreaderDeviceName => 'Kindle';

  @override
  String get fieldDeviceEmail => 'E-Mail-Adresse des Geräts';

  @override
  String get exampleEreaderDeviceEmail => 'kindle@kindle.com';

  @override
  String get fieldAccessibleBy => 'Zugriffsberechtigt';

  @override
  String get fieldAllowedUsers => 'Zulässige Benutzer';

  @override
  String get statusNoUsersAvailable => 'Keine Benutzer verfügbar';

  @override
  String get errorDeviceNameRequired => 'Gib einen Gerätenamen ein';

  @override
  String get errorDeviceNameAlreadyExists => 'Ein Gerät mit diesem Namen ist bereits vorhanden';

  @override
  String get errorDeviceEmailRequired => 'Gib eine E-Mail-Adresse für das Gerät ein';

  @override
  String get errorDeviceEmailInvalid => 'Gib eine gültige E-Mail-Adresse für das Gerät ein';

  @override
  String get errorSelectAtLeastOneUserForSpecificAccess =>
      'Wähle mindestens einen Benutzer für den eingeschränkten Zugriff aus';

  @override
  String get headingEditEreaderDevice => 'E-Reader-Gerät bearbeiten';

  @override
  String get headingAddEreaderDevice => 'E-Reader-Gerät hinzufügen';

  @override
  String get statusNoEreaderDevicesFound => 'Keine E-Reader-Geräte gefunden';

  @override
  String get messageAddEreaderDeviceDestination =>
      'Füge ein Ziel hinzu, um den E-Mail-Versand an das Gerät zu aktivieren';

  @override
  String get titleDeleteEreaderDevice => 'E-Reader-Gerät löschen';

  @override
  String promptDeleteEreaderDevice(String name) {
    return '$name löschen? Dadurch wird das Ziel für den E-Mail-Versand an das Gerät entfernt';
  }

  @override
  String get statusEmailSettingsSaved => 'E-Mail-Einstellungen gespeichert';

  @override
  String get statusTestEmailSent => 'Test-E-Mail gesendet';

  @override
  String get errorEmailTestSendFailed => 'Test-E-Mail konnte nicht gesendet werden';

  @override
  String get statusEreaderDeviceAdded => 'E-Reader-Gerät hinzugefügt';

  @override
  String get statusEreaderDeviceUpdated => 'E-Reader-Gerät aktualisiert';

  @override
  String get statusEreaderDeviceDeleted => 'E-Reader-Gerät gelöscht';

  @override
  String get operationLoadEmailSettings => 'Server-E-Mail-Einstellungen werden geladen';

  @override
  String get operationSaveEmailSettings => 'Server-E-Mail-Einstellungen werden gespeichert';

  @override
  String get operationSendTestEmail => 'Test-E-Mail wird gesendet';

  @override
  String get operationAddEreaderDevice => 'E-Reader-Gerät wird hinzugefügt';

  @override
  String get operationUpdateEreaderDevice => 'E-Reader-Gerät wird aktualisiert';

  @override
  String get operationDeleteEreaderDevice => 'E-Reader-Gerät wird gelöscht';

  @override
  String get errorEmailHostRequired => 'Gib einen Host ein';

  @override
  String get errorEmailPortRequired => 'Gib einen Port ein';

  @override
  String get errorEmailPortMustBeNumber => 'Gib eine gültige Portnummer ein';

  @override
  String errorEmailPortRange(int minimum, int maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Gib einen Port zwischen $minimumString und $maximumString ein';
  }

  @override
  String errorEmailFieldInvalid(String field) {
    return 'Gib für $field eine gültige E-Mail-Adresse ein';
  }

  @override
  String get headingFolders => 'Ordner';

  @override
  String get statusNoFoldersAdded => 'Noch keine Ordner hinzugefügt';

  @override
  String get statusExistingFolder => 'Vorhandener Ordner';

  @override
  String get fieldAddFolderPath => 'Ordnerpfad hinzufügen';

  @override
  String get actionAddFolder => 'Ordner hinzufügen';

  @override
  String get fieldSearchLibraries => 'Bibliotheken suchen';

  @override
  String get hintSearchLibraries => 'Nach Name, Anbieter, Medientyp oder Pfad filtern';

  @override
  String statusLibraryCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Bibliotheken',
      one: '1 Bibliothek',
      zero: 'Keine Bibliotheken',
    );
    return '$_temp0';
  }

  @override
  String statusLibraryFilteredCount(int filtered, int total) {
    final intl.NumberFormat filteredNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String filteredString = filteredNumberFormat.format(filtered);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$totalString Bibliotheken',
      one: '1 Bibliothek',
    );
    return '$filteredString von $_temp0';
  }

  @override
  String get statusSavingLibraryOrder => 'Reihenfolge wird gespeichert…';

  @override
  String get statusLibraryCreated => 'Bibliothek erfolgreich erstellt';

  @override
  String get statusLibraryUpdated => 'Bibliothek erfolgreich aktualisiert';

  @override
  String get statusLibraryDeleted => 'Bibliothek gelöscht';

  @override
  String get statusLibraryOrderUpdated => 'Reihenfolge der Bibliotheken aktualisiert';

  @override
  String get statusLibraryScanStarted => 'Bibliotheksscan gestartet';

  @override
  String get statusLibraryForceRescanStarted => 'Erneuter Scan erzwungen';

  @override
  String get statusMatchAllMetadataStarted => 'Abgleich aller Metadaten gestartet';

  @override
  String get errorLoadLibrariesFailed => 'Bibliotheken konnten nicht geladen werden';

  @override
  String get errorCreateLibraryFailed => 'Bibliothek konnte nicht erstellt werden';

  @override
  String get errorUpdateLibraryFailed => 'Bibliothek konnte nicht aktualisiert werden';

  @override
  String get errorDeleteLibraryFailed => 'Bibliothek konnte nicht gelöscht werden';

  @override
  String get errorStartLibraryScanFailed => 'Bibliotheksscan konnte nicht gestartet werden';

  @override
  String get errorSaveLibraryOrderFailed => 'Reihenfolge der Bibliotheken konnte nicht gespeichert werden';

  @override
  String get errorStartMatchAllMetadataFailed => 'Abgleich aller Metadaten konnte nicht gestartet werden';

  @override
  String get headingDeleteLibrary => 'Bibliothek löschen?';

  @override
  String promptDeleteLibrary(String name) {
    return '„$name“ löschen? Dies kann nicht rückgängig gemacht werden';
  }

  @override
  String get actionScan => 'Scannen';

  @override
  String get actionForceRescan => 'Erneut scannen erzwingen';

  @override
  String get actionMatchAllBooks => 'Alle Bücher abgleichen';

  @override
  String get headingLibraryActions => 'Bibliotheksaktionen';

  @override
  String get statusNoLibrariesAvailable => 'Auf diesem Server sind keine Bibliotheken verfügbar';

  @override
  String get statusNoLibrariesMatchSearch => 'Keine Bibliotheken entsprechen deiner Suche';

  @override
  String get messageCreateLibraryToAddContent => 'Erstelle eine Bibliothek, um Bücher oder Podcasts hinzuzufügen';

  @override
  String get hintAdjustSearchQuery => 'Passe deine Suchanfrage an';

  @override
  String errorLoadAdminUserData(String error) {
    return 'Benutzerdaten konnten nicht geladen werden: $error';
  }

  @override
  String get countryUnitedStates => 'Vereinigte Staaten';

  @override
  String get countryUnitedKingdom => 'Vereinigtes Königreich';

  @override
  String get countryGermany => 'Deutschland';

  @override
  String get countryFrance => 'Frankreich';

  @override
  String get countrySpain => 'Spanien';

  @override
  String get countryItaly => 'Italien';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryAustralia => 'Australien';

  @override
  String get countryCanada => 'Kanada';

  @override
  String get metadataSourceFolderStructure => 'Ordnerstruktur';

  @override
  String get metadataSourceAudioAndEbookMetadata => 'Audio- und E-Book-Metadaten';

  @override
  String get metadataSourceNfoFile => 'NFO-Datei';

  @override
  String get metadataSourceDescriptionFiles => 'desc.txt und reader.txt';

  @override
  String get metadataSourceOpfFile => 'OPF-Datei';

  @override
  String get metadataSourceAudiobookshelfFile => 'Audiobookshelf-Metadatendatei';

  @override
  String get errorLibraryFolderPathAlreadyExists => 'Dieser Ordnerpfad wurde bereits hinzugefügt';

  @override
  String get errorNestedFolderPathsNotAllowed => 'Verschachtelte Ordnerpfade sind nicht zulässig';

  @override
  String get errorLibraryNameRequired => 'Gib einen Bibliotheksnamen ein';

  @override
  String get errorAddAtLeastOneFolderPath => 'Füge mindestens einen Ordnerpfad hinzu';

  @override
  String get errorFolderPathsCannotBeEmpty => 'Ordnerpfade dürfen nicht leer sein';

  @override
  String get errorDuplicateFolderPathsNotAllowed => 'Doppelte Ordnerpfade sind nicht zulässig';

  @override
  String get errorCronRequiredWhenLibrarySchedulingEnabled =>
      'Gib einen Cron-Ausdruck ein, wenn geplante Scans aktiviert sind';

  @override
  String errorPercentBetweenZeroAndHundred(int minimum, int maximum) {
    final intl.NumberFormat minimumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String minimumString = minimumNumberFormat.format(minimum);
    final intl.NumberFormat maximumNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String maximumString = maximumNumberFormat.format(maximum);

    return 'Gib einen Wert zwischen $minimumString und $maximumString ein';
  }

  @override
  String get titleSelectLibraryFolder => 'Bibliotheksordner auswählen';

  @override
  String statusNoLibraryMetadataFilesFound(String extension) {
    return 'Keine .$extension-Metadatendateien gefunden';
  }

  @override
  String statusNoLibraryMetadataFilesRemoved(String extension) {
    return 'Keine .$extension-Metadatendateien entfernt';
  }

  @override
  String statusLibraryMetadataFilesRemoved(int count, String extension) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString .$extension-Metadatendateien entfernt',
      one: '1 .$extension-Metadatendatei entfernt',
    );
    return '$_temp0';
  }

  @override
  String errorRemoveLibraryMetadataFilesFailed(String extension, String error) {
    return '.$extension-Metadatendateien konnten nicht entfernt werden ($error)';
  }

  @override
  String errorMatchAllMetadataFailed(String error) {
    return 'Abgleich aller Metadaten konnte nicht gestartet werden ($error)';
  }

  @override
  String get hintSelectMetadataProvider => 'Metadatenanbieter auswählen';

  @override
  String get fieldMediaType => 'Medientyp';

  @override
  String get hintMediaTypeCannotBeChanged =>
      'Der Medientyp kann nach dem Erstellen der Bibliothek nicht mehr geändert werden';

  @override
  String get hintLibraryNameExample => 'Meine Hörbücher';

  @override
  String get fieldLibraryIcon => 'Bibliothekssymbol';

  @override
  String get hintSelectLibraryIcon => 'Bibliothekssymbol auswählen';

  @override
  String get headingLibraryBehavior => 'Bibliotheksverhalten';

  @override
  String get settingUseSquareBookCovers => 'Quadratische Buchcover verwenden';

  @override
  String get settingAudiobooksOnly => 'Nur Hörbücher';

  @override
  String get settingHideSingleBookSeries => 'Serien mit nur einem Buch ausblenden';

  @override
  String get settingOnlyShowLaterBooksInContinueSeries => 'Unter „Serie fortsetzen“ nur spätere Bücher anzeigen';

  @override
  String get settingAllowScriptedEbookContent => 'Skriptinhalte in E-Books zulassen';

  @override
  String get headingMarkAsFinishedThreshold => 'Schwellenwert für „Als abgeschlossen markieren“';

  @override
  String get optionTimeRemainingSeconds => 'Verbleibende Zeit in Sekunden';

  @override
  String get optionPercentComplete => 'Abgeschlossen in Prozent';

  @override
  String get fieldMode => 'Modus';

  @override
  String get fieldPercent => 'Prozent';

  @override
  String get fieldPodcastSearchRegion => 'Podcast-Suchregion';

  @override
  String get messageScannerSettingsBookLibrariesOnly => 'Scannereinstellungen sind für Hörbuchbibliotheken verfügbar';

  @override
  String get settingEnableFolderWatcher => 'Ordnerüberwachung aktivieren';

  @override
  String get settingEnableFolderWatcherDescription =>
      'Deaktiviere diese Option, wenn der Server Dateiänderungen nicht zuverlässig überwachen kann';

  @override
  String get settingSkipMatchingBooksWithAsin => 'Bücher mit ASIN vom Abgleich ausschließen';

  @override
  String get settingSkipMatchingBooksWithIsbn => 'Bücher mit ISBN vom Abgleich ausschließen';

  @override
  String get settingEnableScheduledScans => 'Geplante Scans aktivieren';

  @override
  String settingScheduledScansDescription(String example) {
    return 'Cron-Syntax verwenden. Beispiel: $example führt jeden Montag um 00:00 Uhr einen Scan aus';
  }

  @override
  String get hintDisableSchedulingToClearCron => 'Deaktiviere die Planung, um den Cron-Ausdruck zu löschen';

  @override
  String get messageCreateLibraryBeforeUsingTools =>
      'Erstelle zuerst die Bibliothek, um auf ihre Werkzeuge zuzugreifen';

  @override
  String get headingLibraryMetadataFileCleanup => 'Metadatendateien bereinigen';

  @override
  String get messageRemoveGeneratedLibraryMetadataFiles =>
      'Erstellte Metadatendateien aus Bibliotheksordnern entfernen';

  @override
  String actionRemoveMetadataFile(String fileName) {
    return '$fileName entfernen';
  }

  @override
  String get messageRunMatchAllMetadataForLibrary => 'Serverabgleich aller Metadaten für diese Bibliothek ausführen';

  @override
  String get actionStartMatchAll => 'Abgleich aller Metadaten starten';

  @override
  String get settingsCategorySchedule => 'Zeitplan';

  @override
  String get statusOnlyActiveMetadataSource => 'Nur aktive Quelle';

  @override
  String get statusHighestMetadataPriority => 'Höchste Priorität';

  @override
  String get statusLowestMetadataPriority => 'Niedrigste Priorität';

  @override
  String statusMetadataPriority(int position, int count) {
    final intl.NumberFormat positionNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String positionString = positionNumberFormat.format(position);
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Priorität $positionString von $countString';
  }

  @override
  String get headingMetadataPrecedence => 'Metadatenrangfolge';

  @override
  String get statusNoMetadataSourcesAvailable => 'Keine Metadatenquellen verfügbar';

  @override
  String get entityItem => 'Eintrag';

  @override
  String get fieldRssFeed => 'Feed';

  @override
  String get fieldEntity => 'Entität';

  @override
  String get fieldSearchRssFeeds => 'RSS-Feeds suchen';

  @override
  String get hintSearchRssFeeds => 'Nach Titel, URL, Autor oder Entität filtern';

  @override
  String statusRssFeedCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Feeds',
      one: '1 Feed',
      zero: 'Keine Feeds',
    );
    return '$_temp0';
  }

  @override
  String statusRssFeedFilteredCount(int filtered, int total) {
    final intl.NumberFormat filteredNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String filteredString = filteredNumberFormat.format(filtered);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(total, locale: localeName, other: '$totalString Feeds', one: '1 Feed');
    return '$filteredString von $_temp0';
  }

  @override
  String statusRssFeedEntitySummary(String entity, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Folgen',
      one: '1 Folge',
      zero: 'Keine Folgen',
    );
    return '$entity • $_temp0';
  }

  @override
  String get headingCloseRssFeed => 'RSS-Feed schließen?';

  @override
  String promptCloseRssFeed(String name) {
    return '„$name“ schließen?';
  }

  @override
  String get actionCloseRssFeed => 'Feed schließen';

  @override
  String get statusRssFeedClosed => 'RSS-Feed geschlossen';

  @override
  String get errorCloseRssFeedFailed => 'RSS-Feed konnte nicht geschlossen werden';

  @override
  String get errorLoadRssFeedsFailed => 'RSS-Feeds konnten nicht geladen werden';

  @override
  String get statusNoRssFeedsFound => 'Keine RSS-Feeds gefunden';

  @override
  String get statusNoRssFeedsMatchSearch => 'Keine RSS-Feeds entsprechen deiner Suche';

  @override
  String get messageRssFeedsAppearHere => 'Feeds erscheinen hier';

  @override
  String get hintAdjustRssFeedSearch =>
      'Versuche einen anderen Titel, eine andere URL, einen anderen Autor oder eine andere Entität';

  @override
  String get headingRssFeedDetails => 'RSS-Feeddetails';

  @override
  String get fieldOwnerName => 'Name des Eigentümers';

  @override
  String get fieldOwnerEmail => 'E-Mail-Adresse des Eigentümers';

  @override
  String get statusRssFeedUrlCopied => 'Feed-URL kopiert';

  @override
  String get actionCopyFeedUrl => 'Feed-URL kopieren';

  @override
  String get messageRssFeedPreventIndexing => 'Dieser Feed ist so eingestellt, dass er nicht indexiert wird';

  @override
  String labelEpisodeSeasonAndNumber(String season, String episode) {
    return 'Staffel $season, Folge $episode';
  }

  @override
  String labelEpisodeNumber(String episode) {
    return 'Folge $episode';
  }

  @override
  String get statusNoEpisodesInRssFeed => 'Keine Folgen in diesem Feed';

  @override
  String get messageRssEpisodesAppearHere => 'Verfügbare Folgen erscheinen hier';

  @override
  String get headingLanguages => 'Sprachen';

  @override
  String get headingMissingMetadata => 'Fehlende Metadaten';

  @override
  String get headingSpecialFilters => 'Spezialfilter';

  @override
  String get filterOpenFeeds => 'Offene Feeds';

  @override
  String get statusNotStarted => 'Nicht begonnen';

  @override
  String get statusNotFinished => 'Nicht abgeschlossen';

  @override
  String get filterSingleTrack => 'Einzelner Track';

  @override
  String get filterMultipleTracks => 'Mehrere Tracks';

  @override
  String get statusNoSeriesFilterOption => 'Keine Serien';

  @override
  String get statusNoFilterOptionsAvailable => 'Keine Filteroptionen verfügbar';

  @override
  String get messageNoLibraryFilterValues => 'Diese Bibliothek enthält noch keine Filterwerte';

  @override
  String statusSelectedFilterOption(String option) {
    return 'Ausgewählt: $option';
  }

  @override
  String statusFilterOptionCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Optionen', one: '1 Option');
    return '$_temp0';
  }

  @override
  String get fieldSearchOptions => 'Suchoptionen';

  @override
  String get hintSearchWithinOptions => 'Diesen Bereich durchsuchen';

  @override
  String get statusNoMatchingOptions => 'Keine passenden Optionen';

  @override
  String get actionSort => 'Sortieren';

  @override
  String get sortAscending => 'Aufsteigend';

  @override
  String get sortDescending => 'Absteigend';

  @override
  String errorDownloadFileFailed(String error) {
    return 'Datei konnte nicht heruntergeladen werden ($error)';
  }

  @override
  String promptDeleteDownloadedFile(String name) {
    return '$name aus dem Offline-Speicher entfernen?';
  }

  @override
  String get errorDeleteDownloadedFileFailed => 'Diese Datei konnte nicht gelöscht werden';

  @override
  String errorDeleteDownloadedFileDetails(String error) {
    return 'Datei konnte nicht gelöscht werden ($error)';
  }

  @override
  String errorCancelDownloadDetails(String error) {
    return 'Download konnte nicht abgebrochen werden ($error)';
  }

  @override
  String get errorLoadDownloadFilesFailed => 'Dieser Download konnte nicht geladen werden';

  @override
  String get statusDownloadNoLongerAvailable => 'Dieser Download wurde entfernt';

  @override
  String downloadedFileCountSummary(int downloaded, int total) {
    final intl.NumberFormat downloadedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String downloadedString = downloadedNumberFormat.format(downloaded);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '$totalString Dateien offline',
      one: '1 Datei offline',
    );
    return '$downloadedString von $_temp0';
  }

  @override
  String get actionDownloadMissingFiles => 'Fehlende Dateien herunterladen';

  @override
  String get actionRetryLoadingFiles => 'Dateien erneut laden';

  @override
  String get statusNotDownloaded => 'Nicht heruntergeladen';

  @override
  String get statusAvailableOffline => 'Offline verfügbar';

  @override
  String get statusOffline => 'Offline';

  @override
  String downloadOfflineFileCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Dateien offline',
      one: '1 Datei offline',
    );
    return '$_temp0';
  }

  @override
  String downloadedFilesPartialTooltip(int downloaded, int total) {
    final intl.NumberFormat downloadedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String downloadedString = downloadedNumberFormat.format(downloaded);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    String _temp0 = intl.Intl.pluralLogic(total, locale: localeName, other: '$totalString Dateien', one: '1 Datei');
    return '$downloadedString von $_temp0 offline. Dateien verwalten';
  }

  @override
  String get headingDownloadActions => 'Downloadaktionen';

  @override
  String get statusSmartDownload => 'Intelligenter Download';

  @override
  String get errorLoadOptionsFailed => 'Optionen konnten nicht geladen werden';

  @override
  String get statusCollectionsUpdated => 'Sammlungen aktualisiert';

  @override
  String get statusPlaylistsUpdated => 'Wiedergabelisten aktualisiert';

  @override
  String get errorFullListUnavailable => 'Die vollständige Liste ist nicht verfügbar';

  @override
  String get errorOnlyOwnPlaylistsCanBeEdited => 'Nur deine eigenen Wiedergabelisten können bearbeitet werden';

  @override
  String get headingDeleteEmptyPlaylists => 'Leere Wiedergabelisten löschen?';

  @override
  String promptRemovingBookMayDeleteEmptyPlaylists(String names) {
    return 'Durch das Entfernen dieses Buchs werden diese Wiedergabelisten leer. Audiobookshelf wird sie löschen:\n\n$names';
  }

  @override
  String errorLoadNamedListFailed(String lists) {
    return '$lists konnten nicht geladen werden';
  }

  @override
  String statusNoNamedListsFound(String lists) {
    return 'Keine $lists in dieser Bibliothek gefunden';
  }

  @override
  String headingManageNamedLists(String lists) {
    return '$lists verwalten';
  }

  @override
  String get statusNamedListChangedReviewUpdates =>
      'Diese Liste wurde geändert. Überprüfe die Änderungen vor dem Speichern';

  @override
  String get errorEditingListNotAllowed => 'Bearbeiten ist nicht zulässig';

  @override
  String get actionReviewUpdates => 'Änderungen überprüfen';

  @override
  String get actionRetryUnavailableLists => 'Nicht verfügbare Listen erneut laden';

  @override
  String get errorOnlyAudiobooksCanBeDeletedHere => 'Mit dieser Aktion können nur Hörbücher gelöscht werden';

  @override
  String statusAudiobookDeletedFromServerAndFileSystem(String title) {
    return '„$title“ aus Audiobookshelf und dem Dateisystem gelöscht';
  }

  @override
  String statusAudiobookDeletedFromServer(String title) {
    return '„$title“ aus Audiobookshelf gelöscht';
  }

  @override
  String get errorDeleteAudiobookFailed => 'Hörbuch konnte nicht gelöscht werden';

  @override
  String get errorNoSelectedAudiobooksCanBeDeleted =>
      'Keine der ausgewählten Hörbücher kann gelöscht werden. Wähle Hörbucheinträge aus und versuche es erneut';

  @override
  String statusSelectedAudiobooksDeletedFromServerAndFileSystem(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Hörbücher', one: '1 Hörbuch');
    return '$_temp0 aus Audiobookshelf und dem Dateisystem gelöscht';
  }

  @override
  String statusSelectedAudiobooksDeletedFromServer(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Hörbücher', one: '1 Hörbuch');
    return '$_temp0 aus Audiobookshelf gelöscht';
  }

  @override
  String get errorDeleteSelectedAudiobooksFailed => 'Ausgewählte Hörbücher konnten nicht gelöscht werden';

  @override
  String get errorProgressUpdatesAudiobooksOnly =>
      'Fortschrittsaktualisierungen sind derzeit nur für Hörbücher verfügbar';

  @override
  String get errorProgressUpdatesPodcastEpisodesOnly =>
      'Fortschrittsaktualisierungen sind derzeit nur für Podcastfolgen verfügbar';

  @override
  String statusNamedProgressMarkedFinished(String name) {
    return '„$name“ als abgeschlossen markiert';
  }

  @override
  String statusNamedProgressCleared(String name) {
    return 'Fortschritt für „$name“ zurückgesetzt';
  }

  @override
  String errorMarkNamedProgressFinishedFailed(String name) {
    return '„$name“ konnte nicht als abgeschlossen markiert werden';
  }

  @override
  String errorClearNamedProgressFailed(String name) {
    return 'Fortschritt für „$name“ konnte nicht zurückgesetzt werden';
  }

  @override
  String statusNamedProgressUpdated(String name) {
    return 'Fortschritt für „$name“ aktualisiert';
  }

  @override
  String get errorUpdateProgressFailed => 'Fortschritt konnte nicht aktualisiert werden';

  @override
  String statusSelectedItemsMarkedFinished(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählte Einträge',
      one: '1 ausgewählter Eintrag',
    );
    return '$_temp0 als abgeschlossen markiert';
  }

  @override
  String statusSelectedItemsMarkedUnfinished(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählte Einträge',
      one: '1 ausgewählter Eintrag',
    );
    return '$_temp0 als nicht abgeschlossen markiert';
  }

  @override
  String get errorMarkSelectedItemsFinishedFailed =>
      'Ausgewählte Einträge konnten nicht als abgeschlossen markiert werden';

  @override
  String get errorMarkSelectedItemsUnfinishedFailed =>
      'Ausgewählte Einträge konnten nicht als nicht abgeschlossen markiert werden';

  @override
  String errorUpdatePinnedShelfFailed(String error) {
    return '„Angeheftet“ konnte nicht aktualisiert werden ($error)';
  }

  @override
  String get errorLoadSeriesDetailsFailed => 'Seriendetails konnten nicht geladen werden';

  @override
  String get actionSelectLibrary => 'Bibliothek auswählen';

  @override
  String get statusNoLibrarySelected => 'Keine Bibliothek';

  @override
  String get headingBookInformation => 'Buchinformationen';

  @override
  String get statusLessThanOneMinuteLeft => 'Weniger als 1 Minute verbleibend';

  @override
  String labelListeningProgress(String progress) {
    return 'Hörfortschritt $progress';
  }

  @override
  String get headingBookStats => 'Buchstatistiken';

  @override
  String get statsBookLoadError => 'Buchstatistiken konnten nicht geladen werden';

  @override
  String get fieldTimesStarted => 'Anzahl der Starts';

  @override
  String get fieldFirstStarted => 'Erster Start';

  @override
  String get fieldLastStarted => 'Letzter Start';

  @override
  String get headingFinishHistory => 'Abschlussverlauf';

  @override
  String get statusNotAvailable => 'Nicht verfügbar';

  @override
  String statusCurrentProgress(String progress) {
    return 'Aktueller Fortschritt $progress';
  }

  @override
  String get fieldFilePath => 'Pfad';

  @override
  String get fieldFormat => 'Format';

  @override
  String get fieldTimeBase => 'Zeitbasis';

  @override
  String get fieldEmbeddedCover => 'Eingebettetes Cover';

  @override
  String get headingMetadataTags => 'Metadaten-Tags';

  @override
  String get headingFfprobeData => 'FFprobe-Daten';

  @override
  String get actionLoadFfprobeData => 'FFprobe-Daten laden';

  @override
  String get actionCopyFfprobeData => 'FFprobe-Daten kopieren';

  @override
  String get errorLoadFfprobeDataFailed => 'FFprobe-Daten konnten nicht geladen werden';

  @override
  String get titleSaveFile => 'Datei speichern';

  @override
  String get errorDownloadOrSaveFileFailed => 'Datei konnte nicht heruntergeladen oder gespeichert werden';

  @override
  String get headingDownloadFile => 'Datei herunterladen';

  @override
  String get statusSavingFile => 'Datei wird gespeichert…';

  @override
  String get hintChooseFileSaveLocation => 'Speicherort für die Datei auswählen';

  @override
  String statusDownloadedBytes(String received, String total) {
    return '$received von $total';
  }

  @override
  String get headingDeleteFile => 'Datei löschen?';

  @override
  String promptDeleteServerFilePermanently(String filename) {
    return '„$filename“ dauerhaft vom Server löschen? Dies kann nicht rückgängig gemacht werden';
  }

  @override
  String get statusFileSaved => 'Datei gespeichert';

  @override
  String get statusFileDeleted => 'Datei gelöscht';

  @override
  String get errorDeleteServerFileFailed => 'Serverdatei konnte nicht gelöscht werden';

  @override
  String errorCompleteFileActionFailed(String error) {
    return 'Dateiaktion konnte nicht abgeschlossen werden ($error)';
  }

  @override
  String get headingFileActions => 'Dateiaktionen';

  @override
  String get actionMoreInfo => 'Weitere Informationen';

  @override
  String get actionAddFiles => 'Dateien hinzufügen';

  @override
  String get fieldMetadataProviders => 'Metadatenanbieter';

  @override
  String get hintSearchTitle => 'Titel suchen';

  @override
  String get errorLoadMetadataProvidersFailed => 'Metadatenanbieter konnten nicht geladen werden';

  @override
  String get statusNoMetadataProvidersAvailable => 'Keine Metadatenanbieter verfügbar';

  @override
  String get headingMatchCandidates => 'Abgleichkandidaten';

  @override
  String get statusNoMatchResultsYet => 'Noch keine Ergebnisse';

  @override
  String matchResultCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Ergebnisse',
      one: '1 Ergebnis',
    );
    return '$_temp0';
  }

  @override
  String get hintRunMetadataMatchSearch => 'Starte eine Suche, um Abgleichergebnisse zu laden';

  @override
  String get actionSelectProviders => 'Anbieter auswählen';

  @override
  String get headingSearchFiltersCollapsed => 'Suchfilter eingeklappt';

  @override
  String get hintTapToEditSearchFilters => 'Tippe, um Suchfilter zu bearbeiten';

  @override
  String metadataProviderCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Anbieter', one: '1 Anbieter');
    return '$_temp0';
  }

  @override
  String matchSearchFieldSummary(String field, String value) {
    return '$field: $value';
  }

  @override
  String get headingQuickMatchBook => 'Schnellabgleich für dieses Buch';

  @override
  String get actionRunQuickMatch => 'Schnellabgleich starten';

  @override
  String errorQuickMatchFailed(String error) {
    return 'Schnellabgleich konnte nicht ausgeführt werden ($error)';
  }

  @override
  String get statusQuickMatchUpdated => 'Schnellabgleich hat diesen Eintrag aktualisiert';

  @override
  String get statusQuickMatchNoChanges => 'Schnellabgleich abgeschlossen, keine Metadaten geändert';

  @override
  String get errorManualMatchTitleRequired => 'Gib vor der Suche einen Titel ein';

  @override
  String get errorManualMatchProviderRequired => 'Wähle mindestens einen Anbieter aus';

  @override
  String get errorManualMatchResultsNotFound => 'Keine Abgleichergebnisse gefunden';

  @override
  String get errorManualMatchFieldRequired => 'Wähle mindestens ein zu übernehmendes Feld aus';

  @override
  String get errorManualMatchNoWritableFields =>
      'Aus diesem Abgleichergebnis wurden keine übernehmbaren Werte ausgewählt';

  @override
  String errorManualMatchSaveFailed(String error) {
    return 'Manueller Abgleich konnte nicht gespeichert werden ($error)';
  }

  @override
  String get statusManualMatchUpdated => 'Eintragsmetadaten durch manuellen Abgleich aktualisiert';

  @override
  String get headingManualMatchSelection => 'Auswahl';

  @override
  String get hintSelectManualMatchResult =>
      'Wähle ein Abgleichergebnis aus, um die zu übernehmenden Metadatenfelder festzulegen';

  @override
  String get headingApplyMatchedFields => 'Felder übernehmen';

  @override
  String get hintAddValue => 'Wert hinzufügen';

  @override
  String get optionYes => 'Ja';

  @override
  String get optionNo => 'Nein';

  @override
  String get fieldCoverImage => 'Coverbild';

  @override
  String get optionOverwrite => 'Überschreiben';

  @override
  String get optionAddToCurrent => 'Zu aktuellen Werten hinzufügen';

  @override
  String get statusNotSet => 'Nicht festgelegt';

  @override
  String get statusUntitled => 'Ohne Titel';

  @override
  String matchCurrentValueSummary(String value) {
    return 'Aktuell: $value';
  }

  @override
  String get fieldCurrentCover => 'Aktuelles Cover';

  @override
  String get fieldSelectedCover => 'Ausgewähltes Cover';

  @override
  String get headingQuickMatchSelectedBooks => 'Schnellabgleich für ausgewählte Bücher';

  @override
  String get actionPreview => 'Vorschau';

  @override
  String get actionStart => 'Starten';

  @override
  String get statusLoadingMetadataProviders => 'Metadatenanbieter werden geladen…';

  @override
  String get statusNoProvidersForMediaType => 'Für diesen Medientyp sind keine Metadatenanbieter verfügbar';

  @override
  String get settingOverwriteCurrentMetadata => 'Vorhandene Metadaten überschreiben';

  @override
  String get settingOverwriteCurrentMetadataDescription =>
      'Vorhandene Titel-, Autor-, Beschreibungs- und ähnliche Felder ersetzen';

  @override
  String get settingOverwriteCoverImage => 'Coverbild überschreiben';

  @override
  String get settingOverwriteCoverImageDescription =>
      'Aktuelles Coverbild ersetzen, wenn ein Abgleichergebnis eines bereitstellt';

  @override
  String get hintQuickMatchSingleProviderOnly =>
      'Der Schnellabgleich unterstützt nur einen Anbieter. Verwende „Vorschau“, um mehrere Anbieter auszuführen';

  @override
  String get headingPreviewChanges => 'Änderungen in der Vorschau';

  @override
  String quickMatchChangeSummary(int changed, int total) {
    final intl.NumberFormat changedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String changedString = changedNumberFormat.format(changed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$changedString von $totalString Feldern geändert';
  }

  @override
  String actionApplyQuickMatchChanges(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString übernehmen';
  }

  @override
  String get statusSearchingMatches => 'Abgleichergebnisse werden gesucht…';

  @override
  String statusSearchingMatchesProgress(int completed, int total) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return 'Abgleichergebnisse werden gesucht… ($completedString von $totalString abgeschlossen)';
  }

  @override
  String errorQuickMatchPreviewLoadFailed(String error) {
    return 'Vorschau konnte nicht geladen werden ($error)';
  }

  @override
  String get statusNoMatch => 'Kein Treffer';

  @override
  String get statusNoMatchResultForItem =>
      'Der ausgewählte Anbieter hat für diesen Eintrag keine Metadaten zurückgegeben';

  @override
  String errorMetadataSearchFailed(String error) {
    return 'Metadatensuche fehlgeschlagen ($error)';
  }

  @override
  String get statusNoMetadataFieldChanges => 'Für diesen Eintrag wurden keine Änderungen an Metadatenfeldern erkannt';

  @override
  String get headingBeforeValue => 'Vorher';

  @override
  String get headingAfterValue => 'Nachher';

  @override
  String get errorSelectQuickMatchItems => 'Wähle mindestens einen abgeglichenen Eintrag mit Änderungen aus';

  @override
  String statusQuickMatchItemsUpdated(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Einträge aktualisiert',
      one: '1 Eintrag aktualisiert',
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
      other: '$countString Einträge ohne Änderungen',
      one: '1 Eintrag ohne Änderungen',
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
      other: '$countString Einträge fehlgeschlagen',
      one: '1 Eintrag fehlgeschlagen',
    );
    return '$_temp0';
  }

  @override
  String get errorLoadCurrentItemMetadataFailed => 'Aktuelle Eintragsmetadaten konnten nicht geladen werden';

  @override
  String get errorItemTitleUnavailableForSearch => 'Kein Titel für die Suche verfügbar';

  @override
  String get statusNoMetadataMatchesFromProviders => 'Bei keinem Anbieter wurden Ergebnisse gefunden';

  @override
  String statusQuickMatchBatchStarted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Anfrage zur Metadatenänderung für $countString Bücher gesendet',
      one: 'Anfrage zur Metadatenänderung für 1 Buch gesendet',
    );
    return '$_temp0';
  }

  @override
  String get errorStartQuickMatchBatchFailed => 'Anfrage zur Metadatenänderung konnte nicht gestartet werden';

  @override
  String errorQuickMatchBatchFailed(String error) {
    return 'Ausgewählte Bücher konnten nicht schnell abgeglichen werden ($error)';
  }

  @override
  String get actionRemoveAuthorsWithoutBooks => 'Autoren ohne Bücher entfernen';

  @override
  String get statusCheckingAuthors => 'Autoren werden überprüft…';

  @override
  String get statusScanningAuthors => 'Autoren werden gescannt';

  @override
  String get statusPreparingToLoadAuthors => 'Laden der Autoren wird vorbereitet…';

  @override
  String get statusDeletingAuthors => 'Autoren werden gelöscht';

  @override
  String statusDeletingAuthorProgress(String name, int completed, int total) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$name wird gelöscht ($completedString von $totalString)';
  }

  @override
  String statusLoadingAuthorsPage(int page, int pageSize) {
    final intl.NumberFormat pageNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageString = pageNumberFormat.format(page);
    final intl.NumberFormat pageSizeNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String pageSizeString = pageSizeNumberFormat.format(pageSize);

    return 'Seite $pageString mit $pageSizeString Autoren wird geladen…';
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
      other: '$scannedString Autoren gescannt',
      one: '1 Autor gescannt',
    );
    String _temp1 = intl.Intl.pluralLogic(
      empty,
      locale: localeName,
      other: '$emptyString Autoren ohne Bücher',
      one: '1 Autor ohne Bücher',
      zero: 'keine Autoren ohne Bücher',
    );
    return '$_temp0 und $_temp1 gefunden';
  }

  @override
  String get headingNoAuthorsToRemove => 'Keine Autoren zum Entfernen';

  @override
  String get statusNoAuthorsWithoutBooks => 'Keine Autoren ohne Bücher gefunden';

  @override
  String headingDeleteAuthorsWithoutBooks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Autoren', one: '1 Autor');
    return '$_temp0 löschen?';
  }

  @override
  String get confirmDeleteAuthorsWithoutBooks => 'Diese Autoren haben keine Bücher und werden dauerhaft entfernt';

  @override
  String actionDeleteAuthorsCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString löschen';
  }

  @override
  String statusDeletedAuthorsWithoutBooks(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Autoren', one: '1 Autor');
    return '$_temp0 ohne Bücher gelöscht';
  }

  @override
  String errorDeleteAuthorsWithoutBooksFailed(int count, String names) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Autoren', one: '1 Autor');
    return '$_temp0 konnten nicht gelöscht werden ($names)';
  }

  @override
  String authorNamesWithMoreCount(String names, int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$names und $countString weitere';
  }

  @override
  String errorRemoveAuthorsWithoutBooksFailed(String error) {
    return 'Autoren ohne Bücher konnten nicht entfernt werden ($error)';
  }

  @override
  String progressPosition(int completed, int total) {
    final intl.NumberFormat completedNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String completedString = completedNumberFormat.format(completed);
    final intl.NumberFormat totalNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String totalString = totalNumberFormat.format(total);

    return '$completedString von $totalString';
  }

  @override
  String get actionUndo => 'Rückgängig';

  @override
  String get fieldElapsedTime => 'Vergangene Zeit';

  @override
  String hintBookLength(String duration) {
    return 'Buchlänge $duration';
  }

  @override
  String get validationEnterTimeFormat => 'Gib die Zeit im Format Stunden:Minuten:Sekunden ein';

  @override
  String validationTimeExceedsDuration(String duration) {
    return 'Die Zeit darf $duration nicht überschreiten';
  }

  @override
  String get validationPercentageRequired => 'Gib einen Prozentwert ein';

  @override
  String get validationPercentageExceedsMaximum => 'Der Prozentwert darf 100 nicht überschreiten';

  @override
  String labelStartedDate(String date) {
    return 'Gestartet am $date';
  }

  @override
  String labelFinishedDate(String date) {
    return 'Abgeschlossen am $date';
  }

  @override
  String get actionSetFinished => 'Als abgeschlossen festlegen';

  @override
  String get statusPinnedShelfAdded => 'Zum angehefteten Regal hinzugefügt';

  @override
  String get statusPinnedShelfRemoved => 'Aus dem angehefteten Regal entfernt';

  @override
  String errorUndoPinnedShelfChangeFailed(String error) {
    return 'Änderung am angehefteten Regal konnte nicht rückgängig gemacht werden ($error)';
  }

  @override
  String get actionDownloadSelectedItems => 'Ausgewählte Einträge herunterladen';

  @override
  String get actionDeleteSelectedAudiobooks => 'Ausgewählte Hörbücher löschen';

  @override
  String get statusNoSelectedAudiobooksCanBeDeleted => 'Keine ausgewählten Hörbücher können gelöscht werden';

  @override
  String statusQuickMatchBatchCompleted(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Bücher aktualisiert',
      one: '1 Buch aktualisiert',
    );
    return 'Anfrage zur Metadatenänderung abgeschlossen. $_temp0';
  }

  @override
  String get statusQuickMatchBatchCompletedWithoutUpdates =>
      'Anfrage zur Metadatenänderung ohne Aktualisierungen abgeschlossen';

  @override
  String get headingAddEpisodesToPlaylist => 'Folgen zur Wiedergabeliste hinzufügen';

  @override
  String statusItemsAddedToPlaylist(int count, String target) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString ausgewählte Einträge',
      one: '1 ausgewählter Eintrag',
    );
    return '$_temp0 zu „$target“ hinzugefügt';
  }

  @override
  String statusEpisodesAddedToPlaylist(int count, String target) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Folgen', one: '1 Folge');
    return '$_temp0 zu „$target“ hinzugefügt';
  }

  @override
  String get errorAddItemsToPlaylistFailed =>
      'Ausgewählte Einträge konnten nicht zur Wiedergabeliste hinzugefügt werden';

  @override
  String get errorAddBooksToPlaylistFailed => 'Bücher konnten nicht zur Wiedergabeliste hinzugefügt werden';

  @override
  String get errorAddEpisodesToPlaylistFailed => 'Folgen konnten nicht zur Wiedergabeliste hinzugefügt werden';

  @override
  String get errorAddBooksToCollectionFailed => 'Bücher konnten nicht zur Sammlung hinzugefügt werden';

  @override
  String get statusNoEditablePlaylistsFound => 'Keine bearbeitbaren Wiedergabelisten gefunden';

  @override
  String get errorLoadPlaylistsFailed => 'Wiedergabelisten konnten nicht geladen werden';

  @override
  String get statusNoCollectionsFound => 'Keine Sammlungen gefunden';

  @override
  String get errorLoadCollectionsFailed => 'Sammlungen konnten nicht geladen werden';

  @override
  String statusActiveFilter(String group, String value) {
    return '$group · $value';
  }

  @override
  String statusSpecialFilter(String value) {
    return 'Spezial · $value';
  }

  @override
  String get headingStorage => 'Speicher';

  @override
  String get fieldRssFeedUrl => 'RSS-Feed-URL';

  @override
  String fieldRequired(String label) {
    return '$label *';
  }

  @override
  String get hintAddGenre => 'Genre hinzufügen';

  @override
  String get settingPodcastExplicitContent => 'Explizite Inhalte';

  @override
  String get settingPodcastAutoDownloadEpisodes => 'Neue Folgen automatisch herunterladen';

  @override
  String get actionCreatePodcast => 'Podcast erstellen';

  @override
  String get validationLibraryFolderRequired => 'Wähle einen Zielordner in der Bibliothek aus';

  @override
  String get validationTitleRequired => 'Titel erforderlich';

  @override
  String get validationRssFeedUrlRequired => 'RSS-Feed-URL erforderlich';

  @override
  String get statusUntitledPodcast => 'Podcast ohne Titel';

  @override
  String get hintPodcastTitleAndMetadata => 'Podcasttitel und Metadaten';

  @override
  String get statusMissingRssFeedUrl => 'RSS-Feed-URL fehlt';

  @override
  String get actionAddPodcast => 'Podcast hinzufügen';

  @override
  String get statusAlreadyInLibrary => 'Bereits in der Bibliothek';

  @override
  String get statusNoPodcastSearchResultsYet => 'Noch keine Podcast-Suchergebnisse';

  @override
  String get hintSearchOrPasteRssFeed =>
      'Suche nach Titel oder Ersteller oder füge eine RSS-Feed-URL ein, um zu beginnen';

  @override
  String get actionClearSearch => 'Suche leeren';

  @override
  String get actionDecreaseVolume => 'Lautstärke verringern';

  @override
  String get actionIncreaseVolume => 'Lautstärke erhöhen';

  @override
  String get playbackSettings => 'Wiedergabeeinstellungen';

  @override
  String get fieldServer => 'Server';

  @override
  String get statusServerAddressUnavailable => 'Serveradresse nicht verfügbar';

  @override
  String get statusServerAvailable => 'Server verfügbar';

  @override
  String get statusServerUnavailable => 'Server nicht verfügbar';

  @override
  String accountRoleLabel(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Administrator',
      'guest': 'Gast',
      'listener': 'Hörer',
      'other': 'Hörer',
    });
    return '$_temp0';
  }

  @override
  String get headingCustomLoginMessage => 'Benutzerdefinierte Anmeldenachricht';

  @override
  String get fieldLoginMessage => 'Anmeldenachricht';

  @override
  String get settingShowCustomLoginMessage => 'Benutzerdefinierte Anmeldenachricht anzeigen';

  @override
  String get settingEnableLocalAuthentication => 'Lokale Authentifizierung aktivieren';

  @override
  String get settingEnableOpenIdAuthentication => 'OpenID-Authentifizierung aktivieren';

  @override
  String get fieldIssuerUrl => 'Aussteller-URL';

  @override
  String get fieldAuthorizationUrl => 'Autorisierungs-URL';

  @override
  String get fieldTokenUrl => 'Token-URL';

  @override
  String get fieldUserInfoUrl => 'Benutzerinfo-URL';

  @override
  String get fieldJwksUrl => 'JWKS-URL';

  @override
  String get fieldLogoutUrl => 'Abmelde-URL';

  @override
  String get fieldClientId => 'Client-ID';

  @override
  String get fieldClientSecret => 'Client-Secret';

  @override
  String get actionShowSecret => 'Geheimnis anzeigen';

  @override
  String get actionHideSecret => 'Geheimnis ausblenden';

  @override
  String get fieldSigningAlgorithm => 'Signaturalgorithmus';

  @override
  String get fieldMobileRedirectUris => 'Mobile Weiterleitungs-URIs';

  @override
  String get hintMobileRedirectUris => 'Pro Eintrag eine URI hinzufügen. * nur als einzelnen Eintrag verwenden';

  @override
  String get fieldWebRedirectSubfolder => 'Web-Weiterleitungsunterordner';

  @override
  String get fieldWebCallbackUrl => 'Web-Callback-URL';

  @override
  String get fieldMobileCallbackUrl => 'Mobiler Callback-URL';

  @override
  String get fieldOpenIdButtonText => 'Text der OpenID-Schaltfläche';

  @override
  String get fieldExistingUserMatchMethod => 'Vorhandene Benutzer abgleichen nach';

  @override
  String get optionDoNotMatchExistingUsers => 'Nicht abgleichen';

  @override
  String get optionMatchExistingUsersByEmail => 'Nach E-Mail-Adresse abgleichen';

  @override
  String get optionMatchExistingUsersByUsername => 'Nach Benutzername abgleichen';

  @override
  String get settingAutoLaunchOpenIdLogin => 'OpenID-Anmeldung automatisch starten';

  @override
  String get settingAutoLaunchOpenIdLoginDescription =>
      'Benutzer auf der Anmeldeseite automatisch zur OpenID-Anmeldung weiterleiten';

  @override
  String get settingAutoRegisterOpenIdUsers => 'OpenID-Benutzer automatisch registrieren';

  @override
  String get settingAutoRegisterOpenIdUsersDescription =>
      'Beim ersten Anmelden von OpenID-Benutzern automatisch lokale Benutzerkonten erstellen';

  @override
  String get fieldGroupClaim => 'Gruppen-Claim';

  @override
  String get fieldAdvancedPermissionClaim => 'Erweiterter Berechtigungs-Claim';

  @override
  String get actionAutoPopulateOpenIdConfiguration => 'Automatisch ausfüllen';

  @override
  String get errorAuthenticationMethodsRequired => 'Mindestens eine Authentifizierungsmethode muss aktiviert sein';

  @override
  String validationFieldRequired(String field) {
    return '$field ist erforderlich';
  }

  @override
  String validationFieldInvalid(String field) {
    return '$field ist ungültig';
  }

  @override
  String get validationWildcardMustBeOnlyRedirectUri =>
      'Bei Verwendung muss der Stern (*) die einzige Weiterleitungs-URI sein';

  @override
  String validationMobileRedirectUriInvalid(String uri) {
    return 'Die mobile Weiterleitungs-URI $uri ist ungültig';
  }

  @override
  String get validationSubfolderMustStartWithSlash => 'Der Unterordner muss mit / beginnen';

  @override
  String get validationSubfolderCannotBeOnlySlash => 'Der Unterordner darf nicht nur aus / bestehen';

  @override
  String get validationSubfolderMustNotEndWithSlash => 'Der Unterordner darf nicht mit / enden';

  @override
  String get validationSubfolderCannotContainSpaces => 'Der Unterordner darf keine Leerzeichen enthalten';

  @override
  String get headingDisableLocalAuthentication => 'Lokale Authentifizierung deaktivieren?';

  @override
  String get confirmDisableLocalAuthentication =>
      'Wenn die lokale Authentifizierung deaktiviert und OpenID falsch eingerichtet oder defekt ist, lässt sich der Zugriff nur durch eine manuelle Bearbeitung der Datenbank wiederherstellen. Es wird dringend empfohlen, ein Backup-Administratorkonto und die lokale Authentifizierung aktiviert zu lassen.';

  @override
  String get actionDisableLocalAuthentication => 'Lokale Authentifizierung deaktivieren';

  @override
  String get headingRotateAuthenticationCodeKey => 'Schlüssel für Authentifizierungscode erneuern?';

  @override
  String get confirmRotateAuthenticationCodeKey =>
      'Mit dem bisherigen Schlüssel erstellte Authentifizierungscodes funktionieren danach nicht mehr. Bereits angemeldete Konten sind nicht betroffen';

  @override
  String get actionRotateAuthenticationCodeKey => 'Schlüssel für Authentifizierungscode erneuern';

  @override
  String get errorLoadAuthenticationSettingsFailed => 'Authentifizierungseinstellungen konnten nicht geladen werden';

  @override
  String get errorRotateAuthenticationCodeKeyFailed =>
      'Schlüssel für Authentifizierungscode konnte nicht erneuert werden';

  @override
  String get errorAuthenticationCodeKeyUnavailable =>
      'Schlüssel für Authentifizierungscode ist nicht mehr verfügbar. Aktualisiere die Einstellungen und versuche es erneut';

  @override
  String get errorAuthenticationCodeKeyRotationNotPreserved =>
      'Der Server hat den neuen Schlüssel für Authentifizierungscodes nicht beibehalten';

  @override
  String get statusAuthenticationCodeKeyRotated =>
      'Schlüssel für Authentifizierungscode erneuert. Mit dem bisherigen Schlüssel erstellte Codes sind jetzt ungültig';

  @override
  String get statusAuthenticationSettingsSaved => 'Authentifizierungseinstellungen gespeichert';

  @override
  String get statusOpenIdFieldsPopulated => 'OpenID-Felder aus der Ausstellerkonfiguration übernommen';

  @override
  String get errorSaveAuthenticationSettingsFailed =>
      'Authentifizierungseinstellungen konnten nicht gespeichert werden';

  @override
  String get errorAutoPopulateOpenIdConfigurationFailed =>
      'OpenID-Konfiguration konnte nicht automatisch ausgefüllt werden';

  @override
  String get errorConfigureOpenIdBeforeDisablingLocalAuthentication =>
      'Richte OpenID ein, bevor du die lokale Authentifizierung deaktivierst';

  @override
  String get statusNoActiveUserForAuthenticationSettings =>
      'Kein aktiver Benutzer. Melde dich an, um die Authentifizierungseinstellungen zu verwalten';

  @override
  String get statusAdminRequiredForAuthenticationSettings => 'Für diese Seite ist ein Administratorkonto erforderlich';

  @override
  String get actionSaveAuthenticationSettings => 'Authentifizierungseinstellungen speichern';

  @override
  String get hintOpenIdChangesMayRequireRestart =>
      'Damit OpenID-Änderungen vollständig übernommen werden, ist möglicherweise ein Serverneustart erforderlich';

  @override
  String statusCopiedValue(String label) {
    return '$label kopiert';
  }

  @override
  String errorLoadUserAuthenticationSettingsFailed(String error) {
    return 'Benutzereinstellungen konnten nicht geladen werden ($error)';
  }

  @override
  String statusEpisodeDownloadsQueued(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Folgen zum Download vorgemerkt',
      one: 'Folge zum Download vorgemerkt',
      zero: 'Keine Folgen zum Download vorgemerkt',
    );
    return '$_temp0';
  }

  @override
  String get actionDeleteListenedDownloads => 'Gehörte Einträge jetzt löschen';

  @override
  String get statusNoListenedDownloadsToDelete => 'Keine gehörten intelligenten Downloads zum Löschen bereit';

  @override
  String statusDeletedListenedDownloads(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString gehörte intelligente Downloads gelöscht',
      one: '1 gehörter intelligenter Download gelöscht',
    );
    return '$_temp0';
  }

  @override
  String errorDeleteListenedDownloadsFailed(String error) {
    return 'Gehörte intelligente Downloads konnten nicht gelöscht werden ($error)';
  }

  @override
  String seriesBookCount(int count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Bücher in der Serie',
      one: '1 Buch in der Serie',
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
    return '$action wird geladen';
  }

  @override
  String get statusLoadingPdf => 'PDF wird geladen…';

  @override
  String statusLoadingPdfProgress(String progress) {
    return 'PDF wird geladen… $progress';
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
  String get uploadIgnoredNonBookSidecarFiles =>
      'Nicht zum Buch gehörende Begleitdateien wurden beim Gruppieren dieses Uploads ignoriert';

  @override
  String statusBooksAddedToTarget(int count, String target) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$countString Bücher', one: '1 Buch');
    return '$_temp0 zu „$target“ hinzugefügt';
  }

  @override
  String get accountLabel => 'Konto';

  @override
  String get statusNoChangesWereNecessary => 'Es waren keine Aktualisierungen erforderlich';

  @override
  String get optionPausePlayback => 'Wiedergabe pausieren';

  @override
  String get optionBoth => 'Beides';
}
