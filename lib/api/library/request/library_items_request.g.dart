// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryItemsRequest _$LibraryItemsRequestFromJson(Map<String, dynamic> json) =>
    _LibraryItemsRequest(
      limit: (json['limit'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      sort: json['sort'] as String?,
      desc: (json['desc'] as num?)?.toInt(),
      filter: json['filter'] as String?,
      collapseseries: (json['collapseseries'] as num?)?.toInt(),
      include: json['include'] as String?,
    );

Map<String, dynamic> _$LibraryItemsRequestToJson(
  _LibraryItemsRequest instance,
) => <String, dynamic>{
  'limit': instance.limit,
  'page': instance.page,
  'sort': instance.sort,
  'desc': instance.desc,
  'filter': instance.filter,
  'collapseseries': instance.collapseseries,
  'include': instance.include,
};
