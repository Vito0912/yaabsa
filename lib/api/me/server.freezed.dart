// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Server {

@JsonKey(name: 'port') int get externalPort;@JsonKey(name: 'port') set externalPort(int value);@JsonKey(name: 'host') String get externalHost;@JsonKey(name: 'host') set externalHost(String value);@JsonKey(name: 'ssl') bool get externalSsl;@JsonKey(name: 'ssl') set externalSsl(bool value);@JsonKey(name: 'subdirectory') String? get externalSubdirectory;@JsonKey(name: 'subdirectory') set externalSubdirectory(String? value); Map<String, String>? get headers; set headers(Map<String, String>? value); String? get localHost; set localHost(String? value); int? get localPort; set localPort(int? value); bool? get localSsl; set localSsl(bool? value); String? get localSubdirectory; set localSubdirectory(String? value);@JsonKey(unknownEnumValue: ServerConnection.external) ServerConnection get activeConnection;@JsonKey(unknownEnumValue: ServerConnection.external) set activeConnection(ServerConnection value);
/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerCopyWith<Server> get copyWith => _$ServerCopyWithImpl<Server>(this as Server, _$identity);

  /// Serializes this Server to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Server(externalPort: $externalPort, externalHost: $externalHost, externalSsl: $externalSsl, externalSubdirectory: $externalSubdirectory, headers: $headers, localHost: $localHost, localPort: $localPort, localSsl: $localSsl, localSubdirectory: $localSubdirectory, activeConnection: $activeConnection)';
}


}

/// @nodoc
abstract mixin class $ServerCopyWith<$Res>  {
  factory $ServerCopyWith(Server value, $Res Function(Server) _then) = _$ServerCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'port') int externalPort,@JsonKey(name: 'host') String externalHost,@JsonKey(name: 'ssl') bool externalSsl,@JsonKey(name: 'subdirectory') String? externalSubdirectory, Map<String, String>? headers, String? localHost, int? localPort, bool? localSsl, String? localSubdirectory,@JsonKey(unknownEnumValue: ServerConnection.external) ServerConnection activeConnection
});




}
/// @nodoc
class _$ServerCopyWithImpl<$Res>
    implements $ServerCopyWith<$Res> {
  _$ServerCopyWithImpl(this._self, this._then);

  final Server _self;
  final $Res Function(Server) _then;

/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? externalPort = null,Object? externalHost = null,Object? externalSsl = null,Object? externalSubdirectory = freezed,Object? headers = freezed,Object? localHost = freezed,Object? localPort = freezed,Object? localSsl = freezed,Object? localSubdirectory = freezed,Object? activeConnection = null,}) {
  return _then(_self.copyWith(
externalPort: null == externalPort ? _self.externalPort : externalPort // ignore: cast_nullable_to_non_nullable
as int,externalHost: null == externalHost ? _self.externalHost : externalHost // ignore: cast_nullable_to_non_nullable
as String,externalSsl: null == externalSsl ? _self.externalSsl : externalSsl // ignore: cast_nullable_to_non_nullable
as bool,externalSubdirectory: freezed == externalSubdirectory ? _self.externalSubdirectory : externalSubdirectory // ignore: cast_nullable_to_non_nullable
as String?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,localHost: freezed == localHost ? _self.localHost : localHost // ignore: cast_nullable_to_non_nullable
as String?,localPort: freezed == localPort ? _self.localPort : localPort // ignore: cast_nullable_to_non_nullable
as int?,localSsl: freezed == localSsl ? _self.localSsl : localSsl // ignore: cast_nullable_to_non_nullable
as bool?,localSubdirectory: freezed == localSubdirectory ? _self.localSubdirectory : localSubdirectory // ignore: cast_nullable_to_non_nullable
as String?,activeConnection: null == activeConnection ? _self.activeConnection : activeConnection // ignore: cast_nullable_to_non_nullable
as ServerConnection,
  ));
}

}


