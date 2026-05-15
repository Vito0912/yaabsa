// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user_upsert_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUserUpsertRequest {

@JsonKey(name: 'username') String get username;@JsonKey(name: 'password') String? get password;@JsonKey(name: 'email') String? get email;@JsonKey(name: 'type') String get type;@JsonKey(name: 'isActive') bool get isActive;@JsonKey(name: 'permissions') AdminUserPermissions get permissions;@JsonKey(name: 'librariesAccessible') List<String> get librariesAccessible;@JsonKey(name: 'itemTagsSelected') List<String> get itemTagsSelected;
/// Create a copy of AdminUserUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserUpsertRequestCopyWith<AdminUserUpsertRequest> get copyWith => _$AdminUserUpsertRequestCopyWithImpl<AdminUserUpsertRequest>(this as AdminUserUpsertRequest, _$identity);

  /// Serializes this AdminUserUpsertRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserUpsertRequest&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other.librariesAccessible, librariesAccessible)&&const DeepCollectionEquality().equals(other.itemTagsSelected, itemTagsSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,email,type,isActive,permissions,const DeepCollectionEquality().hash(librariesAccessible),const DeepCollectionEquality().hash(itemTagsSelected));

@override
String toString() {
  return 'AdminUserUpsertRequest(username: $username, password: $password, email: $email, type: $type, isActive: $isActive, permissions: $permissions, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected)';
}


}

/// @nodoc
abstract mixin class $AdminUserUpsertRequestCopyWith<$Res>  {
  factory $AdminUserUpsertRequestCopyWith(AdminUserUpsertRequest value, $Res Function(AdminUserUpsertRequest) _then) = _$AdminUserUpsertRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'username') String username,@JsonKey(name: 'password') String? password,@JsonKey(name: 'email') String? email,@JsonKey(name: 'type') String type,@JsonKey(name: 'isActive') bool isActive,@JsonKey(name: 'permissions') AdminUserPermissions permissions,@JsonKey(name: 'librariesAccessible') List<String> librariesAccessible,@JsonKey(name: 'itemTagsSelected') List<String> itemTagsSelected
});


