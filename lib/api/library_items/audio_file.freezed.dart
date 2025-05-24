// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioFile {

@JsonKey(name: "index") int? get index;@JsonKey(name: "ino") String get ino;@JsonKey(name: "metadata") LibraryFileMetadata get metadata;@JsonKey(name: "addedAt") int get addedAt;@JsonKey(name: "updatedAt") int? get updatedAt;@JsonKey(name: "trackNumFromMeta") int? get trackNumFromMeta;@JsonKey(name: "discNumFromMeta") int? get discNumFromMeta;@JsonKey(name: "trackNumFromFilename") int? get trackNumFromFilename;@JsonKey(name: "discNumFromFilename") int? get discNumFromFilename;@JsonKey(name: "manuallyVerified") bool? get manuallyVerified;@JsonKey(name: "exclude") bool? get exclude;@JsonKey(name: "error") bool? get error;@JsonKey(name: "format") String? get format;@JsonKey(name: "duration") double? get duration;@JsonKey(name: "bitRate") int? get bitRate;@JsonKey(name: "language") String? get language;@JsonKey(name: "codec") String? get codec;@JsonKey(name: "timeBase") String? get timeBase;@JsonKey(name: "channels") int? get channels;@JsonKey(name: "channelLayout") String? get channelLayout;@JsonKey(name: "chapters") List<Chapter>? get chapters;@JsonKey(name: "embeddedCoverArt") String? get embeddedCoverArt;@JsonKey(name: "metaTags") MetaTags? get metaTags;@JsonKey(name: "mimeType") String? get mimeType;
/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioFileCopyWith<AudioFile> get copyWith => _$AudioFileCopyWithImpl<AudioFile>(this as AudioFile, _$identity);

  /// Serializes this AudioFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioFile&&(identical(other.index, index) || other.index == index)&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.trackNumFromMeta, trackNumFromMeta) || other.trackNumFromMeta == trackNumFromMeta)&&(identical(other.discNumFromMeta, discNumFromMeta) || other.discNumFromMeta == discNumFromMeta)&&(identical(other.trackNumFromFilename, trackNumFromFilename) || other.trackNumFromFilename == trackNumFromFilename)&&(identical(other.discNumFromFilename, discNumFromFilename) || other.discNumFromFilename == discNumFromFilename)&&(identical(other.manuallyVerified, manuallyVerified) || other.manuallyVerified == manuallyVerified)&&(identical(other.exclude, exclude) || other.exclude == exclude)&&(identical(other.error, error) || other.error == error)&&(identical(other.format, format) || other.format == format)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bitRate, bitRate) || other.bitRate == bitRate)&&(identical(other.language, language) || other.language == language)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.timeBase, timeBase) || other.timeBase == timeBase)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.channelLayout, channelLayout) || other.channelLayout == channelLayout)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&(identical(other.embeddedCoverArt, embeddedCoverArt) || other.embeddedCoverArt == embeddedCoverArt)&&(identical(other.metaTags, metaTags) || other.metaTags == metaTags)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,index,ino,metadata,addedAt,updatedAt,trackNumFromMeta,discNumFromMeta,trackNumFromFilename,discNumFromFilename,manuallyVerified,exclude,error,format,duration,bitRate,language,codec,timeBase,channels,channelLayout,const DeepCollectionEquality().hash(chapters),embeddedCoverArt,metaTags,mimeType]);

