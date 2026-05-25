import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/routes/library_item_api.dart';
import 'package:yaabsa/api/routes/upload_api.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/components/app/item/match/quick_match_preview/quick_match_preview_models.dart';
import 'package:yaabsa/components/app/item/match/quick_match_preview/quick_match_preview_widgets.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

Future<bool> showQuickMatchPreviewDialog({
  required BuildContext context,
  required List<LibraryItem> items,
  required String mediaType,
  required String providerValue,
  required String providerLabel,
  required bool overrideCover,
  required bool overrideDetails,
}) async {
  if (items.isEmpty) {
    return false;
  }

  final preview = QuickMatchPreviewDialog(
    items: items,
    mediaType: mediaType,
    providerValue: providerValue,
    providerLabel: providerLabel,
    overrideCover: overrideCover,
    overrideDetails: overrideDetails,
  );

  if (context.isMobile) {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return FractionallySizedBox(heightFactor: 0.94, child: preview);
      },
    );
    return result ?? false;
  }

  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1020, maxHeight: 780), child: preview),
      );
    },
  );

  return result ?? false;
}

class QuickMatchPreviewDialog extends ConsumerStatefulWidget {
  const QuickMatchPreviewDialog({
    super.key,
    required this.items,
    required this.mediaType,
    required this.providerValue,
    required this.providerLabel,
    required this.overrideCover,
    required this.overrideDetails,
  });

  final List<LibraryItem> items;
  final String mediaType;
  final String providerValue;
  final String providerLabel;
  final bool overrideCover;
  final bool overrideDetails;

  @override
  ConsumerState<QuickMatchPreviewDialog> createState() => _QuickMatchPreviewDialogState();
}

class _QuickMatchPreviewDialogState extends ConsumerState<QuickMatchPreviewDialog> {
  late final Future<List<QuickMatchPreviewEntry>> _previewFuture;
  Set<String> _selectedItemIds = <String>{};
  bool _selectionInitialized = false;
  bool _applying = false;

  @override
  void initState() {
    super.initState();
    _previewFuture = _loadPreview();
  }

  Future<List<QuickMatchPreviewEntry>> _loadPreview() async {
    final api = ref.read(absApiProvider);
    if (api == null) {
      throw StateError('No API session available.');
    }

    final uploadApi = api.getUploadApi();
    final libraryItemApi = api.getLibraryItemApi();
    final normalizedMediaType = widget.mediaType == 'podcast' ? 'podcast' : 'book';

    final futures = widget.items
        .map(
          (item) => _loadPreviewForItem(
            uploadApi: uploadApi,
            libraryItemApi: libraryItemApi,
            item: item,
            mediaType: normalizedMediaType,
          ),
        )
        .toList(growable: false);

    return Future.wait(futures);
  }

  Future<QuickMatchPreviewEntry> _loadPreviewForItem({
    required UploadApi uploadApi,
    required LibraryItemApi libraryItemApi,
    required LibraryItem item,
    required String mediaType,
  }) async {
    LibraryItem currentItem;
    try {
      final response = await libraryItemApi.getLibraryItem(itemId: item.id);
      final data = response.data;
      if (data == null) {
        logger(
          'Could not load current item metadata for quick match preview. itemId=${item.id}',
          tag: 'QuickMatchPreviewDialog',
          level: InfoLevel.warning,
        );
        return QuickMatchPreviewEntry(item: item, error: 'Could not load current item metadata.');
      }
      currentItem = data;
    } catch (error, stackTrace) {
      logger(
        'Failed to load current item metadata for quick match preview. itemId=${item.id}, error=$error',
        tag: 'QuickMatchPreviewDialog',
        level: InfoLevel.error,
      );
      logger(
        'Stack trace for item metadata load failure. itemId=${item.id}, stackTrace=$stackTrace',
        tag: 'QuickMatchPreviewDialog',
        level: InfoLevel.debug,
      );
      return QuickMatchPreviewEntry(item: item, error: 'Could not load current item metadata: $error');
    }

    final metadata = currentItem.media?.bookMedia?.metadata;
    final title = trimmedOrNull(metadata?.title) ?? trimmedOrNull(currentItem.title);
    if (title == null) {
      return QuickMatchPreviewEntry(item: currentItem, error: 'No title available for search.');
    }

    final author =
        trimmedOrNull(metadata?.authors?.map((entry) => entry.name).join(', ')) ??
        trimmedOrNull(currentItem.authorString);

    try {
      final response = await uploadApi.searchMetadata(
        mediaType: mediaType,
        title: title,
        author: author,
        provider: widget.providerValue,
        fallbackTitleOnly: true,
        libraryItemId: currentItem.id,
      );

      final rawResults = extractManualMatchResultMaps(response.data);
      for (final rawResult in rawResults) {
        final result = ManualMatchResult.fromMap(
          rawResult,
          providerValue: widget.providerValue,
          providerLabel: widget.providerLabel,
        );
        if (result.hasMeaningfulData) {
          return QuickMatchPreviewEntry(item: currentItem, result: result);
        }
      }

      return QuickMatchPreviewEntry(item: currentItem);
    } catch (error, stackTrace) {
      logger(
        'Metadata search failed in quick match preview. itemId=${currentItem.id}, error=$error',
        tag: 'QuickMatchPreviewDialog',
        level: InfoLevel.warning,
      );
      logger(
        'Stack trace for metadata search failure. itemId=${currentItem.id}, stackTrace=$stackTrace',
        tag: 'QuickMatchPreviewDialog',
        level: InfoLevel.debug,
      );
      return QuickMatchPreviewEntry(item: currentItem, error: '$error');
    }
  }

