// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Bookmark _$BookmarkFromJson(Map<String, dynamic> json) => _Bookmark(
  libraryItemId: json['libraryItemId'] as String,
  title: json['title'] as String,
  time: (json['time'] as num).toInt(),
  createdAt: (json['createdAt'] as num).toInt(),
);

Map<String, dynamic> _$BookmarkToJson(_Bookmark instance) => <String, dynamic>{
  'libraryItemId': instance.libraryItemId,
  'title': instance.title,
  'time': instance.time,
  'createdAt': instance.createdAt,
};
