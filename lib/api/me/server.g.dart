// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Server _$ServerFromJson(Map<String, dynamic> json) => _Server(
  externalPort: (json['port'] as num).toInt(),
  externalHost: json['host'] as String,
  externalSsl: json['ssl'] as bool,
  externalSubdirectory: json['subdirectory'] as String?,
  headers: (json['headers'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as String)),
  localHost: json['localHost'] as String?,
  localPort: (json['localPort'] as num?)?.toInt(),
  localSsl: json['localSsl'] as bool?,
  localSubdirectory: json['localSubdirectory'] as String?,
  activeConnection:
      $enumDecodeNullable(
        _$ServerConnectionEnumMap,
        json['activeConnection'],
        unknownValue: ServerConnection.external,
      ) ??
      ServerConnection.external,
);

Map<String, dynamic> _$ServerToJson(_Server instance) => <String, dynamic>{
  'port': instance.externalPort,
  'host': instance.externalHost,
  'ssl': instance.externalSsl,
  'subdirectory': instance.externalSubdirectory,
  'headers': instance.headers,
  'localHost': instance.localHost,
  'localPort': instance.localPort,
  'localSsl': instance.localSsl,
  'localSubdirectory': instance.localSubdirectory,
  'activeConnection': _$ServerConnectionEnumMap[instance.activeConnection]!,
};

const _$ServerConnectionEnumMap = {ServerConnection.external: 'external', ServerConnection.local: 'local'};
