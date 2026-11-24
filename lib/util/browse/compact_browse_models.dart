enum CompactBrowseSection {
  libraries,
  library,
  items,
  recent,
  authors,
  series,
  episodes,
  latestEpisodes,
  continueListening,
  downloads,
}

typedef CompactBrowseQuery = ({
  CompactBrowseSection section,
  String? libraryId,
  String? itemId,
  String? filter,
  int page,
});

CompactBrowseQuery compactBrowseQuery(
  CompactBrowseSection section, {
  String? libraryId,
  String? itemId,
  String? filter,
  int page = 0,
}) {
  return (section: section, libraryId: libraryId, itemId: itemId, filter: filter, page: page);
}

class CompactBrowseEntry {
  const CompactBrowseEntry({
    required this.title,
    this.subtitle,
    this.destination,
    this.itemId,
    this.episodeId,
    this.coverUri,
    this.libraryIcon,
  });

  final String title;
  final String? subtitle;
  final CompactBrowseQuery? destination;
  final String? itemId;
  final String? episodeId;
  final Uri? coverUri;
  final String? libraryIcon;
}

class CompactBrowsePage {
  CompactBrowsePage({required Iterable<CompactBrowseEntry> entries, this.hasMore = false})
    : entries = List.unmodifiable(entries);

  final List<CompactBrowseEntry> entries;
  final bool hasMore;
}
