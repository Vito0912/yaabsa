import 'package:audio_service/audio_service.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/player/session_provider.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/playback_sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/transformers.dart';

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final ProviderContainer _ref;
  List<QueueItem> queueList = [];

  void setQueue(QueueItem item) {
    queueList = [item];
  }

  void addToQueue(dynamic item) {
    if (item is List<QueueItem>) {
      queueList.addAll(item);
    } else if (item is QueueItem) {
      queueList.add(item);
    }
  }

  AudioPlayer get player => _player;

  int _currentTrackIndex = 0;
  InternalMedia? _currentMediaItem;

  Stream<Duration> get durationStream {
    return _player.durationStream.map((duration) {
      return _currentMediaItem?.totalDuration ?? duration ?? Duration.zero;
    }).distinct();
  }

  Duration get duration {
    return _currentMediaItem?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> get positionStream {
    return _player.positionStream
        .throttleTime(const Duration(milliseconds: 200))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();
  }

  Stream<Duration> get bufferedPositionStream {
    return _player.bufferedPositionStream
        .throttleTime(const Duration(seconds: 1))
        .map((position) => (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + position)
        .distinct();
  }

  Stream<InternalChapter?> get chapterStream {
    return _player.positionStream
        .throttleTime(const Duration(milliseconds: 1000))
        .map((position) => _currentMediaItem?.getChapterForDuration(position))
        .distinct();
  }

  Stream<List<InternalChapter>> get chaptersStream {
    return _player.playerStateStream.map((position) => _currentMediaItem?.chapters ?? []).distinct();
  }

  Duration get position {
    final pos = _player.position;
    return (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ?? Duration.zero) + pos;
  }

  @override
  Future<void> play() async {
    if (_currentMediaItem != null) await _player.play();

    QueueItem? tmp = queueList.isNotEmpty ? queueList.removeAt(0) : null;
    if (tmp == null) return Future.value();
    _currentMediaItem = await _ref.read(sessionRepositoryProvider).openSession(tmp.itemId);
    if (_currentMediaItem == null) {
      logger('No media item found for ID: ${tmp.itemId}', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }
    await _setSource();
    await _player.play();
  }

  @override
  Future<void> stop() async {
    _currentMediaItem = null;
    _currentTrackIndex = 0;
    queueList.clear();
    await _ref.read(sessionRepositoryProvider).closeSession();
    return _player.stop();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    return Future.value();
  }

  // TODO: Skiptime
  static const Duration skipTime = Duration(seconds: 10);

  @override
  Future<void> fastForward() async {
    if (_currentMediaItem == null) return Future.value();
    final newPosition = position + skipTime;
    seek(newPosition);
    return Future.value();
  }

  @override
  Future<void> rewind() async {
    if (_currentMediaItem == null) return Future.value();
    final newPosition = position - skipTime;
    seek(newPosition);
    return Future.value();
  }

  @override
  Future<void> seek(Duration position) async {
    if (_currentMediaItem == null) return Future.value();
    final newTrackIndex = _currentMediaItem!.getIndexForDuration(position);
    if (newTrackIndex != _currentTrackIndex) {
      _currentTrackIndex = newTrackIndex;
      await _player.seek(
        position - _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
        index: _currentTrackIndex,
      );
    } else {
      await _player.seek(position - _currentMediaItem!.startDurationForTrack(_currentTrackIndex));
    }
    return Future.value();
  }

  BGAudioHandler(this._ref) {
    PlaybackSyncService syncService = PlaybackSyncService(this, _ref);
    _player.playerStateStream.listen((PlayerState state) async {
      logger(state.toString(), tag: 'AudioHandler', level: InfoLevel.debug);
      if (state.processingState == ProcessingState.completed) {
        if (_currentMediaItem == null) return;
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${_currentMediaItem!.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await syncService.flush();
        await _ref.read(sessionRepositoryProvider).closeSession();

        if (queueList.isNotEmpty) {
          await play();
        } else {
          await _player.stop();
          await _player.dispose();
        }
      }
      _updatePlaybackState();
    });
  }

  _setSource({Duration initialPosition = Duration.zero}) async {
    if (_currentMediaItem == null) return Future.value();
    final source = _currentMediaItem!.toAudioSources();
    await player.setAudioSources(source, initialIndex: 0, initialPosition: Duration.zero, preload: true);
    await _player.play();
  }

  _updatePlaybackState() async {
    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: [MediaControl.skipToPrevious, MediaControl.pause, MediaControl.stop, MediaControl.skipToNext],
        // Which other actions should be enabled in the notification
        systemActions: const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward},
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState: AudioProcessingState.ready,
        // Whether audio is playing
        playing: _player.playerState.playing,
        // The current position as of this update. You should not broadcast
        // position changes continuously because listeners will be able to
        // project the current position after any elapsed time based on the
        // current speed and whether audio is playing and ready. Instead, only
        // broadcast position updates when they are different from expected (e.g.
        // buffering, or seeking).
        updatePosition: _player.position,
        // speed: _player.play,
      ),
    );
  }
}
