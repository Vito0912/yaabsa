// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlaylistResponse _$PlaylistResponseFromJson(Map<String, dynamic> json) =>
    _PlaylistResponse(
      items:
          (json['playlists'] as List<dynamic>)
              .map((e) => Playlist.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$PlaylistResponseToJson(_PlaylistResponse instance) =>
    <String, dynamic>{'playlists': instance.items};
