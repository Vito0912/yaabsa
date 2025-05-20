// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenreStats _$GenreStatsFromJson(Map<String, dynamic> json) =>
    _GenreStats(genre: json['genre'] as String, count: (json['count'] as num).toInt());

Map<String, dynamic> _$GenreStatsToJson(_GenreStats instance) => <String, dynamic>{
  'genre': instance.genre,
  'count': instance.count,
};
