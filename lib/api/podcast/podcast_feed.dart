import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'podcast_feed.freezed.dart';
part 'podcast_feed.g.dart';

@freezed
abstract class PodcastFeedResponse with _$PodcastFeedResponse {
  const factory PodcastFeedResponse({@JsonKey(name: 'podcast') required PodcastFeed podcast}) = _PodcastFeedResponse;

  factory PodcastFeedResponse.fromJson(Map<String, dynamic> json) => _$PodcastFeedResponseFromJson(json);
}

@freezed
abstract class PodcastFeed with _$PodcastFeed {
  const factory PodcastFeed({
    @JsonKey(name: 'metadata') required PodcastFeedMetadata metadata,
    @JsonKey(name: 'episodes') @Default(<PodcastFeedEpisode>[]) List<PodcastFeedEpisode> episodes,
    @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? numEpisodes,
  }) = _PodcastFeed;

  factory PodcastFeed.fromJson(Map<String, dynamic> json) => _$PodcastFeedFromJson(json);
}

@freezed
abstract class PodcastFeedMetadata with _$PodcastFeedMetadata {
  const factory PodcastFeedMetadata({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'explicit') String? explicit,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'pubDate') String? pubDate,
    @JsonKey(name: 'link') String? link,
    @JsonKey(name: 'image') String? image,
    @JsonKey(name: 'categories') @Default(<String>[]) List<String> categories,
    @JsonKey(name: 'feedUrl') String? feedUrl,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'descriptionPlain') String? descriptionPlain,
    @JsonKey(name: 'type') String? type,
  }) = _PodcastFeedMetadata;

  factory PodcastFeedMetadata.fromJson(Map<String, dynamic> json) => _$PodcastFeedMetadataFromJson(json);
}

@freezed
abstract class PodcastFeedEpisode with _$PodcastFeedEpisode {
  const factory PodcastFeedEpisode({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'subtitle') String? subtitle,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'descriptionPlain') String? descriptionPlain,
    @JsonKey(name: 'pubDate') String? pubDate,
    @JsonKey(name: 'episodeType') String? episodeType,
    @JsonKey(name: 'season') String? season,
    @JsonKey(name: 'episode') String? episode,
    @JsonKey(name: 'author') String? author,
    @JsonKey(name: 'duration') String? duration,
    @JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic) int? durationSeconds,
    @JsonKey(name: 'explicit') String? explicit,
    @JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic) int? publishedAt,
    @JsonKey(name: 'enclosure') PodcastFeedEpisodeEnclosure? enclosure,
    @JsonKey(name: 'guid') String? guid,
    @JsonKey(name: 'chaptersUrl') String? chaptersUrl,
    @JsonKey(name: 'chaptersType') String? chaptersType,
    @JsonKey(name: 'chapters') @Default(<PodcastFeedEpisodeChapter>[]) List<PodcastFeedEpisodeChapter> chapters,
  }) = _PodcastFeedEpisode;

  factory PodcastFeedEpisode.fromJson(Map<String, dynamic> json) => _$PodcastFeedEpisodeFromJson(json);
}

@freezed
abstract class PodcastFeedEpisodeEnclosure with _$PodcastFeedEpisodeEnclosure {
  const factory PodcastFeedEpisodeEnclosure({
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? length,
  }) = _PodcastFeedEpisodeEnclosure;

  factory PodcastFeedEpisodeEnclosure.fromJson(Map<String, dynamic> json) =>
      _$PodcastFeedEpisodeEnclosureFromJson(json);
}

@freezed
abstract class PodcastFeedEpisodeChapter with _$PodcastFeedEpisodeChapter {
  const factory PodcastFeedEpisodeChapter({
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic) double? start,
  }) = _PodcastFeedEpisodeChapter;

  factory PodcastFeedEpisodeChapter.fromJson(Map<String, dynamic> json) => _$PodcastFeedEpisodeChapterFromJson(json);
}
