// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_in_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemsInProgress _$ItemsInProgressFromJson(Map<String, dynamic> json) => _ItemsInProgress(
  libraryItems:
      (json['libraryItems'] as List<dynamic>?)?.map((e) => LibraryItem.fromJson(e as Map<String, dynamic>)).toList() ??
      const <LibraryItem>[],
);

Map<String, dynamic> _$ItemsInProgressToJson(_ItemsInProgress instance) => <String, dynamic>{
  'libraryItems': instance.libraryItems,
};
