// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
