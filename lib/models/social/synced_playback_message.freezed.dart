// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'synced_playback_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncedPlaybackMessage {

@JsonKey(name: 'feature') String get feature;@JsonKey(name: 'type') String get type;@JsonKey(name: 'sessionId') String get sessionId;@JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic) int get messageVersion;@JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic) int get minClientVersion;@JsonKey(name: 'invite') SyncedPlaybackInvitePayload? get invite;@JsonKey(name: 'inviteResponse') SyncedPlaybackInviteResponsePayload? get inviteResponse;@JsonKey(name: 'control') SyncedPlaybackControlPayload? get control;@JsonKey(name: 'sessionEnd') SyncedPlaybackSessionEndPayload? get sessionEnd;
/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncedPlaybackMessageCopyWith<SyncedPlaybackMessage> get copyWith => _$SyncedPlaybackMessageCopyWithImpl<SyncedPlaybackMessage>(this as SyncedPlaybackMessage, _$identity);

  /// Serializes this SyncedPlaybackMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncedPlaybackMessage&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.type, type) || other.type == type)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.messageVersion, messageVersion) || other.messageVersion == messageVersion)&&(identical(other.minClientVersion, minClientVersion) || other.minClientVersion == minClientVersion)&&(identical(other.invite, invite) || other.invite == invite)&&(identical(other.inviteResponse, inviteResponse) || other.inviteResponse == inviteResponse)&&(identical(other.control, control) || other.control == control)&&(identical(other.sessionEnd, sessionEnd) || other.sessionEnd == sessionEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feature,type,sessionId,messageVersion,minClientVersion,invite,inviteResponse,control,sessionEnd);

@override
String toString() {
  return 'SyncedPlaybackMessage(feature: $feature, type: $type, sessionId: $sessionId, messageVersion: $messageVersion, minClientVersion: $minClientVersion, invite: $invite, inviteResponse: $inviteResponse, control: $control, sessionEnd: $sessionEnd)';
}


}

/// @nodoc
abstract mixin class $SyncedPlaybackMessageCopyWith<$Res>  {
  factory $SyncedPlaybackMessageCopyWith(SyncedPlaybackMessage value, $Res Function(SyncedPlaybackMessage) _then) = _$SyncedPlaybackMessageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'feature') String feature,@JsonKey(name: 'type') String type,@JsonKey(name: 'sessionId') String sessionId,@JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic) int messageVersion,@JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic) int minClientVersion,@JsonKey(name: 'invite') SyncedPlaybackInvitePayload? invite,@JsonKey(name: 'inviteResponse') SyncedPlaybackInviteResponsePayload? inviteResponse,@JsonKey(name: 'control') SyncedPlaybackControlPayload? control,@JsonKey(name: 'sessionEnd') SyncedPlaybackSessionEndPayload? sessionEnd
});


