// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_admin_api_key_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateAdminApiKeyRequest {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'expiresIn') int? get expiresIn;@JsonKey(name: 'isActive') bool get isActive;
/// Create a copy of CreateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateAdminApiKeyRequestCopyWith<CreateAdminApiKeyRequest> get copyWith => _$CreateAdminApiKeyRequestCopyWithImpl<CreateAdminApiKeyRequest>(this as CreateAdminApiKeyRequest, _$identity);

  /// Serializes this CreateAdminApiKeyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateAdminApiKeyRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,userId,expiresIn,isActive);

@override
String toString() {
  return 'CreateAdminApiKeyRequest(name: $name, userId: $userId, expiresIn: $expiresIn, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $CreateAdminApiKeyRequestCopyWith<$Res>  {
  factory $CreateAdminApiKeyRequestCopyWith(CreateAdminApiKeyRequest value, $Res Function(CreateAdminApiKeyRequest) _then) = _$CreateAdminApiKeyRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'expiresIn') int? expiresIn,@JsonKey(name: 'isActive') bool isActive
});




}
/// @nodoc
class _$CreateAdminApiKeyRequestCopyWithImpl<$Res>
    implements $CreateAdminApiKeyRequestCopyWith<$Res> {
  _$CreateAdminApiKeyRequestCopyWithImpl(this._self, this._then);

  final CreateAdminApiKeyRequest _self;
  final $Res Function(CreateAdminApiKeyRequest) _then;

/// Create a copy of CreateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? userId = null,Object? expiresIn = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateAdminApiKeyRequest].
extension CreateAdminApiKeyRequestPatterns on CreateAdminApiKeyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateAdminApiKeyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateAdminApiKeyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateAdminApiKeyRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateAdminApiKeyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateAdminApiKeyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateAdminApiKeyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'expiresIn')  int? expiresIn, @JsonKey(name: 'isActive')  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateAdminApiKeyRequest() when $default != null:
return $default(_that.name,_that.userId,_that.expiresIn,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'expiresIn')  int? expiresIn, @JsonKey(name: 'isActive')  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _CreateAdminApiKeyRequest():
return $default(_that.name,_that.userId,_that.expiresIn,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'expiresIn')  int? expiresIn, @JsonKey(name: 'isActive')  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _CreateAdminApiKeyRequest() when $default != null:
return $default(_that.name,_that.userId,_that.expiresIn,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateAdminApiKeyRequest implements CreateAdminApiKeyRequest {
  const _CreateAdminApiKeyRequest({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'expiresIn') this.expiresIn, @JsonKey(name: 'isActive') this.isActive = true});
  factory _CreateAdminApiKeyRequest.fromJson(Map<String, dynamic> json) => _$CreateAdminApiKeyRequestFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'expiresIn') final  int? expiresIn;
@override@JsonKey(name: 'isActive') final  bool isActive;

/// Create a copy of CreateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateAdminApiKeyRequestCopyWith<_CreateAdminApiKeyRequest> get copyWith => __$CreateAdminApiKeyRequestCopyWithImpl<_CreateAdminApiKeyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateAdminApiKeyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateAdminApiKeyRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,userId,expiresIn,isActive);

@override
String toString() {
  return 'CreateAdminApiKeyRequest(name: $name, userId: $userId, expiresIn: $expiresIn, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$CreateAdminApiKeyRequestCopyWith<$Res> implements $CreateAdminApiKeyRequestCopyWith<$Res> {
  factory _$CreateAdminApiKeyRequestCopyWith(_CreateAdminApiKeyRequest value, $Res Function(_CreateAdminApiKeyRequest) _then) = __$CreateAdminApiKeyRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'expiresIn') int? expiresIn,@JsonKey(name: 'isActive') bool isActive
});




}
/// @nodoc
class __$CreateAdminApiKeyRequestCopyWithImpl<$Res>
    implements _$CreateAdminApiKeyRequestCopyWith<$Res> {
  __$CreateAdminApiKeyRequestCopyWithImpl(this._self, this._then);

  final _CreateAdminApiKeyRequest _self;
  final $Res Function(_CreateAdminApiKeyRequest) _then;

/// Create a copy of CreateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? userId = null,Object? expiresIn = freezed,Object? isActive = null,}) {
  return _then(_CreateAdminApiKeyRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,expiresIn: freezed == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
