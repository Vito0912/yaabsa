// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_file_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryFileMetadata {

@JsonKey(name: "filename") String get filename;@JsonKey(name: "ext") String get ext;@JsonKey(name: "path") String get path;@JsonKey(name: "relPath") String get relPath;@JsonKey(name: "size") int get size;@JsonKey(name: "mtimeMs") int get mtimeMs;@JsonKey(name: "ctimeMs") int get ctimeMs;@JsonKey(name: "birthtimeMs") int get birthtimeMs;
/// Create a copy of LibraryFileMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<LibraryFileMetadata> get copyWith => _$LibraryFileMetadataCopyWithImpl<LibraryFileMetadata>(this as LibraryFileMetadata, _$identity);

  /// Serializes this LibraryFileMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryFileMetadata&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.path, path) || other.path == path)&&(identical(other.relPath, relPath) || other.relPath == relPath)&&(identical(other.size, size) || other.size == size)&&(identical(other.mtimeMs, mtimeMs) || other.mtimeMs == mtimeMs)&&(identical(other.ctimeMs, ctimeMs) || other.ctimeMs == ctimeMs)&&(identical(other.birthtimeMs, birthtimeMs) || other.birthtimeMs == birthtimeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,ext,path,relPath,size,mtimeMs,ctimeMs,birthtimeMs);

@override
String toString() {
  return 'LibraryFileMetadata(filename: $filename, ext: $ext, path: $path, relPath: $relPath, size: $size, mtimeMs: $mtimeMs, ctimeMs: $ctimeMs, birthtimeMs: $birthtimeMs)';
}


}

/// @nodoc
abstract mixin class $LibraryFileMetadataCopyWith<$Res>  {
  factory $LibraryFileMetadataCopyWith(LibraryFileMetadata value, $Res Function(LibraryFileMetadata) _then) = _$LibraryFileMetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "filename") String filename,@JsonKey(name: "ext") String ext,@JsonKey(name: "path") String path,@JsonKey(name: "relPath") String relPath,@JsonKey(name: "size") int size,@JsonKey(name: "mtimeMs") int mtimeMs,@JsonKey(name: "ctimeMs") int ctimeMs,@JsonKey(name: "birthtimeMs") int birthtimeMs
});




}
/// @nodoc
class _$LibraryFileMetadataCopyWithImpl<$Res>
    implements $LibraryFileMetadataCopyWith<$Res> {
  _$LibraryFileMetadataCopyWithImpl(this._self, this._then);

  final LibraryFileMetadata _self;
  final $Res Function(LibraryFileMetadata) _then;

/// Create a copy of LibraryFileMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filename = null,Object? ext = null,Object? path = null,Object? relPath = null,Object? size = null,Object? mtimeMs = null,Object? ctimeMs = null,Object? birthtimeMs = null,}) {
  return _then(_self.copyWith(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,ext: null == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,relPath: null == relPath ? _self.relPath : relPath // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mtimeMs: null == mtimeMs ? _self.mtimeMs : mtimeMs // ignore: cast_nullable_to_non_nullable
as int,ctimeMs: null == ctimeMs ? _self.ctimeMs : ctimeMs // ignore: cast_nullable_to_non_nullable
as int,birthtimeMs: null == birthtimeMs ? _self.birthtimeMs : birthtimeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryFileMetadata implements LibraryFileMetadata {
  const _LibraryFileMetadata({@JsonKey(name: "filename") required this.filename, @JsonKey(name: "ext") required this.ext, @JsonKey(name: "path") required this.path, @JsonKey(name: "relPath") required this.relPath, @JsonKey(name: "size") required this.size, @JsonKey(name: "mtimeMs") required this.mtimeMs, @JsonKey(name: "ctimeMs") required this.ctimeMs, @JsonKey(name: "birthtimeMs") required this.birthtimeMs});
  factory _LibraryFileMetadata.fromJson(Map<String, dynamic> json) => _$LibraryFileMetadataFromJson(json);

@override@JsonKey(name: "filename") final  String filename;
@override@JsonKey(name: "ext") final  String ext;
@override@JsonKey(name: "path") final  String path;
@override@JsonKey(name: "relPath") final  String relPath;
@override@JsonKey(name: "size") final  int size;
@override@JsonKey(name: "mtimeMs") final  int mtimeMs;
@override@JsonKey(name: "ctimeMs") final  int ctimeMs;
@override@JsonKey(name: "birthtimeMs") final  int birthtimeMs;

/// Create a copy of LibraryFileMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryFileMetadataCopyWith<_LibraryFileMetadata> get copyWith => __$LibraryFileMetadataCopyWithImpl<_LibraryFileMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryFileMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryFileMetadata&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.path, path) || other.path == path)&&(identical(other.relPath, relPath) || other.relPath == relPath)&&(identical(other.size, size) || other.size == size)&&(identical(other.mtimeMs, mtimeMs) || other.mtimeMs == mtimeMs)&&(identical(other.ctimeMs, ctimeMs) || other.ctimeMs == ctimeMs)&&(identical(other.birthtimeMs, birthtimeMs) || other.birthtimeMs == birthtimeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filename,ext,path,relPath,size,mtimeMs,ctimeMs,birthtimeMs);

@override
String toString() {
  return 'LibraryFileMetadata(filename: $filename, ext: $ext, path: $path, relPath: $relPath, size: $size, mtimeMs: $mtimeMs, ctimeMs: $ctimeMs, birthtimeMs: $birthtimeMs)';
}


}

/// @nodoc
abstract mixin class _$LibraryFileMetadataCopyWith<$Res> implements $LibraryFileMetadataCopyWith<$Res> {
  factory _$LibraryFileMetadataCopyWith(_LibraryFileMetadata value, $Res Function(_LibraryFileMetadata) _then) = __$LibraryFileMetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "filename") String filename,@JsonKey(name: "ext") String ext,@JsonKey(name: "path") String path,@JsonKey(name: "relPath") String relPath,@JsonKey(name: "size") int size,@JsonKey(name: "mtimeMs") int mtimeMs,@JsonKey(name: "ctimeMs") int ctimeMs,@JsonKey(name: "birthtimeMs") int birthtimeMs
});




}
/// @nodoc
class __$LibraryFileMetadataCopyWithImpl<$Res>
    implements _$LibraryFileMetadataCopyWith<$Res> {
  __$LibraryFileMetadataCopyWithImpl(this._self, this._then);

  final _LibraryFileMetadata _self;
  final $Res Function(_LibraryFileMetadata) _then;

/// Create a copy of LibraryFileMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filename = null,Object? ext = null,Object? path = null,Object? relPath = null,Object? size = null,Object? mtimeMs = null,Object? ctimeMs = null,Object? birthtimeMs = null,}) {
  return _then(_LibraryFileMetadata(
filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,ext: null == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,relPath: null == relPath ? _self.relPath : relPath // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,mtimeMs: null == mtimeMs ? _self.mtimeMs : mtimeMs // ignore: cast_nullable_to_non_nullable
as int,ctimeMs: null == ctimeMs ? _self.ctimeMs : ctimeMs // ignore: cast_nullable_to_non_nullable
as int,birthtimeMs: null == birthtimeMs ? _self.birthtimeMs : birthtimeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
