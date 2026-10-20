part of 'reader_speech_playback.dart';

extension _ReaderSpeechPlaybackAudio on ReaderSpeechPlayback {
  AudioPlayer _ensurePlayer() {
    final existing = _player;

    if (existing != null) {
      return existing;
    }

    final player = _player = AudioPlayer(handleInterruptions: false);

    _subscriptions.add(
      player.currentIndexStream.listen((queueIndex) {
        if (_disposed || _loading || _editingQueue || queueIndex == null || queueIndex >= _queue.length) {
          return;
        }

        final index = _queue[queueIndex];

        if (_index != index) {
          _index = index;
          _offset = 0;
          _relative = Duration.zero;
          _processing = ProcessingState.ready;
          _measureCurrentAudio();
          _prefetch(index + 1, _generation);
          _publish();
        }
      }),
    );
    _subscriptions.add(
      player.durationStream.listen((_) {
        if (!_disposed && !_loading && !_editingQueue) {
          _measureCurrentAudio();
        }
      }),
    );
    _subscriptions.add(
      player.playerStateStream.listen((state) {
        if (_disposed || _loading || _editingQueue) {
          return;
        }

        if (state.processingState == ProcessingState.completed) {
          if (_index + 1 == timeline.chunks.length) {
            _complete();

            if (player.playing) {
              unawaited(player.pause());
            }
          } else if (_prefetchError != null) {
            _fail(_prefetchError!);
          } else {
            _processing = ProcessingState.buffering;
            _prefetch(_index + 1, _generation);
            _publish();
          }
        } else {
          _processing = state.processingState;
          _publish();
        }
      }),
    );
    _subscriptions.add(
      player.errorStream.listen((error) {
        if (!_disposed) {
          _fail(StateError('Could not play speech audio'));
        }
      }),
    );

    return player;
  }

  void _measureCurrentAudio() {
    final queueIndex = _player?.currentIndex;

    if (queueIndex == null || queueIndex >= _queue.length || _queue[queueIndex] != _index) {
      return;
    }

    final duration = _player?.duration;

    if (duration == null || duration <= Duration.zero) {
      return;
    }

    timeline.measure(_index, duration);
    _publish();
  }

  void _startNative() {
    _player?.play().catchError((Object error) {
      if (!_disposed) {
        _fail(StateError('Could not play speech audio'));
      }
    }).ignore();
  }

  Future<ReaderSpeechAudio> _fetchAudio(int index, int generation) async {
    final cached = _cache[index];

    if (cached != null) {
      return cached;
    }

    final directory = _directory ??= await Directory.systemTemp.createTemp('yaabsa-speech-');
    final file = File('${directory.path}/${_fileSequence++}.mp3');

    final audio = await _generator!.generate(_request(index), file);

    if (!_isCurrent(generation)) {
      if (await file.exists()) {
        await file.delete();
      }

      throw StateError('Speech was cancelled');
    }

    _cache[index] = audio;

    return audio;
  }

  Future<void> _loadAudio(int generation, {Duration? exactRelative}) async {
    _loading = true;
    _processing = ProcessingState.buffering;
    _publish();

    final player = _ensurePlayer();

    try {
      await player.pause();

      final index = _index;

      final audio = await _fetchAudio(index, generation);

      if (!_isCurrent(generation)) {
        return;
      }

      await player.setSpeed(_rate);
      await setVolume(_volume);
      await player.setAudioSources([AudioSource.file(audio.file.path)]);

      if (!_isCurrent(generation)) {
        return;
      }

      _queue.clear();
      _queue.add(index);

      final duration = player.duration;

      if (duration != null) {
        timeline.measure(index, duration);
      }

      final relative = exactRelative ?? audio.positionForOffset(_offset);

      _relative = Duration(microseconds: relative.inMicroseconds.clamp(0, timeline.durations[index].inMicroseconds));
      await player.seek(_relative, index: 0);

      if (!_isCurrent(generation)) {
        return;
      }

      _processing = ProcessingState.ready;
      _loading = false;
      _publish();

      if (_playing) {
        _startNative();
      }

      await _trimCache(generation);

      _prefetch(index + 1, generation);
    } catch (error) {
      if (_isCurrent(generation)) {
        _queue.clear();
        await player.clearAudioSources();

        final brokenAudio = _cache.remove(_index);

        if (brokenAudio != null && await brokenAudio.file.exists()) {
          await brokenAudio.file.delete();
        }

        _fail(error);
      }
    } finally {
      _loading = false;
    }
  }

  void _prefetch(int index, int generation) {
    if (!_isCurrent(generation) || _prefetching || index >= timeline.chunks.length || _queue.contains(index)) {
      return;
    }

    _prefetching = true;

    final future = _appendNext(index, generation);

    _pending.add(future);
    future.whenComplete(() {
      _pending.remove(future);
      _prefetching = false;

      if (_isCurrent(generation) && _index >= index) {
        _prefetch(_index + 1, generation);
      }
    }).ignore();
  }

  Future<void> _appendNext(int index, int generation) async {
    var appended = false;

    try {
      final audio = await _fetchAudio(index, generation);

      if (!_isCurrent(generation)) {
        return;
      }

      final player = _player!;
      final wasCompleted = player.processingState == ProcessingState.completed;

      _editingQueue = true;
      _queue.add(index);
      await player.addAudioSource(AudioSource.file(audio.file.path));

      appended = true;
      _editingQueue = false;

      if (!_isCurrent(generation)) {
        return;
      }

      _prefetchError = null;

      if (wasCompleted || player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero, index: _queue.indexOf(index));

        _index = index;
        _offset = 0;
        _relative = Duration.zero;
        _processing = ProcessingState.ready;
        _measureCurrentAudio();

        if (_playing) {
          _startNative();
        }
      }

      await _trimCache(generation);

      _publish();
    } catch (error) {
      if (_isCurrent(generation)) {
        if (!appended) {
          _queue.remove(index);
        }

        _prefetchError = error;

        if (_player?.processingState == ProcessingState.completed) {
          _fail(error);
        }
      }
    } finally {
      _editingQueue = false;
    }
  }

  Future<void> _trimCache(int generation) async {
    while (_queue.isNotEmpty && _queue.first < _index - 2 && _isCurrent(generation)) {
      _editingQueue = true;
      _queue.removeAt(0);
      await _player!.removeAudioSourceAt(0);

      _editingQueue = false;
    }

    if (!_isCurrent(generation)) {
      return;
    }

    final obsolete = _cache.keys
        .where((index) => !_queue.contains(index) && (index < _index - 2 || index > _index + 1))
        .toList();

    for (final index in obsolete) {
      final audio = _cache.remove(index);

      if (audio != null && await audio.file.exists()) {
        await audio.file.delete();
      }
    }
  }
}
