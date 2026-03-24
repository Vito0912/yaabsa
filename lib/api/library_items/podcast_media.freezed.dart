// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PodcastMedia {

@JsonKey(name: "id") String get id;@JsonKey(name: "libraryItemId") String get libraryItemId;@JsonKey(name: "metadata") PodcastMetadata get metadata;@JsonKey(name: "coverPath") String? get coverPath;@JsonKey(name: "tags") List<String>? get tags;@JsonKey(name: "episodes") List<Episode>? get episodes;@JsonKey(name: "autoDownloadEpisodes") bool? get autoDownloadEpisodes;@JsonKey(name: "autoDownloadSchedule") String? get autoDownloadSchedule;@JsonKey(name: "lastEpisodeCheck") int? get lastEpisodeCheck;@JsonKey(name: "maxEpisodesToKeep") int? get maxEpisodesToKeep;@JsonKey(name: "maxNewEpisodesToDownload") int? get maxNewEpisodesToDownload;
/// Create a copy of PodcastMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastMediaCopyWith<PodcastMedia> get copyWith => _$PodcastMediaCopyWithImpl<PodcastMedia>(this as PodcastMedia, _$identity);

  /// Serializes this PodcastMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.autoDownloadEpisodes, autoDownloadEpisodes) || other.autoDownloadEpisodes == autoDownloadEpisodes)&&(identical(other.autoDownloadSchedule, autoDownloadSchedule) || other.autoDownloadSchedule == autoDownloadSchedule)&&(identical(other.lastEpisodeCheck, lastEpisodeCheck) || other.lastEpisodeCheck == lastEpisodeCheck)&&(identical(other.maxEpisodesToKeep, maxEpisodesToKeep) || other.maxEpisodesToKeep == maxEpisodesToKeep)&&(identical(other.maxNewEpisodesToDownload, maxNewEpisodesToDownload) || other.maxNewEpisodesToDownload == maxNewEpisodesToDownload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryItemId,metadata,coverPath,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(episodes),autoDownloadEpisodes,autoDownloadSchedule,lastEpisodeCheck,maxEpisodesToKeep,maxNewEpisodesToDownload);

@override
String toString() {
  return 'PodcastMedia(id: $id, libraryItemId: $libraryItemId, metadata: $metadata, coverPath: $coverPath, tags: $tags, episodes: $episodes, autoDownloadEpisodes: $autoDownloadEpisodes, autoDownloadSchedule: $autoDownloadSchedule, lastEpisodeCheck: $lastEpisodeCheck, maxEpisodesToKeep: $maxEpisodesToKeep, maxNewEpisodesToDownload: $maxNewEpisodesToDownload)';
}


}

/// @nodoc
abstract mixin class $PodcastMediaCopyWith<$Res>  {
  factory $PodcastMediaCopyWith(PodcastMedia value, $Res Function(PodcastMedia) _then) = _$PodcastMediaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "metadata") PodcastMetadata metadata,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "tags") List<String>? tags,@JsonKey(name: "episodes") List<Episode>? episodes,@JsonKey(name: "autoDownloadEpisodes") bool? autoDownloadEpisodes,@JsonKey(name: "autoDownloadSchedule") String? autoDownloadSchedule,@JsonKey(name: "lastEpisodeCheck") int? lastEpisodeCheck,@JsonKey(name: "maxEpisodesToKeep") int? maxEpisodesToKeep,@JsonKey(name: "maxNewEpisodesToDownload") int? maxNewEpisodesToDownload
});


$PodcastMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$PodcastMediaCopyWithImpl<$Res>
    implements $PodcastMediaCopyWith<$Res> {
  _$PodcastMediaCopyWithImpl(this._self, this._then);

  final PodcastMedia _self;
  final $Res Function(PodcastMedia) _then;

/// Create a copy of PodcastMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? libraryItemId = null,Object? metadata = null,Object? coverPath = freezed,Object? tags = freezed,Object? episodes = freezed,Object? autoDownloadEpisodes = freezed,Object? autoDownloadSchedule = freezed,Object? lastEpisodeCheck = freezed,Object? maxEpisodesToKeep = freezed,Object? maxNewEpisodesToDownload = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PodcastMetadata,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,episodes: freezed == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>?,autoDownloadEpisodes: freezed == autoDownloadEpisodes ? _self.autoDownloadEpisodes : autoDownloadEpisodes // ignore: cast_nullable_to_non_nullable
as bool?,autoDownloadSchedule: freezed == autoDownloadSchedule ? _self.autoDownloadSchedule : autoDownloadSchedule // ignore: cast_nullable_to_non_nullable
as String?,lastEpisodeCheck: freezed == lastEpisodeCheck ? _self.lastEpisodeCheck : lastEpisodeCheck // ignore: cast_nullable_to_non_nullable
as int?,maxEpisodesToKeep: freezed == maxEpisodesToKeep ? _self.maxEpisodesToKeep : maxEpisodesToKeep // ignore: cast_nullable_to_non_nullable
as int?,maxNewEpisodesToDownload: freezed == maxNewEpisodesToDownload ? _self.maxNewEpisodesToDownload : maxNewEpisodesToDownload // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<$Res> get metadata {
  
  return $PodcastMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastMedia].
