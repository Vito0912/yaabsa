import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';
import 'package:yaabsa/components/settings/libraries/library_folder_list_editor.dart';
import 'package:yaabsa/components/settings/libraries/library_metadata_precedence_editor.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_dialog.dart';
import 'package:yaabsa/components/settings/libraries/library_upsert_form_helpers.dart';
import 'package:yaabsa/util/l10n.dart';

enum LibraryUpsertSection { settings, scanner, schedule, tools }

class LibraryUpsertFormController extends ChangeNotifier {
  LibraryUpsertFormController({this.library}) {
    final sourceLibrary = library;
    final sourceSettings =
        sourceLibrary?.settings ??
        const LibrarySettings(
          coverAspectRatio: 1,
          disableWatcher: false,
          skipMatchingMediaWithAsin: false,
          skipMatchingMediaWithIsbn: false,
          autoScanCronExpression: null,
          audiobooksOnly: false,
          epubScriptedContent: false,
          hideSingleBookSeries: false,
          showLaterBooks: false,
          podcastSearchRegion: 'us',
          markAsFinishedTimeRemaining: 10,
          markAsFinishedPercentComplete: null,
          metadataPrecedence: defaultLibraryMetadataPrecedenceIds,
        );

    selectedMediaType = sourceLibrary?.mediaType ?? 'book';
    selectedProvider = (sourceLibrary?.provider ?? defaultProviderForLibraryMediaType(selectedMediaType)).trim();
    if (selectedProvider.isEmpty) {
      selectedProvider = defaultProviderForLibraryMediaType(selectedMediaType);
    }

    selectedPodcastRegion = sourceSettings.podcastSearchRegion?.trim().isNotEmpty == true
        ? sourceSettings.podcastSearchRegion!.trim()
        : 'us';

    _existingFoldersById = {for (final folder in sourceLibrary?.folders ?? const <LibraryFolder>[]) folder.id: folder};

    final markAsFinishedPercent = safeLibraryMarkAsFinishedPercent(sourceSettings);
    final markAsFinishedTime = sourceSettings.markAsFinishedTimeRemaining;
    markAsFinishedMode = markAsFinishedPercent == null ? 'timeRemaining' : 'percentComplete';

    nameController = TextEditingController(text: sourceLibrary?.name ?? '');
    selectedIconName = (sourceLibrary?.icon ?? 'database').trim();
    if (selectedIconName.isEmpty) {
      selectedIconName = 'database';
    }
    newFolderPathController = TextEditingController();
    autoScanCronController = TextEditingController(text: sourceSettings.autoScanCronExpression ?? '');
    markAsFinishedValueController = TextEditingController(
      text: formatLibraryNumericInputValue(markAsFinishedPercent ?? markAsFinishedTime ?? 10),
    );

    folders = (sourceLibrary?.folders ?? const <LibraryFolder>[])
        .map((folder) => LibraryFolderEditorEntry(id: folder.id, path: folder.fullPath.trim()))
        .where((folder) => folder.path.isNotEmpty)
        .toList(growable: true);

    metadataSources = buildLibraryMetadataSources(sourceSettings.metadataPrecedence);

    useSquareBookCovers = (sourceSettings.coverAspectRatio ?? 1) <= 1.01;
    enableWatcher = !(sourceSettings.disableWatcher ?? false);
    skipMatchingMediaWithAsin = sourceSettings.skipMatchingMediaWithAsin ?? false;
    skipMatchingMediaWithIsbn = sourceSettings.skipMatchingMediaWithIsbn ?? false;
    audiobooksOnly = sourceSettings.audiobooksOnly ?? false;
    epubScriptedContent = sourceSettings.epubScriptedContent ?? false;
    hideSingleBookSeries = sourceSettings.hideSingleBookSeries ?? false;
    showLaterBooks = sourceSettings.showLaterBooks ?? false;
    scheduleEnabled = autoScanCronController.text.trim().isNotEmpty;
  }

