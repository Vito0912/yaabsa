import 'package:audio_service/audio_service.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/player/session_provider.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final ProviderContainer _ref;
  List<QueueItem> queueList = [];

  void setQueue(QueueItem item) {
    queueList = [item];
  }

  AudioPlayer get player => _player;

  int _currentTrackIndex = 0;
  InternalMedia? _currentMediaItem;

  Stream<Duration> get durationStream {
    return _player.durationStream.map((duration) {
      return internalMedia.firstOrNull?.totalDuration ??
          duration ??
          Duration.zero;
    });
  }

  Duration get duration {
    return internalMedia.firstOrNull?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> get positionStream {
    return _player.positionStream.map((position) {
      return (internalMedia.firstOrNull?.offsetForTrack(_currentTrackIndex) ??
              Duration.zero) +
          position;
    });
  }

  Duration get position {
    final pos = _player.position;
    return (internalMedia.firstOrNull?.offsetForTrack(_currentTrackIndex) ??
            Duration.zero) +
        pos;
  }

  @override
  Future<void> play() async {
    QueueItem? tmp = queueList.firstOrNull;
    if (tmp == null) return Future.value();
    _currentMediaItem = await _ref
        .read(sessionRepositoryProvider)
        .openSession(tmp.itemId);
    if (_currentMediaItem == null) {
      logger(
        'No media item found for ID: ${tmp.itemId}',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      return Future.value();
    }
    await _setSource();
    await _player.play();
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
      await _player.seek(
        position - _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
      );
    }
    return Future.value();
  }

  BGAudioHandler(this._ref) {
    _player.playerStateStream.listen((PlayerState state) {
      logger(state.toString());
      if (state.processingState == ProcessingState.completed) {
        if (internalMedia.firstOrNull == null) return;
        _currentTrackIndex++;
        if (_currentTrackIndex >= internalMedia.firstOrNull!.tracks.length) {
          _currentTrackIndex = 0;
          internalMedia.removeAt(0);
        }
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${internalMedia.firstOrNull!.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        // _setSource();
      }
      _updatePlaybackState();
    });
  }

  _setSource({Duration initialPosition = Duration.zero}) async {
    if (_currentMediaItem == null) return Future.value();
    final source = _currentMediaItem!.toAudioSources();
    await player.setAudioSources(
      source,
      initialIndex: 0,
      initialPosition: Duration.zero,
      preload: true,
    );
    await _player.play();
  }

  _updatePlaybackState() async {
    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: [
          MediaControl.skipToPrevious,
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        // Which other actions should be enabled in the notification
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
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
