// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_message_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocketUserMessageEvent {

@JsonKey(name: 'message') String get message;@JsonKey(name: 'client') SocketUserMessageClient? get client;@JsonKey(name: 'sender') SocketUserMessageSender get sender;@JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic) int? get sentAt;
/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketUserMessageEventCopyWith<SocketUserMessageEvent> get copyWith => _$SocketUserMessageEventCopyWithImpl<SocketUserMessageEvent>(this as SocketUserMessageEvent, _$identity);

  /// Serializes this SocketUserMessageEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketUserMessageEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.client, client) || other.client == client)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,client,sender,sentAt);

@override
String toString() {
  return 'SocketUserMessageEvent(message: $message, client: $client, sender: $sender, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class $SocketUserMessageEventCopyWith<$Res>  {
  factory $SocketUserMessageEventCopyWith(SocketUserMessageEvent value, $Res Function(SocketUserMessageEvent) _then) = _$SocketUserMessageEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'message') String message,@JsonKey(name: 'client') SocketUserMessageClient? client,@JsonKey(name: 'sender') SocketUserMessageSender sender,@JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic) int? sentAt
});


$SocketUserMessageClientCopyWith<$Res>? get client;$SocketUserMessageSenderCopyWith<$Res> get sender;

}
/// @nodoc
class _$SocketUserMessageEventCopyWithImpl<$Res>
    implements $SocketUserMessageEventCopyWith<$Res> {
  _$SocketUserMessageEventCopyWithImpl(this._self, this._then);

  final SocketUserMessageEvent _self;
  final $Res Function(SocketUserMessageEvent) _then;

/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = null,Object? client = freezed,Object? sender = null,Object? sentAt = freezed,}) {
  return _then(_self.copyWith(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as SocketUserMessageClient?,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as SocketUserMessageSender,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocketUserMessageClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $SocketUserMessageClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocketUserMessageSenderCopyWith<$Res> get sender {
  
  return $SocketUserMessageSenderCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}
}


/// Adds pattern-matching-related methods to [SocketUserMessageEvent].
extension SocketUserMessageEventPatterns on SocketUserMessageEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocketUserMessageEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocketUserMessageEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocketUserMessageEvent value)  $default,){
final _that = this;
switch (_that) {
case _SocketUserMessageEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocketUserMessageEvent value)?  $default,){
final _that = this;
switch (_that) {
case _SocketUserMessageEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'client')  SocketUserMessageClient? client, @JsonKey(name: 'sender')  SocketUserMessageSender sender, @JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic)  int? sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketUserMessageEvent() when $default != null:
return $default(_that.message,_that.client,_that.sender,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'client')  SocketUserMessageClient? client, @JsonKey(name: 'sender')  SocketUserMessageSender sender, @JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic)  int? sentAt)  $default,) {final _that = this;
switch (_that) {
case _SocketUserMessageEvent():
return $default(_that.message,_that.client,_that.sender,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'message')  String message, @JsonKey(name: 'client')  SocketUserMessageClient? client, @JsonKey(name: 'sender')  SocketUserMessageSender sender, @JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic)  int? sentAt)?  $default,) {final _that = this;
switch (_that) {
case _SocketUserMessageEvent() when $default != null:
return $default(_that.message,_that.client,_that.sender,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketUserMessageEvent implements SocketUserMessageEvent {
  const _SocketUserMessageEvent({@JsonKey(name: 'message') required this.message, @JsonKey(name: 'client') this.client, @JsonKey(name: 'sender') required this.sender, @JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic) this.sentAt});
  factory _SocketUserMessageEvent.fromJson(Map<String, dynamic> json) => _$SocketUserMessageEventFromJson(json);

@override@JsonKey(name: 'message') final  String message;
@override@JsonKey(name: 'client') final  SocketUserMessageClient? client;
@override@JsonKey(name: 'sender') final  SocketUserMessageSender sender;
@override@JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic) final  int? sentAt;

/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocketUserMessageEventCopyWith<_SocketUserMessageEvent> get copyWith => __$SocketUserMessageEventCopyWithImpl<_SocketUserMessageEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocketUserMessageEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketUserMessageEvent&&(identical(other.message, message) || other.message == message)&&(identical(other.client, client) || other.client == client)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,message,client,sender,sentAt);

@override
String toString() {
  return 'SocketUserMessageEvent(message: $message, client: $client, sender: $sender, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$SocketUserMessageEventCopyWith<$Res> implements $SocketUserMessageEventCopyWith<$Res> {
  factory _$SocketUserMessageEventCopyWith(_SocketUserMessageEvent value, $Res Function(_SocketUserMessageEvent) _then) = __$SocketUserMessageEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'message') String message,@JsonKey(name: 'client') SocketUserMessageClient? client,@JsonKey(name: 'sender') SocketUserMessageSender sender,@JsonKey(name: 'sentAt', fromJson: jsonIntFromDynamic) int? sentAt
});