$SyncedPlaybackInvitePayloadCopyWith<$Res>? get invite;$SyncedPlaybackInviteResponsePayloadCopyWith<$Res>? get inviteResponse;$SyncedPlaybackControlPayloadCopyWith<$Res>? get control;$SyncedPlaybackSessionEndPayloadCopyWith<$Res>? get sessionEnd;

}
/// @nodoc
class _$SyncedPlaybackMessageCopyWithImpl<$Res>
    implements $SyncedPlaybackMessageCopyWith<$Res> {
  _$SyncedPlaybackMessageCopyWithImpl(this._self, this._then);

  final SyncedPlaybackMessage _self;
  final $Res Function(SyncedPlaybackMessage) _then;

/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feature = null,Object? type = null,Object? sessionId = null,Object? messageVersion = null,Object? minClientVersion = null,Object? invite = freezed,Object? inviteResponse = freezed,Object? control = freezed,Object? sessionEnd = freezed,}) {
  return _then(_self.copyWith(
feature: null == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,messageVersion: null == messageVersion ? _self.messageVersion : messageVersion // ignore: cast_nullable_to_non_nullable
as int,minClientVersion: null == minClientVersion ? _self.minClientVersion : minClientVersion // ignore: cast_nullable_to_non_nullable
as int,invite: freezed == invite ? _self.invite : invite // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackInvitePayload?,inviteResponse: freezed == inviteResponse ? _self.inviteResponse : inviteResponse // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackInviteResponsePayload?,control: freezed == control ? _self.control : control // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackControlPayload?,sessionEnd: freezed == sessionEnd ? _self.sessionEnd : sessionEnd // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackSessionEndPayload?,
  ));
}
/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackInvitePayloadCopyWith<$Res>? get invite {
    if (_self.invite == null) {
    return null;
  }

  return $SyncedPlaybackInvitePayloadCopyWith<$Res>(_self.invite!, (value) {
    return _then(_self.copyWith(invite: value));
  });
}/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackInviteResponsePayloadCopyWith<$Res>? get inviteResponse {
    if (_self.inviteResponse == null) {
    return null;
  }

  return $SyncedPlaybackInviteResponsePayloadCopyWith<$Res>(_self.inviteResponse!, (value) {
    return _then(_self.copyWith(inviteResponse: value));
  });
}/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<$Res>? get control {
    if (_self.control == null) {
    return null;
  }

  return $SyncedPlaybackControlPayloadCopyWith<$Res>(_self.control!, (value) {
    return _then(_self.copyWith(control: value));
  });
}/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackSessionEndPayloadCopyWith<$Res>? get sessionEnd {
    if (_self.sessionEnd == null) {
    return null;
  }

  return $SyncedPlaybackSessionEndPayloadCopyWith<$Res>(_self.sessionEnd!, (value) {
    return _then(_self.copyWith(sessionEnd: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncedPlaybackMessage].
extension SyncedPlaybackMessagePatterns on SyncedPlaybackMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncedPlaybackMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncedPlaybackMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncedPlaybackMessage value)  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncedPlaybackMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'feature')  String feature, @JsonKey(name: 'type')  String type, @JsonKey(name: 'sessionId')  String sessionId, @JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic)  int messageVersion, @JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic)  int minClientVersion, @JsonKey(name: 'invite')  SyncedPlaybackInvitePayload? invite, @JsonKey(name: 'inviteResponse')  SyncedPlaybackInviteResponsePayload? inviteResponse, @JsonKey(name: 'control')  SyncedPlaybackControlPayload? control, @JsonKey(name: 'sessionEnd')  SyncedPlaybackSessionEndPayload? sessionEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncedPlaybackMessage() when $default != null:
return $default(_that.feature,_that.type,_that.sessionId,_that.messageVersion,_that.minClientVersion,_that.invite,_that.inviteResponse,_that.control,_that.sessionEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'feature')  String feature, @JsonKey(name: 'type')  String type, @JsonKey(name: 'sessionId')  String sessionId, @JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic)  int messageVersion, @JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic)  int minClientVersion, @JsonKey(name: 'invite')  SyncedPlaybackInvitePayload? invite, @JsonKey(name: 'inviteResponse')  SyncedPlaybackInviteResponsePayload? inviteResponse, @JsonKey(name: 'control')  SyncedPlaybackControlPayload? control, @JsonKey(name: 'sessionEnd')  SyncedPlaybackSessionEndPayload? sessionEnd)  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackMessage():
return $default(_that.feature,_that.type,_that.sessionId,_that.messageVersion,_that.minClientVersion,_that.invite,_that.inviteResponse,_that.control,_that.sessionEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'feature')  String feature, @JsonKey(name: 'type')  String type, @JsonKey(name: 'sessionId')  String sessionId, @JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic)  int messageVersion, @JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic)  int minClientVersion, @JsonKey(name: 'invite')  SyncedPlaybackInvitePayload? invite, @JsonKey(name: 'inviteResponse')  SyncedPlaybackInviteResponsePayload? inviteResponse, @JsonKey(name: 'control')  SyncedPlaybackControlPayload? control, @JsonKey(name: 'sessionEnd')  SyncedPlaybackSessionEndPayload? sessionEnd)?  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackMessage() when $default != null:
return $default(_that.feature,_that.type,_that.sessionId,_that.messageVersion,_that.minClientVersion,_that.invite,_that.inviteResponse,_that.control,_that.sessionEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncedPlaybackMessage implements SyncedPlaybackMessage {
  const _SyncedPlaybackMessage({@JsonKey(name: 'feature') required this.feature, @JsonKey(name: 'type') required this.type, @JsonKey(name: 'sessionId') required this.sessionId, @JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic) this.messageVersion = 1, @JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic) this.minClientVersion = 1, @JsonKey(name: 'invite') this.invite, @JsonKey(name: 'inviteResponse') this.inviteResponse, @JsonKey(name: 'control') this.control, @JsonKey(name: 'sessionEnd') this.sessionEnd});
  factory _SyncedPlaybackMessage.fromJson(Map<String, dynamic> json) => _$SyncedPlaybackMessageFromJson(json);

@override@JsonKey(name: 'feature') final  String feature;
@override@JsonKey(name: 'type') final  String type;
@override@JsonKey(name: 'sessionId') final  String sessionId;
@override@JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic) final  int messageVersion;
@override@JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic) final  int minClientVersion;
@override@JsonKey(name: 'invite') final  SyncedPlaybackInvitePayload? invite;
@override@JsonKey(name: 'inviteResponse') final  SyncedPlaybackInviteResponsePayload? inviteResponse;
@override@JsonKey(name: 'control') final  SyncedPlaybackControlPayload? control;
@override@JsonKey(name: 'sessionEnd') final  SyncedPlaybackSessionEndPayload? sessionEnd;

