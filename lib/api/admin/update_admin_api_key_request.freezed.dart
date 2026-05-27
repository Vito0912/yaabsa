// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_admin_api_key_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateAdminApiKeyRequest {

@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'isActive') bool? get isActive;
/// Create a copy of UpdateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAdminApiKeyRequestCopyWith<UpdateAdminApiKeyRequest> get copyWith => _$UpdateAdminApiKeyRequestCopyWithImpl<UpdateAdminApiKeyRequest>(this as UpdateAdminApiKeyRequest, _$identity);

  /// Serializes this UpdateAdminApiKeyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAdminApiKeyRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isActive);

@override
String toString() {
  return 'UpdateAdminApiKeyRequest(userId: $userId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $UpdateAdminApiKeyRequestCopyWith<$Res>  {
  factory $UpdateAdminApiKeyRequestCopyWith(UpdateAdminApiKeyRequest value, $Res Function(UpdateAdminApiKeyRequest) _then) = _$UpdateAdminApiKeyRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'isActive') bool? isActive
});




}
/// @nodoc
class _$UpdateAdminApiKeyRequestCopyWithImpl<$Res>
    implements $UpdateAdminApiKeyRequestCopyWith<$Res> {
  _$UpdateAdminApiKeyRequestCopyWithImpl(this._self, this._then);

  final UpdateAdminApiKeyRequest _self;
  final $Res Function(UpdateAdminApiKeyRequest) _then;

/// Create a copy of UpdateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAdminApiKeyRequest].
extension UpdateAdminApiKeyRequestPatterns on UpdateAdminApiKeyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAdminApiKeyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAdminApiKeyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAdminApiKeyRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminApiKeyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAdminApiKeyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminApiKeyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String? userId, @JsonKey(name: 'isActive')  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAdminApiKeyRequest() when $default != null:
return $default(_that.userId,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String? userId, @JsonKey(name: 'isActive')  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminApiKeyRequest():
return $default(_that.userId,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userId')  String? userId, @JsonKey(name: 'isActive')  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminApiKeyRequest() when $default != null:
return $default(_that.userId,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAdminApiKeyRequest implements UpdateAdminApiKeyRequest {
  const _UpdateAdminApiKeyRequest({@JsonKey(name: 'userId') this.userId, @JsonKey(name: 'isActive') this.isActive});
  factory _UpdateAdminApiKeyRequest.fromJson(Map<String, dynamic> json) => _$UpdateAdminApiKeyRequestFromJson(json);

@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'isActive') final  bool? isActive;

/// Create a copy of UpdateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAdminApiKeyRequestCopyWith<_UpdateAdminApiKeyRequest> get copyWith => __$UpdateAdminApiKeyRequestCopyWithImpl<_UpdateAdminApiKeyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAdminApiKeyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAdminApiKeyRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,isActive);

@override
String toString() {
  return 'UpdateAdminApiKeyRequest(userId: $userId, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$UpdateAdminApiKeyRequestCopyWith<$Res> implements $UpdateAdminApiKeyRequestCopyWith<$Res> {
  factory _$UpdateAdminApiKeyRequestCopyWith(_UpdateAdminApiKeyRequest value, $Res Function(_UpdateAdminApiKeyRequest) _then) = __$UpdateAdminApiKeyRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'isActive') bool? isActive
});




}
/// @nodoc
class __$UpdateAdminApiKeyRequestCopyWithImpl<$Res>
    implements _$UpdateAdminApiKeyRequestCopyWith<$Res> {
  __$UpdateAdminApiKeyRequestCopyWithImpl(this._self, this._then);

  final _UpdateAdminApiKeyRequest _self;
  final $Res Function(_UpdateAdminApiKeyRequest) _then;

/// Create a copy of UpdateAdminApiKeyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? isActive = freezed,}) {
  return _then(_UpdateAdminApiKeyRequest(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
