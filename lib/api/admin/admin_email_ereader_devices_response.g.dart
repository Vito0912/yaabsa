// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_email_ereader_devices_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminEmailEreaderDevicesResponse _$AdminEmailEreaderDevicesResponseFromJson(Map<String, dynamic> json) =>
    _AdminEmailEreaderDevicesResponse(
      ereaderDevices:
          (json['ereaderDevices'] as List<dynamic>?)
              ?.map((e) => AdminEmailEreaderDevice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AdminEmailEreaderDevice>[],
    );

Map<String, dynamic> _$AdminEmailEreaderDevicesResponseToJson(_AdminEmailEreaderDevicesResponse instance) =>
    <String, dynamic>{'ereaderDevices': instance.ereaderDevices};
