import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'genre_stats.freezed.dart';
part 'genre_stats.g.dart';

@freezed
abstract class GenreStats with _$GenreStats {
  const factory GenreStats({
    @JsonKey(name: "genre") required String genre,
    @JsonKey(name: "count", fromJson: jsonIntRequiredFromDynamic) required int count,
  }) = _GenreStats;

  factory GenreStats.fromJson(Map<String, dynamic> json) => _$GenreStatsFromJson(json);
}
