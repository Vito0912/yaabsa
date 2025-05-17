import 'package:buchshelfly/api/library_items/audio_file.dart';
import 'package:buchshelfly/api/library_items/chapter.dart';
import 'package:buchshelfly/api/library_items/ebook_file.dart';
import 'package:buchshelfly/api/library_items/media_metadata.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_media.freezed.dart';
part 'book_media.g.dart';

@freezed
abstract class BookMedia with _$BookMedia {
  const factory BookMedia({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "libraryItemId") String? libraryItemId,
    @JsonKey(name: "metadata") required MediaMetadata metadata,
    @JsonKey(name: "coverPath") String? coverPath,
    @JsonKey(name: "tags") List<String>? tags,
    @JsonKey(name: "audioFiles") List<AudioFile>? audioFiles,
    @JsonKey(name: "chapters") List<Chapter>? chapters,
    @JsonKey(name: "ebookFile") EbookFile? ebookFile,
    @JsonKey(name: "numTracks") int? numTracks,
    @JsonKey(name: "numChapters") int? numChapters,
    @JsonKey(name: "numAudioFiles") int? numAudioFiles,
    @JsonKey(name: "size") int? size,
    @JsonKey(name: "ebookFormat") String? ebookFormat,
  }) = _BookMedia;

  factory BookMedia.fromJson(Map<String, dynamic> json) =>
      _$BookMediaFromJson(json);
}
