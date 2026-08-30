part of '../bg_audio_handler.dart';

const String _androidAutoContinueNodeId = 'aa/continue';
const String _androidAutoRecentNodeId = 'aa/recent';
const String _androidAutoLibrariesNodeId = 'aa/libraries';
const String _androidAutoDownloadsNodeId = 'aa/downloads';
const String _androidAutoAutomotiveFeatureFlag = 'android.hardware.type.automotive';
const String _androidAutoBrowseSessionMarker = '/auth-session-';

bool? _androidAutoIsAutomotiveSystemCache;

String _androidAutoSessionNodeId(BGAudioHandler handler, String nodeId) {
  return '$nodeId$_androidAutoBrowseSessionMarker${handler._androidAutoBrowseSession}';
}

String _androidAutoNormalizeSessionNodeId(String nodeId) {
  for (final rootNodeId in const <String>[
    _androidAutoContinueNodeId,
    _androidAutoRecentNodeId,
    _androidAutoLibrariesNodeId,
  ]) {
    if (nodeId.startsWith('$rootNodeId$_androidAutoBrowseSessionMarker')) {
      return rootNodeId;
    }
  }
  return nodeId;
}

const String _androidAutoCompletionStatusExtrasKey = 'android.media.extra.PLAYBACK_STATUS';
const String _androidAutoCompletionPercentageExtrasKey = 'androidx.media.MediaItem.Extras.COMPLETION_PERCENTAGE';
const int _androidAutoCompletionStatusNotPlayed = 0;
const int _androidAutoCompletionStatusPartiallyPlayed = 1;
const int _androidAutoCompletionStatusFullyPlayed = 2;

const int _androidAutoDefaultPageSize = 100;
const int _androidAutoSeriesPageSize = 10;
const int _androidAutoMaxPageSize = 200;
const int _androidAutoSearchResultsPerLibrary = 4;
const int _androidAutoLetterGroupingThreshold = 30;
const int _androidAutoAuthenticationRequiredErrorCode = 3;
const String _androidAutoAuthenticationRequiredMessage = 'Authentication required';
const String _androidAutoUnauthenticatedContentUnavailableMessage = 'No content is avaiable if not signed in.';
const String _androidAutoUnauthenticatedSignInHintMessage = 'You can sign in via the settings';

const String _androidAutoSortFieldTitle = 'title';
const String _androidAutoSortFieldAuthor = 'author';
const String _androidAutoSortFieldAdded = 'added';

const Map<String, String> _androidAutoBookSortFieldToApiSort = <String, String>{
  _androidAutoSortFieldTitle: 'media.metadata.title',
  _androidAutoSortFieldAuthor: 'media.metadata.authorName',
  _androidAutoSortFieldAdded: 'addedAt',
};

