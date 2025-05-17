// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryFile _$LibraryFileFromJson(Map<String, dynamic> json) => _LibraryFile(
  ino: json['ino'] as String,
  metadata: LibraryFileMetadata.fromJson(
    json['metadata'] as Map<String, dynamic>,
  ),
  isSupplementary: json['isSupplementary'] as bool?,
  addedAt: (json['addedAt'] as num).toInt(),
  updatedAt: (json['updatedAt'] as num?)?.toInt(),
  fileType: json['fileType'] as String?,
);

Map<String, dynamic> _$LibraryFileToJson(_LibraryFile instance) =>
    <String, dynamic>{
      'ino': instance.ino,
      'metadata': instance.metadata,
      'isSupplementary': instance.isSupplementary,
      'addedAt': instance.addedAt,
      'updatedAt': instance.updatedAt,
      'fileType': instance.fileType,
    };
