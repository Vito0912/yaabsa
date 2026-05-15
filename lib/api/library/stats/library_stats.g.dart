// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryStats _$LibraryStatsFromJson(Map<String, dynamic> json) => _LibraryStats(
  totalItems: jsonIntFromDynamic(json['totalItems']),
  totalAuthors: jsonIntFromDynamic(json['totalAuthors']),
  totalGenres: jsonIntFromDynamic(json['totalGenres']),
  totalDuration: jsonDoubleFromDynamic(json['totalDuration']),
  longestItems:
      (json['longestItems'] as List<dynamic>?)
          ?.map((e) => LibraryItemDurationStats.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LibraryItemDurationStats>[],
  numAudioTracks: jsonIntFromDynamic(json['numAudioTracks']),
  totalSize: jsonIntFromDynamic(json['totalSize']),
  largestItems:
      (json['largestItems'] as List<dynamic>?)
          ?.map((e) => LibraryItemSizeStats.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LibraryItemSizeStats>[],
  authorsWithCount:
      (json['authorsWithCount'] as List<dynamic>?)
          ?.map((e) => AuthorStats.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <AuthorStats>[],
  genresWithCount:
      (json['genresWithCount'] as List<dynamic>?)
          ?.map((e) => GenreStats.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <GenreStats>[],
);

Map<String, dynamic> _$LibraryStatsToJson(_LibraryStats instance) => <String, dynamic>{
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
