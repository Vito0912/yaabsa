// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchProviders _$SearchProvidersFromJson(Map<String, dynamic> json) => _SearchProviders(
  books:
      (json['books'] as List<dynamic>?)
          ?.map((e) => SearchProviderOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SearchProviderOption>[],
  booksCovers:
      (json['booksCovers'] as List<dynamic>?)
          ?.map((e) => SearchProviderOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SearchProviderOption>[],
  podcasts:
      (json['podcasts'] as List<dynamic>?)
          ?.map((e) => SearchProviderOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SearchProviderOption>[],
);

Map<String, dynamic> _$SearchProvidersToJson(_SearchProviders instance) => <String, dynamic>{
  'books': instance.books,
  'booksCovers': instance.booksCovers,
  'podcasts': instance.podcasts,
};
