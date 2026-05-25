// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServerLogEntry {

@JsonKey(name: 'timestamp') String get timestamp;@JsonKey(name: 'source') String? get source;@JsonKey(name: 'message') String get message;@JsonKey(name: 'levelName') String get levelName;@JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic) int get level;
/// Create a copy of ServerLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerLogEntryCopyWith<ServerLogEntry> get copyWith => _$ServerLogEntryCopyWithImpl<ServerLogEntry>(this as ServerLogEntry, _$identity);

  /// Serializes this ServerLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerLogEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.source, source) || other.source == source)&&(identical(other.message, message) || other.message == message)&&(identical(other.levelName, levelName) || other.levelName == levelName)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,source,message,levelName,level);

@override
String toString() {
  return 'ServerLogEntry(timestamp: $timestamp, source: $source, message: $message, levelName: $levelName, level: $level)';
}


}

/// @nodoc
abstract mixin class $ServerLogEntryCopyWith<$Res>  {
  factory $ServerLogEntryCopyWith(ServerLogEntry value, $Res Function(ServerLogEntry) _then) = _$ServerLogEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'timestamp') String timestamp,@JsonKey(name: 'source') String? source,@JsonKey(name: 'message') String message,@JsonKey(name: 'levelName') String levelName,@JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic) int level
});




}
/// @nodoc
class _$ServerLogEntryCopyWithImpl<$Res>
    implements $ServerLogEntryCopyWith<$Res> {
  _$ServerLogEntryCopyWithImpl(this._self, this._then);

  final ServerLogEntry _self;
  final $Res Function(ServerLogEntry) _then;

/// Create a copy of ServerLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? source = freezed,Object? message = null,Object? levelName = null,Object? level = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,levelName: null == levelName ? _self.levelName : levelName // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerLogEntry].
extension ServerLogEntryPatterns on ServerLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _ServerLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ServerLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'timestamp')  String timestamp, @JsonKey(name: 'source')  String? source, @JsonKey(name: 'message')  String message, @JsonKey(name: 'levelName')  String levelName, @JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic)  int level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerLogEntry() when $default != null:
return $default(_that.timestamp,_that.source,_that.message,_that.levelName,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'timestamp')  String timestamp, @JsonKey(name: 'source')  String? source, @JsonKey(name: 'message')  String message, @JsonKey(name: 'levelName')  String levelName, @JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic)  int level)  $default,) {final _that = this;
switch (_that) {
case _ServerLogEntry():
return $default(_that.timestamp,_that.source,_that.message,_that.levelName,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'timestamp')  String timestamp, @JsonKey(name: 'source')  String? source, @JsonKey(name: 'message')  String message, @JsonKey(name: 'levelName')  String levelName, @JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic)  int level)?  $default,) {final _that = this;
switch (_that) {
case _ServerLogEntry() when $default != null:
return $default(_that.timestamp,_that.source,_that.message,_that.levelName,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServerLogEntry implements ServerLogEntry {
  const _ServerLogEntry({@JsonKey(name: 'timestamp') required this.timestamp, @JsonKey(name: 'source') this.source, @JsonKey(name: 'message') required this.message, @JsonKey(name: 'levelName') required this.levelName, @JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic) required this.level});
  factory _ServerLogEntry.fromJson(Map<String, dynamic> json) => _$ServerLogEntryFromJson(json);

@override@JsonKey(name: 'timestamp') final  String timestamp;
@override@JsonKey(name: 'source') final  String? source;
@override@JsonKey(name: 'message') final  String message;
@override@JsonKey(name: 'levelName') final  String levelName;
@override@JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic) final  int level;

/// Create a copy of ServerLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerLogEntryCopyWith<_ServerLogEntry> get copyWith => __$ServerLogEntryCopyWithImpl<_ServerLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServerLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerLogEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.source, source) || other.source == source)&&(identical(other.message, message) || other.message == message)&&(identical(other.levelName, levelName) || other.levelName == levelName)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timestamp,source,message,levelName,level);

@override
String toString() {
  return 'ServerLogEntry(timestamp: $timestamp, source: $source, message: $message, levelName: $levelName, level: $level)';
}


}

/// @nodoc
abstract mixin class _$ServerLogEntryCopyWith<$Res> implements $ServerLogEntryCopyWith<$Res> {
  factory _$ServerLogEntryCopyWith(_ServerLogEntry value, $Res Function(_ServerLogEntry) _then) = __$ServerLogEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'timestamp') String timestamp,@JsonKey(name: 'source') String? source,@JsonKey(name: 'message') String message,@JsonKey(name: 'levelName') String levelName,@JsonKey(name: 'level', fromJson: jsonIntRequiredFromDynamic) int level
});




}
/// @nodoc
class __$ServerLogEntryCopyWithImpl<$Res>
    implements _$ServerLogEntryCopyWith<$Res> {
  __$ServerLogEntryCopyWithImpl(this._self, this._then);

  final _ServerLogEntry _self;
  final $Res Function(_ServerLogEntry) _then;

/// Create a copy of ServerLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? source = freezed,Object? message = null,Object? levelName = null,Object? level = null,}) {
  return _then(_ServerLogEntry(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,levelName: null == levelName ? _self.levelName : levelName // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
