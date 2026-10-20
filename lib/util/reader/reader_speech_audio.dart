import 'dart:io';

import 'package:yaabsa/util/reader/reader_speech_engine.dart';

class ReaderSpeechAudio {
  const ReaderSpeechAudio({required this.file, required this.timings});

  final File file;
  final List<({double time, int start, int end})> timings;

  int offsetAt(Duration position) {
    final seconds = position.inMicroseconds / 1e6;
    var left = 0;
    var right = timings.length - 1;
    var result = 0;

    while (left <= right) {
      final middle = (left + right) ~/ 2;

      if (timings[middle].time <= seconds) {
        result = timings[middle].start;
        left = middle + 1;
      } else {
        right = middle - 1;
      }
    }

    return result;
  }

  Duration positionForOffset(int offset) {
    final timing = timings.where((timing) => timing.end > offset).firstOrNull;

    return Duration(microseconds: ((timing?.time ?? 0) * 1e6).round());
  }
}

abstract interface class ReaderSpeechAudioGenerator {
  Future<ReaderSpeechAudio> generate(ReaderSpeechRequest request, File file);
  Future<void> reset();
}
