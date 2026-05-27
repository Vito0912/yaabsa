// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_api_key.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminApiKey {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'expiresAt') DateTime? get expiresAt;@JsonKey(name: 'lastUsedAt') DateTime? get lastUsedAt;@JsonKey(name: 'isActive') bool get isActive;@JsonKey(name: 'permissions') AdminUserPermissions get permissions;@JsonKey(name: 'createdAt') DateTime? get createdAt;@JsonKey(name: 'updatedAt') DateTime? get updatedAt;@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'createdByUserId') String? get createdByUserId;@JsonKey(name: 'user') SessionUserSummary? get user;@JsonKey(name: 'createdByUser') SessionUserSummary? get createdByUser;@JsonKey(name: 'apiKey') String? get apiKey;
/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminApiKeyCopyWith<AdminApiKey> get copyWith => _$AdminApiKeyCopyWithImpl<AdminApiKey>(this as AdminApiKey, _$identity);

  /// Serializes this AdminApiKey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminApiKey&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdByUser, createdByUser) || other.createdByUser == createdByUser)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,expiresAt,lastUsedAt,isActive,permissions,createdAt,updatedAt,userId,createdByUserId,user,createdByUser,apiKey);

@override
String toString() {
  return 'AdminApiKey(id: $id, name: $name, description: $description, expiresAt: $expiresAt, lastUsedAt: $lastUsedAt, isActive: $isActive, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, createdByUserId: $createdByUserId, user: $user, createdByUser: $createdByUser, apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class $AdminApiKeyCopyWith<$Res>  {
  factory $AdminApiKeyCopyWith(AdminApiKey value, $Res Function(AdminApiKey) _then) = _$AdminApiKeyCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'lastUsedAt') DateTime? lastUsedAt,@JsonKey(name: 'isActive') bool isActive,@JsonKey(name: 'permissions') AdminUserPermissions permissions,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'updatedAt') DateTime? updatedAt,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'createdByUserId') String? createdByUserId,@JsonKey(name: 'user') SessionUserSummary? user,@JsonKey(name: 'createdByUser') SessionUserSummary? createdByUser,@JsonKey(name: 'apiKey') String? apiKey
});


$AdminUserPermissionsCopyWith<$Res> get permissions;$SessionUserSummaryCopyWith<$Res>? get user;$SessionUserSummaryCopyWith<$Res>? get createdByUser;

}
/// @nodoc
class _$AdminApiKeyCopyWithImpl<$Res>
    implements $AdminApiKeyCopyWith<$Res> {
  _$AdminApiKeyCopyWithImpl(this._self, this._then);

  final AdminApiKey _self;
  final $Res Function(AdminApiKey) _then;

/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? expiresAt = freezed,Object? lastUsedAt = freezed,Object? isActive = null,Object? permissions = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? createdByUserId = freezed,Object? user = freezed,Object? createdByUser = freezed,Object? apiKey = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUsedAt: freezed == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AdminUserPermissions,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,createdByUser: freezed == createdByUser ? _self.createdByUser : createdByUser // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminUserPermissionsCopyWith<$Res> get permissions {
  
  return $AdminUserPermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $SessionUserSummaryCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<$Res>? get createdByUser {
    if (_self.createdByUser == null) {
    return null;
  }

  return $SessionUserSummaryCopyWith<$Res>(_self.createdByUser!, (value) {
    return _then(_self.copyWith(createdByUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminApiKey].
extension AdminApiKeyPatterns on AdminApiKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminApiKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminApiKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminApiKey value)  $default,){
final _that = this;
switch (_that) {
case _AdminApiKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminApiKey value)?  $default,){
final _that = this;
switch (_that) {
case _AdminApiKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'expiresAt')  DateTime? expiresAt, @JsonKey(name: 'lastUsedAt')  DateTime? lastUsedAt, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'createdAt')  DateTime? createdAt, @JsonKey(name: 'updatedAt')  DateTime? updatedAt, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'createdByUserId')  String? createdByUserId, @JsonKey(name: 'user')  SessionUserSummary? user, @JsonKey(name: 'createdByUser')  SessionUserSummary? createdByUser, @JsonKey(name: 'apiKey')  String? apiKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminApiKey() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.expiresAt,_that.lastUsedAt,_that.isActive,_that.permissions,_that.createdAt,_that.updatedAt,_that.userId,_that.createdByUserId,_that.user,_that.createdByUser,_that.apiKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'expiresAt')  DateTime? expiresAt, @JsonKey(name: 'lastUsedAt')  DateTime? lastUsedAt, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'createdAt')  DateTime? createdAt, @JsonKey(name: 'updatedAt')  DateTime? updatedAt, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'createdByUserId')  String? createdByUserId, @JsonKey(name: 'user')  SessionUserSummary? user, @JsonKey(name: 'createdByUser')  SessionUserSummary? createdByUser, @JsonKey(name: 'apiKey')  String? apiKey)  $default,) {final _that = this;
switch (_that) {
case _AdminApiKey():
return $default(_that.id,_that.name,_that.description,_that.expiresAt,_that.lastUsedAt,_that.isActive,_that.permissions,_that.createdAt,_that.updatedAt,_that.userId,_that.createdByUserId,_that.user,_that.createdByUser,_that.apiKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'expiresAt')  DateTime? expiresAt, @JsonKey(name: 'lastUsedAt')  DateTime? lastUsedAt, @JsonKey(name: 'isActive')  bool isActive, @JsonKey(name: 'permissions')  AdminUserPermissions permissions, @JsonKey(name: 'createdAt')  DateTime? createdAt, @JsonKey(name: 'updatedAt')  DateTime? updatedAt, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'createdByUserId')  String? createdByUserId, @JsonKey(name: 'user')  SessionUserSummary? user, @JsonKey(name: 'createdByUser')  SessionUserSummary? createdByUser, @JsonKey(name: 'apiKey')  String? apiKey)?  $default,) {final _that = this;
switch (_that) {
case _AdminApiKey() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.expiresAt,_that.lastUsedAt,_that.isActive,_that.permissions,_that.createdAt,_that.updatedAt,_that.userId,_that.createdByUserId,_that.user,_that.createdByUser,_that.apiKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminApiKey extends AdminApiKey {
  const _AdminApiKey({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'description') this.description, @JsonKey(name: 'expiresAt') this.expiresAt, @JsonKey(name: 'lastUsedAt') this.lastUsedAt, @JsonKey(name: 'isActive') this.isActive = false, @JsonKey(name: 'permissions') this.permissions = const AdminUserPermissions(), @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'updatedAt') this.updatedAt, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'createdByUserId') this.createdByUserId, @JsonKey(name: 'user') this.user, @JsonKey(name: 'createdByUser') this.createdByUser, @JsonKey(name: 'apiKey') this.apiKey}): super._();
  factory _AdminApiKey.fromJson(Map<String, dynamic> json) => _$AdminApiKeyFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'expiresAt') final  DateTime? expiresAt;
