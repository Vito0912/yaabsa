// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genre_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenreStats {

@JsonKey(name: "genre") String get genre;@JsonKey(name: "count") int get count;
/// Create a copy of GenreStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreStatsCopyWith<GenreStats> get copyWith => _$GenreStatsCopyWithImpl<GenreStats>(this as GenreStats, _$identity);

  /// Serializes this GenreStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreStats&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genre,count);

@override
String toString() {
  return 'GenreStats(genre: $genre, count: $count)';
}


}

/// @nodoc
abstract mixin class $GenreStatsCopyWith<$Res>  {
  factory $GenreStatsCopyWith(GenreStats value, $Res Function(GenreStats) _then) = _$GenreStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "genre") String genre,@JsonKey(name: "count") int count
});




}
/// @nodoc
class _$GenreStatsCopyWithImpl<$Res>
    implements $GenreStatsCopyWith<$Res> {
  _$GenreStatsCopyWithImpl(this._self, this._then);

  final GenreStats _self;
  final $Res Function(GenreStats) _then;

/// Create a copy of GenreStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genre = null,Object? count = null,}) {
  return _then(_self.copyWith(
genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GenreStats].
extension GenreStatsPatterns on GenreStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenreStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenreStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenreStats value)  $default,){
final _that = this;
switch (_that) {
case _GenreStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenreStats value)?  $default,){
final _that = this;
switch (_that) {
case _GenreStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "genre")  String genre, @JsonKey(name: "count")  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenreStats() when $default != null:
return $default(_that.genre,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "genre")  String genre, @JsonKey(name: "count")  int count)  $default,) {final _that = this;
switch (_that) {
case _GenreStats():
return $default(_that.genre,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "genre")  String genre, @JsonKey(name: "count")  int count)?  $default,) {final _that = this;
switch (_that) {
case _GenreStats() when $default != null:
return $default(_that.genre,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenreStats implements GenreStats {
  const _GenreStats({@JsonKey(name: "genre") required this.genre, @JsonKey(name: "count") required this.count});
  factory _GenreStats.fromJson(Map<String, dynamic> json) => _$GenreStatsFromJson(json);

@override@JsonKey(name: "genre") final  String genre;
@override@JsonKey(name: "count") final  int count;

/// Create a copy of GenreStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreStatsCopyWith<_GenreStats> get copyWith => __$GenreStatsCopyWithImpl<_GenreStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreStats&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,genre,count);

@override
String toString() {
  return 'GenreStats(genre: $genre, count: $count)';
}


}

/// @nodoc
abstract mixin class _$GenreStatsCopyWith<$Res> implements $GenreStatsCopyWith<$Res> {
  factory _$GenreStatsCopyWith(_GenreStats value, $Res Function(_GenreStats) _then) = __$GenreStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "genre") String genre,@JsonKey(name: "count") int count
});




}
/// @nodoc
class __$GenreStatsCopyWithImpl<$Res>
    implements _$GenreStatsCopyWith<$Res> {
  __$GenreStatsCopyWithImpl(this._self, this._then);

  final _GenreStats _self;
  final $Res Function(_GenreStats) _then;

/// Create a copy of GenreStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genre = null,Object? count = null,}) {
  return _then(_GenreStats(
genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
