// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_duration_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryItemDurationStats _$LibraryItemDurationStatsFromJson(Map<String, dynamic> json) => _LibraryItemDurationStats(
  id: json['id'] as String,
  duration: (json['duration'] as num).toDouble(),
  title: json['title'] as String,
);

Map<String, dynamic> _$LibraryItemDurationStatsToJson(_LibraryItemDurationStats instance) => <String, dynamic>{
  'id': instance.id,
  'duration': instance.duration,
  'title': instance.title,
};
