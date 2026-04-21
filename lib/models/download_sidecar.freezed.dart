// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_sidecar.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadSidecar {

@JsonKey(name: 'schemaVersion') int get schemaVersion;@JsonKey(name: 'itemId') String get itemId;@JsonKey(name: 'episodeId') String? get episodeId;@JsonKey(name: 'libraryId') String? get libraryId;@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'serverId') String? get serverId;@JsonKey(name: 'serverUrl') String? get serverUrl;@JsonKey(name: 'serverHost') String? get serverHost;@JsonKey(name: 'serverPort') int? get serverPort;@JsonKey(name: 'serverSsl') bool? get serverSsl;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'fileInode') String? get fileInode;@JsonKey(name: 'fileIndex') int get fileIndex;@JsonKey(name: 'fileKind') String get fileKind;@JsonKey(name: 'fileName') String? get fileName;@JsonKey(name: 'fileMimeType') String? get fileMimeType;@JsonKey(name: 'coverPath') String? get coverPath;@JsonKey(name: 'createdAt') int get createdAtEpochMs;
/// Create a copy of DownloadSidecar
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadSidecarCopyWith<DownloadSidecar> get copyWith => _$DownloadSidecarCopyWithImpl<DownloadSidecar>(this as DownloadSidecar, _$identity);

  /// Serializes this DownloadSidecar to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadSidecar&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.serverHost, serverHost) || other.serverHost == serverHost)&&(identical(other.serverPort, serverPort) || other.serverPort == serverPort)&&(identical(other.serverSsl, serverSsl) || other.serverSsl == serverSsl)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileInode, fileInode) || other.fileInode == fileInode)&&(identical(other.fileIndex, fileIndex) || other.fileIndex == fileIndex)&&(identical(other.fileKind, fileKind) || other.fileKind == fileKind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileMimeType, fileMimeType) || other.fileMimeType == fileMimeType)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.createdAtEpochMs, createdAtEpochMs) || other.createdAtEpochMs == createdAtEpochMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,itemId,episodeId,libraryId,userId,serverId,serverUrl,serverHost,serverPort,serverSsl,title,fileInode,fileIndex,fileKind,fileName,fileMimeType,coverPath,createdAtEpochMs);

@override
String toString() {
  return 'DownloadSidecar(schemaVersion: $schemaVersion, itemId: $itemId, episodeId: $episodeId, libraryId: $libraryId, userId: $userId, serverId: $serverId, serverUrl: $serverUrl, serverHost: $serverHost, serverPort: $serverPort, serverSsl: $serverSsl, title: $title, fileInode: $fileInode, fileIndex: $fileIndex, fileKind: $fileKind, fileName: $fileName, fileMimeType: $fileMimeType, coverPath: $coverPath, createdAtEpochMs: $createdAtEpochMs)';
}


}

