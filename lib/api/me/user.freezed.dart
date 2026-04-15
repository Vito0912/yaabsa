// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

@JsonKey(name: "id") String get id;@JsonKey(name: "id") set id(String value);@JsonKey(name: "username") String get username;@JsonKey(name: "username") set username(String value);@JsonKey(name: "email") dynamic get email;@JsonKey(name: "email") set email(dynamic value);@JsonKey(name: "type") String get type;@JsonKey(name: "type") set type(String value);@JsonKey(name: "token") String? get token;@JsonKey(name: "token") set token(String? value);@JsonKey(name: "accessToken") String? get accessToken;@JsonKey(name: "accessToken") set accessToken(String? value);@JsonKey(name: "refreshToken") String? get refreshToken;@JsonKey(name: "refreshToken") set refreshToken(String? value);@JsonKey(name: "apiKey") String? get apiKey;@JsonKey(name: "apiKey") set apiKey(String? value);@JsonKey(name: "mediaProgress") List<MediaProgress>? get mediaProgress;@JsonKey(name: "mediaProgress") set mediaProgress(List<MediaProgress>? value);@JsonKey(name: "seriesHideFromContinueListening") List<String>? get seriesHideFromContinueListening;@JsonKey(name: "seriesHideFromContinueListening") set seriesHideFromContinueListening(List<String>? value);@JsonKey(name: "bookmarks") List<Bookmark>? get bookmarks;@JsonKey(name: "bookmarks") set bookmarks(List<Bookmark>? value);@JsonKey(name: "isActive") bool? get isActive;@JsonKey(name: "isActive") set isActive(bool? value);@JsonKey(name: "isLocked") bool? get isLocked;@JsonKey(name: "isLocked") set isLocked(bool? value);@JsonKey(name: "lastSeen") int? get lastSeen;@JsonKey(name: "lastSeen") set lastSeen(int? value);@JsonKey(name: "createdAt") int? get createdAt;@JsonKey(name: "createdAt") set createdAt(int? value);@JsonKey(name: "permissions") Permissions get permissions;@JsonKey(name: "permissions") set permissions(Permissions value);@JsonKey(name: "librariesAccessible") List<String>? get librariesAccessible;@JsonKey(name: "librariesAccessible") set librariesAccessible(List<String>? value);@JsonKey(name: "itemTagsSelected") List<String>? get itemTagsSelected;@JsonKey(name: "itemTagsSelected") set itemTagsSelected(List<String>? value);@JsonKey(name: "hasOpenIDLink") bool? get hasOpenIdLink;@JsonKey(name: "hasOpenIDLink") set hasOpenIdLink(bool? value); ServerSettings? get setting; set setting(ServerSettings? value); Server? get server; set server(Server? value);
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, type: $type, token: $token, accessToken: $accessToken, refreshToken: $refreshToken, apiKey: $apiKey, mediaProgress: $mediaProgress, seriesHideFromContinueListening: $seriesHideFromContinueListening, bookmarks: $bookmarks, isActive: $isActive, isLocked: $isLocked, lastSeen: $lastSeen, createdAt: $createdAt, permissions: $permissions, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected, hasOpenIdLink: $hasOpenIdLink, setting: $setting, server: $server)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "username") String username,@JsonKey(name: "email") dynamic email,@JsonKey(name: "type") String type,@JsonKey(name: "token") String? token,@JsonKey(name: "accessToken") String? accessToken,@JsonKey(name: "refreshToken") String? refreshToken,@JsonKey(name: "apiKey") String? apiKey,@JsonKey(name: "mediaProgress") List<MediaProgress>? mediaProgress,@JsonKey(name: "seriesHideFromContinueListening") List<String>? seriesHideFromContinueListening,@JsonKey(name: "bookmarks") List<Bookmark>? bookmarks,@JsonKey(name: "isActive") bool? isActive,@JsonKey(name: "isLocked") bool? isLocked,@JsonKey(name: "lastSeen") int? lastSeen,@JsonKey(name: "createdAt") int? createdAt,@JsonKey(name: "permissions") Permissions permissions,@JsonKey(name: "librariesAccessible") List<String>? librariesAccessible,@JsonKey(name: "itemTagsSelected") List<String>? itemTagsSelected,@JsonKey(name: "hasOpenIDLink") bool? hasOpenIdLink, ServerSettings? setting, Server? server
});


