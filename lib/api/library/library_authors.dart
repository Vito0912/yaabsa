import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library/library_author.dart';

part 'library_authors.freezed.dart';
part 'library_authors.g.dart';

@freezed
abstract class LibraryAuthors with _$LibraryAuthors {
  const factory LibraryAuthors({
    @JsonKey(name: 'results') @Default(<LibraryAuthor>[]) List<LibraryAuthor> results,
    @JsonKey(name: 'total') @Default(0) int total,
    @JsonKey(name: 'limit') int? limit,
    @JsonKey(name: 'page') int? page,
    @JsonKey(name: 'sortBy') String? sortBy,
    @JsonKey(name: 'sortDesc') bool? sortDesc,
    @JsonKey(name: 'filterBy') String? filterBy,
    @JsonKey(name: 'minified') bool? minified,
    @JsonKey(name: 'include') String? include,
  }) = _LibraryAuthors;

  factory LibraryAuthors.fromJson(Map<String, dynamic> json) => _$LibraryAuthorsFromJson(json);
}