/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncedPlaybackMessageCopyWith<_SyncedPlaybackMessage> get copyWith => __$SyncedPlaybackMessageCopyWithImpl<_SyncedPlaybackMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncedPlaybackMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncedPlaybackMessage&&(identical(other.feature, feature) || other.feature == feature)&&(identical(other.type, type) || other.type == type)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.messageVersion, messageVersion) || other.messageVersion == messageVersion)&&(identical(other.minClientVersion, minClientVersion) || other.minClientVersion == minClientVersion)&&(identical(other.invite, invite) || other.invite == invite)&&(identical(other.inviteResponse, inviteResponse) || other.inviteResponse == inviteResponse)&&(identical(other.control, control) || other.control == control)&&(identical(other.sessionEnd, sessionEnd) || other.sessionEnd == sessionEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,feature,type,sessionId,messageVersion,minClientVersion,invite,inviteResponse,control,sessionEnd);

@override
String toString() {
  return 'SyncedPlaybackMessage(feature: $feature, type: $type, sessionId: $sessionId, messageVersion: $messageVersion, minClientVersion: $minClientVersion, invite: $invite, inviteResponse: $inviteResponse, control: $control, sessionEnd: $sessionEnd)';
}


}

/// @nodoc
abstract mixin class _$SyncedPlaybackMessageCopyWith<$Res> implements $SyncedPlaybackMessageCopyWith<$Res> {
  factory _$SyncedPlaybackMessageCopyWith(_SyncedPlaybackMessage value, $Res Function(_SyncedPlaybackMessage) _then) = __$SyncedPlaybackMessageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'feature') String feature,@JsonKey(name: 'type') String type,@JsonKey(name: 'sessionId') String sessionId,@JsonKey(name: 'messageVersion', fromJson: jsonIntRequiredFromDynamic) int messageVersion,@JsonKey(name: 'minClientVersion', fromJson: jsonIntRequiredFromDynamic) int minClientVersion,@JsonKey(name: 'invite') SyncedPlaybackInvitePayload? invite,@JsonKey(name: 'inviteResponse') SyncedPlaybackInviteResponsePayload? inviteResponse,@JsonKey(name: 'control') SyncedPlaybackControlPayload? control,@JsonKey(name: 'sessionEnd') SyncedPlaybackSessionEndPayload? sessionEnd
});


@override $SyncedPlaybackInvitePayloadCopyWith<$Res>? get invite;@override $SyncedPlaybackInviteResponsePayloadCopyWith<$Res>? get inviteResponse;@override $SyncedPlaybackControlPayloadCopyWith<$Res>? get control;@override $SyncedPlaybackSessionEndPayloadCopyWith<$Res>? get sessionEnd;

}
/// @nodoc
class __$SyncedPlaybackMessageCopyWithImpl<$Res>
    implements _$SyncedPlaybackMessageCopyWith<$Res> {
  __$SyncedPlaybackMessageCopyWithImpl(this._self, this._then);

  final _SyncedPlaybackMessage _self;
  final $Res Function(_SyncedPlaybackMessage) _then;

/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feature = null,Object? type = null,Object? sessionId = null,Object? messageVersion = null,Object? minClientVersion = null,Object? invite = freezed,Object? inviteResponse = freezed,Object? control = freezed,Object? sessionEnd = freezed,}) {
  return _then(_SyncedPlaybackMessage(
feature: null == feature ? _self.feature : feature // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,messageVersion: null == messageVersion ? _self.messageVersion : messageVersion // ignore: cast_nullable_to_non_nullable
as int,minClientVersion: null == minClientVersion ? _self.minClientVersion : minClientVersion // ignore: cast_nullable_to_non_nullable
as int,invite: freezed == invite ? _self.invite : invite // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackInvitePayload?,inviteResponse: freezed == inviteResponse ? _self.inviteResponse : inviteResponse // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackInviteResponsePayload?,control: freezed == control ? _self.control : control // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackControlPayload?,sessionEnd: freezed == sessionEnd ? _self.sessionEnd : sessionEnd // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackSessionEndPayload?,
  ));
}

/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackInvitePayloadCopyWith<$Res>? get invite {
    if (_self.invite == null) {
    return null;
  }

  return $SyncedPlaybackInvitePayloadCopyWith<$Res>(_self.invite!, (value) {
    return _then(_self.copyWith(invite: value));
  });
}/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackInviteResponsePayloadCopyWith<$Res>? get inviteResponse {
    if (_self.inviteResponse == null) {
    return null;
  }

  return $SyncedPlaybackInviteResponsePayloadCopyWith<$Res>(_self.inviteResponse!, (value) {
    return _then(_self.copyWith(inviteResponse: value));
  });
}/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<$Res>? get control {
    if (_self.control == null) {
    return null;
  }

  return $SyncedPlaybackControlPayloadCopyWith<$Res>(_self.control!, (value) {
    return _then(_self.copyWith(control: value));
  });
}/// Create a copy of SyncedPlaybackMessage
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackSessionEndPayloadCopyWith<$Res>? get sessionEnd {
    if (_self.sessionEnd == null) {
    return null;
  }

  return $SyncedPlaybackSessionEndPayloadCopyWith<$Res>(_self.sessionEnd!, (value) {
    return _then(_self.copyWith(sessionEnd: value));
  });
}
}


