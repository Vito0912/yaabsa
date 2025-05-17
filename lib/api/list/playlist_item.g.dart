// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaylistItem _$PlaylistItemFromJson(Map<String, dynamic> json) =>
    _PlaylistItem(
      itemId: json['libraryItemId'] as String,
      episodeId: json['episodeId'] as String?,
      episode:
          json['episode'] == null
              ? null
              : Episode.fromJson(json['episode'] as Map<String, dynamic>),
      libraryItem:
          json['libraryItem'] == null
              ? null
              : LibraryItem.fromJson(
                json['libraryItem'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$PlaylistItemToJson(_PlaylistItem instance) =>
    <String, dynamic>{
      'libraryItemId': instance.itemId,
      'episodeId': instance.episodeId,
      'episode': instance.episode,
      'libraryItem': instance.libraryItem,
    };
