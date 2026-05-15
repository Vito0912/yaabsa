// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logger_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoggerData _$LoggerDataFromJson(Map<String, dynamic> json) => _LoggerData(
  currentDailyLogs: json['currentDailyLogs'] == null
      ? const <ServerLogEntry>[]
      : _serverLogEntriesFromJson(json['currentDailyLogs']),
);

Map<String, dynamic> _$LoggerDataToJson(_LoggerData instance) => <String, dynamic>{
  'currentDailyLogs': instance.currentDailyLogs,
};
