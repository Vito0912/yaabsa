import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_author.freezed.dart';
part 'library_author.g.dart';

@freezed
abstract class LibraryAuthor with _$LibraryAuthor {
  const factory LibraryAuthor({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'asin') String? asin,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'imagePath') String? imagePath,
    @JsonKey(name: 'libraryId') required String libraryId,
    @JsonKey(name: 'addedAt') required int addedAt,
    @JsonKey(name: 'updatedAt') required int updatedAt,
    @Default(0) @JsonKey(name: 'numBooks') int numBooks,
    @JsonKey(name: 'lastFirst') String? lastFirst,
  }) = _LibraryAuthor;

  factory LibraryAuthor.fromJson(Map<String, dynamic> json) => _$LibraryAuthorFromJson(json);
}
