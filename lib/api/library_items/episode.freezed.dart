// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Episode {

@JsonKey(name: "libraryItemId") String get libraryItemId;@JsonKey(name: "id") String get id;@JsonKey(name: "index", fromJson: jsonIntFromDynamic) int? get index;@JsonKey(name: "season") String? get season;@JsonKey(name: "episode") String? get episode;@JsonKey(name: "episodeType") String? get episodeType;@JsonKey(name: "title") String? get title;@JsonKey(name: "subtitle") String? get subtitle;@JsonKey(name: "description") String? get description;@JsonKey(name: "guid") String? get guid;@JsonKey(name: "enclosure") EpisodeEnclosure? get enclosure;@JsonKey(name: "pubDate") String? get pubDate;@JsonKey(name: "audioFile") AudioFile? get audioFile;@JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic) int? get publishedAt;@JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic) int? get addedAt;@JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic) int? get updatedAt;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);

  /// Serializes this Episode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.guid, guid) || other.guid == guid)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.audioFile, audioFile) || other.audioFile == audioFile)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,id,index,season,episode,episodeType,title,subtitle,description,guid,enclosure,pubDate,audioFile,publishedAt,addedAt,updatedAt);

@override
String toString() {
  return 'Episode(libraryItemId: $libraryItemId, id: $id, index: $index, season: $season, episode: $episode, episodeType: $episodeType, title: $title, subtitle: $subtitle, description: $description, guid: $guid, enclosure: $enclosure, pubDate: $pubDate, audioFile: $audioFile, publishedAt: $publishedAt, addedAt: $addedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "id") String id,@JsonKey(name: "index", fromJson: jsonIntFromDynamic) int? index,@JsonKey(name: "season") String? season,@JsonKey(name: "episode") String? episode,@JsonKey(name: "episodeType") String? episodeType,@JsonKey(name: "title") String? title,@JsonKey(name: "subtitle") String? subtitle,@JsonKey(name: "description") String? description,@JsonKey(name: "guid") String? guid,@JsonKey(name: "enclosure") EpisodeEnclosure? enclosure,@JsonKey(name: "pubDate") String? pubDate,@JsonKey(name: "audioFile") AudioFile? audioFile,@JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic) int? publishedAt,@JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic) int? addedAt,@JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic) int? updatedAt
});


$EpisodeEnclosureCopyWith<$Res>? get enclosure;$AudioFileCopyWith<$Res>? get audioFile;

}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItemId = null,Object? id = null,Object? index = freezed,Object? season = freezed,Object? episode = freezed,Object? episodeType = freezed,Object? title = freezed,Object? subtitle = freezed,Object? description = freezed,Object? guid = freezed,Object? enclosure = freezed,Object? pubDate = freezed,Object? audioFile = freezed,Object? publishedAt = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,guid: freezed == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as EpisodeEnclosure?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,audioFile: freezed == audioFile ? _self.audioFile : audioFile // ignore: cast_nullable_to_non_nullable
as AudioFile?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as int?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeEnclosureCopyWith<$Res>? get enclosure {
    if (_self.enclosure == null) {
    return null;
  }

  return $EpisodeEnclosureCopyWith<$Res>(_self.enclosure!, (value) {
    return _then(_self.copyWith(enclosure: value));
  });
}/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioFileCopyWith<$Res>? get audioFile {
    if (_self.audioFile == null) {
    return null;
  }

  return $AudioFileCopyWith<$Res>(_self.audioFile!, (value) {
    return _then(_self.copyWith(audioFile: value));
  });
}
}


