import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/library_items/podcast_metadata.dart';

part 'podcast_minified.freezed.dart';
part 'podcast_minified.g.dart';

@freezed
abstract class PodcastMinified with _$PodcastMinified {
  const factory PodcastMinified({
    @JsonKey(name: 'metadata') required PodcastMetadata metadata,
    @JsonKey(name: 'coverPath') String? coverPath,
    @JsonKey(name: 'tags') @Default(<String>[]) List<String> tags,
    @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? numEpisodes,
    @JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic) bool? autoDownloadEpisodes,
    @JsonKey(name: 'autoDownloadSchedule') String? autoDownloadSchedule,
    @JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic) int? lastEpisodeCheck,
    @JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic) int? maxEpisodesToKeep,
    @JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic) int? maxNewEpisodesToDownload,
    @JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? size,
  }) = _PodcastMinified;

  factory PodcastMinified.fromJson(Map<String, dynamic> json) => _$PodcastMinifiedFromJson(json);
}
