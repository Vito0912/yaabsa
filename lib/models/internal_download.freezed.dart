// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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

@JsonKey(name: "item") LibraryItem? get item;@JsonKey(name: "episode") Episode? get episode;@JsonKey(name: "tracks") List<InternalTrack> get tracks;@JsonKey(name: "expectedFileCount") int? get expectedFileCount;@JsonKey(name: "auxiliaryFilePaths") List<String> get auxiliaryFilePaths;@JsonKey(name: "saf", defaultValue: false) bool get saf;@JsonKey(name: "coverPath") String? get coverPath;@JsonKey(name: "sidecarPaths") List<String> get sidecarPaths;
/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalDownloadCopyWith<InternalDownload> get copyWith => _$InternalDownloadCopyWithImpl<InternalDownload>(this as InternalDownload, _$identity);

  /// Serializes this InternalDownload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalDownload&&(identical(other.item, item) || other.item == item)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other.tracks, tracks)&&(identical(other.expectedFileCount, expectedFileCount) || other.expectedFileCount == expectedFileCount)&&const DeepCollectionEquality().equals(other.auxiliaryFilePaths, auxiliaryFilePaths)&&(identical(other.saf, saf) || other.saf == saf)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.sidecarPaths, sidecarPaths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,item,episode,const DeepCollectionEquality().hash(tracks),expectedFileCount,const DeepCollectionEquality().hash(auxiliaryFilePaths),saf,coverPath,const DeepCollectionEquality().hash(sidecarPaths));

@override
String toString() {
  return 'InternalDownload(item: $item, episode: $episode, tracks: $tracks, expectedFileCount: $expectedFileCount, auxiliaryFilePaths: $auxiliaryFilePaths, saf: $saf, coverPath: $coverPath, sidecarPaths: $sidecarPaths)';
}


}

