// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_library_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateLibraryRequest _$UpdateLibraryRequestFromJson(Map<String, dynamic> json) => _UpdateLibraryRequest(
  name: json['name'] as String?,
  displayOrder: (json['displayOrder'] as num?)?.toInt(),
  icon: json['icon'] as String?,
  mediaType: json['mediaType'] as String?,
  provider: json['provider'] as String?,
  settings: json['settings'] == null
      ? null
      : UpdateLibrarySettingsRequest.fromJson(json['settings'] as Map<String, dynamic>),
  folders: (json['folders'] as List<dynamic>?)
      ?.map((e) => LibraryFolderPayload.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateLibraryRequestToJson(_UpdateLibraryRequest instance) => <String, dynamic>{
  'name': ?instance.name,
  'displayOrder': ?instance.displayOrder,
  'icon': ?instance.icon,
  'mediaType': ?instance.mediaType,
  'provider': ?instance.provider,
  'settings': ?instance.settings,
  'folders': ?instance.folders,
};
