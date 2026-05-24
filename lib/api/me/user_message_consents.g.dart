// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_message_consents.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserMessageConsents _$UserMessageConsentsFromJson(Map<String, dynamic> json) => _UserMessageConsents(
  consents:
      (json['consents'] as List<dynamic>?)
          ?.map((e) => UserMessageConsentEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <UserMessageConsentEntry>[],
  incomingRequests:
      (json['incomingRequests'] as List<dynamic>?)
          ?.map((e) => UserMessageIncomingRequest.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <UserMessageIncomingRequest>[],
  blockedUserIds: (json['blockedUserIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$UserMessageConsentsToJson(_UserMessageConsents instance) => <String, dynamic>{
  'consents': instance.consents,
  'incomingRequests': instance.incomingRequests,
  'blockedUserIds': instance.blockedUserIds,
};

_UserMessageConsentEntry _$UserMessageConsentEntryFromJson(Map<String, dynamic> json) => _UserMessageConsentEntry(
  userId: json['userId'] as String,
  username: json['username'] as String?,
  otherAccepted: json['otherAccepted'] as bool? ?? false,
);

Map<String, dynamic> _$UserMessageConsentEntryToJson(_UserMessageConsentEntry instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
  'otherAccepted': instance.otherAccepted,
};

_UserMessageIncomingRequest _$UserMessageIncomingRequestFromJson(Map<String, dynamic> json) =>
    _UserMessageIncomingRequest(userId: json['userId'] as String, username: json['username'] as String?);

Map<String, dynamic> _$UserMessageIncomingRequestToJson(_UserMessageIncomingRequest instance) => <String, dynamic>{
  'userId': instance.userId,
  'username': instance.username,
};
