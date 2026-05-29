import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/library/library_settings.dart';
import 'package:yaabsa/api/library/request/library_folder_payload.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/common/expressive_tab_view.dart';
import 'package:yaabsa/components/common/filesystem_directory_picker_dialog.dart';
import 'package:yaabsa/components/common/inputs/expressive_dropdown.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/components/settings/libraries/library_folder_list_editor.dart';
import 'package:yaabsa/components/settings/libraries/library_metadata_precedence_editor.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/provider/core/user_providers.dart';

class LibraryUpsertFormResult {
  const LibraryUpsertFormResult({
    required this.name,
    required this.mediaType,
    required this.provider,
    required this.icon,
    required this.folders,
    required this.settings,
  });

  final String name;
  final String mediaType;
  final String provider;
  final String icon;
  final List<LibraryFolderPayload> folders;
  final LibrarySettings settings;
}

Future<LibraryUpsertFormResult?> showLibraryUpsertFormDialog(BuildContext context, {Library? library}) {
  return showDialog<LibraryUpsertFormResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _LibraryUpsertFormDialog(library: library),
  );
}

class _LibraryUpsertFormDialog extends ConsumerStatefulWidget {
  const _LibraryUpsertFormDialog({this.library});

  final Library? library;

  bool get isCreate => library == null;

  @override
  ConsumerState<_LibraryUpsertFormDialog> createState() => _LibraryUpsertFormDialogState();
}

