import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/me/media_progress.dart';

part 'user_item_progress_updated_event.freezed.dart';
part 'user_item_progress_updated_event.g.dart';

@freezed
abstract class UserItemProgressUpdatedEvent with _$UserItemProgressUpdatedEvent {
  const factory UserItemProgressUpdatedEvent({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "data") required MediaProgress data,
  }) = _UserItemProgressUpdatedEvent;

  factory UserItemProgressUpdatedEvent.fromJson(Map<String, dynamic> json) =>
      _$UserItemProgressUpdatedEventFromJson(json);
}
