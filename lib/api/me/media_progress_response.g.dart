// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_progress_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaProgressResponse _$MediaProgressResponseFromJson(Map<String, dynamic> json) => _MediaProgressResponse(
  mediaProgress:
      (json['mediaProgress'] as List<dynamic>?)
          ?.map((e) => MediaProgress.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MediaProgress>[],
);

Map<String, dynamic> _$MediaProgressResponseToJson(_MediaProgressResponse instance) => <String, dynamic>{
  'mediaProgress': instance.mediaProgress,
};
