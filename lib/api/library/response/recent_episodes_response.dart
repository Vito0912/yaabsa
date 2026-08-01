import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/library_items/episode.dart';

part 'recent_episodes_response.freezed.dart';
part 'recent_episodes_response.g.dart';

@freezed
abstract class RecentEpisodesResponse with _$RecentEpisodesResponse {
  const factory RecentEpisodesResponse({
    @JsonKey(name: 'episodes') @Default(<Episode>[]) List<Episode> episodes,
    @JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic) @Default(0) int limit,
    @JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic) @Default(0) int page,
  }) = _RecentEpisodesResponse;

  factory RecentEpisodesResponse.fromJson(Map<String, dynamic> json) => _$RecentEpisodesResponseFromJson(json);
}
