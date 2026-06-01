part of 'bg_audio_handler.dart';

extension _BGAudioHandlerState on BGAudioHandler {
  Stream<Duration> _durationStreamInternal() {
    return _player.durationStream.map((duration) {
      return _currentMediaItem?.totalDuration ?? duration ?? Duration.zero;
    }).distinct();
  }

  Duration _durationInternal() {
    return _currentMediaItem?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> _positionStreamInternal() {
    final localPositionStream = _player.positionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();

    if (!_supportsCastPlatform) {
      return localPositionStream;
    }

    final castPositionStream = GoogleCastRemoteMediaClient.instance.playerPositionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map(_castAbsolutePosition)
        .distinct();

    return castControlActiveStream.startWith(isCastControlActive).switchMap((castActive) {
      if (castActive) {
        return castPositionStream.startWith(position);
      }
      return localPositionStream.startWith(position);
    }).distinct();
  }

  Stream<Duration> _bufferedPositionStreamInternal() {
    return _player.bufferedPositionStream
        .throttleTime(const Duration(seconds: 1))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();
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
    if (_currentMediaItem == null) return false;
    if (queueList.isNotEmpty) return true;
    return _currentMediaItem!.getNextChapterForDuration(position) != null;
  }

  Stream<bool> _canSkipForwardStreamInternal() {
    return Rx.combineLatest3<Duration, List<InternalChapter>, int, bool>(
      positionStream,
      chaptersStream,
      queueLengthStream,
      (position, chapters, queueLength) {
        if (_currentMediaItem == null) return false;
        if (queueLength > 0) return true;
        return _currentMediaItem!.getNextChapterForDuration(position) != null;
      },
    ).startWith(canSkipForwardNow).distinct();
  }

  Duration _positionInternal() {
    if (isCastControlActive) {
      return _castAbsolutePosition(GoogleCastRemoteMediaClient.instance.playerPosition);
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
    if (!GoogleCastSessionManager.instance.hasConnectedSession) {
      return false;
    }
    if (_currentMediaItem!.id != _castControlledContentId) {
      return false;
    }

    final status = GoogleCastRemoteMediaClient.instance.mediaStatus;
    if (status == null) {
      return false;
    }

    if (status.playerState == CastMediaPlayerState.idle) {
      return false;
    }

    final remoteContentId = status.mediaInformation?.contentId;
    return remoteContentId != null && remoteContentId == _castControlledContentId;
  }

  PlayerState _castPlayerStateFromStatus(GoggleCastMediaStatus? status) {
    if (status == null) {
      return PlayerState(false, ProcessingState.loading);
    }

    switch (status.playerState) {
      case CastMediaPlayerState.playing:
        return PlayerState(true, ProcessingState.ready);
      case CastMediaPlayerState.paused:
        return PlayerState(false, ProcessingState.ready);
      case CastMediaPlayerState.buffering:
        return PlayerState(true, ProcessingState.buffering);
      case CastMediaPlayerState.loading:
        return PlayerState(false, ProcessingState.loading);
      case CastMediaPlayerState.idle:
        if (status.idleReason == GoogleCastMediaIdleReason.finished) {
          return PlayerState(false, ProcessingState.completed);
        }
        return PlayerState(false, ProcessingState.idle);
      case CastMediaPlayerState.unknown:
        return PlayerState(false, ProcessingState.loading);
    }
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
    final trackStart = media.startDurationForTrack(trackIndex);
    final trackEnd = _trackEndDurationForIndex(media, trackIndex);
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
    final trackStart = media.startDurationForTrack(trackIndex);
    final trackEnd = _trackEndDurationForIndex(media, trackIndex);
    final boundedTrackEnd = trackEnd < trackStart ? media.totalDuration : trackEnd;

    final bounded = absolutePosition < trackStart
        ? trackStart
        : (absolutePosition > boundedTrackEnd ? boundedTrackEnd : absolutePosition);
    return bounded - trackStart;
  }

  Duration _localAbsolutePosition() {
    return (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + _player.position;
  }

  void _refreshPlayerControlState() {
    if (_supportsCastPlatform && !GoogleCastSessionManager.instance.hasConnectedSession) {
      _clearCastControlTracking();
    }

    final castActive = _computeCastControlActive();
    if (!_castControlActiveSubject.isClosed && _castControlActiveSubject.value != castActive) {
      _castControlActiveSubject.add(castActive);
    }

    final state = castActive
        ? _castPlayerStateFromStatus(GoogleCastRemoteMediaClient.instance.mediaStatus)
        : _player.playerState;

    if (!_playerControlStateSubject.isClosed && !_isSameControlState(_playerControlStateSubject.value, state)) {
      _playerControlStateSubject.add(state);
    }
  }

  void _setupCastStateListeners() {
    if (!_supportsCastPlatform) {
      return;
    }

    _castSessionSubscription = GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
      final wasCastControlActive = isCastControlActive;
      if (session?.connectionState != GoogleCastConnectState.connected) {
        _clearCastControlTracking();
      }
      _refreshPlayerControlState();
      if (wasCastControlActive != isCastControlActive || isCastControlActive) {
        unawaited(_updatePlaybackState());
      }
    });

    _castMediaStatusSubscription = GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((_) {
      final wasCastControlActive = isCastControlActive;

      final status = GoogleCastRemoteMediaClient.instance.mediaStatus;
      if (status == null || status.playerState == CastMediaPlayerState.idle) {
        _clearCastControlTracking();
      }

      _refreshPlayerControlState();
      if (wasCastControlActive != isCastControlActive || isCastControlActive) {
        unawaited(_updatePlaybackState());
      }
    });
  }
}
