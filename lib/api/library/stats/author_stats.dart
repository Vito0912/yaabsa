import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'author_stats.freezed.dart';
part 'author_stats.g.dart';

@freezed
abstract class AuthorStats with _$AuthorStats {
  const factory AuthorStats({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "count", fromJson: jsonIntRequiredFromDynamic) required int count,
  }) = _AuthorStats;

  factory AuthorStats.fromJson(Map<String, dynamic> json) => _$AuthorStatsFromJson(json);
}
