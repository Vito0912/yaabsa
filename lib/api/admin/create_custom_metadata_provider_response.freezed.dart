// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_custom_metadata_provider_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateCustomMetadataProviderResponse {

@JsonKey(name: 'provider', fromJson: _providerFromJson) CustomMetadataProvider? get provider;
/// Create a copy of CreateCustomMetadataProviderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCustomMetadataProviderResponseCopyWith<CreateCustomMetadataProviderResponse> get copyWith => _$CreateCustomMetadataProviderResponseCopyWithImpl<CreateCustomMetadataProviderResponse>(this as CreateCustomMetadataProviderResponse, _$identity);

  /// Serializes this CreateCustomMetadataProviderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCustomMetadataProviderResponse&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider);

@override
String toString() {
  return 'CreateCustomMetadataProviderResponse(provider: $provider)';
}


}

/// @nodoc
abstract mixin class $CreateCustomMetadataProviderResponseCopyWith<$Res>  {
  factory $CreateCustomMetadataProviderResponseCopyWith(CreateCustomMetadataProviderResponse value, $Res Function(CreateCustomMetadataProviderResponse) _then) = _$CreateCustomMetadataProviderResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'provider', fromJson: _providerFromJson) CustomMetadataProvider? provider
});


$CustomMetadataProviderCopyWith<$Res>? get provider;

}
/// @nodoc
class _$CreateCustomMetadataProviderResponseCopyWithImpl<$Res>
    implements $CreateCustomMetadataProviderResponseCopyWith<$Res> {
  _$CreateCustomMetadataProviderResponseCopyWithImpl(this._self, this._then);

  final CreateCustomMetadataProviderResponse _self;
  final $Res Function(CreateCustomMetadataProviderResponse) _then;

/// Create a copy of CreateCustomMetadataProviderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = freezed,}) {
  return _then(_self.copyWith(
provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as CustomMetadataProvider?,
  ));
}
/// Create a copy of CreateCustomMetadataProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomMetadataProviderCopyWith<$Res>? get provider {
    if (_self.provider == null) {
    return null;
  }

  return $CustomMetadataProviderCopyWith<$Res>(_self.provider!, (value) {
    return _then(_self.copyWith(provider: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateCustomMetadataProviderResponse].
extension CreateCustomMetadataProviderResponsePatterns on CreateCustomMetadataProviderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCustomMetadataProviderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCustomMetadataProviderResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCustomMetadataProviderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider', fromJson: _providerFromJson)  CustomMetadataProvider? provider)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderResponse() when $default != null:
return $default(_that.provider);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider', fromJson: _providerFromJson)  CustomMetadataProvider? provider)  $default,) {final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderResponse():
return $default(_that.provider);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'provider', fromJson: _providerFromJson)  CustomMetadataProvider? provider)?  $default,) {final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderResponse() when $default != null:
return $default(_that.provider);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCustomMetadataProviderResponse implements CreateCustomMetadataProviderResponse {
  const _CreateCustomMetadataProviderResponse({@JsonKey(name: 'provider', fromJson: _providerFromJson) this.provider});
  factory _CreateCustomMetadataProviderResponse.fromJson(Map<String, dynamic> json) => _$CreateCustomMetadataProviderResponseFromJson(json);

@override@JsonKey(name: 'provider', fromJson: _providerFromJson) final  CustomMetadataProvider? provider;

/// Create a copy of CreateCustomMetadataProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCustomMetadataProviderResponseCopyWith<_CreateCustomMetadataProviderResponse> get copyWith => __$CreateCustomMetadataProviderResponseCopyWithImpl<_CreateCustomMetadataProviderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCustomMetadataProviderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCustomMetadataProviderResponse&&(identical(other.provider, provider) || other.provider == provider));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider);

@override
String toString() {
  return 'CreateCustomMetadataProviderResponse(provider: $provider)';
}


}

/// @nodoc
abstract mixin class _$CreateCustomMetadataProviderResponseCopyWith<$Res> implements $CreateCustomMetadataProviderResponseCopyWith<$Res> {
  factory _$CreateCustomMetadataProviderResponseCopyWith(_CreateCustomMetadataProviderResponse value, $Res Function(_CreateCustomMetadataProviderResponse) _then) = __$CreateCustomMetadataProviderResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'provider', fromJson: _providerFromJson) CustomMetadataProvider? provider
});


@override $CustomMetadataProviderCopyWith<$Res>? get provider;

}
/// @nodoc
class __$CreateCustomMetadataProviderResponseCopyWithImpl<$Res>
    implements _$CreateCustomMetadataProviderResponseCopyWith<$Res> {
  __$CreateCustomMetadataProviderResponseCopyWithImpl(this._self, this._then);

  final _CreateCustomMetadataProviderResponse _self;
  final $Res Function(_CreateCustomMetadataProviderResponse) _then;

/// Create a copy of CreateCustomMetadataProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = freezed,}) {
  return _then(_CreateCustomMetadataProviderResponse(
provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as CustomMetadataProvider?,
  ));
}

/// Create a copy of CreateCustomMetadataProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CustomMetadataProviderCopyWith<$Res>? get provider {
    if (_self.provider == null) {
    return null;
  }

  return $CustomMetadataProviderCopyWith<$Res>(_self.provider!, (value) {
    return _then(_self.copyWith(provider: value));
  });
}
}

// dart format on
