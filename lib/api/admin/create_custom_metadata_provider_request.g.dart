// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_custom_metadata_provider_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateCustomMetadataProviderRequest _$CreateCustomMetadataProviderRequestFromJson(Map<String, dynamic> json) =>
    _CreateCustomMetadataProviderRequest(
      name: json['name'] as String,
      url: json['url'] as String,
      mediaType: json['mediaType'] as String,
      authHeaderValue: json['authHeaderValue'] as String?,
    );

Map<String, dynamic> _$CreateCustomMetadataProviderRequestToJson(_CreateCustomMetadataProviderRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'url': instance.url,
      'mediaType': instance.mediaType,
      'authHeaderValue': instance.authHeaderValue,
    };
