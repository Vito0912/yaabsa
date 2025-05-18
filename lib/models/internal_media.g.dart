// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InternalMedia _$InternalMediaFromJson(Map<String, dynamic> json) =>
    _InternalMedia(
      libraryId: json['libraryId'] as String,
      itemId: json['itemId'] as String,
      episodeId: json['episodeId'] as String?,
      tracks:
          (json['tracks'] as List<dynamic>)
              .map((e) => InternalTrack.fromJson(e as Map<String, dynamic>))
              .toList(),
      duration: (json['duration'] as num?)?.toDouble(),
      local: json['local'] as bool? ?? false,
      saf: json['saf'] as bool,
    );

Map<String, dynamic> _$InternalMediaToJson(_InternalMedia instance) =>
    <String, dynamic>{
      'libraryId': instance.libraryId,
      'itemId': instance.itemId,
      'episodeId': instance.episodeId,
      'tracks': instance.tracks,
      'duration': instance.duration,
      'local': instance.local,
      'saf': instance.saf,
    };

_InternalTrack _$InternalTrackFromJson(Map<String, dynamic> json) =>
    _InternalTrack(
      index: (json['index'] as num).toInt(),
      duration: (json['duration'] as num).toDouble(),
      url: json['url'] as String,
      start: (json['start'] as num?)?.toDouble(),
      end: (json['end'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InternalTrackToJson(_InternalTrack instance) =>
    <String, dynamic>{
      'index': instance.index,
      'duration': instance.duration,
      'url': instance.url,
      'start': instance.start,
      'end': instance.end,
    };
