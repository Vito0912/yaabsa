part of 'bg_audio_handler.dart';

extension _BGAudioHandlerQueue on BGAudioHandler {
  Future<LibraryItem?> _resolveQueueLibraryItemInternal(String itemId) {
    return _queueItemDetailsCache.putIfAbsent(itemId, () async {
      try {
        return await _ref.read(libraryItemProvider(itemId).future);
      } catch (e) {
        logger('Failed to resolve queue item $itemId: $e', tag: 'AudioHandler', level: InfoLevel.warning);
        return null;
      }
    });
  }

  void _removeFromQueueByItemIdInternal(String itemId, {String? episodeId}) {
    final nextQueue = queueList
        .where(
          (entry) => episodeId == null
              ? entry.item.itemId != itemId
              : !_queueItemsMatch(
                  leftItemId: entry.item.itemId,
                  leftEpisodeId: entry.item.episodeId,
                  rightItemId: itemId,
                  rightEpisodeId: episodeId,
                ),
        )
        .toList();
    if (nextQueue.length != queueList.length) {
      queueList = nextQueue;
      _emitQueueState();
    }

    _originalQueueList = _originalQueueList
        .where(
          (entry) => episodeId == null
              ? entry.item.itemId != itemId
              : !_queueItemsMatch(
                  leftItemId: entry.item.itemId,
                  leftEpisodeId: entry.item.episodeId,
                  rightItemId: itemId,
                  rightEpisodeId: episodeId,
                ),
        )
        .toList();
  }

  void _reorderQueueInternal(int oldIndex, int newIndex) {
    if (queueList.isEmpty || oldIndex < 0 || oldIndex >= queueList.length) {
      return;
    }

    var targetIndex = newIndex;
    if (targetIndex > oldIndex) {
      targetIndex -= 1;
    }

    if (targetIndex < 0 || targetIndex >= queueList.length) {
      return;
    }

    final nextQueue = List<PlayerQueueEntry>.from(queueList);
    final moved = nextQueue.removeAt(oldIndex);
    nextQueue.insert(targetIndex, moved);
    queueList = nextQueue;
    _emitQueueState();
  }

  void _emitQueueLength() {
    if (!_queueLengthSubject.isClosed) {
      _queueLengthSubject.add(queueList.length);
    }
  }

  void _emitQueueState() {
    _emitQueueLength();
    if (!_queueSnapshotSubject.isClosed) {
      _queueSnapshotSubject.add(_buildQueueSnapshot());
    }
    unawaited(_updatePlaybackState());
  }

  bool _enqueueItem(
    QueueItem item, {
    QueueDisplayInfo displayInfo = QueueDisplayInfo.empty,
    bool autoQueued = false,
    int? autoQueuePage,
    bool allowCurrent = false,
  }) {
    if (!allowCurrent &&
        _currentMediaItem != null &&
        _queueItemsMatch(
          leftItemId: _currentMediaItem!.itemId,
          leftEpisodeId: _currentMediaItem!.episodeId,
          rightItemId: item.itemId,
          rightEpisodeId: item.episodeId,
        )) {
      return false;
    }

    if (isInQueue(item.itemId, episodeId: item.episodeId)) {
      return false;
    }

    final entry = PlayerQueueEntry(
      id: 'q_${_queueEntryCounter++}',
      item: item,
      displayInfo: displayInfo,
      autoQueued: autoQueued,
      autoQueuePage: autoQueuePage,
    );

    queueList = [...queueList, entry];

    final manager = _ref.read(settingsManagerProvider.notifier);
    final isMix = manager.getGlobalSetting<bool>(SettingKeys.mixQueue, defaultValue: false);
    if (isMix) {
      _originalQueueList.add(entry);
    }

    return true;
  }

  QueueDisplayInfo _displayInfoFromLibraryItem(LibraryItem item) {
    return QueueDisplayInfo(title: item.title, subtitle: item.subtitle, author: item.authorString);
  }

  QueueDisplayInfo _displayInfoFromPodcastEpisode(LibraryItem item, Episode episode) {
    final title = (episode.title != null && episode.title!.trim().isNotEmpty) ? episode.title!.trim() : item.title;
    final subtitle = (episode.subtitle != null && episode.subtitle!.trim().isNotEmpty)
        ? episode.subtitle!.trim()
        : item.title;
    return QueueDisplayInfo(title: title, subtitle: subtitle, author: item.authorString);
  }

  bool get _isAutoQueueEnabled {
    return _ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.autoQueue);
  }

  bool get _isSeriesFallbackAutoQueueEnabled {
    return _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.autoQueueIncludeSeriesOutsideContext);
  }

  PlayerQueueSnapshot _buildQueueSnapshot() {
    final autoState = _autoQueueState;
    final autoQueueRemaining = autoState == null ? 0 : _remainingAutoQueueItems(autoState);

    return PlayerQueueSnapshot(
      entries: List<PlayerQueueEntry>.unmodifiable(queueList),
      autoQueueEnabled: _isAutoQueueEnabled,
      autoQueueActive: autoState != null,
      autoQueueLoading: autoState?.isLoading ?? false,
      autoQueueRemaining: autoQueueRemaining,
      canLoadMoreAutoQueue: autoState != null && !autoState.isLoading && autoQueueRemaining > 0,
    );
  }

  int _remainingAutoQueueItems(_AutoQueueState state) {
    if (state.totalItems <= 0 || state.pageSize <= 0) {
      return 0;
    }

    final highestLoadedAbsoluteIndex = ((state.highestLoadedPage + 1) * state.pageSize - 1)
        .clamp(0, state.totalItems - 1)
        .toInt();
    final loadedAfterCurrent = (highestLoadedAbsoluteIndex - state.currentItemAbsoluteIndex)
        .clamp(0, state.totalItems)
        .toInt();
    final totalAfterCurrent = (state.totalItems - state.currentItemAbsoluteIndex - 1)
        .clamp(0, state.totalItems)
        .toInt();

    return (totalAfterCurrent - loadedAfterCurrent).clamp(0, state.totalItems).toInt();
  }

  void _maybePrefetchAutoQueue({int minBufferedEntries = 1}) {
    final autoState = _autoQueueState;
    if (autoState == null || autoState.isLoading) {
      return;
    }

    if (_remainingAutoQueueItems(autoState) <= 0 || queueList.length > minBufferedEntries) {
      return;
    }

    logger(
      'Prefetching auto-queue page (buffered=${queueList.length}, remaining=${_remainingAutoQueueItems(autoState)}).',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    unawaited(_loadMoreAutoQueue());
  }

  void _clearAutoQueueState() {
    _autoQueueGeneration += 1;
    _autoQueueState = null;
  }
}
