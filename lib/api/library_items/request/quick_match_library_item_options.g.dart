// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_match_library_item_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuickMatchLibraryItemOptions _$QuickMatchLibraryItemOptionsFromJson(Map<String, dynamic> json) =>
    _QuickMatchLibraryItemOptions(
      provider: json['provider'] as String?,
      title: json['title'] as String?,
      author: json['author'] as String?,
      isbn: json['isbn'] as String?,
      asin: json['asin'] as String?,
      overrideCover: json['overrideCover'] as bool? ?? true,
      overrideDetails: json['overrideDetails'] as bool? ?? true,
    );

Map<String, dynamic> _$QuickMatchLibraryItemOptionsToJson(_QuickMatchLibraryItemOptions instance) => <String, dynamic>{
  'provider': ?instance.provider,
  'title': ?instance.title,
  'author': ?instance.author,
  'isbn': ?instance.isbn,
  'asin': ?instance.asin,
  'overrideCover': instance.overrideCover,
  'overrideDetails': instance.overrideDetails,
};
