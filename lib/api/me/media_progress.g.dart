// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaProgress _$MediaProgressFromJson(Map<String, dynamic> json) => _MediaProgress(
  id: json['id'] as String,
  userId: json['userId'] as String,
  libraryItemId: json['libraryItemId'] as String,
  episodeId: json['episodeId'] as String?,
  mediaItemId: json['mediaItemId'] as String,
  mediaItemType: const MediaItemTypeConverter().fromJson(json['mediaItemType'] as String),
  duration: const AllowNullableForDoubleConverter().fromJson(json['duration']),
  progress: const AllowNullableForDoubleConverter().fromJson(json['progress']),
  currentTime: const AllowNullableForDoubleConverter().fromJson(json['currentTime']),
  isFinished: json['isFinished'] as bool,
  hideFromContinueListening: json['hideFromContinueListening'] as bool?,
  ebookLocation: const IntToStringConverter().fromJson(json['ebookLocation']),
  ebookProgress: (json['ebookProgress'] as num?)?.toDouble(),
  lastUpdate: (json['lastUpdate'] as num?)?.toInt(),
  startedAt: (json['startedAt'] as num).toInt(),
  finishedAt: (json['finishedAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$MediaProgressToJson(_MediaProgress instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'libraryItemId': instance.libraryItemId,
  'episodeId': instance.episodeId,
  'mediaItemId': instance.mediaItemId,
  'mediaItemType': const MediaItemTypeConverter().toJson(instance.mediaItemType),
  'duration': const AllowNullableForDoubleConverter().toJson(instance.duration),
  'progress': const AllowNullableForDoubleConverter().toJson(instance.progress),
  'currentTime': const AllowNullableForDoubleConverter().toJson(instance.currentTime),
  'isFinished': instance.isFinished,
  'hideFromContinueListening': instance.hideFromContinueListening,
  'ebookLocation': _$JsonConverterToJson<dynamic, String>(instance.ebookLocation, const IntToStringConverter().toJson),
  'ebookProgress': instance.ebookProgress,
  'lastUpdate': instance.lastUpdate,
  'startedAt': instance.startedAt,
  'finishedAt': instance.finishedAt,
};

Json? _$JsonConverterToJson<Json, Value>(Value? value, Json? Function(Value value) toJson) =>
    value == null ? null : toJson(value);
