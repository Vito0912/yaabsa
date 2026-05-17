part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoBrowse on BGAudioHandler {
  Future<List<MediaItem>> _androidAutoRootItems() async {
    final isAutomotiveSystem = await _androidAutoIsAutomotiveSystem();
    final continueItems = await _androidAutoContinueAcrossLibraries(const _AndroidAutoPagingOptions(page: 0, pageSize: 1, hasExplicitPaging: true));

    final items = <MediaItem>[];

    if (continueItems.isNotEmpty) {
      items.add(
        _androidAutoBrowsableItem(
          id: _androidAutoContinueNodeId,
          title: 'Continue',
          artUri: _androidAutoDrawableIconUri('continue_ic'),
          categoryStyle: true,
        ),
      );
    }

    items.addAll([
      _androidAutoBrowsableItem(
        id: _androidAutoRecentNodeId,
        title: 'Recent',
        artUri: _androidAutoDrawableIconUri('recent'),
        categoryStyle: true,
      ),
      _androidAutoBrowsableItem(
        id: _androidAutoLibrariesNodeId,
        title: 'Libraries',
        artUri: _androidAutoDrawableIconUri('apps'),
        categoryStyle: true,
      ),
      if (!isAutomotiveSystem)
        _androidAutoBrowsableItem(id: _androidAutoDownloadsNodeId, title: 'Downloads', categoryStyle: true),
    ]);

    return items;
  }

  Future<List<MediaItem>> _androidAutoContinueAcrossLibraries(_AndroidAutoPagingOptions paging) async {
    final libraries = await _androidAutoFetchLibraries();
    if (libraries.isEmpty) {
      return const <MediaItem>[];
    }

    final entries = await Future.wait(
      libraries.map((library) async {
        return (library: library, personalized: await _androidAutoFetchPersonalizedLibrary(library.id));
      }),
    );

    final results = <MediaItem>[];
    final seen = <String>{};

    for (final entry in entries) {
      final continueItems = <LibraryItem>[
        ...?entry.personalized?.continueListening?.entities,
        ...?entry.personalized?.continueSeries?.entities,
      ];

      for (final item in continueItems) {
        final mediaItem = _androidAutoMediaEntryFromLibraryItem(item);
        if (mediaItem == null) {
          continue;
        }

        if (!seen.add(mediaItem.id)) {
          continue;
        }

        results.add(mediaItem);
      }
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(results, paging) : results;
  }

  Future<List<MediaItem>> _androidAutoRecentAcrossLibraries(_AndroidAutoPagingOptions paging) async {
    final libraries = await _androidAutoFetchLibraries();
    if (libraries.isEmpty) {
      return const <MediaItem>[];
    }

    final entries = await Future.wait(
      libraries.map((library) async {
        return (library: library, personalized: await _androidAutoFetchPersonalizedLibrary(library.id));
      }),
    );

    final results = <MediaItem>[];
    final seen = <String>{};

    for (final entry in entries) {
      final recentItems = <LibraryItem>[...?entry.personalized?.recentlyAdded?.entities];

      for (final item in recentItems) {
        final mediaItem = _androidAutoMediaEntryFromLibraryItem(item);
        if (mediaItem == null) {
          continue;
        }

        if (!seen.add(mediaItem.id)) {
          continue;
        }

        results.add(mediaItem);
      }
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(results, paging) : results;
  }

  Future<List<MediaItem>> _androidAutoRecentLibraryNodes(_AndroidAutoPagingOptions paging) async {
    final libraries = await _androidAutoFetchLibraries();
    if (libraries.isEmpty) {
      return const <MediaItem>[];
    }

    final nodes = libraries
        .map(
          (library) => _androidAutoBrowsableItem(
            id: _androidAutoRecentLibraryNodeId(library.id),
            title: library.name,
            categoryStyle: true,
          ),
        )
        .toList(growable: false);

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(nodes, paging) : nodes;
  }

  Future<List<MediaItem>> _androidAutoRecentForLibrary(String libraryId, _AndroidAutoPagingOptions paging) async {
    final personalized = await _androidAutoFetchPersonalizedLibrary(libraryId);
    final recentItems = personalized?.recentlyAdded?.entities ?? const <LibraryItem>[];
    if (recentItems.isEmpty) {
      return const <MediaItem>[];
    }

    final playableItems = <MediaItem>[];

    for (final item in recentItems) {
      final mediaItem = _androidAutoMediaEntryFromLibraryItem(item);
      if (mediaItem == null) {
        continue;
      }
      playableItems.add(mediaItem);
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(playableItems, paging) : playableItems;
  }

  Future<List<MediaItem>> _androidAutoLibraryNodes(_AndroidAutoPagingOptions paging) async {
    final libraries = await _androidAutoFetchLibraries();
    if (libraries.isEmpty) {
      return const <MediaItem>[];
    }

    final nodes = libraries
        .map(
          (library) => _androidAutoBrowsableItem(
            id: _androidAutoLibraryNodeId(library.id),
            title: library.name,
            categoryStyle: true,
          ),
        )
        .toList(growable: false);

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(nodes, paging) : nodes;
  }

  Future<List<_AndroidAutoLibraryTab>> _androidAutoTabsForLibrary(String libraryId) async {
    if (!await _androidAutoLibraryIsPodcast(libraryId)) {
      return _AndroidAutoLibraryTab.values.toList(growable: false);
    }

    return _AndroidAutoLibraryTab.values
        .where(
          (tab) =>
              tab != _AndroidAutoLibraryTab.authors &&
              tab != _AndroidAutoLibraryTab.series &&
              tab != _AndroidAutoLibraryTab.continueSeries &&
              tab != _AndroidAutoLibraryTab.narrators,
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoLibraryTabNodes(String libraryId) async {
    final tabs = await _androidAutoTabsForLibrary(libraryId);
    return tabs
        .map(
          (tab) => _androidAutoBrowsableItem(
            id: _androidAutoLibraryTabNodeId(libraryId, tab),
            title: tab.label,
            subtitle: tab.subtitle,
            artUri: _androidAutoLibraryTabIconUri(tab),
            categoryStyle: true,
          ),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoLibraryTabChildren(
    String libraryId,
    _AndroidAutoLibraryTab tab,
    _AndroidAutoPagingOptions paging,
  ) async {
    final isPodcastLibrary = await _androidAutoLibraryIsPodcast(libraryId);
    if (isPodcastLibrary &&
        (tab == _AndroidAutoLibraryTab.authors ||
            tab == _AndroidAutoLibraryTab.series ||
            tab == _AndroidAutoLibraryTab.narrators)) {
      return const <MediaItem>[];
    }

    switch (tab) {
      case _AndroidAutoLibraryTab.all:
        return _androidAutoAllItemsForLibrary(libraryId, paging, includeMoreNode: !paging.hasExplicitPaging);
      case _AndroidAutoLibraryTab.authors:
        return _androidAutoAuthorNodes(libraryId, paging);
      case _AndroidAutoLibraryTab.series:
        return _androidAutoSeriesNodes(libraryId, paging);
      case _AndroidAutoLibraryTab.collections:
        return _androidAutoCollectionNodes(libraryId, paging);
      case _AndroidAutoLibraryTab.playlists:
        return _androidAutoPlaylistNodes(libraryId, paging);
      case _AndroidAutoLibraryTab.discovery:
        return _androidAutoDiscoveryItems(libraryId, paging);
      case _AndroidAutoLibraryTab.continueSeries:
        return _androidAutoContinueSeriesItems(libraryId, paging);
      case _AndroidAutoLibraryTab.narrators:
        return _androidAutoNarratorNodes(libraryId, paging);
    }
  }

  Future<List<MediaItem>> _androidAutoAllItemsForLibrary(
    String libraryId,
    _AndroidAutoPagingOptions paging, {
    bool includeMoreNode = false,
  }) async {
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

    final page = await _androidAutoFetchLibraryItemsPage(
      libraryId: libraryId,
      paging: paging,
      sort: sortApiField,
      desc: desc,
      collapseseries: 0,
    );

    final mediaItems = _androidAutoMediaItemsFromLibraryItems(page.items, subtitlePrefix: '');
    if (includeMoreNode && page.hasMore) {
      mediaItems.add(_androidAutoBrowsableItem(id: _androidAutoAllPageNodeId(libraryId, page.page + 1), title: 'More'));
    }

    return mediaItems;
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
    final effectivePaging = paging.hasExplicitPaging
        ? paging
        : const _AndroidAutoPagingOptions(page: 0, pageSize: 10000, hasExplicitPaging: true);

    final series = await _androidAutoFetchSeriesForLibrary(libraryId, effectivePaging);
    return series
        .map((entry) => _androidAutoBrowsableItem(id: _androidAutoSeriesNodeId(libraryId, entry.id), title: entry.name))
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoCollectionNodes(String libraryId, _AndroidAutoPagingOptions paging) async {
    final collections = await _androidAutoFetchCollectionsForLibrary(libraryId);
    final selectedCollections = paging.hasExplicitPaging ? _androidAutoApplyPaging(collections, paging) : collections;

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
    final selectedPlaylists = paging.hasExplicitPaging ? _androidAutoApplyPaging(playlists, paging) : playlists;

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
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);
    final sortApiField = await _androidAutoSortApiFieldForLibrary(libraryId);

    if (!paging.hasExplicitPaging) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: sortApiField,
        desc: sortDescending ? 1 : 0,
        filter: LibraryFilter.grouped(LibraryFilterGroup.authors, authorId).queryValue,
        collapseseries: 0,
      );
      return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: '');
    }

    final items = await _androidAutoFetchLibraryItems(
      libraryId: libraryId,
      paging: paging,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.authors, authorId).queryValue,
      collapseseries: 0,
    );

    return _androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: '');
  }

  Future<List<MediaItem>> _androidAutoItemsForSeries(
    String libraryId,
    String seriesId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);

    if (!paging.hasExplicitPaging) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: 'sequence',
        desc: sortDescending ? 1 : 0,
        filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
        collapseseries: 0,
      );
      return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: '');
    }

    final items = await _androidAutoFetchLibraryItems(
      libraryId: libraryId,
      paging: paging,
      sort: 'sequence',
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
      collapseseries: 0,
    );

    return _androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: '');
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
    final sortDescending = await _androidAutoSortDescendingForLibrary(libraryId);
    final sortApiField = await _androidAutoSortApiFieldForLibrary(libraryId);

    if (!paging.hasExplicitPaging) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: sortApiField,
        desc: sortDescending ? 1 : 0,
        filter: LibraryFilter.grouped(LibraryFilterGroup.narrators, narrator).queryValue,
        collapseseries: 0,
      );
      return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: '');
    }

    final items = await _androidAutoFetchLibraryItems(
      libraryId: libraryId,
      paging: paging,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.narrators, narrator).queryValue,
      collapseseries: 0,
    );

    return _androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: '');
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

  String _androidAutoGroupingKey(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      return '#';
    }

    final first = trimmed[0].toUpperCase();
    return RegExp(r'[A-Z0-9]').hasMatch(first) ? first : '#';
  }

  int _androidAutoGroupingKeyComparator(String left, String right) {
    if (left == right) {
      return 0;
    }
    if (left == '#') {
      return 1;
    }
    if (right == '#') {
      return -1;
    }
    return left.compareTo(right);
  }

  String _androidAutoCountLabel(int count) {
    if (count == 1) {
      return '1 item';
    }
    return '$count items';
  }

  Uri _androidAutoLibraryTabIconUri(_AndroidAutoLibraryTab tab) {
    final drawableName = switch (tab) {
      _AndroidAutoLibraryTab.all => 'apps',
      _AndroidAutoLibraryTab.authors => 'person',
      _AndroidAutoLibraryTab.narrators => 'record_voice_over',
      _AndroidAutoLibraryTab.series => 'column',
      _AndroidAutoLibraryTab.collections => 'collections_bookmark',
      _AndroidAutoLibraryTab.playlists => 'playlist_play',
      _AndroidAutoLibraryTab.discovery => 'star',
      _AndroidAutoLibraryTab.continueSeries => 'history',
    };

    return _androidAutoDrawableIconUri(drawableName);
  }

  Uri _androidAutoDrawableIconUri(String drawableName) {
    final packageName = _androidAutoDrawablePackageName();
    final uri = Uri(scheme: 'android.resource', host: packageName, path: '/drawable/$drawableName');

    logger('AAOS drawable icon URI: $uri', tag: 'AudioHandler', level: InfoLevel.debug);

    return uri;
  }

  String _androidAutoDrawablePackageName() {
    try {
      final currentPackageName = packageInfo.packageName.trim();
      if (currentPackageName.isNotEmpty) {
        return currentPackageName;
      }
    } catch (_) {
      // Fall through to conservative defaults if package info is unavailable.
    }

    return kDebugMode ? 'de.vito0912.yaabsa.dev' : 'de.vito0912.yaabsa';
  }
}
