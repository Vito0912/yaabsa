// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_admin_api_key_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateAdminApiKeyRequest _$CreateAdminApiKeyRequestFromJson(Map<String, dynamic> json) => _CreateAdminApiKeyRequest(
  name: json['name'] as String,
  userId: json['userId'] as String,
  expiresIn: (json['expiresIn'] as num?)?.toInt(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$CreateAdminApiKeyRequestToJson(_CreateAdminApiKeyRequest instance) => <String, dynamic>{
  'name': instance.name,
  'userId': instance.userId,
  'expiresIn': instance.expiresIn,
  'isActive': instance.isActive,
};
