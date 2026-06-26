import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/api/library_items/author.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/routes/library_item_api.dart';
import 'package:yaabsa/api/routes/upload_api.dart';
import 'package:yaabsa/api/search/search_provider_option.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/components/app/item/match/quick_match_preview/quick_match_preview_models.dart';
import 'package:yaabsa/components/app/item/match/quick_match_preview/quick_match_preview_widgets.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/upload_providers.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/logger.dart';

Future<bool> showQuickMatchPreviewDialog({
  required BuildContext context,
  required List<LibraryItem> items,
  required String mediaType,
  required List<String> providerValues,
  required bool overrideCover,
  required bool overrideDetails,
}) async {
  if (items.isEmpty) {
    return false;
  }

  final preview = QuickMatchPreviewDialog(
    items: items,
    mediaType: mediaType,
    providerValues: providerValues,
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
    required this.providerValues,
    required this.overrideCover,
    required this.overrideDetails,
  });

  final List<LibraryItem> items;
  final String mediaType;
  final List<String> providerValues;
  final bool overrideCover;
  final bool overrideDetails;

  @override
  ConsumerState<QuickMatchPreviewDialog> createState() => _QuickMatchPreviewDialogState();
}

class _QuickMatchPreviewDialogState extends ConsumerState<QuickMatchPreviewDialog> {
  List<QuickMatchPreviewEntry>? _entries;
  int _completedCount = 0;
  bool _isLoading = true;
  String? _loadingError;

  Set<String> _selectedItemIds = <String>{};
  bool _applying = false;

  final List<Future<void> Function()> _taskQueue = [];
  bool _queueRunning = false;

  @override
  void initState() {
    super.initState();
    _startLoadingPreview();
  }

  void _enqueueTask(Future<void> Function() task) {
    _taskQueue.add(task);
    if (!_queueRunning) {
      _runQueue();
    }
  }

  Future<void> _runQueue() async {
    _queueRunning = true;
    while (_taskQueue.isNotEmpty && mounted) {
      final task = _taskQueue.removeAt(0);
      task(); // run asynchronously
      await Future.delayed(const Duration(seconds: 1));
    }
    _queueRunning = false;
  }

  void _startLoadingPreview() {
    final api = ref.read(absApiProvider);
    if (api == null) {
      setState(() {
        _isLoading = false;
        _loadingError = 'No API session available.';
      });
      return;
    }

    _entries = widget.items.map((item) => QuickMatchPreviewEntry(item: item, isLoading: true)).toList();
    _completedCount = 0;
    _isLoading = true;
    _loadingError = null;

    final uploadApi = api.getUploadApi();
    final libraryItemApi = api.getLibraryItemApi();
    final normalizedMediaType = widget.mediaType == 'podcast' ? 'podcast' : 'book';

    final providers =
        ref.read(uploadMetadataProvidersProvider(widget.mediaType)).asData?.value ?? const <SearchProviderOption>[];
    String getProviderLabel(String providerValue) {
      for (final provider in providers) {
        if (provider.value == providerValue) {
          return provider.text;
        }
      }
      return providerValue;
    }

    for (var i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final index = i;
      _enqueueTask(
        () => _searchItemWithProviders(
          uploadApi: uploadApi,
          libraryItemApi: libraryItemApi,
          item: item,
          entryIndex: index,
          mediaType: normalizedMediaType,
          providerIndex: 0,
          getProviderLabel: getProviderLabel,
        ),
      );
    }
  }

