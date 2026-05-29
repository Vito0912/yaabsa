// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_backups_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminBackupsResponse {

@JsonKey(name: 'backups') List<AdminBackup> get backups;@JsonKey(name: 'backupLocation') String? get backupLocation;@JsonKey(name: 'backupPathEnvSet') bool get backupPathEnvSet;
/// Create a copy of AdminBackupsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBackupsResponseCopyWith<AdminBackupsResponse> get copyWith => _$AdminBackupsResponseCopyWithImpl<AdminBackupsResponse>(this as AdminBackupsResponse, _$identity);

  /// Serializes this AdminBackupsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBackupsResponse&&const DeepCollectionEquality().equals(other.backups, backups)&&(identical(other.backupLocation, backupLocation) || other.backupLocation == backupLocation)&&(identical(other.backupPathEnvSet, backupPathEnvSet) || other.backupPathEnvSet == backupPathEnvSet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(backups),backupLocation,backupPathEnvSet);

@override
String toString() {
  return 'AdminBackupsResponse(backups: $backups, backupLocation: $backupLocation, backupPathEnvSet: $backupPathEnvSet)';
}


}

/// @nodoc
abstract mixin class $AdminBackupsResponseCopyWith<$Res>  {
  factory $AdminBackupsResponseCopyWith(AdminBackupsResponse value, $Res Function(AdminBackupsResponse) _then) = _$AdminBackupsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'backups') List<AdminBackup> backups,@JsonKey(name: 'backupLocation') String? backupLocation,@JsonKey(name: 'backupPathEnvSet') bool backupPathEnvSet
});




}
/// @nodoc
class _$AdminBackupsResponseCopyWithImpl<$Res>
    implements $AdminBackupsResponseCopyWith<$Res> {
  _$AdminBackupsResponseCopyWithImpl(this._self, this._then);

  final AdminBackupsResponse _self;
  final $Res Function(AdminBackupsResponse) _then;

/// Create a copy of AdminBackupsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backups = null,Object? backupLocation = freezed,Object? backupPathEnvSet = null,}) {
  return _then(_self.copyWith(
backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as List<AdminBackup>,backupLocation: freezed == backupLocation ? _self.backupLocation : backupLocation // ignore: cast_nullable_to_non_nullable
as String?,backupPathEnvSet: null == backupPathEnvSet ? _self.backupPathEnvSet : backupPathEnvSet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBackupsResponse].
extension AdminBackupsResponsePatterns on AdminBackupsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBackupsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBackupsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBackupsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminBackupsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBackupsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBackupsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'backups')  List<AdminBackup> backups, @JsonKey(name: 'backupLocation')  String? backupLocation, @JsonKey(name: 'backupPathEnvSet')  bool backupPathEnvSet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBackupsResponse() when $default != null:
return $default(_that.backups,_that.backupLocation,_that.backupPathEnvSet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'backups')  List<AdminBackup> backups, @JsonKey(name: 'backupLocation')  String? backupLocation, @JsonKey(name: 'backupPathEnvSet')  bool backupPathEnvSet)  $default,) {final _that = this;
switch (_that) {
case _AdminBackupsResponse():
return $default(_that.backups,_that.backupLocation,_that.backupPathEnvSet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'backups')  List<AdminBackup> backups, @JsonKey(name: 'backupLocation')  String? backupLocation, @JsonKey(name: 'backupPathEnvSet')  bool backupPathEnvSet)?  $default,) {final _that = this;
switch (_that) {
case _AdminBackupsResponse() when $default != null:
return $default(_that.backups,_that.backupLocation,_that.backupPathEnvSet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminBackupsResponse implements AdminBackupsResponse {
  const _AdminBackupsResponse({@JsonKey(name: 'backups') final  List<AdminBackup> backups = const <AdminBackup>[], @JsonKey(name: 'backupLocation') this.backupLocation, @JsonKey(name: 'backupPathEnvSet') this.backupPathEnvSet = false}): _backups = backups;
  factory _AdminBackupsResponse.fromJson(Map<String, dynamic> json) => _$AdminBackupsResponseFromJson(json);

 final  List<AdminBackup> _backups;
@override@JsonKey(name: 'backups') List<AdminBackup> get backups {
  if (_backups is EqualUnmodifiableListView) return _backups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backups);
}

@override@JsonKey(name: 'backupLocation') final  String? backupLocation;
@override@JsonKey(name: 'backupPathEnvSet') final  bool backupPathEnvSet;

/// Create a copy of AdminBackupsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBackupsResponseCopyWith<_AdminBackupsResponse> get copyWith => __$AdminBackupsResponseCopyWithImpl<_AdminBackupsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminBackupsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBackupsResponse&&const DeepCollectionEquality().equals(other._backups, _backups)&&(identical(other.backupLocation, backupLocation) || other.backupLocation == backupLocation)&&(identical(other.backupPathEnvSet, backupPathEnvSet) || other.backupPathEnvSet == backupPathEnvSet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_backups),backupLocation,backupPathEnvSet);

@override
String toString() {
  return 'AdminBackupsResponse(backups: $backups, backupLocation: $backupLocation, backupPathEnvSet: $backupPathEnvSet)';
}


}

/// @nodoc
abstract mixin class _$AdminBackupsResponseCopyWith<$Res> implements $AdminBackupsResponseCopyWith<$Res> {
  factory _$AdminBackupsResponseCopyWith(_AdminBackupsResponse value, $Res Function(_AdminBackupsResponse) _then) = __$AdminBackupsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'backups') List<AdminBackup> backups,@JsonKey(name: 'backupLocation') String? backupLocation,@JsonKey(name: 'backupPathEnvSet') bool backupPathEnvSet
});




}
/// @nodoc
class __$AdminBackupsResponseCopyWithImpl<$Res>
    implements _$AdminBackupsResponseCopyWith<$Res> {
  __$AdminBackupsResponseCopyWithImpl(this._self, this._then);

  final _AdminBackupsResponse _self;
  final $Res Function(_AdminBackupsResponse) _then;

/// Create a copy of AdminBackupsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backups = null,Object? backupLocation = freezed,Object? backupPathEnvSet = null,}) {
  return _then(_AdminBackupsResponse(
backups: null == backups ? _self._backups : backups // ignore: cast_nullable_to_non_nullable
as List<AdminBackup>,backupLocation: freezed == backupLocation ? _self.backupLocation : backupLocation // ignore: cast_nullable_to_non_nullable
as String?,backupPathEnvSet: null == backupPathEnvSet ? _self.backupPathEnvSet : backupPathEnvSet // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
