// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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

@JsonKey(name: "libraryItemId") String get libraryItemId;@JsonKey(name: "id") String get id;@JsonKey(name: "index") int? get index;@JsonKey(name: "season") String? get season;@JsonKey(name: "episode") String? get episode;@JsonKey(name: "episodeType") String? get episodeType;@JsonKey(name: "title") String? get title;@JsonKey(name: "subtitle") String? get subtitle;@JsonKey(name: "description") String? get description;//TODO: PodcastEnclosure
@JsonKey(name: "pubDate") String? get pubDate;@JsonKey(name: "audioFile") AudioFile? get audioFile;@JsonKey(name: "publishedAt") int? get publishedAt;@JsonKey(name: "addedAt") int? get addedAt;@JsonKey(name: "updatedAt") int? get updatedAt;
/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeCopyWith<Episode> get copyWith => _$EpisodeCopyWithImpl<Episode>(this as Episode, _$identity);

  /// Serializes this Episode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Episode&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.audioFile, audioFile) || other.audioFile == audioFile)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,id,index,season,episode,episodeType,title,subtitle,description,pubDate,audioFile,publishedAt,addedAt,updatedAt);

@override
String toString() {
  return 'Episode(libraryItemId: $libraryItemId, id: $id, index: $index, season: $season, episode: $episode, episodeType: $episodeType, title: $title, subtitle: $subtitle, description: $description, pubDate: $pubDate, audioFile: $audioFile, publishedAt: $publishedAt, addedAt: $addedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EpisodeCopyWith<$Res>  {
  factory $EpisodeCopyWith(Episode value, $Res Function(Episode) _then) = _$EpisodeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "id") String id,@JsonKey(name: "index") int? index,@JsonKey(name: "season") String? season,@JsonKey(name: "episode") String? episode,@JsonKey(name: "episodeType") String? episodeType,@JsonKey(name: "title") String? title,@JsonKey(name: "subtitle") String? subtitle,@JsonKey(name: "description") String? description,@JsonKey(name: "pubDate") String? pubDate,@JsonKey(name: "audioFile") AudioFile? audioFile,@JsonKey(name: "publishedAt") int? publishedAt,@JsonKey(name: "addedAt") int? addedAt,@JsonKey(name: "updatedAt") int? updatedAt
});


$AudioFileCopyWith<$Res>? get audioFile;

}
/// @nodoc
class _$EpisodeCopyWithImpl<$Res>
    implements $EpisodeCopyWith<$Res> {
  _$EpisodeCopyWithImpl(this._self, this._then);

  final Episode _self;
  final $Res Function(Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItemId = null,Object? id = null,Object? index = freezed,Object? season = freezed,Object? episode = freezed,Object? episodeType = freezed,Object? title = freezed,Object? subtitle = freezed,Object? description = freezed,Object? pubDate = freezed,Object? audioFile = freezed,Object? publishedAt = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,}) {
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
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
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
$AudioFileCopyWith<$Res>? get audioFile {
    if (_self.audioFile == null) {
    return null;
  }

  return $AudioFileCopyWith<$Res>(_self.audioFile!, (value) {
    return _then(_self.copyWith(audioFile: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Episode implements Episode {
  const _Episode({@JsonKey(name: "libraryItemId") required this.libraryItemId, @JsonKey(name: "id") required this.id, @JsonKey(name: "index") this.index, @JsonKey(name: "season") this.season, @JsonKey(name: "episode") this.episode, @JsonKey(name: "episodeType") this.episodeType, @JsonKey(name: "title") this.title, @JsonKey(name: "subtitle") this.subtitle, @JsonKey(name: "description") this.description, @JsonKey(name: "pubDate") this.pubDate, @JsonKey(name: "audioFile") this.audioFile, @JsonKey(name: "publishedAt") this.publishedAt, @JsonKey(name: "addedAt") this.addedAt, @JsonKey(name: "updatedAt") this.updatedAt});
  factory _Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);

@override@JsonKey(name: "libraryItemId") final  String libraryItemId;
@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "index") final  int? index;
@override@JsonKey(name: "season") final  String? season;
@override@JsonKey(name: "episode") final  String? episode;
@override@JsonKey(name: "episodeType") final  String? episodeType;
@override@JsonKey(name: "title") final  String? title;
@override@JsonKey(name: "subtitle") final  String? subtitle;
@override@JsonKey(name: "description") final  String? description;
//TODO: PodcastEnclosure
@override@JsonKey(name: "pubDate") final  String? pubDate;
@override@JsonKey(name: "audioFile") final  AudioFile? audioFile;
@override@JsonKey(name: "publishedAt") final  int? publishedAt;
@override@JsonKey(name: "addedAt") final  int? addedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Episode&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.id, id) || other.id == id)&&(identical(other.index, index) || other.index == index)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.audioFile, audioFile) || other.audioFile == audioFile)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItemId,id,index,season,episode,episodeType,title,subtitle,description,pubDate,audioFile,publishedAt,addedAt,updatedAt);

@override
String toString() {
  return 'Episode(libraryItemId: $libraryItemId, id: $id, index: $index, season: $season, episode: $episode, episodeType: $episodeType, title: $title, subtitle: $subtitle, description: $description, pubDate: $pubDate, audioFile: $audioFile, publishedAt: $publishedAt, addedAt: $addedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EpisodeCopyWith<$Res> implements $EpisodeCopyWith<$Res> {
  factory _$EpisodeCopyWith(_Episode value, $Res Function(_Episode) _then) = __$EpisodeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "id") String id,@JsonKey(name: "index") int? index,@JsonKey(name: "season") String? season,@JsonKey(name: "episode") String? episode,@JsonKey(name: "episodeType") String? episodeType,@JsonKey(name: "title") String? title,@JsonKey(name: "subtitle") String? subtitle,@JsonKey(name: "description") String? description,@JsonKey(name: "pubDate") String? pubDate,@JsonKey(name: "audioFile") AudioFile? audioFile,@JsonKey(name: "publishedAt") int? publishedAt,@JsonKey(name: "addedAt") int? addedAt,@JsonKey(name: "updatedAt") int? updatedAt
});


@override $AudioFileCopyWith<$Res>? get audioFile;

}
/// @nodoc
class __$EpisodeCopyWithImpl<$Res>
    implements _$EpisodeCopyWith<$Res> {
  __$EpisodeCopyWithImpl(this._self, this._then);

  final _Episode _self;
  final $Res Function(_Episode) _then;

/// Create a copy of Episode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItemId = null,Object? id = null,Object? index = freezed,Object? season = freezed,Object? episode = freezed,Object? episodeType = freezed,Object? title = freezed,Object? subtitle = freezed,Object? description = freezed,Object? pubDate = freezed,Object? audioFile = freezed,Object? publishedAt = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,}) {
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
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
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
