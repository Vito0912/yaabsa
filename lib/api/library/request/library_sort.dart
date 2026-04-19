import 'package:yaabsa/api/library/request/library_filter.dart';

const String defaultLibrarySortWireValue = 'addedAt';
const int defaultLibrarySortDesc = 1;

enum LibrarySortValue {
  title,
  author,
  authorName,
  authorNameLF,
  publishedYear,
  addedAt,
  size,
  duration,
  tracks,
  birthtime,
  modified,
  progressUpdated,
  progressStarted,
  progressFinished,
  random,
  sequence,
}

extension LibrarySortValueX on LibrarySortValue {
  String get wireValue => switch (this) {
    LibrarySortValue.title => 'media.metadata.title',
    LibrarySortValue.author => 'media.metadata.author',
    LibrarySortValue.authorName => 'media.metadata.authorName',
    LibrarySortValue.authorNameLF => 'media.metadata.authorNameLF',
    LibrarySortValue.publishedYear => 'media.metadata.publishedYear',
    LibrarySortValue.addedAt => 'addedAt',
    LibrarySortValue.size => 'size',
    LibrarySortValue.duration => 'media.duration',
    LibrarySortValue.tracks => 'media.numTracks',
    LibrarySortValue.birthtime => 'birthtimeMs',
    LibrarySortValue.modified => 'mtimeMs',
    LibrarySortValue.progressUpdated => 'progress',
    LibrarySortValue.progressStarted => 'progress.createdAt',
    LibrarySortValue.progressFinished => 'progress.finishedAt',
    LibrarySortValue.random => 'random',
    LibrarySortValue.sequence => 'sequence',
  };

  String get displayName => switch (this) {
    LibrarySortValue.title => 'Title',
    LibrarySortValue.author => 'Author',
    LibrarySortValue.authorName => 'Author (First Last)',
    LibrarySortValue.authorNameLF => 'Author (Last, First)',
    LibrarySortValue.publishedYear => 'Publish Year',
    LibrarySortValue.addedAt => 'Added At',
    LibrarySortValue.size => 'Size',
    LibrarySortValue.duration => 'Duration',
    LibrarySortValue.tracks => 'Number of Episodes',
    LibrarySortValue.birthtime => 'File Birthtime',
    LibrarySortValue.modified => 'File Modified',
    LibrarySortValue.progressUpdated => 'Progress: Last Updated',
    LibrarySortValue.progressStarted => 'Progress: Started',
    LibrarySortValue.progressFinished => 'Progress: Finished',
    LibrarySortValue.random => 'Randomly',
    LibrarySortValue.sequence => 'Sequence',
  };

  bool get defaultsToAscending => switch (this) {
    LibrarySortValue.title ||
    LibrarySortValue.author ||
    LibrarySortValue.authorName ||
    LibrarySortValue.authorNameLF ||
    LibrarySortValue.sequence => true,
    _ => false,
  };

  static LibrarySortValue? tryParse(String raw) {
    for (final value in LibrarySortValue.values) {
      if (value.wireValue == raw) {
        return value;
      }
    }
    return null;
  }
}

class LibrarySortSelection {
  const LibrarySortSelection({required this.sort, required this.desc});

  final String sort;
  final int desc;

  bool get isDescending => desc == 1;
}

const List<LibrarySortValue> _bookSortOptions = <LibrarySortValue>[
  LibrarySortValue.title,
  LibrarySortValue.authorName,
  LibrarySortValue.authorNameLF,
  LibrarySortValue.publishedYear,
  LibrarySortValue.addedAt,
  LibrarySortValue.size,
  LibrarySortValue.duration,
  LibrarySortValue.birthtime,
  LibrarySortValue.modified,
  LibrarySortValue.progressUpdated,
  LibrarySortValue.progressStarted,
  LibrarySortValue.progressFinished,
  LibrarySortValue.random,
];

const List<LibrarySortValue> _podcastSortOptions = <LibrarySortValue>[
  LibrarySortValue.title,
  LibrarySortValue.author,
  LibrarySortValue.addedAt,
  LibrarySortValue.size,
  LibrarySortValue.tracks,
  LibrarySortValue.birthtime,
  LibrarySortValue.modified,
  LibrarySortValue.random,
];

List<LibrarySortValue> getLibrarySortOptions({required String libraryMediaType, required String? activeFilter}) {
  final isPodcast = libraryMediaType == 'podcast';
  final hasSeriesFilter = isSeriesLibraryFilter(activeFilter);

  final baseOptions = isPodcast ? _podcastSortOptions : _bookSortOptions;
  if (hasSeriesFilter && !isPodcast) {
    return <LibrarySortValue>[...baseOptions, LibrarySortValue.sequence];
  }
  return baseOptions;
}

bool isSeriesLibraryFilter(String? activeFilter) {
  final parsed = parseGroupedLibraryFilterQuery(activeFilter);
  return parsed?.group == LibraryFilterGroup.series;
}

LibrarySortSelection resolveLibrarySortSelection({
  required String libraryMediaType,
  required String? activeFilter,
  required String? activeSort,
  required int? activeDesc,
}) {
  final options = getLibrarySortOptions(libraryMediaType: libraryMediaType, activeFilter: activeFilter);
  final selectedSort = _resolveSortValue(activeSort, options);

  return LibrarySortSelection(sort: selectedSort.wireValue, desc: _resolveSortDesc(activeDesc, selectedSort));
}

String buildLibrarySortLabel({
  required String libraryMediaType,
  required String? activeFilter,
  required String? activeSort,
  required int? activeDesc,
}) {
  final selection = resolveLibrarySortSelection(
    libraryMediaType: libraryMediaType,
    activeFilter: activeFilter,
    activeSort: activeSort,
    activeDesc: activeDesc,
  );

  final sortValue = LibrarySortValueX.tryParse(selection.sort);
  if (sortValue == null) {
    return selection.sort;
  }

  if (sortValue == LibrarySortValue.random) {
    return sortValue.displayName;
  }

  final directionLabel = selection.isDescending ? 'DESC' : 'ASC';
  return '${sortValue.displayName} ($directionLabel)';
}

LibrarySortValue _resolveSortValue(String? rawSort, List<LibrarySortValue> options) {
  if (rawSort != null) {
    final parsedSort = LibrarySortValueX.tryParse(rawSort);
    if (parsedSort != null && options.contains(parsedSort)) {
      return parsedSort;
    }
  }

  final defaultSort = LibrarySortValueX.tryParse(defaultLibrarySortWireValue);
  if (defaultSort != null && options.contains(defaultSort)) {
    return defaultSort;
  }

  return options.first;
}

int _resolveSortDesc(int? activeDesc, LibrarySortValue selectedSort) {
  if (activeDesc == 0 || activeDesc == 1) {
    return activeDesc!;
  }

  return selectedSort.defaultsToAscending ? 0 : 1;
}
