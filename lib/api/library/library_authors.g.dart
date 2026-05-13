// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_authors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LibraryAuthors _$LibraryAuthorsFromJson(Map<String, dynamic> json) => _LibraryAuthors(
  results:
      (json['results'] as List<dynamic>?)?.map((e) => LibraryAuthor.fromJson(e as Map<String, dynamic>)).toList() ??
      const <LibraryAuthor>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
  limit: (json['limit'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  sortBy: json['sortBy'] as String?,
  sortDesc: json['sortDesc'] as bool?,
  filterBy: json['filterBy'] as String?,
  minified: json['minified'] as bool?,
  include: json['include'] as String?,
);

Map<String, dynamic> _$LibraryAuthorsToJson(_LibraryAuthors instance) => <String, dynamic>{
  'results': instance.results,
  'total': instance.total,
  'limit': instance.limit,
  'page': instance.page,
  'sortBy': instance.sortBy,
  'sortDesc': instance.sortDesc,
  'filterBy': instance.filterBy,
  'minified': instance.minified,
  'include': instance.include,
};
