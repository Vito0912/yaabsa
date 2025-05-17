// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Metadata {

 PodcastMetadata? get podcastMetadata; MediaMetadata? get bookMetadata;
/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetadataCopyWith<Metadata> get copyWith => _$MetadataCopyWithImpl<Metadata>(this as Metadata, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Metadata&&(identical(other.podcastMetadata, podcastMetadata) || other.podcastMetadata == podcastMetadata)&&(identical(other.bookMetadata, bookMetadata) || other.bookMetadata == bookMetadata));
}


@override
int get hashCode => Object.hash(runtimeType,podcastMetadata,bookMetadata);

@override
String toString() {
  return 'Metadata(podcastMetadata: $podcastMetadata, bookMetadata: $bookMetadata)';
}


}

/// @nodoc
abstract mixin class $MetadataCopyWith<$Res>  {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) _then) = _$MetadataCopyWithImpl;
@useResult
$Res call({
 PodcastMetadata? podcastMetadata, MediaMetadata? bookMetadata
});


$PodcastMetadataCopyWith<$Res>? get podcastMetadata;$MediaMetadataCopyWith<$Res>? get bookMetadata;

}
/// @nodoc
class _$MetadataCopyWithImpl<$Res>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._self, this._then);

  final Metadata _self;
  final $Res Function(Metadata) _then;

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcastMetadata = freezed,Object? bookMetadata = freezed,}) {
  return _then(_self.copyWith(
podcastMetadata: freezed == podcastMetadata ? _self.podcastMetadata : podcastMetadata // ignore: cast_nullable_to_non_nullable
as PodcastMetadata?,bookMetadata: freezed == bookMetadata ? _self.bookMetadata : bookMetadata // ignore: cast_nullable_to_non_nullable
as MediaMetadata?,
  ));
}
/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<$Res>? get podcastMetadata {
    if (_self.podcastMetadata == null) {
    return null;
  }

  return $PodcastMetadataCopyWith<$Res>(_self.podcastMetadata!, (value) {
    return _then(_self.copyWith(podcastMetadata: value));
  });
}/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaMetadataCopyWith<$Res>? get bookMetadata {
    if (_self.bookMetadata == null) {
    return null;
  }

  return $MediaMetadataCopyWith<$Res>(_self.bookMetadata!, (value) {
    return _then(_self.copyWith(bookMetadata: value));
  });
}
}


/// @nodoc


class _Metadata extends Metadata {
  const _Metadata({this.podcastMetadata, this.bookMetadata}): super._();
  

@override final  PodcastMetadata? podcastMetadata;
@override final  MediaMetadata? bookMetadata;

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetadataCopyWith<_Metadata> get copyWith => __$MetadataCopyWithImpl<_Metadata>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Metadata&&(identical(other.podcastMetadata, podcastMetadata) || other.podcastMetadata == podcastMetadata)&&(identical(other.bookMetadata, bookMetadata) || other.bookMetadata == bookMetadata));
}


@override
int get hashCode => Object.hash(runtimeType,podcastMetadata,bookMetadata);

@override
String toString() {
  return 'Metadata(podcastMetadata: $podcastMetadata, bookMetadata: $bookMetadata)';
}


}

/// @nodoc
abstract mixin class _$MetadataCopyWith<$Res> implements $MetadataCopyWith<$Res> {
  factory _$MetadataCopyWith(_Metadata value, $Res Function(_Metadata) _then) = __$MetadataCopyWithImpl;
@override @useResult
$Res call({
 PodcastMetadata? podcastMetadata, MediaMetadata? bookMetadata
});


@override $PodcastMetadataCopyWith<$Res>? get podcastMetadata;@override $MediaMetadataCopyWith<$Res>? get bookMetadata;

}
/// @nodoc
class __$MetadataCopyWithImpl<$Res>
    implements _$MetadataCopyWith<$Res> {
  __$MetadataCopyWithImpl(this._self, this._then);

  final _Metadata _self;
  final $Res Function(_Metadata) _then;

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastMetadata = freezed,Object? bookMetadata = freezed,}) {
  return _then(_Metadata(
podcastMetadata: freezed == podcastMetadata ? _self.podcastMetadata : podcastMetadata // ignore: cast_nullable_to_non_nullable
as PodcastMetadata?,bookMetadata: freezed == bookMetadata ? _self.bookMetadata : bookMetadata // ignore: cast_nullable_to_non_nullable
as MediaMetadata?,
  ));
}

/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<$Res>? get podcastMetadata {
    if (_self.podcastMetadata == null) {
    return null;
  }

  return $PodcastMetadataCopyWith<$Res>(_self.podcastMetadata!, (value) {
    return _then(_self.copyWith(podcastMetadata: value));
  });
}/// Create a copy of Metadata
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaMetadataCopyWith<$Res>? get bookMetadata {
    if (_self.bookMetadata == null) {
    return null;
  }

  return $MediaMetadataCopyWith<$Res>(_self.bookMetadata!, (value) {
    return _then(_self.copyWith(bookMetadata: value));
  });
}
}

// dart format on
