// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_match_library_item_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickMatchLibraryItemResponse _$QuickMatchLibraryItemResponseFromJson(Map<String, dynamic> json) =>
    _QuickMatchLibraryItemResponse(
      updated: json['updated'] as bool? ?? false,
      libraryItem: json['libraryItem'] == null
          ? null
          : LibraryItem.fromJson(json['libraryItem'] as Map<String, dynamic>),
      message: json['message'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$QuickMatchLibraryItemResponseToJson(_QuickMatchLibraryItemResponse instance) =>
    <String, dynamic>{
      'updated': instance.updated,
      'libraryItem': instance.libraryItem,
      'message': instance.message,
      'error': instance.error,
    };
