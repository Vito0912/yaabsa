// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reorder_library_entry_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReorderLibraryEntryRequest _$ReorderLibraryEntryRequestFromJson(Map<String, dynamic> json) =>
    _ReorderLibraryEntryRequest(id: json['id'] as String, newOrder: (json['newOrder'] as num).toInt());

Map<String, dynamic> _$ReorderLibraryEntryRequestToJson(_ReorderLibraryEntryRequest instance) => <String, dynamic>{
  'id': instance.id,
  'newOrder': instance.newOrder,
};
