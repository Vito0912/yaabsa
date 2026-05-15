// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminUserListResponse _$AdminUserListResponseFromJson(Map<String, dynamic> json) => _AdminUserListResponse(
  users:
      (json['users'] as List<dynamic>?)?.map((e) => AdminUser.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AdminUser>[],
);

Map<String, dynamic> _$AdminUserListResponseToJson(_AdminUserListResponse instance) => <String, dynamic>{
  'users': instance.users,
};
