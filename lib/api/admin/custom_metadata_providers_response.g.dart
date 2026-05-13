// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_metadata_providers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CustomMetadataProvidersResponse _$CustomMetadataProvidersResponseFromJson(Map<String, dynamic> json) =>
    _CustomMetadataProvidersResponse(
      providers: json['providers'] == null ? const <CustomMetadataProvider>[] : _providersFromJson(json['providers']),
    );

Map<String, dynamic> _$CustomMetadataProvidersResponseToJson(_CustomMetadataProvidersResponse instance) =>
    <String, dynamic>{'providers': instance.providers};
