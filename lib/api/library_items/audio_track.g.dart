// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AudioTrack _$AudioTrackFromJson(Map<String, dynamic> json) => _AudioTrack(
  index: (json['index'] as num?)?.toInt(),
  startOffset: (json['startOffset'] as num).toDouble(),
  duration: (json['duration'] as num).toDouble(),
  title: json['title'] as String,
  contentUrl: json['contentUrl'] as String,
  mimeType: json['mimeType'] as String,
  metadata: json['metadata'] == null ? null : LibraryFileMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AudioTrackToJson(_AudioTrack instance) => <String, dynamic>{
  'index': instance.index,
  'startOffset': instance.startOffset,
  'duration': instance.duration,
  'title': instance.title,
  'contentUrl': instance.contentUrl,
  'mimeType': instance.mimeType,
  'metadata': instance.metadata,
};
