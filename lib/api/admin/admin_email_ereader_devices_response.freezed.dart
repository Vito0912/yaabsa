// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_email_ereader_devices_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminEmailEreaderDevicesResponse {

@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> get ereaderDevices;
/// Create a copy of AdminEmailEreaderDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminEmailEreaderDevicesResponseCopyWith<AdminEmailEreaderDevicesResponse> get copyWith => _$AdminEmailEreaderDevicesResponseCopyWithImpl<AdminEmailEreaderDevicesResponse>(this as AdminEmailEreaderDevicesResponse, _$identity);

  /// Serializes this AdminEmailEreaderDevicesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminEmailEreaderDevicesResponse&&const DeepCollectionEquality().equals(other.ereaderDevices, ereaderDevices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(ereaderDevices));

@override
String toString() {
  return 'AdminEmailEreaderDevicesResponse(ereaderDevices: $ereaderDevices)';
}


}

/// @nodoc
abstract mixin class $AdminEmailEreaderDevicesResponseCopyWith<$Res>  {
  factory $AdminEmailEreaderDevicesResponseCopyWith(AdminEmailEreaderDevicesResponse value, $Res Function(AdminEmailEreaderDevicesResponse) _then) = _$AdminEmailEreaderDevicesResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> ereaderDevices
});




}
/// @nodoc
class _$AdminEmailEreaderDevicesResponseCopyWithImpl<$Res>
    implements $AdminEmailEreaderDevicesResponseCopyWith<$Res> {
  _$AdminEmailEreaderDevicesResponseCopyWithImpl(this._self, this._then);

  final AdminEmailEreaderDevicesResponse _self;
  final $Res Function(AdminEmailEreaderDevicesResponse) _then;

/// Create a copy of AdminEmailEreaderDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ereaderDevices = null,}) {
  return _then(_self.copyWith(
ereaderDevices: null == ereaderDevices ? _self.ereaderDevices : ereaderDevices // ignore: cast_nullable_to_non_nullable
as List<AdminEmailEreaderDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminEmailEreaderDevicesResponse].
extension AdminEmailEreaderDevicesResponsePatterns on AdminEmailEreaderDevicesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminEmailEreaderDevicesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminEmailEreaderDevicesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminEmailEreaderDevicesResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminEmailEreaderDevicesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminEmailEreaderDevicesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminEmailEreaderDevicesResponse() when $default != null:
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
case _AdminEmailEreaderDevicesResponse() when $default != null:
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
case _AdminEmailEreaderDevicesResponse():
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
case _AdminEmailEreaderDevicesResponse() when $default != null:
return $default(_that.ereaderDevices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminEmailEreaderDevicesResponse implements AdminEmailEreaderDevicesResponse {
  const _AdminEmailEreaderDevicesResponse({@JsonKey(name: 'ereaderDevices') final  List<AdminEmailEreaderDevice> ereaderDevices = const <AdminEmailEreaderDevice>[]}): _ereaderDevices = ereaderDevices;
  factory _AdminEmailEreaderDevicesResponse.fromJson(Map<String, dynamic> json) => _$AdminEmailEreaderDevicesResponseFromJson(json);

 final  List<AdminEmailEreaderDevice> _ereaderDevices;
@override@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> get ereaderDevices {
  if (_ereaderDevices is EqualUnmodifiableListView) return _ereaderDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ereaderDevices);
}


/// Create a copy of AdminEmailEreaderDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminEmailEreaderDevicesResponseCopyWith<_AdminEmailEreaderDevicesResponse> get copyWith => __$AdminEmailEreaderDevicesResponseCopyWithImpl<_AdminEmailEreaderDevicesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminEmailEreaderDevicesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminEmailEreaderDevicesResponse&&const DeepCollectionEquality().equals(other._ereaderDevices, _ereaderDevices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_ereaderDevices));

@override
String toString() {
  return 'AdminEmailEreaderDevicesResponse(ereaderDevices: $ereaderDevices)';
}


}

/// @nodoc
abstract mixin class _$AdminEmailEreaderDevicesResponseCopyWith<$Res> implements $AdminEmailEreaderDevicesResponseCopyWith<$Res> {
  factory _$AdminEmailEreaderDevicesResponseCopyWith(_AdminEmailEreaderDevicesResponse value, $Res Function(_AdminEmailEreaderDevicesResponse) _then) = __$AdminEmailEreaderDevicesResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> ereaderDevices
});




}
/// @nodoc
class __$AdminEmailEreaderDevicesResponseCopyWithImpl<$Res>
    implements _$AdminEmailEreaderDevicesResponseCopyWith<$Res> {
  __$AdminEmailEreaderDevicesResponseCopyWithImpl(this._self, this._then);

  final _AdminEmailEreaderDevicesResponse _self;
  final $Res Function(_AdminEmailEreaderDevicesResponse) _then;

/// Create a copy of AdminEmailEreaderDevicesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ereaderDevices = null,}) {
  return _then(_AdminEmailEreaderDevicesResponse(
ereaderDevices: null == ereaderDevices ? _self._ereaderDevices : ereaderDevices // ignore: cast_nullable_to_non_nullable
as List<AdminEmailEreaderDevice>,
  ));
}


}

// dart format on
