// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'internal_media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InternalMedia {

@JsonKey(name: "libraryId") String get libraryId;@JsonKey(name: "libraryId") set libraryId(String value);@JsonKey(name: "itemId") String get itemId;@JsonKey(name: "itemId") set itemId(String value);@JsonKey(name: "episodeId") String? get episodeId;@JsonKey(name: "episodeId") set episodeId(String? value);@JsonKey(name: "title") String get title;@JsonKey(name: "title") set title(String value);@JsonKey(name: "author") String? get author;@JsonKey(name: "author") set author(String? value);@JsonKey(name: "series") String? get series;@JsonKey(name: "series") set series(String? value);@JsonKey(name: "seriesPosition") String? get seriesPosition;@JsonKey(name: "seriesPosition") set seriesPosition(String? value);@JsonKey(name: "cover") Uri get cover;@JsonKey(name: "cover") set cover(Uri value);@JsonKey(name: "tracks") List<InternalTrack> get tracks;@JsonKey(name: "tracks") set tracks(List<InternalTrack> value);@JsonKey(name: "chapters") List<InternalChapter>? get chapters;@JsonKey(name: "chapters") set chapters(List<InternalChapter>? value);// Removed incorrect defaultValue: false
@JsonKey(name: "duration") double? get duration;// Removed incorrect defaultValue: false
@JsonKey(name: "duration") set duration(double? value);@JsonKey(name: "local", defaultValue: false) bool get local;@JsonKey(name: "local", defaultValue: false) set local(bool value);// SAF is for Android only
@JsonKey(name: "saf") bool get saf;// SAF is for Android only
@JsonKey(name: "saf") set saf(bool value);
/// Create a copy of InternalMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalMediaCopyWith<InternalMedia> get copyWith => _$InternalMediaCopyWithImpl<InternalMedia>(this as InternalMedia, _$identity);

  /// Serializes this InternalMedia to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'InternalMedia(libraryId: $libraryId, itemId: $itemId, episodeId: $episodeId, title: $title, author: $author, series: $series, seriesPosition: $seriesPosition, cover: $cover, tracks: $tracks, chapters: $chapters, duration: $duration, local: $local, saf: $saf)';
}


}

