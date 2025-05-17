// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItem {

@JsonKey(name: "id") String get id;@JsonKey(name: "ino") String get ino;@JsonKey(name: "oldLibraryItemId") String? get oldLibraryItemId;@JsonKey(name: "libraryId") String? get libraryId;@JsonKey(name: "folderId") String? get folderId;@JsonKey(name: "path") String? get path;@JsonKey(name: "relPath") String? get relPath;@JsonKey(name: "isFile") bool? get isFile;@JsonKey(name: "mtimeMs") int? get mtimeMs;@JsonKey(name: "ctimeMs") int? get ctimeMs;@JsonKey(name: "birthtimeMs") int? get birthtimeMs;@JsonKey(name: "addedAt") int? get addedAt;@JsonKey(name: "updatedAt") int? get updatedAt;@JsonKey(name: "lastScan") int? get lastScan;@JsonKey(name: "scanVersion") String? get scanVersion;@JsonKey(name: "isMissing") bool? get isMissing;@JsonKey(name: "isInvalid") bool? get isInvalid;@JsonKey(name: "mediaType") String? get mediaType;@JsonKey(name: "media") Media? get media;@JsonKey(name: "libraryFiles") List<LibraryFile>? get libraryFiles;@JsonKey(name: "size") int? get size;@JsonKey(name: "collapsedSeries") CollapsedSeries? get collapsedSeries;
/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<LibraryItem> get copyWith => _$LibraryItemCopyWithImpl<LibraryItem>(this as LibraryItem, _$identity);

  /// Serializes this LibraryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.oldLibraryItemId, oldLibraryItemId) || other.oldLibraryItemId == oldLibraryItemId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.path, path) || other.path == path)&&(identical(other.relPath, relPath) || other.relPath == relPath)&&(identical(other.isFile, isFile) || other.isFile == isFile)&&(identical(other.mtimeMs, mtimeMs) || other.mtimeMs == mtimeMs)&&(identical(other.ctimeMs, ctimeMs) || other.ctimeMs == ctimeMs)&&(identical(other.birthtimeMs, birthtimeMs) || other.birthtimeMs == birthtimeMs)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastScan, lastScan) || other.lastScan == lastScan)&&(identical(other.scanVersion, scanVersion) || other.scanVersion == scanVersion)&&(identical(other.isMissing, isMissing) || other.isMissing == isMissing)&&(identical(other.isInvalid, isInvalid) || other.isInvalid == isInvalid)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.media, media) || other.media == media)&&const DeepCollectionEquality().equals(other.libraryFiles, libraryFiles)&&(identical(other.size, size) || other.size == size)&&(identical(other.collapsedSeries, collapsedSeries) || other.collapsedSeries == collapsedSeries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,ino,oldLibraryItemId,libraryId,folderId,path,relPath,isFile,mtimeMs,ctimeMs,birthtimeMs,addedAt,updatedAt,lastScan,scanVersion,isMissing,isInvalid,mediaType,media,const DeepCollectionEquality().hash(libraryFiles),size,collapsedSeries]);

@override
String toString() {
  return 'LibraryItem(id: $id, ino: $ino, oldLibraryItemId: $oldLibraryItemId, libraryId: $libraryId, folderId: $folderId, path: $path, relPath: $relPath, isFile: $isFile, mtimeMs: $mtimeMs, ctimeMs: $ctimeMs, birthtimeMs: $birthtimeMs, addedAt: $addedAt, updatedAt: $updatedAt, lastScan: $lastScan, scanVersion: $scanVersion, isMissing: $isMissing, isInvalid: $isInvalid, mediaType: $mediaType, media: $media, libraryFiles: $libraryFiles, size: $size, collapsedSeries: $collapsedSeries)';
}


}

/// @nodoc
abstract mixin class $LibraryItemCopyWith<$Res>  {
  factory $LibraryItemCopyWith(LibraryItem value, $Res Function(LibraryItem) _then) = _$LibraryItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "ino") String ino,@JsonKey(name: "oldLibraryItemId") String? oldLibraryItemId,@JsonKey(name: "libraryId") String? libraryId,@JsonKey(name: "folderId") String? folderId,@JsonKey(name: "path") String? path,@JsonKey(name: "relPath") String? relPath,@JsonKey(name: "isFile") bool? isFile,@JsonKey(name: "mtimeMs") int? mtimeMs,@JsonKey(name: "ctimeMs") int? ctimeMs,@JsonKey(name: "birthtimeMs") int? birthtimeMs,@JsonKey(name: "addedAt") int? addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "lastScan") int? lastScan,@JsonKey(name: "scanVersion") String? scanVersion,@JsonKey(name: "isMissing") bool? isMissing,@JsonKey(name: "isInvalid") bool? isInvalid,@JsonKey(name: "mediaType") String? mediaType,@JsonKey(name: "media") Media? media,@JsonKey(name: "libraryFiles") List<LibraryFile>? libraryFiles,@JsonKey(name: "size") int? size,@JsonKey(name: "collapsedSeries") CollapsedSeries? collapsedSeries
});


