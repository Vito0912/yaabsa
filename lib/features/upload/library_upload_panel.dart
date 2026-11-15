import 'dart:async';
import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/library_folder.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_advanced_options.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_drop_zone.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_destination_fields.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_item_card.dart';
import 'package:yaabsa/features/upload/widgets/library_upload_queue_actions.dart';
import 'package:yaabsa/features/upload/widgets/upload_path_conflict_dialog.dart';
import 'package:yaabsa/features/upload/library_upload_models.dart';
import 'package:yaabsa/features/upload/upload_metadata_parser.dart';
import 'package:yaabsa/features/upload/upload_draft_factory.dart';
import 'package:yaabsa/features/upload/upload_progress_tracker.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/ui/components/feedback/empty_state_card.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/player_utils.dart';

class LibraryUploadPanel extends ConsumerStatefulWidget {
  const LibraryUploadPanel({
    super.key,
    required this.selectedLibrary,
    required this.onClose,
    this.onUploadingChanged,
    this.advancedOptionsInitiallyExpanded = false,
  });

  final Library selectedLibrary;
  final VoidCallback onClose;
  final ValueChanged<bool>? onUploadingChanged;
  final bool advancedOptionsInitiallyExpanded;

  @override
  ConsumerState<LibraryUploadPanel> createState() => _LibraryUploadPanelState();
}

class _LibraryUploadPanelState extends ConsumerState<LibraryUploadPanel> {
  final TextEditingController _bulkAuthorController = TextEditingController();
  final TextEditingController _bulkSeriesController = TextEditingController();
  final Map<int, CancelToken> _cancelTokens = <int, CancelToken>{};
  final Map<int, UploadProgressTracker> _progressSamples = <int, UploadProgressTracker>{};

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
      final authorDirectories = authorResponse.data?.directories ?? const [];
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
      final seriesSuggestions = _sortedUniqueNames(
        (response.data?.directories ?? const []).map((entry) => entry.dirname),
      );

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

  int _takeNextItemId() {
    final nextId = _nextItemId;
    _nextItemId += 1;
    return nextId;
  }

