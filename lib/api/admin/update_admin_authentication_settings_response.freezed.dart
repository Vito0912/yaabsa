// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_admin_authentication_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateAdminAuthenticationSettingsResponse {

@JsonKey(name: 'updated') bool get updated;@JsonKey(name: 'serverSettings') ServerSettings? get serverSettings;
/// Create a copy of UpdateAdminAuthenticationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAdminAuthenticationSettingsResponseCopyWith<UpdateAdminAuthenticationSettingsResponse> get copyWith => _$UpdateAdminAuthenticationSettingsResponseCopyWithImpl<UpdateAdminAuthenticationSettingsResponse>(this as UpdateAdminAuthenticationSettingsResponse, _$identity);

  /// Serializes this UpdateAdminAuthenticationSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAdminAuthenticationSettingsResponse&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.serverSettings, serverSettings) || other.serverSettings == serverSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated,serverSettings);

@override
String toString() {
  return 'UpdateAdminAuthenticationSettingsResponse(updated: $updated, serverSettings: $serverSettings)';
}


}

/// @nodoc
abstract mixin class $UpdateAdminAuthenticationSettingsResponseCopyWith<$Res>  {
  factory $UpdateAdminAuthenticationSettingsResponseCopyWith(UpdateAdminAuthenticationSettingsResponse value, $Res Function(UpdateAdminAuthenticationSettingsResponse) _then) = _$UpdateAdminAuthenticationSettingsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'updated') bool updated,@JsonKey(name: 'serverSettings') ServerSettings? serverSettings
});


$ServerSettingsCopyWith<$Res>? get serverSettings;

}
/// @nodoc
class _$UpdateAdminAuthenticationSettingsResponseCopyWithImpl<$Res>
    implements $UpdateAdminAuthenticationSettingsResponseCopyWith<$Res> {
  _$UpdateAdminAuthenticationSettingsResponseCopyWithImpl(this._self, this._then);

  final UpdateAdminAuthenticationSettingsResponse _self;
  final $Res Function(UpdateAdminAuthenticationSettingsResponse) _then;

/// Create a copy of UpdateAdminAuthenticationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updated = null,Object? serverSettings = freezed,}) {
  return _then(_self.copyWith(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,serverSettings: freezed == serverSettings ? _self.serverSettings : serverSettings // ignore: cast_nullable_to_non_nullable
as ServerSettings?,
  ));
}
/// Create a copy of UpdateAdminAuthenticationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res>? get serverSettings {
    if (_self.serverSettings == null) {
    return null;
  }

  return $ServerSettingsCopyWith<$Res>(_self.serverSettings!, (value) {
    return _then(_self.copyWith(serverSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateAdminAuthenticationSettingsResponse].
extension UpdateAdminAuthenticationSettingsResponsePatterns on UpdateAdminAuthenticationSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAdminAuthenticationSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAdminAuthenticationSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAdminAuthenticationSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminAuthenticationSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAdminAuthenticationSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminAuthenticationSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'updated')  bool updated, @JsonKey(name: 'serverSettings')  ServerSettings? serverSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAdminAuthenticationSettingsResponse() when $default != null:
return $default(_that.updated,_that.serverSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'updated')  bool updated, @JsonKey(name: 'serverSettings')  ServerSettings? serverSettings)  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminAuthenticationSettingsResponse():
return $default(_that.updated,_that.serverSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'updated')  bool updated, @JsonKey(name: 'serverSettings')  ServerSettings? serverSettings)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminAuthenticationSettingsResponse() when $default != null:
return $default(_that.updated,_that.serverSettings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAdminAuthenticationSettingsResponse implements UpdateAdminAuthenticationSettingsResponse {
  const _UpdateAdminAuthenticationSettingsResponse({@JsonKey(name: 'updated') this.updated = false, @JsonKey(name: 'serverSettings') this.serverSettings});
  factory _UpdateAdminAuthenticationSettingsResponse.fromJson(Map<String, dynamic> json) => _$UpdateAdminAuthenticationSettingsResponseFromJson(json);

@override@JsonKey(name: 'updated') final  bool updated;
@override@JsonKey(name: 'serverSettings') final  ServerSettings? serverSettings;

/// Create a copy of UpdateAdminAuthenticationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAdminAuthenticationSettingsResponseCopyWith<_UpdateAdminAuthenticationSettingsResponse> get copyWith => __$UpdateAdminAuthenticationSettingsResponseCopyWithImpl<_UpdateAdminAuthenticationSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAdminAuthenticationSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAdminAuthenticationSettingsResponse&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.serverSettings, serverSettings) || other.serverSettings == serverSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated,serverSettings);

@override
String toString() {
  return 'UpdateAdminAuthenticationSettingsResponse(updated: $updated, serverSettings: $serverSettings)';
}


}

/// @nodoc
abstract mixin class _$UpdateAdminAuthenticationSettingsResponseCopyWith<$Res> implements $UpdateAdminAuthenticationSettingsResponseCopyWith<$Res> {
  factory _$UpdateAdminAuthenticationSettingsResponseCopyWith(_UpdateAdminAuthenticationSettingsResponse value, $Res Function(_UpdateAdminAuthenticationSettingsResponse) _then) = __$UpdateAdminAuthenticationSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'updated') bool updated,@JsonKey(name: 'serverSettings') ServerSettings? serverSettings
});


@override $ServerSettingsCopyWith<$Res>? get serverSettings;

}
/// @nodoc
class __$UpdateAdminAuthenticationSettingsResponseCopyWithImpl<$Res>
    implements _$UpdateAdminAuthenticationSettingsResponseCopyWith<$Res> {
  __$UpdateAdminAuthenticationSettingsResponseCopyWithImpl(this._self, this._then);

  final _UpdateAdminAuthenticationSettingsResponse _self;
  final $Res Function(_UpdateAdminAuthenticationSettingsResponse) _then;

/// Create a copy of UpdateAdminAuthenticationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updated = null,Object? serverSettings = freezed,}) {
  return _then(_UpdateAdminAuthenticationSettingsResponse(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,serverSettings: freezed == serverSettings ? _self.serverSettings : serverSettings // ignore: cast_nullable_to_non_nullable
as ServerSettings?,
  ));
}

/// Create a copy of UpdateAdminAuthenticationSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res>? get serverSettings {
    if (_self.serverSettings == null) {
    return null;
  }

  return $ServerSettingsCopyWith<$Res>(_self.serverSettings!, (value) {
    return _then(_self.copyWith(serverSettings: value));
  });
}
}

// dart format on
