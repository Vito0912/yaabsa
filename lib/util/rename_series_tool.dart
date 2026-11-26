import 'dart:math' as math;

import 'package:yaabsa/api/library/request/library_filter.dart';
import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/batch_update_library_item_request.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/routes/abs_api.dart';

const int _renameSeriesPageSize = 200;
const int _renameSeriesBatchSize = 200;

class RenameSeriesToolResult {
  const RenameSeriesToolResult({required this.booksMatched, required this.booksUpdated});

  final int booksMatched;
  final int booksUpdated;
}

Future<RenameSeriesToolResult> runRenameSeriesTool({
  required ABSApi api,
  required String libraryId,
  required String seriesId,
  required String newName,
}) async {
  final trimmedLibraryId = libraryId.trim();
  final trimmedSeriesId = seriesId.trim();
  final trimmedName = newName.trim();

  if (trimmedLibraryId.isEmpty) {
    throw ArgumentError('Library ID cannot be empty.');
  }
  if (trimmedSeriesId.isEmpty) {
    throw ArgumentError('Series ID cannot be empty.');
  }
  if (trimmedName.isEmpty) {
    throw ArgumentError('Series name cannot be empty.');
  }

  final seriesItems = await _fetchAllSeriesItems(api: api, libraryId: trimmedLibraryId, seriesId: trimmedSeriesId);
  if (seriesItems.isEmpty) {
    return const RenameSeriesToolResult(booksMatched: 0, booksUpdated: 0);
  }

  final itemIds = seriesItems.map((item) => item.id).toList(growable: false);
  final fullItems = await _fetchFullLibraryItems(api: api, itemIds: itemIds);

  var booksMatched = 0;
  final payloads = <BatchUpdateLibraryItemRequest>[];

  for (final item in fullItems) {
    final existingSeries = item.media?.bookMedia?.metadata.series;
    if (existingSeries == null || existingSeries.isEmpty) {
      continue;
    }

    var matchedSeries = false;
    var hasNameChange = false;
    final updatedSeries = <Series>[];

    for (final entry in existingSeries) {
      if (entry.id == trimmedSeriesId) {
        matchedSeries = true;
        if (entry.name != trimmedName) {
          hasNameChange = true;
        }
        updatedSeries.add(Series(id: entry.id, name: trimmedName, sequence: entry.sequence));
      } else {
        updatedSeries.add(Series(id: entry.id, name: entry.name, sequence: entry.sequence));
      }
    }

    if (!matchedSeries) {
      continue;
    }

    booksMatched += 1;
    if (!hasNameChange) {
      continue;
    }

    payloads.add(
      BatchUpdateLibraryItemRequest(
        id: item.id,
        mediaPayload: UpdateLibraryItemMediaRequest(
          metadata: UpdateLibraryItemMediaMetadataPatch(series: updatedSeries),
        ),
      ),
    );
  }

  final booksUpdated = await _applyBatchUpdates(api: api, payloads: payloads);
  return RenameSeriesToolResult(booksMatched: booksMatched, booksUpdated: booksUpdated);
}

Future<List<LibraryItem>> _fetchAllSeriesItems({
  required ABSApi api,
  required String libraryId,
  required String seriesId,
}) async {
  final allItems = <LibraryItem>[];
  final filterQuery = LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue;
  var page = 0;

  while (true) {
    final request = LibraryItemsRequest(limit: _renameSeriesPageSize, page: page, filter: filterQuery);
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
    } else if (pageData.results.length < _renameSeriesPageSize) {
      break;
    }

    page += 1;
  }

  return allItems;
}

Future<List<LibraryItem>> _fetchFullLibraryItems({required ABSApi api, required List<String> itemIds}) async {
  final itemApi = api.getLibraryItemApi();
  final fullItems = <LibraryItem>[];

  for (var start = 0; start < itemIds.length; start += _renameSeriesBatchSize) {
    final end = math.min(start + _renameSeriesBatchSize, itemIds.length);
    final chunk = itemIds.sublist(start, end);

    try {
      final batchItems = await itemApi.batchGetLibraryItems(chunk);
      if (batchItems.length == chunk.length) {
        fullItems.addAll(batchItems);
        continue;
      }

      final fetchedById = <String, LibraryItem>{};
      for (final item in batchItems) {
        fetchedById[item.id] = item;
      }

      for (final itemId in chunk) {
        final existing = fetchedById[itemId];
        if (existing != null) {
          fullItems.add(existing);
          continue;
        }

        final singleResponse = await itemApi.getLibraryItem(itemId: itemId);
        final singleItem = singleResponse.data;
        if (singleItem != null) {
          fullItems.add(singleItem);
        }
      }
    } catch (_) {
      for (final itemId in chunk) {
        final singleResponse = await itemApi.getLibraryItem(itemId: itemId);
        final singleItem = singleResponse.data;
        if (singleItem != null) {
          fullItems.add(singleItem);
        }
      }
    }
  }

  return fullItems;
}

Future<int> _applyBatchUpdates({required ABSApi api, required List<BatchUpdateLibraryItemRequest> payloads}) async {
  if (payloads.isEmpty) {
    return 0;
  }

  var updates = 0;
  for (var start = 0; start < payloads.length; start += _renameSeriesBatchSize) {
    final end = math.min(start + _renameSeriesBatchSize, payloads.length);
    final chunk = payloads.sublist(start, end);
    final response = await api.getLibraryItemApi().batchUpdateLibraryItems(chunk);
    if (!response.success) {
      throw Exception('Batch item update failed.');
    }

    updates += response.updates;
  }

  return updates;
}