$MediaCopyWith<$Res>? get media;$CollapsedSeriesCopyWith<$Res>? get collapsedSeries;

}
/// @nodoc
class _$LibraryItemCopyWithImpl<$Res>
    implements $LibraryItemCopyWith<$Res> {
  _$LibraryItemCopyWithImpl(this._self, this._then);

  final LibraryItem _self;
  final $Res Function(LibraryItem) _then;

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ino = null,Object? oldLibraryItemId = freezed,Object? libraryId = freezed,Object? folderId = freezed,Object? path = freezed,Object? relPath = freezed,Object? isFile = freezed,Object? mtimeMs = freezed,Object? ctimeMs = freezed,Object? birthtimeMs = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,Object? lastScan = freezed,Object? scanVersion = freezed,Object? isMissing = freezed,Object? isInvalid = freezed,Object? mediaType = freezed,Object? media = freezed,Object? libraryFiles = freezed,Object? size = freezed,Object? collapsedSeries = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,oldLibraryItemId: freezed == oldLibraryItemId ? _self.oldLibraryItemId : oldLibraryItemId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,relPath: freezed == relPath ? _self.relPath : relPath // ignore: cast_nullable_to_non_nullable
as String?,isFile: freezed == isFile ? _self.isFile : isFile // ignore: cast_nullable_to_non_nullable
as bool?,mtimeMs: freezed == mtimeMs ? _self.mtimeMs : mtimeMs // ignore: cast_nullable_to_non_nullable
as int?,ctimeMs: freezed == ctimeMs ? _self.ctimeMs : ctimeMs // ignore: cast_nullable_to_non_nullable
as int?,birthtimeMs: freezed == birthtimeMs ? _self.birthtimeMs : birthtimeMs // ignore: cast_nullable_to_non_nullable
as int?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,lastScan: freezed == lastScan ? _self.lastScan : lastScan // ignore: cast_nullable_to_non_nullable
as int?,scanVersion: freezed == scanVersion ? _self.scanVersion : scanVersion // ignore: cast_nullable_to_non_nullable
as String?,isMissing: freezed == isMissing ? _self.isMissing : isMissing // ignore: cast_nullable_to_non_nullable
as bool?,isInvalid: freezed == isInvalid ? _self.isInvalid : isInvalid // ignore: cast_nullable_to_non_nullable
as bool?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media?,libraryFiles: freezed == libraryFiles ? _self.libraryFiles : libraryFiles // ignore: cast_nullable_to_non_nullable
as List<LibraryFile>?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,collapsedSeries: freezed == collapsedSeries ? _self.collapsedSeries : collapsedSeries // ignore: cast_nullable_to_non_nullable
as CollapsedSeries?,
  ));
}
/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollapsedSeriesCopyWith<$Res>? get collapsedSeries {
    if (_self.collapsedSeries == null) {
    return null;
  }

  return $CollapsedSeriesCopyWith<$Res>(_self.collapsedSeries!, (value) {
    return _then(_self.copyWith(collapsedSeries: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _LibraryItem extends LibraryItem {
  const _LibraryItem({@JsonKey(name: "id") required this.id, @JsonKey(name: "ino") required this.ino, @JsonKey(name: "oldLibraryItemId") this.oldLibraryItemId, @JsonKey(name: "libraryId") this.libraryId, @JsonKey(name: "folderId") this.folderId, @JsonKey(name: "path") this.path, @JsonKey(name: "relPath") this.relPath, @JsonKey(name: "isFile") this.isFile, @JsonKey(name: "mtimeMs") this.mtimeMs, @JsonKey(name: "ctimeMs") this.ctimeMs, @JsonKey(name: "birthtimeMs") this.birthtimeMs, @JsonKey(name: "addedAt") this.addedAt, @JsonKey(name: "updatedAt") this.updatedAt, @JsonKey(name: "lastScan") this.lastScan, @JsonKey(name: "scanVersion") this.scanVersion, @JsonKey(name: "isMissing") this.isMissing, @JsonKey(name: "isInvalid") this.isInvalid, @JsonKey(name: "mediaType") this.mediaType, @JsonKey(name: "media") required this.media, @JsonKey(name: "libraryFiles") required final  List<LibraryFile>? libraryFiles, @JsonKey(name: "size") this.size, @JsonKey(name: "collapsedSeries") this.collapsedSeries}): _libraryFiles = libraryFiles,super._();
  factory _LibraryItem.fromJson(Map<String, dynamic> json) => _$LibraryItemFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "ino") final  String ino;
@override@JsonKey(name: "oldLibraryItemId") final  String? oldLibraryItemId;
@override@JsonKey(name: "libraryId") final  String? libraryId;
@override@JsonKey(name: "folderId") final  String? folderId;
@override@JsonKey(name: "path") final  String? path;
@override@JsonKey(name: "relPath") final  String? relPath;
@override@JsonKey(name: "isFile") final  bool? isFile;
@override@JsonKey(name: "mtimeMs") final  int? mtimeMs;
@override@JsonKey(name: "ctimeMs") final  int? ctimeMs;
@override@JsonKey(name: "birthtimeMs") final  int? birthtimeMs;
@override@JsonKey(name: "addedAt") final  int? addedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;
@override@JsonKey(name: "lastScan") final  int? lastScan;
@override@JsonKey(name: "scanVersion") final  String? scanVersion;
@override@JsonKey(name: "isMissing") final  bool? isMissing;
@override@JsonKey(name: "isInvalid") final  bool? isInvalid;
@override@JsonKey(name: "mediaType") final  String? mediaType;
@override@JsonKey(name: "media") final  Media? media;
 final  List<LibraryFile>? _libraryFiles;
@override@JsonKey(name: "libraryFiles") List<LibraryFile>? get libraryFiles {
  final value = _libraryFiles;
  if (value == null) return null;
  if (_libraryFiles is EqualUnmodifiableListView) return _libraryFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "size") final  int? size;
@override@JsonKey(name: "collapsedSeries") final  CollapsedSeries? collapsedSeries;

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemCopyWith<_LibraryItem> get copyWith => __$LibraryItemCopyWithImpl<_LibraryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.oldLibraryItemId, oldLibraryItemId) || other.oldLibraryItemId == oldLibraryItemId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.path, path) || other.path == path)&&(identical(other.relPath, relPath) || other.relPath == relPath)&&(identical(other.isFile, isFile) || other.isFile == isFile)&&(identical(other.mtimeMs, mtimeMs) || other.mtimeMs == mtimeMs)&&(identical(other.ctimeMs, ctimeMs) || other.ctimeMs == ctimeMs)&&(identical(other.birthtimeMs, birthtimeMs) || other.birthtimeMs == birthtimeMs)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.lastScan, lastScan) || other.lastScan == lastScan)&&(identical(other.scanVersion, scanVersion) || other.scanVersion == scanVersion)&&(identical(other.isMissing, isMissing) || other.isMissing == isMissing)&&(identical(other.isInvalid, isInvalid) || other.isInvalid == isInvalid)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.media, media) || other.media == media)&&const DeepCollectionEquality().equals(other._libraryFiles, _libraryFiles)&&(identical(other.size, size) || other.size == size)&&(identical(other.collapsedSeries, collapsedSeries) || other.collapsedSeries == collapsedSeries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,ino,oldLibraryItemId,libraryId,folderId,path,relPath,isFile,mtimeMs,ctimeMs,birthtimeMs,addedAt,updatedAt,lastScan,scanVersion,isMissing,isInvalid,mediaType,media,const DeepCollectionEquality().hash(_libraryFiles),size,collapsedSeries]);

