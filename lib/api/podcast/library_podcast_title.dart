import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'library_podcast_title.freezed.dart';
part 'library_podcast_title.g.dart';

@freezed
abstract class LibraryPodcastTitle with _$LibraryPodcastTitle {
  const factory LibraryPodcastTitle({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'libraryItemId') String? libraryItemId,
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? itunesId,
  }) = _LibraryPodcastTitle;

  factory LibraryPodcastTitle.fromJson(Map<String, dynamic> json) => _$LibraryPodcastTitleFromJson(json);
}
