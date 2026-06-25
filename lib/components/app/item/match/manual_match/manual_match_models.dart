import 'package:yaabsa/util/item_formatters.dart';

class ManualMatchSeriesEntry {
  const ManualMatchSeriesEntry({required this.name, this.sequence});

  final String name;
  final String? sequence;
}

class ManualMatchResult {
  const ManualMatchResult({
    required this.providerValue,
    required this.providerLabel,
    required this.title,
    required this.subtitle,
    required this.authors,
    required this.narrators,
    required this.description,
    required this.publisher,
    required this.publishedYear,
    required this.runtimeLabel,
    required this.seriesEntries,
    required this.genres,
    required this.tags,
    required this.language,
    required this.isbn,
    required this.asin,
    required this.explicit,
    required this.abridged,
    required this.coverUrl,
  });

  factory ManualMatchResult.fromMap(
    Map<String, dynamic> map, {
    required String providerValue,
    required String providerLabel,
  }) {
    final parsedAuthors = extractAuthorList(map);
    final normalizedTitle = _asTrimmedString(map['title']) ?? _asTrimmedString(map['name']) ?? 'Untitled';

    return ManualMatchResult(
      providerValue: providerValue,
      providerLabel: providerLabel,
      title: normalizedTitle,
      subtitle: _asTrimmedString(map['subtitle']),
      authors: parsedAuthors,
      narrators: extractStringList(map['narrators'] ?? map['narrator']),
      description: _asTrimmedString(map['description']),
      publisher: _asTrimmedString(map['publisher']),
      publishedYear: _asTrimmedString(map['publishedYear']) ?? _asTrimmedString(map['publishYear']),
      runtimeLabel: formatDurationLong(Duration(minutes: map['duration'] ?? 0)),
      seriesEntries: extractSeriesEntries(map['series']),
      genres: extractStringList(map['genres']),
      tags: extractStringList(map['tags']),
      language: _asTrimmedString(map['language']),
      isbn: _asTrimmedString(map['isbn']),
      asin: _asTrimmedString(map['asin']),
      explicit: _asNullableBool(map['explicit']),
      abridged: _asNullableBool(map['abridged']),
      coverUrl: _asTrimmedString(map['cover']) ?? _asTrimmedString(map['imageUrl']) ?? _asTrimmedString(map['image']),
    );
  }

  final String providerValue;
  final String providerLabel;
  final String title;
  final String? subtitle;
  final List<String> authors;
  final List<String> narrators;
  final String? description;
  final String? publisher;
  final String? publishedYear;
  final String? runtimeLabel;
  final List<ManualMatchSeriesEntry> seriesEntries;
  final List<String> genres;
  final List<String> tags;
  final String? language;
  final String? isbn;
  final String? asin;
  final bool? explicit;
  final bool? abridged;
  final String? coverUrl;

  String? get authorDisplay => authors.isEmpty ? null : authors.join(', ');

  bool get hasMeaningfulData {
    return title.trim().isNotEmpty ||
        subtitle != null ||
        authors.isNotEmpty ||
        narrators.isNotEmpty ||
        description != null ||
        publisher != null ||
        publishedYear != null ||
        runtimeLabel != null ||
        seriesEntries.isNotEmpty ||
        genres.isNotEmpty ||
        tags.isNotEmpty ||
        language != null ||
        isbn != null ||
        asin != null ||
        explicit != null ||
        abridged != null ||
        coverUrl != null;
  }

  List<ManualMatchField> get availableFields {
    final fields = <ManualMatchField>[];

    if (coverUrl != null) {
      fields.add(ManualMatchField.cover);
    }
    if (title.trim().isNotEmpty) {
      fields.add(ManualMatchField.title);
    }
    if (subtitle != null) {
      fields.add(ManualMatchField.subtitle);
    }
    if (authors.isNotEmpty) {
      fields.add(ManualMatchField.authors);
    }
    if (narrators.isNotEmpty) {
      fields.add(ManualMatchField.narrators);
    }
    if (description != null) {
      fields.add(ManualMatchField.description);
    }
    if (publisher != null) {
      fields.add(ManualMatchField.publisher);
    }
    if (publishedYear != null) {
      fields.add(ManualMatchField.publishedYear);
    }
    if (seriesEntries.isNotEmpty) {
      fields.add(ManualMatchField.series);
    }
    if (genres.isNotEmpty) {
      fields.add(ManualMatchField.genres);
    }
    if (tags.isNotEmpty) {
      fields.add(ManualMatchField.tags);
    }
    if (language != null) {
      fields.add(ManualMatchField.language);
    }
    if (isbn != null) {
      fields.add(ManualMatchField.isbn);
    }
    if (asin != null) {
      fields.add(ManualMatchField.asin);
    }
    if (explicit != null) {
      fields.add(ManualMatchField.explicit);
    }
    if (abridged != null) {
      fields.add(ManualMatchField.abridged);
    }

    return fields;
  }
}

enum ManualMatchField {
  cover,
  title,
  subtitle,
  authors,
  narrators,
  description,
  publisher,
  publishedYear,
  series,
  genres,
  tags,
  language,
  isbn,
  asin,
  explicit,
  abridged,
}

