// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_openid_issuer_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminOpenIdIssuerConfig {

@JsonKey(name: 'issuer') String? get issuer;@JsonKey(name: 'authorization_endpoint') String? get authorizationEndpoint;@JsonKey(name: 'token_endpoint') String? get tokenEndpoint;@JsonKey(name: 'userinfo_endpoint') String? get userInfoEndpoint;@JsonKey(name: 'end_session_endpoint') String? get endSessionEndpoint;@JsonKey(name: 'jwks_uri') String? get jwksUri;@JsonKey(name: 'id_token_signing_alg_values_supported') List<String> get signingAlgorithms;
/// Create a copy of AdminOpenIdIssuerConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminOpenIdIssuerConfigCopyWith<AdminOpenIdIssuerConfig> get copyWith => _$AdminOpenIdIssuerConfigCopyWithImpl<AdminOpenIdIssuerConfig>(this as AdminOpenIdIssuerConfig, _$identity);

  /// Serializes this AdminOpenIdIssuerConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminOpenIdIssuerConfig&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.authorizationEndpoint, authorizationEndpoint) || other.authorizationEndpoint == authorizationEndpoint)&&(identical(other.tokenEndpoint, tokenEndpoint) || other.tokenEndpoint == tokenEndpoint)&&(identical(other.userInfoEndpoint, userInfoEndpoint) || other.userInfoEndpoint == userInfoEndpoint)&&(identical(other.endSessionEndpoint, endSessionEndpoint) || other.endSessionEndpoint == endSessionEndpoint)&&(identical(other.jwksUri, jwksUri) || other.jwksUri == jwksUri)&&const DeepCollectionEquality().equals(other.signingAlgorithms, signingAlgorithms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,issuer,authorizationEndpoint,tokenEndpoint,userInfoEndpoint,endSessionEndpoint,jwksUri,const DeepCollectionEquality().hash(signingAlgorithms));

@override
String toString() {
  return 'AdminOpenIdIssuerConfig(issuer: $issuer, authorizationEndpoint: $authorizationEndpoint, tokenEndpoint: $tokenEndpoint, userInfoEndpoint: $userInfoEndpoint, endSessionEndpoint: $endSessionEndpoint, jwksUri: $jwksUri, signingAlgorithms: $signingAlgorithms)';
}


}

