// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filesystem_paths_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FilesystemPathsResponse _$FilesystemPathsResponseFromJson(Map<String, dynamic> json) => _FilesystemPathsResponse(
  posix: json['posix'] as bool,
  directories:
      (json['directories'] as List<dynamic>?)
          ?.map((e) => FilesystemDirectory.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <FilesystemDirectory>[],
);

Map<String, dynamic> _$FilesystemPathsResponseToJson(_FilesystemPathsResponse instance) => <String, dynamic>{
  'posix': instance.posix,
  'directories': instance.directories,
};
