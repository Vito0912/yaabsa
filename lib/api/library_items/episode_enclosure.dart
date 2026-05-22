import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'episode_enclosure.freezed.dart';
part 'episode_enclosure.g.dart';

@freezed
abstract class EpisodeEnclosure with _$EpisodeEnclosure {
  const factory EpisodeEnclosure({
    @JsonKey(name: 'url') String? url,
    @JsonKey(name: 'type') String? type,
    @JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? length,
  }) = _EpisodeEnclosure;

  factory EpisodeEnclosure.fromJson(Map<String, dynamic> json) => _$EpisodeEnclosureFromJson(json);
}