@override
String toString() {
  return 'AudioFile(index: $index, ino: $ino, metadata: $metadata, addedAt: $addedAt, updatedAt: $updatedAt, trackNumFromMeta: $trackNumFromMeta, discNumFromMeta: $discNumFromMeta, trackNumFromFilename: $trackNumFromFilename, discNumFromFilename: $discNumFromFilename, manuallyVerified: $manuallyVerified, exclude: $exclude, error: $error, format: $format, duration: $duration, bitRate: $bitRate, language: $language, codec: $codec, timeBase: $timeBase, channels: $channels, channelLayout: $channelLayout, chapters: $chapters, embeddedCoverArt: $embeddedCoverArt, metaTags: $metaTags, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class $AudioFileCopyWith<$Res>  {
  factory $AudioFileCopyWith(AudioFile value, $Res Function(AudioFile) _then) = _$AudioFileCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "index") int? index,@JsonKey(name: "ino") String ino,@JsonKey(name: "metadata") LibraryFileMetadata metadata,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "trackNumFromMeta") int? trackNumFromMeta,@JsonKey(name: "discNumFromMeta") int? discNumFromMeta,@JsonKey(name: "trackNumFromFilename") int? trackNumFromFilename,@JsonKey(name: "discNumFromFilename") int? discNumFromFilename,@JsonKey(name: "manuallyVerified") bool? manuallyVerified,@JsonKey(name: "exclude") bool? exclude,@JsonKey(name: "error") bool? error,@JsonKey(name: "format") String? format,@JsonKey(name: "duration") double? duration,@JsonKey(name: "bitRate") int? bitRate,@JsonKey(name: "language") String? language,@JsonKey(name: "codec") String? codec,@JsonKey(name: "timeBase") String? timeBase,@JsonKey(name: "channels") int? channels,@JsonKey(name: "channelLayout") String? channelLayout,@JsonKey(name: "chapters") List<Chapter>? chapters,@JsonKey(name: "embeddedCoverArt") String? embeddedCoverArt,@JsonKey(name: "metaTags") MetaTags? metaTags,@JsonKey(name: "mimeType") String? mimeType
});


