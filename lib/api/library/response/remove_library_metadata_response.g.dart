// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_library_metadata_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RemoveLibraryMetadataResponse _$RemoveLibraryMetadataResponseFromJson(Map<String, dynamic> json) =>
    _RemoveLibraryMetadataResponse(
      found: json['found'] as bool,
      numRemoved: (json['numRemoved'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$RemoveLibraryMetadataResponseToJson(_RemoveLibraryMetadataResponse instance) =>
    <String, dynamic>{'found': instance.found, 'numRemoved': instance.numRemoved, 'error': instance.error};
