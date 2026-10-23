part of 'bg_audio_handler.dart';

extension _BGAudioHandlerSpeech on BGAudioHandler {
  Future<void> _prepareReaderSpeech({
    required LibraryItem item,
    required List<Map<String, String>> sentences,
    Uri? cover,
  }) async {
    final timeline = ReaderSpeechTimeline(sentences);

    if (timeline.chunks.isEmpty) {
      throw const FormatException('No readable text found');
    }

    final generation = ++_readerNarrationRequestGeneration;
    final userId = _ref.read(currentUserProvider).value?.id;

    await stop();

    if (_isDisposing || generation + 1 != _readerNarrationRequestGeneration) {
      return;
    }

    _speechItem = item;
    _speechCover = cover;
    _speechProgressUserId = userId;
    _lastSpeechProgressCfi = null;
    _lastSpeechProgressSavedAt = null;
    _installReaderSpeech(timeline, newSession: true);
    _watchReaderSpeechSettings();
    await play();
  }

  void _installReaderSpeech(ReaderSpeechTimeline timeline, {bool newSession = false}) {
    final item = _speechItem!;
    final settings = _ref.read(settingsManagerProvider.notifier);
    final registration = ReaderSpeechEngines.registration(
      settings.getGlobalSetting<String>(SettingKeys.readerTtsEngine),
    );
    final session = ReaderSpeechPlayback(
      timeline: timeline,
      registration: registration,
      language: settings.getGlobalSetting<String>(registration.languageSettingKey),
      voice: settings.getGlobalSetting<String>(registration.voiceSettingKey),
      rate: settings.getGlobalSetting<double>(SettingKeys.readerTtsRate),
      volume: volume,
    );

    _speechPlayback = session;

    if (newSession) {
      _currentMediaItem = InternalMedia(
        libraryId: item.libraryId ?? '',
        itemId: item.id,
        episodeId: null,
        sessionId: 'epub:tts:${DateTime.now().microsecondsSinceEpoch}',
        title: item.title,
        subtitle: 'Read aloud',
        author: item.authorString,
        cover: _speechCover,
        tracks: const [],
        chapters: timeline.chapters.toList(),
        duration: timeline.duration.inMicroseconds / 1e6,
        local: true,
        saf: false,
      );
    }

    _speechPlaybackSubject.add(session);

    ReaderSpeechPlaybackState? previous;

    _speechPlaybackSubscription = session.states.listen((state) {
      if (_isDisposing || !identical(_speechPlayback, session)) {
        return;
      }

      final old = previous;

      previous = state;

      final stoppedPlaying = old?.playerState.playing == true && !state.playerState.playing;
      final completed =
          state.playerState.processingState == ProcessingState.completed &&
          old?.playerState.processingState != ProcessingState.completed;
      unawaited(_saveReaderSpeechProgress(force: stoppedPlaying || completed));

      if (old?.duration != state.duration || old?.isEstimated != state.isEstimated) {
        final media = _currentMediaItem;

        if (media == null) {
          return;
        }

        media.duration = state.duration.inMicroseconds / 1e6;
        media.chapters = timeline.chapters.toList();
        media.subtitle = state.isEstimated ? 'Read aloud · Estimated time' : 'Read aloud';
        mediaItemStream.add(media);
        _refreshChapterNotificationState();
        _updateMediaItemForChapterNotification();
      }

      _refreshPlayerControlState();

      if (old?.playerState.playing != state.playerState.playing ||
          old?.playerState.processingState != state.playerState.processingState ||
          old?.duration != state.duration ||
          (old != null && (old.position - state.position).abs() > const Duration(seconds: 1))) {
        unawaited(_updatePlaybackState());
        TrayManager.update();
      }

      if (state.error != null && state.error != old?.error) {
        logger('Read aloud stopped: ${state.error}', tag: 'AudioHandler', level: InfoLevel.warning);
      }

      if (state.playerState.processingState == ProcessingState.completed &&
          old?.playerState.processingState != ProcessingState.completed) {
        unawaited(_finishReaderSpeech(session));
      }
    });
  }

  Future<void> _finishReaderSpeech(ReaderSpeechPlayback session) async {
    final media = _currentMediaItem;

    if (media == null || !identical(_speechPlayback, session)) {
      return;
    }

    PlayerUtils.disableWakelock(_ref);
    await _ref.read(sleepTimerHandlerProvider.notifier).handleItemCompletion(media);

    if (!identical(_speechPlayback, session)) {
      return;
    }

    if (queueList.isNotEmpty) {
      await stop(clearQueue: false);
      await play();
    }
  }

  void _watchReaderSpeechSettings() {
    for (final subscription in _speechSettingsSubscriptions) {
      unawaited(subscription.cancel());
    }

    _speechSettingsSubscriptions.clear();

    final session = _speechPlayback;

    if (session == null) {
      return;
    }

    final registration = session.registration;
    final keys = {
      SettingKeys.readerTtsEngine,
      SettingKeys.readerTtsRate,
      registration.languageSettingKey,
      registration.voiceSettingKey,
      ...registration.playbackSettingKeys,
    };

    for (final key in keys) {
      _speechSettingsSubscriptions.add(
        _ref
            .read(appDatabaseProvider)
            .watchGlobalSetting(key)
            .map((setting) => setting?.value)
            .distinct()
            .skip(1)
            .listen((_) {
              if (!identical(_speechPlayback, session)) {
                return;
              }

              _speechSettingsTransition = _speechSettingsTransition
                  .catchError((Object _) {})
                  .then((_) async {
                    final current = _speechPlayback;

                    if (current == null || !identical(current, session) || _speechItem == null || _isDisposing) {
                      return;
                    }

                    if (key == SettingKeys.readerTtsRate) {
                      await current.setRate(_ref.read(settingsManagerProvider.notifier).getGlobalSetting<double>(key));
                      await _updatePlaybackState();

                      return;
                    }

                    final cfi = current.state.cfi;
                    final wasPlaying = current.state.playerState.playing;

                    await _speechPlaybackSubscription?.cancel();
                    await current.dispose();

                    if (!identical(_speechPlayback, current) || _speechItem == null || _isDisposing) {
                      return;
                    }

                    final sentences = current.timeline.sentences
                        .map(
                          (sentence) => <String, String>{...sentence, 'isStart': (sentence['cfi'] == cfi).toString()},
                        )
                        .toList();

                    _installReaderSpeech(ReaderSpeechTimeline(sentences));
                    _watchReaderSpeechSettings();

                    if (wasPlaying) {
                      await _speechPlayback!.play();
                    }
                  })
                  .catchError((Object error) {
                    logger(
                      'Could not update read aloud settings: $error',
                      tag: 'AudioHandler',
                      level: InfoLevel.warning,
                    );
                  });
            }),
      );
    }
  }

  Future<void> _disposeReaderSpeech() async {
    final session = _speechPlayback;

    await _saveReaderSpeechProgress(force: true);

    _speechPlayback = null;
    _speechItem = null;
    _speechCover = null;
    _speechProgressUserId = null;
    _lastSpeechProgressCfi = null;
    _lastSpeechProgressSavedAt = null;

    if (!_speechPlaybackSubject.isClosed) {
      _speechPlaybackSubject.add(null);
    }

    await _speechPlaybackSubscription?.cancel();

    _speechPlaybackSubscription = null;

    for (final subscription in _speechSettingsSubscriptions) {
      await subscription.cancel();
    }

    _speechSettingsSubscriptions.clear();
    await session?.dispose();
  }
}
