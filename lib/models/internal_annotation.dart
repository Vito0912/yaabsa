import 'package:freezed_annotation/freezed_annotation.dart';

part 'internal_annotation.freezed.dart';
part 'internal_annotation.g.dart';

@freezed
abstract class InternalAnnotation with _$InternalAnnotation {
  InternalAnnotation._();

  factory InternalAnnotation({
    @JsonKey(name: "cfi") required String cfi,
    @JsonKey(name: "text") String? text,
    @JsonKey(name: "color") String? color,
    @JsonKey(name: "opacity") double? opacity,
    @JsonKey(name: "thickness") double? thickness,
    @JsonKey(name: "type") AnnotationType? type,
  }) = _InternalAnnotation;

  factory InternalAnnotation.fromJson(Map<String, dynamic> json) => _$InternalAnnotationFromJson(json);
}

enum AnnotationType {
  @JsonValue("highlight")
  highlight,
  @JsonValue("underline")
  underline,
  @JsonValue("bookmark")
  bookmark,
}
