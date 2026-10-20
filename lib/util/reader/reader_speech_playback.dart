import 'dart:async';
import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yaabsa/util/reader/reader_speech_audio.dart';
import 'package:yaabsa/util/reader/reader_speech_engine.dart';
import 'package:yaabsa/util/reader/reader_speech_timeline.dart';

part 'reader_speech_playback_audio.dart';
part 'reader_speech_playback_device.dart';

class ReaderSpeechPlaybackState {
  const ReaderSpeechPlaybackState({
    required this.position,
    required this.duration,
    required this.bufferedPosition,
    required this.playerState,
    required this.cfi,
    required this.isEstimated,
    this.error,
  });

  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  final PlayerState playerState;
  final String cfi;
  final bool isEstimated;
  final String? error;
}

class ReaderSpeechPlayback {
  ReaderSpeechPlayback({
    required this.timeline,
    required this.registration,
    required this.language,
    required this.voice,
    required double rate,
    required double volume,
  }) : _rate = rate.clamp(0.5, 2.0),
       _volume = volume.clamp(0.0, 1.0) {
    _generator = registration.createAudioGenerator?.call();
    _engine = _generator == null ? ReaderSpeechEngines.create(registration.id) : null;

    final initial = timeline.initialAnchor;

    _index = initial.index;
    _offset = initial.offset;
    _relative = _estimatedRelative(_index, _offset);
    _publish();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) => _publish());
  }

  final ReaderSpeechTimeline timeline;
  final ReaderSpeechEngineRegistration registration;
  final String language;
  final String voice;

  final BehaviorSubject<ReaderSpeechPlaybackState> states = BehaviorSubject<ReaderSpeechPlaybackState>();
  late final ReaderSpeechAudioGenerator? _generator;
  late final ReaderSpeechEngine? _engine;
  AudioPlayer? _player;
  Directory? _directory;

  final Map<int, ReaderSpeechAudio> _cache = {};
  final List<int> _queue = [];
  final Set<Future<void>> _pending = {};
  final List<StreamSubscription<dynamic>> _subscriptions = [];
  int _fileSequence = 0;

  Future<void> _transition = Future.value();
  Future<void>? _disposal;
  Future<void>? _audioSessionInitialization;
  int _generation = 0;
  bool _disposed = false;

  int _index = 0;
  int _offset = 0;
  Duration _relative = Duration.zero;
  Duration _speechBaseRelative = Duration.zero;
  Stopwatch? _speechClock;
  Timer? _ticker;
  bool _hasSpeechProgress = false;

  double _rate;
  double _volume;
  bool _playing = false;
  bool _loading = false;
  bool _editingQueue = false;
  bool _prefetching = false;
  bool _resumeAfterInterruption = false;
  bool _ducked = false;
  ProcessingState _processing = ProcessingState.ready;
  String? _error;
  Object? _prefetchError;

  double get rate => _rate;

  ReaderSpeechPlaybackState get state => states.value;

  bool _isCurrent(int generation) => !_disposed && generation == _generation;

  Duration _estimatedRelative(int index, int offset) {
    return Duration(
      microseconds: (timeline.durations[index].inMicroseconds * offset / timeline.chunks[index].text.length).round(),
    );
  }

  void _publish() {
    if (_disposed) {
      return;
    }

    if (_generator != null && !_loading && !_editingQueue && _player != null && _queue.isNotEmpty) {
      _relative = _player!.position;

      final audio = _cache[_index];

      if (audio != null && audio.timings.isNotEmpty) {
        _offset = audio.offsetAt(_relative);
      }
    } else if (_speechClock?.isRunning == true) {
      _relative = _speechBaseRelative + Duration(microseconds: (_speechClock!.elapsedMicroseconds * _rate).round());

      if (!_hasSpeechProgress) {
        _offset = timeline.offsetAt(_index, _relative);
      }
    }

    _relative = Duration(microseconds: _relative.inMicroseconds.clamp(0, timeline.durations[_index].inMicroseconds));

    var buffered = timeline.starts[_index] + _relative;

    if (_generator != null && _cache.containsKey(_index)) {
      buffered = timeline.starts[_index] + timeline.durations[_index];

      if (_cache.containsKey(_index + 1)) {
        buffered += timeline.durations[_index + 1];
      }
    }

    states.add(
      ReaderSpeechPlaybackState(
        position: timeline.starts[_index] + _relative,
        duration: timeline.duration,
        bufferedPosition: buffered,
        playerState: PlayerState(_playing, _processing),
        cfi: timeline.cfiAt(_index, _offset),
        isEstimated: _generator == null || timeline.isEstimated,
        error: _error,
      ),
    );
  }

  ReaderSpeechRequest _request(int index, {int offset = 0, ReaderSpeechProgress? onProgress}) {
    return ReaderSpeechRequest(
      text: timeline.chunks[index].text.substring(offset),
      language: language,
      voice: voice,
      rate: _rate,
      previousText: index > 0 ? timeline.chunks[index - 1].text : null,
      nextText: index + 1 < timeline.chunks.length ? timeline.chunks[index + 1].text : null,
      nextNextText: index + 2 < timeline.chunks.length ? timeline.chunks[index + 2].text : null,
      onProgress: onProgress,
    );
  }

  Future<void> _serialize(Future<void> Function() operation) {
    final future = _transition.catchError((Object _) {}).then((_) async {
      if (!_disposed) {
        await operation();
      }
    });

    _transition = future.catchError((Object _) {});

    return future;
  }

  Future<void> play() {
    return _serialize(() async {
      if (_playing) {
        return;
      }

      _error = null;
      await _initializeAudioSession();

      if (_disposed) {
        return;
      }

      final audioSession = await AudioSession.instance;

      if (!await audioSession.setActive(true) || _disposed) {
        return;
      }

      _playing = true;

      final restart = _processing == ProcessingState.completed;

      if (restart) {
        _index = 0;
        _offset = 0;
        _relative = Duration.zero;
      }

      if (_generator != null && _prefetchError != null && _player?.processingState == ProcessingState.completed) {
        _index++;
        _offset = 0;
        _relative = Duration.zero;
        _prefetchError = null;
      }

      final generation = _generator == null || _queue.isEmpty || restart ? ++_generation : _generation;

      if (_generator != null) {
        if (restart || _queue.isEmpty || _queue[_player?.currentIndex ?? 0] != _index) {
          await _loadAudio(generation);
        } else {
          if (_player?.processingState == ProcessingState.completed) {
            _processing = ProcessingState.buffering;
          } else {
            _processing = ProcessingState.ready;
            _startNative();
          }

          _prefetch(_index + 1, generation);
          _publish();
        }
      } else {
        unawaited(_readDevice(generation));
      }
    });
  }

  Future<void> pause({bool interruption = false}) {
    if (!interruption) {
      _resumeAfterInterruption = false;
    }

    _playing = false;
    _publish();

    if (_generator == null) {
      _generation++;
      _speechClock?.stop();
    }

    return _serialize(() async {
      if (_generator != null) {
        await _player?.pause();
      } else {
        await _engine?.stop();

        if (!_hasSpeechProgress) {
          _offset = timeline.offsetAt(_index, _relative);
        }

        _offset = timeline.chunks[_index].boundaries.lastWhere((boundary) => boundary.offset <= _offset).offset;
        _relative = _estimatedRelative(_index, _offset);
      }

      _processing = ProcessingState.ready;
      _publish();
    });
  }

  Future<void> seek(Duration position) {
    final bounded = Duration(microseconds: position.inMicroseconds.clamp(0, timeline.duration.inMicroseconds));
    final index = timeline.indexAt(bounded);
    final relative = bounded - timeline.starts[index];
    final audio = _cache[index];

    return _seekAnchor(
      index,
      audio?.offsetAt(relative) ?? timeline.offsetAt(index, relative),
      audio == null ? null : relative,
    );
  }

  Future<void> seekCfi(String cfi) {
    final anchor = timeline.anchorForCfi(cfi);

    if (anchor == null) {
      return Future.value();
    }

    return _seekAnchor(anchor.index, anchor.offset, _cache[anchor.index]?.positionForOffset(anchor.offset));
  }

  Future<void> _seekAnchor(int index, int offset, Duration? relative) {
    final generation = ++_generation;

    _speechClock?.stop();
    _loading = true;
    _processing = ProcessingState.buffering;
    _publish();

    return _serialize(() async {
      if (!_isCurrent(generation)) {
        return;
      }

      await _player?.pause();
      await _engine?.stop();
      await _generator?.reset();
      await _waitPending();

      if (!_isCurrent(generation)) {
        return;
      }

      _index = index;
      _offset = offset;
      _relative = relative ?? _estimatedRelative(index, offset);
      _error = null;
      _prefetchError = null;
      _publish();

      if (_generator != null) {
        await _loadAudio(generation, exactRelative: relative);
      } else if (_playing) {
        _loading = false;
        unawaited(_readDevice(generation));
      } else {
        _loading = false;
        _processing = ProcessingState.ready;
        _publish();
      }
    });
  }

  Future<void> setRate(double rate) async {
    if (_disposed) {
      return;
    }

    final newRate = rate.clamp(0.5, 2.0);

    if (_rate == newRate) {
      return;
    }

    if (_generator != null) {
      _rate = newRate;
      await _player?.setSpeed(newRate);

      _publish();
    } else {
      final anchor = timeline.cfiAt(_index, _offset);

      _rate = newRate;
      await seekCfi(anchor);
    }
  }

  Future<void> setVolume(double volume) async {
    if (_disposed) {
      return;
    }

    _volume = volume.clamp(0.0, 1.0);

    final effectiveVolume = _ducked ? _volume * 0.5 : _volume;

    await _player?.setVolume(effectiveVolume);

    final engine = _engine;

    if (engine is ReaderSpeechVolumeControl) {
      await (engine as ReaderSpeechVolumeControl).setVolume(effectiveVolume);
    }
  }

  Future<void> _initializeAudioSession() => _audioSessionInitialization ??= _configureAudioSession();

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;

    if (_disposed) {
      return;
    }

    _subscriptions.add(
      session.becomingNoisyEventStream.listen((_) {
        if (!_disposed) {
          unawaited(pause());
        }
      }),
    );
    _subscriptions.add(
      session.interruptionEventStream.listen((event) {
        if (_disposed) {
          return;
        }

        if (event.type == AudioInterruptionType.duck && (_generator != null || _engine is ReaderSpeechVolumeControl)) {
          _ducked = event.begin;
          unawaited(setVolume(_volume));
        } else if (event.begin) {
          _resumeAfterInterruption = _playing;
          unawaited(pause(interruption: true));
        } else if (_resumeAfterInterruption && event.type != AudioInterruptionType.unknown) {
          _resumeAfterInterruption = false;
          unawaited(play());
        }
      }),
    );
  }

  void _complete() {
    _playing = false;
    _processing = ProcessingState.completed;
    _relative = timeline.durations[_index];
    _offset = timeline.chunks[_index].text.length - 1;
    _speechClock?.stop();
    _publish();
  }

  void _fail(Object error) {
    _playing = false;
    _processing = ProcessingState.ready;
    _error = error.toString();
    _speechClock?.stop();
    unawaited(_player?.pause());
    _publish();
  }

  Future<void> _waitPending() async {
    await Future.wait(_pending.toList().map((future) => future.catchError((Object _) {})));
  }

  Future<void> dispose() => _disposal ??= _dispose();

  Future<void> _dispose() async {
    _disposed = true;
    _generation++;
    _ticker?.cancel();
    _speechClock?.stop();
    await _generator?.reset();
    await _engine?.stop();
    await _transition;
    await _waitPending();

    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }

    await _player?.dispose();

    final directory = _directory;

    if (directory != null && await directory.exists()) {
      await directory.delete(recursive: true);
    }

    await states.close();
  }
}
