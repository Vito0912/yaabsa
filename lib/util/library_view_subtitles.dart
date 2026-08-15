import 'package:intl/intl.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/series.dart';
import 'package:yaabsa/api/library/library_author.dart';
import 'package:yaabsa/util/byte_format.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/library_view_subtitle_preferences.dart';

class LibraryViewSubtitle {
  const LibraryViewSubtitle._(this.parts);

  const LibraryViewSubtitle.empty() : this._(const <LibraryViewSubtitlePart>[]);

  factory LibraryViewSubtitle.fromParts(Iterable<LibraryViewSubtitlePart> parts) {
    final inlineParts = <LibraryViewSubtitlePart>[];
    final standaloneParts = <LibraryViewSubtitlePart>[];
    for (final part in parts) {
      if (part.text.isEmpty) {
        continue;
      }
      (part.isStandalone ? standaloneParts : inlineParts).add(part);
    }

    return LibraryViewSubtitle._fromSortedParts(inlineParts, standaloneParts);
  }

  factory LibraryViewSubtitle.plain(String value) {
    final normalized = value.trim();
    return normalized.isEmpty
        ? const LibraryViewSubtitle.empty()
        : LibraryViewSubtitle.fromParts([LibraryViewSubtitlePart(text: normalized)]);
  }

  final List<LibraryViewSubtitlePart> parts;

  bool get isEmpty => parts.isEmpty;

  String get text => parts.map((part) => part.displayText).join(' • ');

  LibraryViewSubtitle._fromSortedParts(
    List<LibraryViewSubtitlePart> inlineParts,
    List<LibraryViewSubtitlePart> standaloneParts,
  ) : parts = List.unmodifiable([...inlineParts, ...standaloneParts]);
}

class LibraryViewSubtitlePart {
  const LibraryViewSubtitlePart({
    required this.text,
    this.label,
    this.separator = ':\u00a0',
    this.isStandalone = false,
  });

  final String text;
  final String? label;
  final String separator;
  final bool isStandalone;

  bool get isLabelled => label != null;

  String get displayText => isLabelled ? '$label$separator$text' : text;
}

class LibraryViewSubtitleResolver {
  LibraryViewSubtitleResolver({
    required LibraryViewSubtitlePreferences preferences,
    required LibraryViewSubtitleView view,
    required String? activeSort,
  }) : _fields = _resolveFields(preferences: preferences, view: view, activeSort: activeSort);

  final List<LibraryViewSubtitleField> _fields;

  LibraryViewSubtitle? forLibraryItem(LibraryItem item) {
    if (_fields.isEmpty) {
      return null;
    }
    return _joinValues(_fields.map((field) => _libraryItemFieldValue(item, field)));
  }

  LibraryViewSubtitle? forSeries(Series series) {
    if (_fields.isEmpty) {
      return null;
    }
    return _joinValues(_fields.map((field) => _seriesFieldValue(series, field)));
  }

  LibraryViewSubtitle? forAuthor(LibraryAuthor author) {
    if (_fields.isEmpty) {
      return null;
    }
    return _joinValues(_fields.map((field) => _authorFieldValue(author, field)));
  }
}

LibraryViewSubtitle? resolveLibraryItemSubtitle({
  required LibraryItem item,
  required LibraryViewSubtitlePreferences preferences,
  required String? activeSort,
}) {
  return LibraryViewSubtitleResolver(
    preferences: preferences,
    view: LibraryViewSubtitleView.library,
    activeSort: activeSort,
  ).forLibraryItem(item);
}

LibraryViewSubtitle? resolveSeriesSubtitle({
  required Series series,
  required LibraryViewSubtitlePreferences preferences,
  required String? activeSort,
}) {
  return LibraryViewSubtitleResolver(
    preferences: preferences,
    view: LibraryViewSubtitleView.series,
    activeSort: activeSort,
  ).forSeries(series);
}

LibraryViewSubtitle? resolveAuthorSubtitle({
  required LibraryAuthor author,
  required LibraryViewSubtitlePreferences preferences,
  required String? activeSort,
}) {
  return LibraryViewSubtitleResolver(
    preferences: preferences,
    view: LibraryViewSubtitleView.authors,
    activeSort: activeSort,
  ).forAuthor(author);
}