extension ManualMatchFieldX on ManualMatchField {
  String get label {
    switch (this) {
      case ManualMatchField.cover:
        return 'Cover image';
      case ManualMatchField.title:
        return 'Title';
      case ManualMatchField.subtitle:
        return 'Subtitle';
      case ManualMatchField.authors:
        return 'Authors';
      case ManualMatchField.narrators:
        return 'Narrators';
      case ManualMatchField.description:
        return 'Description';
      case ManualMatchField.publisher:
        return 'Publisher';
      case ManualMatchField.publishedYear:
        return 'Published year';
      case ManualMatchField.series:
        return 'Series';
      case ManualMatchField.genres:
        return 'Genres';
      case ManualMatchField.tags:
        return 'Tags';
      case ManualMatchField.language:
        return 'Language';
      case ManualMatchField.isbn:
        return 'ISBN';
      case ManualMatchField.asin:
        return 'ASIN';
      case ManualMatchField.explicit:
        return 'Explicit';
      case ManualMatchField.abridged:
        return 'Abridged';
    }
  }
}

enum ManualListApplyMode { overwrite, add }

extension ManualListApplyModeX on ManualListApplyMode {
  String get label {
    switch (this) {
      case ManualListApplyMode.overwrite:
        return 'Overwrite';
      case ManualListApplyMode.add:
        return 'Add to current';
    }
  }
}

const Set<ManualMatchField> manualListFields = <ManualMatchField>{
  ManualMatchField.authors,
  ManualMatchField.narrators,
  ManualMatchField.series,
  ManualMatchField.genres,
  ManualMatchField.tags,
};

List<Map<String, dynamic>> extractManualMatchResultMaps(Object? responseData) {
  if (responseData is List) {
    return responseData.whereType<Map>().map((entry) => Map<String, dynamic>.from(entry)).toList(growable: false);
  }

  if (responseData is Map<String, dynamic>) {
    const listKeys = <String>['results', 'books', 'items', 'podcasts'];
    for (final key in listKeys) {
      final value = responseData[key];
      if (value is List) {
        return value.whereType<Map>().map((entry) => Map<String, dynamic>.from(entry)).toList(growable: false);
      }
    }

    final direct = responseData['book'];
    if (direct is Map) {
      return <Map<String, dynamic>>[Map<String, dynamic>.from(direct)];
    }
  }

  return const <Map<String, dynamic>>[];
}

List<String> extractAuthorList(Map<String, dynamic> map) {
  final explicitAuthor = _asTrimmedString(map['author']);
  if (explicitAuthor != null) {
    final fromAuthor = extractStringList(explicitAuthor);
    if (fromAuthor.isNotEmpty) {
      return fromAuthor;
    }
  }

  final parsedAuthors = extractStringList(map['authors']);
  if (parsedAuthors.isNotEmpty) {
    return parsedAuthors;
  }

  return const <String>[];
}

List<String> extractStringList(Object? rawValue) {
  final results = <String>[];
  final seen = <String>{};

  void addValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return;
    }
    final key = normalized.toLowerCase();
    if (!seen.add(key)) {
      return;
    }
    results.add(normalized);
  }

  if (rawValue is String) {
    for (final value in rawValue.split(',')) {
      addValue(value);
    }
    return results;
  }

  if (rawValue is List) {
    for (final entry in rawValue) {
      if (entry is String) {
        addValue(entry);
      } else if (entry is Map) {
        final map = Map<String, dynamic>.from(entry);
        final name = _asTrimmedString(map['name']) ?? _asTrimmedString(map['title']) ?? _asTrimmedString(map['series']);
        if (name != null) {
          addValue(name);
        }
      }
    }
  }

  return results;
}

List<ManualMatchSeriesEntry> extractSeriesEntries(Object? rawValue) {
  final normalized = <ManualMatchSeriesEntry>[];
  final seen = <String>{};

  void addEntry(String name, {String? sequence}) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) {
      return;
    }
    final cleanSequence = sequence?.trim();
    final key = '${cleanName.toLowerCase()}#${(cleanSequence ?? '').toLowerCase()}';
    if (!seen.add(key)) {
      return;
    }

    normalized.add(
      ManualMatchSeriesEntry(name: cleanName, sequence: cleanSequence?.isEmpty == true ? null : cleanSequence),
    );
  }

  if (rawValue is String) {
    for (final entry in rawValue.split(',')) {
      addEntry(entry);
    }
    return normalized;
  }

  if (rawValue is List) {
    for (final entry in rawValue) {
      if (entry is String) {
        addEntry(entry);
        continue;
      }
      if (entry is! Map) {
        continue;
      }

      final map = Map<String, dynamic>.from(entry);
      final name = _asTrimmedString(map['name']) ?? _asTrimmedString(map['series']);
      if (name == null) {
        continue;
      }
      final sequence = _asTrimmedString(map['sequence']);
      addEntry(name, sequence: sequence);
    }
  }

  return normalized;
}

String? _asTrimmedString(Object? value) {
  if (value == null) {
    return null;
  }
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}

bool? _asNullableBool(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final lowered = value.trim().toLowerCase();
    if (lowered == 'true' || lowered == '1') {
      return true;
    }
    if (lowered == 'false' || lowered == '0') {
      return false;
    }
  }
  return null;
}
