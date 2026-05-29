// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_api_keys_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminApiKeysResponse _$AdminApiKeysResponseFromJson(Map<String, dynamic> json) => _AdminApiKeysResponse(
  apiKeys:
      (json['apiKeys'] as List<dynamic>?)?.map((e) => AdminApiKey.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AdminApiKey>[],
);

Map<String, dynamic> _$AdminApiKeysResponseToJson(_AdminApiKeysResponse instance) => <String, dynamic>{
  'apiKeys': instance.apiKeys,
};
