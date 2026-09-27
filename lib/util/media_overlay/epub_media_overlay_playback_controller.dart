import 'dart:io';

import 'package:path/path.dart' as p;

import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/audio_handler/bg_audio_handler.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/media_overlay/epub_media_overlay_engine.dart';
import 'package:yaabsa/util/media_overlay/epub_media_overlay_models.dart';

class EpubMediaOverlayPlaybackController {
  EpubMediaOverlayPlaybackController({
    required this.engine,
    required this.itemId,
    required this.libraryId,
    required this.title,
    required this.extractionDir,
    this.author,
    this.narrator,
    this.series,
    this.seriesPosition,
    this.cover,
  });

  final EpubMediaOverlayEngine engine;
  final String itemId;
  final String libraryId;
  final String title;
  final String? author;
  final String? narrator;
  final String? series;
  final String? seriesPosition;
  final Uri? cover;

  final Directory extractionDir;

  final Map<String, String> _extractedPathByHref = {};

  List<MediaOverlayBookTrack>? _bookTracks;
  InternalMedia? _bookMedia;

  bool get isActive => _bookMedia != null && audioHandler.isPlayingEphemeralMedia;

  int? get activeSectionIndex {
    final media = _bookMedia;
    final tracks = _bookTracks;
    if (media == null || tracks == null || !audioHandler.isPlayingEphemeralMedia) return null;
    final trackIndex = media.getIndexForDuration(audioHandler.position);
    if (trackIndex < 0 || trackIndex >= tracks.length) return null;
    return tracks[trackIndex].sectionIndex;
  }

  Future<bool> playSection(int sectionIndex, {Duration initialPosition = Duration.zero}) async {
    final prepared = await _ensureBookMedia();
    if (prepared == null) return false;
    final (media, tracks) = prepared;

    final trackIndex = _firstTrackIndexAtOrAfterSection(tracks, sectionIndex);
    if (trackIndex == null) return false;

    final target =
        media.offsetForTrack(trackIndex) +
        (tracks[trackIndex].sectionIndex == sectionIndex ? initialPosition : Duration.zero);
    return _playOrSeek(media, target);
  }

  Future<bool> seekToTextHref(int sectionIndex, String textHref) async {
    final prepared = await _ensureBookMedia();
    if (prepared == null) return false;
    final (media, tracks) = prepared;

    for (var trackIndex = 0; trackIndex < tracks.length; trackIndex++) {
      final group = tracks[trackIndex].group;
      if (tracks[trackIndex].sectionIndex != sectionIndex) continue;
      for (final clip in group.clips) {
        if (clip.textHref == textHref) {
          final localSeconds = clip.begin - group.clips.first.begin;
          final target = media.offsetForTrack(trackIndex) + Duration(microseconds: (localSeconds * 1e6).round());
          return _playOrSeek(media, target);
        }
      }
    }
    return false;
  }

  Future<void> pause() => audioHandler.pause();

  Future<void> resume() => audioHandler.play();

  Future<void> stop() async {
    if (audioHandler.isPlayingEphemeralMedia) {
      await audioHandler.stop();
    }
  }

  double? bookFractionAtGlobalPosition(Duration globalPosition) {
    final media = _bookMedia;
    if (media == null) return null;
    final totalMicros = media.totalDuration.inMicroseconds;
    if (totalMicros <= 0) return null;
    return (globalPosition.inMicroseconds / totalMicros).clamp(0.0, 1.0);
  }

