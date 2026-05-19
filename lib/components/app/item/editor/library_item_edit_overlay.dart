import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_data.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/chapter.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';
import 'package:yaabsa/components/app/item/editor/library_item_embedding_view.dart';
import 'package:yaabsa/components/app/item/editor/library_item_encoder_view.dart';
import 'package:yaabsa/components/app/item/editor/library_item_edit_models.dart';
import 'package:yaabsa/components/app/item/editor/library_item_editor_form.dart';
import 'package:yaabsa/components/common/list_management_dialogs.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/library_item_sync.dart';
import 'package:yaabsa/provider/core/server_tasks_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';

import 'package:yaabsa/generated/l10n.dart';

enum _LibraryItemEditorTab { details, embedding, encoder }

class LibraryItemEditOverlay extends ConsumerStatefulWidget {
  const LibraryItemEditOverlay({
    super.key,
    required this.orderedItemIds,
    required this.currentItemId,
    required this.onSelectItem,
    required this.onClose,
    required this.onItemSaved,
    this.filterData,
  });

  final List<String> orderedItemIds;
  final String currentItemId;
  final ValueChanged<String> onSelectItem;
  final VoidCallback onClose;
  final Future<void> Function(String itemId, LibraryItem? updatedItem) onItemSaved;
  final LibraryFilterData? filterData;

  @override
  ConsumerState<LibraryItemEditOverlay> createState() => _LibraryItemEditOverlayState();
}

class _LibraryItemEditOverlayState extends ConsumerState<LibraryItemEditOverlay> {
  var _isSaving = false;
  final Map<String, LibraryItem> _cachedItems = <String, LibraryItem>{};
  final Map<String, Map<String, dynamic>> _metadataObjectsByItemId = <String, Map<String, dynamic>>{};
  final Set<String> _metadataLoadingItemIds = <String>{};
  final Set<String> _encoderSeededItemIds = <String>{};

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

  _LibraryItemEditorTab _selectedTab = _LibraryItemEditorTab.details;

  int get _currentIndex => widget.orderedItemIds.indexOf(widget.currentItemId);

  bool get _hasPrevious => _currentIndex > 0;
  bool get _hasNext => _currentIndex >= 0 && _currentIndex < widget.orderedItemIds.length - 1;

  @override
  void initState() {
    super.initState();
    _preloadAdjacentItems();
  }

