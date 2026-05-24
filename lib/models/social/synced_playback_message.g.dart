// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'synced_playback_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncedPlaybackMessage _$SyncedPlaybackMessageFromJson(Map<String, dynamic> json) => _SyncedPlaybackMessage(
  feature: json['feature'] as String,
  type: json['type'] as String,
  sessionId: json['sessionId'] as String,
  messageVersion: json['messageVersion'] == null ? 1 : jsonIntRequiredFromDynamic(json['messageVersion']),
  minClientVersion: json['minClientVersion'] == null ? 1 : jsonIntRequiredFromDynamic(json['minClientVersion']),
  invite: json['invite'] == null ? null : SyncedPlaybackInvitePayload.fromJson(json['invite'] as Map<String, dynamic>),
  inviteResponse: json['inviteResponse'] == null
      ? null
      : SyncedPlaybackInviteResponsePayload.fromJson(json['inviteResponse'] as Map<String, dynamic>),
  control: json['control'] == null
      ? null
      : SyncedPlaybackControlPayload.fromJson(json['control'] as Map<String, dynamic>),
  sessionEnd: json['sessionEnd'] == null
      ? null
      : SyncedPlaybackSessionEndPayload.fromJson(json['sessionEnd'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SyncedPlaybackMessageToJson(_SyncedPlaybackMessage instance) => <String, dynamic>{
  'feature': instance.feature,
  'type': instance.type,
  'sessionId': instance.sessionId,
  'messageVersion': instance.messageVersion,
  'minClientVersion': instance.minClientVersion,
  'invite': instance.invite,
  'inviteResponse': instance.inviteResponse,
  'control': instance.control,
  'sessionEnd': instance.sessionEnd,
};

_SyncedPlaybackInvitePayload _$SyncedPlaybackInvitePayloadFromJson(Map<String, dynamic> json) =>
    _SyncedPlaybackInvitePayload(
      snapshot: json['snapshot'] == null
          ? null
          : SyncedPlaybackControlPayload.fromJson(json['snapshot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SyncedPlaybackInvitePayloadToJson(_SyncedPlaybackInvitePayload instance) => <String, dynamic>{
  'snapshot': instance.snapshot,
};

_SyncedPlaybackInviteResponsePayload _$SyncedPlaybackInviteResponsePayloadFromJson(Map<String, dynamic> json) =>
    _SyncedPlaybackInviteResponsePayload(
      decision: json['decision'] as String,
      reason: json['reason'] as String?,
      snapshot: json['snapshot'] == null
          ? null
          : SyncedPlaybackControlPayload.fromJson(json['snapshot'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SyncedPlaybackInviteResponsePayloadToJson(_SyncedPlaybackInviteResponsePayload instance) =>
    <String, dynamic>{'decision': instance.decision, 'reason': instance.reason, 'snapshot': instance.snapshot};

_SyncedPlaybackControlPayload _$SyncedPlaybackControlPayloadFromJson(Map<String, dynamic> json) =>
    _SyncedPlaybackControlPayload(
      itemId: json['itemId'] as String?,
      episodeId: json['episodeId'] as String?,
      positionMs: json['positionMs'] == null ? 0 : jsonIntRequiredFromDynamic(json['positionMs']),
      speed: json['speed'] == null ? 1.0 : jsonDoubleRequiredFromDynamic(json['speed']),
      sequence: json['sequence'] == null ? 0 : jsonIntRequiredFromDynamic(json['sequence']),
      isBuffering: json['isBuffering'] as bool? ?? false,
      isPlaying: json['isPlaying'] as bool? ?? false,
      isStopped: json['isStopped'] as bool? ?? false,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$SyncedPlaybackControlPayloadToJson(_SyncedPlaybackControlPayload instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'episodeId': instance.episodeId,
  'positionMs': instance.positionMs,
  'speed': instance.speed,
  'sequence': instance.sequence,
  'isBuffering': instance.isBuffering,
  'isPlaying': instance.isPlaying,
  'isStopped': instance.isStopped,
  'reason': instance.reason,
};

_SyncedPlaybackSessionEndPayload _$SyncedPlaybackSessionEndPayloadFromJson(Map<String, dynamic> json) =>
    _SyncedPlaybackSessionEndPayload(reason: json['reason'] as String?);

Map<String, dynamic> _$SyncedPlaybackSessionEndPayloadToJson(_SyncedPlaybackSessionEndPayload instance) =>
    <String, dynamic>{'reason': instance.reason};
