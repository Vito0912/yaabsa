import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/library_items/library_item.dart';

part 'author_details.freezed.dart';
part 'author_details.g.dart';

@freezed
abstract class AuthorDetails with _$AuthorDetails {
  const factory AuthorDetails({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'asin') String? asin,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'imagePath') String? imagePath,
    @JsonKey(name: 'libraryId') required String libraryId,
    @JsonKey(name: 'addedAt') required int addedAt,
    @JsonKey(name: 'updatedAt') required int updatedAt,
    @JsonKey(name: 'series') @Default(<AuthorSeriesGroup>[]) List<AuthorSeriesGroup> series,
    @JsonKey(name: 'libraryItems') @Default(<LibraryItem>[]) List<LibraryItem> libraryItems,
  }) = _AuthorDetails;

  factory AuthorDetails.fromJson(Map<String, dynamic> json) => _$AuthorDetailsFromJson(json);
}

@freezed
abstract class AuthorSeriesGroup with _$AuthorSeriesGroup {
  const factory AuthorSeriesGroup({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'items') @Default(<LibraryItem>[]) List<LibraryItem> items,
  }) = _AuthorSeriesGroup;

  factory AuthorSeriesGroup.fromJson(Map<String, dynamic> json) => _$AuthorSeriesGroupFromJson(json);
}
