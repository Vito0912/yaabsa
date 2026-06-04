part of 'bg_audio_handler.dart';

extension _BGAudioHandlerResume on BGAudioHandler {
  Future<void> _applySleepTimerAutoRewindNowInternal() async {
    if (_currentMediaItem == null) {
      return;
    }

    final rewindMinutes = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<int>(SettingKeys.sleepTimerAutoRewindMinutes);

    if (rewindMinutes <= 0) {
      return;
    }

    final rewindBy = Duration(minutes: rewindMinutes);
    final currentPosition = position;
    final targetPosition = _rewindPosition(currentPosition, rewindBy);
    if (targetPosition >= currentPosition) {
      return;
    }

    await _seekInternal(targetPosition);

    final currentPositionSeconds = targetPosition.inMicroseconds / Duration.microsecondsPerSecond;
    final canReachServer = _ref.read(serverReachabilityProvider);

    try {
      await _ref
          .read(sessionRepositoryProvider)
          .syncOpenSession(currentPositionSeconds, 0.3, canReachServer: canReachServer);
    } catch (e) {
      logger('Failed to sync sleep timer rewind before stop: $e', tag: 'AudioHandler', level: InfoLevel.warning);
    }

    logger(
      'Applied sleep timer auto-rewind (${rewindBy.inMinutes} min) before stop at ${targetPosition.inSeconds}s.',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
  }

  Future<bool> _playLastPlayedInternal({
    required bool requireStartupSettingEnabled,
    required bool resumeCurrentIfPaused,
  }) async {
    if (requireStartupSettingEnabled) {
      final autoPlayEnabled = _ref
          .read(settingsManagerProvider.notifier)
          .getGlobalSetting<bool>(SettingKeys.autoPlayLastPlayedOnLaunch);
      if (!autoPlayEnabled) {
        return false;
      }
    }

    if (_currentMediaItem != null) {
      if (resumeCurrentIfPaused && !playerControlState.playing) {
        await play();
        return true;
      }
      return false;
    }

    if (playerControlState.playing || _queueTransitionLoading || queueList.isNotEmpty) {
      return false;
    }

    final lastPlayedItem = await _readLastPlayedQueueItemForActiveUser();
    if (lastPlayedItem == null) {
      return false;
    }

    final progress = await _ref
        .read(mediaProgressProvider.notifier)
        .fetchOrRefreshIndividualProgress(lastPlayedItem.itemId, episodeId: lastPlayedItem.episodeId);

    if (progress?.isFinished ?? false) {
      logger(
        'Last played item ${lastPlayedItem.itemId} is finished. Skipping resume.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return false;
    }

    final resumePosition = Duration(
      microseconds: ((progress?.currentTime ?? 0) * Duration.microsecondsPerSecond).round(),
    );

    await playItemFromPosition(
      itemId: lastPlayedItem.itemId,
      episodeId: lastPlayedItem.episodeId,
      position: resumePosition,
    );

    return true;
  }

  Future<bool> _playLastPlayedIfEnabledOnStartupInternal() {
    return _playLastPlayedInternal(requireStartupSettingEnabled: true, resumeCurrentIfPaused: false);
  }

  Future<void> _restoreLastPlayedMiniPlayerIfEnabledInternal({String? explicitUserId}) async {
    if (_currentMediaItem != null || _queueTransitionLoading) {
      return;
    }

    _setLastPlayedMiniPlayerSnapshot(null);

    final isEnabled = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.showLastPlayedMiniPlayerAlways);
    if (!isEnabled) {
      return;
    }

    final lastPlayedItem = await _readLastPlayedQueueItemForActiveUser(explicitUserId: explicitUserId);
    if (lastPlayedItem == null) {
      return;
    }

    _lastQueueItem = lastPlayedItem;

    final rawSnapshot = await _readLastPlayedMiniPlayerSnapshotRawForActiveUser(explicitUserId: explicitUserId);
    final snapshot = LastPlayedMiniPlayerSnapshot.fromRawJson(rawSnapshot);
    if (snapshot == null) {
      return;
    }

    if (snapshot.matchesQueueItem(lastPlayedItem)) {
      _setLastPlayedMiniPlayerSnapshot(snapshot);
      return;
    }

    _setLastPlayedMiniPlayerSnapshot(
      LastPlayedMiniPlayerSnapshot(
        itemId: lastPlayedItem.itemId,
        episodeId: lastPlayedItem.episodeId,
        title: snapshot.title,
        subtitle: snapshot.subtitle,
        author: snapshot.author,
        cover: snapshot.cover,
      ),
    );
  }

  Future<QueueItem?> _readLastPlayedQueueItemForActiveUser({String? explicitUserId}) async {
    final userId = explicitUserId ?? _activeUserId;
    if (userId == null || userId.isEmpty) {
      return null;
    }

    final db = _ref.read(appDatabaseProvider);
    final rawLastPlayed = (await db.getUserSetting(userId, SettingKeys.lastPlayedQueueItem))?.value;
    return _decodeLastPlayedQueueItem(rawLastPlayed);
  }

  Future<String?> _readLastPlayedMiniPlayerSnapshotRawForActiveUser({String? explicitUserId}) async {
    final userId = explicitUserId ?? _activeUserId;
    if (userId == null || userId.isEmpty) {
      return null;
    }

    final db = _ref.read(appDatabaseProvider);
    return (await db.getUserSetting(userId, SettingKeys.lastPlayedMiniPlayerSnapshot))?.value;
  }

  void _clearSmartRewindPauseMarker() {
    _pausedAt = null;
    _pausedItemId = null;
    _pausedEpisodeId = null;
  }

  void _clearPausedManualSeekMarker() {
    _pausedManualSeekPosition = null;
    _pausedManualSeekItemId = null;
    _pausedManualSeekEpisodeId = null;
  }

  void _markPausedManualSeek(Duration targetPosition) {
    if (_currentMediaItem == null) {
      _clearPausedManualSeekMarker();
      return;
    }

    _pausedManualSeekPosition = targetPosition;
    _pausedManualSeekItemId = _currentMediaItem!.itemId;
    _pausedManualSeekEpisodeId = _currentMediaItem!.episodeId;
  }

  bool _hasPausedManualSeekMarkerForItem({required String itemId, required String? episodeId}) {
    final markedPosition = _pausedManualSeekPosition;
    if (markedPosition == null) {
      return false;
    }

    return _queueItemsMatch(
      leftItemId: _pausedManualSeekItemId ?? '',
      leftEpisodeId: _pausedManualSeekEpisodeId,
      rightItemId: itemId,
      rightEpisodeId: episodeId,
    );
  }

  bool _consumePausedManualSeekMarkerForCurrentItem() {
    final currentMedia = _currentMediaItem;
    if (currentMedia == null) {
      _clearPausedManualSeekMarker();
      return false;
    }

    final markedPosition = _pausedManualSeekPosition;
    final hasMarker = _hasPausedManualSeekMarkerForItem(itemId: currentMedia.itemId, episodeId: currentMedia.episodeId);

    if (hasMarker) {
      logger(
        'Skipping resume progress reconcile after paused manual seek to $markedPosition.',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }

    _clearPausedManualSeekMarker();
    return hasMarker;
  }

  Future<void> _seekWithoutPausedManualMarker(Future<void> Function() action) async {
    _internalSeekGuardDepth += 1;
    try {
      await action();
    } finally {
      _internalSeekGuardDepth -= 1;
    }
  }

  void _recordPausedPlaybackMarker() {
    if (_currentMediaItem == null) {
      _clearSmartRewindPauseMarker();
      return;
    }

    _pausedAt = DateTime.now();
    _pausedItemId = _currentMediaItem!.itemId;
    _pausedEpisodeId = _currentMediaItem!.episodeId;
  }

  bool _hasPauseMarkerForCurrentItem() {
    if (_currentMediaItem == null || _pausedAt == null) {
      return false;
    }

    return _queueItemsMatch(
      leftItemId: _currentMediaItem!.itemId,
      leftEpisodeId: _currentMediaItem!.episodeId,
      rightItemId: _pausedItemId ?? '',
      rightEpisodeId: _pausedEpisodeId,
    );
  }

  Duration _smartRewindDurationForPause(Duration pausedFor) {
    final settingManager = _ref.read(settingsManagerProvider.notifier);

    final shortPauseThresholdSeconds = settingManager.getGlobalSetting<int>(
      SettingKeys.smartRewindShortPauseThresholdSeconds,
    );
    final longPauseThresholdSeconds = settingManager.getGlobalSetting<int>(
      SettingKeys.smartRewindLongPauseThresholdSeconds,
    );

    final shortThreshold = shortPauseThresholdSeconds < 1 ? 1 : shortPauseThresholdSeconds;
    final longThresholdSeed = longPauseThresholdSeconds < 1 ? shortThreshold : longPauseThresholdSeconds;
    final longThreshold = longThresholdSeed < shortThreshold ? shortThreshold : longThresholdSeed;

    final shortRewindSeconds = settingManager.getGlobalSetting<int>(SettingKeys.smartRewindShortRewindSeconds);
    final mediumRewindSeconds = settingManager.getGlobalSetting<int>(SettingKeys.smartRewindMediumRewindSeconds);
    final longRewindSeconds = settingManager.getGlobalSetting<int>(SettingKeys.smartRewindLongRewindSeconds);

    final shortRewind = shortRewindSeconds < 1 ? 1 : shortRewindSeconds;
    final mediumRewind = mediumRewindSeconds < 1 ? shortRewind : mediumRewindSeconds;
    final longRewind = longRewindSeconds < 1 ? mediumRewind : longRewindSeconds;

    final pausedSeconds = pausedFor.inSeconds;
    if (pausedSeconds <= shortThreshold) {
      return Duration(seconds: shortRewind);
    }
    if (pausedSeconds <= longThreshold) {
      return Duration(seconds: mediumRewind);
    }
    return Duration(seconds: longRewind);
  }

  Future<void> _applySmartRewindOnResumeIfNeeded() async {
    if (_currentMediaItem == null || playerControlState.playing) {
      return;
    }

    if (!_hasPauseMarkerForCurrentItem()) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final settingManager = _ref.read(settingsManagerProvider.notifier);
    final smartRewindEnabled = settingManager.getGlobalSetting<bool>(SettingKeys.smartRewindEnabled);
    if (!smartRewindEnabled) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final pausedAt = _pausedAt;
    if (pausedAt == null) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final pausedFor = DateTime.now().difference(pausedAt);
    final rewindBy = _smartRewindDurationForPause(pausedFor);
    final currentPosition = position;

    if (rewindBy <= Duration.zero || currentPosition <= Duration.zero) {
      _clearSmartRewindPauseMarker();
      return;
    }

    final targetPosition = _rewindPosition(currentPosition, rewindBy);

    if (targetPosition < currentPosition) {
      await _seekWithoutPausedManualMarker(() => _seekInternal(targetPosition));
      logger(
        'Applied smart rewind (${rewindBy.inSeconds}s) after pause (${pausedFor.inSeconds}s).',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
    }

    _clearSmartRewindPauseMarker();
  }

  Future<void> _persistLastPlayedQueueItem({required String itemId, String? episodeId}) async {
    final userId = _ref.read(currentUserProvider).value?.id;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final db = _ref.read(appDatabaseProvider);
    final payload = jsonEncode(<String, dynamic>{'itemId': itemId, 'episodeId': episodeId});

    try {
      await db.setUserSetting(userId, SettingKeys.lastPlayedQueueItem, payload);
    } catch (e, s) {
      logger(
        'Failed to persist last played item for user $userId: $e\\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }
  }

  Future<void> _persistLastPlayedMiniPlayerSnapshot(InternalMedia mediaItem) async {
    final userId = _activeUserId;
    if (userId == null || userId.isEmpty) {
      return;
    }

    final db = _ref.read(appDatabaseProvider);
    final snapshot = LastPlayedMiniPlayerSnapshot.fromMedia(mediaItem);

    try {
      await db.setUserSetting(userId, SettingKeys.lastPlayedMiniPlayerSnapshot, snapshot.toRawJson());
    } catch (e, s) {
      logger(
        'Failed to persist mini player snapshot for user $userId: $e\n$s',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
    }
  }

  QueueItem? _decodeLastPlayedQueueItem(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }

      final itemIdValue = decoded['itemId'];
      if (itemIdValue is! String || itemIdValue.trim().isEmpty) {
        return null;
      }

      final episodeIdValue = decoded['episodeId'];
      final episodeId = episodeIdValue is String && episodeIdValue.trim().isNotEmpty ? episodeIdValue.trim() : null;

      return QueueItem(itemId: itemIdValue.trim(), episodeId: episodeId);
    } catch (e) {
      logger('Failed to decode last played item payload: $e', tag: 'AudioHandler', level: InfoLevel.warning);
      return null;
    }
  }
}
