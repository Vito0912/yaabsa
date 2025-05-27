// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'internal_download.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InternalDownload {

@JsonKey(name: "item") LibraryItem? get item;@JsonKey(name: "episode") Episode? get episode;@JsonKey(name: "tracks") List<InternalTrack> get tracks;@JsonKey(name: "saf", defaultValue: false) bool get saf;
/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalDownloadCopyWith<InternalDownload> get copyWith => _$InternalDownloadCopyWithImpl<InternalDownload>(this as InternalDownload, _$identity);

  /// Serializes this InternalDownload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalDownload&&(identical(other.item, item) || other.item == item)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other.tracks, tracks)&&(identical(other.saf, saf) || other.saf == saf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,item,episode,const DeepCollectionEquality().hash(tracks),saf);

@override
String toString() {
  return 'InternalDownload(item: $item, episode: $episode, tracks: $tracks, saf: $saf)';
}


}

/// @nodoc
abstract mixin class $InternalDownloadCopyWith<$Res>  {
  factory $InternalDownloadCopyWith(InternalDownload value, $Res Function(InternalDownload) _then) = _$InternalDownloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "item") LibraryItem? item,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "saf", defaultValue: false) bool saf
});


$LibraryItemCopyWith<$Res>? get item;$EpisodeCopyWith<$Res>? get episode;

}
/// @nodoc
class _$InternalDownloadCopyWithImpl<$Res>
    implements $InternalDownloadCopyWith<$Res> {
  _$InternalDownloadCopyWithImpl(this._self, this._then);

  final InternalDownload _self;
  final $Res Function(InternalDownload) _then;

/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? item = freezed,Object? episode = freezed,Object? tracks = null,Object? saf = null,}) {
  return _then(_self.copyWith(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _InternalDownload extends InternalDownload {
   _InternalDownload({@JsonKey(name: "item") required this.item, @JsonKey(name: "episode") required this.episode, @JsonKey(name: "tracks") required final  List<InternalTrack> tracks, @JsonKey(name: "saf", defaultValue: false) required this.saf}): _tracks = tracks,super._();
  factory _InternalDownload.fromJson(Map<String, dynamic> json) => _$InternalDownloadFromJson(json);

@override@JsonKey(name: "item") final  LibraryItem? item;
@override@JsonKey(name: "episode") final  Episode? episode;
 final  List<InternalTrack> _tracks;
@override@JsonKey(name: "tracks") List<InternalTrack> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}

@override@JsonKey(name: "saf", defaultValue: false) final  bool saf;

/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InternalDownloadCopyWith<_InternalDownload> get copyWith => __$InternalDownloadCopyWithImpl<_InternalDownload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InternalDownloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalDownload&&(identical(other.item, item) || other.item == item)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other._tracks, _tracks)&&(identical(other.saf, saf) || other.saf == saf));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,item,episode,const DeepCollectionEquality().hash(_tracks),saf);

@override
String toString() {
  return 'InternalDownload(item: $item, episode: $episode, tracks: $tracks, saf: $saf)';
}


}

/// @nodoc
abstract mixin class _$InternalDownloadCopyWith<$Res> implements $InternalDownloadCopyWith<$Res> {
  factory _$InternalDownloadCopyWith(_InternalDownload value, $Res Function(_InternalDownload) _then) = __$InternalDownloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "item") LibraryItem? item,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "saf", defaultValue: false) bool saf
});


@override $LibraryItemCopyWith<$Res>? get item;@override $EpisodeCopyWith<$Res>? get episode;

}
/// @nodoc
class __$InternalDownloadCopyWithImpl<$Res>
    implements _$InternalDownloadCopyWith<$Res> {
  __$InternalDownloadCopyWithImpl(this._self, this._then);

  final _InternalDownload _self;
  final $Res Function(_InternalDownload) _then;

/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? item = freezed,Object? episode = freezed,Object? tracks = null,Object? saf = null,}) {
  return _then(_InternalDownload(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}
}

// dart format on
