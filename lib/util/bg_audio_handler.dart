import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:buchshelfly/util/logger.dart';

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer get player => _player;

  int _currentTrackIndex = 0;
  InternalMedia? _currentMediaItem;

  Stream<Duration> get durationStream {
    return _player.onDurationChanged.map((duration) {
      return internalMedia.firstOrNull?.totalDuration ?? duration;
    });
  }

  Duration get duration {
    return internalMedia.firstOrNull?.totalDuration ?? Duration.zero;
  }

  Stream<Duration> get positionStream {
    return _player.onPositionChanged.map((position) {
      return (internalMedia.firstOrNull?.offsetForTrack(_currentTrackIndex) ??
              Duration.zero) +
          position;
    });
  }

  Future<Duration> get position async {
    final pos = await _player.getCurrentPosition() ?? Duration.zero;
    return (internalMedia.firstOrNull?.offsetForTrack(_currentTrackIndex) ??
            Duration.zero) +
        pos;
  }

  @override
  Future<void> play() async {
    _currentMediaItem = internalMedia.firstOrNull;
    final currentMediaItem = _currentMediaItem;
    if (currentMediaItem == null) return Future.value();
    await _setSource();
    await _player.resume();
  }

  @override
  Future<void> seek(Duration position) async {
    if (_currentMediaItem == null) return Future.value();
    _currentTrackIndex = _currentMediaItem!.getIndexForDuration(position);
    await _setSource(
      initialPosition:
          position -
          _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
    );
    return Future.value();
  }

  BGAudioHandler() {
    _player.onPlayerStateChanged.listen((PlayerState state) {
      logger(state.toString());
      if (state == PlayerState.completed) {
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
        _setSource();
      }
      _updatePlaybackState();
    });
  }

  _setSource({Duration initialPosition = Duration.zero}) async {
    if (_currentMediaItem == null) return Future.value();
    final source =
        _currentMediaItem!.local
            ? UrlSource(_currentMediaItem!.tracks[_currentTrackIndex].url)
            : UrlSource(_currentMediaItem!.tracks[_currentTrackIndex].url);
    await _player.play(source, position: initialPosition);
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
        playing: _player.state == PlayerState.playing,
        // The current position as of this update. You should not broadcast
        // position changes continuously because listeners will be able to
        // project the current position after any elapsed time based on the
        // current speed and whether audio is playing and ready. Instead, only
        // broadcast position updates when they are different from expected (e.g.
        // buffering, or seeking).
        updatePosition: await position,
        speed: _player.playbackRate,
      ),
    );
  }
}
