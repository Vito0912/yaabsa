// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'open_share_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenShareSession {

 String get id; String? get userId; String? get libraryItemId; String? get episodeId; String? get displayTitle; String? get displayAuthor; int? get playMethod; String? get mediaPlayer; DeviceInfo? get deviceInfo; double? get currentTime; int? get startedAt; int? get updatedAt; SessionUserSummary? get user;
/// Create a copy of OpenShareSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenShareSessionCopyWith<OpenShareSession> get copyWith => _$OpenShareSessionCopyWithImpl<OpenShareSession>(this as OpenShareSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenShareSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.displayAuthor, displayAuthor) || other.displayAuthor == displayAuthor)&&(identical(other.playMethod, playMethod) || other.playMethod == playMethod)&&(identical(other.mediaPlayer, mediaPlayer) || other.mediaPlayer == mediaPlayer)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,libraryItemId,episodeId,displayTitle,displayAuthor,playMethod,mediaPlayer,deviceInfo,currentTime,startedAt,updatedAt,user);

@override
String toString() {
  return 'OpenShareSession(id: $id, userId: $userId, libraryItemId: $libraryItemId, episodeId: $episodeId, displayTitle: $displayTitle, displayAuthor: $displayAuthor, playMethod: $playMethod, mediaPlayer: $mediaPlayer, deviceInfo: $deviceInfo, currentTime: $currentTime, startedAt: $startedAt, updatedAt: $updatedAt, user: $user)';
}


}

/// @nodoc
abstract mixin class $OpenShareSessionCopyWith<$Res>  {
  factory $OpenShareSessionCopyWith(OpenShareSession value, $Res Function(OpenShareSession) _then) = _$OpenShareSessionCopyWithImpl;
@useResult
$Res call({
 String id, String? userId, String? libraryItemId, String? episodeId, String? displayTitle, String? displayAuthor, int? playMethod, String? mediaPlayer, DeviceInfo? deviceInfo, double? currentTime, int? startedAt, int? updatedAt, SessionUserSummary? user
});


$DeviceInfoCopyWith<$Res>? get deviceInfo;$SessionUserSummaryCopyWith<$Res>? get user;

}
/// @nodoc
class _$OpenShareSessionCopyWithImpl<$Res>
    implements $OpenShareSessionCopyWith<$Res> {
  _$OpenShareSessionCopyWithImpl(this._self, this._then);

  final OpenShareSession _self;
  final $Res Function(OpenShareSession) _then;

/// Create a copy of OpenShareSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = freezed,Object? libraryItemId = freezed,Object? episodeId = freezed,Object? displayTitle = freezed,Object? displayAuthor = freezed,Object? playMethod = freezed,Object? mediaPlayer = freezed,Object? deviceInfo = freezed,Object? currentTime = freezed,Object? startedAt = freezed,Object? updatedAt = freezed,Object? user = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,displayAuthor: freezed == displayAuthor ? _self.displayAuthor : displayAuthor // ignore: cast_nullable_to_non_nullable
as String?,playMethod: freezed == playMethod ? _self.playMethod : playMethod // ignore: cast_nullable_to_non_nullable
as int?,mediaPlayer: freezed == mediaPlayer ? _self.mediaPlayer : mediaPlayer // ignore: cast_nullable_to_non_nullable
as String?,deviceInfo: freezed == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as DeviceInfo?,currentTime: freezed == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,
  ));
}
/// Create a copy of OpenShareSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res>? get deviceInfo {
    if (_self.deviceInfo == null) {
    return null;
  }

  return $DeviceInfoCopyWith<$Res>(_self.deviceInfo!, (value) {
    return _then(_self.copyWith(deviceInfo: value));
  });
}/// Create a copy of OpenShareSession
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


/// Adds pattern-matching-related methods to [OpenShareSession].
extension OpenShareSessionPatterns on OpenShareSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenShareSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenShareSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenShareSession value)  $default,){
final _that = this;
switch (_that) {
case _OpenShareSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenShareSession value)?  $default,){
final _that = this;
switch (_that) {
case _OpenShareSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? userId,  String? libraryItemId,  String? episodeId,  String? displayTitle,  String? displayAuthor,  int? playMethod,  String? mediaPlayer,  DeviceInfo? deviceInfo,  double? currentTime,  int? startedAt,  int? updatedAt,  SessionUserSummary? user)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenShareSession() when $default != null:
return $default(_that.id,_that.userId,_that.libraryItemId,_that.episodeId,_that.displayTitle,_that.displayAuthor,_that.playMethod,_that.mediaPlayer,_that.deviceInfo,_that.currentTime,_that.startedAt,_that.updatedAt,_that.user);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? userId,  String? libraryItemId,  String? episodeId,  String? displayTitle,  String? displayAuthor,  int? playMethod,  String? mediaPlayer,  DeviceInfo? deviceInfo,  double? currentTime,  int? startedAt,  int? updatedAt,  SessionUserSummary? user)  $default,) {final _that = this;
switch (_that) {
case _OpenShareSession():
return $default(_that.id,_that.userId,_that.libraryItemId,_that.episodeId,_that.displayTitle,_that.displayAuthor,_that.playMethod,_that.mediaPlayer,_that.deviceInfo,_that.currentTime,_that.startedAt,_that.updatedAt,_that.user);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? userId,  String? libraryItemId,  String? episodeId,  String? displayTitle,  String? displayAuthor,  int? playMethod,  String? mediaPlayer,  DeviceInfo? deviceInfo,  double? currentTime,  int? startedAt,  int? updatedAt,  SessionUserSummary? user)?  $default,) {final _that = this;
switch (_that) {
case _OpenShareSession() when $default != null:
return $default(_that.id,_that.userId,_that.libraryItemId,_that.episodeId,_that.displayTitle,_that.displayAuthor,_that.playMethod,_that.mediaPlayer,_that.deviceInfo,_that.currentTime,_that.startedAt,_that.updatedAt,_that.user);case _:
  return null;

}
}

}

