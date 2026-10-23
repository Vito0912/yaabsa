import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/reader/reader_speech_chunk.dart';

class ReaderSpeechTimeline {
  ReaderSpeechTimeline(this.sentences) {
    for (var index = 0; index < sentences.length; index++) {
      final sentence = sentences[index];
      final fraction = double.tryParse(sentence['fraction'] ?? '');
      _progressByCfi[sentence['cfi'] ?? ''] = fraction != null && fraction.isFinite
          ? fraction.clamp(0.0, 1.0)
          : index / sentences.length;
    }

    for (var start = 0; start < sentences.length;) {
      var end = start + 1;

      while (end < sentences.length && sentences[end]['section'] == sentences[start]['section']) {
        end++;
      }

      final sectionChunks = ReaderSpeechChunk.fromSentences(sentences.sublist(start, end));

      chunks.addAll(
        sectionChunks.map(
          (chunk) => ReaderSpeechChunk(
            text: chunk.text,
            firstSentence: start + chunk.firstSentence,
            boundaries: chunk.boundaries
                .map((boundary) => (offset: boundary.offset, sentence: start + boundary.sentence))
                .toList(),
          ),
        ),
      );
      start = end;
    }

    _measured = List.filled(chunks.length, null);
    _units = chunks.map((chunk) => _speechUnits(chunk.text)).toList();
    _unmeasuredCount = chunks.length;
    _rebuild();
  }

  final List<Map<String, String>> sentences;
  final List<ReaderSpeechChunk> chunks = [];
  final Map<String, double> _progressByCfi = {};

  double progressForCfi(String cfi) => _progressByCfi[cfi] ?? 0;

  late final List<Duration?> _measured;
  late final List<double> _units;
  late int _unmeasuredCount;

  final List<Duration> starts = [];
  final List<Duration> durations = [];
  final List<InternalChapter> chapters = [];
  double _secondsPerUnit = 0.06;

  Duration get duration => starts.last + durations.last;

  bool get isEstimated => _unmeasuredCount > 0;

  static final _cjkCharacters = RegExp(r'[\u3040-\u30ff\u3400-\u9fff\uac00-\ud7af]');

  double _speechUnits(String text) => text.length + _cjkCharacters.allMatches(text).length * 3.0;

  int indexAt(Duration position) {
    var left = 0;
    var right = starts.length - 1;

    while (left < right) {
      final middle = (left + right + 1) ~/ 2;

      if (starts[middle] <= position) {
        left = middle;
      } else {
        right = middle - 1;
      }
    }

    return left;
  }

  int offsetAt(int index, Duration position) {
    final fraction = position.inMicroseconds / durations[index].inMicroseconds;
    final offset = (fraction * chunks[index].text.length).round().clamp(0, chunks[index].text.length);

    return chunks[index].boundaries.lastWhere((boundary) => boundary.offset <= offset).offset;
  }

  String cfiAt(int index, int offset) => sentences[chunks[index].sentenceAt(offset)]['cfi'] ?? '';

  ({int index, int offset})? anchorForCfi(String cfi) {
    for (var index = 0; index < chunks.length; index++) {
      for (final boundary in chunks[index].boundaries) {
        if (sentences[boundary.sentence]['cfi'] == cfi) {
          return (index: index, offset: boundary.offset);
        }
      }
    }

    return null;
  }

  ({int index, int offset}) get initialAnchor {
    final sentence = sentences.indexWhere((sentence) => sentence['isStart'] == 'true');

    if (sentence < 0) {
      return (index: 0, offset: 0);
    }

    return anchorForCfi(sentences[sentence]['cfi'] ?? '') ?? (index: 0, offset: 0);
  }

  void measure(int index, Duration duration) {
    if (duration <= Duration.zero || _measured[index] != null) {
      return;
    }

    _measured[index] = duration;
    _unmeasuredCount--;

    final observed = (duration.inMicroseconds / 1e6 / _units[index]).clamp(0.015, 0.25);

    _secondsPerUnit = _secondsPerUnit * 0.7 + observed * 0.3;
    _rebuild();
  }

  void _rebuild() {
    starts.clear();
    durations.clear();
    chapters.clear();

    var position = Duration.zero;
    String? previousSection;

    for (var index = 0; index < chunks.length; index++) {
      final chunk = chunks[index];
      final duration = _measured[index] ?? Duration(microseconds: (_units[index] * _secondsPerUnit * 1e6).round());

      starts.add(position);
      durations.add(duration);

      final sentence = sentences[chunk.firstSentence];
      final section = sentence['section'];
      final start = position.inMicroseconds / 1e6;

      position += duration;

      final end = position.inMicroseconds / 1e6;

      if (chapters.isNotEmpty && section == previousSection) {
        chapters[chapters.length - 1] = chapters.last.copyWith(end: end);
      } else {
        chapters.add(
          InternalChapter(start: start, end: end, title: sentence['title'] ?? 'Chapter ${chapters.length + 1}'),
        );
      }

      previousSection = section;
    }
  }
}
