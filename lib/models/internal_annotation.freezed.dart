// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'internal_annotation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InternalAnnotation {

@JsonKey(name: "cfi") String get cfi;@JsonKey(name: "text") String? get text;@JsonKey(name: "color") String? get color;@JsonKey(name: "opacity") double? get opacity;@JsonKey(name: "thickness") double? get thickness;@JsonKey(name: "type") AnnotationType? get type;
/// Create a copy of InternalAnnotation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalAnnotationCopyWith<InternalAnnotation> get copyWith => _$InternalAnnotationCopyWithImpl<InternalAnnotation>(this as InternalAnnotation, _$identity);

  /// Serializes this InternalAnnotation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalAnnotation&&(identical(other.cfi, cfi) || other.cfi == cfi)&&(identical(other.text, text) || other.text == text)&&(identical(other.color, color) || other.color == color)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.thickness, thickness) || other.thickness == thickness)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cfi,text,color,opacity,thickness,type);

@override
String toString() {
  return 'InternalAnnotation(cfi: $cfi, text: $text, color: $color, opacity: $opacity, thickness: $thickness, type: $type)';
}


}

/// @nodoc
abstract mixin class $InternalAnnotationCopyWith<$Res>  {
  factory $InternalAnnotationCopyWith(InternalAnnotation value, $Res Function(InternalAnnotation) _then) = _$InternalAnnotationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "cfi") String cfi,@JsonKey(name: "text") String? text,@JsonKey(name: "color") String? color,@JsonKey(name: "opacity") double? opacity,@JsonKey(name: "thickness") double? thickness,@JsonKey(name: "type") AnnotationType? type
});




}
/// @nodoc
class _$InternalAnnotationCopyWithImpl<$Res>
    implements $InternalAnnotationCopyWith<$Res> {
  _$InternalAnnotationCopyWithImpl(this._self, this._then);

  final InternalAnnotation _self;
  final $Res Function(InternalAnnotation) _then;

/// Create a copy of InternalAnnotation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cfi = null,Object? text = freezed,Object? color = freezed,Object? opacity = freezed,Object? thickness = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
cfi: null == cfi ? _self.cfi : cfi // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double?,thickness: freezed == thickness ? _self.thickness : thickness // ignore: cast_nullable_to_non_nullable
as double?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnnotationType?,
  ));
}

}


/// Adds pattern-matching-related methods to [InternalAnnotation].
extension InternalAnnotationPatterns on InternalAnnotation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InternalAnnotation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InternalAnnotation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InternalAnnotation value)  $default,){
final _that = this;
switch (_that) {
case _InternalAnnotation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InternalAnnotation value)?  $default,){
final _that = this;
switch (_that) {
case _InternalAnnotation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "cfi")  String cfi, @JsonKey(name: "text")  String? text, @JsonKey(name: "color")  String? color, @JsonKey(name: "opacity")  double? opacity, @JsonKey(name: "thickness")  double? thickness, @JsonKey(name: "type")  AnnotationType? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InternalAnnotation() when $default != null:
return $default(_that.cfi,_that.text,_that.color,_that.opacity,_that.thickness,_that.type);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "cfi")  String cfi, @JsonKey(name: "text")  String? text, @JsonKey(name: "color")  String? color, @JsonKey(name: "opacity")  double? opacity, @JsonKey(name: "thickness")  double? thickness, @JsonKey(name: "type")  AnnotationType? type)  $default,) {final _that = this;
switch (_that) {
case _InternalAnnotation():
return $default(_that.cfi,_that.text,_that.color,_that.opacity,_that.thickness,_that.type);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "cfi")  String cfi, @JsonKey(name: "text")  String? text, @JsonKey(name: "color")  String? color, @JsonKey(name: "opacity")  double? opacity, @JsonKey(name: "thickness")  double? thickness, @JsonKey(name: "type")  AnnotationType? type)?  $default,) {final _that = this;
switch (_that) {
case _InternalAnnotation() when $default != null:
return $default(_that.cfi,_that.text,_that.color,_that.opacity,_that.thickness,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InternalAnnotation extends InternalAnnotation {
   _InternalAnnotation({@JsonKey(name: "cfi") required this.cfi, @JsonKey(name: "text") this.text, @JsonKey(name: "color") this.color, @JsonKey(name: "opacity") this.opacity, @JsonKey(name: "thickness") this.thickness, @JsonKey(name: "type") this.type}): super._();
  factory _InternalAnnotation.fromJson(Map<String, dynamic> json) => _$InternalAnnotationFromJson(json);

@override@JsonKey(name: "cfi") final  String cfi;
@override@JsonKey(name: "text") final  String? text;
@override@JsonKey(name: "color") final  String? color;
@override@JsonKey(name: "opacity") final  double? opacity;
@override@JsonKey(name: "thickness") final  double? thickness;
@override@JsonKey(name: "type") final  AnnotationType? type;

/// Create a copy of InternalAnnotation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternalAnnotationCopyWith<_InternalAnnotation> get copyWith => __$InternalAnnotationCopyWithImpl<_InternalAnnotation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternalAnnotationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalAnnotation&&(identical(other.cfi, cfi) || other.cfi == cfi)&&(identical(other.text, text) || other.text == text)&&(identical(other.color, color) || other.color == color)&&(identical(other.opacity, opacity) || other.opacity == opacity)&&(identical(other.thickness, thickness) || other.thickness == thickness)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,cfi,text,color,opacity,thickness,type);

@override
String toString() {
  return 'InternalAnnotation(cfi: $cfi, text: $text, color: $color, opacity: $opacity, thickness: $thickness, type: $type)';
}


}

/// @nodoc
abstract mixin class _$InternalAnnotationCopyWith<$Res> implements $InternalAnnotationCopyWith<$Res> {
  factory _$InternalAnnotationCopyWith(_InternalAnnotation value, $Res Function(_InternalAnnotation) _then) = __$InternalAnnotationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "cfi") String cfi,@JsonKey(name: "text") String? text,@JsonKey(name: "color") String? color,@JsonKey(name: "opacity") double? opacity,@JsonKey(name: "thickness") double? thickness,@JsonKey(name: "type") AnnotationType? type
});




}
/// @nodoc
class __$InternalAnnotationCopyWithImpl<$Res>
    implements _$InternalAnnotationCopyWith<$Res> {
  __$InternalAnnotationCopyWithImpl(this._self, this._then);

  final _InternalAnnotation _self;
  final $Res Function(_InternalAnnotation) _then;

/// Create a copy of InternalAnnotation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cfi = null,Object? text = freezed,Object? color = freezed,Object? opacity = freezed,Object? thickness = freezed,Object? type = freezed,}) {
  return _then(_InternalAnnotation(
cfi: null == cfi ? _self.cfi : cfi // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,opacity: freezed == opacity ? _self.opacity : opacity // ignore: cast_nullable_to_non_nullable
as double?,thickness: freezed == thickness ? _self.thickness : thickness // ignore: cast_nullable_to_non_nullable
as double?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AnnotationType?,
  ));
}


}

// dart format on
