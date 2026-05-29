// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_email_settings_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminEmailSettingsResponse {

@JsonKey(name: 'settings') AdminEmailSettings? get settings;
/// Create a copy of AdminEmailSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminEmailSettingsResponseCopyWith<AdminEmailSettingsResponse> get copyWith => _$AdminEmailSettingsResponseCopyWithImpl<AdminEmailSettingsResponse>(this as AdminEmailSettingsResponse, _$identity);

  /// Serializes this AdminEmailSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminEmailSettingsResponse&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,settings);

@override
String toString() {
  return 'AdminEmailSettingsResponse(settings: $settings)';
}


}

/// @nodoc
abstract mixin class $AdminEmailSettingsResponseCopyWith<$Res>  {
  factory $AdminEmailSettingsResponseCopyWith(AdminEmailSettingsResponse value, $Res Function(AdminEmailSettingsResponse) _then) = _$AdminEmailSettingsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'settings') AdminEmailSettings? settings
});


$AdminEmailSettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class _$AdminEmailSettingsResponseCopyWithImpl<$Res>
    implements $AdminEmailSettingsResponseCopyWith<$Res> {
  _$AdminEmailSettingsResponseCopyWithImpl(this._self, this._then);

  final AdminEmailSettingsResponse _self;
  final $Res Function(AdminEmailSettingsResponse) _then;

/// Create a copy of AdminEmailSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? settings = freezed,}) {
  return _then(_self.copyWith(
settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AdminEmailSettings?,
  ));
}
/// Create a copy of AdminEmailSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminEmailSettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $AdminEmailSettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminEmailSettingsResponse].
extension AdminEmailSettingsResponsePatterns on AdminEmailSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminEmailSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminEmailSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminEmailSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminEmailSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminEmailSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminEmailSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'settings')  AdminEmailSettings? settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminEmailSettingsResponse() when $default != null:
return $default(_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'settings')  AdminEmailSettings? settings)  $default,) {final _that = this;
switch (_that) {
case _AdminEmailSettingsResponse():
return $default(_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'settings')  AdminEmailSettings? settings)?  $default,) {final _that = this;
switch (_that) {
case _AdminEmailSettingsResponse() when $default != null:
return $default(_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminEmailSettingsResponse implements AdminEmailSettingsResponse {
  const _AdminEmailSettingsResponse({@JsonKey(name: 'settings') this.settings});
  factory _AdminEmailSettingsResponse.fromJson(Map<String, dynamic> json) => _$AdminEmailSettingsResponseFromJson(json);

@override@JsonKey(name: 'settings') final  AdminEmailSettings? settings;

/// Create a copy of AdminEmailSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminEmailSettingsResponseCopyWith<_AdminEmailSettingsResponse> get copyWith => __$AdminEmailSettingsResponseCopyWithImpl<_AdminEmailSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminEmailSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminEmailSettingsResponse&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,settings);

@override
String toString() {
  return 'AdminEmailSettingsResponse(settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$AdminEmailSettingsResponseCopyWith<$Res> implements $AdminEmailSettingsResponseCopyWith<$Res> {
  factory _$AdminEmailSettingsResponseCopyWith(_AdminEmailSettingsResponse value, $Res Function(_AdminEmailSettingsResponse) _then) = __$AdminEmailSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'settings') AdminEmailSettings? settings
});


@override $AdminEmailSettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class __$AdminEmailSettingsResponseCopyWithImpl<$Res>
    implements _$AdminEmailSettingsResponseCopyWith<$Res> {
  __$AdminEmailSettingsResponseCopyWithImpl(this._self, this._then);

  final _AdminEmailSettingsResponse _self;
  final $Res Function(_AdminEmailSettingsResponse) _then;

/// Create a copy of AdminEmailSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? settings = freezed,}) {
  return _then(_AdminEmailSettingsResponse(
settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as AdminEmailSettings?,
  ));
}

/// Create a copy of AdminEmailSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminEmailSettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $AdminEmailSettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
