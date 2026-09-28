part of 'sleep_timer_handler.dart';

extension SleepTimerChapters on SleepTimerHandler {
  bool get canExtendChapter {
    final timer = _chapterTimer;
    return timer != null && _data.isActive && timer.targetIndex < timer.endings.length - 1;
  }

  String? _mediaKey(InternalMedia? media) =>
      media == null ? null : '${media.itemId}:${media.episodeId ?? ''}:${media.sessionId}';

  List<Duration> _chapterEndings() {
    final media = audioHandler.currentMediaItem;
    final chapters = media?.chapters;
    if (media == null || chapters == null) return const [];

    final itemDurationSeconds = media.totalDuration.inMicroseconds / Duration.microsecondsPerSecond;
    return chapters
        .where(
          (chapter) =>
              chapter.start.isFinite &&
              chapter.end.isFinite &&
              chapter.start >= 0 &&
              chapter.end > chapter.start &&
              chapter.end <= itemDurationSeconds,
        )
        .map((chapter) => Duration(microseconds: (chapter.end * Duration.microsecondsPerSecond).round()))
        .toSet()
        .toList()
      ..sort();
  }

  int _chapterIndexAt(InternalMedia media, List<Duration> endings, Duration position) {
    final chapter = media.getChapterForDuration(position);
    if (chapter == null || !chapter.start.isFinite || !chapter.end.isFinite) return -1;

    final end = Duration(microseconds: (chapter.end * Duration.microsecondsPerSecond).round());
    final index = endings.indexOf(end);
    if (index < 0 || position >= end) return -1;
    return index;
  }

  bool _hasCurrentChapterSession(InternalMedia media, PlaybackSessionBinding binding) {
    return _chapterMediaKey == _mediaKey(media) && _sessionRepository.isCurrentSessionBinding(binding);
  }

  void _publishChapterTimer(ChapterSleepTimer timer) {
    _data = _data.copyWith(
      remainingTime: timer.remainingTime(audioHandler.effectivePlaybackSpeed),
      remainingChapters: timer.remainingChapters,
      targetChapterIndex: timer.targetIndex,
    );
  }

  bool startChapters(int chapters, {bool automatic = false}) {
    if (_expiry != null || chapters < 1 || !isAudioHandlerInitialized || audioHandler.isCastControlActive) {
      return false;
    }
    final media = audioHandler.currentMediaItem;
    final binding = _sessionRepository.currentSessionBinding;
    if (media == null || binding == null || binding.sessionId != media.sessionId) return false;

    final endings = _chapterEndings();
    if (endings.isEmpty) return false;
    final currentIndex = _chapterIndexAt(media, endings, audioHandler.position);
    if (currentIndex < 0) return false;

    if (_data.isActive) stop(recordHistory: false);
    _runRevision++;
    _completedChapterMediaKey = null;
    unawaited(initializeAutoMinutes());
    unawaited(_restoreFadeVolumeIfNeeded());
    _chapterMediaKey = _mediaKey(audioHandler.currentMediaItem);
    _chapterBinding = binding;
    _chapterNavigationGeneration = audioHandler.sleepTimerNavigationGeneration;

    final timer = ChapterSleepTimer(endings: endings, position: audioHandler.position, chapters: chapters);
    _chapterTimer = timer;
    final playing = audioHandler.playerControlState.playing;
    _pauseTriggeredByPlayback = !playing;
    _cancelMarkerVisibilityTimers();
    final marker = _createMarker();

    _data = SleepTimerData(
      mode: SleepTimerMode.chapters,
      configuredChapters: chapters,
      remainingChapters: timer.remainingChapters,
      targetChapterIndex: timer.targetIndex,
      remainingTime: timer.remainingTime(audioHandler.effectivePlaybackSpeed),
      state: playing ? SleepTimerState.running : SleepTimerState.paused,
      marker: marker,
      showMarkerPin: false,
      showMarkerRange: false,
    );
    unawaited(_persistMarker(marker));
    unawaited(
      recordHistory(
        automatic ? PlayerHistoryType.sleepTimerAutoStarted : PlayerHistoryType.sleepTimerStarted,
        details: <String, Object?>{'mode': SleepTimerMode.chapters.name, 'chapters': chapters},
      ),
    );
    return true;
  }

