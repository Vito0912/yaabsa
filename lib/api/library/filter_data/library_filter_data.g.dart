// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_filter_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryFilterData _$LibraryFilterDataFromJson(Map<String, dynamic> json) => _LibraryFilterData(
  authors:
      (json['authors'] as List<dynamic>?)
          ?.map((e) => LibraryFilterNamedEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LibraryFilterNamedEntity>[],
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  series:
      (json['series'] as List<dynamic>?)
          ?.map((e) => LibraryFilterNamedEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LibraryFilterNamedEntity>[],
  narrators: (json['narrators'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  languages: (json['languages'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  publishers: (json['publishers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  publishedDecades: (json['publishedDecades'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  bookCount: (json['bookCount'] as num?)?.toInt() ?? 0,
  authorCount: (json['authorCount'] as num?)?.toInt() ?? 0,
  seriesCount: (json['seriesCount'] as num?)?.toInt() ?? 0,
  podcastCount: (json['podcastCount'] as num?)?.toInt() ?? 0,
  numIssues: (json['numIssues'] as num?)?.toInt() ?? 0,
  loadedAt: (json['loadedAt'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LibraryFilterDataToJson(_LibraryFilterData instance) => <String, dynamic>{
  'authors': instance.authors,
  'genres': instance.genres,
  'tags': instance.tags,
  'series': instance.series,
  'narrators': instance.narrators,
  'languages': instance.languages,
  'publishers': instance.publishers,
  'publishedDecades': instance.publishedDecades,
  'bookCount': instance.bookCount,
  'authorCount': instance.authorCount,
  'seriesCount': instance.seriesCount,
  'podcastCount': instance.podcastCount,
  'numIssues': instance.numIssues,
  'loadedAt': instance.loadedAt,
};
