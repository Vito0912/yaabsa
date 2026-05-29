// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_authentication_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminAuthenticationSettings {

@JsonKey(name: 'authLoginCustomMessage') String? get authLoginCustomMessage;@JsonKey(name: 'authActiveAuthMethods') List<String> get authActiveAuthMethods;@JsonKey(name: 'authOpenIDIssuerURL') String? get authOpenIdIssuerUrl;@JsonKey(name: 'authOpenIDAuthorizationURL') String? get authOpenIdAuthorizationUrl;@JsonKey(name: 'authOpenIDTokenURL') String? get authOpenIdTokenUrl;@JsonKey(name: 'authOpenIDUserInfoURL') String? get authOpenIdUserInfoUrl;@JsonKey(name: 'authOpenIDJwksURL') String? get authOpenIdJwksUrl;@JsonKey(name: 'authOpenIDLogoutURL') String? get authOpenIdLogoutUrl;@JsonKey(name: 'authOpenIDClientID') String? get authOpenIdClientId;@JsonKey(name: 'authOpenIDClientSecret') String? get authOpenIdClientSecret;@JsonKey(name: 'authOpenIDTokenSigningAlgorithm') String? get authOpenIdTokenSigningAlgorithm;@JsonKey(name: 'authOpenIDButtonText') String? get authOpenIdButtonText;@JsonKey(name: 'authOpenIDAutoLaunch') bool get authOpenIdAutoLaunch;@JsonKey(name: 'authOpenIDAutoRegister') bool get authOpenIdAutoRegister;@JsonKey(name: 'authOpenIDMatchExistingBy') String? get authOpenIdMatchExistingBy;@JsonKey(name: 'authOpenIDMobileRedirectURIs') List<String> get authOpenIdMobileRedirectUris;@JsonKey(name: 'authOpenIDGroupClaim') String? get authOpenIdGroupClaim;@JsonKey(name: 'authOpenIDAdvancedPermsClaim') String? get authOpenIdAdvancedPermsClaim;@JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') String? get authOpenIdSubfolderForRedirectUrls;@JsonKey(name: 'authOpenIDSamplePermissions') String? get authOpenIdSamplePermissions;
/// Create a copy of AdminAuthenticationSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminAuthenticationSettingsCopyWith<AdminAuthenticationSettings> get copyWith => _$AdminAuthenticationSettingsCopyWithImpl<AdminAuthenticationSettings>(this as AdminAuthenticationSettings, _$identity);

  /// Serializes this AdminAuthenticationSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminAuthenticationSettings&&(identical(other.authLoginCustomMessage, authLoginCustomMessage) || other.authLoginCustomMessage == authLoginCustomMessage)&&const DeepCollectionEquality().equals(other.authActiveAuthMethods, authActiveAuthMethods)&&(identical(other.authOpenIdIssuerUrl, authOpenIdIssuerUrl) || other.authOpenIdIssuerUrl == authOpenIdIssuerUrl)&&(identical(other.authOpenIdAuthorizationUrl, authOpenIdAuthorizationUrl) || other.authOpenIdAuthorizationUrl == authOpenIdAuthorizationUrl)&&(identical(other.authOpenIdTokenUrl, authOpenIdTokenUrl) || other.authOpenIdTokenUrl == authOpenIdTokenUrl)&&(identical(other.authOpenIdUserInfoUrl, authOpenIdUserInfoUrl) || other.authOpenIdUserInfoUrl == authOpenIdUserInfoUrl)&&(identical(other.authOpenIdJwksUrl, authOpenIdJwksUrl) || other.authOpenIdJwksUrl == authOpenIdJwksUrl)&&(identical(other.authOpenIdLogoutUrl, authOpenIdLogoutUrl) || other.authOpenIdLogoutUrl == authOpenIdLogoutUrl)&&(identical(other.authOpenIdClientId, authOpenIdClientId) || other.authOpenIdClientId == authOpenIdClientId)&&(identical(other.authOpenIdClientSecret, authOpenIdClientSecret) || other.authOpenIdClientSecret == authOpenIdClientSecret)&&(identical(other.authOpenIdTokenSigningAlgorithm, authOpenIdTokenSigningAlgorithm) || other.authOpenIdTokenSigningAlgorithm == authOpenIdTokenSigningAlgorithm)&&(identical(other.authOpenIdButtonText, authOpenIdButtonText) || other.authOpenIdButtonText == authOpenIdButtonText)&&(identical(other.authOpenIdAutoLaunch, authOpenIdAutoLaunch) || other.authOpenIdAutoLaunch == authOpenIdAutoLaunch)&&(identical(other.authOpenIdAutoRegister, authOpenIdAutoRegister) || other.authOpenIdAutoRegister == authOpenIdAutoRegister)&&(identical(other.authOpenIdMatchExistingBy, authOpenIdMatchExistingBy) || other.authOpenIdMatchExistingBy == authOpenIdMatchExistingBy)&&const DeepCollectionEquality().equals(other.authOpenIdMobileRedirectUris, authOpenIdMobileRedirectUris)&&(identical(other.authOpenIdGroupClaim, authOpenIdGroupClaim) || other.authOpenIdGroupClaim == authOpenIdGroupClaim)&&(identical(other.authOpenIdAdvancedPermsClaim, authOpenIdAdvancedPermsClaim) || other.authOpenIdAdvancedPermsClaim == authOpenIdAdvancedPermsClaim)&&(identical(other.authOpenIdSubfolderForRedirectUrls, authOpenIdSubfolderForRedirectUrls) || other.authOpenIdSubfolderForRedirectUrls == authOpenIdSubfolderForRedirectUrls)&&(identical(other.authOpenIdSamplePermissions, authOpenIdSamplePermissions) || other.authOpenIdSamplePermissions == authOpenIdSamplePermissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,authLoginCustomMessage,const DeepCollectionEquality().hash(authActiveAuthMethods),authOpenIdIssuerUrl,authOpenIdAuthorizationUrl,authOpenIdTokenUrl,authOpenIdUserInfoUrl,authOpenIdJwksUrl,authOpenIdLogoutUrl,authOpenIdClientId,authOpenIdClientSecret,authOpenIdTokenSigningAlgorithm,authOpenIdButtonText,authOpenIdAutoLaunch,authOpenIdAutoRegister,authOpenIdMatchExistingBy,const DeepCollectionEquality().hash(authOpenIdMobileRedirectUris),authOpenIdGroupClaim,authOpenIdAdvancedPermsClaim,authOpenIdSubfolderForRedirectUrls,authOpenIdSamplePermissions]);

