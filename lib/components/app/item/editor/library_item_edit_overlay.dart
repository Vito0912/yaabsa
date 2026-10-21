import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';
import 'package:yaabsa/components/app/item/editor/library_item_embedding_view.dart';
import 'package:yaabsa/components/app/item/editor/chapters/library_item_chapter_editor.dart';
import 'package:yaabsa/components/app/item/editor/library_item_encoder_view.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_models.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_form.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_shell.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_dialog.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/server_tasks_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/interceptors/cache_interceptor.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/server_management_preferences.dart';

enum LibraryItemEditorTab { details, chapters, match, embedding, encoder }

class LibraryItemEditOverlay extends ConsumerStatefulWidget {
  const LibraryItemEditOverlay({
    super.key,
    required this.orderedItemIds,
    required this.currentItemId,
    required this.onSelectItem,
    required this.onClose,
    required this.onItemSaved,
    this.filterData,
    this.initialTab = LibraryItemEditorTab.details,
  });

  final List<String> orderedItemIds;
  final String currentItemId;
  final ValueChanged<String> onSelectItem;
  final VoidCallback onClose;
  final Future<void> Function(String itemId, LibraryItem? updatedItem) onItemSaved;
  final LibraryFilterData? filterData;
  final LibraryItemEditorTab initialTab;

  @override
  ConsumerState<LibraryItemEditOverlay> createState() => _LibraryItemEditOverlayState();
}

class _LibraryItemEditOverlayState extends ConsumerState<LibraryItemEditOverlay> {
  var _isSaving = false;
  var _chapterEditorKey = GlobalKey<LibraryItemChapterEditorState>();
  final Map<String, LibraryItem> _cachedItems = <String, LibraryItem>{};
  final Map<String, Map<String, dynamic>> _metadataObjectsByItemId = <String, Map<String, dynamic>>{};
  final Set<String> _metadataLoadingItemIds = <String>{};
  final Set<String> _refreshingItemIds = <String>{};
  final Set<String> _encoderSeededItemIds = <String>{};
  final Map<String, String?> _encoderCurrentEncodingHintsByItemId = <String, String?>{};

  var _isEmbedding = false;
  var _isEncoding = false;
  var _isCancelingEncode = false;

  var _backupAudioFiles = true;
  var _forceEmbedChapters = false;
  var _encoderAdvancedMode = false;
  var _encoderCodec = 'aac';
  var _encoderBitrate = '128k';
  var _encoderChannels = 2;

  String? _toolErrorMessage;

  late LibraryItemEditorTab _selectedTab;

  int get _currentIndex => widget.orderedItemIds.indexOf(widget.currentItemId);

