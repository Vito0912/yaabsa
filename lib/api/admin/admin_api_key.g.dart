// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_api_key.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminApiKey _$AdminApiKeyFromJson(Map<String, dynamic> json) => _AdminApiKey(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  expiresAt: json['expiresAt'] == null ? null : DateTime.parse(json['expiresAt'] as String),
  lastUsedAt: json['lastUsedAt'] == null ? null : DateTime.parse(json['lastUsedAt'] as String),
  isActive: json['isActive'] as bool? ?? false,
  permissions: json['permissions'] == null
      ? const AdminUserPermissions()
      : AdminUserPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  createdAt: json['createdAt'] == null ? null : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
  userId: json['userId'] as String,
  createdByUserId: json['createdByUserId'] as String?,
  user: json['user'] == null ? null : SessionUserSummary.fromJson(json['user'] as Map<String, dynamic>),
  createdByUser: json['createdByUser'] == null
      ? null
      : SessionUserSummary.fromJson(json['createdByUser'] as Map<String, dynamic>),
  apiKey: json['apiKey'] as String?,
);

Map<String, dynamic> _$AdminApiKeyToJson(_AdminApiKey instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'expiresAt': instance.expiresAt?.toIso8601String(),
  'lastUsedAt': instance.lastUsedAt?.toIso8601String(),
  'isActive': instance.isActive,
  'permissions': instance.permissions,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'userId': instance.userId,
  'createdByUserId': instance.createdByUserId,
  'user': instance.user,
  'createdByUser': instance.createdByUser,
  'apiKey': instance.apiKey,
};
