part of 'bg_audio_handler.dart';

extension _BGAudioHandlerRuntime on BGAudioHandler {
  Future<bool> _handlePlaybackFailure(PlayerException error) {
    switch (classifyPlaybackError(error)) {
      case PlaybackFailureAction.retryStream:
        _scheduleStreamRecoveryRetry(error);
        return Future<bool>.value(true);
      case PlaybackFailureAction.transcode:
        final lease = _playerMutationBarrier.currentLease;
        if (!playerControlState.playing || lease == null || !_playerMutationBarrier.isCurrent(lease)) {
          return Future<bool>.value(false);
        }
        return _attemptTranscodeFallback(error, mutationLease: lease);
      case PlaybackFailureAction.ignore:
        return Future<bool>.value(true);
      case PlaybackFailureAction.fail:
        return Future<bool>.value(false);
    }
  }

  Future<bool> _attemptTranscodeFallback(
    PlayerException error, {
    Duration? initialPosition,
    bool resumePlayback = true,
    required PlayerMutationLease mutationLease,
  }) {
    if (!_playerMutationBarrier.isCurrent(mutationLease)) {
      return Future<bool>.value(false);
    }

    final repository = _ref.read(sessionRepositoryProvider);
    if (repository.currentSession?.playMethod == 2) {
      return Future<bool>.value(false);
    }

    final activeFallback = _transcodeFallbackFuture;
    final activeLease = _transcodeFallbackLease;
    if (activeFallback != null) {
      if (identical(activeLease, mutationLease) && _playerMutationBarrier.isCurrent(mutationLease)) {
        return activeFallback;
      }
      return activeFallback.then((_) {
        if (!_playerMutationBarrier.isCurrent(mutationLease)) {
          return false;
        }
        return _attemptTranscodeFallback(
          error,
          initialPosition: initialPosition,
          resumePlayback: resumePlayback,
          mutationLease: mutationLease,
        );
      });
    }

    late final Future<bool> fallback;
    fallback = _performTranscodeFallback(
      error,
      initialPosition: initialPosition,
      resumePlayback: resumePlayback,
      mutationLease: mutationLease,
    );
    _transcodeFallbackFuture = fallback;
    _transcodeFallbackLease = mutationLease;
    unawaited(
      fallback.whenComplete(() {
        if (identical(_transcodeFallbackFuture, fallback)) {
          _transcodeFallbackFuture = null;
          _transcodeFallbackLease = null;
        }
      }),
    );
    return fallback;
  }

  Future<bool> _performTranscodeFallback(
    PlayerException error, {
    Duration? initialPosition,
    required bool resumePlayback,
    required PlayerMutationLease mutationLease,
  }) async {
    final media = _currentMediaItem;
    if (_isDisposing ||
        media == null ||
        media.local ||
        isCastControlActive ||
        !_playerMutationBarrier.isCurrent(mutationLease)) {
      return false;
    }

    final repository = _ref.read(sessionRepositoryProvider);
    if (repository.currentSession?.playMethod == 2) {
      return false;
    }

    final mediaKey = _mediaKey(media);
    if (_transcodeFallbackInFlight || _transcodeAttemptedFor == mediaKey) {
      return false;
    }

    _transcodeFallbackInFlight = true;
    _transcodeAttemptedFor = mediaKey;

    final resumePosition = initialPosition ?? position;
    final sourceSessionBinding = repository.currentSessionBinding;
    var ownedMedia = media;
    var completedFallback = false;
    bool isCurrentRequest() =>
        !_isDisposing &&
        identical(_currentMediaItem, ownedMedia) &&
        !isCastControlActive &&
        _playerMutationBarrier.isCurrent(mutationLease);

    try {
      logger(
        'Direct playback failed due to decoder incompatibility ($error). '
        'Retrying with server transcoding.',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );

      if (sourceSessionBinding != null) {
        await _syncService.flush(
          positionOverride: resumePosition,
          sessionClosing: true,
          expectedSessionId: sourceSessionBinding.sessionId,
        );
        if (!isCurrentRequest()) return false;

        await repository.closeSessionBinding(sourceSessionBinding);
        if (!isCurrentRequest()) return false;
      }

      final transcodedMedia = await repository.openSession(
        media.itemId,
        episodeId: media.episodeId,
        forceTranscode: true,
        isStillCurrent: isCurrentRequest,
      );
      if (!isCurrentRequest() || transcodedMedia == null) {
        return false;
      }
      if (repository.currentSession?.playMethod != 2) {
        logger('Server did not return a transcoded session.', tag: 'AudioHandler', level: InfoLevel.error);
        return false;
      }

      _currentMediaItem = transcodedMedia;
      ownedMedia = transcodedMedia;
      await _setSource(
        initialPosition: resumePosition,
        ignoreSavedProgress: true,
        mutationLease: mutationLease,
        isStillCurrent: isCurrentRequest,
      );
      if (!isCurrentRequest()) {
        return false;
      }

      if (resumePlayback) {
        await _syncedPlay(mutationLease: mutationLease);
        if (!isCurrentRequest()) {
          return false;
        }
      }

      completedFallback = true;
      return true;
    } on PlayerInterruptedException {
      return false;
    } catch (e, s) {
      logger('Transcode fallback failed: $e\n$s', tag: 'AudioHandler', level: InfoLevel.error);
      return false;
    } finally {
      _transcodeFallbackInFlight = false;
      if (!completedFallback &&
          !_playerMutationBarrier.isCurrent(mutationLease) &&
          _transcodeAttemptedFor == mediaKey) {
        _transcodeAttemptedFor = null;
      }
    }
  }

