import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_admin_email_settings_request.freezed.dart';
part 'update_admin_email_settings_request.g.dart';

@freezed
abstract class UpdateAdminEmailSettingsRequest with _$UpdateAdminEmailSettingsRequest {
  const factory UpdateAdminEmailSettingsRequest({
    @JsonKey(name: 'host') String? host,
    @JsonKey(name: 'port') int? port,
    @JsonKey(name: 'secure') bool? secure,
    @JsonKey(name: 'rejectUnauthorized') bool? rejectUnauthorized,
    @JsonKey(name: 'user') String? user,
    @JsonKey(name: 'pass') String? pass,
    @JsonKey(name: 'testAddress') String? testAddress,
    @JsonKey(name: 'fromAddress') String? fromAddress,
  }) = _UpdateAdminEmailSettingsRequest;

  factory UpdateAdminEmailSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdminEmailSettingsRequestFromJson(json);
}
