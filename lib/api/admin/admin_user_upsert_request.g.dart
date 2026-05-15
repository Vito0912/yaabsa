// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_upsert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUserUpsertRequest _$AdminUserUpsertRequestFromJson(Map<String, dynamic> json) => _AdminUserUpsertRequest(
  username: json['username'] as String,
  password: json['password'] as String?,
  email: json['email'] as String?,
  type: json['type'] as String? ?? 'user',
  isActive: json['isActive'] as bool? ?? true,
  permissions: json['permissions'] == null
      ? const AdminUserPermissions()
      : AdminUserPermissions.fromJson(json['permissions'] as Map<String, dynamic>),
  librariesAccessible:
      (json['librariesAccessible'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  itemTagsSelected: (json['itemTagsSelected'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$AdminUserUpsertRequestToJson(_AdminUserUpsertRequest instance) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'email': instance.email,
  'type': instance.type,
  'isActive': instance.isActive,
  'permissions': instance.permissions,
  'librariesAccessible': instance.librariesAccessible,
  'itemTagsSelected': instance.itemTagsSelected,
};
