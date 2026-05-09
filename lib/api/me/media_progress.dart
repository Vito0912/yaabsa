import 'package:freezed_annotation/freezed_annotation.dart';

import 'media_item_type.dart';
import 'media_item_type_converter.dart';

part 'media_progress.freezed.dart';
part 'media_progress.g.dart';

@freezed
abstract class MediaProgress with _$MediaProgress {
  const factory MediaProgress({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "userId") required String userId,
    @JsonKey(name: "libraryItemId") required String libraryItemId,
    @JsonKey(name: "episodeId") required String? episodeId,
    @JsonKey(name: "mediaItemId") required String mediaItemId,
    @JsonKey(name: "mediaItemType") @MediaItemTypeConverter() required MediaItemType mediaItemType,
    @AllowNullableForDoubleConverter() @JsonKey(name: "duration") required double duration,
    @AllowNullableForDoubleConverter() @JsonKey(name: "progress") required double progress,
    @AllowNullableForDoubleConverter() @JsonKey(name: "currentTime") required double currentTime,
    @JsonKey(name: "isFinished") required bool isFinished,
    @JsonKey(name: "hideFromContinueListening") bool? hideFromContinueListening,
    @IntToStringConverter() @JsonKey(name: "ebookLocation") String? ebookLocation,
    @JsonKey(name: "ebookProgress") double? ebookProgress,
    @JsonKey(name: "lastUpdate") required int? lastUpdate,
    @JsonKey(name: "startedAt") required int startedAt,
    @JsonKey(name: "finishedAt") required int? finishedAt,
  }) = _MediaProgress;

  factory MediaProgress.fromJson(Map<String, dynamic> json) => _$MediaProgressFromJson(json);
}

class IntToStringConverter implements JsonConverter<String, dynamic> {
  const IntToStringConverter();

  @override
  String fromJson(dynamic json) {
    return json?.toString() ?? '';
  }

  @override
  dynamic toJson(String object) {
    return object;
  }
}

class AllowNullableForDoubleConverter implements JsonConverter<double, dynamic> {
  const AllowNullableForDoubleConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null || (json is String && json.isEmpty)) {
      return 0;
    }
    if (json is num) {
      return json.toDouble();
    }
    throw FormatException('Expected a number or null, but got: $json');
  }

  @override
  dynamic toJson(double object) {
    return object;
  }
}
