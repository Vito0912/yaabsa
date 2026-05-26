// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_podcast_title.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryPodcastTitle _$LibraryPodcastTitleFromJson(Map<String, dynamic> json) => _LibraryPodcastTitle(
  id: json['id'] as String?,
  libraryItemId: json['libraryItemId'] as String?,
  title: json['title'] as String? ?? '',
  itunesId: jsonStringFromDynamic(json['itunesId']),
);

Map<String, dynamic> _$LibraryPodcastTitleToJson(_LibraryPodcastTitle instance) => <String, dynamic>{
  'id': instance.id,
  'libraryItemId': instance.libraryItemId,
  'title': instance.title,
  'itunesId': instance.itunesId,
};
