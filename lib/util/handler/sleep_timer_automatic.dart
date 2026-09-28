part of 'sleep_timer_handler.dart';

extension SleepTimerAutomatic on SleepTimerHandler {
  SleepTimerAutoConfig _autoConfig() {
    final settings = _settings;
    final modeSetting = settings.getGlobalSetting<String>(SettingKeys.sleepTimerAutoMode);
    final configuredMinutes = settings.getGlobalSetting<int>(SettingKeys.sleepTimerAutoMinutes);
    final remembered = settings.getGlobalSetting<int>(SettingKeys.sleepTimerLastDurationMinutes);
    final minutes = configuredMinutes > 0 ? configuredMinutes : (remembered > 0 ? remembered : 30);
    final configuredChapters = settings.getGlobalSetting<int>(SettingKeys.sleepTimerAutoChapters);

    return SleepTimerAutoConfig(
      enabled: settings.getGlobalSetting<bool>(SettingKeys.sleepTimerAutoRestartEnabled),
      mode: modeSetting == SleepTimerMode.chapters.name ? SleepTimerMode.chapters : SleepTimerMode.minutes,
      minutes: minutes,
      chapters: configuredChapters > 0 ? configuredChapters : 1,
      useTimeRange: settings.getGlobalSetting<bool>(SettingKeys.sleepTimerAutoRestartUseTimeRange),
      startMinutes: settings.getGlobalSetting<int>(SettingKeys.sleepTimerAutoRestartRangeStartMinutes),
      endMinutes: settings.getGlobalSetting<int>(SettingKeys.sleepTimerAutoRestartRangeEndMinutes),
    );
  }

  Future<void> initializeAutoMinutes() async {
    final settings = _settings;
    if (settings.getGlobalSetting<int>(SettingKeys.sleepTimerAutoMinutes) > 0) return;

    try {
      await settings.setGlobalSetting<int>(SettingKeys.sleepTimerAutoMinutes, _autoConfig().minutes);
    } catch (e) {
      logger('Failed to initialize automatic sleep timer duration: $e', tag: 'SleepTimer', level: InfoLevel.warning);
    }
  }

  void _tryAutoRestartSleepTimerOnPlaybackStart() {
    if (_disposed || _expiry != null || !isAudioHandlerInitialized || audioHandler.currentMediaItem == null) return;

    final playerState = audioHandler.playerControlState;
    if (!playerState.playing || playerState.processingState != ProcessingState.ready) {
      return;
    }

    _autoStartPending = false;
    final config = _autoConfig();
    if (!config.shouldStart(
      now: currentTime,
      active: _data.isActive,
      playing: playerState.playing && playerState.processingState == ProcessingState.ready,
      hasChapters: _chapterEndings().isNotEmpty,
    )) {
      return;
    }

    if (config.mode == SleepTimerMode.chapters) {
      startChapters(config.chapters, automatic: true);
    } else {
      start(Duration(minutes: config.minutes), automatic: true);
    }
  }
}
