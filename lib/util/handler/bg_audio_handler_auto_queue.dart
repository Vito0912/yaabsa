part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAutoQueueExtension on BGAudioHandler {
  Future<_AutoQueueRequestContext?> _buildSeriesFallbackAutoQueueContext(LibraryItem item) async {
    final seriesId = await _resolvePrimarySeriesId(item);
    final libraryId = item.libraryId;
    if (seriesId == null || seriesId.isEmpty || libraryId == null || libraryId.isEmpty) {
      return null;
    }

    final api = _ref.read(absApiProvider);
    if (api == null) {
      return null;
    }

    try {
      var initialPage = 0;
      final details = (await api.getLibraryApi().getSeriesById(seriesId)).data;
      if (details != null) {
        final orderedIds = <String>[];
        final seen = <String>{};

        for (final book in details.books ?? const <LibraryItem>[]) {
          if (seen.add(book.id)) {
            orderedIds.add(book.id);
          }
        }

        for (final id in details.libraryItemIds ?? const <String>[]) {
          if (id.isEmpty) {
            continue;
          }
          if (seen.add(id)) {
            orderedIds.add(id);
          }
        }

        final itemIndex = orderedIds.indexOf(item.id);
        if (itemIndex >= 0) {
          initialPage = itemIndex ~/ _autoQueuePageSize;
        }
      }

      return _AutoQueueRequestContext.series(libraryId: libraryId, seriesId: seriesId, initialPage: initialPage);
    } catch (e) {
      logger(
        'Failed to build fallback series auto-queue context for ${item.id}: $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  String? _firstSeriesIdFromItem(LibraryItem item) {
    final series = item.media?.bookMedia?.metadata.series;
    if (series == null || series.isEmpty) {
      return null;
    }

    final id = series.first.id;
    if (id.isEmpty) {
      return null;
    }

    return id;
  }

  Future<String?> _resolvePrimarySeriesId(LibraryItem item) async {
    final initialSeriesId = _firstSeriesIdFromItem(item);
    if (initialSeriesId != null) {
      return initialSeriesId;
    }

    try {
      final fullItem = await _ref.read(libraryItemProvider(item.id).future);
      return _firstSeriesIdFromItem(fullItem);
    } catch (e) {
      logger(
        'Failed to resolve full item for fallback auto-queue series lookup (${item.id}): $e',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<void> _startAutoQueue(_AutoQueueRequestContext context, QueueItem currentQueueItem) async {
    final currentItemReferenceKey = _queueItemReferenceKey(
      itemId: currentQueueItem.itemId,
      episodeId: currentQueueItem.episodeId,
    );

    final generation = ++_autoQueueGeneration;
    _autoQueueState = null;
    _emitQueueState();

    try {
      final locatedStart = await _locateAutoQueueStart(context, currentItemReferenceKey);
      if (!_isAutoQueueStillValid(generation, currentItemReferenceKey)) {
        return;
      }

      if (locatedStart == null) {
        logger(
          'Auto queue aborted: current queue item $currentItemReferenceKey not found in source context',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        return;
      }

      final currentPageResult = locatedStart.pageResult;
      final currentIndexInPage = locatedStart.itemIndex;

      final autoState = _AutoQueueState(
        context: context,
        currentItemReferenceKey: currentItemReferenceKey,
        currentItemAbsoluteIndex: (currentPageResult.page * currentPageResult.pageSize) + currentIndexInPage,
        totalItems: currentPageResult.total,
        pageSize: currentPageResult.pageSize,
        highestLoadedPage: currentPageResult.page,
      );

      _autoQueueState = autoState;

      final samePageQueueItems = currentPageResult.items.skip(currentIndexInPage + 1).toList(growable: false);
      _appendAutoQueueItems(samePageQueueItems, page: currentPageResult.page);

      if (_remainingAutoQueueItems(autoState) > 0) {
        await _loadMoreAutoQueue();
      } else {
        _emitQueueState();
      }
    } catch (e) {
      logger('Failed to start auto queue: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<({_AutoQueuePageResult pageResult, int itemIndex})?> _locateAutoQueueStart(
    _AutoQueueRequestContext context,
    String currentItemReferenceKey,
  ) async {
    final initialResult = await _fetchAutoQueuePage(context, context.initialPage);
    final initialIndex = initialResult.items.indexWhere((item) => item.referenceKey == currentItemReferenceKey);
    if (initialIndex >= 0) {
      return (pageResult: initialResult, itemIndex: initialIndex);
    }

    final maxPage = _maxAutoQueuePage(initialResult);
    if (maxPage <= 0) {
      return null;
    }

    for (var page = 0; page <= maxPage; page++) {
      if (page == initialResult.page) {
        continue;
      }

      final result = await _fetchAutoQueuePage(context, page);
      final index = result.items.indexWhere((item) => item.referenceKey == currentItemReferenceKey);
      if (index >= 0) {
        return (pageResult: result, itemIndex: index);
      }
    }

    return null;
  }

  int _maxAutoQueuePage(_AutoQueuePageResult result) {
    final pageSize = result.pageSize > 0 ? result.pageSize : _autoQueuePageSize;
    if (result.total <= 0) {
      return result.page;
    }

    return (result.total - 1) ~/ pageSize;
  }

  bool _isAutoQueueStillValid(int generation, String currentItemReferenceKey) {
    final activeReference = _currentMediaItem == null
        ? null
        : _queueItemReferenceKey(itemId: _currentMediaItem!.itemId, episodeId: _currentMediaItem!.episodeId);
    return generation == _autoQueueGeneration && activeReference == currentItemReferenceKey;
  }

  int _appendAutoQueueItems(List<_AutoQueueItemCandidate> items, {required int page}) {
    var addedCount = 0;
    for (final item in items) {
      final didAdd = _enqueueItem(item.queueItem, displayInfo: item.displayInfo, autoQueued: true, autoQueuePage: page);
      if (didAdd) {
        addedCount += 1;
      }
    }

    if (addedCount > 0) {
      _emitQueueState();
    }

    return addedCount;
  }

  Future<void> _loadMoreAutoQueue() async {
    final autoState = _autoQueueState;
    if (autoState == null || autoState.isLoading) {
      return;
    }

    if (_remainingAutoQueueItems(autoState) <= 0) {
      _emitQueueState();
      return;
    }

    autoState.isLoading = true;
    _emitQueueState();

    final nextPage = autoState.highestLoadedPage + 1;
    try {
      final pageResult = await _fetchAutoQueuePage(autoState.context, nextPage);
      if (_autoQueueState != autoState) {
        return;
      }

      autoState.highestLoadedPage = pageResult.page;
      if (pageResult.items.isNotEmpty) {
        autoState.firstItemReferenceByPage[pageResult.page] = pageResult.items.first.referenceKey;
      }

      _appendAutoQueueItems(pageResult.items, page: pageResult.page);
    } catch (e) {
      logger('Failed to load more auto queue items: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    } finally {
      if (_autoQueueState == autoState) {
        autoState.isLoading = false;
        _emitQueueState();
      }
    }
  }

  void _handleAutoQueueOnCurrentItemChange(String? currentItemReferenceKey) {
    if (currentItemReferenceKey == null) {
      return;
    }

    final autoState = _autoQueueState;
    if (autoState == null || autoState.isLoading || _remainingAutoQueueItems(autoState) <= 0) {
      return;
    }

    final triggerItemReference = autoState.firstItemReferenceByPage[autoState.highestLoadedPage];
    if (triggerItemReference == null || triggerItemReference != currentItemReferenceKey) {
      return;
    }

    final pageToTrigger = autoState.highestLoadedPage;
    if (!autoState.triggeredPages.add(pageToTrigger)) {
      return;
    }

    unawaited(_loadMoreAutoQueue());
  }

  Future<_AutoQueuePageResult> _fetchAutoQueuePage(_AutoQueueRequestContext context, int page) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      throw Exception('No API available for auto queue');
    }

    switch (context.sourceType) {
      case _AutoQueueSourceType.series:
        final request = LibraryItemsRequest(
          limit: context.pageSize,
          page: page,
          filter: normalizeLibraryFilterQuery(context.filter),
          collapseseries: context.collapseseries,
        );

        final response = await api.getLibraryApi().getLibraryItems(context.libraryId, request);
        final data = response.data;
        if (data == null) {
          throw Exception('No page data received for auto queue');
        }

        return _AutoQueuePageResult(
          items: _queueCandidatesFromLibraryItems(data.results),
          total: data.total ?? data.results.length,
          page: data.page ?? page,
          pageSize: data.limit ?? context.pageSize,
        );
      case _AutoQueueSourceType.playlist:
        context.cachedCandidates ??= await _resolvePlaylistItems(context);
        return _sliceAutoQueuePage(items: context.cachedCandidates!, page: page, pageSize: context.pageSize);
      case _AutoQueueSourceType.collection:
        context.cachedCandidates ??= await _resolveCollectionItems(context);
        return _sliceAutoQueuePage(items: context.cachedCandidates!, page: page, pageSize: context.pageSize);
      case _AutoQueueSourceType.podcast:
        context.cachedCandidates ??= await _resolvePodcastEpisodeItems(context);
        return _sliceAutoQueuePage(items: context.cachedCandidates!, page: page, pageSize: context.pageSize);
    }
  }

  List<_AutoQueueItemCandidate> _queueCandidatesFromLibraryItems(List<LibraryItem> items) {
    final seen = <String>{};
    final candidates = <_AutoQueueItemCandidate>[];

    for (final item in items) {
      final queueItem = QueueItem(itemId: item.id);
      final referenceKey = _queueItemReferenceKey(itemId: queueItem.itemId, episodeId: queueItem.episodeId);
      if (!seen.add(referenceKey)) {
        continue;
      }

      candidates.add(
        _AutoQueueItemCandidate(
          queueItem: queueItem,
          referenceKey: referenceKey,
          displayInfo: _displayInfoFromLibraryItem(item),
        ),
      );
    }

    return candidates;
  }

  _AutoQueuePageResult _sliceAutoQueuePage({
    required List<_AutoQueueItemCandidate> items,
    required int page,
    required int pageSize,
  }) {
    final safePageSize = pageSize < 1 ? _autoQueuePageSize : pageSize;
    final start = page * safePageSize;
    if (start >= items.length) {
      return _AutoQueuePageResult(
        items: const <_AutoQueueItemCandidate>[],
        total: items.length,
        page: page,
        pageSize: safePageSize,
      );
    }

    final end = (start + safePageSize) > items.length ? items.length : (start + safePageSize);
    return _AutoQueuePageResult(
      items: items.sublist(start, end),
      total: items.length,
      page: page,
      pageSize: safePageSize,
    );
  }

  Future<List<_AutoQueueItemCandidate>> _resolvePlaylistItems(_AutoQueueRequestContext context) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      throw Exception('No API available for playlist auto queue');
    }

    final playlistId = context.playlistId;
    if (playlistId == null || playlistId.isEmpty) {
      throw Exception('Missing playlist id for auto queue');
    }

    final response = await api.getListApi().getUserPlaylist();
    final playlists = response.data?.items ?? const [];

    for (final playlist in playlists) {
      if (playlist.id != playlistId) {
        continue;
      }

      final items = <_AutoQueueItemCandidate>[];
      final seen = <String>{};
      for (final playlistItem in playlist.items ?? const []) {
        final libraryItem = playlistItem.libraryItem;
        if (libraryItem == null || libraryItem.id.isEmpty) {
          continue;
        }
        if (libraryItem.libraryId != null && libraryItem.libraryId != context.libraryId) {
          continue;
        }

        final episode = playlistItem.episode;
        final queueItem = QueueItem(itemId: libraryItem.id, episodeId: playlistItem.episodeId ?? episode?.id);
        final referenceKey = _queueItemReferenceKey(itemId: queueItem.itemId, episodeId: queueItem.episodeId);
        if (!seen.add(referenceKey)) {
          continue;
        }

        final displayInfo = episode == null
            ? _displayInfoFromLibraryItem(libraryItem)
            : _displayInfoFromPodcastEpisode(libraryItem, episode);

        items.add(_AutoQueueItemCandidate(queueItem: queueItem, referenceKey: referenceKey, displayInfo: displayInfo));
      }

      return items;
    }

    return const <_AutoQueueItemCandidate>[];
  }

  Future<List<_AutoQueueItemCandidate>> _resolveCollectionItems(_AutoQueueRequestContext context) async {
    final api = _ref.read(absApiProvider);
    if (api == null) {
      throw Exception('No API available for collection auto queue');
    }

    final collectionId = context.collectionId;
    if (collectionId == null || collectionId.isEmpty) {
      throw Exception('Missing collection id for auto queue');
    }

    final response = await api.getListApi().getCollections();
    final collections = response.data?.items ?? const [];

    for (final collection in collections) {
      if (collection.id != collectionId) {
        continue;
      }

      final items = <_AutoQueueItemCandidate>[];
      final seen = <String>{};
      for (final item in collection.items ?? const []) {
        if (item.id.isEmpty) {
          continue;
        }
        if (item.libraryId != null && item.libraryId != context.libraryId) {
          continue;
        }

        final queueItem = QueueItem(itemId: item.id);
        final referenceKey = _queueItemReferenceKey(itemId: queueItem.itemId, episodeId: queueItem.episodeId);
        if (seen.add(referenceKey)) {
          items.add(
            _AutoQueueItemCandidate(
              queueItem: queueItem,
              referenceKey: referenceKey,
              displayInfo: _displayInfoFromLibraryItem(item),
            ),
          );
        }
      }

      return items;
    }

    return const <_AutoQueueItemCandidate>[];
  }

  Future<List<_AutoQueueItemCandidate>> _resolvePodcastEpisodeItems(_AutoQueueRequestContext context) async {
    final podcastItemId = context.podcastItemId;
    if (podcastItemId == null || podcastItemId.isEmpty) {
      throw Exception('Missing podcast item id for auto queue');
    }

    LibraryItem? baseItem = context.podcastItem;
    baseItem ??= await _ref.read(libraryItemProvider(podcastItemId).future);
    if (baseItem == null) {
      return const <_AutoQueueItemCandidate>[];
    }

    final episodes = context.seededPodcastEpisodes ?? baseItem.media?.podcastMedia?.episodes ?? const <Episode>[];
    if (episodes.isEmpty) {
      return const <_AutoQueueItemCandidate>[];
    }

    final seen = <String>{};
    final items = <_AutoQueueItemCandidate>[];

    for (final episode in episodes) {
      if (episode.id.isEmpty || episode.audioFile == null) {
        continue;
      }

      final queueItem = QueueItem(itemId: baseItem.id, episodeId: episode.id);
      final referenceKey = _queueItemReferenceKey(itemId: queueItem.itemId, episodeId: queueItem.episodeId);
      if (!seen.add(referenceKey)) {
        continue;
      }

      items.add(
        _AutoQueueItemCandidate(
          queueItem: queueItem,
          referenceKey: referenceKey,
          displayInfo: _displayInfoFromPodcastEpisode(baseItem, episode),
        ),
      );
    }

    return items;
  }
}
