import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:yaabsa/database/settings_manager.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/handler/playback_sync_service.dart';
import 'package:yaabsa/util/handler/player_history_handler.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:rxdart/rxdart.dart';

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _player;
  final ProviderContainer _ref;
  late final PlaybackSyncService _syncService;
  StreamSubscription<PlayerException>? _errorSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;
  bool _isDisposing = false;
  List<QueueItem> queueList = [];
  QueueItem? _lastQueueItem;
  Future<void> _skipOperationQueue = Future.value();
  final BehaviorSubject<int> _queueLengthSubject = BehaviorSubject<int>.seeded(0);
  BehaviorSubject<InternalMedia?> mediaItemStream =
      BehaviorSubject<InternalMedia?>();
  InternalMedia? get currentMediaItem => _currentMediaItem;

  static double get maxVolume {
    if (Platform.isAndroid) {
      return 2.0;
    }
    return 1.0;
  }

  void setQueue(QueueItem item) {
    queueList = [item];
    _emitQueueLength();
  }

  void addToQueue(dynamic item) {
    if (item is List<QueueItem>) {
      queueList.addAll(item);
    } else if (item is QueueItem) {
      queueList.add(item);
    }
    _emitQueueLength();
  }

  void _emitQueueLength() {
    if (!_queueLengthSubject.isClosed) {
      _queueLengthSubject.add(queueList.length);
    }
  }

  AudioPlayer get player => _player;

  int _currentTrackIndex = 0;
  InternalMedia? __currentMediaItem;

  InternalMedia? get _currentMediaItem => __currentMediaItem;
  set _currentMediaItem(InternalMedia? mediaItem) {
    __currentMediaItem = mediaItem;
    _currentTrackIndex = 0;
    mediaItemStream.add(mediaItem);
  }

  Stream<double> get volumeStream => _player.volumeStream;

  Future<void> setVolume(double volume) async {
    if (volume < 0 || volume > maxVolume) {
      logger(
        'Volume out of bounds: $volume',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      return Future.value();
    }
    await _player.setVolume(volume);
    return Future.value();
  }

  @override
  Future<void> setSpeed(double speed) async {
    if (speed < 0.25 || speed > 3) {
      logger(
        'Speed out of bounds: $speed',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      return Future.value();
    }
    await _player.setSpeed(speed);
    return Future.value();
  }

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
        .map(
          (position) =>
              (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ??
                  Duration.zero) +
              position,
        )
        .distinct();
  }

  Stream<Duration> get bufferedPositionStream {
    return _player.bufferedPositionStream
        .throttleTime(const Duration(seconds: 1))
        .map(
          (position) =>
              (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ??
                  Duration.zero) +
              position,
        )
        .distinct();
  }

  Stream<InternalChapter?> get chapterStream {
    return _player.positionStream
        .throttleTime(const Duration(milliseconds: 1000))
        .map((position) => _currentMediaItem?.getChapterForDuration(position))
        .distinct();
  }

  Stream<List<InternalChapter>> get chaptersStream {
    return mediaItemStream
        .map((position) => _currentMediaItem?.chapters ?? [])
        .distinct();
  }

  Stream<int> get queueLengthStream => _queueLengthSubject.stream;

  bool get canSkipForwardNow {
    if (_currentMediaItem == null) return false;
    if (queueList.isNotEmpty) return true;
    return _currentMediaItem!.getNextChapterForDuration(position) != null;
  }

  Stream<bool> get canSkipForwardStream {
    return Rx.combineLatest3<Duration, List<InternalChapter>, int, bool>(
      positionStream,
      chaptersStream,
      queueLengthStream,
      (position, chapters, queueLength) {
        if (_currentMediaItem == null) return false;
        if (queueLength > 0) return true;
        return _currentMediaItem!.getNextChapterForDuration(position) != null;
      },
    ).startWith(canSkipForwardNow).distinct();
  }

  Duration get position {
    final pos = _player.position;
    return (_currentMediaItem?.offsetForTrack(_currentTrackIndex) ??
            Duration.zero) +
        pos;
  }

  Stream<bool> get shouldShowPlayer {
    return _player.playerStateStream
        .map((state) => _currentMediaItem != null)
        .distinct();
  }

  @override
  Future<void> play() async {
    if (_currentMediaItem != null) {
      await _syncedPlay();
      return Future.value();
    }

    QueueItem? tmp = queueList.isNotEmpty ? queueList.removeAt(0) : null;
    if (tmp != null) {
      _emitQueueLength();
    }

    if (tmp == null && _lastQueueItem != null) {
      // e.g. Android still shows the notification and allows pressing play. This will re-use the last item.
      tmp = _lastQueueItem;
    }
    if (tmp == null) return Future.value();
    _lastQueueItem = tmp;
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
    logger(
      'Playing item: ${_currentMediaItem!.itemId}',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    await _setSource();
    logger(
      'Setting source for item: ${_currentMediaItem!.itemId}',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    await _syncedPlay(restoreProgress: true);
  }

  Future<void> _syncedPlay({bool restoreProgress = false}) async {
    mediaItem.add(_currentMediaItem?.toMediaItem());

    if (_currentMediaItem == null) return Future.value();

    if (!restoreProgress) {
      await _player.play();
      return Future.value();
    }

    Duration currentPosition = Duration.zero;

    final progress = await _ref
        .read(mediaProgressProvider.notifier)
        .fetchOrRefreshIndividualProgress(_currentMediaItem!.itemId);

    currentPosition = Duration(
      microseconds:
          ((progress?.currentTime ?? 0) * Duration.microsecondsPerSecond)
              .round(),
    );

    logger(
      'Current position: $currentPosition, player position: ${_player.position}, progress: ${progress?.currentTime}',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    if (currentPosition > Duration.zero) {
      await seek(currentPosition);
    }

    await _player.play();
  }

  @override
  Future<void> stop({bool clearQueue = true}) async {
    _currentMediaItem = null;
    _currentTrackIndex = 0;
    if (clearQueue) {
      queueList.clear();
      _emitQueueLength();
    }
    try {
      await _syncService.flush();
      await _ref.read(sessionRepositoryProvider).closeSession();
    } catch (e) {
      logger(
        'Error closing session: $e',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
    }

    return _safePlayerStop();
  }

  Future<void> _safePlayerStop() async {
    if (Platform.isLinux) {
      await _player.pause();
      await _player.seek(Duration.zero);
      return;
    }
    await _player.stop();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
    return Future.value();
  }

  // TODO: Settings
  static const Duration skipTime = Duration(seconds: 10);
  static const bool headphoneSkip =
      true; // Later should determine if the skip button just fasts forward or skips chapters

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
    if (newPosition < Duration.zero) {
      logger(
        'Rewind position is negative, resetting to zero',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      return seek(Duration.zero);
    }
    seek(newPosition);
    return Future.value();
  }

  @override
  Future<void> skipToNext() async {
    return _queueSkipOperation(() async {
      if (_currentMediaItem == null) return;
      InternalChapter? nextChapter = _currentMediaItem!.getNextChapterForDuration(
        position,
      );
      if (nextChapter != null) {
        final newPosition = Duration(
          microseconds: (nextChapter.start * Duration.microsecondsPerSecond)
              .round(),
        );
        logger(
          'Skipping to next chapter: $nextChapter, new position: $newPosition',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await seek(newPosition);
        return;
      }

      logger(
        'No next chapter found, skipping to next item',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );
      if (queueList.isNotEmpty) {
        await stop(clearQueue: false);
        await play();
      } else {
        logger(
          'No next chapter and queue is empty, ignoring skip-to-next',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
      }
    });
  }

  @override
  Future<void> skipToPrevious() async {
    return _queueSkipOperation(() async {
      if (_currentMediaItem == null) return;
      InternalChapter? previousChapter = _currentMediaItem!
          .getPreviousChapterForDuration(position);
      if (previousChapter != null) {
        final newPosition = Duration(
          microseconds:
              (previousChapter.start * Duration.microsecondsPerSecond).round(),
        );
        logger(
          'Skipping to previous chapter: $previousChapter, new position: $newPosition',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await seek(newPosition);
      }
    });
  }

  Future<void> _queueSkipOperation(Future<void> Function() operation) {
    _skipOperationQueue = _skipOperationQueue
        .then((_) => operation())
        .catchError((Object e, StackTrace s) {
          logger(
            'Skip operation failed: $e\n$s',
            tag: 'AudioHandler',
            level: InfoLevel.error,
          );
        });
    return _skipOperationQueue;
  }

  @override
  Future<void> seek(Duration position) async {
    if (_currentMediaItem == null) return Future.value();
    final maxPosition = _currentMediaItem!.totalDuration;
    final boundedPosition = position < Duration.zero
        ? Duration.zero
        : (position > maxPosition ? maxPosition : position);
    final newTrackIndex = _currentMediaItem!.getIndexForDuration(boundedPosition);
    if (newTrackIndex < 0) {
      logger(
        'Ignoring seek with invalid track index for position: $boundedPosition',
        tag: 'AudioHandler',
        level: InfoLevel.warning,
      );
      return Future.value();
    }
    logger(
      'Seeking to position: $boundedPosition, track index: $newTrackIndex',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );
    if (newTrackIndex != _currentTrackIndex) {
      _currentTrackIndex = newTrackIndex;
      await _player.seek(
        boundedPosition - _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
        index: _currentTrackIndex,
      );
      if (Platform.isWindows) {
        // Bugfix for Windows as it doesn't seek correctly if the index changed
        _player.playerStateStream
            .firstWhere(
              (state) => state.processingState == ProcessingState.ready,
            )
            .then((_) async {
              await _player.seek(
                boundedPosition -
                    _currentMediaItem!.startDurationForTrack(
                      _currentTrackIndex,
                    ),
              );
            });
      }
    } else {
      await _player.seek(
        boundedPosition - _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
      );
    }
    return Future.value();
  }

  BGAudioHandler(this._ref) {
    final settingManager = _ref.read(settingsManagerProvider.notifier);
    final bufferSize = settingManager.getGlobalSetting<int>(
      SettingKeys.bufferSize,
    );

    logger(
      'Buffer size: $bufferSize',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    final AndroidLoadControl androidLoadControl = AndroidLoadControl(
      minBufferDuration: Duration(seconds: 50),
      maxBufferDuration: Duration(seconds: 300),
      backBufferDuration: Duration(seconds: 120),
      targetBufferBytes: bufferSize,
    );

    JustAudioMediaKit.bufferSize = bufferSize;

    final DarwinLoadControl iOSLoadControl = DarwinLoadControl(
      // iOS does what iOS wants anyways
      preferredForwardBufferDuration: Duration(seconds: 300),
      canUseNetworkResourcesForLiveStreamingWhilePaused: false,
    );

    AudioLoadConfiguration loadCfg = AudioLoadConfiguration(
      androidLoadControl: androidLoadControl,
      darwinLoadControl: iOSLoadControl,
    );

    _player = AudioPlayer(audioLoadConfiguration: loadCfg);

    _errorSubscription = _player.errorStream.listen((error) {
      logger(
        'AudioPlayer error: $error',
        tag: 'AudioHandler',
        level: InfoLevel.error,
      );
      if (error.toString().contains('ffurl_read')) {
        logger(
          'Trying to reconnect to stream',
          tag: 'AudioHandler',
          level: InfoLevel.warning,
        );
        _syncedPlay();
      }
    });

    _syncService = PlaybackSyncService(this, _ref);
    _playerStateSubscription = _player.playerStateStream.listen((
      PlayerState state,
    ) async {
      if (_isDisposing) return;
      logger(state.toString(), tag: 'AudioHandler', level: InfoLevel.debug);

      if (state.processingState == ProcessingState.completed) {
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.stop);
      }
      if (state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering) {
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.pause);
      }
      if (state.playing && state.processingState == ProcessingState.ready) {
        PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.play);
      }

      if (state.processingState == ProcessingState.completed) {
        if (_currentMediaItem == null) return;
        logger(
          'Current track index: $_currentTrackIndex, total tracks: ${_currentMediaItem!.tracks.length}',
          tag: 'AudioHandler',
          level: InfoLevel.debug,
        );
        await _syncService.flush();
        await _ref.read(sessionRepositoryProvider).closeSession();

        if (queueList.isNotEmpty) {
          await play();
        } else {
          await _safePlayerStop();
        }
      }
      _updatePlaybackState();
    });
  }

  Future<dynamic> _setSource({Duration initialPosition = Duration.zero}) async {
    if (_currentMediaItem == null) return Future.value();
    final source = _currentMediaItem!.toAudioSources();
    final currentProgress = _ref.read(
      mediaProgressProvider.select((asyncValue) {
        return asyncValue.value?[_currentMediaItem!.itemId];
      }),
    );

    if (currentProgress != null) {
      initialPosition = Duration(
        microseconds:
            ((currentProgress.currentTime ?? 0) *
                    Duration.microsecondsPerSecond)
                .round(),
      );
    }

    logger(
      'Setting source with initial position: $initialPosition',
      tag: 'AudioHandler',
      level: InfoLevel.debug,
    );

    final trackIndex = _currentMediaItem!.getIndexForDuration(initialPosition);

    await player.setAudioSources(
      source,
      initialIndex: trackIndex,
      initialPosition: Duration.zero,
      preload: true,
    );
  }

  Future<void> _updatePlaybackState() async {
    final lockMediaNotification = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.lockMediaNotification);
    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: [
          MediaControl.rewind,
          MediaControl.pause,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        // Which other actions should be enabled in the notification
        systemActions: lockMediaNotification
            ? const {MediaAction.seekForward, MediaAction.seekBackward}
            : const {
                MediaAction.seek,
                MediaAction.seekForward,
                MediaAction.seekBackward,
              },
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState:
            (_player.processingState == ProcessingState.completed &&
                queueList.isNotEmpty)
            ? AudioProcessingState.loading
            : {
                ProcessingState.idle: AudioProcessingState.idle,
                ProcessingState.loading: AudioProcessingState.loading,
                ProcessingState.buffering: AudioProcessingState.buffering,
                ProcessingState.ready: AudioProcessingState.ready,
                ProcessingState.completed: AudioProcessingState.completed,
              }[_player.processingState]!,
        playing:
            (_player.processingState == ProcessingState.completed &&
                queueList.isNotEmpty)
            ? true
            : _player.playerState.playing,
        // The current position as of this update. You should not broadcast
        // position changes continuously because listeners will be able to
        // project the current position after any elapsed time based on the
        // current speed and whether audio is playing and ready. Instead, only
        // broadcast position updates when they are different from expected (e.g.
        // buffering, or seeking).
        updatePosition: _player.position,
        speed: _player.speed,
      ),
    );
  }

  Future<void> dispose() async {
    _isDisposing = true;
    await _errorSubscription?.cancel();
    _errorSubscription = null;
    await _playerStateSubscription?.cancel();
    _playerStateSubscription = null;
    await _syncService.dispose();
    await _player.dispose();
    await mediaItemStream.close();
    await _queueLengthSubject.close();
  }
}
