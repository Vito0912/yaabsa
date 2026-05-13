// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ServerSettings _$ServerSettingsFromJson(Map<String, dynamic> json) => _ServerSettings(
  id: json['id'] as String,
  scannerFindCovers: json['scannerFindCovers'] as bool?,
  scannerCoverProvider: json['scannerCoverProvider'] as String?,
  scannerParseSubtitle: json['scannerParseSubtitle'] as bool?,
  scannerPreferMatchedMetadata: json['scannerPreferMatchedMetadata'] as bool?,
  scannerDisableWatcher: json['scannerDisableWatcher'] as bool?,
  storeCoverWithItem: json['storeCoverWithItem'] as bool?,
  storeMetadataWithItem: json['storeMetadataWithItem'] as bool?,
  metadataFileFormat: json['metadataFileFormat'] as String?,
  rateLimitLoginRequests: (json['rateLimitLoginRequests'] as num?)?.toInt(),
  rateLimitLoginWindow: (json['rateLimitLoginWindow'] as num?)?.toInt(),
  backupSchedule: json['backupSchedule'],
  backupsToKeep: (json['backupsToKeep'] as num?)?.toInt(),
  maxBackupSize: (json['maxBackupSize'] as num?)?.toInt(),
  loggerDailyLogsToKeep: (json['loggerDailyLogsToKeep'] as num?)?.toInt(),
  loggerScannerLogsToKeep: (json['loggerScannerLogsToKeep'] as num?)?.toInt(),
  homeBookshelfView: (json['homeBookshelfView'] as num?)?.toInt(),
  bookshelfView: (json['bookshelfView'] as num?)?.toInt(),
  allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)?.map((e) => e as String).toList(),
  sortingIgnorePrefix: json['sortingIgnorePrefix'] as bool?,
  sortingPrefixes: (json['sortingPrefixes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  chromecastEnabled: json['chromecastEnabled'] as bool?,
  dateFormat: json['dateFormat'] as String?,
  language: json['language'] as String?,
  logLevel: $enumDecodeNullable(_$LogLevelEnumMap, json['logLevel']),
  version: json['version'] as String?,
);

Map<String, dynamic> _$ServerSettingsToJson(_ServerSettings instance) => <String, dynamic>{
  'id': instance.id,
  'scannerFindCovers': instance.scannerFindCovers,
  'scannerCoverProvider': instance.scannerCoverProvider,
  'scannerParseSubtitle': instance.scannerParseSubtitle,
  'scannerPreferMatchedMetadata': instance.scannerPreferMatchedMetadata,
  'scannerDisableWatcher': instance.scannerDisableWatcher,
  'storeCoverWithItem': instance.storeCoverWithItem,
  'storeMetadataWithItem': instance.storeMetadataWithItem,
  'metadataFileFormat': instance.metadataFileFormat,
  'rateLimitLoginRequests': instance.rateLimitLoginRequests,
  'rateLimitLoginWindow': instance.rateLimitLoginWindow,
  'backupSchedule': instance.backupSchedule,
  'backupsToKeep': instance.backupsToKeep,
  'maxBackupSize': instance.maxBackupSize,
  'loggerDailyLogsToKeep': instance.loggerDailyLogsToKeep,
  'loggerScannerLogsToKeep': instance.loggerScannerLogsToKeep,
  'homeBookshelfView': instance.homeBookshelfView,
  'bookshelfView': instance.bookshelfView,
  'allowedOrigins': instance.allowedOrigins,
  'sortingIgnorePrefix': instance.sortingIgnorePrefix,
  'sortingPrefixes': instance.sortingPrefixes,
  'chromecastEnabled': instance.chromecastEnabled,
  'dateFormat': instance.dateFormat,
  'language': instance.language,
  'logLevel': _$LogLevelEnumMap[instance.logLevel],
  'version': instance.version,
};

const _$LogLevelEnumMap = {LogLevel.debug: 1, LogLevel.info: 2, LogLevel.warn: 3, LogLevel.error: 4};
