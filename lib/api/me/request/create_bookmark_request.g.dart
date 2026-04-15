// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_bookmark_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateBookmarkRequest _$CreateBookmarkRequestFromJson(Map<String, dynamic> json) =>
    _CreateBookmarkRequest(time: (json['time'] as num).toInt(), title: json['title'] as String);

Map<String, dynamic> _$CreateBookmarkRequestToJson(_CreateBookmarkRequest instance) => <String, dynamic>{
  'time': instance.time,
  'title': instance.title,
};
