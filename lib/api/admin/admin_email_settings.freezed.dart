// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_email_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminEmailEreaderDevice {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'email') String get email;@JsonKey(name: 'availabilityOption') String get availabilityOption;@JsonKey(name: 'users') List<String> get users;
/// Create a copy of AdminEmailEreaderDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminEmailEreaderDeviceCopyWith<AdminEmailEreaderDevice> get copyWith => _$AdminEmailEreaderDeviceCopyWithImpl<AdminEmailEreaderDevice>(this as AdminEmailEreaderDevice, _$identity);

  /// Serializes this AdminEmailEreaderDevice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminEmailEreaderDevice&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.availabilityOption, availabilityOption) || other.availabilityOption == availabilityOption)&&const DeepCollectionEquality().equals(other.users, users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,availabilityOption,const DeepCollectionEquality().hash(users));

@override
String toString() {
  return 'AdminEmailEreaderDevice(name: $name, email: $email, availabilityOption: $availabilityOption, users: $users)';
}


}

/// @nodoc
abstract mixin class $AdminEmailEreaderDeviceCopyWith<$Res>  {
  factory $AdminEmailEreaderDeviceCopyWith(AdminEmailEreaderDevice value, $Res Function(AdminEmailEreaderDevice) _then) = _$AdminEmailEreaderDeviceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'email') String email,@JsonKey(name: 'availabilityOption') String availabilityOption,@JsonKey(name: 'users') List<String> users
});




}
/// @nodoc
class _$AdminEmailEreaderDeviceCopyWithImpl<$Res>
    implements $AdminEmailEreaderDeviceCopyWith<$Res> {
  _$AdminEmailEreaderDeviceCopyWithImpl(this._self, this._then);

  final AdminEmailEreaderDevice _self;
  final $Res Function(AdminEmailEreaderDevice) _then;

/// Create a copy of AdminEmailEreaderDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? availabilityOption = null,Object? users = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,availabilityOption: null == availabilityOption ? _self.availabilityOption : availabilityOption // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self.users : users // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminEmailEreaderDevice].
extension AdminEmailEreaderDevicePatterns on AdminEmailEreaderDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminEmailEreaderDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminEmailEreaderDevice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminEmailEreaderDevice value)  $default,){
final _that = this;
switch (_that) {
case _AdminEmailEreaderDevice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminEmailEreaderDevice value)?  $default,){
final _that = this;
switch (_that) {
case _AdminEmailEreaderDevice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'email')  String email, @JsonKey(name: 'availabilityOption')  String availabilityOption, @JsonKey(name: 'users')  List<String> users)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminEmailEreaderDevice() when $default != null:
return $default(_that.name,_that.email,_that.availabilityOption,_that.users);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'email')  String email, @JsonKey(name: 'availabilityOption')  String availabilityOption, @JsonKey(name: 'users')  List<String> users)  $default,) {final _that = this;
switch (_that) {
case _AdminEmailEreaderDevice():
return $default(_that.name,_that.email,_that.availabilityOption,_that.users);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'email')  String email, @JsonKey(name: 'availabilityOption')  String availabilityOption, @JsonKey(name: 'users')  List<String> users)?  $default,) {final _that = this;
switch (_that) {
case _AdminEmailEreaderDevice() when $default != null:
return $default(_that.name,_that.email,_that.availabilityOption,_that.users);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminEmailEreaderDevice implements AdminEmailEreaderDevice {
  const _AdminEmailEreaderDevice({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'email') required this.email, @JsonKey(name: 'availabilityOption') this.availabilityOption = 'adminOrUp', @JsonKey(name: 'users') final  List<String> users = const <String>[]}): _users = users;
  factory _AdminEmailEreaderDevice.fromJson(Map<String, dynamic> json) => _$AdminEmailEreaderDeviceFromJson(json);

@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'email') final  String email;
@override@JsonKey(name: 'availabilityOption') final  String availabilityOption;
 final  List<String> _users;
@override@JsonKey(name: 'users') List<String> get users {
  if (_users is EqualUnmodifiableListView) return _users;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_users);
}


/// Create a copy of AdminEmailEreaderDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminEmailEreaderDeviceCopyWith<_AdminEmailEreaderDevice> get copyWith => __$AdminEmailEreaderDeviceCopyWithImpl<_AdminEmailEreaderDevice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminEmailEreaderDeviceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminEmailEreaderDevice&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.availabilityOption, availabilityOption) || other.availabilityOption == availabilityOption)&&const DeepCollectionEquality().equals(other._users, _users));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,availabilityOption,const DeepCollectionEquality().hash(_users));