/// Adds pattern-matching-related methods to [Episode].
extension EpisodePatterns on Episode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Episode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Episode value)  $default,){
final _that = this;
switch (_that) {
case _Episode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Episode value)?  $default,){
final _that = this;
switch (_that) {
case _Episode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "libraryItemId")  String libraryItemId, @JsonKey(name: "id")  String id, @JsonKey(name: "index", fromJson: jsonIntFromDynamic)  int? index, @JsonKey(name: "season")  String? season, @JsonKey(name: "episode")  String? episode, @JsonKey(name: "episodeType")  String? episodeType, @JsonKey(name: "title")  String? title, @JsonKey(name: "subtitle")  String? subtitle, @JsonKey(name: "description")  String? description, @JsonKey(name: "guid")  String? guid, @JsonKey(name: "enclosure")  EpisodeEnclosure? enclosure, @JsonKey(name: "pubDate")  String? pubDate, @JsonKey(name: "audioFile")  AudioFile? audioFile, @JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic)  int? publishedAt, @JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic)  int? addedAt, @JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic)  int? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.libraryItemId,_that.id,_that.index,_that.season,_that.episode,_that.episodeType,_that.title,_that.subtitle,_that.description,_that.guid,_that.enclosure,_that.pubDate,_that.audioFile,_that.publishedAt,_that.addedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "libraryItemId")  String libraryItemId, @JsonKey(name: "id")  String id, @JsonKey(name: "index", fromJson: jsonIntFromDynamic)  int? index, @JsonKey(name: "season")  String? season, @JsonKey(name: "episode")  String? episode, @JsonKey(name: "episodeType")  String? episodeType, @JsonKey(name: "title")  String? title, @JsonKey(name: "subtitle")  String? subtitle, @JsonKey(name: "description")  String? description, @JsonKey(name: "guid")  String? guid, @JsonKey(name: "enclosure")  EpisodeEnclosure? enclosure, @JsonKey(name: "pubDate")  String? pubDate, @JsonKey(name: "audioFile")  AudioFile? audioFile, @JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic)  int? publishedAt, @JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic)  int? addedAt, @JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic)  int? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Episode():
return $default(_that.libraryItemId,_that.id,_that.index,_that.season,_that.episode,_that.episodeType,_that.title,_that.subtitle,_that.description,_that.guid,_that.enclosure,_that.pubDate,_that.audioFile,_that.publishedAt,_that.addedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "libraryItemId")  String libraryItemId, @JsonKey(name: "id")  String id, @JsonKey(name: "index", fromJson: jsonIntFromDynamic)  int? index, @JsonKey(name: "season")  String? season, @JsonKey(name: "episode")  String? episode, @JsonKey(name: "episodeType")  String? episodeType, @JsonKey(name: "title")  String? title, @JsonKey(name: "subtitle")  String? subtitle, @JsonKey(name: "description")  String? description, @JsonKey(name: "guid")  String? guid, @JsonKey(name: "enclosure")  EpisodeEnclosure? enclosure, @JsonKey(name: "pubDate")  String? pubDate, @JsonKey(name: "audioFile")  AudioFile? audioFile, @JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic)  int? publishedAt, @JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic)  int? addedAt, @JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic)  int? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Episode() when $default != null:
return $default(_that.libraryItemId,_that.id,_that.index,_that.season,_that.episode,_that.episodeType,_that.title,_that.subtitle,_that.description,_that.guid,_that.enclosure,_that.pubDate,_that.audioFile,_that.publishedAt,_that.addedAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Episode implements Episode {
  const _Episode({@JsonKey(name: "libraryItemId") required this.libraryItemId, @JsonKey(name: "id") required this.id, @JsonKey(name: "index", fromJson: jsonIntFromDynamic) this.index, @JsonKey(name: "season") this.season, @JsonKey(name: "episode") this.episode, @JsonKey(name: "episodeType") this.episodeType, @JsonKey(name: "title") this.title, @JsonKey(name: "subtitle") this.subtitle, @JsonKey(name: "description") this.description, @JsonKey(name: "guid") this.guid, @JsonKey(name: "enclosure") this.enclosure, @JsonKey(name: "pubDate") this.pubDate, @JsonKey(name: "audioFile") this.audioFile, @JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic) this.publishedAt, @JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic) this.addedAt, @JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic) this.updatedAt});
  factory _Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);

