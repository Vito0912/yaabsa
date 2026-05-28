// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_library_item_media_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateLibraryItemMediaResponse _$UpdateLibraryItemMediaResponseFromJson(Map<String, dynamic> json) =>
    _UpdateLibraryItemMediaResponse(
      updated: json['updated'] == null ? false : jsonBoolRequiredFromDynamic(json['updated']),
      libraryItem: json['libraryItem'] == null
          ? null
          : LibraryItem.fromJson(json['libraryItem'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateLibraryItemMediaResponseToJson(_UpdateLibraryItemMediaResponse instance) =>
    <String, dynamic>{'updated': instance.updated, 'libraryItem': instance.libraryItem};
