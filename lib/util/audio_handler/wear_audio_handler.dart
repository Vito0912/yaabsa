import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/audio_handler/playback_sync_service.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;

class WearAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  late final PlaybackSyncService _syncService;
  StreamSubscription<PlayerState>? _ps;
  InternalMedia? _media;

  WearAudioHandler() {
    _ps = _player.playerStateStream.listen((s) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: s.playing,
          processingState: _map(s.processingState),
          updatePosition: position,
          bufferedPosition: _player.bufferedPosition,
        ),
      );
    });
    _syncService = PlaybackSyncService(
      containerRef,
      playerStateStream: _player.playerStateStream.distinct(
        (previous, next) => previous.playing == next.playing && previous.processingState == next.processingState,
      ),
      position: () => position,
    );
  }

  AudioProcessingState _map(ProcessingState s) => switch (s) {
    ProcessingState.idle => AudioProcessingState.idle,
    ProcessingState.loading => AudioProcessingState.loading,
    ProcessingState.buffering => AudioProcessingState.buffering,
    ProcessingState.ready => AudioProcessingState.ready,
    ProcessingState.completed => AudioProcessingState.completed,
  };

  InternalMedia? get media => _media;

  /// Position on the item's global timeline (across all tracks).
  Duration get position {
    final media = _media;
    final index = _player.currentIndex;
    if (media == null || index == null || index >= media.tracks.length) return _player.position;
    return media.offsetForTrack(index) + _player.position;
  }

  Future<void> loadInternalMedia(InternalMedia media, {Duration initialPosition = Duration.zero}) async {
    final sources = media.toAudioSources();
    if (sources.isEmpty) return;

    _media = media;
    final item = media.toMediaItem();
    queue.add([item]);
    mediaItem.add(item);

    final index = media.getIndexForDuration(initialPosition);
    await _player.setAudioSources(
      sources,
      initialIndex: index,
      initialPosition: initialPosition - media.offsetForTrack(index),
    );
  }

  @override
  Future<void> play() => _player.play();
  @override
  Future<void> pause() => _player.pause();
  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) async {
    final media = _media;
    if (media == null) return _player.seek(position);

    var target = position < Duration.zero ? Duration.zero : position;
    final total = media.totalDuration;
    if (target > total) target = total;

    final index = media.getIndexForDuration(target);
    await _player.seek(target - media.offsetForTrack(index), index: index);
  }

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
    await _syncService.dispose();
    await _ps?.cancel();
    await _player.dispose();
  }
}
