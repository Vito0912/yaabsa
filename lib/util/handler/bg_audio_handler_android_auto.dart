part of 'bg_audio_handler.dart';

const String _androidAutoContinueNodeId = 'aa/continue';
const String _androidAutoRecentNodeId = 'aa/recent';
const String _androidAutoLibrariesNodeId = 'aa/libraries';
const String _androidAutoDownloadsNodeId = 'aa/downloads';

const int _androidAutoDefaultPageSize = 100;
const int _androidAutoMaxPageSize = 200;
const int _androidAutoSearchResultsPerLibrary = 50;
const int _androidAutoLetterGroupingThreshold = 30;

const String _androidAutoSortFieldTitle = 'title';
const String _androidAutoSortFieldAuthor = 'author';
const String _androidAutoSortFieldAdded = 'added';

const Map<String, String> _androidAutoSortFieldToApiSort = <String, String>{
  _androidAutoSortFieldTitle: 'media.metadata.title',
  _androidAutoSortFieldAuthor: 'media.metadata.authorName',
  _androidAutoSortFieldAdded: 'addedAt',
};

class _AndroidAutoPagingOptions {
  const _AndroidAutoPagingOptions({required this.page, required this.pageSize, required this.hasExplicitPaging});

  final int page;
  final int pageSize;
  final bool hasExplicitPaging;

  int get startIndex => page * pageSize;
}

class _AndroidAutoPlaybackTarget {
  const _AndroidAutoPlaybackTarget({required this.itemId, this.episodeId});

  final String itemId;
  final String? episodeId;
}

class _AndroidAutoLibraryItemsPage {
  const _AndroidAutoLibraryItemsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<LibraryItem> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => ((page + 1) * pageSize) < total;
}

enum _AndroidAutoLibraryTab { all, authors, series, collections, playlists, discovery, narrators }

extension _AndroidAutoLibraryTabX on _AndroidAutoLibraryTab {
  String get key {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'all';
      case _AndroidAutoLibraryTab.authors:
        return 'authors';
      case _AndroidAutoLibraryTab.series:
        return 'series';
      case _AndroidAutoLibraryTab.collections:
        return 'collections';
      case _AndroidAutoLibraryTab.playlists:
        return 'playlists';
      case _AndroidAutoLibraryTab.discovery:
        return 'discovery';
      case _AndroidAutoLibraryTab.narrators:
        return 'narrators';
    }
  }

  String get label {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'All';
      case _AndroidAutoLibraryTab.authors:
        return 'Authors';
      case _AndroidAutoLibraryTab.series:
        return 'Series';
      case _AndroidAutoLibraryTab.collections:
        return 'Collections';
      case _AndroidAutoLibraryTab.playlists:
        return 'Playlists';
      case _AndroidAutoLibraryTab.discovery:
        return 'Discovery';
      case _AndroidAutoLibraryTab.narrators:
        return 'Narrators';
    }
  }

  String? get subtitle {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'This can take a while to load';
      default:
        return null;
    }
  }

  static _AndroidAutoLibraryTab? tryParse(String key) {
    for (final tab in _AndroidAutoLibraryTab.values) {
      if (tab.key == key) {
        return tab;
      }
    }
    return null;
  }
}

extension _BGAudioHandlerAndroidAutoEntry on BGAudioHandler {
  Future<List<MediaItem>> _androidAutoGetChildren(String parentMediaId, {Map<String, dynamic>? options}) async {
    final paging = _androidAutoPagingFromOptions(options);

    if (parentMediaId == AudioService.browsableRootId) {
      return _androidAutoRootItems();
    }

    if (parentMediaId == AudioService.recentRootId) {
      return _androidAutoRecentAcrossLibraries(paging);
    }

    if (parentMediaId == _androidAutoDownloadsNodeId) {
      return _androidAutoDownloadItems(paging);
    }

    if (parentMediaId == _androidAutoContinueNodeId) {
      return _androidAutoContinueAcrossLibraries(paging);
    }

    if (parentMediaId == _androidAutoRecentNodeId) {
      return _androidAutoRecentLibraryNodes(paging);
    }

    final recentLibraryId = _androidAutoRecentLibraryIdFromNode(parentMediaId);
    if (recentLibraryId != null) {
      return _androidAutoRecentForLibrary(recentLibraryId, paging);
    }

    if (parentMediaId == _androidAutoLibrariesNodeId) {
      return _androidAutoLibraryNodes(paging);
    }

    final libraryNodeId = _androidAutoLibraryIdFromNode(parentMediaId);
    if (libraryNodeId != null) {
      return _androidAutoLibraryTabNodes(libraryNodeId);
    }

    final allLetterInfo = _androidAutoAllLetterNodeFromId(parentMediaId);
    if (allLetterInfo != null) {
      return _androidAutoAllItemsForLetter(allLetterInfo.libraryId, allLetterInfo.letter, paging);
    }

    final allPageInfo = _androidAutoAllPageNodeFromId(parentMediaId);
    if (allPageInfo != null) {
      return _androidAutoAllItemsForLibrary(
        allPageInfo.libraryId,
        _AndroidAutoPagingOptions(
          page: allPageInfo.page,
          pageSize: _androidAutoDefaultPageSize,
          hasExplicitPaging: false,
        ),
        includeMoreNode: true,
      );
    }

    final libraryTabInfo = _androidAutoLibraryTabFromNode(parentMediaId);
    if (libraryTabInfo != null) {
      return _androidAutoLibraryTabChildren(libraryTabInfo.libraryId, libraryTabInfo.tab, paging);
    }

    final authorInfo = _androidAutoAuthorNodeFromId(parentMediaId);
    if (authorInfo != null) {
      return _androidAutoItemsForAuthor(authorInfo.libraryId, authorInfo.authorId, paging);
    }

    final seriesInfo = _androidAutoSeriesNodeFromId(parentMediaId);
    if (seriesInfo != null) {
      return _androidAutoItemsForSeries(seriesInfo.libraryId, seriesInfo.seriesId, paging);
    }

    final collectionInfo = _androidAutoCollectionNodeFromId(parentMediaId);
    if (collectionInfo != null) {
      return _androidAutoItemsForCollection(collectionInfo.libraryId, collectionInfo.collectionId, paging);
    }

    final playlistInfo = _androidAutoPlaylistNodeFromId(parentMediaId);
    if (playlistInfo != null) {
      return _androidAutoItemsForPlaylist(playlistInfo.libraryId, playlistInfo.playlistId, paging);
    }

    final narratorInfo = _androidAutoNarratorNodeFromId(parentMediaId);
    if (narratorInfo != null) {
      return _androidAutoItemsForNarrator(narratorInfo.libraryId, narratorInfo.narrator, paging);
    }

    return const <MediaItem>[];
  }

