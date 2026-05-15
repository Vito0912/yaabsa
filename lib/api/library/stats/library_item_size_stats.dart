import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'library_item_size_stats.freezed.dart';
part 'library_item_size_stats.g.dart';

@freezed
abstract class LibraryItemSizeStats with _$LibraryItemSizeStats {
  const factory LibraryItemSizeStats({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "size", fromJson: jsonIntRequiredFromDynamic) required int size,
    @JsonKey(name: "title") required String title,
  }) = _LibraryItemSizeStats;

  factory LibraryItemSizeStats.fromJson(Map<String, dynamic> json) => _$LibraryItemSizeStatsFromJson(json);
}
