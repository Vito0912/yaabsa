// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_minified.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodcastMinified _$PodcastMinifiedFromJson(Map<String, dynamic> json) => _PodcastMinified(
  metadata: PodcastMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  coverPath: json['coverPath'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  numEpisodes: jsonIntFromDynamic(json['numEpisodes']),
  autoDownloadEpisodes: jsonBoolFromDynamic(json['autoDownloadEpisodes']),
  autoDownloadSchedule: json['autoDownloadSchedule'] as String?,
  lastEpisodeCheck: jsonIntFromDynamic(json['lastEpisodeCheck']),
  maxEpisodesToKeep: jsonIntFromDynamic(json['maxEpisodesToKeep']),
  maxNewEpisodesToDownload: jsonIntFromDynamic(json['maxNewEpisodesToDownload']),
  size: jsonIntFromDynamic(json['size']),
);

Map<String, dynamic> _$PodcastMinifiedToJson(_PodcastMinified instance) => <String, dynamic>{
  'metadata': instance.metadata,
  'coverPath': instance.coverPath,
  'tags': instance.tags,
  'numEpisodes': instance.numEpisodes,
  'autoDownloadEpisodes': instance.autoDownloadEpisodes,
  'autoDownloadSchedule': instance.autoDownloadSchedule,
  'lastEpisodeCheck': instance.lastEpisodeCheck,
  'maxEpisodesToKeep': instance.maxEpisodesToKeep,
  'maxNewEpisodesToDownload': instance.maxNewEpisodesToDownload,
  'size': instance.size,
};
