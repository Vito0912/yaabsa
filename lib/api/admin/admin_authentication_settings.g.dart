// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_authentication_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminAuthenticationSettings _$AdminAuthenticationSettingsFromJson(
  Map<String, dynamic> json,
) => _AdminAuthenticationSettings(
  authLoginCustomMessage: json['authLoginCustomMessage'] as String?,
  authActiveAuthMethods:
      (json['authActiveAuthMethods'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>['local'],
  authOpenIdIssuerUrl: json['authOpenIDIssuerURL'] as String?,
  authOpenIdAuthorizationUrl: json['authOpenIDAuthorizationURL'] as String?,
  authOpenIdTokenUrl: json['authOpenIDTokenURL'] as String?,
  authOpenIdUserInfoUrl: json['authOpenIDUserInfoURL'] as String?,
  authOpenIdJwksUrl: json['authOpenIDJwksURL'] as String?,
  authOpenIdLogoutUrl: json['authOpenIDLogoutURL'] as String?,
  authOpenIdClientId: json['authOpenIDClientID'] as String?,
  authOpenIdClientSecret: json['authOpenIDClientSecret'] as String?,
  authOpenIdTokenSigningAlgorithm: json['authOpenIDTokenSigningAlgorithm'] as String?,
  authOpenIdButtonText: json['authOpenIDButtonText'] as String?,
  authOpenIdAutoLaunch: json['authOpenIDAutoLaunch'] as bool? ?? false,
  authOpenIdAutoRegister: json['authOpenIDAutoRegister'] as bool? ?? false,
  authOpenIdMatchExistingBy: json['authOpenIDMatchExistingBy'] as String?,
  authOpenIdMobileRedirectUris:
      (json['authOpenIDMobileRedirectURIs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  authOpenIdGroupClaim: json['authOpenIDGroupClaim'] as String?,
  authOpenIdAdvancedPermsClaim: json['authOpenIDAdvancedPermsClaim'] as String?,
  authOpenIdSubfolderForRedirectUrls: json['authOpenIDSubfolderForRedirectURLs'] as String?,
  authOpenIdSamplePermissions: json['authOpenIDSamplePermissions'] as String?,
);

Map<String, dynamic> _$AdminAuthenticationSettingsToJson(_AdminAuthenticationSettings instance) => <String, dynamic>{
  'authLoginCustomMessage': instance.authLoginCustomMessage,
  'authActiveAuthMethods': instance.authActiveAuthMethods,
  'authOpenIDIssuerURL': instance.authOpenIdIssuerUrl,
  'authOpenIDAuthorizationURL': instance.authOpenIdAuthorizationUrl,
  'authOpenIDTokenURL': instance.authOpenIdTokenUrl,
  'authOpenIDUserInfoURL': instance.authOpenIdUserInfoUrl,
  'authOpenIDJwksURL': instance.authOpenIdJwksUrl,
  'authOpenIDLogoutURL': instance.authOpenIdLogoutUrl,
  'authOpenIDClientID': instance.authOpenIdClientId,
  'authOpenIDClientSecret': instance.authOpenIdClientSecret,
  'authOpenIDTokenSigningAlgorithm': instance.authOpenIdTokenSigningAlgorithm,
  'authOpenIDButtonText': instance.authOpenIdButtonText,
  'authOpenIDAutoLaunch': instance.authOpenIdAutoLaunch,
  'authOpenIDAutoRegister': instance.authOpenIdAutoRegister,
  'authOpenIDMatchExistingBy': instance.authOpenIdMatchExistingBy,
  'authOpenIDMobileRedirectURIs': instance.authOpenIdMobileRedirectUris,
  'authOpenIDGroupClaim': instance.authOpenIdGroupClaim,
  'authOpenIDAdvancedPermsClaim': instance.authOpenIdAdvancedPermsClaim,
  'authOpenIDSubfolderForRedirectURLs': instance.authOpenIdSubfolderForRedirectUrls,
  'authOpenIDSamplePermissions': instance.authOpenIdSamplePermissions,
};
