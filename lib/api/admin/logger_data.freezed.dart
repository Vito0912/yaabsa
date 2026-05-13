// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'logger_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoggerData {

@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson) List<ServerLogEntry> get currentDailyLogs;
/// Create a copy of LoggerData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoggerDataCopyWith<LoggerData> get copyWith => _$LoggerDataCopyWithImpl<LoggerData>(this as LoggerData, _$identity);

  /// Serializes this LoggerData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoggerData&&const DeepCollectionEquality().equals(other.currentDailyLogs, currentDailyLogs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(currentDailyLogs));

@override
String toString() {
  return 'LoggerData(currentDailyLogs: $currentDailyLogs)';
}


}

/// @nodoc
abstract mixin class $LoggerDataCopyWith<$Res>  {
  factory $LoggerDataCopyWith(LoggerData value, $Res Function(LoggerData) _then) = _$LoggerDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson) List<ServerLogEntry> currentDailyLogs
});




}
/// @nodoc
class _$LoggerDataCopyWithImpl<$Res>
    implements $LoggerDataCopyWith<$Res> {
  _$LoggerDataCopyWithImpl(this._self, this._then);

  final LoggerData _self;
  final $Res Function(LoggerData) _then;

/// Create a copy of LoggerData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentDailyLogs = null,}) {
  return _then(_self.copyWith(
currentDailyLogs: null == currentDailyLogs ? _self.currentDailyLogs : currentDailyLogs // ignore: cast_nullable_to_non_nullable
as List<ServerLogEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [LoggerData].
extension LoggerDataPatterns on LoggerData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoggerData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoggerData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoggerData value)  $default,){
final _that = this;
switch (_that) {
case _LoggerData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoggerData value)?  $default,){
final _that = this;
switch (_that) {
case _LoggerData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson)  List<ServerLogEntry> currentDailyLogs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoggerData() when $default != null:
return $default(_that.currentDailyLogs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson)  List<ServerLogEntry> currentDailyLogs)  $default,) {final _that = this;
switch (_that) {
case _LoggerData():
return $default(_that.currentDailyLogs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson)  List<ServerLogEntry> currentDailyLogs)?  $default,) {final _that = this;
switch (_that) {
case _LoggerData() when $default != null:
return $default(_that.currentDailyLogs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoggerData implements LoggerData {
  const _LoggerData({@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson) final  List<ServerLogEntry> currentDailyLogs = const <ServerLogEntry>[]}): _currentDailyLogs = currentDailyLogs;
  factory _LoggerData.fromJson(Map<String, dynamic> json) => _$LoggerDataFromJson(json);

 final  List<ServerLogEntry> _currentDailyLogs;
@override@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson) List<ServerLogEntry> get currentDailyLogs {
  if (_currentDailyLogs is EqualUnmodifiableListView) return _currentDailyLogs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentDailyLogs);
}


/// Create a copy of LoggerData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoggerDataCopyWith<_LoggerData> get copyWith => __$LoggerDataCopyWithImpl<_LoggerData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoggerDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoggerData&&const DeepCollectionEquality().equals(other._currentDailyLogs, _currentDailyLogs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_currentDailyLogs));

@override
String toString() {
  return 'LoggerData(currentDailyLogs: $currentDailyLogs)';
}


}

/// @nodoc
abstract mixin class _$LoggerDataCopyWith<$Res> implements $LoggerDataCopyWith<$Res> {
  factory _$LoggerDataCopyWith(_LoggerData value, $Res Function(_LoggerData) _then) = __$LoggerDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'currentDailyLogs', fromJson: _serverLogEntriesFromJson) List<ServerLogEntry> currentDailyLogs
});




}
/// @nodoc
class __$LoggerDataCopyWithImpl<$Res>
    implements _$LoggerDataCopyWith<$Res> {
  __$LoggerDataCopyWithImpl(this._self, this._then);

  final _LoggerData _self;
  final $Res Function(_LoggerData) _then;

/// Create a copy of LoggerData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentDailyLogs = null,}) {
  return _then(_LoggerData(
currentDailyLogs: null == currentDailyLogs ? _self._currentDailyLogs : currentDailyLogs // ignore: cast_nullable_to_non_nullable
as List<ServerLogEntry>,
  ));
}


}

// dart format on
