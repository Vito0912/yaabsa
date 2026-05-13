// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_metadata_providers_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomMetadataProvidersResponse {

@JsonKey(name: 'providers', fromJson: _providersFromJson) List<CustomMetadataProvider> get providers;
/// Create a copy of CustomMetadataProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomMetadataProvidersResponseCopyWith<CustomMetadataProvidersResponse> get copyWith => _$CustomMetadataProvidersResponseCopyWithImpl<CustomMetadataProvidersResponse>(this as CustomMetadataProvidersResponse, _$identity);

  /// Serializes this CustomMetadataProvidersResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomMetadataProvidersResponse&&const DeepCollectionEquality().equals(other.providers, providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(providers));

@override
String toString() {
  return 'CustomMetadataProvidersResponse(providers: $providers)';
}


}

/// @nodoc
abstract mixin class $CustomMetadataProvidersResponseCopyWith<$Res>  {
  factory $CustomMetadataProvidersResponseCopyWith(CustomMetadataProvidersResponse value, $Res Function(CustomMetadataProvidersResponse) _then) = _$CustomMetadataProvidersResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'providers', fromJson: _providersFromJson) List<CustomMetadataProvider> providers
});




}
/// @nodoc
class _$CustomMetadataProvidersResponseCopyWithImpl<$Res>
    implements $CustomMetadataProvidersResponseCopyWith<$Res> {
  _$CustomMetadataProvidersResponseCopyWithImpl(this._self, this._then);

  final CustomMetadataProvidersResponse _self;
  final $Res Function(CustomMetadataProvidersResponse) _then;

/// Create a copy of CustomMetadataProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providers = null,}) {
  return _then(_self.copyWith(
providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as List<CustomMetadataProvider>,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomMetadataProvidersResponse].
extension CustomMetadataProvidersResponsePatterns on CustomMetadataProvidersResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomMetadataProvidersResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomMetadataProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomMetadataProvidersResponse value)  $default,){
final _that = this;
switch (_that) {
case _CustomMetadataProvidersResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomMetadataProvidersResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CustomMetadataProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'providers', fromJson: _providersFromJson)  List<CustomMetadataProvider> providers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomMetadataProvidersResponse() when $default != null:
return $default(_that.providers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'providers', fromJson: _providersFromJson)  List<CustomMetadataProvider> providers)  $default,) {final _that = this;
switch (_that) {
case _CustomMetadataProvidersResponse():
return $default(_that.providers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'providers', fromJson: _providersFromJson)  List<CustomMetadataProvider> providers)?  $default,) {final _that = this;
switch (_that) {
case _CustomMetadataProvidersResponse() when $default != null:
return $default(_that.providers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomMetadataProvidersResponse implements CustomMetadataProvidersResponse {
  const _CustomMetadataProvidersResponse({@JsonKey(name: 'providers', fromJson: _providersFromJson) final  List<CustomMetadataProvider> providers = const <CustomMetadataProvider>[]}): _providers = providers;
  factory _CustomMetadataProvidersResponse.fromJson(Map<String, dynamic> json) => _$CustomMetadataProvidersResponseFromJson(json);

 final  List<CustomMetadataProvider> _providers;
@override@JsonKey(name: 'providers', fromJson: _providersFromJson) List<CustomMetadataProvider> get providers {
  if (_providers is EqualUnmodifiableListView) return _providers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_providers);
}


/// Create a copy of CustomMetadataProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomMetadataProvidersResponseCopyWith<_CustomMetadataProvidersResponse> get copyWith => __$CustomMetadataProvidersResponseCopyWithImpl<_CustomMetadataProvidersResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomMetadataProvidersResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomMetadataProvidersResponse&&const DeepCollectionEquality().equals(other._providers, _providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_providers));

@override
String toString() {
  return 'CustomMetadataProvidersResponse(providers: $providers)';
}


}

/// @nodoc
abstract mixin class _$CustomMetadataProvidersResponseCopyWith<$Res> implements $CustomMetadataProvidersResponseCopyWith<$Res> {
  factory _$CustomMetadataProvidersResponseCopyWith(_CustomMetadataProvidersResponse value, $Res Function(_CustomMetadataProvidersResponse) _then) = __$CustomMetadataProvidersResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'providers', fromJson: _providersFromJson) List<CustomMetadataProvider> providers
});




}
/// @nodoc
class __$CustomMetadataProvidersResponseCopyWithImpl<$Res>
    implements _$CustomMetadataProvidersResponseCopyWith<$Res> {
  __$CustomMetadataProvidersResponseCopyWithImpl(this._self, this._then);

  final _CustomMetadataProvidersResponse _self;
  final $Res Function(_CustomMetadataProvidersResponse) _then;

/// Create a copy of CustomMetadataProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providers = null,}) {
  return _then(_CustomMetadataProvidersResponse(
providers: null == providers ? _self._providers : providers // ignore: cast_nullable_to_non_nullable
as List<CustomMetadataProvider>,
  ));
}


}

// dart format on
