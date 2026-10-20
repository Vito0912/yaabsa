import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_api.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_clip.dart';
import 'package:yaabsa/util/reader/reader_speech_engine.dart';

class ElevenLabsReaderSpeechEngine implements ReaderSpeechEngine {
  ElevenLabsReaderSpeechEngine({required this.api, required this.readModel});

  final ElevenLabsSpeechApi api;
  final String Function() readModel;
  AudioPlayer? _player;
  Directory? _directory;
  int _generation = 0;
  int _fileSequence = 0;
  Completer<void>? _playbackCancellation;
  final Set<CancelToken> _requests = {};
  final Set<Future<ElevenLabsSpeechClip>> _syntheses = {};
  final List<({String id, DateTime created})> _previousIds = [];
  (String, String, String, String, double)? _configuration;
  String? _previousText;
  ({String text, Future<ElevenLabsSpeechClip> future})? _prefetched;

  Future<ElevenLabsSpeechClip> _synthesize({
    required ReaderSpeechRequest request,
    required String key,
    required String model,
    required Directory directory,
    required int generation,
  }) {
    _previousIds.removeWhere((entry) => DateTime.now().difference(entry.created) >= const Duration(hours: 2));

    final ids = _previousIds.map((entry) => entry.id).toList();
    final future = _generateClip(
      request: request,
      key: key,
      model: model,
      previousIds: ids,
      directory: directory,
      generation: generation,
    );

    _syntheses.add(future);
    future.whenComplete(() => _syntheses.remove(future)).ignore();

    return future;
  }

  Future<ElevenLabsSpeechClip> _generateClip({
    required ReaderSpeechRequest request,
    required String key,
    required String model,
    required List<String> previousIds,
    required Directory directory,
    required int generation,
  }) async {
    if (generation != _generation) {
      throw const ElevenLabsSpeechException('Speech was cancelled');
    }

    final token = CancelToken();

    _requests.add(token);

    try {
      final response = await api.synthesize(
        request: request,
        apiKey: key,
        model: model,
        previousRequestIds: previousIds,
        cancelToken: token,
      );

      if (generation != _generation) {
        throw const ElevenLabsSpeechException('Speech was cancelled');
      }

      final clip = await ElevenLabsSpeechClip.fromResponse(
        response: response,
        text: request.text,
        file: File('${directory.path}/${_fileSequence++}.mp3'),
      );

      if (generation != _generation) {
        throw const ElevenLabsSpeechException('Speech was cancelled');
      }

      return clip;
    } finally {
      _requests.remove(token);
    }
  }

  @override
  Future<void> speak(ReaderSpeechRequest request) async {
    final generation = _generation;
    ElevenLabsSpeechClip? clip;

    try {
      final key = await api.requireApiKey();

      if (generation != _generation) {
        return;
      }

      final model = readModel();

      if (!isAllowedElevenLabsModel(model)) {
        throw const ElevenLabsSpeechException('Choose a v2 or v4 ElevenLabs model');
      }

      final configuration = (key, model, request.voice, request.language, request.rate);

      if (_configuration != configuration || (_previousText != null && request.previousText != _previousText)) {
        await _discardPrefetch();

        if (generation != _generation) {
          return;
        }

        _previousIds.clear();
      }

      _configuration = configuration;

      final directory = _directory ?? await Directory.systemTemp.createTemp('yaabsa-elevenlabs-');

      if (generation != _generation) {
        if (await directory.exists()) {
          await directory.delete(recursive: true);
        }

        return;
      }

      _directory = directory;

      final prefetched = _prefetched;

      _prefetched = null;

      if (prefetched != null && prefetched.text == request.text) {
        clip = await prefetched.future;
      } else {
        if (prefetched != null) {
          try {
            final discarded = await prefetched.future;

            if (await discarded.file.exists()) {
              await discarded.file.delete();
            }
          } catch (_) {}
        }

        if (generation != _generation) {
          return;
        }

        clip = await _synthesize(
          request: request,
          key: key,
          model: model,
          directory: directory,
          generation: generation,
        );
      }

      if (generation != _generation) {
        return;
      }

      _previousIds.add((id: clip.requestId, created: clip.createdAt));

      if (_previousIds.length > 3) {
        _previousIds.removeAt(0);
      }

      _previousText = request.text;

      final player = _player ??= AudioPlayer();

      await player.setFilePath(clip.file.path);

      if (generation != _generation) {
        return;
      }

      await player.setSpeed(request.rate.clamp(0.5, 2.0));

      if (generation != _generation) {
        return;
      }

      if (request.nextText?.isNotEmpty == true) {
        final next = ReaderSpeechRequest(
          text: request.nextText!,
          language: request.language,
          voice: request.voice,
          rate: request.rate,
          previousText: request.text,
          nextText: request.nextNextText,
        );
        final future = _synthesize(request: next, key: key, model: model, directory: directory, generation: generation);

        future.ignore();
        _prefetched = (text: next.text, future: future);
      }

      await _playClip(player, clip, request, generation);
    } catch (_) {
      if (generation == _generation) {
        rethrow;
      }
    } finally {
      if (generation == _generation && clip != null) {
        await _player?.clearAudioSources();

        if (await clip.file.exists()) {
          await clip.file.delete();
        }
      }
    }
  }