/// Adds pattern-matching-related methods to [Server].
extension ServerPatterns on Server {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Server value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Server() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Server value)  $default,){
final _that = this;
switch (_that) {
case _Server():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Server value)?  $default,){
final _that = this;
switch (_that) {
case _Server() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'port')  int externalPort, @JsonKey(name: 'host')  String externalHost, @JsonKey(name: 'ssl')  bool externalSsl, @JsonKey(name: 'subdirectory')  String? externalSubdirectory,  Map<String, String>? headers,  String? localHost,  int? localPort,  bool? localSsl,  String? localSubdirectory, @JsonKey(unknownEnumValue: ServerConnection.external)  ServerConnection activeConnection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Server() when $default != null:
return $default(_that.externalPort,_that.externalHost,_that.externalSsl,_that.externalSubdirectory,_that.headers,_that.localHost,_that.localPort,_that.localSsl,_that.localSubdirectory,_that.activeConnection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'port')  int externalPort, @JsonKey(name: 'host')  String externalHost, @JsonKey(name: 'ssl')  bool externalSsl, @JsonKey(name: 'subdirectory')  String? externalSubdirectory,  Map<String, String>? headers,  String? localHost,  int? localPort,  bool? localSsl,  String? localSubdirectory, @JsonKey(unknownEnumValue: ServerConnection.external)  ServerConnection activeConnection)  $default,) {final _that = this;
switch (_that) {
case _Server():
return $default(_that.externalPort,_that.externalHost,_that.externalSsl,_that.externalSubdirectory,_that.headers,_that.localHost,_that.localPort,_that.localSsl,_that.localSubdirectory,_that.activeConnection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'port')  int externalPort, @JsonKey(name: 'host')  String externalHost, @JsonKey(name: 'ssl')  bool externalSsl, @JsonKey(name: 'subdirectory')  String? externalSubdirectory,  Map<String, String>? headers,  String? localHost,  int? localPort,  bool? localSsl,  String? localSubdirectory, @JsonKey(unknownEnumValue: ServerConnection.external)  ServerConnection activeConnection)?  $default,) {final _that = this;
switch (_that) {
case _Server() when $default != null:
return $default(_that.externalPort,_that.externalHost,_that.externalSsl,_that.externalSubdirectory,_that.headers,_that.localHost,_that.localPort,_that.localSsl,_that.localSubdirectory,_that.activeConnection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Server extends Server {
   _Server({@JsonKey(name: 'port') required this.externalPort, @JsonKey(name: 'host') required this.externalHost, @JsonKey(name: 'ssl') required this.externalSsl, @JsonKey(name: 'subdirectory') this.externalSubdirectory, this.headers, this.localHost, this.localPort, this.localSsl, this.localSubdirectory, @JsonKey(unknownEnumValue: ServerConnection.external) this.activeConnection = ServerConnection.external}): super._();
  factory _Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);

@override@JsonKey(name: 'port')  int externalPort;
@override@JsonKey(name: 'host')  String externalHost;
@override@JsonKey(name: 'ssl')  bool externalSsl;
@override@JsonKey(name: 'subdirectory')  String? externalSubdirectory;
@override  Map<String, String>? headers;
@override  String? localHost;
@override  int? localPort;
@override  bool? localSsl;
@override  String? localSubdirectory;
@override@JsonKey(unknownEnumValue: ServerConnection.external)  ServerConnection activeConnection;

/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerCopyWith<_Server> get copyWith => __$ServerCopyWithImpl<_Server>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerToJson(this, );
}



@override
String toString() {
  return 'Server(externalPort: $externalPort, externalHost: $externalHost, externalSsl: $externalSsl, externalSubdirectory: $externalSubdirectory, headers: $headers, localHost: $localHost, localPort: $localPort, localSsl: $localSsl, localSubdirectory: $localSubdirectory, activeConnection: $activeConnection)';
}


}

/// @nodoc
abstract mixin class _$ServerCopyWith<$Res> implements $ServerCopyWith<$Res> {
  factory _$ServerCopyWith(_Server value, $Res Function(_Server) _then) = __$ServerCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'port') int externalPort,@JsonKey(name: 'host') String externalHost,@JsonKey(name: 'ssl') bool externalSsl,@JsonKey(name: 'subdirectory') String? externalSubdirectory, Map<String, String>? headers, String? localHost, int? localPort, bool? localSsl, String? localSubdirectory,@JsonKey(unknownEnumValue: ServerConnection.external) ServerConnection activeConnection
});




}
/// @nodoc
class __$ServerCopyWithImpl<$Res>
    implements _$ServerCopyWith<$Res> {
  __$ServerCopyWithImpl(this._self, this._then);

  final _Server _self;
  final $Res Function(_Server) _then;

/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? externalPort = null,Object? externalHost = null,Object? externalSsl = null,Object? externalSubdirectory = freezed,Object? headers = freezed,Object? localHost = freezed,Object? localPort = freezed,Object? localSsl = freezed,Object? localSubdirectory = freezed,Object? activeConnection = null,}) {
  return _then(_Server(
externalPort: null == externalPort ? _self.externalPort : externalPort // ignore: cast_nullable_to_non_nullable
as int,externalHost: null == externalHost ? _self.externalHost : externalHost // ignore: cast_nullable_to_non_nullable
as String,externalSsl: null == externalSsl ? _self.externalSsl : externalSsl // ignore: cast_nullable_to_non_nullable
as bool,externalSubdirectory: freezed == externalSubdirectory ? _self.externalSubdirectory : externalSubdirectory // ignore: cast_nullable_to_non_nullable
as String?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,localHost: freezed == localHost ? _self.localHost : localHost // ignore: cast_nullable_to_non_nullable
as String?,localPort: freezed == localPort ? _self.localPort : localPort // ignore: cast_nullable_to_non_nullable
as int?,localSsl: freezed == localSsl ? _self.localSsl : localSsl // ignore: cast_nullable_to_non_nullable
as bool?,localSubdirectory: freezed == localSubdirectory ? _self.localSubdirectory : localSubdirectory // ignore: cast_nullable_to_non_nullable
as String?,activeConnection: null == activeConnection ? _self.activeConnection : activeConnection // ignore: cast_nullable_to_non_nullable
as ServerConnection,
  ));
}


}

// dart format on
