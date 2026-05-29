// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorting_prefixes_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SortingPrefixesUpdateResponse _$SortingPrefixesUpdateResponseFromJson(Map<String, dynamic> json) =>
    _SortingPrefixesUpdateResponse(
      rowsUpdated: (json['rowsUpdated'] as num).toInt(),
      serverSettings: ServerSettings.fromJson(json['serverSettings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SortingPrefixesUpdateResponseToJson(_SortingPrefixesUpdateResponse instance) =>
    <String, dynamic>{'rowsUpdated': instance.rowsUpdated, 'serverSettings': instance.serverSettings};
