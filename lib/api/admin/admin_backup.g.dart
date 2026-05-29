// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_backup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminBackup _$AdminBackupFromJson(Map<String, dynamic> json) => _AdminBackup(
  id: json['id'] as String,
  key: json['key'] as String?,
  backupDirPath: json['backupDirPath'] as String?,
  datePretty: json['datePretty'] as String?,
  fullPath: json['fullPath'] as String?,
  path: json['path'] as String?,
  filename: json['filename'] as String?,
  fileSize: (json['fileSize'] as num?)?.toInt(),
  createdAt: (json['createdAt'] as num?)?.toInt(),
  serverVersion: json['serverVersion'] as String?,
);

Map<String, dynamic> _$AdminBackupToJson(_AdminBackup instance) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'backupDirPath': instance.backupDirPath,
  'datePretty': instance.datePretty,
  'fullPath': instance.fullPath,
  'path': instance.path,
  'filename': instance.filename,
  'fileSize': instance.fileSize,
  'createdAt': instance.createdAt,
  'serverVersion': instance.serverVersion,
};
