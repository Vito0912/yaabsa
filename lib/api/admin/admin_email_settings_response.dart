import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';

part 'admin_email_settings_response.freezed.dart';
part 'admin_email_settings_response.g.dart';

@freezed
abstract class AdminEmailSettingsResponse with _$AdminEmailSettingsResponse {
  const factory AdminEmailSettingsResponse({@JsonKey(name: 'settings') AdminEmailSettings? settings}) =
      _AdminEmailSettingsResponse;

  factory AdminEmailSettingsResponse.fromJson(Map<String, dynamic> json) => _$AdminEmailSettingsResponseFromJson(json);
}
