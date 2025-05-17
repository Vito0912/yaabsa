// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PodcastMetadata {

@JsonKey(name: "title") String? get title;@JsonKey(name: "author") String? get author;@JsonKey(name: "description") String? get description;@JsonKey(name: "releaseDate") String? get releaseDate;@JsonKey(name: "genres") List<String>? get genres;@JsonKey(name: "feedUrl") String? get feedUrl;@JsonKey(name: "imageUrl") String? get imageUrl;@JsonKey(name: "itunesPageUrl") String? get itunesPageUrl;@JsonKey(name: "itunesId") String? get itunesId;@JsonKey(name: "itunesArtistId") String? get itunesArtistId;@JsonKey(name: "explicit") bool? get explicit;@JsonKey(name: "language") String? get language;@JsonKey(name: "type") String? get type;@JsonKey(name: "titleIgnorePrefix") String? get titleIgnorePrefix;
/// Create a copy of PodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<PodcastMetadata> get copyWith => _$PodcastMetadataCopyWithImpl<PodcastMetadata>(this as PodcastMetadata, _$identity);

  /// Serializes this PodcastMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.itunesPageUrl, itunesPageUrl) || other.itunesPageUrl == itunesPageUrl)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId)&&(identical(other.itunesArtistId, itunesArtistId) || other.itunesArtistId == itunesArtistId)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.language, language) || other.language == language)&&(identical(other.type, type) || other.type == type)&&(identical(other.titleIgnorePrefix, titleIgnorePrefix) || other.titleIgnorePrefix == titleIgnorePrefix));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,releaseDate,const DeepCollectionEquality().hash(genres),feedUrl,imageUrl,itunesPageUrl,itunesId,itunesArtistId,explicit,language,type,titleIgnorePrefix);

@override
String toString() {
  return 'PodcastMetadata(title: $title, author: $author, description: $description, releaseDate: $releaseDate, genres: $genres, feedUrl: $feedUrl, imageUrl: $imageUrl, itunesPageUrl: $itunesPageUrl, itunesId: $itunesId, itunesArtistId: $itunesArtistId, explicit: $explicit, language: $language, type: $type, titleIgnorePrefix: $titleIgnorePrefix)';
}


}

/// @nodoc
abstract mixin class $PodcastMetadataCopyWith<$Res>  {
  factory $PodcastMetadataCopyWith(PodcastMetadata value, $Res Function(PodcastMetadata) _then) = _$PodcastMetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "title") String? title,@JsonKey(name: "author") String? author,@JsonKey(name: "description") String? description,@JsonKey(name: "releaseDate") String? releaseDate,@JsonKey(name: "genres") List<String>? genres,@JsonKey(name: "feedUrl") String? feedUrl,@JsonKey(name: "imageUrl") String? imageUrl,@JsonKey(name: "itunesPageUrl") String? itunesPageUrl,@JsonKey(name: "itunesId") String? itunesId,@JsonKey(name: "itunesArtistId") String? itunesArtistId,@JsonKey(name: "explicit") bool? explicit,@JsonKey(name: "language") String? language,@JsonKey(name: "type") String? type,@JsonKey(name: "titleIgnorePrefix") String? titleIgnorePrefix
});




}
/// @nodoc
class _$PodcastMetadataCopyWithImpl<$Res>
    implements $PodcastMetadataCopyWith<$Res> {
  _$PodcastMetadataCopyWithImpl(this._self, this._then);

  final PodcastMetadata _self;
  final $Res Function(PodcastMetadata) _then;

/// Create a copy of PodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? author = freezed,Object? description = freezed,Object? releaseDate = freezed,Object? genres = freezed,Object? feedUrl = freezed,Object? imageUrl = freezed,Object? itunesPageUrl = freezed,Object? itunesId = freezed,Object? itunesArtistId = freezed,Object? explicit = freezed,Object? language = freezed,Object? type = freezed,Object? titleIgnorePrefix = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesPageUrl: freezed == itunesPageUrl ? _self.itunesPageUrl : itunesPageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,itunesArtistId: freezed == itunesArtistId ? _self.itunesArtistId : itunesArtistId // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,titleIgnorePrefix: freezed == titleIgnorePrefix ? _self.titleIgnorePrefix : titleIgnorePrefix // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PodcastMetadata implements PodcastMetadata {
  const _PodcastMetadata({@JsonKey(name: "title") this.title, @JsonKey(name: "author") this.author, @JsonKey(name: "description") this.description, @JsonKey(name: "releaseDate") this.releaseDate, @JsonKey(name: "genres") final  List<String>? genres, @JsonKey(name: "feedUrl") this.feedUrl, @JsonKey(name: "imageUrl") this.imageUrl, @JsonKey(name: "itunesPageUrl") this.itunesPageUrl, @JsonKey(name: "itunesId") this.itunesId, @JsonKey(name: "itunesArtistId") this.itunesArtistId, @JsonKey(name: "explicit") this.explicit, @JsonKey(name: "language") this.language, @JsonKey(name: "type") this.type, @JsonKey(name: "titleIgnorePrefix") this.titleIgnorePrefix}): _genres = genres;
  factory _PodcastMetadata.fromJson(Map<String, dynamic> json) => _$PodcastMetadataFromJson(json);

@override@JsonKey(name: "title") final  String? title;
@override@JsonKey(name: "author") final  String? author;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "releaseDate") final  String? releaseDate;
 final  List<String>? _genres;
