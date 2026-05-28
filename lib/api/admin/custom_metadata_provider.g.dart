// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_metadata_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomMetadataProvider _$CustomMetadataProviderFromJson(Map<String, dynamic> json) => _CustomMetadataProvider(
  id: json['id'] as String,
  name: json['name'] as String,
  mediaType: json['mediaType'] as String,
  url: json['url'] as String,
  authHeaderValue: json['authHeaderValue'] as String?,
  createdAt: json['createdAt'] == null ? 0 : jsonIntRequiredFromDynamic(json['createdAt']),
  updatedAt: json['updatedAt'] == null ? 0 : jsonIntRequiredFromDynamic(json['updatedAt']),
);

Map<String, dynamic> _$CustomMetadataProviderToJson(_CustomMetadataProvider instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'mediaType': instance.mediaType,
  'url': instance.url,
  'authHeaderValue': instance.authHeaderValue,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
