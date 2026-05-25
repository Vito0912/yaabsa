// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_log_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerLogEntry _$ServerLogEntryFromJson(Map<String, dynamic> json) => _ServerLogEntry(
  timestamp: json['timestamp'] as String,
  source: json['source'] as String?,
  message: json['message'] as String,
  levelName: json['levelName'] as String,
  level: jsonIntRequiredFromDynamic(json['level']),
);

Map<String, dynamic> _$ServerLogEntryToJson(_ServerLogEntry instance) => <String, dynamic>{
  'timestamp': instance.timestamp,
  'source': instance.source,
  'message': instance.message,
  'levelName': instance.levelName,
  'level': instance.level,
};
