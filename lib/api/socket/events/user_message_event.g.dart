// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_message_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SocketUserMessageEvent _$SocketUserMessageEventFromJson(Map<String, dynamic> json) => _SocketUserMessageEvent(
  message: json['message'] as String,
  client: json['client'] == null ? null : SocketUserMessageClient.fromJson(json['client'] as Map<String, dynamic>),
  sender: SocketUserMessageSender.fromJson(json['sender'] as Map<String, dynamic>),
  sentAt: jsonIntFromDynamic(json['sentAt']),
);

Map<String, dynamic> _$SocketUserMessageEventToJson(_SocketUserMessageEvent instance) => <String, dynamic>{
  'message': instance.message,
  'client': instance.client,
  'sender': instance.sender,
  'sentAt': instance.sentAt,
};

_SocketUserMessageClient _$SocketUserMessageClientFromJson(Map<String, dynamic> json) => _SocketUserMessageClient(
  client: json['client'] as String?,
  clientVersion: jsonIntFromDynamic(json['clientVersion']),
  clientId: json['clientId'] as String?,
);

Map<String, dynamic> _$SocketUserMessageClientToJson(_SocketUserMessageClient instance) => <String, dynamic>{
  'client': instance.client,
  'clientVersion': instance.clientVersion,
  'clientId': instance.clientId,
};

_SocketUserMessageSender _$SocketUserMessageSenderFromJson(Map<String, dynamic> json) => _SocketUserMessageSender(
  id: json['id'] as String,
  username: json['username'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$SocketUserMessageSenderToJson(_SocketUserMessageSender instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'type': instance.type,
};
