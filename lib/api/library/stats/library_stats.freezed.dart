// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryStats {

@JsonKey(name: "totalItems") int? get totalItems;@JsonKey(name: "totalAuthors") int? get totalAuthors;@JsonKey(name: "totalGenres") int? get totalGenres;@JsonKey(name: "totalDuration") double? get totalDuration;@JsonKey(name: "longestItems") List<LibraryItemDurationStats>? get longestItems;@JsonKey(name: "numAudioTracks") int? get numAudioTracks;@JsonKey(name: "totalSize") int? get totalSize;@JsonKey(name: "largestItems") List<LibraryItemSizeStats>? get largestItems;@JsonKey(name: "authorsWithCount") List<AuthorStats>? get authorsWithCount;@JsonKey(name: "genresWithCount") List<GenreStats>? get genresWithCount;
/// Create a copy of LibraryStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryStatsCopyWith<LibraryStats> get copyWith => _$LibraryStatsCopyWithImpl<LibraryStats>(this as LibraryStats, _$identity);

  /// Serializes this LibraryStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryStats&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.totalAuthors, totalAuthors) || other.totalAuthors == totalAuthors)&&(identical(other.totalGenres, totalGenres) || other.totalGenres == totalGenres)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&const DeepCollectionEquality().equals(other.longestItems, longestItems)&&(identical(other.numAudioTracks, numAudioTracks) || other.numAudioTracks == numAudioTracks)&&(identical(other.totalSize, totalSize) || other.totalSize == totalSize)&&const DeepCollectionEquality().equals(other.largestItems, largestItems)&&const DeepCollectionEquality().equals(other.authorsWithCount, authorsWithCount)&&const DeepCollectionEquality().equals(other.genresWithCount, genresWithCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalItems,totalAuthors,totalGenres,totalDuration,const DeepCollectionEquality().hash(longestItems),numAudioTracks,totalSize,const DeepCollectionEquality().hash(largestItems),const DeepCollectionEquality().hash(authorsWithCount),const DeepCollectionEquality().hash(genresWithCount));

@override
String toString() {
  return 'LibraryStats(totalItems: $totalItems, totalAuthors: $totalAuthors, totalGenres: $totalGenres, totalDuration: $totalDuration, longestItems: $longestItems, numAudioTracks: $numAudioTracks, totalSize: $totalSize, largestItems: $largestItems, authorsWithCount: $authorsWithCount, genresWithCount: $genresWithCount)';
}


}