/// @nodoc


class _OpenShareSession implements OpenShareSession {
  const _OpenShareSession({required this.id, this.userId, this.libraryItemId, this.episodeId, this.displayTitle, this.displayAuthor, this.playMethod, this.mediaPlayer, this.deviceInfo, this.currentTime, this.startedAt, this.updatedAt, this.user});
  

@override final  String id;
@override final  String? userId;
@override final  String? libraryItemId;
@override final  String? episodeId;
@override final  String? displayTitle;
@override final  String? displayAuthor;
@override final  int? playMethod;
@override final  String? mediaPlayer;
@override final  DeviceInfo? deviceInfo;
@override final  double? currentTime;
@override final  int? startedAt;
@override final  int? updatedAt;
@override final  SessionUserSummary? user;

/// Create a copy of OpenShareSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenShareSessionCopyWith<_OpenShareSession> get copyWith => __$OpenShareSessionCopyWithImpl<_OpenShareSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenShareSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.displayAuthor, displayAuthor) || other.displayAuthor == displayAuthor)&&(identical(other.playMethod, playMethod) || other.playMethod == playMethod)&&(identical(other.mediaPlayer, mediaPlayer) || other.mediaPlayer == mediaPlayer)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.user, user) || other.user == user));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,libraryItemId,episodeId,displayTitle,displayAuthor,playMethod,mediaPlayer,deviceInfo,currentTime,startedAt,updatedAt,user);

@override
String toString() {
  return 'OpenShareSession(id: $id, userId: $userId, libraryItemId: $libraryItemId, episodeId: $episodeId, displayTitle: $displayTitle, displayAuthor: $displayAuthor, playMethod: $playMethod, mediaPlayer: $mediaPlayer, deviceInfo: $deviceInfo, currentTime: $currentTime, startedAt: $startedAt, updatedAt: $updatedAt, user: $user)';
}


}

/// @nodoc
abstract mixin class _$OpenShareSessionCopyWith<$Res> implements $OpenShareSessionCopyWith<$Res> {
  factory _$OpenShareSessionCopyWith(_OpenShareSession value, $Res Function(_OpenShareSession) _then) = __$OpenShareSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String? userId, String? libraryItemId, String? episodeId, String? displayTitle, String? displayAuthor, int? playMethod, String? mediaPlayer, DeviceInfo? deviceInfo, double? currentTime, int? startedAt, int? updatedAt, SessionUserSummary? user
});


@override $DeviceInfoCopyWith<$Res>? get deviceInfo;@override $SessionUserSummaryCopyWith<$Res>? get user;

}
/// @nodoc
class __$OpenShareSessionCopyWithImpl<$Res>
    implements _$OpenShareSessionCopyWith<$Res> {
  __$OpenShareSessionCopyWithImpl(this._self, this._then);

  final _OpenShareSession _self;
  final $Res Function(_OpenShareSession) _then;

/// Create a copy of OpenShareSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = freezed,Object? libraryItemId = freezed,Object? episodeId = freezed,Object? displayTitle = freezed,Object? displayAuthor = freezed,Object? playMethod = freezed,Object? mediaPlayer = freezed,Object? deviceInfo = freezed,Object? currentTime = freezed,Object? startedAt = freezed,Object? updatedAt = freezed,Object? user = freezed,}) {
  return _then(_OpenShareSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,displayAuthor: freezed == displayAuthor ? _self.displayAuthor : displayAuthor // ignore: cast_nullable_to_non_nullable
as String?,playMethod: freezed == playMethod ? _self.playMethod : playMethod // ignore: cast_nullable_to_non_nullable
as int?,mediaPlayer: freezed == mediaPlayer ? _self.mediaPlayer : mediaPlayer // ignore: cast_nullable_to_non_nullable
as String?,deviceInfo: freezed == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as DeviceInfo?,currentTime: freezed == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as SessionUserSummary?,
  ));
}

/// Create a copy of OpenShareSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res>? get deviceInfo {
    if (_self.deviceInfo == null) {
    return null;
  }

  return $DeviceInfoCopyWith<$Res>(_self.deviceInfo!, (value) {
    return _then(_self.copyWith(deviceInfo: value));
  });
}/// Create a copy of OpenShareSession
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
