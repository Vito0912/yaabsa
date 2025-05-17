// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Media {

 PodcastMedia? get podcastMedia; BookMedia? get bookMedia;
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaCopyWith<Media> get copyWith => _$MediaCopyWithImpl<Media>(this as Media, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Media&&(identical(other.podcastMedia, podcastMedia) || other.podcastMedia == podcastMedia)&&(identical(other.bookMedia, bookMedia) || other.bookMedia == bookMedia));
}


@override
int get hashCode => Object.hash(runtimeType,podcastMedia,bookMedia);

@override
String toString() {
  return 'Media(podcastMedia: $podcastMedia, bookMedia: $bookMedia)';
}


}

/// @nodoc
abstract mixin class $MediaCopyWith<$Res>  {
  factory $MediaCopyWith(Media value, $Res Function(Media) _then) = _$MediaCopyWithImpl;
@useResult
$Res call({
 PodcastMedia? podcastMedia, BookMedia? bookMedia
});


$PodcastMediaCopyWith<$Res>? get podcastMedia;$BookMediaCopyWith<$Res>? get bookMedia;

}
/// @nodoc
class _$MediaCopyWithImpl<$Res>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._self, this._then);

  final Media _self;
  final $Res Function(Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcastMedia = freezed,Object? bookMedia = freezed,}) {
  return _then(_self.copyWith(
podcastMedia: freezed == podcastMedia ? _self.podcastMedia : podcastMedia // ignore: cast_nullable_to_non_nullable
as PodcastMedia?,bookMedia: freezed == bookMedia ? _self.bookMedia : bookMedia // ignore: cast_nullable_to_non_nullable
as BookMedia?,
  ));
}
/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMediaCopyWith<$Res>? get podcastMedia {
    if (_self.podcastMedia == null) {
    return null;
  }

  return $PodcastMediaCopyWith<$Res>(_self.podcastMedia!, (value) {
    return _then(_self.copyWith(podcastMedia: value));
  });
}/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookMediaCopyWith<$Res>? get bookMedia {
    if (_self.bookMedia == null) {
    return null;
  }

  return $BookMediaCopyWith<$Res>(_self.bookMedia!, (value) {
    return _then(_self.copyWith(bookMedia: value));
  });
}
}


/// @nodoc


class _Media extends Media {
  const _Media({this.podcastMedia, this.bookMedia}): super._();
  

@override final  PodcastMedia? podcastMedia;
@override final  BookMedia? bookMedia;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaCopyWith<_Media> get copyWith => __$MediaCopyWithImpl<_Media>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Media&&(identical(other.podcastMedia, podcastMedia) || other.podcastMedia == podcastMedia)&&(identical(other.bookMedia, bookMedia) || other.bookMedia == bookMedia));
}


@override
int get hashCode => Object.hash(runtimeType,podcastMedia,bookMedia);

@override
String toString() {
  return 'Media(podcastMedia: $podcastMedia, bookMedia: $bookMedia)';
}


}

/// @nodoc
abstract mixin class _$MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$MediaCopyWith(_Media value, $Res Function(_Media) _then) = __$MediaCopyWithImpl;
@override @useResult
$Res call({
 PodcastMedia? podcastMedia, BookMedia? bookMedia
});


@override $PodcastMediaCopyWith<$Res>? get podcastMedia;@override $BookMediaCopyWith<$Res>? get bookMedia;

}
/// @nodoc
class __$MediaCopyWithImpl<$Res>
    implements _$MediaCopyWith<$Res> {
  __$MediaCopyWithImpl(this._self, this._then);

  final _Media _self;
  final $Res Function(_Media) _then;

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcastMedia = freezed,Object? bookMedia = freezed,}) {
  return _then(_Media(
podcastMedia: freezed == podcastMedia ? _self.podcastMedia : podcastMedia // ignore: cast_nullable_to_non_nullable
as PodcastMedia?,bookMedia: freezed == bookMedia ? _self.bookMedia : bookMedia // ignore: cast_nullable_to_non_nullable
as BookMedia?,
  ));
}

/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMediaCopyWith<$Res>? get podcastMedia {
    if (_self.podcastMedia == null) {
    return null;
  }

  return $PodcastMediaCopyWith<$Res>(_self.podcastMedia!, (value) {
    return _then(_self.copyWith(podcastMedia: value));
  });
}/// Create a copy of Media
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BookMediaCopyWith<$Res>? get bookMedia {
    if (_self.bookMedia == null) {
    return null;
  }

  return $BookMediaCopyWith<$Res>(_self.bookMedia!, (value) {
    return _then(_self.copyWith(bookMedia: value));
  });
}
}

// dart format on
