// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InternalDownload _$InternalDownloadFromJson(Map<String, dynamic> json) =>
    _InternalDownload(
      item:
          json['item'] == null
              ? null
              : LibraryItem.fromJson(json['item'] as Map<String, dynamic>),
      episode:
          json['episode'] == null
              ? null
              : Episode.fromJson(json['episode'] as Map<String, dynamic>),
      tracks:
          json['tracks'] == null
              ? null
              : InternalTrack.fromJson(json['tracks'] as Map<String, dynamic>),
      saf: json['saf'] as bool? ?? false,
    );

Map<String, dynamic> _$InternalDownloadToJson(_InternalDownload instance) =>
    <String, dynamic>{
      'item': instance.item,
      'episode': instance.episode,
      'tracks': instance.tracks,
      'saf': instance.saf,
    };