  @override
  void didUpdateWidget(covariant LibraryItemEditOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentItemId != widget.currentItemId) {
      _selectedTab = _LibraryItemEditorTab.details;
      _toolErrorMessage = null;
      _isEmbedding = false;
      _isEncoding = false;
      _isCancelingEncode = false;
      _preloadAdjacentItems();
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

  List<_LibraryItemEditorTab> _availableTabsForItem(LibraryItem? item, String? userType) {
    if (item == null) {
      return const <_LibraryItemEditorTab>[_LibraryItemEditorTab.details];
    }

    final tabs = <_LibraryItemEditorTab>[_LibraryItemEditorTab.details];
    if (_canUseBookTools(item, userType)) {
      tabs.add(_LibraryItemEditorTab.embedding);
      tabs.add(_LibraryItemEditorTab.encoder);
    }

    return tabs;
  }

  String _tabTitle(_LibraryItemEditorTab tab) {
    switch (tab) {
      case _LibraryItemEditorTab.details:
        return S.current.componentsAppItemEditorLibraryItemEditOverlayTabDetails;
      case _LibraryItemEditorTab.embedding:
        return S.current.componentsAppItemEditorLibraryItemEditOverlayTabEmbedding;
      case _LibraryItemEditorTab.encoder:
        return S.current.componentsAppItemEditorLibraryItemEditOverlayTabEncoder;
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

    if (codecs.length == 1 && codecs.first == 'aac') {
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
          _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable;
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
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayFailedToLoadMetadataObject(
          _extractApiMessage(error),
        );
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
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable;
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
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayFailedToStartEmbedding(
          _extractApiMessage(error),
        );
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
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable;
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
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayFailedToStartM4bEncoding(
          _extractApiMessage(error),
        );
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
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable;
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
        _toolErrorMessage = S.current.componentsAppItemEditorLibraryItemEditOverlayFailedToCancelEncoding(
          _extractApiMessage(error),
        );
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
        return S.current.componentsAppItemEditorLibraryItemEditOverlayRequestFailed(statusCode);
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

  Future<void> _saveChanges(LibraryItemEditorDiff diff) async {
    if (_isSaving) {
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.current.componentsAppItemEditorLibraryItemEditOverlayNoServerConnectionAvailable)),
        );
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

      if (payload == null || !payload.updated) {
        throw Exception(S.current.componentsAppItemEditorLibraryItemEditOverlayUpdateRequestFailed);
      }

      final updatedItem = payload.libraryItem;
      if (updatedItem != null) {
        _cachedItems[widget.currentItemId] = updatedItem;
        await processLibraryItemUpdate(container: ref.container, item: updatedItem, source: 'editor.save');
      } else {
        invalidateLibraryItemConsumers(container: ref.container, itemId: widget.currentItemId);
      }
      await widget.onItemSaved(widget.currentItemId, updatedItem);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.componentsAppItemEditorLibraryItemEditOverlaySavedItemDetails)));
    } catch (error) {
      if (!mounted) {
        return;
      }

      final message = listManagementErrorMessage(
        error,
        fallback: S.current.componentsAppItemEditorLibraryItemEditOverlayCouldNotSaveItemDetails,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserAsync = ref.watch(currentUserProvider);
    final currentUserType = currentUserAsync.value?.type;

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

    final localErrorMessage = _toolErrorMessage?.trim();

    final embeddingErrorMessage = (localErrorMessage != null && localErrorMessage.isNotEmpty)
        ? localErrorMessage
        : _taskFailureMessage(
            embedTask,
            fallback: S.current.componentsAppItemEditorLibraryItemEditOverlayEmbeddingTaskFailed,
          );

    final encodingErrorMessage = (localErrorMessage != null && localErrorMessage.isNotEmpty)
        ? localErrorMessage
        : _taskFailureMessage(
            encodeTask,
            fallback: S.current.componentsAppItemEditorLibraryItemEditOverlayM4bEncodingTaskFailed,
          );

    final availableTabs = _availableTabsForItem(activeItem, currentUserType);
    final selectedTab = availableTabs.contains(_selectedTab) ? _selectedTab : availableTabs.first;

    if (activeItem != null && selectedTab == _LibraryItemEditorTab.embedding) {
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

    if (activeItem != null && availableTabs.contains(_LibraryItemEditorTab.encoder)) {
      final audioFiles = (activeItem.media?.bookMedia?.audioFiles ?? const <AudioFile>[])
          .where((file) => file.exclude != true)
          .toList(growable: false);
      _seedEncoderDefaultsIfNeeded(itemId: activeItem.id, audioFiles: audioFiles);
    }

    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.52),
        child: SafeArea(
          minimum: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: widget.onClose,
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
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.8),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildHeader(
                                context,
                                tabs: availableTabs,
                                selectedTab: selectedTab,
                                onSelectTab: (tab) {
                                  setState(() {
                                    _selectedTab = tab;
                                    _toolErrorMessage = null;
                                  });

                                  if (tab == _LibraryItemEditorTab.embedding && activeItem != null) {
                                    unawaited(_loadMetadataObject(activeItem.id));
                                  }
                                },
                              ),
                              Expanded(
                                child: itemAsync.when(
                                  data: (item) {
                                    final audioFiles = (item.media?.bookMedia?.audioFiles ?? const <AudioFile>[])
                                        .where((file) => file.exclude != true)
                                        .toList(growable: false);
                                    final chapters = item.media?.bookMedia?.chapters ?? const <Chapter>[];

                                    switch (selectedTab) {
                                      case _LibraryItemEditorTab.details:
                                        return LibraryItemEditorForm(
                                          key: ValueKey(item.id),
                                          item: item,
                                          filterData: widget.filterData,
                                          isSaving: _isSaving,
                                          onSave: _saveChanges,
                                          onClose: widget.onClose,
                                        );
                                      case _LibraryItemEditorTab.embedding:
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
                                      case _LibraryItemEditorTab.encoder:
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
                                        S.current
                                            .componentsAppItemEditorLibraryItemEditOverlayCouldNotLoadItemDetailsFor(
                                              error,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required List<_LibraryItemEditorTab> tabs,
    required _LibraryItemEditorTab selectedTab,
    required ValueChanged<_LibraryItemEditorTab> onSelectTab,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final showNavigation = widget.orderedItemIds.length > 1;

    final isMobile = context.isMobile;

    Widget buildTabsRow({required bool centered}) {
      final tabChildren = <Widget>[
        for (final tab in tabs)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _OverlayTabChip(title: _tabTitle(tab), selected: selectedTab == tab, onTap: () => onSelectTab(tab)),
          ),
      ];

      if (centered) {
        return SizedBox(
          height: 34,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(mainAxisSize: MainAxisSize.min, children: tabChildren),
          ),
        );
      }

      return SizedBox(
        height: 34,
        child: ListView(scrollDirection: Axis.horizontal, children: tabChildren),
      );
    }

    final titleText = Text(
      S.current.componentsAppItemEditorLibraryItemEditOverlayEditItem,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorScheme.onPrimaryContainer),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
      padding: EdgeInsets.fromLTRB(14, 6, 10, isMobile ? 8 : 6),
      child: Row(
        children: [
          if (showNavigation)
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton.filledTonal(
                onPressed: _hasPrevious ? () => widget.onSelectItem(widget.orderedItemIds[_currentIndex - 1]) : null,
                tooltip: S.current.componentsAppItemEditorLibraryItemEditOverlayPreviousItem,
                icon: const Icon(Icons.arrow_back_rounded, size: 16),
              ),
            ),
          if (showNavigation) const SizedBox(width: 8),
          Expanded(
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [titleText, const SizedBox(height: 6), buildTabsRow(centered: false)],
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(alignment: Alignment.centerLeft, child: titleText),
                      Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: buildTabsRow(centered: true),
                        ),
                      ),
                    ],
                  ),
          ),
          if (showNavigation) const SizedBox(width: 8),
          if (showNavigation)
            SizedBox(
              width: 32,
              height: 32,
              child: IconButton.filledTonal(
                onPressed: _hasNext ? () => widget.onSelectItem(widget.orderedItemIds[_currentIndex + 1]) : null,
                tooltip: S.current.componentsAppItemEditorLibraryItemEditOverlayNextItem,
                icon: const Icon(Icons.arrow_forward_rounded, size: 16),
              ),
            ),
          if (showNavigation) const SizedBox(width: 8),
          SizedBox(
            width: 32,
            height: 32,
            child: IconButton(
              onPressed: widget.onClose,
              tooltip: S.current.componentsAppItemEditorLibraryItemEditOverlayCloseEditor,
              icon: const Icon(Icons.close_rounded, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _OverlayTabChip extends StatelessWidget {
  const _OverlayTabChip({required this.title, required this.selected, required this.onTap});

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedColor = theme.colorScheme.primaryContainer;
    final selectedTextColor = theme.colorScheme.onPrimaryContainer;

    return Material(
      color: selected ? selectedColor : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Center(
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? selectedTextColor : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