$PermissionsCopyWith<$Res> get permissions;$ServerSettingsCopyWith<$Res>? get setting;$ServerCopyWith<$Res>? get server;

}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? type = null,Object? token = freezed,Object? accessToken = freezed,Object? refreshToken = freezed,Object? apiKey = freezed,Object? mediaProgress = freezed,Object? seriesHideFromContinueListening = freezed,Object? bookmarks = freezed,Object? isActive = freezed,Object? isLocked = freezed,Object? lastSeen = freezed,Object? createdAt = freezed,Object? permissions = null,Object? librariesAccessible = freezed,Object? itemTagsSelected = freezed,Object? hasOpenIdLink = freezed,Object? setting = freezed,Object? server = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as dynamic,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,mediaProgress: freezed == mediaProgress ? _self.mediaProgress : mediaProgress // ignore: cast_nullable_to_non_nullable
as List<MediaProgress>?,seriesHideFromContinueListening: freezed == seriesHideFromContinueListening ? _self.seriesHideFromContinueListening : seriesHideFromContinueListening // ignore: cast_nullable_to_non_nullable
as List<String>?,bookmarks: freezed == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<Bookmark>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,isLocked: freezed == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Permissions,librariesAccessible: freezed == librariesAccessible ? _self.librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>?,itemTagsSelected: freezed == itemTagsSelected ? _self.itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>?,hasOpenIdLink: freezed == hasOpenIdLink ? _self.hasOpenIdLink : hasOpenIdLink // ignore: cast_nullable_to_non_nullable
as bool?,setting: freezed == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as ServerSettings?,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as Server?,
  ));
}
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionsCopyWith<$Res> get permissions {
  
  return $PermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res>? get setting {
    if (_self.setting == null) {
    return null;
  }

  return $ServerSettingsCopyWith<$Res>(_self.setting!, (value) {
    return _then(_self.copyWith(setting: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerCopyWith<$Res>? get server {
    if (_self.server == null) {
    return null;
  }

  return $ServerCopyWith<$Res>(_self.server!, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "username")  String username, @JsonKey(name: "email")  dynamic email, @JsonKey(name: "type")  String type, @JsonKey(name: "token")  String? token, @JsonKey(name: "accessToken")  String? accessToken, @JsonKey(name: "refreshToken")  String? refreshToken, @JsonKey(name: "apiKey")  String? apiKey, @JsonKey(name: "mediaProgress")  List<MediaProgress>? mediaProgress, @JsonKey(name: "seriesHideFromContinueListening")  List<String>? seriesHideFromContinueListening, @JsonKey(name: "bookmarks")  List<Bookmark>? bookmarks, @JsonKey(name: "isActive")  bool? isActive, @JsonKey(name: "isLocked")  bool? isLocked, @JsonKey(name: "lastSeen")  int? lastSeen, @JsonKey(name: "createdAt")  int? createdAt, @JsonKey(name: "permissions")  Permissions permissions, @JsonKey(name: "librariesAccessible")  List<String>? librariesAccessible, @JsonKey(name: "itemTagsSelected")  List<String>? itemTagsSelected, @JsonKey(name: "hasOpenIDLink")  bool? hasOpenIdLink,  ServerSettings? setting,  Server? server)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.type,_that.token,_that.accessToken,_that.refreshToken,_that.apiKey,_that.mediaProgress,_that.seriesHideFromContinueListening,_that.bookmarks,_that.isActive,_that.isLocked,_that.lastSeen,_that.createdAt,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected,_that.hasOpenIdLink,_that.setting,_that.server);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "username")  String username, @JsonKey(name: "email")  dynamic email, @JsonKey(name: "type")  String type, @JsonKey(name: "token")  String? token, @JsonKey(name: "accessToken")  String? accessToken, @JsonKey(name: "refreshToken")  String? refreshToken, @JsonKey(name: "apiKey")  String? apiKey, @JsonKey(name: "mediaProgress")  List<MediaProgress>? mediaProgress, @JsonKey(name: "seriesHideFromContinueListening")  List<String>? seriesHideFromContinueListening, @JsonKey(name: "bookmarks")  List<Bookmark>? bookmarks, @JsonKey(name: "isActive")  bool? isActive, @JsonKey(name: "isLocked")  bool? isLocked, @JsonKey(name: "lastSeen")  int? lastSeen, @JsonKey(name: "createdAt")  int? createdAt, @JsonKey(name: "permissions")  Permissions permissions, @JsonKey(name: "librariesAccessible")  List<String>? librariesAccessible, @JsonKey(name: "itemTagsSelected")  List<String>? itemTagsSelected, @JsonKey(name: "hasOpenIDLink")  bool? hasOpenIdLink,  ServerSettings? setting,  Server? server)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.username,_that.email,_that.type,_that.token,_that.accessToken,_that.refreshToken,_that.apiKey,_that.mediaProgress,_that.seriesHideFromContinueListening,_that.bookmarks,_that.isActive,_that.isLocked,_that.lastSeen,_that.createdAt,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected,_that.hasOpenIdLink,_that.setting,_that.server);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "username")  String username, @JsonKey(name: "email")  dynamic email, @JsonKey(name: "type")  String type, @JsonKey(name: "token")  String? token, @JsonKey(name: "accessToken")  String? accessToken, @JsonKey(name: "refreshToken")  String? refreshToken, @JsonKey(name: "apiKey")  String? apiKey, @JsonKey(name: "mediaProgress")  List<MediaProgress>? mediaProgress, @JsonKey(name: "seriesHideFromContinueListening")  List<String>? seriesHideFromContinueListening, @JsonKey(name: "bookmarks")  List<Bookmark>? bookmarks, @JsonKey(name: "isActive")  bool? isActive, @JsonKey(name: "isLocked")  bool? isLocked, @JsonKey(name: "lastSeen")  int? lastSeen, @JsonKey(name: "createdAt")  int? createdAt, @JsonKey(name: "permissions")  Permissions permissions, @JsonKey(name: "librariesAccessible")  List<String>? librariesAccessible, @JsonKey(name: "itemTagsSelected")  List<String>? itemTagsSelected, @JsonKey(name: "hasOpenIDLink")  bool? hasOpenIdLink,  ServerSettings? setting,  Server? server)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.username,_that.email,_that.type,_that.token,_that.accessToken,_that.refreshToken,_that.apiKey,_that.mediaProgress,_that.seriesHideFromContinueListening,_that.bookmarks,_that.isActive,_that.isLocked,_that.lastSeen,_that.createdAt,_that.permissions,_that.librariesAccessible,_that.itemTagsSelected,_that.hasOpenIdLink,_that.setting,_that.server);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _User extends User {
   _User({@JsonKey(name: "id") required this.id, @JsonKey(name: "username") required this.username, @JsonKey(name: "email") required this.email, @JsonKey(name: "type") required this.type, @JsonKey(name: "token") required this.token, @JsonKey(name: "accessToken") this.accessToken, @JsonKey(name: "refreshToken") this.refreshToken, @JsonKey(name: "apiKey") this.apiKey, @JsonKey(name: "mediaProgress") this.mediaProgress, @JsonKey(name: "seriesHideFromContinueListening") this.seriesHideFromContinueListening, @JsonKey(name: "bookmarks") this.bookmarks, @JsonKey(name: "isActive") this.isActive, @JsonKey(name: "isLocked") this.isLocked, @JsonKey(name: "lastSeen") this.lastSeen, @JsonKey(name: "createdAt") this.createdAt, @JsonKey(name: "permissions") required this.permissions, @JsonKey(name: "librariesAccessible") this.librariesAccessible, @JsonKey(name: "itemTagsSelected") this.itemTagsSelected, @JsonKey(name: "hasOpenIDLink") this.hasOpenIdLink, this.setting, this.server}): super._();
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override@JsonKey(name: "id")  String id;
@override@JsonKey(name: "username")  String username;
@override@JsonKey(name: "email")  dynamic email;
@override@JsonKey(name: "type")  String type;
@override@JsonKey(name: "token")  String? token;
@override@JsonKey(name: "accessToken")  String? accessToken;
@override@JsonKey(name: "refreshToken")  String? refreshToken;
@override@JsonKey(name: "apiKey")  String? apiKey;
@override@JsonKey(name: "mediaProgress")  List<MediaProgress>? mediaProgress;
@override@JsonKey(name: "seriesHideFromContinueListening")  List<String>? seriesHideFromContinueListening;
@override@JsonKey(name: "bookmarks")  List<Bookmark>? bookmarks;
@override@JsonKey(name: "isActive")  bool? isActive;
@override@JsonKey(name: "isLocked")  bool? isLocked;
@override@JsonKey(name: "lastSeen")  int? lastSeen;
@override@JsonKey(name: "createdAt")  int? createdAt;
@override@JsonKey(name: "permissions")  Permissions permissions;
@override@JsonKey(name: "librariesAccessible")  List<String>? librariesAccessible;
@override@JsonKey(name: "itemTagsSelected")  List<String>? itemTagsSelected;
@override@JsonKey(name: "hasOpenIDLink")  bool? hasOpenIdLink;
@override  ServerSettings? setting;
@override  Server? server;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}



