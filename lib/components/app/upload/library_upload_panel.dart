import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/app/upload/library_upload_item_card.dart';
import 'package:yaabsa/components/app/upload/library_upload_models.dart';
import 'package:yaabsa/components/app/upload/settings_toggle_row.dart';
import 'package:yaabsa/components/common/inputs/styled_form_fields.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/player_utils.dart';

class LibraryUploadPanel extends ConsumerStatefulWidget {
  const LibraryUploadPanel({super.key, required this.selectedLibrary, required this.onClose, this.onUploadingChanged});

  final Library selectedLibrary;
  final VoidCallback onClose;
  final ValueChanged<bool>? onUploadingChanged;

  @override
  ConsumerState<LibraryUploadPanel> createState() => _LibraryUploadPanelState();
}

class _LibraryUploadPanelState extends ConsumerState<LibraryUploadPanel> {
  static const Set<String> _audioExtensions = {
    'aac',
    'aax',
    'aif',
    'aiff',
    'alac',
    'ape',
    'flac',
    'm4a',
    'm4b',
    'mka',
    'mp3',
    'mp4',
    'mpc',
    'mpeg',
    'ogg',
    'oga',
    'opus',
    'wav',
    'wma',
  };

  static const Set<String> _ebookExtensions = {'epub', 'pdf', 'mobi', 'azw', 'azw3', 'cbz', 'cbr'};

  static const Set<String> _otherSupportedExtensions = {
    'jpg',
    'jpeg',
    'png',
    'webp',
    'bmp',
    'gif',
    'nfo',
    'opf',
    'cue',
    'txt',
    'json',
    'xml',
    'srt',
    'vtt',
  };

  final TextEditingController _bulkAuthorController = TextEditingController();
  final TextEditingController _bulkSeriesController = TextEditingController();
  final Map<int, CancelToken> _cancelTokens = <int, CancelToken>{};
  final Map<int, _UploadProgressSample> _progressSamples = <int, _UploadProgressSample>{};

  int _nextItemId = 1;
  List<UploadItemDraft> _items = const [];

  bool _isUploading = false;
  bool _isDropHovering = false;
  bool _autoFetchMetadata = true;
  bool _autoAcceptMetadata = true;
  bool _autocompleteSeriesAndAuthors = true;
  bool _isLoadingAutocompleteSuggestions = false;
  String? _selectedFolderId;
  String? _selectedProvider;
  String? _loadedAutocompleteFolderPath;
  List<String> _authorAutocompleteOptions = const [];
  Map<String, String> _authorDirectoryPathsByName = const {};
  Map<String, List<String>> _seriesAutocompleteByAuthor = const {};
  String? _panelMessage;

  bool get _isBookLibrary => widget.selectedLibrary.mediaType == 'book';

  List<LibraryFolder> get _folders => widget.selectedLibrary.folders ?? const <LibraryFolder>[];

  LibraryFolder? get _selectedFolder {
    if (_selectedFolderId == null) {
      return _folders.isEmpty ? null : _folders.first;
    }

    for (final folder in _folders) {
      if (folder.id == _selectedFolderId) {
        return folder;
      }
    }

    return _folders.isEmpty ? null : _folders.first;
  }

  bool get _supportsDragDrop {
    if (kIsWeb) {
      return false;
    }

    return switch (defaultTargetPlatform) {
      TargetPlatform.windows || TargetPlatform.linux || TargetPlatform.macOS => true,
      _ => false,
    };
  }

  @override
  void initState() {
    super.initState();
    _resetSelectionsForLibrary();
    unawaited(_refreshFolderAutocompleteSuggestions(force: true));
  }

  @override
  void didUpdateWidget(covariant LibraryUploadPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedLibrary.id == widget.selectedLibrary.id) {
      return;
    }

