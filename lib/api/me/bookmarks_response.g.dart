// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookmarksResponse _$BookmarksResponseFromJson(Map<String, dynamic> json) => _BookmarksResponse(
  bookmarks:
      (json['bookmarks'] as List<dynamic>?)?.map((e) => Bookmark.fromJson(e as Map<String, dynamic>)).toList() ??
      const <Bookmark>[],
);

Map<String, dynamic> _$BookmarksResponseToJson(_BookmarksResponse instance) => <String, dynamic>{
  'bookmarks': instance.bookmarks,
};
