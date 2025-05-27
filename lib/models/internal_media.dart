import 'package:audio_service/audio_service.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart' show AudioSource;

part 'internal_media.freezed.dart';
part 'internal_media.g.dart';

@unfreezed
abstract class InternalMedia with _$InternalMedia {
  InternalMedia._();

  factory InternalMedia({
    @JsonKey(name: "libraryId") required String libraryId,
    @JsonKey(name: "itemId") required String itemId,
    @JsonKey(name: "episodeId") required String? episodeId,
    @JsonKey(name: "sessionId") required String sessionId,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "subtitle") String? subtitle,
    @JsonKey(name: "author") String? author,
    @JsonKey(name: "series") String? series,
    @JsonKey(name: "seriesPosition") String? seriesPosition,
    @JsonKey(name: "cover") Uri? cover,
    @JsonKey(name: "tracks") required List<InternalTrack> tracks,
    @JsonKey(name: "chapters") List<InternalChapter>? chapters,
    // Removed incorrect defaultValue: false
    @JsonKey(name: "duration") double? duration,
    @JsonKey(name: "local", defaultValue: false) required bool local,
    // SAF is for Android only
    @JsonKey(name: "saf") required bool saf,
  }) = _InternalMedia;

  factory InternalMedia.fromJson(Map<String, dynamic> json) => _$InternalMediaFromJson(json);

  String get id => episodeId ?? itemId;

  MediaItem toMediaItem() {
    return MediaItem(
      id: episodeId ?? itemId,
      album: (series != null && seriesPosition != null) ? '$series #$seriesPosition' : (series ?? ''),
      title: title,
      displayTitle: title,
      artist: author,
      // Maybe add current chapter via settings?
      displaySubtitle: subtitle,
      duration: totalDuration,
      isLive: false,
      artUri: cover,
    );
  }

  List<AudioSource> toAudioSources() {
    if (local) {
      logger('Using local audio sources', tag: 'InternalMedia', level: InfoLevel.debug);
    }
    return tracks.map((track) {
      if (track.url == null) {
        throw ArgumentError('Track URL cannot be null for track index ${track.index}');
      }
      if (track.mimeType.isEmpty) {
        throw ArgumentError('Track mimeType cannot be empty for track index ${track.index}');
      }
      if (local) {
        // TODO: SAF
        return AudioSource.file(track.url!);
      } else {
        return AudioSource.uri(Uri.parse(track.url!));
      }
    }).toList();
  }

  void populateFields() {
    tracks = tracks.toList();

    double currentStart = 0.0;
    for (int i = 0; i < tracks.length; i++) {
      final track = tracks[i];
      final start = track.start ?? currentStart;
      final end = track.end ?? (start + track.duration);
      tracks[i] = track.copyWith(start: start, end: end);
      currentStart = end;
    }
    duration = currentStart;
  }

  Duration get totalDuration {
    if (duration != null) {
      return Duration(microseconds: (duration! * 1e6).round());
    }
    final calculated = tracks.fold(0.0, (sum, track) => sum + track.duration);
    duration = calculated;
    return Duration(microseconds: (calculated * 1e6).round());
  }

  Duration offsetForTrack(int index) {
    if (index < 0 || index >= tracks.length) {
      throw RangeError('Index out of range: $index');
    }
    return tracks[index].start != null ? Duration(microseconds: (tracks[index].start! * 1e6).round()) : Duration.zero;
  }

  int getIndexForDuration(Duration duration) {
    double targetDuration = duration.inMicroseconds / 1e6;
    for (int i = 0; i < tracks.length; i++) {
      if (tracks[i].start != null && tracks[i].end != null) {
        if (targetDuration >= tracks[i].start! && targetDuration <= tracks[i].end!) {
          return i;
        }
      }
    }
    return -1;
  }

  Duration startDurationForTrack(int index) {
    if (index < 0 || index >= tracks.length) {
      throw RangeError('Index out of range: $index');
    }
    return Duration(microseconds: (tracks[index].start! * 1e6).round());
  }

  InternalChapter? getChapterForDuration(Duration duration) {
    if (chapters == null || chapters!.isEmpty) {
      return null;
    }
    double targetDuration = duration.inMicroseconds / 1e6;
    for (int i = 0; i < chapters!.length; i++) {
      if (chapters![i].start <= targetDuration && chapters![i].end >= targetDuration) {
        return chapters![i];
      }
    }
    return null;
  }
}

@freezed
abstract class InternalTrack with _$InternalTrack {
  const factory InternalTrack({
    @JsonKey(name: "index") required int index,
    @JsonKey(name: "duration") required double duration,
    @JsonKey(name: "url") required String? url,
    @JsonKey(name: "mimeType") required String mimeType,
    @JsonKey(name: "start") double? start,
    @JsonKey(name: "end") double? end,
  }) = _InternalTrack;

  factory InternalTrack.fromJson(Map<String, dynamic> json) => _$InternalTrackFromJson(json);
}

@freezed
abstract class InternalChapter with _$InternalChapter {
  const factory InternalChapter({
    @JsonKey(name: "start") required double start,
    @JsonKey(name: "end") required double end,
    @JsonKey(name: "title") required String title,
  }) = _InternalChapter;

  factory InternalChapter.fromJson(Map<String, dynamic> json) => _$InternalChapterFromJson(json);
}

@freezed
abstract class QueueItem with _$QueueItem {
  const factory QueueItem({
    @JsonKey(name: "itemId") required String itemId,
    @JsonKey(name: "episodeId") String? episodeId,
  }) = _QueueItem;

  factory QueueItem.fromJson(Map<String, dynamic> json) => _$QueueItemFromJson(json);
}
