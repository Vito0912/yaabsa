// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchLibrary _$SearchLibraryFromJson(
  Map<String, dynamic> json,
) => _SearchLibrary(
  book:
      (json['book'] as List<dynamic>?)
          ?.map((e) => SearchLibraryResult.fromJson(e as Map<String, dynamic>))
          .toList(),
  podcast:
      (json['podcast'] as List<dynamic>?)
          ?.map((e) => SearchLibraryResult.fromJson(e as Map<String, dynamic>))
          .toList(),
  narrators:
      (json['narrators'] as List<dynamic>?)
          ?.map((e) => SearchResultNarrator.fromJson(e as Map<String, dynamic>))
          .toList(),
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
  genres:
      (json['genres'] as List<dynamic>?)
          ?.map((e) => SearchResultItem.fromJson(e as Map<String, dynamic>))
          .toList(),
  series:
      (json['series'] as List<dynamic>?)
          ?.map((e) => SearchSeries.fromJson(e as Map<String, dynamic>))
          .toList(),
  authors:
      (json['authors'] as List<dynamic>?)
          ?.map((e) => SearchLibraryAuthor.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SearchLibraryToJson(_SearchLibrary instance) =>
    <String, dynamic>{
      'book': instance.book,
      'podcast': instance.podcast,
      'narrators': instance.narrators,
      'tags': instance.tags,
      'genres': instance.genres,
      'series': instance.series,
      'authors': instance.authors,
    };

_SearchLibraryResult _$SearchLibraryResultFromJson(Map<String, dynamic> json) =>
    _SearchLibraryResult(
      libraryItem:
          json['libraryItem'] == null
              ? null
              : LibraryItem.fromJson(
                json['libraryItem'] as Map<String, dynamic>,
              ),
      matchKey: json['matchKey'] as String?,
      matchText: json['matchText'] as String?,
    );

Map<String, dynamic> _$SearchLibraryResultToJson(
  _SearchLibraryResult instance,
) => <String, dynamic>{
  'libraryItem': instance.libraryItem,
  'matchKey': instance.matchKey,
  'matchText': instance.matchText,
};

_SearchResultItem _$SearchResultItemFromJson(Map<String, dynamic> json) =>
    _SearchResultItem(
      name: json['name'] as String,
      numItems: (json['numItems'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SearchResultItemToJson(_SearchResultItem instance) =>
    <String, dynamic>{'name': instance.name, 'numItems': instance.numItems};

_SearchResultNarrator _$SearchResultNarratorFromJson(
  Map<String, dynamic> json,
) => _SearchResultNarrator(
  name: json['name'] as String,
  numItems: (json['numItems'] as num?)?.toInt(),
);

Map<String, dynamic> _$SearchResultNarratorToJson(
  _SearchResultNarrator instance,
) => <String, dynamic>{'name': instance.name, 'numItems': instance.numItems};