  bool _isSameControlState(PlayerState left, PlayerState right) {
    return left.playing == right.playing && left.processingState == right.processingState;
  }

  void _clearCastControlTracking() {
    _castControlledContentId = null;
    _castControlledTrackIndex = 0;
  }

  void _emitShouldShowPlayer() {
    if (!_showPlayerSubject.isClosed) {
      _showPlayerSubject.add(_shouldShowPlayerNowInternal());
    }
  }

  bool _isSameLastPlayedMiniPlayerSnapshot(LastPlayedMiniPlayerSnapshot? left, LastPlayedMiniPlayerSnapshot? right) {
    if (left == null && right == null) {
      return true;
    }

    if (left == null || right == null) {
      return false;
    }

    return left.itemId == right.itemId &&
        left.episodeId == right.episodeId &&
        left.title == right.title &&
        left.subtitle == right.subtitle &&
        left.author == right.author &&
        left.cover == right.cover;
  }

  void _setLastPlayedMiniPlayerSnapshot(LastPlayedMiniPlayerSnapshot? snapshot) {
    if (_lastPlayedMiniPlayerSnapshotSubject.isClosed) {
      return;
    }

    final current = _lastPlayedMiniPlayerSnapshotSubject.value;
    if (_isSameLastPlayedMiniPlayerSnapshot(current, snapshot)) {
      return;
    }

    _lastPlayedMiniPlayerSnapshotSubject.add(snapshot);
    _emitShouldShowPlayer();
  }

  void _setAndroidAutoMoreMenuVisible(bool visible, {Duration? autoCloseAfter}) {
    if (_androidAutoMoreMenuVisible == visible && autoCloseAfter == null) {
      return;
    }

    _androidAutoMoreMenuVisible = visible;

    _androidAutoMoreMenuTimer?.cancel();
    _androidAutoMoreMenuTimer = null;

    if (visible && autoCloseAfter != null) {
      _androidAutoMoreMenuTimer = Timer(autoCloseAfter, () {
        if (!_androidAutoMoreMenuVisible) {
          return;
        }

        _androidAutoMoreMenuVisible = false;
        unawaited(_updatePlaybackState());
      });
    }

    unawaited(_updatePlaybackState());
  }

  void _setQueueTransitionLoading(bool value, {bool emitMediaWhenEmpty = false}) {
    if (!value) {
      _queueTransitionItemId = null;
      _queueTransitionEpisodeId = null;
    }

    if (_queueTransitionLoading == value) {
      return;
    }

    _queueTransitionLoading = value;
    if (!_queueTransitionLoadingSubject.isClosed) {
      _queueTransitionLoadingSubject.add(value);
    }
    _emitShouldShowPlayer();

    if (emitMediaWhenEmpty && !value && _currentMediaItem == null && !mediaItemStream.isClosed) {
      mediaItemStream.add(null);
    }

    unawaited(_updatePlaybackState());
  }

  void _setQueueTransitionTargetItem(QueueItem? item) {
    _queueTransitionItemId = item?.itemId;
    _queueTransitionEpisodeId = item?.episodeId;
  }

  void _recordPlayerHistoryForState(PlayerState state) {
    final isPlayingReady = state.playing && state.processingState == ProcessingState.ready;
    final isCompleted = state.processingState == ProcessingState.completed;

    if (isCompleted && !_historyWasCompleted) {
      unawaited(PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.completed));
    }

