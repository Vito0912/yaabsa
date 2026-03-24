// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryFile {

@JsonKey(name: "ino") String get ino;@JsonKey(name: "metadata") LibraryFileMetadata get metadata;@JsonKey(name: "isSupplementary") bool? get isSupplementary;@JsonKey(name: "addedAt") int get addedAt;@JsonKey(name: "updatedAt") int? get updatedAt;@JsonKey(name: "fileType") String? get fileType;
/// Create a copy of LibraryFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryFileCopyWith<LibraryFile> get copyWith => _$LibraryFileCopyWithImpl<LibraryFile>(this as LibraryFile, _$identity);

  /// Serializes this LibraryFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryFile&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.isSupplementary, isSupplementary) || other.isSupplementary == isSupplementary)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.fileType, fileType) || other.fileType == fileType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ino,metadata,isSupplementary,addedAt,updatedAt,fileType);

@override
String toString() {
  return 'LibraryFile(ino: $ino, metadata: $metadata, isSupplementary: $isSupplementary, addedAt: $addedAt, updatedAt: $updatedAt, fileType: $fileType)';
}


}

/// @nodoc
abstract mixin class $LibraryFileCopyWith<$Res>  {
  factory $LibraryFileCopyWith(LibraryFile value, $Res Function(LibraryFile) _then) = _$LibraryFileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "ino") String ino,@JsonKey(name: "metadata") LibraryFileMetadata metadata,@JsonKey(name: "isSupplementary") bool? isSupplementary,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "fileType") String? fileType
});


$LibraryFileMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$LibraryFileCopyWithImpl<$Res>
    implements $LibraryFileCopyWith<$Res> {
  _$LibraryFileCopyWithImpl(this._self, this._then);

  final LibraryFile _self;
  final $Res Function(LibraryFile) _then;

/// Create a copy of LibraryFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ino = null,Object? metadata = null,Object? isSupplementary = freezed,Object? addedAt = null,Object? updatedAt = freezed,Object? fileType = freezed,}) {
  return _then(_self.copyWith(
ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata,isSupplementary: freezed == isSupplementary ? _self.isSupplementary : isSupplementary // ignore: cast_nullable_to_non_nullable
as bool?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of LibraryFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res> get metadata {
  
  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [LibraryFile].
extension LibraryFilePatterns on LibraryFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryFile value)  $default,){
final _that = this;
switch (_that) {
case _LibraryFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryFile value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "ino")  String ino, @JsonKey(name: "metadata")  LibraryFileMetadata metadata, @JsonKey(name: "isSupplementary")  bool? isSupplementary, @JsonKey(name: "addedAt")  int addedAt, @JsonKey(name: "updatedAt")  int? updatedAt, @JsonKey(name: "fileType")  String? fileType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryFile() when $default != null:
return $default(_that.ino,_that.metadata,_that.isSupplementary,_that.addedAt,_that.updatedAt,_that.fileType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "ino")  String ino, @JsonKey(name: "metadata")  LibraryFileMetadata metadata, @JsonKey(name: "isSupplementary")  bool? isSupplementary, @JsonKey(name: "addedAt")  int addedAt, @JsonKey(name: "updatedAt")  int? updatedAt, @JsonKey(name: "fileType")  String? fileType)  $default,) {final _that = this;
switch (_that) {
case _LibraryFile():
return $default(_that.ino,_that.metadata,_that.isSupplementary,_that.addedAt,_that.updatedAt,_that.fileType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "ino")  String ino, @JsonKey(name: "metadata")  LibraryFileMetadata metadata, @JsonKey(name: "isSupplementary")  bool? isSupplementary, @JsonKey(name: "addedAt")  int addedAt, @JsonKey(name: "updatedAt")  int? updatedAt, @JsonKey(name: "fileType")  String? fileType)?  $default,) {final _that = this;
switch (_that) {
case _LibraryFile() when $default != null:
return $default(_that.ino,_that.metadata,_that.isSupplementary,_that.addedAt,_that.updatedAt,_that.fileType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryFile implements LibraryFile {
  const _LibraryFile({@JsonKey(name: "ino") required this.ino, @JsonKey(name: "metadata") required this.metadata, @JsonKey(name: "isSupplementary") this.isSupplementary, @JsonKey(name: "addedAt") required this.addedAt, @JsonKey(name: "updatedAt") this.updatedAt, @JsonKey(name: "fileType") this.fileType});
  factory _LibraryFile.fromJson(Map<String, dynamic> json) => _$LibraryFileFromJson(json);

@override@JsonKey(name: "ino") final  String ino;
@override@JsonKey(name: "metadata") final  LibraryFileMetadata metadata;
@override@JsonKey(name: "isSupplementary") final  bool? isSupplementary;
@override@JsonKey(name: "addedAt") final  int addedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;
@override@JsonKey(name: "fileType") final  String? fileType;

/// Create a copy of LibraryFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryFileCopyWith<_LibraryFile> get copyWith => __$LibraryFileCopyWithImpl<_LibraryFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryFile&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.isSupplementary, isSupplementary) || other.isSupplementary == isSupplementary)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.fileType, fileType) || other.fileType == fileType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ino,metadata,isSupplementary,addedAt,updatedAt,fileType);

@override
String toString() {
  return 'LibraryFile(ino: $ino, metadata: $metadata, isSupplementary: $isSupplementary, addedAt: $addedAt, updatedAt: $updatedAt, fileType: $fileType)';
}


}

/// @nodoc
abstract mixin class _$LibraryFileCopyWith<$Res> implements $LibraryFileCopyWith<$Res> {
  factory _$LibraryFileCopyWith(_LibraryFile value, $Res Function(_LibraryFile) _then) = __$LibraryFileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "ino") String ino,@JsonKey(name: "metadata") LibraryFileMetadata metadata,@JsonKey(name: "isSupplementary") bool? isSupplementary,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "fileType") String? fileType
});


@override $LibraryFileMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$LibraryFileCopyWithImpl<$Res>
    implements _$LibraryFileCopyWith<$Res> {
  __$LibraryFileCopyWithImpl(this._self, this._then);

  final _LibraryFile _self;
  final $Res Function(_LibraryFile) _then;

/// Create a copy of LibraryFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ino = null,Object? metadata = null,Object? isSupplementary = freezed,Object? addedAt = null,Object? updatedAt = freezed,Object? fileType = freezed,}) {
  return _then(_LibraryFile(
ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata,isSupplementary: freezed == isSupplementary ? _self.isSupplementary : isSupplementary // ignore: cast_nullable_to_non_nullable
as bool?,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,fileType: freezed == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of LibraryFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res> get metadata {
  
  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
