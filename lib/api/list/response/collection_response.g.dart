// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CollectionResponse _$CollectionResponseFromJson(Map<String, dynamic> json) =>
    _CollectionResponse(
      items:
          (json['collections'] as List<dynamic>)
              .map((e) => Collection.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$CollectionResponseToJson(_CollectionResponse instance) =>
    <String, dynamic>{'collections': instance.items};
