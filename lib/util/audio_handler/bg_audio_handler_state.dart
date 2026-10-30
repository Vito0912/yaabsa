part of 'bg_audio_handler.dart';

const Duration _subtitlePositionUpdateInterval = Duration(milliseconds: 50);

extension _BGAudioHandlerState on BGAudioHandler {
  Duration get _localTrackOffset {
    final media = _currentMediaItem;

    if (media == null || media.tracks.isEmpty) {
      return Duration.zero;
    }

    return media.offsetForTrack(_currentTrackIndex);
  }

  Stream<Duration> _withSpeechPosition(Stream<Duration> ordinary) {
    return _speechPlaybackSubject.switchMap((speech) {
      if (speech != null) {
        return speech.states.map((state) => state.position);
      }

      return ordinary;
    });
  }

  Stream<Duration> _durationStreamInternal() {
    return _speechPlaybackSubject.switchMap((speech) {
      if (speech != null) {
        return speech.states.map((state) => state.duration);
      }

      return _player.durationStream.map((duration) {
        return _currentMediaItem?.totalDuration ?? duration ?? Duration.zero;
      });
    }).distinct();
  }

  Duration _durationInternal() {
    return _speechPlayback?.state.duration ?? _currentMediaItem?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> _positionStreamInternal() {
    final localPositionStream = _player.positionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map((position) => _localTrackOffset + position)
        .distinct();

    if (!_supportsCastPlatform) {
      return _withSpeechPosition(localPositionStream);
    }

    final castPositionStream = casting.playerPositionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map(_castAbsolutePosition)
        .distinct();

    final ordinary = castControlActiveStream.startWith(isCastControlActive).switchMap((castActive) {
      if (castActive) {
        return castPositionStream.startWith(position);
      }

      return localPositionStream.startWith(position);
    }).distinct();

    return _withSpeechPosition(ordinary);
  }

  Stream<Duration> _subtitlePositionStreamInternal() {
    final cachedStream = _subtitlePositionStream;

    if (cachedStream != null) {
      return cachedStream;
    }

    final localPositionStream = _player
        .createPositionStream(minPeriod: _subtitlePositionUpdateInterval, maxPeriod: _subtitlePositionUpdateInterval)
        .map((position) => _localTrackOffset + position)
        .distinct();

    if (!_supportsCastPlatform) {
      final stream = _withSpeechPosition(localPositionStream);

      _subtitlePositionStream = stream;

      return stream;
    }

    final castPositionStream = casting.playerPositionStream
        .throttleTime(_subtitlePositionUpdateInterval)
        .map(_castAbsolutePosition)
        .distinct();

    final stream = castControlActiveStream.startWith(isCastControlActive).switchMap((castActive) {
      if (castActive) {
        return castPositionStream.startWith(position);
      }

      return localPositionStream.startWith(position);
    }).distinct();
    final combined = _withSpeechPosition(stream);

    _subtitlePositionStream = combined;

    return combined;
  }

  Stream<Duration> _bufferedPositionStreamInternal() {
    return _speechPlaybackSubject.switchMap((speech) {
      if (speech != null) {
        return speech.states.map((state) => state.bufferedPosition);
      }

      return _player.bufferedPositionStream
          .throttleTime(const Duration(seconds: 1))
          .map((position) => _localTrackOffset + position)
          .distinct();
    });
  }

  Duration _notificationBufferedPosition(Duration updatePosition) {
    final speech = _speechPlayback;

    if (speech != null) {
      final buffered = speech.state.bufferedPosition;

      if (_chapterNotificationEnabled) {
        return _clampDuration(buffered - _chapterNotificationOffset, Duration.zero, _chapterNotificationDuration);
      }

      return buffered;
    }

    if (isCastControlActive || _chapterNotificationEnabled) {
      return updatePosition;
    }

    if (_currentMediaItem == null && _restoredMediaItem != null) {
      return _restoredPosition;
    }

    return _localTrackOffset + _player.bufferedPosition;
  }

  AudioProcessingState _notificationProcessingState({
    required bool hasPlaybackContext,
    required bool isTransitionLoading,
    required PlayerState controlState,
  }) {
    if (!hasPlaybackContext) {
      return AudioProcessingState.idle;
    }

    if (isTransitionLoading) {
      return AudioProcessingState.loading;
    }

    if (_currentMediaItem == null && _restoredMediaItem != null) {
      return AudioProcessingState.ready;
    }

    return _toAudioProcessingState(controlState.processingState);
  }

  Stream<InternalChapter?> _chapterStreamInternal() {
    return positionStream
        .throttleTime(const Duration(milliseconds: 1000))
        .map((position) => _currentMediaItem?.getChapterForDuration(position))
        .distinct();
  }

  Stream<List<InternalChapter>> _chaptersStreamInternal() {
    return mediaItemStream.map((position) => _currentMediaItem?.chapters ?? []).distinct();
  }

  Stream<int> _queueLengthStreamInternal() {
    return _queueLengthSubject.stream;
  }

  bool _canSkipForwardNowInternal() {
    if (_currentMediaItem == null) {
      return false;
    }
    if (queueList.isNotEmpty) {
      return true;
    }

    return _currentMediaItem!.getNextChapterForDuration(position) != null;
  }

  Stream<bool> _canSkipForwardStreamInternal() {
    return Rx.combineLatest3<Duration, List<InternalChapter>, int, bool>(
      positionStream,
      chaptersStream,
      queueLengthStream,
      (position, chapters, queueLength) {
        if (_currentMediaItem == null) {
          return false;
        }
        if (queueLength > 0) {
          return true;
        }

        return _currentMediaItem!.getNextChapterForDuration(position) != null;
      },
    ).startWith(canSkipForwardNow).distinct();
  }

  Duration _positionInternal() {
    final handoffPosition = _castHandoffPosition;
    if (handoffPosition != null) {
      return handoffPosition;
    }

    if (_speechPlayback != null) {
      return _speechPlayback!.state.position;
    }

    if (isCastControlActive) {
      final pos = _castAbsolutePosition(casting.playerPosition);

      if (casting.hasConnectedSession) {
        _lastKnownCastPosition = pos;
      }

      return pos;
    }

    if (_currentMediaItem == null && _restoredMediaItem != null) {
      return _restoredPosition;
    }

    return _localAbsolutePosition();
  }

  Stream<bool> _shouldShowPlayerInternal() {
    return _showPlayerSubject.stream.distinct();
  }

  bool _shouldShowPlayerNowInternal() {
    if (_currentMediaItem != null || _queueTransitionLoading) {
      return true;
    }

    if (!_isAlwaysShowLastPlayedMiniPlayerEnabled()) {
      return false;
    }

    return lastPlayedMiniPlayerSnapshot != null;
  }

  bool _isAlwaysShowLastPlayedMiniPlayerEnabled() {
    return _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.showLastPlayedMiniPlayerAlways);
  }

