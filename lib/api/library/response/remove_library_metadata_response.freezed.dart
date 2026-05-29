// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remove_library_metadata_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoveLibraryMetadataResponse {

@JsonKey(name: 'found') bool get found;@JsonKey(name: 'numRemoved') int get numRemoved;@JsonKey(name: 'error') String? get error;
/// Create a copy of RemoveLibraryMetadataResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoveLibraryMetadataResponseCopyWith<RemoveLibraryMetadataResponse> get copyWith => _$RemoveLibraryMetadataResponseCopyWithImpl<RemoveLibraryMetadataResponse>(this as RemoveLibraryMetadataResponse, _$identity);

  /// Serializes this RemoveLibraryMetadataResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoveLibraryMetadataResponse&&(identical(other.found, found) || other.found == found)&&(identical(other.numRemoved, numRemoved) || other.numRemoved == numRemoved)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,found,numRemoved,error);

@override
String toString() {
  return 'RemoveLibraryMetadataResponse(found: $found, numRemoved: $numRemoved, error: $error)';
}


}

/// @nodoc
abstract mixin class $RemoveLibraryMetadataResponseCopyWith<$Res>  {
  factory $RemoveLibraryMetadataResponseCopyWith(RemoveLibraryMetadataResponse value, $Res Function(RemoveLibraryMetadataResponse) _then) = _$RemoveLibraryMetadataResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'found') bool found,@JsonKey(name: 'numRemoved') int numRemoved,@JsonKey(name: 'error') String? error
});




}
/// @nodoc
class _$RemoveLibraryMetadataResponseCopyWithImpl<$Res>
    implements $RemoveLibraryMetadataResponseCopyWith<$Res> {
  _$RemoveLibraryMetadataResponseCopyWithImpl(this._self, this._then);

  final RemoveLibraryMetadataResponse _self;
  final $Res Function(RemoveLibraryMetadataResponse) _then;

/// Create a copy of RemoveLibraryMetadataResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? found = null,Object? numRemoved = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
found: null == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as bool,numRemoved: null == numRemoved ? _self.numRemoved : numRemoved // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RemoveLibraryMetadataResponse].
extension RemoveLibraryMetadataResponsePatterns on RemoveLibraryMetadataResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoveLibraryMetadataResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoveLibraryMetadataResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoveLibraryMetadataResponse value)  $default,){
final _that = this;
switch (_that) {
case _RemoveLibraryMetadataResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoveLibraryMetadataResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RemoveLibraryMetadataResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'found')  bool found, @JsonKey(name: 'numRemoved')  int numRemoved, @JsonKey(name: 'error')  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoveLibraryMetadataResponse() when $default != null:
return $default(_that.found,_that.numRemoved,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'found')  bool found, @JsonKey(name: 'numRemoved')  int numRemoved, @JsonKey(name: 'error')  String? error)  $default,) {final _that = this;
switch (_that) {
case _RemoveLibraryMetadataResponse():
return $default(_that.found,_that.numRemoved,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'found')  bool found, @JsonKey(name: 'numRemoved')  int numRemoved, @JsonKey(name: 'error')  String? error)?  $default,) {final _that = this;
switch (_that) {
case _RemoveLibraryMetadataResponse() when $default != null:
return $default(_that.found,_that.numRemoved,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RemoveLibraryMetadataResponse implements RemoveLibraryMetadataResponse {
  const _RemoveLibraryMetadataResponse({@JsonKey(name: 'found') required this.found, @JsonKey(name: 'numRemoved') this.numRemoved = 0, @JsonKey(name: 'error') this.error});
  factory _RemoveLibraryMetadataResponse.fromJson(Map<String, dynamic> json) => _$RemoveLibraryMetadataResponseFromJson(json);

@override@JsonKey(name: 'found') final  bool found;
@override@JsonKey(name: 'numRemoved') final  int numRemoved;
@override@JsonKey(name: 'error') final  String? error;

/// Create a copy of RemoveLibraryMetadataResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveLibraryMetadataResponseCopyWith<_RemoveLibraryMetadataResponse> get copyWith => __$RemoveLibraryMetadataResponseCopyWithImpl<_RemoveLibraryMetadataResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RemoveLibraryMetadataResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveLibraryMetadataResponse&&(identical(other.found, found) || other.found == found)&&(identical(other.numRemoved, numRemoved) || other.numRemoved == numRemoved)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,found,numRemoved,error);

@override
String toString() {
  return 'RemoveLibraryMetadataResponse(found: $found, numRemoved: $numRemoved, error: $error)';
}


}

/// @nodoc
abstract mixin class _$RemoveLibraryMetadataResponseCopyWith<$Res> implements $RemoveLibraryMetadataResponseCopyWith<$Res> {
  factory _$RemoveLibraryMetadataResponseCopyWith(_RemoveLibraryMetadataResponse value, $Res Function(_RemoveLibraryMetadataResponse) _then) = __$RemoveLibraryMetadataResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'found') bool found,@JsonKey(name: 'numRemoved') int numRemoved,@JsonKey(name: 'error') String? error
});




}
/// @nodoc
class __$RemoveLibraryMetadataResponseCopyWithImpl<$Res>
    implements _$RemoveLibraryMetadataResponseCopyWith<$Res> {
  __$RemoveLibraryMetadataResponseCopyWithImpl(this._self, this._then);

  final _RemoveLibraryMetadataResponse _self;
  final $Res Function(_RemoveLibraryMetadataResponse) _then;

/// Create a copy of RemoveLibraryMetadataResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? found = null,Object? numRemoved = null,Object? error = freezed,}) {
  return _then(_RemoveLibraryMetadataResponse(
found: null == found ? _self.found : found // ignore: cast_nullable_to_non_nullable
as bool,numRemoved: null == numRemoved ? _self.numRemoved : numRemoved // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