  final Library? library;

  bool get isCreate => library == null;

  late final TextEditingController nameController;
  late final TextEditingController newFolderPathController;
  late final TextEditingController autoScanCronController;
  late final TextEditingController markAsFinishedValueController;

  late String selectedMediaType;
  late String selectedProvider;
  late String selectedIconName;
  late String selectedPodcastRegion;
  late String markAsFinishedMode;
  late List<LibraryFolderEditorEntry> folders;
  late final Map<String, LibraryFolder> _existingFoldersById;
  late List<LibraryMetadataSourceEntry> metadataSources;

  LibraryUpsertSection selectedSection = LibraryUpsertSection.settings;

  bool useSquareBookCovers = true;
  bool enableWatcher = true;
  bool skipMatchingMediaWithAsin = false;
  bool skipMatchingMediaWithIsbn = false;
  bool audiobooksOnly = false;
  bool epubScriptedContent = false;
  bool hideSingleBookSeries = false;
  bool showLaterBooks = false;
  bool scheduleEnabled = false;
  bool isBrowsingFolders = false;

  String? nameError;
  String? foldersError;
  String? scheduleError;
  String? markAsFinishedError;

  String? get activeValidationError => nameError ?? foldersError ?? markAsFinishedError ?? scheduleError;

  List<LibraryUpsertSection> get availableSections {
    return <LibraryUpsertSection>[
      LibraryUpsertSection.settings,
      if (selectedMediaType == 'book') LibraryUpsertSection.scanner,
      LibraryUpsertSection.schedule,
      if (!isCreate) LibraryUpsertSection.tools,
    ];
  }

  LibraryUpsertSection get activeSection {
    final sections = availableSections;
    if (sections.contains(selectedSection)) {
      return selectedSection;
    }

    return LibraryUpsertSection.settings;
  }

  int get selectedSectionIndex => availableSections.indexOf(activeSection);

  void selectSection(LibraryUpsertSection section) {
    if (selectedSection == section) {
      return;
    }

    selectedSection = section;
    notifyListeners();
  }

  void setBrowsingFolders(bool value) {
    if (isBrowsingFolders == value) {
      return;
    }

    isBrowsingFolders = value;
    notifyListeners();
  }

  void onMediaTypeChanged(String? value, AppLocalizations l10n) {
    if (value == null || value == selectedMediaType) {
      return;
    }

    selectedMediaType = value;
    if (isCreate) {
      selectedProvider = defaultProviderForLibraryMediaType(value);
    }

    if (selectedMediaType != 'book' && selectedSection == LibraryUpsertSection.scanner) {
      selectedSection = LibraryUpsertSection.settings;
    }

    markAsFinishedError = validateLibraryMarkAsFinished(
      mediaType: selectedMediaType,
      markAsFinishedMode: markAsFinishedMode,
      rawValue: markAsFinishedValueController.text,
      l10n: l10n,
    );
    notifyListeners();
  }

  void onNameChanged(AppLocalizations l10n) {
    if (nameError == null) {
      return;
    }

    nameError = validateLibraryName(nameController.text, l10n);
    notifyListeners();
  }

  void onProviderChanged(String? value) {
    if (value == null || value.trim().isEmpty) {
      return;
    }

    selectedProvider = value.trim();
    notifyListeners();
  }

  void onIconChanged(String? value) {
    if (value == null || value.trim().isEmpty) {
      return;
    }

    selectedIconName = value.trim();
    notifyListeners();
  }

  void onPodcastRegionChanged(String? value) {
    if (value == null) {
      return;
    }

    selectedPodcastRegion = value;
    notifyListeners();
  }

