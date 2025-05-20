// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_library_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayLibraryItemRequest _$PlayLibraryItemRequestFromJson(Map<String, dynamic> json) => _PlayLibraryItemRequest(
  deviceInfo: DeviceInfo.fromJson(json['deviceInfo'] as Map<String, dynamic>),
  forceDirectPlay: json['forceDirectPlay'] as bool? ?? false,
  forceTranscode: json['forceTranscode'] as bool? ?? false,
  supportedMimeTypes: (json['supportedMimeTypes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
  mediaPlayer: json['mediaPlayer'] as String,
);

Map<String, dynamic> _$PlayLibraryItemRequestToJson(_PlayLibraryItemRequest instance) => <String, dynamic>{
  'deviceInfo': instance.deviceInfo,
  'forceDirectPlay': instance.forceDirectPlay,
  'forceTranscode': instance.forceTranscode,
  'supportedMimeTypes': instance.supportedMimeTypes,
  'mediaPlayer': instance.mediaPlayer,
};
