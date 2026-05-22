// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Episode _$EpisodeFromJson(Map<String, dynamic> json) => _Episode(
  libraryItemId: json['libraryItemId'] as String,
  id: json['id'] as String,
  index: jsonIntFromDynamic(json['index']),
  season: json['season'] as String?,
  episode: json['episode'] as String?,
  episodeType: json['episodeType'] as String?,
  title: json['title'] as String?,
  subtitle: json['subtitle'] as String?,
  description: json['description'] as String?,
  guid: json['guid'] as String?,
  enclosure: json['enclosure'] == null ? null : EpisodeEnclosure.fromJson(json['enclosure'] as Map<String, dynamic>),
  pubDate: json['pubDate'] as String?,
  audioFile: json['audioFile'] == null ? null : AudioFile.fromJson(json['audioFile'] as Map<String, dynamic>),
  publishedAt: jsonIntFromDynamic(json['publishedAt']),
  addedAt: jsonIntFromDynamic(json['addedAt']),
  updatedAt: jsonIntFromDynamic(json['updatedAt']),
);

Map<String, dynamic> _$EpisodeToJson(_Episode instance) => <String, dynamic>{
  'libraryItemId': instance.libraryItemId,
  'id': instance.id,
  'index': instance.index,
  'season': instance.season,
  'episode': instance.episode,
  'episodeType': instance.episodeType,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'description': instance.description,
  'guid': instance.guid,
  'enclosure': instance.enclosure,
  'pubDate': instance.pubDate,
  'audioFile': instance.audioFile,
  'publishedAt': instance.publishedAt,
  'addedAt': instance.addedAt,
  'updatedAt': instance.updatedAt,
};
