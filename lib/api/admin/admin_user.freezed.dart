// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUser {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'username') String get username;@JsonKey(name: 'email') String? get email;@JsonKey(name: 'type') String get type;@JsonKey(name: 'isActive') bool get isActive;@JsonKey(name: 'isLocked') bool? get isLocked;@JsonKey(name: 'lastSeen') int? get lastSeen;@JsonKey(name: 'createdAt') int? get createdAt;@JsonKey(name: 'hasOpenIDLink') bool? get hasOpenIdLink;@JsonKey(name: 'permissions') AdminUserPermissions get permissions;@JsonKey(name: 'librariesAccessible') List<String> get librariesAccessible;@JsonKey(name: 'itemTagsSelected') List<String> get itemTagsSelected;
/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserCopyWith<AdminUser> get copyWith => _$AdminUserCopyWithImpl<AdminUser>(this as AdminUser, _$identity);

  /// Serializes this AdminUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hasOpenIdLink, hasOpenIdLink) || other.hasOpenIdLink == hasOpenIdLink)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other.librariesAccessible, librariesAccessible)&&const DeepCollectionEquality().equals(other.itemTagsSelected, itemTagsSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,type,isActive,isLocked,lastSeen,createdAt,hasOpenIdLink,permissions,const DeepCollectionEquality().hash(librariesAccessible),const DeepCollectionEquality().hash(itemTagsSelected));

@override
String toString() {
  return 'AdminUser(id: $id, username: $username, email: $email, type: $type, isActive: $isActive, isLocked: $isLocked, lastSeen: $lastSeen, createdAt: $createdAt, hasOpenIdLink: $hasOpenIdLink, permissions: $permissions, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected)';
}


}

/// @nodoc
abstract mixin class $AdminUserCopyWith<$Res>  {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) _then) = _$AdminUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'username') String username,@JsonKey(name: 'email') String? email,@JsonKey(name: 'type') String type,@JsonKey(name: 'isActive') bool isActive,@JsonKey(name: 'isLocked') bool? isLocked,@JsonKey(name: 'lastSeen') int? lastSeen,@JsonKey(name: 'createdAt') int? createdAt,@JsonKey(name: 'hasOpenIDLink') bool? hasOpenIdLink,@JsonKey(name: 'permissions') AdminUserPermissions permissions,@JsonKey(name: 'librariesAccessible') List<String> librariesAccessible,@JsonKey(name: 'itemTagsSelected') List<String> itemTagsSelected
});


$AdminUserPermissionsCopyWith<$Res> get permissions;

}
/// @nodoc
class _$AdminUserCopyWithImpl<$Res>
    implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._self, this._then);

  final AdminUser _self;
  final $Res Function(AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? type = null,Object? isActive = null,Object? isLocked = freezed,Object? lastSeen = freezed,Object? createdAt = freezed,Object? hasOpenIdLink = freezed,Object? permissions = null,Object? librariesAccessible = null,Object? itemTagsSelected = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isLocked: freezed == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,hasOpenIdLink: freezed == hasOpenIdLink ? _self.hasOpenIdLink : hasOpenIdLink // ignore: cast_nullable_to_non_nullable
as bool?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AdminUserPermissions,librariesAccessible: null == librariesAccessible ? _self.librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>,itemTagsSelected: null == itemTagsSelected ? _self.itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminUserPermissionsCopyWith<$Res> get permissions {
  
  return $AdminUserPermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminUser].
extension AdminUserPatterns on AdminUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUser value)  $default,){
final _that = this;
switch (_that) {
case _AdminUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUser value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String username, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'type')  String type, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'isLocked')  bool? isLocked, @JsonKey(name: 'lastSeen')  int? lastSeen, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'hasOpenIDLink')  bool? hasOpenIdLink, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.type,_that.isActive,_that.isLocked,_that.lastSeen,_that.createdAt,_that.hasOpenIdLink,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String username, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'type')  String type, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'isLocked')  bool? isLocked, @JsonKey(name: 'lastSeen')  int? lastSeen, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'hasOpenIDLink')  bool? hasOpenIdLink, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)  $default,) {final _that = this;
switch (_that) {
case _AdminUser():
return $default(_that.id,_that.username,_that.email,_that.type,_that.isActive,_that.isLocked,_that.lastSeen,_that.createdAt,_that.hasOpenIdLink,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String username, @JsonKey(name: 'email')  String? email, @JsonKey(name: 'type')  String type, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'isLocked')  bool? isLocked, @JsonKey(name: 'lastSeen')  int? lastSeen, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'hasOpenIDLink')  bool? hasOpenIdLink, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)?  $default,) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.type,_that.isActive,_that.isLocked,_that.lastSeen,_that.createdAt,_that.hasOpenIdLink,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUser extends AdminUser {
  const _AdminUser({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'username') required this.username, @JsonKey(name: 'email') this.email, @JsonKey(name: 'type') this.type = 'user', @JsonKey(name: 'isActive') this.isActive = true, @JsonKey(name: 'isLocked') this.isLocked, @JsonKey(name: 'lastSeen') this.lastSeen, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'hasOpenIDLink') this.hasOpenIdLink, @JsonKey(name: 'permissions') this.permissions = const AdminUserPermissions(), @JsonKey(name: 'librariesAccessible') final  List<String> librariesAccessible = const <String>[], @JsonKey(name: 'itemTagsSelected') final  List<String> itemTagsSelected = const <String>[]}): _librariesAccessible = librariesAccessible,_itemTagsSelected = itemTagsSelected,super._();
  factory _AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'username') final  String username;
