import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';

const quickMatchNotSetLabel = 'Not set';
const quickMatchCoverPreviewSize = 92.0;

class QuickMatchPreviewEntry {
  const QuickMatchPreviewEntry({required this.item, this.result, this.error});

  final LibraryItem item;
  final ManualMatchResult? result;
  final String? error;
}

class QuickMatchComparisonRow {
  const QuickMatchComparisonRow({required this.label, required this.before, required this.after});

  final String label;
  final String before;
  final String after;

  bool get changed => before != after;
}

List<QuickMatchComparisonRow> buildQuickMatchComparisonRows({
  required LibraryItem item,
  required ManualMatchResult result,
  required bool overrideDetails,
}) {
  final metadata = item.media?.bookMedia?.metadata;

  String keepOrReplace(String current, String suggested) {
    if (!overrideDetails || suggested == quickMatchNotSetLabel) {
      return current;
    }
    return suggested;
  }

  final fields = <({String label, String current, String suggested})>[
    (
      label: 'Title',
      current: stringValue(trimmedOrNull(metadata?.title) ?? trimmedOrNull(item.title)),
      suggested: stringValue(trimmedOrNull(result.title)),
    ),
    (
      label: 'Subtitle',
      current: stringValue(trimmedOrNull(metadata?.subtitle)),
      suggested: stringValue(trimmedOrNull(result.subtitle)),
    ),
    (
      label: 'Authors',
      current: listValue(metadata?.authors?.map((entry) => entry.name)),
      suggested: listValue(result.authors),
    ),
    (label: 'Narrators', current: listValue(metadata?.narrators), suggested: listValue(result.narrators)),
    (label: 'Series', current: _seriesFromMetadata(metadata?.series), suggested: _seriesFromResult(result)),
    (label: 'Genres', current: listValue(metadata?.genres), suggested: listValue(result.genres)),
    (
      label: 'Published year',
      current: stringValue(trimmedOrNull(metadata?.publishedYear)),
      suggested: stringValue(trimmedOrNull(result.publishedYear)),
    ),
    (
      label: 'Publisher',
      current: stringValue(trimmedOrNull(metadata?.publisher)),
      suggested: stringValue(trimmedOrNull(result.publisher)),
    ),
    (
      label: 'Description',
      current: stringValue(trimmedOrNull(metadata?.description)),
      suggested: stringValue(trimmedOrNull(result.description)),
    ),
    (
      label: 'ISBN',
      current: stringValue(trimmedOrNull(metadata?.isbn)),
      suggested: stringValue(trimmedOrNull(result.isbn)),
    ),
    (
      label: 'ASIN',
      current: stringValue(trimmedOrNull(metadata?.asin)),
      suggested: stringValue(trimmedOrNull(result.asin)),
    ),
    (
      label: 'Language',
      current: stringValue(trimmedOrNull(metadata?.language)),
      suggested: stringValue(trimmedOrNull(result.language)),
    ),
    (label: 'Explicit', current: boolValue(metadata?.explicit), suggested: boolValue(result.explicit)),
    (label: 'Abridged', current: boolValue(metadata?.abridged), suggested: boolValue(result.abridged)),
  ];

  return fields
      .map(
        (field) => QuickMatchComparisonRow(
          label: field.label,
          before: field.current,
          after: keepOrReplace(field.current, field.suggested),
        ),
      )
      .toList(growable: false);
}

List<String> normalizeQuickMatchStrings(Iterable<String> values) {
  final normalized = <String>[];
  final seen = <String>{};
  for (final value in values) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      continue;
    }

    final key = trimmed.toLowerCase();
    if (!seen.add(key)) {
      continue;
    }
    normalized.add(trimmed);
  }
  return normalized;
}

String? trimmedOrNull(String? value) {
  if (value == null) {
    return null;
  }

  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String stringValue(String? value) {
  return trimmedOrNull(value) ?? quickMatchNotSetLabel;
}

String listValue(Iterable<String>? values) {
  if (values == null) {
    return quickMatchNotSetLabel;
  }

  final normalized = values
      .map(trimmedOrNull)
      .whereType<String>()
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);

  if (normalized.isEmpty) {
    return quickMatchNotSetLabel;
  }

  return normalized.join(', ');
}

String boolValue(bool? value) {
  if (value == null) {
    return quickMatchNotSetLabel;
  }
  return value ? 'Yes' : 'No';
}

String _seriesFromMetadata(List<Series>? series) {
  if (series == null || series.isEmpty) {
    return quickMatchNotSetLabel;
  }

  return _seriesLabelFromEntries(series.map((entry) => (name: entry.name, sequence: entry.sequence)));
}

String _seriesFromResult(ManualMatchResult result) {
  if (result.seriesEntries.isEmpty) {
    return quickMatchNotSetLabel;
  }

  return _seriesLabelFromEntries(result.seriesEntries.map((entry) => (name: entry.name, sequence: entry.sequence)));
}

String _seriesLabelFromEntries(Iterable<({String? name, String? sequence})> entries) {
  final labels = <String>[];
  for (final entry in entries) {
    final name = trimmedOrNull(entry.name);
    if (name == null) {
      continue;
    }

    final sequence = trimmedOrNull(entry.sequence);
    if (sequence == null) {
      labels.add(name);
      continue;
    }

    labels.add('$name #$sequence');
  }

  if (labels.isEmpty) {
    return quickMatchNotSetLabel;
  }

  return labels.join(', ');
}