/// @nodoc
abstract mixin class $DownloadSidecarCopyWith<$Res>  {
  factory $DownloadSidecarCopyWith(DownloadSidecar value, $Res Function(DownloadSidecar) _then) = _$DownloadSidecarCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'schemaVersion') int schemaVersion,@JsonKey(name: 'itemId') String itemId,@JsonKey(name: 'episodeId') String? episodeId,@JsonKey(name: 'libraryId') String? libraryId,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'serverId') String? serverId,@JsonKey(name: 'serverUrl') String? serverUrl,@JsonKey(name: 'serverHost') String? serverHost,@JsonKey(name: 'serverPort') int? serverPort,@JsonKey(name: 'serverSsl') bool? serverSsl,@JsonKey(name: 'title') String? title,@JsonKey(name: 'fileInode') String? fileInode,@JsonKey(name: 'fileIndex') int fileIndex,@JsonKey(name: 'fileKind') String fileKind,@JsonKey(name: 'fileName') String? fileName,@JsonKey(name: 'fileMimeType') String? fileMimeType,@JsonKey(name: 'coverPath') String? coverPath,@JsonKey(name: 'createdAt') int createdAtEpochMs
});




}
/// @nodoc
class _$DownloadSidecarCopyWithImpl<$Res>
    implements $DownloadSidecarCopyWith<$Res> {
  _$DownloadSidecarCopyWithImpl(this._self, this._then);

  final DownloadSidecar _self;
  final $Res Function(DownloadSidecar) _then;

/// Create a copy of DownloadSidecar
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? itemId = null,Object? episodeId = freezed,Object? libraryId = freezed,Object? userId = null,Object? serverId = freezed,Object? serverUrl = freezed,Object? serverHost = freezed,Object? serverPort = freezed,Object? serverSsl = freezed,Object? title = freezed,Object? fileInode = freezed,Object? fileIndex = null,Object? fileKind = null,Object? fileName = freezed,Object? fileMimeType = freezed,Object? coverPath = freezed,Object? createdAtEpochMs = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,serverUrl: freezed == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String?,serverHost: freezed == serverHost ? _self.serverHost : serverHost // ignore: cast_nullable_to_non_nullable
as String?,serverPort: freezed == serverPort ? _self.serverPort : serverPort // ignore: cast_nullable_to_non_nullable
as int?,serverSsl: freezed == serverSsl ? _self.serverSsl : serverSsl // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,fileInode: freezed == fileInode ? _self.fileInode : fileInode // ignore: cast_nullable_to_non_nullable
as String?,fileIndex: null == fileIndex ? _self.fileIndex : fileIndex // ignore: cast_nullable_to_non_nullable
as int,fileKind: null == fileKind ? _self.fileKind : fileKind // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileMimeType: freezed == fileMimeType ? _self.fileMimeType : fileMimeType // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,createdAtEpochMs: null == createdAtEpochMs ? _self.createdAtEpochMs : createdAtEpochMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadSidecar].
extension DownloadSidecarPatterns on DownloadSidecar {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadSidecar value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadSidecar() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadSidecar value)  $default,){
final _that = this;
switch (_that) {
case _DownloadSidecar():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadSidecar value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadSidecar() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'schemaVersion')  int schemaVersion, @JsonKey(name: 'itemId')  String itemId, @JsonKey(name: 'episodeId')  String? episodeId, @JsonKey(name: 'libraryId')  String? libraryId, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'serverId')  String? serverId, @JsonKey(name: 'serverUrl')  String? serverUrl, @JsonKey(name: 'serverHost')  String? serverHost, @JsonKey(name: 'serverPort')  int? serverPort, @JsonKey(name: 'serverSsl')  bool? serverSsl, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'fileInode')  String? fileInode, @JsonKey(name: 'fileIndex')  int fileIndex, @JsonKey(name: 'fileKind')  String fileKind, @JsonKey(name: 'fileName')  String? fileName, @JsonKey(name: 'fileMimeType')  String? fileMimeType, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'createdAt')  int createdAtEpochMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadSidecar() when $default != null:
return $default(_that.schemaVersion,_that.itemId,_that.episodeId,_that.libraryId,_that.userId,_that.serverId,_that.serverUrl,_that.serverHost,_that.serverPort,_that.serverSsl,_that.title,_that.fileInode,_that.fileIndex,_that.fileKind,_that.fileName,_that.fileMimeType,_that.coverPath,_that.createdAtEpochMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'schemaVersion')  int schemaVersion, @JsonKey(name: 'itemId')  String itemId, @JsonKey(name: 'episodeId')  String? episodeId, @JsonKey(name: 'libraryId')  String? libraryId, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'serverId')  String? serverId, @JsonKey(name: 'serverUrl')  String? serverUrl, @JsonKey(name: 'serverHost')  String? serverHost, @JsonKey(name: 'serverPort')  int? serverPort, @JsonKey(name: 'serverSsl')  bool? serverSsl, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'fileInode')  String? fileInode, @JsonKey(name: 'fileIndex')  int fileIndex, @JsonKey(name: 'fileKind')  String fileKind, @JsonKey(name: 'fileName')  String? fileName, @JsonKey(name: 'fileMimeType')  String? fileMimeType, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'createdAt')  int createdAtEpochMs)  $default,) {final _that = this;
switch (_that) {
case _DownloadSidecar():
return $default(_that.schemaVersion,_that.itemId,_that.episodeId,_that.libraryId,_that.userId,_that.serverId,_that.serverUrl,_that.serverHost,_that.serverPort,_that.serverSsl,_that.title,_that.fileInode,_that.fileIndex,_that.fileKind,_that.fileName,_that.fileMimeType,_that.coverPath,_that.createdAtEpochMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'schemaVersion')  int schemaVersion, @JsonKey(name: 'itemId')  String itemId, @JsonKey(name: 'episodeId')  String? episodeId, @JsonKey(name: 'libraryId')  String? libraryId, @JsonKey(name: 'userId')  String userId, @JsonKey(name: 'serverId')  String? serverId, @JsonKey(name: 'serverUrl')  String? serverUrl, @JsonKey(name: 'serverHost')  String? serverHost, @JsonKey(name: 'serverPort')  int? serverPort, @JsonKey(name: 'serverSsl')  bool? serverSsl, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'fileInode')  String? fileInode, @JsonKey(name: 'fileIndex')  int fileIndex, @JsonKey(name: 'fileKind')  String fileKind, @JsonKey(name: 'fileName')  String? fileName, @JsonKey(name: 'fileMimeType')  String? fileMimeType, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'createdAt')  int createdAtEpochMs)?  $default,) {final _that = this;
switch (_that) {
case _DownloadSidecar() when $default != null:
return $default(_that.schemaVersion,_that.itemId,_that.episodeId,_that.libraryId,_that.userId,_that.serverId,_that.serverUrl,_that.serverHost,_that.serverPort,_that.serverSsl,_that.title,_that.fileInode,_that.fileIndex,_that.fileKind,_that.fileName,_that.fileMimeType,_that.coverPath,_that.createdAtEpochMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadSidecar implements DownloadSidecar {
  const _DownloadSidecar({@JsonKey(name: 'schemaVersion') this.schemaVersion = 1, @JsonKey(name: 'itemId') required this.itemId, @JsonKey(name: 'episodeId') this.episodeId, @JsonKey(name: 'libraryId') this.libraryId, @JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'serverId') this.serverId, @JsonKey(name: 'serverUrl') this.serverUrl, @JsonKey(name: 'serverHost') this.serverHost, @JsonKey(name: 'serverPort') this.serverPort, @JsonKey(name: 'serverSsl') this.serverSsl, @JsonKey(name: 'title') this.title, @JsonKey(name: 'fileInode') this.fileInode, @JsonKey(name: 'fileIndex') required this.fileIndex, @JsonKey(name: 'fileKind') required this.fileKind, @JsonKey(name: 'fileName') this.fileName, @JsonKey(name: 'fileMimeType') this.fileMimeType, @JsonKey(name: 'coverPath') this.coverPath, @JsonKey(name: 'createdAt') required this.createdAtEpochMs});
  factory _DownloadSidecar.fromJson(Map<String, dynamic> json) => _$DownloadSidecarFromJson(json);

@override@JsonKey(name: 'schemaVersion') final  int schemaVersion;
@override@JsonKey(name: 'itemId') final  String itemId;
@override@JsonKey(name: 'episodeId') final  String? episodeId;
@override@JsonKey(name: 'libraryId') final  String? libraryId;
@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'serverId') final  String? serverId;
@override@JsonKey(name: 'serverUrl') final  String? serverUrl;
@override@JsonKey(name: 'serverHost') final  String? serverHost;
@override@JsonKey(name: 'serverPort') final  int? serverPort;
@override@JsonKey(name: 'serverSsl') final  bool? serverSsl;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'fileInode') final  String? fileInode;
@override@JsonKey(name: 'fileIndex') final  int fileIndex;
@override@JsonKey(name: 'fileKind') final  String fileKind;
@override@JsonKey(name: 'fileName') final  String? fileName;
@override@JsonKey(name: 'fileMimeType') final  String? fileMimeType;
@override@JsonKey(name: 'coverPath') final  String? coverPath;
@override@JsonKey(name: 'createdAt') final  int createdAtEpochMs;

/// Create a copy of DownloadSidecar
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadSidecarCopyWith<_DownloadSidecar> get copyWith => __$DownloadSidecarCopyWithImpl<_DownloadSidecar>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadSidecarToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadSidecar&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.serverId, serverId) || other.serverId == serverId)&&(identical(other.serverUrl, serverUrl) || other.serverUrl == serverUrl)&&(identical(other.serverHost, serverHost) || other.serverHost == serverHost)&&(identical(other.serverPort, serverPort) || other.serverPort == serverPort)&&(identical(other.serverSsl, serverSsl) || other.serverSsl == serverSsl)&&(identical(other.title, title) || other.title == title)&&(identical(other.fileInode, fileInode) || other.fileInode == fileInode)&&(identical(other.fileIndex, fileIndex) || other.fileIndex == fileIndex)&&(identical(other.fileKind, fileKind) || other.fileKind == fileKind)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileMimeType, fileMimeType) || other.fileMimeType == fileMimeType)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.createdAtEpochMs, createdAtEpochMs) || other.createdAtEpochMs == createdAtEpochMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,itemId,episodeId,libraryId,userId,serverId,serverUrl,serverHost,serverPort,serverSsl,title,fileInode,fileIndex,fileKind,fileName,fileMimeType,coverPath,createdAtEpochMs);

