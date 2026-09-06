part of 'bg_audio_handler.dart';

extension _BGAudioHandlerRuntime on BGAudioHandler {
  Future<bool> _handlePlaybackFailure(PlayerException error) {
    switch (classifyPlaybackError(error)) {
      case PlaybackFailureAction.retryStream:
        _scheduleStreamRecoveryRetry(error);
        return Future<bool>.value(true);
      case PlaybackFailureAction.transcode:
        return _attemptTranscodeFallback(error);
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
  }) {
    final repository = _ref.read(sessionRepositoryProvider);
    if (repository.currentSession?.playMethod == 2) {
      return Future<bool>.value(false);
    }

    final activeFallback = _transcodeFallbackFuture;
    if (activeFallback != null) {
      return activeFallback;
    }

    final fallback = _performTranscodeFallback(error, initialPosition: initialPosition, resumePlayback: resumePlayback);
    _transcodeFallbackFuture = fallback;
    unawaited(
      fallback.whenComplete(() {
        if (identical(_transcodeFallbackFuture, fallback)) {
          _transcodeFallbackFuture = null;
        }
      }),
    );
    return fallback;
  }

  Future<bool> _performTranscodeFallback(
    PlayerException error, {
    Duration? initialPosition,
    required bool resumePlayback,
  }) async {
    final media = _currentMediaItem;
    if (_isDisposing || media == null || media.local || isCastControlActive) {
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
    final shouldResume = resumePlayback && playerControlState.playing;
    bool isCurrentRequest() => !_isDisposing && identical(_currentMediaItem, media) && !isCastControlActive;

    try {
      logger(
        'Direct playback failed due to decoder incompatibility ($error). '
        'Retrying with server transcoding.',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );

      await _syncService.flush(positionOverride: resumePosition, sessionClosing: true);
      if (!isCurrentRequest()) return false;

      final transcodedMedia = await repository.reopenSessionWithTranscode(media.itemId, episodeId: media.episodeId);
      if (!isCurrentRequest() || transcodedMedia == null) {
        return false;
      }
      if (repository.currentSession?.playMethod != 2) {
        logger('Server did not return a transcoded session.', tag: 'AudioHandler', level: InfoLevel.error);
        return false;
      }

      _currentMediaItem = transcodedMedia;
      await _setSource(initialPosition: resumePosition, ignoreSavedProgress: true);

      if (shouldResume && identical(_currentMediaItem, transcodedMedia) && !_isDisposing && !isCastControlActive) {
        await _syncedPlay();
      }

      return true;
    } catch (e, s) {
      logger('Transcode fallback failed: $e\n$s', tag: 'AudioHandler', level: InfoLevel.error);
      return false;
    } finally {
      _transcodeFallbackInFlight = false;
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
    if (_isDisposing || _currentMediaItem == null || isCastControlActive) {
      return;
    }

    if (_streamRecoveryRetryTimer != null || _streamRecoveryInFlight) {
      return;
    }

    final currentState = _player.playerState;
    if (currentState.playing && currentState.processingState == ProcessingState.ready) {
      _resetStreamRecoveryState(clearWindow: true);
      return;
    }

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

      if (_isDisposing || _currentMediaItem == null || isCastControlActive || _streamRecoveryInFlight) {
        return;
      }

      _streamRecoveryInFlight = true;
      _streamRecoveryAttempts += 1;
      _lastStreamRecoveryAttemptAt = DateTime.now();

      try {
        await _syncedPlay();
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