$LibraryFileMetadataCopyWith<$Res> get metadata;$MetaTagsCopyWith<$Res>? get metaTags;

}
/// @nodoc
class _$AudioFileCopyWithImpl<$Res>
    implements $AudioFileCopyWith<$Res> {
  _$AudioFileCopyWithImpl(this._self, this._then);

  final AudioFile _self;
  final $Res Function(AudioFile) _then;

/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = freezed,Object? ino = null,Object? metadata = null,Object? addedAt = null,Object? updatedAt = freezed,Object? trackNumFromMeta = freezed,Object? discNumFromMeta = freezed,Object? trackNumFromFilename = freezed,Object? discNumFromFilename = freezed,Object? manuallyVerified = freezed,Object? exclude = freezed,Object? error = freezed,Object? format = freezed,Object? duration = freezed,Object? bitRate = freezed,Object? language = freezed,Object? codec = freezed,Object? timeBase = freezed,Object? channels = freezed,Object? channelLayout = freezed,Object? chapters = freezed,Object? embeddedCoverArt = freezed,Object? metaTags = freezed,Object? mimeType = freezed,}) {
  return _then(_self.copyWith(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,trackNumFromMeta: freezed == trackNumFromMeta ? _self.trackNumFromMeta : trackNumFromMeta // ignore: cast_nullable_to_non_nullable
as int?,discNumFromMeta: freezed == discNumFromMeta ? _self.discNumFromMeta : discNumFromMeta // ignore: cast_nullable_to_non_nullable
as int?,trackNumFromFilename: freezed == trackNumFromFilename ? _self.trackNumFromFilename : trackNumFromFilename // ignore: cast_nullable_to_non_nullable
as int?,discNumFromFilename: freezed == discNumFromFilename ? _self.discNumFromFilename : discNumFromFilename // ignore: cast_nullable_to_non_nullable
as int?,manuallyVerified: freezed == manuallyVerified ? _self.manuallyVerified : manuallyVerified // ignore: cast_nullable_to_non_nullable
as bool?,exclude: freezed == exclude ? _self.exclude : exclude // ignore: cast_nullable_to_non_nullable
as bool?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,bitRate: freezed == bitRate ? _self.bitRate : bitRate // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,timeBase: freezed == timeBase ? _self.timeBase : timeBase // ignore: cast_nullable_to_non_nullable
as String?,channels: freezed == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int?,channelLayout: freezed == channelLayout ? _self.channelLayout : channelLayout // ignore: cast_nullable_to_non_nullable
as String?,chapters: freezed == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>?,embeddedCoverArt: freezed == embeddedCoverArt ? _self.embeddedCoverArt : embeddedCoverArt // ignore: cast_nullable_to_non_nullable
as String?,metaTags: freezed == metaTags ? _self.metaTags : metaTags // ignore: cast_nullable_to_non_nullable
as MetaTags?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res> get metadata {
  
  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaTagsCopyWith<$Res>? get metaTags {
    if (_self.metaTags == null) {
    return null;
  }

  return $MetaTagsCopyWith<$Res>(_self.metaTags!, (value) {
    return _then(_self.copyWith(metaTags: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AudioFile extends AudioFile {
  const _AudioFile({@JsonKey(name: "index") this.index, @JsonKey(name: "ino") required this.ino, @JsonKey(name: "metadata") required this.metadata, @JsonKey(name: "addedAt") required this.addedAt, @JsonKey(name: "updatedAt") this.updatedAt, @JsonKey(name: "trackNumFromMeta") this.trackNumFromMeta, @JsonKey(name: "discNumFromMeta") this.discNumFromMeta, @JsonKey(name: "trackNumFromFilename") this.trackNumFromFilename, @JsonKey(name: "discNumFromFilename") this.discNumFromFilename, @JsonKey(name: "manuallyVerified") this.manuallyVerified, @JsonKey(name: "exclude") this.exclude, @JsonKey(name: "error") this.error, @JsonKey(name: "format") this.format, @JsonKey(name: "duration") this.duration, @JsonKey(name: "bitRate") this.bitRate, @JsonKey(name: "language") this.language, @JsonKey(name: "codec") this.codec, @JsonKey(name: "timeBase") this.timeBase, @JsonKey(name: "channels") this.channels, @JsonKey(name: "channelLayout") this.channelLayout, @JsonKey(name: "chapters") final  List<Chapter>? chapters, @JsonKey(name: "embeddedCoverArt") this.embeddedCoverArt, @JsonKey(name: "metaTags") this.metaTags, @JsonKey(name: "mimeType") this.mimeType}): _chapters = chapters,super._();
  factory _AudioFile.fromJson(Map<String, dynamic> json) => _$AudioFileFromJson(json);

@override@JsonKey(name: "index") final  int? index;
@override@JsonKey(name: "ino") final  String ino;
@override@JsonKey(name: "metadata") final  LibraryFileMetadata metadata;
@override@JsonKey(name: "addedAt") final  int addedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;
@override@JsonKey(name: "trackNumFromMeta") final  int? trackNumFromMeta;
@override@JsonKey(name: "discNumFromMeta") final  int? discNumFromMeta;
@override@JsonKey(name: "trackNumFromFilename") final  int? trackNumFromFilename;
@override@JsonKey(name: "discNumFromFilename") final  int? discNumFromFilename;
@override@JsonKey(name: "manuallyVerified") final  bool? manuallyVerified;
@override@JsonKey(name: "exclude") final  bool? exclude;
@override@JsonKey(name: "error") final  bool? error;
@override@JsonKey(name: "format") final  String? format;
@override@JsonKey(name: "duration") final  double? duration;
@override@JsonKey(name: "bitRate") final  int? bitRate;
@override@JsonKey(name: "language") final  String? language;
@override@JsonKey(name: "codec") final  String? codec;
@override@JsonKey(name: "timeBase") final  String? timeBase;
@override@JsonKey(name: "channels") final  int? channels;
@override@JsonKey(name: "channelLayout") final  String? channelLayout;
 final  List<Chapter>? _chapters;
@override@JsonKey(name: "chapters") List<Chapter>? get chapters {
  final value = _chapters;
  if (value == null) return null;
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "embeddedCoverArt") final  String? embeddedCoverArt;
@override@JsonKey(name: "metaTags") final  MetaTags? metaTags;
@override@JsonKey(name: "mimeType") final  String? mimeType;

/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioFileCopyWith<_AudioFile> get copyWith => __$AudioFileCopyWithImpl<_AudioFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioFile&&(identical(other.index, index) || other.index == index)&&(identical(other.ino, ino) || other.ino == ino)&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.trackNumFromMeta, trackNumFromMeta) || other.trackNumFromMeta == trackNumFromMeta)&&(identical(other.discNumFromMeta, discNumFromMeta) || other.discNumFromMeta == discNumFromMeta)&&(identical(other.trackNumFromFilename, trackNumFromFilename) || other.trackNumFromFilename == trackNumFromFilename)&&(identical(other.discNumFromFilename, discNumFromFilename) || other.discNumFromFilename == discNumFromFilename)&&(identical(other.manuallyVerified, manuallyVerified) || other.manuallyVerified == manuallyVerified)&&(identical(other.exclude, exclude) || other.exclude == exclude)&&(identical(other.error, error) || other.error == error)&&(identical(other.format, format) || other.format == format)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bitRate, bitRate) || other.bitRate == bitRate)&&(identical(other.language, language) || other.language == language)&&(identical(other.codec, codec) || other.codec == codec)&&(identical(other.timeBase, timeBase) || other.timeBase == timeBase)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.channelLayout, channelLayout) || other.channelLayout == channelLayout)&&const DeepCollectionEquality().equals(other._chapters, _chapters)&&(identical(other.embeddedCoverArt, embeddedCoverArt) || other.embeddedCoverArt == embeddedCoverArt)&&(identical(other.metaTags, metaTags) || other.metaTags == metaTags)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,index,ino,metadata,addedAt,updatedAt,trackNumFromMeta,discNumFromMeta,trackNumFromFilename,discNumFromFilename,manuallyVerified,exclude,error,format,duration,bitRate,language,codec,timeBase,channels,channelLayout,const DeepCollectionEquality().hash(_chapters),embeddedCoverArt,metaTags,mimeType]);

@override
String toString() {
  return 'AudioFile(index: $index, ino: $ino, metadata: $metadata, addedAt: $addedAt, updatedAt: $updatedAt, trackNumFromMeta: $trackNumFromMeta, discNumFromMeta: $discNumFromMeta, trackNumFromFilename: $trackNumFromFilename, discNumFromFilename: $discNumFromFilename, manuallyVerified: $manuallyVerified, exclude: $exclude, error: $error, format: $format, duration: $duration, bitRate: $bitRate, language: $language, codec: $codec, timeBase: $timeBase, channels: $channels, channelLayout: $channelLayout, chapters: $chapters, embeddedCoverArt: $embeddedCoverArt, metaTags: $metaTags, mimeType: $mimeType)';
}


}

/// @nodoc
abstract mixin class _$AudioFileCopyWith<$Res> implements $AudioFileCopyWith<$Res> {
  factory _$AudioFileCopyWith(_AudioFile value, $Res Function(_AudioFile) _then) = __$AudioFileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "index") int? index,@JsonKey(name: "ino") String ino,@JsonKey(name: "metadata") LibraryFileMetadata metadata,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "trackNumFromMeta") int? trackNumFromMeta,@JsonKey(name: "discNumFromMeta") int? discNumFromMeta,@JsonKey(name: "trackNumFromFilename") int? trackNumFromFilename,@JsonKey(name: "discNumFromFilename") int? discNumFromFilename,@JsonKey(name: "manuallyVerified") bool? manuallyVerified,@JsonKey(name: "exclude") bool? exclude,@JsonKey(name: "error") bool? error,@JsonKey(name: "format") String? format,@JsonKey(name: "duration") double? duration,@JsonKey(name: "bitRate") int? bitRate,@JsonKey(name: "language") String? language,@JsonKey(name: "codec") String? codec,@JsonKey(name: "timeBase") String? timeBase,@JsonKey(name: "channels") int? channels,@JsonKey(name: "channelLayout") String? channelLayout,@JsonKey(name: "chapters") List<Chapter>? chapters,@JsonKey(name: "embeddedCoverArt") String? embeddedCoverArt,@JsonKey(name: "metaTags") MetaTags? metaTags,@JsonKey(name: "mimeType") String? mimeType
});


