part of 'bg_audio_handler.dart';

extension _BGAudioHandlerPlaybackInternal on BGAudioHandler {
  Future<void> _playPodcastEpisodeInternal(
    LibraryItem item,
    Episode episode, {
    int? episodeIndex,
    List<Episode>? orderedEpisodes,
  }) async {
    _activeMusicLibraryId = null;
    final libraryId = item.libraryId;
    final autoQueueContext = libraryId != null && episodeIndex != null
        ? _AutoQueueRequestContext.podcast(
            libraryId: libraryId,
            podcastItemId: item.id,
            podcastItem: item,
            episodeId: episode.id,
            seededPodcastEpisodes: orderedEpisodes,
          )
        : null;

    final operationId = _beginUserSeekNavigation();
    var navigationSucceeded = false;
    try {
      setQueueFromPodcastEpisode(item, episode);
      await play();
      navigationSucceeded = _queueItemsMatch(
        leftItemId: _currentMediaItem?.itemId ?? '',
        leftEpisodeId: _currentMediaItem?.episodeId,
        rightItemId: item.id,
        rightEpisodeId: episode.id,
      );
    } finally {
      _settleUserSeekNavigation(operationId, shouldRetarget: navigationSucceeded);
    }

    if (!_isAutoQueueEnabled) {
      return;
    }

    if (!_queueItemsMatch(
      leftItemId: _currentMediaItem?.itemId ?? '',
      leftEpisodeId: _currentMediaItem?.episodeId,
      rightItemId: item.id,
      rightEpisodeId: episode.id,
    )) {
      return;
    }

    if (autoQueueContext != null) {
      unawaited(_startAutoQueue(autoQueueContext, QueueItem(itemId: item.id, episodeId: episode.id)));
    }
  }

