import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/screens/wear/wear_home_screen.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/init.dart' show Init;
import 'package:yaabsa/util/logger.dart';

late final WearAudioHandler wearAudioHandler;

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Init.globals();
      Init.initLogger();
      wearAudioHandler = await AudioService.init(
        builder: () => WearAudioHandler(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'de.vito0912.yaabsa.wear.audio',
          androidNotificationChannelName: 'Playback',
          androidNotificationIcon: 'drawable/ic_launcher_monochrome',
          androidNotificationOngoing: false,
          androidStopForegroundOnPause: false,
        ),
      );
      runApp(
        UncontrolledProviderScope(
          container: containerRef,
          child: MaterialApp(debugShowCheckedModeBanner: false, theme: ThemeData.dark(), home: const WearHomeScreen()),
        ),
      );
    },
    (error, stack) {
      logger('Uncaught Dart error: $error\n$stack', tag: 'WearZoneError', level: InfoLevel.error);
    },
  );
}

/// Lightweight audio handler for WearOS wrapping just_audio with audio_service.
class WearAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<PlayerState>? _ps;
  StreamSubscription<SequenceState?>? _ss;

  WearAudioHandler() {
    _ps = _player.playerStateStream.listen((s) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: s.playing,
          processingState: _map(s.processingState),
          updatePosition: _player.position,
          bufferedPosition: _player.bufferedPosition,
        ),
      );
    });
    _ss = _player.sequenceStateStream.listen((s) {
      final i = s.currentIndex;
      if (i != null && i < queue.value.length) mediaItem.add(queue.value[i]);
    });
  }

  AudioProcessingState _map(ProcessingState s) => switch (s) {
    ProcessingState.idle => AudioProcessingState.idle,
    ProcessingState.loading => AudioProcessingState.loading,
    ProcessingState.buffering => AudioProcessingState.buffering,
    ProcessingState.ready => AudioProcessingState.ready,
    ProcessingState.completed => AudioProcessingState.completed,
  };

  Future<void> loadMedia({
    required List<MediaItem> mediaItems,
    required List<AudioSource> audioSources,
    Duration initialPosition = Duration.zero,
  }) async {
    if (mediaItems.isEmpty || audioSources.isEmpty) return;
    queue.add(mediaItems);
    await _player.setAudioSource(ConcatenatingAudioSource(children: audioSources), initialPosition: initialPosition);
    mediaItem.add(mediaItems.first);
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> seek(Duration p) => _player.seek(p);
  @override
  Future<void> skipToNext() async {
    if (_player.hasNext) await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    _player.hasPrevious ? await _player.seekToPrevious() : await _player.seek(Duration.zero);
  }

  AudioPlayer get player => _player;
  bool get isPlaying => _player.playing;

  Future<void> dispose() async {
    await _ps?.cancel();
    await _ss?.cancel();
    await _player.dispose();
  }
}
