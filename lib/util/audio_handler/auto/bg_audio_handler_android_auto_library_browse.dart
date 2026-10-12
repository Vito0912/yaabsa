part of '../bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoLibraryBrowse on BGAudioHandler {
  Future<List<MediaItem>> _androidAutoAllItemsForLibrary(String libraryId, _AndroidAutoPagingOptions paging) async {
    if (await _androidAutoIsAutomotiveSystem() || paging.hasExplicitPaging) {
      return _aaosAllItemsPage(this, libraryId, paging);
    }
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);
    final sortApiField = await _androidAutoSortApiFieldForLibrary(libraryId);
    final desc = sortDescending ? 1 : 0;

    final shouldGroupByLetters = !paging.hasExplicitPaging && await _androidAutoGroupByLettersEnabled();
    if (shouldGroupByLetters) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: sortApiField,
        desc: desc,
        collapseseries: 0,
      );
      final displayableItems = allItems.where(_androidAutoIsSupportedAudioItem).toList(growable: false);

      if (displayableItems.length > _androidAutoLetterGroupingThreshold) {
        final countByLetter = <String, int>{};
        for (final item in displayableItems) {
          final key = _androidAutoGroupingKey(item.title);
          countByLetter.update(key, (count) => count + 1, ifAbsent: () => 1);
        }

        final letters = countByLetter.keys.toList(growable: false)..sort(_androidAutoGroupingKeyComparator);

        return letters
            .map(
              (letter) => _androidAutoBrowsableItem(
                id: _androidAutoAllLetterNodeId(libraryId, letter),
                title: letter,
                subtitle: _androidAutoCountLabel(countByLetter[letter] ?? 0),
              ),
            )
            .toList(growable: false);
      }

      return _androidAutoMediaItemsFromLibraryItems(displayableItems, subtitlePrefix: '');
    }

    return _aaosAllItemsPage(this, libraryId, paging);
  }

  Future<List<MediaItem>> _androidAutoAllItemsForLetter(
    String libraryId,
    String letter,
    _AndroidAutoPagingOptions paging,
  ) async {
    final normalizedLetter = letter.trim().toUpperCase();
    if (normalizedLetter.isEmpty) {
      return const <MediaItem>[];
    }

    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);
    final sortApiField = await _androidAutoSortApiFieldForLibrary(libraryId);
    final allItems = await _androidAutoFetchAllLibraryItems(
      libraryId: libraryId,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      collapseseries: 0,
    );

    final filteredItems = allItems
        .where(
          (item) => _androidAutoIsSupportedAudioItem(item) && _androidAutoGroupingKey(item.title) == normalizedLetter,
        )
        .toList(growable: false);

    final mediaItems = _androidAutoMediaItemsFromLibraryItems(filteredItems, subtitlePrefix: '');
    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }

  Future<List<MediaItem>> _androidAutoAuthorNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final filterData = await _androidAutoFetchFilterData(libraryId);
    final authors = [...?filterData?.authors]
      ..sort((left, right) => left.name.toLowerCase().compareTo(right.name.toLowerCase()));

    final selectedAuthors = paging.hasExplicitPaging ? _androidAutoApplyPaging(authors, paging) : authors;
    return selectedAuthors
        .map(
          (author) => _androidAutoBrowsableItem(id: _androidAutoAuthorNodeId(libraryId, author.id), title: author.name),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoSeriesNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    if (await _androidAutoIsAutomotiveSystem() || paging.hasExplicitPaging) {
      return _aaosSeriesPage(this, libraryId, paging);
    }

    final series = <Series>[];
    var nextPage = 0;

    while (true) {
      final page = await _androidAutoFetchSeriesPageForLibrary(
        libraryId,
        _AndroidAutoPagingOptions(page: nextPage, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: false),
      );
      series.addAll(page.series);

      if (!page.hasMore || page.series.isEmpty || page.page != nextPage) {
        break;
      }

      nextPage = page.page + 1;
    }

    final nodes = series
        .map((entry) => _androidAutoBrowsableItem(id: _androidAutoSeriesNodeId(libraryId, entry.id), title: entry.name))
        .toList(growable: false);
    return nodes;
  }

  Future<List<MediaItem>> _androidAutoCollectionNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final collections = await _androidAutoFetchCollectionsForLibrary(libraryId);
    final isAutomotive = await _androidAutoIsAutomotiveSystem();
    final displayableCollections = isAutomotive
        ? collections
              .where(
                (collection) => _androidAutoMediaItemsFromLibraryItems(
                  collection.items ?? const <LibraryItem>[],
                  subtitlePrefix: '',
                ).isNotEmpty,
              )
              .toList(growable: false)
        : collections;
    final selectedCollections = paging.hasExplicitPaging
        ? _androidAutoApplyPaging(displayableCollections, paging)
        : displayableCollections;

    return selectedCollections
        .map(
          (collection) => _androidAutoBrowsableItem(
            id: _androidAutoCollectionNodeId(libraryId, collection.id),
            title: collection.name,
          ),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoPlaylistNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final playlists = await _androidAutoFetchPlaylistsForLibrary(libraryId);
    final isAutomotive = await _androidAutoIsAutomotiveSystem();
    final displayablePlaylists = isAutomotive
        ? playlists
              .where(
                (playlist) => (playlist.items ?? const []).any(
                  (entry) =>
                      entry.libraryItem != null &&
                      _androidAutoIsSupportedAudioItem(entry.libraryItem!) &&
                      (entry.episodeId != null
                          ? entry.episode?.audioFile != null
                          : _androidAutoMediaEntryFromLibraryItem(entry.libraryItem!) != null),
                ),
              )
              .toList(growable: false)
        : playlists;
    final selectedPlaylists = paging.hasExplicitPaging
        ? _androidAutoApplyPaging(displayablePlaylists, paging)
        : displayablePlaylists;

    return selectedPlaylists
        .map(
          (playlist) =>
              _androidAutoBrowsableItem(id: _androidAutoPlaylistNodeId(libraryId, playlist.id), title: playlist.name),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoDiscoveryItems(String libraryId, _AndroidAutoPagingOptions paging) async {
    final personalized = await _androidAutoFetchPersonalizedLibrary(libraryId);
    final discoveryItems = personalized?.discover?.entities ?? const <LibraryItem>[];
    if (discoveryItems.isEmpty) {
      return const <MediaItem>[];
    }

    final mediaItems = <MediaItem>[];

    for (final item in discoveryItems) {
      final mediaItem = _androidAutoMediaEntryFromLibraryItem(item);
      if (mediaItem == null) {
        continue;
      }
      mediaItems.add(mediaItem);
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }

  Future<List<MediaItem>> _androidAutoContinueSeriesItems(String libraryId, _AndroidAutoPagingOptions paging) async {
    final personalized = await _androidAutoFetchPersonalizedLibrary(libraryId);
    final continueSeriesItems = personalized?.continueSeries?.entities ?? const <LibraryItem>[];
    if (continueSeriesItems.isEmpty) {
      return const <MediaItem>[];
    }

    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final item in continueSeriesItems) {
      final mediaItem = _androidAutoMediaEntryFromLibraryItem(item);
      if (mediaItem == null || !seen.add(mediaItem.id)) {
        continue;
      }
      mediaItems.add(mediaItem);
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }

  Future<List<MediaItem>> _androidAutoNarratorNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final filterData = await _androidAutoFetchFilterData(libraryId);
    final narrators =
        (filterData?.narrators ?? const <String>[])
            .map((name) => name.trim())
            .where((name) => name.isNotEmpty)
            .toSet()
            .toList(growable: false)
          ..sort((left, right) => left.toLowerCase().compareTo(right.toLowerCase()));

    final selectedNarrators = paging.hasExplicitPaging ? _androidAutoApplyPaging(narrators, paging) : narrators;

    return selectedNarrators
        .map(
          (narrator) => _androidAutoBrowsableItem(id: _androidAutoNarratorNodeId(libraryId, narrator), title: narrator),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoPodcastEpisodesForItem(String itemId, _AndroidAutoPagingOptions paging) async {
    LibraryItem? item = await resolveQueueLibraryItem(itemId);
    item ??= (await _androidAutoStoredDownload(itemId))?.item;
    if (item == null || !_androidAutoIsPodcastLibraryItem(item)) {
      return const <MediaItem>[];
    }

    final episodes = await _androidAutoOrderedPlayablePodcastEpisodes(item);
    if (episodes.isEmpty) {
      return const <MediaItem>[];
    }

    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final episode in episodes) {
      final mediaItem = _androidAutoPlayableFromEpisode(item: item, episode: episode);
      if (!seen.add(mediaItem.id)) {
        continue;
      }
      mediaItems.add(mediaItem);
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }

  Future<List<MediaItem>> _androidAutoItemsForAuthor(
    String libraryId,
    String authorId,
    _AndroidAutoPagingOptions paging,
  ) async {
    if (await _androidAutoIsAutomotiveSystem() || paging.hasExplicitPaging) {
      return _aaosAllItemsPage(this, libraryId, paging, kind: 'author/$authorId');
    }
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);
    final sortApiField = await _androidAutoSortApiFieldForLibrary(libraryId);

    final allItems = await _androidAutoFetchAllLibraryItems(
      libraryId: libraryId,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.authors, authorId).queryValue,
      collapseseries: 0,
    );
    return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: '');
  }

  Future<List<MediaItem>> _androidAutoItemsForSeries(
    String libraryId,
    String seriesId,
    _AndroidAutoPagingOptions paging,
  ) async {
    if (await _androidAutoIsAutomotiveSystem() || paging.hasExplicitPaging) {
      return _aaosAllItemsPage(this, libraryId, paging, kind: 'series-items/$seriesId');
    }
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);

    final allItems = await _androidAutoFetchAllLibraryItems(
      libraryId: libraryId,
      sort: 'sequence',
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
      collapseseries: 0,
    );
    return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: '');
  }

  Future<List<MediaItem>> _androidAutoItemsForCollection(
    String libraryId,
    String collectionId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final collections = await _androidAutoFetchCollectionsForLibrary(libraryId);
    Collection? collection;
    for (final entry in collections) {
      if (entry.id == collectionId) {
        collection = entry;
        break;
      }
    }

    if (collection == null) {
      return const <MediaItem>[];
    }

    final allItems = collection.items ?? const <LibraryItem>[];
    final selectedItems = paging.hasExplicitPaging ? _androidAutoApplyPaging(allItems, paging) : allItems;

    return _androidAutoMediaItemsFromLibraryItems(selectedItems, subtitlePrefix: collection.name);
  }

  Future<List<MediaItem>> _androidAutoItemsForPlaylist(
    String libraryId,
    String playlistId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final playlists = await _androidAutoFetchPlaylistsForLibrary(libraryId);
    Playlist? playlist;
    for (final entry in playlists) {
      if (entry.id == playlistId) {
        playlist = entry;
        break;
      }
    }

    if (playlist == null) {
      return const <MediaItem>[];
    }

    final playlistItems = playlist.items ?? const [];
    if (playlistItems.isEmpty) {
      return const <MediaItem>[];
    }

    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final playlistItem in playlistItems) {
      final libraryItem = playlistItem.libraryItem;
      if (libraryItem == null || !_androidAutoIsSupportedAudioItem(libraryItem)) {
        continue;
      }

      final episode = playlistItem.episode;
      if (episode != null && playlistItem.episodeId != null) {
        if (episode.audioFile == null) {
          continue;
        }

        final item = _androidAutoPlayableFromEpisode(
          item: libraryItem,
          episode: episode,
          subtitlePrefix: playlist.name,
        );
        if (seen.add(item.id)) {
          mediaItems.add(item);
        }
        continue;
      }

      final mediaItem = _androidAutoMediaEntryFromLibraryItem(libraryItem, subtitlePrefix: playlist.name);
      if (mediaItem == null || !seen.add(mediaItem.id)) {
        continue;
      }

      mediaItems.add(mediaItem);
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }

  Future<List<MediaItem>> _androidAutoItemsForNarrator(
    String libraryId,
    String narrator,
    _AndroidAutoPagingOptions paging,
  ) async {
    if (await _androidAutoIsAutomotiveSystem() || paging.hasExplicitPaging) {
      return _aaosAllItemsPage(this, libraryId, paging, kind: 'narrator/$narrator');
    }
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);
    final sortApiField = await _androidAutoSortApiFieldForLibrary(libraryId);

    final allItems = await _androidAutoFetchAllLibraryItems(
      libraryId: libraryId,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.narrators, narrator).queryValue,
      collapseseries: 0,
    );
    return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: '');
  }

  Future<List<MediaItem>> _androidAutoDownloadItems(_AndroidAutoPagingOptions paging) async {
    final user = await _androidAutoCurrentUser();
    if (user == null) {
      return const <MediaItem>[];
    }

    final downloads = await _ref.read(appDatabaseProvider).getAllStoredDownloadsByUser(user.id);
    final completeDownloads = downloads.where((download) => download.isComplete).toList(growable: false)
      ..sort(
        (left, right) =>
            _androidAutoDownloadTitle(left).toLowerCase().compareTo(_androidAutoDownloadTitle(right).toLowerCase()),
      );

    final mediaItems = <MediaItem>[];
    final seen = <String>{};

    for (final download in completeDownloads) {
      final mediaItem = _androidAutoPlayableFromDownload(download);
      if (mediaItem == null) {
        continue;
      }
      if (!seen.add(mediaItem.id)) {
        continue;
      }
      mediaItems.add(mediaItem);
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }
}
