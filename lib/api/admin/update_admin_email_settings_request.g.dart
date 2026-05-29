// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_admin_email_settings_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateAdminEmailSettingsRequest _$UpdateAdminEmailSettingsRequestFromJson(Map<String, dynamic> json) =>
    _UpdateAdminEmailSettingsRequest(
      host: json['host'] as String?,
      port: (json['port'] as num?)?.toInt(),
      secure: json['secure'] as bool?,
      rejectUnauthorized: json['rejectUnauthorized'] as bool?,
      user: json['user'] as String?,
      pass: json['pass'] as String?,
      testAddress: json['testAddress'] as String?,
      fromAddress: json['fromAddress'] as String?,
    );

Map<String, dynamic> _$UpdateAdminEmailSettingsRequestToJson(_UpdateAdminEmailSettingsRequest instance) =>
    <String, dynamic>{
      'host': instance.host,
      'port': instance.port,
      'secure': instance.secure,
      'rejectUnauthorized': instance.rejectUnauthorized,
      'user': instance.user,
      'pass': instance.pass,
      'testAddress': instance.testAddress,
      'fromAddress': instance.fromAddress,
    };
