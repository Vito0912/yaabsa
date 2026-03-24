// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerStatus {

@JsonKey(name: 'app') String get app;@JsonKey(name: 'serverVersion') String get serverVersion;@JsonKey(name: 'isInit') bool get isInit;@JsonKey(name: 'language') String get language;@JsonKey(name: 'authMethods') List<String> get authMethods;@JsonKey(name: 'authFormData') AuthFormData? get authFormData;@JsonKey(name: 'ConfigPath') String? get configPath;@JsonKey(name: 'MetadataPath') String? get metadataPath;
/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerStatusCopyWith<ServerStatus> get copyWith => _$ServerStatusCopyWithImpl<ServerStatus>(this as ServerStatus, _$identity);

  /// Serializes this ServerStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerStatus&&(identical(other.app, app) || other.app == app)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.isInit, isInit) || other.isInit == isInit)&&(identical(other.language, language) || other.language == language)&&const DeepCollectionEquality().equals(other.authMethods, authMethods)&&(identical(other.authFormData, authFormData) || other.authFormData == authFormData)&&(identical(other.configPath, configPath) || other.configPath == configPath)&&(identical(other.metadataPath, metadataPath) || other.metadataPath == metadataPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,app,serverVersion,isInit,language,const DeepCollectionEquality().hash(authMethods),authFormData,configPath,metadataPath);

@override
String toString() {
  return 'ServerStatus(app: $app, serverVersion: $serverVersion, isInit: $isInit, language: $language, authMethods: $authMethods, authFormData: $authFormData, configPath: $configPath, metadataPath: $metadataPath)';
}


}

/// @nodoc
abstract mixin class $ServerStatusCopyWith<$Res>  {
  factory $ServerStatusCopyWith(ServerStatus value, $Res Function(ServerStatus) _then) = _$ServerStatusCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'app') String app,@JsonKey(name: 'serverVersion') String serverVersion,@JsonKey(name: 'isInit') bool isInit,@JsonKey(name: 'language') String language,@JsonKey(name: 'authMethods') List<String> authMethods,@JsonKey(name: 'authFormData') AuthFormData? authFormData,@JsonKey(name: 'ConfigPath') String? configPath,@JsonKey(name: 'MetadataPath') String? metadataPath
});


