import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'abs_task.freezed.dart';
part 'abs_task.g.dart';

@freezed
abstract class AbsTask with _$AbsTask {
  const factory AbsTask({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'action') @Default('') String action,
    @JsonKey(name: 'data') AbsTaskData? data,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'titleKey') String? titleKey,
    @JsonKey(name: 'titleSubs', fromJson: _stringListFromDynamic) @Default(<String>[]) List<String> titleSubs,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'descriptionKey') String? descriptionKey,
    @JsonKey(name: 'descriptionSubs', fromJson: _stringListFromDynamic)
    @Default(<String>[])
    List<String> descriptionSubs,
    @JsonKey(name: 'error') String? error,
    @JsonKey(name: 'errorKey') String? errorKey,
    @JsonKey(name: 'errorSubs', fromJson: _stringListFromDynamic) @Default(<String>[]) List<String> errorSubs,
    @JsonKey(name: 'showSuccess') @Default(false) bool showSuccess,
    @JsonKey(name: 'isFailed') @Default(false) bool isFailed,
    @JsonKey(name: 'isFinished') @Default(false) bool isFinished,
    @JsonKey(name: 'startedAt', fromJson: jsonIntFromDynamic) int? startedAt,
    @JsonKey(name: 'finishedAt', fromJson: jsonIntFromDynamic) int? finishedAt,
  }) = _AbsTask;

  factory AbsTask.fromJson(Map<String, dynamic> json) => _$AbsTaskFromJson(json);
}

@freezed
abstract class AbsTaskData with _$AbsTaskData {
  const factory AbsTaskData({
    @JsonKey(name: 'libraryItemId', fromJson: _stringFromDynamic) String? libraryItemId,
    @JsonKey(name: 'libraryId', fromJson: _stringFromDynamic) String? libraryId,
    @JsonKey(name: 'ino', fromJson: _stringFromDynamic) String? ino,
    @JsonKey(name: 'encodeOptions') AbsTaskEncodeOptions? encodeOptions,
    @JsonKey(name: 'scanResults') AbsTaskScanResults? scanResults,
  }) = _AbsTaskData;

  factory AbsTaskData.fromJson(Map<String, dynamic> json) => _$AbsTaskDataFromJson(json);
}

@freezed
abstract class AbsTaskEncodeOptions with _$AbsTaskEncodeOptions {
  const factory AbsTaskEncodeOptions({
    @JsonKey(name: 'codec', fromJson: _stringFromDynamic) String? codec,
    @JsonKey(name: 'bitrate', fromJson: _stringFromDynamic) String? bitrate,
    @JsonKey(name: 'channels', fromJson: jsonIntFromDynamic) int? channels,
  }) = _AbsTaskEncodeOptions;

  factory AbsTaskEncodeOptions.fromJson(Map<String, dynamic> json) => _$AbsTaskEncodeOptionsFromJson(json);
}

@freezed
abstract class AbsTaskScanResults with _$AbsTaskScanResults {
  const factory AbsTaskScanResults({
    @JsonKey(name: 'added', fromJson: jsonIntFromDynamic) int? added,
    @JsonKey(name: 'updated', fromJson: jsonIntFromDynamic) int? updated,
    @JsonKey(name: 'missing', fromJson: jsonIntFromDynamic) int? missing,
    @JsonKey(name: 'elapsed', fromJson: jsonIntFromDynamic) int? elapsed,
  }) = _AbsTaskScanResults;

  factory AbsTaskScanResults.fromJson(Map<String, dynamic> json) => _$AbsTaskScanResultsFromJson(json);
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

List<String> _stringListFromDynamic(Object? value) {
  if (value is! List) {
    return const <String>[];
  }

  return value.map((entry) => _stringFromDynamic(entry)).whereType<String>().toList(growable: false);
}