  bool _computeCastControlActive() {
    if (!_supportsCastPlatform) {
      return false;
    }
    if (_castControlledContentId == null || _currentMediaItem == null) {
      return false;
    }
    if (!casting.hasConnectedSession) {
      return false;
    }
    if (_currentMediaItem!.id != _castControlledContentId) {
      return false;
    }

    final status = casting.mediaStatus;

    if (status == null) {
      return true;
    }

    if (status.playerState == RemotePlayerState.idle && !_castTrackLoading) {
      return false;
    }

    final remoteContentId = status.contentId;

    return remoteContentId != null && remoteContentId == _castControlledContentId;
  }

  PlayerState _castPlayerStateFromStatus(RemoteMediaStatus? status) {
    if (status == null) {
      return PlayerState(false, ProcessingState.loading);
    }

    switch (status.playerState) {
      case RemotePlayerState.playing:
        _castRequestedPlaying = true;
        return PlayerState(true, ProcessingState.ready);
      case RemotePlayerState.paused:
        _castRequestedPlaying = false;
        return PlayerState(false, ProcessingState.ready);
      case RemotePlayerState.buffering:
        if (_castRequestedPlaying == false) {
          return PlayerState(false, ProcessingState.ready);
        }
        if (_castPositionIsAdvancing()) {
          return PlayerState(true, ProcessingState.ready);
        }
        return PlayerState(true, ProcessingState.buffering);
      case RemotePlayerState.loading:
        return PlayerState(false, ProcessingState.loading);
      case RemotePlayerState.idle:
        if (status.idleReason == RemoteIdleReason.finished) {
          return PlayerState(false, ProcessingState.completed);
        }
        return PlayerState(false, ProcessingState.idle);
      case RemotePlayerState.unknown:
        if (_castRequestedPlaying == false) {
          return PlayerState(false, ProcessingState.ready);
        }
        return PlayerState(true, ProcessingState.loading);
    }
  }

