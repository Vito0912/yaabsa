// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_session_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncSessionRequest _$SyncSessionRequestFromJson(Map<String, dynamic> json) =>
    _SyncSessionRequest(
      currentTime: (json['currentTime'] as num).toDouble(),
      timeListened: (json['timeListened'] as num).toDouble(),
      duration: (json['duration'] as num).toDouble(),
    );

Map<String, dynamic> _$SyncSessionRequestToJson(_SyncSessionRequest instance) =>
    <String, dynamic>{
      'currentTime': instance.currentTime,
      'timeListened': instance.timeListened,
      'duration': instance.duration,
    };
