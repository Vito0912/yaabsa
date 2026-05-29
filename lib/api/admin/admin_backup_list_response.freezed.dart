// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_backup_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminBackupListResponse {

@JsonKey(name: 'backups') List<AdminBackup> get backups;
/// Create a copy of AdminBackupListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBackupListResponseCopyWith<AdminBackupListResponse> get copyWith => _$AdminBackupListResponseCopyWithImpl<AdminBackupListResponse>(this as AdminBackupListResponse, _$identity);

  /// Serializes this AdminBackupListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBackupListResponse&&const DeepCollectionEquality().equals(other.backups, backups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(backups));

@override
String toString() {
  return 'AdminBackupListResponse(backups: $backups)';
}


}

/// @nodoc
abstract mixin class $AdminBackupListResponseCopyWith<$Res>  {
  factory $AdminBackupListResponseCopyWith(AdminBackupListResponse value, $Res Function(AdminBackupListResponse) _then) = _$AdminBackupListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'backups') List<AdminBackup> backups
});




}
/// @nodoc
class _$AdminBackupListResponseCopyWithImpl<$Res>
    implements $AdminBackupListResponseCopyWith<$Res> {
  _$AdminBackupListResponseCopyWithImpl(this._self, this._then);

  final AdminBackupListResponse _self;
  final $Res Function(AdminBackupListResponse) _then;

/// Create a copy of AdminBackupListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backups = null,}) {
  return _then(_self.copyWith(
backups: null == backups ? _self.backups : backups // ignore: cast_nullable_to_non_nullable
as List<AdminBackup>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBackupListResponse].
extension AdminBackupListResponsePatterns on AdminBackupListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBackupListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBackupListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBackupListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminBackupListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBackupListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBackupListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'backups')  List<AdminBackup> backups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBackupListResponse() when $default != null:
return $default(_that.backups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'backups')  List<AdminBackup> backups)  $default,) {final _that = this;
switch (_that) {
case _AdminBackupListResponse():
return $default(_that.backups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'backups')  List<AdminBackup> backups)?  $default,) {final _that = this;
switch (_that) {
case _AdminBackupListResponse() when $default != null:
return $default(_that.backups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminBackupListResponse implements AdminBackupListResponse {
  const _AdminBackupListResponse({@JsonKey(name: 'backups') final  List<AdminBackup> backups = const <AdminBackup>[]}): _backups = backups;
  factory _AdminBackupListResponse.fromJson(Map<String, dynamic> json) => _$AdminBackupListResponseFromJson(json);

 final  List<AdminBackup> _backups;
@override@JsonKey(name: 'backups') List<AdminBackup> get backups {
  if (_backups is EqualUnmodifiableListView) return _backups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_backups);
}


/// Create a copy of AdminBackupListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBackupListResponseCopyWith<_AdminBackupListResponse> get copyWith => __$AdminBackupListResponseCopyWithImpl<_AdminBackupListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminBackupListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBackupListResponse&&const DeepCollectionEquality().equals(other._backups, _backups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_backups));

@override
String toString() {
  return 'AdminBackupListResponse(backups: $backups)';
}


}

/// @nodoc
abstract mixin class _$AdminBackupListResponseCopyWith<$Res> implements $AdminBackupListResponseCopyWith<$Res> {
  factory _$AdminBackupListResponseCopyWith(_AdminBackupListResponse value, $Res Function(_AdminBackupListResponse) _then) = __$AdminBackupListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'backups') List<AdminBackup> backups
});




}
/// @nodoc
class __$AdminBackupListResponseCopyWithImpl<$Res>
    implements _$AdminBackupListResponseCopyWith<$Res> {
  __$AdminBackupListResponseCopyWithImpl(this._self, this._then);

  final _AdminBackupListResponse _self;
  final $Res Function(_AdminBackupListResponse) _then;

/// Create a copy of AdminBackupListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backups = null,}) {
  return _then(_AdminBackupListResponse(
backups: null == backups ? _self._backups : backups // ignore: cast_nullable_to_non_nullable
as List<AdminBackup>,
  ));
}


}

// dart format on
