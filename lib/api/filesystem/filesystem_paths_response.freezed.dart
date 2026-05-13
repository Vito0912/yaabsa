// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filesystem_paths_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilesystemPathsResponse {

@JsonKey(name: 'posix') bool get posix;@JsonKey(name: 'directories') List<FilesystemDirectory> get directories;
/// Create a copy of FilesystemPathsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilesystemPathsResponseCopyWith<FilesystemPathsResponse> get copyWith => _$FilesystemPathsResponseCopyWithImpl<FilesystemPathsResponse>(this as FilesystemPathsResponse, _$identity);

  /// Serializes this FilesystemPathsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilesystemPathsResponse&&(identical(other.posix, posix) || other.posix == posix)&&const DeepCollectionEquality().equals(other.directories, directories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,posix,const DeepCollectionEquality().hash(directories));

@override
String toString() {
  return 'FilesystemPathsResponse(posix: $posix, directories: $directories)';
}


}

/// @nodoc
abstract mixin class $FilesystemPathsResponseCopyWith<$Res>  {
  factory $FilesystemPathsResponseCopyWith(FilesystemPathsResponse value, $Res Function(FilesystemPathsResponse) _then) = _$FilesystemPathsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'posix') bool posix,@JsonKey(name: 'directories') List<FilesystemDirectory> directories
});




}
/// @nodoc
class _$FilesystemPathsResponseCopyWithImpl<$Res>
    implements $FilesystemPathsResponseCopyWith<$Res> {
  _$FilesystemPathsResponseCopyWithImpl(this._self, this._then);

  final FilesystemPathsResponse _self;
  final $Res Function(FilesystemPathsResponse) _then;

/// Create a copy of FilesystemPathsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? posix = null,Object? directories = null,}) {
  return _then(_self.copyWith(
posix: null == posix ? _self.posix : posix // ignore: cast_nullable_to_non_nullable
as bool,directories: null == directories ? _self.directories : directories // ignore: cast_nullable_to_non_nullable
as List<FilesystemDirectory>,
  ));
}

}


/// Adds pattern-matching-related methods to [FilesystemPathsResponse].
extension FilesystemPathsResponsePatterns on FilesystemPathsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilesystemPathsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilesystemPathsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilesystemPathsResponse value)  $default,){
final _that = this;
switch (_that) {
case _FilesystemPathsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilesystemPathsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _FilesystemPathsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'posix')  bool posix, @JsonKey(name: 'directories')  List<FilesystemDirectory> directories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilesystemPathsResponse() when $default != null:
return $default(_that.posix,_that.directories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'posix')  bool posix, @JsonKey(name: 'directories')  List<FilesystemDirectory> directories)  $default,) {final _that = this;
switch (_that) {
case _FilesystemPathsResponse():
return $default(_that.posix,_that.directories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'posix')  bool posix, @JsonKey(name: 'directories')  List<FilesystemDirectory> directories)?  $default,) {final _that = this;
switch (_that) {
case _FilesystemPathsResponse() when $default != null:
return $default(_that.posix,_that.directories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilesystemPathsResponse implements FilesystemPathsResponse {
  const _FilesystemPathsResponse({@JsonKey(name: 'posix') required this.posix, @JsonKey(name: 'directories') final  List<FilesystemDirectory> directories = const <FilesystemDirectory>[]}): _directories = directories;
  factory _FilesystemPathsResponse.fromJson(Map<String, dynamic> json) => _$FilesystemPathsResponseFromJson(json);

@override@JsonKey(name: 'posix') final  bool posix;
 final  List<FilesystemDirectory> _directories;
@override@JsonKey(name: 'directories') List<FilesystemDirectory> get directories {
  if (_directories is EqualUnmodifiableListView) return _directories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_directories);
}


/// Create a copy of FilesystemPathsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilesystemPathsResponseCopyWith<_FilesystemPathsResponse> get copyWith => __$FilesystemPathsResponseCopyWithImpl<_FilesystemPathsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilesystemPathsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilesystemPathsResponse&&(identical(other.posix, posix) || other.posix == posix)&&const DeepCollectionEquality().equals(other._directories, _directories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,posix,const DeepCollectionEquality().hash(_directories));

@override
String toString() {
  return 'FilesystemPathsResponse(posix: $posix, directories: $directories)';
}


}

/// @nodoc
abstract mixin class _$FilesystemPathsResponseCopyWith<$Res> implements $FilesystemPathsResponseCopyWith<$Res> {
  factory _$FilesystemPathsResponseCopyWith(_FilesystemPathsResponse value, $Res Function(_FilesystemPathsResponse) _then) = __$FilesystemPathsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'posix') bool posix,@JsonKey(name: 'directories') List<FilesystemDirectory> directories
});




}
/// @nodoc
class __$FilesystemPathsResponseCopyWithImpl<$Res>
    implements _$FilesystemPathsResponseCopyWith<$Res> {
  __$FilesystemPathsResponseCopyWithImpl(this._self, this._then);

  final _FilesystemPathsResponse _self;
  final $Res Function(_FilesystemPathsResponse) _then;

/// Create a copy of FilesystemPathsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? posix = null,Object? directories = null,}) {
  return _then(_FilesystemPathsResponse(
posix: null == posix ? _self.posix : posix // ignore: cast_nullable_to_non_nullable
as bool,directories: null == directories ? _self._directories : directories // ignore: cast_nullable_to_non_nullable
as List<FilesystemDirectory>,
  ));
}


}

// dart format on