  bool _castPositionIsAdvancing() {
    final lastAdvance = _lastCastPositionAdvance;

    return lastAdvance != null && DateTime.now().difference(lastAdvance) < const Duration(seconds: 2);
  }

  AudioProcessingState _toAudioProcessingState(ProcessingState state) {
    return {
      ProcessingState.idle: AudioProcessingState.idle,
      ProcessingState.loading: AudioProcessingState.loading,
      ProcessingState.buffering: AudioProcessingState.buffering,
      ProcessingState.ready: AudioProcessingState.ready,
      ProcessingState.completed: AudioProcessingState.completed,
    }[state]!;
  }

  int _resolvedCastTrackIndex(InternalMedia media) {
    if (media.tracks.isEmpty) {
      return 0;
    }

    final maxIndex = media.tracks.length - 1;

    return _castControlledTrackIndex.clamp(0, maxIndex).toInt();
  }

  Duration _trackEndDurationForIndex(InternalMedia media, int trackIndex) {
    final track = media.tracks[trackIndex];
    final endSeconds = track.end ?? ((track.start ?? 0) + track.duration);

    return Duration(microseconds: (endSeconds * Duration.microsecondsPerSecond).round());
  }

  Duration _castAbsolutePosition(Duration castRelativePosition) {
    final media = _currentMediaItem;

    if (media == null || media.tracks.isEmpty) {
      return castRelativePosition;
    }

    final trackIndex = _resolvedCastTrackIndex(media);
    final trackStart = casting.currentMedia?.trackOffset ?? media.startDurationForTrack(trackIndex);
    final trackEnd = casting.currentMedia == null
        ? _trackEndDurationForIndex(media, trackIndex)
        : trackStart + casting.currentMedia!.duration;
    final boundedTrackEnd = trackEnd < trackStart ? media.totalDuration : trackEnd;
    final absolute = trackStart + castRelativePosition;

    if (absolute < trackStart) {
      return trackStart;
    }
    if (absolute > boundedTrackEnd) {
      return boundedTrackEnd;
    }
    if (absolute > media.totalDuration) {
      return media.totalDuration;
    }

    return absolute;
  }

  Duration _absoluteToCastRelativePosition(Duration absolutePosition) {
    final media = _currentMediaItem;

    if (media == null || media.tracks.isEmpty) {
      return absolutePosition;
    }

    final trackIndex = _resolvedCastTrackIndex(media);
    final trackStart = casting.currentMedia?.trackOffset ?? media.startDurationForTrack(trackIndex);
    final trackEnd = casting.currentMedia == null
        ? _trackEndDurationForIndex(media, trackIndex)
        : trackStart + casting.currentMedia!.duration;
    final boundedTrackEnd = trackEnd < trackStart ? media.totalDuration : trackEnd;

    final bounded = absolutePosition < trackStart
        ? trackStart
        : (absolutePosition > boundedTrackEnd ? boundedTrackEnd : absolutePosition);

    return bounded - trackStart;
  }