/// @nodoc
abstract mixin class $InternalMediaCopyWith<$Res>  {
  factory $InternalMediaCopyWith(InternalMedia value, $Res Function(InternalMedia) _then) = _$InternalMediaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "itemId") String itemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "title") String title,@JsonKey(name: "author") String? author,@JsonKey(name: "series") String? series,@JsonKey(name: "seriesPosition") String? seriesPosition,@JsonKey(name: "cover") Uri cover,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "chapters") List<InternalChapter>? chapters,@JsonKey(name: "duration") double? duration,@JsonKey(name: "local", defaultValue: false) bool local,@JsonKey(name: "saf") bool saf
});




}
/// @nodoc
class _$InternalMediaCopyWithImpl<$Res>
    implements $InternalMediaCopyWith<$Res> {
  _$InternalMediaCopyWithImpl(this._self, this._then);

  final InternalMedia _self;
  final $Res Function(InternalMedia) _then;

/// Create a copy of InternalMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryId = null,Object? itemId = null,Object? episodeId = freezed,Object? title = null,Object? author = freezed,Object? series = freezed,Object? seriesPosition = freezed,Object? cover = null,Object? tracks = null,Object? chapters = freezed,Object? duration = freezed,Object? local = null,Object? saf = null,}) {
  return _then(_self.copyWith(
libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,seriesPosition: freezed == seriesPosition ? _self.seriesPosition : seriesPosition // ignore: cast_nullable_to_non_nullable
as String?,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as Uri,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,chapters: freezed == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<InternalChapter>?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,local: null == local ? _self.local : local // ignore: cast_nullable_to_non_nullable
as bool,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _InternalMedia extends InternalMedia {
   _InternalMedia({@JsonKey(name: "libraryId") required this.libraryId, @JsonKey(name: "itemId") required this.itemId, @JsonKey(name: "episodeId") required this.episodeId, @JsonKey(name: "title") required this.title, @JsonKey(name: "author") this.author, @JsonKey(name: "series") this.series, @JsonKey(name: "seriesPosition") this.seriesPosition, @JsonKey(name: "cover") required this.cover, @JsonKey(name: "tracks") required this.tracks, @JsonKey(name: "chapters") this.chapters, @JsonKey(name: "duration") this.duration, @JsonKey(name: "local", defaultValue: false) required this.local, @JsonKey(name: "saf") required this.saf}): super._();
  factory _InternalMedia.fromJson(Map<String, dynamic> json) => _$InternalMediaFromJson(json);

@override@JsonKey(name: "libraryId")  String libraryId;
@override@JsonKey(name: "itemId")  String itemId;
@override@JsonKey(name: "episodeId")  String? episodeId;
@override@JsonKey(name: "title")  String title;
@override@JsonKey(name: "author")  String? author;
@override@JsonKey(name: "series")  String? series;
@override@JsonKey(name: "seriesPosition")  String? seriesPosition;
@override@JsonKey(name: "cover")  Uri cover;
@override@JsonKey(name: "tracks")  List<InternalTrack> tracks;
@override@JsonKey(name: "chapters")  List<InternalChapter>? chapters;
// Removed incorrect defaultValue: false
@override@JsonKey(name: "duration")  double? duration;
@override@JsonKey(name: "local", defaultValue: false)  bool local;
// SAF is for Android only
@override@JsonKey(name: "saf")  bool saf;

/// Create a copy of InternalMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternalMediaCopyWith<_InternalMedia> get copyWith => __$InternalMediaCopyWithImpl<_InternalMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternalMediaToJson(this, );
}



@override
String toString() {
  return 'InternalMedia(libraryId: $libraryId, itemId: $itemId, episodeId: $episodeId, title: $title, author: $author, series: $series, seriesPosition: $seriesPosition, cover: $cover, tracks: $tracks, chapters: $chapters, duration: $duration, local: $local, saf: $saf)';
}


}

/// @nodoc
abstract mixin class _$InternalMediaCopyWith<$Res> implements $InternalMediaCopyWith<$Res> {
  factory _$InternalMediaCopyWith(_InternalMedia value, $Res Function(_InternalMedia) _then) = __$InternalMediaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "itemId") String itemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "title") String title,@JsonKey(name: "author") String? author,@JsonKey(name: "series") String? series,@JsonKey(name: "seriesPosition") String? seriesPosition,@JsonKey(name: "cover") Uri cover,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "chapters") List<InternalChapter>? chapters,@JsonKey(name: "duration") double? duration,@JsonKey(name: "local", defaultValue: false) bool local,@JsonKey(name: "saf") bool saf
});




}
/// @nodoc
class __$InternalMediaCopyWithImpl<$Res>
    implements _$InternalMediaCopyWith<$Res> {
  __$InternalMediaCopyWithImpl(this._self, this._then);

  final _InternalMedia _self;
  final $Res Function(_InternalMedia) _then;

/// Create a copy of InternalMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryId = null,Object? itemId = null,Object? episodeId = freezed,Object? title = null,Object? author = freezed,Object? series = freezed,Object? seriesPosition = freezed,Object? cover = null,Object? tracks = null,Object? chapters = freezed,Object? duration = freezed,Object? local = null,Object? saf = null,}) {
  return _then(_InternalMedia(
libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as String?,seriesPosition: freezed == seriesPosition ? _self.seriesPosition : seriesPosition // ignore: cast_nullable_to_non_nullable
as String?,cover: null == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as Uri,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,chapters: freezed == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<InternalChapter>?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,local: null == local ? _self.local : local // ignore: cast_nullable_to_non_nullable
as bool,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$InternalTrack {

@JsonKey(name: "index") int get index;@JsonKey(name: "duration") double get duration;@JsonKey(name: "url") String get url;@JsonKey(name: "start") double? get start;@JsonKey(name: "end") double? get end;
/// Create a copy of InternalTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalTrackCopyWith<InternalTrack> get copyWith => _$InternalTrackCopyWithImpl<InternalTrack>(this as InternalTrack, _$identity);

  /// Serializes this InternalTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalTrack&&(identical(other.index, index) || other.index == index)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.url, url) || other.url == url)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,duration,url,start,end);

@override
String toString() {
  return 'InternalTrack(index: $index, duration: $duration, url: $url, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $InternalTrackCopyWith<$Res>  {
  factory $InternalTrackCopyWith(InternalTrack value, $Res Function(InternalTrack) _then) = _$InternalTrackCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "index") int index,@JsonKey(name: "duration") double duration,@JsonKey(name: "url") String url,@JsonKey(name: "start") double? start,@JsonKey(name: "end") double? end
});




}
/// @nodoc
class _$InternalTrackCopyWithImpl<$Res>
    implements $InternalTrackCopyWith<$Res> {
  _$InternalTrackCopyWithImpl(this._self, this._then);

  final InternalTrack _self;
  final $Res Function(InternalTrack) _then;

/// Create a copy of InternalTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? duration = null,Object? url = null,Object? start = freezed,Object? end = freezed,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _InternalTrack implements InternalTrack {
  const _InternalTrack({@JsonKey(name: "index") required this.index, @JsonKey(name: "duration") required this.duration, @JsonKey(name: "url") required this.url, @JsonKey(name: "start") this.start, @JsonKey(name: "end") this.end});
  factory _InternalTrack.fromJson(Map<String, dynamic> json) => _$InternalTrackFromJson(json);

@override@JsonKey(name: "index") final  int index;
@override@JsonKey(name: "duration") final  double duration;
@override@JsonKey(name: "url") final  String url;
@override@JsonKey(name: "start") final  double? start;
@override@JsonKey(name: "end") final  double? end;

/// Create a copy of InternalTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternalTrackCopyWith<_InternalTrack> get copyWith => __$InternalTrackCopyWithImpl<_InternalTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternalTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalTrack&&(identical(other.index, index) || other.index == index)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.url, url) || other.url == url)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,duration,url,start,end);

@override
String toString() {
  return 'InternalTrack(index: $index, duration: $duration, url: $url, start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$InternalTrackCopyWith<$Res> implements $InternalTrackCopyWith<$Res> {
  factory _$InternalTrackCopyWith(_InternalTrack value, $Res Function(_InternalTrack) _then) = __$InternalTrackCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "index") int index,@JsonKey(name: "duration") double duration,@JsonKey(name: "url") String url,@JsonKey(name: "start") double? start,@JsonKey(name: "end") double? end
});




}
/// @nodoc
class __$InternalTrackCopyWithImpl<$Res>
    implements _$InternalTrackCopyWith<$Res> {
  __$InternalTrackCopyWithImpl(this._self, this._then);

  final _InternalTrack _self;
  final $Res Function(_InternalTrack) _then;

/// Create a copy of InternalTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? duration = null,Object? url = null,Object? start = freezed,Object? end = freezed,}) {
  return _then(_InternalTrack(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$InternalChapter {

@JsonKey(name: "start") double get start;@JsonKey(name: "end") double get end;@JsonKey(name: "title") String get title;
/// Create a copy of InternalChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalChapterCopyWith<InternalChapter> get copyWith => _$InternalChapterCopyWithImpl<InternalChapter>(this as InternalChapter, _$identity);

  /// Serializes this InternalChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalChapter&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,title);

@override
String toString() {
  return 'InternalChapter(start: $start, end: $end, title: $title)';
}


}

/// @nodoc
abstract mixin class $InternalChapterCopyWith<$Res>  {
  factory $InternalChapterCopyWith(InternalChapter value, $Res Function(InternalChapter) _then) = _$InternalChapterCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "start") double start,@JsonKey(name: "end") double end,@JsonKey(name: "title") String title
});




}
/// @nodoc
class _$InternalChapterCopyWithImpl<$Res>
    implements $InternalChapterCopyWith<$Res> {
  _$InternalChapterCopyWithImpl(this._self, this._then);

  final InternalChapter _self;
  final $Res Function(InternalChapter) _then;

/// Create a copy of InternalChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? title = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _InternalChapter implements InternalChapter {
  const _InternalChapter({@JsonKey(name: "start") required this.start, @JsonKey(name: "end") required this.end, @JsonKey(name: "title") required this.title});
  factory _InternalChapter.fromJson(Map<String, dynamic> json) => _$InternalChapterFromJson(json);

@override@JsonKey(name: "start") final  double start;
@override@JsonKey(name: "end") final  double end;
@override@JsonKey(name: "title") final  String title;

/// Create a copy of InternalChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternalChapterCopyWith<_InternalChapter> get copyWith => __$InternalChapterCopyWithImpl<_InternalChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternalChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalChapter&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,title);

@override
String toString() {
  return 'InternalChapter(start: $start, end: $end, title: $title)';
}


}

/// @nodoc
abstract mixin class _$InternalChapterCopyWith<$Res> implements $InternalChapterCopyWith<$Res> {
  factory _$InternalChapterCopyWith(_InternalChapter value, $Res Function(_InternalChapter) _then) = __$InternalChapterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "start") double start,@JsonKey(name: "end") double end,@JsonKey(name: "title") String title
});




}
/// @nodoc
class __$InternalChapterCopyWithImpl<$Res>
    implements _$InternalChapterCopyWith<$Res> {
  __$InternalChapterCopyWithImpl(this._self, this._then);

  final _InternalChapter _self;
  final $Res Function(_InternalChapter) _then;

/// Create a copy of InternalChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? title = null,}) {
  return _then(_InternalChapter(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