    _cancelAllUploads('Upload canceled because library changed.');
    _resetSelectionsForLibrary();
    setState(() {
      _items = const [];
      _panelMessage = null;
      _authorAutocompleteOptions = const [];
      _authorDirectoryPathsByName = const {};
      _seriesAutocompleteByAuthor = const {};
      _loadedAutocompleteFolderPath = null;
    });
    unawaited(_refreshFolderAutocompleteSuggestions(force: true));
  }

  @override
  void dispose() {
    _cancelAllUploads('Upload canceled because uploader was closed.');
    if (_isUploading) {
      PlayerUtils.disableUploadWakelock();
    }
    _bulkAuthorController.dispose();
    _bulkSeriesController.dispose();
    widget.onUploadingChanged?.call(false);
    super.dispose();
  }

  void _resetSelectionsForLibrary() {
    _selectedFolderId = _folders.isEmpty ? null : _folders.first.id;
    _selectedProvider = widget.selectedLibrary.provider.trim().isEmpty ? null : widget.selectedLibrary.provider.trim();
  }

  bool _isAdminType(String? userType) {
    final normalized = (userType ?? '').trim().toLowerCase();
    return normalized == 'admin' || normalized == 'root';
  }

  List<String> _sortedUniqueNames(Iterable<String> rawValues) {
    final seen = <String>{};
    final values = <String>[];
    for (final value in rawValues) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        continue;
      }
      final key = trimmed.toLowerCase();
      if (seen.add(key)) {
        values.add(trimmed);
      }
    }
    values.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return values;
  }

  String _normalizeDirectoryKey(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  Future<void> _refreshFolderAutocompleteSuggestions({bool force = false}) async {
    final currentUser = ref.read(currentUserProvider).value;
    final isAdmin = _isAdminType(currentUser?.type);
    final folderPath = _selectedFolder?.fullPath.trim();

    if (!_autocompleteSeriesAndAuthors || !isAdmin || folderPath == null || folderPath.isEmpty) {
      if (!mounted) {
        return;
      }
      setState(() {
        _authorAutocompleteOptions = const [];
        _authorDirectoryPathsByName = const {};
        _seriesAutocompleteByAuthor = const {};
        _loadedAutocompleteFolderPath = null;
        _isLoadingAutocompleteSuggestions = false;
      });
      return;
    }

    if (!force && _loadedAutocompleteFolderPath == folderPath) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingAutocompleteSuggestions = true;
      });
    }

    try {
      final uploadApi = api.getUploadApi();
      final authorResponse = await uploadApi.getFilesystemPaths(path: folderPath, level: 0);
      final authorDirectories = authorResponse?.directories ?? const [];
      final authorSuggestions = _sortedUniqueNames(authorDirectories.map((entry) => entry.dirname));
      final authorPaths = <String, String>{};
      for (final directory in authorDirectories) {
        final name = directory.dirname.trim();
        if (name.isEmpty) {
          continue;
        }
        authorPaths[name.toLowerCase()] = directory.path;
      }

      if (!mounted) {
        return;
      }
      setState(() {
        _authorAutocompleteOptions = authorSuggestions;
        _authorDirectoryPathsByName = authorPaths;
        _seriesAutocompleteByAuthor = const {};
        _loadedAutocompleteFolderPath = folderPath;
      });
    } catch (error, stackTrace) {
      logger(
        'Failed loading filesystem autocomplete suggestions: $error\n$stackTrace',
        tag: 'LibraryUploadPanel',
        level: InfoLevel.warning,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAutocompleteSuggestions = false;
        });
      }
    }
  }

  List<String> _seriesSuggestionsForAuthor(String author) {
    final key = author.trim().toLowerCase();
    if (key.isEmpty) {
      return const [];
    }
    return _seriesAutocompleteByAuthor[key] ?? const [];
  }

  Future<void> _loadSeriesSuggestionsForAuthor(String author) async {
    final normalizedAuthor = author.trim().toLowerCase();
    if (normalizedAuthor.isEmpty || !mounted) {
      return;
    }

    if (_seriesAutocompleteByAuthor.containsKey(normalizedAuthor)) {
      return;
    }

    final currentUser = ref.read(currentUserProvider).value;
    if (!_autocompleteSeriesAndAuthors || !_isAdminType(currentUser?.type)) {
      return;
    }

    var authorPath = _authorDirectoryPathsByName[normalizedAuthor];
    if (authorPath == null) {
      final normalizedKey = _normalizeDirectoryKey(author);
      for (final entry in _authorDirectoryPathsByName.entries) {
        if (_normalizeDirectoryKey(entry.key) == normalizedKey) {
          authorPath = entry.value;
          break;
        }
      }
    }

    if (authorPath == null || authorPath.trim().isEmpty) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      return;
    }

    try {
      final response = await api.getUploadApi().getFilesystemPaths(path: authorPath, level: 1);
      final seriesSuggestions = _sortedUniqueNames((response?.directories ?? const []).map((entry) => entry.dirname));

      if (!mounted) {
        return;
      }

      setState(() {
        _seriesAutocompleteByAuthor = <String, List<String>>{
          ..._seriesAutocompleteByAuthor,
          normalizedAuthor: seriesSuggestions,
        };
      });
    } catch (error, stackTrace) {
      logger(
        'Failed loading series suggestions for author "$author": $error\n$stackTrace',
        tag: 'LibraryUploadPanel',
        level: InfoLevel.warning,
      );
    }
  }

  void _setUploading(bool value) {
    if (_isUploading == value) {
      return;
    }

    if (value) {
      PlayerUtils.enableUploadWakelock();
    } else {
      PlayerUtils.disableUploadWakelock();
    }

    setState(() {
      _isUploading = value;
    });
    widget.onUploadingChanged?.call(value);
  }

  void _cancelAllUploads(String reason) {
    for (final token in _cancelTokens.values) {
      if (!token.isCancelled) {
        token.cancel(reason);
      }
    }

    _cancelTokens.clear();
    _progressSamples.clear();
  }

  void _updateItem(int itemId, UploadItemDraft Function(UploadItemDraft current) transform) {
    if (!mounted) {
      return;
    }

    setState(() {
      _items = _items.map((item) => item.id == itemId ? transform(item) : item).toList(growable: false);
    });
  }

  UploadPickedFile _classifyFile({required String absolutePath, required String relativePath}) {
    final fileName = p.basename(absolutePath);
    final extension = p.extension(fileName).toLowerCase().replaceFirst('.', '');

    final isItem = _isBookLibrary
        ? (_audioExtensions.contains(extension) || _ebookExtensions.contains(extension))
        : _audioExtensions.contains(extension);

    final kind = isItem
        ? UploadFileKind.item
        : (_otherSupportedExtensions.contains(extension) ? UploadFileKind.other : UploadFileKind.ignored);

    return UploadPickedFile(absolutePath: absolutePath, relativePath: relativePath, fileName: fileName, kind: kind);
  }

  String _cleanSegment(String value) {
    final cleaned = value.replaceAll(RegExp(r'[_\.]+'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned.isEmpty ? value : cleaned;
  }

  String _titleFromFileName(String fileName) {
    return _cleanSegment(p.basenameWithoutExtension(fileName));
  }

  UploadItemDraft _buildUploadItem({
    required String title,
    required String author,
    required String series,
    required List<UploadPickedFile> itemFiles,
    required List<UploadPickedFile> otherFiles,
    required List<UploadPickedFile> ignoredFiles,
    required String sourceDescription,
    String? message,
  }) {
    final item = UploadItemDraft(
      id: _nextItemId,
      title: title,
      author: author,
      series: series,
      itemFiles: itemFiles,
      otherFiles: otherFiles,
      ignoredFiles: ignoredFiles,
      status: UploadItemStatus.ready,
      progress: 0,
      uploadSpeedBytesPerSecond: 0,
      uploadedBytes: 0,
      totalBytes: 0,
      sourceDescription: sourceDescription,
      message: message,
    );
    _nextItemId += 1;
    return item;
  }

  List<UploadItemDraft> _buildDirectFileItems(List<UploadPickedFile> directFiles) {
    final itemFiles = directFiles.where((file) => file.kind == UploadFileKind.item).toList(growable: false);
    final otherFiles = directFiles.where((file) => file.kind == UploadFileKind.other).toList(growable: false);
    final ignoredFiles = directFiles.where((file) => file.kind == UploadFileKind.ignored).toList(growable: false);

    if (itemFiles.isEmpty) {
      return const [];
    }

    if (_isBookLibrary && itemFiles.length > 1) {
      return itemFiles
          .map(
            (file) => _buildUploadItem(
              title: _titleFromFileName(file.fileName),
              author: '',
              series: '',
              itemFiles: <UploadPickedFile>[file],
              otherFiles: const <UploadPickedFile>[],
              ignoredFiles: const <UploadPickedFile>[],
              sourceDescription: file.relativePath,
              message: (otherFiles.isNotEmpty || ignoredFiles.isNotEmpty)
                  ? 'Non-book sidecar files were ignored for multi-file book upload grouping.'
                  : null,
            ),
          )
          .toList(growable: false);
    }

    final title = itemFiles.length == 1
        ? _titleFromFileName(itemFiles.first.fileName)
        : _cleanSegment(widget.selectedLibrary.name);

    return <UploadItemDraft>[
      _buildUploadItem(
        title: title,
        author: '',
        series: '',
        itemFiles: itemFiles,
        otherFiles: otherFiles,
        ignoredFiles: ignoredFiles,
        sourceDescription: itemFiles.length == 1 ? itemFiles.first.relativePath : 'Direct file selection',
      ),
    ];
  }

  Future<UploadItemDraft?> _buildFolderItem(String folderPath, Set<String> existingAbsolutePaths) async {
    final rootDirectory = Directory(folderPath);
    if (!await rootDirectory.exists()) {
      return null;
    }

    final byDirectory = <String, List<UploadPickedFile>>{};
    final allFiles = <UploadPickedFile>[];

    await for (final entity in rootDirectory.list(recursive: true, followLinks: false)) {
      if (entity is! File) {
        continue;
      }

      final absolutePath = entity.path;
      if (existingAbsolutePaths.contains(absolutePath)) {
        continue;
      }

      final relativeToRoot = p.relative(absolutePath, from: folderPath);
      final displayRelativePath = p.join(p.basename(folderPath), relativeToRoot);
      final pickedFile = _classifyFile(absolutePath: absolutePath, relativePath: displayRelativePath);
      allFiles.add(pickedFile);

      final directoryPath = p.dirname(absolutePath);
      byDirectory.putIfAbsent(directoryPath, () => <UploadPickedFile>[]).add(pickedFile);
    }

    if (allFiles.isEmpty) {
      return null;
    }

    String? targetDirectory;
    final rootItemFiles = byDirectory[folderPath]?.where((file) => file.kind == UploadFileKind.item) ?? const [];
    if (rootItemFiles.isNotEmpty) {
      targetDirectory = folderPath;
    } else {
      final candidateDirectories =
          byDirectory.entries
              .where((entry) => entry.value.any((file) => file.kind == UploadFileKind.item))
              .map((entry) => entry.key)
              .toList(growable: false)
            ..sort();

      for (final candidate in candidateDirectories) {
        if (candidate != folderPath) {
          targetDirectory = candidate;
          break;
        }
      }
    }

    final targetDirectoryPath = targetDirectory;
    if (targetDirectoryPath == null) {
      return null;
    }

    final scopedFiles = allFiles
        .where((file) {
          final fileDirectory = p.dirname(file.absolutePath);
          return fileDirectory == targetDirectoryPath || p.isWithin(targetDirectoryPath, fileDirectory);
        })
        .toList(growable: false);

    final itemFiles = scopedFiles.where((file) => file.kind == UploadFileKind.item).toList(growable: false);
    final otherFiles = scopedFiles.where((file) => file.kind == UploadFileKind.other).toList(growable: false);
    final ignoredFiles = scopedFiles.where((file) => file.kind == UploadFileKind.ignored).toList(growable: false);

    if (itemFiles.isEmpty) {
      return null;
    }

    final rootParent = p.dirname(folderPath);
    final targetRelativeToParent = p.relative(targetDirectoryPath, from: rootParent);
    final segments = p
        .split(targetRelativeToParent)
        .where((segment) => segment.trim().isNotEmpty && segment.trim() != '.')
        .map(_cleanSegment)
        .toList(growable: false);

    final title = segments.isNotEmpty ? segments.last : _cleanSegment(p.basename(targetDirectoryPath));
    final author = segments.length >= 2 ? segments.first : '';
    final series = segments.length >= 3 ? segments[segments.length - 2] : '';

    return _buildUploadItem(
      title: title,
      author: author,
      series: series,
      itemFiles: itemFiles,
      otherFiles: otherFiles,
      ignoredFiles: ignoredFiles,
      sourceDescription: targetRelativeToParent,
    );
  }

  Future<void> _appendInputPaths(List<String> rawPaths) async {
    final existingAbsolutePaths = <String>{
      for (final item in _items) ...item.itemFiles.map((file) => file.absolutePath),
      for (final item in _items) ...item.otherFiles.map((file) => file.absolutePath),
      for (final item in _items) ...item.ignoredFiles.map((file) => file.absolutePath),
    };

    final directFiles = <UploadPickedFile>[];
    final folders = <String>[];

    for (final rawPath in rawPaths) {
      final path = rawPath.trim();
      if (path.isEmpty || existingAbsolutePaths.contains(path)) {
        continue;
      }

      final entityType = await FileSystemEntity.type(path, followLinks: false);
      if (entityType == FileSystemEntityType.directory) {
        folders.add(path);
      } else if (entityType == FileSystemEntityType.file) {
        directFiles.add(_classifyFile(absolutePath: path, relativePath: p.basename(path)));
      }
    }

    final createdItems = <UploadItemDraft>[];
    if (directFiles.isNotEmpty) {
      createdItems.addAll(_buildDirectFileItems(directFiles));
    }

    for (final folderPath in folders) {
      final item = await _buildFolderItem(folderPath, existingAbsolutePaths);
      if (item != null) {
        createdItems.add(item);
      }
    }

    if (createdItems.isEmpty) {
      setState(() {
        _panelMessage = 'No supported files were found in the selected input.';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _panelMessage = 'Added ${createdItems.length} upload item${createdItems.length == 1 ? '' : 's'}.';
      _items = <UploadItemDraft>[..._items, ...createdItems];
    });

    if (_autoFetchMetadata) {
      for (final item in createdItems) {
        unawaited(_fetchMetadataForItem(item.id, silentNoResults: true));
      }
    }
  }

  Future<void> _pickFiles() async {
    if (_isUploading) {
      return;
    }

    final result = await FilePicker.pickFiles(allowMultiple: true, withData: false);
    if (result == null) {
      return;
    }

    final paths = result.paths.whereType<String>().toList(growable: false);
    await _appendInputPaths(paths);
  }

  Future<void> _pickFolder() async {
    if (_isUploading) {
      return;
    }

    final folderPath = await FilePicker.getDirectoryPath();
    if (folderPath == null || folderPath.trim().isEmpty) {
      return;
    }

    await _appendInputPaths(<String>[folderPath]);
  }

  Future<void> _handleDropDone(Iterable<Object?> files) async {
    if (_isUploading) {
      return;
    }

    final paths = files
        .map((file) {
          if (file == null) {
            return null;
          }
          final dynamic candidate = file;
          final dynamic path = candidate.path;
          return path is String ? path : null;
        })
        .whereType<String>()
        .where((path) => path.trim().isNotEmpty)
        .toList(growable: false);

    if (paths.isEmpty) {
      return;
    }

    await _appendInputPaths(paths);
  }

  String _buildRemoteItemPath(UploadItemDraft item) {
    final segments = <String>[];
    final author = item.author.trim();
    final series = item.series.trim();
    final title = item.title.trim();

    if (author.isNotEmpty) {
      segments.add(author);
    }
    if (series.isNotEmpty) {
      segments.add(series);
    }
    segments.add(title.isEmpty ? 'Untitled Upload' : title);
    return segments.join('/');
  }

  String _itemIdentityLabel(UploadItemDraft item) {
    final title = item.title.trim().isEmpty ? 'Untitled' : item.title.trim();
    final author = item.author.trim().isEmpty ? '-' : item.author.trim();
    final series = item.series.trim().isEmpty ? '-' : item.series.trim();
    return '$title | $author | $series';
  }

  Future<bool> _confirmPathConflicts(List<String> conflicts) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Path check issues found'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Some items have destination conflicts or path-check errors. Continue anyway?'),
                const SizedBox(height: 8),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: conflicts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Text('- ${conflicts[index]}', style: Theme.of(context).textTheme.bodySmall),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel upload')),
            FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Continue anyway')),
          ],
        );
      },
    );

    return result == true;
  }

  Future<void> _fetchMetadataForItem(int itemId, {bool silentNoResults = false}) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return;
    }

    final item = _items.where((entry) => entry.id == itemId).firstOrNull;
    if (item == null) {
      return;
    }

    final title = item.title.trim();
    if (title.isEmpty) {
      return;
    }

    try {
      final response = await api.getUploadApi().searchMetadata(
        mediaType: widget.selectedLibrary.mediaType,
        title: title,
        author: item.author.trim().isEmpty ? null : item.author.trim(),
        provider: _selectedProvider,
      );

      final firstResult = _extractFirstMetadataResult(response.data);
      if (firstResult == null) {
        if (!silentNoResults) {
          _updateItem(
            itemId,
            (current) =>
                current.copyWith(status: UploadItemStatus.ready, message: 'No metadata result found for this item.'),
          );
        }
        return;
      }

      final resolvedTitle = (firstResult['title'] as String?)?.trim();
      final resolvedAuthor = _extractAuthor(firstResult) ?? item.author;
      final resolvedSeries = _extractSeries(firstResult) ?? item.series;
      final suggestedTitle = resolvedTitle != null && resolvedTitle.isNotEmpty ? resolvedTitle : item.title;

      if (_autoAcceptMetadata) {
        _updateItem(
          itemId,
          (current) => current.copyWith(
            status: UploadItemStatus.ready,
            title: suggestedTitle,
            author: resolvedAuthor,
            series: resolvedSeries,
            clearPendingMetadata: true,
            message: 'Metadata updated from provider lookup.',
          ),
        );
        unawaited(_loadSeriesSuggestionsForAuthor(resolvedAuthor));
      } else {
        _updateItem(
          itemId,
          (current) => current.copyWith(
            status: UploadItemStatus.ready,
            pendingMetadata: UploadMetadataSuggestion(
              title: suggestedTitle,
              author: resolvedAuthor,
              series: resolvedSeries,
            ),
            message: 'Metadata suggestion ready. Accept or reject it.',
          ),
        );
      }
    } catch (error, stackTrace) {
      logger('Failed metadata lookup: $error\n$stackTrace', tag: 'LibraryUploadPanel', level: InfoLevel.warning);
      if (!silentNoResults) {
        _updateItem(
          itemId,
          (current) => current.copyWith(status: UploadItemStatus.ready, message: 'Metadata lookup failed.'),
        );
      }
    }
  }

  void _acceptPendingMetadata(int itemId) {
    _updateItem(itemId, (current) {
      final pending = current.pendingMetadata;
      if (pending == null) {
        return current;
      }

      return current.copyWith(
        status: UploadItemStatus.ready,
        title: pending.title,
        author: pending.author,
        series: pending.series,
        clearPendingMetadata: true,
        message: 'Metadata suggestion accepted.',
      );
    });
    final acceptedAuthor = _items.where((entry) => entry.id == itemId).firstOrNull?.author;
    if (acceptedAuthor != null) {
      unawaited(_loadSeriesSuggestionsForAuthor(acceptedAuthor));
    }
  }

  void _rejectPendingMetadata(int itemId) {
    _updateItem(
      itemId,
      (current) => current.copyWith(
        status: UploadItemStatus.ready,
        clearPendingMetadata: true,
        message: 'Metadata suggestion rejected.',
      ),
    );
  }

  Map<String, dynamic>? _extractFirstMetadataResult(Object? responseData) {
    if (responseData is List) {
      for (final entry in responseData) {
        if (entry is Map<String, dynamic>) {
          return entry;
        }
      }
      return null;
    }

    if (responseData is Map<String, dynamic>) {
      final directBook = responseData['book'];
      if (directBook is Map<String, dynamic>) {
        return directBook;
      }

      final keysWithLists = <String>['results', 'books', 'podcasts'];
      for (final key in keysWithLists) {
        final value = responseData[key];
        if (value is List) {
          for (final entry in value) {
            if (entry is Map<String, dynamic>) {
              return entry;
            }
          }
        }
      }
    }

    return null;
  }

  String? _extractAuthor(Map<String, dynamic> metadata) {
    final singleAuthor = metadata['author'];
    if (singleAuthor is String && singleAuthor.trim().isNotEmpty) {
      return singleAuthor.trim();
    }

    final authors = metadata['authors'];
    if (authors is List) {
      for (final authorEntry in authors) {
        if (authorEntry is String && authorEntry.trim().isNotEmpty) {
          return authorEntry.trim();
        }

        if (authorEntry is Map<String, dynamic>) {
          final name = authorEntry['name'];
          if (name is String && name.trim().isNotEmpty) {
            return name.trim();
          }
        }
      }
    }

    return null;
  }

  String? _extractSeries(Map<String, dynamic> metadata) {
    final singleSeries = metadata['series'];
    if (singleSeries is String && singleSeries.trim().isNotEmpty) {
      return singleSeries.trim();
    }

    if (singleSeries is List) {
      for (final seriesEntry in singleSeries) {
        if (seriesEntry is String && seriesEntry.trim().isNotEmpty) {
          return seriesEntry.trim();
        }

        if (seriesEntry is Map<String, dynamic>) {
          final name = seriesEntry['name'];
          if (name is String && name.trim().isNotEmpty) {
            return name.trim();
          }

          final seriesName = seriesEntry['series'];
          if (seriesName is String && seriesName.trim().isNotEmpty) {
            return seriesName.trim();
          }
        }
      }
    }

    return null;
  }

  bool _shouldRetryUpload(DioException error, {required bool payloadUploadComplete}) {
    if (CancelToken.isCancel(error)) {
      return false;
    }

    if (payloadUploadComplete && error.type == DioExceptionType.receiveTimeout) {
      return false;
    }

    final isNetworkType =
        error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.unknown;
    if (isNetworkType) {
      return true;
    }

    final statusCode = error.response?.statusCode ?? 0;
    return statusCode >= 500;
  }

  Future<FormData> _buildUploadFormData(UploadItemDraft item, LibraryFolder folder) async {
    final entries = <MapEntry<String, MultipartFile>>[];
    for (var index = 0; index < item.uploadFiles.length; index++) {
      final file = item.uploadFiles[index];
      entries.add(MapEntry('$index', await MultipartFile.fromFile(file.absolutePath, filename: file.fileName)));
    }

    final map = <String, dynamic>{
      'title': item.title.trim().isEmpty ? 'Untitled Upload' : item.title.trim(),
      'author': item.author.trim(),
      'series': item.series.trim(),
      'library': widget.selectedLibrary.id,
      'folder': folder.id,
      for (final entry in entries) entry.key: entry.value,
    };

    return FormData.fromMap(map);
  }

  Future<UploadItemStatus> _uploadSingleItem(UploadItemDraft item, LibraryFolder folder) async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      _updateItem(item.id, (current) => current.copyWith(status: UploadItemStatus.failed, message: 'No API session.'));
      return UploadItemStatus.failed;
    }

    const maxAttempts = 5;

    for (var attempt = 1; attempt <= maxAttempts; attempt++) {
      final cancelToken = CancelToken();
      _cancelTokens[item.id] = cancelToken;
      _progressSamples[item.id] = _UploadProgressSample.start(DateTime.now());
      var latestSentBytes = 0;
      var latestTotalBytes = 0;
      var payloadUploadComplete = false;

      _updateItem(
        item.id,
        (current) => current.copyWith(
          status: UploadItemStatus.uploading,
          progress: 0,
          uploadSpeedBytesPerSecond: 0,
          uploadedBytes: 0,
          totalBytes: 0,
          message: attempt == 1 ? 'Uploading...' : 'Retrying upload ($attempt/$maxAttempts)...',
        ),
      );

      try {
        final formData = await _buildUploadFormData(item, folder);
        await api.getUploadApi().uploadLibraryItem(
          formData: formData,
          cancelToken: cancelToken,
          sendTimeout: const Duration(hours: 1),
          // Upload processing on ABS can take much longer than the global receive timeout.
          // Keep waiting after bytes are fully sent instead of restarting the upload.
          // This can take multiple 10th of seconds for medium to large items
          // I am not quite sure why this even happens for ABS in general, but same
          // happens in the web. So currently this is the "workaround"
          receiveTimeout: Duration.zero,
          onSendProgress: (sent, total) {
            latestSentBytes = sent;
            latestTotalBytes = total;
            if (total > 0 && sent >= total) {
              payloadUploadComplete = true;
            }

            if (!mounted || total <= 0) {
              return;
            }

            final now = DateTime.now();
            final previous = _progressSamples[item.id];
            if (previous == null) {
              _progressSamples[item.id] = _UploadProgressSample.start(now);
              return;
            }

            final deltaMs = now.difference(previous.lastUpdateAt).inMilliseconds;
            final deltaSeconds = deltaMs <= 0 ? 0.0 : deltaMs / 1000;
            final instantRate = deltaSeconds > 0 ? (sent - previous.sentBytes) / deltaSeconds : 0.0;

            final smoothedRate = previous.smoothedBytesPerSecond <= 0
                ? instantRate
                : (previous.smoothedBytesPerSecond * 0.75) + (instantRate * 0.25);

            final totalElapsedMs = now.difference(previous.startedAt).inMilliseconds;
            final totalElapsedSeconds = totalElapsedMs <= 0 ? 0.0 : totalElapsedMs / 1000;
            final averageRate = totalElapsedSeconds > 0 ? sent / totalElapsedSeconds : 0.0;
            final blendedRate = (averageRate * 0.7) + (smoothedRate * 0.3);

            final shouldUpdateUi = now.difference(previous.lastUiUpdateAt).inMilliseconds >= 180 || sent >= total;

            _progressSamples[item.id] = _UploadProgressSample(
              sentBytes: sent,
              startedAt: previous.startedAt,
              lastUpdateAt: now,
              lastUiUpdateAt: shouldUpdateUi ? now : previous.lastUiUpdateAt,
              smoothedBytesPerSecond: smoothedRate,
            );

            if (!shouldUpdateUi) {
              return;
            }

            _updateItem(
              item.id,
              (current) => current.copyWith(
                progress: sent / total,
                uploadSpeedBytesPerSecond: blendedRate,
                uploadedBytes: sent,
                totalBytes: total,
                message: sent >= total ? 'Upload complete. Waiting for server processing...' : null,
              ),
            );
          },
        );

        if (mounted) {
          setState(() {
            _items = _items.where((entry) => entry.id != item.id).toList(growable: false);
          });
        }
        return UploadItemStatus.success;
      } on DioException catch (error) {
        if (CancelToken.isCancel(error)) {
          _updateItem(
            item.id,
            (current) => current.copyWith(status: UploadItemStatus.canceled, message: 'Upload canceled.'),
          );
          return UploadItemStatus.canceled;
        }

        final isPayloadUploadComplete =
            payloadUploadComplete || (latestTotalBytes > 0 && latestSentBytes >= latestTotalBytes);
        final canRetry =
            attempt < maxAttempts && _shouldRetryUpload(error, payloadUploadComplete: isPayloadUploadComplete);
        if (!canRetry) {
          _updateItem(
            item.id,
            (current) => current.copyWith(
              status: UploadItemStatus.failed,
              message: 'Upload failed: ${error.message ?? 'Unknown network error'}',
            ),
          );
          return UploadItemStatus.failed;
        }

        final isNetworkInterruption =
            error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.sendTimeout ||
            error.type == DioExceptionType.receiveTimeout ||
            error.type == DioExceptionType.unknown;

        _updateItem(
          item.id,
          (current) => current.copyWith(
            message: isNetworkInterruption
                ? 'Network interruption detected. Retrying ($attempt/$maxAttempts)...'
                : 'Upload issue detected. Retrying ($attempt/$maxAttempts)...',
          ),
        );

        await Future<void>.delayed(Duration(milliseconds: 800 * attempt));
      } catch (error) {
        _updateItem(
          item.id,
          (current) => current.copyWith(status: UploadItemStatus.failed, message: 'Upload failed: $error'),
        );
        return UploadItemStatus.failed;
      } finally {
        _cancelTokens.remove(item.id);
        _progressSamples.remove(item.id);
      }
    }

    return UploadItemStatus.failed;
  }

  Future<void> _startUpload() async {
    if (_isUploading) {
      return;
    }

    final folder = _selectedFolder;
    if (folder == null) {
      setState(() {
        _panelMessage = 'Select a library folder before starting upload.';
      });
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _panelMessage = 'No active authenticated API session.';
      });
      return;
    }

    final candidates = _items
        .where((item) => item.uploadFiles.isNotEmpty)
        .where((item) => item.status != UploadItemStatus.success)
        .toList(growable: false);

    if (candidates.isEmpty) {
      setState(() {
        _panelMessage = 'Nothing queued for upload.';
      });
      return;
    }

    _setUploading(true);

    final conflicts = <String>[];
    for (final item in candidates) {
      _updateItem(
        item.id,
        (current) => current.copyWith(
          status: UploadItemStatus.checkingPaths,
          progress: 0,
          uploadSpeedBytesPerSecond: 0,
          uploadedBytes: 0,
          totalBytes: 0,
          message: 'Checking destination path...',
        ),
      );

      final identityLabel = _itemIdentityLabel(item);
      try {
        final itemPath = _buildRemoteItemPath(item);
        final response = await api.getUploadApi().checkPathExists(directory: itemPath, folderPath: folder.fullPath);
        if (response?.exists == true) {
          final existingTitle = response?.libraryItemTitle;
          conflicts.add(
            existingTitle == null
                ? '$identityLabel (destination path exists)'
                : '$identityLabel (destination exists as "$existingTitle")',
          );
        }
      } catch (error, stackTrace) {
        logger(
          'Path check failed for upload: $error\n$stackTrace',
          tag: 'LibraryUploadPanel',
          level: InfoLevel.warning,
        );
        conflicts.add('$identityLabel (path check failed)');
      }

      _updateItem(
        item.id,
        (current) => current.copyWith(
          status: UploadItemStatus.ready,
          progress: 0,
          uploadSpeedBytesPerSecond: 0,
          uploadedBytes: 0,
          totalBytes: 0,
          clearMessage: true,
        ),
      );
    }

    if (conflicts.isNotEmpty) {
      final continueUpload = await _confirmPathConflicts(conflicts);
      if (!continueUpload) {
        _setUploading(false);
        setState(() {
          _panelMessage = 'Upload canceled after path conflict review.';
        });
        return;
      }
    }

    var uploaded = 0;
    var failed = 0;

    for (final item in candidates) {
      if (!mounted || !_isUploading) {
        break;
      }

      final status = await _uploadSingleItem(item, folder);
      if (status == UploadItemStatus.success) {
        uploaded += 1;
      } else if (status == UploadItemStatus.failed || status == UploadItemStatus.canceled) {
        failed += 1;
      }
    }

    if (!mounted) {
      return;
    }

    _setUploading(false);
    setState(() {
      _panelMessage = 'Upload finished. Success: $uploaded, failed/canceled: $failed.';
    });
  }

  void _applyBulkAuthor() {
    final author = _bulkAuthorController.text.trim();
    if (author.isEmpty) {
      return;
    }

    setState(() {
      _items = _items.map((item) => item.copyWith(author: author, clearPendingMetadata: true)).toList(growable: false);
      _panelMessage = 'Applied author "$author" to all queued items.';
    });
  }

  void _applyBulkSeries() {
    final series = _bulkSeriesController.text.trim();
    if (series.isEmpty) {
      return;
    }

    setState(() {
      _items = _items.map((item) => item.copyWith(series: series, clearPendingMetadata: true)).toList(growable: false);
      _panelMessage = 'Applied series "$series" to all queued items.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final metadataProvidersAsync = ref.watch(uploadMetadataProvidersProvider(widget.selectedLibrary.mediaType));
    final metadataProviders = metadataProvidersAsync.value ?? const <SearchProviderOption>[];

    if (_selectedProvider == null && metadataProviders.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _selectedProvider != null) {
          return;
        }
        setState(() {
          _selectedProvider = metadataProviders.first.value;
        });
      });
    }

    final hasQueuedItems = _items.any((item) => item.uploadFiles.isNotEmpty);
    final currentUser = ref.watch(currentUserProvider).value;
    final isAdminUser = _isAdminType(currentUser?.type);
    final canUseAutocomplete = isAdminUser && _autocompleteSeriesAndAuthors;

    if (!isAdminUser && _autocompleteSeriesAndAuthors) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _autocompleteSeriesAndAuthors = false;
        });
        unawaited(_refreshFolderAutocompleteSuggestions(force: true));
      });
    }

    final selectedFolderPath = _selectedFolder?.fullPath.trim();
    if (canUseAutocomplete &&
        !_isLoadingAutocompleteSuggestions &&
        selectedFolderPath != null &&
        selectedFolderPath.isNotEmpty &&
        _loadedAutocompleteFolderPath != selectedFolderPath) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(_refreshFolderAutocompleteSuggestions(force: true));
      });
    }

    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = context.isMobile;

    return Material(
      color: colorScheme.surface,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Builder(
              builder: (context) {
                final content = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: 'Back',
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Upload to ${widget.selectedLibrary.name}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final canApplyBulk = !_isUploading && hasQueuedItems;

                        final dropdownRow = Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: YaabsaDropdownField<String>(
                                label: 'Library folder',
                                value: _selectedFolder?.id,
                                onChanged: _isUploading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedFolderId = value;
                                          _loadedAutocompleteFolderPath = null;
                                        });
                                        unawaited(_refreshFolderAutocompleteSuggestions(force: true));
                                      },
                                items: _folders
                                    .map(
                                      (folder) => DropdownMenuItem<String>(
                                        value: folder.id,
                                        child: Text(folder.fullPath, overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                    .toList(growable: false),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: YaabsaDropdownField<String>(
                                label: 'Metadata provider',
                                value: _selectedProvider,
                                onChanged: _isUploading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _selectedProvider = value;
                                        });
                                      },
                                items: [
                                  if (_selectedProvider != null &&
                                      _selectedProvider!.isNotEmpty &&
                                      !metadataProviders.any((option) => option.value == _selectedProvider))
                                    DropdownMenuItem<String>(value: _selectedProvider, child: Text(_selectedProvider!)),
                                  ...metadataProviders.map(
                                    (option) => DropdownMenuItem<String>(
                                      value: option.value,
                                      child: Text(option.text, overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );

                        final advancedBulkSection = Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                            child: ExpansionTile(
                              tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                              childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                              title: const Text('Advanced options'),
                              children: [
                                LayoutBuilder(
                                  builder: (context, advancedConstraints) {
                                    final canShowSideBySide = advancedConstraints.maxWidth > 840;

                                    final settingsCard = Container(
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Settings',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          SettingsToggleRow(
                                            label: 'Auto-fetch metadata',
                                            value: _autoFetchMetadata,
                                            enabled: !_isUploading,
                                            onChanged: (selected) {
                                              setState(() {
                                                _autoFetchMetadata = selected;
                                              });
                                            },
                                          ),
                                          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.35), height: 1),
                                          const SizedBox(height: 4),
                                          SettingsToggleRow(
                                            label: 'Auto-accept metadata',
                                            value: _autoAcceptMetadata,
                                            enabled: !_isUploading,
                                            onChanged: (selected) {
                                              setState(() {
                                                _autoAcceptMetadata = selected;
                                              });
                                            },
                                          ),
                                          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.35), height: 1),
                                          const SizedBox(height: 4),
                                          SettingsToggleRow(
                                            label: 'Autocomplete series and authors',
                                            value: canUseAutocomplete,
                                            enabled: isAdminUser && !_isUploading,
                                            onChanged: (selected) {
                                              setState(() {
                                                _autocompleteSeriesAndAuthors = selected;
                                                _loadedAutocompleteFolderPath = null;
                                              });
                                              unawaited(_refreshFolderAutocompleteSuggestions(force: true));
                                            },
                                          ),
                                          if (!isAdminUser) ...[
                                            const SizedBox(height: 6),
                                            Text(
                                              'Requires admin role.',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                            ),
                                          ],
                                          if (canUseAutocomplete && _isLoadingAutocompleteSuggestions) ...[
                                            const SizedBox(height: 8),
                                            const LinearProgressIndicator(minHeight: 2),
                                          ],
                                        ],
                                      ),
                                    );

                                    final bulkCard = Container(
                                      decoration: BoxDecoration(
                                        color: colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.34)),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Bulk update queue metadata',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 8),
                                          LayoutBuilder(
                                            builder: (context, bulkConstraints) {
                                              final compactBulk = bulkConstraints.maxWidth < 700;

                                              if (compactBulk) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: StyledTextField(
                                                            label: 'Author for all items',
                                                            controller: _bulkAuthorController,
                                                            enabled: !_isUploading,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        SizedBox(
                                                          height: 32,
                                                          child: FilledButton.tonal(
                                                            style: FilledButton.styleFrom(
                                                              visualDensity: VisualDensity.compact,
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            ),
                                                            onPressed: canApplyBulk ? _applyBulkAuthor : null,
                                                            child: const Text('Apply author'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Expanded(
                                                          child: StyledTextField(
                                                            label: 'Series for all items',
                                                            controller: _bulkSeriesController,
                                                            enabled: !_isUploading,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 8),
                                                        SizedBox(
                                                          height: 32,
                                                          child: FilledButton.tonal(
                                                            style: FilledButton.styleFrom(
                                                              visualDensity: VisualDensity.compact,
                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                            ),
                                                            onPressed: canApplyBulk ? _applyBulkSeries : null,
                                                            child: const Text('Apply series'),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }

                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: StyledTextField(
                                                          label: 'Author for all items',
                                                          controller: _bulkAuthorController,
                                                          enabled: !_isUploading,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      SizedBox(
                                                        width: 115,
                                                        height: 32,
                                                        child: FilledButton.tonal(
                                                          style: FilledButton.styleFrom(
                                                            visualDensity: VisualDensity.compact,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                                          ),
                                                          onPressed: canApplyBulk ? _applyBulkAuthor : null,
                                                          child: const Text('Apply author'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: StyledTextField(
                                                          label: 'Series for all items',
                                                          controller: _bulkSeriesController,
                                                          enabled: !_isUploading,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      SizedBox(
                                                        width: 115,
                                                        height: 32,
                                                        child: FilledButton.tonal(
                                                          style: FilledButton.styleFrom(
                                                            visualDensity: VisualDensity.compact,
                                                            padding: const EdgeInsets.symmetric(horizontal: 8),
                                                          ),
                                                          onPressed: canApplyBulk ? _applyBulkSeries : null,
                                                          child: const Text('Apply series'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );

                                    if (!canShowSideBySide) {
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [settingsCard, const SizedBox(height: 10), bulkCard],
                                      );
                                    }

                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 300, child: settingsCard),
                                        const SizedBox(width: 10),
                                        Expanded(child: bulkCard),
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );

                        return Column(children: [dropdownRow, const SizedBox(height: 8), advancedBulkSection]);
                      },
                    ),
                    const SizedBox(height: 10),
                    _buildDropArea(context),
                    const SizedBox(height: 10),
                    if (isMobile)
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _isUploading
                                ? null
                                : () {
                                    setState(() {
                                      _items = const [];
                                      _panelMessage = 'Upload queue cleared.';
                                    });
                                  },
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('Clear queue'),
                          ),
                          if (_isUploading)
                            FilledButton.tonalIcon(
                              onPressed: () {
                                _cancelAllUploads('Upload canceled by user.');
                                _setUploading(false);
                                setState(() {
                                  _panelMessage = 'Upload cancellation requested.';
                                });
                              },
                              icon: const Icon(Icons.stop_circle_outlined),
                              label: const Text('Cancel uploads'),
                            ),
                          FilledButton.icon(
                            onPressed: (!_isUploading && hasQueuedItems) ? _startUpload : null,
                            icon: const Icon(Icons.cloud_upload_rounded),
                            label: const Text('Start upload'),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          OutlinedButton.icon(
                            onPressed: _isUploading
                                ? null
                                : () {
                                    setState(() {
                                      _items = const [];
                                      _panelMessage = 'Upload queue cleared.';
                                    });
                                  },
                            icon: const Icon(Icons.delete_sweep_outlined),
                            label: const Text('Clear queue'),
                          ),
                          if (_isUploading) ...[
                            const SizedBox(width: 8),
                            FilledButton.tonalIcon(
                              onPressed: () {
                                _cancelAllUploads('Upload canceled by user.');
                                _setUploading(false);
                                setState(() {
                                  _panelMessage = 'Upload cancellation requested.';
                                });
                              },
                              icon: const Icon(Icons.stop_circle_outlined),
                              label: const Text('Cancel uploads'),
                            ),
                          ],
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: (!_isUploading && hasQueuedItems) ? _startUpload : null,
                            icon: const Icon(Icons.cloud_upload_rounded),
                            label: const Text('Start upload'),
                          ),
                        ],
                      ),
                    if (_panelMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(_panelMessage!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                    const SizedBox(height: 10),
                    if (_items.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Center(
                          child: Text(
                            'Upload queue is empty. Add files or folders using the drop area above.',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          final normalizedAuthor = item.author.trim().toLowerCase();
                          if (canUseAutocomplete &&
                              normalizedAuthor.isNotEmpty &&
                              _authorDirectoryPathsByName.containsKey(normalizedAuthor) &&
                              !_seriesAutocompleteByAuthor.containsKey(normalizedAuthor)) {
                            unawaited(_loadSeriesSuggestionsForAuthor(item.author));
                          }

                          return LibraryUploadItemCard(
                            item: item,
                            enabled: !_isUploading,
                            canFetchMetadata: !_isUploading,
                            authorSuggestions: canUseAutocomplete ? _authorAutocompleteOptions : const <String>[],
                            seriesSuggestions: canUseAutocomplete
                                ? _seriesSuggestionsForAuthor(item.author)
                                : const <String>[],
                            onChanged: (updatedItem) {
                              _updateItem(item.id, (_) => updatedItem);
                              if (canUseAutocomplete && item.author.trim() != updatedItem.author.trim()) {
                                unawaited(_loadSeriesSuggestionsForAuthor(updatedItem.author));
                              }
                            },
                            onRemove: () {
                              setState(() {
                                _items = _items.where((entry) => entry.id != item.id).toList(growable: false);
                              });
                            },
                            onFetchMetadata: () => _fetchMetadataForItem(item.id),
                            onAcceptPendingMetadata: () => _acceptPendingMetadata(item.id),
                            onRejectPendingMetadata: () => _rejectPendingMetadata(item.id),
                          );
                        },
                      ),
                  ],
                );

                return SingleChildScrollView(child: content);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropArea(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dropBody = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDropHovering ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: _isDropHovering ? 1.6 : 1,
        ),
        color: _isDropHovering
            ? colorScheme.primaryContainer.withValues(alpha: 0.28)
            : colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(_isDropHovering ? Icons.move_to_inbox_rounded : Icons.upload_file_rounded, size: 26),
          const SizedBox(height: 8),
          Text(
            _supportsDragDrop ? 'Drop files or folders here, or choose them below.' : 'Choose files or a folder below.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: _isUploading ? null : _pickFiles,
                icon: const Icon(Icons.file_open_rounded),
                label: const Text('Choose files'),
              ),
              OutlinedButton.icon(
                onPressed: _isUploading ? null : _pickFolder,
                icon: const Icon(Icons.folder_open_rounded),
                label: const Text('Choose folder'),
              ),
            ],
          ),
        ],
      ),
    );

    if (!_supportsDragDrop) {
      return dropBody;
    }

    return DropTarget(
      onDragEntered: (_) {
        setState(() {
          _isDropHovering = true;
        });
      },
      onDragExited: (_) {
        setState(() {
          _isDropHovering = false;
        });
      },
      onDragDone: (details) async {
        setState(() {
          _isDropHovering = false;
        });
        await _handleDropDone(details.files);
      },
      child: dropBody,
    );
  }
}

class _UploadProgressSample {
  const _UploadProgressSample({
    required this.sentBytes,
    required this.startedAt,
    required this.lastUpdateAt,
    required this.lastUiUpdateAt,
    required this.smoothedBytesPerSecond,
  });

  factory _UploadProgressSample.start(DateTime now) {
    return _UploadProgressSample(
      sentBytes: 0,
      startedAt: now,
      lastUpdateAt: now,
      lastUiUpdateAt: now,
      smoothedBytesPerSecond: 0,
    );
  }

  final int sentBytes;
  final DateTime startedAt;
  final DateTime lastUpdateAt;
  final DateTime lastUiUpdateAt;
  final double smoothedBytesPerSecond;
}

extension _FirstWhereOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }
}
