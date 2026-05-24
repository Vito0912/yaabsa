import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'synced_playback_message.freezed.dart';
part 'synced_playback_message.g.dart';

@freezed
abstract class SyncedPlaybackMessage with _$SyncedPlaybackMessage {
  const factory SyncedPlaybackMessage({
    @JsonKey(name: 'feature') required String feature,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'sessionId') required String sessionId,
    @JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic) @Default(1) int messageVersion,
    @JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic) @Default(1) int minClientVersion,
    @JsonKey(name: 'invite') SyncedPlaybackInvitePayload? invite,
    @JsonKey(name: 'inviteResponse') SyncedPlaybackInviteResponsePayload? inviteResponse,
    @JsonKey(name: 'control') SyncedPlaybackControlPayload? control,
    @JsonKey(name: 'sessionEnd') SyncedPlaybackSessionEndPayload? sessionEnd,
  }) = _SyncedPlaybackMessage;

  factory SyncedPlaybackMessage.fromJson(Map<String, dynamic> json) => _$SyncedPlaybackMessageFromJson(json);
}

@freezed
abstract class SyncedPlaybackInvitePayload with _$SyncedPlaybackInvitePayload {
  const factory SyncedPlaybackInvitePayload({@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? snapshot}) =
      _SyncedPlaybackInvitePayload;

  factory SyncedPlaybackInvitePayload.fromJson(Map<String, dynamic> json) =>
      _$SyncedPlaybackInvitePayloadFromJson(json);
}

@freezed
abstract class SyncedPlaybackInviteResponsePayload with _$SyncedPlaybackInviteResponsePayload {
  const factory SyncedPlaybackInviteResponsePayload({
    @JsonKey(name: 'decision') required String decision,
    @JsonKey(name: 'reason') String? reason,
    @JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? snapshot,
  }) = _SyncedPlaybackInviteResponsePayload;

  factory SyncedPlaybackInviteResponsePayload.fromJson(Map<String, dynamic> json) =>
      _$SyncedPlaybackInviteResponsePayloadFromJson(json);
}

@freezed
abstract class SyncedPlaybackControlPayload with _$SyncedPlaybackControlPayload {
  const factory SyncedPlaybackControlPayload({
    @JsonKey(name: 'itemId') String? itemId,
    @JsonKey(name: 'episodeId') String? episodeId,
    @JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic) @Default(0) int positionMs,
    @JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic) @Default(1.0) double speed,
    @JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic) @Default(0) int sequence,
    @JsonKey(name: 'isBuffering') @Default(false) bool isBuffering,
    @JsonKey(name: 'isPlaying') @Default(false) bool isPlaying,
    @JsonKey(name: 'isStopped') @Default(false) bool isStopped,
    @JsonKey(name: 'reason') String? reason,
  }) = _SyncedPlaybackControlPayload;

  factory SyncedPlaybackControlPayload.fromJson(Map<String, dynamic> json) =>
      _$SyncedPlaybackControlPayloadFromJson(json);
}

@freezed
abstract class SyncedPlaybackSessionEndPayload with _$SyncedPlaybackSessionEndPayload {
  const factory SyncedPlaybackSessionEndPayload({@JsonKey(name: 'reason') String? reason}) =
      _SyncedPlaybackSessionEndPayload;

  factory SyncedPlaybackSessionEndPayload.fromJson(Map<String, dynamic> json) =>
      _$SyncedPlaybackSessionEndPayloadFromJson(json);
}
