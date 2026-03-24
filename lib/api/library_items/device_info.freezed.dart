// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceInfo {

@JsonKey(name: "deviceId") String? get deviceId;@JsonKey(name: "clientName") String? get clientName;@JsonKey(name: "clientVersion") String? get clientVersion;@JsonKey(name: "manufacturer") String? get manufacturer;@JsonKey(name: "model") String? get model;@JsonKey(name: "sdkVersion") String? get sdkVersion;
/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<DeviceInfo> get copyWith => _$DeviceInfoCopyWithImpl<DeviceInfo>(this as DeviceInfo, _$identity);

  /// Serializes this DeviceInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceInfo&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientVersion, clientVersion) || other.clientVersion == clientVersion)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,clientName,clientVersion,manufacturer,model,sdkVersion);

@override
String toString() {
  return 'DeviceInfo(deviceId: $deviceId, clientName: $clientName, clientVersion: $clientVersion, manufacturer: $manufacturer, model: $model, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class $DeviceInfoCopyWith<$Res>  {
  factory $DeviceInfoCopyWith(DeviceInfo value, $Res Function(DeviceInfo) _then) = _$DeviceInfoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "deviceId") String? deviceId,@JsonKey(name: "clientName") String? clientName,@JsonKey(name: "clientVersion") String? clientVersion,@JsonKey(name: "manufacturer") String? manufacturer,@JsonKey(name: "model") String? model,@JsonKey(name: "sdkVersion") String? sdkVersion
});




}
/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._self, this._then);

  final DeviceInfo _self;
  final $Res Function(DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = freezed,Object? clientName = freezed,Object? clientVersion = freezed,Object? manufacturer = freezed,Object? model = freezed,Object? sdkVersion = freezed,}) {
  return _then(_self.copyWith(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,clientVersion: freezed == clientVersion ? _self.clientVersion : clientVersion // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,sdkVersion: freezed == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceInfo].
extension DeviceInfoPatterns on DeviceInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceInfo value)  $default,){
final _that = this;
switch (_that) {
case _DeviceInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceInfo value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "deviceId")  String? deviceId, @JsonKey(name: "clientName")  String? clientName, @JsonKey(name: "clientVersion")  String? clientVersion, @JsonKey(name: "manufacturer")  String? manufacturer, @JsonKey(name: "model")  String? model, @JsonKey(name: "sdkVersion")  String? sdkVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
return $default(_that.deviceId,_that.clientName,_that.clientVersion,_that.manufacturer,_that.model,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "deviceId")  String? deviceId, @JsonKey(name: "clientName")  String? clientName, @JsonKey(name: "clientVersion")  String? clientVersion, @JsonKey(name: "manufacturer")  String? manufacturer, @JsonKey(name: "model")  String? model, @JsonKey(name: "sdkVersion")  String? sdkVersion)  $default,) {final _that = this;
switch (_that) {
case _DeviceInfo():
return $default(_that.deviceId,_that.clientName,_that.clientVersion,_that.manufacturer,_that.model,_that.sdkVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "deviceId")  String? deviceId, @JsonKey(name: "clientName")  String? clientName, @JsonKey(name: "clientVersion")  String? clientVersion, @JsonKey(name: "manufacturer")  String? manufacturer, @JsonKey(name: "model")  String? model, @JsonKey(name: "sdkVersion")  String? sdkVersion)?  $default,) {final _that = this;
switch (_that) {
case _DeviceInfo() when $default != null:
return $default(_that.deviceId,_that.clientName,_that.clientVersion,_that.manufacturer,_that.model,_that.sdkVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceInfo implements DeviceInfo {
  const _DeviceInfo({@JsonKey(name: "deviceId") this.deviceId, @JsonKey(name: "clientName") this.clientName, @JsonKey(name: "clientVersion") this.clientVersion, @JsonKey(name: "manufacturer") this.manufacturer, @JsonKey(name: "model") this.model, @JsonKey(name: "sdkVersion") this.sdkVersion});
  factory _DeviceInfo.fromJson(Map<String, dynamic> json) => _$DeviceInfoFromJson(json);

@override@JsonKey(name: "deviceId") final  String? deviceId;
@override@JsonKey(name: "clientName") final  String? clientName;
@override@JsonKey(name: "clientVersion") final  String? clientVersion;
@override@JsonKey(name: "manufacturer") final  String? manufacturer;
@override@JsonKey(name: "model") final  String? model;
@override@JsonKey(name: "sdkVersion") final  String? sdkVersion;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceInfoCopyWith<_DeviceInfo> get copyWith => __$DeviceInfoCopyWithImpl<_DeviceInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceInfo&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientVersion, clientVersion) || other.clientVersion == clientVersion)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.sdkVersion, sdkVersion) || other.sdkVersion == sdkVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,clientName,clientVersion,manufacturer,model,sdkVersion);

@override
String toString() {
  return 'DeviceInfo(deviceId: $deviceId, clientName: $clientName, clientVersion: $clientVersion, manufacturer: $manufacturer, model: $model, sdkVersion: $sdkVersion)';
}


}

/// @nodoc
abstract mixin class _$DeviceInfoCopyWith<$Res> implements $DeviceInfoCopyWith<$Res> {
  factory _$DeviceInfoCopyWith(_DeviceInfo value, $Res Function(_DeviceInfo) _then) = __$DeviceInfoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "deviceId") String? deviceId,@JsonKey(name: "clientName") String? clientName,@JsonKey(name: "clientVersion") String? clientVersion,@JsonKey(name: "manufacturer") String? manufacturer,@JsonKey(name: "model") String? model,@JsonKey(name: "sdkVersion") String? sdkVersion
});




}
/// @nodoc
class __$DeviceInfoCopyWithImpl<$Res>
    implements _$DeviceInfoCopyWith<$Res> {
  __$DeviceInfoCopyWithImpl(this._self, this._then);

  final _DeviceInfo _self;
  final $Res Function(_DeviceInfo) _then;

/// Create a copy of DeviceInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = freezed,Object? clientName = freezed,Object? clientVersion = freezed,Object? manufacturer = freezed,Object? model = freezed,Object? sdkVersion = freezed,}) {
  return _then(_DeviceInfo(
deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,clientVersion: freezed == clientVersion ? _self.clientVersion : clientVersion // ignore: cast_nullable_to_non_nullable
as String?,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,sdkVersion: freezed == sdkVersion ? _self.sdkVersion : sdkVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