/// @nodoc
mixin _$SyncedPlaybackInvitePayload {

@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? get snapshot;
/// Create a copy of SyncedPlaybackInvitePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncedPlaybackInvitePayloadCopyWith<SyncedPlaybackInvitePayload> get copyWith => _$SyncedPlaybackInvitePayloadCopyWithImpl<SyncedPlaybackInvitePayload>(this as SyncedPlaybackInvitePayload, _$identity);

  /// Serializes this SyncedPlaybackInvitePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncedPlaybackInvitePayload&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,snapshot);

@override
String toString() {
  return 'SyncedPlaybackInvitePayload(snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $SyncedPlaybackInvitePayloadCopyWith<$Res>  {
  factory $SyncedPlaybackInvitePayloadCopyWith(SyncedPlaybackInvitePayload value, $Res Function(SyncedPlaybackInvitePayload) _then) = _$SyncedPlaybackInvitePayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? snapshot
});


$SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot;

}
/// @nodoc
class _$SyncedPlaybackInvitePayloadCopyWithImpl<$Res>
    implements $SyncedPlaybackInvitePayloadCopyWith<$Res> {
  _$SyncedPlaybackInvitePayloadCopyWithImpl(this._self, this._then);

  final SyncedPlaybackInvitePayload _self;
  final $Res Function(SyncedPlaybackInvitePayload) _then;

/// Create a copy of SyncedPlaybackInvitePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? snapshot = freezed,}) {
  return _then(_self.copyWith(
snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackControlPayload?,
  ));
}
/// Create a copy of SyncedPlaybackInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $SyncedPlaybackControlPayloadCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncedPlaybackInvitePayload].
extension SyncedPlaybackInvitePayloadPatterns on SyncedPlaybackInvitePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncedPlaybackInvitePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncedPlaybackInvitePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncedPlaybackInvitePayload value)  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackInvitePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncedPlaybackInvitePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackInvitePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'snapshot')  SyncedPlaybackControlPayload? snapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncedPlaybackInvitePayload() when $default != null:
return $default(_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'snapshot')  SyncedPlaybackControlPayload? snapshot)  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackInvitePayload():
return $default(_that.snapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'snapshot')  SyncedPlaybackControlPayload? snapshot)?  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackInvitePayload() when $default != null:
return $default(_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncedPlaybackInvitePayload implements SyncedPlaybackInvitePayload {
  const _SyncedPlaybackInvitePayload({@JsonKey(name: 'snapshot') this.snapshot});
  factory _SyncedPlaybackInvitePayload.fromJson(Map<String, dynamic> json) => _$SyncedPlaybackInvitePayloadFromJson(json);

@override@JsonKey(name: 'snapshot') final  SyncedPlaybackControlPayload? snapshot;

/// Create a copy of SyncedPlaybackInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncedPlaybackInvitePayloadCopyWith<_SyncedPlaybackInvitePayload> get copyWith => __$SyncedPlaybackInvitePayloadCopyWithImpl<_SyncedPlaybackInvitePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncedPlaybackInvitePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncedPlaybackInvitePayload&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,snapshot);

@override
String toString() {
  return 'SyncedPlaybackInvitePayload(snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class _$SyncedPlaybackInvitePayloadCopyWith<$Res> implements $SyncedPlaybackInvitePayloadCopyWith<$Res> {
  factory _$SyncedPlaybackInvitePayloadCopyWith(_SyncedPlaybackInvitePayload value, $Res Function(_SyncedPlaybackInvitePayload) _then) = __$SyncedPlaybackInvitePayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? snapshot
});


@override $SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot;

}
/// @nodoc
class __$SyncedPlaybackInvitePayloadCopyWithImpl<$Res>
    implements _$SyncedPlaybackInvitePayloadCopyWith<$Res> {
  __$SyncedPlaybackInvitePayloadCopyWithImpl(this._self, this._then);

  final _SyncedPlaybackInvitePayload _self;
  final $Res Function(_SyncedPlaybackInvitePayload) _then;

/// Create a copy of SyncedPlaybackInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? snapshot = freezed,}) {
  return _then(_SyncedPlaybackInvitePayload(
snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackControlPayload?,
  ));
}

/// Create a copy of SyncedPlaybackInvitePayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $SyncedPlaybackControlPayloadCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// @nodoc
mixin _$SyncedPlaybackInviteResponsePayload {

@JsonKey(name: 'decision') String get decision;@JsonKey(name: 'reason') String? get reason;@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? get snapshot;
/// Create a copy of SyncedPlaybackInviteResponsePayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncedPlaybackInviteResponsePayloadCopyWith<SyncedPlaybackInviteResponsePayload> get copyWith => _$SyncedPlaybackInviteResponsePayloadCopyWithImpl<SyncedPlaybackInviteResponsePayload>(this as SyncedPlaybackInviteResponsePayload, _$identity);

  /// Serializes this SyncedPlaybackInviteResponsePayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncedPlaybackInviteResponsePayload&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,decision,reason,snapshot);

@override
String toString() {
  return 'SyncedPlaybackInviteResponsePayload(decision: $decision, reason: $reason, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $SyncedPlaybackInviteResponsePayloadCopyWith<$Res>  {
  factory $SyncedPlaybackInviteResponsePayloadCopyWith(SyncedPlaybackInviteResponsePayload value, $Res Function(SyncedPlaybackInviteResponsePayload) _then) = _$SyncedPlaybackInviteResponsePayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'decision') String decision,@JsonKey(name: 'reason') String? reason,@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? snapshot
});


$SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot;

}
/// @nodoc
class _$SyncedPlaybackInviteResponsePayloadCopyWithImpl<$Res>
    implements $SyncedPlaybackInviteResponsePayloadCopyWith<$Res> {
  _$SyncedPlaybackInviteResponsePayloadCopyWithImpl(this._self, this._then);

  final SyncedPlaybackInviteResponsePayload _self;
  final $Res Function(SyncedPlaybackInviteResponsePayload) _then;

/// Create a copy of SyncedPlaybackInviteResponsePayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? decision = null,Object? reason = freezed,Object? snapshot = freezed,}) {
  return _then(_self.copyWith(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackControlPayload?,
  ));
}
/// Create a copy of SyncedPlaybackInviteResponsePayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $SyncedPlaybackControlPayloadCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [SyncedPlaybackInviteResponsePayload].
extension SyncedPlaybackInviteResponsePayloadPatterns on SyncedPlaybackInviteResponsePayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncedPlaybackInviteResponsePayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncedPlaybackInviteResponsePayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncedPlaybackInviteResponsePayload value)  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackInviteResponsePayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncedPlaybackInviteResponsePayload value)?  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackInviteResponsePayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'decision')  String decision, @JsonKey(name: 'reason')  String? reason, @JsonKey(name: 'snapshot')  SyncedPlaybackControlPayload? snapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncedPlaybackInviteResponsePayload() when $default != null:
return $default(_that.decision,_that.reason,_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'decision')  String decision, @JsonKey(name: 'reason')  String? reason, @JsonKey(name: 'snapshot')  SyncedPlaybackControlPayload? snapshot)  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackInviteResponsePayload():
return $default(_that.decision,_that.reason,_that.snapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'decision')  String decision, @JsonKey(name: 'reason')  String? reason, @JsonKey(name: 'snapshot')  SyncedPlaybackControlPayload? snapshot)?  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackInviteResponsePayload() when $default != null:
return $default(_that.decision,_that.reason,_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncedPlaybackInviteResponsePayload implements SyncedPlaybackInviteResponsePayload {
  const _SyncedPlaybackInviteResponsePayload({@JsonKey(name: 'decision') required this.decision, @JsonKey(name: 'reason') this.reason, @JsonKey(name: 'snapshot') this.snapshot});
  factory _SyncedPlaybackInviteResponsePayload.fromJson(Map<String, dynamic> json) => _$SyncedPlaybackInviteResponsePayloadFromJson(json);

@override@JsonKey(name: 'decision') final  String decision;
@override@JsonKey(name: 'reason') final  String? reason;
@override@JsonKey(name: 'snapshot') final  SyncedPlaybackControlPayload? snapshot;

/// Create a copy of SyncedPlaybackInviteResponsePayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncedPlaybackInviteResponsePayloadCopyWith<_SyncedPlaybackInviteResponsePayload> get copyWith => __$SyncedPlaybackInviteResponsePayloadCopyWithImpl<_SyncedPlaybackInviteResponsePayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncedPlaybackInviteResponsePayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncedPlaybackInviteResponsePayload&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,decision,reason,snapshot);

@override
String toString() {
  return 'SyncedPlaybackInviteResponsePayload(decision: $decision, reason: $reason, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class _$SyncedPlaybackInviteResponsePayloadCopyWith<$Res> implements $SyncedPlaybackInviteResponsePayloadCopyWith<$Res> {
  factory _$SyncedPlaybackInviteResponsePayloadCopyWith(_SyncedPlaybackInviteResponsePayload value, $Res Function(_SyncedPlaybackInviteResponsePayload) _then) = __$SyncedPlaybackInviteResponsePayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'decision') String decision,@JsonKey(name: 'reason') String? reason,@JsonKey(name: 'snapshot') SyncedPlaybackControlPayload? snapshot
});


