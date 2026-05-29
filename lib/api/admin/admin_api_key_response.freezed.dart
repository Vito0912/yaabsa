// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_api_key_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminApiKeyResponse {

@JsonKey(name: 'apiKey') AdminApiKey get apiKey;
/// Create a copy of AdminApiKeyResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminApiKeyResponseCopyWith<AdminApiKeyResponse> get copyWith => _$AdminApiKeyResponseCopyWithImpl<AdminApiKeyResponse>(this as AdminApiKeyResponse, _$identity);

  /// Serializes this AdminApiKeyResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminApiKeyResponse&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,apiKey);

@override
String toString() {
  return 'AdminApiKeyResponse(apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class $AdminApiKeyResponseCopyWith<$Res>  {
  factory $AdminApiKeyResponseCopyWith(AdminApiKeyResponse value, $Res Function(AdminApiKeyResponse) _then) = _$AdminApiKeyResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'apiKey') AdminApiKey apiKey
});


$AdminApiKeyCopyWith<$Res> get apiKey;

}
/// @nodoc
class _$AdminApiKeyResponseCopyWithImpl<$Res>
    implements $AdminApiKeyResponseCopyWith<$Res> {
  _$AdminApiKeyResponseCopyWithImpl(this._self, this._then);

  final AdminApiKeyResponse _self;
  final $Res Function(AdminApiKeyResponse) _then;

/// Create a copy of AdminApiKeyResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiKey = null,}) {
  return _then(_self.copyWith(
apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as AdminApiKey,
  ));
}
/// Create a copy of AdminApiKeyResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminApiKeyCopyWith<$Res> get apiKey {
  
  return $AdminApiKeyCopyWith<$Res>(_self.apiKey, (value) {
    return _then(_self.copyWith(apiKey: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminApiKeyResponse].
extension AdminApiKeyResponsePatterns on AdminApiKeyResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminApiKeyResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminApiKeyResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminApiKeyResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminApiKeyResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminApiKeyResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminApiKeyResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'apiKey')  AdminApiKey apiKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminApiKeyResponse() when $default != null:
return $default(_that.apiKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'apiKey')  AdminApiKey apiKey)  $default,) {final _that = this;
switch (_that) {
case _AdminApiKeyResponse():
return $default(_that.apiKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'apiKey')  AdminApiKey apiKey)?  $default,) {final _that = this;
switch (_that) {
case _AdminApiKeyResponse() when $default != null:
return $default(_that.apiKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminApiKeyResponse implements AdminApiKeyResponse {
  const _AdminApiKeyResponse({@JsonKey(name: 'apiKey') required this.apiKey});
  factory _AdminApiKeyResponse.fromJson(Map<String, dynamic> json) => _$AdminApiKeyResponseFromJson(json);

@override@JsonKey(name: 'apiKey') final  AdminApiKey apiKey;

/// Create a copy of AdminApiKeyResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminApiKeyResponseCopyWith<_AdminApiKeyResponse> get copyWith => __$AdminApiKeyResponseCopyWithImpl<_AdminApiKeyResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminApiKeyResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminApiKeyResponse&&(identical(other.apiKey, apiKey) || other.apiKey == apiKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,apiKey);

@override
String toString() {
  return 'AdminApiKeyResponse(apiKey: $apiKey)';
}


}

/// @nodoc
abstract mixin class _$AdminApiKeyResponseCopyWith<$Res> implements $AdminApiKeyResponseCopyWith<$Res> {
  factory _$AdminApiKeyResponseCopyWith(_AdminApiKeyResponse value, $Res Function(_AdminApiKeyResponse) _then) = __$AdminApiKeyResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'apiKey') AdminApiKey apiKey
});


@override $AdminApiKeyCopyWith<$Res> get apiKey;

}
/// @nodoc
class __$AdminApiKeyResponseCopyWithImpl<$Res>
    implements _$AdminApiKeyResponseCopyWith<$Res> {
  __$AdminApiKeyResponseCopyWithImpl(this._self, this._then);

  final _AdminApiKeyResponse _self;
  final $Res Function(_AdminApiKeyResponse) _then;

/// Create a copy of AdminApiKeyResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiKey = null,}) {
  return _then(_AdminApiKeyResponse(
apiKey: null == apiKey ? _self.apiKey : apiKey // ignore: cast_nullable_to_non_nullable
as AdminApiKey,
  ));
}

/// Create a copy of AdminApiKeyResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminApiKeyCopyWith<$Res> get apiKey {
  
  return $AdminApiKeyCopyWith<$Res>(_self.apiKey, (value) {
    return _then(_self.copyWith(apiKey: value));
  });
}
}

// dart format on
