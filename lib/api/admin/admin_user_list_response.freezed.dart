// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUserListResponse {

@JsonKey(name: 'users') List<AdminUser> get users;
/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserListResponseCopyWith<AdminUserListResponse> get copyWith => _$AdminUserListResponseCopyWithImpl<AdminUserListResponse>(this as AdminUserListResponse, _$identity);

  /// Serializes this AdminUserListResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserListResponse&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'AdminUserListResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class $AdminUserListResponseCopyWith<$Res>  {
  factory $AdminUserListResponseCopyWith(AdminUserListResponse value, $Res Function(AdminUserListResponse) _then) = _$AdminUserListResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'users') List<AdminUser> users
});




}
/// @nodoc
class _$AdminUserListResponseCopyWithImpl<$Res>
    implements $AdminUserListResponseCopyWith<$Res> {
  _$AdminUserListResponseCopyWithImpl(this._self, this._then);

  final AdminUserListResponse _self;
  final $Res Function(AdminUserListResponse) _then;

/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUser>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserListResponse].
extension AdminUserListResponsePatterns on AdminUserListResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserListResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserListResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserListResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserListResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'users')  List<AdminUser> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
return $default(_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'users')  List<AdminUser> users)  $default,) {final _that = this;
switch (_that) {
case _AdminUserListResponse():
return $default(_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'users')  List<AdminUser> users)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserListResponse() when $default != null:
return $default(_that.users);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserListResponse implements AdminUserListResponse {
  const _AdminUserListResponse({@JsonKey(name: 'users') final  List<AdminUser> users = const <AdminUser>[]}): _users = users;
  factory _AdminUserListResponse.fromJson(Map<String, dynamic> json) => _$AdminUserListResponseFromJson(json);

 final  List<AdminUser> _users;
@override@JsonKey(name: 'users') List<AdminUser> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserListResponseCopyWith<_AdminUserListResponse> get copyWith => __$AdminUserListResponseCopyWithImpl<_AdminUserListResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserListResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserListResponse&&const DeepCollectionEquality().equals(other._users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'AdminUserListResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class _$AdminUserListResponseCopyWith<$Res> implements $AdminUserListResponseCopyWith<$Res> {
  factory _$AdminUserListResponseCopyWith(_AdminUserListResponse value, $Res Function(_AdminUserListResponse) _then) = __$AdminUserListResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'users') List<AdminUser> users
});




}
/// @nodoc
class __$AdminUserListResponseCopyWithImpl<$Res>
    implements _$AdminUserListResponseCopyWith<$Res> {
  __$AdminUserListResponseCopyWithImpl(this._self, this._then);

  final _AdminUserListResponse _self;
  final $Res Function(_AdminUserListResponse) _then;

/// Create a copy of AdminUserListResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,}) {
  return _then(_AdminUserListResponse(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<AdminUser>,
  ));
}


}

// dart format on
