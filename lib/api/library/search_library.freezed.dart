// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_library.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchLibrary {

@JsonKey(name: "book") List<SearchLibraryResult>? get book;@JsonKey(name: "podcast") List<SearchLibraryResult>? get podcast;@JsonKey(name: "narrators") List<SearchResultNarrator>? get narrators;@JsonKey(name: "tags") List<SearchResultItem>? get tags;@JsonKey(name: "genres") List<SearchResultItem>? get genres;@JsonKey(name: "series") List<SearchSeries>? get series;@JsonKey(name: "authors") List<SearchLibraryAuthor>? get authors;
/// Create a copy of SearchLibrary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLibraryCopyWith<SearchLibrary> get copyWith => _$SearchLibraryCopyWithImpl<SearchLibrary>(this as SearchLibrary, _$identity);

  /// Serializes this SearchLibrary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLibrary&&const DeepCollectionEquality().equals(other.book, book)&&const DeepCollectionEquality().equals(other.podcast, podcast)&&const DeepCollectionEquality().equals(other.narrators, narrators)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.genres, genres)&&const DeepCollectionEquality().equals(other.series, series)&&const DeepCollectionEquality().equals(other.authors, authors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(book),const DeepCollectionEquality().hash(podcast),const DeepCollectionEquality().hash(narrators),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(genres),const DeepCollectionEquality().hash(series),const DeepCollectionEquality().hash(authors));

@override
String toString() {
  return 'SearchLibrary(book: $book, podcast: $podcast, narrators: $narrators, tags: $tags, genres: $genres, series: $series, authors: $authors)';
}


}