  void addFolderPath(String path, AppLocalizations l10n) {
    final nextPath = path.trim();
    if (nextPath.isEmpty) {
      foldersError = l10n.errorFolderPathsCannotBeEmpty;
      notifyListeners();
      return;
    }

    final conflictError = validateLibraryFolderCandidate(candidatePath: nextPath, existingFolders: folders, l10n: l10n);
    if (conflictError != null) {
      foldersError = conflictError;
      notifyListeners();
      return;
    }

    folders.add(LibraryFolderEditorEntry(path: nextPath));
    newFolderPathController.clear();
    foldersError = validateLibraryFolders(folders, l10n);
    notifyListeners();
  }

  void removeFolder(LibraryFolderEditorEntry folder, AppLocalizations l10n) {
    folders.remove(folder);
    foldersError = validateLibraryFolders(folders, l10n);
    notifyListeners();
  }

  void setUseSquareBookCovers(bool value) {
    useSquareBookCovers = value;
    notifyListeners();
  }

  void setAudiobooksOnly(bool value) {
    audiobooksOnly = value;
    notifyListeners();
  }

  void setHideSingleBookSeries(bool value) {
    hideSingleBookSeries = value;
    notifyListeners();
  }

  void setShowLaterBooks(bool value) {
    showLaterBooks = value;
    notifyListeners();
  }

  void setEpubScriptedContent(bool value) {
    epubScriptedContent = value;
    notifyListeners();
  }

  void onMarkAsFinishedModeChanged(String? value, AppLocalizations l10n) {
    if (value == null) {
      return;
    }

    markAsFinishedMode = value;
    markAsFinishedError = validateLibraryMarkAsFinished(
      mediaType: selectedMediaType,
      markAsFinishedMode: markAsFinishedMode,
      rawValue: markAsFinishedValueController.text,
      l10n: l10n,
    );
    notifyListeners();
  }

  void onMarkAsFinishedValueChanged(AppLocalizations l10n) {
    if (markAsFinishedError == null) {
      return;
    }

    markAsFinishedError = validateLibraryMarkAsFinished(
      mediaType: selectedMediaType,
      markAsFinishedMode: markAsFinishedMode,
      rawValue: markAsFinishedValueController.text,
      l10n: l10n,
    );
    notifyListeners();
  }

  void setEnableWatcher(bool value) {
    enableWatcher = value;
    notifyListeners();
  }

  void setSkipMatchingMediaWithAsin(bool value) {
    skipMatchingMediaWithAsin = value;
    notifyListeners();
  }

  void setSkipMatchingMediaWithIsbn(bool value) {
    skipMatchingMediaWithIsbn = value;
    notifyListeners();
  }

  void reorderMetadataSource(int oldIndex, int newIndex) {
    final reordered = List<LibraryMetadataSourceEntry>.from(metadataSources);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    metadataSources = reordered;
    notifyListeners();
  }

  void toggleMetadataSource(LibraryMetadataSourceEntry entry) {
    metadataSources = metadataSources.map((source) => source.id == entry.id ? entry : source).toList(growable: false);
    notifyListeners();
  }

  void resetMetadataSources() {
    metadataSources = buildLibraryMetadataSources(defaultLibraryMetadataPrecedenceIds);
    notifyListeners();
  }

  void setScheduleEnabled(bool value, AppLocalizations l10n) {
    scheduleEnabled = value;
    scheduleError = validateLibrarySchedule(
      scheduleEnabled: scheduleEnabled,
      cronExpression: autoScanCronController.text,
      l10n: l10n,
    );
    notifyListeners();
  }

  void onCronChanged(AppLocalizations l10n) {
    if (scheduleError == null) {
      return;
    }

    scheduleError = validateLibrarySchedule(
      scheduleEnabled: scheduleEnabled,
      cronExpression: autoScanCronController.text,
      l10n: l10n,
    );
    notifyListeners();
  }