@override@JsonKey(name: 'email') final  String? email;
@override@JsonKey(name: 'type') final  String type;
@override@JsonKey(name: 'isActive') final  bool isActive;
@override@JsonKey(name: 'isLocked') final  bool? isLocked;
@override@JsonKey(name: 'lastSeen') final  int? lastSeen;
@override@JsonKey(name: 'createdAt') final  int? createdAt;
@override@JsonKey(name: 'hasOpenIDLink') final  bool? hasOpenIdLink;
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


/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserCopyWith<_AdminUser> get copyWith => __$AdminUserCopyWithImpl<_AdminUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUser&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.email, email) || other.email == email)&&(identical(other.type, type) || other.type == type)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.hasOpenIdLink, hasOpenIdLink) || other.hasOpenIdLink == hasOpenIdLink)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&const DeepCollectionEquality().equals(other._librariesAccessible, _librariesAccessible)&&const DeepCollectionEquality().equals(other._itemTagsSelected, _itemTagsSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,email,type,isActive,isLocked,lastSeen,createdAt,hasOpenIdLink,permissions,const DeepCollectionEquality().hash(_librariesAccessible),const DeepCollectionEquality().hash(_itemTagsSelected));

@override
String toString() {
  return 'AdminUser(id: $id, username: $username, email: $email, type: $type, isActive: $isActive, isLocked: $isLocked, lastSeen: $lastSeen, createdAt: $createdAt, hasOpenIdLink: $hasOpenIdLink, permissions: $permissions, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected)';
}


}

/// @nodoc
abstract mixin class _$AdminUserCopyWith<$Res> implements $AdminUserCopyWith<$Res> {
  factory _$AdminUserCopyWith(_AdminUser value, $Res Function(_AdminUser) _then) = __$AdminUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'username') String username,@JsonKey(name: 'email') String? email,@JsonKey(name: 'type') String type,@JsonKey(name: 'isActive') bool isActive,@JsonKey(name: 'isLocked') bool? isLocked,@JsonKey(name: 'lastSeen') int? lastSeen,@JsonKey(name: 'createdAt') int? createdAt,@JsonKey(name: 'hasOpenIDLink') bool? hasOpenIdLink,@JsonKey(name: 'permissions') AdminUserPermissions permissions,@JsonKey(name: 'librariesAccessible') List<String> librariesAccessible,@JsonKey(name: 'itemTagsSelected') List<String> itemTagsSelected
});


@override $AdminUserPermissionsCopyWith<$Res> get permissions;

}
/// @nodoc
class __$AdminUserCopyWithImpl<$Res>
    implements _$AdminUserCopyWith<$Res> {
  __$AdminUserCopyWithImpl(this._self, this._then);

  final _AdminUser _self;
  final $Res Function(_AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? type = null,Object? isActive = null,Object? isLocked = freezed,Object? lastSeen = freezed,Object? createdAt = freezed,Object? hasOpenIdLink = freezed,Object? permissions = null,Object? librariesAccessible = null,Object? itemTagsSelected = null,}) {
  return _then(_AdminUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isLocked: freezed == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,hasOpenIdLink: freezed == hasOpenIdLink ? _self.hasOpenIdLink : hasOpenIdLink // ignore: cast_nullable_to_non_nullable
as bool?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AdminUserPermissions,librariesAccessible: null == librariesAccessible ? _self._librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>,itemTagsSelected: null == itemTagsSelected ? _self._itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of AdminUser
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