@override@JsonKey(name: "genres") List<String>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "feedUrl") final  String? feedUrl;
@override@JsonKey(name: "imageUrl") final  String? imageUrl;
@override@JsonKey(name: "itunesPageUrl") final  String? itunesPageUrl;
@override@JsonKey(name: "itunesId") final  String? itunesId;
@override@JsonKey(name: "itunesArtistId") final  String? itunesArtistId;
@override@JsonKey(name: "explicit") final  bool? explicit;
@override@JsonKey(name: "language") final  String? language;
@override@JsonKey(name: "type") final  String? type;
@override@JsonKey(name: "titleIgnorePrefix") final  String? titleIgnorePrefix;

/// Create a copy of PodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastMetadataCopyWith<_PodcastMetadata> get copyWith => __$PodcastMetadataCopyWithImpl<_PodcastMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.itunesPageUrl, itunesPageUrl) || other.itunesPageUrl == itunesPageUrl)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId)&&(identical(other.itunesArtistId, itunesArtistId) || other.itunesArtistId == itunesArtistId)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.language, language) || other.language == language)&&(identical(other.type, type) || other.type == type)&&(identical(other.titleIgnorePrefix, titleIgnorePrefix) || other.titleIgnorePrefix == titleIgnorePrefix));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,releaseDate,const DeepCollectionEquality().hash(_genres),feedUrl,imageUrl,itunesPageUrl,itunesId,itunesArtistId,explicit,language,type,titleIgnorePrefix);

@override
String toString() {
  return 'PodcastMetadata(title: $title, author: $author, description: $description, releaseDate: $releaseDate, genres: $genres, feedUrl: $feedUrl, imageUrl: $imageUrl, itunesPageUrl: $itunesPageUrl, itunesId: $itunesId, itunesArtistId: $itunesArtistId, explicit: $explicit, language: $language, type: $type, titleIgnorePrefix: $titleIgnorePrefix)';
}


}

/// @nodoc
abstract mixin class _$PodcastMetadataCopyWith<$Res> implements $PodcastMetadataCopyWith<$Res> {
  factory _$PodcastMetadataCopyWith(_PodcastMetadata value, $Res Function(_PodcastMetadata) _then) = __$PodcastMetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "title") String? title,@JsonKey(name: "author") String? author,@JsonKey(name: "description") String? description,@JsonKey(name: "releaseDate") String? releaseDate,@JsonKey(name: "genres") List<String>? genres,@JsonKey(name: "feedUrl") String? feedUrl,@JsonKey(name: "imageUrl") String? imageUrl,@JsonKey(name: "itunesPageUrl") String? itunesPageUrl,@JsonKey(name: "itunesId") String? itunesId,@JsonKey(name: "itunesArtistId") String? itunesArtistId,@JsonKey(name: "explicit") bool? explicit,@JsonKey(name: "language") String? language,@JsonKey(name: "type") String? type,@JsonKey(name: "titleIgnorePrefix") String? titleIgnorePrefix
});




}
/// @nodoc
class __$PodcastMetadataCopyWithImpl<$Res>
    implements _$PodcastMetadataCopyWith<$Res> {
  __$PodcastMetadataCopyWithImpl(this._self, this._then);

  final _PodcastMetadata _self;
  final $Res Function(_PodcastMetadata) _then;

/// Create a copy of PodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? author = freezed,Object? description = freezed,Object? releaseDate = freezed,Object? genres = freezed,Object? feedUrl = freezed,Object? imageUrl = freezed,Object? itunesPageUrl = freezed,Object? itunesId = freezed,Object? itunesArtistId = freezed,Object? explicit = freezed,Object? language = freezed,Object? type = freezed,Object? titleIgnorePrefix = freezed,}) {
  return _then(_PodcastMetadata(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesPageUrl: freezed == itunesPageUrl ? _self.itunesPageUrl : itunesPageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,itunesArtistId: freezed == itunesArtistId ? _self.itunesArtistId : itunesArtistId // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,titleIgnorePrefix: freezed == titleIgnorePrefix ? _self.titleIgnorePrefix : titleIgnorePrefix // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
