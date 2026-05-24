import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/json/value_parsers.dart';

part 'user_message_event.freezed.dart';
part 'user_message_event.g.dart';

@freezed
abstract class SocketUserMessageEvent with _$SocketUserMessageEvent {
  const factory SocketUserMessageEvent({
    @JsonKey(name: 'message') required String message,
    @JsonKey(name: 'client') SocketUserMessageClient? client,
    @JsonKey(name: 'sender') required SocketUserMessageSender sender,
    @JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic) int? sentAt,
  }) = _SocketUserMessageEvent;

  factory SocketUserMessageEvent.fromJson(Map<String, dynamic> json) => _$SocketUserMessageEventFromJson(json);
}

@freezed
abstract class SocketUserMessageClient with _$SocketUserMessageClient {
  const factory SocketUserMessageClient({
    @JsonKey(name: 'client') String? client,
    @JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic) int? clientVersion,
    @JsonKey(name: 'clientId') String? clientId,
  }) = _SocketUserMessageClient;

  factory SocketUserMessageClient.fromJson(Map<String, dynamic> json) => _$SocketUserMessageClientFromJson(json);
}

@freezed
abstract class SocketUserMessageSender with _$SocketUserMessageSender {
  const factory SocketUserMessageSender({
    @JsonKey(name: 'id') required String id,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'type') String? type,
  }) = _SocketUserMessageSender;

  factory SocketUserMessageSender.fromJson(Map<String, dynamic> json) => _$SocketUserMessageSenderFromJson(json);
}
