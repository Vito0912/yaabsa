// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_admin_api_key_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateAdminApiKeyRequest _$UpdateAdminApiKeyRequestFromJson(Map<String, dynamic> json) =>
    _UpdateAdminApiKeyRequest(userId: json['userId'] as String?, isActive: json['isActive'] as bool?);

Map<String, dynamic> _$UpdateAdminApiKeyRequestToJson(_UpdateAdminApiKeyRequest instance) => <String, dynamic>{
  'userId': instance.userId,
  'isActive': instance.isActive,
};
