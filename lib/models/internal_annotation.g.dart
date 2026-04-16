// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'internal_annotation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InternalAnnotation _$InternalAnnotationFromJson(Map<String, dynamic> json) =>
    _InternalAnnotation(
      cfi: json['cfi'] as String,
      text: json['text'] as String?,
      color: json['color'] as String?,
      opacity: (json['opacity'] as num?)?.toDouble(),
      thickness: (json['thickness'] as num?)?.toDouble(),
      type: $enumDecodeNullable(_$AnnotationTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$InternalAnnotationToJson(_InternalAnnotation instance) =>
    <String, dynamic>{
      'cfi': instance.cfi,
      'text': instance.text,
      'color': instance.color,
      'opacity': instance.opacity,
      'thickness': instance.thickness,
      'type': _$AnnotationTypeEnumMap[instance.type],
    };

const _$AnnotationTypeEnumMap = {
  AnnotationType.highlight: 'highlight',
  AnnotationType.underline: 'underline',
  AnnotationType.bookmark: 'bookmark',
};
