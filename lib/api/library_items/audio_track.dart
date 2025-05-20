import 'package:buchshelfly/api/library_items/library_file_metadata.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_track.freezed.dart';
part 'audio_track.g.dart';

@freezed
abstract class AudioTrack with _$AudioTrack {
  const AudioTrack._();

  const factory AudioTrack({
    @JsonKey(name: "index") int? index,
    @JsonKey(name: "startOffset") required double startOffset,
    @JsonKey(name: "duration") required double duration,
    @JsonKey(name: "title") required String title,
    @JsonKey(name: "contentUrl") required String contentUrl,
    @JsonKey(name: "mimeType") required String mimeType,
    @JsonKey(name: "metadata") LibraryFileMetadata? metadata,
  }) = _AudioTrack;

  // Overwrite contentUrl to remove /audiobookshelf if it starts
  String get processedContentUrl {
    if (contentUrl.startsWith('/audiobookshelf')) {
      return contentUrl.substring(15);
    }
    return contentUrl;
  }

  InternalTrack toInternalTrack(String baseUrl, String sessionId, {int? localIndex}) {
    final tmpIndex = (index ?? localIndex)!;
    return InternalTrack(
      index: tmpIndex,
      duration: duration,
      url: '$baseUrl/public/session/$sessionId/track/$tmpIndex',
      mimeType: mimeType,
    );
  }

  factory AudioTrack.fromJson(Map<String, dynamic> json) => _$AudioTrackFromJson(json);
}