  Future<MediaItem?> _androidAutoGetMediaItem(String mediaId) async {
    final target = _androidAutoPlaybackTargetFromMediaId(mediaId);
    if (target == null) {
      return null;
    }

    InternalDownload? download;
    LibraryItem? item = await resolveQueueLibraryItem(target.itemId);
    Episode? episode;

    if (item != null && target.episodeId != null) {
      episode = _androidAutoEpisodeForItem(item, target.episodeId!);
    }

    if (item == null || (target.episodeId != null && episode == null)) {
      download = await _androidAutoStoredDownload(target.itemId, episodeId: target.episodeId);
      item ??= download?.item;
      episode ??= download?.episode;
    }

    if (item == null) {
      return null;
    }

    if (target.episodeId != null && episode != null) {
      return _androidAutoPlayableFromEpisode(
        item: item,
        episode: episode,
        mediaIdOverride: mediaId,
        subtitlePrefix: download == null ? null : 'Downloaded',
        artUriOverride: _androidAutoUriFromPathOrUri(download?.coverPath),
      );
    }

    return _androidAutoPlayableFromLibraryItem(
      item,
      mediaId: mediaId,
      subtitlePrefix: download == null ? null : 'Downloaded',
      artUriOverride: _androidAutoUriFromPathOrUri(download?.coverPath),
    );
  }

  Future<List<MediaItem>> _androidAutoSearch(String query, {Map<String, dynamic>? extras}) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return const <MediaItem>[];
    }

    if (!await _androidAutoHasServerConnection()) {
      return const <MediaItem>[];
    }

    final api = _ref.read(absApiProvider);
    if (api == null) {
      return const <MediaItem>[];
    }

    final paging = _androidAutoPagingFromOptions(extras);
    final perLibraryLimit = _clampInt(
      _androidAutoReadInt(extras, const <String>['limit', 'android.media.browse.extra.PAGE_SIZE']) ??
          _androidAutoSearchResultsPerLibrary,
      1,
      100,
    );

    final libraries = await _androidAutoFetchLibraries();
    final bookLibraries = libraries.where((library) => library.mediaType == 'book').toList(growable: false);
    if (bookLibraries.isEmpty) {
      return const <MediaItem>[];
    }

    final searchResults = await Future.wait(
      bookLibraries.map((library) async {
        try {
          final response = await api.getLibraryApi().getSearchLibrary(library.id, trimmedQuery, limit: perLibraryLimit);
          return (library: library, result: response.data);
        } catch (e) {
          logger(
            'Android Auto search failed for library ${library.id}: $e',
            tag: 'AudioHandler',
            level: InfoLevel.warning,
          );
          return (library: library, result: null);
        }
      }),
    );

    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final entry in searchResults) {
      final libraryItems = entry.result?.book ?? const <SearchLibraryResult>[];
      for (final searchResult in libraryItems) {
        final libraryItem = searchResult.libraryItem;
        if (libraryItem == null || !_androidAutoIsPlayableAudioItem(libraryItem)) {
          continue;
        }

        final mediaId = _androidAutoItemPlaybackId(libraryItem.id);
        if (!seen.add(mediaId)) {
          continue;
        }

        mediaItems.add(
          _androidAutoPlayableFromLibraryItem(libraryItem, mediaId: mediaId, subtitlePrefix: entry.library.name),
        );
      }
    }

    return _androidAutoApplyPaging(mediaItems, paging);
  }

  Future<void> _androidAutoPlayFromMediaId(String mediaId, {Map<String, dynamic>? extras}) async {
    final target = _androidAutoPlaybackTargetFromMediaId(mediaId);
    if (target == null) {
      return;
    }

    try {
      InternalDownload? download;
      LibraryItem? item = await resolveQueueLibraryItem(target.itemId);
      Episode? episode;

      if (item != null && target.episodeId != null) {
        episode = _androidAutoEpisodeForItem(item, target.episodeId!);
      }

      if (item == null || (target.episodeId != null && episode == null)) {
        download = await _androidAutoStoredDownload(target.itemId, episodeId: target.episodeId);
        item ??= download?.item;
        episode ??= download?.episode;
      }

      if (item == null) {
        return;
      }

      if (target.episodeId != null && episode != null) {
        await playPodcastEpisode(item, episode);
        return;
      }

      await playLibraryItem(item);
    } catch (e, s) {
      logger('Failed to play Android Auto media ID $mediaId: $e\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _androidAutoPlayFromSearch(String query, {Map<String, dynamic>? extras}) async {
    final results = await _androidAutoSearch(query, extras: extras);
    if (results.isEmpty) {
      return;
    }

    await _androidAutoPlayFromMediaId(results.first.id, extras: extras);
  }
}
