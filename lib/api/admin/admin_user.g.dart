// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUser _$AdminUserFromJson(Map<String, dynamic> json) => _AdminUser(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String?,
  type: json['type'] as String? ?? 'user',
  isActive: json['isActive'] as bool? ?? true,
  isLocked: json['isLocked'] as bool?,
  lastSeen: (json['lastSeen'] as num?)?.toInt(),
  createdAt: (json['createdAt'] as num?)?.toInt(),
  hasOpenIdLink: json['hasOpenIDLink'] as bool?,
  permissions: json['permissions'] == null
      ? const AdminUserPermissions()
      : AdminUserPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  librariesAccessible:
      (json['librariesAccessible'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  itemTagsSelected: (json['itemTagsSelected'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$AdminUserToJson(_AdminUser instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'type': instance.type,
  'isActive': instance.isActive,
  'isLocked': instance.isLocked,
  'lastSeen': instance.lastSeen,
  'createdAt': instance.createdAt,
  'hasOpenIDLink': instance.hasOpenIdLink,
  'permissions': instance.permissions,
  'librariesAccessible': instance.librariesAccessible,
  'itemTagsSelected': instance.itemTagsSelected,
};
