// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_duration_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItemDurationStats {

@JsonKey(name: "id") String get id;@JsonKey(name: "duration") double get duration;@JsonKey(name: "title") String get title;
/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemDurationStatsCopyWith<LibraryItemDurationStats> get copyWith => _$LibraryItemDurationStatsCopyWithImpl<LibraryItemDurationStats>(this as LibraryItemDurationStats, _$identity);

  /// Serializes this LibraryItemDurationStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemDurationStats&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,duration,title);

@override
String toString() {
  return 'LibraryItemDurationStats(id: $id, duration: $duration, title: $title)';
}


}

/// @nodoc
abstract mixin class $LibraryItemDurationStatsCopyWith<$Res>  {
  factory $LibraryItemDurationStatsCopyWith(LibraryItemDurationStats value, $Res Function(LibraryItemDurationStats) _then) = _$LibraryItemDurationStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "duration") double duration,@JsonKey(name: "title") String title
});




}
/// @nodoc
class _$LibraryItemDurationStatsCopyWithImpl<$Res>
    implements $LibraryItemDurationStatsCopyWith<$Res> {
  _$LibraryItemDurationStatsCopyWithImpl(this._self, this._then);

  final LibraryItemDurationStats _self;
  final $Res Function(LibraryItemDurationStats) _then;

/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? duration = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryItemDurationStats].
extension LibraryItemDurationStatsPatterns on LibraryItemDurationStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryItemDurationStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryItemDurationStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryItemDurationStats value)  $default,){
final _that = this;
switch (_that) {
case _LibraryItemDurationStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryItemDurationStats value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryItemDurationStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "duration")  double duration, @JsonKey(name: "title")  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryItemDurationStats() when $default != null:
return $default(_that.id,_that.duration,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "duration")  double duration, @JsonKey(name: "title")  String title)  $default,) {final _that = this;
switch (_that) {
case _LibraryItemDurationStats():
return $default(_that.id,_that.duration,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "duration")  double duration, @JsonKey(name: "title")  String title)?  $default,) {final _that = this;
switch (_that) {
case _LibraryItemDurationStats() when $default != null:
return $default(_that.id,_that.duration,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryItemDurationStats implements LibraryItemDurationStats {
  const _LibraryItemDurationStats({@JsonKey(name: "id") required this.id, @JsonKey(name: "duration") required this.duration, @JsonKey(name: "title") required this.title});
  factory _LibraryItemDurationStats.fromJson(Map<String, dynamic> json) => _$LibraryItemDurationStatsFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "duration") final  double duration;
@override@JsonKey(name: "title") final  String title;

/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemDurationStatsCopyWith<_LibraryItemDurationStats> get copyWith => __$LibraryItemDurationStatsCopyWithImpl<_LibraryItemDurationStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemDurationStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemDurationStats&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,duration,title);

@override
String toString() {
  return 'LibraryItemDurationStats(id: $id, duration: $duration, title: $title)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemDurationStatsCopyWith<$Res> implements $LibraryItemDurationStatsCopyWith<$Res> {
  factory _$LibraryItemDurationStatsCopyWith(_LibraryItemDurationStats value, $Res Function(_LibraryItemDurationStats) _then) = __$LibraryItemDurationStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "duration") double duration,@JsonKey(name: "title") String title
});




}
/// @nodoc
class __$LibraryItemDurationStatsCopyWithImpl<$Res>
    implements _$LibraryItemDurationStatsCopyWith<$Res> {
  __$LibraryItemDurationStatsCopyWithImpl(this._self, this._then);

  final _LibraryItemDurationStats _self;
  final $Res Function(_LibraryItemDurationStats) _then;

/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? duration = null,Object? title = null,}) {
  return _then(_LibraryItemDurationStats(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