  Future<void> _playClip(
    AudioPlayer player,
    ElevenLabsSpeechClip clip,
    ReaderSpeechRequest request,
    int generation,
  ) async {
    final completed = Completer<void>();
    final cancelled = Completer<void>();

    _playbackCancellation = cancelled;

    var lastIndex = -1;
    final positionSubscription = player
        .createPositionStream(minPeriod: const Duration(milliseconds: 50), maxPeriod: const Duration(milliseconds: 100))
        .listen((position) {
          if (generation != _generation) {
            return;
          }

          final index = clip.timingIndexAt(position);

          if (index < 0 || index == lastIndex) {
            return;
          }

          lastIndex = index;

          final timing = clip.timings[index];

          request.onProgress?.call(timing.start, timing.end);
        });
    final stateSubscription = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed && !completed.isCompleted) {
        completed.complete();
      }
    });
    final errorSubscription = player.errorStream.listen((error) {
      if (!completed.isCompleted) {
        completed.completeError(const ElevenLabsSpeechException('Could not play ElevenLabs audio'));
      }
    });

    try {
      final waiting = Future.any<void>([completed.future, cancelled.future]);

      player.play().catchError((Object error) {
        if (!completed.isCompleted) {
          completed.completeError(const ElevenLabsSpeechException('Could not play ElevenLabs audio'));
        }
      }).ignore();
      await waiting;
    } finally {
      if (identical(_playbackCancellation, cancelled)) {
        _playbackCancellation = null;
      }

      await positionSubscription.cancel();
      await stateSubscription.cancel();
      await errorSubscription.cancel();
    }
  }

  Future<void> _discardPrefetch() async {
    final prefetched = _prefetched;

    _prefetched = null;

    if (prefetched == null) {
      return;
    }

    try {
      final clip = await prefetched.future;

      if (await clip.file.exists()) {
        await clip.file.delete();
      }
    } catch (_) {}
  }

  @override
  Future<void> stop() async {
    _generation++;

    for (final token in _requests.toList()) {
      token.cancel();
    }

    final cancellation = _playbackCancellation;

    _playbackCancellation = null;

    if (cancellation != null && !cancellation.isCompleted) {
      cancellation.complete();
    }

    _previousIds.clear();
    _configuration = null;
    _previousText = null;
    _prefetched = null;

    final directory = _directory;

    _directory = null;

    final player = _player;

    _player = null;
    await player?.stop();
    await player?.dispose();
    await Future.wait(
      _syntheses.toList().map((future) => future.then<Object?>((clip) => clip, onError: (Object _) => null)),
    );

    if (directory != null && await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  @override
  Future<void> dispose() => stop();

  @override
  Future<List<String>> languages() async {
    final models = await api.models();

    return models.where((model) => model.id == readModel()).firstOrNull?.languages.keys.toList() ?? const [];
  }

  @override
  Future<List<Map<String, String>>> voices() => api.voices();
}
