// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_custom_metadata_provider_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateCustomMetadataProviderRequest {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'url') String get url;@JsonKey(name: 'mediaType') String get mediaType;@JsonKey(name: 'authHeaderValue') String? get authHeaderValue;
/// Create a copy of CreateCustomMetadataProviderRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateCustomMetadataProviderRequestCopyWith<CreateCustomMetadataProviderRequest> get copyWith => _$CreateCustomMetadataProviderRequestCopyWithImpl<CreateCustomMetadataProviderRequest>(this as CreateCustomMetadataProviderRequest, _$identity);

  /// Serializes this CreateCustomMetadataProviderRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateCustomMetadataProviderRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.authHeaderValue, authHeaderValue) || other.authHeaderValue == authHeaderValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,mediaType,authHeaderValue);

@override
String toString() {
  return 'CreateCustomMetadataProviderRequest(name: $name, url: $url, mediaType: $mediaType, authHeaderValue: $authHeaderValue)';
}


}

/// @nodoc
abstract mixin class $CreateCustomMetadataProviderRequestCopyWith<$Res>  {
  factory $CreateCustomMetadataProviderRequestCopyWith(CreateCustomMetadataProviderRequest value, $Res Function(CreateCustomMetadataProviderRequest) _then) = _$CreateCustomMetadataProviderRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'url') String url,@JsonKey(name: 'mediaType') String mediaType,@JsonKey(name: 'authHeaderValue') String? authHeaderValue
});




}
/// @nodoc
class _$CreateCustomMetadataProviderRequestCopyWithImpl<$Res>
    implements $CreateCustomMetadataProviderRequestCopyWith<$Res> {
  _$CreateCustomMetadataProviderRequestCopyWithImpl(this._self, this._then);

  final CreateCustomMetadataProviderRequest _self;
  final $Res Function(CreateCustomMetadataProviderRequest) _then;

/// Create a copy of CreateCustomMetadataProviderRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? url = null,Object? mediaType = null,Object? authHeaderValue = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,authHeaderValue: freezed == authHeaderValue ? _self.authHeaderValue : authHeaderValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateCustomMetadataProviderRequest].
extension CreateCustomMetadataProviderRequestPatterns on CreateCustomMetadataProviderRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateCustomMetadataProviderRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateCustomMetadataProviderRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateCustomMetadataProviderRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'url')  String url, @JsonKey(name: 'mediaType')  String mediaType, @JsonKey(name: 'authHeaderValue')  String? authHeaderValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderRequest() when $default != null:
return $default(_that.name,_that.url,_that.mediaType,_that.authHeaderValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'url')  String url, @JsonKey(name: 'mediaType')  String mediaType, @JsonKey(name: 'authHeaderValue')  String? authHeaderValue)  $default,) {final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderRequest():
return $default(_that.name,_that.url,_that.mediaType,_that.authHeaderValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'url')  String url, @JsonKey(name: 'mediaType')  String mediaType, @JsonKey(name: 'authHeaderValue')  String? authHeaderValue)?  $default,) {final _that = this;
switch (_that) {
case _CreateCustomMetadataProviderRequest() when $default != null:
return $default(_that.name,_that.url,_that.mediaType,_that.authHeaderValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateCustomMetadataProviderRequest implements CreateCustomMetadataProviderRequest {
  const _CreateCustomMetadataProviderRequest({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'url') required this.url, @JsonKey(name: 'mediaType') required this.mediaType, @JsonKey(name: 'authHeaderValue') this.authHeaderValue});
  factory _CreateCustomMetadataProviderRequest.fromJson(Map<String, dynamic> json) => _$CreateCustomMetadataProviderRequestFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'url') final  String url;
@override@JsonKey(name: 'mediaType') final  String mediaType;
@override@JsonKey(name: 'authHeaderValue') final  String? authHeaderValue;

/// Create a copy of CreateCustomMetadataProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateCustomMetadataProviderRequestCopyWith<_CreateCustomMetadataProviderRequest> get copyWith => __$CreateCustomMetadataProviderRequestCopyWithImpl<_CreateCustomMetadataProviderRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateCustomMetadataProviderRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateCustomMetadataProviderRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.authHeaderValue, authHeaderValue) || other.authHeaderValue == authHeaderValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,url,mediaType,authHeaderValue);

@override
String toString() {
  return 'CreateCustomMetadataProviderRequest(name: $name, url: $url, mediaType: $mediaType, authHeaderValue: $authHeaderValue)';
}


}

/// @nodoc
abstract mixin class _$CreateCustomMetadataProviderRequestCopyWith<$Res> implements $CreateCustomMetadataProviderRequestCopyWith<$Res> {
  factory _$CreateCustomMetadataProviderRequestCopyWith(_CreateCustomMetadataProviderRequest value, $Res Function(_CreateCustomMetadataProviderRequest) _then) = __$CreateCustomMetadataProviderRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'url') String url,@JsonKey(name: 'mediaType') String mediaType,@JsonKey(name: 'authHeaderValue') String? authHeaderValue
});




}
/// @nodoc
class __$CreateCustomMetadataProviderRequestCopyWithImpl<$Res>
    implements _$CreateCustomMetadataProviderRequestCopyWith<$Res> {
  __$CreateCustomMetadataProviderRequestCopyWithImpl(this._self, this._then);

  final _CreateCustomMetadataProviderRequest _self;
  final $Res Function(_CreateCustomMetadataProviderRequest) _then;

/// Create a copy of CreateCustomMetadataProviderRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? url = null,Object? mediaType = null,Object? authHeaderValue = freezed,}) {
  return _then(_CreateCustomMetadataProviderRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,authHeaderValue: freezed == authHeaderValue ? _self.authHeaderValue : authHeaderValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
