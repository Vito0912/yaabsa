// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_listened_to.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemsListenedTo _$ItemsListenedToFromJson(Map<String, dynamic> json) =>
    _ItemsListenedTo(
      id: json['id'] as String?,
      timeListening: (json['timeListening'] as num?)?.toDouble(),
      mediaMetadata:
          json['mediaMetadata'] == null
              ? null
              : Metadata.fromJson(
                json['mediaMetadata'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$ItemsListenedToToJson(_ItemsListenedTo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timeListening': instance.timeListening,
      'mediaMetadata': instance.mediaMetadata,
    };
