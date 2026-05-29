// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_library_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateLibraryRequest _$CreateLibraryRequestFromJson(Map<String, dynamic> json) => _CreateLibraryRequest(
  name: json['name'] as String,
  folders: (json['folders'] as List<dynamic>)
      .map((e) => LibraryFolderPayload.fromJson(e as Map<String, dynamic>))
      .toList(),
  provider: json['provider'] as String?,
  icon: json['icon'] as String?,
  mediaType: json['mediaType'] as String?,
  settings: json['settings'] == null ? null : LibrarySettings.fromJson(json['settings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateLibraryRequestToJson(_CreateLibraryRequest instance) => <String, dynamic>{
  'name': instance.name,
  'folders': instance.folders,
  'provider': instance.provider,
  'icon': instance.icon,
  'mediaType': instance.mediaType,
  'settings': instance.settings,
};
