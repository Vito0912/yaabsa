// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Login {

@JsonKey(name: "user") User get user;@JsonKey(name: "userDefaultLibraryId") String get userDefaultLibraryId;@JsonKey(name: "serverSettings") ServerSettings get serverSettings;@JsonKey(name: "Source") String get source;
/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginCopyWith<Login> get copyWith => _$LoginCopyWithImpl<Login>(this as Login, _$identity);

  /// Serializes this Login to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Login&&(identical(other.user, user) || other.user == user)&&(identical(other.userDefaultLibraryId, userDefaultLibraryId) || other.userDefaultLibraryId == userDefaultLibraryId)&&(identical(other.serverSettings, serverSettings) || other.serverSettings == serverSettings)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,userDefaultLibraryId,serverSettings,source);

@override
String toString() {
  return 'Login(user: $user, userDefaultLibraryId: $userDefaultLibraryId, serverSettings: $serverSettings, source: $source)';
}


}

/// @nodoc
abstract mixin class $LoginCopyWith<$Res>  {
  factory $LoginCopyWith(Login value, $Res Function(Login) _then) = _$LoginCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "user") User user,@JsonKey(name: "userDefaultLibraryId") String userDefaultLibraryId,@JsonKey(name: "serverSettings") ServerSettings serverSettings,@JsonKey(name: "Source") String source
});


$UserCopyWith<$Res> get user;$ServerSettingsCopyWith<$Res> get serverSettings;

}
/// @nodoc
class _$LoginCopyWithImpl<$Res>
    implements $LoginCopyWith<$Res> {
  _$LoginCopyWithImpl(this._self, this._then);

  final Login _self;
  final $Res Function(Login) _then;

/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? userDefaultLibraryId = null,Object? serverSettings = null,Object? source = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,userDefaultLibraryId: null == userDefaultLibraryId ? _self.userDefaultLibraryId : userDefaultLibraryId // ignore: cast_nullable_to_non_nullable
as String,serverSettings: null == serverSettings ? _self.serverSettings : serverSettings // ignore: cast_nullable_to_non_nullable
as ServerSettings,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res> get serverSettings {
  
  return $ServerSettingsCopyWith<$Res>(_self.serverSettings, (value) {
    return _then(_self.copyWith(serverSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [Login].
extension LoginPatterns on Login {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Login value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Login() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Login value)  $default,){
final _that = this;
switch (_that) {
case _Login():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Login value)?  $default,){
final _that = this;
switch (_that) {
case _Login() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "user")  User user, @JsonKey(name: "userDefaultLibraryId")  String userDefaultLibraryId, @JsonKey(name: "serverSettings")  ServerSettings serverSettings, @JsonKey(name: "Source")  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Login() when $default != null:
return $default(_that.user,_that.userDefaultLibraryId,_that.serverSettings,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "user")  User user, @JsonKey(name: "userDefaultLibraryId")  String userDefaultLibraryId, @JsonKey(name: "serverSettings")  ServerSettings serverSettings, @JsonKey(name: "Source")  String source)  $default,) {final _that = this;
switch (_that) {
case _Login():
return $default(_that.user,_that.userDefaultLibraryId,_that.serverSettings,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "user")  User user, @JsonKey(name: "userDefaultLibraryId")  String userDefaultLibraryId, @JsonKey(name: "serverSettings")  ServerSettings serverSettings, @JsonKey(name: "Source")  String source)?  $default,) {final _that = this;
switch (_that) {
case _Login() when $default != null:
return $default(_that.user,_that.userDefaultLibraryId,_that.serverSettings,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Login implements Login {
  const _Login({@JsonKey(name: "user") required this.user, @JsonKey(name: "userDefaultLibraryId") required this.userDefaultLibraryId, @JsonKey(name: "serverSettings") required this.serverSettings, @JsonKey(name: "Source") required this.source});
  factory _Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

@override@JsonKey(name: "user") final  User user;
@override@JsonKey(name: "userDefaultLibraryId") final  String userDefaultLibraryId;
@override@JsonKey(name: "serverSettings") final  ServerSettings serverSettings;
@override@JsonKey(name: "Source") final  String source;

/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginCopyWith<_Login> get copyWith => __$LoginCopyWithImpl<_Login>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Login&&(identical(other.user, user) || other.user == user)&&(identical(other.userDefaultLibraryId, userDefaultLibraryId) || other.userDefaultLibraryId == userDefaultLibraryId)&&(identical(other.serverSettings, serverSettings) || other.serverSettings == serverSettings)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,user,userDefaultLibraryId,serverSettings,source);

@override
String toString() {
  return 'Login(user: $user, userDefaultLibraryId: $userDefaultLibraryId, serverSettings: $serverSettings, source: $source)';
}


}

/// @nodoc
abstract mixin class _$LoginCopyWith<$Res> implements $LoginCopyWith<$Res> {
  factory _$LoginCopyWith(_Login value, $Res Function(_Login) _then) = __$LoginCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "user") User user,@JsonKey(name: "userDefaultLibraryId") String userDefaultLibraryId,@JsonKey(name: "serverSettings") ServerSettings serverSettings,@JsonKey(name: "Source") String source
});


@override $UserCopyWith<$Res> get user;@override $ServerSettingsCopyWith<$Res> get serverSettings;

}
/// @nodoc
class __$LoginCopyWithImpl<$Res>
    implements _$LoginCopyWith<$Res> {
  __$LoginCopyWithImpl(this._self, this._then);

  final _Login _self;
  final $Res Function(_Login) _then;

/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? userDefaultLibraryId = null,Object? serverSettings = null,Object? source = null,}) {
  return _then(_Login(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as User,userDefaultLibraryId: null == userDefaultLibraryId ? _self.userDefaultLibraryId : userDefaultLibraryId // ignore: cast_nullable_to_non_nullable
as String,serverSettings: null == serverSettings ? _self.serverSettings : serverSettings // ignore: cast_nullable_to_non_nullable
as ServerSettings,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserCopyWith<$Res> get user {
  
  return $UserCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}/// Create a copy of Login
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res> get serverSettings {
  
  return $ServerSettingsCopyWith<$Res>(_self.serverSettings, (value) {
    return _then(_self.copyWith(serverSettings: value));
  });
}
}

// dart format on
