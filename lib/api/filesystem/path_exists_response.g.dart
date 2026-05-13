// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_exists_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PathExistsResponse _$PathExistsResponseFromJson(Map<String, dynamic> json) => _PathExistsResponse(
  exists: json['exists'] as bool,
  libraryItemTitle: json['libraryItemTitle'] as String?,
  error: json['error'] as String?,
);

Map<String, dynamic> _$PathExistsResponseToJson(_PathExistsResponse instance) => <String, dynamic>{
  'exists': instance.exists,
  'libraryItemTitle': instance.libraryItemTitle,
  'error': instance.error,
};
