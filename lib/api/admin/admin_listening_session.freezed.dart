// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_listening_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AdminListeningSession {

 PlaybackSession get session; SessionUserSummary? get user;
/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminListeningSessionCopyWith<AdminListeningSession> get copyWith => _$AdminListeningSessionCopyWithImpl<AdminListeningSession>(this as AdminListeningSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminListeningSession&&(identical(other.session, session) || other.session == session)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,session,user);

@override
String toString() {
  return 'AdminListeningSession(session: $session, user: $user)';
}


}

/// @nodoc
abstract mixin class $AdminListeningSessionCopyWith<$Res>  {
  factory $AdminListeningSessionCopyWith(AdminListeningSession value, $Res Function(AdminListeningSession) _then) = _$AdminListeningSessionCopyWithImpl;
@useResult
$Res call({
 PlaybackSession session, SessionUserSummary? user
});


$PlaybackSessionCopyWith<$Res> get session;$SessionUserSummaryCopyWith<$Res>? get user;

}
/// @nodoc
class _$AdminListeningSessionCopyWithImpl<$Res>
    implements $AdminListeningSessionCopyWith<$Res> {
  _$AdminListeningSessionCopyWithImpl(this._self, this._then);

  final AdminListeningSession _self;
  final $Res Function(AdminListeningSession) _then;

/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? user = freezed,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PlaybackSession,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,
  ));
}
/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaybackSessionCopyWith<$Res> get session {
  
  return $PlaybackSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $SessionUserSummaryCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminListeningSession].
extension AdminListeningSessionPatterns on AdminListeningSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminListeningSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminListeningSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminListeningSession value)  $default,){
final _that = this;
switch (_that) {
case _AdminListeningSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminListeningSession value)?  $default,){
final _that = this;
switch (_that) {
case _AdminListeningSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlaybackSession session,  SessionUserSummary? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminListeningSession() when $default != null:
return $default(_that.session,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlaybackSession session,  SessionUserSummary? user)  $default,) {final _that = this;
switch (_that) {
case _AdminListeningSession():
return $default(_that.session,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlaybackSession session,  SessionUserSummary? user)?  $default,) {final _that = this;
switch (_that) {
case _AdminListeningSession() when $default != null:
return $default(_that.session,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _AdminListeningSession extends AdminListeningSession {
  const _AdminListeningSession({required this.session, this.user}): super._();
  

@override final  PlaybackSession session;
@override final  SessionUserSummary? user;

/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminListeningSessionCopyWith<_AdminListeningSession> get copyWith => __$AdminListeningSessionCopyWithImpl<_AdminListeningSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminListeningSession&&(identical(other.session, session) || other.session == session)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,session,user);

@override
String toString() {
  return 'AdminListeningSession(session: $session, user: $user)';
}


}

/// @nodoc
abstract mixin class _$AdminListeningSessionCopyWith<$Res> implements $AdminListeningSessionCopyWith<$Res> {
  factory _$AdminListeningSessionCopyWith(_AdminListeningSession value, $Res Function(_AdminListeningSession) _then) = __$AdminListeningSessionCopyWithImpl;
@override @useResult
$Res call({
 PlaybackSession session, SessionUserSummary? user
});


@override $PlaybackSessionCopyWith<$Res> get session;@override $SessionUserSummaryCopyWith<$Res>? get user;

}
/// @nodoc
class __$AdminListeningSessionCopyWithImpl<$Res>
    implements _$AdminListeningSessionCopyWith<$Res> {
  __$AdminListeningSessionCopyWithImpl(this._self, this._then);

  final _AdminListeningSession _self;
  final $Res Function(_AdminListeningSession) _then;

/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? user = freezed,}) {
  return _then(_AdminListeningSession(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as PlaybackSession,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,
  ));
}

/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaybackSessionCopyWith<$Res> get session {
  
  return $PlaybackSessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}/// Create a copy of AdminListeningSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $SessionUserSummaryCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
