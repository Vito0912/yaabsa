import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'create_podcast_request.freezed.dart';
part 'create_podcast_request.g.dart';

@freezed
abstract class CreatePodcastRequest with _$CreatePodcastRequest {
  const factory CreatePodcastRequest({
    @JsonKey(name: 'path') required String path,
    @JsonKey(name: 'folderId') required String folderId,
    @JsonKey(name: 'libraryId') required String libraryId,
    @JsonKey(name: 'media') required CreatePodcastMedia media,
  }) = _CreatePodcastRequest;

  factory CreatePodcastRequest.fromJson(Map<String, dynamic> json) => _$CreatePodcastRequestFromJson(json);
}

@freezed
abstract class CreatePodcastMedia with _$CreatePodcastMedia {
  const factory CreatePodcastMedia({
    @JsonKey(name: 'metadata') required CreatePodcastMetadata metadata,
    @JsonKey(name: 'autoDownloadEpisodes') @Default(false) bool autoDownloadEpisodes,
  }) = _CreatePodcastMedia;

  factory CreatePodcastMedia.fromJson(Map<String, dynamic> json) => _$CreatePodcastMediaFromJson(json);
}

@freezed
abstract class CreatePodcastMetadata with _$CreatePodcastMetadata {
  const factory CreatePodcastMetadata({
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'releaseDate') String? releaseDate,
    @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) @Default(<String>[]) List<String> genres,
    @JsonKey(name: 'feedUrl') required String feedUrl,
    @JsonKey(name: 'imageUrl') String? imageUrl,
    @JsonKey(name: 'itunesPageUrl') String? itunesPageUrl,
    @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? itunesId,
    @JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic) String? itunesArtistId,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? explicit,
    @JsonKey(name: 'type') String? type,
  }) = _CreatePodcastMetadata;

  factory CreatePodcastMetadata.fromJson(Map<String, dynamic> json) => _$CreatePodcastMetadataFromJson(json);
}
