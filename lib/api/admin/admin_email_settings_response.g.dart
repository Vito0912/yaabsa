// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_email_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminEmailSettingsResponse _$AdminEmailSettingsResponseFromJson(Map<String, dynamic> json) =>
    _AdminEmailSettingsResponse(
      settings: json['settings'] == null ? null : AdminEmailSettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminEmailSettingsResponseToJson(_AdminEmailSettingsResponse instance) => <String, dynamic>{
  'settings': instance.settings,
};