class _LibraryUpsertFormDialogState extends ConsumerState<_LibraryUpsertFormDialog> {
  static const List<YaabsaDropdownOption<String>> _mediaTypeOptions = <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'book', label: 'Books'),
    YaabsaDropdownOption<String>(value: 'podcast', label: 'Podcasts'),
  ];

  static const List<YaabsaDropdownOption<String>> _podcastRegionOptions = <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'us', label: 'United States'),
    YaabsaDropdownOption<String>(value: 'gb', label: 'United Kingdom'),
    YaabsaDropdownOption<String>(value: 'de', label: 'Germany'),
    YaabsaDropdownOption<String>(value: 'fr', label: 'France'),
    YaabsaDropdownOption<String>(value: 'es', label: 'Spain'),
    YaabsaDropdownOption<String>(value: 'it', label: 'Italy'),
    YaabsaDropdownOption<String>(value: 'jp', label: 'Japan'),
    YaabsaDropdownOption<String>(value: 'au', label: 'Australia'),
    YaabsaDropdownOption<String>(value: 'ca', label: 'Canada'),
  ];

  static const List<String> _defaultMetadataPrecedenceIds = <String>[
    'folderStructure',
    'audioMetatags',
    'nfoFile',
    'txtFiles',
    'opfFile',
    'absMetadata',
  ];

  static const Map<String, String> _metadataSourceLabels = <String, String>{
    'folderStructure': 'Folder structure',
    'audioMetatags': 'Audio and ebook metadata',
    'nfoFile': 'NFO file',
    'txtFiles': 'desc.txt and reader.txt',
    'opfFile': 'OPF file',
    'absMetadata': 'Audiobookshelf metadata file',
  };

  static const List<YaabsaDropdownOption<String>> _bookProviderFallback = <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'google', label: 'Google Books'),
    YaabsaDropdownOption<String>(value: 'openlibrary', label: 'Open Library'),
    YaabsaDropdownOption<String>(value: 'itunes', label: 'iTunes'),
    YaabsaDropdownOption<String>(value: 'audible', label: 'Audible'),
    YaabsaDropdownOption<String>(value: 'fantlab', label: 'FantLab'),
  ];

  static const List<YaabsaDropdownOption<String>> _podcastProviderFallback = <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'itunes', label: 'iTunes'),
  ];

  static const List<YaabsaDropdownOption<String>> _iconOptions = <YaabsaDropdownOption<String>>[
    YaabsaDropdownOption<String>(value: 'database', label: 'database'),
    YaabsaDropdownOption<String>(value: 'audiobookshelf', label: 'audiobookshelf'),
    YaabsaDropdownOption<String>(value: 'books-1', label: 'books-1'),
    YaabsaDropdownOption<String>(value: 'books-2', label: 'books-2'),
    YaabsaDropdownOption<String>(value: 'book-1', label: 'book-1'),
    YaabsaDropdownOption<String>(value: 'microphone-1', label: 'microphone-1'),
    YaabsaDropdownOption<String>(value: 'microphone-3', label: 'microphone-3'),
    YaabsaDropdownOption<String>(value: 'radio', label: 'radio'),
    YaabsaDropdownOption<String>(value: 'podcast', label: 'podcast'),
    YaabsaDropdownOption<String>(value: 'rss', label: 'rss'),
    YaabsaDropdownOption<String>(value: 'headphones', label: 'headphones'),
    YaabsaDropdownOption<String>(value: 'music', label: 'music'),
    YaabsaDropdownOption<String>(value: 'file-picture', label: 'file-picture'),
    YaabsaDropdownOption<String>(value: 'rocket', label: 'rocket'),
    YaabsaDropdownOption<String>(value: 'power', label: 'power'),
    YaabsaDropdownOption<String>(value: 'star', label: 'star'),
    YaabsaDropdownOption<String>(value: 'heart', label: 'heart'),
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _newFolderPathController;
  late final TextEditingController _autoScanCronController;
  late final TextEditingController _markAsFinishedValueController;

  late String _selectedMediaType;
  late String _selectedProvider;
  late String _selectedIconName;
  late String _selectedPodcastRegion;
  late String _markAsFinishedMode;
  late List<LibraryFolderEditorEntry> _folders;
  late final Map<String, LibraryFolder> _existingFoldersById;
  late List<LibraryMetadataSourceEntry> _metadataSources;

  bool _useSquareBookCovers = true;
  bool _enableWatcher = true;
  bool _skipMatchingMediaWithAsin = false;
  bool _skipMatchingMediaWithIsbn = false;
  bool _audiobooksOnly = false;
  bool _epubScriptedContent = false;
  bool _hideSingleBookSeries = false;
  bool _showLaterBooks = false;
  bool _scheduleEnabled = false;

  bool _isBrowsingFolders = false;
  bool _isRunningToolAction = false;

  String? _nameError;
  String? _foldersError;
  String? _scheduleError;
  String? _markAsFinishedError;

  @override
  void initState() {
    super.initState();

    final sourceLibrary = widget.library;
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
          metadataPrecedence: _defaultMetadataPrecedenceIds,
        );

    _selectedMediaType = sourceLibrary?.mediaType ?? 'book';
    _selectedProvider = (sourceLibrary?.provider ?? _defaultProviderForMediaType(_selectedMediaType)).trim();
    if (_selectedProvider.isEmpty) {
      _selectedProvider = _defaultProviderForMediaType(_selectedMediaType);
    }

    _selectedPodcastRegion = sourceSettings.podcastSearchRegion?.trim().isNotEmpty == true
        ? sourceSettings.podcastSearchRegion!.trim()
        : 'us';

    _existingFoldersById = {for (final folder in sourceLibrary?.folders ?? const <LibraryFolder>[]) folder.id: folder};

    final markAsFinishedPercent = _safeMarkAsFinishedPercent(sourceSettings);
    final markAsFinishedTime = sourceSettings.markAsFinishedTimeRemaining;
    _markAsFinishedMode = markAsFinishedPercent == null ? 'timeRemaining' : 'percentComplete';

    _nameController = TextEditingController(text: sourceLibrary?.name ?? '');
    _selectedIconName = (sourceLibrary?.icon ?? 'database').trim();
    if (_selectedIconName.isEmpty) {
      _selectedIconName = 'database';
    }
    _newFolderPathController = TextEditingController();
    _autoScanCronController = TextEditingController(text: sourceSettings.autoScanCronExpression ?? '');
    _markAsFinishedValueController = TextEditingController(
      text: _formatNumericInputValue(markAsFinishedPercent ?? markAsFinishedTime ?? 10),
    );

    _folders = (sourceLibrary?.folders ?? const <LibraryFolder>[])
        .map((folder) => LibraryFolderEditorEntry(id: folder.id, path: folder.fullPath.trim()))
        .where((folder) => folder.path.isNotEmpty)
        .toList(growable: true);

    _metadataSources = _buildMetadataSources(sourceSettings.metadataPrecedence);

    _useSquareBookCovers = (sourceSettings.coverAspectRatio ?? 1) <= 1.01;
    _enableWatcher = !(sourceSettings.disableWatcher ?? false);
    _skipMatchingMediaWithAsin = sourceSettings.skipMatchingMediaWithAsin ?? false;
    _skipMatchingMediaWithIsbn = sourceSettings.skipMatchingMediaWithIsbn ?? false;
    _audiobooksOnly = sourceSettings.audiobooksOnly ?? false;
    _epubScriptedContent = sourceSettings.epubScriptedContent ?? false;
    _hideSingleBookSeries = sourceSettings.hideSingleBookSeries ?? false;
    _showLaterBooks = sourceSettings.showLaterBooks ?? false;
    _scheduleEnabled = _autoScanCronController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _newFolderPathController.dispose();
    _autoScanCronController.dispose();
    _markAsFinishedValueController.dispose();
    super.dispose();
  }

  String _defaultProviderForMediaType(String mediaType) {
    return mediaType == 'podcast' ? 'itunes' : 'google';
  }

  double? _safeMarkAsFinishedPercent(LibrarySettings settings) {
    try {
      return settings.markAsFinishedPercentComplete;
    } on TypeError {
      // Existing in-memory objects can still hold an int after hot-reload.
      return null;
    }
  }

  String _formatNumericInputValue(num value) {
    final asDouble = value.toDouble();
    if (asDouble == asDouble.truncateToDouble()) {
      return asDouble.toStringAsFixed(0);
    }

    return asDouble.toString();
  }

  List<LibraryMetadataSourceEntry> _buildMetadataSources(List<String>? precedence) {
    final normalizedPrecedence = (precedence ?? _defaultMetadataPrecedenceIds)
        .where((id) => _metadataSourceLabels.containsKey(id))
        .toList(growable: false);

    final displayPrecedence = normalizedPrecedence.reversed.toList(growable: false);

    final entries = <LibraryMetadataSourceEntry>[];
    final includedIds = <String>{};

    for (final sourceId in displayPrecedence) {
      final label = _metadataSourceLabels[sourceId];
      if (label == null) {
        continue;
      }
      includedIds.add(sourceId);
      entries.add(LibraryMetadataSourceEntry(id: sourceId, label: label, enabled: true));
    }

    for (final sourceId in _defaultMetadataPrecedenceIds) {
      if (includedIds.contains(sourceId)) {
        continue;
      }

      final label = _metadataSourceLabels[sourceId];
      if (label == null) {
        continue;
      }

      entries.add(LibraryMetadataSourceEntry(id: sourceId, label: label, enabled: false));
    }

    return entries;
  }

  String _normalizePathForComparison(String rawPath) {
    var normalized = rawPath.trim().replaceAll('\\', '/').replaceAll(RegExp(r'/+'), '/');
    final isWindowsRoot = RegExp(r'^[a-zA-Z]:/$').hasMatch(normalized);
    if (normalized.length > 1 && normalized.endsWith('/') && !isWindowsRoot) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized.toLowerCase();
  }

  bool _isNestedPathPair(String firstPath, String secondPath) {
    return firstPath.startsWith('$secondPath/') || secondPath.startsWith('$firstPath/');
  }

  String? _folderConflictError(String candidatePath) {
    final normalizedCandidate = _normalizePathForComparison(candidatePath);

    for (final folder in _folders) {
      final normalizedExisting = _normalizePathForComparison(folder.path);
      if (normalizedCandidate == normalizedExisting) {
        return 'Folder path already exists.';
      }

      if (_isNestedPathPair(normalizedCandidate, normalizedExisting)) {
        return 'Nested folder paths are not allowed.';
      }
    }

    return null;
  }

  String? _validateName(String rawValue) {
    final name = rawValue.trim();
    if (name.isEmpty) {
      return 'Library name is required.';
    }

    return null;
  }

  String? _validateFolders(List<LibraryFolderEditorEntry> folders) {
    if (folders.isEmpty) {
      return 'Add at least one folder path.';
    }

    final normalizedByPath = <String, String>{};

    for (final folder in folders) {
      final trimmedPath = folder.path.trim();
      if (trimmedPath.isEmpty) {
        return 'Folder paths cannot be empty.';
      }

      final normalized = _normalizePathForComparison(trimmedPath);
      if (normalizedByPath.containsKey(normalized)) {
        return 'Duplicate folder paths are not allowed.';
      }

      normalizedByPath[normalized] = trimmedPath;
    }

    final normalizedEntries = normalizedByPath.entries.toList(growable: false);
    for (var index = 0; index < normalizedEntries.length; index++) {
      for (var nestedIndex = index + 1; nestedIndex < normalizedEntries.length; nestedIndex++) {
        if (_isNestedPathPair(normalizedEntries[index].key, normalizedEntries[nestedIndex].key)) {
          return 'Nested folder paths are not allowed.';
        }
      }
    }

    return null;
  }

  String? _validateSchedule() {
    if (!_scheduleEnabled) {
      return null;
    }

    if (_autoScanCronController.text.trim().isEmpty) {
      return 'Cron expression is required when scheduling is enabled.';
    }

    return null;
  }

  String? _validateMarkAsFinished() {
    if (_selectedMediaType != 'book') {
      return null;
    }

    final rawValue = _markAsFinishedValueController.text.trim();
    if (_markAsFinishedMode == 'percentComplete') {
      final percentValue = double.tryParse(rawValue);
      if (percentValue == null || percentValue < 0 || percentValue > 100) {
        return 'Enter a value between 0 and 100.';
      }
      return null;
    }

    final value = int.tryParse(rawValue);
    if (value == null || value <= 0) {
      return 'Enter a positive number.';
    }

    return null;
  }

  List<YaabsaDropdownOption<String>> _providerOptions(List<SearchProviderOption> rawOptions) {
    final options = rawOptions
        .where((option) => option.value.trim().isNotEmpty)
        .map(
          (option) => YaabsaDropdownOption<String>(
            value: option.value.trim(),
            label: option.text.trim().isEmpty ? option.value.trim() : option.text.trim(),
          ),
        )
        .toList(growable: false);

    final deduplicated = <String, YaabsaDropdownOption<String>>{for (final option in options) option.value: option};

    final fallback = _selectedMediaType == 'podcast' ? _podcastProviderFallback : _bookProviderFallback;
    for (final option in fallback) {
      deduplicated.putIfAbsent(option.value, () => option);
    }

    if (!deduplicated.containsKey(_selectedProvider)) {
      deduplicated[_selectedProvider] = YaabsaDropdownOption<String>(
        value: _selectedProvider,
        label: _selectedProvider,
      );
    }

    return deduplicated.values.toList(growable: false);
  }

  List<YaabsaDropdownOption<String>> _resolvedIconOptions() {
    final options = <String, YaabsaDropdownOption<String>>{for (final option in _iconOptions) option.value: option};

    if (!options.containsKey(_selectedIconName)) {
      options[_selectedIconName] = YaabsaDropdownOption<String>(value: _selectedIconName, label: _selectedIconName);
    }

    return options.values.toList(growable: false);
  }

  void _showMessage(String message) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  void _onMediaTypeChanged(String? value) {
    if (value == null || value == _selectedMediaType) {
      return;
    }

    setState(() {
      _selectedMediaType = value;
      if (widget.isCreate) {
        _selectedProvider = _defaultProviderForMediaType(value);
      }
      _markAsFinishedError = _validateMarkAsFinished();
    });
  }

  void _onProviderChanged(String? value) {
    if (value == null || value.trim().isEmpty) {
      return;
    }

    setState(() {
      _selectedProvider = value.trim();
    });
  }

  void _onIconChanged(String? value) {
    if (value == null || value.trim().isEmpty) {
      return;
    }

    setState(() {
      _selectedIconName = value.trim();
    });
  }

  void _addFolderPath(String path) {
    final nextPath = path.trim();
    if (nextPath.isEmpty) {
      setState(() {
        _foldersError = 'Folder path cannot be empty.';
      });
      return;
    }

    final conflictError = _folderConflictError(nextPath);
    if (conflictError != null) {
      setState(() {
        _foldersError = conflictError;
      });
      return;
    }

    setState(() {
      _folders.add(LibraryFolderEditorEntry(path: nextPath));
      _newFolderPathController.clear();
      _foldersError = _validateFolders(_folders);
    });
  }

  void _addFolderFromInput() {
    _addFolderPath(_newFolderPathController.text);
  }

  Future<void> _browseForFolder() async {
    if (_isBrowsingFolders) {
      return;
    }

    setState(() {
      _isBrowsingFolders = true;
    });

    final initialPath = _folders.isEmpty ? null : _folders.last.path;
    final selectedPath = await showFilesystemDirectoryPickerDialog(
      context,
      title: 'Select library folder',
      initialPath: initialPath,
    );

    if (!mounted) {
      return;
    }

    if (selectedPath != null && selectedPath.trim().isNotEmpty) {
      _addFolderPath(selectedPath);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isBrowsingFolders = false;
    });
  }

  void _removeFolder(LibraryFolderEditorEntry folder) {
    setState(() {
      _folders.remove(folder);
      _foldersError = _validateFolders(_folders);
    });
  }

  void _onMetadataSourceReorder(int oldIndex, int newIndex) {
    final reordered = List<LibraryMetadataSourceEntry>.from(_metadataSources);
    final moved = reordered.removeAt(oldIndex);
    reordered.insert(newIndex, moved);

    setState(() {
      _metadataSources = reordered;
    });
  }

  void _onToggleMetadataSource(LibraryMetadataSourceEntry entry) {
    setState(() {
      _metadataSources = _metadataSources
          .map((source) => source.id == entry.id ? entry : source)
          .toList(growable: false);
    });
  }

  void _resetMetadataSources() {
    setState(() {
      _metadataSources = _buildMetadataSources(_defaultMetadataPrecedenceIds);
    });
  }

  LibrarySettings _buildSettings() {
    final enabledMetadataSources = _metadataSources
        .where((source) => source.enabled)
        .map((source) => source.id)
        .toList();
    final metadataPrecedence = enabledMetadataSources.isEmpty
        ? _defaultMetadataPrecedenceIds
        : enabledMetadataSources.reversed.toList(growable: false);

    final rawMarkValue = _markAsFinishedValueController.text.trim();
    final parsedTimeRemaining = int.tryParse(rawMarkValue) ?? 10;
    final parsedPercentComplete = double.tryParse(rawMarkValue) ?? 10;
    final boundedTimeRemaining = parsedTimeRemaining < 1 ? 1 : parsedTimeRemaining;
    final boundedPercentComplete = parsedPercentComplete.clamp(0, 100).toDouble();

    return LibrarySettings(
      coverAspectRatio: _useSquareBookCovers ? 1 : 1.6,
      disableWatcher: !_enableWatcher,
      skipMatchingMediaWithAsin: _selectedMediaType == 'book' ? _skipMatchingMediaWithAsin : null,
      skipMatchingMediaWithIsbn: _selectedMediaType == 'book' ? _skipMatchingMediaWithIsbn : null,
      autoScanCronExpression: _scheduleEnabled ? _autoScanCronController.text.trim() : null,
      audiobooksOnly: _selectedMediaType == 'book' ? _audiobooksOnly : null,
      epubScriptedContent: _selectedMediaType == 'book' ? _epubScriptedContent : null,
      hideSingleBookSeries: _selectedMediaType == 'book' ? _hideSingleBookSeries : null,
      showLaterBooks: _selectedMediaType == 'book' ? _showLaterBooks : null,
      podcastSearchRegion: _selectedMediaType == 'podcast' ? _selectedPodcastRegion : null,
      markAsFinishedTimeRemaining: _selectedMediaType == 'book' && _markAsFinishedMode == 'timeRemaining'
          ? boundedTimeRemaining
          : null,
      markAsFinishedPercentComplete: _selectedMediaType == 'book' && _markAsFinishedMode == 'percentComplete'
          ? boundedPercentComplete
          : null,
      metadataPrecedence: _selectedMediaType == 'book' ? metadataPrecedence : null,
    );
  }

  Future<void> _runRemoveMetadata(String extension) async {
    final sourceLibrary = widget.library;
    if (sourceLibrary == null || _isRunningToolAction) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isRunningToolAction = true;
    });

    try {
      final response = await api.getLibraryApi().removeLibraryMetadata(sourceLibrary.id, extension: extension);
      final payload = response.data;

      if (payload == null || !payload.found) {
        _showMessage('No .$extension metadata files were found.');
        return;
      }

      if (payload.numRemoved <= 0) {
        _showMessage('No .$extension metadata files were removed.');
        return;
      }

      _showMessage('Removed ${payload.numRemoved} .$extension metadata files.');
    } catch (error) {
      _showMessage('Failed removing .$extension metadata files: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isRunningToolAction = false;
        });
      }
    }
  }

  Future<void> _runMatchAllBooks() async {
    final sourceLibrary = widget.library;
    if (sourceLibrary == null || _isRunningToolAction) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      _showMessage('No active API client.');
      return;
    }

    setState(() {
      _isRunningToolAction = true;
    });

    try {
      final success = await api.getLibraryApi().matchAllBooks(sourceLibrary.id);
      if (!success) {
        _showMessage('Failed to start match-all job.');
        return;
      }

      _showMessage('Started match-all metadata job.');
    } catch (error) {
      _showMessage('Failed to start match-all metadata job: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isRunningToolAction = false;
        });
      }
    }
  }

  void _submit() {
    final nameError = _validateName(_nameController.text);
    final foldersError = _validateFolders(_folders);
    final scheduleError = _validateSchedule();
    final markError = _validateMarkAsFinished();

    if (nameError != null || foldersError != null || scheduleError != null || markError != null) {
      setState(() {
        _nameError = nameError;
        _foldersError = foldersError;
        _scheduleError = scheduleError;
        _markAsFinishedError = markError;
      });
      return;
    }

    final folderPayloads = _folders
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

    Navigator.of(context).pop(
      LibraryUpsertFormResult(
        name: _nameController.text.trim(),
        mediaType: _selectedMediaType,
        provider: _selectedProvider,
        icon: _selectedIconName,
        folders: folderPayloads,
        settings: _buildSettings(),
      ),
    );
  }

  Widget _buildProviderField(List<YaabsaDropdownOption<String>> providerOptions) {
    return YaabsaExpressiveDropdownField<String>(
      value: _selectedProvider,
      options: providerOptions,
      onChanged: _onProviderChanged,
      decoration: yaabsaFieldDecoration(context, label: 'Provider', hintText: 'Select metadata provider'),
    );
  }

  Widget _buildLibrarySettingsTab(AsyncValue<List<SearchProviderOption>> providerOptionsAsync) {
    final providerOptions = _providerOptions(providerOptionsAsync.value ?? const <SearchProviderOption>[]);
    final iconOptions = _resolvedIconOptions();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          YaabsaExpressiveDropdownField<String>(
            value: _selectedMediaType,
            options: _mediaTypeOptions,
            onChanged: widget.isCreate ? _onMediaTypeChanged : null,
            decoration: yaabsaFieldDecoration(
              context,
              label: 'Media type',
              hintText: widget.isCreate ? null : 'Media type cannot be changed for existing libraries',
            ),
          ),
          const SizedBox(height: 10),
          StyledTextField(
            label: 'Library name',
            controller: _nameController,
            hintText: 'My Audiobooks',
            errorText: _nameError,
            onChanged: (_) {
              if (_nameError == null) {
                return;
              }
              setState(() {
                _nameError = _validateName(_nameController.text);
              });
            },
          ),
          const SizedBox(height: 10),
          if (providerOptionsAsync.isLoading && providerOptionsAsync.value == null)
            const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: LinearProgressIndicator(minHeight: 2)),
          _buildProviderField(providerOptions),
          const SizedBox(height: 10),
          YaabsaExpressiveDropdownField<String>(
            value: _selectedIconName,
            options: iconOptions,
            onChanged: _onIconChanged,
            decoration: yaabsaFieldDecoration(context, label: 'Icon name', hintText: 'Select library icon key'),
          ),
          const SizedBox(height: 12),
          LibraryFolderListEditor(
            folders: _folders,
            newFolderPathController: _newFolderPathController,
            onAddFolderPressed: _addFolderFromInput,
            onRemoveFolderPressed: _removeFolder,
            onBrowseFolderPressed: _browseForFolder,
            isBrowsing: _isBrowsingFolders,
            errorText: _foldersError,
          ),
          const SizedBox(height: 12),
          Text('Library behavior', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Use square book covers'),
            value: _useSquareBookCovers,
            onChanged: (value) {
              setState(() {
                _useSquareBookCovers = value;
              });
            },
          ),
          if (_selectedMediaType == 'book') ...[
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Audiobooks only'),
              value: _audiobooksOnly,
              onChanged: (value) {
                setState(() {
                  _audiobooksOnly = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Hide single-book series'),
              value: _hideSingleBookSeries,
              onChanged: (value) {
                setState(() {
                  _hideSingleBookSeries = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Only show later books in continue series'),
              value: _showLaterBooks,
              onChanged: (value) {
                setState(() {
                  _showLaterBooks = value;
                });
              },
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Allow scripted ebook content'),
              value: _epubScriptedContent,
              onChanged: (value) {
                setState(() {
                  _epubScriptedContent = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Text('Mark as finished threshold', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: YaabsaExpressiveDropdownField<String>(
                    value: _markAsFinishedMode,
                    options: const [
                      YaabsaDropdownOption<String>(value: 'timeRemaining', label: 'Time remaining (seconds)'),
                      YaabsaDropdownOption<String>(value: 'percentComplete', label: 'Percent complete'),
                    ],
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _markAsFinishedMode = value;
                        _markAsFinishedError = _validateMarkAsFinished();
                      });
                    },
                    decoration: yaabsaFieldDecoration(context, label: 'Mode'),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  child: StyledTextField(
                    label: _markAsFinishedMode == 'percentComplete' ? 'Percent' : 'Seconds',
                    controller: _markAsFinishedValueController,
                    keyboardType: _markAsFinishedMode == 'percentComplete'
                        ? const TextInputType.numberWithOptions(decimal: true)
                        : TextInputType.number,
                    errorText: _markAsFinishedError,
                    onChanged: (_) {
                      if (_markAsFinishedError == null) {
                        return;
                      }
                      setState(() {
                        _markAsFinishedError = _validateMarkAsFinished();
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
          if (_selectedMediaType == 'podcast') ...[
            const SizedBox(height: 8),
            YaabsaExpressiveDropdownField<String>(
              value: _selectedPodcastRegion,
              options: _podcastRegionOptions,
              onChanged: (value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _selectedPodcastRegion = value;
                });
              },
              decoration: yaabsaFieldDecoration(context, label: 'Podcast search region'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScannerTab() {
    if (_selectedMediaType != 'book') {
      return Center(
        child: Text(
          'Scanner settings are available for book libraries.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    final controls = <Widget>[
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: const Text('Enable folder watcher'),
        subtitle: const Text('Disable if your host cannot provide reliable filesystem watch events.'),
        value: _enableWatcher,
        onChanged: (value) {
          setState(() {
            _enableWatcher = value;
          });
        },
      ),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: const Text('Skip matching books with ASIN'),
        value: _skipMatchingMediaWithAsin,
        onChanged: (value) {
          setState(() {
            _skipMatchingMediaWithAsin = value;
          });
        },
      ),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        title: const Text('Skip matching books with ISBN'),
        value: _skipMatchingMediaWithIsbn,
        onChanged: (value) {
          setState(() {
            _skipMatchingMediaWithIsbn = value;
          });
        },
      ),
      const SizedBox(height: 8),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < 460) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ...controls,
                SizedBox(
                  height: 280,
                  child: LibraryMetadataPrecedenceEditor(
                    sources: _metadataSources,
                    onReorderItem: _onMetadataSourceReorder,
                    onToggleSource: _onToggleMetadataSource,
                    onResetToDefault: _resetMetadataSources,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...controls,
            Expanded(
              child: LibraryMetadataPrecedenceEditor(
                sources: _metadataSources,
                onReorderItem: _onMetadataSourceReorder,
                onToggleSource: _onToggleMetadataSource,
                onResetToDefault: _resetMetadataSources,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScheduleTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: const Text('Enable scheduled scans'),
            subtitle: const Text('Use cron syntax. Example: 0 0 * * 1 runs weekly on Monday at 00:00.'),
            value: _scheduleEnabled,
            onChanged: (value) {
              setState(() {
                _scheduleEnabled = value;
                _scheduleError = _validateSchedule();
              });
            },
          ),
          const SizedBox(height: 8),
          StyledTextField(
            label: 'Cron expression',
            controller: _autoScanCronController,
            hintText: '0 0 * * 1',
            enabled: _scheduleEnabled,
            errorText: _scheduleError,
            onChanged: (_) {
              if (_scheduleError == null) {
                return;
              }
              setState(() {
                _scheduleError = _validateSchedule();
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Disable scheduling to clear the cron expression.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsTab() {
    final sourceLibrary = widget.library;

    if (sourceLibrary == null) {
      return Center(
        child: Text(
          'Create the library first to access tools.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    final isBookLibrary = sourceLibrary.mediaType == 'book';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Metadata file cleanup', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            'Remove generated metadata files from library folders.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _isRunningToolAction ? null : () => _runRemoveMetadata('json'),
                icon: const Icon(Icons.cleaning_services_outlined),
                label: const Text('Remove metadata.json'),
              ),
              OutlinedButton.icon(
                onPressed: _isRunningToolAction ? null : () => _runRemoveMetadata('abs'),
                icon: const Icon(Icons.cleaning_services_outlined),
                label: const Text('Remove metadata.abs'),
              ),
            ],
          ),
          if (isBookLibrary) ...[
            const SizedBox(height: 14),
            Divider(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.35)),
            const SizedBox(height: 10),
            Text('Match all books', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text(
              'Run the server match-all process for this library.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _isRunningToolAction ? null : _runMatchAllBooks,
              icon: _isRunningToolAction
                  ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_fix_high_rounded),
              label: const Text('Start match-all'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerOptionsAsync = ref.watch(uploadMetadataProvidersProvider(_selectedMediaType));
    final mediaQuery = MediaQuery.of(context);
    final dialogWidth = (mediaQuery.size.width - 48).clamp(280.0, 980.0).toDouble();
    final dialogHeight = (mediaQuery.size.height - 190).clamp(120.0, 640.0).toDouble();

    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      buttonPadding: const EdgeInsets.symmetric(horizontal: 6),
      content: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: ExpressiveTabView(
          tabs: [
            ExpressiveTabViewItem(
              id: 'library-settings',
              label: 'Library Settings',
              child: _buildLibrarySettingsTab(providerOptionsAsync),
            ),
            ExpressiveTabViewItem(id: 'scanner', label: 'Scanner', child: _buildScannerTab()),
            ExpressiveTabViewItem(id: 'schedule', label: 'Schedule', child: _buildScheduleTab()),
            ExpressiveTabViewItem(id: 'tools', label: 'Tools', child: _buildToolsTab()),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton.icon(
          onPressed: _submit,
          icon: Icon(widget.isCreate ? Icons.add_rounded : Icons.save_rounded),
          label: Text(widget.isCreate ? 'Create library' : 'Save changes'),
        ),
      ],
    );
  }
}