@override $SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot;

}
/// @nodoc
class __$SyncedPlaybackInviteResponsePayloadCopyWithImpl<$Res>
    implements _$SyncedPlaybackInviteResponsePayloadCopyWith<$Res> {
  __$SyncedPlaybackInviteResponsePayloadCopyWithImpl(this._self, this._then);

  final _SyncedPlaybackInviteResponsePayload _self;
  final $Res Function(_SyncedPlaybackInviteResponsePayload) _then;

/// Create a copy of SyncedPlaybackInviteResponsePayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? decision = null,Object? reason = freezed,Object? snapshot = freezed,}) {
  return _then(_SyncedPlaybackInviteResponsePayload(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as String,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,snapshot: freezed == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as SyncedPlaybackControlPayload?,
  ));
}

/// Create a copy of SyncedPlaybackInviteResponsePayload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<$Res>? get snapshot {
    if (_self.snapshot == null) {
    return null;
  }

  return $SyncedPlaybackControlPayloadCopyWith<$Res>(_self.snapshot!, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// @nodoc
mixin _$SyncedPlaybackControlPayload {

@JsonKey(name: 'itemId') String? get itemId;@JsonKey(name: 'episodeId') String? get episodeId;@JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic) int get positionMs;@JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic) double get speed;@JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic) int get sequence;@JsonKey(name: 'isBuffering') bool get isBuffering;@JsonKey(name: 'isPlaying') bool get isPlaying;@JsonKey(name: 'isStopped') bool get isStopped;@JsonKey(name: 'reason') String? get reason;
/// Create a copy of SyncedPlaybackControlPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncedPlaybackControlPayloadCopyWith<SyncedPlaybackControlPayload> get copyWith => _$SyncedPlaybackControlPayloadCopyWithImpl<SyncedPlaybackControlPayload>(this as SyncedPlaybackControlPayload, _$identity);

  /// Serializes this SyncedPlaybackControlPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncedPlaybackControlPayload&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isStopped, isStopped) || other.isStopped == isStopped)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId,positionMs,speed,sequence,isBuffering,isPlaying,isStopped,reason);