@override@JsonKey(name: "libraryItemId") final  String libraryItemId;
@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "index", fromJson: jsonIntFromDynamic) final  int? index;
@override@JsonKey(name: "season") final  String? season;
@override@JsonKey(name: "episode") final  String? episode;
@override@JsonKey(name: "episodeType") final  String? episodeType;
@override@JsonKey(name: "title") final  String? title;
@override@JsonKey(name: "subtitle") final  String? subtitle;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "guid") final  String? guid;
@override@JsonKey(name: "enclosure") final  EpisodeEnclosure? enclosure;
@override@JsonKey(name: "pubDate") final  String? pubDate;
@override@JsonKey(name: "audioFile") final  AudioFile? audioFile;
@override@JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic) final  int? publishedAt;
@override@JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic) final  int? addedAt;
@override@JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic) final  int? updatedAt;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeCopyWith<_Episode> get copyWith => __$EpisodeCopyWithImpl<_Episode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.guid, guid) || other.guid == guid)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.audioFile, audioFile) || other.audioFile == audioFile)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,id,index,season,episode,episodeType,title,subtitle,description,guid,enclosure,pubDate,audioFile,publishedAt,addedAt,updatedAt);

@override
String toString() {
  return 'Episode(libraryItemId: $libraryItemId, id: $id, index: $index, season: $season, episode: $episode, episodeType: $episodeType, title: $title, subtitle: $subtitle, description: $description, guid: $guid, enclosure: $enclosure, pubDate: $pubDate, audioFile: $audioFile, publishedAt: $publishedAt, addedAt: $addedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "id") String id,@JsonKey(name: "index", fromJson: jsonIntFromDynamic) int? index,@JsonKey(name: "season") String? season,@JsonKey(name: "episode") String? episode,@JsonKey(name: "episodeType") String? episodeType,@JsonKey(name: "title") String? title,@JsonKey(name: "subtitle") String? subtitle,@JsonKey(name: "description") String? description,@JsonKey(name: "guid") String? guid,@JsonKey(name: "enclosure") EpisodeEnclosure? enclosure,@JsonKey(name: "pubDate") String? pubDate,@JsonKey(name: "audioFile") AudioFile? audioFile,@JsonKey(name: "publishedAt", fromJson: jsonIntFromDynamic) int? publishedAt,@JsonKey(name: "addedAt", fromJson: jsonIntFromDynamic) int? addedAt,@JsonKey(name: "updatedAt", fromJson: jsonIntFromDynamic) int? updatedAt
});


@override $EpisodeEnclosureCopyWith<$Res>? get enclosure;@override $AudioFileCopyWith<$Res>? get audioFile;

}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItemId = null,Object? id = null,Object? index = freezed,Object? season = freezed,Object? episode = freezed,Object? episodeType = freezed,Object? title = freezed,Object? subtitle = freezed,Object? description = freezed,Object? guid = freezed,Object? enclosure = freezed,Object? pubDate = freezed,Object? audioFile = freezed,Object? publishedAt = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Episode(
libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,guid: freezed == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as EpisodeEnclosure?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,audioFile: freezed == audioFile ? _self.audioFile : audioFile // ignore: cast_nullable_to_non_nullable
as AudioFile?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as int?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeEnclosureCopyWith<$Res>? get enclosure {
    if (_self.enclosure == null) {
    return null;
  }

  return $EpisodeEnclosureCopyWith<$Res>(_self.enclosure!, (value) {
    return _then(_self.copyWith(enclosure: value));
  });
}/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AudioFileCopyWith<$Res>? get audioFile {
    if (_self.audioFile == null) {
    return null;
  }

  return $AudioFileCopyWith<$Res>(_self.audioFile!, (value) {
    return _then(_self.copyWith(audioFile: value));
  });
}
}

// dart format on
