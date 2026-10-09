part of 'bg_audio_handler.dart';

extension _BGAudioHandlerRuntime on BGAudioHandler {
  Future<bool> _handlePlaybackFailure(PlayerException error) async {
    if (await _attemptLocalStreamingFallback(error)) return true;
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

  Future<bool> _attemptLocalStreamingFallback(
    PlayerException error, {
    Duration? initialPosition,
    bool resumePlayback = true,
  }) async {
    final media = _currentMediaItem;
    if (_isDisposing || media == null || !media.local || isCastControlActive) return false;
    final index = error.index ?? _currentTrackIndex;
    if (index < 0 || index >= media.tracks.length) return false;
    final uri = Uri.tryParse(media.tracks[index].url ?? '');
    if (uri?.scheme != 'http' && uri?.scheme != 'https') return false;
    final activeFallback = _localStreamingFallbackFuture;
    if (activeFallback != null) return activeFallback;

    final fallback = _reopenLocalSessionForStreaming(
      media,
      resumePosition: initialPosition ?? position,
      shouldResume: resumePlayback && playerControlState.playing,
    );
    _localStreamingFallbackFuture = fallback;
    try {
      return await fallback;
    } finally {
      if (identical(_localStreamingFallbackFuture, fallback)) _localStreamingFallbackFuture = null;
    }
  }

  Future<bool> _reopenLocalSessionForStreaming(
    InternalMedia media, {
    required Duration resumePosition,
    required bool shouldResume,
  }) async {
    bool isCurrentRequest() => !_isDisposing && identical(_currentMediaItem, media) && !isCastControlActive;
    try {
      await _syncService.flush(positionOverride: resumePosition, sessionClosing: true);
      if (!isCurrentRequest()) return false;
      final streamedMedia = await _ref
          .read(sessionRepositoryProvider)
          .reopenSessionForStreaming(media.itemId, episodeId: media.episodeId);
      if (!isCurrentRequest() || streamedMedia == null || streamedMedia.local) return false;
      _currentMediaItem = streamedMedia;
      await _setSource(initialPosition: resumePosition, ignoreSavedProgress: true);
      if (shouldResume && identical(_currentMediaItem, streamedMedia) && !_isDisposing && !isCastControlActive) {
        await _syncedPlay();
      }
      return true;
    } catch (error, stackTrace) {
      logger(
        'Could not stream the missing audio file: $error\n$stackTrace',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return false;
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
    _castRequestedPlaying = null;
    _lastObservedCastPosition = null;
    _lastCastPositionAdvance = null;
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
    _streamRecoveryGeneration++;
    _streamRecoveryPendingError = null;

    if (clearWindow) {
      _streamRecoveryAttempts = 0;
      _lastStreamRecoveryAttemptAt = null;
    }
  }

  void _scheduleStreamRecoveryRetry(Object error, {bool resumeAfterReloadFailure = false}) {
    if (_isDisposing || _currentMediaItem == null || isCastControlActive) {
      return;
    }

    if (!_player.playing && !resumeAfterReloadFailure) return;

    _streamRecoveryResumePosition ??= position;
    if (_streamRecoveryInFlight) {
      _streamRecoveryPendingError = error;
      return;
    }

    if (_streamRecoveryRetryTimer != null) {
      return;
    }

    final recoveryMedia = _currentMediaItem;
    final recoveryGeneration = _streamRecoveryGeneration;
    bool isCurrentRecovery() =>
        !_isDisposing &&
        identical(_currentMediaItem, recoveryMedia) &&
        _streamRecoveryGeneration == recoveryGeneration &&
        !isCastControlActive;

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
      unawaited(pause());
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

      if (!isCurrentRecovery() || (!_player.playing && !resumeAfterReloadFailure) || _streamRecoveryInFlight) {
        return;
      }

      _streamRecoveryInFlight = true;
      _streamRecoveryAttempts += 1;
      _lastStreamRecoveryAttemptAt = DateTime.now();

      Object? retryError;
      try {
        await _syncedPlay(reloadSource: true);
      } catch (e, s) {
        logger(
          'Stream recovery attempt $_streamRecoveryAttempts failed: $e\n$s',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        if (e is PlayerException && classifyPlaybackError(e) == PlaybackFailureAction.retryStream) {
          retryError = e;
        } else if (isCurrentRecovery()) {
          unawaited(pause());
        }
      } finally {
        _streamRecoveryInFlight = false;
      }

      retryError ??= _streamRecoveryPendingError;
      _streamRecoveryPendingError = null;
      if (retryError != null && isCurrentRecovery()) {
        _scheduleStreamRecoveryRetry(retryError, resumeAfterReloadFailure: true);
      }
    });
  }

  Future<void> _reloadStreamSource(Duration resumePosition, bool Function() isCurrentRequest) async {
    final activeReload = _streamSourceReloadFuture;
    if (activeReload != null) {
      await activeReload;
      if (isCurrentRequest() && _player.processingState == ProcessingState.idle) {
        await _reloadStreamSource(resumePosition, isCurrentRequest);
      }
      return;
    }

    final reload = () async {
      await _player.pause();
      if (!isCurrentRequest()) return;
      await _setSource(initialPosition: resumePosition, ignoreSavedProgress: true);
    }();
    _streamSourceReloadFuture = reload;
    try {
      await reload;
    } finally {
      if (identical(_streamSourceReloadFuture, reload)) _streamSourceReloadFuture = null;
    }
  }

  Duration _rewindPosition(Duration position, Duration rewindBy) {
    if (rewindBy <= Duration.zero) {
      return position;
    }

    final rewoundPosition = position - rewindBy;
    return rewoundPosition.isNegative ? Duration.zero : rewoundPosition;
  }
}
