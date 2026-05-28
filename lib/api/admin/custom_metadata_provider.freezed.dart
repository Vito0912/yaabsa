// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'custom_metadata_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CustomMetadataProvider {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'mediaType') String get mediaType;@JsonKey(name: 'url') String get url;@JsonKey(name: 'authHeaderValue') String? get authHeaderValue;@JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic) int get createdAt;@JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic) int get updatedAt;
/// Create a copy of CustomMetadataProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomMetadataProviderCopyWith<CustomMetadataProvider> get copyWith => _$CustomMetadataProviderCopyWithImpl<CustomMetadataProvider>(this as CustomMetadataProvider, _$identity);

  /// Serializes this CustomMetadataProvider to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomMetadataProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.url, url) || other.url == url)&&(identical(other.authHeaderValue, authHeaderValue) || other.authHeaderValue == authHeaderValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mediaType,url,authHeaderValue,createdAt,updatedAt);

@override
String toString() {
  return 'CustomMetadataProvider(id: $id, name: $name, mediaType: $mediaType, url: $url, authHeaderValue: $authHeaderValue, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CustomMetadataProviderCopyWith<$Res>  {
  factory $CustomMetadataProviderCopyWith(CustomMetadataProvider value, $Res Function(CustomMetadataProvider) _then) = _$CustomMetadataProviderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'mediaType') String mediaType,@JsonKey(name: 'url') String url,@JsonKey(name: 'authHeaderValue') String? authHeaderValue,@JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic) int createdAt,@JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic) int updatedAt
});




}
/// @nodoc
class _$CustomMetadataProviderCopyWithImpl<$Res>
    implements $CustomMetadataProviderCopyWith<$Res> {
  _$CustomMetadataProviderCopyWithImpl(this._self, this._then);

  final CustomMetadataProvider _self;
  final $Res Function(CustomMetadataProvider) _then;

/// Create a copy of CustomMetadataProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? mediaType = null,Object? url = null,Object? authHeaderValue = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,authHeaderValue: freezed == authHeaderValue ? _self.authHeaderValue : authHeaderValue // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomMetadataProvider].
extension CustomMetadataProviderPatterns on CustomMetadataProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomMetadataProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomMetadataProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomMetadataProvider value)  $default,){
final _that = this;
switch (_that) {
case _CustomMetadataProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomMetadataProvider value)?  $default,){
final _that = this;
switch (_that) {
case _CustomMetadataProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'mediaType')  String mediaType, @JsonKey(name: 'url')  String url, @JsonKey(name: 'authHeaderValue')  String? authHeaderValue, @JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic)  int createdAt, @JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic)  int updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomMetadataProvider() when $default != null:
return $default(_that.id,_that.name,_that.mediaType,_that.url,_that.authHeaderValue,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'mediaType')  String mediaType, @JsonKey(name: 'url')  String url, @JsonKey(name: 'authHeaderValue')  String? authHeaderValue, @JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic)  int createdAt, @JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic)  int updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CustomMetadataProvider():
return $default(_that.id,_that.name,_that.mediaType,_that.url,_that.authHeaderValue,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'mediaType')  String mediaType, @JsonKey(name: 'url')  String url, @JsonKey(name: 'authHeaderValue')  String? authHeaderValue, @JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic)  int createdAt, @JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic)  int updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CustomMetadataProvider() when $default != null:
return $default(_that.id,_that.name,_that.mediaType,_that.url,_that.authHeaderValue,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomMetadataProvider implements CustomMetadataProvider {
  const _CustomMetadataProvider({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'mediaType') required this.mediaType, @JsonKey(name: 'url') required this.url, @JsonKey(name: 'authHeaderValue') this.authHeaderValue, @JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic) this.createdAt = 0, @JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic) this.updatedAt = 0});
  factory _CustomMetadataProvider.fromJson(Map<String, dynamic> json) => _$CustomMetadataProviderFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'mediaType') final  String mediaType;
@override@JsonKey(name: 'url') final  String url;
@override@JsonKey(name: 'authHeaderValue') final  String? authHeaderValue;
@override@JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic) final  int createdAt;
@override@JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic) final  int updatedAt;

/// Create a copy of CustomMetadataProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomMetadataProviderCopyWith<_CustomMetadataProvider> get copyWith => __$CustomMetadataProviderCopyWithImpl<_CustomMetadataProvider>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomMetadataProviderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomMetadataProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.url, url) || other.url == url)&&(identical(other.authHeaderValue, authHeaderValue) || other.authHeaderValue == authHeaderValue)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,mediaType,url,authHeaderValue,createdAt,updatedAt);

@override
String toString() {
  return 'CustomMetadataProvider(id: $id, name: $name, mediaType: $mediaType, url: $url, authHeaderValue: $authHeaderValue, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CustomMetadataProviderCopyWith<$Res> implements $CustomMetadataProviderCopyWith<$Res> {
  factory _$CustomMetadataProviderCopyWith(_CustomMetadataProvider value, $Res Function(_CustomMetadataProvider) _then) = __$CustomMetadataProviderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'mediaType') String mediaType,@JsonKey(name: 'url') String url,@JsonKey(name: 'authHeaderValue') String? authHeaderValue,@JsonKey(name: 'createdAt', fromJson: jsonIntRequiredFromDynamic) int createdAt,@JsonKey(name: 'updatedAt', fromJson: jsonIntRequiredFromDynamic) int updatedAt
});




}
/// @nodoc
class __$CustomMetadataProviderCopyWithImpl<$Res>
    implements _$CustomMetadataProviderCopyWith<$Res> {
  __$CustomMetadataProviderCopyWithImpl(this._self, this._then);

  final _CustomMetadataProvider _self;
  final $Res Function(_CustomMetadataProvider) _then;

/// Create a copy of CustomMetadataProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? mediaType = null,Object? url = null,Object? authHeaderValue = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_CustomMetadataProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,authHeaderValue: freezed == authHeaderValue ? _self.authHeaderValue : authHeaderValue // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