@override
String toString() {
  return 'SyncedPlaybackControlPayload(itemId: $itemId, episodeId: $episodeId, positionMs: $positionMs, speed: $speed, sequence: $sequence, isBuffering: $isBuffering, isPlaying: $isPlaying, isStopped: $isStopped, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SyncedPlaybackControlPayloadCopyWith<$Res>  {
  factory $SyncedPlaybackControlPayloadCopyWith(SyncedPlaybackControlPayload value, $Res Function(SyncedPlaybackControlPayload) _then) = _$SyncedPlaybackControlPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'itemId') String? itemId,@JsonKey(name: 'episodeId') String? episodeId,@JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic) int positionMs,@JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic) double speed,@JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic) int sequence,@JsonKey(name: 'isBuffering') bool isBuffering,@JsonKey(name: 'isPlaying') bool isPlaying,@JsonKey(name: 'isStopped') bool isStopped,@JsonKey(name: 'reason') String? reason
});




}
/// @nodoc
class _$SyncedPlaybackControlPayloadCopyWithImpl<$Res>
    implements $SyncedPlaybackControlPayloadCopyWith<$Res> {
  _$SyncedPlaybackControlPayloadCopyWithImpl(this._self, this._then);

  final SyncedPlaybackControlPayload _self;
  final $Res Function(SyncedPlaybackControlPayload) _then;

/// Create a copy of SyncedPlaybackControlPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = freezed,Object? episodeId = freezed,Object? positionMs = null,Object? speed = null,Object? sequence = null,Object? isBuffering = null,Object? isPlaying = null,Object? isStopped = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isStopped: null == isStopped ? _self.isStopped : isStopped // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncedPlaybackControlPayload].
extension SyncedPlaybackControlPayloadPatterns on SyncedPlaybackControlPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncedPlaybackControlPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncedPlaybackControlPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncedPlaybackControlPayload value)  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackControlPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncedPlaybackControlPayload value)?  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackControlPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'itemId')  String? itemId, @JsonKey(name: 'episodeId')  String? episodeId, @JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic)  int positionMs, @JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic)  double speed, @JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic)  int sequence, @JsonKey(name: 'isBuffering')  bool isBuffering, @JsonKey(name: 'isPlaying')  bool isPlaying, @JsonKey(name: 'isStopped')  bool isStopped, @JsonKey(name: 'reason')  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncedPlaybackControlPayload() when $default != null:
return $default(_that.itemId,_that.episodeId,_that.positionMs,_that.speed,_that.sequence,_that.isBuffering,_that.isPlaying,_that.isStopped,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'itemId')  String? itemId, @JsonKey(name: 'episodeId')  String? episodeId, @JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic)  int positionMs, @JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic)  double speed, @JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic)  int sequence, @JsonKey(name: 'isBuffering')  bool isBuffering, @JsonKey(name: 'isPlaying')  bool isPlaying, @JsonKey(name: 'isStopped')  bool isStopped, @JsonKey(name: 'reason')  String? reason)  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackControlPayload():
return $default(_that.itemId,_that.episodeId,_that.positionMs,_that.speed,_that.sequence,_that.isBuffering,_that.isPlaying,_that.isStopped,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'itemId')  String? itemId, @JsonKey(name: 'episodeId')  String? episodeId, @JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic)  int positionMs, @JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic)  double speed, @JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic)  int sequence, @JsonKey(name: 'isBuffering')  bool isBuffering, @JsonKey(name: 'isPlaying')  bool isPlaying, @JsonKey(name: 'isStopped')  bool isStopped, @JsonKey(name: 'reason')  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackControlPayload() when $default != null:
return $default(_that.itemId,_that.episodeId,_that.positionMs,_that.speed,_that.sequence,_that.isBuffering,_that.isPlaying,_that.isStopped,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncedPlaybackControlPayload implements SyncedPlaybackControlPayload {
  const _SyncedPlaybackControlPayload({@JsonKey(name: 'itemId') this.itemId, @JsonKey(name: 'episodeId') this.episodeId, @JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic) this.positionMs = 0, @JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic) this.speed = 1.0, @JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic) this.sequence = 0, @JsonKey(name: 'isBuffering') this.isBuffering = false, @JsonKey(name: 'isPlaying') this.isPlaying = false, @JsonKey(name: 'isStopped') this.isStopped = false, @JsonKey(name: 'reason') this.reason});
  factory _SyncedPlaybackControlPayload.fromJson(Map<String, dynamic> json) => _$SyncedPlaybackControlPayloadFromJson(json);

@override@JsonKey(name: 'itemId') final  String? itemId;
@override@JsonKey(name: 'episodeId') final  String? episodeId;
@override@JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic) final  int positionMs;
@override@JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic) final  double speed;
@override@JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic) final  int sequence;
@override@JsonKey(name: 'isBuffering') final  bool isBuffering;
@override@JsonKey(name: 'isPlaying') final  bool isPlaying;
@override@JsonKey(name: 'isStopped') final  bool isStopped;
@override@JsonKey(name: 'reason') final  String? reason;

/// Create a copy of SyncedPlaybackControlPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncedPlaybackControlPayloadCopyWith<_SyncedPlaybackControlPayload> get copyWith => __$SyncedPlaybackControlPayloadCopyWithImpl<_SyncedPlaybackControlPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncedPlaybackControlPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncedPlaybackControlPayload&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.isBuffering, isBuffering) || other.isBuffering == isBuffering)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isStopped, isStopped) || other.isStopped == isStopped)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId,positionMs,speed,sequence,isBuffering,isPlaying,isStopped,reason);