  LibraryUpsertFormResult? validateAndBuildResult(AppLocalizations l10n) {
    final nextNameError = validateLibraryName(nameController.text, l10n);
    final nextFoldersError = validateLibraryFolders(folders, l10n);
    final nextScheduleError = validateLibrarySchedule(
      scheduleEnabled: scheduleEnabled,
      cronExpression: autoScanCronController.text,
      l10n: l10n,
    );
    final nextMarkError = validateLibraryMarkAsFinished(
      mediaType: selectedMediaType,
      markAsFinishedMode: markAsFinishedMode,
      rawValue: markAsFinishedValueController.text,
      l10n: l10n,
    );

    if (nextNameError != null || nextFoldersError != null || nextScheduleError != null || nextMarkError != null) {
      nameError = nextNameError;
      foldersError = nextFoldersError;
      scheduleError = nextScheduleError;
      markAsFinishedError = nextMarkError;
      if (nextNameError != null || nextFoldersError != null || nextMarkError != null) {
        selectedSection = LibraryUpsertSection.settings;
      } else {
        selectedSection = LibraryUpsertSection.schedule;
      }
      notifyListeners();
      return null;
    }

    final folderPayloads = folders
        .map((folder) {
          final folderId = folder.id?.trim();
          final existingFolder = folderId == null || folderId.isEmpty ? null : _existingFoldersById[folderId];

          return LibraryFolderPayload(
            id: folderId == null || folderId.isEmpty ? null : folderId,
            fullPath: folder.path,
            libraryId: existingFolder?.libraryId,
            addedAt: existingFolder?.addedAt,
          );
        })
        .toList(growable: false);

    return LibraryUpsertFormResult(
      name: nameController.text.trim(),
      mediaType: selectedMediaType,
      provider: selectedProvider,
      icon: selectedIconName,
      folders: folderPayloads,
      settings: _buildSettings(),
    );
  }

  LibrarySettings _buildSettings() {
    final enabledMetadataSources = metadataSources
        .where((source) => source.enabled)
        .map((source) => source.id)
        .toList();
    final metadataPrecedence = enabledMetadataSources.isEmpty
        ? defaultLibraryMetadataPrecedenceIds
        : enabledMetadataSources.reversed.toList(growable: false);

    final rawMarkValue = markAsFinishedValueController.text.trim();
    final parsedTimeRemaining = int.tryParse(rawMarkValue) ?? 10;
    final parsedPercentComplete = double.tryParse(rawMarkValue) ?? 10;
    final boundedTimeRemaining = parsedTimeRemaining < 1 ? 1 : parsedTimeRemaining;
    final boundedPercentComplete = parsedPercentComplete.clamp(0, 100).toDouble();

    return LibrarySettings(
      coverAspectRatio: useSquareBookCovers ? 1 : 1.6,
      disableWatcher: !enableWatcher,
      skipMatchingMediaWithAsin: selectedMediaType == 'book' ? skipMatchingMediaWithAsin : null,
      skipMatchingMediaWithIsbn: selectedMediaType == 'book' ? skipMatchingMediaWithIsbn : null,
      autoScanCronExpression: scheduleEnabled ? autoScanCronController.text.trim() : null,
      audiobooksOnly: selectedMediaType == 'book' ? audiobooksOnly : null,
      epubScriptedContent: selectedMediaType == 'book' ? epubScriptedContent : null,
      hideSingleBookSeries: selectedMediaType == 'book' ? hideSingleBookSeries : null,
      showLaterBooks: selectedMediaType == 'book' ? showLaterBooks : null,
      podcastSearchRegion: selectedMediaType == 'podcast' ? selectedPodcastRegion : null,
      markAsFinishedTimeRemaining: selectedMediaType == 'book' && markAsFinishedMode == 'timeRemaining'
          ? boundedTimeRemaining
          : null,
      markAsFinishedPercentComplete: selectedMediaType == 'book' && markAsFinishedMode == 'percentComplete'
          ? boundedPercentComplete
          : null,
      metadataPrecedence: selectedMediaType == 'book' ? metadataPrecedence : null,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    newFolderPathController.dispose();
    autoScanCronController.dispose();
    markAsFinishedValueController.dispose();
    super.dispose();
  }
}
