// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryFolder _$LibraryFolderFromJson(Map<String, dynamic> json) => _LibraryFolder(
  id: json['id'] as String,
  fullPath: json['fullPath'] as String,
  libraryId: json['libraryId'] as String,
  addedAt: (json['addedAt'] as num?)?.toInt(),
);

Map<String, dynamic> _$LibraryFolderToJson(_LibraryFolder instance) => <String, dynamic>{
  'id': instance.id,
  'fullPath': instance.fullPath,
  'libraryId': instance.libraryId,
  'addedAt': instance.addedAt,
};
