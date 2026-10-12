part of '../bg_audio_handler.dart';

extension _BGAudioHandlerAndroidAutoEntry on BGAudioHandler {
  Future<void> _androidAutoHandleSignedOutIfAutomotive() async {
    if (!await _androidAutoIsAutomotiveSystem()) {
      return;
    }

    logger('[AAOS] logout observed', tag: 'AudioHandler', level: InfoLevel.info);
    await _androidAutoAuthenticationChanged(this, authenticated: false);
  }

  Future<bool> _androidAutoEnsureAuthenticatedUser() async {
    if (!await _androidAutoHasAuthenticatedUser()) {
      logger('[AAOS] authenticated user not present', tag: 'AudioHandler', level: InfoLevel.info);
      _androidAutoSetAuthenticationRequiredStateIfNeeded(this);
      return false;
    }

    logger('[AAOS] authenticated user present', tag: 'AudioHandler', level: InfoLevel.debug);
    await _androidAutoClearAuthenticationRequiredState(this);
    return true;
  }

  Future<bool> _androidAutoHasAuthenticatedUser() async {
    final currentUser = await _androidAutoCurrentUser();
    final apiUserId = _ref.read(absApiProvider)?.user?.id;
    if (currentUser == null || apiUserId != currentUser.id) {
      return false;
    }
    return true;
  }

