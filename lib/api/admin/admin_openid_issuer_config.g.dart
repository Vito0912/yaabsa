// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_openid_issuer_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminOpenIdIssuerConfig _$AdminOpenIdIssuerConfigFromJson(Map<String, dynamic> json) => _AdminOpenIdIssuerConfig(
  issuer: json['issuer'] as String?,
  authorizationEndpoint: json['authorization_endpoint'] as String?,
  tokenEndpoint: json['token_endpoint'] as String?,
  userInfoEndpoint: json['userinfo_endpoint'] as String?,
  endSessionEndpoint: json['end_session_endpoint'] as String?,
  jwksUri: json['jwks_uri'] as String?,
  signingAlgorithms:
      (json['id_token_signing_alg_values_supported'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$AdminOpenIdIssuerConfigToJson(_AdminOpenIdIssuerConfig instance) => <String, dynamic>{
  'issuer': instance.issuer,
  'authorization_endpoint': instance.authorizationEndpoint,
  'token_endpoint': instance.tokenEndpoint,
  'userinfo_endpoint': instance.userInfoEndpoint,
  'end_session_endpoint': instance.endSessionEndpoint,
  'jwks_uri': instance.jwksUri,
  'id_token_signing_alg_values_supported': instance.signingAlgorithms,
};
