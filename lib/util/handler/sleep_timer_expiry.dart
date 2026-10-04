part of 'sleep_timer_handler.dart';

class _SleepTimerExpiryContext {
  const _SleepTimerExpiryContext({
    required this.action,
    required this.revision,
    required this.mediaKey,
    required this.owner,
    required this.marker,
    required this.historyDetails,
  });

  final SleepTimerExpireAction action;
  final int revision;
  final String? mediaKey;
  final SleepTimerPlaybackOwner? owner;
  final SleepTimerMarker? marker;
  final Map<String, Object?> historyDetails;
}

extension _SleepTimerExpiry on SleepTimerHandler {
  Future<void> _onTimerExpired() {
    if (_expiry != null) return _expiry!;
    if (!_data.isActive) return Future.value();

    final owner = _captureChapterExpiryOwner();
    if (_data.isChapterTimer && owner == null) {
      stop(recordHistory: false);
      return Future.value();
    }

    final action = SleepTimerExpireAction.fromSettingValue(
      _settings.getGlobalSetting<String>(SettingKeys.sleepTimerExpireAction),
    );
    final context = _SleepTimerExpiryContext(
      action: action,
      revision: ++_runRevision,
      mediaKey: _mediaKey(audioHandler.currentMediaItem),
      owner: owner,
      marker: _completeMarkerAtCurrentPosition(),
      historyDetails: <String, Object?>{
        'action': action.name,
        'mode': _data.mode.name,
        if (_data.isChapterTimer) 'chapters': _data.configuredChapters,
      },
    );

    _clearActiveTimerForExpiry(context);
    if (owner == null) _recordExpiry(context);

    final expiry = Future<void>.microtask(() => _runExpiry(context));
    _expiry = expiry;
    unawaited(expiry.whenComplete(() => _finishExpiry(context)));
    return expiry;
  }

  SleepTimerPlaybackOwner? _captureChapterExpiryOwner() {
    if (!_data.isChapterTimer) return null;

    final media = audioHandler.currentMediaItem;
    final binding = _chapterBinding;
    if (media == null || binding == null) return null;

    final owner = SleepTimerPlaybackOwner(
      media: media,
      binding: binding,
      navigationGeneration: _chapterNavigationGeneration,
      playbackGeneration: audioHandler.sleepTimerPlaybackGeneration,
    );
    final isCurrent = audioHandler.isSleepTimerOwnerCurrent(
      media: owner.media,
      binding: owner.binding,
      navigationGeneration: owner.navigationGeneration,
      playbackGeneration: owner.playbackGeneration,
    );
    return isCurrent ? owner : null;
  }

  void _clearActiveTimerForExpiry(_SleepTimerExpiryContext context) {
    _completedChapterMediaKey = _chapterMediaKey;
    _chapterTimer = null;
    _chapterMediaKey = null;
    _chapterBinding = null;

    _timer?.cancel();
    _timer = null;
    _countdownStartTime = null;
    _countdownRunDuration = null;
    _pauseTriggeredByPlayback = false;
    _cancelMarkerVisibilityTimers();

    _data = SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive, marker: context.marker);
  }

  Future<void> _runExpiry(_SleepTimerExpiryContext context) async {
    final completed = await _executeExpiry(context);
    if (context.owner == null) return;

    if (completed) {
      _recordExpiry(context);
    } else if (!_disposed && context.revision == _runRevision) {
      _completedChapterMediaKey = null;
      _data = const SleepTimerData(remainingTime: Duration.zero, state: SleepTimerState.inactive);
    }
  }

  Future<bool> _executeExpiry(_SleepTimerExpiryContext context) async {
    try {
      if (!_isExpiryCurrent(context)) return false;

      final owner = context.owner;
      if (owner != null) {
        return await _executeChapterExpiry(context, owner);
      }
      return await _executeDurationExpiry(context);
    } catch (e) {
      logger('Failed to run sleep timer expiry action: $e', tag: 'SleepTimer', level: InfoLevel.warning);
      return false;
    } finally {
      await _restoreFadeVolumeIfNeeded();
    }
  }

  Future<bool> _executeChapterExpiry(_SleepTimerExpiryContext context, SleepTimerPlaybackOwner owner) async {
    final paused = await audioHandler.pauseForSleepTimer(owner);
    if (!paused || !_isExpiryCurrent(context)) return false;

    final rewoundPosition = await audioHandler.rewindForSleepTimer(owner);
    if (rewoundPosition == null || !_isExpiryCurrent(context)) return false;

    final stillCurrent = await audioHandler.flushForSleepTimer(
      owner,
      position: rewoundPosition,
      closing: context.action == SleepTimerExpireAction.stop,
    );
    if (!stillCurrent || !_isExpiryCurrent(context)) return false;

    if (context.action == SleepTimerExpireAction.stop) {
      return audioHandler.stopForSleepTimer(owner, position: rewoundPosition);
    }
    return true;
  }

  Future<bool> _executeDurationExpiry(_SleepTimerExpiryContext context) async {
    await audioHandler.pause();
    if (!_isExpiryCurrent(context)) return false;

    await audioHandler.applySleepTimerAutoRewindNow();
    if (!_isExpiryCurrent(context)) return false;

    if (context.action == SleepTimerExpireAction.stop) {
      await audioHandler.stop();
    }
    return true;
  }

  bool _isExpiryCurrent(_SleepTimerExpiryContext context) {
    return !_disposed &&
        context.revision == _runRevision &&
        context.mediaKey == _mediaKey(audioHandler.currentMediaItem);
  }

  void _recordExpiry(_SleepTimerExpiryContext context) {
    _showMarker();
    unawaited(_persistMarker(context.marker));
    unawaited(recordHistory(PlayerHistoryType.sleepTimerExpired, details: context.historyDetails));
  }

  void _finishExpiry(_SleepTimerExpiryContext context) {
    _expiry = null;
    if (!_disposed && _autoStartPending && context.mediaKey != _mediaKey(audioHandler.currentMediaItem)) {
      _tryAutoRestartSleepTimerOnPlaybackStart();
    }
  }
}