/// @nodoc
abstract mixin class $SearchLibraryCopyWith<$Res>  {
  factory $SearchLibraryCopyWith(SearchLibrary value, $Res Function(SearchLibrary) _then) = _$SearchLibraryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "book") List<SearchLibraryResult>? book,@JsonKey(name: "podcast") List<SearchLibraryResult>? podcast,@JsonKey(name: "narrators") List<SearchResultNarrator>? narrators,@JsonKey(name: "tags") List<SearchResultItem>? tags,@JsonKey(name: "genres") List<SearchResultItem>? genres,@JsonKey(name: "series") List<SearchSeries>? series,@JsonKey(name: "authors") List<SearchLibraryAuthor>? authors
});




}
/// @nodoc
class _$SearchLibraryCopyWithImpl<$Res>
    implements $SearchLibraryCopyWith<$Res> {
  _$SearchLibraryCopyWithImpl(this._self, this._then);

  final SearchLibrary _self;
  final $Res Function(SearchLibrary) _then;

/// Create a copy of SearchLibrary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? book = freezed,Object? podcast = freezed,Object? narrators = freezed,Object? tags = freezed,Object? genres = freezed,Object? series = freezed,Object? authors = freezed,}) {
  return _then(_self.copyWith(
book: freezed == book ? _self.book : book // ignore: cast_nullable_to_non_nullable
as List<SearchLibraryResult>?,podcast: freezed == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as List<SearchLibraryResult>?,narrators: freezed == narrators ? _self.narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<SearchResultNarrator>?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<SearchSeries>?,authors: freezed == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<SearchLibraryAuthor>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SearchLibrary implements SearchLibrary {
  const _SearchLibrary({@JsonKey(name: "book") final  List<SearchLibraryResult>? book, @JsonKey(name: "podcast") final  List<SearchLibraryResult>? podcast, @JsonKey(name: "narrators") final  List<SearchResultNarrator>? narrators, @JsonKey(name: "tags") final  List<SearchResultItem>? tags, @JsonKey(name: "genres") final  List<SearchResultItem>? genres, @JsonKey(name: "series") final  List<SearchSeries>? series, @JsonKey(name: "authors") final  List<SearchLibraryAuthor>? authors}): _book = book,_podcast = podcast,_narrators = narrators,_tags = tags,_genres = genres,_series = series,_authors = authors;
  factory _SearchLibrary.fromJson(Map<String, dynamic> json) => _$SearchLibraryFromJson(json);

 final  List<SearchLibraryResult>? _book;
@override@JsonKey(name: "book") List<SearchLibraryResult>? get book {
  final value = _book;
  if (value == null) return null;
  if (_book is EqualUnmodifiableListView) return _book;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SearchLibraryResult>? _podcast;
@override@JsonKey(name: "podcast") List<SearchLibraryResult>? get podcast {
  final value = _podcast;
  if (value == null) return null;
  if (_podcast is EqualUnmodifiableListView) return _podcast;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SearchResultNarrator>? _narrators;
@override@JsonKey(name: "narrators") List<SearchResultNarrator>? get narrators {
  final value = _narrators;
  if (value == null) return null;
  if (_narrators is EqualUnmodifiableListView) return _narrators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SearchResultItem>? _tags;
@override@JsonKey(name: "tags") List<SearchResultItem>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SearchResultItem>? _genres;
@override@JsonKey(name: "genres") List<SearchResultItem>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SearchSeries>? _series;
@override@JsonKey(name: "series") List<SearchSeries>? get series {
  final value = _series;
  if (value == null) return null;
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SearchLibraryAuthor>? _authors;
@override@JsonKey(name: "authors") List<SearchLibraryAuthor>? get authors {
  final value = _authors;
  if (value == null) return null;
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SearchLibrary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchLibraryCopyWith<_SearchLibrary> get copyWith => __$SearchLibraryCopyWithImpl<_SearchLibrary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchLibraryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchLibrary&&const DeepCollectionEquality().equals(other._book, _book)&&const DeepCollectionEquality().equals(other._podcast, _podcast)&&const DeepCollectionEquality().equals(other._narrators, _narrators)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._genres, _genres)&&const DeepCollectionEquality().equals(other._series, _series)&&const DeepCollectionEquality().equals(other._authors, _authors));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_book),const DeepCollectionEquality().hash(_podcast),const DeepCollectionEquality().hash(_narrators),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_genres),const DeepCollectionEquality().hash(_series),const DeepCollectionEquality().hash(_authors));

@override
String toString() {
  return 'SearchLibrary(book: $book, podcast: $podcast, narrators: $narrators, tags: $tags, genres: $genres, series: $series, authors: $authors)';
}


}

/// @nodoc
abstract mixin class _$SearchLibraryCopyWith<$Res> implements $SearchLibraryCopyWith<$Res> {
  factory _$SearchLibraryCopyWith(_SearchLibrary value, $Res Function(_SearchLibrary) _then) = __$SearchLibraryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "book") List<SearchLibraryResult>? book,@JsonKey(name: "podcast") List<SearchLibraryResult>? podcast,@JsonKey(name: "narrators") List<SearchResultNarrator>? narrators,@JsonKey(name: "tags") List<SearchResultItem>? tags,@JsonKey(name: "genres") List<SearchResultItem>? genres,@JsonKey(name: "series") List<SearchSeries>? series,@JsonKey(name: "authors") List<SearchLibraryAuthor>? authors
});




}
/// @nodoc
class __$SearchLibraryCopyWithImpl<$Res>
    implements _$SearchLibraryCopyWith<$Res> {
  __$SearchLibraryCopyWithImpl(this._self, this._then);

  final _SearchLibrary _self;
  final $Res Function(_SearchLibrary) _then;

/// Create a copy of SearchLibrary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? book = freezed,Object? podcast = freezed,Object? narrators = freezed,Object? tags = freezed,Object? genres = freezed,Object? series = freezed,Object? authors = freezed,}) {
  return _then(_SearchLibrary(
book: freezed == book ? _self._book : book // ignore: cast_nullable_to_non_nullable
as List<SearchLibraryResult>?,podcast: freezed == podcast ? _self._podcast : podcast // ignore: cast_nullable_to_non_nullable
as List<SearchLibraryResult>?,narrators: freezed == narrators ? _self._narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<SearchResultNarrator>?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<SearchResultItem>?,series: freezed == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<SearchSeries>?,authors: freezed == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<SearchLibraryAuthor>?,
  ));
}


}


/// @nodoc
mixin _$SearchLibraryResult {

@JsonKey(name: "libraryItem") LibraryItem? get libraryItem;@JsonKey(name: "matchKey") String? get matchKey;@JsonKey(name: "matchText") String? get matchText;
/// Create a copy of SearchLibraryResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLibraryResultCopyWith<SearchLibraryResult> get copyWith => _$SearchLibraryResultCopyWithImpl<SearchLibraryResult>(this as SearchLibraryResult, _$identity);

  /// Serializes this SearchLibraryResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLibraryResult&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.matchText, matchText) || other.matchText == matchText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItem,matchKey,matchText);

@override
String toString() {
  return 'SearchLibraryResult(libraryItem: $libraryItem, matchKey: $matchKey, matchText: $matchText)';
}


}

/// @nodoc
abstract mixin class $SearchLibraryResultCopyWith<$Res>  {
  factory $SearchLibraryResultCopyWith(SearchLibraryResult value, $Res Function(SearchLibraryResult) _then) = _$SearchLibraryResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraryItem") LibraryItem? libraryItem,@JsonKey(name: "matchKey") String? matchKey,@JsonKey(name: "matchText") String? matchText
});


$LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class _$SearchLibraryResultCopyWithImpl<$Res>
    implements $SearchLibraryResultCopyWith<$Res> {
  _$SearchLibraryResultCopyWithImpl(this._self, this._then);

  final SearchLibraryResult _self;
  final $Res Function(SearchLibraryResult) _then;

/// Create a copy of SearchLibraryResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItem = freezed,Object? matchKey = freezed,Object? matchText = freezed,}) {
  return _then(_self.copyWith(
libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,matchKey: freezed == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String?,matchText: freezed == matchText ? _self.matchText : matchText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SearchLibraryResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get libraryItem {
    if (_self.libraryItem == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.libraryItem!, (value) {
    return _then(_self.copyWith(libraryItem: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SearchLibraryResult implements SearchLibraryResult {
  const _SearchLibraryResult({@JsonKey(name: "libraryItem") this.libraryItem, @JsonKey(name: "matchKey") this.matchKey, @JsonKey(name: "matchText") this.matchText});
  factory _SearchLibraryResult.fromJson(Map<String, dynamic> json) => _$SearchLibraryResultFromJson(json);

@override@JsonKey(name: "libraryItem") final  LibraryItem? libraryItem;
@override@JsonKey(name: "matchKey") final  String? matchKey;
@override@JsonKey(name: "matchText") final  String? matchText;

/// Create a copy of SearchLibraryResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchLibraryResultCopyWith<_SearchLibraryResult> get copyWith => __$SearchLibraryResultCopyWithImpl<_SearchLibraryResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchLibraryResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchLibraryResult&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem)&&(identical(other.matchKey, matchKey) || other.matchKey == matchKey)&&(identical(other.matchText, matchText) || other.matchText == matchText));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItem,matchKey,matchText);

@override
String toString() {
  return 'SearchLibraryResult(libraryItem: $libraryItem, matchKey: $matchKey, matchText: $matchText)';
}


}

/// @nodoc
abstract mixin class _$SearchLibraryResultCopyWith<$Res> implements $SearchLibraryResultCopyWith<$Res> {
  factory _$SearchLibraryResultCopyWith(_SearchLibraryResult value, $Res Function(_SearchLibraryResult) _then) = __$SearchLibraryResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraryItem") LibraryItem? libraryItem,@JsonKey(name: "matchKey") String? matchKey,@JsonKey(name: "matchText") String? matchText
});


@override $LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class __$SearchLibraryResultCopyWithImpl<$Res>
    implements _$SearchLibraryResultCopyWith<$Res> {
  __$SearchLibraryResultCopyWithImpl(this._self, this._then);

  final _SearchLibraryResult _self;
  final $Res Function(_SearchLibraryResult) _then;

/// Create a copy of SearchLibraryResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItem = freezed,Object? matchKey = freezed,Object? matchText = freezed,}) {
  return _then(_SearchLibraryResult(
libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,matchKey: freezed == matchKey ? _self.matchKey : matchKey // ignore: cast_nullable_to_non_nullable
as String?,matchText: freezed == matchText ? _self.matchText : matchText // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SearchLibraryResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get libraryItem {
    if (_self.libraryItem == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.libraryItem!, (value) {
    return _then(_self.copyWith(libraryItem: value));
  });
}
}


/// @nodoc
mixin _$SearchResultItem {

@JsonKey(name: "name") String get name;@JsonKey(name: "numItems") int? get numItems;
/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultItemCopyWith<SearchResultItem> get copyWith => _$SearchResultItemCopyWithImpl<SearchResultItem>(this as SearchResultItem, _$identity);

  /// Serializes this SearchResultItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultItem&&(identical(other.name, name) || other.name == name)&&(identical(other.numItems, numItems) || other.numItems == numItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,numItems);

@override
String toString() {
  return 'SearchResultItem(name: $name, numItems: $numItems)';
}


}

/// @nodoc
abstract mixin class $SearchResultItemCopyWith<$Res>  {
  factory $SearchResultItemCopyWith(SearchResultItem value, $Res Function(SearchResultItem) _then) = _$SearchResultItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "numItems") int? numItems
});




}
/// @nodoc
class _$SearchResultItemCopyWithImpl<$Res>
    implements $SearchResultItemCopyWith<$Res> {
  _$SearchResultItemCopyWithImpl(this._self, this._then);

  final SearchResultItem _self;
  final $Res Function(SearchResultItem) _then;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? numItems = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,numItems: freezed == numItems ? _self.numItems : numItems // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SearchResultItem implements SearchResultItem {
  const _SearchResultItem({@JsonKey(name: "name") required this.name, @JsonKey(name: "numItems") this.numItems});
  factory _SearchResultItem.fromJson(Map<String, dynamic> json) => _$SearchResultItemFromJson(json);

@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "numItems") final  int? numItems;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultItemCopyWith<_SearchResultItem> get copyWith => __$SearchResultItemCopyWithImpl<_SearchResultItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultItem&&(identical(other.name, name) || other.name == name)&&(identical(other.numItems, numItems) || other.numItems == numItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,numItems);

@override
String toString() {
  return 'SearchResultItem(name: $name, numItems: $numItems)';
}


}

/// @nodoc
abstract mixin class _$SearchResultItemCopyWith<$Res> implements $SearchResultItemCopyWith<$Res> {
  factory _$SearchResultItemCopyWith(_SearchResultItem value, $Res Function(_SearchResultItem) _then) = __$SearchResultItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "numItems") int? numItems
});




}
/// @nodoc
class __$SearchResultItemCopyWithImpl<$Res>
    implements _$SearchResultItemCopyWith<$Res> {
  __$SearchResultItemCopyWithImpl(this._self, this._then);

  final _SearchResultItem _self;
  final $Res Function(_SearchResultItem) _then;

/// Create a copy of SearchResultItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? numItems = freezed,}) {
  return _then(_SearchResultItem(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,numItems: freezed == numItems ? _self.numItems : numItems // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$SearchResultNarrator {

@JsonKey(name: "name") String get name;@JsonKey(name: "numItems") int? get numItems;
/// Create a copy of SearchResultNarrator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResultNarratorCopyWith<SearchResultNarrator> get copyWith => _$SearchResultNarratorCopyWithImpl<SearchResultNarrator>(this as SearchResultNarrator, _$identity);

  /// Serializes this SearchResultNarrator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResultNarrator&&(identical(other.name, name) || other.name == name)&&(identical(other.numItems, numItems) || other.numItems == numItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,numItems);

@override
String toString() {
  return 'SearchResultNarrator(name: $name, numItems: $numItems)';
}


}

/// @nodoc
abstract mixin class $SearchResultNarratorCopyWith<$Res>  {
  factory $SearchResultNarratorCopyWith(SearchResultNarrator value, $Res Function(SearchResultNarrator) _then) = _$SearchResultNarratorCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "numItems") int? numItems
});




}
/// @nodoc
class _$SearchResultNarratorCopyWithImpl<$Res>
    implements $SearchResultNarratorCopyWith<$Res> {
  _$SearchResultNarratorCopyWithImpl(this._self, this._then);

  final SearchResultNarrator _self;
  final $Res Function(SearchResultNarrator) _then;

/// Create a copy of SearchResultNarrator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? numItems = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,numItems: freezed == numItems ? _self.numItems : numItems // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SearchResultNarrator implements SearchResultNarrator {
  const _SearchResultNarrator({@JsonKey(name: "name") required this.name, @JsonKey(name: "numItems") this.numItems});
  factory _SearchResultNarrator.fromJson(Map<String, dynamic> json) => _$SearchResultNarratorFromJson(json);

@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "numItems") final  int? numItems;

