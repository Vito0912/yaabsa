// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_session_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncSessionRequest {

@JsonKey(name: "currentTime") double get currentTime;@JsonKey(name: "timeListened") double get timeListened;@JsonKey(name: "duration") double get duration;
/// Create a copy of SyncSessionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SyncSessionRequestCopyWith<SyncSessionRequest> get copyWith => _$SyncSessionRequestCopyWithImpl<SyncSessionRequest>(this as SyncSessionRequest, _$identity);

  /// Serializes this SyncSessionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SyncSessionRequest&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.timeListened, timeListened) || other.timeListened == timeListened)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentTime,timeListened,duration);

@override
String toString() {
  return 'SyncSessionRequest(currentTime: $currentTime, timeListened: $timeListened, duration: $duration)';
}


}

/// @nodoc
abstract mixin class $SyncSessionRequestCopyWith<$Res>  {
  factory $SyncSessionRequestCopyWith(SyncSessionRequest value, $Res Function(SyncSessionRequest) _then) = _$SyncSessionRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "currentTime") double currentTime,@JsonKey(name: "timeListened") double timeListened,@JsonKey(name: "duration") double duration
});




}
/// @nodoc
class _$SyncSessionRequestCopyWithImpl<$Res>
    implements $SyncSessionRequestCopyWith<$Res> {
  _$SyncSessionRequestCopyWithImpl(this._self, this._then);

  final SyncSessionRequest _self;
  final $Res Function(SyncSessionRequest) _then;

/// Create a copy of SyncSessionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentTime = null,Object? timeListened = null,Object? duration = null,}) {
  return _then(_self.copyWith(
currentTime: null == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double,timeListened: null == timeListened ? _self.timeListened : timeListened // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SyncSessionRequest].
extension SyncSessionRequestPatterns on SyncSessionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SyncSessionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SyncSessionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SyncSessionRequest value)  $default,){
final _that = this;
switch (_that) {
case _SyncSessionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SyncSessionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SyncSessionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "currentTime")  double currentTime, @JsonKey(name: "timeListened")  double timeListened, @JsonKey(name: "duration")  double duration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SyncSessionRequest() when $default != null:
return $default(_that.currentTime,_that.timeListened,_that.duration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "currentTime")  double currentTime, @JsonKey(name: "timeListened")  double timeListened, @JsonKey(name: "duration")  double duration)  $default,) {final _that = this;
switch (_that) {
case _SyncSessionRequest():
return $default(_that.currentTime,_that.timeListened,_that.duration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "currentTime")  double currentTime, @JsonKey(name: "timeListened")  double timeListened, @JsonKey(name: "duration")  double duration)?  $default,) {final _that = this;
switch (_that) {
case _SyncSessionRequest() when $default != null:
return $default(_that.currentTime,_that.timeListened,_that.duration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SyncSessionRequest implements SyncSessionRequest {
  const _SyncSessionRequest({@JsonKey(name: "currentTime") required this.currentTime, @JsonKey(name: "timeListened") required this.timeListened, @JsonKey(name: "duration") required this.duration});
  factory _SyncSessionRequest.fromJson(Map<String, dynamic> json) => _$SyncSessionRequestFromJson(json);

@override@JsonKey(name: "currentTime") final  double currentTime;
@override@JsonKey(name: "timeListened") final  double timeListened;
@override@JsonKey(name: "duration") final  double duration;

/// Create a copy of SyncSessionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SyncSessionRequestCopyWith<_SyncSessionRequest> get copyWith => __$SyncSessionRequestCopyWithImpl<_SyncSessionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SyncSessionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SyncSessionRequest&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.timeListened, timeListened) || other.timeListened == timeListened)&&(identical(other.duration, duration) || other.duration == duration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,currentTime,timeListened,duration);

@override
String toString() {
  return 'SyncSessionRequest(currentTime: $currentTime, timeListened: $timeListened, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$SyncSessionRequestCopyWith<$Res> implements $SyncSessionRequestCopyWith<$Res> {
  factory _$SyncSessionRequestCopyWith(_SyncSessionRequest value, $Res Function(_SyncSessionRequest) _then) = __$SyncSessionRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "currentTime") double currentTime,@JsonKey(name: "timeListened") double timeListened,@JsonKey(name: "duration") double duration
});




}
/// @nodoc
class __$SyncSessionRequestCopyWithImpl<$Res>
    implements _$SyncSessionRequestCopyWith<$Res> {
  __$SyncSessionRequestCopyWithImpl(this._self, this._then);

  final _SyncSessionRequest _self;
  final $Res Function(_SyncSessionRequest) _then;

/// Create a copy of SyncSessionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentTime = null,Object? timeListened = null,Object? duration = null,}) {
  return _then(_SyncSessionRequest(
currentTime: null == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double,timeListened: null == timeListened ? _self.timeListened : timeListened // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