    if (isPlayingReady && !_historyWasPlayingReady) {
      unawaited(PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.play));
    }

    if (!state.playing && state.processingState == ProcessingState.ready && _historyWasPlayingReady) {
      unawaited(PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.pause));
    }

    _historyWasPlayingReady = isPlayingReady;
    _historyWasCompleted = isCompleted;
  }

  bool _queueItemsMatch({
    required String leftItemId,
    required String? leftEpisodeId,
    required String rightItemId,
    required String? rightEpisodeId,
  }) {
    return leftItemId == rightItemId && leftEpisodeId == rightEpisodeId;
  }

  String _queueItemReferenceKey({required String itemId, String? episodeId}) {
    return '$itemId::${episodeId ?? ''}';
  }

  void _resetStreamRecoveryState({bool clearWindow = false}) {
    _streamRecoveryRetryTimer?.cancel();
    _streamRecoveryRetryTimer = null;
    _streamRecoveryInFlight = false;

    if (clearWindow) {
      _streamRecoveryAttempts = 0;
      _lastStreamRecoveryAttemptAt = null;
    }
  }

  void _scheduleStreamRecoveryRetry(Object error) {
    final media = _currentMediaItem;
    final lease = _playerMutationBarrier.currentLease;
    if (_isDisposing ||
        media == null ||
        isCastControlActive ||
        lease == null ||
        !_playerMutationBarrier.isCurrent(lease)) {
      return;
    }

    if (_streamRecoveryRetryTimer != null || _streamRecoveryInFlight) {
      return;
    }

    final currentState = _player.playerState;
    if (!currentState.playing) {
      return;
    }
    if (currentState.processingState == ProcessingState.ready) {
      _resetStreamRecoveryState(clearWindow: true);
      return;
    }

    final recoveryGuard = DeferredPlayerMutationGuard(
      lease: lease,
      playbackContextGeneration: _playbackContextGeneration,
      seekGeneration: _seekGeneration,
      mediaKey: _mediaKey(media),
    );

    final now = DateTime.now();
    final lastAttemptAt = _lastStreamRecoveryAttemptAt;
    if (lastAttemptAt == null || now.difference(lastAttemptAt) > _streamRecoveryResetWindow) {
      _streamRecoveryAttempts = 0;
    }

    if (_streamRecoveryAttempts >= _streamRecoveryMaxAttempts) {
      logger(
        'Suppressing automatic stream recovery after $_streamRecoveryAttempts attempts within '
        '${_streamRecoveryResetWindow.inSeconds}s. Waiting for manual retry.',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return;
    }

    final delayMs = (_streamRecoveryMinDelayMs * (1 << _streamRecoveryAttempts))
        .clamp(_streamRecoveryMinDelayMs, _streamRecoveryMaxDelayMs)
        .toInt();
    final delay = Duration(milliseconds: delayMs);

    logger(
      'Scheduling stream recovery attempt ${_streamRecoveryAttempts + 1} in '
      '${delay.inMilliseconds}ms after error: $error',
      tag: 'AudioHandler',
      level: InfoLevel.warning,
    );

    _streamRecoveryRetryTimer = Timer(delay, () async {
      _streamRecoveryRetryTimer = null;

      final currentMedia = _currentMediaItem;
      if (_isDisposing ||
          currentMedia == null ||
          isCastControlActive ||
          _streamRecoveryInFlight ||
          !_player.playerState.playing ||
          !recoveryGuard.isCurrent(
            barrier: _playerMutationBarrier,
            playbackContextGeneration: _playbackContextGeneration,
            seekGeneration: _seekGeneration,
            mediaKey: _mediaKey(currentMedia),
          )) {
        return;
      }

      _streamRecoveryInFlight = true;
      _streamRecoveryAttempts += 1;
      _lastStreamRecoveryAttemptAt = DateTime.now();

      try {
        await _syncedPlay(mutationLease: recoveryGuard.lease);
      } catch (e, s) {
        logger(
          'Stream recovery attempt $_streamRecoveryAttempts failed: $e\n$s',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
      } finally {
        _streamRecoveryInFlight = false;
      }
    });
  }

  Duration _rewindPosition(Duration position, Duration rewindBy) {
    if (rewindBy <= Duration.zero) {
      return position;
    }

    final rewoundPosition = position - rewindBy;
    return rewoundPosition.isNegative ? Duration.zero : rewoundPosition;
  }
}
