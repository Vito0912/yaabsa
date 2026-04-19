// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_filter_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryFilterData {

@JsonKey(name: 'authors') List<LibraryFilterNamedEntity> get authors;@JsonKey(name: 'genres') List<String> get genres;@JsonKey(name: 'tags') List<String> get tags;@JsonKey(name: 'series') List<LibraryFilterNamedEntity> get series;@JsonKey(name: 'narrators') List<String> get narrators;@JsonKey(name: 'languages') List<String> get languages;@JsonKey(name: 'publishers') List<String> get publishers;@JsonKey(name: 'publishedDecades') List<String> get publishedDecades;@JsonKey(name: 'bookCount') int get bookCount;@JsonKey(name: 'authorCount') int get authorCount;@JsonKey(name: 'seriesCount') int get seriesCount;@JsonKey(name: 'podcastCount') int get podcastCount;@JsonKey(name: 'numIssues') int get numIssues;@JsonKey(name: 'loadedAt') int get loadedAt;
/// Create a copy of LibraryFilterData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryFilterDataCopyWith<LibraryFilterData> get copyWith => _$LibraryFilterDataCopyWithImpl<LibraryFilterData>(this as LibraryFilterData, _$identity);

  /// Serializes this LibraryFilterData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryFilterData&&const DeepCollectionEquality().equals(other.authors, authors)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.series, series)&&const DeepCollectionEquality().equals(other.narrators, narrators)&&const DeepCollectionEquality().equals(other.languages, languages)&&const DeepCollectionEquality().equals(other.publishers, publishers)&&const DeepCollectionEquality().equals(other.publishedDecades, publishedDecades)&&(identical(other.bookCount, bookCount) || other.bookCount == bookCount)&&(identical(other.authorCount, authorCount) || other.authorCount == authorCount)&&(identical(other.seriesCount, seriesCount) || other.seriesCount == seriesCount)&&(identical(other.podcastCount, podcastCount) || other.podcastCount == podcastCount)&&(identical(other.numIssues, numIssues) || other.numIssues == numIssues)&&(identical(other.loadedAt, loadedAt) || other.loadedAt == loadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(authors),const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(series),const DeepCollectionEquality().hash(narrators),const DeepCollectionEquality().hash(languages),const DeepCollectionEquality().hash(publishers),const DeepCollectionEquality().hash(publishedDecades),bookCount,authorCount,seriesCount,podcastCount,numIssues,loadedAt);

@override
String toString() {
  return 'LibraryFilterData(authors: $authors, genres: $genres, tags: $tags, series: $series, narrators: $narrators, languages: $languages, publishers: $publishers, publishedDecades: $publishedDecades, bookCount: $bookCount, authorCount: $authorCount, seriesCount: $seriesCount, podcastCount: $podcastCount, numIssues: $numIssues, loadedAt: $loadedAt)';
}


}

