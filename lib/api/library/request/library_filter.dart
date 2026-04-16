import 'dart:convert';

enum LibraryFilterGroup { genres, tags, series, authors, progress, narrators, missing, languages, tracks }

extension LibraryFilterGroupX on LibraryFilterGroup {
  String get wireValue => switch (this) {
    LibraryFilterGroup.genres => 'genres',
    LibraryFilterGroup.tags => 'tags',
    LibraryFilterGroup.series => 'series',
    LibraryFilterGroup.authors => 'authors',
    LibraryFilterGroup.progress => 'progress',
    LibraryFilterGroup.narrators => 'narrators',
    LibraryFilterGroup.missing => 'missing',
    LibraryFilterGroup.languages => 'languages',
    LibraryFilterGroup.tracks => 'tracks',
  };

  static LibraryFilterGroup? tryParse(String raw) {
    for (final value in LibraryFilterGroup.values) {
      if (value.wireValue == raw) return value;
    }
    return null;
  }
}

enum LibraryProgressFilterValue { finished, notStarted, notFinished, inProgress }

extension LibraryProgressFilterValueX on LibraryProgressFilterValue {
  String get wireValue => switch (this) {
    LibraryProgressFilterValue.finished => 'finished',
    LibraryProgressFilterValue.notStarted => 'not-started',
    LibraryProgressFilterValue.notFinished => 'not-finished',
    LibraryProgressFilterValue.inProgress => 'in-progress',
  };
}

enum LibraryMissingFilterValue {
  asin,
  isbn,
  subtitle,
  authors,
  publishedYear,
  series,
  description,
  genres,
  tags,
  narrators,
  publisher,
  language,
}

extension LibraryMissingFilterValueX on LibraryMissingFilterValue {
  String get wireValue => switch (this) {
    LibraryMissingFilterValue.asin => 'asin',
    LibraryMissingFilterValue.isbn => 'isbn',
    LibraryMissingFilterValue.subtitle => 'subtitle',
    LibraryMissingFilterValue.authors => 'authors',
    LibraryMissingFilterValue.publishedYear => 'publishedYear',
    LibraryMissingFilterValue.series => 'series',
    LibraryMissingFilterValue.description => 'description',
    LibraryMissingFilterValue.genres => 'genres',
    LibraryMissingFilterValue.tags => 'tags',
    LibraryMissingFilterValue.narrators => 'narrators',
    LibraryMissingFilterValue.publisher => 'publisher',
    LibraryMissingFilterValue.language => 'language',
  };
}

enum LibraryTracksFilterValue { single, multi }

extension LibraryTracksFilterValueX on LibraryTracksFilterValue {
  String get wireValue => switch (this) {
    LibraryTracksFilterValue.single => 'single',
    LibraryTracksFilterValue.multi => 'multi',
  };
}

class LibraryFilter {
  const LibraryFilter._(this.queryValue);

  final String queryValue;

  factory LibraryFilter.grouped(LibraryFilterGroup group, String value) {
    return LibraryFilter._('${group.wireValue}.${encodeFilterValue(value)}');
  }

  factory LibraryFilter.progress(LibraryProgressFilterValue value) {
    return LibraryFilter.grouped(LibraryFilterGroup.progress, value.wireValue);
  }

  factory LibraryFilter.missing(LibraryMissingFilterValue value) {
    return LibraryFilter.grouped(LibraryFilterGroup.missing, value.wireValue);
  }

  factory LibraryFilter.tracks(LibraryTracksFilterValue value) {
    return LibraryFilter.grouped(LibraryFilterGroup.tracks, value.wireValue);
  }

  factory LibraryFilter.issues() {
    return const LibraryFilter._('issues');
  }

  factory LibraryFilter.feedOpen() {
    return const LibraryFilter._('feed-open');
  }
}

String encodeFilterValue(String value) {
  final base64Value = base64Encode(utf8.encode(value));
  return Uri.encodeComponent(base64Value);
}

String? normalizeLibraryFilterQuery(String? filter) {
  if (filter == null || filter.isEmpty) return null;
  if (filter == 'issues' || filter == 'feed-open') return filter;

  final dotIndex = filter.indexOf('.');
  if (dotIndex <= 0 || dotIndex >= filter.length - 1) {
    return filter;
  }

  final groupRaw = filter.substring(0, dotIndex);
  final valueRaw = filter.substring(dotIndex + 1);

  final group = LibraryFilterGroupX.tryParse(groupRaw);
  if (group == null) {
    return filter;
  }

  if (_looksUrlEncodedBase64(valueRaw)) {
    return filter;
  }

  final decodedRaw = Uri.decodeComponent(valueRaw);
  return LibraryFilter.grouped(group, decodedRaw).queryValue;
}

bool _looksUrlEncodedBase64(String raw) {
  try {
    final decoded = Uri.decodeComponent(raw);
    base64Decode(decoded);
    return true;
  } catch (_) {
    return false;
  }
}
