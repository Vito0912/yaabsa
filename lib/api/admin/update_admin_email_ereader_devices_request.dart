import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:yaabsa/api/admin/admin_email_settings.dart';

part 'update_admin_email_ereader_devices_request.freezed.dart';
part 'update_admin_email_ereader_devices_request.g.dart';

@freezed
abstract class UpdateAdminEmailEreaderDevicesRequest with _$UpdateAdminEmailEreaderDevicesRequest {
  const factory UpdateAdminEmailEreaderDevicesRequest({
    @JsonKey(name: 'ereaderDevices') @Default(<AdminEmailEreaderDevice>[]) List<AdminEmailEreaderDevice> ereaderDevices,
  }) = _UpdateAdminEmailEreaderDevicesRequest;

  factory UpdateAdminEmailEreaderDevicesRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdminEmailEreaderDevicesRequestFromJson(json);
}
