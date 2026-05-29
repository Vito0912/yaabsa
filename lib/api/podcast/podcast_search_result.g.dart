// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'podcast_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PodcastSearchResult _$PodcastSearchResultFromJson(Map<String, dynamic> json) => _PodcastSearchResult(
  id: jsonStringFromDynamic(json['id']),
  artistId: jsonStringFromDynamic(json['artistId']),
  title: json['title'] as String?,
  artistName: json['artistName'] as String?,
  description: json['description'] as String?,
  descriptionPlain: json['descriptionPlain'] as String?,
  genres: json['genres'] == null ? const <String>[] : jsonStringListFromDynamic(json['genres']),
  cover: json['cover'] as String?,
  feedUrl: json['feedUrl'] as String?,
  pageUrl: json['pageUrl'] as String?,
  releaseDate: json['releaseDate'] as String?,
  explicit: jsonBoolFromDynamic(json['explicit']),
  trackCount: jsonIntFromDynamic(json['trackCount']),
  language: json['language'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$PodcastSearchResultToJson(_PodcastSearchResult instance) => <String, dynamic>{
  'id': instance.id,
  'artistId': instance.artistId,
  'title': instance.title,
  'artistName': instance.artistName,
  'description': instance.description,
  'descriptionPlain': instance.descriptionPlain,
  'genres': instance.genres,
  'cover': instance.cover,
  'feedUrl': instance.feedUrl,
  'pageUrl': instance.pageUrl,
  'releaseDate': instance.releaseDate,
  'explicit': instance.explicit,
  'trackCount': instance.trackCount,
  'language': instance.language,
  'type': instance.type,
};
