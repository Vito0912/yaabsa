import 'package:yaabsa/provider/wear/wear_preferences_provider.dart';

import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/provider/core/socket_provider.dart';
import 'package:yaabsa/provider/core/socket_work_policy.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/provider/player/session_provider.dart';
import 'package:yaabsa/util/audio_handler/playback_sync_service.dart';
import 'package:yaabsa/util/globals.dart' show containerRef;
import 'package:yaabsa/util/network/request_headers.dart';

class WearAudioHandler extends BaseAudioHandler {
  final AudioPlayer _player = AudioPlayer();
  late final PlaybackSyncService _syncService;
  late final StreamSubscription<PlayerState> _playerState;
  late final ProviderSubscription<String?> _accountSubscription;
  late final ProviderSubscription<MediaProgress?> _remoteProgressSubscription;
  late final ProviderSubscription<bool> _activitySubscription;
  late final StreamSubscription<PlayerException> _errors;
  late final ProviderSubscription<double> _speedSubscription;

  InternalMedia? _media;
  Future<void> _selectionQueue = Future<void>.value();
  int _selectionGeneration = 0;
  bool _disposed = false;

  WearAudioHandler() {
    _playerState = _player.playerStateStream.listen((state) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            if (state.playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: const {MediaAction.seek},
          androidCompactActionIndices: const [0, 1, 2],
          playing: state.playing,
          processingState: _map(state.processingState),
          updatePosition: position,
          speed: _player.speed,
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
      recordSmartDownloads: false,
    );
    _errors = _player.errorStream.listen(_reportPlaybackError);
    _remoteProgressSubscription = containerRef.listen<MediaProgress?>(remoteMediaProgressUpdateProvider, (_, progress) {
      if (progress != null) {
        unawaited(_followRemoteProgress(progress));
      }
    });
    _activitySubscription = containerRef.listen<bool>(socketInteractionActiveProvider, (previous, active) {
      if (active && previous == false) {
        unawaited(_refreshPausedProgress());
      }
    });
    _speedSubscription = containerRef.listen<double>(
      wearPreferencesProvider.select((preferences) => preferences.speed),
      (_, speed) {
        unawaited(_applySpeed(speed));
      },
      fireImmediately: true,
    );
    _accountSubscription = containerRef.listen<String?>(
      currentUserProvider.select((value) {
        final user = value.value;
        return user == null ? null : '${user.server?.url}/${user.id}';
      }),
      (previous, next) {
        if (previous != next) {
          _resetForAccountChange();
        }
      },
    );
  }

  Future<void> _applySpeed(double speed) async {
    try {
      await _player.setSpeed(speed);
      if (!_disposed) {
        playbackState.add(playbackState.value.copyWith(speed: speed, updatePosition: position));
      }
    } catch (error) {
      logger('Could not apply watch playback speed: $error', tag: 'WearAudio');
    }
  }

  void _resetForAccountChange() {
    _selectionGeneration += 1;
    final sessions = containerRef.read(sessionRepositoryProvider);
    final binding = sessions.currentSessionBinding;
    final flush = _syncService.flush(positionOverride: position, binding: binding, sessionClosing: true);
    _media = null;
    mediaItem.add(null);
    queue.add([]);
    unawaited(_player.stop());

    _selectionQueue = _selectionQueue
        .then((_) async {
          await flush;
          if (binding != null) {
            await sessions.closeSessionBinding(binding);
          }
        })
        .catchError((Object error) {
          logger('Could not finish previous watch account session: $error', tag: 'WearAudio');
        });
  }

  void _reportPlaybackError(Object error) {
    logger('Watch playback failed: $error', tag: 'WearAudio', level: InfoLevel.error);
    playbackState.add(
      playbackState.value.copyWith(
        processingState: AudioProcessingState.error,
        errorCode: 1,
        errorMessage: 'Playback failed. Check your connection or use a download.',
      ),
    );
  }

  Future<void> _followRemoteProgress(MediaProgress progress) async {
    final media = _media;
    if (_disposed ||
        media == null ||
        _player.playing ||
        progress.isFinished ||
        progress.libraryItemId != media.itemId ||
        progress.episodeId != media.episodeId) {
      return;
    }
    final target = Duration(milliseconds: (progress.currentTime * 1000).round());
    if ((target - position).abs() < const Duration(seconds: 5)) {
      return;
    }
    try {
      await seek(target);
    } catch (error) {
      logger('Could not follow remote watch progress: $error', tag: 'WearAudio');
    }
  }

  Future<void> _refreshPausedProgress() async {
    final media = _media;
    final generation = _selectionGeneration;
    final api = containerRef.read(absApiProvider);
    if (_disposed || media == null || api == null || _player.playing) {
      return;
    }
    try {
      final response = await api.getMeApi().getProgress(
        media.itemId,
        episodeId: media.episodeId,
        extra: const {'doNotCache': true},
      );
      final progress = response.data;
      if (progress != null && generation == _selectionGeneration) {
        await _followRemoteProgress(progress);
      }
    } catch (error) {
      logger('Could not refresh paused watch progress: $error', tag: 'WearAudio');
    }
  }

  AudioProcessingState _map(ProcessingState state) => switch (state) {
    ProcessingState.idle => AudioProcessingState.idle,
    ProcessingState.loading => AudioProcessingState.loading,
    ProcessingState.buffering => AudioProcessingState.buffering,
    ProcessingState.ready => AudioProcessingState.ready,
    ProcessingState.completed => AudioProcessingState.completed,
  };

  InternalMedia? get media => _media;
  AudioPlayer get player => _player;
  bool get isPlaying => _player.playing;

  Duration get position {
    final media = _media;
    final index = _player.currentIndex;
    if (media == null || index == null || index >= media.tracks.length) {
      return _player.position;
    }
    return media.offsetForTrack(index) + _player.position;
  }

  Future<void> openItem({required String itemId, String? episodeId}) {
    final generation = ++_selectionGeneration;
    final user = containerRef.read(currentUserProvider).value;
    final api = containerRef.read(absApiProvider);
    final operation = _selectionQueue.then((_) async {
      bool isCurrent() {
        final current = containerRef.read(currentUserProvider).value;
        return !_disposed &&
            generation == _selectionGeneration &&
            user != null &&
            current?.id == user.id &&
            current?.server?.url == user.server?.url;
      }

      if (!isCurrent()) {
        return;
      }
      if (_media?.itemId == itemId &&
          _media?.episodeId == episodeId &&
          playbackState.value.processingState != AudioProcessingState.error) {
        return;
      }

      final sessions = containerRef.read(sessionRepositoryProvider);
      await _player.pause();
      await _syncService.flush(sessionClosing: true);
      if (!isCurrent()) {
        return;
      }
      await _player.stop();
      _media = null;
      mediaItem.add(null);
      queue.add([]);
      final previousBinding = sessions.currentSessionBinding;
      if (previousBinding != null) {
        await sessions.closeSessionBinding(previousBinding, apiOverride: api);
      }
      if (!isCurrent()) {
        return;
      }

      try {
        final opened = await sessions.openSession(itemId, episodeId: episodeId, isCancelled: () => !isCurrent());
        if (!isCurrent()) {
          final binding = sessions.currentSessionBinding;
          if (binding != null) {
            await sessions.closeSessionBinding(binding, apiOverride: api);
          }
          return;
        }
        if (opened == null || opened.tracks.isEmpty) {
          throw const FormatException('This item cannot be played.');
        }

        final resumeSeconds = sessions.currentSession?.currentTime ?? 0;
        final resume = Duration(milliseconds: (resumeSeconds * 1000).round());
        await _loadInternalMedia(opened, initialPosition: resume);
        if (!isCurrent()) {
          await _player.stop();
          _media = null;
          mediaItem.add(null);
          queue.add([]);
        }
      } catch (_) {
        await _player.stop();
        _media = null;
        mediaItem.add(null);
        queue.add([]);
        final binding = sessions.currentSessionBinding;
        if (binding != null && binding.session.userId == user?.id) {
          await sessions.closeSessionBinding(binding, apiOverride: api);
        }
        rethrow;
      }
    });
    _selectionQueue = operation.catchError((Object _) {});
    return operation;
  }

  Future<void> _loadInternalMedia(InternalMedia media, {required Duration initialPosition}) async {
    final user = containerRef.read(currentUserProvider).value;
    final isHls = media.tracks.any((track) => track.mimeType.toLowerCase().contains('mpegurl'));
    final headers = buildRequestHeaders(
      serverHeaders: user?.server?.headers,
      bearerToken: isHls ? user?.preferredAuthToken : null,
    );
    final sources = media.toAudioSources(headers: headers);
    final target = initialPosition < Duration.zero ? Duration.zero : initialPosition;
    final bounded = target > media.totalDuration ? media.totalDuration : target;
    final index = media.getIndexForDuration(bounded);

    await _player.setAudioSources(sources, initialIndex: index, initialPosition: bounded - media.offsetForTrack(index));
    _media = media;
    playbackState.add(playbackState.value.copyWith(updatePosition: position));
    final item = media.toMediaItem(artHeaders: buildRequestHeaders(serverHeaders: user?.server?.headers));
    final cover = media.cover;
    final artwork = cover != null && (cover.scheme == 'https' || cover.scheme == 'http')
        ? cover.replace(queryParameters: {...cover.queryParameters, 'width': '256', 'height': '256'})
        : cover;
    final watchItem = item.copyWith(artUri: artwork);
    queue.add([watchItem]);
    mediaItem.add(watchItem);
  }

  Future<void> clearAccount() async {
    _selectionGeneration += 1;
    await _selectionQueue;
    await _player.pause();
    await _syncService.flush(sessionClosing: true);
    await _player.stop();
    await containerRef.read(sessionRepositoryProvider).closeSession();
    _media = null;
    queue.add([]);
    mediaItem.add(null);
  }

  @override
  Future<void> play() async {
    final selected = _media;
    if (selected == null) {
      return;
    }
    if (playbackState.value.processingState == AudioProcessingState.error) {
      try {
        await openItem(itemId: selected.itemId, episodeId: selected.episodeId);
      } catch (error) {
        _reportPlaybackError(error);
        return;
      }
    }
    if (_media != null) {
      unawaited(
        _player.play().catchError((Object error) {
          _reportPlaybackError(error);
        }),
      );
    }
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.pause();
    await _syncService.flush();
    await _player.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    final media = _media;
    if (media == null) {
      return;
    }
    var target = position < Duration.zero ? Duration.zero : position;
    if (target > media.totalDuration) {
      target = media.totalDuration;
    }
    final index = media.getIndexForDuration(target);
    await _player.seek(target - media.offsetForTrack(index), index: index);
  }

  @override
  Future<void> skipToNext() {
    final seconds = containerRef.read(wearPreferencesProvider).forwardSeconds;
    return seek(position + Duration(seconds: seconds));
  }

  @override
  Future<void> skipToPrevious() {
    final seconds = containerRef.read(wearPreferencesProvider).rewindSeconds;
    return seek(position - Duration(seconds: seconds));
  }

  Future<void> dispose() async {
    _disposed = true;
    _selectionGeneration += 1;
    _accountSubscription.close();
    _speedSubscription.close();
    _remoteProgressSubscription.close();
    _activitySubscription.close();
    await _errors.cancel();
    await _selectionQueue;
    await _syncService.dispose();
    await _playerState.cancel();
    await _player.dispose();
  }
}
