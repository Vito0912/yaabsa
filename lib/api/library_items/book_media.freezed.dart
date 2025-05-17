// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookMedia {

@JsonKey(name: "id") String get id;@JsonKey(name: "libraryItemId") String? get libraryItemId;@JsonKey(name: "metadata") MediaMetadata get metadata;@JsonKey(name: "coverPath") String? get coverPath;@JsonKey(name: "tags") List<String>? get tags;@JsonKey(name: "audioFiles") List<AudioFile>? get audioFiles;@JsonKey(name: "chapters") List<Chapter>? get chapters;@JsonKey(name: "ebookFile") EbookFile? get ebookFile;@JsonKey(name: "numTracks") int? get numTracks;@JsonKey(name: "numChapters") int? get numChapters;@JsonKey(name: "numAudioFiles") int? get numAudioFiles;@JsonKey(name: "size") int? get size;@JsonKey(name: "ebookFormat") String? get ebookFormat;
/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookMediaCopyWith<BookMedia> get copyWith => _$BookMediaCopyWithImpl<BookMedia>(this as BookMedia, _$identity);

  /// Serializes this BookMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.audioFiles, audioFiles)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&(identical(other.ebookFile, ebookFile) || other.ebookFile == ebookFile)&&(identical(other.numTracks, numTracks) || other.numTracks == numTracks)&&(identical(other.numChapters, numChapters) || other.numChapters == numChapters)&&(identical(other.numAudioFiles, numAudioFiles) || other.numAudioFiles == numAudioFiles)&&(identical(other.size, size) || other.size == size)&&(identical(other.ebookFormat, ebookFormat) || other.ebookFormat == ebookFormat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryItemId,metadata,coverPath,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(audioFiles),const DeepCollectionEquality().hash(chapters),ebookFile,numTracks,numChapters,numAudioFiles,size,ebookFormat);

@override
String toString() {
  return 'BookMedia(id: $id, libraryItemId: $libraryItemId, metadata: $metadata, coverPath: $coverPath, tags: $tags, audioFiles: $audioFiles, chapters: $chapters, ebookFile: $ebookFile, numTracks: $numTracks, numChapters: $numChapters, numAudioFiles: $numAudioFiles, size: $size, ebookFormat: $ebookFormat)';
}


}

/// @nodoc
abstract mixin class $BookMediaCopyWith<$Res>  {
  factory $BookMediaCopyWith(BookMedia value, $Res Function(BookMedia) _then) = _$BookMediaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "libraryItemId") String? libraryItemId,@JsonKey(name: "metadata") MediaMetadata metadata,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "tags") List<String>? tags,@JsonKey(name: "audioFiles") List<AudioFile>? audioFiles,@JsonKey(name: "chapters") List<Chapter>? chapters,@JsonKey(name: "ebookFile") EbookFile? ebookFile,@JsonKey(name: "numTracks") int? numTracks,@JsonKey(name: "numChapters") int? numChapters,@JsonKey(name: "numAudioFiles") int? numAudioFiles,@JsonKey(name: "size") int? size,@JsonKey(name: "ebookFormat") String? ebookFormat
});


