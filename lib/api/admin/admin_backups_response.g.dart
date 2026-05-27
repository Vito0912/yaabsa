// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_backups_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminBackupsResponse _$AdminBackupsResponseFromJson(Map<String, dynamic> json) => _AdminBackupsResponse(
  backups:
      (json['backups'] as List<dynamic>?)?.map((e) => AdminBackup.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AdminBackup>[],
  backupLocation: json['backupLocation'] as String?,
  backupPathEnvSet: json['backupPathEnvSet'] as bool? ?? false,
);

Map<String, dynamic> _$AdminBackupsResponseToJson(_AdminBackupsResponse instance) => <String, dynamic>{
  'backups': instance.backups,
  'backupLocation': instance.backupLocation,
  'backupPathEnvSet': instance.backupPathEnvSet,
};
