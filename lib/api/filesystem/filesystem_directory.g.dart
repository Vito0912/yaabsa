// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filesystem_directory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilesystemDirectory _$FilesystemDirectoryFromJson(Map<String, dynamic> json) => _FilesystemDirectory(
  path: json['path'] as String,
  dirname: json['dirname'] as String,
  level: (json['level'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$FilesystemDirectoryToJson(_FilesystemDirectory instance) => <String, dynamic>{
  'path': instance.path,
  'dirname': instance.dirname,
  'level': instance.level,
};
