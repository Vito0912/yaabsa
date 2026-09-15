part of 'bg_audio_handler.dart';

class PlaybackPreferenceGuard {
  int _speedRevision = 0;
  int _volumeRevision = 0;
  Future<void> _speedMutationTail = Future<void>.value();
  Future<void> _volumeMutationTail = Future<void>.value();
  Future<void> _speedPersistenceTail = Future<void>.value();
  Future<void> _volumePersistenceTail = Future<void>.value();

  int get speedRevision => _speedRevision;
  int get volumeRevision => _volumeRevision;

  int beginSpeedMutation() => ++_speedRevision;
  int beginVolumeMutation() => ++_volumeRevision;

  bool isSpeedCurrent(int revision) => revision == _speedRevision;
  bool isVolumeCurrent(int revision) => revision == _volumeRevision;

  Future<void> get speedMutationsDrained => _speedMutationTail;
  Future<void> get volumeMutationsDrained => _volumeMutationTail;

  Future<bool> runSpeedMutation(int revision, Future<void> Function() mutation) {
    final previous = _speedMutationTail;
    final operation = () async {
      await previous;
      if (!isSpeedCurrent(revision)) {
        return false;
      }
      await mutation();
      return true;
    }();
    _speedMutationTail = operation.then<void>((_) {}, onError: (_, _) {});
    return operation;
  }

  Future<bool> runVolumeMutation(int revision, Future<void> Function() mutation) {
    final previous = _volumeMutationTail;
    final operation = () async {
      await previous;
      if (!isVolumeCurrent(revision)) {
        return false;
      }
      await mutation();
      return true;
    }();
    _volumeMutationTail = operation.then<void>((_) {}, onError: (_, _) {});
    return operation;
  }

  Future<bool> enqueueSpeedPersistence(int revision, Future<void> Function() persistence) {
    final previous = _speedPersistenceTail;
    final operation = () async {
      await previous;
      if (!isSpeedCurrent(revision)) {
        return false;
      }
      await persistence();
      return true;
    }();
    _speedPersistenceTail = operation.then<void>((_) {}, onError: (_, _) {});
    return operation;
  }

  Future<bool> enqueueVolumePersistence(int revision, Future<void> Function() persistence) {
    final previous = _volumePersistenceTail;
    final operation = () async {
      await previous;
      if (!isVolumeCurrent(revision)) {
        return false;
      }
      await persistence();
      return true;
    }();
    _volumePersistenceTail = operation.then<void>((_) {}, onError: (_, _) {});
    return operation;
  }
}

final Expando<PlaybackPreferenceGuard> _playbackPreferenceGuards = Expando<PlaybackPreferenceGuard>(
  'yaabsa.playbackPreferenceGuard',
);

extension _BGAudioHandlerPreferences on BGAudioHandler {
  PlaybackPreferenceGuard get _playbackPreferenceGuard => _playbackPreferenceGuards[this] ??= PlaybackPreferenceGuard();

  Future<void> _applyVolumeToPlayer(double normalizedVolume) async {
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
    final preferenceRevision = _playbackPreferenceGuard.beginVolumeMutation();

    // Publish the newest user intent immediately. The serialized player
    // mutation below ensures an already-running older restore cannot become
    // the final backend state after this change.
    _volumeSubject.add(normalizedVolume);

    final applied = await _playbackPreferenceGuard.runVolumeMutation(
      preferenceRevision,
      () => _applyVolumeToPlayer(normalizedVolume),
    );
    if (!applied) {
      return;
    }

    unawaited(_persistLastVolume(normalizedVolume, preferenceRevision: preferenceRevision));
  }

