// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_backup_path_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateBackupPathRequest {

@JsonKey(name: 'path') String get path;
/// Create a copy of UpdateBackupPathRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateBackupPathRequestCopyWith<UpdateBackupPathRequest> get copyWith => _$UpdateBackupPathRequestCopyWithImpl<UpdateBackupPathRequest>(this as UpdateBackupPathRequest, _$identity);

  /// Serializes this UpdateBackupPathRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateBackupPathRequest&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'UpdateBackupPathRequest(path: $path)';
}


}

/// @nodoc
abstract mixin class $UpdateBackupPathRequestCopyWith<$Res>  {
  factory $UpdateBackupPathRequestCopyWith(UpdateBackupPathRequest value, $Res Function(UpdateBackupPathRequest) _then) = _$UpdateBackupPathRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'path') String path
});




}
/// @nodoc
class _$UpdateBackupPathRequestCopyWithImpl<$Res>
    implements $UpdateBackupPathRequestCopyWith<$Res> {
  _$UpdateBackupPathRequestCopyWithImpl(this._self, this._then);

  final UpdateBackupPathRequest _self;
  final $Res Function(UpdateBackupPathRequest) _then;

/// Create a copy of UpdateBackupPathRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateBackupPathRequest].
extension UpdateBackupPathRequestPatterns on UpdateBackupPathRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateBackupPathRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateBackupPathRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateBackupPathRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateBackupPathRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateBackupPathRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateBackupPathRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateBackupPathRequest() when $default != null:
return $default(_that.path);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path)  $default,) {final _that = this;
switch (_that) {
case _UpdateBackupPathRequest():
return $default(_that.path);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'path')  String path)?  $default,) {final _that = this;
switch (_that) {
case _UpdateBackupPathRequest() when $default != null:
return $default(_that.path);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateBackupPathRequest implements UpdateBackupPathRequest {
  const _UpdateBackupPathRequest({@JsonKey(name: 'path') required this.path});
  factory _UpdateBackupPathRequest.fromJson(Map<String, dynamic> json) => _$UpdateBackupPathRequestFromJson(json);

@override@JsonKey(name: 'path') final  String path;

/// Create a copy of UpdateBackupPathRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateBackupPathRequestCopyWith<_UpdateBackupPathRequest> get copyWith => __$UpdateBackupPathRequestCopyWithImpl<_UpdateBackupPathRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateBackupPathRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateBackupPathRequest&&(identical(other.path, path) || other.path == path));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path);

@override
String toString() {
  return 'UpdateBackupPathRequest(path: $path)';
}


}

/// @nodoc
abstract mixin class _$UpdateBackupPathRequestCopyWith<$Res> implements $UpdateBackupPathRequestCopyWith<$Res> {
  factory _$UpdateBackupPathRequestCopyWith(_UpdateBackupPathRequest value, $Res Function(_UpdateBackupPathRequest) _then) = __$UpdateBackupPathRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'path') String path
});




}
/// @nodoc
class __$UpdateBackupPathRequestCopyWithImpl<$Res>
    implements _$UpdateBackupPathRequestCopyWith<$Res> {
  __$UpdateBackupPathRequestCopyWithImpl(this._self, this._then);

  final _UpdateBackupPathRequest _self;
  final $Res Function(_UpdateBackupPathRequest) _then;

/// Create a copy of UpdateBackupPathRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,}) {
  return _then(_UpdateBackupPathRequest(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
