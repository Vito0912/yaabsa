// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_email_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminEmailEreaderDevice _$AdminEmailEreaderDeviceFromJson(Map<String, dynamic> json) => _AdminEmailEreaderDevice(
  name: json['name'] as String,
  email: json['email'] as String,
  availabilityOption: json['availabilityOption'] as String? ?? 'adminOrUp',
  users: (json['users'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$AdminEmailEreaderDeviceToJson(_AdminEmailEreaderDevice instance) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'availabilityOption': instance.availabilityOption,
  'users': instance.users,
};

_AdminEmailSettings _$AdminEmailSettingsFromJson(Map<String, dynamic> json) => _AdminEmailSettings(
  id: json['id'] as String? ?? 'email-settings',
  host: json['host'] as String?,
  port: (json['port'] as num?)?.toInt() ?? 465,
  secure: json['secure'] as bool? ?? true,
  rejectUnauthorized: json['rejectUnauthorized'] as bool? ?? true,
  user: json['user'] as String?,
  pass: json['pass'] as String?,
  testAddress: json['testAddress'] as String?,
  fromAddress: json['fromAddress'] as String?,
  ereaderDevices:
      (json['ereaderDevices'] as List<dynamic>?)
          ?.map((e) => AdminEmailEreaderDevice.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AdminEmailEreaderDevice>[],
);

Map<String, dynamic> _$AdminEmailSettingsToJson(_AdminEmailSettings instance) => <String, dynamic>{
  'id': instance.id,
  'host': instance.host,
  'port': instance.port,
  'secure': instance.secure,
  'rejectUnauthorized': instance.rejectUnauthorized,
  'user': instance.user,
  'pass': instance.pass,
  'testAddress': instance.testAddress,
  'fromAddress': instance.fromAddress,
  'ereaderDevices': instance.ereaderDevices,
};
