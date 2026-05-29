// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_api_keys_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminApiKeysResponse {

@JsonKey(name: 'apiKeys') List<AdminApiKey> get apiKeys;
/// Create a copy of AdminApiKeysResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminApiKeysResponseCopyWith<AdminApiKeysResponse> get copyWith => _$AdminApiKeysResponseCopyWithImpl<AdminApiKeysResponse>(this as AdminApiKeysResponse, _$identity);

  /// Serializes this AdminApiKeysResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminApiKeysResponse&&const DeepCollectionEquality().equals(other.apiKeys, apiKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(apiKeys));

@override
String toString() {
  return 'AdminApiKeysResponse(apiKeys: $apiKeys)';
}


}

/// @nodoc
abstract mixin class $AdminApiKeysResponseCopyWith<$Res>  {
  factory $AdminApiKeysResponseCopyWith(AdminApiKeysResponse value, $Res Function(AdminApiKeysResponse) _then) = _$AdminApiKeysResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'apiKeys') List<AdminApiKey> apiKeys
});




}
/// @nodoc
class _$AdminApiKeysResponseCopyWithImpl<$Res>
    implements $AdminApiKeysResponseCopyWith<$Res> {
  _$AdminApiKeysResponseCopyWithImpl(this._self, this._then);

  final AdminApiKeysResponse _self;
  final $Res Function(AdminApiKeysResponse) _then;

/// Create a copy of AdminApiKeysResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? apiKeys = null,}) {
  return _then(_self.copyWith(
apiKeys: null == apiKeys ? _self.apiKeys : apiKeys // ignore: cast_nullable_to_non_nullable
as List<AdminApiKey>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminApiKeysResponse].
extension AdminApiKeysResponsePatterns on AdminApiKeysResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminApiKeysResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminApiKeysResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminApiKeysResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminApiKeysResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminApiKeysResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminApiKeysResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'apiKeys')  List<AdminApiKey> apiKeys)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminApiKeysResponse() when $default != null:
return $default(_that.apiKeys);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'apiKeys')  List<AdminApiKey> apiKeys)  $default,) {final _that = this;
switch (_that) {
case _AdminApiKeysResponse():
return $default(_that.apiKeys);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'apiKeys')  List<AdminApiKey> apiKeys)?  $default,) {final _that = this;
switch (_that) {
case _AdminApiKeysResponse() when $default != null:
return $default(_that.apiKeys);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminApiKeysResponse implements AdminApiKeysResponse {
  const _AdminApiKeysResponse({@JsonKey(name: 'apiKeys') final  List<AdminApiKey> apiKeys = const <AdminApiKey>[]}): _apiKeys = apiKeys;
  factory _AdminApiKeysResponse.fromJson(Map<String, dynamic> json) => _$AdminApiKeysResponseFromJson(json);

 final  List<AdminApiKey> _apiKeys;
@override@JsonKey(name: 'apiKeys') List<AdminApiKey> get apiKeys {
  if (_apiKeys is EqualUnmodifiableListView) return _apiKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_apiKeys);
}


/// Create a copy of AdminApiKeysResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminApiKeysResponseCopyWith<_AdminApiKeysResponse> get copyWith => __$AdminApiKeysResponseCopyWithImpl<_AdminApiKeysResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminApiKeysResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminApiKeysResponse&&const DeepCollectionEquality().equals(other._apiKeys, _apiKeys));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_apiKeys));

@override
String toString() {
  return 'AdminApiKeysResponse(apiKeys: $apiKeys)';
}


}

/// @nodoc
abstract mixin class _$AdminApiKeysResponseCopyWith<$Res> implements $AdminApiKeysResponseCopyWith<$Res> {
  factory _$AdminApiKeysResponseCopyWith(_AdminApiKeysResponse value, $Res Function(_AdminApiKeysResponse) _then) = __$AdminApiKeysResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'apiKeys') List<AdminApiKey> apiKeys
});




}
/// @nodoc
class __$AdminApiKeysResponseCopyWithImpl<$Res>
    implements _$AdminApiKeysResponseCopyWith<$Res> {
  __$AdminApiKeysResponseCopyWithImpl(this._self, this._then);

  final _AdminApiKeysResponse _self;
  final $Res Function(_AdminApiKeysResponse) _then;

/// Create a copy of AdminApiKeysResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? apiKeys = null,}) {
  return _then(_AdminApiKeysResponse(
apiKeys: null == apiKeys ? _self._apiKeys : apiKeys // ignore: cast_nullable_to_non_nullable
as List<AdminApiKey>,
  ));
}


}

// dart format on
