import 'package:yaabsa/api/library_items/audio_file.dart';
import 'package:yaabsa/api/library_items/episode_enclosure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    @JsonKey(name: "libraryItemId") required String libraryItemId,
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "index", fromJson: jsonIntFromDynamic) int? index,
    @JsonKey(name: "season") String? season,
    @JsonKey(name: "episode") String? episode,
    @JsonKey(name: "episodeType") String? episodeType,
    @JsonKey(name: "title") String? title,
    @JsonKey(name: "subtitle") String? subtitle,
    @JsonKey(name: "description") String? description,
    @JsonKey(name: "guid") String? guid,
    @JsonKey(name: "enclosure") EpisodeEnclosure? enclosure,
    @JsonKey(name: "pubDate") String? pubDate,
    @JsonKey(name: "audioFile") AudioFile? audioFile,
    @JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic) int? publishedAt,
    @JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic) int? addedAt,
    @JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic) int? updatedAt,
  }) = _Episode;

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);
}