@override
String toString() {
  return 'LibraryItem(id: $id, ino: $ino, oldLibraryItemId: $oldLibraryItemId, libraryId: $libraryId, folderId: $folderId, path: $path, relPath: $relPath, isFile: $isFile, mtimeMs: $mtimeMs, ctimeMs: $ctimeMs, birthtimeMs: $birthtimeMs, addedAt: $addedAt, updatedAt: $updatedAt, lastScan: $lastScan, scanVersion: $scanVersion, isMissing: $isMissing, isInvalid: $isInvalid, mediaType: $mediaType, media: $media, libraryFiles: $libraryFiles, size: $size, collapsedSeries: $collapsedSeries)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemCopyWith<$Res> implements $LibraryItemCopyWith<$Res> {
  factory _$LibraryItemCopyWith(_LibraryItem value, $Res Function(_LibraryItem) _then) = __$LibraryItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "ino") String ino,@JsonKey(name: "oldLibraryItemId") String? oldLibraryItemId,@JsonKey(name: "libraryId") String? libraryId,@JsonKey(name: "folderId") String? folderId,@JsonKey(name: "path") String? path,@JsonKey(name: "relPath") String? relPath,@JsonKey(name: "isFile") bool? isFile,@JsonKey(name: "mtimeMs") int? mtimeMs,@JsonKey(name: "ctimeMs") int? ctimeMs,@JsonKey(name: "birthtimeMs") int? birthtimeMs,@JsonKey(name: "addedAt") int? addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "lastScan") int? lastScan,@JsonKey(name: "scanVersion") String? scanVersion,@JsonKey(name: "isMissing") bool? isMissing,@JsonKey(name: "isInvalid") bool? isInvalid,@JsonKey(name: "mediaType") String? mediaType,@JsonKey(name: "media") Media? media,@JsonKey(name: "libraryFiles") List<LibraryFile>? libraryFiles,@JsonKey(name: "size") int? size,@JsonKey(name: "collapsedSeries") CollapsedSeries? collapsedSeries
});


