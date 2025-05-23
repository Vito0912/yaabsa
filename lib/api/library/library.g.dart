// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Library _$LibraryFromJson(Map<String, dynamic> json) => _Library(
  id: json['id'] as String,
  name: json['name'] as String,
  displayOrder: (json['displayOrder'] as num).toInt(),
  icon: json['icon'] as String,
  mediaType: json['mediaType'] as String,
  provider: json['provider'] as String,
  lastScan: (json['lastScan'] as num?)?.toInt(),
  lastScanVersion: json['lastScanVersion'] as String?,
  createdAt: (json['createdAt'] as num).toInt(),
  lastUpdate: (json['lastUpdate'] as num?)?.toInt(),
  settings: LibrarySettings.fromJson(json['settings'] as Map<String, dynamic>),
  folders:
      (json['folders'] as List<dynamic>?)
          ?.map((e) => LibraryFolder.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$LibraryToJson(_Library instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'displayOrder': instance.displayOrder,
  'icon': instance.icon,
  'mediaType': instance.mediaType,
  'provider': instance.provider,
  'lastScan': instance.lastScan,
  'lastScanVersion': instance.lastScanVersion,
  'createdAt': instance.createdAt,
  'lastUpdate': instance.lastUpdate,
  'settings': instance.settings,
  'folders': instance.folders,
};