  void _initializeSelection(List<QuickMatchPreviewEntry> entries) {
    if (_selectionInitialized) {
      return;
    }

    final initialSelection = entries.where(_canSelectEntry).map((entry) => entry.item.id).toSet();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _selectionInitialized) {
        return;
      }

      setState(() {
        _selectedItemIds = initialSelection;
        _selectionInitialized = true;
      });
    });
  }

  void _setEntrySelected(String itemId, bool selected) {
    setState(() {
      final next = Set<String>.from(_selectedItemIds);
      if (selected) {
        next.add(itemId);
      } else {
        next.remove(itemId);
      }
      _selectedItemIds = next;
    });
  }

  void _selectAllMatching(List<QuickMatchPreviewEntry> entries) {
    setState(() {
      _selectedItemIds = entries.where(_canSelectEntry).map((entry) => entry.item.id).toSet();
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItemIds = <String>{};
    });
  }

  int _selectedApplicableCount(List<QuickMatchPreviewEntry> entries) {
    return entries.where((entry) => _selectedItemIds.contains(entry.item.id) && _canSelectEntry(entry)).length;
  }

  Future<void> _applySelected(List<QuickMatchPreviewEntry> entries) async {
    if (_applying) {
      return;
    }

    final selectedEntries = entries
        .where((entry) => _selectedItemIds.contains(entry.item.id) && _canSelectEntry(entry))
        .toList(growable: false);
    if (selectedEntries.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Select at least one matched item with changes to apply.')));
      }
      return;
    }

    final api = ref.read(absApiProvider);
    if (api == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No API session available.')));
      }
      return;
    }

    setState(() {
      _applying = true;
    });

    var updatedCount = 0;
    var unchangedCount = 0;
    var failedCount = 0;

    for (final entry in selectedEntries) {
      final request = _buildUpdateRequest(entry);
      if (request == null) {
        unchangedCount++;
        continue;
      }

      try {
        final response = await api.getLibraryItemApi().updateLibraryItemMedia(entry.item.id, request: request);
        final updated = response.data?.updated ?? false;
        if (updated) {
          updatedCount++;
        } else {
          unchangedCount++;
        }

        ref.invalidate(libraryItemProvider(entry.item.id));
      } catch (error, stackTrace) {
        failedCount++;
        logger(
          'Failed to apply quick match preview update. itemId=${entry.item.id}, error=$error',
          tag: 'QuickMatchPreviewDialog',
          level: InfoLevel.error,
        );
        logger(
          'Stack trace for quick match preview apply failure. itemId=${entry.item.id}, stackTrace=$stackTrace',
          tag: 'QuickMatchPreviewDialog',
          level: InfoLevel.debug,
        );
      }
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _applying = false;
    });

    final parts = <String>[];
    parts.add(updatedCount == 1 ? 'Updated 1 item.' : 'Updated $updatedCount items.');
    if (unchangedCount > 0) {
      parts.add(unchangedCount == 1 ? '1 item had no changes.' : '$unchangedCount items had no changes.');
    }
    if (failedCount > 0) {
      parts.add(failedCount == 1 ? '1 item failed.' : '$failedCount items failed.');
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(parts.join(' '))));

    if (updatedCount > 0 || unchangedCount > 0) {
      Navigator.of(context).pop(true);
    }
  }

  UpdateLibraryItemMediaRequest? _buildUpdateRequest(QuickMatchPreviewEntry entry) {
    final result = entry.result;
    if (result == null) {
      return null;
    }

    UpdateLibraryItemMediaMetadataPatch? metadata;

    if (widget.overrideDetails) {
      final authors = normalizeQuickMatchStrings(result.authors);
      final narrators = normalizeQuickMatchStrings(result.narrators);
      final genres = normalizeQuickMatchStrings(result.genres);
      final series = _buildSeries(result);

      final patch = UpdateLibraryItemMediaMetadataPatch(
        title: trimmedOrNull(result.title),
        subtitle: trimmedOrNull(result.subtitle),
        author: authors.isEmpty ? null : authors.join(', '),
        authors: _buildAuthors(authors),
        narrators: narrators.isEmpty ? null : narrators,
        series: series.isEmpty ? null : series,
        genres: genres.isEmpty ? null : genres,
        publisher: trimmedOrNull(result.publisher),
        publishedYear: trimmedOrNull(result.publishedYear),
        description: trimmedOrNull(result.description),
        language: trimmedOrNull(result.language),
        explicit: result.explicit,
        abridged: result.abridged,
        isbn: trimmedOrNull(result.isbn),
        asin: trimmedOrNull(result.asin),
      );

      metadata = patch.toJson().isEmpty ? null : patch;
    }

    final coverUrl = widget.overrideCover ? trimmedOrNull(result.coverUrl) : null;
    final request = UpdateLibraryItemMediaRequest(metadata: metadata, url: coverUrl);
    if (request.toJson().isEmpty) {
      return null;
    }
    return request;
  }

  List<Author>? _buildAuthors(List<String> authors) {
    if (authors.isEmpty) {
      return null;
    }

    return authors
        .asMap()
        .entries
        .map((entry) => Author(id: _generatedId('author', entry.key), name: entry.value))
        .toList(growable: false);
  }

  List<Series> _buildSeries(ManualMatchResult result) {
    final series = <Series>[];
    for (var index = 0; index < result.seriesEntries.length; index++) {
      final entry = result.seriesEntries[index];
      final name = trimmedOrNull(entry.name);
      if (name == null) {
        continue;
      }

      series.add(Series(id: _generatedId('series', index), name: name, sequence: trimmedOrNull(entry.sequence)));
    }
    return series;
  }

  String _generatedId(String prefix, int index) {
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-$index';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const QuickMatchPreviewHeader(),
        const Divider(height: 1),
        Expanded(
          child: FutureBuilder<List<QuickMatchPreviewEntry>>(
            future: _previewFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Column(
                  children: [
                    const Expanded(child: QuickMatchPreviewLoading()),
                    const Divider(height: 1),
                    QuickMatchPreviewActionRow(
                      applying: _applying,
                      selectedCount: 0,
                      onClose: () => Navigator.of(context).pop(),
                      onApply: null,
                    ),
                  ],
                );
              }

              if (snapshot.hasError) {
                return Column(
                  children: [
                    Expanded(child: QuickMatchPreviewFailure(error: '${snapshot.error}')),
                    const Divider(height: 1),
                    QuickMatchPreviewActionRow(
                      applying: _applying,
                      selectedCount: 0,
                      onClose: () => Navigator.of(context).pop(),
                      onApply: null,
                    ),
                  ],
                );
              }

              final entries = snapshot.data ?? const <QuickMatchPreviewEntry>[];
              _initializeSelection(entries);

              final changedCount = entries.where(_entryWillChange).length;
              final selectedCount = _selectedApplicableCount(entries);

              return Column(
                children: [
                  QuickMatchPreviewSummary(
                    changedCount: changedCount,
                    totalCount: entries.length,
                    onSelectAll: changedCount == 0 ? null : () => _selectAllMatching(entries),
                    onClearSelection: selectedCount == 0 ? null : _clearSelection,
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 14),
                      itemCount: entries.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final item = entry.item;
                        final result = entry.result;

                        if (result == null) {
                          return QuickMatchPreviewNoResultCard(item: item, error: entry.error);
                        }

                        final changedRows = buildQuickMatchComparisonRows(
                          item: item,
                          result: result,
                          overrideDetails: widget.overrideDetails,
                        ).where((row) => row.changed).toList(growable: false);
                        final coverWillChange = _willReplaceCover(result);
                        final selectable = _canSelectEntry(entry);
                        final selected = _selectedItemIds.contains(item.id);

                        return QuickMatchPreviewResultCard(
                          item: item,
                          result: result,
                          rows: changedRows,
                          coverWillChange: coverWillChange,
                          overrideCover: widget.overrideCover,
                          selectable: selectable,
                          selected: selected,
                          onSelectionChanged: (value) => _setEntrySelected(item.id, value),
                          buildCurrentCover: () => _buildCurrentCoverPreview(context, item),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  QuickMatchPreviewActionRow(
                    applying: _applying,
                    selectedCount: selectedCount,
                    onClose: () => Navigator.of(context).pop(),
                    onApply: selectedCount == 0 ? null : () => _applySelected(entries),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentCoverPreview(BuildContext context, LibraryItem item) {
    final api = ref.read(absApiProvider);
    if (api == null) {
      return quickMatchFallbackCoverPlaceholder(context, icon: Icons.menu_book_rounded);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: quickMatchCoverPreviewSize,
        height: quickMatchCoverPreviewSize,
        child: api.getLibraryItemApi().getLibraryItemCover(
          item.id,
          item: item,
          width: quickMatchCoverPreviewSize,
          height: quickMatchCoverPreviewSize,
        ),
      ),
    );
  }

  bool _canSelectEntry(QuickMatchPreviewEntry entry) => _entryWillChange(entry);

  bool _entryWillChange(QuickMatchPreviewEntry entry) {
    final result = entry.result;
    if (result == null) {
      return false;
    }

    if (_willReplaceCover(result)) {
      return true;
    }

    return buildQuickMatchComparisonRows(
      item: entry.item,
      result: result,
      overrideDetails: widget.overrideDetails,
    ).any((row) => row.changed);
  }

  bool _willReplaceCover(ManualMatchResult result) {
    return widget.overrideCover && trimmedOrNull(result.coverUrl) != null;
  }
}
