import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'podcast_search_result.freezed.dart';
part 'podcast_search_result.g.dart';

@freezed
abstract class PodcastSearchResult with _$PodcastSearchResult {
  const factory PodcastSearchResult({
    @JsonKey(name: 'id', fromJson: jsonStringFromDynamic) String? id,
    @JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic) String? artistId,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'artistName') String? artistName,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'descriptionPlain') String? descriptionPlain,
    @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) @Default(<String>[]) List<String> genres,
    @JsonKey(name: 'cover') String? cover,
    @JsonKey(name: 'feedUrl') String? feedUrl,
    @JsonKey(name: 'pageUrl') String? pageUrl,
    @JsonKey(name: 'releaseDate') String? releaseDate,
    @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? explicit,
    @JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic) int? trackCount,
    @JsonKey(name: 'language') String? language,
    @JsonKey(name: 'type') String? type,
  }) = _PodcastSearchResult;

  factory PodcastSearchResult.fromJson(Map<String, dynamic> json) => _$PodcastSearchResultFromJson(json);
}
