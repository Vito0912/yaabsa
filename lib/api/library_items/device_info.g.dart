// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => _DeviceInfo(
  deviceId: json['deviceId'] as String?,
  clientName: json['clientName'] as String?,
  clientVersion: json['clientVersion'] as String?,
  manufacturer: json['manufacturer'] as String?,
  model: json['model'] as String?,
  sdkVersion: json['sdkVersion'] as String?,
);

Map<String, dynamic> _$DeviceInfoToJson(_DeviceInfo instance) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'clientName': instance.clientName,
  'clientVersion': instance.clientVersion,
  'manufacturer': instance.manufacturer,
  'model': instance.model,
  'sdkVersion': instance.sdkVersion,
};
