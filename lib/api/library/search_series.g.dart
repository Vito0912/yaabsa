// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchSeries _$SearchSeriesFromJson(Map<String, dynamic> json) =>
    _SearchSeries(
      series: Series.fromJson(json['series'] as Map<String, dynamic>),
      books:
          (json['books'] as List<dynamic>)
              .map((e) => LibraryItem.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SearchSeriesToJson(_SearchSeries instance) =>
    <String, dynamic>{'series': instance.series, 'books': instance.books};