@override@JsonKey(name: 'lastUsedAt') final  DateTime? lastUsedAt;
@override@JsonKey(name: 'isActive') final  bool isActive;
@override@JsonKey(name: 'permissions') final  AdminUserPermissions permissions;
@override@JsonKey(name: 'createdAt') final  DateTime? createdAt;
@override@JsonKey(name: 'updatedAt') final  DateTime? updatedAt;
@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'createdByUserId') final  String? createdByUserId;
@override@JsonKey(name: 'user') final  SessionUserSummary? user;
@override@JsonKey(name: 'createdByUser') final  SessionUserSummary? createdByUser;
@override@JsonKey(name: 'apiKey') final  String? apiKey;

/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminApiKeyCopyWith<_AdminApiKey> get copyWith => __$AdminApiKeyCopyWithImpl<_AdminApiKey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminApiKeyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminApiKey&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.lastUsedAt, lastUsedAt) || other.lastUsedAt == lastUsedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.permissions, permissions) || other.permissions == permissions)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.user, user) || other.user == user)&&(identical(other.createdByUser, createdByUser) || other.createdByUser == createdByUser)&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,expiresAt,lastUsedAt,isActive,permissions,createdAt,updatedAt,userId,createdByUserId,user,createdByUser,apiKey);

@override
String toString() {
  return 'AdminApiKey(id: $id, name: $name, description: $description, expiresAt: $expiresAt, lastUsedAt: $lastUsedAt, isActive: $isActive, permissions: $permissions, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, createdByUserId: $createdByUserId, user: $user, createdByUser: $createdByUser, apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class _$AdminApiKeyCopyWith<$Res> implements $AdminApiKeyCopyWith<$Res> {
  factory _$AdminApiKeyCopyWith(_AdminApiKey value, $Res Function(_AdminApiKey) _then) = __$AdminApiKeyCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'expiresAt') DateTime? expiresAt,@JsonKey(name: 'lastUsedAt') DateTime? lastUsedAt,@JsonKey(name: 'isActive') bool isActive,@JsonKey(name: 'permissions') AdminUserPermissions permissions,@JsonKey(name: 'createdAt') DateTime? createdAt,@JsonKey(name: 'updatedAt') DateTime? updatedAt,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'createdByUserId') String? createdByUserId,@JsonKey(name: 'user') SessionUserSummary? user,@JsonKey(name: 'createdByUser') SessionUserSummary? createdByUser,@JsonKey(name: 'apiKey') String? apiKey
});


@override $AdminUserPermissionsCopyWith<$Res> get permissions;@override $SessionUserSummaryCopyWith<$Res>? get user;@override $SessionUserSummaryCopyWith<$Res>? get createdByUser;

}
/// @nodoc
class __$AdminApiKeyCopyWithImpl<$Res>
    implements _$AdminApiKeyCopyWith<$Res> {
  __$AdminApiKeyCopyWithImpl(this._self, this._then);

  final _AdminApiKey _self;
  final $Res Function(_AdminApiKey) _then;

/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? expiresAt = freezed,Object? lastUsedAt = freezed,Object? isActive = null,Object? permissions = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? userId = null,Object? createdByUserId = freezed,Object? user = freezed,Object? createdByUser = freezed,Object? apiKey = freezed,}) {
  return _then(_AdminApiKey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUsedAt: freezed == lastUsedAt ? _self.lastUsedAt : lastUsedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as AdminUserPermissions,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,createdByUser: freezed == createdByUser ? _self.createdByUser : createdByUser // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminUserPermissionsCopyWith<$Res> get permissions {
  
  return $AdminUserPermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $SessionUserSummaryCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of AdminApiKey
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<$Res>? get createdByUser {
    if (_self.createdByUser == null) {
    return null;
  }

  return $SessionUserSummaryCopyWith<$Res>(_self.createdByUser!, (value) {
    return _then(_self.copyWith(createdByUser: value));
  });
}
}

// dart format on
