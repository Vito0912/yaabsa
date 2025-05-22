// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalized_library.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShelfEntry<T> _$ShelfEntryFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _ShelfEntry<T>(
  id: json['id'] as String,
  label: json['label'] as String,
  labelStringKey: json['labelStringKey'] as String,
  type: $enumDecode(_$ShelfTypeEnumMap, json['type']),
  total: (json['total'] as num).toInt(),
  entities: (json['entities'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$ShelfEntryToJson<T>(
  _ShelfEntry<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'labelStringKey': instance.labelStringKey,
  'type': _$ShelfTypeEnumMap[instance.type]!,
  'total': instance.total,
  'entities': instance.entities.map(toJsonT).toList(),
};

const _$ShelfTypeEnumMap = {
  ShelfType.book: 'book',
  ShelfType.series: 'series',
  ShelfType.author: 'authors',
  ShelfType.episode: 'episodes',
  ShelfType.podcast: 'podcast',
};
