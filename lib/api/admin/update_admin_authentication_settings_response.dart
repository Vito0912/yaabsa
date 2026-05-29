import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/me/server_settings.dart';

part 'update_admin_authentication_settings_response.freezed.dart';
part 'update_admin_authentication_settings_response.g.dart';

@freezed
abstract class UpdateAdminAuthenticationSettingsResponse with _$UpdateAdminAuthenticationSettingsResponse {
  const factory UpdateAdminAuthenticationSettingsResponse({
    @JsonKey(name: 'updated') @Default(false) bool updated,
    @JsonKey(name: 'serverSettings') ServerSettings? serverSettings,
  }) = _UpdateAdminAuthenticationSettingsResponse;

  factory UpdateAdminAuthenticationSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdminAuthenticationSettingsResponseFromJson(json);
}
