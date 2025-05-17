// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaMetadata {

@JsonKey(name: "title") String get title;@JsonKey(name: "subtitle") String? get subtitle;@JsonKey(name: "authors") List<Author>? get authors;@JsonKey(name: "narrators") List<String>? get narrators;@JsonKey(name: "series")@SeriesConverter() List<Series>? get series;@JsonKey(name: "genres") List<String>? get genres;@JsonKey(name: "publishedYear") String? get publishedYear;@JsonKey(name: "publishedDate") String? get publishedDate;@JsonKey(name: "publisher") String? get publisher;@JsonKey(name: "description") String? get description;@JsonKey(name: "isbn") String? get isbn;@JsonKey(name: "asin") String? get asin;@JsonKey(name: "language") String? get language;@JsonKey(name: "explicit") bool? get explicit;@JsonKey(name: "abridged") bool? get abridged;
/// Create a copy of MediaMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaMetadataCopyWith<MediaMetadata> get copyWith => _$MediaMetadataCopyWithImpl<MediaMetadata>(this as MediaMetadata, _$identity);

  /// Serializes this MediaMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other.authors, authors)&&const DeepCollectionEquality().equals(other.narrators, narrators)&&const DeepCollectionEquality().equals(other.series, series)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.description, description) || other.description == description)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.abridged, abridged) || other.abridged == abridged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle,const DeepCollectionEquality().hash(authors),const DeepCollectionEquality().hash(narrators),const DeepCollectionEquality().hash(series),const DeepCollectionEquality().hash(genres),publishedYear,publishedDate,publisher,description,isbn,asin,language,explicit,abridged);

@override
String toString() {
  return 'MediaMetadata(title: $title, subtitle: $subtitle, authors: $authors, narrators: $narrators, series: $series, genres: $genres, publishedYear: $publishedYear, publishedDate: $publishedDate, publisher: $publisher, description: $description, isbn: $isbn, asin: $asin, language: $language, explicit: $explicit, abridged: $abridged)';
}


}

