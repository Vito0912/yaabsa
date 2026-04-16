// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_size_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryItemSizeStats _$LibraryItemSizeStatsFromJson(
  Map<String, dynamic> json,
) => _LibraryItemSizeStats(
  id: json['id'] as String,
  size: (json['size'] as num).toInt(),
  title: json['title'] as String,
);

Map<String, dynamic> _$LibraryItemSizeStatsToJson(
  _LibraryItemSizeStats instance,
) => <String, dynamic>{
  'id': instance.id,
  'size': instance.size,
  'title': instance.title,
};