const Map<String, String> _androidAutoPodcastSortFieldToApiSort = <String, String>{
  _androidAutoSortFieldTitle: 'media.metadata.title',
  _androidAutoSortFieldAuthor: 'media.metadata.author',
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

class _AndroidAutoSeriesPage {
  const _AndroidAutoSeriesPage({required this.series, required this.total, required this.page, required this.pageSize});

  final List<Series> series;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => ((page + 1) * pageSize) < total;
}

enum _AndroidAutoLibraryTab {
  all,
  latestEpisodes,
  authors,
  series,
  collections,
  playlists,
  discovery,
  continueSeries,
  narrators,
}

extension _AndroidAutoLibraryTabX on _AndroidAutoLibraryTab {
  String get key {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'all';
      case _AndroidAutoLibraryTab.latestEpisodes:
        return 'latest-episodes';
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
      case _AndroidAutoLibraryTab.continueSeries:
        return 'continue-series';
      case _AndroidAutoLibraryTab.narrators:
        return 'narrators';
    }
  }

  String get label {
    switch (this) {
      case _AndroidAutoLibraryTab.all:
        return 'All';
      case _AndroidAutoLibraryTab.latestEpisodes:
        return 'Latest Episodes';
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
      case _AndroidAutoLibraryTab.continueSeries:
        return 'Continue Series';
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

Future<bool> _androidAutoIsAutomotiveSystem() async {
  if (kIsWeb || !Platform.isAndroid) {
    return false;
  }

  final cached = _androidAutoIsAutomotiveSystemCache;
  if (cached != null) {
    return cached;
  }

  try {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final isAutomotive = androidInfo.systemFeatures.contains(_androidAutoAutomotiveFeatureFlag);
    _androidAutoIsAutomotiveSystemCache = isAutomotive;
    return isAutomotive;
  } catch (error) {
    logger(
      'Failed to detect automotive system for car browse root: $error',
      tag: 'AudioHandler',
      level: InfoLevel.warning,
    );
    _androidAutoIsAutomotiveSystemCache = false;
    return false;
  }
}

void _androidAutoSetAuthenticationRequiredStateIfNeeded(BGAudioHandler handler) {
  final currentState = handler.playbackState.value;
  if (currentState.errorCode == _androidAutoAuthenticationRequiredErrorCode) {
    return;
  }

  logger('[AAOS] authentication required', tag: 'AudioHandler', level: InfoLevel.info);
  handler.playbackState.add(
    currentState.copyWith(
      controls: const <MediaControl>[],
      systemActions: const <MediaAction>{},
      androidCompactActionIndices: const <int>[],
      processingState: AudioProcessingState.error,
      playing: false,
      errorCode: _androidAutoAuthenticationRequiredErrorCode,
      errorMessage: _androidAutoAuthenticationRequiredMessage,
    ),
  );
}

Future<void> _androidAutoClearAuthenticationRequiredState(BGAudioHandler handler) async {
  if (handler.playbackState.value.errorCode != _androidAutoAuthenticationRequiredErrorCode) {
    return;
  }

  await handler._updatePlaybackState();
  logger('[AAOS] authentication requirement cleared', tag: 'AudioHandler', level: InfoLevel.info);
}

Future<void> _androidAutoRefreshBrowseRoots(BGAudioHandler handler) async {
  final activeRefresh = handler._androidAutoBrowseRefreshFuture;
  if (activeRefresh != null) {
    await activeRefresh;
    return;
  }

  final refresh = () async {
    const customBrowseNodeIds = <String>[
      _androidAutoContinueNodeId,
      _androidAutoRecentNodeId,
      _androidAutoLibrariesNodeId,
    ];
    final browseNodeIds = <String>[
      AudioService.browsableRootId,
      AudioService.recentRootId,
      ...customBrowseNodeIds,
      ...customBrowseNodeIds.map((nodeId) => _androidAutoSessionNodeId(handler, nodeId)),
    ];

    logger('[AAOS] browse refresh requested: ${browseNodeIds.join(', ')}', tag: 'AudioHandler', level: InfoLevel.info);
    for (final browseNodeId in browseNodeIds) {
      // ignore: deprecated_member_use
      await AudioServiceBackground.notifyChildrenChanged(browseNodeId);
    }
  }();
  handler._androidAutoBrowseRefreshFuture = refresh;

  try {
    await refresh;
  } finally {
    if (identical(handler._androidAutoBrowseRefreshFuture, refresh)) {
      handler._androidAutoBrowseRefreshFuture = null;
    }
  }
}

Future<void> _androidAutoAuthenticationChanged(BGAudioHandler handler, {required bool authenticated}) async {
  logger(
    '[AAOS] auth changed: authenticated=$authenticated; refreshing roots',
    tag: 'AudioHandler',
    level: InfoLevel.info,
  );

  if (authenticated) {
    final currentUser = await handler._androidAutoCurrentUser();
    if (currentUser != null && handler._androidAutoBrowseUserId != currentUser.id) {
      handler._androidAutoBrowseUserId = currentUser.id;
      handler._androidAutoBrowseSession += 1;
      handler._androidAutoPreparedForNextLaunch = false;
      handler._androidAutoPrimedChildren.clear();
      logger(
        '[AAOS] started authenticated browse session ${handler._androidAutoBrowseSession}',
        tag: 'AudioHandler',
        level: InfoLevel.info,
      );
    }
    await _androidAutoPrepareBrowse(handler);
    await _androidAutoClearAuthenticationRequiredState(handler);
  } else {
    handler._androidAutoBrowseUserId = null;
    handler._androidAutoPreparedForNextLaunch = false;
    handler._androidAutoPrimedChildren.clear();
    _androidAutoSetAuthenticationRequiredStateIfNeeded(handler);
  }

  await _androidAutoRefreshBrowseRoots(handler);
}

Future<void> _androidAutoPrepareBrowse(BGAudioHandler handler) async {
  if (!await _androidAutoIsAutomotiveSystem()) {
    return;
  }
  if (handler._androidAutoPreparedForNextLaunch) {
    return;
  }

  final activePreparation = handler._androidAutoBrowsePreparationFuture;
  if (activePreparation != null) {
    await activePreparation;
    if (handler._androidAutoPreparedForNextLaunch) {
      return;
    }
    if (identical(handler._androidAutoBrowsePreparationFuture, activePreparation)) {
      handler._androidAutoBrowsePreparationFuture = null;
    }
    await _androidAutoPrepareBrowse(handler);
    return;
  }

  final preparation = () async {
    if (!await handler._androidAutoHasAuthenticatedUser()) {
      handler._androidAutoPrimedChildren.clear();
      return;
    }

    logger('[AAOS] preparing browse content', tag: 'AudioHandler', level: InfoLevel.info);
    const paging = _AndroidAutoPagingOptions(page: 0, pageSize: _androidAutoDefaultPageSize, hasExplicitPaging: false);
    final libraries = await handler._androidAutoFetchLibraries();
    final personalizedEntries = await Future.wait(
      libraries.map(
        (library) async =>
            (libraryId: library.id, personalized: await handler._androidAutoFetchPersonalizedLibrary(library.id)),
      ),
    );
    final personalizedByLibraryId = <String, PersonalizedLibrary?>{
      for (final entry in personalizedEntries) entry.libraryId: entry.personalized,
    };

    final continueItems = await handler._androidAutoContinueAcrossLibraries(
      paging,
      libraries: libraries,
      personalizedByLibraryId: personalizedByLibraryId,
    );
    final recentNodes = await handler._androidAutoRecentLibraryNodes(paging, libraries: libraries);
    final libraryNodes = await handler._androidAutoLibraryNodes(paging, libraries: libraries);

    final primedChildren = <String, List<MediaItem>>{
      _androidAutoContinueNodeId: continueItems,
      _androidAutoRecentNodeId: recentNodes,
      AudioService.recentRootId: recentNodes,
      _androidAutoLibrariesNodeId: libraryNodes,
    };
    for (final library in libraries) {
      primedChildren[handler._androidAutoRecentLibraryNodeId(library.id)] = await handler._androidAutoRecentForLibrary(
        library.id,
        paging,
        personalized: personalizedByLibraryId[library.id],
        personalizedResolved: true,
      );
    }

    handler._androidAutoPrimedChildren
      ..clear()
      ..addAll(primedChildren);
    handler._androidAutoPreparedForNextLaunch = true;
    await handler._updatePlaybackState();
    logger(
      '[AAOS] browse content ready: libraries=${libraries.length}; continue=${continueItems.length}',
      tag: 'AudioHandler',
      level: InfoLevel.info,
    );
  }();
  handler._androidAutoBrowsePreparationFuture = preparation;

  try {
    await preparation;
  } finally {
    if (identical(handler._androidAutoBrowsePreparationFuture, preparation)) {
      handler._androidAutoBrowsePreparationFuture = null;
    }
  }
}

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

    if (!await _androidAutoEnsureAuthenticatedUser()) {
      if (isAutomotiveSystem) {
        // The local audio_service Android bridge translates this error into a
        // null onLoadChildren result so AAOS renders the media-session
        // authentication error and its sign-in resolution action.
        throw PlatformException(code: 'authentication_expired', message: _androidAutoAuthenticationRequiredMessage);
      }

      return <MediaItem>[
        _androidAutoBrowsableItem(
          id: 'aa/auth-required/$parentMediaId',
          title: _androidAutoUnauthenticatedContentUnavailableMessage,
          subtitle: _androidAutoUnauthenticatedSignInHintMessage,
        ),
      ];
    }

    final resolvedParentMediaId = isAutomotiveSystem
        ? _androidAutoNormalizeSessionNodeId(parentMediaId)
        : parentMediaId;
    final paging = _androidAutoPagingFromOptions(options);
    final isTopLevelAuthenticatedNode =
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
        if (primedChildren.isNotEmpty) {
          logger(
            '[AAOS] serving prepared children for $resolvedParentMediaId',
            tag: 'AudioHandler',
            level: InfoLevel.debug,
          );
          return paging.hasExplicitPaging ? _androidAutoApplyPaging(primedChildren, paging) : primedChildren;
        }
        logger(
          '[AAOS] prepared children for $resolvedParentMediaId were empty; fetching live content',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
      }
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
      return _androidAutoItemsForAuthor(authorInfo.libraryId, authorInfo.authorId);
    }

    final seriesInfo = _androidAutoSeriesNodeFromId(resolvedParentMediaId);
    if (seriesInfo != null) {
      return _androidAutoItemsForSeries(seriesInfo.libraryId, seriesInfo.seriesId);
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
      return _androidAutoItemsForNarrator(narratorInfo.libraryId, narratorInfo.narrator);
    }

    return const <MediaItem>[];
  }

  Future<MediaItem?> _androidAutoGetMediaItem(String mediaId) async {
    if (!await _androidAutoEnsureAuthenticatedUser()) {
      return null;
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