  Future<void> _setSpeedInternal(double speed) async {
    if (speed < BGAudioHandler._minPlaybackSpeed || speed > BGAudioHandler._maxPlaybackSpeed) {
      logger('Speed out of bounds: $speed', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }

    final normalizedSpeed = _clampSpeed(speed);
    final preferenceRevision = _playbackPreferenceGuard.beginSpeedMutation();
    final previousSpeed = _player.speed;

    // Capture persistence ownership before the first await. A media/user switch
    // while this mutation is in flight must never make this speed persist onto
    // the newer media context.
    final userId = _activeUserId;
    final itemId = _currentMediaItem?.itemId;
    final persistPerBook = _rememberPlaybackSpeedPerBook;

    final applied = await _playbackPreferenceGuard.runSpeedMutation(
      preferenceRevision,
      () => _player.setSpeed(normalizedSpeed),
    );
    if (!applied) {
      return;
    }

    await _persistPlaybackSpeedSnapshot(
      normalizedSpeed,
      preferenceRevision: preferenceRevision,
      userId: userId,
      itemId: itemId,
      persistPerBook: persistPerBook,
    );

    if (!_playbackPreferenceGuard.isSpeedCurrent(preferenceRevision)) {
      return;
    }

    await _updatePlaybackState();
    if ((previousSpeed - normalizedSpeed).abs() > BGAudioHandler._playbackPreferenceEpsilon) {
      unawaited(
        PlayerHistoryHandler.addPlayerHistory(
          PlayerHistoryType.speedChanged,
          details: <String, Object?>{'previousSpeed': previousSpeed, 'speed': normalizedSpeed},
        ),
      );
    }
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

  Future<void> _persistPlaybackSpeedSnapshot(
    double speed, {
    required int preferenceRevision,
    required String? userId,
    required String? itemId,
    required bool persistPerBook,
  }) async {
    final normalizedSpeed = _clampSpeed(speed);

    try {
      await _playbackPreferenceGuard.enqueueSpeedPersistence(preferenceRevision, () async {
        final settingsManager = _ref.read(settingsManagerProvider.notifier);
        await settingsManager.setGlobalSetting<double>(SettingKeys.playbackSpeed, normalizedSpeed);

        if (userId != null) {
          await settingsManager.setUserSetting<double>(userId, SettingKeys.playbackSpeed, normalizedSpeed);
        }

        if (persistPerBook && userId != null && itemId != null) {
          await _ref.read(appDatabaseProvider).setBookPlaybackSpeed(userId, itemId, normalizedSpeed);
        }
      });
    } catch (e, s) {
      logger('Failed to persist playback speed snapshot: $e\\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<void> _persistLastVolume(double volume, {required int preferenceRevision}) async {
    final normalizedVolume = _clampVolume(volume);
    try {
      await _playbackPreferenceGuard.enqueueVolumePersistence(preferenceRevision, () async {
        await _ref
            .read(settingsManagerProvider.notifier)
            .setGlobalSetting<double>(SettingKeys.volume, normalizedVolume);
      });
    } catch (e, s) {
      logger('Failed to persist last volume: $e\\n$s', tag: 'AudioHandler', level: InfoLevel.warning);
    }
  }

  Future<double> _resolvePreferredPlaybackSpeed({
    bool seedPerBookSpeedWhenMissing = false,
    required int expectedPreferenceRevision,
  }) async {
    final fallbackSpeed = _readLastPlaybackSpeedSetting();

    if (!_rememberPlaybackSpeedPerBook) {
      return fallbackSpeed;
    }

    final mediaItem = _currentMediaItem;
    final userId = _activeUserId;
    if (mediaItem == null || userId == null) {
      return fallbackSpeed;
    }
    final itemId = mediaItem.itemId;

    try {
      final persistedBookSpeed = await _ref.read(appDatabaseProvider).getBookPlaybackSpeed(userId, itemId);

      if (!_playbackPreferenceGuard.isSpeedCurrent(expectedPreferenceRevision)) {
        return _player.speed;
      }
      final currentMediaItem = _currentMediaItem;
      if (currentMediaItem == null || currentMediaItem.itemId != itemId || _activeUserId != userId) {
        return _player.speed;
      }

      if (persistedBookSpeed != null) {
        return _clampSpeed(persistedBookSpeed);
      }

      if (seedPerBookSpeedWhenMissing) {
        await _playbackPreferenceGuard.enqueueSpeedPersistence(expectedPreferenceRevision, () async {
          final stillCurrentMediaItem = _currentMediaItem;
          if (stillCurrentMediaItem == null || stillCurrentMediaItem.itemId != itemId || _activeUserId != userId) {
            return;
          }
          await _ref.read(appDatabaseProvider).setBookPlaybackSpeed(userId, itemId, fallbackSpeed);
        });
      }
    } catch (e, s) {
      logger(
        'Failed to resolve per-book playback speed for user=$userId item=$itemId: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }

    return fallbackSpeed;
  }

  Future<void> _restoreSavedVolume({required int expectedPreferenceRevision}) async {
    final targetVolume = _readLastVolumeSetting();
    await _playbackPreferenceGuard.runVolumeMutation(expectedPreferenceRevision, () async {
      if (!_playbackPreferenceGuard.isVolumeCurrent(expectedPreferenceRevision)) {
        return;
      }
      _volumeSubject.add(targetVolume);
      await _applyVolumeToPlayer(targetVolume);
    });
  }

  Future<void> _applyPreferredPlaybackSpeed({
    bool seedPerBookSpeedWhenMissing = false,
    PlayerMutationLease? mutationLease,
    bool Function()? isStillCurrent,
    int? expectedPreferenceRevision,
  }) async {
    final preferenceRevision = expectedPreferenceRevision ?? _playbackPreferenceGuard.speedRevision;

    bool ownsPlaybackMutation() =>
        (mutationLease == null || _playerMutationBarrier.isCurrent(mutationLease)) &&
        (isStillCurrent == null || isStillCurrent());

    if (!ownsPlaybackMutation()) {
      throw PlayerInterruptedException('Playback preference update superseded before resolving saved speed');
    }

    final targetSpeed = await _resolvePreferredPlaybackSpeed(
      seedPerBookSpeedWhenMissing: seedPerBookSpeedWhenMissing,
      expectedPreferenceRevision: preferenceRevision,
    );

    if (!ownsPlaybackMutation()) {
      throw PlayerInterruptedException('Playback preference update superseded while resolving saved speed');
    }

    // A manual speed change is preference ownership, not playback ownership.
    // It must fence the stale saved-speed application without aborting the
    // source/playback command that triggered this restore.
    if (!_playbackPreferenceGuard.isSpeedCurrent(preferenceRevision)) {
      await _playbackPreferenceGuard.speedMutationsDrained;
      return;
    }

    if ((_player.speed - targetSpeed).abs() <= BGAudioHandler._playbackPreferenceEpsilon) {
      return;
    }

    final applied = await _playbackPreferenceGuard.runSpeedMutation(preferenceRevision, () async {
      if (!ownsPlaybackMutation()) {
        throw PlayerInterruptedException('Playback preference update superseded before player mutation');
      }

      if (mutationLease == null) {
        await _player.setSpeed(targetSpeed);
        return;
      }

      final playerMutationApplied = await _playerMutationBarrier.run<bool>(mutationLease, () async {
        if (!ownsPlaybackMutation()) {
          throw PlayerInterruptedException('Playback preference update superseded before player mutation');
        }
        await _player.setSpeed(targetSpeed);
        return true;
      });
      if (playerMutationApplied != true) {
        throw PlayerInterruptedException('Playback preference update superseded while applying saved speed');
      }
    });

    if (!ownsPlaybackMutation()) {
      throw PlayerInterruptedException('Playback preference update superseded after applying saved speed');
    }

    if (!applied || !_playbackPreferenceGuard.isSpeedCurrent(preferenceRevision)) {
      await _playbackPreferenceGuard.speedMutationsDrained;
      return;
    }

    await _updatePlaybackState();
  }

  Future<void> _restorePlaybackPreferencesOnStartup() async {
    final volumePreferenceRevision = _playbackPreferenceGuard.volumeRevision;
    final speedPreferenceRevision = _playbackPreferenceGuard.speedRevision;

    try {
      await _restoreSavedVolume(expectedPreferenceRevision: volumePreferenceRevision);
    } catch (e, s) {
      logger(
        'Failed to restore saved playback volume on startup: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }

    try {
      await _applyPreferredPlaybackSpeed(expectedPreferenceRevision: speedPreferenceRevision);
    } catch (e, s) {
      logger(
        'Failed to restore saved playback speed on startup: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }
  }
}
