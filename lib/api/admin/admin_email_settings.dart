import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_email_settings.freezed.dart';
part 'admin_email_settings.g.dart';

@freezed
abstract class AdminEmailEreaderDevice with _$AdminEmailEreaderDevice {
  const factory AdminEmailEreaderDevice({
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'email') required String email,
    @JsonKey(name: 'availabilityOption') @Default('adminOrUp') String availabilityOption,
    @JsonKey(name: 'users') @Default(<String>[]) List<String> users,
  }) = _AdminEmailEreaderDevice;

  factory AdminEmailEreaderDevice.fromJson(Map<String, dynamic> json) => _$AdminEmailEreaderDeviceFromJson(json);
}

@freezed
abstract class AdminEmailSettings with _$AdminEmailSettings {
  const AdminEmailSettings._();

  const factory AdminEmailSettings({
    @JsonKey(name: 'id') @Default('email-settings') String id,
    @JsonKey(name: 'host') String? host,
    @JsonKey(name: 'port') @Default(465) int port,
    @JsonKey(name: 'secure') @Default(true) bool secure,
    @JsonKey(name: 'rejectUnauthorized') @Default(true) bool rejectUnauthorized,
    @JsonKey(name: 'user') String? user,
    @JsonKey(name: 'pass') String? pass,
    @JsonKey(name: 'testAddress') String? testAddress,
    @JsonKey(name: 'fromAddress') String? fromAddress,
    @JsonKey(name: 'ereaderDevices') @Default(<AdminEmailEreaderDevice>[]) List<AdminEmailEreaderDevice> ereaderDevices,
  }) = _AdminEmailSettings;

  factory AdminEmailSettings.fromJson(Map<String, dynamic> json) => _$AdminEmailSettingsFromJson(json);

  bool get hasHost => (host ?? '').trim().isNotEmpty;
}
