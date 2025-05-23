// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryStats _$LibraryStatsFromJson(
  Map<String, dynamic> json,
) => _LibraryStats(
  totalItems: (json['totalItems'] as num?)?.toInt(),
  totalAuthors: (json['totalAuthors'] as num?)?.toInt(),
  totalGenres: (json['totalGenres'] as num?)?.toInt(),
  totalDuration: (json['totalDuration'] as num?)?.toDouble(),
  longestItems:
      (json['longestItems'] as List<dynamic>?)
          ?.map(
            (e) => LibraryItemDurationStats.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  numAudioTracks: (json['numAudioTracks'] as num?)?.toInt(),
  totalSize: (json['totalSize'] as num?)?.toInt(),
  largestItems:
      (json['largestItems'] as List<dynamic>?)
          ?.map((e) => LibraryItemSizeStats.fromJson(e as Map<String, dynamic>))
          .toList(),
  authorsWithCount:
      (json['authorsWithCount'] as List<dynamic>?)
          ?.map((e) => AuthorStats.fromJson(e as Map<String, dynamic>))
          .toList(),
  genresWithCount:
      (json['genresWithCount'] as List<dynamic>?)
          ?.map((e) => GenreStats.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$LibraryStatsToJson(_LibraryStats instance) =>
    <String, dynamic>{
      'totalItems': instance.totalItems,
      'totalAuthors': instance.totalAuthors,
      'totalGenres': instance.totalGenres,
      'totalDuration': instance.totalDuration,
      'longestItems': instance.longestItems,
      'numAudioTracks': instance.numAudioTracks,
      'totalSize': instance.totalSize,
      'largestItems': instance.largestItems,
      'authorsWithCount': instance.authorsWithCount,
      'genresWithCount': instance.genresWithCount,
    };
