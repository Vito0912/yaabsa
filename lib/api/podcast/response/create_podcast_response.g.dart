// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_podcast_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreatePodcastResponse _$CreatePodcastResponseFromJson(Map<String, dynamic> json) => _CreatePodcastResponse(
  libraryItem: json['libraryItem'] == null ? null : LibraryItem.fromJson(json['libraryItem'] as Map<String, dynamic>),
  item: json['item'] == null ? null : LibraryItem.fromJson(json['item'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreatePodcastResponseToJson(_CreatePodcastResponse instance) => <String, dynamic>{
  'libraryItem': instance.libraryItem,
  'item': instance.item,
};
