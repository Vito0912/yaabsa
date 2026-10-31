part of 'bg_audio_handler.dart';

extension BGAudioHandlerCasting on BGAudioHandler {
  Future<void> castToDevice(CastDevice device) async {
    if (_castConnecting) {
      throw StateError('A cast connection is already being prepared');
    }

    _castConnecting = true;
    try {
      await _castToDeviceInternal(device);
    } finally {
      _castConnecting = false;
      _refreshPlayerControlState();
      unawaited(_updatePlaybackState());
    }
  }

  Future<void> _castToDeviceInternal(CastDevice device) async {
    final media = _currentMediaItem;
    if (isReaderNarration || media == null || media.tracks.isEmpty) {
      throw StateError('There is no audio available to cast');
    }

    final startPosition = position;
    final wasPlaying = isCastControlActive ? playerControlState.playing : _player.playing;
    final trackIndex = media.getIndexForDuration(startPosition);
    CastMedia? prepared;
    var handedToService = false;
    _refreshPlayerControlState();

    try {
      if (isCastControlActive) {
        await disconnectCast();
      }

      await _player.pause();
      prepared = await _prepareCastMedia(
        device: device,
        media: media,
        trackIndex: trackIndex,
        position: startPosition,
        autoPlay: wasPlaying,
      );
      if (!identical(_currentMediaItem, media) || _isDisposing) {
        throw StateError('Playback changed while preparing the cast');
      }

      await casting.connect(device);
      await _castDeactivation;
      if (!identical(_currentMediaItem, media) || _isDisposing) {
        throw StateError('Playback changed while connecting');
      }

      handedToService = true;
      await _loadCastWithFallback(
        prepared: prepared,
        device: device,
        media: media,
        trackIndex: trackIndex,
        position: startPosition,
        autoPlay: wasPlaying,
      );
      if (!identical(_currentMediaItem, media) || _isDisposing) {
        throw StateError('Playback changed while connecting');
      }

      activateCastControl(contentId: media.id, trackIndex: trackIndex);
      _castRequestedPlaying = wasPlaying;
    } catch (_) {
      if (!handedToService) {
        await prepared?.release?.call();
      }

      _castHandoffPosition = startPosition;
      try {
        await casting.disconnect();
        await deactivateCastControl(fallbackPosition: startPosition);
      } finally {
        _castHandoffPosition = null;
      }

      if (identical(_currentMediaItem, media) && !_isDisposing && wasPlaying) {
        unawaited(_player.play());
      }

      rethrow;
    }
  }

  Future<void> disconnectCast({Duration? positionOverride, bool restoreLocalPosition = true}) async {
    var castPosition = positionOverride ?? position;
    if (positionOverride == null && isCastControlActive) {
      try {
        castPosition = _castAbsolutePosition(await casting.refreshPosition());
      } catch (error) {
        logger('Unable to refresh cast position: $error', tag: 'Casting', level: InfoLevel.warning);
      }
    }

    _castHandoffPosition = castPosition;
    try {
      await casting.disconnect();
    } finally {
      try {
        await deactivateCastControl(fallbackPosition: castPosition, restoreLocalPosition: restoreLocalPosition);
      } finally {
        _castHandoffPosition = null;
        _refreshPlayerControlState();
      }
    }
  }

  Future<void> _disconnectCastForUserChange() async {
    if (!casting.hasConnectedSession) {
      return;
    }

    try {
      await disconnectCast();
    } catch (error) {
      logger('Unable to disconnect cast after user change: $error', tag: 'Casting', level: InfoLevel.warning);
    }
  }

  Future<void> _loadCastPosition(Duration target, {required bool autoPlay, bool forceTranscode = false}) async {
    final media = _currentMediaItem;
    if (media == null) {
      return;
    }

    final device = casting.activeDevice;
    if (device == null) {
      return;
    }

    final trackIndex = media.getIndexForDuration(target);
    final prepared = await _prepareCastMedia(
      device: device,
      media: media,
      trackIndex: trackIndex,
      position: target,
      autoPlay: autoPlay,
      forceTranscode: forceTranscode || (casting.currentMedia?.isTranscoded ?? false),
    );
    if (!identical(_currentMediaItem, media) || !casting.hasConnectedSession || _isDisposing) {
      await prepared.release?.call();
      return;
    }

    try {
      await _loadCastWithFallback(
        prepared: prepared,
        device: device,
        media: media,
        trackIndex: trackIndex,
        position: target,
        autoPlay: autoPlay,
      );
    } catch (_) {
      await disconnectCast();
      rethrow;
    }
    activateCastControl(contentId: media.id, trackIndex: trackIndex);
    _castRequestedPlaying = autoPlay;
  }

