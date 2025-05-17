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

@JsonKey(name: "libraryId") String get libraryId;@JsonKey(name: "libraryId") set libraryId(String value);@JsonKey(name: "itemId") String get itemId;@JsonKey(name: "itemId") set itemId(String value);@JsonKey(name: "episodeId") String? get episodeId;@JsonKey(name: "episodeId") set episodeId(String? value);@JsonKey(name: "tracks") List<InternalTrack> get tracks;@JsonKey(name: "tracks") set tracks(List<InternalTrack> value);
/// Create a copy of InternalMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalMediaCopyWith<InternalMedia> get copyWith => _$InternalMediaCopyWithImpl<InternalMedia>(this as InternalMedia, _$identity);

  /// Serializes this InternalMedia to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'InternalMedia(libraryId: $libraryId, itemId: $itemId, episodeId: $episodeId, tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class $InternalMediaCopyWith<$Res>  {
  factory $InternalMediaCopyWith(InternalMedia value, $Res Function(InternalMedia) _then) = _$InternalMediaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "itemId") String itemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "tracks") List<InternalTrack> tracks
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
@pragma('vm:prefer-inline') @override $Res call({Object? libraryId = null,Object? itemId = null,Object? episodeId = freezed,Object? tracks = null,}) {
  return _then(_self.copyWith(
libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _InternalMedia implements InternalMedia {
  const _InternalMedia({@JsonKey(name: "libraryId") required this.libraryId, @JsonKey(name: "itemId") required this.itemId, @JsonKey(name: "episodeId") required this.episodeId, @JsonKey(name: "tracks") required this.tracks});
  factory _InternalMedia.fromJson(Map<String, dynamic> json) => _$InternalMediaFromJson(json);

@override@JsonKey(name: "libraryId")  String libraryId;
@override@JsonKey(name: "itemId")  String itemId;
@override@JsonKey(name: "episodeId")  String? episodeId;
@override@JsonKey(name: "tracks")  List<InternalTrack> tracks;

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
  return 'InternalMedia(libraryId: $libraryId, itemId: $itemId, episodeId: $episodeId, tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class _$InternalMediaCopyWith<$Res> implements $InternalMediaCopyWith<$Res> {
  factory _$InternalMediaCopyWith(_InternalMedia value, $Res Function(_InternalMedia) _then) = __$InternalMediaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "itemId") String itemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "tracks") List<InternalTrack> tracks
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
@override @pragma('vm:prefer-inline') $Res call({Object? libraryId = null,Object? itemId = null,Object? episodeId = freezed,Object? tracks = null,}) {
  return _then(_InternalMedia(
libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,
  ));
}


}


/// @nodoc
mixin _$InternalTrack {

@JsonKey(name: "index") int get index;@JsonKey(name: "index") set index(int value);@JsonKey(name: "duration") double get duration;@JsonKey(name: "duration") set duration(double value);@JsonKey(name: "url") String get url;@JsonKey(name: "url") set url(String value);@JsonKey(name: "start") double? get start;@JsonKey(name: "start") set start(double? value);@JsonKey(name: "end") double? get end;@JsonKey(name: "end") set end(double? value);
/// Create a copy of InternalTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalTrackCopyWith<InternalTrack> get copyWith => _$InternalTrackCopyWithImpl<InternalTrack>(this as InternalTrack, _$identity);

  /// Serializes this InternalTrack to a JSON map.
  Map<String, dynamic> toJson();




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

@override@JsonKey(name: "index")  int index;
@override@JsonKey(name: "duration")  double duration;
@override@JsonKey(name: "url")  String url;
@override@JsonKey(name: "start")  double? start;
@override@JsonKey(name: "end")  double? end;

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

// dart format on
