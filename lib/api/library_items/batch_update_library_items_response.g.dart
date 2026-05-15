// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_update_library_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchUpdateLibraryItemsResponse _$BatchUpdateLibraryItemsResponseFromJson(Map<String, dynamic> json) =>
    _BatchUpdateLibraryItemsResponse(
      success: json['success'] as bool? ?? false,
      updates: json['updates'] == null ? 0 : _intFromDynamic(json['updates']),
    );

Map<String, dynamic> _$BatchUpdateLibraryItemsResponseToJson(_BatchUpdateLibraryItemsResponse instance) =>
    <String, dynamic>{'success': instance.success, 'updates': instance.updates};
