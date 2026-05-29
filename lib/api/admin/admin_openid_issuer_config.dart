import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_openid_issuer_config.freezed.dart';
part 'admin_openid_issuer_config.g.dart';

@freezed
abstract class AdminOpenIdIssuerConfig with _$AdminOpenIdIssuerConfig {
  const factory AdminOpenIdIssuerConfig({
    @JsonKey(name: 'issuer') String? issuer,
    @JsonKey(name: 'authorization_endpoint') String? authorizationEndpoint,
    @JsonKey(name: 'token_endpoint') String? tokenEndpoint,
    @JsonKey(name: 'userinfo_endpoint') String? userInfoEndpoint,
    @JsonKey(name: 'end_session_endpoint') String? endSessionEndpoint,
    @JsonKey(name: 'jwks_uri') String? jwksUri,
    @JsonKey(name: 'id_token_signing_alg_values_supported') @Default(<String>[]) List<String> signingAlgorithms,
  }) = _AdminOpenIdIssuerConfig;

  factory AdminOpenIdIssuerConfig.fromJson(Map<String, dynamic> json) => _$AdminOpenIdIssuerConfigFromJson(json);
}
