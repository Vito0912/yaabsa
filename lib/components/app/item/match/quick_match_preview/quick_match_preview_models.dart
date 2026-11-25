import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/components/app/item/match/manual_match/manual_match_models.dart';
import 'package:yaabsa/l10n/generated/app_localizations.dart';

const quickMatchCoverPreviewSize = 92.0;

class QuickMatchPreviewEntry {
  const QuickMatchPreviewEntry({required this.item, this.result, this.error, this.isLoading = false});

  final LibraryItem item;
  final ManualMatchResult? result;
  final String? error;
  final bool isLoading;
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
  required AppLocalizations l10n,
}) {
  final metadata = item.media?.bookMedia?.metadata;

  String keepOrReplace(String current, String suggested) {
    if (!overrideDetails || suggested == l10n.statusNotSet) {
      return current;
    }
    return suggested;
  }

  final fields = <({String label, String current, String suggested})>[
    (
      label: l10n.fieldTitle,
      current: stringValue(trimmedOrNull(metadata?.title) ?? trimmedOrNull(item.title), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.title), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldSubtitle,
      current: stringValue(trimmedOrNull(metadata?.subtitle), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.subtitle), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldAuthors,
      current: listValue(metadata?.authors?.map((entry) => entry.name), notSetLabel: l10n.statusNotSet),
      suggested: listValue(result.authors, notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldNarrators,
      current: listValue(metadata?.narrators, notSetLabel: l10n.statusNotSet),
      suggested: listValue(result.narrators, notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldSeries,
      current: _seriesFromMetadata(metadata?.series, l10n.statusNotSet),
      suggested: _seriesFromResult(result, l10n.statusNotSet),
    ),
    (
      label: l10n.fieldGenres,
      current: listValue(metadata?.genres, notSetLabel: l10n.statusNotSet),
      suggested: listValue(result.genres, notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldPublishedYear,
      current: stringValue(trimmedOrNull(metadata?.publishedYear), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.publishedYear), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldPublisher,
      current: stringValue(trimmedOrNull(metadata?.publisher), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.publisher), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldDescription,
      current: stringValue(trimmedOrNull(metadata?.description), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.description), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldIsbn,
      current: stringValue(trimmedOrNull(metadata?.isbn), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.isbn), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldAsin,
      current: stringValue(trimmedOrNull(metadata?.asin), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.asin), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldLanguage,
      current: stringValue(trimmedOrNull(metadata?.language), notSetLabel: l10n.statusNotSet),
      suggested: stringValue(trimmedOrNull(result.language), notSetLabel: l10n.statusNotSet),
    ),
    (
      label: l10n.fieldExplicit,
      current: boolValue(
        metadata?.explicit,
        notSetLabel: l10n.statusNotSet,
        yesLabel: l10n.optionYes,
        noLabel: l10n.optionNo,
      ),
      suggested: boolValue(
        result.explicit,
        notSetLabel: l10n.statusNotSet,
        yesLabel: l10n.optionYes,
        noLabel: l10n.optionNo,
      ),
    ),
    (
      label: l10n.fieldAbridged,
      current: boolValue(
        metadata?.abridged,
        notSetLabel: l10n.statusNotSet,
        yesLabel: l10n.optionYes,
        noLabel: l10n.optionNo,
      ),
      suggested: boolValue(
        result.abridged,
        notSetLabel: l10n.statusNotSet,
        yesLabel: l10n.optionYes,
        noLabel: l10n.optionNo,
      ),
    ),
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

String stringValue(String? value, {required String notSetLabel}) {
  return trimmedOrNull(value) ?? notSetLabel;
}

String listValue(Iterable<String>? values, {required String notSetLabel}) {
  if (values == null) {
    return notSetLabel;
  }

  final normalized = values
      .map(trimmedOrNull)
      .whereType<String>()
      .where((entry) => entry.isNotEmpty)
      .toList(growable: false);

  if (normalized.isEmpty) {
    return notSetLabel;
  }

  return normalized.join(', ');
}

String boolValue(bool? value, {required String notSetLabel, required String yesLabel, required String noLabel}) {
  if (value == null) {
    return notSetLabel;
  }
  return value ? yesLabel : noLabel;
}

String _seriesFromMetadata(List<Series>? series, String notSetLabel) {
  if (series == null || series.isEmpty) {
    return notSetLabel;
  }

  return _seriesLabelFromEntries(series.map((entry) => (name: entry.name, sequence: entry.sequence)), notSetLabel);
}

String _seriesFromResult(ManualMatchResult result, String notSetLabel) {
  if (result.seriesEntries.isEmpty) {
    return notSetLabel;
  }

  return _seriesLabelFromEntries(
    result.seriesEntries.map((entry) => (name: entry.name, sequence: entry.sequence)),
    notSetLabel,
  );
}

String _seriesLabelFromEntries(Iterable<({String? name, String? sequence})> entries, String notSetLabel) {
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
    return notSetLabel;
  }

  return labels.join(', ');
}