  MediaOverlayFlatClip? clipAtGlobalPosition(Duration globalPosition) {
    final media = _bookMedia;
    final tracks = _bookTracks;
    if (media == null || tracks == null || tracks.isEmpty) return null;

    final trackIndex = media.getIndexForDuration(globalPosition);
    if (trackIndex < 0 || trackIndex >= tracks.length) return null;

    final trackInfo = tracks[trackIndex];
    final trackStart = media.offsetForTrack(trackIndex);
    final clips = trackInfo.group.clips;
    if (clips.isEmpty) return null;

    final absoluteSeconds = (globalPosition - trackStart).inMicroseconds / 1e6 + clips.first.begin;

    for (final clip in clips) {
      if (absoluteSeconds >= clip.begin && absoluteSeconds < clip.end) {
        return MediaOverlayFlatClip(sectionIndex: trackInfo.sectionIndex, groupIndex: trackIndex, clip: clip);
      }
    }
    if (absoluteSeconds < clips.first.begin) {
      return MediaOverlayFlatClip(sectionIndex: trackInfo.sectionIndex, groupIndex: trackIndex, clip: clips.first);
    }
    return MediaOverlayFlatClip(sectionIndex: trackInfo.sectionIndex, groupIndex: trackIndex, clip: clips.last);
  }

  int? _firstTrackIndexAtOrAfterSection(List<MediaOverlayBookTrack> tracks, int sectionIndex) {
    for (var i = 0; i < tracks.length; i++) {
      if (tracks[i].sectionIndex >= sectionIndex) return i;
    }
    return null;
  }

  Future<bool> _playOrSeek(InternalMedia media, Duration target) async {
    if (identical(_bookMedia, media) && audioHandler.isPlayingEphemeralMedia) {
      await audioHandler.seek(target);
      await audioHandler.play();
      return true;
    }
    return audioHandler.playEphemeralMedia(media, initialPosition: target);
  }

  Future<String> _extractAudio(String href) async {
    final cached = _extractedPathByHref[href];
    if (cached != null && File(cached).existsSync()) return cached;

    final bytes = engine.readEntryBytes(href);
    if (bytes == null) {
      throw StateError('Media overlay audio entry not found in EPUB: $href');
    }

    if (!extractionDir.existsSync()) {
      extractionDir.createSync(recursive: true);
    }
    final safeName = href.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final file = File(p.join(extractionDir.path, safeName));
    if (!file.existsSync() || file.lengthSync() != bytes.length) {
      await file.writeAsBytes(bytes, flush: true);
    }
    _extractedPathByHref[href] = file.path;
    return file.path;
  }

  String _guessMimeType(String href) {
    final lower = href.toLowerCase();
    if (lower.endsWith('.mp3')) return 'audio/mpeg';
    if (lower.endsWith('.m4a') || lower.endsWith('.m4b')) return 'audio/mp4';
    if (lower.endsWith('.ogg') || lower.endsWith('.oga')) return 'audio/ogg';
    if (lower.endsWith('.wav')) return 'audio/wav';
    if (lower.endsWith('.flac')) return 'audio/flac';
    if (lower.endsWith('.aac')) return 'audio/aac';
    return 'audio/mpeg';
  }

  Future<(InternalMedia, List<MediaOverlayBookTrack>)?> _ensureBookMedia() async {
    final cachedMedia = _bookMedia;
    final cachedTracks = _bookTracks;
    if (cachedMedia != null && cachedTracks != null) {
      return (cachedMedia, cachedTracks);
    }

    final bookTracks = engine.collectBookTracks().where((t) => t.group.clips.isNotEmpty).toList(growable: false);
    if (bookTracks.isEmpty) return null;

    final tracks = <InternalTrack>[];
    for (var i = 0; i < bookTracks.length; i++) {
      final group = bookTracks[i].group;
      final path = await _extractAudio(group.audioHref);
      tracks.add(
        InternalTrack(
          index: i,
          duration: group.duration,
          url: Uri.file(path).toString(),
          mimeType: _guessMimeType(group.audioHref),
          clipStart: group.clips.first.begin,
          clipEnd: group.clips.last.end,
        ),
      );
    }

    final media = InternalMedia(
      libraryId: libraryId,
      itemId: itemId,
      episodeId: null,
      sessionId: 'media-overlay-$itemId-${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      author: author,
      narrator: narrator,
      series: series,
      seriesPosition: seriesPosition,
      cover: cover,
      tracks: tracks,
      local: true,
      saf: false,
    );
    media.populateFields();

    _bookMedia = media;
    _bookTracks = bookTracks;
    return (media, bookTracks);
  }

  Future<void> dispose() async {}
}
