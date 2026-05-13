// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_providers_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchProvidersResponse {

@JsonKey(name: 'providers') SearchProviders get providers;
/// Create a copy of SearchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchProvidersResponseCopyWith<SearchProvidersResponse> get copyWith => _$SearchProvidersResponseCopyWithImpl<SearchProvidersResponse>(this as SearchProvidersResponse, _$identity);

  /// Serializes this SearchProvidersResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchProvidersResponse&&(identical(other.providers, providers) || other.providers == providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providers);

@override
String toString() {
  return 'SearchProvidersResponse(providers: $providers)';
}


}

/// @nodoc
abstract mixin class $SearchProvidersResponseCopyWith<$Res>  {
  factory $SearchProvidersResponseCopyWith(SearchProvidersResponse value, $Res Function(SearchProvidersResponse) _then) = _$SearchProvidersResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'providers') SearchProviders providers
});


$SearchProvidersCopyWith<$Res> get providers;

}
/// @nodoc
class _$SearchProvidersResponseCopyWithImpl<$Res>
    implements $SearchProvidersResponseCopyWith<$Res> {
  _$SearchProvidersResponseCopyWithImpl(this._self, this._then);

  final SearchProvidersResponse _self;
  final $Res Function(SearchProvidersResponse) _then;

/// Create a copy of SearchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? providers = null,}) {
  return _then(_self.copyWith(
providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as SearchProviders,
  ));
}
/// Create a copy of SearchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchProvidersCopyWith<$Res> get providers {
  
  return $SearchProvidersCopyWith<$Res>(_self.providers, (value) {
    return _then(_self.copyWith(providers: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchProvidersResponse].
extension SearchProvidersResponsePatterns on SearchProvidersResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchProvidersResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchProvidersResponse value)  $default,){
final _that = this;
switch (_that) {
case _SearchProvidersResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchProvidersResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SearchProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'providers')  SearchProviders providers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchProvidersResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'providers')  SearchProviders providers)  $default,) {final _that = this;
switch (_that) {
case _SearchProvidersResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'providers')  SearchProviders providers)?  $default,) {final _that = this;
switch (_that) {
case _SearchProvidersResponse() when $default != null:
return $default(_that.providers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchProvidersResponse implements SearchProvidersResponse {
  const _SearchProvidersResponse({@JsonKey(name: 'providers') required this.providers});
  factory _SearchProvidersResponse.fromJson(Map<String, dynamic> json) => _$SearchProvidersResponseFromJson(json);

@override@JsonKey(name: 'providers') final  SearchProviders providers;

/// Create a copy of SearchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchProvidersResponseCopyWith<_SearchProvidersResponse> get copyWith => __$SearchProvidersResponseCopyWithImpl<_SearchProvidersResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchProvidersResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchProvidersResponse&&(identical(other.providers, providers) || other.providers == providers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,providers);

@override
String toString() {
  return 'SearchProvidersResponse(providers: $providers)';
}


}

/// @nodoc
abstract mixin class _$SearchProvidersResponseCopyWith<$Res> implements $SearchProvidersResponseCopyWith<$Res> {
  factory _$SearchProvidersResponseCopyWith(_SearchProvidersResponse value, $Res Function(_SearchProvidersResponse) _then) = __$SearchProvidersResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'providers') SearchProviders providers
});


@override $SearchProvidersCopyWith<$Res> get providers;

}
/// @nodoc
class __$SearchProvidersResponseCopyWithImpl<$Res>
    implements _$SearchProvidersResponseCopyWith<$Res> {
  __$SearchProvidersResponseCopyWithImpl(this._self, this._then);

  final _SearchProvidersResponse _self;
  final $Res Function(_SearchProvidersResponse) _then;

/// Create a copy of SearchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? providers = null,}) {
  return _then(_SearchProvidersResponse(
providers: null == providers ? _self.providers : providers // ignore: cast_nullable_to_non_nullable
as SearchProviders,
  ));
}

/// Create a copy of SearchProvidersResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchProvidersCopyWith<$Res> get providers {
  
  return $SearchProvidersCopyWith<$Res>(_self.providers, (value) {
    return _then(_self.copyWith(providers: value));
  });
}
}

// dart format on
