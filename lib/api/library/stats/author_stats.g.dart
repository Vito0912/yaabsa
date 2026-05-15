// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthorStats _$AuthorStatsFromJson(Map<String, dynamic> json) => _AuthorStats(
  id: json['id'] as String,
  name: json['name'] as String,
  count: jsonIntRequiredFromDynamic(json['count']),
);

Map<String, dynamic> _$AuthorStatsToJson(_AuthorStats instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'count': instance.count,
};
