// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_admin_email_settings_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateAdminEmailSettingsRequest {

@JsonKey(name: 'host') String? get host;@JsonKey(name: 'port') int? get port;@JsonKey(name: 'secure') bool? get secure;@JsonKey(name: 'rejectUnauthorized') bool? get rejectUnauthorized;@JsonKey(name: 'user') String? get user;@JsonKey(name: 'pass') String? get pass;@JsonKey(name: 'testAddress') String? get testAddress;@JsonKey(name: 'fromAddress') String? get fromAddress;
/// Create a copy of UpdateAdminEmailSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAdminEmailSettingsRequestCopyWith<UpdateAdminEmailSettingsRequest> get copyWith => _$UpdateAdminEmailSettingsRequestCopyWithImpl<UpdateAdminEmailSettingsRequest>(this as UpdateAdminEmailSettingsRequest, _$identity);

  /// Serializes this UpdateAdminEmailSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAdminEmailSettingsRequest&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.secure, secure) || other.secure == secure)&&(identical(other.rejectUnauthorized, rejectUnauthorized) || other.rejectUnauthorized == rejectUnauthorized)&&(identical(other.user, user) || other.user == user)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.testAddress, testAddress) || other.testAddress == testAddress)&&(identical(other.fromAddress, fromAddress) || other.fromAddress == fromAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host,port,secure,rejectUnauthorized,user,pass,testAddress,fromAddress);

@override
String toString() {
  return 'UpdateAdminEmailSettingsRequest(host: $host, port: $port, secure: $secure, rejectUnauthorized: $rejectUnauthorized, user: $user, pass: $pass, testAddress: $testAddress, fromAddress: $fromAddress)';
}


}

