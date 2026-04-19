import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library/filter_data/library_filter_named_entity.dart';

part 'library_filter_data.freezed.dart';
part 'library_filter_data.g.dart';

@freezed
abstract class LibraryFilterData with _$LibraryFilterData {
  const factory LibraryFilterData({
    @JsonKey(name: 'authors') @Default(<LibraryFilterNamedEntity>[]) List<LibraryFilterNamedEntity> authors,
    @JsonKey(name: 'genres') @Default(<String>[]) List<String> genres,
    @JsonKey(name: 'tags') @Default(<String>[]) List<String> tags,
    @JsonKey(name: 'series') @Default(<LibraryFilterNamedEntity>[]) List<LibraryFilterNamedEntity> series,
    @JsonKey(name: 'narrators') @Default(<String>[]) List<String> narrators,
    @JsonKey(name: 'languages') @Default(<String>[]) List<String> languages,
    @JsonKey(name: 'publishers') @Default(<String>[]) List<String> publishers,
    @JsonKey(name: 'publishedDecades') @Default(<String>[]) List<String> publishedDecades,
    @JsonKey(name: 'bookCount') @Default(0) int bookCount,
    @JsonKey(name: 'authorCount') @Default(0) int authorCount,
    @JsonKey(name: 'seriesCount') @Default(0) int seriesCount,
    @JsonKey(name: 'podcastCount') @Default(0) int podcastCount,
    @JsonKey(name: 'numIssues') @Default(0) int numIssues,
    @JsonKey(name: 'loadedAt') @Default(0) int loadedAt,
  }) = _LibraryFilterData;

  factory LibraryFilterData.fromJson(Map<String, dynamic> json) => _$LibraryFilterDataFromJson(json);
}
