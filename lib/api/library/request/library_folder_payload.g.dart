// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_folder_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryFolderPayload _$LibraryFolderPayloadFromJson(Map<String, dynamic> json) => _LibraryFolderPayload(
  id: json['id'] as String?,
  fullPath: json['fullPath'] as String?,
  path: json['path'] as String?,
  libraryId: json['libraryId'] as String?,
  addedAt: (json['addedAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$LibraryFolderPayloadToJson(_LibraryFolderPayload instance) => <String, dynamic>{
  'id': ?instance.id,
  'fullPath': ?instance.fullPath,
  'path': ?instance.path,
  'libraryId': ?instance.libraryId,
  'addedAt': ?instance.addedAt,
};