/// Create a copy of SearchResultNarrator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResultNarratorCopyWith<_SearchResultNarrator> get copyWith => __$SearchResultNarratorCopyWithImpl<_SearchResultNarrator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResultNarratorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResultNarrator&&(identical(other.name, name) || other.name == name)&&(identical(other.numItems, numItems) || other.numItems == numItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,numItems);

@override
String toString() {
  return 'SearchResultNarrator(name: $name, numItems: $numItems)';
}


}

/// @nodoc
abstract mixin class _$SearchResultNarratorCopyWith<$Res> implements $SearchResultNarratorCopyWith<$Res> {
  factory _$SearchResultNarratorCopyWith(_SearchResultNarrator value, $Res Function(_SearchResultNarrator) _then) = __$SearchResultNarratorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "name") String name,@JsonKey(name: "numItems") int? numItems
});




}
/// @nodoc
class __$SearchResultNarratorCopyWithImpl<$Res>
    implements _$SearchResultNarratorCopyWith<$Res> {
  __$SearchResultNarratorCopyWithImpl(this._self, this._then);

  final _SearchResultNarrator _self;
  final $Res Function(_SearchResultNarrator) _then;

/// Create a copy of SearchResultNarrator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? numItems = freezed,}) {
  return _then(_SearchResultNarrator(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,numItems: freezed == numItems ? _self.numItems : numItems // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