/// @nodoc
abstract mixin class $UpdateAdminEmailSettingsRequestCopyWith<$Res>  {
  factory $UpdateAdminEmailSettingsRequestCopyWith(UpdateAdminEmailSettingsRequest value, $Res Function(UpdateAdminEmailSettingsRequest) _then) = _$UpdateAdminEmailSettingsRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'host') String? host,@JsonKey(name: 'port') int? port,@JsonKey(name: 'secure') bool? secure,@JsonKey(name: 'rejectUnauthorized') bool? rejectUnauthorized,@JsonKey(name: 'user') String? user,@JsonKey(name: 'pass') String? pass,@JsonKey(name: 'testAddress') String? testAddress,@JsonKey(name: 'fromAddress') String? fromAddress
});




}
/// @nodoc
class _$UpdateAdminEmailSettingsRequestCopyWithImpl<$Res>
    implements $UpdateAdminEmailSettingsRequestCopyWith<$Res> {
  _$UpdateAdminEmailSettingsRequestCopyWithImpl(this._self, this._then);

  final UpdateAdminEmailSettingsRequest _self;
  final $Res Function(UpdateAdminEmailSettingsRequest) _then;

/// Create a copy of UpdateAdminEmailSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = freezed,Object? port = freezed,Object? secure = freezed,Object? rejectUnauthorized = freezed,Object? user = freezed,Object? pass = freezed,Object? testAddress = freezed,Object? fromAddress = freezed,}) {
  return _then(_self.copyWith(
host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,secure: freezed == secure ? _self.secure : secure // ignore: cast_nullable_to_non_nullable
as bool?,rejectUnauthorized: freezed == rejectUnauthorized ? _self.rejectUnauthorized : rejectUnauthorized // ignore: cast_nullable_to_non_nullable
as bool?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,pass: freezed == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as String?,testAddress: freezed == testAddress ? _self.testAddress : testAddress // ignore: cast_nullable_to_non_nullable
as String?,fromAddress: freezed == fromAddress ? _self.fromAddress : fromAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateAdminEmailSettingsRequest].
extension UpdateAdminEmailSettingsRequestPatterns on UpdateAdminEmailSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateAdminEmailSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateAdminEmailSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateAdminEmailSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminEmailSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateAdminEmailSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateAdminEmailSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'host')  String? host, @JsonKey(name: 'port')  int? port, @JsonKey(name: 'secure')  bool? secure, @JsonKey(name: 'rejectUnauthorized')  bool? rejectUnauthorized, @JsonKey(name: 'user')  String? user, @JsonKey(name: 'pass')  String? pass, @JsonKey(name: 'testAddress')  String? testAddress, @JsonKey(name: 'fromAddress')  String? fromAddress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateAdminEmailSettingsRequest() when $default != null:
return $default(_that.host,_that.port,_that.secure,_that.rejectUnauthorized,_that.user,_that.pass,_that.testAddress,_that.fromAddress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'host')  String? host, @JsonKey(name: 'port')  int? port, @JsonKey(name: 'secure')  bool? secure, @JsonKey(name: 'rejectUnauthorized')  bool? rejectUnauthorized, @JsonKey(name: 'user')  String? user, @JsonKey(name: 'pass')  String? pass, @JsonKey(name: 'testAddress')  String? testAddress, @JsonKey(name: 'fromAddress')  String? fromAddress)  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminEmailSettingsRequest():
return $default(_that.host,_that.port,_that.secure,_that.rejectUnauthorized,_that.user,_that.pass,_that.testAddress,_that.fromAddress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'host')  String? host, @JsonKey(name: 'port')  int? port, @JsonKey(name: 'secure')  bool? secure, @JsonKey(name: 'rejectUnauthorized')  bool? rejectUnauthorized, @JsonKey(name: 'user')  String? user, @JsonKey(name: 'pass')  String? pass, @JsonKey(name: 'testAddress')  String? testAddress, @JsonKey(name: 'fromAddress')  String? fromAddress)?  $default,) {final _that = this;
switch (_that) {
case _UpdateAdminEmailSettingsRequest() when $default != null:
return $default(_that.host,_that.port,_that.secure,_that.rejectUnauthorized,_that.user,_that.pass,_that.testAddress,_that.fromAddress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateAdminEmailSettingsRequest implements UpdateAdminEmailSettingsRequest {
  const _UpdateAdminEmailSettingsRequest({@JsonKey(name: 'host') this.host, @JsonKey(name: 'port') this.port, @JsonKey(name: 'secure') this.secure, @JsonKey(name: 'rejectUnauthorized') this.rejectUnauthorized, @JsonKey(name: 'user') this.user, @JsonKey(name: 'pass') this.pass, @JsonKey(name: 'testAddress') this.testAddress, @JsonKey(name: 'fromAddress') this.fromAddress});
  factory _UpdateAdminEmailSettingsRequest.fromJson(Map<String, dynamic> json) => _$UpdateAdminEmailSettingsRequestFromJson(json);

@override@JsonKey(name: 'host') final  String? host;
@override@JsonKey(name: 'port') final  int? port;
@override@JsonKey(name: 'secure') final  bool? secure;
@override@JsonKey(name: 'rejectUnauthorized') final  bool? rejectUnauthorized;
@override@JsonKey(name: 'user') final  String? user;
@override@JsonKey(name: 'pass') final  String? pass;
@override@JsonKey(name: 'testAddress') final  String? testAddress;
@override@JsonKey(name: 'fromAddress') final  String? fromAddress;

/// Create a copy of UpdateAdminEmailSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateAdminEmailSettingsRequestCopyWith<_UpdateAdminEmailSettingsRequest> get copyWith => __$UpdateAdminEmailSettingsRequestCopyWithImpl<_UpdateAdminEmailSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateAdminEmailSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateAdminEmailSettingsRequest&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.secure, secure) || other.secure == secure)&&(identical(other.rejectUnauthorized, rejectUnauthorized) || other.rejectUnauthorized == rejectUnauthorized)&&(identical(other.user, user) || other.user == user)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.testAddress, testAddress) || other.testAddress == testAddress)&&(identical(other.fromAddress, fromAddress) || other.fromAddress == fromAddress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,host,port,secure,rejectUnauthorized,user,pass,testAddress,fromAddress);

@override
String toString() {
  return 'UpdateAdminEmailSettingsRequest(host: $host, port: $port, secure: $secure, rejectUnauthorized: $rejectUnauthorized, user: $user, pass: $pass, testAddress: $testAddress, fromAddress: $fromAddress)';
}


}

/// @nodoc
abstract mixin class _$UpdateAdminEmailSettingsRequestCopyWith<$Res> implements $UpdateAdminEmailSettingsRequestCopyWith<$Res> {
  factory _$UpdateAdminEmailSettingsRequestCopyWith(_UpdateAdminEmailSettingsRequest value, $Res Function(_UpdateAdminEmailSettingsRequest) _then) = __$UpdateAdminEmailSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'host') String? host,@JsonKey(name: 'port') int? port,@JsonKey(name: 'secure') bool? secure,@JsonKey(name: 'rejectUnauthorized') bool? rejectUnauthorized,@JsonKey(name: 'user') String? user,@JsonKey(name: 'pass') String? pass,@JsonKey(name: 'testAddress') String? testAddress,@JsonKey(name: 'fromAddress') String? fromAddress
});




}
/// @nodoc
class __$UpdateAdminEmailSettingsRequestCopyWithImpl<$Res>
    implements _$UpdateAdminEmailSettingsRequestCopyWith<$Res> {
  __$UpdateAdminEmailSettingsRequestCopyWithImpl(this._self, this._then);

  final _UpdateAdminEmailSettingsRequest _self;
  final $Res Function(_UpdateAdminEmailSettingsRequest) _then;

/// Create a copy of UpdateAdminEmailSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = freezed,Object? port = freezed,Object? secure = freezed,Object? rejectUnauthorized = freezed,Object? user = freezed,Object? pass = freezed,Object? testAddress = freezed,Object? fromAddress = freezed,}) {
  return _then(_UpdateAdminEmailSettingsRequest(
host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: freezed == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int?,secure: freezed == secure ? _self.secure : secure // ignore: cast_nullable_to_non_nullable
as bool?,rejectUnauthorized: freezed == rejectUnauthorized ? _self.rejectUnauthorized : rejectUnauthorized // ignore: cast_nullable_to_non_nullable
as bool?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,pass: freezed == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as String?,testAddress: freezed == testAddress ? _self.testAddress : testAddress // ignore: cast_nullable_to_non_nullable
as String?,fromAddress: freezed == fromAddress ? _self.fromAddress : fromAddress // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
