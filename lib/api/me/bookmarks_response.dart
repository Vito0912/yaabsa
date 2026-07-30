import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/me/bookmark.dart';

part 'bookmarks_response.freezed.dart';
part 'bookmarks_response.g.dart';

@freezed
abstract class BookmarksResponse with _$BookmarksResponse {
  const factory BookmarksResponse({@JsonKey(name: 'bookmarks') @Default(<Bookmark>[]) List<Bookmark> bookmarks}) =
      _BookmarksResponse;

  factory BookmarksResponse.fromJson(Map<String, dynamic> json) => _$BookmarksResponseFromJson(json);
}