/// @nodoc
abstract mixin class $LibraryFilterDataCopyWith<$Res>  {
  factory $LibraryFilterDataCopyWith(LibraryFilterData value, $Res Function(LibraryFilterData) _then) = _$LibraryFilterDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'authors') List<LibraryFilterNamedEntity> authors,@JsonKey(name: 'genres') List<String> genres,@JsonKey(name: 'tags') List<String> tags,@JsonKey(name: 'series') List<LibraryFilterNamedEntity> series,@JsonKey(name: 'narrators') List<String> narrators,@JsonKey(name: 'languages') List<String> languages,@JsonKey(name: 'publishers') List<String> publishers,@JsonKey(name: 'publishedDecades') List<String> publishedDecades,@JsonKey(name: 'bookCount') int bookCount,@JsonKey(name: 'authorCount') int authorCount,@JsonKey(name: 'seriesCount') int seriesCount,@JsonKey(name: 'podcastCount') int podcastCount,@JsonKey(name: 'numIssues') int numIssues,@JsonKey(name: 'loadedAt') int loadedAt
});




}
/// @nodoc
class _$LibraryFilterDataCopyWithImpl<$Res>
    implements $LibraryFilterDataCopyWith<$Res> {
  _$LibraryFilterDataCopyWithImpl(this._self, this._then);

  final LibraryFilterData _self;
  final $Res Function(LibraryFilterData) _then;

/// Create a copy of LibraryFilterData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authors = null,Object? genres = null,Object? tags = null,Object? series = null,Object? narrators = null,Object? languages = null,Object? publishers = null,Object? publishedDecades = null,Object? bookCount = null,Object? authorCount = null,Object? seriesCount = null,Object? podcastCount = null,Object? numIssues = null,Object? loadedAt = null,}) {
  return _then(_self.copyWith(
authors: null == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<LibraryFilterNamedEntity>,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<LibraryFilterNamedEntity>,narrators: null == narrators ? _self.narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,publishers: null == publishers ? _self.publishers : publishers // ignore: cast_nullable_to_non_nullable
as List<String>,publishedDecades: null == publishedDecades ? _self.publishedDecades : publishedDecades // ignore: cast_nullable_to_non_nullable
as List<String>,bookCount: null == bookCount ? _self.bookCount : bookCount // ignore: cast_nullable_to_non_nullable
as int,authorCount: null == authorCount ? _self.authorCount : authorCount // ignore: cast_nullable_to_non_nullable
as int,seriesCount: null == seriesCount ? _self.seriesCount : seriesCount // ignore: cast_nullable_to_non_nullable
as int,podcastCount: null == podcastCount ? _self.podcastCount : podcastCount // ignore: cast_nullable_to_non_nullable
as int,numIssues: null == numIssues ? _self.numIssues : numIssues // ignore: cast_nullable_to_non_nullable
as int,loadedAt: null == loadedAt ? _self.loadedAt : loadedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryFilterData].
extension LibraryFilterDataPatterns on LibraryFilterData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryFilterData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryFilterData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryFilterData value)  $default,){
final _that = this;
switch (_that) {
case _LibraryFilterData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryFilterData value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryFilterData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'authors')  List<LibraryFilterNamedEntity> authors, @JsonKey(name: 'genres')  List<String> genres, @JsonKey(name: 'tags')  List<String> tags, @JsonKey(name: 'series')  List<LibraryFilterNamedEntity> series, @JsonKey(name: 'narrators')  List<String> narrators, @JsonKey(name: 'languages')  List<String> languages, @JsonKey(name: 'publishers')  List<String> publishers, @JsonKey(name: 'publishedDecades')  List<String> publishedDecades, @JsonKey(name: 'bookCount')  int bookCount, @JsonKey(name: 'authorCount')  int authorCount, @JsonKey(name: 'seriesCount')  int seriesCount, @JsonKey(name: 'podcastCount')  int podcastCount, @JsonKey(name: 'numIssues')  int numIssues, @JsonKey(name: 'loadedAt')  int loadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryFilterData() when $default != null:
return $default(_that.authors,_that.genres,_that.tags,_that.series,_that.narrators,_that.languages,_that.publishers,_that.publishedDecades,_that.bookCount,_that.authorCount,_that.seriesCount,_that.podcastCount,_that.numIssues,_that.loadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'authors')  List<LibraryFilterNamedEntity> authors, @JsonKey(name: 'genres')  List<String> genres, @JsonKey(name: 'tags')  List<String> tags, @JsonKey(name: 'series')  List<LibraryFilterNamedEntity> series, @JsonKey(name: 'narrators')  List<String> narrators, @JsonKey(name: 'languages')  List<String> languages, @JsonKey(name: 'publishers')  List<String> publishers, @JsonKey(name: 'publishedDecades')  List<String> publishedDecades, @JsonKey(name: 'bookCount')  int bookCount, @JsonKey(name: 'authorCount')  int authorCount, @JsonKey(name: 'seriesCount')  int seriesCount, @JsonKey(name: 'podcastCount')  int podcastCount, @JsonKey(name: 'numIssues')  int numIssues, @JsonKey(name: 'loadedAt')  int loadedAt)  $default,) {final _that = this;
switch (_that) {
case _LibraryFilterData():
return $default(_that.authors,_that.genres,_that.tags,_that.series,_that.narrators,_that.languages,_that.publishers,_that.publishedDecades,_that.bookCount,_that.authorCount,_that.seriesCount,_that.podcastCount,_that.numIssues,_that.loadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'authors')  List<LibraryFilterNamedEntity> authors, @JsonKey(name: 'genres')  List<String> genres, @JsonKey(name: 'tags')  List<String> tags, @JsonKey(name: 'series')  List<LibraryFilterNamedEntity> series, @JsonKey(name: 'narrators')  List<String> narrators, @JsonKey(name: 'languages')  List<String> languages, @JsonKey(name: 'publishers')  List<String> publishers, @JsonKey(name: 'publishedDecades')  List<String> publishedDecades, @JsonKey(name: 'bookCount')  int bookCount, @JsonKey(name: 'authorCount')  int authorCount, @JsonKey(name: 'seriesCount')  int seriesCount, @JsonKey(name: 'podcastCount')  int podcastCount, @JsonKey(name: 'numIssues')  int numIssues, @JsonKey(name: 'loadedAt')  int loadedAt)?  $default,) {final _that = this;
switch (_that) {
case _LibraryFilterData() when $default != null:
return $default(_that.authors,_that.genres,_that.tags,_that.series,_that.narrators,_that.languages,_that.publishers,_that.publishedDecades,_that.bookCount,_that.authorCount,_that.seriesCount,_that.podcastCount,_that.numIssues,_that.loadedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryFilterData implements LibraryFilterData {
  const _LibraryFilterData({@JsonKey(name: 'authors') final  List<LibraryFilterNamedEntity> authors = const <LibraryFilterNamedEntity>[], @JsonKey(name: 'genres') final  List<String> genres = const <String>[], @JsonKey(name: 'tags') final  List<String> tags = const <String>[], @JsonKey(name: 'series') final  List<LibraryFilterNamedEntity> series = const <LibraryFilterNamedEntity>[], @JsonKey(name: 'narrators') final  List<String> narrators = const <String>[], @JsonKey(name: 'languages') final  List<String> languages = const <String>[], @JsonKey(name: 'publishers') final  List<String> publishers = const <String>[], @JsonKey(name: 'publishedDecades') final  List<String> publishedDecades = const <String>[], @JsonKey(name: 'bookCount') this.bookCount = 0, @JsonKey(name: 'authorCount') this.authorCount = 0, @JsonKey(name: 'seriesCount') this.seriesCount = 0, @JsonKey(name: 'podcastCount') this.podcastCount = 0, @JsonKey(name: 'numIssues') this.numIssues = 0, @JsonKey(name: 'loadedAt') this.loadedAt = 0}): _authors = authors,_genres = genres,_tags = tags,_series = series,_narrators = narrators,_languages = languages,_publishers = publishers,_publishedDecades = publishedDecades;
  factory _LibraryFilterData.fromJson(Map<String, dynamic> json) => _$LibraryFilterDataFromJson(json);

 final  List<LibraryFilterNamedEntity> _authors;
@override@JsonKey(name: 'authors') List<LibraryFilterNamedEntity> get authors {
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_authors);
}

 final  List<String> _genres;
@override@JsonKey(name: 'genres') List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

 final  List<String> _tags;
@override@JsonKey(name: 'tags') List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<LibraryFilterNamedEntity> _series;
@override@JsonKey(name: 'series') List<LibraryFilterNamedEntity> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

 final  List<String> _narrators;
@override@JsonKey(name: 'narrators') List<String> get narrators {
  if (_narrators is EqualUnmodifiableListView) return _narrators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_narrators);
}

 final  List<String> _languages;
@override@JsonKey(name: 'languages') List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}

 final  List<String> _publishers;
@override@JsonKey(name: 'publishers') List<String> get publishers {
  if (_publishers is EqualUnmodifiableListView) return _publishers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_publishers);
}

 final  List<String> _publishedDecades;
