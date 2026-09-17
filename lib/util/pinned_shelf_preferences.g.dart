// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_shelf_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PinnedShelfEntry _$PinnedShelfEntryFromJson(Map<String, dynamic> json) => _PinnedShelfEntry(
  itemId: json['itemId'] as String,
  episodeId: json['episodeId'] as String?,
  pinnedAt: _pinnedAtFromJson(json['pinnedAt']),
);

Map<String, dynamic> _$PinnedShelfEntryToJson(_PinnedShelfEntry instance) => <String, dynamic>{
  'itemId': instance.itemId,
  'episodeId': instance.episodeId,
  'pinnedAt': _pinnedAtToJson(instance.pinnedAt),
};
