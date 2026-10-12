part of '../bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoBrowse on BGAudioHandler {
  Future<List<MediaItem>> _androidAutoRootItems() async {
    final isAutomotiveSystem = await _androidAutoIsAutomotiveSystem();

    if (isAutomotiveSystem) {
      final snapshot = await _androidAutoGetBrowseSnapshot(this);
      if (snapshot.continueItems.isEmpty && snapshot.audioLibraries.isEmpty && snapshot.downloadItems.isEmpty) {
        playbackState.add(
          playbackState.value.copyWith(
            processingState: _currentMediaItem == null
                ? AudioProcessingState.error
                : playbackState.value.processingState,
            errorCode: 1,
            errorMessage: snapshot.remoteContentUnavailable
                ? 'Unable to connect. Loading after your first sign-in can take some time. Check your server in Settings if this continues.'
                : 'No audio available yet. The first sign-in may take a little longer. Add audiobooks, podcasts or downloads if this continues.',
          ),
        );
        _aaosScheduleRetry(this);
        throw PlatformException(code: 'browse_unavailable', message: playbackState.value.errorMessage);
      }
      if (playbackState.value.errorCode == 1) {
        await _updatePlaybackState();
      }
      return buildAndroidAutoRoot(
        snapshot,
        session: _androidAutoBrowseSession,
        artUriForNode: (nodeId) => _androidAutoDrawableIconUri(nodeId),
      );
    }

    final items = <MediaItem>[];

    items.addAll([
      _androidAutoBrowsableItem(
        id: isAutomotiveSystem
            ? _androidAutoSessionNodeId(this, _androidAutoContinueNodeId)
            : _androidAutoContinueNodeId,
        title: 'Continue',
        artUri: _androidAutoDrawableIconUri('continue_ic'),
        categoryStyle: true,
      ),
      _androidAutoBrowsableItem(
        id: isAutomotiveSystem
            ? _androidAutoSessionNodeId(this, _androidAutoLibrariesNodeId)
            : _androidAutoLibrariesNodeId,
        title: 'Libraries',
        artUri: _androidAutoDrawableIconUri('apps'),
        categoryStyle: true,
      ),
      if (!isAutomotiveSystem)
        _androidAutoBrowsableItem(id: _androidAutoDownloadsNodeId, title: 'Downloads', categoryStyle: true),
    ]);

    return items;
  }

  Future<List<MediaItem>> _androidAutoContinueAcrossLibraries(
    _AndroidAutoPagingOptions paging, {
    List<Library>? libraries,
    Map<String, PersonalizedLibrary?>? personalizedByLibraryId,
  }) async {
    if (await _androidAutoIsAutomotiveSystem() && libraries == null && personalizedByLibraryId == null) {
      final snapshot = await _androidAutoGetBrowseSnapshot(this);
      final items = _aaosContinueWithProgress(this, snapshot.continueItems);

      return paging.hasExplicitPaging ? _androidAutoApplyPaging(items, paging) : items;
    }

    final resolvedLibraries = libraries ?? await _androidAutoFetchLibraries();
    if (resolvedLibraries.isEmpty) {
      return const <MediaItem>[];
    }

    final entries = await Future.wait(
      resolvedLibraries.map((library) async {
        final personalized = personalizedByLibraryId?.containsKey(library.id) == true
            ? personalizedByLibraryId![library.id]
            : await _androidAutoFetchPersonalizedLibrary(library.id);
        return (library: library, personalized: personalized);
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

  Future<List<MediaItem>> _androidAutoRecentLibraryNodes(
    _AndroidAutoPagingOptions paging, {
    List<Library>? libraries,
  }) async {
    final resolvedLibraries =
        libraries ??
        (await _androidAutoIsAutomotiveSystem()
            ? (await _androidAutoGetBrowseSnapshot(this)).audioLibraries
            : await _androidAutoFetchLibraries());
    if (resolvedLibraries.isEmpty) {
      return const <MediaItem>[];
    }

    final nodes = resolvedLibraries
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

  Future<List<MediaItem>> _androidAutoRecentForLibrary(String libraryId, _AndroidAutoPagingOptions paging) {
    return _aaosAllItemsPage(this, libraryId, paging, kind: 'recently-added');
  }

  Future<List<MediaItem>> _androidAutoLibraryNodes(_AndroidAutoPagingOptions paging, {List<Library>? libraries}) async {
    final resolvedLibraries =
        libraries ??
        (await _androidAutoIsAutomotiveSystem()
            ? (await _androidAutoGetBrowseSnapshot(this)).audioLibraries
            : await _androidAutoFetchLibraries());
    if (resolvedLibraries.isEmpty) {
      return const <MediaItem>[];
    }

    final nodes = resolvedLibraries
        .map(
          (library) => _androidAutoBrowsableItem(
            id: _androidAutoLibraryNodeId(library.id),
            title: library.name,
            artUri: _androidAutoLibraryIconUri(library),
            categoryStyle: true,
          ),
        )
        .toList(growable: false);

    return paging.hasExplicitPaging ? _androidAutoApplyPaging(nodes, paging) : nodes;
  }

  Future<List<_AndroidAutoLibraryTab>> _androidAutoTabsForLibrary(String libraryId) async {
    final library = await _androidAutoLibraryForId(libraryId);
    final isBookLibrary = library?.mediaType == 'book';
    final isPodcastLibrary = library?.mediaType == 'podcast';

    return _AndroidAutoLibraryTab.values
        .where((tab) {
          switch (tab) {
            case _AndroidAutoLibraryTab.latestEpisodes:
              return isPodcastLibrary;
            case _AndroidAutoLibraryTab.authors:
            case _AndroidAutoLibraryTab.series:
            case _AndroidAutoLibraryTab.continueSeries:
            case _AndroidAutoLibraryTab.narrators:
              return isBookLibrary;
            default:
              return true;
          }
        })
        .toList(growable: false);
  }

  Future<List<MediaItem>> _androidAutoLibraryTabNodes(String libraryId) async {
    if (await _androidAutoIsAutomotiveSystem()) {
      return _aaosLibraryTabNodes(this, libraryId);
    }
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
    if (!await _androidAutoIsAutomotiveSystem()) {
      return _androidAutoLibraryTabChildrenLive(libraryId, tab, paging);
    }
    return _carBrowseRequest(
      this,
      'tab/$libraryId/${tab.key}/${paging.page}/${paging.pageSize}/${paging.hasExplicitPaging}',
      () => _androidAutoLibraryTabChildrenLive(libraryId, tab, paging),
    );
  }

  Future<List<MediaItem>> _androidAutoLibraryTabChildrenLive(
    String libraryId,
    _AndroidAutoLibraryTab tab,
    _AndroidAutoPagingOptions paging,
  ) async {
    final isPodcastLibrary = await _androidAutoLibraryIsPodcast(libraryId);
    if (!isPodcastLibrary && tab == _AndroidAutoLibraryTab.latestEpisodes) {
      return const <MediaItem>[];
    }
    if (isPodcastLibrary &&
        (tab == _AndroidAutoLibraryTab.authors ||
            tab == _AndroidAutoLibraryTab.series ||
            tab == _AndroidAutoLibraryTab.continueSeries ||
            tab == _AndroidAutoLibraryTab.narrators)) {
      return const <MediaItem>[];
    }

    switch (tab) {
      case _AndroidAutoLibraryTab.all:
        return _androidAutoAllItemsForLibrary(libraryId, paging);
      case _AndroidAutoLibraryTab.recentlyAdded:
        return _androidAutoRecentForLibrary(libraryId, paging);
      case _AndroidAutoLibraryTab.latestEpisodes:
        return _androidAutoLatestEpisodesForLibrary(libraryId, paging);
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

  Future<List<MediaItem>> _androidAutoLatestEpisodesForLibrary(
    String libraryId,
    _AndroidAutoPagingOptions paging,
  ) async {
    final episodes = await _androidAutoFetchRecentEpisodesPage(libraryId, paging);
    if (episodes.isEmpty) {
      return const <MediaItem>[];
    }

    final mediaItems = <MediaItem>[];
    final seen = <String>{};
    for (final episode in episodes) {
      final mediaItem = _androidAutoPlayableFromRecentEpisode(episode);
      if (mediaItem == null || !seen.add(mediaItem.id)) {
        continue;
      }
      mediaItems.add(mediaItem);
    }

    return mediaItems;
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
      _AndroidAutoLibraryTab.recentlyAdded => 'recent',
      _AndroidAutoLibraryTab.latestEpisodes => 'recent',
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
    final uri = Uri(scheme: 'content', host: '$packageName.covers', path: '/drawable/$drawableName');

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