  Future<void> _appendInputPaths(List<String> rawPaths) async {
    final draftFactory = UploadDraftFactory(isBookLibrary: _isBookLibrary, libraryName: widget.selectedLibrary.name);
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
        directFiles.add(draftFactory.classifyFile(absolutePath: path, relativePath: p.basename(path)));
      }
    }

    final createdItems = <UploadItemDraft>[];
    if (directFiles.isNotEmpty) {
      createdItems.addAll(draftFactory.buildDirectFileItems(directFiles, nextId: _takeNextItemId));
    }

    for (final folderPath in folders) {
      final item = await draftFactory.buildFolderItem(
        folderPath,
        existingAbsolutePaths: existingAbsolutePaths,
        nextId: _takeNextItemId,
      );
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
      _panelMessage = null;
      _items = <UploadItemDraft>[..._items, ...createdItems];
    });

    if (_autoFetchMetadata) {
      for (final item in createdItems) {
        if (item.itemFiles.isEmpty) {
          continue;
        }
        unawaited(_fetchMetadataForItem(item.id, silentNoResults: true));
      }
    }
  }

  Future<void> _pickFiles() async {
    if (_isUploading) {
      return;
    }

    final result = await FilePicker.pickFiles();
    final paths = result.map((file) => file.path).whereType<String>().toList(growable: false);
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
      builder: (context) => UploadPathConflictDialog(conflicts: conflicts),
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

      final firstResult = UploadMetadataParser.firstResult(response.data);
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
      final resolvedAuthor = UploadMetadataParser.author(firstResult) ?? item.author;
      final resolvedSeries = UploadMetadataParser.series(firstResult) ?? item.series;
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
            clearMessage: true,
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
            clearMessage: true,
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
        clearMessage: true,
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
      (current) => current.copyWith(status: UploadItemStatus.ready, clearPendingMetadata: true, clearMessage: true),
    );
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
      _progressSamples[item.id] = UploadProgressTracker.start(DateTime.now());
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

            final progressTracker = _progressSamples[item.id];
            if (progressTracker == null) {
              _progressSamples[item.id] = UploadProgressTracker.start(DateTime.now());
              return;
            }

            final update = progressTracker.update(sentBytes: sent, totalBytes: total, now: DateTime.now());
            if (update == null) {
              return;
            }

            _updateItem(
              item.id,
              (current) => current.copyWith(
                progress: update.progress,
                uploadSpeedBytesPerSecond: update.uploadSpeedBytesPerSecond,
                uploadedBytes: update.uploadedBytes,
                totalBytes: update.totalBytes,
                message: update.isComplete ? 'Upload complete. Waiting for server processing...' : null,
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
        if (response.data?.exists == true) {
          final existingTitle = response.data?.libraryItemTitle;
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
      _panelMessage = null;
    });
  }

  void _applyBulkSeries() {
    final series = _bulkSeriesController.text.trim();
    if (series.isEmpty) {
      return;
    }

    setState(() {
      _items = _items.map((item) => item.copyWith(series: series, clearPendingMetadata: true)).toList(growable: false);
      _panelMessage = null;
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
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;
    final isAdminUser = _isAdminType(currentUser?.type);
    final canUseAutocomplete = isAdminUser && _autocompleteSeriesAndAuthors;

    if (currentUserAsync.hasValue && !isAdminUser && _autocompleteSeriesAndAuthors) {
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
    return Material(
      color: colorScheme.surface,
      child: SingleChildScrollView(
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
                      Builder(
                        builder: (context) {
                          final canApplyBulk = !_isUploading && hasQueuedItems;

                          final destinationFields = LibraryUploadDestinationFields(
                            folderValue: _selectedFolder?.id,
                            providerValue: _selectedProvider,
                            folderItems: _folders
                                .map(
                                  (folder) => DropdownMenuItem<String>(
                                    value: folder.id,
                                    child: Text(folder.fullPath, overflow: TextOverflow.ellipsis),
                                  ),
                                )
                                .toList(growable: false),
                            providerItems: [
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
                            enabled: !_isUploading,
                            onFolderChanged: (value) {
                              setState(() {
                                _selectedFolderId = value;
                                _loadedAutocompleteFolderPath = null;
                              });
                              unawaited(_refreshFolderAutocompleteSuggestions(force: true));
                            },
                            onProviderChanged: (value) {
                              setState(() {
                                _selectedProvider = value;
                              });
                            },
                          );

                          final advancedBulkSection = LibraryUploadAdvancedOptions(
                            initiallyExpanded: widget.advancedOptionsInitiallyExpanded,
                            autoFetchMetadata: _autoFetchMetadata,
                            autoAcceptMetadata: _autoAcceptMetadata,
                            autocompleteSeriesAndAuthors: canUseAutocomplete,
                            enabled: !_isUploading,
                            canEditAutocomplete: isAdminUser && !_isUploading,
                            isAdminUser: isAdminUser,
                            isLoadingAutocompleteSuggestions: _isLoadingAutocompleteSuggestions,
                            canApplyBulk: canApplyBulk,
                            bulkAuthorController: _bulkAuthorController,
                            bulkSeriesController: _bulkSeriesController,
                            onAutoFetchMetadataChanged: (selected) {
                              setState(() {
                                _autoFetchMetadata = selected;
                              });
                            },
                            onAutoAcceptMetadataChanged: (selected) {
                              setState(() {
                                _autoAcceptMetadata = selected;
                              });
                            },
                            onAutocompleteChanged: (selected) {
                              setState(() {
                                _autocompleteSeriesAndAuthors = selected;
                                _loadedAutocompleteFolderPath = null;
                              });
                              unawaited(_refreshFolderAutocompleteSuggestions(force: true));
                            },
                            onApplyAuthor: _applyBulkAuthor,
                            onApplySeries: _applyBulkSeries,
                          );

                          return Column(children: [destinationFields, const SizedBox(height: 8), advancedBulkSection]);
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildDropArea(),
                      const SizedBox(height: 6),
                      LibraryUploadQueueActions(
                        isUploading: _isUploading,
                        hasQueuedItems: hasQueuedItems,
                        onClear: () {
                          setState(() {
                            _items = const [];
                            _panelMessage = null;
                          });
                        },
                        onCancel: _isUploading
                            ? () {
                                _cancelAllUploads('Upload canceled by user.');
                                _setUploading(false);
                                setState(() {
                                  _panelMessage = null;
                                });
                              }
                            : null,
                        onStart: _startUpload,
                      ),
                      if (_panelMessage != null) ...[
                        const SizedBox(height: 8),
                        Text(_panelMessage!, style: Theme.of(context).textTheme.bodySmall),
                      ],
                      const SizedBox(height: 10),
                      if (_items.isEmpty)
                        YaabsaEmptyStateCard(
                          key: const ValueKey<String>('uploadQueueEmptyState'),
                          icon: Icons.drive_folder_upload_outlined,
                          title: 'Your queue is empty',
                          centered: true,
                          compact: true,
                        )
                      else ...[
                        ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: ListView.separated(
                            shrinkWrap: true,
                            primary: false,
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
                        ),
                      ],
                    ],
                  );

                  return content;
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropArea() {
    final dropBody = LibraryUploadDropZone(
      supportsDragDrop: _supportsDragDrop,
      isDropHovering: _isDropHovering,
      enabled: !_isUploading,
      onChooseFiles: _pickFiles,
      onChooseFolder: _pickFolder,
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

extension _FirstWhereOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) {
      return null;
    }
    return first;
  }
}
