// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaMetadata _$MediaMetadataFromJson(
  Map<String, dynamic> json,
) => _MediaMetadata(
  title: json['title'] as String,
  subtitle: json['subtitle'] as String?,
  authors:
      (json['authors'] as List<dynamic>?)
          ?.map((e) => Author.fromJson(e as Map<String, dynamic>))
          .toList(),
  narrators:
      (json['narrators'] as List<dynamic>?)?.map((e) => e as String).toList(),
  series: const SeriesConverter().fromJson(json['series']),
  genres: (json['genres'] as List<dynamic>?)?.map((e) => e as String).toList(),
  publishedYear: json['publishedYear'] as String?,
  publishedDate: json['publishedDate'] as String?,
  publisher: json['publisher'] as String?,
  description: json['description'] as String?,
  isbn: json['isbn'] as String?,
  asin: json['asin'] as String?,
  language: json['language'] as String?,
  explicit: json['explicit'] as bool?,
  abridged: json['abridged'] as bool?,
);

Map<String, dynamic> _$MediaMetadataToJson(_MediaMetadata instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'authors': instance.authors,
      'narrators': instance.narrators,
      'series': const SeriesConverter().toJson(instance.series),
      'genres': instance.genres,
      'publishedYear': instance.publishedYear,
      'publishedDate': instance.publishedDate,
      'publisher': instance.publisher,
      'description': instance.description,
      'isbn': instance.isbn,
      'asin': instance.asin,
      'language': instance.language,
      'explicit': instance.explicit,
      'abridged': instance.abridged,
    };
