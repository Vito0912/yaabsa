import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/me/media_progress.dart';

part 'media_progress_response.freezed.dart';
part 'media_progress_response.g.dart';

@freezed
abstract class MediaProgressResponse with _$MediaProgressResponse {
  const factory MediaProgressResponse({
    @JsonKey(name: 'mediaProgress') @Default(<MediaProgress>[]) List<MediaProgress> mediaProgress,
  }) = _MediaProgressResponse;

  factory MediaProgressResponse.fromJson(Map<String, dynamic> json) => _$MediaProgressResponseFromJson(json);
}
