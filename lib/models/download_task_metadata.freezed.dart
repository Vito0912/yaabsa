// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_task_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadTaskMetadata {

 String get itemId; String get userId; String? get episodeId; InternalTrack? get track; int get expectedFileCount; String get fileInode; int get fileIndex; String get fileKind; String? get fileName; String? get fileMimeType; bool get saf; String? get downloadBasePath; String? get libraryId; String? get serverUrl; String? get serverHost; int? get serverPort; bool? get serverSsl; String? get title; String get downloadType;
/// Create a copy of DownloadTaskMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadTaskMetadataCopyWith<DownloadTaskMetadata> get copyWith => _$DownloadTaskMetadataCopyWithImpl<DownloadTaskMetadata>(this as DownloadTaskMetadata, _$identity);

  /// Serializes this DownloadTaskMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadTaskMetadata&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.track, track) || other.track == track)&&(identical(other.expectedFileCount, expectedFileCount) || other.expectedFileCount == expectedFileCount)&&(identical(other.fileInode, fileInode) || other.fileInode == fileInode)&&(identical(other.fileIndex, fileIndex) || other.fileIndex == fileIndex)&&(identical(other.fileKind, fileKind) || other.fileKind == fileKind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileMimeType, fileMimeType) || other.fileMimeType == fileMimeType)&&(identical(other.saf, saf) || other.saf == saf)&&(identical(other.downloadBasePath, downloadBasePath) || other.downloadBasePath == downloadBasePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.serverHost, serverHost) || other.serverHost == serverHost)&&(identical(other.serverPort, serverPort) || other.serverPort == serverPort)&&(identical(other.serverSsl, serverSsl) || other.serverSsl == serverSsl)&&(identical(other.title, title) || other.title == title)&&(identical(other.downloadType, downloadType) || other.downloadType == downloadType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,userId,episodeId,track,expectedFileCount,fileInode,fileIndex,fileKind,fileName,fileMimeType,saf,downloadBasePath,libraryId,serverUrl,serverHost,serverPort,serverSsl,title,downloadType]);

@override
String toString() {
  return 'DownloadTaskMetadata(itemId: $itemId, userId: $userId, episodeId: $episodeId, track: $track, expectedFileCount: $expectedFileCount, fileInode: $fileInode, fileIndex: $fileIndex, fileKind: $fileKind, fileName: $fileName, fileMimeType: $fileMimeType, saf: $saf, downloadBasePath: $downloadBasePath, libraryId: $libraryId, serverUrl: $serverUrl, serverHost: $serverHost, serverPort: $serverPort, serverSsl: $serverSsl, title: $title, downloadType: $downloadType)';
}


}