@override $SocketUserMessageClientCopyWith<$Res>? get client;@override $SocketUserMessageSenderCopyWith<$Res> get sender;

}
/// @nodoc
class __$SocketUserMessageEventCopyWithImpl<$Res>
    implements _$SocketUserMessageEventCopyWith<$Res> {
  __$SocketUserMessageEventCopyWithImpl(this._self, this._then);

  final _SocketUserMessageEvent _self;
  final $Res Function(_SocketUserMessageEvent) _then;

/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = null,Object? client = freezed,Object? sender = null,Object? sentAt = freezed,}) {
  return _then(_SocketUserMessageEvent(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as SocketUserMessageClient?,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as SocketUserMessageSender,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocketUserMessageClientCopyWith<$Res>? get client {
    if (_self.client == null) {
    return null;
  }

  return $SocketUserMessageClientCopyWith<$Res>(_self.client!, (value) {
    return _then(_self.copyWith(client: value));
  });
}/// Create a copy of SocketUserMessageEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SocketUserMessageSenderCopyWith<$Res> get sender {
  
  return $SocketUserMessageSenderCopyWith<$Res>(_self.sender, (value) {
    return _then(_self.copyWith(sender: value));
  });
}
}


/// @nodoc
mixin _$SocketUserMessageClient {

@JsonKey(name: 'client') String? get client;@JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic) int? get clientVersion;@JsonKey(name: 'clientId') String? get clientId;
/// Create a copy of SocketUserMessageClient
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketUserMessageClientCopyWith<SocketUserMessageClient> get copyWith => _$SocketUserMessageClientCopyWithImpl<SocketUserMessageClient>(this as SocketUserMessageClient, _$identity);

  /// Serializes this SocketUserMessageClient to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketUserMessageClient&&(identical(other.client, client) || other.client == client)&&(identical(other.clientVersion, clientVersion) || other.clientVersion == clientVersion)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,client,clientVersion,clientId);

@override
String toString() {
  return 'SocketUserMessageClient(client: $client, clientVersion: $clientVersion, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class $SocketUserMessageClientCopyWith<$Res>  {
  factory $SocketUserMessageClientCopyWith(SocketUserMessageClient value, $Res Function(SocketUserMessageClient) _then) = _$SocketUserMessageClientCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'client') String? client,@JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic) int? clientVersion,@JsonKey(name: 'clientId') String? clientId
});




}
/// @nodoc
class _$SocketUserMessageClientCopyWithImpl<$Res>
    implements $SocketUserMessageClientCopyWith<$Res> {
  _$SocketUserMessageClientCopyWithImpl(this._self, this._then);

  final SocketUserMessageClient _self;
  final $Res Function(SocketUserMessageClient) _then;

/// Create a copy of SocketUserMessageClient
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? client = freezed,Object? clientVersion = freezed,Object? clientId = freezed,}) {
  return _then(_self.copyWith(
client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String?,clientVersion: freezed == clientVersion ? _self.clientVersion : clientVersion // ignore: cast_nullable_to_non_nullable
as int?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SocketUserMessageClient].
extension SocketUserMessageClientPatterns on SocketUserMessageClient {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocketUserMessageClient value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocketUserMessageClient() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocketUserMessageClient value)  $default,){
final _that = this;
switch (_that) {
case _SocketUserMessageClient():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocketUserMessageClient value)?  $default,){
final _that = this;
switch (_that) {
case _SocketUserMessageClient() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'client')  String? client, @JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic)  int? clientVersion, @JsonKey(name: 'clientId')  String? clientId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketUserMessageClient() when $default != null:
return $default(_that.client,_that.clientVersion,_that.clientId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'client')  String? client, @JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic)  int? clientVersion, @JsonKey(name: 'clientId')  String? clientId)  $default,) {final _that = this;
switch (_that) {
case _SocketUserMessageClient():
return $default(_that.client,_that.clientVersion,_that.clientId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'client')  String? client, @JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic)  int? clientVersion, @JsonKey(name: 'clientId')  String? clientId)?  $default,) {final _that = this;
switch (_that) {
case _SocketUserMessageClient() when $default != null:
return $default(_that.client,_that.clientVersion,_that.clientId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketUserMessageClient implements SocketUserMessageClient {
  const _SocketUserMessageClient({@JsonKey(name: 'client') this.client, @JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic) this.clientVersion, @JsonKey(name: 'clientId') this.clientId});
  factory _SocketUserMessageClient.fromJson(Map<String, dynamic> json) => _$SocketUserMessageClientFromJson(json);

@override@JsonKey(name: 'client') final  String? client;
@override@JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic) final  int? clientVersion;
@override@JsonKey(name: 'clientId') final  String? clientId;

/// Create a copy of SocketUserMessageClient
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocketUserMessageClientCopyWith<_SocketUserMessageClient> get copyWith => __$SocketUserMessageClientCopyWithImpl<_SocketUserMessageClient>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocketUserMessageClientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketUserMessageClient&&(identical(other.client, client) || other.client == client)&&(identical(other.clientVersion, clientVersion) || other.clientVersion == clientVersion)&&(identical(other.clientId, clientId) || other.clientId == clientId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,client,clientVersion,clientId);

@override
String toString() {
  return 'SocketUserMessageClient(client: $client, clientVersion: $clientVersion, clientId: $clientId)';
}


}

/// @nodoc
abstract mixin class _$SocketUserMessageClientCopyWith<$Res> implements $SocketUserMessageClientCopyWith<$Res> {
  factory _$SocketUserMessageClientCopyWith(_SocketUserMessageClient value, $Res Function(_SocketUserMessageClient) _then) = __$SocketUserMessageClientCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'client') String? client,@JsonKey(name: 'clientVersion', fromJson: jsonIntFromDynamic) int? clientVersion,@JsonKey(name: 'clientId') String? clientId
});




}
/// @nodoc
class __$SocketUserMessageClientCopyWithImpl<$Res>
    implements _$SocketUserMessageClientCopyWith<$Res> {
  __$SocketUserMessageClientCopyWithImpl(this._self, this._then);

  final _SocketUserMessageClient _self;
  final $Res Function(_SocketUserMessageClient) _then;

/// Create a copy of SocketUserMessageClient
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? client = freezed,Object? clientVersion = freezed,Object? clientId = freezed,}) {
  return _then(_SocketUserMessageClient(
client: freezed == client ? _self.client : client // ignore: cast_nullable_to_non_nullable
as String?,clientVersion: freezed == clientVersion ? _self.clientVersion : clientVersion // ignore: cast_nullable_to_non_nullable
as int?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SocketUserMessageSender {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'username') String? get username;@JsonKey(name: 'type') String? get type;
/// Create a copy of SocketUserMessageSender
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketUserMessageSenderCopyWith<SocketUserMessageSender> get copyWith => _$SocketUserMessageSenderCopyWithImpl<SocketUserMessageSender>(this as SocketUserMessageSender, _$identity);

  /// Serializes this SocketUserMessageSender to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketUserMessageSender&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,type);

@override
String toString() {
  return 'SocketUserMessageSender(id: $id, username: $username, type: $type)';
}


}

/// @nodoc
abstract mixin class $SocketUserMessageSenderCopyWith<$Res>  {
  factory $SocketUserMessageSenderCopyWith(SocketUserMessageSender value, $Res Function(SocketUserMessageSender) _then) = _$SocketUserMessageSenderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'username') String? username,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$SocketUserMessageSenderCopyWithImpl<$Res>
    implements $SocketUserMessageSenderCopyWith<$Res> {
  _$SocketUserMessageSenderCopyWithImpl(this._self, this._then);

  final SocketUserMessageSender _self;
  final $Res Function(SocketUserMessageSender) _then;

/// Create a copy of SocketUserMessageSender
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SocketUserMessageSender].
extension SocketUserMessageSenderPatterns on SocketUserMessageSender {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocketUserMessageSender value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocketUserMessageSender() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocketUserMessageSender value)  $default,){
final _that = this;
switch (_that) {
case _SocketUserMessageSender():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocketUserMessageSender value)?  $default,){
final _that = this;
switch (_that) {
case _SocketUserMessageSender() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String? username, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketUserMessageSender() when $default != null:
return $default(_that.id,_that.username,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String? username, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _SocketUserMessageSender():
return $default(_that.id,_that.username,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String? username, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _SocketUserMessageSender() when $default != null:
return $default(_that.id,_that.username,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketUserMessageSender implements SocketUserMessageSender {
  const _SocketUserMessageSender({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'username') this.username, @JsonKey(name: 'type') this.type});
  factory _SocketUserMessageSender.fromJson(Map<String, dynamic> json) => _$SocketUserMessageSenderFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'username') final  String? username;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of SocketUserMessageSender
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocketUserMessageSenderCopyWith<_SocketUserMessageSender> get copyWith => __$SocketUserMessageSenderCopyWithImpl<_SocketUserMessageSender>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocketUserMessageSenderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketUserMessageSender&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,type);

@override
String toString() {
  return 'SocketUserMessageSender(id: $id, username: $username, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SocketUserMessageSenderCopyWith<$Res> implements $SocketUserMessageSenderCopyWith<$Res> {
  factory _$SocketUserMessageSenderCopyWith(_SocketUserMessageSender value, $Res Function(_SocketUserMessageSender) _then) = __$SocketUserMessageSenderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'username') String? username,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$SocketUserMessageSenderCopyWithImpl<$Res>
    implements _$SocketUserMessageSenderCopyWith<$Res> {
  __$SocketUserMessageSenderCopyWithImpl(this._self, this._then);

  final _SocketUserMessageSender _self;
  final $Res Function(_SocketUserMessageSender) _then;

/// Create a copy of SocketUserMessageSender
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = freezed,Object? type = freezed,}) {
  return _then(_SocketUserMessageSender(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
