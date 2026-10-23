part of 'bg_audio_handler.dart';

extension _BGAudioHandlerReaderProgress on BGAudioHandler {
  Future<void> _saveReaderSpeechProgress({bool force = false}) async {
    final speech = _speechPlayback;
    final item = _speechItem;
    final userId = _speechProgressUserId;

    if (speech == null || item == null || userId == null || speech.state.cfi.isEmpty) {
      return;
    }

    final state = speech.state;
    final now = DateTime.now();
    final lastSaved = _lastSpeechProgressSavedAt;

    if (!force &&
        (_lastSpeechProgressCfi == state.cfi ||
            (lastSaved != null && now.difference(lastSaved) < const Duration(seconds: 2)))) {
      return;
    }

    _lastSpeechProgressCfi = state.cfi;
    _lastSpeechProgressSavedAt = now;

    try {
      await _readerProgressSync.save(
        userId: userId,
        itemId: item.id,
        location: state.cfi,
        progress: state.playerState.processingState == ProcessingState.completed
            ? 1.0
            : speech.timeline.progressForCfi(state.cfi),
      );

      if (force) {
        unawaited(_readerProgressSync.flush());
      }
    } catch (error, stack) {
      if (identical(_speechPlayback, speech)) {
        _lastSpeechProgressCfi = null;
      }

      logger('Could not save read aloud position: $error\n$stack', tag: 'ReaderProgressSync', level: InfoLevel.warning);
    }
  }
}