@override
String toString() {
  return 'AdminAuthenticationSettings(authLoginCustomMessage: $authLoginCustomMessage, authActiveAuthMethods: $authActiveAuthMethods, authOpenIdIssuerUrl: $authOpenIdIssuerUrl, authOpenIdAuthorizationUrl: $authOpenIdAuthorizationUrl, authOpenIdTokenUrl: $authOpenIdTokenUrl, authOpenIdUserInfoUrl: $authOpenIdUserInfoUrl, authOpenIdJwksUrl: $authOpenIdJwksUrl, authOpenIdLogoutUrl: $authOpenIdLogoutUrl, authOpenIdClientId: $authOpenIdClientId, authOpenIdClientSecret: $authOpenIdClientSecret, authOpenIdTokenSigningAlgorithm: $authOpenIdTokenSigningAlgorithm, authOpenIdButtonText: $authOpenIdButtonText, authOpenIdAutoLaunch: $authOpenIdAutoLaunch, authOpenIdAutoRegister: $authOpenIdAutoRegister, authOpenIdMatchExistingBy: $authOpenIdMatchExistingBy, authOpenIdMobileRedirectUris: $authOpenIdMobileRedirectUris, authOpenIdGroupClaim: $authOpenIdGroupClaim, authOpenIdAdvancedPermsClaim: $authOpenIdAdvancedPermsClaim, authOpenIdSubfolderForRedirectUrls: $authOpenIdSubfolderForRedirectUrls, authOpenIdSamplePermissions: $authOpenIdSamplePermissions)';
}


}

