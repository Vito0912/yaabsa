import 'package:yaabsa/util/subtitles/subtitle_parser.dart';

Stream<Duration> subtitlePresentationUpdates({
  required Stream<Duration> positions,
  required ParsedSubtitleDocument document,
  required bool readAlongEnabled,
  bool useNearestCue = false,
}) {
  int cueIndex(Duration position) {
    final current = document.cueIndexAt(position);
    if (current < 0 && useNearestCue) {
      return document.nearestCueIndex(position);
    }
    return current;
  }

  return positions.distinct((previous, next) {
    final previousCue = cueIndex(previous);
    final nextCue = cueIndex(next);
    if (previousCue != nextCue) {
      return false;
    }
    if (!readAlongEnabled || nextCue < 0) {
      return true;
    }

    for (final segment in document.cues[nextCue].segments) {
      final wasActive = previous >= segment.start && previous < segment.end;
      final isActive = next >= segment.start && next < segment.end;
      if (wasActive != isActive) {
        return false;
      }
    }
    return true;
  });
}
