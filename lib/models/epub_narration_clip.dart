import 'package:yaabsa/api/json/value_parsers.dart';

class EpubNarrationClip {
  const EpubNarrationClip({
    required this.path,
    required this.begin,
    required this.end,
    required this.target,
    required this.sectionIndex,
    this.isStart = false,
    this.mimeType = 'audio/mpeg',
  });

  factory EpubNarrationClip.fromMap(Map<String, dynamic> value) {
    final begin = jsonDoubleRequiredFromDynamic(value['begin']);
    final end = jsonDoubleRequiredFromDynamic(value['end']);
    final path = jsonStringFromDynamic(value['path']) ?? '';
    final target = jsonStringFromDynamic(value['target']) ?? '';

    if (path.isEmpty || target.isEmpty || !begin.isFinite || !end.isFinite || begin < 0 || end <= begin) {
      throw const FormatException('Invalid EPUB narration interval');
    }

    return EpubNarrationClip(
      path: path,
      begin: begin,
      end: end,
      target: target,
      sectionIndex: jsonIntRequiredFromDynamic(value['sectionIndex']),
      isStart: jsonBoolRequiredFromDynamic(value['isStart']),
      mimeType: jsonStringFromDynamic(value['mimeType']) ?? 'audio/mpeg',
    );
  }

  final String path;
  final double begin;
  final double end;
  final String target;
  final int sectionIndex;
  final bool isStart;
  final String mimeType;

  double get duration => end - begin;
}