List<LibraryViewSubtitleField> _resolveFields({
  required LibraryViewSubtitlePreferences preferences,
  required LibraryViewSubtitleView view,
  required String? activeSort,
}) {
  switch (preferences.mode) {
    case LibraryViewSubtitleMode.none:
      return const <LibraryViewSubtitleField>[];
    case LibraryViewSubtitleMode.custom:
      return preferences.fields;
    case LibraryViewSubtitleMode.sort:
      final field = _fieldForSort(view, activeSort);
      return field == null ? const <LibraryViewSubtitleField>[] : <LibraryViewSubtitleField>[field];
  }
}

LibraryViewSubtitleField? _fieldForSort(LibraryViewSubtitleView view, String? activeSort) {
  if (activeSort == null) {
    return null;
  }

  return switch (view) {
    LibraryViewSubtitleView.library => switch (activeSort) {
      'media.metadata.author' ||
      'media.metadata.authorName' ||
      'media.metadata.authorNameLF' => LibraryViewSubtitleField.author,
      'media.metadata.publishedYear' => LibraryViewSubtitleField.publishedYear,
      'addedAt' => LibraryViewSubtitleField.addedAt,
      'size' => LibraryViewSubtitleField.size,
      'media.duration' => LibraryViewSubtitleField.duration,
      'media.numTracks' => LibraryViewSubtitleField.tracks,
      'birthtimeMs' => LibraryViewSubtitleField.birthtime,
      'mtimeMs' => LibraryViewSubtitleField.modified,
      _ => null,
    },
    LibraryViewSubtitleView.series => switch (activeSort) {
      'numBooks' => LibraryViewSubtitleField.numBooks,
      'totalDuration' => LibraryViewSubtitleField.totalDuration,
      'addedAt' => LibraryViewSubtitleField.addedAt,
      _ => null,
    },
    LibraryViewSubtitleView.authors => switch (activeSort) {
      'numBooks' => LibraryViewSubtitleField.numBooks,
      'addedAt' => LibraryViewSubtitleField.addedAt,
      'updatedAt' => LibraryViewSubtitleField.updatedAt,
      _ => null,
    },
  };
}

LibraryViewSubtitlePart? _libraryItemFieldValue(LibraryItem item, LibraryViewSubtitleField field) {
  final rawValue = switch (field) {
    LibraryViewSubtitleField.author => item.authorString,
    LibraryViewSubtitleField.series => item.seriesName,
    LibraryViewSubtitleField.duration => _formatDuration(_libraryItemDuration(item)),
    LibraryViewSubtitleField.size => _formatSize(item.size ?? item.media?.bookMedia?.size),
    LibraryViewSubtitleField.tracks => _formatCount(
      item.media?.bookMedia?.numTracks ??
          item.media?.bookMedia?.audioFiles?.length ??
          item.media?.podcastMedia?.numEpisodes ??
          item.media?.podcastMedia?.episodes?.length,
      singular: item.media?.podcastMedia == null ? 'track' : 'episode',
    ),
    LibraryViewSubtitleField.addedAt => _formatDate(item.addedAt),
    LibraryViewSubtitleField.publishedYear => _nonEmpty(item.media?.bookMedia?.metadata.publishedYear),
    LibraryViewSubtitleField.narrator => item.narratorString,
    LibraryViewSubtitleField.birthtime => _formatDate(item.birthtimeMs),
    LibraryViewSubtitleField.modified => _formatDate(item.mtimeMs),
    LibraryViewSubtitleField.numBooks ||
    LibraryViewSubtitleField.totalDuration ||
    LibraryViewSubtitleField.updatedAt => null,
  };

  return _withFieldLabel(field, rawValue);
}

LibraryViewSubtitlePart? _seriesFieldValue(Series series, LibraryViewSubtitleField field) {
  final rawValue = switch (field) {
    LibraryViewSubtitleField.numBooks => _formatCount(_seriesBookCount(series), singular: 'book'),
    LibraryViewSubtitleField.totalDuration => _formatDuration(_seriesDuration(series)),
    LibraryViewSubtitleField.addedAt => _formatDate(series.addedAt),
    _ => null,
  };

  return _withFieldLabel(field, rawValue);
}

int? _seriesBookCount(Series series) {
  if (series.numBooks != null) {
    return series.numBooks;
  }

  if (series.books != null) {
    return series.books!.length;
  }

  return series.libraryItemIds?.length;
}

