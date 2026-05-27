// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_admin_email_ereader_devices_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateAdminEmailEreaderDevicesRequest {

@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> get ereaderDevices;
/// Create a copy of UpdateAdminEmailEreaderDevicesRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAdminEmailEreaderDevicesRequestCopyWith<UpdateAdminEmailEreaderDevicesRequest> get copyWith => _$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl<UpdateAdminEmailEreaderDevicesRequest>(this as UpdateAdminEmailEreaderDevicesRequest, _$identity);

  /// Serializes this UpdateAdminEmailEreaderDevicesRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAdminEmailEreaderDevicesRequest&&const DeepCollectionEquality().equals(other.ereaderDevices, ereaderDevices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ereaderDevices));

@override
String toString() {
  return 'UpdateAdminEmailEreaderDevicesRequest(ereaderDevices: $ereaderDevices)';
}


}

/// @nodoc
abstract mixin class $UpdateAdminEmailEreaderDevicesRequestCopyWith<$Res>  {
  factory $UpdateAdminEmailEreaderDevicesRequestCopyWith(UpdateAdminEmailEreaderDevicesRequest value, $Res Function(UpdateAdminEmailEreaderDevicesRequest) _then) = _$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> ereaderDevices
});




}
/// @nodoc
class _$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl<$Res>
    implements $UpdateAdminEmailEreaderDevicesRequestCopyWith<$Res> {
  _$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl(this._self, this._then);

  final UpdateAdminEmailEreaderDevicesRequest _self;
  final $Res Function(UpdateAdminEmailEreaderDevicesRequest) _then;

/// Create a copy of UpdateAdminEmailEreaderDevicesRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ereaderDevices = null,}) {
  return _then(_self.copyWith(
ereaderDevices: null == ereaderDevices ? _self.ereaderDevices : ereaderDevices // ignore: cast_nullable_to_non_nullable
as List<AdminEmailEreaderDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAdminEmailEreaderDevicesRequest].
extension UpdateAdminEmailEreaderDevicesRequestPatterns on UpdateAdminEmailEreaderDevicesRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAdminEmailEreaderDevicesRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAdminEmailEreaderDevicesRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAdminEmailEreaderDevicesRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminEmailEreaderDevicesRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAdminEmailEreaderDevicesRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminEmailEreaderDevicesRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'ereaderDevices')  List<AdminEmailEreaderDevice> ereaderDevices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAdminEmailEreaderDevicesRequest() when $default != null:
return $default(_that.ereaderDevices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'ereaderDevices')  List<AdminEmailEreaderDevice> ereaderDevices)  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminEmailEreaderDevicesRequest():
return $default(_that.ereaderDevices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'ereaderDevices')  List<AdminEmailEreaderDevice> ereaderDevices)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminEmailEreaderDevicesRequest() when $default != null:
return $default(_that.ereaderDevices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAdminEmailEreaderDevicesRequest implements UpdateAdminEmailEreaderDevicesRequest {
  const _UpdateAdminEmailEreaderDevicesRequest({@JsonKey(name: 'ereaderDevices') final  List<AdminEmailEreaderDevice> ereaderDevices = const <AdminEmailEreaderDevice>[]}): _ereaderDevices = ereaderDevices;
  factory _UpdateAdminEmailEreaderDevicesRequest.fromJson(Map<String, dynamic> json) => _$UpdateAdminEmailEreaderDevicesRequestFromJson(json);

 final  List<AdminEmailEreaderDevice> _ereaderDevices;
@override@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> get ereaderDevices {
  if (_ereaderDevices is EqualUnmodifiableListView) return _ereaderDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ereaderDevices);
}


/// Create a copy of UpdateAdminEmailEreaderDevicesRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAdminEmailEreaderDevicesRequestCopyWith<_UpdateAdminEmailEreaderDevicesRequest> get copyWith => __$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl<_UpdateAdminEmailEreaderDevicesRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAdminEmailEreaderDevicesRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAdminEmailEreaderDevicesRequest&&const DeepCollectionEquality().equals(other._ereaderDevices, _ereaderDevices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ereaderDevices));

@override
String toString() {
  return 'UpdateAdminEmailEreaderDevicesRequest(ereaderDevices: $ereaderDevices)';
}


}

/// @nodoc
abstract mixin class _$UpdateAdminEmailEreaderDevicesRequestCopyWith<$Res> implements $UpdateAdminEmailEreaderDevicesRequestCopyWith<$Res> {
  factory _$UpdateAdminEmailEreaderDevicesRequestCopyWith(_UpdateAdminEmailEreaderDevicesRequest value, $Res Function(_UpdateAdminEmailEreaderDevicesRequest) _then) = __$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> ereaderDevices
});




}
/// @nodoc
class __$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl<$Res>
    implements _$UpdateAdminEmailEreaderDevicesRequestCopyWith<$Res> {
  __$UpdateAdminEmailEreaderDevicesRequestCopyWithImpl(this._self, this._then);

  final _UpdateAdminEmailEreaderDevicesRequest _self;
  final $Res Function(_UpdateAdminEmailEreaderDevicesRequest) _then;

/// Create a copy of UpdateAdminEmailEreaderDevicesRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ereaderDevices = null,}) {
  return _then(_UpdateAdminEmailEreaderDevicesRequest(
ereaderDevices: null == ereaderDevices ? _self._ereaderDevices : ereaderDevices // ignore: cast_nullable_to_non_nullable
as List<AdminEmailEreaderDevice>,
  ));
}


}

// dart format on