extension PodcastMediaPatterns on PodcastMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastMedia value)  $default,){
final _that = this;
switch (_that) {
case _PodcastMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastMedia value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "libraryItemId")  String libraryItemId, @JsonKey(name: "metadata")  PodcastMetadata metadata, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "tags")  List<String>? tags, @JsonKey(name: "episodes")  List<Episode>? episodes, @JsonKey(name: "autoDownloadEpisodes")  bool? autoDownloadEpisodes, @JsonKey(name: "autoDownloadSchedule")  String? autoDownloadSchedule, @JsonKey(name: "lastEpisodeCheck")  int? lastEpisodeCheck, @JsonKey(name: "maxEpisodesToKeep")  int? maxEpisodesToKeep, @JsonKey(name: "maxNewEpisodesToDownload")  int? maxNewEpisodesToDownload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastMedia() when $default != null:
return $default(_that.id,_that.libraryItemId,_that.metadata,_that.coverPath,_that.tags,_that.episodes,_that.autoDownloadEpisodes,_that.autoDownloadSchedule,_that.lastEpisodeCheck,_that.maxEpisodesToKeep,_that.maxNewEpisodesToDownload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "libraryItemId")  String libraryItemId, @JsonKey(name: "metadata")  PodcastMetadata metadata, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "tags")  List<String>? tags, @JsonKey(name: "episodes")  List<Episode>? episodes, @JsonKey(name: "autoDownloadEpisodes")  bool? autoDownloadEpisodes, @JsonKey(name: "autoDownloadSchedule")  String? autoDownloadSchedule, @JsonKey(name: "lastEpisodeCheck")  int? lastEpisodeCheck, @JsonKey(name: "maxEpisodesToKeep")  int? maxEpisodesToKeep, @JsonKey(name: "maxNewEpisodesToDownload")  int? maxNewEpisodesToDownload)  $default,) {final _that = this;
switch (_that) {
case _PodcastMedia():
return $default(_that.id,_that.libraryItemId,_that.metadata,_that.coverPath,_that.tags,_that.episodes,_that.autoDownloadEpisodes,_that.autoDownloadSchedule,_that.lastEpisodeCheck,_that.maxEpisodesToKeep,_that.maxNewEpisodesToDownload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "libraryItemId")  String libraryItemId, @JsonKey(name: "metadata")  PodcastMetadata metadata, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "tags")  List<String>? tags, @JsonKey(name: "episodes")  List<Episode>? episodes, @JsonKey(name: "autoDownloadEpisodes")  bool? autoDownloadEpisodes, @JsonKey(name: "autoDownloadSchedule")  String? autoDownloadSchedule, @JsonKey(name: "lastEpisodeCheck")  int? lastEpisodeCheck, @JsonKey(name: "maxEpisodesToKeep")  int? maxEpisodesToKeep, @JsonKey(name: "maxNewEpisodesToDownload")  int? maxNewEpisodesToDownload)?  $default,) {final _that = this;
switch (_that) {
case _PodcastMedia() when $default != null:
return $default(_that.id,_that.libraryItemId,_that.metadata,_that.coverPath,_that.tags,_that.episodes,_that.autoDownloadEpisodes,_that.autoDownloadSchedule,_that.lastEpisodeCheck,_that.maxEpisodesToKeep,_that.maxNewEpisodesToDownload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastMedia implements PodcastMedia {
  const _PodcastMedia({@JsonKey(name: "id") required this.id, @JsonKey(name: "libraryItemId") required this.libraryItemId, @JsonKey(name: "metadata") required this.metadata, @JsonKey(name: "coverPath") this.coverPath, @JsonKey(name: "tags") final  List<String>? tags, @JsonKey(name: "episodes") final  List<Episode>? episodes, @JsonKey(name: "autoDownloadEpisodes") this.autoDownloadEpisodes, @JsonKey(name: "autoDownloadSchedule") this.autoDownloadSchedule, @JsonKey(name: "lastEpisodeCheck") this.lastEpisodeCheck, @JsonKey(name: "maxEpisodesToKeep") this.maxEpisodesToKeep, @JsonKey(name: "maxNewEpisodesToDownload") this.maxNewEpisodesToDownload}): _tags = tags,_episodes = episodes;
  factory _PodcastMedia.fromJson(Map<String, dynamic> json) => _$PodcastMediaFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "libraryItemId") final  String libraryItemId;
@override@JsonKey(name: "metadata") final  PodcastMetadata metadata;
@override@JsonKey(name: "coverPath") final  String? coverPath;
 final  List<String>? _tags;
@override@JsonKey(name: "tags") List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Episode>? _episodes;
@override@JsonKey(name: "episodes") List<Episode>? get episodes {
  final value = _episodes;
  if (value == null) return null;
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "autoDownloadEpisodes") final  bool? autoDownloadEpisodes;
@override@JsonKey(name: "autoDownloadSchedule") final  String? autoDownloadSchedule;
@override@JsonKey(name: "lastEpisodeCheck") final  int? lastEpisodeCheck;
@override@JsonKey(name: "maxEpisodesToKeep") final  int? maxEpisodesToKeep;
@override@JsonKey(name: "maxNewEpisodesToDownload") final  int? maxNewEpisodesToDownload;

/// Create a copy of PodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastMediaCopyWith<_PodcastMedia> get copyWith => __$PodcastMediaCopyWithImpl<_PodcastMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.autoDownloadEpisodes, autoDownloadEpisodes) || other.autoDownloadEpisodes == autoDownloadEpisodes)&&(identical(other.autoDownloadSchedule, autoDownloadSchedule) || other.autoDownloadSchedule == autoDownloadSchedule)&&(identical(other.lastEpisodeCheck, lastEpisodeCheck) || other.lastEpisodeCheck == lastEpisodeCheck)&&(identical(other.maxEpisodesToKeep, maxEpisodesToKeep) || other.maxEpisodesToKeep == maxEpisodesToKeep)&&(identical(other.maxNewEpisodesToDownload, maxNewEpisodesToDownload) || other.maxNewEpisodesToDownload == maxNewEpisodesToDownload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryItemId,metadata,coverPath,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_episodes),autoDownloadEpisodes,autoDownloadSchedule,lastEpisodeCheck,maxEpisodesToKeep,maxNewEpisodesToDownload);

@override
String toString() {
  return 'PodcastMedia(id: $id, libraryItemId: $libraryItemId, metadata: $metadata, coverPath: $coverPath, tags: $tags, episodes: $episodes, autoDownloadEpisodes: $autoDownloadEpisodes, autoDownloadSchedule: $autoDownloadSchedule, lastEpisodeCheck: $lastEpisodeCheck, maxEpisodesToKeep: $maxEpisodesToKeep, maxNewEpisodesToDownload: $maxNewEpisodesToDownload)';
}


}

/// @nodoc
abstract mixin class _$PodcastMediaCopyWith<$Res> implements $PodcastMediaCopyWith<$Res> {
  factory _$PodcastMediaCopyWith(_PodcastMedia value, $Res Function(_PodcastMedia) _then) = __$PodcastMediaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "metadata") PodcastMetadata metadata,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "tags") List<String>? tags,@JsonKey(name: "episodes") List<Episode>? episodes,@JsonKey(name: "autoDownloadEpisodes") bool? autoDownloadEpisodes,@JsonKey(name: "autoDownloadSchedule") String? autoDownloadSchedule,@JsonKey(name: "lastEpisodeCheck") int? lastEpisodeCheck,@JsonKey(name: "maxEpisodesToKeep") int? maxEpisodesToKeep,@JsonKey(name: "maxNewEpisodesToDownload") int? maxNewEpisodesToDownload
});