double? _seriesDuration(Series series) {
  if (series.totalDuration != null && series.totalDuration! > 0) {
    return series.totalDuration;
  }

  final books = series.books;
  if (books == null || books.isEmpty) {
    return null;
  }

  var totalDuration = 0.0;
  var hasDuration = false;
  for (final book in books) {
    final duration = _libraryItemDuration(book);
    if (duration == null) {
      continue;
    }
    totalDuration += duration;
    hasDuration = true;
  }

  if (!hasDuration) {
    return null;
  }

  return totalDuration;
}

LibraryViewSubtitlePart? _authorFieldValue(LibraryAuthor author, LibraryViewSubtitleField field) {
  final rawValue = switch (field) {
    LibraryViewSubtitleField.numBooks => _formatCount(author.numBooks, singular: 'book'),
    LibraryViewSubtitleField.addedAt => _formatDate(author.addedAt),
    LibraryViewSubtitleField.updatedAt => _formatDate(author.updatedAt),
    _ => null,
  };

  return _withFieldLabel(field, rawValue);
}

LibraryViewSubtitlePart? _withFieldLabel(LibraryViewSubtitleField field, String? value) {
  final normalized = _nonEmpty(value);
  if (normalized == null) {
    return null;
  }

  final hasLabel = switch (field) {
    LibraryViewSubtitleField.author ||
    LibraryViewSubtitleField.narrator ||
    LibraryViewSubtitleField.duration ||
    LibraryViewSubtitleField.size ||
    LibraryViewSubtitleField.tracks ||
    LibraryViewSubtitleField.numBooks ||
    LibraryViewSubtitleField.totalDuration ||
    LibraryViewSubtitleField.publishedYear => false,
    _ => true,
  };

  return LibraryViewSubtitlePart(
    text: normalized,
    label: hasLabel ? field.subtitleLabel : null,
    separator: field.subtitleSeparator,
    isStandalone: hasLabel || field == LibraryViewSubtitleField.author || field == LibraryViewSubtitleField.narrator,
  );
}

LibraryViewSubtitle? _joinValues(Iterable<LibraryViewSubtitlePart?> values) {
  final inlineParts = <LibraryViewSubtitlePart>[];
  final standaloneParts = <LibraryViewSubtitlePart>[];
  for (final part in values) {
    if (part == null || part.text.isEmpty) {
      continue;
    }
    (part.isStandalone ? standaloneParts : inlineParts).add(part);
  }

  if (inlineParts.isEmpty && standaloneParts.isEmpty) {
    return null;
  }

  return LibraryViewSubtitle._fromSortedParts(inlineParts, standaloneParts);
}

String? _formatCount(int? value, {required String singular}) {
  if (value == null || value < 0) {
    return null;
  }

  return _keepNumberAndUnitTogether('$value ${value == 1 ? singular : '${singular}s'}');
}

String? _formatSize(int? bytes) {
  if (bytes == null || bytes < 0) {
    return null;
  }

  return _keepNumberAndUnitTogether(formatByteSize(bytes));
}

String? _formatDuration(double? seconds) {
  if (seconds == null || seconds <= 0) {
    return null;
  }

  return _keepNumberAndUnitTogether(formatDurationLong(Duration(seconds: seconds.round())));
}

String? _formatDate(int? milliseconds) {
  if (milliseconds == null || milliseconds <= 0) {
    return null;
  }

  return _dateFormatter().format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
}

final Map<String, DateFormat> _dateFormatterCache = <String, DateFormat>{};

DateFormat _dateFormatter() {
  final locale = Intl.getCurrentLocale();
  return _dateFormatterCache.putIfAbsent(locale, DateFormat.yMMMd);
}

double? _libraryItemDuration(LibraryItem item) {
  final media = item.media;
  final storedDuration = media?.bookMedia?.duration ?? media?.podcastMedia?.duration;
  if (storedDuration != null && storedDuration > 0) {
    return storedDuration;
  }

  if (media == null) {
    return null;
  }

  final calculatedDuration = media.duration();
  return calculatedDuration > 0 ? calculatedDuration : null;
}

String? _nonEmpty(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}

String _keepNumberAndUnitTogether(String value) {
  return value.replaceAllMapped(RegExp(r'(\d)\s+(?=[A-Za-z])'), (match) => '${match.group(1)}\u00a0');
}
