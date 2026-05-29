// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_backup_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminBackupListResponse _$AdminBackupListResponseFromJson(Map<String, dynamic> json) => _AdminBackupListResponse(
  backups:
      (json['backups'] as List<dynamic>?)?.map((e) => AdminBackup.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AdminBackup>[],
);

Map<String, dynamic> _$AdminBackupListResponseToJson(_AdminBackupListResponse instance) => <String, dynamic>{
  'backups': instance.backups,
};
