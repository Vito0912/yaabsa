part of 'bg_audio_handler.dart';

extension BGAudioHandlerEphemeral on BGAudioHandler {
  Future<bool> playEphemeralMedia(InternalMedia media, {Duration initialPosition = Duration.zero}) async {
    _activeMusicLibraryId = null;
    PlayerUtils.enableWakelock(_ref);
    _resetStreamRecoveryState(clearWindow: true);

    final hasPlaybackToReplace =
        _currentMediaItem != null || queueList.isNotEmpty || _player.processingState != ProcessingState.idle;
    if (hasPlaybackToReplace) {
      await stop(clearQueue: true);
    }

    _setQueueTransitionTargetItem(null);
    _setQueueTransitionLoading(true);
    _lastQueueItem = null;
    media.populateFields();
    _currentMediaItem = media;
    _currentTrackIndex = 0;

    try {
      await _setSource(ignoreSavedProgress: true);
    } catch (e, s) {
      logger(
        'Failed to prepare ephemeral media ${media.itemId} for playback: $e\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      _currentMediaItem = null;
      PlayerUtils.disableWakelock(_ref);
      _setQueueTransitionLoading(false, emitMediaWhenEmpty: true);
      return false;
    }

    try {
      _clearSmartRewindPauseMarker();
      await _seekInternal(initialPosition);
      _setQueueTransitionLoading(false);
      await _syncedPlay();
      TrayManager.update();
      return true;
    } catch (e, s) {
      logger(
        'Failed to start ephemeral media ${media.itemId} from the requested position: $e\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      PlayerUtils.disableWakelock(_ref);
      _setQueueTransitionLoading(false, emitMediaWhenEmpty: true);
      return false;
    }
  }

  bool get isPlayingEphemeralMedia =>
      _currentMediaItem != null && _ref.read(sessionRepositoryProvider).currentSession == null;
}
