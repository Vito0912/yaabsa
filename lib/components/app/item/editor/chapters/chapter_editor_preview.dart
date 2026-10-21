import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/util/globals.dart';

class ChapterEditorPreview {
  final activeKey = ValueNotifier<int?>(null);
  AudioPlayer? _player;
  Timer? _timer;
  var _generation = 0;
  var _disposed = false;

  Future<void> play({
    required int key,
    required double start,
    required double end,
    required String itemId,
    required List<AudioFile> files,
    required ABSApi api,
  }) async {
    final wasPlaying = activeKey.value == key;
    await stop();
    if (wasPlaying || _disposed) {
      return;
    }

    final generation = _generation;
    var offset = 0.0;
    AudioFile? source;
    for (final file in files) {
      final duration = file.duration ?? 0;
      if (start >= offset && start < offset + duration) {
        source = file;
        break;
      }
      offset += duration;
    }
    if (source == null) {
      throw StateError('No audio track is available at this chapter start.');
    }

    activeKey.value = key;
    if (isAudioHandlerInitialized) {
      await audioHandler.pause();
    }
    if (_disposed || generation != _generation) {
      return;
    }

    final base = api.basePathOverride.replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.parse('$base/api/items/${Uri.encodeComponent(itemId)}/file/${Uri.encodeComponent(source.ino)}')
        .replace(queryParameters: {if (api.token != null) 'token': api.token!});
    final headers = <String, String>{
      for (final entry in api.dio.options.headers.entries) entry.key: entry.value.toString(),
    };
    final player = _player ??= AudioPlayer(handleInterruptions: false);

    try {
      await player.setAudioSources([
        AudioSource.uri(uri, headers: headers),
      ], initialPosition: Duration(microseconds: ((start - offset) * 1000000).round()));
      if (_disposed || generation != _generation) {
        return;
      }

      final previewSeconds = math.min(20.0, math.min(end - start, offset + (source.duration ?? 0) - start));
      _timer = Timer(Duration(microseconds: (previewSeconds * 1000000).round()), () => unawaited(stop()));
      unawaited(_play(player, generation));
    } catch (_) {
      if (!_disposed && generation == _generation) {
        await stop();
        rethrow;
      }
    }
  }

  Future<void> _play(AudioPlayer player, int generation) async {
    try {
      await player.play();
    } catch (_) {
      if (!_disposed && generation == _generation) {
        await stop();
      }
    }
  }

  Future<void> stop() async {
    _generation++;
    _timer?.cancel();
    _timer = null;
    if (!_disposed) {
      activeKey.value = null;
    }
    await _player?.stop();
  }

  void dispose() {
    _disposed = true;
    _generation++;
    _timer?.cancel();
    final player = _player;
    _player = null;
    if (player != null) {
      unawaited(player.dispose());
    }
    activeKey.dispose();
  }
}
