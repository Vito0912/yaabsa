/// Data model for an EPUB3 media-overlay (SMIL) synchronized-narration sync table.
///
/// Mirrors the shape already computed today in JS inside the reader WebView
/// (`packages/foliate_reader/assets/reader-app.js`), but built here in plain
/// Dart with no WebView dependency, so the same sync table can drive playback
/// from contexts that have no WebView at all (Android Auto, Wear OS,
/// background playback).
library;

/// One `<par>` element from a SMIL file: a single synchronized clip of audio
/// mapped to a fragment of book text.
class MediaOverlayClip {
  /// The book-relative href + fragment identifying the synced text, exactly
  /// as it appears in the SMIL `<text src="...">` attribute (already resolved
  /// relative to the SMIL file's own location), e.g. `chapter1.xhtml#sent3`.
  final String textHref;

  /// Start of the clip within its audio file, in seconds.
  final double begin;

  /// End of the clip within its audio file, in seconds.
  final double end;

  const MediaOverlayClip({required this.textHref, required this.begin, required this.end});

  double get duration => end - begin;
}

/// A run of contiguous [MediaOverlayClip]s that all point at the same audio
/// file, in the order they appear in the SMIL file.
class MediaOverlayAudioGroup {
  /// Book-relative href to the audio file, resolved relative to the SMIL
  /// file's own location, e.g. `audio/chapter1.mp3`.
  final String audioHref;

  final List<MediaOverlayClip> clips;

  const MediaOverlayAudioGroup({required this.audioHref, required this.clips});

  /// Duration of just this group's own slice of [audioHref] — i.e. the span
  /// from its first clip's start to its last clip's end. This is NOT
  /// necessarily `clips.last.end` alone: several groups (in the same or
  /// different sections) can reference the same physical audio file at
  /// different, non-zero-based offset ranges (e.g. one recording spanning a
  /// chapter boundary), so `clips.first.begin` must be treated as this
  /// group's own starting offset within that file, not assumed to be 0.
  double get duration => clips.isEmpty ? 0.0 : clips.last.end - clips.first.begin;
}

/// The full sync table for one spine section (one SMIL file), i.e. one
/// chapter/document's worth of narration, potentially spanning several
/// distinct audio files.
class MediaOverlaySection {
  /// Index of this section within the EPUB's spine.
  final int sectionIndex;

  /// Book-relative href of the SMIL file this section was parsed from.
  final String smilHref;

  final List<MediaOverlayAudioGroup> audioGroups;

  const MediaOverlaySection({required this.sectionIndex, required this.smilHref, required this.audioGroups});

  bool get isEmpty => audioGroups.isEmpty;

  /// Flattened, in-order list of clips across all audio groups in this
  /// section, each tagged with which audio group (and thus audio file) it
  /// belongs to.
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

/// A [MediaOverlayClip] together with enough context (section + audio-group
/// index) to resolve which audio file it belongs to and where within the
/// book-wide track list that audio file lives.
class MediaOverlayFlatClip {
  final int sectionIndex;
  final int groupIndex;
  final MediaOverlayClip clip;

  const MediaOverlayFlatClip({required this.sectionIndex, required this.groupIndex, required this.clip});
}

/// One audio file's worth of narration, in book-wide (spine) order — i.e.
/// one entry per [MediaOverlayAudioGroup] across every narrated section,
/// concatenated. This is the book-wide analog of [MediaOverlayFlatClip]:
/// each entry here becomes exactly one track in the whole-book
/// `InternalMedia`, so playback and its seek bar span the entire audiobook
/// rather than restarting per section.
class MediaOverlayBookTrack {
  final int sectionIndex;
  final MediaOverlayAudioGroup group;

  const MediaOverlayBookTrack({required this.sectionIndex, required this.group});
}