@override
String toString() {
  return 'DownloadSidecar(schemaVersion: $schemaVersion, itemId: $itemId, episodeId: $episodeId, libraryId: $libraryId, userId: $userId, serverId: $serverId, serverUrl: $serverUrl, serverHost: $serverHost, serverPort: $serverPort, serverSsl: $serverSsl, title: $title, fileInode: $fileInode, fileIndex: $fileIndex, fileKind: $fileKind, fileName: $fileName, fileMimeType: $fileMimeType, coverPath: $coverPath, createdAtEpochMs: $createdAtEpochMs)';
}


}

/// @nodoc
abstract mixin class _$DownloadSidecarCopyWith<$Res> implements $DownloadSidecarCopyWith<$Res> {
  factory _$DownloadSidecarCopyWith(_DownloadSidecar value, $Res Function(_DownloadSidecar) _then) = __$DownloadSidecarCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'schemaVersion') int schemaVersion,@JsonKey(name: 'itemId') String itemId,@JsonKey(name: 'episodeId') String? episodeId,@JsonKey(name: 'libraryId') String? libraryId,@JsonKey(name: 'userId') String userId,@JsonKey(name: 'serverId') String? serverId,@JsonKey(name: 'serverUrl') String? serverUrl,@JsonKey(name: 'serverHost') String? serverHost,@JsonKey(name: 'serverPort') int? serverPort,@JsonKey(name: 'serverSsl') bool? serverSsl,@JsonKey(name: 'title') String? title,@JsonKey(name: 'fileInode') String? fileInode,@JsonKey(name: 'fileIndex') int fileIndex,@JsonKey(name: 'fileKind') String fileKind,@JsonKey(name: 'fileName') String? fileName,@JsonKey(name: 'fileMimeType') String? fileMimeType,@JsonKey(name: 'coverPath') String? coverPath,@JsonKey(name: 'createdAt') int createdAtEpochMs
});




}
/// @nodoc
class __$DownloadSidecarCopyWithImpl<$Res>
    implements _$DownloadSidecarCopyWith<$Res> {
  __$DownloadSidecarCopyWithImpl(this._self, this._then);

  final _DownloadSidecar _self;
  final $Res Function(_DownloadSidecar) _then;

/// Create a copy of DownloadSidecar
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? itemId = null,Object? episodeId = freezed,Object? libraryId = freezed,Object? userId = null,Object? serverId = freezed,Object? serverUrl = freezed,Object? serverHost = freezed,Object? serverPort = freezed,Object? serverSsl = freezed,Object? title = freezed,Object? fileInode = freezed,Object? fileIndex = null,Object? fileKind = null,Object? fileName = freezed,Object? fileMimeType = freezed,Object? coverPath = freezed,Object? createdAtEpochMs = null,}) {
  return _then(_DownloadSidecar(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,serverId: freezed == serverId ? _self.serverId : serverId // ignore: cast_nullable_to_non_nullable
as String?,serverUrl: freezed == serverUrl ? _self.serverUrl : serverUrl // ignore: cast_nullable_to_non_nullable
as String?,serverHost: freezed == serverHost ? _self.serverHost : serverHost // ignore: cast_nullable_to_non_nullable
as String?,serverPort: freezed == serverPort ? _self.serverPort : serverPort // ignore: cast_nullable_to_non_nullable
as int?,serverSsl: freezed == serverSsl ? _self.serverSsl : serverSsl // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,fileInode: freezed == fileInode ? _self.fileInode : fileInode // ignore: cast_nullable_to_non_nullable
as String?,fileIndex: null == fileIndex ? _self.fileIndex : fileIndex // ignore: cast_nullable_to_non_nullable
as int,fileKind: null == fileKind ? _self.fileKind : fileKind // ignore: cast_nullable_to_non_nullable
as String,fileName: freezed == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String?,fileMimeType: freezed == fileMimeType ? _self.fileMimeType : fileMimeType // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,createdAtEpochMs: null == createdAtEpochMs ? _self.createdAtEpochMs : createdAtEpochMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
