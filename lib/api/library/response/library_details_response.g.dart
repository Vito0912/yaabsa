// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryDetailsResponse _$LibraryDetailsResponseFromJson(Map<String, dynamic> json) => _LibraryDetailsResponse(
  filterData: json['filterdata'] == null
      ? null
      : LibraryFilterData.fromJson(json['filterdata'] as Map<String, dynamic>),
  issues: (json['issues'] as num?)?.toInt() ?? 0,
  numUserPlaylists: (json['numUserPlaylists'] as num?)?.toInt() ?? 0,
  library: json['library'] == null ? null : Library.fromJson(json['library'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LibraryDetailsResponseToJson(_LibraryDetailsResponse instance) => <String, dynamic>{
  'filterdata': instance.filterData,
  'issues': instance.issues,
  'numUserPlaylists': instance.numUserPlaylists,
  'library': instance.library,
};
