part of 'reader_speech_playback.dart';

extension _ReaderSpeechPlaybackDevice on ReaderSpeechPlayback {
  Future<void> _readDevice(int generation) async {
    try {
      while (_isCurrent(generation) && _playing) {
        final index = _index;
        final initialOffset = _offset;

        _hasSpeechProgress = false;
        await setVolume(_volume);

        if (!_isCurrent(generation) || !_playing) {
          return;
        }

        _speechBaseRelative = _estimatedRelative(index, initialOffset);

        final clock = Stopwatch()..start();

        _speechClock = clock;
        _processing = ProcessingState.ready;
        _publish();
        await _engine!.speak(
          _request(
            index,
            offset: initialOffset,
            onProgress: (start, end) {
              if (!_isCurrent(generation)) {
                return;
              }

              _hasSpeechProgress = true;
              _offset = initialOffset + start;
              _publish();
            },
          ),
        );

        clock.stop();

        if (!_isCurrent(generation) || !_playing) {
          return;
        }

        if (initialOffset == 0) {
          timeline.measure(index, Duration(microseconds: (clock.elapsedMicroseconds * _rate).round()));
        }

        if (index + 1 == timeline.chunks.length) {
          _complete();
          return;
        }

        _index++;
        _offset = 0;
        _relative = Duration.zero;
      }
    } catch (error) {
      if (_isCurrent(generation)) {
        _fail(error);
      }
    }
  }
}
