part of 'bg_audio_handler.dart';

const int _autoQueuePageSize = 20;

class QueueDisplayInfo {
  const QueueDisplayInfo({this.title, this.subtitle, this.author});

  final String? title;
  final String? subtitle;
  final String? author;

  static const empty = QueueDisplayInfo();
}

class LastPlayedMiniPlayerSnapshot {
  const LastPlayedMiniPlayerSnapshot({
    required this.itemId,
    required this.episodeId,
    required this.title,
    this.subtitle,
    this.author,
    this.cover,
  });

  final String itemId;
  final String? episodeId;
  final String title;
  final String? subtitle;
  final String? author;
  final Uri? cover;

  factory LastPlayedMiniPlayerSnapshot.fromMedia(InternalMedia media) {
    return LastPlayedMiniPlayerSnapshot(
      itemId: media.itemId,
      episodeId: media.episodeId,
      title: media.title,
      subtitle: media.subtitle,
      author: media.author,
      cover: media.cover,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'itemId': itemId,
      'episodeId': episodeId,
      'title': title,
      'subtitle': subtitle,
      'author': author,
      'cover': cover?.toString(),
    };
  }

  String toRawJson() {
    return jsonEncode(toJson());
  }

  static LastPlayedMiniPlayerSnapshot? fromRawJson(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }

      final itemIdValue = decoded['itemId'];
      final titleValue = decoded['title'];

      if (itemIdValue is! String || itemIdValue.trim().isEmpty) {
        return null;
      }
      if (titleValue is! String || titleValue.trim().isEmpty) {
        return null;
      }

      final episodeIdValue = decoded['episodeId'];
      final subtitleValue = decoded['subtitle'];
      final authorValue = decoded['author'];
      final coverValue = decoded['cover'];

      final episodeId = episodeIdValue is String && episodeIdValue.trim().isNotEmpty ? episodeIdValue.trim() : null;
      final subtitle = subtitleValue is String && subtitleValue.trim().isNotEmpty ? subtitleValue.trim() : null;
      final author = authorValue is String && authorValue.trim().isNotEmpty ? authorValue.trim() : null;
      final cover = coverValue is String && coverValue.trim().isNotEmpty ? Uri.tryParse(coverValue.trim()) : null;

      return LastPlayedMiniPlayerSnapshot(
        itemId: itemIdValue.trim(),
        episodeId: episodeId,
        title: titleValue.trim(),
        subtitle: subtitle,
        author: author,
        cover: cover,
      );
    } catch (_) {
      return null;
    }
  }

  bool matchesQueueItem(QueueItem item) {
    return itemId == item.itemId && episodeId == item.episodeId;
  }
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

enum AutoQueueStartType { none, series, playlist, collection }

class AutoQueueStart {
  const AutoQueueStart({required this.type, this.sourceId, this.globalIndex});

  const AutoQueueStart.none() : type = AutoQueueStartType.none, sourceId = null, globalIndex = null;

  final AutoQueueStartType type;
  final String? sourceId;
  final int? globalIndex;
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