  Duration _localAbsolutePosition() {
    final media = _currentMediaItem;
    if (media != null && _player.processingState == ProcessingState.completed) {
      return media.totalDuration;
    }

    return _localTrackOffset + _player.position;
  }

  void _refreshPlayerControlState() {
    if (_supportsCastPlatform && !casting.hasConnectedSession) {
      _clearCastControlTracking();
    }

    final castActive = _computeCastControlActive();

    if (!_castControlActiveSubject.isClosed && _castControlActiveSubject.value != castActive) {
      _castControlActiveSubject.add(castActive);
    }

    final PlayerState state;
    if (_castConnecting || _castTrackLoading) {
      state = PlayerState(false, ProcessingState.loading);
    } else if (castActive) {
      state = _castPlayerStateFromStatus(casting.mediaStatus);
    } else {
      state = _speechPlayback?.state.playerState ?? _player.playerState;
    }

    if (!_playerControlStateSubject.isClosed && !_isSameControlState(_playerControlStateSubject.value, state)) {
      _playerControlStateSubject.add(state);
    }
  }

  void _setupCastStateListeners() {
    if (!_supportsCastPlatform) {
      return;
    }

    _castSessionSubscription = casting.connected.listen((connected) {
      final wasCastControlActive = isCastControlActive;

      if (connected != casting.hasConnectedSession) {
        return;
      }

      if (_castHandoffPosition != null) {
        return;
      }

      if (!connected) {
        if (wasCastControlActive && _currentMediaItem?.id == _castControlledContentId) {
          unawaited(deactivateCastControl());
        } else {
          _clearCastControlTracking();
        }
      }

      _refreshPlayerControlState();

      if (wasCastControlActive != isCastControlActive || isCastControlActive) {
        unawaited(_updatePlaybackState());
      }
    });

    _castMediaStatusSubscription = casting.mediaStatusStream.listen((_) {
      if (_castHandoffPosition != null) {
        return;
      }

      final wasCastControlActive = isCastControlActive;

      final status = casting.mediaStatus;

      if (status?.playerState == RemotePlayerState.paused || status?.playerState == RemotePlayerState.idle) {
        _lastCastPositionAdvance = null;
      }

      if (!_castTrackLoading && status != null && status.playerState == RemotePlayerState.idle) {
        final reason = status.idleReason;

        if (reason == RemoteIdleReason.finished ||
            reason == RemoteIdleReason.cancelled ||
            reason == RemoteIdleReason.error) {
          if (wasCastControlActive && reason == RemoteIdleReason.finished) {
            unawaited(_handleCastFinished());
          } else if (wasCastControlActive) {
            unawaited(deactivateCastControl());
          } else {
            _clearCastControlTracking();
          }
        }
      }

      _refreshPlayerControlState();

      if (wasCastControlActive != isCastControlActive || isCastControlActive) {
        unawaited(_updatePlaybackState());
      }
    });

    _castPositionSubscription = casting.playerPositionStream.listen((castPosition) {
      if (!isCastControlActive) {
        _lastObservedCastPosition = null;
        _lastCastPositionAdvance = null;

        return;
      }

      final previousPosition = _lastObservedCastPosition;

      _lastObservedCastPosition = castPosition;
      _lastKnownCastPosition = _castAbsolutePosition(castPosition);

      if (previousPosition != null &&
          castPosition > previousPosition &&
          castPosition - previousPosition <= const Duration(seconds: 2)) {
        _lastCastPositionAdvance = DateTime.now();
      }

      final previousState = playerControlState;

      _refreshPlayerControlState();

      if (!_isSameControlState(previousState, playerControlState)) {
        unawaited(_updatePlaybackState());
      }
    });
  }
}