/// @nodoc
abstract mixin class $DownloadTaskMetadataCopyWith<$Res>  {
  factory $DownloadTaskMetadataCopyWith(DownloadTaskMetadata value, $Res Function(DownloadTaskMetadata) _then) = _$DownloadTaskMetadataCopyWithImpl;
@useResult
$Res call({
 String itemId, String userId, String? episodeId, InternalTrack? track, int expectedFileCount, String fileInode, int fileIndex, String fileKind, String? fileName, String? fileMimeType, bool saf, String? downloadBasePath, String? libraryId, String? serverUrl, String? serverHost, int? serverPort, bool? serverSsl, String? title, String downloadType
});


$InternalTrackCopyWith<$Res>? get track;

}
/// @nodoc
class _$DownloadTaskMetadataCopyWithImpl<$Res>
    implements $DownloadTaskMetadataCopyWith<$Res> {
  _$DownloadTaskMetadataCopyWithImpl(this._self, this._then);

  final DownloadTaskMetadata _self;
  final $Res Function(DownloadTaskMetadata) _then;

/// Create a copy of DownloadTaskMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? userId = null,Object? episodeId = freezed,Object? track = freezed,Object? expectedFileCount = null,Object? fileInode = null,Object? fileIndex = null,Object? fileKind = null,Object? fileName = freezed,Object? fileMimeType = freezed,Object? saf = null,Object? downloadBasePath = freezed,Object? libraryId = freezed,Object? serverUrl = freezed,Object? serverHost = freezed,Object? serverPort = freezed,Object? serverSsl = freezed,Object? title = freezed,Object? downloadType = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as InternalTrack?,expectedFileCount: null == expectedFileCount ? _self.expectedFileCount : expectedFileCount // ignore: cast_nullable_to_non_nullable
as int,fileInode: null == fileInode ? _self.fileInode : fileInode // ignore: cast_nullable_to_non_nullable
as String,fileIndex: null == fileIndex ? _self.fileIndex : fileIndex // ignore: cast_nullable_to_non_nullable
as int,fileKind: null == fileKind ? _self.fileKind : fileKind // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileMimeType: freezed == fileMimeType ? _self.fileMimeType : fileMimeType // ignore: cast_nullable_to_non_nullable
as String?,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,downloadBasePath: freezed == downloadBasePath ? _self.downloadBasePath : downloadBasePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,serverUrl: freezed == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String?,serverHost: freezed == serverHost ? _self.serverHost : serverHost // ignore: cast_nullable_to_non_nullable
as String?,serverPort: freezed == serverPort ? _self.serverPort : serverPort // ignore: cast_nullable_to_non_nullable
as int?,serverSsl: freezed == serverSsl ? _self.serverSsl : serverSsl // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,downloadType: null == downloadType ? _self.downloadType : downloadType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of DownloadTaskMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InternalTrackCopyWith<$Res>? get track {
    if (_self.track == null) {
    return null;
  }

  return $InternalTrackCopyWith<$Res>(_self.track!, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// Adds pattern-matching-related methods to [DownloadTaskMetadata].
extension DownloadTaskMetadataPatterns on DownloadTaskMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadTaskMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadTaskMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadTaskMetadata value)  $default,){
final _that = this;
switch (_that) {
case _DownloadTaskMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadTaskMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadTaskMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String userId,  String? episodeId,  InternalTrack? track,  int expectedFileCount,  String fileInode,  int fileIndex,  String fileKind,  String? fileName,  String? fileMimeType,  bool saf,  String? downloadBasePath,  String? libraryId,  String? serverUrl,  String? serverHost,  int? serverPort,  bool? serverSsl,  String? title,  String downloadType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadTaskMetadata() when $default != null:
return $default(_that.itemId,_that.userId,_that.episodeId,_that.track,_that.expectedFileCount,_that.fileInode,_that.fileIndex,_that.fileKind,_that.fileName,_that.fileMimeType,_that.saf,_that.downloadBasePath,_that.libraryId,_that.serverUrl,_that.serverHost,_that.serverPort,_that.serverSsl,_that.title,_that.downloadType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String userId,  String? episodeId,  InternalTrack? track,  int expectedFileCount,  String fileInode,  int fileIndex,  String fileKind,  String? fileName,  String? fileMimeType,  bool saf,  String? downloadBasePath,  String? libraryId,  String? serverUrl,  String? serverHost,  int? serverPort,  bool? serverSsl,  String? title,  String downloadType)  $default,) {final _that = this;
switch (_that) {
case _DownloadTaskMetadata():
return $default(_that.itemId,_that.userId,_that.episodeId,_that.track,_that.expectedFileCount,_that.fileInode,_that.fileIndex,_that.fileKind,_that.fileName,_that.fileMimeType,_that.saf,_that.downloadBasePath,_that.libraryId,_that.serverUrl,_that.serverHost,_that.serverPort,_that.serverSsl,_that.title,_that.downloadType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String userId,  String? episodeId,  InternalTrack? track,  int expectedFileCount,  String fileInode,  int fileIndex,  String fileKind,  String? fileName,  String? fileMimeType,  bool saf,  String? downloadBasePath,  String? libraryId,  String? serverUrl,  String? serverHost,  int? serverPort,  bool? serverSsl,  String? title,  String downloadType)?  $default,) {final _that = this;
switch (_that) {
case _DownloadTaskMetadata() when $default != null:
return $default(_that.itemId,_that.userId,_that.episodeId,_that.track,_that.expectedFileCount,_that.fileInode,_that.fileIndex,_that.fileKind,_that.fileName,_that.fileMimeType,_that.saf,_that.downloadBasePath,_that.libraryId,_that.serverUrl,_that.serverHost,_that.serverPort,_that.serverSsl,_that.title,_that.downloadType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadTaskMetadata implements DownloadTaskMetadata {
  const _DownloadTaskMetadata({required this.itemId, required this.userId, this.episodeId, this.track, this.expectedFileCount = 1, this.fileInode = '', this.fileIndex = 0, this.fileKind = 'file', this.fileName, this.fileMimeType, this.saf = false, this.downloadBasePath, this.libraryId, this.serverUrl, this.serverHost, this.serverPort, this.serverSsl, this.title, this.downloadType = 'both'});
  factory _DownloadTaskMetadata.fromJson(Map<String, dynamic> json) => _$DownloadTaskMetadataFromJson(json);

@override final  String itemId;
@override final  String userId;
@override final  String? episodeId;
@override final  InternalTrack? track;
@override@JsonKey() final  int expectedFileCount;
@override@JsonKey() final  String fileInode;
@override@JsonKey() final  int fileIndex;
@override@JsonKey() final  String fileKind;
@override final  String? fileName;
@override final  String? fileMimeType;
@override@JsonKey() final  bool saf;
@override final  String? downloadBasePath;
@override final  String? libraryId;
@override final  String? serverUrl;
@override final  String? serverHost;
@override final  int? serverPort;
@override final  bool? serverSsl;
@override final  String? title;
@override@JsonKey() final  String downloadType;

/// Create a copy of DownloadTaskMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadTaskMetadataCopyWith<_DownloadTaskMetadata> get copyWith => __$DownloadTaskMetadataCopyWithImpl<_DownloadTaskMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadTaskMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadTaskMetadata&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.track, track) || other.track == track)&&(identical(other.expectedFileCount, expectedFileCount) || other.expectedFileCount == expectedFileCount)&&(identical(other.fileInode, fileInode) || other.fileInode == fileInode)&&(identical(other.fileIndex, fileIndex) || other.fileIndex == fileIndex)&&(identical(other.fileKind, fileKind) || other.fileKind == fileKind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileMimeType, fileMimeType) || other.fileMimeType == fileMimeType)&&(identical(other.saf, saf) || other.saf == saf)&&(identical(other.downloadBasePath, downloadBasePath) || other.downloadBasePath == downloadBasePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.serverHost, serverHost) || other.serverHost == serverHost)&&(identical(other.serverPort, serverPort) || other.serverPort == serverPort)&&(identical(other.serverSsl, serverSsl) || other.serverSsl == serverSsl)&&(identical(other.title, title) || other.title == title)&&(identical(other.downloadType, downloadType) || other.downloadType == downloadType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,itemId,userId,episodeId,track,expectedFileCount,fileInode,fileIndex,fileKind,fileName,fileMimeType,saf,downloadBasePath,libraryId,serverUrl,serverHost,serverPort,serverSsl,title,downloadType]);

@override
String toString() {
  return 'DownloadTaskMetadata(itemId: $itemId, userId: $userId, episodeId: $episodeId, track: $track, expectedFileCount: $expectedFileCount, fileInode: $fileInode, fileIndex: $fileIndex, fileKind: $fileKind, fileName: $fileName, fileMimeType: $fileMimeType, saf: $saf, downloadBasePath: $downloadBasePath, libraryId: $libraryId, serverUrl: $serverUrl, serverHost: $serverHost, serverPort: $serverPort, serverSsl: $serverSsl, title: $title, downloadType: $downloadType)';
}


}

/// @nodoc
abstract mixin class _$DownloadTaskMetadataCopyWith<$Res> implements $DownloadTaskMetadataCopyWith<$Res> {
  factory _$DownloadTaskMetadataCopyWith(_DownloadTaskMetadata value, $Res Function(_DownloadTaskMetadata) _then) = __$DownloadTaskMetadataCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String userId, String? episodeId, InternalTrack? track, int expectedFileCount, String fileInode, int fileIndex, String fileKind, String? fileName, String? fileMimeType, bool saf, String? downloadBasePath, String? libraryId, String? serverUrl, String? serverHost, int? serverPort, bool? serverSsl, String? title, String downloadType
});


@override $InternalTrackCopyWith<$Res>? get track;

}
/// @nodoc
class __$DownloadTaskMetadataCopyWithImpl<$Res>
    implements _$DownloadTaskMetadataCopyWith<$Res> {
  __$DownloadTaskMetadataCopyWithImpl(this._self, this._then);

  final _DownloadTaskMetadata _self;
  final $Res Function(_DownloadTaskMetadata) _then;

/// Create a copy of DownloadTaskMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? userId = null,Object? episodeId = freezed,Object? track = freezed,Object? expectedFileCount = null,Object? fileInode = null,Object? fileIndex = null,Object? fileKind = null,Object? fileName = freezed,Object? fileMimeType = freezed,Object? saf = null,Object? downloadBasePath = freezed,Object? libraryId = freezed,Object? serverUrl = freezed,Object? serverHost = freezed,Object? serverPort = freezed,Object? serverSsl = freezed,Object? title = freezed,Object? downloadType = null,}) {
  return _then(_DownloadTaskMetadata(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as InternalTrack?,expectedFileCount: null == expectedFileCount ? _self.expectedFileCount : expectedFileCount // ignore: cast_nullable_to_non_nullable
as int,fileInode: null == fileInode ? _self.fileInode : fileInode // ignore: cast_nullable_to_non_nullable
as String,fileIndex: null == fileIndex ? _self.fileIndex : fileIndex // ignore: cast_nullable_to_non_nullable
as int,fileKind: null == fileKind ? _self.fileKind : fileKind // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileMimeType: freezed == fileMimeType ? _self.fileMimeType : fileMimeType // ignore: cast_nullable_to_non_nullable
as String?,saf: null == saf ? _self.saf : saf // ignore: cast_nullable_to_non_nullable
as bool,downloadBasePath: freezed == downloadBasePath ? _self.downloadBasePath : downloadBasePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,serverUrl: freezed == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String?,serverHost: freezed == serverHost ? _self.serverHost : serverHost // ignore: cast_nullable_to_non_nullable
as String?,serverPort: freezed == serverPort ? _self.serverPort : serverPort // ignore: cast_nullable_to_non_nullable
as int?,serverSsl: freezed == serverSsl ? _self.serverSsl : serverSsl // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,downloadType: null == downloadType ? _self.downloadType : downloadType // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of DownloadTaskMetadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InternalTrackCopyWith<$Res>? get track {
    if (_self.track == null) {
    return null;
  }

  return $InternalTrackCopyWith<$Res>(_self.track!, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}

// dart format on