@override@JsonKey(name: 'publishedDecades') List<String> get publishedDecades {
  if (_publishedDecades is EqualUnmodifiableListView) return _publishedDecades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_publishedDecades);
}

@override@JsonKey(name: 'bookCount') final  int bookCount;
@override@JsonKey(name: 'authorCount') final  int authorCount;
@override@JsonKey(name: 'seriesCount') final  int seriesCount;
@override@JsonKey(name: 'podcastCount') final  int podcastCount;
@override@JsonKey(name: 'numIssues') final  int numIssues;
@override@JsonKey(name: 'loadedAt') final  int loadedAt;

/// Create a copy of LibraryFilterData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryFilterDataCopyWith<_LibraryFilterData> get copyWith => __$LibraryFilterDataCopyWithImpl<_LibraryFilterData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryFilterDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryFilterData&&const DeepCollectionEquality().equals(other._authors, _authors)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._series, _series)&&const DeepCollectionEquality().equals(other._narrators, _narrators)&&const DeepCollectionEquality().equals(other._languages, _languages)&&const DeepCollectionEquality().equals(other._publishers, _publishers)&&const DeepCollectionEquality().equals(other._publishedDecades, _publishedDecades)&&(identical(other.bookCount, bookCount) || other.bookCount == bookCount)&&(identical(other.authorCount, authorCount) || other.authorCount == authorCount)&&(identical(other.seriesCount, seriesCount) || other.seriesCount == seriesCount)&&(identical(other.podcastCount, podcastCount) || other.podcastCount == podcastCount)&&(identical(other.numIssues, numIssues) || other.numIssues == numIssues)&&(identical(other.loadedAt, loadedAt) || other.loadedAt == loadedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_authors),const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_series),const DeepCollectionEquality().hash(_narrators),const DeepCollectionEquality().hash(_languages),const DeepCollectionEquality().hash(_publishers),const DeepCollectionEquality().hash(_publishedDecades),bookCount,authorCount,seriesCount,podcastCount,numIssues,loadedAt);

