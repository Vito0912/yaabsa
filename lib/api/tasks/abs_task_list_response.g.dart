// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'abs_task_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbsTaskListResponse _$AbsTaskListResponseFromJson(Map<String, dynamic> json) => _AbsTaskListResponse(
  tasks:
      (json['tasks'] as List<dynamic>?)?.map((e) => AbsTask.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AbsTask>[],
  queuedTaskData: json['queuedTaskData'] == null
      ? null
      : AbsQueuedTaskData.fromJson(json['queuedTaskData'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AbsTaskListResponseToJson(_AbsTaskListResponse instance) => <String, dynamic>{
  'tasks': instance.tasks,
  'queuedTaskData': instance.queuedTaskData,
};

_AbsQueuedTaskData _$AbsQueuedTaskDataFromJson(Map<String, dynamic> json) => _AbsQueuedTaskData(
  embedMetadata:
      (json['embedMetadata'] as List<dynamic>?)
          ?.map((e) => AbsQueuedEmbedMetadataTaskData.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AbsQueuedEmbedMetadataTaskData>[],
);

Map<String, dynamic> _$AbsQueuedTaskDataToJson(_AbsQueuedTaskData instance) => <String, dynamic>{
  'embedMetadata': instance.embedMetadata,
};

_AbsQueuedEmbedMetadataTaskData _$AbsQueuedEmbedMetadataTaskDataFromJson(Map<String, dynamic> json) =>
    _AbsQueuedEmbedMetadataTaskData(
      libraryItemId: jsonStringFromDynamic(json['libraryItemId']),
      libraryId: jsonStringFromDynamic(json['libraryId']),
    );

Map<String, dynamic> _$AbsQueuedEmbedMetadataTaskDataToJson(_AbsQueuedEmbedMetadataTaskData instance) =>
    <String, dynamic>{'libraryItemId': instance.libraryItemId, 'libraryId': instance.libraryId};
