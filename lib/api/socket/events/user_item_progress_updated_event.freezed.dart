// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_item_progress_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserItemProgressUpdatedEvent {

@JsonKey(name: "id") String get id;@JsonKey(name: "data") MediaProgress get data;
/// Create a copy of UserItemProgressUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserItemProgressUpdatedEventCopyWith<UserItemProgressUpdatedEvent> get copyWith => _$UserItemProgressUpdatedEventCopyWithImpl<UserItemProgressUpdatedEvent>(this as UserItemProgressUpdatedEvent, _$identity);

  /// Serializes this UserItemProgressUpdatedEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserItemProgressUpdatedEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,data);

@override
String toString() {
  return 'UserItemProgressUpdatedEvent(id: $id, data: $data)';
}


}

/// @nodoc
abstract mixin class $UserItemProgressUpdatedEventCopyWith<$Res>  {
  factory $UserItemProgressUpdatedEventCopyWith(UserItemProgressUpdatedEvent value, $Res Function(UserItemProgressUpdatedEvent) _then) = _$UserItemProgressUpdatedEventCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "data") MediaProgress data
});


$MediaProgressCopyWith<$Res> get data;

}
/// @nodoc
class _$UserItemProgressUpdatedEventCopyWithImpl<$Res>
    implements $UserItemProgressUpdatedEventCopyWith<$Res> {
  _$UserItemProgressUpdatedEventCopyWithImpl(this._self, this._then);

  final UserItemProgressUpdatedEvent _self;
  final $Res Function(UserItemProgressUpdatedEvent) _then;

/// Create a copy of UserItemProgressUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? data = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MediaProgress,
  ));
}
/// Create a copy of UserItemProgressUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaProgressCopyWith<$Res> get data {
  
  return $MediaProgressCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserItemProgressUpdatedEvent].
extension UserItemProgressUpdatedEventPatterns on UserItemProgressUpdatedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserItemProgressUpdatedEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserItemProgressUpdatedEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserItemProgressUpdatedEvent value)  $default,){
final _that = this;
switch (_that) {
case _UserItemProgressUpdatedEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserItemProgressUpdatedEvent value)?  $default,){
final _that = this;
switch (_that) {
case _UserItemProgressUpdatedEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "data")  MediaProgress data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserItemProgressUpdatedEvent() when $default != null:
return $default(_that.id,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "data")  MediaProgress data)  $default,) {final _that = this;
switch (_that) {
case _UserItemProgressUpdatedEvent():
return $default(_that.id,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "data")  MediaProgress data)?  $default,) {final _that = this;
switch (_that) {
case _UserItemProgressUpdatedEvent() when $default != null:
return $default(_that.id,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserItemProgressUpdatedEvent implements UserItemProgressUpdatedEvent {
  const _UserItemProgressUpdatedEvent({@JsonKey(name: "id") required this.id, @JsonKey(name: "data") required this.data});
  factory _UserItemProgressUpdatedEvent.fromJson(Map<String, dynamic> json) => _$UserItemProgressUpdatedEventFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "data") final  MediaProgress data;

/// Create a copy of UserItemProgressUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserItemProgressUpdatedEventCopyWith<_UserItemProgressUpdatedEvent> get copyWith => __$UserItemProgressUpdatedEventCopyWithImpl<_UserItemProgressUpdatedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserItemProgressUpdatedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserItemProgressUpdatedEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,data);

@override
String toString() {
  return 'UserItemProgressUpdatedEvent(id: $id, data: $data)';
}


}

/// @nodoc
abstract mixin class _$UserItemProgressUpdatedEventCopyWith<$Res> implements $UserItemProgressUpdatedEventCopyWith<$Res> {
  factory _$UserItemProgressUpdatedEventCopyWith(_UserItemProgressUpdatedEvent value, $Res Function(_UserItemProgressUpdatedEvent) _then) = __$UserItemProgressUpdatedEventCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "data") MediaProgress data
});


@override $MediaProgressCopyWith<$Res> get data;

}
/// @nodoc
class __$UserItemProgressUpdatedEventCopyWithImpl<$Res>
    implements _$UserItemProgressUpdatedEventCopyWith<$Res> {
  __$UserItemProgressUpdatedEventCopyWithImpl(this._self, this._then);

  final _UserItemProgressUpdatedEvent _self;
  final $Res Function(_UserItemProgressUpdatedEvent) _then;

/// Create a copy of UserItemProgressUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? data = null,}) {
  return _then(_UserItemProgressUpdatedEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as MediaProgress,
  ));
}

/// Create a copy of UserItemProgressUpdatedEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaProgressCopyWith<$Res> get data {
  
  return $MediaProgressCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

// dart format on