  Future<bool> _playItemFromPositionInternal({
    required String itemId,
    required String? episodeId,
    required Duration position,
    bool preserveQueue = false,
    PlayerMutationLease? mutationLease,
  }) async {
    late final PlayerMutationLease lease;
    if (mutationLease != null) {
      lease = mutationLease;
    } else {
      _playbackContextGeneration += 1;
      lease = _playerMutationBarrier.acquire();
    }
    bool ownsPlayback() => _playerMutationBarrier.isCurrent(lease) && !_isDisposing;
    if (!ownsPlayback()) {
      return false;
    }

    _activeMusicLibraryId = null;
    PlayerUtils.enableWakelock(_ref);
    _resetStreamRecoveryState(clearWindow: true);

    final isCurrentItem =
        _currentMediaItem != null &&
        _queueItemsMatch(
          leftItemId: _currentMediaItem!.itemId,
          leftEpisodeId: _currentMediaItem!.episodeId,
          rightItemId: itemId,
          rightEpisodeId: episodeId,
        );
    if (!isCurrentItem) {
      final hasPlaybackToReplace =
          _currentMediaItem != null || queueList.isNotEmpty || _player.processingState != ProcessingState.idle;
      if (hasPlaybackToReplace) {
        final stopped = await _stopWithPlayerMutationLease(lease, clearQueue: !preserveQueue);
        if (!stopped || !ownsPlayback()) {
          return false;
        }
      }
    }

    if (!isCurrentItem) {
      final targetItem = QueueItem(itemId: itemId, episodeId: episodeId);
      _setQueueTransitionTargetItem(targetItem);
      _setOwnedQueueTransitionLoading(lease);
      await _updatePlaybackState();
      if (!ownsPlayback()) {
        _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
        return false;
      }
      _lastQueueItem = targetItem;

      try {
        final openedMedia = await _ref
            .read(sessionRepositoryProvider)
            .openSession(itemId, episodeId: episodeId, isStillCurrent: ownsPlayback);
        if (!ownsPlayback()) {
          _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
          return false;
        }
        _currentMediaItem = openedMedia;
        if (_currentMediaItem == null) {
          logger('No media item found for ID: $itemId', tag: 'AudioHandler', level: InfoLevel.error);
          PlayerUtils.disableWakelock(_ref);
          _clearQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: true);
          return false;
        }
        await _setSource(ignoreSavedProgress: true, mutationLease: lease);
        if (!ownsPlayback()) {
          _abandonQueueTransitionLoadingIfOwned(lease);
          return false;
        }
      } catch (e, s) {
        if (!ownsPlayback()) {
          _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
          return false;
        }
        logger('Failed to prepare item $itemId for playback: $e\n$s', tag: 'AudioHandler', level: InfoLevel.error);
        _currentMediaItem = null;
        PlayerUtils.disableWakelock(_ref);
        _clearQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: true);
        return false;
      }
    }

    try {
      if (!ownsPlayback()) {
        _abandonQueueTransitionLoadingIfOwned(lease);
        return false;
      }
      _clearSmartRewindPauseMarker();
      await _seekInternal(position, mutationLease: lease);
      if (!ownsPlayback()) {
        _abandonQueueTransitionLoadingIfOwned(lease);
        return false;
      }
      if (isCastControlActive) {
        _clearQueueTransitionLoadingIfOwned(lease);
        await play();
        if (!ownsPlayback()) {
          return false;
        }
      } else {
        final startAttempt = _beginPlaybackStartAttempt(lease);
        final startResult = await _syncedPlay(mutationLease: lease);
        final attemptCurrent = ownsPlayback() && _isPlaybackStartAttemptCurrent(startAttempt);
        _settlePlaybackStartAttempt(
          startAttempt,
          attemptCurrent ? _statusForPlaybackStartResult(startResult) : PlaybackStartAttemptStatus.superseded,
        );
        if (!attemptCurrent || !startResult.started) {
          _abandonQueueTransitionLoadingIfOwned(lease);
          PlayerUtils.disableWakelock(_ref);
          return false;
        }
        _clearQueueTransitionLoadingIfOwned(lease);
      }

      TrayManager.update();
      if (!isCurrentItem) {
        _markPendingManualQueueSessionPlayed();
        unawaited(_setupAutoQueueOnResume(itemId: itemId, episodeId: episodeId));
      }
      return true;
    } catch (e, s) {
      if (!ownsPlayback()) {
        _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
        return false;
      }
      logger(
        'Failed to start item $itemId from the requested position: $e\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      PlayerUtils.disableWakelock(_ref);
      _clearQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: true);
      return false;
    }
  }

  Future<void> _playLibraryItemWithContext(
    LibraryItem item, {
    AutoQueueStart autoQueueStart = const AutoQueueStart.none(),
    String? sort,
    int? desc,
    String? filter,
  }) async {
    logger(
      'Starting library item playback with auto-queue start type=${autoQueueStart.type.name}, '
      'sourceId=${autoQueueStart.sourceId}, globalIndex=${autoQueueStart.globalIndex}.',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    final operationId = _beginUserSeekNavigation();
    var navigationSucceeded = false;
    try {
      setQueueFromLibraryItem(item);
      await play();
      navigationSucceeded = _queueItemsMatch(
        leftItemId: _currentMediaItem?.itemId ?? '',
        leftEpisodeId: _currentMediaItem?.episodeId,
        rightItemId: item.id,
        rightEpisodeId: null,
      );
    } finally {
      _settleUserSeekNavigation(operationId, shouldRetarget: navigationSucceeded);
    }

    final libraryId = item.libraryId ?? await _resolveLibraryId(item);
    final activeUserId = _ref.read(currentUserProvider).value?.id;
    final isMusic =
        autoQueueStart.type == AutoQueueStartType.none &&
        libraryId != null &&
        _ref
            .read(settingsManagerProvider.notifier)
            .getUserSetting<bool>(activeUserId, 'music_library_$libraryId', defaultValue: false);

    if (isMusic) {
      _clearAutoQueueState();
      _activeMusicLibraryId = libraryId;
      _activeMusicLibraryFilter = filter;
      unawaited(_queueMusicLibraryItems(libraryId, item.id, sort: sort, desc: desc, filter: filter));
      return;
    } else {
      _activeMusicLibraryId = null;
    }

    if (!_isAutoQueueEnabled) {
      logger('Auto queue disabled. Skipping auto-queue setup.', tag: 'AudioHandler', level: InfoLevel.debug);
      return;
    }

    if (!_queueItemsMatch(
      leftItemId: _currentMediaItem?.itemId ?? '',
      leftEpisodeId: _currentMediaItem?.episodeId,
      rightItemId: item.id,
      rightEpisodeId: null,
    )) {
      logger(
        'Auto queue setup skipped because active media does not match requested item ${item.id}.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return;
    }

    if (autoQueueStart.type != AutoQueueStartType.none) {
      final scopedContext = await _buildAutoQueueContextFromStart(item, autoQueueStart);
      if (scopedContext == null) {
        logger(
          'Auto queue scope could not be resolved for ${autoQueueStart.type.name} (sourceId=${autoQueueStart.sourceId}).',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        return;
      }

      logger(
        'Starting scoped auto queue: type=${autoQueueStart.type.name}, sourceId=${autoQueueStart.sourceId}, '
        'globalIndex=${autoQueueStart.globalIndex}.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      unawaited(_startAutoQueue(scopedContext, QueueItem(itemId: item.id)));
      return;
    }

    if (!_isSeriesFallbackAutoQueueEnabled) {
      logger(
        'Auto queue start type is none and outside-source fallback is disabled. Skipping auto queue.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return;
    }

    logger('Attempting fallback series auto queue for item ${item.id}.', tag: 'AudioHandler', level: InfoLevel.debug);
    final fallbackContext = await _buildSeriesFallbackAutoQueueContext(item);
    if (fallbackContext != null) {
      unawaited(_startAutoQueue(fallbackContext, QueueItem(itemId: item.id)));
    } else {
      logger(
        'Fallback series auto queue context could not be resolved for item ${item.id}.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }
  }

  Future<void> _prepareForQueuedItemTransition([PlayerMutationLease? mutationLease]) async {
    final lease = mutationLease ?? _playerMutationBarrier.acquire();
    void ensureOwnership(String stage) {
      if (!_playerMutationBarrier.isCurrent(lease)) {
        _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
        throw PlayerInterruptedException('Queued item transition superseded $stage');
      }
    }

    ensureOwnership('before it started');

    final transitionPosition = position;
    _setQueueTransitionTargetItem(null);
    _setOwnedQueueTransitionLoading(lease);
    _currentMediaItem = null;
    _currentTrackIndex = 0;

    try {
      await _syncService.flush(positionOverride: transitionPosition, sessionClosing: true);
      ensureOwnership('while flushing playback progress');
      await _ref.read(sessionRepositoryProvider).closeSession();
      ensureOwnership('while closing the previous session');
    } catch (e) {
      if (!_playerMutationBarrier.isCurrent(lease)) {
        _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
        throw PlayerInterruptedException('Queued item transition superseded while preparing the previous session');
      }
      logger('Error preparing queued transition: $e', tag: 'AudioHandler', level: InfoLevel.error);
    }

    final stopped = await _safePlayerStop(lease);
    if (!stopped) {
      _abandonQueueTransitionLoadingIfOwned(lease, emitMediaWhenEmpty: _currentMediaItem == null);
      throw PlayerInterruptedException('Queued item transition superseded before the old player stopped');
    }
    ensureOwnership('while stopping the old player');
  }

  PlaybackStartAttempt _beginPlaybackStartAttempt(PlayerMutationLease lease, {String? reservedQueueEntryId}) {
    return _playbackStartAttemptLedger.begin(
      lease: lease,
      sourceGeneration: _audioSourceGeneration,
      reservedQueueEntryId: reservedQueueEntryId,
    );
  }

  bool _isPlaybackStartAttemptCurrent(PlaybackStartAttempt attempt) {
    return _playbackStartAttemptLedger.isCurrent(
      attempt,
      barrier: _playerMutationBarrier,
      currentSourceGeneration: _audioSourceGeneration,
      isDisposing: _isDisposing,
      reservationIsCurrent: (queueEntryId) => queueList.any((entry) => entry.id == queueEntryId),
    );
  }

  PlaybackStartAttemptStatus _statusForPlaybackStartResult(PlaybackStartResult result) {
    return switch (result.status) {
      PlaybackStartStatus.started => PlaybackStartAttemptStatus.started,
      PlaybackStartStatus.superseded => PlaybackStartAttemptStatus.superseded,
      PlaybackStartStatus.rejected => PlaybackStartAttemptStatus.rejected,
      PlaybackStartStatus.failed => PlaybackStartAttemptStatus.failed,
      PlaybackStartStatus.unsupported => PlaybackStartAttemptStatus.unsupported,
    };
  }

  void _settlePlaybackStartAttempt(PlaybackStartAttempt attempt, PlaybackStartAttemptStatus status) {
    _playbackStartAttemptLedger.settle(attempt, status);
  }

  Future<PlaybackStartResult> _syncedPlay({
    bool restoreProgress = false,
    bool skipResumeProgressReconcile = false,
    PlayerMutationLease? mutationLease,
  }) async {
    final lease = mutationLease ?? _playerMutationBarrier.acquire();
    if (!_playerMutationBarrier.isCurrent(lease)) {
      return const PlaybackStartResult(PlaybackStartStatus.superseded);
    }

    if (_chapterNotificationEnabled) {
      _updateMediaItemForChapterNotification();
    } else {
      mediaItem.add(_currentMediaItem?.toMediaItem());
    }

    if (_currentMediaItem == null) {
      return const PlaybackStartResult(PlaybackStartStatus.rejected);
    }
    final resumeItem = _currentMediaItem!;
    final startPosition = position;
    final shouldReconcileProgress = restoreProgress && !skipResumeProgressReconcile && !isCastControlActive;
    logger(
      'Starting playback for item: ${resumeItem.itemId} (${resumeItem.episodeId ?? 'item'}) from position: $startPosition (restoreProgress=$restoreProgress, castControl=$isCastControlActive)',
      tag: 'AudioHandler',
      level: InfoLevel.info,
    );

    if (restoreProgress && skipResumeProgressReconcile) {
      logger(
        'Resume progress reconcile skipped because playback position was manually changed while paused.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }

    if (!_playerMutationBarrier.isCurrent(lease)) {
      return const PlaybackStartResult(PlaybackStartStatus.superseded);
    }

    try {
      final playFuture = _player.play();
      unawaited(
        playFuture.catchError((error, stackTrace) {
          logger('Failed to start player playback: $error\n$stackTrace', tag: 'AudioHandler', level: InfoLevel.error);
        }),
      );
      final result = await awaitPlaybackStartOrLeaseInvalidated<PlaybackStartResult>(
        lease: lease,
        backendResult: _player.waitForPlaybackStart(),
        supersededValue: const PlaybackStartResult(PlaybackStartStatus.superseded),
      );
      if (result.started && shouldReconcileProgress && _playerMutationBarrier.isCurrent(lease)) {
        unawaited(_reconcileResumeProgressInBackground(resumeItem, startPosition, mutationLease: lease));
      }
      return result;
    } catch (error, stackTrace) {
      logger(
        'Failed while waiting for backend-confirmed playback start: $error\n$stackTrace',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      return PlaybackStartResult(PlaybackStartStatus.failed, errorMessage: error.toString());
    }
  }

  Future<void> _reconcileResumeProgressInBackground(
    InternalMedia resumeItem,
    Duration startPosition, {
    PlayerMutationLease? mutationLease,
  }) async {
    final reconcilePlaybackContextGeneration = _playbackContextGeneration;
    final reconcileSeekGeneration = _seekGeneration;
    final activeUserId = _ref.read(currentUserProvider).value?.id;
    final isMusic = _ref
        .read(settingsManagerProvider.notifier)
        .getUserSetting<bool>(activeUserId, 'music_library_${resumeItem.libraryId}', defaultValue: false);
    if (isMusic) {
      return;
    }

    final canReachServer = _ref.read(serverReachabilityProvider);
    if (!canReachServer) {
      logger(
        'Server is unreachable, skipping background resume progress reconcile.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return;
    }

    const driftThreshold = Duration(seconds: 10);

    try {
      final progress = await _ref
          .read(mediaProgressProvider.notifier)
          .fetchOrRefreshIndividualProgress(resumeItem.itemId, episodeId: resumeItem.episodeId);

      if ((mutationLease != null && !_playerMutationBarrier.isCurrent(mutationLease)) ||
          reconcilePlaybackContextGeneration != _playbackContextGeneration ||
          reconcileSeekGeneration != _seekGeneration) {
        logger(
          'Background resume reconcile aborted because playback navigation changed while progress was loading.',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        return;
      }

      final currentMedia = _currentMediaItem;
      if (currentMedia == null ||
          !_queueItemsMatch(
            leftItemId: currentMedia.itemId,
            leftEpisodeId: currentMedia.episodeId,
            rightItemId: resumeItem.itemId,
            rightEpisodeId: resumeItem.episodeId,
          )) {
        logger(
          'Background resume reconcile aborted: current media item changed or is null (current=${currentMedia?.itemId}(${currentMedia?.episodeId ?? 'item'}), resume=${resumeItem.itemId}(${resumeItem.episodeId ?? 'item'}))',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        return;
      }

      if (progress == null) {
        logger(
          'Background resume reconcile: no progress found for item ${resumeItem.itemId} (${resumeItem.episodeId ?? 'item'}), skipping reconcile',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        return;
      }

      final remotePosition = progress.isFinished
          ? Duration.zero
          : Duration(microseconds: (progress.currentTime * Duration.microsecondsPerSecond).round());
      final positionDrift = (remotePosition - startPosition).abs();

      logger(
        'Background resume reconcile for item: ${resumeItem.itemId} (${resumeItem.episodeId ?? 'item'}), '
        'start position: $startPosition, remote position: $remotePosition, drift: $positionDrift',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );

      if (positionDrift < driftThreshold) {
        return;
      }

      logger(
        'Background resume reconcile detected position drift of $positionDrift. '
        'Seeking from start position $startPosition to remote position $remotePosition',
        tag: 'AudioHandler',
        level: InfoLevel.info,
      );

      await _seekWithoutPausedManualMarker(() => _seekInternal(remotePosition, mutationLease: mutationLease));
    } catch (e) {
      logger('Background resume reconcile failed: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _queueMusicLibraryItems(
    String libraryId,
    String currentItemId, {
    String? sort,
    int? desc,
    String? filter,
  }) async {
    final api = _ref.read(absApiProvider);
    if (api == null) return;
    try {
      final request = LibraryItemsRequest(limit: 1000, page: 0, sort: sort, desc: desc, filter: filter);
      final response = await api.getLibraryApi().getLibraryItems(libraryId, request, extra: const {'noCache': true});
      final data = response.data;
      if (data != null && data.results.isNotEmpty) {
        final total = data.total ?? data.results.length;
        final targetSize = (total / 2).round().clamp(1, 20);

        final otherItems = data.results.where((item) => item.id != currentItemId).toList();
        otherItems.shuffle(); // Randomize!

        final itemsToQueue = otherItems.take(targetSize).toList();
        for (final item in itemsToQueue) {
          addToQueue(QueueItem(itemId: item.id), displayInfo: _displayInfoFromLibraryItem(item), markAsManual: false);
        }
      }
    } catch (e) {
      logger('Failed to queue music library items: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }
}
