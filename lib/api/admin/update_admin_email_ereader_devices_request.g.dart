// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_admin_email_ereader_devices_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateAdminEmailEreaderDevicesRequest _$UpdateAdminEmailEreaderDevicesRequestFromJson(Map<String, dynamic> json) =>
    _UpdateAdminEmailEreaderDevicesRequest(
      ereaderDevices:
          (json['ereaderDevices'] as List<dynamic>?)
              ?.map((e) => AdminEmailEreaderDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AdminEmailEreaderDevice>[],
    );

Map<String, dynamic> _$UpdateAdminEmailEreaderDevicesRequestToJson(_UpdateAdminEmailEreaderDevicesRequest instance) =>
    <String, dynamic>{'ereaderDevices': instance.ereaderDevices};
