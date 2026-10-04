part of 'bg_audio_handler.dart';

extension _BGAudioHandlerLiveUpdates on BGAudioHandler {
  Future<void> _initializeLiveUpdates() async {
    if (_isDisposing || kIsWeb || !Platform.isAndroid) return;
    _liveUpdatesSettingSubscription = _ref
        .read(appDatabaseProvider)
        .watchGlobalSetting(SettingKeys.androidLiveUpdates)
        .map((setting) => setting?.value.trim())
        .distinct()
        .listen((value) {
          if (_isDisposing) return;
          _liveUpdateMode = AndroidLiveUpdateMode.fromSettingValue(value);
          _listenToLiveUpdateSleepTimer();
          _updateLiveUpdateNotification();
        });
  }

  void _listenToLiveUpdateSleepTimer() {
    if (_liveUpdateMode != AndroidLiveUpdateMode.sleepTimer) {
      _liveUpdatesSleepTimerSubscription?.close();
      _liveUpdatesSleepTimerSubscription = null;
      return;
    }
    _liveUpdatesSleepTimerSubscription ??= _ref.listen<SleepTimerData>(sleepTimerHandlerProvider, (previous, next) {
      if (_isDisposing) return;
      if (previous == null ||
          previous.state != next.state ||
          previous.mode != next.mode ||
          (next.isChapterTimer && previous.remainingTime != next.remainingTime) ||
          previous.totalDuration != next.totalDuration ||
          next.remainingTime > previous.remainingTime) {
        scheduleMicrotask(() {
          if (!_isDisposing && _liveUpdateMode == AndroidLiveUpdateMode.sleepTimer) {
            _updateLiveUpdateNotification();
          }
        });
      }
    });
  }

  void _updateLiveUpdateNotification() {
    if (_isDisposing || kIsWeb || !Platform.isAndroid) return;
    final mode = _liveUpdateMode;
    if (mode == AndroidLiveUpdateMode.off) {
      if (_liveUpdatesActive) {
        _liveUpdatesActive = false;
        unawaited(AndroidLiveUpdates.clear());
      }
      return;
    }
    _liveUpdatesActive = true;
    final item = _currentMediaItem;
    final state = playbackState.value;
    final bookPosition = position;
    final timelinePosition = _chapterNotificationEnabled
        ? _clampDuration(bookPosition - _chapterNotificationOffset, Duration.zero, _chapterNotificationDuration)
        : bookPosition;
    final duration = _chapterNotificationEnabled ? _chapterNotificationDuration : item?.totalDuration;
    final sleepTimer = mode == AndroidLiveUpdateMode.sleepTimer ? _ref.read(sleepTimerHandlerProvider) : null;
    unawaited(
      AndroidLiveUpdates.update({
        'mode': mode.name,
        'mediaId': item == null ? null : '${item.itemId}:${item.episodeId ?? ''}',
        'title': mediaItem.value?.title ?? item?.title ?? '',
        'playing': state.playing && state.processingState == AudioProcessingState.ready && item != null,
        'positionMs': timelinePosition.inMilliseconds,
        'durationMs': duration?.inMilliseconds ?? 0,
        'speed': state.speed,
        if (sleepTimer != null) ...{
          'sleepTimerRunning': sleepTimer.isRunning,
          'sleepTimerRemainingMs': _ref.read(sleepTimerHandlerProvider.notifier).remainingTime.inMilliseconds,
          'sleepTimerTotalMs': sleepTimer.totalDuration?.inMilliseconds ?? 0,
        },
      }),
    );
  }
}