$AdminUserPermissionsCopyWith<$Res> get permissions;

}
/// @nodoc
class _$AdminUserUpsertRequestCopyWithImpl<$Res>
    implements $AdminUserUpsertRequestCopyWith<$Res> {
  _$AdminUserUpsertRequestCopyWithImpl(this._self, this._then);

  final AdminUserUpsertRequest _self;
  final $Res Function(AdminUserUpsertRequest) _then;

/// Create a copy of AdminUserUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? username = null,Object? password = freezed,Object? email = freezed,Object? type = null,Object? isActive = null,Object? permissions = null,Object? librariesAccessible = null,Object? itemTagsSelected = null,}) {
  return _then(_self.copyWith(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AdminUserPermissions,librariesAccessible: null == librariesAccessible ? _self.librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>,itemTagsSelected: null == itemTagsSelected ? _self.itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of AdminUserUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminUserPermissionsCopyWith<$Res> get permissions {
  
  return $AdminUserPermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminUserUpsertRequest].
extension AdminUserUpsertRequestPatterns on AdminUserUpsertRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserUpsertRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserUpsertRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserUpsertRequest value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserUpsertRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserUpsertRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserUpsertRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'username')  String username, @JsonKey(name: 'password')  String? password, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'type')  String type, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserUpsertRequest() when $default != null:
return $default(_that.username,_that.password,_that.email,_that.type,_that.isActive,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'username')  String username, @JsonKey(name: 'password')  String? password, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'type')  String type, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)  $default,) {final _that = this;
switch (_that) {
case _AdminUserUpsertRequest():
return $default(_that.username,_that.password,_that.email,_that.type,_that.isActive,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'username')  String username, @JsonKey(name: 'password')  String? password, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'type')  String type, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserUpsertRequest() when $default != null:
return $default(_that.username,_that.password,_that.email,_that.type,_that.isActive,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserUpsertRequest implements AdminUserUpsertRequest {
  const _AdminUserUpsertRequest({@JsonKey(name: 'username') required this.username, @JsonKey(name: 'password') this.password, @JsonKey(name: 'email') this.email, @JsonKey(name: 'type') this.type = 'user', @JsonKey(name: 'isActive') this.isActive = true, @JsonKey(name: 'permissions') this.permissions = const AdminUserPermissions(), @JsonKey(name: 'librariesAccessible') final  List<String> librariesAccessible = const <String>[], @JsonKey(name: 'itemTagsSelected') final  List<String> itemTagsSelected = const <String>[]}): _librariesAccessible = librariesAccessible,_itemTagsSelected = itemTagsSelected;
  factory _AdminUserUpsertRequest.fromJson(Map<String, dynamic> json) => _$AdminUserUpsertRequestFromJson(json);

@override@JsonKey(name: 'username') final  String username;
@override@JsonKey(name: 'password') final  String? password;
@override@JsonKey(name: 'email') final  String? email;
@override@JsonKey(name: 'type') final  String type;
@override@JsonKey(name: 'isActive') final  bool isActive;
@override@JsonKey(name: 'permissions') final  AdminUserPermissions permissions;
 final  List<String> _librariesAccessible;
@override@JsonKey(name: 'librariesAccessible') List<String> get librariesAccessible {
  if (_librariesAccessible is EqualUnmodifiableListView) return _librariesAccessible;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_librariesAccessible);
}

 final  List<String> _itemTagsSelected;
@override@JsonKey(name: 'itemTagsSelected') List<String> get itemTagsSelected {
  if (_itemTagsSelected is EqualUnmodifiableListView) return _itemTagsSelected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemTagsSelected);
}


/// Create a copy of AdminUserUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserUpsertRequestCopyWith<_AdminUserUpsertRequest> get copyWith => __$AdminUserUpsertRequestCopyWithImpl<_AdminUserUpsertRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserUpsertRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserUpsertRequest&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other._librariesAccessible, _librariesAccessible)&&const DeepCollectionEquality().equals(other._itemTagsSelected, _itemTagsSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,username,password,email,type,isActive,permissions,const DeepCollectionEquality().hash(_librariesAccessible),const DeepCollectionEquality().hash(_itemTagsSelected));

@override
String toString() {
  return 'AdminUserUpsertRequest(username: $username, password: $password, email: $email, type: $type, isActive: $isActive, permissions: $permissions, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected)';
}


}

/// @nodoc
abstract mixin class _$AdminUserUpsertRequestCopyWith<$Res> implements $AdminUserUpsertRequestCopyWith<$Res> {
  factory _$AdminUserUpsertRequestCopyWith(_AdminUserUpsertRequest value, $Res Function(_AdminUserUpsertRequest) _then) = __$AdminUserUpsertRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'username') String username,@JsonKey(name: 'password') String? password,@JsonKey(name: 'email') String? email,@JsonKey(name: 'type') String type,@JsonKey(name: 'isActive') bool isActive,@JsonKey(name: 'permissions') AdminUserPermissions permissions,@JsonKey(name: 'librariesAccessible') List<String> librariesAccessible,@JsonKey(name: 'itemTagsSelected') List<String> itemTagsSelected
});


@override $AdminUserPermissionsCopyWith<$Res> get permissions;

}
/// @nodoc
class __$AdminUserUpsertRequestCopyWithImpl<$Res>
    implements _$AdminUserUpsertRequestCopyWith<$Res> {
  __$AdminUserUpsertRequestCopyWithImpl(this._self, this._then);

  final _AdminUserUpsertRequest _self;
  final $Res Function(_AdminUserUpsertRequest) _then;

/// Create a copy of AdminUserUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? username = null,Object? password = freezed,Object? email = freezed,Object? type = null,Object? isActive = null,Object? permissions = null,Object? librariesAccessible = null,Object? itemTagsSelected = null,}) {
  return _then(_AdminUserUpsertRequest(
username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AdminUserPermissions,librariesAccessible: null == librariesAccessible ? _self._librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>,itemTagsSelected: null == itemTagsSelected ? _self._itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of AdminUserUpsertRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminUserPermissionsCopyWith<$Res> get permissions {
  
  return $AdminUserPermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}

// dart format on
