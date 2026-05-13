// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genres_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenresResponse {

@JsonKey(name: 'genres', fromJson: _stringListFromJson) List<String> get genres;
/// Create a copy of GenresResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenresResponseCopyWith<GenresResponse> get copyWith => _$GenresResponseCopyWithImpl<GenresResponse>(this as GenresResponse, _$identity);

  /// Serializes this GenresResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenresResponse&&const DeepCollectionEquality().equals(other.genres, genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genres));

@override
String toString() {
  return 'GenresResponse(genres: $genres)';
}


}

/// @nodoc
abstract mixin class $GenresResponseCopyWith<$Res>  {
  factory $GenresResponseCopyWith(GenresResponse value, $Res Function(GenresResponse) _then) = _$GenresResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'genres', fromJson: _stringListFromJson) List<String> genres
});




}
/// @nodoc
class _$GenresResponseCopyWithImpl<$Res>
    implements $GenresResponseCopyWith<$Res> {
  _$GenresResponseCopyWithImpl(this._self, this._then);

  final GenresResponse _self;
  final $Res Function(GenresResponse) _then;

/// Create a copy of GenresResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genres = null,}) {
  return _then(_self.copyWith(
genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [GenresResponse].
extension GenresResponsePatterns on GenresResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenresResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenresResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenresResponse value)  $default,){
final _that = this;
switch (_that) {
case _GenresResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenresResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GenresResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'genres', fromJson: _stringListFromJson)  List<String> genres)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenresResponse() when $default != null:
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'genres', fromJson: _stringListFromJson)  List<String> genres)  $default,) {final _that = this;
switch (_that) {
case _GenresResponse():
return $default(_that.genres);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'genres', fromJson: _stringListFromJson)  List<String> genres)?  $default,) {final _that = this;
switch (_that) {
case _GenresResponse() when $default != null:
return $default(_that.genres);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenresResponse implements GenresResponse {
  const _GenresResponse({@JsonKey(name: 'genres', fromJson: _stringListFromJson) final  List<String> genres = const <String>[]}): _genres = genres;
  factory _GenresResponse.fromJson(Map<String, dynamic> json) => _$GenresResponseFromJson(json);

 final  List<String> _genres;
@override@JsonKey(name: 'genres', fromJson: _stringListFromJson) List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}


/// Create a copy of GenresResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenresResponseCopyWith<_GenresResponse> get copyWith => __$GenresResponseCopyWithImpl<_GenresResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenresResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenresResponse&&const DeepCollectionEquality().equals(other._genres, _genres));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genres));

@override
String toString() {
  return 'GenresResponse(genres: $genres)';
}


}

/// @nodoc
abstract mixin class _$GenresResponseCopyWith<$Res> implements $GenresResponseCopyWith<$Res> {
  factory _$GenresResponseCopyWith(_GenresResponse value, $Res Function(_GenresResponse) _then) = __$GenresResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'genres', fromJson: _stringListFromJson) List<String> genres
});




}
/// @nodoc
class __$GenresResponseCopyWithImpl<$Res>
    implements _$GenresResponseCopyWith<$Res> {
  __$GenresResponseCopyWithImpl(this._self, this._then);

  final _GenresResponse _self;
  final $Res Function(_GenresResponse) _then;

/// Create a copy of GenresResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genres = null,}) {
  return _then(_GenresResponse(
genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
