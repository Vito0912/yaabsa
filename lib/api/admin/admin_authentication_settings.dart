import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_authentication_settings.freezed.dart';
part 'admin_authentication_settings.g.dart';

@freezed
abstract class AdminAuthenticationSettings with _$AdminAuthenticationSettings {
  const AdminAuthenticationSettings._();

  const factory AdminAuthenticationSettings({
    @JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,
    @JsonKey(name: 'authActiveAuthMethods') @Default(<String>['local']) List<String> authActiveAuthMethods,
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
    @JsonKey(name: 'authOpenIDAutoLaunch') @Default(false) bool authOpenIdAutoLaunch,
    @JsonKey(name: 'authOpenIDAutoRegister') @Default(false) bool authOpenIdAutoRegister,
    @JsonKey(name: 'authOpenIDMatchExistingBy') String? authOpenIdMatchExistingBy,
    @JsonKey(name: 'authOpenIDMobileRedirectURIs') @Default(<String>[]) List<String> authOpenIdMobileRedirectUris,
    @JsonKey(name: 'authOpenIDGroupClaim') String? authOpenIdGroupClaim,
    @JsonKey(name: 'authOpenIDAdvancedPermsClaim') String? authOpenIdAdvancedPermsClaim,
    @JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') String? authOpenIdSubfolderForRedirectUrls,
    @JsonKey(name: 'authOpenIDSamplePermissions') String? authOpenIdSamplePermissions,
  }) = _AdminAuthenticationSettings;

  factory AdminAuthenticationSettings.fromJson(Map<String, dynamic> json) =>
      _$AdminAuthenticationSettingsFromJson(json);

  bool get localAuthEnabled => authActiveAuthMethods.contains('local');

  bool get openIdAuthEnabled => authActiveAuthMethods.contains('openid');
}
