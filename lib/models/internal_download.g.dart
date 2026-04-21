// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_download.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InternalDownload _$InternalDownloadFromJson(Map<String, dynamic> json) => _InternalDownload(
  item: json['item'] == null ? null : LibraryItem.fromJson(json['item'] as Map<String, dynamic>),
  episode: json['episode'] == null ? null : Episode.fromJson(json['episode'] as Map<String, dynamic>),
  tracks: (json['tracks'] as List<dynamic>).map((e) => InternalTrack.fromJson(e as Map<String, dynamic>)).toList(),
  expectedFileCount: (json['expectedFileCount'] as num?)?.toInt(),
  auxiliaryFilePaths:
      (json['auxiliaryFilePaths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  saf: json['saf'] as bool? ?? false,
  coverPath: json['coverPath'] as String?,
  sidecarPaths: (json['sidecarPaths'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
);

Map<String, dynamic> _$InternalDownloadToJson(_InternalDownload instance) => <String, dynamic>{
  'item': instance.item,
  'episode': instance.episode,
  'tracks': instance.tracks,
  'expectedFileCount': instance.expectedFileCount,
  'auxiliaryFilePaths': instance.auxiliaryFilePaths,
  'saf': instance.saf,
  'coverPath': instance.coverPath,
  'sidecarPaths': instance.sidecarPaths,
};
