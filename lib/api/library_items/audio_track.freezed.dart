// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioTrack {

@JsonKey(name: "index") int? get index;@JsonKey(name: "startOffset") double get startOffset;@JsonKey(name: "duration") double get duration;@JsonKey(name: "title") String get title;@JsonKey(name: "contentUrl") String get contentUrl;@JsonKey(name: "mimeType") String get mimeType;@JsonKey(name: "metadata") LibraryFileMetadata? get metadata;
/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioTrackCopyWith<AudioTrack> get copyWith => _$AudioTrackCopyWithImpl<AudioTrack>(this as AudioTrack, _$identity);

  /// Serializes this AudioTrack to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioTrack&&(identical(other.index, index) || other.index == index)&&(identical(other.startOffset, startOffset) || other.startOffset == startOffset)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title)&&(identical(other.contentUrl, contentUrl) || other.contentUrl == contentUrl)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,startOffset,duration,title,contentUrl,mimeType,metadata);

@override
String toString() {
  return 'AudioTrack(index: $index, startOffset: $startOffset, duration: $duration, title: $title, contentUrl: $contentUrl, mimeType: $mimeType, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AudioTrackCopyWith<$Res>  {
  factory $AudioTrackCopyWith(AudioTrack value, $Res Function(AudioTrack) _then) = _$AudioTrackCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "index") int? index,@JsonKey(name: "startOffset") double startOffset,@JsonKey(name: "duration") double duration,@JsonKey(name: "title") String title,@JsonKey(name: "contentUrl") String contentUrl,@JsonKey(name: "mimeType") String mimeType,@JsonKey(name: "metadata") LibraryFileMetadata? metadata
});


$LibraryFileMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$AudioTrackCopyWithImpl<$Res>
    implements $AudioTrackCopyWith<$Res> {
  _$AudioTrackCopyWithImpl(this._self, this._then);

  final AudioTrack _self;
  final $Res Function(AudioTrack) _then;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = freezed,Object? startOffset = null,Object? duration = null,Object? title = null,Object? contentUrl = null,Object? mimeType = null,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contentUrl: null == contentUrl ? _self.contentUrl : contentUrl // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata?,
  ));
}
/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AudioTrack extends AudioTrack {
  const _AudioTrack({@JsonKey(name: "index") this.index, @JsonKey(name: "startOffset") required this.startOffset, @JsonKey(name: "duration") required this.duration, @JsonKey(name: "title") required this.title, @JsonKey(name: "contentUrl") required this.contentUrl, @JsonKey(name: "mimeType") required this.mimeType, @JsonKey(name: "metadata") this.metadata}): super._();
  factory _AudioTrack.fromJson(Map<String, dynamic> json) => _$AudioTrackFromJson(json);

@override@JsonKey(name: "index") final  int? index;
@override@JsonKey(name: "startOffset") final  double startOffset;
@override@JsonKey(name: "duration") final  double duration;
@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "contentUrl") final  String contentUrl;
@override@JsonKey(name: "mimeType") final  String mimeType;
@override@JsonKey(name: "metadata") final  LibraryFileMetadata? metadata;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioTrackCopyWith<_AudioTrack> get copyWith => __$AudioTrackCopyWithImpl<_AudioTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioTrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioTrack&&(identical(other.index, index) || other.index == index)&&(identical(other.startOffset, startOffset) || other.startOffset == startOffset)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title)&&(identical(other.contentUrl, contentUrl) || other.contentUrl == contentUrl)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,startOffset,duration,title,contentUrl,mimeType,metadata);

@override
String toString() {
  return 'AudioTrack(index: $index, startOffset: $startOffset, duration: $duration, title: $title, contentUrl: $contentUrl, mimeType: $mimeType, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AudioTrackCopyWith<$Res> implements $AudioTrackCopyWith<$Res> {
  factory _$AudioTrackCopyWith(_AudioTrack value, $Res Function(_AudioTrack) _then) = __$AudioTrackCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "index") int? index,@JsonKey(name: "startOffset") double startOffset,@JsonKey(name: "duration") double duration,@JsonKey(name: "title") String title,@JsonKey(name: "contentUrl") String contentUrl,@JsonKey(name: "mimeType") String mimeType,@JsonKey(name: "metadata") LibraryFileMetadata? metadata
});


@override $LibraryFileMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$AudioTrackCopyWithImpl<$Res>
    implements _$AudioTrackCopyWith<$Res> {
  __$AudioTrackCopyWithImpl(this._self, this._then);

  final _AudioTrack _self;
  final $Res Function(_AudioTrack) _then;

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? startOffset = null,Object? duration = null,Object? title = null,Object? contentUrl = null,Object? mimeType = null,Object? metadata = freezed,}) {
  return _then(_AudioTrack(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,startOffset: null == startOffset ? _self.startOffset : startOffset // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contentUrl: null == contentUrl ? _self.contentUrl : contentUrl // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as LibraryFileMetadata?,
  ));
}

/// Create a copy of AudioTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFileMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $LibraryFileMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
