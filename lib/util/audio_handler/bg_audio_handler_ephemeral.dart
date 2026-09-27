part of 'bg_audio_handler.dart';

/// Support for playing media the Audiobookshelf server has no concept of —
/// currently, audio embedded in an EPUB's own media overlays (SMIL
/// synchronized narration). This content has no server library-item audio
/// track and no server session, so it is played directly through the shared
/// player, bypassing [SessionRepository.openSession]/`closeSession` and the
/// server session-sync path entirely.
///
/// Everything else downstream (`PlaybackSyncService`, [PlayerHistoryHandler],
/// bookmark/session-based lookups) already gates on
/// `sessionRepositoryProvider.currentSession` being non-null, so as long as
/// this path never opens a real session, those systems naturally stay inert
/// for this content without any extra flag.
extension BGAudioHandlerEphemeral on BGAudioHandler {
  /// Plays [media] directly, without a server session. Reuses the same
  /// source-loading/seek/play sequence [_playItemFromPositionInternal] uses
  /// for a fresh (non-current) item, minus the `openSession` call.
  ///
  /// Callers are responsible for their own progress persistence for this
  /// content — see the EPUB reading-progress sync path, which is what
  /// keeps this resumable across other reading clients.
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

  /// True while the currently loaded media was started via
  /// [playEphemeralMedia] rather than a real server session — i.e. the
  /// server has no session tracking this playback at all. Callers (e.g. the
  /// reader) can use this to decide whether to run their own progress sync
  /// instead of relying on the normal session-sync path.
  bool get isPlayingEphemeralMedia =>
      _currentMediaItem != null && _ref.read(sessionRepositoryProvider).currentSession == null;
}