@override $MediaCopyWith<$Res>? get media;@override $CollapsedSeriesCopyWith<$Res>? get collapsedSeries;

}
/// @nodoc
class __$LibraryItemCopyWithImpl<$Res>
    implements _$LibraryItemCopyWith<$Res> {
  __$LibraryItemCopyWithImpl(this._self, this._then);

  final _LibraryItem _self;
  final $Res Function(_LibraryItem) _then;

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ino = null,Object? oldLibraryItemId = freezed,Object? libraryId = freezed,Object? folderId = freezed,Object? path = freezed,Object? relPath = freezed,Object? isFile = freezed,Object? mtimeMs = freezed,Object? ctimeMs = freezed,Object? birthtimeMs = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,Object? lastScan = freezed,Object? scanVersion = freezed,Object? isMissing = freezed,Object? isInvalid = freezed,Object? mediaType = freezed,Object? media = freezed,Object? libraryFiles = freezed,Object? size = freezed,Object? collapsedSeries = freezed,}) {
  return _then(_LibraryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,oldLibraryItemId: freezed == oldLibraryItemId ? _self.oldLibraryItemId : oldLibraryItemId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,folderId: freezed == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,relPath: freezed == relPath ? _self.relPath : relPath // ignore: cast_nullable_to_non_nullable
as String?,isFile: freezed == isFile ? _self.isFile : isFile // ignore: cast_nullable_to_non_nullable
as bool?,mtimeMs: freezed == mtimeMs ? _self.mtimeMs : mtimeMs // ignore: cast_nullable_to_non_nullable
as int?,ctimeMs: freezed == ctimeMs ? _self.ctimeMs : ctimeMs // ignore: cast_nullable_to_non_nullable
as int?,birthtimeMs: freezed == birthtimeMs ? _self.birthtimeMs : birthtimeMs // ignore: cast_nullable_to_non_nullable
as int?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,lastScan: freezed == lastScan ? _self.lastScan : lastScan // ignore: cast_nullable_to_non_nullable
as int?,scanVersion: freezed == scanVersion ? _self.scanVersion : scanVersion // ignore: cast_nullable_to_non_nullable
as String?,isMissing: freezed == isMissing ? _self.isMissing : isMissing // ignore: cast_nullable_to_non_nullable
as bool?,isInvalid: freezed == isInvalid ? _self.isInvalid : isInvalid // ignore: cast_nullable_to_non_nullable
as bool?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media?,libraryFiles: freezed == libraryFiles ? _self._libraryFiles : libraryFiles // ignore: cast_nullable_to_non_nullable
as List<LibraryFile>?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,collapsedSeries: freezed == collapsedSeries ? _self.collapsedSeries : collapsedSeries // ignore: cast_nullable_to_non_nullable
as CollapsedSeries?,
  ));
}

/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaCopyWith<$Res>? get media {
    if (_self.media == null) {
    return null;
  }

  return $MediaCopyWith<$Res>(_self.media!, (value) {
    return _then(_self.copyWith(media: value));
  });
}/// Create a copy of LibraryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CollapsedSeriesCopyWith<$Res>? get collapsedSeries {
    if (_self.collapsedSeries == null) {
    return null;
  }

  return $CollapsedSeriesCopyWith<$Res>(_self.collapsedSeries!, (value) {
    return _then(_self.copyWith(collapsedSeries: value));
  });
}
}

// dart format on
