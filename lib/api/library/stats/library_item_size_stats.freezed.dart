// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_size_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItemSizeStats {

@JsonKey(name: "id") String get id;@JsonKey(name: "size") int get size;@JsonKey(name: "title") String get title;
/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemSizeStatsCopyWith<LibraryItemSizeStats> get copyWith => _$LibraryItemSizeStatsCopyWithImpl<LibraryItemSizeStats>(this as LibraryItemSizeStats, _$identity);

  /// Serializes this LibraryItemSizeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemSizeStats&&(identical(other.id, id) || other.id == id)&&(identical(other.size, size) || other.size == size)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,size,title);

@override
String toString() {
  return 'LibraryItemSizeStats(id: $id, size: $size, title: $title)';
}


}

/// @nodoc
abstract mixin class $LibraryItemSizeStatsCopyWith<$Res>  {
  factory $LibraryItemSizeStatsCopyWith(LibraryItemSizeStats value, $Res Function(LibraryItemSizeStats) _then) = _$LibraryItemSizeStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "size") int size,@JsonKey(name: "title") String title
});




}
/// @nodoc
class _$LibraryItemSizeStatsCopyWithImpl<$Res>
    implements $LibraryItemSizeStatsCopyWith<$Res> {
  _$LibraryItemSizeStatsCopyWithImpl(this._self, this._then);

  final LibraryItemSizeStats _self;
  final $Res Function(LibraryItemSizeStats) _then;

/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? size = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryItemSizeStats].
extension LibraryItemSizeStatsPatterns on LibraryItemSizeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryItemSizeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryItemSizeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryItemSizeStats value)  $default,){
final _that = this;
switch (_that) {
case _LibraryItemSizeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryItemSizeStats value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryItemSizeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "size")  int size, @JsonKey(name: "title")  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryItemSizeStats() when $default != null:
return $default(_that.id,_that.size,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "size")  int size, @JsonKey(name: "title")  String title)  $default,) {final _that = this;
switch (_that) {
case _LibraryItemSizeStats():
return $default(_that.id,_that.size,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "size")  int size, @JsonKey(name: "title")  String title)?  $default,) {final _that = this;
switch (_that) {
case _LibraryItemSizeStats() when $default != null:
return $default(_that.id,_that.size,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryItemSizeStats implements LibraryItemSizeStats {
  const _LibraryItemSizeStats({@JsonKey(name: "id") required this.id, @JsonKey(name: "size") required this.size, @JsonKey(name: "title") required this.title});
  factory _LibraryItemSizeStats.fromJson(Map<String, dynamic> json) => _$LibraryItemSizeStatsFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "size") final  int size;
@override@JsonKey(name: "title") final  String title;

/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemSizeStatsCopyWith<_LibraryItemSizeStats> get copyWith => __$LibraryItemSizeStatsCopyWithImpl<_LibraryItemSizeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemSizeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemSizeStats&&(identical(other.id, id) || other.id == id)&&(identical(other.size, size) || other.size == size)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,size,title);

@override
String toString() {
  return 'LibraryItemSizeStats(id: $id, size: $size, title: $title)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemSizeStatsCopyWith<$Res> implements $LibraryItemSizeStatsCopyWith<$Res> {
  factory _$LibraryItemSizeStatsCopyWith(_LibraryItemSizeStats value, $Res Function(_LibraryItemSizeStats) _then) = __$LibraryItemSizeStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "size") int size,@JsonKey(name: "title") String title
});




}
/// @nodoc
class __$LibraryItemSizeStatsCopyWithImpl<$Res>
    implements _$LibraryItemSizeStatsCopyWith<$Res> {
  __$LibraryItemSizeStatsCopyWithImpl(this._self, this._then);

  final _LibraryItemSizeStats _self;
  final $Res Function(_LibraryItemSizeStats) _then;

/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? size = null,Object? title = null,}) {
  return _then(_LibraryItemSizeStats(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
