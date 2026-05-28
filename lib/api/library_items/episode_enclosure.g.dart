// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_enclosure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EpisodeEnclosure _$EpisodeEnclosureFromJson(Map<String, dynamic> json) => _EpisodeEnclosure(
  url: json['url'] as String?,
  type: json['type'] as String?,
  length: jsonIntFromDynamic(json['length']),
);

Map<String, dynamic> _$EpisodeEnclosureToJson(_EpisodeEnclosure instance) => <String, dynamic>{
  'url': instance.url,
  'type': instance.type,
  'length': instance.length,
};