$MediaMetadataCopyWith<$Res> get metadata;$EbookFileCopyWith<$Res>? get ebookFile;

}
/// @nodoc
class _$BookMediaCopyWithImpl<$Res>
    implements $BookMediaCopyWith<$Res> {
  _$BookMediaCopyWithImpl(this._self, this._then);

  final BookMedia _self;
  final $Res Function(BookMedia) _then;

/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? libraryItemId = freezed,Object? metadata = null,Object? coverPath = freezed,Object? tags = freezed,Object? audioFiles = freezed,Object? chapters = freezed,Object? ebookFile = freezed,Object? numTracks = freezed,Object? numChapters = freezed,Object? numAudioFiles = freezed,Object? size = freezed,Object? ebookFormat = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as MediaMetadata,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,audioFiles: freezed == audioFiles ? _self.audioFiles : audioFiles // ignore: cast_nullable_to_non_nullable
as List<AudioFile>?,chapters: freezed == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>?,ebookFile: freezed == ebookFile ? _self.ebookFile : ebookFile // ignore: cast_nullable_to_non_nullable
as EbookFile?,numTracks: freezed == numTracks ? _self.numTracks : numTracks // ignore: cast_nullable_to_non_nullable
as int?,numChapters: freezed == numChapters ? _self.numChapters : numChapters // ignore: cast_nullable_to_non_nullable
as int?,numAudioFiles: freezed == numAudioFiles ? _self.numAudioFiles : numAudioFiles // ignore: cast_nullable_to_non_nullable
as int?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,ebookFormat: freezed == ebookFormat ? _self.ebookFormat : ebookFormat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaMetadataCopyWith<$Res> get metadata {
  
  return $MediaMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EbookFileCopyWith<$Res>? get ebookFile {
    if (_self.ebookFile == null) {
    return null;
  }

  return $EbookFileCopyWith<$Res>(_self.ebookFile!, (value) {
    return _then(_self.copyWith(ebookFile: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _BookMedia implements BookMedia {
  const _BookMedia({@JsonKey(name: "id") required this.id, @JsonKey(name: "libraryItemId") this.libraryItemId, @JsonKey(name: "metadata") required this.metadata, @JsonKey(name: "coverPath") this.coverPath, @JsonKey(name: "tags") final  List<String>? tags, @JsonKey(name: "audioFiles") final  List<AudioFile>? audioFiles, @JsonKey(name: "chapters") final  List<Chapter>? chapters, @JsonKey(name: "ebookFile") this.ebookFile, @JsonKey(name: "numTracks") this.numTracks, @JsonKey(name: "numChapters") this.numChapters, @JsonKey(name: "numAudioFiles") this.numAudioFiles, @JsonKey(name: "size") this.size, @JsonKey(name: "ebookFormat") this.ebookFormat}): _tags = tags,_audioFiles = audioFiles,_chapters = chapters;
  factory _BookMedia.fromJson(Map<String, dynamic> json) => _$BookMediaFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "libraryItemId") final  String? libraryItemId;
@override@JsonKey(name: "metadata") final  MediaMetadata metadata;
@override@JsonKey(name: "coverPath") final  String? coverPath;
 final  List<String>? _tags;
@override@JsonKey(name: "tags") List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AudioFile>? _audioFiles;
@override@JsonKey(name: "audioFiles") List<AudioFile>? get audioFiles {
  final value = _audioFiles;
  if (value == null) return null;
  if (_audioFiles is EqualUnmodifiableListView) return _audioFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Chapter>? _chapters;
@override@JsonKey(name: "chapters") List<Chapter>? get chapters {
  final value = _chapters;
  if (value == null) return null;
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "ebookFile") final  EbookFile? ebookFile;
@override@JsonKey(name: "numTracks") final  int? numTracks;
@override@JsonKey(name: "numChapters") final  int? numChapters;
@override@JsonKey(name: "numAudioFiles") final  int? numAudioFiles;
@override@JsonKey(name: "size") final  int? size;
@override@JsonKey(name: "ebookFormat") final  String? ebookFormat;

/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookMediaCopyWith<_BookMedia> get copyWith => __$BookMediaCopyWithImpl<_BookMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookMedia&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._audioFiles, _audioFiles)&&const DeepCollectionEquality().equals(other._chapters, _chapters)&&(identical(other.ebookFile, ebookFile) || other.ebookFile == ebookFile)&&(identical(other.numTracks, numTracks) || other.numTracks == numTracks)&&(identical(other.numChapters, numChapters) || other.numChapters == numChapters)&&(identical(other.numAudioFiles, numAudioFiles) || other.numAudioFiles == numAudioFiles)&&(identical(other.size, size) || other.size == size)&&(identical(other.ebookFormat, ebookFormat) || other.ebookFormat == ebookFormat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryItemId,metadata,coverPath,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_audioFiles),const DeepCollectionEquality().hash(_chapters),ebookFile,numTracks,numChapters,numAudioFiles,size,ebookFormat);

@override
String toString() {
  return 'BookMedia(id: $id, libraryItemId: $libraryItemId, metadata: $metadata, coverPath: $coverPath, tags: $tags, audioFiles: $audioFiles, chapters: $chapters, ebookFile: $ebookFile, numTracks: $numTracks, numChapters: $numChapters, numAudioFiles: $numAudioFiles, size: $size, ebookFormat: $ebookFormat)';
}


}

/// @nodoc
abstract mixin class _$BookMediaCopyWith<$Res> implements $BookMediaCopyWith<$Res> {
  factory _$BookMediaCopyWith(_BookMedia value, $Res Function(_BookMedia) _then) = __$BookMediaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "libraryItemId") String? libraryItemId,@JsonKey(name: "metadata") MediaMetadata metadata,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "tags") List<String>? tags,@JsonKey(name: "audioFiles") List<AudioFile>? audioFiles,@JsonKey(name: "chapters") List<Chapter>? chapters,@JsonKey(name: "ebookFile") EbookFile? ebookFile,@JsonKey(name: "numTracks") int? numTracks,@JsonKey(name: "numChapters") int? numChapters,@JsonKey(name: "numAudioFiles") int? numAudioFiles,@JsonKey(name: "size") int? size,@JsonKey(name: "ebookFormat") String? ebookFormat
});


@override $MediaMetadataCopyWith<$Res> get metadata;@override $EbookFileCopyWith<$Res>? get ebookFile;

}
/// @nodoc
class __$BookMediaCopyWithImpl<$Res>
    implements _$BookMediaCopyWith<$Res> {
  __$BookMediaCopyWithImpl(this._self, this._then);

  final _BookMedia _self;
  final $Res Function(_BookMedia) _then;

/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? libraryItemId = freezed,Object? metadata = null,Object? coverPath = freezed,Object? tags = freezed,Object? audioFiles = freezed,Object? chapters = freezed,Object? ebookFile = freezed,Object? numTracks = freezed,Object? numChapters = freezed,Object? numAudioFiles = freezed,Object? size = freezed,Object? ebookFormat = freezed,}) {
  return _then(_BookMedia(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as MediaMetadata,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,audioFiles: freezed == audioFiles ? _self._audioFiles : audioFiles // ignore: cast_nullable_to_non_nullable
as List<AudioFile>?,chapters: freezed == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>?,ebookFile: freezed == ebookFile ? _self.ebookFile : ebookFile // ignore: cast_nullable_to_non_nullable
as EbookFile?,numTracks: freezed == numTracks ? _self.numTracks : numTracks // ignore: cast_nullable_to_non_nullable
as int?,numChapters: freezed == numChapters ? _self.numChapters : numChapters // ignore: cast_nullable_to_non_nullable
as int?,numAudioFiles: freezed == numAudioFiles ? _self.numAudioFiles : numAudioFiles // ignore: cast_nullable_to_non_nullable
as int?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,ebookFormat: freezed == ebookFormat ? _self.ebookFormat : ebookFormat // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaMetadataCopyWith<$Res> get metadata {
  
  return $MediaMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}/// Create a copy of BookMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EbookFileCopyWith<$Res>? get ebookFile {
    if (_self.ebookFile == null) {
    return null;
  }

  return $EbookFileCopyWith<$Res>(_self.ebookFile!, (value) {
    return _then(_self.copyWith(ebookFile: value));
  });
}
}

// dart format on