/// @nodoc
abstract mixin class $AdminOpenIdIssuerConfigCopyWith<$Res>  {
  factory $AdminOpenIdIssuerConfigCopyWith(AdminOpenIdIssuerConfig value, $Res Function(AdminOpenIdIssuerConfig) _then) = _$AdminOpenIdIssuerConfigCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'issuer') String? issuer,@JsonKey(name: 'authorization_endpoint') String? authorizationEndpoint,@JsonKey(name: 'token_endpoint') String? tokenEndpoint,@JsonKey(name: 'userinfo_endpoint') String? userInfoEndpoint,@JsonKey(name: 'end_session_endpoint') String? endSessionEndpoint,@JsonKey(name: 'jwks_uri') String? jwksUri,@JsonKey(name: 'id_token_signing_alg_values_supported') List<String> signingAlgorithms
});




}
/// @nodoc
class _$AdminOpenIdIssuerConfigCopyWithImpl<$Res>
    implements $AdminOpenIdIssuerConfigCopyWith<$Res> {
  _$AdminOpenIdIssuerConfigCopyWithImpl(this._self, this._then);

  final AdminOpenIdIssuerConfig _self;
  final $Res Function(AdminOpenIdIssuerConfig) _then;

/// Create a copy of AdminOpenIdIssuerConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issuer = freezed,Object? authorizationEndpoint = freezed,Object? tokenEndpoint = freezed,Object? userInfoEndpoint = freezed,Object? endSessionEndpoint = freezed,Object? jwksUri = freezed,Object? signingAlgorithms = null,}) {
  return _then(_self.copyWith(
issuer: freezed == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String?,authorizationEndpoint: freezed == authorizationEndpoint ? _self.authorizationEndpoint : authorizationEndpoint // ignore: cast_nullable_to_non_nullable
as String?,tokenEndpoint: freezed == tokenEndpoint ? _self.tokenEndpoint : tokenEndpoint // ignore: cast_nullable_to_non_nullable
as String?,userInfoEndpoint: freezed == userInfoEndpoint ? _self.userInfoEndpoint : userInfoEndpoint // ignore: cast_nullable_to_non_nullable
as String?,endSessionEndpoint: freezed == endSessionEndpoint ? _self.endSessionEndpoint : endSessionEndpoint // ignore: cast_nullable_to_non_nullable
as String?,jwksUri: freezed == jwksUri ? _self.jwksUri : jwksUri // ignore: cast_nullable_to_non_nullable
as String?,signingAlgorithms: null == signingAlgorithms ? _self.signingAlgorithms : signingAlgorithms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminOpenIdIssuerConfig].
extension AdminOpenIdIssuerConfigPatterns on AdminOpenIdIssuerConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminOpenIdIssuerConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminOpenIdIssuerConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminOpenIdIssuerConfig value)  $default,){
final _that = this;
switch (_that) {
case _AdminOpenIdIssuerConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminOpenIdIssuerConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AdminOpenIdIssuerConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'issuer')  String? issuer, @JsonKey(name: 'authorization_endpoint')  String? authorizationEndpoint, @JsonKey(name: 'token_endpoint')  String? tokenEndpoint, @JsonKey(name: 'userinfo_endpoint')  String? userInfoEndpoint, @JsonKey(name: 'end_session_endpoint')  String? endSessionEndpoint, @JsonKey(name: 'jwks_uri')  String? jwksUri, @JsonKey(name: 'id_token_signing_alg_values_supported')  List<String> signingAlgorithms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminOpenIdIssuerConfig() when $default != null:
return $default(_that.issuer,_that.authorizationEndpoint,_that.tokenEndpoint,_that.userInfoEndpoint,_that.endSessionEndpoint,_that.jwksUri,_that.signingAlgorithms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'issuer')  String? issuer, @JsonKey(name: 'authorization_endpoint')  String? authorizationEndpoint, @JsonKey(name: 'token_endpoint')  String? tokenEndpoint, @JsonKey(name: 'userinfo_endpoint')  String? userInfoEndpoint, @JsonKey(name: 'end_session_endpoint')  String? endSessionEndpoint, @JsonKey(name: 'jwks_uri')  String? jwksUri, @JsonKey(name: 'id_token_signing_alg_values_supported')  List<String> signingAlgorithms)  $default,) {final _that = this;
switch (_that) {
case _AdminOpenIdIssuerConfig():
return $default(_that.issuer,_that.authorizationEndpoint,_that.tokenEndpoint,_that.userInfoEndpoint,_that.endSessionEndpoint,_that.jwksUri,_that.signingAlgorithms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'issuer')  String? issuer, @JsonKey(name: 'authorization_endpoint')  String? authorizationEndpoint, @JsonKey(name: 'token_endpoint')  String? tokenEndpoint, @JsonKey(name: 'userinfo_endpoint')  String? userInfoEndpoint, @JsonKey(name: 'end_session_endpoint')  String? endSessionEndpoint, @JsonKey(name: 'jwks_uri')  String? jwksUri, @JsonKey(name: 'id_token_signing_alg_values_supported')  List<String> signingAlgorithms)?  $default,) {final _that = this;
switch (_that) {
case _AdminOpenIdIssuerConfig() when $default != null:
return $default(_that.issuer,_that.authorizationEndpoint,_that.tokenEndpoint,_that.userInfoEndpoint,_that.endSessionEndpoint,_that.jwksUri,_that.signingAlgorithms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminOpenIdIssuerConfig implements AdminOpenIdIssuerConfig {
  const _AdminOpenIdIssuerConfig({@JsonKey(name: 'issuer') this.issuer, @JsonKey(name: 'authorization_endpoint') this.authorizationEndpoint, @JsonKey(name: 'token_endpoint') this.tokenEndpoint, @JsonKey(name: 'userinfo_endpoint') this.userInfoEndpoint, @JsonKey(name: 'end_session_endpoint') this.endSessionEndpoint, @JsonKey(name: 'jwks_uri') this.jwksUri, @JsonKey(name: 'id_token_signing_alg_values_supported') final  List<String> signingAlgorithms = const <String>[]}): _signingAlgorithms = signingAlgorithms;
  factory _AdminOpenIdIssuerConfig.fromJson(Map<String, dynamic> json) => _$AdminOpenIdIssuerConfigFromJson(json);

@override@JsonKey(name: 'issuer') final  String? issuer;
@override@JsonKey(name: 'authorization_endpoint') final  String? authorizationEndpoint;
@override@JsonKey(name: 'token_endpoint') final  String? tokenEndpoint;
@override@JsonKey(name: 'userinfo_endpoint') final  String? userInfoEndpoint;
@override@JsonKey(name: 'end_session_endpoint') final  String? endSessionEndpoint;
@override@JsonKey(name: 'jwks_uri') final  String? jwksUri;
 final  List<String> _signingAlgorithms;
@override@JsonKey(name: 'id_token_signing_alg_values_supported') List<String> get signingAlgorithms {
  if (_signingAlgorithms is EqualUnmodifiableListView) return _signingAlgorithms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_signingAlgorithms);
}


/// Create a copy of AdminOpenIdIssuerConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminOpenIdIssuerConfigCopyWith<_AdminOpenIdIssuerConfig> get copyWith => __$AdminOpenIdIssuerConfigCopyWithImpl<_AdminOpenIdIssuerConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminOpenIdIssuerConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminOpenIdIssuerConfig&&(identical(other.issuer, issuer) || other.issuer == issuer)&&(identical(other.authorizationEndpoint, authorizationEndpoint) || other.authorizationEndpoint == authorizationEndpoint)&&(identical(other.tokenEndpoint, tokenEndpoint) || other.tokenEndpoint == tokenEndpoint)&&(identical(other.userInfoEndpoint, userInfoEndpoint) || other.userInfoEndpoint == userInfoEndpoint)&&(identical(other.endSessionEndpoint, endSessionEndpoint) || other.endSessionEndpoint == endSessionEndpoint)&&(identical(other.jwksUri, jwksUri) || other.jwksUri == jwksUri)&&const DeepCollectionEquality().equals(other._signingAlgorithms, _signingAlgorithms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,issuer,authorizationEndpoint,tokenEndpoint,userInfoEndpoint,endSessionEndpoint,jwksUri,const DeepCollectionEquality().hash(_signingAlgorithms));

@override
String toString() {
  return 'AdminOpenIdIssuerConfig(issuer: $issuer, authorizationEndpoint: $authorizationEndpoint, tokenEndpoint: $tokenEndpoint, userInfoEndpoint: $userInfoEndpoint, endSessionEndpoint: $endSessionEndpoint, jwksUri: $jwksUri, signingAlgorithms: $signingAlgorithms)';
}


}

/// @nodoc
abstract mixin class _$AdminOpenIdIssuerConfigCopyWith<$Res> implements $AdminOpenIdIssuerConfigCopyWith<$Res> {
  factory _$AdminOpenIdIssuerConfigCopyWith(_AdminOpenIdIssuerConfig value, $Res Function(_AdminOpenIdIssuerConfig) _then) = __$AdminOpenIdIssuerConfigCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'issuer') String? issuer,@JsonKey(name: 'authorization_endpoint') String? authorizationEndpoint,@JsonKey(name: 'token_endpoint') String? tokenEndpoint,@JsonKey(name: 'userinfo_endpoint') String? userInfoEndpoint,@JsonKey(name: 'end_session_endpoint') String? endSessionEndpoint,@JsonKey(name: 'jwks_uri') String? jwksUri,@JsonKey(name: 'id_token_signing_alg_values_supported') List<String> signingAlgorithms
});




}
/// @nodoc
class __$AdminOpenIdIssuerConfigCopyWithImpl<$Res>
    implements _$AdminOpenIdIssuerConfigCopyWith<$Res> {
  __$AdminOpenIdIssuerConfigCopyWithImpl(this._self, this._then);

  final _AdminOpenIdIssuerConfig _self;
  final $Res Function(_AdminOpenIdIssuerConfig) _then;

/// Create a copy of AdminOpenIdIssuerConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issuer = freezed,Object? authorizationEndpoint = freezed,Object? tokenEndpoint = freezed,Object? userInfoEndpoint = freezed,Object? endSessionEndpoint = freezed,Object? jwksUri = freezed,Object? signingAlgorithms = null,}) {
  return _then(_AdminOpenIdIssuerConfig(
issuer: freezed == issuer ? _self.issuer : issuer // ignore: cast_nullable_to_non_nullable
as String?,authorizationEndpoint: freezed == authorizationEndpoint ? _self.authorizationEndpoint : authorizationEndpoint // ignore: cast_nullable_to_non_nullable
as String?,tokenEndpoint: freezed == tokenEndpoint ? _self.tokenEndpoint : tokenEndpoint // ignore: cast_nullable_to_non_nullable
as String?,userInfoEndpoint: freezed == userInfoEndpoint ? _self.userInfoEndpoint : userInfoEndpoint // ignore: cast_nullable_to_non_nullable
as String?,endSessionEndpoint: freezed == endSessionEndpoint ? _self.endSessionEndpoint : endSessionEndpoint // ignore: cast_nullable_to_non_nullable
as String?,jwksUri: freezed == jwksUri ? _self.jwksUri : jwksUri // ignore: cast_nullable_to_non_nullable
as String?,signingAlgorithms: null == signingAlgorithms ? _self._signingAlgorithms : signingAlgorithms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