/// @nodoc
abstract mixin class $AdminAuthenticationSettingsCopyWith<$Res>  {
  factory $AdminAuthenticationSettingsCopyWith(AdminAuthenticationSettings value, $Res Function(AdminAuthenticationSettings) _then) = _$AdminAuthenticationSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,@JsonKey(name: 'authActiveAuthMethods') List<String> authActiveAuthMethods,@JsonKey(name: 'authOpenIDIssuerURL') String? authOpenIdIssuerUrl,@JsonKey(name: 'authOpenIDAuthorizationURL') String? authOpenIdAuthorizationUrl,@JsonKey(name: 'authOpenIDTokenURL') String? authOpenIdTokenUrl,@JsonKey(name: 'authOpenIDUserInfoURL') String? authOpenIdUserInfoUrl,@JsonKey(name: 'authOpenIDJwksURL') String? authOpenIdJwksUrl,@JsonKey(name: 'authOpenIDLogoutURL') String? authOpenIdLogoutUrl,@JsonKey(name: 'authOpenIDClientID') String? authOpenIdClientId,@JsonKey(name: 'authOpenIDClientSecret') String? authOpenIdClientSecret,@JsonKey(name: 'authOpenIDTokenSigningAlgorithm') String? authOpenIdTokenSigningAlgorithm,@JsonKey(name: 'authOpenIDButtonText') String? authOpenIdButtonText,@JsonKey(name: 'authOpenIDAutoLaunch') bool authOpenIdAutoLaunch,@JsonKey(name: 'authOpenIDAutoRegister') bool authOpenIdAutoRegister,@JsonKey(name: 'authOpenIDMatchExistingBy') String? authOpenIdMatchExistingBy,@JsonKey(name: 'authOpenIDMobileRedirectURIs') List<String> authOpenIdMobileRedirectUris,@JsonKey(name: 'authOpenIDGroupClaim') String? authOpenIdGroupClaim,@JsonKey(name: 'authOpenIDAdvancedPermsClaim') String? authOpenIdAdvancedPermsClaim,@JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') String? authOpenIdSubfolderForRedirectUrls,@JsonKey(name: 'authOpenIDSamplePermissions') String? authOpenIdSamplePermissions
});




}
/// @nodoc
class _$AdminAuthenticationSettingsCopyWithImpl<$Res>
    implements $AdminAuthenticationSettingsCopyWith<$Res> {
  _$AdminAuthenticationSettingsCopyWithImpl(this._self, this._then);

  final AdminAuthenticationSettings _self;
  final $Res Function(AdminAuthenticationSettings) _then;

/// Create a copy of AdminAuthenticationSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authLoginCustomMessage = freezed,Object? authActiveAuthMethods = null,Object? authOpenIdIssuerUrl = freezed,Object? authOpenIdAuthorizationUrl = freezed,Object? authOpenIdTokenUrl = freezed,Object? authOpenIdUserInfoUrl = freezed,Object? authOpenIdJwksUrl = freezed,Object? authOpenIdLogoutUrl = freezed,Object? authOpenIdClientId = freezed,Object? authOpenIdClientSecret = freezed,Object? authOpenIdTokenSigningAlgorithm = freezed,Object? authOpenIdButtonText = freezed,Object? authOpenIdAutoLaunch = null,Object? authOpenIdAutoRegister = null,Object? authOpenIdMatchExistingBy = freezed,Object? authOpenIdMobileRedirectUris = null,Object? authOpenIdGroupClaim = freezed,Object? authOpenIdAdvancedPermsClaim = freezed,Object? authOpenIdSubfolderForRedirectUrls = freezed,Object? authOpenIdSamplePermissions = freezed,}) {
  return _then(_self.copyWith(
authLoginCustomMessage: freezed == authLoginCustomMessage ? _self.authLoginCustomMessage : authLoginCustomMessage // ignore: cast_nullable_to_non_nullable
as String?,authActiveAuthMethods: null == authActiveAuthMethods ? _self.authActiveAuthMethods : authActiveAuthMethods // ignore: cast_nullable_to_non_nullable
as List<String>,authOpenIdIssuerUrl: freezed == authOpenIdIssuerUrl ? _self.authOpenIdIssuerUrl : authOpenIdIssuerUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdAuthorizationUrl: freezed == authOpenIdAuthorizationUrl ? _self.authOpenIdAuthorizationUrl : authOpenIdAuthorizationUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdTokenUrl: freezed == authOpenIdTokenUrl ? _self.authOpenIdTokenUrl : authOpenIdTokenUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdUserInfoUrl: freezed == authOpenIdUserInfoUrl ? _self.authOpenIdUserInfoUrl : authOpenIdUserInfoUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdJwksUrl: freezed == authOpenIdJwksUrl ? _self.authOpenIdJwksUrl : authOpenIdJwksUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdLogoutUrl: freezed == authOpenIdLogoutUrl ? _self.authOpenIdLogoutUrl : authOpenIdLogoutUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdClientId: freezed == authOpenIdClientId ? _self.authOpenIdClientId : authOpenIdClientId // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdClientSecret: freezed == authOpenIdClientSecret ? _self.authOpenIdClientSecret : authOpenIdClientSecret // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdTokenSigningAlgorithm: freezed == authOpenIdTokenSigningAlgorithm ? _self.authOpenIdTokenSigningAlgorithm : authOpenIdTokenSigningAlgorithm // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdButtonText: freezed == authOpenIdButtonText ? _self.authOpenIdButtonText : authOpenIdButtonText // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdAutoLaunch: null == authOpenIdAutoLaunch ? _self.authOpenIdAutoLaunch : authOpenIdAutoLaunch // ignore: cast_nullable_to_non_nullable
as bool,authOpenIdAutoRegister: null == authOpenIdAutoRegister ? _self.authOpenIdAutoRegister : authOpenIdAutoRegister // ignore: cast_nullable_to_non_nullable
as bool,authOpenIdMatchExistingBy: freezed == authOpenIdMatchExistingBy ? _self.authOpenIdMatchExistingBy : authOpenIdMatchExistingBy // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdMobileRedirectUris: null == authOpenIdMobileRedirectUris ? _self.authOpenIdMobileRedirectUris : authOpenIdMobileRedirectUris // ignore: cast_nullable_to_non_nullable
as List<String>,authOpenIdGroupClaim: freezed == authOpenIdGroupClaim ? _self.authOpenIdGroupClaim : authOpenIdGroupClaim // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdAdvancedPermsClaim: freezed == authOpenIdAdvancedPermsClaim ? _self.authOpenIdAdvancedPermsClaim : authOpenIdAdvancedPermsClaim // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdSubfolderForRedirectUrls: freezed == authOpenIdSubfolderForRedirectUrls ? _self.authOpenIdSubfolderForRedirectUrls : authOpenIdSubfolderForRedirectUrls // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdSamplePermissions: freezed == authOpenIdSamplePermissions ? _self.authOpenIdSamplePermissions : authOpenIdSamplePermissions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminAuthenticationSettings].
extension AdminAuthenticationSettingsPatterns on AdminAuthenticationSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminAuthenticationSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminAuthenticationSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminAuthenticationSettings value)  $default,){
final _that = this;
switch (_that) {
case _AdminAuthenticationSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminAuthenticationSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AdminAuthenticationSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'authLoginCustomMessage')  String? authLoginCustomMessage, @JsonKey(name: 'authActiveAuthMethods')  List<String> authActiveAuthMethods, @JsonKey(name: 'authOpenIDIssuerURL')  String? authOpenIdIssuerUrl, @JsonKey(name: 'authOpenIDAuthorizationURL')  String? authOpenIdAuthorizationUrl, @JsonKey(name: 'authOpenIDTokenURL')  String? authOpenIdTokenUrl, @JsonKey(name: 'authOpenIDUserInfoURL')  String? authOpenIdUserInfoUrl, @JsonKey(name: 'authOpenIDJwksURL')  String? authOpenIdJwksUrl, @JsonKey(name: 'authOpenIDLogoutURL')  String? authOpenIdLogoutUrl, @JsonKey(name: 'authOpenIDClientID')  String? authOpenIdClientId, @JsonKey(name: 'authOpenIDClientSecret')  String? authOpenIdClientSecret, @JsonKey(name: 'authOpenIDTokenSigningAlgorithm')  String? authOpenIdTokenSigningAlgorithm, @JsonKey(name: 'authOpenIDButtonText')  String? authOpenIdButtonText, @JsonKey(name: 'authOpenIDAutoLaunch')  bool authOpenIdAutoLaunch, @JsonKey(name: 'authOpenIDAutoRegister')  bool authOpenIdAutoRegister, @JsonKey(name: 'authOpenIDMatchExistingBy')  String? authOpenIdMatchExistingBy, @JsonKey(name: 'authOpenIDMobileRedirectURIs')  List<String> authOpenIdMobileRedirectUris, @JsonKey(name: 'authOpenIDGroupClaim')  String? authOpenIdGroupClaim, @JsonKey(name: 'authOpenIDAdvancedPermsClaim')  String? authOpenIdAdvancedPermsClaim, @JsonKey(name: 'authOpenIDSubfolderForRedirectURLs')  String? authOpenIdSubfolderForRedirectUrls, @JsonKey(name: 'authOpenIDSamplePermissions')  String? authOpenIdSamplePermissions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminAuthenticationSettings() when $default != null:
return $default(_that.authLoginCustomMessage,_that.authActiveAuthMethods,_that.authOpenIdIssuerUrl,_that.authOpenIdAuthorizationUrl,_that.authOpenIdTokenUrl,_that.authOpenIdUserInfoUrl,_that.authOpenIdJwksUrl,_that.authOpenIdLogoutUrl,_that.authOpenIdClientId,_that.authOpenIdClientSecret,_that.authOpenIdTokenSigningAlgorithm,_that.authOpenIdButtonText,_that.authOpenIdAutoLaunch,_that.authOpenIdAutoRegister,_that.authOpenIdMatchExistingBy,_that.authOpenIdMobileRedirectUris,_that.authOpenIdGroupClaim,_that.authOpenIdAdvancedPermsClaim,_that.authOpenIdSubfolderForRedirectUrls,_that.authOpenIdSamplePermissions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'authLoginCustomMessage')  String? authLoginCustomMessage, @JsonKey(name: 'authActiveAuthMethods')  List<String> authActiveAuthMethods, @JsonKey(name: 'authOpenIDIssuerURL')  String? authOpenIdIssuerUrl, @JsonKey(name: 'authOpenIDAuthorizationURL')  String? authOpenIdAuthorizationUrl, @JsonKey(name: 'authOpenIDTokenURL')  String? authOpenIdTokenUrl, @JsonKey(name: 'authOpenIDUserInfoURL')  String? authOpenIdUserInfoUrl, @JsonKey(name: 'authOpenIDJwksURL')  String? authOpenIdJwksUrl, @JsonKey(name: 'authOpenIDLogoutURL')  String? authOpenIdLogoutUrl, @JsonKey(name: 'authOpenIDClientID')  String? authOpenIdClientId, @JsonKey(name: 'authOpenIDClientSecret')  String? authOpenIdClientSecret, @JsonKey(name: 'authOpenIDTokenSigningAlgorithm')  String? authOpenIdTokenSigningAlgorithm, @JsonKey(name: 'authOpenIDButtonText')  String? authOpenIdButtonText, @JsonKey(name: 'authOpenIDAutoLaunch')  bool authOpenIdAutoLaunch, @JsonKey(name: 'authOpenIDAutoRegister')  bool authOpenIdAutoRegister, @JsonKey(name: 'authOpenIDMatchExistingBy')  String? authOpenIdMatchExistingBy, @JsonKey(name: 'authOpenIDMobileRedirectURIs')  List<String> authOpenIdMobileRedirectUris, @JsonKey(name: 'authOpenIDGroupClaim')  String? authOpenIdGroupClaim, @JsonKey(name: 'authOpenIDAdvancedPermsClaim')  String? authOpenIdAdvancedPermsClaim, @JsonKey(name: 'authOpenIDSubfolderForRedirectURLs')  String? authOpenIdSubfolderForRedirectUrls, @JsonKey(name: 'authOpenIDSamplePermissions')  String? authOpenIdSamplePermissions)  $default,) {final _that = this;
switch (_that) {
case _AdminAuthenticationSettings():
return $default(_that.authLoginCustomMessage,_that.authActiveAuthMethods,_that.authOpenIdIssuerUrl,_that.authOpenIdAuthorizationUrl,_that.authOpenIdTokenUrl,_that.authOpenIdUserInfoUrl,_that.authOpenIdJwksUrl,_that.authOpenIdLogoutUrl,_that.authOpenIdClientId,_that.authOpenIdClientSecret,_that.authOpenIdTokenSigningAlgorithm,_that.authOpenIdButtonText,_that.authOpenIdAutoLaunch,_that.authOpenIdAutoRegister,_that.authOpenIdMatchExistingBy,_that.authOpenIdMobileRedirectUris,_that.authOpenIdGroupClaim,_that.authOpenIdAdvancedPermsClaim,_that.authOpenIdSubfolderForRedirectUrls,_that.authOpenIdSamplePermissions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'authLoginCustomMessage')  String? authLoginCustomMessage, @JsonKey(name: 'authActiveAuthMethods')  List<String> authActiveAuthMethods, @JsonKey(name: 'authOpenIDIssuerURL')  String? authOpenIdIssuerUrl, @JsonKey(name: 'authOpenIDAuthorizationURL')  String? authOpenIdAuthorizationUrl, @JsonKey(name: 'authOpenIDTokenURL')  String? authOpenIdTokenUrl, @JsonKey(name: 'authOpenIDUserInfoURL')  String? authOpenIdUserInfoUrl, @JsonKey(name: 'authOpenIDJwksURL')  String? authOpenIdJwksUrl, @JsonKey(name: 'authOpenIDLogoutURL')  String? authOpenIdLogoutUrl, @JsonKey(name: 'authOpenIDClientID')  String? authOpenIdClientId, @JsonKey(name: 'authOpenIDClientSecret')  String? authOpenIdClientSecret, @JsonKey(name: 'authOpenIDTokenSigningAlgorithm')  String? authOpenIdTokenSigningAlgorithm, @JsonKey(name: 'authOpenIDButtonText')  String? authOpenIdButtonText, @JsonKey(name: 'authOpenIDAutoLaunch')  bool authOpenIdAutoLaunch, @JsonKey(name: 'authOpenIDAutoRegister')  bool authOpenIdAutoRegister, @JsonKey(name: 'authOpenIDMatchExistingBy')  String? authOpenIdMatchExistingBy, @JsonKey(name: 'authOpenIDMobileRedirectURIs')  List<String> authOpenIdMobileRedirectUris, @JsonKey(name: 'authOpenIDGroupClaim')  String? authOpenIdGroupClaim, @JsonKey(name: 'authOpenIDAdvancedPermsClaim')  String? authOpenIdAdvancedPermsClaim, @JsonKey(name: 'authOpenIDSubfolderForRedirectURLs')  String? authOpenIdSubfolderForRedirectUrls, @JsonKey(name: 'authOpenIDSamplePermissions')  String? authOpenIdSamplePermissions)?  $default,) {final _that = this;
switch (_that) {
case _AdminAuthenticationSettings() when $default != null:
return $default(_that.authLoginCustomMessage,_that.authActiveAuthMethods,_that.authOpenIdIssuerUrl,_that.authOpenIdAuthorizationUrl,_that.authOpenIdTokenUrl,_that.authOpenIdUserInfoUrl,_that.authOpenIdJwksUrl,_that.authOpenIdLogoutUrl,_that.authOpenIdClientId,_that.authOpenIdClientSecret,_that.authOpenIdTokenSigningAlgorithm,_that.authOpenIdButtonText,_that.authOpenIdAutoLaunch,_that.authOpenIdAutoRegister,_that.authOpenIdMatchExistingBy,_that.authOpenIdMobileRedirectUris,_that.authOpenIdGroupClaim,_that.authOpenIdAdvancedPermsClaim,_that.authOpenIdSubfolderForRedirectUrls,_that.authOpenIdSamplePermissions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminAuthenticationSettings extends AdminAuthenticationSettings {
  const _AdminAuthenticationSettings({@JsonKey(name: 'authLoginCustomMessage') this.authLoginCustomMessage, @JsonKey(name: 'authActiveAuthMethods') final  List<String> authActiveAuthMethods = const <String>['local'], @JsonKey(name: 'authOpenIDIssuerURL') this.authOpenIdIssuerUrl, @JsonKey(name: 'authOpenIDAuthorizationURL') this.authOpenIdAuthorizationUrl, @JsonKey(name: 'authOpenIDTokenURL') this.authOpenIdTokenUrl, @JsonKey(name: 'authOpenIDUserInfoURL') this.authOpenIdUserInfoUrl, @JsonKey(name: 'authOpenIDJwksURL') this.authOpenIdJwksUrl, @JsonKey(name: 'authOpenIDLogoutURL') this.authOpenIdLogoutUrl, @JsonKey(name: 'authOpenIDClientID') this.authOpenIdClientId, @JsonKey(name: 'authOpenIDClientSecret') this.authOpenIdClientSecret, @JsonKey(name: 'authOpenIDTokenSigningAlgorithm') this.authOpenIdTokenSigningAlgorithm, @JsonKey(name: 'authOpenIDButtonText') this.authOpenIdButtonText, @JsonKey(name: 'authOpenIDAutoLaunch') this.authOpenIdAutoLaunch = false, @JsonKey(name: 'authOpenIDAutoRegister') this.authOpenIdAutoRegister = false, @JsonKey(name: 'authOpenIDMatchExistingBy') this.authOpenIdMatchExistingBy, @JsonKey(name: 'authOpenIDMobileRedirectURIs') final  List<String> authOpenIdMobileRedirectUris = const <String>[], @JsonKey(name: 'authOpenIDGroupClaim') this.authOpenIdGroupClaim, @JsonKey(name: 'authOpenIDAdvancedPermsClaim') this.authOpenIdAdvancedPermsClaim, @JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') this.authOpenIdSubfolderForRedirectUrls, @JsonKey(name: 'authOpenIDSamplePermissions') this.authOpenIdSamplePermissions}): _authActiveAuthMethods = authActiveAuthMethods,_authOpenIdMobileRedirectUris = authOpenIdMobileRedirectUris,super._();
  factory _AdminAuthenticationSettings.fromJson(Map<String, dynamic> json) => _$AdminAuthenticationSettingsFromJson(json);

@override@JsonKey(name: 'authLoginCustomMessage') final  String? authLoginCustomMessage;
 final  List<String> _authActiveAuthMethods;
@override@JsonKey(name: 'authActiveAuthMethods') List<String> get authActiveAuthMethods {
  if (_authActiveAuthMethods is EqualUnmodifiableListView) return _authActiveAuthMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authActiveAuthMethods);
}

@override@JsonKey(name: 'authOpenIDIssuerURL') final  String? authOpenIdIssuerUrl;
@override@JsonKey(name: 'authOpenIDAuthorizationURL') final  String? authOpenIdAuthorizationUrl;
@override@JsonKey(name: 'authOpenIDTokenURL') final  String? authOpenIdTokenUrl;
@override@JsonKey(name: 'authOpenIDUserInfoURL') final  String? authOpenIdUserInfoUrl;
@override@JsonKey(name: 'authOpenIDJwksURL') final  String? authOpenIdJwksUrl;
@override@JsonKey(name: 'authOpenIDLogoutURL') final  String? authOpenIdLogoutUrl;
@override@JsonKey(name: 'authOpenIDClientID') final  String? authOpenIdClientId;
@override@JsonKey(name: 'authOpenIDClientSecret') final  String? authOpenIdClientSecret;
@override@JsonKey(name: 'authOpenIDTokenSigningAlgorithm') final  String? authOpenIdTokenSigningAlgorithm;
@override@JsonKey(name: 'authOpenIDButtonText') final  String? authOpenIdButtonText;
@override@JsonKey(name: 'authOpenIDAutoLaunch') final  bool authOpenIdAutoLaunch;
@override@JsonKey(name: 'authOpenIDAutoRegister') final  bool authOpenIdAutoRegister;
@override@JsonKey(name: 'authOpenIDMatchExistingBy') final  String? authOpenIdMatchExistingBy;
 final  List<String> _authOpenIdMobileRedirectUris;
@override@JsonKey(name: 'authOpenIDMobileRedirectURIs') List<String> get authOpenIdMobileRedirectUris {
  if (_authOpenIdMobileRedirectUris is EqualUnmodifiableListView) return _authOpenIdMobileRedirectUris;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authOpenIdMobileRedirectUris);
}

@override@JsonKey(name: 'authOpenIDGroupClaim') final  String? authOpenIdGroupClaim;
@override@JsonKey(name: 'authOpenIDAdvancedPermsClaim') final  String? authOpenIdAdvancedPermsClaim;
@override@JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') final  String? authOpenIdSubfolderForRedirectUrls;
@override@JsonKey(name: 'authOpenIDSamplePermissions') final  String? authOpenIdSamplePermissions;

/// Create a copy of AdminAuthenticationSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminAuthenticationSettingsCopyWith<_AdminAuthenticationSettings> get copyWith => __$AdminAuthenticationSettingsCopyWithImpl<_AdminAuthenticationSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminAuthenticationSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminAuthenticationSettings&&(identical(other.authLoginCustomMessage, authLoginCustomMessage) || other.authLoginCustomMessage == authLoginCustomMessage)&&const DeepCollectionEquality().equals(other._authActiveAuthMethods, _authActiveAuthMethods)&&(identical(other.authOpenIdIssuerUrl, authOpenIdIssuerUrl) || other.authOpenIdIssuerUrl == authOpenIdIssuerUrl)&&(identical(other.authOpenIdAuthorizationUrl, authOpenIdAuthorizationUrl) || other.authOpenIdAuthorizationUrl == authOpenIdAuthorizationUrl)&&(identical(other.authOpenIdTokenUrl, authOpenIdTokenUrl) || other.authOpenIdTokenUrl == authOpenIdTokenUrl)&&(identical(other.authOpenIdUserInfoUrl, authOpenIdUserInfoUrl) || other.authOpenIdUserInfoUrl == authOpenIdUserInfoUrl)&&(identical(other.authOpenIdJwksUrl, authOpenIdJwksUrl) || other.authOpenIdJwksUrl == authOpenIdJwksUrl)&&(identical(other.authOpenIdLogoutUrl, authOpenIdLogoutUrl) || other.authOpenIdLogoutUrl == authOpenIdLogoutUrl)&&(identical(other.authOpenIdClientId, authOpenIdClientId) || other.authOpenIdClientId == authOpenIdClientId)&&(identical(other.authOpenIdClientSecret, authOpenIdClientSecret) || other.authOpenIdClientSecret == authOpenIdClientSecret)&&(identical(other.authOpenIdTokenSigningAlgorithm, authOpenIdTokenSigningAlgorithm) || other.authOpenIdTokenSigningAlgorithm == authOpenIdTokenSigningAlgorithm)&&(identical(other.authOpenIdButtonText, authOpenIdButtonText) || other.authOpenIdButtonText == authOpenIdButtonText)&&(identical(other.authOpenIdAutoLaunch, authOpenIdAutoLaunch) || other.authOpenIdAutoLaunch == authOpenIdAutoLaunch)&&(identical(other.authOpenIdAutoRegister, authOpenIdAutoRegister) || other.authOpenIdAutoRegister == authOpenIdAutoRegister)&&(identical(other.authOpenIdMatchExistingBy, authOpenIdMatchExistingBy) || other.authOpenIdMatchExistingBy == authOpenIdMatchExistingBy)&&const DeepCollectionEquality().equals(other._authOpenIdMobileRedirectUris, _authOpenIdMobileRedirectUris)&&(identical(other.authOpenIdGroupClaim, authOpenIdGroupClaim) || other.authOpenIdGroupClaim == authOpenIdGroupClaim)&&(identical(other.authOpenIdAdvancedPermsClaim, authOpenIdAdvancedPermsClaim) || other.authOpenIdAdvancedPermsClaim == authOpenIdAdvancedPermsClaim)&&(identical(other.authOpenIdSubfolderForRedirectUrls, authOpenIdSubfolderForRedirectUrls) || other.authOpenIdSubfolderForRedirectUrls == authOpenIdSubfolderForRedirectUrls)&&(identical(other.authOpenIdSamplePermissions, authOpenIdSamplePermissions) || other.authOpenIdSamplePermissions == authOpenIdSamplePermissions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,authLoginCustomMessage,const DeepCollectionEquality().hash(_authActiveAuthMethods),authOpenIdIssuerUrl,authOpenIdAuthorizationUrl,authOpenIdTokenUrl,authOpenIdUserInfoUrl,authOpenIdJwksUrl,authOpenIdLogoutUrl,authOpenIdClientId,authOpenIdClientSecret,authOpenIdTokenSigningAlgorithm,authOpenIdButtonText,authOpenIdAutoLaunch,authOpenIdAutoRegister,authOpenIdMatchExistingBy,const DeepCollectionEquality().hash(_authOpenIdMobileRedirectUris),authOpenIdGroupClaim,authOpenIdAdvancedPermsClaim,authOpenIdSubfolderForRedirectUrls,authOpenIdSamplePermissions]);

@override
String toString() {
  return 'AdminAuthenticationSettings(authLoginCustomMessage: $authLoginCustomMessage, authActiveAuthMethods: $authActiveAuthMethods, authOpenIdIssuerUrl: $authOpenIdIssuerUrl, authOpenIdAuthorizationUrl: $authOpenIdAuthorizationUrl, authOpenIdTokenUrl: $authOpenIdTokenUrl, authOpenIdUserInfoUrl: $authOpenIdUserInfoUrl, authOpenIdJwksUrl: $authOpenIdJwksUrl, authOpenIdLogoutUrl: $authOpenIdLogoutUrl, authOpenIdClientId: $authOpenIdClientId, authOpenIdClientSecret: $authOpenIdClientSecret, authOpenIdTokenSigningAlgorithm: $authOpenIdTokenSigningAlgorithm, authOpenIdButtonText: $authOpenIdButtonText, authOpenIdAutoLaunch: $authOpenIdAutoLaunch, authOpenIdAutoRegister: $authOpenIdAutoRegister, authOpenIdMatchExistingBy: $authOpenIdMatchExistingBy, authOpenIdMobileRedirectUris: $authOpenIdMobileRedirectUris, authOpenIdGroupClaim: $authOpenIdGroupClaim, authOpenIdAdvancedPermsClaim: $authOpenIdAdvancedPermsClaim, authOpenIdSubfolderForRedirectUrls: $authOpenIdSubfolderForRedirectUrls, authOpenIdSamplePermissions: $authOpenIdSamplePermissions)';
}


}

/// @nodoc
abstract mixin class _$AdminAuthenticationSettingsCopyWith<$Res> implements $AdminAuthenticationSettingsCopyWith<$Res> {
  factory _$AdminAuthenticationSettingsCopyWith(_AdminAuthenticationSettings value, $Res Function(_AdminAuthenticationSettings) _then) = __$AdminAuthenticationSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'authLoginCustomMessage') String? authLoginCustomMessage,@JsonKey(name: 'authActiveAuthMethods') List<String> authActiveAuthMethods,@JsonKey(name: 'authOpenIDIssuerURL') String? authOpenIdIssuerUrl,@JsonKey(name: 'authOpenIDAuthorizationURL') String? authOpenIdAuthorizationUrl,@JsonKey(name: 'authOpenIDTokenURL') String? authOpenIdTokenUrl,@JsonKey(name: 'authOpenIDUserInfoURL') String? authOpenIdUserInfoUrl,@JsonKey(name: 'authOpenIDJwksURL') String? authOpenIdJwksUrl,@JsonKey(name: 'authOpenIDLogoutURL') String? authOpenIdLogoutUrl,@JsonKey(name: 'authOpenIDClientID') String? authOpenIdClientId,@JsonKey(name: 'authOpenIDClientSecret') String? authOpenIdClientSecret,@JsonKey(name: 'authOpenIDTokenSigningAlgorithm') String? authOpenIdTokenSigningAlgorithm,@JsonKey(name: 'authOpenIDButtonText') String? authOpenIdButtonText,@JsonKey(name: 'authOpenIDAutoLaunch') bool authOpenIdAutoLaunch,@JsonKey(name: 'authOpenIDAutoRegister') bool authOpenIdAutoRegister,@JsonKey(name: 'authOpenIDMatchExistingBy') String? authOpenIdMatchExistingBy,@JsonKey(name: 'authOpenIDMobileRedirectURIs') List<String> authOpenIdMobileRedirectUris,@JsonKey(name: 'authOpenIDGroupClaim') String? authOpenIdGroupClaim,@JsonKey(name: 'authOpenIDAdvancedPermsClaim') String? authOpenIdAdvancedPermsClaim,@JsonKey(name: 'authOpenIDSubfolderForRedirectURLs') String? authOpenIdSubfolderForRedirectUrls,@JsonKey(name: 'authOpenIDSamplePermissions') String? authOpenIdSamplePermissions
});




}
/// @nodoc
class __$AdminAuthenticationSettingsCopyWithImpl<$Res>
    implements _$AdminAuthenticationSettingsCopyWith<$Res> {
  __$AdminAuthenticationSettingsCopyWithImpl(this._self, this._then);

  final _AdminAuthenticationSettings _self;
  final $Res Function(_AdminAuthenticationSettings) _then;

/// Create a copy of AdminAuthenticationSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authLoginCustomMessage = freezed,Object? authActiveAuthMethods = null,Object? authOpenIdIssuerUrl = freezed,Object? authOpenIdAuthorizationUrl = freezed,Object? authOpenIdTokenUrl = freezed,Object? authOpenIdUserInfoUrl = freezed,Object? authOpenIdJwksUrl = freezed,Object? authOpenIdLogoutUrl = freezed,Object? authOpenIdClientId = freezed,Object? authOpenIdClientSecret = freezed,Object? authOpenIdTokenSigningAlgorithm = freezed,Object? authOpenIdButtonText = freezed,Object? authOpenIdAutoLaunch = null,Object? authOpenIdAutoRegister = null,Object? authOpenIdMatchExistingBy = freezed,Object? authOpenIdMobileRedirectUris = null,Object? authOpenIdGroupClaim = freezed,Object? authOpenIdAdvancedPermsClaim = freezed,Object? authOpenIdSubfolderForRedirectUrls = freezed,Object? authOpenIdSamplePermissions = freezed,}) {
  return _then(_AdminAuthenticationSettings(
authLoginCustomMessage: freezed == authLoginCustomMessage ? _self.authLoginCustomMessage : authLoginCustomMessage // ignore: cast_nullable_to_non_nullable
as String?,authActiveAuthMethods: null == authActiveAuthMethods ? _self._authActiveAuthMethods : authActiveAuthMethods // ignore: cast_nullable_to_non_nullable
as List<String>,authOpenIdIssuerUrl: freezed == authOpenIdIssuerUrl ? _self.authOpenIdIssuerUrl : authOpenIdIssuerUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdAuthorizationUrl: freezed == authOpenIdAuthorizationUrl ? _self.authOpenIdAuthorizationUrl : authOpenIdAuthorizationUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdTokenUrl: freezed == authOpenIdTokenUrl ? _self.authOpenIdTokenUrl : authOpenIdTokenUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdUserInfoUrl: freezed == authOpenIdUserInfoUrl ? _self.authOpenIdUserInfoUrl : authOpenIdUserInfoUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdJwksUrl: freezed == authOpenIdJwksUrl ? _self.authOpenIdJwksUrl : authOpenIdJwksUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdLogoutUrl: freezed == authOpenIdLogoutUrl ? _self.authOpenIdLogoutUrl : authOpenIdLogoutUrl // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdClientId: freezed == authOpenIdClientId ? _self.authOpenIdClientId : authOpenIdClientId // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdClientSecret: freezed == authOpenIdClientSecret ? _self.authOpenIdClientSecret : authOpenIdClientSecret // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdTokenSigningAlgorithm: freezed == authOpenIdTokenSigningAlgorithm ? _self.authOpenIdTokenSigningAlgorithm : authOpenIdTokenSigningAlgorithm // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdButtonText: freezed == authOpenIdButtonText ? _self.authOpenIdButtonText : authOpenIdButtonText // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdAutoLaunch: null == authOpenIdAutoLaunch ? _self.authOpenIdAutoLaunch : authOpenIdAutoLaunch // ignore: cast_nullable_to_non_nullable
as bool,authOpenIdAutoRegister: null == authOpenIdAutoRegister ? _self.authOpenIdAutoRegister : authOpenIdAutoRegister // ignore: cast_nullable_to_non_nullable
as bool,authOpenIdMatchExistingBy: freezed == authOpenIdMatchExistingBy ? _self.authOpenIdMatchExistingBy : authOpenIdMatchExistingBy // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdMobileRedirectUris: null == authOpenIdMobileRedirectUris ? _self._authOpenIdMobileRedirectUris : authOpenIdMobileRedirectUris // ignore: cast_nullable_to_non_nullable
as List<String>,authOpenIdGroupClaim: freezed == authOpenIdGroupClaim ? _self.authOpenIdGroupClaim : authOpenIdGroupClaim // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdAdvancedPermsClaim: freezed == authOpenIdAdvancedPermsClaim ? _self.authOpenIdAdvancedPermsClaim : authOpenIdAdvancedPermsClaim // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdSubfolderForRedirectUrls: freezed == authOpenIdSubfolderForRedirectUrls ? _self.authOpenIdSubfolderForRedirectUrls : authOpenIdSubfolderForRedirectUrls // ignore: cast_nullable_to_non_nullable
as String?,authOpenIdSamplePermissions: freezed == authOpenIdSamplePermissions ? _self.authOpenIdSamplePermissions : authOpenIdSamplePermissions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