  Future<CastMedia> _prepareCastMedia({
    required CastDevice device,
    required InternalMedia media,
    required int trackIndex,
    required Duration position,
    required bool autoPlay,
    bool forceTranscode = false,
  }) async {
    final repository = _ref.read(sessionRepositoryProvider);
    final binding = repository.currentSessionBinding;
    final streamId = repository.streamSessionId;
    final hasServerStream = binding != null && (!binding.isLocal || streamId != binding.sessionId);
    final serverSession = hasServerStream ? binding.session.copyWith(id: streamId ?? binding.sessionId) : null;

    return resolveCastMedia(
      media: media,
      trackIndex: trackIndex,
      position: position,
      autoPlay: autoPlay,
      api: _ref.read(absApiProvider),
      headers: currentRequestHeaders,
      supportedMimeTypes: await casting.supportedMimeTypes(device),
      castDeviceId: '${device.protocol.name}:${device.id}',
      serverSession: serverSession,
      forceTranscode: forceTranscode,
    );
  }

  Future<void> _loadCastWithFallback({
    required CastMedia prepared,
    required CastDevice device,
    required InternalMedia media,
    required int trackIndex,
    required Duration position,
    required bool autoPlay,
  }) async {
    final wasLoading = _castTrackLoading;
    _castTrackLoading = true;
    try {
      await _tryLoadCastWithFallback(
        prepared: prepared,
        device: device,
        media: media,
        trackIndex: trackIndex,
        position: position,
        autoPlay: autoPlay,
      );
    } finally {
      _castTrackLoading = wasLoading;
    }
  }

  Future<void> _tryLoadCastWithFallback({
    required CastMedia prepared,
    required CastDevice device,
    required InternalMedia media,
    required int trackIndex,
    required Duration position,
    required bool autoPlay,
  }) async {
    final canRetry = !prepared.isTranscoded && _ref.read(absApiProvider) != null;
    try {
      final loading = casting.load(prepared, retainConnectionOnFailure: canRetry);
      activateCastControl(contentId: media.id, trackIndex: trackIndex);
      _castRequestedPlaying = autoPlay;
      await loading;
    } on CastPlaybackException catch (error) {
      if (!canRetry ||
          !error.canTranscode ||
          !casting.hasConnectedSession ||
          !identical(_currentMediaItem, media) ||
          _isDisposing) {
        rethrow;
      }

      logger('Receiver rejected direct playback, requesting server transcoding', tag: 'Casting', level: InfoLevel.info);
      final transcoded = await _prepareCastMedia(
        device: device,
        media: media,
        trackIndex: trackIndex,
        position: position,
        autoPlay: autoPlay,
        forceTranscode: true,
      );
      if (!identical(_currentMediaItem, media) || !casting.hasConnectedSession || _isDisposing) {
        await transcoded.release?.call();
        throw StateError('Cast playback was cancelled');
      }

      await casting.load(transcoded);
    }
  }

  Future<void> _handleCastFinished() async {
    final media = _currentMediaItem;
    final remote = casting.currentMedia;
    if (media == null || remote == null || _castTrackLoading) {
      return;
    }

    _castTrackLoading = true;
    final end = remote.trackOffset + remote.duration;
    try {
      if (end < media.totalDuration - const Duration(milliseconds: 500)) {
        await _loadCastPosition(end, autoPlay: true);
      } else {
        await deactivateCastControl(fallbackPosition: media.totalDuration);
        await casting.disconnect();
      }
    } catch (error) {
      logger('Unable to advance cast track: $error', tag: 'Casting', level: InfoLevel.warning);
      await disconnectCast();
    } finally {
      _castTrackLoading = false;
      _refreshPlayerControlState();
      unawaited(_updatePlaybackState());
    }
  }
}
