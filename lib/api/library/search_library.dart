import 'package:buchshelfly/api/library/search_library_author.dart';
import 'package:buchshelfly/api/library/search_series.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_library.freezed.dart';
part 'search_library.g.dart';

@freezed
abstract class SearchLibrary with _$SearchLibrary {
  const factory SearchLibrary({
    @JsonKey(name: "book") List<SearchLibraryResult>? book,
    @JsonKey(name: "podcast") List<SearchLibraryResult>? podcast,
    @JsonKey(name: "narrators") List<SearchResultNarrator>? narrators,
    @JsonKey(name: "tags") List<SearchResultItem>? tags,
    @JsonKey(name: "genres") List<SearchResultItem>? genres,
    @JsonKey(name: "series") List<SearchSeries>? series,
    @JsonKey(name: "authors") List<SearchLibraryAuthor>? authors,
  }) = _SearchLibrary;

  factory SearchLibrary.fromJson(Map<String, dynamic> json) => _$SearchLibraryFromJson(json);
}

@freezed
abstract class SearchLibraryResult with _$SearchLibraryResult {
  const factory SearchLibraryResult({
    @JsonKey(name: "libraryItem") LibraryItem? libraryItem,
    @JsonKey(name: "matchKey") String? matchKey,
    @JsonKey(name: "matchText") String? matchText,
  }) = _SearchLibraryResult;

  factory SearchLibraryResult.fromJson(Map<String, dynamic> json) => _$SearchLibraryResultFromJson(json);
}

@freezed
abstract class SearchResultItem with _$SearchResultItem {
  const factory SearchResultItem({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "numItems") int? numItems,
  }) = _SearchResultItem;

  factory SearchResultItem.fromJson(Map<String, dynamic> json) => _$SearchResultItemFromJson(json);
}

@freezed
abstract class SearchResultNarrator with _$SearchResultNarrator {
  const factory SearchResultNarrator({
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "numItems") int? numItems,
  }) = _SearchResultNarrator;

  factory SearchResultNarrator.fromJson(Map<String, dynamic> json) => _$SearchResultNarratorFromJson(json);
}
