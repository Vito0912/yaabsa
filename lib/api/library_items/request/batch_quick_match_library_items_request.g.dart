// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_quick_match_library_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchQuickMatchLibraryItemsRequest _$BatchQuickMatchLibraryItemsRequestFromJson(Map<String, dynamic> json) =>
    _BatchQuickMatchLibraryItemsRequest(
      libraryItemIds: (json['libraryItemIds'] as List<dynamic>).map((e) => e as String).toList(),
      options: QuickMatchLibraryItemOptions.fromJson(json['options'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BatchQuickMatchLibraryItemsRequestToJson(_BatchQuickMatchLibraryItemsRequest instance) =>
    <String, dynamic>{'libraryItemIds': instance.libraryItemIds, 'options': instance.options.toJson()};
