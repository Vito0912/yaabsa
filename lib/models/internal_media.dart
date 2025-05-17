import 'package:freezed_annotation/freezed_annotation.dart';

part 'internal_media.freezed.dart';
part 'internal_media.g.dart';

@unfreezed
abstract class InternalMedia with _$InternalMedia {
  const factory InternalMedia({
    @JsonKey(name: "libraryId") required String libraryId,
    @JsonKey(name: "itemId") required String itemId,
    @JsonKey(name: "episodeId") required String? episodeId,
    @JsonKey(name: "tracks") required List<InternalTrack> tracks,
  }) = _InternalMedia;

  factory InternalMedia.fromJson(Map<String, dynamic> json) =>
      _$InternalMediaFromJson(json);

  /// Populates start and end for each track based on durations and order.
  /// Mutates the tracks list.
  void populateTrackStartEnd() {
    double currentStart = 0.0;
    for (int i = 0; i < tracks.length; i++) {
      final track = tracks[i];
      final start = track.start ?? currentStart;
      final end = track.end ?? (start + track.duration);
      tracks[i] = track.copyWith(start: start, end: end);
      currentStart = end;
    }
  }
}

@unfreezed
abstract class InternalTrack with _$InternalTrack {
  const factory InternalTrack({
    @JsonKey(name: "index") required int index,
    @JsonKey(name: "duration") required double duration,
    @JsonKey(name: "url") required String url,
    @JsonKey(name: "start") double? start,
    @JsonKey(name: "end") double? end,
  }) = _InternalTrack;

  factory InternalTrack.fromJson(Map<String, dynamic> json) =>
      _$InternalTrackFromJson(json);
}
