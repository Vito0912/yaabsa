part of 'bg_audio_handler.dart';

const int _autoQueuePageSize = 20;

class QueueDisplayInfo {
  const QueueDisplayInfo({this.title, this.subtitle, this.author});

  final String? title;
  final String? subtitle;
  final String? author;

  static const empty = QueueDisplayInfo();
}

class PlayerQueueEntry {
  const PlayerQueueEntry({
    required this.id,
    required this.item,
    this.displayInfo = QueueDisplayInfo.empty,
    this.autoQueued = false,
    this.autoQueuePage,
  });

  final String id;
  final QueueItem item;
  final QueueDisplayInfo displayInfo;
  final bool autoQueued;
  final int? autoQueuePage;
}

class PlayerQueueSnapshot {
  const PlayerQueueSnapshot({
    this.entries = const <PlayerQueueEntry>[],
    this.autoQueueEnabled = false,
    this.autoQueueActive = false,
    this.autoQueueLoading = false,
    this.autoQueueRemaining = 0,
    this.canLoadMoreAutoQueue = false,
  });

  final List<PlayerQueueEntry> entries;
  final bool autoQueueEnabled;
  final bool autoQueueActive;
  final bool autoQueueLoading;
  final int autoQueueRemaining;
  final bool canLoadMoreAutoQueue;
}

enum _AutoQueueSourceType { series, playlist, collection, podcast }

class _AutoQueueRequestContext {
  _AutoQueueRequestContext._({
    required this.sourceType,
    required this.libraryId,
    required this.initialPage,
    this.filter,
    this.collapseseries,
    this.seriesId,
    this.playlistId,
    this.collectionId,
    this.podcastItemId,
    this.podcastItem,
    this.seededPodcastEpisodes,
  });

  factory _AutoQueueRequestContext.series({
    required String libraryId,
    required String seriesId,
    required int initialPage,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.series,
      libraryId: libraryId,
      initialPage: initialPage,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
      collapseseries: 0,
      seriesId: seriesId,
    );
  }

  factory _AutoQueueRequestContext.playlist({
    required String libraryId,
    required String playlistId,
    required int initialPage,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.playlist,
      libraryId: libraryId,
      initialPage: initialPage,
      playlistId: playlistId,
    );
  }

  factory _AutoQueueRequestContext.collection({
    required String libraryId,
    required String collectionId,
    required int initialPage,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.collection,
      libraryId: libraryId,
      initialPage: initialPage,
      collectionId: collectionId,
    );
  }

  factory _AutoQueueRequestContext.podcast({
    required String libraryId,
    required String podcastItemId,
    required LibraryItem podcastItem,
    required int initialPage,
    List<Episode>? seededPodcastEpisodes,
  }) {
    return _AutoQueueRequestContext._(
      sourceType: _AutoQueueSourceType.podcast,
      libraryId: libraryId,
      initialPage: initialPage,
      podcastItemId: podcastItemId,
      podcastItem: podcastItem,
      seededPodcastEpisodes: seededPodcastEpisodes,
    );
  }

  final _AutoQueueSourceType sourceType;
  final String libraryId;
  final int initialPage;
  final int pageSize = _autoQueuePageSize;
  final String? filter;
  final int? collapseseries;
  final String? seriesId;
  final String? playlistId;
  final String? collectionId;
  final String? podcastItemId;
  final LibraryItem? podcastItem;
  final List<Episode>? seededPodcastEpisodes;

  List<_AutoQueueItemCandidate>? cachedCandidates;
}

class _AutoQueueItemCandidate {
  const _AutoQueueItemCandidate({required this.queueItem, required this.referenceKey, required this.displayInfo});

  final QueueItem queueItem;
  final String referenceKey;
  final QueueDisplayInfo displayInfo;
}

class _AutoQueuePageResult {
  const _AutoQueuePageResult({required this.items, required this.total, required this.page, required this.pageSize});

  final List<_AutoQueueItemCandidate> items;
  final int total;
  final int page;
  final int pageSize;
}

class _AutoQueueState {
  _AutoQueueState({
    required this.context,
    required this.currentItemReferenceKey,
    required this.currentItemAbsoluteIndex,
    required this.totalItems,
    required this.pageSize,
    required this.highestLoadedPage,
  });

  final _AutoQueueRequestContext context;
  final String currentItemReferenceKey;
  final int currentItemAbsoluteIndex;
  final int totalItems;
  final int pageSize;

  int highestLoadedPage;
  bool isLoading = false;
  final Map<int, String> firstItemReferenceByPage = <int, String>{};
  final Set<int> triggeredPages = <int>{};
}
