// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ebook_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EbookFile {

@JsonKey(name: "ino") String get ino;@JsonKey(name: "metadata") LibraryFileMetadata get metadata;@JsonKey(name: "ebookFormat") String get ebookFormat;@JsonKey(name: "addedAt") int get addedAt;@JsonKey(name: "updatedAt") int? get updatedAt;
/// Create a copy of EbookFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EbookFileCopyWith<EbookFile> get copyWith => _$EbookFileCopyWithImpl<EbookFile>(this as EbookFile, _$identity);

  /// Serializes this EbookFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EbookFile&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.ebookFormat, ebookFormat) || other.ebookFormat == ebookFormat)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ino,metadata,ebookFormat,addedAt,updatedAt);

@override
String toString() {
  return 'EbookFile(ino: $ino, metadata: $metadata, ebookFormat: $ebookFormat, addedAt: $addedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EbookFileCopyWith<$Res>  {
  factory $EbookFileCopyWith(EbookFile value, $Res Function(EbookFile) _then) = _$EbookFileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "ino") String ino,@JsonKey(name: "metadata") LibraryFileMetadata metadata,@JsonKey(name: "ebookFormat") String ebookFormat,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int? updatedAt
});


$LibraryFileMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$EbookFileCopyWithImpl<$Res>
    implements $EbookFileCopyWith<$Res> {
  _$EbookFileCopyWithImpl(this._self, this._then);

  final EbookFile _self;
  final $Res Function(EbookFile) _then;

/// Create a copy of EbookFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ino = null,Object? metadata = null,Object? ebookFormat = null,Object? addedAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata,ebookFormat: null == ebookFormat ? _self.ebookFormat : ebookFormat // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of EbookFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res> get metadata {
  
  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _EbookFile implements EbookFile {
  const _EbookFile({@JsonKey(name: "ino") required this.ino, @JsonKey(name: "metadata") required this.metadata, @JsonKey(name: "ebookFormat") required this.ebookFormat, @JsonKey(name: "addedAt") required this.addedAt, @JsonKey(name: "updatedAt") this.updatedAt});
  factory _EbookFile.fromJson(Map<String, dynamic> json) => _$EbookFileFromJson(json);

@override@JsonKey(name: "ino") final  String ino;
@override@JsonKey(name: "metadata") final  LibraryFileMetadata metadata;
@override@JsonKey(name: "ebookFormat") final  String ebookFormat;
@override@JsonKey(name: "addedAt") final  int addedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;

/// Create a copy of EbookFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EbookFileCopyWith<_EbookFile> get copyWith => __$EbookFileCopyWithImpl<_EbookFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EbookFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EbookFile&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.ebookFormat, ebookFormat) || other.ebookFormat == ebookFormat)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ino,metadata,ebookFormat,addedAt,updatedAt);

@override
String toString() {
  return 'EbookFile(ino: $ino, metadata: $metadata, ebookFormat: $ebookFormat, addedAt: $addedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EbookFileCopyWith<$Res> implements $EbookFileCopyWith<$Res> {
  factory _$EbookFileCopyWith(_EbookFile value, $Res Function(_EbookFile) _then) = __$EbookFileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "ino") String ino,@JsonKey(name: "metadata") LibraryFileMetadata metadata,@JsonKey(name: "ebookFormat") String ebookFormat,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int? updatedAt
});


@override $LibraryFileMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$EbookFileCopyWithImpl<$Res>
    implements _$EbookFileCopyWith<$Res> {
  __$EbookFileCopyWithImpl(this._self, this._then);

  final _EbookFile _self;
  final $Res Function(_EbookFile) _then;

/// Create a copy of EbookFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ino = null,Object? metadata = null,Object? ebookFormat = null,Object? addedAt = null,Object? updatedAt = freezed,}) {
  return _then(_EbookFile(
ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata,ebookFormat: null == ebookFormat ? _self.ebookFormat : ebookFormat // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of EbookFile
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
