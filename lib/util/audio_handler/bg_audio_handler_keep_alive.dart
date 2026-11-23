part of 'bg_audio_handler.dart';

extension _BGAudioHandlerKeepAlive on BGAudioHandler {
  void _setupPlaybackKeepAlive() {
    if (kIsWeb ||
        !(Platform.isAndroid || Platform.isIOS || Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
      return;
    }

    final setting = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<String>(SettingKeys.preventWordClipping);

    _playbackKeepAliveLevel = PlaybackKeepAliveLevel.fromSettingValue(setting);

    _playbackKeepAliveSubscriptions.add(
      _ref
          .read(appDatabaseProvider)
          .watchGlobalSetting(SettingKeys.preventWordClipping)
          .map((setting) => setting?.value)
          .distinct()
          .listen((value) {
            _playbackKeepAliveLevel = PlaybackKeepAliveLevel.fromSettingValue(value);
            _syncPlaybackKeepAlive();
          }),
    );
    _playbackKeepAliveSubscriptions.add(
      Rx.merge<Object?>([
        playerControlStateStream,
        _player.playerStateStream,
        castControlActiveStream,
        volumeStream,
        mediaItemStream,
      ]).listen((_) {
        _syncPlaybackKeepAlive();
      }),
    );
  }

  void _syncPlaybackKeepAlive() {
    if (_isDisposing) {
      return;
    }

    final state = _speechPlayback?.state.playerState ?? _player.playerState;
    final localPlaybackActive =
        _currentMediaItem != null &&
        state.playing &&
        state.processingState == ProcessingState.ready &&
        !isCastControlActive &&
        !_castConnecting &&
        !_castTrackLoading;

    _playbackKeepAlive.update(playing: localPlaybackActive, volume: volume, level: _playbackKeepAliveLevel);
  }

  Future<void> _disposePlaybackKeepAlive() async {
    try {
      await _playbackKeepAlive.dispose();
    } catch (error, stackTrace) {
      logger('Keep-alive cleanup failed: $error\n$stackTrace', tag: 'AudioHandler', level: InfoLevel.warning);
    }

    for (final subscription in _playbackKeepAliveSubscriptions) {
      await subscription.cancel();
    }

    _playbackKeepAliveSubscriptions.clear();
  }
}