@override
String toString() {
  return 'SyncedPlaybackControlPayload(itemId: $itemId, episodeId: $episodeId, positionMs: $positionMs, speed: $speed, sequence: $sequence, isBuffering: $isBuffering, isPlaying: $isPlaying, isStopped: $isStopped, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$SyncedPlaybackControlPayloadCopyWith<$Res> implements $SyncedPlaybackControlPayloadCopyWith<$Res> {
  factory _$SyncedPlaybackControlPayloadCopyWith(_SyncedPlaybackControlPayload value, $Res Function(_SyncedPlaybackControlPayload) _then) = __$SyncedPlaybackControlPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'itemId') String? itemId,@JsonKey(name: 'episodeId') String? episodeId,@JsonKey(name: 'positionMs', fromJson: jsonIntRequiredFromDynamic) int positionMs,@JsonKey(name: 'speed', fromJson: jsonDoubleRequiredFromDynamic) double speed,@JsonKey(name: 'sequence', fromJson: jsonIntRequiredFromDynamic) int sequence,@JsonKey(name: 'isBuffering') bool isBuffering,@JsonKey(name: 'isPlaying') bool isPlaying,@JsonKey(name: 'isStopped') bool isStopped,@JsonKey(name: 'reason') String? reason
});




}
/// @nodoc
class __$SyncedPlaybackControlPayloadCopyWithImpl<$Res>
    implements _$SyncedPlaybackControlPayloadCopyWith<$Res> {
  __$SyncedPlaybackControlPayloadCopyWithImpl(this._self, this._then);

  final _SyncedPlaybackControlPayload _self;
  final $Res Function(_SyncedPlaybackControlPayload) _then;

/// Create a copy of SyncedPlaybackControlPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = freezed,Object? episodeId = freezed,Object? positionMs = null,Object? speed = null,Object? sequence = null,Object? isBuffering = null,Object? isPlaying = null,Object? isStopped = null,Object? reason = freezed,}) {
  return _then(_SyncedPlaybackControlPayload(
itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,isBuffering: null == isBuffering ? _self.isBuffering : isBuffering // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isStopped: null == isStopped ? _self.isStopped : isStopped // ignore: cast_nullable_to_non_nullable
as bool,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SyncedPlaybackSessionEndPayload {

@JsonKey(name: 'reason') String? get reason;
/// Create a copy of SyncedPlaybackSessionEndPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncedPlaybackSessionEndPayloadCopyWith<SyncedPlaybackSessionEndPayload> get copyWith => _$SyncedPlaybackSessionEndPayloadCopyWithImpl<SyncedPlaybackSessionEndPayload>(this as SyncedPlaybackSessionEndPayload, _$identity);

  /// Serializes this SyncedPlaybackSessionEndPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncedPlaybackSessionEndPayload&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'SyncedPlaybackSessionEndPayload(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $SyncedPlaybackSessionEndPayloadCopyWith<$Res>  {
  factory $SyncedPlaybackSessionEndPayloadCopyWith(SyncedPlaybackSessionEndPayload value, $Res Function(SyncedPlaybackSessionEndPayload) _then) = _$SyncedPlaybackSessionEndPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'reason') String? reason
});




}
/// @nodoc
class _$SyncedPlaybackSessionEndPayloadCopyWithImpl<$Res>
    implements $SyncedPlaybackSessionEndPayloadCopyWith<$Res> {
  _$SyncedPlaybackSessionEndPayloadCopyWithImpl(this._self, this._then);

  final SyncedPlaybackSessionEndPayload _self;
  final $Res Function(SyncedPlaybackSessionEndPayload) _then;

/// Create a copy of SyncedPlaybackSessionEndPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = freezed,}) {
  return _then(_self.copyWith(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncedPlaybackSessionEndPayload].
extension SyncedPlaybackSessionEndPayloadPatterns on SyncedPlaybackSessionEndPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncedPlaybackSessionEndPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncedPlaybackSessionEndPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncedPlaybackSessionEndPayload value)  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackSessionEndPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncedPlaybackSessionEndPayload value)?  $default,){
final _that = this;
switch (_that) {
case _SyncedPlaybackSessionEndPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'reason')  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncedPlaybackSessionEndPayload() when $default != null:
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'reason')  String? reason)  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackSessionEndPayload():
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'reason')  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _SyncedPlaybackSessionEndPayload() when $default != null:
return $default(_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncedPlaybackSessionEndPayload implements SyncedPlaybackSessionEndPayload {
  const _SyncedPlaybackSessionEndPayload({@JsonKey(name: 'reason') this.reason});
  factory _SyncedPlaybackSessionEndPayload.fromJson(Map<String, dynamic> json) => _$SyncedPlaybackSessionEndPayloadFromJson(json);

@override@JsonKey(name: 'reason') final  String? reason;

/// Create a copy of SyncedPlaybackSessionEndPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncedPlaybackSessionEndPayloadCopyWith<_SyncedPlaybackSessionEndPayload> get copyWith => __$SyncedPlaybackSessionEndPayloadCopyWithImpl<_SyncedPlaybackSessionEndPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncedPlaybackSessionEndPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncedPlaybackSessionEndPayload&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'SyncedPlaybackSessionEndPayload(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$SyncedPlaybackSessionEndPayloadCopyWith<$Res> implements $SyncedPlaybackSessionEndPayloadCopyWith<$Res> {
  factory _$SyncedPlaybackSessionEndPayloadCopyWith(_SyncedPlaybackSessionEndPayload value, $Res Function(_SyncedPlaybackSessionEndPayload) _then) = __$SyncedPlaybackSessionEndPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'reason') String? reason
});




}
/// @nodoc
class __$SyncedPlaybackSessionEndPayloadCopyWithImpl<$Res>
    implements _$SyncedPlaybackSessionEndPayloadCopyWith<$Res> {
  __$SyncedPlaybackSessionEndPayloadCopyWithImpl(this._self, this._then);

  final _SyncedPlaybackSessionEndPayload _self;
  final $Res Function(_SyncedPlaybackSessionEndPayload) _then;

/// Create a copy of SyncedPlaybackSessionEndPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,}) {
  return _then(_SyncedPlaybackSessionEndPayload(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
