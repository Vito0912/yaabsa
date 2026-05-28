// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_admin_authentication_settings_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateAdminAuthenticationSettingsResponse _$UpdateAdminAuthenticationSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _UpdateAdminAuthenticationSettingsResponse(
  updated: json['updated'] as bool? ?? false,
  serverSettings: json['serverSettings'] == null
      ? null
      : ServerSettings.fromJson(json['serverSettings'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateAdminAuthenticationSettingsResponseToJson(
  _UpdateAdminAuthenticationSettingsResponse instance,
) => <String, dynamic>{'updated': instance.updated, 'serverSettings': instance.serverSettings};
