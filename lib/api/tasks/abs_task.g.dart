// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abs_task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbsTask _$AbsTaskFromJson(Map<String, dynamic> json) => _AbsTask(
  id: json['id'] as String,
  action: json['action'] as String? ?? '',
  data: json['data'] == null ? null : AbsTaskData.fromJson(json['data'] as Map<String, dynamic>),
  title: json['title'] as String?,
  titleKey: json['titleKey'] as String?,
  titleSubs: json['titleSubs'] == null ? const <String>[] : _stringListFromDynamic(json['titleSubs']),
  description: json['description'] as String?,
  descriptionKey: json['descriptionKey'] as String?,
  descriptionSubs: json['descriptionSubs'] == null ? const <String>[] : _stringListFromDynamic(json['descriptionSubs']),
  error: json['error'] as String?,
  errorKey: json['errorKey'] as String?,
  errorSubs: json['errorSubs'] == null ? const <String>[] : _stringListFromDynamic(json['errorSubs']),
  showSuccess: json['showSuccess'] as bool? ?? false,
  isFailed: json['isFailed'] as bool? ?? false,
  isFinished: json['isFinished'] as bool? ?? false,
  startedAt: jsonIntFromDynamic(json['startedAt']),
  finishedAt: jsonIntFromDynamic(json['finishedAt']),
);

Map<String, dynamic> _$AbsTaskToJson(_AbsTask instance) => <String, dynamic>{
  'id': instance.id,
  'action': instance.action,
  'data': instance.data,
  'title': instance.title,
  'titleKey': instance.titleKey,
  'titleSubs': instance.titleSubs,
  'description': instance.description,
  'descriptionKey': instance.descriptionKey,
  'descriptionSubs': instance.descriptionSubs,
  'error': instance.error,
  'errorKey': instance.errorKey,
  'errorSubs': instance.errorSubs,
  'showSuccess': instance.showSuccess,
  'isFailed': instance.isFailed,
  'isFinished': instance.isFinished,
  'startedAt': instance.startedAt,
  'finishedAt': instance.finishedAt,
};

_AbsTaskData _$AbsTaskDataFromJson(Map<String, dynamic> json) => _AbsTaskData(
  libraryItemId: _stringFromDynamic(json['libraryItemId']),
  libraryId: _stringFromDynamic(json['libraryId']),
  ino: _stringFromDynamic(json['ino']),
  encodeOptions: json['encodeOptions'] == null
      ? null
      : AbsTaskEncodeOptions.fromJson(json['encodeOptions'] as Map<String, dynamic>),
  scanResults: json['scanResults'] == null
      ? null
      : AbsTaskScanResults.fromJson(json['scanResults'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AbsTaskDataToJson(_AbsTaskData instance) => <String, dynamic>{
  'libraryItemId': instance.libraryItemId,
  'libraryId': instance.libraryId,
  'ino': instance.ino,
  'encodeOptions': instance.encodeOptions,
  'scanResults': instance.scanResults,
};

_AbsTaskEncodeOptions _$AbsTaskEncodeOptionsFromJson(Map<String, dynamic> json) => _AbsTaskEncodeOptions(
  codec: _stringFromDynamic(json['codec']),
  bitrate: _stringFromDynamic(json['bitrate']),
  channels: jsonIntFromDynamic(json['channels']),
);

Map<String, dynamic> _$AbsTaskEncodeOptionsToJson(_AbsTaskEncodeOptions instance) => <String, dynamic>{
  'codec': instance.codec,
  'bitrate': instance.bitrate,
  'channels': instance.channels,
};

_AbsTaskScanResults _$AbsTaskScanResultsFromJson(Map<String, dynamic> json) => _AbsTaskScanResults(
  added: jsonIntFromDynamic(json['added']),
  updated: jsonIntFromDynamic(json['updated']),
  missing: jsonIntFromDynamic(json['missing']),
  elapsed: jsonIntFromDynamic(json['elapsed']),
);

Map<String, dynamic> _$AbsTaskScanResultsToJson(_AbsTaskScanResults instance) => <String, dynamic>{
  'added': instance.added,
  'updated': instance.updated,
  'missing': instance.missing,
  'elapsed': instance.elapsed,
};
