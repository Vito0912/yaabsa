part of 'bg_audio_handler.dart';

class SleepTimerPlaybackOwner {
  const SleepTimerPlaybackOwner({
    required this.media,
    required this.binding,
    required this.navigationGeneration,
    required this.playbackGeneration,
  });

  final InternalMedia media;
  final PlaybackSessionBinding binding;
  final int navigationGeneration;
  final int playbackGeneration;
}

extension BGAudioHandlerSleepTimer on BGAudioHandler {
  bool isSleepTimerOwnerCurrent({
    required InternalMedia media,
    required PlaybackSessionBinding binding,
    required int navigationGeneration,
    int? playbackGeneration,
  }) {
    final currentMedia = _currentMediaItem;
    final currentSession = _ref.read(sessionRepositoryProvider);

    return !isCastControlActive &&
        currentMedia != null &&
        currentMedia.itemId == media.itemId &&
        currentMedia.episodeId == media.episodeId &&
        currentMedia.sessionId == media.sessionId &&
        binding.sessionId == media.sessionId &&
        currentSession.isCurrentSessionBinding(binding) &&
        _sleepTimerNavigationGeneration == navigationGeneration &&
        (playbackGeneration == null || _sleepTimerPlaybackGeneration == playbackGeneration);
  }

  bool _isSleepTimerPlaybackOwnerCurrent(SleepTimerPlaybackOwner owner) {
    return isSleepTimerOwnerCurrent(
      media: owner.media,
      binding: owner.binding,
      navigationGeneration: owner.navigationGeneration,
      playbackGeneration: owner.playbackGeneration,
    );
  }

  Future<bool> pauseForSleepTimer(SleepTimerPlaybackOwner owner) async {
    if (!_isSleepTimerPlaybackOwnerCurrent(owner)) return false;

    PlayerUtils.disableWakelock(_ref);
    _resetStreamRecoveryState(clearWindow: true);
    await _player.pause();

    if (!_isSleepTimerPlaybackOwnerCurrent(owner)) return false;
    _clearSmartRewindPauseMarker();
    TrayManager.update();
    return true;
  }

  Future<Duration?> rewindForSleepTimer(SleepTimerPlaybackOwner owner) async {
    bool isCurrent() => _isSleepTimerPlaybackOwnerCurrent(owner);
    if (!isCurrent()) return null;

    final rewindMinutes = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<int>(SettingKeys.sleepTimerAutoRewindMinutes);
    if (rewindMinutes <= 0) return position;

    final target = _rewindPosition(position, Duration(minutes: rewindMinutes));
    if (target >= position) return position;

    await _queueSleepTimerAwareSeek(target, internal: true, continuationIsCurrent: isCurrent);
    return isCurrent() ? position : null;
  }

  Future<bool> flushForSleepTimer(
    SleepTimerPlaybackOwner owner, {
    required Duration position,
    bool closing = false,
  }) async {
    if (!_isSleepTimerPlaybackOwnerCurrent(owner)) return false;

    await _syncService.flush(
      positionOverride: position,
      sessionClosing: closing,
      binding: owner.binding,
      forcePositionSync: true,
    );
    return _isSleepTimerPlaybackOwnerCurrent(owner);
  }

  Future<bool> stopForSleepTimer(SleepTimerPlaybackOwner owner, {required Duration position}) async {
    if (!_isSleepTimerPlaybackOwnerCurrent(owner)) return false;

    final repository = _ref.read(sessionRepositoryProvider);
    if (!repository.detachSessionBinding(owner.binding)) return false;

    _recordSleepTimerStop(owner.media, position);
    _clearSleepTimerMedia();
    final detachedGeneration = _sleepTimerNavigationGeneration;

    try {
      await _stopPlayerForSleepTimer(detachedGeneration);
    } finally {
      await repository.closeSessionBinding(owner.binding);
    }

    return _sleepTimerNavigationGeneration == detachedGeneration && _currentMediaItem == null;
  }

  void _recordSleepTimerStop(InternalMedia media, Duration position) {
    unawaited(
      refreshPersonalizedShelfForCompletedItem(
        container: _ref,
        itemId: media.itemId,
        preferredLibraryId: media.libraryId,
        sourceTag: 'AudioHandler',
        reason: 'sleep timer stop',
      ),
    );
    unawaited(PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.stop, media: media, position: position));
  }

  void _clearSleepTimerMedia() {
    _setQueueTransitionLoading(false);
    _clearSmartRewindPauseMarker();
    _clearPausedManualSeekMarker();
    _resetStreamRecoveryState(clearWindow: true);

    _currentMediaItem = null;
    _restoredMediaItem = null;
    _restoredPosition = Duration.zero;
    mediaItem.add(null);
    _currentTrackIndex = 0;
    PlayerUtils.disableWakelock(_ref);
  }

  Future<void> _stopPlayerForSleepTimer(int detachedGeneration) async {
    if (!kIsWeb && Platform.isLinux) {
      await _player.pause();
      if (_sleepTimerNavigationGeneration == detachedGeneration && _currentMediaItem == null) {
        await _player.seek(Duration.zero);
      }
    } else {
      await _player.stop();
    }

    if (_sleepTimerNavigationGeneration == detachedGeneration && _currentMediaItem == null) {
      TrayManager.update();
    }
  }
}