/// @nodoc
abstract mixin class $InternalDownloadCopyWith<$Res>  {
  factory $InternalDownloadCopyWith(InternalDownload value, $Res Function(InternalDownload) _then) = _$InternalDownloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "item") LibraryItem? item,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "expectedFileCount") int? expectedFileCount,@JsonKey(name: "auxiliaryFilePaths") List<String> auxiliaryFilePaths,@JsonKey(name: "saf", defaultValue: false) bool saf,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "sidecarPaths") List<String> sidecarPaths
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
@pragma('vm:prefer-inline') @override $Res call({Object? item = freezed,Object? episode = freezed,Object? tracks = null,Object? expectedFileCount = freezed,Object? auxiliaryFilePaths = null,Object? saf = null,Object? coverPath = freezed,Object? sidecarPaths = null,}) {
  return _then(_self.copyWith(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,expectedFileCount: freezed == expectedFileCount ? _self.expectedFileCount : expectedFileCount // ignore: cast_nullable_to_non_nullable
as int?,auxiliaryFilePaths: null == auxiliaryFilePaths ? _self.auxiliaryFilePaths : auxiliaryFilePaths // ignore: cast_nullable_to_non_nullable
as List<String>,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,sidecarPaths: null == sidecarPaths ? _self.sidecarPaths : sidecarPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
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


/// Adds pattern-matching-related methods to [InternalDownload].
extension InternalDownloadPatterns on InternalDownload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InternalDownload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InternalDownload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InternalDownload value)  $default,){
final _that = this;
switch (_that) {
case _InternalDownload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InternalDownload value)?  $default,){
final _that = this;
switch (_that) {
case _InternalDownload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "item")  LibraryItem? item, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "tracks")  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount")  int? expectedFileCount, @JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths, @JsonKey(name: "saf", defaultValue: false)  bool saf, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "sidecarPaths")  List<String> sidecarPaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InternalDownload() when $default != null:
return $default(_that.item,_that.episode,_that.tracks,_that.expectedFileCount,_that.auxiliaryFilePaths,_that.saf,_that.coverPath,_that.sidecarPaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "item")  LibraryItem? item, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "tracks")  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount")  int? expectedFileCount, @JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths, @JsonKey(name: "saf", defaultValue: false)  bool saf, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "sidecarPaths")  List<String> sidecarPaths)  $default,) {final _that = this;
switch (_that) {
case _InternalDownload():
return $default(_that.item,_that.episode,_that.tracks,_that.expectedFileCount,_that.auxiliaryFilePaths,_that.saf,_that.coverPath,_that.sidecarPaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "item")  LibraryItem? item, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "tracks")  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount")  int? expectedFileCount, @JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths, @JsonKey(name: "saf", defaultValue: false)  bool saf, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "sidecarPaths")  List<String> sidecarPaths)?  $default,) {final _that = this;
switch (_that) {
case _InternalDownload() when $default != null:
return $default(_that.item,_that.episode,_that.tracks,_that.expectedFileCount,_that.auxiliaryFilePaths,_that.saf,_that.coverPath,_that.sidecarPaths);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InternalDownload extends InternalDownload {
   _InternalDownload({@JsonKey(name: "item") required this.item, @JsonKey(name: "episode") required this.episode, @JsonKey(name: "tracks") required final  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount") this.expectedFileCount, @JsonKey(name: "auxiliaryFilePaths") final  List<String> auxiliaryFilePaths = const <String>[], @JsonKey(name: "saf", defaultValue: false) required this.saf, @JsonKey(name: "coverPath") this.coverPath, @JsonKey(name: "sidecarPaths") final  List<String> sidecarPaths = const <String>[]}): _tracks = tracks,_auxiliaryFilePaths = auxiliaryFilePaths,_sidecarPaths = sidecarPaths,super._();
  factory _InternalDownload.fromJson(Map<String, dynamic> json) => _$InternalDownloadFromJson(json);

@override@JsonKey(name: "item") final  LibraryItem? item;
@override@JsonKey(name: "episode") final  Episode? episode;
 final  List<InternalTrack> _tracks;
@override@JsonKey(name: "tracks") List<InternalTrack> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}

@override@JsonKey(name: "expectedFileCount") final  int? expectedFileCount;
 final  List<String> _auxiliaryFilePaths;
@override@JsonKey(name: "auxiliaryFilePaths") List<String> get auxiliaryFilePaths {
  if (_auxiliaryFilePaths is EqualUnmodifiableListView) return _auxiliaryFilePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_auxiliaryFilePaths);
}

@override@JsonKey(name: "saf", defaultValue: false) final  bool saf;
@override@JsonKey(name: "coverPath") final  String? coverPath;
 final  List<String> _sidecarPaths;
@override@JsonKey(name: "sidecarPaths") List<String> get sidecarPaths {
  if (_sidecarPaths is EqualUnmodifiableListView) return _sidecarPaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sidecarPaths);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InternalDownload&&(identical(other.item, item) || other.item == item)&&(identical(other.episode, episode) || other.episode == episode)&&const DeepCollectionEquality().equals(other._tracks, _tracks)&&(identical(other.expectedFileCount, expectedFileCount) || other.expectedFileCount == expectedFileCount)&&const DeepCollectionEquality().equals(other._auxiliaryFilePaths, _auxiliaryFilePaths)&&(identical(other.saf, saf) || other.saf == saf)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other._sidecarPaths, _sidecarPaths));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,item,episode,const DeepCollectionEquality().hash(_tracks),expectedFileCount,const DeepCollectionEquality().hash(_auxiliaryFilePaths),saf,coverPath,const DeepCollectionEquality().hash(_sidecarPaths));

@override
String toString() {
  return 'InternalDownload(item: $item, episode: $episode, tracks: $tracks, expectedFileCount: $expectedFileCount, auxiliaryFilePaths: $auxiliaryFilePaths, saf: $saf, coverPath: $coverPath, sidecarPaths: $sidecarPaths)';
}


}

/// @nodoc
abstract mixin class _$InternalDownloadCopyWith<$Res> implements $InternalDownloadCopyWith<$Res> {
  factory _$InternalDownloadCopyWith(_InternalDownload value, $Res Function(_InternalDownload) _then) = __$InternalDownloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "item") LibraryItem? item,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "expectedFileCount") int? expectedFileCount,@JsonKey(name: "auxiliaryFilePaths") List<String> auxiliaryFilePaths,@JsonKey(name: "saf", defaultValue: false) bool saf,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "sidecarPaths") List<String> sidecarPaths
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
@override @pragma('vm:prefer-inline') $Res call({Object? item = freezed,Object? episode = freezed,Object? tracks = null,Object? expectedFileCount = freezed,Object? auxiliaryFilePaths = null,Object? saf = null,Object? coverPath = freezed,Object? sidecarPaths = null,}) {
  return _then(_InternalDownload(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,expectedFileCount: freezed == expectedFileCount ? _self.expectedFileCount : expectedFileCount // ignore: cast_nullable_to_non_nullable
as int?,auxiliaryFilePaths: null == auxiliaryFilePaths ? _self._auxiliaryFilePaths : auxiliaryFilePaths // ignore: cast_nullable_to_non_nullable
as List<String>,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,sidecarPaths: null == sidecarPaths ? _self._sidecarPaths : sidecarPaths // ignore: cast_nullable_to_non_nullable
as List<String>,
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
