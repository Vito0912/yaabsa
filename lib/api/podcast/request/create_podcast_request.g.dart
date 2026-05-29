// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_podcast_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePodcastRequest _$CreatePodcastRequestFromJson(Map<String, dynamic> json) => _CreatePodcastRequest(
  path: json['path'] as String,
  folderId: json['folderId'] as String,
  libraryId: json['libraryId'] as String,
  media: CreatePodcastMedia.fromJson(json['media'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreatePodcastRequestToJson(_CreatePodcastRequest instance) => <String, dynamic>{
  'path': instance.path,
  'folderId': instance.folderId,
  'libraryId': instance.libraryId,
  'media': instance.media,
};

_CreatePodcastMedia _$CreatePodcastMediaFromJson(Map<String, dynamic> json) => _CreatePodcastMedia(
  metadata: CreatePodcastMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  autoDownloadEpisodes: json['autoDownloadEpisodes'] as bool? ?? false,
);

Map<String, dynamic> _$CreatePodcastMediaToJson(_CreatePodcastMedia instance) => <String, dynamic>{
  'metadata': instance.metadata,
  'autoDownloadEpisodes': instance.autoDownloadEpisodes,
};

_CreatePodcastMetadata _$CreatePodcastMetadataFromJson(Map<String, dynamic> json) => _CreatePodcastMetadata(
  title: json['title'] as String,
  author: json['author'] as String?,
  description: json['description'] as String?,
  releaseDate: json['releaseDate'] as String?,
  genres: json['genres'] == null ? const <String>[] : jsonStringListFromDynamic(json['genres']),
  feedUrl: json['feedUrl'] as String,
  imageUrl: json['imageUrl'] as String?,
  itunesPageUrl: json['itunesPageUrl'] as String?,
  itunesId: jsonStringFromDynamic(json['itunesId']),
  itunesArtistId: jsonStringFromDynamic(json['itunesArtistId']),
  language: json['language'] as String?,
  explicit: jsonBoolFromDynamic(json['explicit']),
  type: json['type'] as String?,
);

Map<String, dynamic> _$CreatePodcastMetadataToJson(_CreatePodcastMetadata instance) => <String, dynamic>{
  'title': instance.title,
  'author': instance.author,
  'description': instance.description,
  'releaseDate': instance.releaseDate,
  'genres': instance.genres,
  'feedUrl': instance.feedUrl,
  'imageUrl': instance.imageUrl,
  'itunesPageUrl': instance.itunesPageUrl,
  'itunesId': instance.itunesId,
  'itunesArtistId': instance.itunesArtistId,
  'language': instance.language,
  'explicit': instance.explicit,
  'type': instance.type,
};
