// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthorDetails _$AuthorDetailsFromJson(Map<String, dynamic> json) => _AuthorDetails(
  id: json['id'] as String,
  asin: json['asin'] as String?,
  name: json['name'] as String,
  description: json['description'] as String?,
  imagePath: json['imagePath'] as String?,
  libraryId: json['libraryId'] as String,
  addedAt: (json['addedAt'] as num).toInt(),
  updatedAt: (json['updatedAt'] as num).toInt(),
  series:
      (json['series'] as List<dynamic>?)?.map((e) => AuthorSeriesGroup.fromJson(e as Map<String, dynamic>)).toList() ??
      const <AuthorSeriesGroup>[],
  libraryItems:
      (json['libraryItems'] as List<dynamic>?)?.map((e) => LibraryItem.fromJson(e as Map<String, dynamic>)).toList() ??
      const <LibraryItem>[],
);

Map<String, dynamic> _$AuthorDetailsToJson(_AuthorDetails instance) => <String, dynamic>{
  'id': instance.id,
  'asin': instance.asin,
  'name': instance.name,
  'description': instance.description,
  'imagePath': instance.imagePath,
  'libraryId': instance.libraryId,
  'addedAt': instance.addedAt,
  'updatedAt': instance.updatedAt,
  'series': instance.series,
  'libraryItems': instance.libraryItems,
};

_AuthorSeriesGroup _$AuthorSeriesGroupFromJson(Map<String, dynamic> json) => _AuthorSeriesGroup(
  id: json['id'] as String,
  name: json['name'] as String,
  items:
      (json['items'] as List<dynamic>?)?.map((e) => LibraryItem.fromJson(e as Map<String, dynamic>)).toList() ??
      const <LibraryItem>[],
);

Map<String, dynamic> _$AuthorSeriesGroupToJson(_AuthorSeriesGroup instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'items': instance.items,
};
