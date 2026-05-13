// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'path_exists_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PathExistsResponse {

@JsonKey(name: 'exists') bool get exists;@JsonKey(name: 'libraryItemTitle') String? get libraryItemTitle;@JsonKey(name: 'error') String? get error;
/// Create a copy of PathExistsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PathExistsResponseCopyWith<PathExistsResponse> get copyWith => _$PathExistsResponseCopyWithImpl<PathExistsResponse>(this as PathExistsResponse, _$identity);

  /// Serializes this PathExistsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PathExistsResponse&&(identical(other.exists, exists) || other.exists == exists)&&(identical(other.libraryItemTitle, libraryItemTitle) || other.libraryItemTitle == libraryItemTitle)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exists,libraryItemTitle,error);

@override
String toString() {
  return 'PathExistsResponse(exists: $exists, libraryItemTitle: $libraryItemTitle, error: $error)';
}


}

/// @nodoc
abstract mixin class $PathExistsResponseCopyWith<$Res>  {
  factory $PathExistsResponseCopyWith(PathExistsResponse value, $Res Function(PathExistsResponse) _then) = _$PathExistsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'exists') bool exists,@JsonKey(name: 'libraryItemTitle') String? libraryItemTitle,@JsonKey(name: 'error') String? error
});




}
/// @nodoc
class _$PathExistsResponseCopyWithImpl<$Res>
    implements $PathExistsResponseCopyWith<$Res> {
  _$PathExistsResponseCopyWithImpl(this._self, this._then);

  final PathExistsResponse _self;
  final $Res Function(PathExistsResponse) _then;

/// Create a copy of PathExistsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? exists = null,Object? libraryItemTitle = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,libraryItemTitle: freezed == libraryItemTitle ? _self.libraryItemTitle : libraryItemTitle // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PathExistsResponse].
extension PathExistsResponsePatterns on PathExistsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PathExistsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PathExistsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PathExistsResponse value)  $default,){
final _that = this;
switch (_that) {
case _PathExistsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PathExistsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PathExistsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'exists')  bool exists, @JsonKey(name: 'libraryItemTitle')  String? libraryItemTitle, @JsonKey(name: 'error')  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PathExistsResponse() when $default != null:
return $default(_that.exists,_that.libraryItemTitle,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'exists')  bool exists, @JsonKey(name: 'libraryItemTitle')  String? libraryItemTitle, @JsonKey(name: 'error')  String? error)  $default,) {final _that = this;
switch (_that) {
case _PathExistsResponse():
return $default(_that.exists,_that.libraryItemTitle,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'exists')  bool exists, @JsonKey(name: 'libraryItemTitle')  String? libraryItemTitle, @JsonKey(name: 'error')  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PathExistsResponse() when $default != null:
return $default(_that.exists,_that.libraryItemTitle,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PathExistsResponse implements PathExistsResponse {
  const _PathExistsResponse({@JsonKey(name: 'exists') required this.exists, @JsonKey(name: 'libraryItemTitle') this.libraryItemTitle, @JsonKey(name: 'error') this.error});
  factory _PathExistsResponse.fromJson(Map<String, dynamic> json) => _$PathExistsResponseFromJson(json);

@override@JsonKey(name: 'exists') final  bool exists;
@override@JsonKey(name: 'libraryItemTitle') final  String? libraryItemTitle;
@override@JsonKey(name: 'error') final  String? error;

/// Create a copy of PathExistsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PathExistsResponseCopyWith<_PathExistsResponse> get copyWith => __$PathExistsResponseCopyWithImpl<_PathExistsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PathExistsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PathExistsResponse&&(identical(other.exists, exists) || other.exists == exists)&&(identical(other.libraryItemTitle, libraryItemTitle) || other.libraryItemTitle == libraryItemTitle)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,exists,libraryItemTitle,error);

@override
String toString() {
  return 'PathExistsResponse(exists: $exists, libraryItemTitle: $libraryItemTitle, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PathExistsResponseCopyWith<$Res> implements $PathExistsResponseCopyWith<$Res> {
  factory _$PathExistsResponseCopyWith(_PathExistsResponse value, $Res Function(_PathExistsResponse) _then) = __$PathExistsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'exists') bool exists,@JsonKey(name: 'libraryItemTitle') String? libraryItemTitle,@JsonKey(name: 'error') String? error
});




}
/// @nodoc
class __$PathExistsResponseCopyWithImpl<$Res>
    implements _$PathExistsResponseCopyWith<$Res> {
  __$PathExistsResponseCopyWithImpl(this._self, this._then);

  final _PathExistsResponse _self;
  final $Res Function(_PathExistsResponse) _then;

/// Create a copy of PathExistsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? exists = null,Object? libraryItemTitle = freezed,Object? error = freezed,}) {
  return _then(_PathExistsResponse(
exists: null == exists ? _self.exists : exists // ignore: cast_nullable_to_non_nullable
as bool,libraryItemTitle: freezed == libraryItemTitle ? _self.libraryItemTitle : libraryItemTitle // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