@override
String toString() {
  return 'LibraryFilterData(authors: $authors, genres: $genres, tags: $tags, series: $series, narrators: $narrators, languages: $languages, publishers: $publishers, publishedDecades: $publishedDecades, bookCount: $bookCount, authorCount: $authorCount, seriesCount: $seriesCount, podcastCount: $podcastCount, numIssues: $numIssues, loadedAt: $loadedAt)';
}


}

/// @nodoc
abstract mixin class _$LibraryFilterDataCopyWith<$Res> implements $LibraryFilterDataCopyWith<$Res> {
  factory _$LibraryFilterDataCopyWith(_LibraryFilterData value, $Res Function(_LibraryFilterData) _then) = __$LibraryFilterDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'authors') List<LibraryFilterNamedEntity> authors,@JsonKey(name: 'genres') List<String> genres,@JsonKey(name: 'tags') List<String> tags,@JsonKey(name: 'series') List<LibraryFilterNamedEntity> series,@JsonKey(name: 'narrators') List<String> narrators,@JsonKey(name: 'languages') List<String> languages,@JsonKey(name: 'publishers') List<String> publishers,@JsonKey(name: 'publishedDecades') List<String> publishedDecades,@JsonKey(name: 'bookCount') int bookCount,@JsonKey(name: 'authorCount') int authorCount,@JsonKey(name: 'seriesCount') int seriesCount,@JsonKey(name: 'podcastCount') int podcastCount,@JsonKey(name: 'numIssues') int numIssues,@JsonKey(name: 'loadedAt') int loadedAt
});




}
/// @nodoc
class __$LibraryFilterDataCopyWithImpl<$Res>
    implements _$LibraryFilterDataCopyWith<$Res> {
  __$LibraryFilterDataCopyWithImpl(this._self, this._then);

  final _LibraryFilterData _self;
  final $Res Function(_LibraryFilterData) _then;

/// Create a copy of LibraryFilterData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authors = null,Object? genres = null,Object? tags = null,Object? series = null,Object? narrators = null,Object? languages = null,Object? publishers = null,Object? publishedDecades = null,Object? bookCount = null,Object? authorCount = null,Object? seriesCount = null,Object? podcastCount = null,Object? numIssues = null,Object? loadedAt = null,}) {
  return _then(_LibraryFilterData(
authors: null == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<LibraryFilterNamedEntity>,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<LibraryFilterNamedEntity>,narrators: null == narrators ? _self._narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<String>,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,publishers: null == publishers ? _self._publishers : publishers // ignore: cast_nullable_to_non_nullable
as List<String>,publishedDecades: null == publishedDecades ? _self._publishedDecades : publishedDecades // ignore: cast_nullable_to_non_nullable
as List<String>,bookCount: null == bookCount ? _self.bookCount : bookCount // ignore: cast_nullable_to_non_nullable
as int,authorCount: null == authorCount ? _self.authorCount : authorCount // ignore: cast_nullable_to_non_nullable
as int,seriesCount: null == seriesCount ? _self.seriesCount : seriesCount // ignore: cast_nullable_to_non_nullable
as int,podcastCount: null == podcastCount ? _self.podcastCount : podcastCount // ignore: cast_nullable_to_non_nullable
as int,numIssues: null == numIssues ? _self.numIssues : numIssues // ignore: cast_nullable_to_non_nullable
as int,loadedAt: null == loadedAt ? _self.loadedAt : loadedAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