/// @nodoc
abstract mixin class $LibraryStatsCopyWith<$Res>  {
  factory $LibraryStatsCopyWith(LibraryStats value, $Res Function(LibraryStats) _then) = _$LibraryStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "totalItems") int? totalItems,@JsonKey(name: "totalAuthors") int? totalAuthors,@JsonKey(name: "totalGenres") int? totalGenres,@JsonKey(name: "totalDuration") double? totalDuration,@JsonKey(name: "longestItems") List<LibraryItemDurationStats>? longestItems,@JsonKey(name: "numAudioTracks") int? numAudioTracks,@JsonKey(name: "totalSize") int? totalSize,@JsonKey(name: "largestItems") List<LibraryItemSizeStats>? largestItems,@JsonKey(name: "authorsWithCount") List<AuthorStats>? authorsWithCount,@JsonKey(name: "genresWithCount") List<GenreStats>? genresWithCount
});




}
/// @nodoc
class _$LibraryStatsCopyWithImpl<$Res>
    implements $LibraryStatsCopyWith<$Res> {
  _$LibraryStatsCopyWithImpl(this._self, this._then);

  final LibraryStats _self;
  final $Res Function(LibraryStats) _then;

/// Create a copy of LibraryStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalItems = freezed,Object? totalAuthors = freezed,Object? totalGenres = freezed,Object? totalDuration = freezed,Object? longestItems = freezed,Object? numAudioTracks = freezed,Object? totalSize = freezed,Object? largestItems = freezed,Object? authorsWithCount = freezed,Object? genresWithCount = freezed,}) {
  return _then(_self.copyWith(
totalItems: freezed == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int?,totalAuthors: freezed == totalAuthors ? _self.totalAuthors : totalAuthors // ignore: cast_nullable_to_non_nullable
as int?,totalGenres: freezed == totalGenres ? _self.totalGenres : totalGenres // ignore: cast_nullable_to_non_nullable
as int?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as double?,longestItems: freezed == longestItems ? _self.longestItems : longestItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItemDurationStats>?,numAudioTracks: freezed == numAudioTracks ? _self.numAudioTracks : numAudioTracks // ignore: cast_nullable_to_non_nullable
as int?,totalSize: freezed == totalSize ? _self.totalSize : totalSize // ignore: cast_nullable_to_non_nullable
as int?,largestItems: freezed == largestItems ? _self.largestItems : largestItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItemSizeStats>?,authorsWithCount: freezed == authorsWithCount ? _self.authorsWithCount : authorsWithCount // ignore: cast_nullable_to_non_nullable
as List<AuthorStats>?,genresWithCount: freezed == genresWithCount ? _self.genresWithCount : genresWithCount // ignore: cast_nullable_to_non_nullable
as List<GenreStats>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryStats implements LibraryStats {
  const _LibraryStats({@JsonKey(name: "totalItems") this.totalItems, @JsonKey(name: "totalAuthors") this.totalAuthors, @JsonKey(name: "totalGenres") this.totalGenres, @JsonKey(name: "totalDuration") this.totalDuration, @JsonKey(name: "longestItems") final  List<LibraryItemDurationStats>? longestItems, @JsonKey(name: "numAudioTracks") this.numAudioTracks, @JsonKey(name: "totalSize") this.totalSize, @JsonKey(name: "largestItems") final  List<LibraryItemSizeStats>? largestItems, @JsonKey(name: "authorsWithCount") final  List<AuthorStats>? authorsWithCount, @JsonKey(name: "genresWithCount") final  List<GenreStats>? genresWithCount}): _longestItems = longestItems,_largestItems = largestItems,_authorsWithCount = authorsWithCount,_genresWithCount = genresWithCount;
  factory _LibraryStats.fromJson(Map<String, dynamic> json) => _$LibraryStatsFromJson(json);

@override@JsonKey(name: "totalItems") final  int? totalItems;
@override@JsonKey(name: "totalAuthors") final  int? totalAuthors;
@override@JsonKey(name: "totalGenres") final  int? totalGenres;
@override@JsonKey(name: "totalDuration") final  double? totalDuration;
 final  List<LibraryItemDurationStats>? _longestItems;
@override@JsonKey(name: "longestItems") List<LibraryItemDurationStats>? get longestItems {
  final value = _longestItems;
  if (value == null) return null;
  if (_longestItems is EqualUnmodifiableListView) return _longestItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "numAudioTracks") final  int? numAudioTracks;
@override@JsonKey(name: "totalSize") final  int? totalSize;
 final  List<LibraryItemSizeStats>? _largestItems;
@override@JsonKey(name: "largestItems") List<LibraryItemSizeStats>? get largestItems {
  final value = _largestItems;
  if (value == null) return null;
  if (_largestItems is EqualUnmodifiableListView) return _largestItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AuthorStats>? _authorsWithCount;
@override@JsonKey(name: "authorsWithCount") List<AuthorStats>? get authorsWithCount {
  final value = _authorsWithCount;
  if (value == null) return null;
  if (_authorsWithCount is EqualUnmodifiableListView) return _authorsWithCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<GenreStats>? _genresWithCount;
@override@JsonKey(name: "genresWithCount") List<GenreStats>? get genresWithCount {
  final value = _genresWithCount;
  if (value == null) return null;
  if (_genresWithCount is EqualUnmodifiableListView) return _genresWithCount;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LibraryStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryStatsCopyWith<_LibraryStats> get copyWith => __$LibraryStatsCopyWithImpl<_LibraryStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryStats&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems)&&(identical(other.totalAuthors, totalAuthors) || other.totalAuthors == totalAuthors)&&(identical(other.totalGenres, totalGenres) || other.totalGenres == totalGenres)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&const DeepCollectionEquality().equals(other._longestItems, _longestItems)&&(identical(other.numAudioTracks, numAudioTracks) || other.numAudioTracks == numAudioTracks)&&(identical(other.totalSize, totalSize) || other.totalSize == totalSize)&&const DeepCollectionEquality().equals(other._largestItems, _largestItems)&&const DeepCollectionEquality().equals(other._authorsWithCount, _authorsWithCount)&&const DeepCollectionEquality().equals(other._genresWithCount, _genresWithCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalItems,totalAuthors,totalGenres,totalDuration,const DeepCollectionEquality().hash(_longestItems),numAudioTracks,totalSize,const DeepCollectionEquality().hash(_largestItems),const DeepCollectionEquality().hash(_authorsWithCount),const DeepCollectionEquality().hash(_genresWithCount));

@override
String toString() {
  return 'LibraryStats(totalItems: $totalItems, totalAuthors: $totalAuthors, totalGenres: $totalGenres, totalDuration: $totalDuration, longestItems: $longestItems, numAudioTracks: $numAudioTracks, totalSize: $totalSize, largestItems: $largestItems, authorsWithCount: $authorsWithCount, genresWithCount: $genresWithCount)';
}


}

/// @nodoc
abstract mixin class _$LibraryStatsCopyWith<$Res> implements $LibraryStatsCopyWith<$Res> {
  factory _$LibraryStatsCopyWith(_LibraryStats value, $Res Function(_LibraryStats) _then) = __$LibraryStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "totalItems") int? totalItems,@JsonKey(name: "totalAuthors") int? totalAuthors,@JsonKey(name: "totalGenres") int? totalGenres,@JsonKey(name: "totalDuration") double? totalDuration,@JsonKey(name: "longestItems") List<LibraryItemDurationStats>? longestItems,@JsonKey(name: "numAudioTracks") int? numAudioTracks,@JsonKey(name: "totalSize") int? totalSize,@JsonKey(name: "largestItems") List<LibraryItemSizeStats>? largestItems,@JsonKey(name: "authorsWithCount") List<AuthorStats>? authorsWithCount,@JsonKey(name: "genresWithCount") List<GenreStats>? genresWithCount
});




}
/// @nodoc
class __$LibraryStatsCopyWithImpl<$Res>
    implements _$LibraryStatsCopyWith<$Res> {
  __$LibraryStatsCopyWithImpl(this._self, this._then);

  final _LibraryStats _self;
  final $Res Function(_LibraryStats) _then;

/// Create a copy of LibraryStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalItems = freezed,Object? totalAuthors = freezed,Object? totalGenres = freezed,Object? totalDuration = freezed,Object? longestItems = freezed,Object? numAudioTracks = freezed,Object? totalSize = freezed,Object? largestItems = freezed,Object? authorsWithCount = freezed,Object? genresWithCount = freezed,}) {
  return _then(_LibraryStats(
totalItems: freezed == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int?,totalAuthors: freezed == totalAuthors ? _self.totalAuthors : totalAuthors // ignore: cast_nullable_to_non_nullable
as int?,totalGenres: freezed == totalGenres ? _self.totalGenres : totalGenres // ignore: cast_nullable_to_non_nullable
as int?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as double?,longestItems: freezed == longestItems ? _self._longestItems : longestItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItemDurationStats>?,numAudioTracks: freezed == numAudioTracks ? _self.numAudioTracks : numAudioTracks // ignore: cast_nullable_to_non_nullable
as int?,totalSize: freezed == totalSize ? _self.totalSize : totalSize // ignore: cast_nullable_to_non_nullable
as int?,largestItems: freezed == largestItems ? _self._largestItems : largestItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItemSizeStats>?,authorsWithCount: freezed == authorsWithCount ? _self._authorsWithCount : authorsWithCount // ignore: cast_nullable_to_non_nullable
as List<AuthorStats>?,genresWithCount: freezed == genresWithCount ? _self._genresWithCount : genresWithCount // ignore: cast_nullable_to_non_nullable
as List<GenreStats>?,
  ));
}


}

// dart format on
