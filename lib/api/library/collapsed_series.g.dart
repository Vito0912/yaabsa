// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collapsed_series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollapsedSeries _$CollapsedSeriesFromJson(Map<String, dynamic> json) =>
    _CollapsedSeries(
      id: json['id'] as String,
      name: json['name'] as String?,
      nameIgnorePrefix: json['nameIgnorePrefix'] as String?,
      sequence: json['sequence'] as String?,
      numBooks: (json['numBooks'] as num?)?.toInt(),
      libraryItemIds:
          (json['libraryItemIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$CollapsedSeriesToJson(_CollapsedSeries instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'nameIgnorePrefix': instance.nameIgnorePrefix,
      'sequence': instance.sequence,
      'numBooks': instance.numBooks,
      'libraryItemIds': instance.libraryItemIds,
    };
