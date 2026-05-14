// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_quick_match_library_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchQuickMatchLibraryItemsResponse _$BatchQuickMatchLibraryItemsResponseFromJson(Map<String, dynamic> json) =>
    _BatchQuickMatchLibraryItemsResponse(
      success: json['success'] as bool? ?? false,
      updates: (json['updates'] as num?)?.toInt() ?? 0,
      unmatched: (json['unmatched'] as num?)?.toInt() ?? 0,
      message: json['message'] as String?,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$BatchQuickMatchLibraryItemsResponseToJson(_BatchQuickMatchLibraryItemsResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'updates': instance.updates,
      'unmatched': instance.unmatched,
      'message': instance.message,
      'error': instance.error,
    };