@override
String toString() {
  return 'AdminEmailEreaderDevice(name: $name, email: $email, availabilityOption: $availabilityOption, users: $users)';
}


}

/// @nodoc
abstract mixin class _$AdminEmailEreaderDeviceCopyWith<$Res> implements $AdminEmailEreaderDeviceCopyWith<$Res> {
  factory _$AdminEmailEreaderDeviceCopyWith(_AdminEmailEreaderDevice value, $Res Function(_AdminEmailEreaderDevice) _then) = __$AdminEmailEreaderDeviceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'email') String email,@JsonKey(name: 'availabilityOption') String availabilityOption,@JsonKey(name: 'users') List<String> users
});




}
/// @nodoc
class __$AdminEmailEreaderDeviceCopyWithImpl<$Res>
    implements _$AdminEmailEreaderDeviceCopyWith<$Res> {
  __$AdminEmailEreaderDeviceCopyWithImpl(this._self, this._then);

  final _AdminEmailEreaderDevice _self;
  final $Res Function(_AdminEmailEreaderDevice) _then;

/// Create a copy of AdminEmailEreaderDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? availabilityOption = null,Object? users = null,}) {
  return _then(_AdminEmailEreaderDevice(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,availabilityOption: null == availabilityOption ? _self.availabilityOption : availabilityOption // ignore: cast_nullable_to_non_nullable
as String,users: null == users ? _self._users : users // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AdminEmailSettings {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'host') String? get host;@JsonKey(name: 'port') int get port;@JsonKey(name: 'secure') bool get secure;@JsonKey(name: 'rejectUnauthorized') bool get rejectUnauthorized;@JsonKey(name: 'user') String? get user;@JsonKey(name: 'pass') String? get pass;@JsonKey(name: 'testAddress') String? get testAddress;@JsonKey(name: 'fromAddress') String? get fromAddress;@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> get ereaderDevices;
/// Create a copy of AdminEmailSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminEmailSettingsCopyWith<AdminEmailSettings> get copyWith => _$AdminEmailSettingsCopyWithImpl<AdminEmailSettings>(this as AdminEmailSettings, _$identity);

  /// Serializes this AdminEmailSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminEmailSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.secure, secure) || other.secure == secure)&&(identical(other.rejectUnauthorized, rejectUnauthorized) || other.rejectUnauthorized == rejectUnauthorized)&&(identical(other.user, user) || other.user == user)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.testAddress, testAddress) || other.testAddress == testAddress)&&(identical(other.fromAddress, fromAddress) || other.fromAddress == fromAddress)&&const DeepCollectionEquality().equals(other.ereaderDevices, ereaderDevices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,host,port,secure,rejectUnauthorized,user,pass,testAddress,fromAddress,const DeepCollectionEquality().hash(ereaderDevices));

@override
String toString() {
  return 'AdminEmailSettings(id: $id, host: $host, port: $port, secure: $secure, rejectUnauthorized: $rejectUnauthorized, user: $user, pass: $pass, testAddress: $testAddress, fromAddress: $fromAddress, ereaderDevices: $ereaderDevices)';
}


}

/// @nodoc
abstract mixin class $AdminEmailSettingsCopyWith<$Res>  {
  factory $AdminEmailSettingsCopyWith(AdminEmailSettings value, $Res Function(AdminEmailSettings) _then) = _$AdminEmailSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'host') String? host,@JsonKey(name: 'port') int port,@JsonKey(name: 'secure') bool secure,@JsonKey(name: 'rejectUnauthorized') bool rejectUnauthorized,@JsonKey(name: 'user') String? user,@JsonKey(name: 'pass') String? pass,@JsonKey(name: 'testAddress') String? testAddress,@JsonKey(name: 'fromAddress') String? fromAddress,@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> ereaderDevices
});




}
/// @nodoc
class _$AdminEmailSettingsCopyWithImpl<$Res>
    implements $AdminEmailSettingsCopyWith<$Res> {
  _$AdminEmailSettingsCopyWithImpl(this._self, this._then);

  final AdminEmailSettings _self;
  final $Res Function(AdminEmailSettings) _then;

/// Create a copy of AdminEmailSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? host = freezed,Object? port = null,Object? secure = null,Object? rejectUnauthorized = null,Object? user = freezed,Object? pass = freezed,Object? testAddress = freezed,Object? fromAddress = freezed,Object? ereaderDevices = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,secure: null == secure ? _self.secure : secure // ignore: cast_nullable_to_non_nullable
as bool,rejectUnauthorized: null == rejectUnauthorized ? _self.rejectUnauthorized : rejectUnauthorized // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,pass: freezed == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as String?,testAddress: freezed == testAddress ? _self.testAddress : testAddress // ignore: cast_nullable_to_non_nullable
as String?,fromAddress: freezed == fromAddress ? _self.fromAddress : fromAddress // ignore: cast_nullable_to_non_nullable
as String?,ereaderDevices: null == ereaderDevices ? _self.ereaderDevices : ereaderDevices // ignore: cast_nullable_to_non_nullable
as List<AdminEmailEreaderDevice>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminEmailSettings].
extension AdminEmailSettingsPatterns on AdminEmailSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminEmailSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminEmailSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminEmailSettings value)  $default,){
final _that = this;
switch (_that) {
case _AdminEmailSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminEmailSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AdminEmailSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'host')  String? host, @JsonKey(name: 'port')  int port, @JsonKey(name: 'secure')  bool secure, @JsonKey(name: 'rejectUnauthorized')  bool rejectUnauthorized, @JsonKey(name: 'user')  String? user, @JsonKey(name: 'pass')  String? pass, @JsonKey(name: 'testAddress')  String? testAddress, @JsonKey(name: 'fromAddress')  String? fromAddress, @JsonKey(name: 'ereaderDevices')  List<AdminEmailEreaderDevice> ereaderDevices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminEmailSettings() when $default != null:
return $default(_that.id,_that.host,_that.port,_that.secure,_that.rejectUnauthorized,_that.user,_that.pass,_that.testAddress,_that.fromAddress,_that.ereaderDevices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'host')  String? host, @JsonKey(name: 'port')  int port, @JsonKey(name: 'secure')  bool secure, @JsonKey(name: 'rejectUnauthorized')  bool rejectUnauthorized, @JsonKey(name: 'user')  String? user, @JsonKey(name: 'pass')  String? pass, @JsonKey(name: 'testAddress')  String? testAddress, @JsonKey(name: 'fromAddress')  String? fromAddress, @JsonKey(name: 'ereaderDevices')  List<AdminEmailEreaderDevice> ereaderDevices)  $default,) {final _that = this;
switch (_that) {
case _AdminEmailSettings():
return $default(_that.id,_that.host,_that.port,_that.secure,_that.rejectUnauthorized,_that.user,_that.pass,_that.testAddress,_that.fromAddress,_that.ereaderDevices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'host')  String? host, @JsonKey(name: 'port')  int port, @JsonKey(name: 'secure')  bool secure, @JsonKey(name: 'rejectUnauthorized')  bool rejectUnauthorized, @JsonKey(name: 'user')  String? user, @JsonKey(name: 'pass')  String? pass, @JsonKey(name: 'testAddress')  String? testAddress, @JsonKey(name: 'fromAddress')  String? fromAddress, @JsonKey(name: 'ereaderDevices')  List<AdminEmailEreaderDevice> ereaderDevices)?  $default,) {final _that = this;
switch (_that) {
case _AdminEmailSettings() when $default != null:
return $default(_that.id,_that.host,_that.port,_that.secure,_that.rejectUnauthorized,_that.user,_that.pass,_that.testAddress,_that.fromAddress,_that.ereaderDevices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminEmailSettings extends AdminEmailSettings {
  const _AdminEmailSettings({@JsonKey(name: 'id') this.id = 'email-settings', @JsonKey(name: 'host') this.host, @JsonKey(name: 'port') this.port = 465, @JsonKey(name: 'secure') this.secure = true, @JsonKey(name: 'rejectUnauthorized') this.rejectUnauthorized = true, @JsonKey(name: 'user') this.user, @JsonKey(name: 'pass') this.pass, @JsonKey(name: 'testAddress') this.testAddress, @JsonKey(name: 'fromAddress') this.fromAddress, @JsonKey(name: 'ereaderDevices') final  List<AdminEmailEreaderDevice> ereaderDevices = const <AdminEmailEreaderDevice>[]}): _ereaderDevices = ereaderDevices,super._();
  factory _AdminEmailSettings.fromJson(Map<String, dynamic> json) => _$AdminEmailSettingsFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'host') final  String? host;
@override@JsonKey(name: 'port') final  int port;
@override@JsonKey(name: 'secure') final  bool secure;
@override@JsonKey(name: 'rejectUnauthorized') final  bool rejectUnauthorized;
@override@JsonKey(name: 'user') final  String? user;
@override@JsonKey(name: 'pass') final  String? pass;
@override@JsonKey(name: 'testAddress') final  String? testAddress;
@override@JsonKey(name: 'fromAddress') final  String? fromAddress;
 final  List<AdminEmailEreaderDevice> _ereaderDevices;
@override@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> get ereaderDevices {
  if (_ereaderDevices is EqualUnmodifiableListView) return _ereaderDevices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ereaderDevices);
}


/// Create a copy of AdminEmailSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminEmailSettingsCopyWith<_AdminEmailSettings> get copyWith => __$AdminEmailSettingsCopyWithImpl<_AdminEmailSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminEmailSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminEmailSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.secure, secure) || other.secure == secure)&&(identical(other.rejectUnauthorized, rejectUnauthorized) || other.rejectUnauthorized == rejectUnauthorized)&&(identical(other.user, user) || other.user == user)&&(identical(other.pass, pass) || other.pass == pass)&&(identical(other.testAddress, testAddress) || other.testAddress == testAddress)&&(identical(other.fromAddress, fromAddress) || other.fromAddress == fromAddress)&&const DeepCollectionEquality().equals(other._ereaderDevices, _ereaderDevices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,host,port,secure,rejectUnauthorized,user,pass,testAddress,fromAddress,const DeepCollectionEquality().hash(_ereaderDevices));

@override
String toString() {
  return 'AdminEmailSettings(id: $id, host: $host, port: $port, secure: $secure, rejectUnauthorized: $rejectUnauthorized, user: $user, pass: $pass, testAddress: $testAddress, fromAddress: $fromAddress, ereaderDevices: $ereaderDevices)';
}


}

/// @nodoc
abstract mixin class _$AdminEmailSettingsCopyWith<$Res> implements $AdminEmailSettingsCopyWith<$Res> {
  factory _$AdminEmailSettingsCopyWith(_AdminEmailSettings value, $Res Function(_AdminEmailSettings) _then) = __$AdminEmailSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'host') String? host,@JsonKey(name: 'port') int port,@JsonKey(name: 'secure') bool secure,@JsonKey(name: 'rejectUnauthorized') bool rejectUnauthorized,@JsonKey(name: 'user') String? user,@JsonKey(name: 'pass') String? pass,@JsonKey(name: 'testAddress') String? testAddress,@JsonKey(name: 'fromAddress') String? fromAddress,@JsonKey(name: 'ereaderDevices') List<AdminEmailEreaderDevice> ereaderDevices
});




}
/// @nodoc
class __$AdminEmailSettingsCopyWithImpl<$Res>
    implements _$AdminEmailSettingsCopyWith<$Res> {
  __$AdminEmailSettingsCopyWithImpl(this._self, this._then);

  final _AdminEmailSettings _self;
  final $Res Function(_AdminEmailSettings) _then;

/// Create a copy of AdminEmailSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? host = freezed,Object? port = null,Object? secure = null,Object? rejectUnauthorized = null,Object? user = freezed,Object? pass = freezed,Object? testAddress = freezed,Object? fromAddress = freezed,Object? ereaderDevices = null,}) {
  return _then(_AdminEmailSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,secure: null == secure ? _self.secure : secure // ignore: cast_nullable_to_non_nullable
as bool,rejectUnauthorized: null == rejectUnauthorized ? _self.rejectUnauthorized : rejectUnauthorized // ignore: cast_nullable_to_non_nullable
as bool,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as String?,pass: freezed == pass ? _self.pass : pass // ignore: cast_nullable_to_non_nullable
as String?,testAddress: freezed == testAddress ? _self.testAddress : testAddress // ignore: cast_nullable_to_non_nullable
as String?,fromAddress: freezed == fromAddress ? _self.fromAddress : fromAddress // ignore: cast_nullable_to_non_nullable
as String?,ereaderDevices: null == ereaderDevices ? _self._ereaderDevices : ereaderDevices // ignore: cast_nullable_to_non_nullable
as List<AdminEmailEreaderDevice>,
  ));
}


}

// dart format on
