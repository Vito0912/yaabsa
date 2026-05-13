// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_update_library_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BatchUpdateLibraryItemRequest _$BatchUpdateLibraryItemRequestFromJson(Map<String, dynamic> json) =>
    _BatchUpdateLibraryItemRequest(
      id: json['id'] as String,
      mediaPayload: UpdateLibraryItemMediaRequest.fromJson(json['mediaPayload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BatchUpdateLibraryItemRequestToJson(_BatchUpdateLibraryItemRequest instance) =>
    <String, dynamic>{'id': instance.id, 'mediaPayload': instance.mediaPayload.toJson()};
