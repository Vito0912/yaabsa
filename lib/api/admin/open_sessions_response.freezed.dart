// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_sessions_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenSessionsResponse {

 List<AdminListeningSession> get sessions; List<OpenShareSession> get shareSessions;
/// Create a copy of OpenSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenSessionsResponseCopyWith<OpenSessionsResponse> get copyWith => _$OpenSessionsResponseCopyWithImpl<OpenSessionsResponse>(this as OpenSessionsResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenSessionsResponse&&const DeepCollectionEquality().equals(other.sessions, sessions)&&const DeepCollectionEquality().equals(other.shareSessions, shareSessions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sessions),const DeepCollectionEquality().hash(shareSessions));

@override
String toString() {
  return 'OpenSessionsResponse(sessions: $sessions, shareSessions: $shareSessions)';
}


}

/// @nodoc
abstract mixin class $OpenSessionsResponseCopyWith<$Res>  {
  factory $OpenSessionsResponseCopyWith(OpenSessionsResponse value, $Res Function(OpenSessionsResponse) _then) = _$OpenSessionsResponseCopyWithImpl;
@useResult
$Res call({
 List<AdminListeningSession> sessions, List<OpenShareSession> shareSessions
});




}
/// @nodoc
class _$OpenSessionsResponseCopyWithImpl<$Res>
    implements $OpenSessionsResponseCopyWith<$Res> {
  _$OpenSessionsResponseCopyWithImpl(this._self, this._then);

  final OpenSessionsResponse _self;
  final $Res Function(OpenSessionsResponse) _then;

/// Create a copy of OpenSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? shareSessions = null,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AdminListeningSession>,shareSessions: null == shareSessions ? _self.shareSessions : shareSessions // ignore: cast_nullable_to_non_nullable
as List<OpenShareSession>,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenSessionsResponse].
extension OpenSessionsResponsePatterns on OpenSessionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenSessionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenSessionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenSessionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _OpenSessionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenSessionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OpenSessionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AdminListeningSession> sessions,  List<OpenShareSession> shareSessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenSessionsResponse() when $default != null:
return $default(_that.sessions,_that.shareSessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AdminListeningSession> sessions,  List<OpenShareSession> shareSessions)  $default,) {final _that = this;
switch (_that) {
case _OpenSessionsResponse():
return $default(_that.sessions,_that.shareSessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AdminListeningSession> sessions,  List<OpenShareSession> shareSessions)?  $default,) {final _that = this;
switch (_that) {
case _OpenSessionsResponse() when $default != null:
return $default(_that.sessions,_that.shareSessions);case _:
  return null;

}
}

}

/// @nodoc


class _OpenSessionsResponse implements OpenSessionsResponse {
  const _OpenSessionsResponse({final  List<AdminListeningSession> sessions = const <AdminListeningSession>[], final  List<OpenShareSession> shareSessions = const <OpenShareSession>[]}): _sessions = sessions,_shareSessions = shareSessions;
  

 final  List<AdminListeningSession> _sessions;
@override@JsonKey() List<AdminListeningSession> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

 final  List<OpenShareSession> _shareSessions;
@override@JsonKey() List<OpenShareSession> get shareSessions {
  if (_shareSessions is EqualUnmodifiableListView) return _shareSessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shareSessions);
}


/// Create a copy of OpenSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenSessionsResponseCopyWith<_OpenSessionsResponse> get copyWith => __$OpenSessionsResponseCopyWithImpl<_OpenSessionsResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenSessionsResponse&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&const DeepCollectionEquality().equals(other._shareSessions, _shareSessions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),const DeepCollectionEquality().hash(_shareSessions));

@override
String toString() {
  return 'OpenSessionsResponse(sessions: $sessions, shareSessions: $shareSessions)';
}


}

/// @nodoc
abstract mixin class _$OpenSessionsResponseCopyWith<$Res> implements $OpenSessionsResponseCopyWith<$Res> {
  factory _$OpenSessionsResponseCopyWith(_OpenSessionsResponse value, $Res Function(_OpenSessionsResponse) _then) = __$OpenSessionsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<AdminListeningSession> sessions, List<OpenShareSession> shareSessions
});




}
/// @nodoc
class __$OpenSessionsResponseCopyWithImpl<$Res>
    implements _$OpenSessionsResponseCopyWith<$Res> {
  __$OpenSessionsResponseCopyWithImpl(this._self, this._then);

  final _OpenSessionsResponse _self;
  final $Res Function(_OpenSessionsResponse) _then;

/// Create a copy of OpenSessionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? shareSessions = null,}) {
  return _then(_OpenSessionsResponse(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<AdminListeningSession>,shareSessions: null == shareSessions ? _self._shareSessions : shareSessions // ignore: cast_nullable_to_non_nullable
as List<OpenShareSession>,
  ));
}


}

// dart format on
