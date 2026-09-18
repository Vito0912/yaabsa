part of 'bg_audio_handler.dart';

extension _BGAudioHandlerAudioSession on BGAudioHandler {
  void _initializeAudioSession() {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) return;

    final mode = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<String>(SettingKeys.audioAnnouncementMode);

    _queueAudioSessionConfiguration(mode);

    _audioAnnouncementModeSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.audioAnnouncementMode)
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen(_queueAudioSessionConfiguration);
  }

  void _queueAudioSessionConfiguration(String? mode) {
    _audioSessionConfigurationFuture = _audioSessionConfigurationFuture.then((_) async {
      if (_isDisposing) return;
      final effectiveMode = mode ?? defaultSettings[SettingKeys.audioAnnouncementMode] as String;
      final pauseForAnnouncements = effectiveMode != 'duck';

      if (_configuredPauseForAnnouncements == pauseForAnnouncements) return;
      if (Platform.isAndroid && !pauseForAnnouncements && _configuredPauseForAnnouncements == null) return;

      try {
        final session = await AudioSession.instance;

        if (_isDisposing) return;

        final configuration = pauseForAnnouncements
            ? const AudioSessionConfiguration.speech()
            : const AudioSessionConfiguration.music();

        await session.configure(configuration);

        _configuredPauseForAnnouncements = pauseForAnnouncements;

        if (!_isDisposing && Platform.isAndroid && _player.playing && !isCastControlActive) {
          if (!await session.setActive(true)) {
            await _player.pause();
          }
        }
      } catch (error, stackTrace) {
        logger(
          'Failed to configure audio announcement mode: $error\n$stackTrace',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
      }
    });
  }
}
