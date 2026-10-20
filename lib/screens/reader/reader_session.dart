part of 'reader.dart';

extension _ReaderSession on _ReaderState {
  Future<void> _startReadingSession() async {
    if (_readingSessionBinding != null ||
        _openingReadingSessionGeneration != null ||
        audioHandler.currentMediaItem != null) {
      return;
    }

    final settings = ref.read(settingsManagerProvider.notifier);
    if (!settings.getGlobalSetting<bool>(SettingKeys.readerStartSession)) {
      return;
    }

    final itemId = widget.itemId;
    final generation = ++_readingSessionGeneration;
    _openingReadingSessionGeneration = generation;

    try {
      final binding = await _sessionRepository.openReadingSession(itemId, currentTime: _currentAudioTime);
      if (binding == null) {
        return;
      }

      if (!mounted ||
          _isDisposed ||
          generation != _readingSessionGeneration ||
          itemId != widget.itemId ||
          audioHandler.currentMediaItem != null) {
        await _sessionRepository.closeReadingSession(binding);
        return;
      }

      _readingSessionBinding = binding;
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) {
        _resumeReadingSession();
      }
    } catch (error, stackTrace) {
      logger('Failed to open reading session: $error\n$stackTrace', tag: 'ReadingSession', level: InfoLevel.error);
    } finally {
      if (_openingReadingSessionGeneration == generation) {
        _openingReadingSessionGeneration = null;
      }
    }
  }

  Future<void> _syncReadingSession() async {
    final binding = _readingSessionBinding;
    final lastSync = _lastReadingSessionSyncTime;
    if (binding == null || lastSync == null) {
      return;
    }

    final now = DateTime.now();
    final elapsed = now.difference(lastSync).inMilliseconds / Duration.millisecondsPerSecond;
    _lastReadingSessionSyncTime = now;

    await _syncReadingSessionBinding(binding, elapsed, now);
  }

  Future<void> _syncReadingSessionBinding(PlaybackSessionBinding binding, double elapsed, DateTime now) async {
    if (elapsed <= 0) {
      return;
    }

    try {
      await _sessionRepository.syncSessionBinding(
        binding,
        _currentAudioTime,
        elapsed,
        canReachServer: _canReachServer,
        recordedAt: now,
      );
    } catch (error, stackTrace) {
      logger('Failed to sync reading session: $error\n$stackTrace', tag: 'ReadingSession', level: InfoLevel.error);
    }
  }

  Future<void> _closeReadingSession() async {
    _readingSessionGeneration++;
    _openingReadingSessionGeneration = null;
    _readingSessionTimer?.cancel();
    _readingSessionTimer = null;

    final binding = _readingSessionBinding;
    final lastSync = _lastReadingSessionSyncTime;
    final now = DateTime.now();
    final finalSync = binding != null && lastSync != null
        ? _syncReadingSessionBinding(
            binding,
            now.difference(lastSync).inMilliseconds / Duration.millisecondsPerSecond,
            now,
          )
        : Future<void>.value();

    _readingSessionBinding = null;
    _lastReadingSessionSyncTime = null;
    _flushPendingProgressSync();

    await finalSync;

    if (binding != null) {
      await _sessionRepository.closeReadingSession(binding);
    }

    await _progressSyncChain;
  }

  Future<void> _pauseReadingSession() async {
    _readingSessionTimer?.cancel();
    _readingSessionTimer = null;

    final sync = _syncReadingSession();
    _lastReadingSessionSyncTime = null;
    _flushPendingProgressSync();

    await sync;
    await _progressSyncChain;
  }

  void _resumeReadingSession() {
    if (_readingSessionBinding == null || _readingSessionTimer != null) {
      return;
    }

    _lastReadingSessionSyncTime = DateTime.now();
    _readingSessionTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      unawaited(_syncReadingSession());
    });
  }
}
