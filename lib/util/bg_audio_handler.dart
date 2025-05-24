import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:buchshelfly/database/settings_manager.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/common/media_progress_provider.dart';
import 'package:buchshelfly/provider/player/session_provider.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/playback_sync_service.dart';
import 'package:buchshelfly/util/setting_key.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:rxdart/transformers.dart';

class BGAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  late final AudioPlayer _player;
  final ProviderContainer _ref;
  late final PlaybackSyncService _syncService;
  List<QueueItem> queueList = [];

  static get maxVolume {
    if (Platform.isAndroid) {
      return 2.0;
    }
    return 1.0;
  }

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

  Stream<bool> get shouldShowPlayer {
    return _player.playerStateStream.map((state) => _currentMediaItem != null).distinct();
  }

  @override
  Future<void> play() async {
    print(_currentMediaItem);
    if (_currentMediaItem != null) await _syncedPlay();

    QueueItem? tmp = queueList.isNotEmpty ? queueList.removeAt(0) : null;
    if (tmp == null) return Future.value();
    _currentMediaItem = await _ref.read(sessionRepositoryProvider).openSession(tmp.itemId);
    if (_currentMediaItem == null) {
      logger('No media item found for ID: ${tmp.itemId}', tag: 'AudioHandler', level: InfoLevel.error);
      return Future.value();
    }
    logger('Playing item: ${_currentMediaItem!.itemId}', tag: 'AudioHandler', level: InfoLevel.debug);
    await _setSource();
    logger('Setting source for item: ${_currentMediaItem!.itemId}', tag: 'AudioHandler', level: InfoLevel.debug);
    await _syncedPlay();
  }

  Future<void> _syncedPlay() async {
    mediaItem.add(_currentMediaItem?.toMediaItem());
    final bool waitForSync = true;
    Duration currentPosition = Duration.zero;

    if (_currentMediaItem == null) return Future.value();

    if (waitForSync) {
      final progress = await _ref
          .read(mediaProgressNotifierProvider.notifier)
          .fetchOrRefreshIndividualProgress(_currentMediaItem!.itemId);

      currentPosition = Duration(microseconds: ((progress?.currentTime ?? 0) * Duration.microsecondsPerSecond).round());

      logger(
        'Current position: $currentPosition, player position: ${_player.position}, progress: ${progress?.currentTime}',
        tag: 'AudioHandler',
        level: InfoLevel.debug,
      );

      await seek(currentPosition);
      await _player.play();
    } else {
      await _player.play();

      final progress = await _ref
          .read(mediaProgressNotifierProvider.notifier)
          .fetchOrRefreshIndividualProgress(_currentMediaItem!.itemId);

      currentPosition = Duration(microseconds: ((progress?.currentTime ?? 0) * Duration.microsecondsPerSecond).round());

      if ((currentPosition - _player.position).abs() >= const Duration(seconds: 10)) {
        await seek(currentPosition);
      }
    }
  }

  @override
  Future<void> stop() async {
    _currentMediaItem = null;
    _currentTrackIndex = 0;
    queueList.clear();
    try {
      await _syncService.flush();
      await _ref.read(sessionRepositoryProvider).closeSession();
    } catch (e) {
      logger('Error closing session: $e', tag: 'AudioHandler', level: InfoLevel.error);
    }

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
    logger('Seeking to position: $position, track index: $newTrackIndex', tag: 'AudioHandler', level: InfoLevel.debug);
    if (newTrackIndex != _currentTrackIndex) {
      _currentTrackIndex = newTrackIndex;
      await _player.seek(
        position - _currentMediaItem!.startDurationForTrack(_currentTrackIndex),
        index: _currentTrackIndex,
      );
      if (Platform.isWindows) {
        // Bugfix for Windows as it doesn't seek correctly if the index changed
        _player.playerStateStream.firstWhere((state) => state.processingState == ProcessingState.ready).then((_) async {
          await _player.seek(position - _currentMediaItem!.startDurationForTrack(_currentTrackIndex));
        });
      }
    } else {
      await _player.seek(position - _currentMediaItem!.startDurationForTrack(_currentTrackIndex));
    }
    return Future.value();
  }

  BGAudioHandler(this._ref) {
    final settingManager = _ref.read(settingsManagerProvider.notifier);
    final bufferSize = settingManager.getGlobalSetting<int>(SettingKeys.bufferSize);

    logger('Buffer size: $bufferSize', tag: 'AudioHandler', level: InfoLevel.debug);

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

    _player.errorStream.listen((error) {
      logger('AudioPlayer error: $error', tag: 'AudioHandler', level: InfoLevel.error);
      if (error.toString().contains('ffurl_read')) {
        logger('Trying to reconnect to stream', tag: 'AudioHandler', level: InfoLevel.warning);
        _syncedPlay();
      }
    });

    _syncService = PlaybackSyncService(this, _ref);
    _player.playerStateStream.listen((PlayerState state) async {
      logger(state.toString(), tag: 'AudioHandler', level: InfoLevel.debug);
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
          await _player.stop();
          //await _player.dispose();
        }
      }
      _updatePlaybackState();
    });
  }

  _setSource({Duration initialPosition = Duration.zero}) async {
    if (_currentMediaItem == null) return Future.value();
    final source = _currentMediaItem!.toAudioSources();
    final currentProgress = _ref.read(
      mediaProgressNotifierProvider.select((asyncValue) {
        return asyncValue.value?[_currentMediaItem!.itemId];
      }),
    );

    if (currentProgress != null) {
      initialPosition = Duration(
        microseconds: ((currentProgress.currentTime ?? 0) * Duration.microsecondsPerSecond).round(),
      );
    }

    logger('Setting source with initial position: $initialPosition', tag: 'AudioHandler', level: InfoLevel.debug);

    final trackIndex = _currentMediaItem!.getIndexForDuration(initialPosition);

    await player.setAudioSources(source, initialIndex: trackIndex, initialPosition: Duration.zero, preload: true);
  }

  _updatePlaybackState() async {
    final lockMediaNotification = _ref
        .read(settingsManagerProvider.notifier)
        .getGlobalSetting<bool>(SettingKeys.lockMediaNotification);
    playbackState.add(
      PlaybackState(
        // Which buttons should appear in the notification now
        controls: [MediaControl.rewind, MediaControl.pause, MediaControl.stop, MediaControl.fastForward],
        // Which other actions should be enabled in the notification
        systemActions:
            lockMediaNotification
                ? const {MediaAction.seekForward, MediaAction.seekBackward}
                : const {MediaAction.seek, MediaAction.seekForward, MediaAction.seekBackward},
        // Which controls to show in Android's compact view.
        androidCompactActionIndices: const [0, 1, 3],
        // Whether audio is ready, buffering, ...
        processingState:
            (_player.processingState == ProcessingState.completed && queueList.isNotEmpty)
                ? AudioProcessingState.loading
                : {
                  ProcessingState.idle: AudioProcessingState.idle,
                  ProcessingState.loading: AudioProcessingState.loading,
                  ProcessingState.buffering: AudioProcessingState.buffering,
                  ProcessingState.ready: AudioProcessingState.ready,
                  ProcessingState.completed: AudioProcessingState.completed,
                }[_player.processingState]!,
        playing:
            (_player.processingState == ProcessingState.completed && queueList.isNotEmpty)
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
}