  bool get _hasPrevious => _currentIndex > 0;
  bool get _hasNext => _currentIndex >= 0 && _currentIndex < widget.orderedItemIds.length - 1;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTab;
    _preloadAdjacentItems();
    unawaited(_refreshItemFromServer(widget.currentItemId));
  }

  @override
  void didUpdateWidget(covariant LibraryItemEditOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentItemId != widget.currentItemId) {
      _chapterEditorKey = GlobalKey<LibraryItemChapterEditorState>();
      _selectedTab = LibraryItemEditorTab.details;
      _toolErrorMessage = null;
      _isEmbedding = false;
      _isEncoding = false;
      _isCancelingEncode = false;
      _preloadAdjacentItems();
      unawaited(_refreshItemFromServer(widget.currentItemId));
    }
  }

  bool _isAdminType(String? userType) {
    final normalizedType = (userType ?? '').trim().toLowerCase();
    return normalizedType == 'admin' || normalizedType == 'root';
  }

  bool _canUseBookTools(LibraryItem item, String? userType) {
    if (!_isAdminType(userType)) {
      return false;
    }

    final mediaType = (item.mediaType ?? '').toLowerCase();
    if (mediaType != 'book') {
      return false;
    }

    if (item.isMissing == true || item.isInvalid == true) {
      return false;
    }

    final audioFiles = item.media?.bookMedia?.audioFiles ?? const <AudioFile>[];
    return audioFiles.any((file) => file.exclude != true);
  }

  List<LibraryItemEditorTab> _availableTabsForItem(
    LibraryItem? item,
    String? userType,
    bool canUseMatchTools,
    bool canEditItems,
  ) {
    if (item == null) {
      return const <LibraryItemEditorTab>[LibraryItemEditorTab.details];
    }

    final tabs = <LibraryItemEditorTab>[LibraryItemEditorTab.details];
    if (canEditItems &&
        item.media?.bookMedia != null &&
        ((item.media?.bookMedia?.duration ?? 0) > 0 ||
            (item.media?.bookMedia?.audioFiles ?? const <AudioFile>[]).any((file) => file.exclude != true))) {
      tabs.add(LibraryItemEditorTab.chapters);
    }
    if (canUseMatchTools) {
      tabs.add(LibraryItemEditorTab.match);
    }
    if (_canUseBookTools(item, userType)) {
      tabs.add(LibraryItemEditorTab.embedding);
      tabs.add(LibraryItemEditorTab.encoder);
    }

    return tabs;
  }

  String _tabTitle(LibraryItemEditorTab tab) {
    switch (tab) {
      case LibraryItemEditorTab.details:
        return 'Details';
      case LibraryItemEditorTab.chapters:
        return 'Chapters';
      case LibraryItemEditorTab.match:
        return 'Match';
      case LibraryItemEditorTab.embedding:
        return 'Embedding';
      case LibraryItemEditorTab.encoder:
        return 'Encoder';
    }
  }

  void _seedEncoderDefaultsIfNeeded({required String itemId, required List<AudioFile> audioFiles}) {
    if (_encoderSeededItemIds.contains(itemId) || audioFiles.isEmpty) {
      return;
    }

    final codecs = audioFiles
        .map((file) => (file.codec ?? '').trim().toLowerCase())
        .where((value) => value.isNotEmpty)
        .toSet();
    _encoderCurrentEncodingHintsByItemId[itemId] = describeCurrentEncoding(audioFiles);

    if (codecs.first == 'aac' || codecs.first == 'opus') {
      _encoderCodec = 'copy';
    } else {
      _encoderCodec = 'aac';
    }

    final bitrates = audioFiles.map((file) => file.bitRate ?? 0).where((value) => value > 0).toList(growable: false);
    if (bitrates.isNotEmpty) {
      final averageKbps = bitrates.reduce((a, b) => a + b) / bitrates.length / 1000;
      const bitrateCandidates = <int>[32, 64, 128, 192];
      final selected = bitrateCandidates.firstWhere((value) => averageKbps <= value, orElse: () => 192);
      _encoderBitrate = '${selected}k';
    } else {
      _encoderBitrate = '128k';
    }

    final maxChannels = audioFiles.fold<int>(2, (current, file) {
      final channels = file.channels ?? current;
      return math.max(current, channels);
    });
    _encoderChannels = maxChannels.clamp(1, 2).toInt();

    _encoderSeededItemIds.add(itemId);
  }

  Future<void> _loadMetadataObject(String itemId, {bool forceRefresh = false}) async {
    if (!forceRefresh && _metadataObjectsByItemId.containsKey(itemId)) {
      return;
    }

    if (_metadataLoadingItemIds.contains(itemId)) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        setState(() {
          _toolErrorMessage = 'No server connection available.';
        });
      }
      return;
    }

    setState(() {
      _metadataLoadingItemIds.add(itemId);
      _toolErrorMessage = null;
    });

    try {
      final response = await api.getLibraryItemApi().getLibraryItemMetadataObject(itemId);
      if (!mounted) {
        return;
      }

      setState(() {
        _metadataObjectsByItemId[itemId] = response.data ?? <String, dynamic>{};
      });
    } catch (error, stackTrace) {
      logger(
        'Failed to load metadata object. itemId=$itemId, error=$error',
        tag: 'LibraryItemEditOverlay',
        level: InfoLevel.error,
      );
      logger(
        'Stack trace for metadata object load failure. itemId=$itemId, stackTrace=$stackTrace',
        tag: 'LibraryItemEditOverlay',
        level: InfoLevel.debug,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _toolErrorMessage = 'Failed to load metadata object: ${_extractApiMessage(error)}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _metadataLoadingItemIds.remove(itemId);
        });
      }
    }
  }

  Future<void> _startEmbedding(LibraryItem item) async {
    if (_isEmbedding) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _toolErrorMessage = 'No server connection available.';
      });
      return;
    }

    setState(() {
      _isEmbedding = true;
      _toolErrorMessage = null;
    });

    try {
      await api.getLibraryItemApi().startEmbedMetadata(
        item.id,
        backup: _backupAudioFiles,
        forceEmbedChapters: _forceEmbedChapters,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _toolErrorMessage = 'Failed to start embedding: ${_extractApiMessage(error)}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isEmbedding = false;
        });
      }
    }
  }

  Future<void> _startEncoding(LibraryItem item) async {
    if (_isEncoding) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _toolErrorMessage = 'No server connection available.';
      });
      return;
    }

    setState(() {
      _isEncoding = true;
      _toolErrorMessage = null;
    });

    try {
      await api.getLibraryItemApi().startEncodeM4b(
        item.id,
        codec: _encoderCodec,
        bitrate: _encoderBitrate,
        channels: _encoderChannels,
      );

      if (!mounted) {
        return;
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _toolErrorMessage = 'Failed to start M4B encoding: ${_extractApiMessage(error)}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isEncoding = false;
        });
      }
    }
  }

  Future<void> _cancelEncoding(LibraryItem item) async {
    if (_isCancelingEncode) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _toolErrorMessage = 'No server connection available.';
      });
      return;
    }

    setState(() {
      _isCancelingEncode = true;
      _toolErrorMessage = null;
    });

    try {
      await api.getLibraryItemApi().cancelEncodeM4b(item.id);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _toolErrorMessage = 'Failed to cancel encoding: ${_extractApiMessage(error)}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isCancelingEncode = false;
        });
      }
    }
  }

  String _extractApiMessage(Object error) {
    if (error is DioException) {
      final responseData = error.response?.data;
      if (responseData is String && responseData.trim().isNotEmpty) {
        return responseData.trim();
      }
      if (responseData is Map && responseData['message'] is String) {
        final message = (responseData['message'] as String).trim();
        if (message.isNotEmpty) {
          return message;
        }
      }

      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        return 'Request failed ($statusCode).';
      }

      final dioMessage = error.message;
      if (dioMessage != null && dioMessage.trim().isNotEmpty) {
        return dioMessage.trim();
      }
    }

    return error.toString();
  }

  AbsTask? _latestTaskForAction(List<AbsTask> tasks, String action) {
    for (final task in tasks) {
      if (task.action == action) {
        return task;
      }
    }
    return null;
  }

  String? _taskFailureMessage(AbsTask? task, {required String fallback}) {
    if (task == null || !task.isFinished || !task.isFailed) {
      return null;
    }

    final taskError = task.error?.trim();
    if (taskError != null && taskError.isNotEmpty) {
      return taskError;
    }

    return fallback;
  }

  void _preloadAdjacentItems() {
    unawaited(_preloadItem(widget.currentItemId));

    if (_hasPrevious) {
      final previousId = widget.orderedItemIds[_currentIndex - 1];
      unawaited(_preloadItem(previousId));
    }

    if (_hasNext) {
      final nextId = widget.orderedItemIds[_currentIndex + 1];
      unawaited(_preloadItem(nextId));
    }
  }

  Future<void> _preloadItem(String itemId) async {
    try {
      final item = await ref.read(libraryItemProvider(itemId).future);
      if (!mounted) {
        return;
      }

      setState(() {
        _cachedItems[itemId] = item;
      });
    } catch (_) {}
  }

  Future<void> _refreshItemFromServer(String itemId) async {
    if (_refreshingItemIds.contains(itemId)) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      return;
    }

    _refreshingItemIds.add(itemId);
    try {
      final response = await api.getLibraryItemApi().getLibraryItem(itemId: itemId);
      final freshItem = response.data;
      if (freshItem == null || !mounted) {
        return;
      }

      setState(() {
        _cachedItems[itemId] = freshItem;
        _encoderSeededItemIds.remove(itemId);
        _encoderCurrentEncodingHintsByItemId.remove(itemId);
      });

      await processLibraryItemUpdate(container: ref.container, item: freshItem, source: 'editor.open.refresh');
    } catch (error, stackTrace) {
      logger(
        'Failed to refresh item from server on editor open. itemId=$itemId, error=$error',
        tag: 'LibraryItemEditOverlay',
        level: InfoLevel.warning,
      );
      logger(
        'Stack trace for editor open refresh failure. itemId=$itemId, stackTrace=$stackTrace',
        tag: 'LibraryItemEditOverlay',
        level: InfoLevel.debug,
      );
    } finally {
      _refreshingItemIds.remove(itemId);
    }
  }

  Future<void> _saveChanges(LibraryItemEditorDiff diff) async {
    if (_isSaving) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No server connection available.')));
      }
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final response = await api.getLibraryItemApi().updateLibraryItemMedia(
        widget.currentItemId,
        request: diff.request,
      );
      final payload = response.data;

      if (payload == null || (!payload.updated && payload.libraryItem == null)) {
        throw Exception('Update request failed.');
      }

      final updatedItem = payload.libraryItem;
      if (updatedItem != null) {
        _cachedItems[widget.currentItemId] = updatedItem;
        _encoderSeededItemIds.remove(widget.currentItemId);
        _encoderCurrentEncodingHintsByItemId.remove(widget.currentItemId);
        await processLibraryItemUpdate(container: ref.container, item: updatedItem, source: 'editor.save');
      } else {
        unawaited(invalidateCachedLibraryItemEntries(container: ref.container, itemId: widget.currentItemId));
      }
      await widget.onItemSaved(widget.currentItemId, updatedItem);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved item details.')));
    } catch (error, stackTrace) {
      logger(
        'Could not save item details. itemId=${widget.currentItemId}, error=$error',
        tag: 'LibraryItemEditOverlay',
        level: InfoLevel.error,
      );
      logger(
        'Stack trace for save failure. itemId=${widget.currentItemId}, stackTrace=$stackTrace',
        tag: 'LibraryItemEditOverlay',
        level: InfoLevel.debug,
      );

      if (!mounted) {
        return;
      }

      final rawError = error.toString().trim();
      final fallback = rawError.isEmpty ? 'Could not save item details.' : 'Could not save item details: $rawError';
      final message = listManagementErrorMessage(error, fallback: fallback);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<bool> _mayLeaveChapters() async {
    final editor = _chapterEditorKey.currentState;
    return editor == null || await editor.requestLeave();
  }

  Future<void> _requestClose() async {
    if (await _mayLeaveChapters() && mounted) {
      widget.onClose();
    }
  }

  Future<void> _selectEditorItem(String itemId) async {
    if (await _mayLeaveChapters() && mounted) {
      widget.onSelectItem(itemId);
    }
  }

  Future<void> _selectEditorTab(LibraryItemEditorTab tab, LibraryItem? item) async {
    if (tab != _selectedTab && !await _mayLeaveChapters()) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedTab = tab;
      _toolErrorMessage = null;
    });
    if (tab == LibraryItemEditorTab.embedding && item != null) {
      unawaited(_loadMetadataObject(item.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUser = currentUserAsync.value;
    final currentUserType = currentUser?.type;

    final watchedItemAsync = ref.watch(libraryItemProvider(widget.currentItemId));
    final watchedItem = watchedItemAsync.asData?.value;
    if (watchedItem != null) {
      _cachedItems[widget.currentItemId] = watchedItem;
    }

    final cachedItem = _cachedItems[widget.currentItemId];
    final itemAsync = cachedItem != null ? AsyncValue.data(cachedItem) : watchedItemAsync;
    final activeItem = itemAsync.asData?.value;

    final serverTaskState = ref.watch(serverTasksProvider);
    final activeItemId = activeItem?.id;
    final itemTasks = activeItemId == null
        ? const <AbsTask>[]
        : serverTaskState.tasks.where((task) => task.data?.libraryItemId == activeItemId).toList(growable: false);
    final embedTask = _latestTaskForAction(itemTasks, 'embed-metadata');
    final encodeTask = _latestTaskForAction(itemTasks, 'encode-m4b');
    final isEmbedTaskQueued = activeItemId != null && serverTaskState.queuedEmbedLibraryItemIds.contains(activeItemId);
    final isEmbedTaskRunning = embedTask != null && !embedTask.isFinished;
    final isEncodeTaskRunning = encodeTask != null && !encodeTask.isFinished;
    final taskProgressLabel = activeItemId == null ? null : serverTaskState.taskProgressByLibraryItem[activeItemId];
    final encodingProgressByIno = activeItemId == null
        ? const <String, String>{}
        : serverTaskState.audioFilesEncoding[activeItemId] ?? const <String, String>{};
    final encodingFinishedByIno = activeItemId == null
        ? const <String, bool>{}
        : serverTaskState.audioFilesFinished[activeItemId] ?? const <String, bool>{};

    final localErrorMessage = _toolErrorMessage?.trim();

    final embeddingErrorMessage = (localErrorMessage != null && localErrorMessage.isNotEmpty)
        ? localErrorMessage
        : _taskFailureMessage(embedTask, fallback: 'Embedding task failed.');

    final encodingErrorMessage = (localErrorMessage != null && localErrorMessage.isNotEmpty)
        ? localErrorMessage
        : _taskFailureMessage(encodeTask, fallback: 'M4B encoding task failed.');

    final managementPreferences = readServerManagementPreferences(ref, currentUser?.id);
    final canEditItems = (currentUser?.permissions.update ?? false) && managementPreferences.editItemsEnabled;
    final canUseMatchTools = canEditItems && managementPreferences.allowMatchesQuickMatchesEnabled;

    final availableTabs = _availableTabsForItem(activeItem, currentUserType, canUseMatchTools, canEditItems);
    final selectedTab = availableTabs.contains(_selectedTab) ? _selectedTab : availableTabs.first;

    if (activeItem != null && selectedTab == LibraryItemEditorTab.embedding) {
      final shouldLoad =
          !_metadataObjectsByItemId.containsKey(activeItem.id) && !_metadataLoadingItemIds.contains(activeItem.id);
      if (shouldLoad) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          unawaited(_loadMetadataObject(activeItem.id));
        });
      }
    }

    if (activeItem != null && availableTabs.contains(LibraryItemEditorTab.encoder)) {
      final audioFiles = (activeItem.media?.bookMedia?.audioFiles ?? const <AudioFile>[])
          .where((file) => file.exclude != true)
          .toList(growable: false);
      _seedEncoderDefaultsIfNeeded(itemId: activeItem.id, audioFiles: audioFiles);
    }

    final currentEncodingHint = activeItem == null ? null : _encoderCurrentEncodingHintsByItemId[activeItem.id];

    return Positioned.fill(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            unawaited(_requestClose());
          }
        },
        child: Focus(
          autofocus: true,
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
              unawaited(_requestClose());
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Material(
            color: Colors.black.withValues(alpha: 0.52),
            child: SafeArea(
              minimum: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => unawaited(_requestClose()),
                behavior: HitTestBehavior.opaque,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final maxWidth = context.isDesktop
                        ? constraints.maxWidth * 0.88
                        : context.isTablet
                        ? constraints.maxWidth * 0.94
                        : constraints.maxWidth;
                    final maxHeight = context.isDesktop ? constraints.maxHeight * 0.9 : constraints.maxHeight;

                    return Center(
                      child: GestureDetector(
                        onTap: () {},
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(context.isMobile ? 18 : 24),
                            child: Material(
                              type: context.isMobile ? MaterialType.transparency : MaterialType.canvas,
                              color: context.isMobile ? null : Theme.of(context).colorScheme.surface,
                              shape: context.isMobile
                                  ? null
                                  : RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                      side: BorderSide(
                                        color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.8),
                                      ),
                                    ),
                              child: LibraryItemEditorShell(
                                itemTitle: activeItem?.media?.title ?? 'Item',
                                destinations: [
                                  for (final tab in availableTabs) (label: _tabTitle(tab), icon: _tabIcon(tab)),
                                ],
                                selectedIndex: availableTabs.indexOf(selectedTab),
                                onSelectDestination: (index) {
                                  unawaited(_selectEditorTab(availableTabs[index], activeItem));
                                },
                                onBackToSelector: () {
                                  unawaited(_chapterEditorKey.currentState?.stopPreview());
                                },
                                showItemNavigation: widget.orderedItemIds.length > 1,
                                onPreviousItem: _hasPrevious
                                    ? () => unawaited(_selectEditorItem(widget.orderedItemIds[_currentIndex - 1]))
                                    : null,
                                onNextItem: _hasNext
                                    ? () => unawaited(_selectEditorItem(widget.orderedItemIds[_currentIndex + 1]))
                                    : null,
                                onClose: () => unawaited(_requestClose()),
                                child: itemAsync.when(
                                  data: (item) {
                                    final audioFiles = (item.media?.bookMedia?.audioFiles ?? const <AudioFile>[])
                                        .where((file) => file.exclude != true)
                                        .toList(growable: false);
                                    final chapters = item.media?.bookMedia?.chapters ?? const <Chapter>[];

                                    switch (selectedTab) {
                                      case LibraryItemEditorTab.details:
                                        return LibraryItemEditorForm(
                                          key: ValueKey(item.id),
                                          item: item,
                                          filterData: widget.filterData,
                                          isSaving: _isSaving,
                                          onSave: _saveChanges,
                                          onClose: () => unawaited(_requestClose()),
                                        );
                                      case LibraryItemEditorTab.chapters:
                                        return LibraryItemChapterEditor(
                                          key: _chapterEditorKey,
                                          item: item,
                                          onSaved: (updatedItem) async {
                                            setState(() {
                                              _cachedItems[updatedItem.id] = updatedItem;
                                            });
                                            await widget.onItemSaved(updatedItem.id, updatedItem);
                                          },
                                        );
                                      case LibraryItemEditorTab.match:
                                        return LibraryItemManualMatchView(
                                          key: ValueKey('${item.id}-match'),
                                          item: item,
                                          filterData: widget.filterData,
                                          isFullScreen: true,
                                          onMatched: (updated) async {
                                            if (updated) {
                                              await widget.onItemSaved(item.id, null);
                                            }
                                            setState(() {
                                              _selectedTab = LibraryItemEditorTab.details;
                                            });
                                          },
                                          onCancel: () {
                                            setState(() {
                                              _selectedTab = LibraryItemEditorTab.details;
                                            });
                                          },
                                        );
                                      case LibraryItemEditorTab.embedding:
                                        return LibraryItemEmbeddingView(
                                          key: ValueKey('${item.id}-embedding'),
                                          audioFiles: audioFiles,
                                          chapters: chapters,
                                          metadataObject: _metadataObjectsByItemId[item.id],
                                          isMetadataLoading: _metadataLoadingItemIds.contains(item.id),
                                          isRequestInFlight: _isEmbedding,
                                          isTaskRunning: isEmbedTaskRunning,
                                          isTaskQueued: isEmbedTaskQueued,
                                          backupAudioFiles: _backupAudioFiles,
                                          forceEmbedChapters: _forceEmbedChapters,
                                          onBackupAudioFilesChanged: (value) {
                                            setState(() {
                                              _backupAudioFiles = value;
                                            });
                                          },
                                          onForceEmbedChaptersChanged: (value) {
                                            setState(() {
                                              _forceEmbedChapters = value;
                                            });
                                          },
                                          onRefreshMetadataObject: () =>
                                              unawaited(_loadMetadataObject(item.id, forceRefresh: true)),
                                          onStartEmbedding: () => unawaited(_startEmbedding(item)),
                                          errorMessage: embeddingErrorMessage,
                                        );
                                      case LibraryItemEditorTab.encoder:
                                        return LibraryItemEncoderView(
                                          key: ValueKey('${item.id}-encoder'),
                                          audioFiles: audioFiles,
                                          advancedMode: _encoderAdvancedMode,
                                          codec: _encoderCodec,
                                          bitrate: _encoderBitrate,
                                          channels: _encoderChannels,
                                          isStarting: _isEncoding,
                                          isTaskRunning: isEncodeTaskRunning,
                                          isCanceling: _isCancelingEncode,
                                          currentEncodingHint: currentEncodingHint,
                                          encodingProgressByIno: encodingProgressByIno,
                                          encodingFinishedByIno: encodingFinishedByIno,
                                          onAdvancedModeChanged: (value) {
                                            setState(() {
                                              _encoderAdvancedMode = value;
                                            });
                                          },
                                          onCodecChanged: (value) {
                                            setState(() {
                                              _encoderCodec = value;
                                            });
                                          },
                                          onBitrateChanged: (value) {
                                            setState(() {
                                              _encoderBitrate = value;
                                            });
                                          },
                                          onChannelsChanged: (value) {
                                            setState(() {
                                              _encoderChannels = value;
                                            });
                                          },
                                          onStartEncoding: () => unawaited(_startEncoding(item)),
                                          onCancelEncoding: () => unawaited(_cancelEncoding(item)),
                                          progressLabel: taskProgressLabel,

                                          errorMessage: encodingErrorMessage,
                                        );
                                    }
                                  },
                                  loading: () => const Center(child: CircularProgressIndicator()),
                                  error: (error, _) => Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'Could not load item details for editing.\n$error',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _tabIcon(LibraryItemEditorTab tab) {
    switch (tab) {
      case LibraryItemEditorTab.details:
        return Icons.edit_outlined;
      case LibraryItemEditorTab.chapters:
        return Icons.format_list_numbered_rounded;
      case LibraryItemEditorTab.match:
        return Icons.manage_search_rounded;
      case LibraryItemEditorTab.embedding:
        return Icons.playlist_add_check_rounded;
      case LibraryItemEditorTab.encoder:
        return Icons.audio_file_outlined;
    }
  }
}
