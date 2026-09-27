library;

class MediaOverlayClip {
  final String textHref;

  final double begin;

  final double end;

  const MediaOverlayClip({required this.textHref, required this.begin, required this.end});

  double get duration => end - begin;
}

class MediaOverlayAudioGroup {
  final String audioHref;

  final List<MediaOverlayClip> clips;

  const MediaOverlayAudioGroup({required this.audioHref, required this.clips});

  double get duration => clips.isEmpty ? 0.0 : clips.last.end - clips.first.begin;
}

class MediaOverlaySection {
  final int sectionIndex;

  final String smilHref;

  final List<MediaOverlayAudioGroup> audioGroups;

  const MediaOverlaySection({required this.sectionIndex, required this.smilHref, required this.audioGroups});

  bool get isEmpty => audioGroups.isEmpty;

  List<MediaOverlayFlatClip> flatten() {
    final result = <MediaOverlayFlatClip>[];
    for (var groupIndex = 0; groupIndex < audioGroups.length; groupIndex++) {
      final group = audioGroups[groupIndex];
      for (final clip in group.clips) {
        result.add(MediaOverlayFlatClip(sectionIndex: sectionIndex, groupIndex: groupIndex, clip: clip));
      }
    }
    return result;
  }
}

class MediaOverlayFlatClip {
  final int sectionIndex;
  final int groupIndex;
  final MediaOverlayClip clip;

  const MediaOverlayFlatClip({required this.sectionIndex, required this.groupIndex, required this.clip});
}

class MediaOverlayBookTrack {
  final int sectionIndex;
  final MediaOverlayAudioGroup group;

  const MediaOverlayBookTrack({required this.sectionIndex, required this.group});
}
