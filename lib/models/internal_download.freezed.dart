// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'internal_download.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InternalDownload {

@JsonKey(name: "item") LibraryItem? get item;@JsonKey(name: "item") set item(LibraryItem? value);@JsonKey(name: "episode") Episode? get episode;@JsonKey(name: "episode") set episode(Episode? value);@JsonKey(name: "tracks") List<InternalTrack> get tracks;@JsonKey(name: "tracks") set tracks(List<InternalTrack> value);@JsonKey(name: "expectedFileCount") int? get expectedFileCount;@JsonKey(name: "expectedFileCount") set expectedFileCount(int? value);@JsonKey(name: "auxiliaryFilePaths") List<String> get auxiliaryFilePaths;@JsonKey(name: "auxiliaryFilePaths") set auxiliaryFilePaths(List<String> value);@JsonKey(name: "saf", defaultValue: false) bool get saf;@JsonKey(name: "saf", defaultValue: false) set saf(bool value);@JsonKey(name: "coverPath") String? get coverPath;@JsonKey(name: "coverPath") set coverPath(String? value);@JsonKey(name: "sidecarPaths") List<String> get sidecarPaths;@JsonKey(name: "sidecarPaths") set sidecarPaths(List<String> value);@JsonKey(name: "downloadType") String get downloadType;@JsonKey(name: "downloadType") set downloadType(String value);@JsonKey(name: 'downloadBasePath') String? get downloadBasePath;@JsonKey(name: 'downloadBasePath') set downloadBasePath(String? value);@JsonKey(name: 'downloadOrigin') String get downloadOrigin;@JsonKey(name: 'downloadOrigin') set downloadOrigin(String value);@JsonKey(name: 'smartProfileIds') List<String> get smartProfileIds;@JsonKey(name: 'smartProfileIds') set smartProfileIds(List<String> value);@JsonKey(name: 'managedBytes') int? get managedBytes;@JsonKey(name: 'managedBytes') set managedBytes(int? value);@JsonKey(name: 'completedAt') int? get completedAt;@JsonKey(name: 'completedAt') set completedAt(int? value);
/// Create a copy of InternalDownload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InternalDownloadCopyWith<InternalDownload> get copyWith => _$InternalDownloadCopyWithImpl<InternalDownload>(this as InternalDownload, _$identity);

  /// Serializes this InternalDownload to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'InternalDownload(item: $item, episode: $episode, tracks: $tracks, expectedFileCount: $expectedFileCount, auxiliaryFilePaths: $auxiliaryFilePaths, saf: $saf, coverPath: $coverPath, sidecarPaths: $sidecarPaths, downloadType: $downloadType, downloadBasePath: $downloadBasePath, downloadOrigin: $downloadOrigin, smartProfileIds: $smartProfileIds, managedBytes: $managedBytes, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $InternalDownloadCopyWith<$Res>  {
  factory $InternalDownloadCopyWith(InternalDownload value, $Res Function(InternalDownload) _then) = _$InternalDownloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "item") LibraryItem? item,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "expectedFileCount") int? expectedFileCount,@JsonKey(name: "auxiliaryFilePaths") List<String> auxiliaryFilePaths,@JsonKey(name: "saf", defaultValue: false) bool saf,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "sidecarPaths") List<String> sidecarPaths,@JsonKey(name: "downloadType") String downloadType,@JsonKey(name: 'downloadBasePath') String? downloadBasePath,@JsonKey(name: 'downloadOrigin') String downloadOrigin,@JsonKey(name: 'smartProfileIds') List<String> smartProfileIds,@JsonKey(name: 'managedBytes') int? managedBytes,@JsonKey(name: 'completedAt') int? completedAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? item = freezed,Object? episode = freezed,Object? tracks = null,Object? expectedFileCount = freezed,Object? auxiliaryFilePaths = null,Object? saf = null,Object? coverPath = freezed,Object? sidecarPaths = null,Object? downloadType = null,Object? downloadBasePath = freezed,Object? downloadOrigin = null,Object? smartProfileIds = null,Object? managedBytes = freezed,Object? completedAt = freezed,}) {
  return _then(InternalDownload(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,expectedFileCount: freezed == expectedFileCount ? _self.expectedFileCount : expectedFileCount // ignore: cast_nullable_to_non_nullable
as int?,auxiliaryFilePaths: null == auxiliaryFilePaths ? _self.auxiliaryFilePaths : auxiliaryFilePaths // ignore: cast_nullable_to_non_nullable
as List<String>,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,sidecarPaths: null == sidecarPaths ? _self.sidecarPaths : sidecarPaths // ignore: cast_nullable_to_non_nullable
as List<String>,downloadType: null == downloadType ? _self.downloadType : downloadType // ignore: cast_nullable_to_non_nullable
as String,downloadBasePath: freezed == downloadBasePath ? _self.downloadBasePath : downloadBasePath // ignore: cast_nullable_to_non_nullable
as String?,downloadOrigin: null == downloadOrigin ? _self.downloadOrigin : downloadOrigin // ignore: cast_nullable_to_non_nullable
as String,smartProfileIds: null == smartProfileIds ? _self.smartProfileIds : smartProfileIds // ignore: cast_nullable_to_non_nullable
as List<String>,managedBytes: freezed == managedBytes ? _self.managedBytes : managedBytes // ignore: cast_nullable_to_non_nullable
as int?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "item")  LibraryItem? item, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "tracks")  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount")  int? expectedFileCount, @JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths, @JsonKey(name: "saf", defaultValue: false)  bool saf, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "sidecarPaths")  List<String> sidecarPaths, @JsonKey(name: "downloadType")  String downloadType, @JsonKey(name: 'downloadBasePath')  String? downloadBasePath, @JsonKey(name: 'downloadOrigin')  String downloadOrigin, @JsonKey(name: 'smartProfileIds')  List<String> smartProfileIds, @JsonKey(name: 'managedBytes')  int? managedBytes, @JsonKey(name: 'completedAt')  int? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InternalDownload() when $default != null:
return $default(_that.item,_that.episode,_that.tracks,_that.expectedFileCount,_that.auxiliaryFilePaths,_that.saf,_that.coverPath,_that.sidecarPaths,_that.downloadType,_that.downloadBasePath,_that.downloadOrigin,_that.smartProfileIds,_that.managedBytes,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "item")  LibraryItem? item, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "tracks")  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount")  int? expectedFileCount, @JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths, @JsonKey(name: "saf", defaultValue: false)  bool saf, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "sidecarPaths")  List<String> sidecarPaths, @JsonKey(name: "downloadType")  String downloadType, @JsonKey(name: 'downloadBasePath')  String? downloadBasePath, @JsonKey(name: 'downloadOrigin')  String downloadOrigin, @JsonKey(name: 'smartProfileIds')  List<String> smartProfileIds, @JsonKey(name: 'managedBytes')  int? managedBytes, @JsonKey(name: 'completedAt')  int? completedAt)  $default,) {final _that = this;
switch (_that) {
case _InternalDownload():
return $default(_that.item,_that.episode,_that.tracks,_that.expectedFileCount,_that.auxiliaryFilePaths,_that.saf,_that.coverPath,_that.sidecarPaths,_that.downloadType,_that.downloadBasePath,_that.downloadOrigin,_that.smartProfileIds,_that.managedBytes,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "item")  LibraryItem? item, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "tracks")  List<InternalTrack> tracks, @JsonKey(name: "expectedFileCount")  int? expectedFileCount, @JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths, @JsonKey(name: "saf", defaultValue: false)  bool saf, @JsonKey(name: "coverPath")  String? coverPath, @JsonKey(name: "sidecarPaths")  List<String> sidecarPaths, @JsonKey(name: "downloadType")  String downloadType, @JsonKey(name: 'downloadBasePath')  String? downloadBasePath, @JsonKey(name: 'downloadOrigin')  String downloadOrigin, @JsonKey(name: 'smartProfileIds')  List<String> smartProfileIds, @JsonKey(name: 'managedBytes')  int? managedBytes, @JsonKey(name: 'completedAt')  int? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _InternalDownload() when $default != null:
return $default(_that.item,_that.episode,_that.tracks,_that.expectedFileCount,_that.auxiliaryFilePaths,_that.saf,_that.coverPath,_that.sidecarPaths,_that.downloadType,_that.downloadBasePath,_that.downloadOrigin,_that.smartProfileIds,_that.managedBytes,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InternalDownload extends InternalDownload {
   _InternalDownload({@JsonKey(name: "item") required this.item, @JsonKey(name: "episode") required this.episode, @JsonKey(name: "tracks") required this.tracks, @JsonKey(name: "expectedFileCount") this.expectedFileCount, @JsonKey(name: "auxiliaryFilePaths") this.auxiliaryFilePaths = const <String>[], @JsonKey(name: "saf", defaultValue: false) required this.saf, @JsonKey(name: "coverPath") this.coverPath, @JsonKey(name: "sidecarPaths") this.sidecarPaths = const <String>[], @JsonKey(name: "downloadType") this.downloadType = 'both', @JsonKey(name: 'downloadBasePath') this.downloadBasePath, @JsonKey(name: 'downloadOrigin') this.downloadOrigin = 'manual', @JsonKey(name: 'smartProfileIds') this.smartProfileIds = const <String>[], @JsonKey(name: 'managedBytes') this.managedBytes, @JsonKey(name: 'completedAt') this.completedAt}): super._();
  factory _InternalDownload.fromJson(Map<String, dynamic> json) => _$InternalDownloadFromJson(json);

@override@JsonKey(name: "item")  LibraryItem? item;
@override@JsonKey(name: "episode")  Episode? episode;
@override@JsonKey(name: "tracks")  List<InternalTrack> tracks;
@override@JsonKey(name: "expectedFileCount")  int? expectedFileCount;
@override@JsonKey(name: "auxiliaryFilePaths")  List<String> auxiliaryFilePaths;
@override@JsonKey(name: "saf", defaultValue: false)  bool saf;
@override@JsonKey(name: "coverPath")  String? coverPath;
@override@JsonKey(name: "sidecarPaths")  List<String> sidecarPaths;
@override@JsonKey(name: "downloadType")  String downloadType;
@override@JsonKey(name: 'downloadBasePath')  String? downloadBasePath;
@override@JsonKey(name: 'downloadOrigin')  String downloadOrigin;
@override@JsonKey(name: 'smartProfileIds')  List<String> smartProfileIds;
@override@JsonKey(name: 'managedBytes')  int? managedBytes;
@override@JsonKey(name: 'completedAt')  int? completedAt;

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
String toString() {
  return 'InternalDownload(item: $item, episode: $episode, tracks: $tracks, expectedFileCount: $expectedFileCount, auxiliaryFilePaths: $auxiliaryFilePaths, saf: $saf, coverPath: $coverPath, sidecarPaths: $sidecarPaths, downloadType: $downloadType, downloadBasePath: $downloadBasePath, downloadOrigin: $downloadOrigin, smartProfileIds: $smartProfileIds, managedBytes: $managedBytes, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$InternalDownloadCopyWith<$Res> implements $InternalDownloadCopyWith<$Res> {
  factory _$InternalDownloadCopyWith(_InternalDownload value, $Res Function(_InternalDownload) _then) = __$InternalDownloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "item") LibraryItem? item,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "tracks") List<InternalTrack> tracks,@JsonKey(name: "expectedFileCount") int? expectedFileCount,@JsonKey(name: "auxiliaryFilePaths") List<String> auxiliaryFilePaths,@JsonKey(name: "saf", defaultValue: false) bool saf,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "sidecarPaths") List<String> sidecarPaths,@JsonKey(name: "downloadType") String downloadType,@JsonKey(name: 'downloadBasePath') String? downloadBasePath,@JsonKey(name: 'downloadOrigin') String downloadOrigin,@JsonKey(name: 'smartProfileIds') List<String> smartProfileIds,@JsonKey(name: 'managedBytes') int? managedBytes,@JsonKey(name: 'completedAt') int? completedAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? item = freezed,Object? episode = freezed,Object? tracks = null,Object? expectedFileCount = freezed,Object? auxiliaryFilePaths = null,Object? saf = null,Object? coverPath = freezed,Object? sidecarPaths = null,Object? downloadType = null,Object? downloadBasePath = freezed,Object? downloadOrigin = null,Object? smartProfileIds = null,Object? managedBytes = freezed,Object? completedAt = freezed,}) {
  return _then(_InternalDownload(
item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<InternalTrack>,expectedFileCount: freezed == expectedFileCount ? _self.expectedFileCount : expectedFileCount // ignore: cast_nullable_to_non_nullable
as int?,auxiliaryFilePaths: null == auxiliaryFilePaths ? _self.auxiliaryFilePaths : auxiliaryFilePaths // ignore: cast_nullable_to_non_nullable
as List<String>,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,sidecarPaths: null == sidecarPaths ? _self.sidecarPaths : sidecarPaths // ignore: cast_nullable_to_non_nullable
as List<String>,downloadType: null == downloadType ? _self.downloadType : downloadType // ignore: cast_nullable_to_non_nullable
as String,downloadBasePath: freezed == downloadBasePath ? _self.downloadBasePath : downloadBasePath // ignore: cast_nullable_to_non_nullable
as String?,downloadOrigin: null == downloadOrigin ? _self.downloadOrigin : downloadOrigin // ignore: cast_nullable_to_non_nullable
as String,smartProfileIds: null == smartProfileIds ? _self.smartProfileIds : smartProfileIds // ignore: cast_nullable_to_non_nullable
as List<String>,managedBytes: freezed == managedBytes ? _self.managedBytes : managedBytes // ignore: cast_nullable_to_non_nullable
as int?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as int?,
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
