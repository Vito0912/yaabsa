// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryItemRequest _$LibraryItemRequestFromJson(Map<String, dynamic> json) => _LibraryItemRequest(
  id: json['id'] as String,
  expanded: (json['expanded'] as num?)?.toInt(),
  include: json['include'] as String?,
  episode: json['episode'] as String?,
);

Map<String, dynamic> _$LibraryItemRequestToJson(_LibraryItemRequest instance) => <String, dynamic>{
  'id': instance.id,
  'expanded': instance.expanded,
  'include': instance.include,
  'episode': instance.episode,
};
