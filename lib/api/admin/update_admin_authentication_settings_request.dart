import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_admin_authentication_settings_request.freezed.dart';
part 'update_admin_authentication_settings_request.g.dart';

@freezed
abstract class UpdateAdminAuthenticationSettingsRequest with _$UpdateAdminAuthenticationSettingsRequest {
  const factory UpdateAdminAuthenticationSettingsRequest({
    @JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,
    @JsonKey(name: 'authActiveAuthMethods') List<String>? authActiveAuthMethods,
    @JsonKey(name: 'authOpenIDIssuerURL') String? authOpenIdIssuerUrl,
    @JsonKey(name: 'authOpenIDAuthorizationURL') String? authOpenIdAuthorizationUrl,
    @JsonKey(name: 'authOpenIDTokenURL') String? authOpenIdTokenUrl,
    @JsonKey(name: 'authOpenIDUserInfoURL') String? authOpenIdUserInfoUrl,
    @JsonKey(name: 'authOpenIDJwksURL') String? authOpenIdJwksUrl,
    @JsonKey(name: 'authOpenIDLogoutURL') String? authOpenIdLogoutUrl,
    @JsonKey(name: 'authOpenIDClientID') String? authOpenIdClientId,
    @JsonKey(name: 'authOpenIDClientSecret') String? authOpenIdClientSecret,
    @JsonKey(name: 'authOpenIDTokenSigningAlgorithm') String? authOpenIdTokenSigningAlgorithm,
    @JsonKey(name: 'authOpenIDButtonText') String? authOpenIdButtonText,
    @JsonKey(name: 'authOpenIDAutoLaunch') bool? authOpenIdAutoLaunch,
    @JsonKey(name: 'authOpenIDAutoRegister') bool? authOpenIdAutoRegister,
    @JsonKey(name: 'authOpenIDMatchExistingBy') String? authOpenIdMatchExistingBy,
    @JsonKey(name: 'authOpenIDMobileRedirectURIs') List<String>? authOpenIdMobileRedirectUris,
    @JsonKey(name: 'authOpenIDGroupClaim') String? authOpenIdGroupClaim,
    @JsonKey(name: 'authOpenIDAdvancedPermsClaim') String? authOpenIdAdvancedPermsClaim,
    @JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') String? authOpenIdSubfolderForRedirectUrls,
  }) = _UpdateAdminAuthenticationSettingsRequest;

  factory UpdateAdminAuthenticationSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdminAuthenticationSettingsRequestFromJson(json);
}