@override
String toString() {
  return 'User(id: $id, username: $username, email: $email, type: $type, token: $token, accessToken: $accessToken, refreshToken: $refreshToken, apiKey: $apiKey, mediaProgress: $mediaProgress, seriesHideFromContinueListening: $seriesHideFromContinueListening, bookmarks: $bookmarks, isActive: $isActive, isLocked: $isLocked, lastSeen: $lastSeen, createdAt: $createdAt, permissions: $permissions, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected, hasOpenIdLink: $hasOpenIdLink, setting: $setting, server: $server)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "username") String username,@JsonKey(name: "email") dynamic email,@JsonKey(name: "type") String type,@JsonKey(name: "token") String? token,@JsonKey(name: "accessToken") String? accessToken,@JsonKey(name: "refreshToken") String? refreshToken,@JsonKey(name: "apiKey") String? apiKey,@JsonKey(name: "mediaProgress") List<MediaProgress>? mediaProgress,@JsonKey(name: "seriesHideFromContinueListening") List<String>? seriesHideFromContinueListening,@JsonKey(name: "bookmarks") List<Bookmark>? bookmarks,@JsonKey(name: "isActive") bool? isActive,@JsonKey(name: "isLocked") bool? isLocked,@JsonKey(name: "lastSeen") int? lastSeen,@JsonKey(name: "createdAt") int? createdAt,@JsonKey(name: "permissions") Permissions permissions,@JsonKey(name: "librariesAccessible") List<String>? librariesAccessible,@JsonKey(name: "itemTagsSelected") List<String>? itemTagsSelected,@JsonKey(name: "hasOpenIDLink") bool? hasOpenIdLink, ServerSettings? setting, Server? server
});


