// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_users_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminUsersResponse {

 List<SessionUserSummary> get users;
/// Create a copy of AdminUsersResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUsersResponseCopyWith<AdminUsersResponse> get copyWith => _$AdminUsersResponseCopyWithImpl<AdminUsersResponse>(this as AdminUsersResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUsersResponse&&const DeepCollectionEquality().equals(other.users, users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'AdminUsersResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class $AdminUsersResponseCopyWith<$Res>  {
  factory $AdminUsersResponseCopyWith(AdminUsersResponse value, $Res Function(AdminUsersResponse) _then) = _$AdminUsersResponseCopyWithImpl;
@useResult
$Res call({
 List<SessionUserSummary> users
});




}
/// @nodoc
class _$AdminUsersResponseCopyWithImpl<$Res>
    implements $AdminUsersResponseCopyWith<$Res> {
  _$AdminUsersResponseCopyWithImpl(this._self, this._then);

  final AdminUsersResponse _self;
  final $Res Function(AdminUsersResponse) _then;

/// Create a copy of AdminUsersResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? users = null,}) {
  return _then(_self.copyWith(
users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<SessionUserSummary>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUsersResponse].
extension AdminUsersResponsePatterns on AdminUsersResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUsersResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUsersResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUsersResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminUsersResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUsersResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUsersResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SessionUserSummary> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUsersResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SessionUserSummary> users)  $default,) {final _that = this;
switch (_that) {
case _AdminUsersResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SessionUserSummary> users)?  $default,) {final _that = this;
switch (_that) {
case _AdminUsersResponse() when $default != null:
return $default(_that.users);case _:
  return null;

}
}

}

/// @nodoc


class _AdminUsersResponse implements AdminUsersResponse {
  const _AdminUsersResponse({final  List<SessionUserSummary> users = const <SessionUserSummary>[]}): _users = users;
  

 final  List<SessionUserSummary> _users;
@override@JsonKey() List<SessionUserSummary> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of AdminUsersResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUsersResponseCopyWith<_AdminUsersResponse> get copyWith => __$AdminUsersResponseCopyWithImpl<_AdminUsersResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUsersResponse&&const DeepCollectionEquality().equals(other._users, _users));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'AdminUsersResponse(users: $users)';
}


}

/// @nodoc
abstract mixin class _$AdminUsersResponseCopyWith<$Res> implements $AdminUsersResponseCopyWith<$Res> {
  factory _$AdminUsersResponseCopyWith(_AdminUsersResponse value, $Res Function(_AdminUsersResponse) _then) = __$AdminUsersResponseCopyWithImpl;
@override @useResult
$Res call({
 List<SessionUserSummary> users
});




}
/// @nodoc
class __$AdminUsersResponseCopyWithImpl<$Res>
    implements _$AdminUsersResponseCopyWith<$Res> {
  __$AdminUsersResponseCopyWithImpl(this._self, this._then);

  final _AdminUsersResponse _self;
  final $Res Function(_AdminUsersResponse) _then;

/// Create a copy of AdminUsersResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? users = null,}) {
  return _then(_AdminUsersResponse(
users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<SessionUserSummary>,
  ));
}


}

// dart format on
