import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/util/reader/elevenlabs/elevenlabs_speech_api.dart';

class ElevenLabsSpeechClip {
  const ElevenLabsSpeechClip({
    required this.file,
    required this.requestId,
    required this.timings,
    required this.createdAt,
  });

  final File file;
  final String requestId;
  final DateTime createdAt;
  final List<({double time, int start, int end})> timings;

  static Future<ElevenLabsSpeechClip> fromResponse({
    required Response<dynamic> response,
    required String text,
    required File file,
  }) async {
    final data = response.data;
    final audio = data is Map ? jsonStringFromDynamic(data['audio_base64']) : null;
    final requestId = response.headers.value('request-id');

    if (requestId == null || requestId.isEmpty) {
      throw const ElevenLabsSpeechException('ElevenLabs did not return a request ID for stitched speech');
    }
    if (audio == null || audio.isEmpty) {
      throw const ElevenLabsSpeechException('ElevenLabs returned no speech audio');
    }

    try {
      final bytes = base64Decode(audio);

      if (bytes.isEmpty) {
        throw const FormatException();
      }

      await file.writeAsBytes(bytes, flush: true);
    } on FormatException {
      throw const ElevenLabsSpeechException('ElevenLabs returned invalid speech audio');
    }

    final timings = <({double time, int start, int end})>[];
    final alignment = data['alignment'];

    if (alignment is Map && alignment['characters'] is List && alignment['character_start_times_seconds'] is List) {
      final characters = jsonStringListFromDynamic(alignment['characters']);
      final starts = alignment['character_start_times_seconds'] as List;

      if (characters.join() == text && starts.length == characters.length) {
        var offset = 0;
        var lastTime = 0.0;

        for (var index = 0; index < characters.length; index++) {
          final time = jsonDoubleFromDynamic(starts[index]);

          if (time == null || !time.isFinite || time < lastTime) {
            timings.clear();
            break;
          }

          final end = offset + characters[index].length;

          timings.add((time: time, start: offset, end: end));
          offset = end;
          lastTime = time;
        }
      }
    }

    return ElevenLabsSpeechClip(file: file, requestId: requestId, timings: timings, createdAt: DateTime.now());
  }

  int timingIndexAt(Duration position) {
    final seconds = position.inMicroseconds / 1e6;
    var left = 0;
    var right = timings.length - 1;
    var result = -1;

    while (left <= right) {
      final middle = (left + right) ~/ 2;

      if (timings[middle].time <= seconds) {
        result = middle;
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }

    return result;
  }
}
