part of 'bg_audio_handler.dart';

extension _BGAudioHandlerPreferences on BGAudioHandler {
  Future<void> _applyVolume(double volume) async {
    final normalizedVolume = _clampVolume(volume);
    _volumeSubject.add(normalizedVolume);
    final loudnessEnhancer = _loudnessEnhancer;
    if (loudnessEnhancer != null && BGAudioHandler.supportsVolumeBoostPlatform && Platform.isAndroid) {
      final baseVolume = normalizedVolume.clamp(0.0, 1.0).toDouble();
      await _player.setVolume(baseVolume);
      if (normalizedVolume > 1.0 && volumeBoostAvailable) {
        final targetGain = 20 * math.log(normalizedVolume) / math.ln10;
        await loudnessEnhancer.setTargetGain(targetGain);
        await loudnessEnhancer.setEnabled(true);
      } else {
        await loudnessEnhancer.setEnabled(false);
      }
      return;
    }

    await _player.setVolume(normalizedVolume);
  }

  Future<void> _setVolumeInternal(double volume) async {
    if (volume < 0 || volume > maxVolume) {
      logger('Volume out of bounds: $volume', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }
    final normalizedVolume = _clampVolume(volume);
    await _applyVolume(normalizedVolume);
    unawaited(_persistLastVolume(normalizedVolume));
    return Future.value();
  }

  Future<void> _setSpeedInternal(double speed) async {
    if (speed < BGAudioHandler._minPlaybackSpeed || speed > BGAudioHandler._maxPlaybackSpeed) {
      logger('Speed out of bounds: $speed', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }

    final normalizedSpeed = _clampSpeed(speed);
    final previousSpeed = _player.speed;
    await _player.setSpeed(normalizedSpeed);
    await _persistLastPlaybackSpeed(normalizedSpeed);
    await _persistCurrentBookPlaybackSpeed(normalizedSpeed);
    await _updatePlaybackState();
    if ((previousSpeed - normalizedSpeed).abs() > BGAudioHandler._playbackPreferenceEpsilon) {
      unawaited(
        PlayerHistoryHandler.addPlayerHistory(
          PlayerHistoryType.speedChanged,
          details: <String, Object?>{'previousSpeed': previousSpeed, 'speed': normalizedSpeed},
        ),
      );
    }
    return Future.value();
  }

  String? get _activeUserId {
    final userId = _ref.read(currentUserProvider).value?.id;
    if (userId == null || userId.isEmpty) {
      return null;
    }
    return userId;
  }

  double _clampVolume(double volume) {
    return volume.clamp(0.0, maxVolume).toDouble();
  }

  double _clampSpeed(double speed) {
    return speed.clamp(BGAudioHandler._minPlaybackSpeed, BGAudioHandler._maxPlaybackSpeed).toDouble();
  }

  bool get _rememberPlaybackSpeedPerBook {
    return _ref.read(settingsManagerProvider.notifier).getGlobalSetting<bool>(SettingKeys.playbackSpeedPerBook);
  }

  double _readLastPlaybackSpeedSetting() {
    final settingsManager = _ref.read(settingsManagerProvider.notifier);
    final globalSpeed = _clampSpeed(settingsManager.getGlobalSetting<double>(SettingKeys.playbackSpeed));
    final userId = _activeUserId;
    if (userId == null) {
      return globalSpeed;
    }

    return _clampSpeed(
      settingsManager.getUserSetting<double>(userId, SettingKeys.playbackSpeed, defaultValue: globalSpeed),
    );
  }

  double _readLastVolumeSetting() {
    final settingsManager = _ref.read(settingsManagerProvider.notifier);
    return _clampVolume(settingsManager.getGlobalSetting<double>(SettingKeys.volume));
  }

  Future<void> _persistLastPlaybackSpeed(double speed) async {
    final normalizedSpeed = _clampSpeed(speed);
    final settingsManager = _ref.read(settingsManagerProvider.notifier);
    try {
      await settingsManager.setGlobalSetting<double>(SettingKeys.playbackSpeed, normalizedSpeed);

      final userId = _activeUserId;
      if (userId != null) {
        await settingsManager.setUserSetting<double>(userId, SettingKeys.playbackSpeed, normalizedSpeed);
      }
    } catch (e, s) {
      logger('Failed to persist last playback speed: $e\\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _persistLastVolume(double volume) async {
    final normalizedVolume = _clampVolume(volume);
    try {
      await _ref.read(settingsManagerProvider.notifier).setGlobalSetting<double>(SettingKeys.volume, normalizedVolume);
    } catch (e, s) {
      logger('Failed to persist last volume: $e\\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _persistCurrentBookPlaybackSpeed(double speed) async {
    if (!_rememberPlaybackSpeedPerBook) {
      return;
    }

    final mediaItem = _currentMediaItem;
    final userId = _activeUserId;
    if (mediaItem == null || userId == null) {
      return;
    }

    final normalizedSpeed = _clampSpeed(speed);
    try {
      await _ref.read(appDatabaseProvider).setBookPlaybackSpeed(userId, mediaItem.itemId, normalizedSpeed);
    } catch (e, s) {
      logger(
        'Failed to persist per-book playback speed for user=$userId item=${mediaItem.itemId}: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }
  }

  Future<double> _resolvePreferredPlaybackSpeed({bool seedPerBookSpeedWhenMissing = false}) async {
    final fallbackSpeed = _readLastPlaybackSpeedSetting();

    if (!_rememberPlaybackSpeedPerBook) {
      return fallbackSpeed;
    }

    final mediaItem = _currentMediaItem;
    final userId = _activeUserId;
    if (mediaItem == null || userId == null) {
      return fallbackSpeed;
    }

    try {
      final persistedBookSpeed = await _ref.read(appDatabaseProvider).getBookPlaybackSpeed(userId, mediaItem.itemId);
      if (persistedBookSpeed != null) {
        return _clampSpeed(persistedBookSpeed);
      }

      if (seedPerBookSpeedWhenMissing) {
        await _ref.read(appDatabaseProvider).setBookPlaybackSpeed(userId, mediaItem.itemId, fallbackSpeed);
      }
    } catch (e, s) {
      logger(
        'Failed to resolve per-book playback speed for user=$userId item=${mediaItem.itemId}: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }

    return fallbackSpeed;
  }

  Future<void> _restoreSavedVolume() async {
    final targetVolume = _readLastVolumeSetting();
    await _applyVolume(targetVolume);
  }

  Future<void> _applyPreferredPlaybackSpeed({bool seedPerBookSpeedWhenMissing = false}) async {
    final targetSpeed = await _resolvePreferredPlaybackSpeed(seedPerBookSpeedWhenMissing: seedPerBookSpeedWhenMissing);

    if ((_player.speed - targetSpeed).abs() <= BGAudioHandler._playbackPreferenceEpsilon) {
      return;
    }

    await _player.setSpeed(targetSpeed);
    await _updatePlaybackState();
  }

  Future<void> _restorePlaybackPreferencesOnStartup() async {
    try {
      await _restoreSavedVolume();
      await _applyPreferredPlaybackSpeed();
    } catch (e, s) {
      logger(
        'Failed to restore playback preferences on startup: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }
  }
}