  void _updateChapterPosition(Duration position) {
    if (_disposed || !_data.isRunning || _chapterTimer == null) return;

    final media = audioHandler.currentMediaItem;
    final binding = _chapterBinding;
    if (media == null ||
        binding == null ||
        !_hasCurrentChapterSession(media, binding) ||
        !audioHandler.isSleepTimerOwnerCurrent(
          media: media,
          binding: binding,
          navigationGeneration: _chapterNavigationGeneration,
        )) {
      stop(recordHistory: false);
      return;
    }

    final timer = _chapterTimer!;
    final positionChapterIndex = _chapterIndexAt(media, timer.endings, position);
    if ((position < timer.target && positionChapterIndex < 0) ||
        (positionChapterIndex >= 0 && positionChapterIndex < timer.currentIndex)) {
      stop(recordHistory: false);
      return;
    }
    timer.update(position);
    if (timer.expired) {
      unawaited(_onTimerExpired());
      return;
    }

    final remaining = timer.remainingTime(audioHandler.effectivePlaybackSpeed);
    _publishChapterTimer(timer);
    _applyFadeOutIfNeeded(remaining);
  }

  void handlePlaybackNavigation(Duration position, {required int navigationGeneration}) {
    final timer = _chapterTimer;
    if (timer == null || !_data.isActive || _expiry != null) return;
    if (navigationGeneration != audioHandler.sleepTimerNavigationGeneration) return;

    final media = audioHandler.currentMediaItem;
    final binding = _chapterBinding;
    if (media == null ||
        binding == null ||
        !_hasCurrentChapterSession(media, binding) ||
        _chapterIndexAt(media, timer.endings, position) < 0) {
      stop(recordHistory: false);
      return;
    }
    _chapterNavigationGeneration = navigationGeneration;
    timer.rebase(position);
    unawaited(_restoreFadeVolumeIfNeeded());
    _publishChapterTimer(timer);
  }

  void handleEndOfItemNavigation(int navigationGeneration) {
    if (_chapterTimer == null || !_data.isRunning) return;

    final media = audioHandler.currentMediaItem;
    final binding = _chapterBinding;
    if (media == null ||
        binding == null ||
        !_hasCurrentChapterSession(media, binding) ||
        navigationGeneration != audioHandler.sleepTimerNavigationGeneration) {
      return;
    }
    _chapterNavigationGeneration = navigationGeneration;
  }

  void extendChapter() {
    final timer = _chapterTimer;
    if (!_data.isActive || timer == null) return;
    if (_data.isRunning) {
      _updateChapterPosition(audioHandler.position);
      if (_chapterTimer == null) return;
    } else {
      timer.rebase(audioHandler.position);
    }
    if (!canExtendChapter) return;

    final oldCount = timer.remainingChapters;
    timer.extend();
    unawaited(_restoreFadeVolumeIfNeeded());
    _publishChapterTimer(timer);
    unawaited(
      recordHistory(
        PlayerHistoryType.sleepTimerExtended,
        details: <String, Object?>{
          'mode': SleepTimerMode.chapters.name,
          'additionalChapters': timer.remainingChapters - oldCount,
          'remainingChapters': timer.remainingChapters,
        },
      ),
    );
  }

  Future<bool> handleItemCompletion(InternalMedia media) async {
    final key = _mediaKey(media);
    if (_completedChapterMediaKey == key) {
      await _expiry;
      return true;
    }

    if (!_data.isRunning || _chapterTimer == null || _chapterMediaKey != key) return false;
    final binding = _chapterBinding;
    if (binding == null ||
        !audioHandler.isSleepTimerOwnerCurrent(
          media: media,
          binding: binding,
          navigationGeneration: _chapterNavigationGeneration,
        )) {
      stop(recordHistory: false);
      return false;
    }
    await _onTimerExpired();
    return true;
  }
}
