// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata_term_update_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MetadataTermUpdateResponse _$MetadataTermUpdateResponseFromJson(Map<String, dynamic> json) =>
    _MetadataTermUpdateResponse(
      numItemsUpdated: json['numItemsUpdated'] == null ? 0 : jsonIntRequiredFromDynamic(json['numItemsUpdated']),
      tagMerged: json['tagMerged'] as bool?,
      genreMerged: json['genreMerged'] as bool?,
    );

Map<String, dynamic> _$MetadataTermUpdateResponseToJson(_MetadataTermUpdateResponse instance) => <String, dynamic>{
  'numItemsUpdated': instance.numItemsUpdated,
  'tagMerged': instance.tagMerged,
  'genreMerged': instance.genreMerged,
};
