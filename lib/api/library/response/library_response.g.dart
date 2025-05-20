// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryResponse _$LibraryResponseFromJson(Map<String, dynamic> json) => _LibraryResponse(
  libraries: (json['libraries'] as List<dynamic>).map((e) => Library.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$LibraryResponseToJson(_LibraryResponse instance) => <String, dynamic>{
  'libraries': instance.libraries,
};
