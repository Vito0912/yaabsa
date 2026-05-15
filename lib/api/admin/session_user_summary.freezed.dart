// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_user_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionUserSummary {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'username') String get username;@JsonKey(name: 'type') String? get type;
/// Create a copy of SessionUserSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionUserSummaryCopyWith<SessionUserSummary> get copyWith => _$SessionUserSummaryCopyWithImpl<SessionUserSummary>(this as SessionUserSummary, _$identity);

  /// Serializes this SessionUserSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,type);

@override
String toString() {
  return 'SessionUserSummary(id: $id, username: $username, type: $type)';
}


}

/// @nodoc
abstract mixin class $SessionUserSummaryCopyWith<$Res>  {
  factory $SessionUserSummaryCopyWith(SessionUserSummary value, $Res Function(SessionUserSummary) _then) = _$SessionUserSummaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'username') String username,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$SessionUserSummaryCopyWithImpl<$Res>
    implements $SessionUserSummaryCopyWith<$Res> {
  _$SessionUserSummaryCopyWithImpl(this._self, this._then);

  final SessionUserSummary _self;
  final $Res Function(SessionUserSummary) _then;

/// Create a copy of SessionUserSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionUserSummary].
extension SessionUserSummaryPatterns on SessionUserSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionUserSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionUserSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionUserSummary value)  $default,){
final _that = this;
switch (_that) {
case _SessionUserSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionUserSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SessionUserSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String username, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionUserSummary() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String username, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _SessionUserSummary():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'username')  String username, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _SessionUserSummary() when $default != null:
return $default(_that.id,_that.username,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionUserSummary implements SessionUserSummary {
  const _SessionUserSummary({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'username') required this.username, @JsonKey(name: 'type') this.type});
  factory _SessionUserSummary.fromJson(Map<String, dynamic> json) => _$SessionUserSummaryFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'username') final  String username;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of SessionUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionUserSummaryCopyWith<_SessionUserSummary> get copyWith => __$SessionUserSummaryCopyWithImpl<_SessionUserSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionUserSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionUserSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,type);

@override
String toString() {
  return 'SessionUserSummary(id: $id, username: $username, type: $type)';
}


}

/// @nodoc
abstract mixin class _$SessionUserSummaryCopyWith<$Res> implements $SessionUserSummaryCopyWith<$Res> {
  factory _$SessionUserSummaryCopyWith(_SessionUserSummary value, $Res Function(_SessionUserSummary) _then) = __$SessionUserSummaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'username') String username,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$SessionUserSummaryCopyWithImpl<$Res>
    implements _$SessionUserSummaryCopyWith<$Res> {
  __$SessionUserSummaryCopyWithImpl(this._self, this._then);

  final _SessionUserSummary _self;
  final $Res Function(_SessionUserSummary) _then;

/// Create a copy of SessionUserSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? type = freezed,}) {
  return _then(_SessionUserSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
