import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:yaabsa/api/library/library.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/batch_update_library_item_request.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

const int _metadataToolPageSize = 200;
const int _metadataBatchSize = 200;
const String forceMetadataTag = 'force-metadata';

enum MetadataSplitType { tags, genres }

class ForceMetadataRefreshToolResult {
  const ForceMetadataRefreshToolResult({
    required this.librariesProcessed,
    required this.itemsTagged,
    required this.itemsUpdated,
  });

  final int librariesProcessed;
  final int itemsTagged;
  final int itemsUpdated;
}

class SplitMetadataTermsToolResult {
  const SplitMetadataTermsToolResult({
    required this.librariesProcessed,
    required this.itemsChanged,
    required this.itemsUpdated,
    required this.termsSplit,
  });

  final int librariesProcessed;
  final int itemsChanged;
  final int itemsUpdated;
  final int termsSplit;
}

class _SplitTermsResult {
  const _SplitTermsResult({required this.changed, required this.updatedValues, required this.sourceTerms});

  final bool changed;
  final List<String> updatedValues;
  final Set<String> sourceTerms;
}

Future<List<Library>> fetchMetadataToolLibraries(ABSApi api) async {
  final response = await api.getLibraryApi().getLibraries();
  final libraries = List<Library>.from(response.data?.libraries ?? const <Library>[]);

  libraries.sort((first, second) => first.name.toLowerCase().compareTo(second.name.toLowerCase()));
  return libraries;
}

Future<ForceMetadataRefreshToolResult> runForceMetadataRefreshTool({
  required ABSApi api,
  required List<String> selectedLibraryIds,
}) async {
  final allLibraries = await fetchMetadataToolLibraries(api);
  final targetLibraries = _targetLibraries(allLibraries, selectedLibraryIds);

  var itemsTagged = 0;
  var itemsUpdated = 0;

  for (final library in targetLibraries) {
    final libraryItems = await _fetchAllLibraryItems(api, library.id);
    final payloads = <BatchUpdateLibraryItemRequest>[];

    for (final item in libraryItems) {
      final currentTags = _normalizedUniqueTerms(_extractItemTags(item));
      final updatedTags = _normalizedUniqueTerms(<String>[...currentTags, forceMetadataTag]);

      if (listEquals(currentTags, updatedTags)) {
        continue;
      }

      payloads.add(
        BatchUpdateLibraryItemRequest(
          id: item.id,
          mediaPayload: UpdateLibraryItemMediaRequest(tags: updatedTags),
        ),
      );
    }

    itemsTagged += payloads.length;
    itemsUpdated += await _applyBatchMediaUpdates(api, payloads);
  }

  if (itemsTagged > 0) {
    await api.getAdminApi().deleteTag(tag: forceMetadataTag);
  }

  return ForceMetadataRefreshToolResult(
    librariesProcessed: targetLibraries.length,
    itemsTagged: itemsTagged,
    itemsUpdated: itemsUpdated,
  );
}

Future<SplitMetadataTermsToolResult> runSplitMetadataTermsTool({
  required ABSApi api,
  required MetadataSplitType splitType,
  required String delimiter,
  required List<String> selectedLibraryIds,
}) async {
  final normalizedDelimiter = delimiter.trim();
  if (normalizedDelimiter.isEmpty) {
    throw ArgumentError('Delimiter cannot be empty.');
  }

  final allLibraries = await fetchMetadataToolLibraries(api);
  final targetLibraries = _targetLibraries(allLibraries, selectedLibraryIds);

  var itemsChanged = 0;
  var itemsUpdated = 0;
  final splitTerms = <String>{};

  for (final library in targetLibraries) {
    final libraryItems = await _fetchAllLibraryItems(api, library.id);
    final payloads = <BatchUpdateLibraryItemRequest>[];

    for (final item in libraryItems) {
      final splitResult = splitType == MetadataSplitType.tags
          ? _splitTerms(_extractItemTags(item), normalizedDelimiter)
          : _splitTerms(_extractItemGenres(item), normalizedDelimiter);

      if (!splitResult.changed) {
        continue;
      }

      splitTerms.addAll(splitResult.sourceTerms);
      if (splitType == MetadataSplitType.tags) {
        payloads.add(
          BatchUpdateLibraryItemRequest(
            id: item.id,
            mediaPayload: UpdateLibraryItemMediaRequest(tags: splitResult.updatedValues),
          ),
        );
      } else {
        payloads.add(
          BatchUpdateLibraryItemRequest(
            id: item.id,
            mediaPayload: UpdateLibraryItemMediaRequest(
              metadata: UpdateLibraryItemMediaMetadataPatch(genres: splitResult.updatedValues),
            ),
          ),
        );
      }
    }

    itemsChanged += payloads.length;
    itemsUpdated += await _applyBatchMediaUpdates(api, payloads);
  }

  return SplitMetadataTermsToolResult(
    librariesProcessed: targetLibraries.length,
    itemsChanged: itemsChanged,
    itemsUpdated: itemsUpdated,
    termsSplit: splitTerms.length,
  );
}

