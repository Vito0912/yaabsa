import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/tasks/abs_task.dart';

part 'abs_task_list_response.freezed.dart';
part 'abs_task_list_response.g.dart';

@freezed
abstract class AbsTaskListResponse with _$AbsTaskListResponse {
  const factory AbsTaskListResponse({
    @JsonKey(name: 'tasks') @Default(<AbsTask>[]) List<AbsTask> tasks,
    @JsonKey(name: 'queuedTaskData') AbsQueuedTaskData? queuedTaskData,
  }) = _AbsTaskListResponse;

  factory AbsTaskListResponse.fromJson(Map<String, dynamic> json) => _$AbsTaskListResponseFromJson(json);
}

@freezed
abstract class AbsQueuedTaskData with _$AbsQueuedTaskData {
  const factory AbsQueuedTaskData({
    @JsonKey(name: 'embedMetadata')
    @Default(<AbsQueuedEmbedMetadataTaskData>[])
    List<AbsQueuedEmbedMetadataTaskData> embedMetadata,
  }) = _AbsQueuedTaskData;

  factory AbsQueuedTaskData.fromJson(Map<String, dynamic> json) => _$AbsQueuedTaskDataFromJson(json);
}

@freezed
abstract class AbsQueuedEmbedMetadataTaskData with _$AbsQueuedEmbedMetadataTaskData {
  const factory AbsQueuedEmbedMetadataTaskData({
    @JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? libraryItemId,
    @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? libraryId,
  }) = _AbsQueuedEmbedMetadataTaskData;

  factory AbsQueuedEmbedMetadataTaskData.fromJson(Map<String, dynamic> json) =>
      _$AbsQueuedEmbedMetadataTaskDataFromJson(json);
}

String? _stringFromDynamic(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  final asString = value.toString().trim();
  return asString.isEmpty ? null : asString;
}
