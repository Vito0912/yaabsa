import 'dart:math' as math;

import 'package:yaabsa/api/library/request/library_items_request.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/request/batch_update_library_item_request.dart';
import 'package:yaabsa/api/library_items/request/update_library_item_media_request.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/util/admin_item_metadata_tools.dart';

const int _pathToolPageSize = 200;
const int _pathToolBatchSize = 200;

class PathTagGenreRuleMatch {
  const PathTagGenreRuleMatch({
    required this.itemId,
    required this.title,
    required this.path,
    required this.value,
    required this.rule,
  });

  final String itemId;
  final String title;
  final String path;
  final String value;
  final String rule;
}

class PathTagGenreToolResult {
  const PathTagGenreToolResult({
    required this.itemsScanned,
    required this.itemsMatched,
    required this.itemsUpdated,
    required this.dryRun,
    required this.matches,
    required this.logs,
  });

  final int itemsScanned;
  final int itemsMatched;
  final int itemsUpdated;
  final bool dryRun;
  final List<PathTagGenreRuleMatch> matches;
  final List<String> logs;
}

class _ParsedPathRule {
  const _ParsedPathRule({required this.raw, required this.regex, required this.value});

  final String raw;
  final RegExp regex;
  final String value;
}

Future<PathTagGenreToolResult> runPathTagGenreTool({
  required ABSApi api,
  required String libraryId,
  required List<String> ruleSets,
  required MetadataSplitType targetType,
  required bool dryRun,
}) async {
  final trimmedLibraryId = libraryId.trim();
  if (trimmedLibraryId.isEmpty) {
    throw ArgumentError('Library ID cannot be empty.');
  }

  final parsedRules = _parseRules(ruleSets);
  final items = await _fetchAllLibraryItems(api: api, libraryId: trimmedLibraryId);

  final matches = <PathTagGenreRuleMatch>[];
  final logs = <String>[];
  final payloads = <BatchUpdateLibraryItemRequest>[];

  for (final item in items) {
    final itemPath = item.path;
    if (itemPath == null || itemPath.isEmpty) {
      continue;
    }

    final existingValues = _extractExistingValues(item: item, targetType: targetType);
    final mergedValues = <String>[];
    final seenValues = <String>{};

    for (final existing in existingValues) {
      final normalized = existing.trim();
      if (normalized.isEmpty || seenValues.contains(normalized)) {
        continue;
      }

      seenValues.add(normalized);
      mergedValues.add(normalized);
    }

    var itemChanged = false;
    for (final rule in parsedRules) {
      if (!rule.regex.hasMatch(itemPath)) {
        continue;
      }

      if (seenValues.contains(rule.value)) {
        continue;
      }

      seenValues.add(rule.value);
      mergedValues.add(rule.value);
      itemChanged = true;

      matches.add(
        PathTagGenreRuleMatch(itemId: item.id, title: item.title, path: itemPath, value: rule.value, rule: rule.raw),
      );

      if (dryRun) {
        logs.add('Dry run: would add "${rule.value}" to "${item.title}" ($itemPath)');
      } else {
        logs.add('Matched "${rule.value}" for "${item.title}" ($itemPath)');
      }
    }

    if (!itemChanged) {
      continue;
    }

    if (targetType == MetadataSplitType.tags) {
      payloads.add(
        BatchUpdateLibraryItemRequest(
          id: item.id,
          mediaPayload: UpdateLibraryItemMediaRequest(tags: mergedValues),
        ),
      );
    } else {
      payloads.add(
        BatchUpdateLibraryItemRequest(
          id: item.id,
          mediaPayload: UpdateLibraryItemMediaRequest(
            metadata: UpdateLibraryItemMediaMetadataPatch(genres: mergedValues),
          ),
        ),
      );
    }
  }

  if (matches.isEmpty) {
    logs.add('No items matched the configured rules.');
  }

  var itemsUpdated = 0;
  if (!dryRun && payloads.isNotEmpty) {
    itemsUpdated = await _applyBatchUpdates(api: api, payloads: payloads);
    logs.add('Updated $itemsUpdated of ${payloads.length} matched items.');
  }

  return PathTagGenreToolResult(
    itemsScanned: items.length,
    itemsMatched: payloads.length,
    itemsUpdated: itemsUpdated,
    dryRun: dryRun,
    matches: matches,
    logs: logs,
  );
}

List<_ParsedPathRule> _parseRules(List<String> ruleSets) {
  final parsed = <_ParsedPathRule>[];

  for (final rawRule in ruleSets) {
    final trimmed = rawRule.trim();
    if (trimmed.isEmpty) {
      continue;
    }

    final lastColonIndex = trimmed.lastIndexOf(':');
    if (lastColonIndex <= 0 || lastColonIndex >= trimmed.length - 1) {
      throw ArgumentError('Invalid rule format: "$trimmed". Expected <regex>:<value>.');
    }

    final pattern = trimmed.substring(0, lastColonIndex);
    final value = trimmed.substring(lastColonIndex + 1).trim();
    if (value.isEmpty) {
      throw ArgumentError('Invalid rule value in "$trimmed".');
    }

    final RegExp regex;
    try {
      regex = RegExp(pattern);
    } on FormatException catch (error) {
      throw ArgumentError('Invalid regular expression in "$trimmed": ${error.message}');
    }

    parsed.add(_ParsedPathRule(raw: trimmed, regex: regex, value: value));
  }

  if (parsed.isEmpty) {
    throw ArgumentError('At least one rule is required.');
  }

  return parsed;
}

List<String> _extractExistingValues({required LibraryItem item, required MetadataSplitType targetType}) {
  if (targetType == MetadataSplitType.tags) {
    return item.media?.bookMedia?.tags ?? item.media?.podcastMedia?.tags ?? const <String>[];
  }

  return item.media?.bookMedia?.metadata.genres ?? item.media?.podcastMedia?.metadata.genres ?? const <String>[];
}

Future<List<LibraryItem>> _fetchAllLibraryItems({required ABSApi api, required String libraryId}) async {
  final allItems = <LibraryItem>[];
  var page = 0;

  while (true) {
    final request = LibraryItemsRequest(limit: _pathToolPageSize, page: page);
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
    } else if (pageData.results.length < _pathToolPageSize) {
      break;
    }

    page += 1;
  }

  return allItems;
}

Future<int> _applyBatchUpdates({required ABSApi api, required List<BatchUpdateLibraryItemRequest> payloads}) async {
  var updates = 0;
  for (var start = 0; start < payloads.length; start += _pathToolBatchSize) {
    final end = math.min(start + _pathToolBatchSize, payloads.length);
    final chunk = payloads.sublist(start, end);
    final response = await api.getLibraryItemApi().batchUpdateLibraryItems(chunk);
    if (!response.success) {
      throw Exception('Batch item update failed.');
    }

    updates += response.updates;
  }

  return updates;
}
