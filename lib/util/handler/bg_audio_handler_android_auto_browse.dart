part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoBrowse on BGAudioHandler {
  List<MediaItem> _androidAutoRootItems() {
    return <MediaItem>[
      _androidAutoBrowsableItem(id: _androidAutoContinueNodeId, title: 'Continue', categoryStyle: true),
      _androidAutoBrowsableItem(id: _androidAutoRecentNodeId, title: 'Recent', categoryStyle: true),
      _androidAutoBrowsableItem(id: _androidAutoLibrariesNodeId, title: 'Libraries', categoryStyle: true),
      _androidAutoBrowsableItem(id: _androidAutoDownloadsNodeId, title: 'Downloads', categoryStyle: true),
    ];
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
        if (!_androidAutoIsPlayableAudioItem(item)) {
          continue;
        }

        final mediaId = _androidAutoItemPlaybackId(item.id);
        if (!seen.add(mediaId)) {
          continue;
        }

        results.add(_androidAutoPlayableFromLibraryItem(item, mediaId: mediaId, subtitlePrefix: entry.library.name));
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
        if (!_androidAutoIsPlayableAudioItem(item)) {
          continue;
        }

        final mediaId = _androidAutoItemPlaybackId(item.id);
        if (!seen.add(mediaId)) {
          continue;
        }

        results.add(_androidAutoPlayableFromLibraryItem(item, mediaId: mediaId, subtitlePrefix: entry.library.name));
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

    final libraryName = await _androidAutoLibraryNameForId(libraryId);
    final playableItems = <MediaItem>[];

    for (final item in recentItems) {
      if (!_androidAutoIsPlayableAudioItem(item)) {
        continue;
      }
      playableItems.add(
        _androidAutoPlayableFromLibraryItem(
          item,
          mediaId: _androidAutoItemPlaybackId(item.id),
          subtitlePrefix: libraryName,
        ),
      );
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

  Future<List<MediaItem>> _androidAutoLibraryTabNodes(String libraryId) async {
    return _AndroidAutoLibraryTab.values
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
      case _AndroidAutoLibraryTab.narrators:
        return _androidAutoNarratorNodes(libraryId, paging);
    }
  }

  Future<List<MediaItem>> _androidAutoAllItemsForLibrary(
    String libraryId,
    _AndroidAutoPagingOptions paging, {
    bool includeMoreNode = false,
  }) async {
    final sortDescending = await _androidAutoLibrarySortDescending();
    final sortApiField = await _androidAutoLibrarySortApiField();
    final desc = sortDescending ? 1 : 0;
    final libraryName = await _androidAutoLibraryNameForId(libraryId);

    final shouldGroupByLetters = !paging.hasExplicitPaging && await _androidAutoGroupByLettersEnabled();
    if (shouldGroupByLetters) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: sortApiField,
        desc: desc,
        collapseseries: 0,
      );
      final playableItems = allItems.where(_androidAutoIsPlayableAudioItem).toList(growable: false);

      if (playableItems.length > _androidAutoLetterGroupingThreshold) {
        final countByLetter = <String, int>{};
        for (final item in playableItems) {
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

      return _androidAutoMediaItemsFromLibraryItems(playableItems, subtitlePrefix: libraryName);
    }

    final page = await _androidAutoFetchLibraryItemsPage(
      libraryId: libraryId,
      paging: paging,
      sort: sortApiField,
      desc: desc,
      collapseseries: 0,
    );

    final mediaItems = _androidAutoMediaItemsFromLibraryItems(page.items, subtitlePrefix: libraryName);
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

    final sortDescending = await _androidAutoLibrarySortDescending();
    final sortApiField = await _androidAutoLibrarySortApiField();
    final libraryName = await _androidAutoLibraryNameForId(libraryId);

    final allItems = await _androidAutoFetchAllLibraryItems(
      libraryId: libraryId,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      collapseseries: 0,
    );

    final filteredItems = allItems
        .where(
          (item) => _androidAutoIsPlayableAudioItem(item) && _androidAutoGroupingKey(item.title) == normalizedLetter,
        )
        .toList(growable: false);

    final mediaItems = _androidAutoMediaItemsFromLibraryItems(filteredItems, subtitlePrefix: libraryName);
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

    final libraryName = await _androidAutoLibraryNameForId(libraryId);
    final mediaItems = <MediaItem>[];

    for (final item in discoveryItems) {
      if (!_androidAutoIsPlayableAudioItem(item)) {
        continue;
      }
      mediaItems.add(
        _androidAutoPlayableFromLibraryItem(
          item,
          mediaId: _androidAutoItemPlaybackId(item.id),
          subtitlePrefix: libraryName,
        ),
      );
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

  Future<List<MediaItem>> _androidAutoItemsForAuthor(
    String libraryId,
    String authorId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final sortDescending = await _androidAutoLibrarySortDescending();
    final sortApiField = await _androidAutoLibrarySortApiField();
    final libraryName = await _androidAutoLibraryNameForId(libraryId);

    if (!paging.hasExplicitPaging) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: sortApiField,
        desc: sortDescending ? 1 : 0,
        filter: LibraryFilter.grouped(LibraryFilterGroup.authors, authorId).queryValue,
        collapseseries: 0,
      );
      return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: libraryName);
    }

    final items = await _androidAutoFetchLibraryItems(
      libraryId: libraryId,
      paging: paging,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.authors, authorId).queryValue,
      collapseseries: 0,
    );

    return _androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: libraryName);
  }

  Future<List<MediaItem>> _androidAutoItemsForSeries(
    String libraryId,
    String seriesId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final sortDescending = await _androidAutoLibrarySortDescending();
    final libraryName = await _androidAutoLibraryNameForId(libraryId);

    if (!paging.hasExplicitPaging) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: 'sequence',
        desc: sortDescending ? 1 : 0,
        filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
        collapseseries: 0,
      );
      return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: libraryName);
    }

    final items = await _androidAutoFetchLibraryItems(
      libraryId: libraryId,
      paging: paging,
      sort: 'sequence',
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.series, seriesId).queryValue,
      collapseseries: 0,
    );

    return _androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: libraryName);
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
      if (libraryItem == null || !_androidAutoIsPlayableAudioItem(libraryItem)) {
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

      final mediaId = _androidAutoItemPlaybackId(libraryItem.id);
      if (!seen.add(mediaId)) {
        continue;
      }

      mediaItems.add(_androidAutoPlayableFromLibraryItem(libraryItem, mediaId: mediaId, subtitlePrefix: playlist.name));
    }

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(mediaItems, paging) : mediaItems;
  }

  Future<List<MediaItem>> _androidAutoItemsForNarrator(
    String libraryId,
    String narrator,
    _AndroidAutoPagingOptions paging,
  ) async {
    final sortDescending = await _androidAutoLibrarySortDescending();
    final sortApiField = await _androidAutoLibrarySortApiField();
    final libraryName = await _androidAutoLibraryNameForId(libraryId);

    if (!paging.hasExplicitPaging) {
      final allItems = await _androidAutoFetchAllLibraryItems(
        libraryId: libraryId,
        sort: sortApiField,
        desc: sortDescending ? 1 : 0,
        filter: LibraryFilter.grouped(LibraryFilterGroup.narrators, narrator).queryValue,
        collapseseries: 0,
      );
      return _androidAutoMediaItemsFromLibraryItems(allItems, subtitlePrefix: libraryName);
    }

    final items = await _androidAutoFetchLibraryItems(
      libraryId: libraryId,
      paging: paging,
      sort: sortApiField,
      desc: sortDescending ? 1 : 0,
      filter: LibraryFilter.grouped(LibraryFilterGroup.narrators, narrator).queryValue,
      collapseseries: 0,
    );

    return _androidAutoMediaItemsFromLibraryItems(items, subtitlePrefix: libraryName);
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
      return '1 book';
    }
    return '$count books';
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
    };

    return Uri.parse('android.resource://${packageInfo.packageName}/drawable/$drawableName');
  }
}