$AuthFormDataCopyWith<$Res>? get authFormData;

}
/// @nodoc
class _$ServerStatusCopyWithImpl<$Res>
    implements $ServerStatusCopyWith<$Res> {
  _$ServerStatusCopyWithImpl(this._self, this._then);

  final ServerStatus _self;
  final $Res Function(ServerStatus) _then;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? app = null,Object? serverVersion = null,Object? isInit = null,Object? language = null,Object? authMethods = null,Object? authFormData = freezed,Object? configPath = freezed,Object? metadataPath = freezed,}) {
  return _then(_self.copyWith(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String,serverVersion: null == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String,isInit: null == isInit ? _self.isInit : isInit // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,authMethods: null == authMethods ? _self.authMethods : authMethods // ignore: cast_nullable_to_non_nullable
as List<String>,authFormData: freezed == authFormData ? _self.authFormData : authFormData // ignore: cast_nullable_to_non_nullable
as AuthFormData?,configPath: freezed == configPath ? _self.configPath : configPath // ignore: cast_nullable_to_non_nullable
as String?,metadataPath: freezed == metadataPath ? _self.metadataPath : metadataPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFormDataCopyWith<$Res>? get authFormData {
    if (_self.authFormData == null) {
    return null;
  }

  return $AuthFormDataCopyWith<$Res>(_self.authFormData!, (value) {
    return _then(_self.copyWith(authFormData: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerStatus].
extension ServerStatusPatterns on ServerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerStatus value)  $default,){
final _that = this;
switch (_that) {
case _ServerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'app')  String app, @JsonKey(name: 'serverVersion')  String serverVersion, @JsonKey(name: 'isInit')  bool isInit, @JsonKey(name: 'language')  String language, @JsonKey(name: 'authMethods')  List<String> authMethods, @JsonKey(name: 'authFormData')  AuthFormData? authFormData, @JsonKey(name: 'ConfigPath')  String? configPath, @JsonKey(name: 'MetadataPath')  String? metadataPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
return $default(_that.app,_that.serverVersion,_that.isInit,_that.language,_that.authMethods,_that.authFormData,_that.configPath,_that.metadataPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'app')  String app, @JsonKey(name: 'serverVersion')  String serverVersion, @JsonKey(name: 'isInit')  bool isInit, @JsonKey(name: 'language')  String language, @JsonKey(name: 'authMethods')  List<String> authMethods, @JsonKey(name: 'authFormData')  AuthFormData? authFormData, @JsonKey(name: 'ConfigPath')  String? configPath, @JsonKey(name: 'MetadataPath')  String? metadataPath)  $default,) {final _that = this;
switch (_that) {
case _ServerStatus():
return $default(_that.app,_that.serverVersion,_that.isInit,_that.language,_that.authMethods,_that.authFormData,_that.configPath,_that.metadataPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'app')  String app, @JsonKey(name: 'serverVersion')  String serverVersion, @JsonKey(name: 'isInit')  bool isInit, @JsonKey(name: 'language')  String language, @JsonKey(name: 'authMethods')  List<String> authMethods, @JsonKey(name: 'authFormData')  AuthFormData? authFormData, @JsonKey(name: 'ConfigPath')  String? configPath, @JsonKey(name: 'MetadataPath')  String? metadataPath)?  $default,) {final _that = this;
switch (_that) {
case _ServerStatus() when $default != null:
return $default(_that.app,_that.serverVersion,_that.isInit,_that.language,_that.authMethods,_that.authFormData,_that.configPath,_that.metadataPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerStatus implements ServerStatus {
  const _ServerStatus({@JsonKey(name: 'app') required this.app, @JsonKey(name: 'serverVersion') required this.serverVersion, @JsonKey(name: 'isInit') required this.isInit, @JsonKey(name: 'language') required this.language, @JsonKey(name: 'authMethods') final  List<String> authMethods = const <String>[], @JsonKey(name: 'authFormData') this.authFormData, @JsonKey(name: 'ConfigPath') this.configPath, @JsonKey(name: 'MetadataPath') this.metadataPath}): _authMethods = authMethods;
  factory _ServerStatus.fromJson(Map<String, dynamic> json) => _$ServerStatusFromJson(json);

@override@JsonKey(name: 'app') final  String app;
@override@JsonKey(name: 'serverVersion') final  String serverVersion;
@override@JsonKey(name: 'isInit') final  bool isInit;
@override@JsonKey(name: 'language') final  String language;
 final  List<String> _authMethods;
@override@JsonKey(name: 'authMethods') List<String> get authMethods {
  if (_authMethods is EqualUnmodifiableListView) return _authMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authMethods);
}

@override@JsonKey(name: 'authFormData') final  AuthFormData? authFormData;
@override@JsonKey(name: 'ConfigPath') final  String? configPath;
@override@JsonKey(name: 'MetadataPath') final  String? metadataPath;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerStatusCopyWith<_ServerStatus> get copyWith => __$ServerStatusCopyWithImpl<_ServerStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerStatus&&(identical(other.app, app) || other.app == app)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.isInit, isInit) || other.isInit == isInit)&&(identical(other.language, language) || other.language == language)&&const DeepCollectionEquality().equals(other._authMethods, _authMethods)&&(identical(other.authFormData, authFormData) || other.authFormData == authFormData)&&(identical(other.configPath, configPath) || other.configPath == configPath)&&(identical(other.metadataPath, metadataPath) || other.metadataPath == metadataPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,app,serverVersion,isInit,language,const DeepCollectionEquality().hash(_authMethods),authFormData,configPath,metadataPath);

@override
String toString() {
  return 'ServerStatus(app: $app, serverVersion: $serverVersion, isInit: $isInit, language: $language, authMethods: $authMethods, authFormData: $authFormData, configPath: $configPath, metadataPath: $metadataPath)';
}


}

/// @nodoc
abstract mixin class _$ServerStatusCopyWith<$Res> implements $ServerStatusCopyWith<$Res> {
  factory _$ServerStatusCopyWith(_ServerStatus value, $Res Function(_ServerStatus) _then) = __$ServerStatusCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'app') String app,@JsonKey(name: 'serverVersion') String serverVersion,@JsonKey(name: 'isInit') bool isInit,@JsonKey(name: 'language') String language,@JsonKey(name: 'authMethods') List<String> authMethods,@JsonKey(name: 'authFormData') AuthFormData? authFormData,@JsonKey(name: 'ConfigPath') String? configPath,@JsonKey(name: 'MetadataPath') String? metadataPath
});


@override $AuthFormDataCopyWith<$Res>? get authFormData;

}
/// @nodoc
class __$ServerStatusCopyWithImpl<$Res>
    implements _$ServerStatusCopyWith<$Res> {
  __$ServerStatusCopyWithImpl(this._self, this._then);

  final _ServerStatus _self;
  final $Res Function(_ServerStatus) _then;

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? app = null,Object? serverVersion = null,Object? isInit = null,Object? language = null,Object? authMethods = null,Object? authFormData = freezed,Object? configPath = freezed,Object? metadataPath = freezed,}) {
  return _then(_ServerStatus(
app: null == app ? _self.app : app // ignore: cast_nullable_to_non_nullable
as String,serverVersion: null == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String,isInit: null == isInit ? _self.isInit : isInit // ignore: cast_nullable_to_non_nullable
as bool,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,authMethods: null == authMethods ? _self._authMethods : authMethods // ignore: cast_nullable_to_non_nullable
as List<String>,authFormData: freezed == authFormData ? _self.authFormData : authFormData // ignore: cast_nullable_to_non_nullable
as AuthFormData?,configPath: freezed == configPath ? _self.configPath : configPath // ignore: cast_nullable_to_non_nullable
as String?,metadataPath: freezed == metadataPath ? _self.metadataPath : metadataPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ServerStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFormDataCopyWith<$Res>? get authFormData {
    if (_self.authFormData == null) {
    return null;
  }

  return $AuthFormDataCopyWith<$Res>(_self.authFormData!, (value) {
    return _then(_self.copyWith(authFormData: value));
  });
}
}


/// @nodoc
mixin _$AuthFormData {

@JsonKey(name: 'authLoginCustomMessage') String? get authLoginCustomMessage;@JsonKey(name: 'authOpenIDButtonText') String? get authOpenIDButtonText;@JsonKey(name: 'authOpenIDAutoLaunch') bool? get authOpenIDAutoLaunch;
/// Create a copy of AuthFormData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthFormDataCopyWith<AuthFormData> get copyWith => _$AuthFormDataCopyWithImpl<AuthFormData>(this as AuthFormData, _$identity);

  /// Serializes this AuthFormData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFormData&&(identical(other.authLoginCustomMessage, authLoginCustomMessage) || other.authLoginCustomMessage == authLoginCustomMessage)&&(identical(other.authOpenIDButtonText, authOpenIDButtonText) || other.authOpenIDButtonText == authOpenIDButtonText)&&(identical(other.authOpenIDAutoLaunch, authOpenIDAutoLaunch) || other.authOpenIDAutoLaunch == authOpenIDAutoLaunch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authLoginCustomMessage,authOpenIDButtonText,authOpenIDAutoLaunch);

@override
String toString() {
  return 'AuthFormData(authLoginCustomMessage: $authLoginCustomMessage, authOpenIDButtonText: $authOpenIDButtonText, authOpenIDAutoLaunch: $authOpenIDAutoLaunch)';
}


}

/// @nodoc
abstract mixin class $AuthFormDataCopyWith<$Res>  {
  factory $AuthFormDataCopyWith(AuthFormData value, $Res Function(AuthFormData) _then) = _$AuthFormDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,@JsonKey(name: 'authOpenIDButtonText') String? authOpenIDButtonText,@JsonKey(name: 'authOpenIDAutoLaunch') bool? authOpenIDAutoLaunch
});




}
/// @nodoc
class _$AuthFormDataCopyWithImpl<$Res>
    implements $AuthFormDataCopyWith<$Res> {
  _$AuthFormDataCopyWithImpl(this._self, this._then);

  final AuthFormData _self;
  final $Res Function(AuthFormData) _then;

/// Create a copy of AuthFormData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authLoginCustomMessage = freezed,Object? authOpenIDButtonText = freezed,Object? authOpenIDAutoLaunch = freezed,}) {
  return _then(_self.copyWith(
authLoginCustomMessage: freezed == authLoginCustomMessage ? _self.authLoginCustomMessage : authLoginCustomMessage // ignore: cast_nullable_to_non_nullable
as String?,authOpenIDButtonText: freezed == authOpenIDButtonText ? _self.authOpenIDButtonText : authOpenIDButtonText // ignore: cast_nullable_to_non_nullable
as String?,authOpenIDAutoLaunch: freezed == authOpenIDAutoLaunch ? _self.authOpenIDAutoLaunch : authOpenIDAutoLaunch // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthFormData].
extension AuthFormDataPatterns on AuthFormData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthFormData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthFormData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthFormData value)  $default,){
final _that = this;
switch (_that) {
case _AuthFormData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthFormData value)?  $default,){
final _that = this;
switch (_that) {
case _AuthFormData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'authLoginCustomMessage')  String? authLoginCustomMessage, @JsonKey(name: 'authOpenIDButtonText')  String? authOpenIDButtonText, @JsonKey(name: 'authOpenIDAutoLaunch')  bool? authOpenIDAutoLaunch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthFormData() when $default != null:
return $default(_that.authLoginCustomMessage,_that.authOpenIDButtonText,_that.authOpenIDAutoLaunch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'authLoginCustomMessage')  String? authLoginCustomMessage, @JsonKey(name: 'authOpenIDButtonText')  String? authOpenIDButtonText, @JsonKey(name: 'authOpenIDAutoLaunch')  bool? authOpenIDAutoLaunch)  $default,) {final _that = this;
switch (_that) {
case _AuthFormData():
return $default(_that.authLoginCustomMessage,_that.authOpenIDButtonText,_that.authOpenIDAutoLaunch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'authLoginCustomMessage')  String? authLoginCustomMessage, @JsonKey(name: 'authOpenIDButtonText')  String? authOpenIDButtonText, @JsonKey(name: 'authOpenIDAutoLaunch')  bool? authOpenIDAutoLaunch)?  $default,) {final _that = this;
switch (_that) {
case _AuthFormData() when $default != null:
return $default(_that.authLoginCustomMessage,_that.authOpenIDButtonText,_that.authOpenIDAutoLaunch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthFormData implements AuthFormData {
  const _AuthFormData({@JsonKey(name: 'authLoginCustomMessage') this.authLoginCustomMessage, @JsonKey(name: 'authOpenIDButtonText') this.authOpenIDButtonText, @JsonKey(name: 'authOpenIDAutoLaunch') this.authOpenIDAutoLaunch});
  factory _AuthFormData.fromJson(Map<String, dynamic> json) => _$AuthFormDataFromJson(json);

@override@JsonKey(name: 'authLoginCustomMessage') final  String? authLoginCustomMessage;
@override@JsonKey(name: 'authOpenIDButtonText') final  String? authOpenIDButtonText;
@override@JsonKey(name: 'authOpenIDAutoLaunch') final  bool? authOpenIDAutoLaunch;

/// Create a copy of AuthFormData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthFormDataCopyWith<_AuthFormData> get copyWith => __$AuthFormDataCopyWithImpl<_AuthFormData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthFormDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthFormData&&(identical(other.authLoginCustomMessage, authLoginCustomMessage) || other.authLoginCustomMessage == authLoginCustomMessage)&&(identical(other.authOpenIDButtonText, authOpenIDButtonText) || other.authOpenIDButtonText == authOpenIDButtonText)&&(identical(other.authOpenIDAutoLaunch, authOpenIDAutoLaunch) || other.authOpenIDAutoLaunch == authOpenIDAutoLaunch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,authLoginCustomMessage,authOpenIDButtonText,authOpenIDAutoLaunch);

@override
String toString() {
  return 'AuthFormData(authLoginCustomMessage: $authLoginCustomMessage, authOpenIDButtonText: $authOpenIDButtonText, authOpenIDAutoLaunch: $authOpenIDAutoLaunch)';
}


}

/// @nodoc
abstract mixin class _$AuthFormDataCopyWith<$Res> implements $AuthFormDataCopyWith<$Res> {
  factory _$AuthFormDataCopyWith(_AuthFormData value, $Res Function(_AuthFormData) _then) = __$AuthFormDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,@JsonKey(name: 'authOpenIDButtonText') String? authOpenIDButtonText,@JsonKey(name: 'authOpenIDAutoLaunch') bool? authOpenIDAutoLaunch
});




}
/// @nodoc
class __$AuthFormDataCopyWithImpl<$Res>
    implements _$AuthFormDataCopyWith<$Res> {
  __$AuthFormDataCopyWithImpl(this._self, this._then);

  final _AuthFormData _self;
  final $Res Function(_AuthFormData) _then;

/// Create a copy of AuthFormData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authLoginCustomMessage = freezed,Object? authOpenIDButtonText = freezed,Object? authOpenIDAutoLaunch = freezed,}) {
  return _then(_AuthFormData(
authLoginCustomMessage: freezed == authLoginCustomMessage ? _self.authLoginCustomMessage : authLoginCustomMessage // ignore: cast_nullable_to_non_nullable
as String?,authOpenIDButtonText: freezed == authOpenIDButtonText ? _self.authOpenIDButtonText : authOpenIDButtonText // ignore: cast_nullable_to_non_nullable
as String?,authOpenIDAutoLaunch: freezed == authOpenIDAutoLaunch ? _self.authOpenIDAutoLaunch : authOpenIDAutoLaunch // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
