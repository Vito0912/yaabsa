// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodcastMedia _$PodcastMediaFromJson(
  Map<String, dynamic> json,
) => _PodcastMedia(
  id: json['id'] as String,
  libraryItemId: json['libraryItemId'] as String,
  metadata: PodcastMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  coverPath: json['coverPath'] as String?,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  episodes:
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
  autoDownloadEpisodes: json['autoDownloadEpisodes'] as bool?,
  autoDownloadSchedule: json['autoDownloadSchedule'] as String?,
  lastEpisodeCheck: (json['lastEpisodeCheck'] as num?)?.toInt(),
  maxEpisodesToKeep: (json['maxEpisodesToKeep'] as num?)?.toInt(),
  maxNewEpisodesToDownload: (json['maxNewEpisodesToDownload'] as num?)?.toInt(),
);

Map<String, dynamic> _$PodcastMediaToJson(_PodcastMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'libraryItemId': instance.libraryItemId,
      'metadata': instance.metadata,
      'coverPath': instance.coverPath,
      'tags': instance.tags,
      'episodes': instance.episodes,
      'autoDownloadEpisodes': instance.autoDownloadEpisodes,
      'autoDownloadSchedule': instance.autoDownloadSchedule,
      'lastEpisodeCheck': instance.lastEpisodeCheck,
      'maxEpisodesToKeep': instance.maxEpisodesToKeep,
      'maxNewEpisodesToDownload': instance.maxNewEpisodesToDownload,
    };