@override $LibraryFileMetadataCopyWith<$Res> get metadata;@override $MetaTagsCopyWith<$Res>? get metaTags;

}
/// @nodoc
class __$AudioFileCopyWithImpl<$Res>
    implements _$AudioFileCopyWith<$Res> {
  __$AudioFileCopyWithImpl(this._self, this._then);

  final _AudioFile _self;
  final $Res Function(_AudioFile) _then;

/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? ino = null,Object? metadata = null,Object? addedAt = null,Object? updatedAt = freezed,Object? trackNumFromMeta = freezed,Object? discNumFromMeta = freezed,Object? trackNumFromFilename = freezed,Object? discNumFromFilename = freezed,Object? manuallyVerified = freezed,Object? exclude = freezed,Object? error = freezed,Object? format = freezed,Object? duration = freezed,Object? bitRate = freezed,Object? language = freezed,Object? codec = freezed,Object? timeBase = freezed,Object? channels = freezed,Object? channelLayout = freezed,Object? chapters = freezed,Object? embeddedCoverArt = freezed,Object? metaTags = freezed,Object? mimeType = freezed,}) {
  return _then(_AudioFile(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,ino: null == ino ? _self.ino : ino // ignore: cast_nullable_to_non_nullable
as String,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,trackNumFromMeta: freezed == trackNumFromMeta ? _self.trackNumFromMeta : trackNumFromMeta // ignore: cast_nullable_to_non_nullable
as int?,discNumFromMeta: freezed == discNumFromMeta ? _self.discNumFromMeta : discNumFromMeta // ignore: cast_nullable_to_non_nullable
as int?,trackNumFromFilename: freezed == trackNumFromFilename ? _self.trackNumFromFilename : trackNumFromFilename // ignore: cast_nullable_to_non_nullable
as int?,discNumFromFilename: freezed == discNumFromFilename ? _self.discNumFromFilename : discNumFromFilename // ignore: cast_nullable_to_non_nullable
as int?,manuallyVerified: freezed == manuallyVerified ? _self.manuallyVerified : manuallyVerified // ignore: cast_nullable_to_non_nullable
as bool?,exclude: freezed == exclude ? _self.exclude : exclude // ignore: cast_nullable_to_non_nullable
as bool?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as bool?,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,bitRate: freezed == bitRate ? _self.bitRate : bitRate // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,codec: freezed == codec ? _self.codec : codec // ignore: cast_nullable_to_non_nullable
as String?,timeBase: freezed == timeBase ? _self.timeBase : timeBase // ignore: cast_nullable_to_non_nullable
as String?,channels: freezed == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int?,channelLayout: freezed == channelLayout ? _self.channelLayout : channelLayout // ignore: cast_nullable_to_non_nullable
as String?,chapters: freezed == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>?,embeddedCoverArt: freezed == embeddedCoverArt ? _self.embeddedCoverArt : embeddedCoverArt // ignore: cast_nullable_to_non_nullable
as String?,metaTags: freezed == metaTags ? _self.metaTags : metaTags // ignore: cast_nullable_to_non_nullable
as MetaTags?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res> get metadata {
  
  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}/// Create a copy of AudioFile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetaTagsCopyWith<$Res>? get metaTags {
    if (_self.metaTags == null) {
    return null;
  }

  return $MetaTagsCopyWith<$Res>(_self.metaTags!, (value) {
    return _then(_self.copyWith(metaTags: value));
  });
}
}

// dart format on
