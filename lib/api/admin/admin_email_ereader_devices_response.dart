import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';

part 'admin_email_ereader_devices_response.freezed.dart';
part 'admin_email_ereader_devices_response.g.dart';

@freezed
abstract class AdminEmailEreaderDevicesResponse with _$AdminEmailEreaderDevicesResponse {
  const factory AdminEmailEreaderDevicesResponse({
    @JsonKey(name: 'ereaderDevices') @Default(<AdminEmailEreaderDevice>[]) List<AdminEmailEreaderDevice> ereaderDevices,
  }) = _AdminEmailEreaderDevicesResponse;

  factory AdminEmailEreaderDevicesResponse.fromJson(Map<String, dynamic> json) =>
      _$AdminEmailEreaderDevicesResponseFromJson(json);
}
