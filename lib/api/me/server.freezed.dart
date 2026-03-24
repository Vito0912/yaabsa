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

 int get port; set port(int value); String get host; set host(String value); bool get ssl; set ssl(bool value); String? get subdirectory; set subdirectory(String? value); Map<String, String>? get headers; set headers(Map<String, String>? value);
/// Create a copy of Server
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerCopyWith<Server> get copyWith => _$ServerCopyWithImpl<Server>(this as Server, _$identity);

  /// Serializes this Server to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'Server(port: $port, host: $host, ssl: $ssl, subdirectory: $subdirectory, headers: $headers)';
}


}

/// @nodoc
abstract mixin class $ServerCopyWith<$Res>  {
  factory $ServerCopyWith(Server value, $Res Function(Server) _then) = _$ServerCopyWithImpl;
@useResult
$Res call({
 int port, String host, bool ssl, String? subdirectory, Map<String, String>? headers
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
@pragma('vm:prefer-inline') @override $Res call({Object? port = null,Object? host = null,Object? ssl = null,Object? subdirectory = freezed,Object? headers = freezed,}) {
  return _then(_self.copyWith(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,ssl: null == ssl ? _self.ssl : ssl // ignore: cast_nullable_to_non_nullable
as bool,subdirectory: freezed == subdirectory ? _self.subdirectory : subdirectory // ignore: cast_nullable_to_non_nullable
as String?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int port,  String host,  bool ssl,  String? subdirectory,  Map<String, String>? headers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Server() when $default != null:
return $default(_that.port,_that.host,_that.ssl,_that.subdirectory,_that.headers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int port,  String host,  bool ssl,  String? subdirectory,  Map<String, String>? headers)  $default,) {final _that = this;
switch (_that) {
case _Server():
return $default(_that.port,_that.host,_that.ssl,_that.subdirectory,_that.headers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int port,  String host,  bool ssl,  String? subdirectory,  Map<String, String>? headers)?  $default,) {final _that = this;
switch (_that) {
case _Server() when $default != null:
return $default(_that.port,_that.host,_that.ssl,_that.subdirectory,_that.headers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Server extends Server {
   _Server({required this.port, required this.host, required this.ssl, this.subdirectory, this.headers}): super._();
  factory _Server.fromJson(Map<String, dynamic> json) => _$ServerFromJson(json);

@override  int port;
@override  String host;
@override  bool ssl;
@override  String? subdirectory;
@override  Map<String, String>? headers;

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
  return 'Server(port: $port, host: $host, ssl: $ssl, subdirectory: $subdirectory, headers: $headers)';
}


}

/// @nodoc
abstract mixin class _$ServerCopyWith<$Res> implements $ServerCopyWith<$Res> {
  factory _$ServerCopyWith(_Server value, $Res Function(_Server) _then) = __$ServerCopyWithImpl;
@override @useResult
$Res call({
 int port, String host, bool ssl, String? subdirectory, Map<String, String>? headers
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
@override @pragma('vm:prefer-inline') $Res call({Object? port = null,Object? host = null,Object? ssl = null,Object? subdirectory = freezed,Object? headers = freezed,}) {
  return _then(_Server(
port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,ssl: null == ssl ? _self.ssl : ssl // ignore: cast_nullable_to_non_nullable
as bool,subdirectory: freezed == subdirectory ? _self.subdirectory : subdirectory // ignore: cast_nullable_to_non_nullable
as String?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on