@override $PodcastMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$PodcastMediaCopyWithImpl<$Res>
    implements _$PodcastMediaCopyWith<$Res> {
  __$PodcastMediaCopyWithImpl(this._self, this._then);

  final _PodcastMedia _self;
  final $Res Function(_PodcastMedia) _then;

/// Create a copy of PodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? libraryItemId = null,Object? metadata = null,Object? coverPath = freezed,Object? tags = freezed,Object? episodes = freezed,Object? autoDownloadEpisodes = freezed,Object? autoDownloadSchedule = freezed,Object? lastEpisodeCheck = freezed,Object? maxEpisodesToKeep = freezed,Object? maxNewEpisodesToDownload = freezed,}) {
  return _then(_PodcastMedia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PodcastMetadata,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,episodes: freezed == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>?,autoDownloadEpisodes: freezed == autoDownloadEpisodes ? _self.autoDownloadEpisodes : autoDownloadEpisodes // ignore: cast_nullable_to_non_nullable
as bool?,autoDownloadSchedule: freezed == autoDownloadSchedule ? _self.autoDownloadSchedule : autoDownloadSchedule // ignore: cast_nullable_to_non_nullable
as String?,lastEpisodeCheck: freezed == lastEpisodeCheck ? _self.lastEpisodeCheck : lastEpisodeCheck // ignore: cast_nullable_to_non_nullable
as int?,maxEpisodesToKeep: freezed == maxEpisodesToKeep ? _self.maxEpisodesToKeep : maxEpisodesToKeep // ignore: cast_nullable_to_non_nullable
as int?,maxNewEpisodesToDownload: freezed == maxNewEpisodesToDownload ? _self.maxNewEpisodesToDownload : maxNewEpisodesToDownload // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<$Res> get metadata {
  
  return $PodcastMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