Future<List<LibraryItem>> _fetchAllLibraryItems(ABSApi api, String libraryId) async {
  final allItems = <LibraryItem>[];
  var page = 0;

  while (true) {
    final request = LibraryItemsRequest(limit: _metadataToolPageSize, page: page);
    final response = await api.getLibraryApi().getLibraryItems(libraryId, request);
    final pageData = response.data;
    if (pageData == null || pageData.results.isEmpty) {
      break;
    }

    allItems.addAll(pageData.results);

    final total = pageData.total;
    if (total != null) {
      if (allItems.length >= total) {
        break;
      }
    } else if (pageData.results.length < _metadataToolPageSize) {
      break;
    }

    page++;
  }

  return allItems;
}

Future<int> _applyBatchMediaUpdates(ABSApi api, List<BatchUpdateLibraryItemRequest> payloads) async {
  if (payloads.isEmpty) {
    return 0;
  }

  var updates = 0;
  for (var start = 0; start < payloads.length; start += _metadataBatchSize) {
    final end = math.min(start + _metadataBatchSize, payloads.length);
    final chunk = payloads.sublist(start, end);
    final response = await api.getLibraryItemApi().batchUpdateLibraryItems(chunk);
    if (!response.success) {
      throw Exception('Batch item update failed.');
    }

    updates += response.updates;
  }

  return updates;
}

List<Library> _targetLibraries(List<Library> libraries, List<String> selectedLibraryIds) {
  if (selectedLibraryIds.isEmpty) {
    return libraries;
  }

  final selectedSet = selectedLibraryIds.toSet();
  return libraries.where((library) => selectedSet.contains(library.id)).toList(growable: false);
}

List<String> _extractItemTags(LibraryItem item) {
  return item.media?.bookMedia?.tags ?? item.media?.podcastMedia?.tags ?? const <String>[];
}

List<String> _extractItemGenres(LibraryItem item) {
  return item.media?.bookMedia?.metadata.genres ?? item.media?.podcastMedia?.metadata.genres ?? const <String>[];
}

List<String> _normalizedUniqueTerms(Iterable<String> terms) {
  final normalized = <String>[];
  final seen = <String>{};

  for (final term in terms) {
    final trimmed = term.trim();
    if (trimmed.isEmpty || seen.contains(trimmed)) {
      continue;
    }

    seen.add(trimmed);
    normalized.add(trimmed);
  }

  return normalized;
}

_SplitTermsResult _splitTerms(List<String> currentTerms, String delimiter) {
  final normalizedCurrent = _normalizedUniqueTerms(currentTerms);
  final splitSourceTerms = <String>{};
  final nextTerms = <String>[];

  for (final term in normalizedCurrent) {
    final parts = term
        .split(delimiter)
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);

    if (parts.length > 1) {
      splitSourceTerms.add(term);
      nextTerms.addAll(parts);
    } else {
      nextTerms.add(term);
    }
  }

  final normalizedNext = _normalizedUniqueTerms(nextTerms);
  return _SplitTermsResult(
    changed: !listEquals(normalizedCurrent, normalizedNext),
    updatedValues: normalizedNext,
    sourceTerms: splitSourceTerms,
  );
}