@override $PermissionsCopyWith<$Res> get permissions;@override $ServerSettingsCopyWith<$Res>? get setting;@override $ServerCopyWith<$Res>? get server;

}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? email = freezed,Object? type = null,Object? token = freezed,Object? accessToken = freezed,Object? refreshToken = freezed,Object? apiKey = freezed,Object? mediaProgress = freezed,Object? seriesHideFromContinueListening = freezed,Object? bookmarks = freezed,Object? isActive = freezed,Object? isLocked = freezed,Object? lastSeen = freezed,Object? createdAt = freezed,Object? permissions = null,Object? librariesAccessible = freezed,Object? itemTagsSelected = freezed,Object? hasOpenIdLink = freezed,Object? setting = freezed,Object? server = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as dynamic,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,accessToken: freezed == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String?,refreshToken: freezed == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String?,apiKey: freezed == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as String?,mediaProgress: freezed == mediaProgress ? _self.mediaProgress : mediaProgress // ignore: cast_nullable_to_non_nullable
as List<MediaProgress>?,seriesHideFromContinueListening: freezed == seriesHideFromContinueListening ? _self.seriesHideFromContinueListening : seriesHideFromContinueListening // ignore: cast_nullable_to_non_nullable
as List<String>?,bookmarks: freezed == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<Bookmark>?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,isLocked: freezed == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,permissions: null == permissions ? _self.permissions : permissions // ignore: cast_nullable_to_non_nullable
as Permissions,librariesAccessible: freezed == librariesAccessible ? _self.librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>?,itemTagsSelected: freezed == itemTagsSelected ? _self.itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>?,hasOpenIdLink: freezed == hasOpenIdLink ? _self.hasOpenIdLink : hasOpenIdLink // ignore: cast_nullable_to_non_nullable
as bool?,setting: freezed == setting ? _self.setting : setting // ignore: cast_nullable_to_non_nullable
as ServerSettings?,server: freezed == server ? _self.server : server // ignore: cast_nullable_to_non_nullable
as Server?,
  ));
}

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PermissionsCopyWith<$Res> get permissions {
  
  return $PermissionsCopyWith<$Res>(_self.permissions, (value) {
    return _then(_self.copyWith(permissions: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res>? get setting {
    if (_self.setting == null) {
    return null;
  }

  return $ServerSettingsCopyWith<$Res>(_self.setting!, (value) {
    return _then(_self.copyWith(setting: value));
  });
}/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerCopyWith<$Res>? get server {
    if (_self.server == null) {
    return null;
  }

  return $ServerCopyWith<$Res>(_self.server!, (value) {
    return _then(_self.copyWith(server: value));
  });
}
}

// dart format on