  Future<List<MediaItem>> _androidAutoGetChildren(String parentMediaId, {Map<String, dynamic>? options}) async {
    final isAutomotiveSystem = await _androidAutoIsAutomotiveSystem();
    if (isAutomotiveSystem &&
        (parentMediaId == AudioService.browsableRootId || parentMediaId == AudioService.recentRootId)) {
      logger('[AAOS] getChildren($parentMediaId)', tag: 'AudioHandler', level: InfoLevel.debug);
    }

    var authenticationState = await _androidAutoAuthenticationState(this);

    if (isAutomotiveSystem && authenticationState == _AndroidAutoAuthenticationState.initializing) {
      _aaosBeginBrowseLoading(this);
      await _aaosWaitForBrowseReady(this);
      authenticationState = await _androidAutoAuthenticationState(this);

      if (authenticationState == _AndroidAutoAuthenticationState.initializing) {
        _aaosScheduleRetry(this);
        throw PlatformException(code: 'browse_not_ready', message: 'Loading content');
      }
    }

    if (authenticationState != _AndroidAutoAuthenticationState.authenticated) {
      if (isAutomotiveSystem) {
        if (authenticationState == _AndroidAutoAuthenticationState.authRequired) {
          _androidAutoSetAuthenticationRequiredStateIfNeeded(this);
        }
        final isInitializing = authenticationState == _AndroidAutoAuthenticationState.initializing;
        throw PlatformException(
          code: isInitializing ? 'browse_not_ready' : 'authentication_expired',
          message: isInitializing ? 'AAOS browse API is not ready' : _androidAutoAuthenticationRequiredMessage,
        );
      }

      return <MediaItem>[
        _androidAutoBrowsableItem(
          id: 'aa/auth-required/$parentMediaId',
          title: _androidAutoUnauthenticatedContentUnavailableMessage,
          subtitle: _androidAutoUnauthenticatedSignInHintMessage,
        ),
      ];
    }

    if (isAutomotiveSystem) {
      _aaosBeginBrowseLoading(this);
      unawaited(_androidAutoEnsureMediaProgress());
    }

    final resolvedParentMediaId = isAutomotiveSystem
        ? _androidAutoNormalizeSessionNodeId(parentMediaId)
        : parentMediaId;
    final paging = _androidAutoPagingFromOptions(options);
    final isTopLevelAuthenticatedNode =
        resolvedParentMediaId == AudioService.browsableRootId ||
        resolvedParentMediaId == _androidAutoContinueNodeId ||
        resolvedParentMediaId == _androidAutoRecentNodeId ||
        resolvedParentMediaId == _androidAutoLibrariesNodeId ||
        resolvedParentMediaId == AudioService.recentRootId;
    if (isAutomotiveSystem && paging.page == 0 && isTopLevelAuthenticatedNode) {
      logger(
        '[AAOS] waiting for browse preparation before getChildren($resolvedParentMediaId)',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      await _androidAutoPrepareBrowse(this);
    }

    if (paging.page == 0) {
      final primedChildren = _androidAutoPrimedChildren.remove(resolvedParentMediaId);
      if (primedChildren != null) {
        final children = isAutomotiveSystem && resolvedParentMediaId == _androidAutoContinueNodeId
            ? _aaosContinueWithProgress(this, primedChildren)
            : primedChildren;

        return paging.hasExplicitPaging ? _androidAutoApplyPaging(children, paging) : children;
      }
    }

    final pageNode = _aaosPageNode(resolvedParentMediaId);
    if (pageNode != null) {
      return _aaosLoadPage(this, pageNode);
    }

    if (resolvedParentMediaId == AudioService.browsableRootId) {
      return _androidAutoRootItems();
    }

    if (resolvedParentMediaId == AudioService.recentRootId) {
      return _androidAutoRecentLibraryNodes(paging);
    }

    if (resolvedParentMediaId == _androidAutoDownloadsNodeId) {
      return _androidAutoDownloadItems(paging);
    }

    if (resolvedParentMediaId == _androidAutoContinueNodeId) {
      return _androidAutoContinueAcrossLibraries(paging);
    }

    if (resolvedParentMediaId == _androidAutoRecentNodeId) {
      return _androidAutoRecentLibraryNodes(paging);
    }

    final recentLibraryId = _androidAutoRecentLibraryIdFromNode(resolvedParentMediaId);
    if (recentLibraryId != null) {
      return _androidAutoRecentForLibrary(recentLibraryId, paging);
    }

    if (resolvedParentMediaId == _androidAutoLibrariesNodeId) {
      return _androidAutoLibraryNodes(paging);
    }

    final libraryNodeId = _androidAutoLibraryIdFromNode(resolvedParentMediaId);
    if (libraryNodeId != null) {
      return _androidAutoLibraryTabNodes(libraryNodeId);
    }

    final allLetterInfo = _androidAutoAllLetterNodeFromId(resolvedParentMediaId);
    if (allLetterInfo != null) {
      return _androidAutoAllItemsForLetter(allLetterInfo.libraryId, allLetterInfo.letter, paging);
    }

    final libraryTabInfo = _androidAutoLibraryTabFromNode(resolvedParentMediaId);
    if (libraryTabInfo != null) {
      return _androidAutoLibraryTabChildren(libraryTabInfo.libraryId, libraryTabInfo.tab, paging);
    }

    final podcastItemId = _androidAutoPodcastItemIdFromNode(resolvedParentMediaId);
    if (podcastItemId != null) {
      return _androidAutoPodcastEpisodesForItem(podcastItemId, paging);
    }

    final authorInfo = _androidAutoAuthorNodeFromId(resolvedParentMediaId);
    if (authorInfo != null) {
      return _androidAutoItemsForAuthor(authorInfo.libraryId, authorInfo.authorId, paging);
    }

    final seriesInfo = _androidAutoSeriesNodeFromId(resolvedParentMediaId);
    if (seriesInfo != null) {
      return _androidAutoItemsForSeries(seriesInfo.libraryId, seriesInfo.seriesId, paging);
    }

    final collectionInfo = _androidAutoCollectionNodeFromId(resolvedParentMediaId);
    if (collectionInfo != null) {
      return _androidAutoItemsForCollection(collectionInfo.libraryId, collectionInfo.collectionId, paging);
    }

    final playlistInfo = _androidAutoPlaylistNodeFromId(resolvedParentMediaId);
    if (playlistInfo != null) {
      return _androidAutoItemsForPlaylist(playlistInfo.libraryId, playlistInfo.playlistId, paging);
    }

    final narratorInfo = _androidAutoNarratorNodeFromId(resolvedParentMediaId);
    if (narratorInfo != null) {
      return _androidAutoItemsForNarrator(narratorInfo.libraryId, narratorInfo.narrator, paging);
    }

    return const <MediaItem>[];
  }

  Future<MediaItem?> _androidAutoGetMediaItem(String mediaId) async {
    if (!await _androidAutoEnsureAuthenticatedUser()) {
      return null;
    }

    if (await _androidAutoIsAutomotiveSystem()) {
      unawaited(_androidAutoEnsureMediaProgress());
    }

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

    if (target.episodeId != null) {
      if (episode == null) {
        return null;
      }

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
    if (!await _androidAutoEnsureAuthenticatedUser()) {
      return const <MediaItem>[];
    }

    if (await _androidAutoIsAutomotiveSystem()) {
      await _androidAutoEnsureMediaProgress();
    }

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
    final mediaLibraries = libraries
        .where((library) => library.mediaType == 'book' || library.mediaType == 'podcast')
        .toList(growable: false);
    if (mediaLibraries.isEmpty) {
      return const <MediaItem>[];
    }

    final searchResults = await Future.wait(
      mediaLibraries.map((library) async {
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
      final libraryItems = <SearchLibraryResult>[...?entry.result?.book, ...?entry.result?.podcast];

      for (final searchResult in libraryItems) {
        final libraryItem = searchResult.libraryItem;
        if (libraryItem == null) {
          continue;
        }

        final mediaItem = _androidAutoMediaEntryFromLibraryItem(libraryItem);
        if (mediaItem == null || !seen.add(mediaItem.id)) {
          continue;
        }

        mediaItems.add(mediaItem);
      }
    }

    return _androidAutoApplyPaging(mediaItems, paging);
  }

  Future<void> _androidAutoPlayFromMediaId(String mediaId, {Map<String, dynamic>? extras}) async {
    if (!await _androidAutoEnsureAuthenticatedUser()) {
      return;
    }

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

      if (target.episodeId != null) {
        if (episode == null) {
          return;
        }

        final resolvedEpisode = episode;
        final orderedEpisodes = await _androidAutoOrderedPlayablePodcastEpisodes(item);
        final episodeIndex = orderedEpisodes.indexWhere((entry) => entry.id == resolvedEpisode.id);
        await playPodcastEpisode(
          item,
          resolvedEpisode,
          episodeIndex: episodeIndex < 0 ? null : episodeIndex,
          orderedEpisodes: orderedEpisodes,
        );
        return;
      }

      if (_androidAutoIsPodcastLibraryItem(item)) {
        return;
      }

      await playLibraryItem(item);
    } catch (e, s) {
      logger('Failed to play Android Auto media ID $mediaId: $e\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _androidAutoPlayFromSearch(String query, {Map<String, dynamic>? extras}) async {
    if (!await _androidAutoEnsureAuthenticatedUser()) {
      return;
    }

    final results = await _androidAutoSearch(query, extras: extras);
    if (results.isEmpty) {
      return;
    }

    for (final result in results) {
      if (_androidAutoPlaybackTargetFromMediaId(result.id) != null) {
        await _androidAutoPlayFromMediaId(result.id, extras: extras);
        return;
      }

      final podcastItemId = _androidAutoPodcastItemIdFromNode(result.id);
      if (podcastItemId == null) {
        continue;
      }

      final episodes = await _androidAutoPodcastEpisodesForItem(
        podcastItemId,
        const _AndroidAutoPagingOptions(page: 0, pageSize: 1, hasExplicitPaging: true),
      );
      if (episodes.isEmpty) {
        continue;
      }

      await _androidAutoPlayFromMediaId(episodes.first.id, extras: extras);
      return;
    }
  }
}