  Future<void> _searchItemWithProviders({
    required UploadApi uploadApi,
    required LibraryItemApi libraryItemApi,
    required LibraryItem item,
    required int entryIndex,
    required String mediaType,
    required int providerIndex,
    required String Function(String) getProviderLabel,
  }) async {
    if (!mounted) {
      return;
    }

    LibraryItem currentItem = item;
    if (providerIndex == 0) {
      try {
        final response = await libraryItemApi.getLibraryItem(itemId: item.id);
        final data = response.data;
        if (data != null) {
          currentItem = data;
        } else {
          _markEntryCompleted(
            entryIndex,
            QuickMatchPreviewEntry(item: item, error: 'Could not load current item metadata.'),
          );
          return;
        }
      } catch (error) {
        _markEntryCompleted(
          entryIndex,
          QuickMatchPreviewEntry(item: item, error: 'Could not load current item metadata: $error'),
        );
        return;
      }
    } else {
      currentItem = _entries![entryIndex].item;
    }

    final providerValue = widget.providerValues[providerIndex];
    final providerLabel = getProviderLabel(providerValue);

    final metadata = currentItem.media?.bookMedia?.metadata;
    final rawTitle = trimmedOrNull(metadata?.title) ?? trimmedOrNull(currentItem.title);
    if (rawTitle == null) {
      _markEntryCompleted(
        entryIndex,
        QuickMatchPreviewEntry(item: currentItem, error: 'No title available for search.'),
      );
      return;
    }
    final title = _cleanTitle(rawTitle);

    final rawAuthor = (metadata?.authors != null && metadata!.authors!.isNotEmpty)
        ? metadata.authors!.first.name
        : currentItem.authorString;
    final author = _cleanAuthor(rawAuthor);

    try {
      final response = await uploadApi.searchMetadata(
        mediaType: mediaType,
        title: title,
        author: author,
        provider: providerValue,
        fallbackTitleOnly: true,
        libraryItemId: currentItem.id,
      );

      final rawResults = extractManualMatchResultMaps(response.data);
      ManualMatchResult? bestResult;

      for (final rawResult in rawResults) {
        final result = ManualMatchResult.fromMap(rawResult, providerValue: providerValue, providerLabel: providerLabel);
        if (result.hasMeaningfulData) {
          bestResult = result;
          break;
        }
      }

      if (bestResult != null) {
        _markEntryCompleted(entryIndex, QuickMatchPreviewEntry(item: currentItem, result: bestResult));
      } else {
        _handleNoMatchOrError(
          uploadApi: uploadApi,
          libraryItemApi: libraryItemApi,
          item: currentItem,
          entryIndex: entryIndex,
          mediaType: mediaType,
          providerIndex: providerIndex,
          getProviderLabel: getProviderLabel,
          errorMsg: 'No match found.',
        );
      }
    } catch (error) {
      _handleNoMatchOrError(
        uploadApi: uploadApi,
        libraryItemApi: libraryItemApi,
        item: currentItem,
        entryIndex: entryIndex,
        mediaType: mediaType,
        providerIndex: providerIndex,
        getProviderLabel: getProviderLabel,
        errorMsg: error.toString(),
      );
    }
  }

  void _handleNoMatchOrError({
    required UploadApi uploadApi,
    required LibraryItemApi libraryItemApi,
    required LibraryItem item,
    required int entryIndex,
    required String mediaType,
    required int providerIndex,
    required String Function(String) getProviderLabel,
    required String errorMsg,
  }) {
    if (providerIndex + 1 < widget.providerValues.length) {
      _enqueueTask(
        () => _searchItemWithProviders(
          uploadApi: uploadApi,
          libraryItemApi: libraryItemApi,
          item: item,
          entryIndex: entryIndex,
          mediaType: mediaType,
          providerIndex: providerIndex + 1,
          getProviderLabel: getProviderLabel,
        ),
      );
    } else {
      _markEntryCompleted(
        entryIndex,
        QuickMatchPreviewEntry(
          item: item,
          error: widget.providerValues.length > 1 ? 'No results found with any provider.' : errorMsg,
        ),
      );
    }
  }

  void _markEntryCompleted(int index, QuickMatchPreviewEntry entry) {
    if (!mounted) {
      return;
    }
    setState(() {
      _entries![index] = entry;
      _completedCount++;
      if (_completedCount == widget.items.length) {
        _isLoading = false;
        _selectedItemIds = _entries!.where(_canSelectEntry).map((e) => e.item.id).toSet();
      }
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
          child: Builder(
            builder: (context) {
              if (_loadingError != null) {
                return Column(
                  children: [
                    Expanded(child: QuickMatchPreviewFailure(error: _loadingError!)),
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

              if (_isLoading) {
                return Column(
                  children: [
                    Expanded(
                      child: QuickMatchPreviewLoading(completed: _completedCount, total: widget.items.length),
                    ),
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

              final entries = _entries ?? const <QuickMatchPreviewEntry>[];
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

  String? _cleanAuthor(String? author) {
    if (author == null) {
      return null;
    }
    final trimmed = author.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split(RegExp(r',\s*|&\s*|\band\b\s*', caseSensitive: false));
    if (parts.isEmpty) {
      return trimmed;
    }
    final primary = parts.first.trim();
    return primary.isEmpty ? trimmed : primary;
  }

  String _cleanTitle(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return title;
    }
    final cleaned = trimmed.replaceAll(
      RegExp(
        r'\s*[\(\[][^\]\)]*(Audiobook|Unabridged|Edition|Series|Book|Vol|Volume)[^\]\)]*[\)\]]',
        caseSensitive: false,
      ),
      '',
    );
    final finalTitle = cleaned.trim();
    return finalTitle.isEmpty ? trimmed : finalTitle;
  }
}
