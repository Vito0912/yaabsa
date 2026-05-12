// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_library_item_media_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateLibraryItemMediaRequest _$UpdateLibraryItemMediaRequestFromJson(Map<String, dynamic> json) =>
    _UpdateLibraryItemMediaRequest(
      metadata: json['metadata'] == null
          ? null
          : UpdateLibraryItemMediaMetadataPatch.fromJson(json['metadata'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      url: json['url'] as String?,
    );

Map<String, dynamic> _$UpdateLibraryItemMediaRequestToJson(_UpdateLibraryItemMediaRequest instance) =>
    <String, dynamic>{'metadata': ?instance.metadata, 'tags': ?instance.tags, 'url': ?instance.url};

_UpdateLibraryItemMediaMetadataPatch _$UpdateLibraryItemMediaMetadataPatchFromJson(Map<String, dynamic> json) =>
    _UpdateLibraryItemMediaMetadataPatch(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      author: json['author'] as String?,
      authors: (json['authors'] as List<dynamic>?)?.map((e) => Author.fromJson(e as Map<String, dynamic>)).toList(),
      narrators: (json['narrators'] as List<dynamic>?)?.map((e) => e as String).toList(),
      series: (json['series'] as List<dynamic>?)?.map((e) => Series.fromJson(e as Map<String, dynamic>)).toList(),
      genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
      publisher: json['publisher'] as String?,
      publishedYear: json['publishedYear'] as String?,
      publishedDate: json['publishedDate'] as String?,
      description: json['description'] as String?,
      language: json['language'] as String?,
      explicit: json['explicit'] as bool?,
      abridged: json['abridged'] as bool?,
      isbn: json['isbn'] as String?,
      asin: json['asin'] as String?,
      feedUrl: json['feedUrl'] as String?,
      itunesPageUrl: json['itunesPageUrl'] as String?,
      itunesId: json['itunesId'] as String?,
      releaseDate: json['releaseDate'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$UpdateLibraryItemMediaMetadataPatchToJson(_UpdateLibraryItemMediaMetadataPatch instance) =>
    <String, dynamic>{
      'title': ?instance.title,
      'subtitle': ?instance.subtitle,
      'author': ?instance.author,
      'authors': ?instance.authors,
      'narrators': ?instance.narrators,
      'series': ?instance.series,
      'genres': ?instance.genres,
      'publisher': ?instance.publisher,
      'publishedYear': ?instance.publishedYear,
      'publishedDate': ?instance.publishedDate,
      'description': ?instance.description,
      'language': ?instance.language,
      'explicit': ?instance.explicit,
      'abridged': ?instance.abridged,
      'isbn': ?instance.isbn,
      'asin': ?instance.asin,
      'feedUrl': ?instance.feedUrl,
      'itunesPageUrl': ?instance.itunesPageUrl,
      'itunesId': ?instance.itunesId,
      'releaseDate': ?instance.releaseDate,
      'type': ?instance.type,
    };
