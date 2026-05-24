import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_message_consents.freezed.dart';
part 'user_message_consents.g.dart';

@freezed
abstract class UserMessageConsents with _$UserMessageConsents {
  const factory UserMessageConsents({
    @JsonKey(name: 'consents') @Default(<UserMessageConsentEntry>[]) List<UserMessageConsentEntry> consents,
    @JsonKey(name: 'incomingRequests')
    @Default(<UserMessageIncomingRequest>[])
    List<UserMessageIncomingRequest> incomingRequests,
    @JsonKey(name: 'blockedUserIds') @Default(<String>[]) List<String> blockedUserIds,
  }) = _UserMessageConsents;

  factory UserMessageConsents.fromJson(Map<String, dynamic> json) => _$UserMessageConsentsFromJson(json);
}

@freezed
abstract class UserMessageConsentEntry with _$UserMessageConsentEntry {
  const factory UserMessageConsentEntry({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'username') String? username,
    @JsonKey(name: 'otherAccepted') @Default(false) bool otherAccepted,
  }) = _UserMessageConsentEntry;

  factory UserMessageConsentEntry.fromJson(Map<String, dynamic> json) => _$UserMessageConsentEntryFromJson(json);
}

@freezed
abstract class UserMessageIncomingRequest with _$UserMessageIncomingRequest {
  const factory UserMessageIncomingRequest({
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'username') String? username,
  }) = _UserMessageIncomingRequest;

  factory UserMessageIncomingRequest.fromJson(Map<String, dynamic> json) => _$UserMessageIncomingRequestFromJson(json);
}