/// @nodoc
abstract mixin class $MediaMetadataCopyWith<$Res>  {
  factory $MediaMetadataCopyWith(MediaMetadata value, $Res Function(MediaMetadata) _then) = _$MediaMetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "title") String title,@JsonKey(name: "subtitle") String? subtitle,@JsonKey(name: "authors") List<Author>? authors,@JsonKey(name: "narrators") List<String>? narrators,@JsonKey(name: "series")@SeriesConverter() List<Series>? series,@JsonKey(name: "genres") List<String>? genres,@JsonKey(name: "publishedYear") String? publishedYear,@JsonKey(name: "publishedDate") String? publishedDate,@JsonKey(name: "publisher") String? publisher,@JsonKey(name: "description") String? description,@JsonKey(name: "isbn") String? isbn,@JsonKey(name: "asin") String? asin,@JsonKey(name: "language") String? language,@JsonKey(name: "explicit") bool? explicit,@JsonKey(name: "abridged") bool? abridged
});




}
/// @nodoc
class _$MediaMetadataCopyWithImpl<$Res>
    implements $MediaMetadataCopyWith<$Res> {
  _$MediaMetadataCopyWithImpl(this._self, this._then);

  final MediaMetadata _self;
  final $Res Function(MediaMetadata) _then;

/// Create a copy of MediaMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? subtitle = freezed,Object? authors = freezed,Object? narrators = freezed,Object? series = freezed,Object? genres = freezed,Object? publishedYear = freezed,Object? publishedDate = freezed,Object? publisher = freezed,Object? description = freezed,Object? isbn = freezed,Object? asin = freezed,Object? language = freezed,Object? explicit = freezed,Object? abridged = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: freezed == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<Author>?,narrators: freezed == narrators ? _self.narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<String>?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<Series>?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,abridged: freezed == abridged ? _self.abridged : abridged // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MediaMetadata implements MediaMetadata {
  const _MediaMetadata({@JsonKey(name: "title") required this.title, @JsonKey(name: "subtitle") this.subtitle, @JsonKey(name: "authors") final  List<Author>? authors, @JsonKey(name: "narrators") final  List<String>? narrators, @JsonKey(name: "series")@SeriesConverter() final  List<Series>? series, @JsonKey(name: "genres") final  List<String>? genres, @JsonKey(name: "publishedYear") this.publishedYear, @JsonKey(name: "publishedDate") this.publishedDate, @JsonKey(name: "publisher") this.publisher, @JsonKey(name: "description") this.description, @JsonKey(name: "isbn") this.isbn, @JsonKey(name: "asin") this.asin, @JsonKey(name: "language") this.language, @JsonKey(name: "explicit") this.explicit, @JsonKey(name: "abridged") this.abridged}): _authors = authors,_narrators = narrators,_series = series,_genres = genres;
  factory _MediaMetadata.fromJson(Map<String, dynamic> json) => _$MediaMetadataFromJson(json);

@override@JsonKey(name: "title") final  String title;
@override@JsonKey(name: "subtitle") final  String? subtitle;
 final  List<Author>? _authors;
@override@JsonKey(name: "authors") List<Author>? get authors {
  final value = _authors;
  if (value == null) return null;
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _narrators;
@override@JsonKey(name: "narrators") List<String>? get narrators {
  final value = _narrators;
  if (value == null) return null;
  if (_narrators is EqualUnmodifiableListView) return _narrators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Series>? _series;
@override@JsonKey(name: "series")@SeriesConverter() List<Series>? get series {
  final value = _series;
  if (value == null) return null;
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _genres;
@override@JsonKey(name: "genres") List<String>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "publishedYear") final  String? publishedYear;
@override@JsonKey(name: "publishedDate") final  String? publishedDate;
@override@JsonKey(name: "publisher") final  String? publisher;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "isbn") final  String? isbn;
@override@JsonKey(name: "asin") final  String? asin;
@override@JsonKey(name: "language") final  String? language;
@override@JsonKey(name: "explicit") final  bool? explicit;
@override@JsonKey(name: "abridged") final  bool? abridged;

/// Create a copy of MediaMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaMetadataCopyWith<_MediaMetadata> get copyWith => __$MediaMetadataCopyWithImpl<_MediaMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&const DeepCollectionEquality().equals(other._authors, _authors)&&const DeepCollectionEquality().equals(other._narrators, _narrators)&&const DeepCollectionEquality().equals(other._series, _series)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.description, description) || other.description == description)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.abridged, abridged) || other.abridged == abridged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle,const DeepCollectionEquality().hash(_authors),const DeepCollectionEquality().hash(_narrators),const DeepCollectionEquality().hash(_series),const DeepCollectionEquality().hash(_genres),publishedYear,publishedDate,publisher,description,isbn,asin,language,explicit,abridged);

@override
String toString() {
  return 'MediaMetadata(title: $title, subtitle: $subtitle, authors: $authors, narrators: $narrators, series: $series, genres: $genres, publishedYear: $publishedYear, publishedDate: $publishedDate, publisher: $publisher, description: $description, isbn: $isbn, asin: $asin, language: $language, explicit: $explicit, abridged: $abridged)';
}


}

/// @nodoc
abstract mixin class _$MediaMetadataCopyWith<$Res> implements $MediaMetadataCopyWith<$Res> {
  factory _$MediaMetadataCopyWith(_MediaMetadata value, $Res Function(_MediaMetadata) _then) = __$MediaMetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "title") String title,@JsonKey(name: "subtitle") String? subtitle,@JsonKey(name: "authors") List<Author>? authors,@JsonKey(name: "narrators") List<String>? narrators,@JsonKey(name: "series")@SeriesConverter() List<Series>? series,@JsonKey(name: "genres") List<String>? genres,@JsonKey(name: "publishedYear") String? publishedYear,@JsonKey(name: "publishedDate") String? publishedDate,@JsonKey(name: "publisher") String? publisher,@JsonKey(name: "description") String? description,@JsonKey(name: "isbn") String? isbn,@JsonKey(name: "asin") String? asin,@JsonKey(name: "language") String? language,@JsonKey(name: "explicit") bool? explicit,@JsonKey(name: "abridged") bool? abridged
});




}
/// @nodoc
class __$MediaMetadataCopyWithImpl<$Res>
    implements _$MediaMetadataCopyWith<$Res> {
  __$MediaMetadataCopyWithImpl(this._self, this._then);

  final _MediaMetadata _self;
  final $Res Function(_MediaMetadata) _then;

/// Create a copy of MediaMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? subtitle = freezed,Object? authors = freezed,Object? narrators = freezed,Object? series = freezed,Object? genres = freezed,Object? publishedYear = freezed,Object? publishedDate = freezed,Object? publisher = freezed,Object? description = freezed,Object? isbn = freezed,Object? asin = freezed,Object? language = freezed,Object? explicit = freezed,Object? abridged = freezed,}) {
  return _then(_MediaMetadata(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,authors: freezed == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<Author>?,narrators: freezed == narrators ? _self._narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<String>?,series: freezed == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<Series>?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,abridged: freezed == abridged ? _self.abridged : abridged // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
