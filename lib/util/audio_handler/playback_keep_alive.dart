import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaabsa/util/audio_handler/playback_keep_alive_level.dart';
import 'package:yaabsa/util/audio_handler/playback_keep_alive_wave.dart';
import 'package:yaabsa/util/logger.dart';

class PlaybackKeepAlive {
  AudioPlayer? _player;
  StreamSubscription<PlayerException>? _playerErrorSubscription;
  Directory? _directory;
  File? _noiseFile;
  bool _loaded = false;

  StreamSubscription<AudioInterruptionEvent>? _interruptionSubscription;
  StreamSubscription<void>? _noisySubscription;
  bool _interrupted = false;
  bool _ducked = false;
  bool _routeDisconnected = false;

  PlaybackKeepAliveLevel _level = PlaybackKeepAliveLevel.off;
  bool _playing = false;
  double _volume = 0;
  bool _failed = false;
  bool _disposed = false;
  int _revision = 0;
  Future<void> _transition = Future<void>.value();
  Future<void>? _disposal;

  void update({required bool playing, required double volume, required PlaybackKeepAliveLevel level}) {
    if (_disposed) {
      return;
    }

    final normalizedVolume = volume.clamp(0.0, 1.0).toDouble();

    if (_playing == playing && _volume == normalizedVolume && _level == level) {
      return;
    }

    if (!_playing && playing) {
      _interrupted = false;
    }

    if ((!_playing && playing) || _level != level) {
      _failed = false;
      _routeDisconnected = false;
    }

    _playing = playing;
    _volume = normalizedVolume;
    _level = level;
    _scheduleUpdate();
  }

  bool get _shouldPlay {
    return _playing &&
        _volume > 0 &&
        _level != PlaybackKeepAliveLevel.off &&
        !_interrupted &&
        !_routeDisconnected &&
        !_failed;
  }

  bool _isCurrent(int revision) {
    return !_disposed && revision == _revision;
  }

  void _scheduleUpdate() {
    if (_disposed) {
      return;
    }

    final revision = ++_revision;

    _transition = _transition.then((_) async {
      if (!_isCurrent(revision)) {
        return;
      }

      try {
        await _apply(revision);
      } catch (error, stackTrace) {
        _fail(error, stackTrace);
      }
    });
  }

  Future<void> _apply(int revision) async {
    if (_level == PlaybackKeepAliveLevel.off || _failed) {
      await _releasePlayer();

      return;
    }

    if (!_shouldPlay) {
      await _player?.pause();

      return;
    }

    final player = await _preparePlayer(revision);

    if (player == null || !_isCurrent(revision) || !_shouldPlay) {
      return;
    }

    final duckingGain = _ducked ? 0.5 : 1.0;
    final effectiveVolume = _level.gain * _volume * duckingGain;

    await player.setVolume(effectiveVolume);

    if (!_isCurrent(revision) || !_shouldPlay) {
      return;
    }

    if (!player.playing) {
      unawaited(
        player.play().catchError((Object error, StackTrace stackTrace) {
          if (identical(_player, player)) {
            _fail(error, stackTrace);
          }
        }),
      );
    }
  }

  Future<AudioPlayer?> _preparePlayer(int revision) async {
    await _watchAudioSession();

    if (!_isCurrent(revision)) {
      return null;
    }

    final existingFile = _noiseFile;

    if (_loaded && existingFile != null && !await existingFile.exists()) {
      await _releasePlayer();
    }

    if (!_isCurrent(revision)) {
      return null;
    }

    final file = await _prepareNoiseFile();

    if (!_isCurrent(revision)) {
      return null;
    }

    var player = _player;

    if (player == null) {
      player = AudioPlayer(handleAudioSessionActivation: false, handleInterruptions: false);
      _player = player;
      _playerErrorSubscription = player.errorStream.listen((error) {
        _fail(error, StackTrace.current);
      });
    }

    if (!_loaded) {
      await player.setVolume(0);

      if (!_isCurrent(revision)) {
        return null;
      }

      await player.setLoopMode(LoopMode.one);

      if (!_isCurrent(revision)) {
        return null;
      }

      await player.setFilePath(file.path);
      _loaded = true;
    }

    return player;
  }

  Future<File> _prepareNoiseFile() async {
    final existing = _noiseFile;

    if (existing != null && await existing.exists()) {
      return existing;
    }

    _noiseFile = null;

    final bytes = await compute(createPlaybackKeepAliveWave, null);
    final temporaryDirectory = await getTemporaryDirectory();
    var directory = _directory;

    if (directory == null) {
      directory = await temporaryDirectory.createTemp('yaabsa-keep-alive-');
      _directory = directory;
    }

    final file = File('${directory.path}/noise.wav');

    await file.writeAsBytes(bytes, flush: true);
    _noiseFile = file;

    return file;
  }

  Future<void> _watchAudioSession() async {
    if (!(Platform.isAndroid || Platform.isIOS) || _interruptionSubscription != null) {
      return;
    }

    final session = await AudioSession.instance;

    if (_disposed) {
      return;
    }

    _interruptionSubscription = session.interruptionEventStream.listen((event) {
      if (event.type == AudioInterruptionType.duck) {
        _ducked = event.begin;
      } else {
        _interrupted = event.begin;
      }

      _scheduleUpdate();
    });
    _noisySubscription = session.becomingNoisyEventStream.listen((_) {
      _routeDisconnected = true;
      _scheduleUpdate();
    });
  }

  void _fail(Object error, StackTrace stackTrace) {
    if (_disposed || _failed) {
      return;
    }

    _failed = true;
    _loaded = false;
    logger('Keep-alive audio failed: $error\n$stackTrace', tag: 'PlaybackKeepAlive', level: InfoLevel.warning);
    _scheduleUpdate();
  }

  Future<void> _releasePlayer() async {
    final player = _player;

    _player = null;
    _loaded = false;

    await _playerErrorSubscription?.cancel();
    _playerErrorSubscription = null;
    await player?.dispose();
  }

  Future<void> dispose() {
    return _disposal ??= _dispose();
  }

  Future<void> _dispose() async {
    _disposed = true;
    _revision++;

    await _transition;
    await _interruptionSubscription?.cancel();
    await _noisySubscription?.cancel();

    try {
      await _releasePlayer();
    } finally {
      final directory = _directory;

      if (directory != null && await directory.exists()) {
        await directory.delete(recursive: true);
      }
    }
  }
}
