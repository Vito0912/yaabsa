import 'package:yaabsa/api/library/stats/author_stats.dart';
import 'package:yaabsa/api/json/value_parsers.dart';
import 'package:yaabsa/api/library/stats/genre_stats.dart';
import 'package:yaabsa/api/library/stats/library_item_duration_stats.dart';
import 'package:yaabsa/api/library/stats/library_item_size_stats.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_stats.freezed.dart';
part 'library_stats.g.dart';

@freezed
abstract class LibraryStats with _$LibraryStats {
  const factory LibraryStats({
    @JsonKey(name: "totalItems", fromJson: jsonIntFromDynamic) int? totalItems,
    @JsonKey(name: "totalAuthors", fromJson: jsonIntFromDynamic) int? totalAuthors,
    @JsonKey(name: "totalGenres", fromJson: jsonIntFromDynamic) int? totalGenres,
    @JsonKey(name: "totalDuration", fromJson: jsonDoubleFromDynamic) double? totalDuration,
    @JsonKey(name: "longestItems") @Default(<LibraryItemDurationStats>[]) List<LibraryItemDurationStats> longestItems,
    @JsonKey(name: "numAudioTracks", fromJson: jsonIntFromDynamic) int? numAudioTracks,
    @JsonKey(name: "totalSize", fromJson: jsonIntFromDynamic) int? totalSize,
    @JsonKey(name: "largestItems") @Default(<LibraryItemSizeStats>[]) List<LibraryItemSizeStats> largestItems,
    @JsonKey(name: "authorsWithCount") @Default(<AuthorStats>[]) List<AuthorStats> authorsWithCount,
    @JsonKey(name: "genresWithCount") @Default(<GenreStats>[]) List<GenreStats> genresWithCount,
  }) = _LibraryStats;

  factory LibraryStats.fromJson(Map<String, dynamic> json) => _$LibraryStatsFromJson(json);
}
