// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_library_item_media_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateLibraryItemMediaRequest {

@JsonKey(name: 'metadata') UpdateLibraryItemMediaMetadataPatch? get metadata;@JsonKey(name: 'tags') List<String>? get tags;@JsonKey(name: 'url') String? get url;
/// Create a copy of UpdateLibraryItemMediaRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaRequestCopyWith<UpdateLibraryItemMediaRequest> get copyWith => _$UpdateLibraryItemMediaRequestCopyWithImpl<UpdateLibraryItemMediaRequest>(this as UpdateLibraryItemMediaRequest, _$identity);

  /// Serializes this UpdateLibraryItemMediaRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLibraryItemMediaRequest&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(tags),url);

@override
String toString() {
  return 'UpdateLibraryItemMediaRequest(metadata: $metadata, tags: $tags, url: $url)';
}


}

/// @nodoc
abstract mixin class $UpdateLibraryItemMediaRequestCopyWith<$Res>  {
  factory $UpdateLibraryItemMediaRequestCopyWith(UpdateLibraryItemMediaRequest value, $Res Function(UpdateLibraryItemMediaRequest) _then) = _$UpdateLibraryItemMediaRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metadata') UpdateLibraryItemMediaMetadataPatch? metadata,@JsonKey(name: 'tags') List<String>? tags,@JsonKey(name: 'url') String? url
});


$UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$UpdateLibraryItemMediaRequestCopyWithImpl<$Res>
    implements $UpdateLibraryItemMediaRequestCopyWith<$Res> {
  _$UpdateLibraryItemMediaRequestCopyWithImpl(this._self, this._then);

  final UpdateLibraryItemMediaRequest _self;
  final $Res Function(UpdateLibraryItemMediaRequest) _then;

/// Create a copy of UpdateLibraryItemMediaRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = freezed,Object? tags = freezed,Object? url = freezed,}) {
  return _then(_self.copyWith(
metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as UpdateLibraryItemMediaMetadataPatch?,tags: freezed == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UpdateLibraryItemMediaRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateLibraryItemMediaRequest].
extension UpdateLibraryItemMediaRequestPatterns on UpdateLibraryItemMediaRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateLibraryItemMediaRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateLibraryItemMediaRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateLibraryItemMediaRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  UpdateLibraryItemMediaMetadataPatch? metadata, @JsonKey(name: 'tags')  List<String>? tags, @JsonKey(name: 'url')  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaRequest() when $default != null:
return $default(_that.metadata,_that.tags,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  UpdateLibraryItemMediaMetadataPatch? metadata, @JsonKey(name: 'tags')  List<String>? tags, @JsonKey(name: 'url')  String? url)  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaRequest():
return $default(_that.metadata,_that.tags,_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metadata')  UpdateLibraryItemMediaMetadataPatch? metadata, @JsonKey(name: 'tags')  List<String>? tags, @JsonKey(name: 'url')  String? url)?  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaRequest() when $default != null:
return $default(_that.metadata,_that.tags,_that.url);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateLibraryItemMediaRequest implements UpdateLibraryItemMediaRequest {
  const _UpdateLibraryItemMediaRequest({@JsonKey(name: 'metadata') this.metadata, @JsonKey(name: 'tags') final  List<String>? tags, @JsonKey(name: 'url') this.url}): _tags = tags;
  factory _UpdateLibraryItemMediaRequest.fromJson(Map<String, dynamic> json) => _$UpdateLibraryItemMediaRequestFromJson(json);

@override@JsonKey(name: 'metadata') final  UpdateLibraryItemMediaMetadataPatch? metadata;
 final  List<String>? _tags;
@override@JsonKey(name: 'tags') List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'url') final  String? url;

/// Create a copy of UpdateLibraryItemMediaRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLibraryItemMediaRequestCopyWith<_UpdateLibraryItemMediaRequest> get copyWith => __$UpdateLibraryItemMediaRequestCopyWithImpl<_UpdateLibraryItemMediaRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateLibraryItemMediaRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLibraryItemMediaRequest&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(_tags),url);

@override
String toString() {
  return 'UpdateLibraryItemMediaRequest(metadata: $metadata, tags: $tags, url: $url)';
}


}

/// @nodoc
abstract mixin class _$UpdateLibraryItemMediaRequestCopyWith<$Res> implements $UpdateLibraryItemMediaRequestCopyWith<$Res> {
  factory _$UpdateLibraryItemMediaRequestCopyWith(_UpdateLibraryItemMediaRequest value, $Res Function(_UpdateLibraryItemMediaRequest) _then) = __$UpdateLibraryItemMediaRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metadata') UpdateLibraryItemMediaMetadataPatch? metadata,@JsonKey(name: 'tags') List<String>? tags,@JsonKey(name: 'url') String? url
});


@override $UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$UpdateLibraryItemMediaRequestCopyWithImpl<$Res>
    implements _$UpdateLibraryItemMediaRequestCopyWith<$Res> {
  __$UpdateLibraryItemMediaRequestCopyWithImpl(this._self, this._then);

  final _UpdateLibraryItemMediaRequest _self;
  final $Res Function(_UpdateLibraryItemMediaRequest) _then;

/// Create a copy of UpdateLibraryItemMediaRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = freezed,Object? tags = freezed,Object? url = freezed,}) {
  return _then(_UpdateLibraryItemMediaRequest(
metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as UpdateLibraryItemMediaMetadataPatch?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UpdateLibraryItemMediaRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$UpdateLibraryItemMediaMetadataPatch {

@JsonKey(name: 'title') String? get title;@JsonKey(name: 'subtitle') String? get subtitle;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'authors') List<Author>? get authors;@JsonKey(name: 'narrators') List<String>? get narrators;@JsonKey(name: 'series') List<Series>? get series;@JsonKey(name: 'genres') List<String>? get genres;@JsonKey(name: 'publisher') String? get publisher;@JsonKey(name: 'publishedYear') String? get publishedYear;@JsonKey(name: 'publishedDate') String? get publishedDate;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'language') String? get language;@JsonKey(name: 'explicit') bool? get explicit;@JsonKey(name: 'abridged') bool? get abridged;@JsonKey(name: 'isbn') String? get isbn;@JsonKey(name: 'asin') String? get asin;@JsonKey(name: 'feedUrl') String? get feedUrl;@JsonKey(name: 'itunesPageUrl') String? get itunesPageUrl;@JsonKey(name: 'itunesId') String? get itunesId;@JsonKey(name: 'releaseDate') String? get releaseDate;@JsonKey(name: 'type') String? get type;
/// Create a copy of UpdateLibraryItemMediaMetadataPatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaMetadataPatchCopyWith<UpdateLibraryItemMediaMetadataPatch> get copyWith => _$UpdateLibraryItemMediaMetadataPatchCopyWithImpl<UpdateLibraryItemMediaMetadataPatch>(this as UpdateLibraryItemMediaMetadataPatch, _$identity);

  /// Serializes this UpdateLibraryItemMediaMetadataPatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLibraryItemMediaMetadataPatch&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.authors, authors)&&const DeepCollectionEquality().equals(other.narrators, narrators)&&const DeepCollectionEquality().equals(other.series, series)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.abridged, abridged) || other.abridged == abridged)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.itunesPageUrl, itunesPageUrl) || other.itunesPageUrl == itunesPageUrl)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,subtitle,author,const DeepCollectionEquality().hash(authors),const DeepCollectionEquality().hash(narrators),const DeepCollectionEquality().hash(series),const DeepCollectionEquality().hash(genres),publisher,publishedYear,publishedDate,description,language,explicit,abridged,isbn,asin,feedUrl,itunesPageUrl,itunesId,releaseDate,type]);

@override
String toString() {
  return 'UpdateLibraryItemMediaMetadataPatch(title: $title, subtitle: $subtitle, author: $author, authors: $authors, narrators: $narrators, series: $series, genres: $genres, publisher: $publisher, publishedYear: $publishedYear, publishedDate: $publishedDate, description: $description, language: $language, explicit: $explicit, abridged: $abridged, isbn: $isbn, asin: $asin, feedUrl: $feedUrl, itunesPageUrl: $itunesPageUrl, itunesId: $itunesId, releaseDate: $releaseDate, type: $type)';
}


}

/// @nodoc
abstract mixin class $UpdateLibraryItemMediaMetadataPatchCopyWith<$Res>  {
  factory $UpdateLibraryItemMediaMetadataPatchCopyWith(UpdateLibraryItemMediaMetadataPatch value, $Res Function(UpdateLibraryItemMediaMetadataPatch) _then) = _$UpdateLibraryItemMediaMetadataPatchCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'subtitle') String? subtitle,@JsonKey(name: 'author') String? author,@JsonKey(name: 'authors') List<Author>? authors,@JsonKey(name: 'narrators') List<String>? narrators,@JsonKey(name: 'series') List<Series>? series,@JsonKey(name: 'genres') List<String>? genres,@JsonKey(name: 'publisher') String? publisher,@JsonKey(name: 'publishedYear') String? publishedYear,@JsonKey(name: 'publishedDate') String? publishedDate,@JsonKey(name: 'description') String? description,@JsonKey(name: 'language') String? language,@JsonKey(name: 'explicit') bool? explicit,@JsonKey(name: 'abridged') bool? abridged,@JsonKey(name: 'isbn') String? isbn,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'itunesPageUrl') String? itunesPageUrl,@JsonKey(name: 'itunesId') String? itunesId,@JsonKey(name: 'releaseDate') String? releaseDate,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$UpdateLibraryItemMediaMetadataPatchCopyWithImpl<$Res>
    implements $UpdateLibraryItemMediaMetadataPatchCopyWith<$Res> {
  _$UpdateLibraryItemMediaMetadataPatchCopyWithImpl(this._self, this._then);

  final UpdateLibraryItemMediaMetadataPatch _self;
  final $Res Function(UpdateLibraryItemMediaMetadataPatch) _then;

/// Create a copy of UpdateLibraryItemMediaMetadataPatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? subtitle = freezed,Object? author = freezed,Object? authors = freezed,Object? narrators = freezed,Object? series = freezed,Object? genres = freezed,Object? publisher = freezed,Object? publishedYear = freezed,Object? publishedDate = freezed,Object? description = freezed,Object? language = freezed,Object? explicit = freezed,Object? abridged = freezed,Object? isbn = freezed,Object? asin = freezed,Object? feedUrl = freezed,Object? itunesPageUrl = freezed,Object? itunesId = freezed,Object? releaseDate = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authors: freezed == authors ? _self.authors : authors // ignore: cast_nullable_to_non_nullable
as List<Author>?,narrators: freezed == narrators ? _self.narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<String>?,series: freezed == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<Series>?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,abridged: freezed == abridged ? _self.abridged : abridged // ignore: cast_nullable_to_non_nullable
as bool?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesPageUrl: freezed == itunesPageUrl ? _self.itunesPageUrl : itunesPageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateLibraryItemMediaMetadataPatch].
extension UpdateLibraryItemMediaMetadataPatchPatterns on UpdateLibraryItemMediaMetadataPatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateLibraryItemMediaMetadataPatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaMetadataPatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateLibraryItemMediaMetadataPatch value)  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaMetadataPatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateLibraryItemMediaMetadataPatch value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaMetadataPatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'subtitle')  String? subtitle, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'authors')  List<Author>? authors, @JsonKey(name: 'narrators')  List<String>? narrators, @JsonKey(name: 'series')  List<Series>? series, @JsonKey(name: 'genres')  List<String>? genres, @JsonKey(name: 'publisher')  String? publisher, @JsonKey(name: 'publishedYear')  String? publishedYear, @JsonKey(name: 'publishedDate')  String? publishedDate, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'abridged')  bool? abridged, @JsonKey(name: 'isbn')  String? isbn, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'itunesPageUrl')  String? itunesPageUrl, @JsonKey(name: 'itunesId')  String? itunesId, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaMetadataPatch() when $default != null:
return $default(_that.title,_that.subtitle,_that.author,_that.authors,_that.narrators,_that.series,_that.genres,_that.publisher,_that.publishedYear,_that.publishedDate,_that.description,_that.language,_that.explicit,_that.abridged,_that.isbn,_that.asin,_that.feedUrl,_that.itunesPageUrl,_that.itunesId,_that.releaseDate,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'subtitle')  String? subtitle, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'authors')  List<Author>? authors, @JsonKey(name: 'narrators')  List<String>? narrators, @JsonKey(name: 'series')  List<Series>? series, @JsonKey(name: 'genres')  List<String>? genres, @JsonKey(name: 'publisher')  String? publisher, @JsonKey(name: 'publishedYear')  String? publishedYear, @JsonKey(name: 'publishedDate')  String? publishedDate, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'abridged')  bool? abridged, @JsonKey(name: 'isbn')  String? isbn, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'itunesPageUrl')  String? itunesPageUrl, @JsonKey(name: 'itunesId')  String? itunesId, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaMetadataPatch():
return $default(_that.title,_that.subtitle,_that.author,_that.authors,_that.narrators,_that.series,_that.genres,_that.publisher,_that.publishedYear,_that.publishedDate,_that.description,_that.language,_that.explicit,_that.abridged,_that.isbn,_that.asin,_that.feedUrl,_that.itunesPageUrl,_that.itunesId,_that.releaseDate,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'subtitle')  String? subtitle, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'authors')  List<Author>? authors, @JsonKey(name: 'narrators')  List<String>? narrators, @JsonKey(name: 'series')  List<Series>? series, @JsonKey(name: 'genres')  List<String>? genres, @JsonKey(name: 'publisher')  String? publisher, @JsonKey(name: 'publishedYear')  String? publishedYear, @JsonKey(name: 'publishedDate')  String? publishedDate, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'abridged')  bool? abridged, @JsonKey(name: 'isbn')  String? isbn, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'itunesPageUrl')  String? itunesPageUrl, @JsonKey(name: 'itunesId')  String? itunesId, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaMetadataPatch() when $default != null:
return $default(_that.title,_that.subtitle,_that.author,_that.authors,_that.narrators,_that.series,_that.genres,_that.publisher,_that.publishedYear,_that.publishedDate,_that.description,_that.language,_that.explicit,_that.abridged,_that.isbn,_that.asin,_that.feedUrl,_that.itunesPageUrl,_that.itunesId,_that.releaseDate,_that.type);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateLibraryItemMediaMetadataPatch implements UpdateLibraryItemMediaMetadataPatch {
  const _UpdateLibraryItemMediaMetadataPatch({@JsonKey(name: 'title') this.title, @JsonKey(name: 'subtitle') this.subtitle, @JsonKey(name: 'author') this.author, @JsonKey(name: 'authors') final  List<Author>? authors, @JsonKey(name: 'narrators') final  List<String>? narrators, @JsonKey(name: 'series') final  List<Series>? series, @JsonKey(name: 'genres') final  List<String>? genres, @JsonKey(name: 'publisher') this.publisher, @JsonKey(name: 'publishedYear') this.publishedYear, @JsonKey(name: 'publishedDate') this.publishedDate, @JsonKey(name: 'description') this.description, @JsonKey(name: 'language') this.language, @JsonKey(name: 'explicit') this.explicit, @JsonKey(name: 'abridged') this.abridged, @JsonKey(name: 'isbn') this.isbn, @JsonKey(name: 'asin') this.asin, @JsonKey(name: 'feedUrl') this.feedUrl, @JsonKey(name: 'itunesPageUrl') this.itunesPageUrl, @JsonKey(name: 'itunesId') this.itunesId, @JsonKey(name: 'releaseDate') this.releaseDate, @JsonKey(name: 'type') this.type}): _authors = authors,_narrators = narrators,_series = series,_genres = genres;
  factory _UpdateLibraryItemMediaMetadataPatch.fromJson(Map<String, dynamic> json) => _$UpdateLibraryItemMediaMetadataPatchFromJson(json);

@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'subtitle') final  String? subtitle;
@override@JsonKey(name: 'author') final  String? author;
 final  List<Author>? _authors;
@override@JsonKey(name: 'authors') List<Author>? get authors {
  final value = _authors;
  if (value == null) return null;
  if (_authors is EqualUnmodifiableListView) return _authors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _narrators;
@override@JsonKey(name: 'narrators') List<String>? get narrators {
  final value = _narrators;
  if (value == null) return null;
  if (_narrators is EqualUnmodifiableListView) return _narrators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Series>? _series;
@override@JsonKey(name: 'series') List<Series>? get series {
  final value = _series;
  if (value == null) return null;
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _genres;
@override@JsonKey(name: 'genres') List<String>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'publisher') final  String? publisher;
@override@JsonKey(name: 'publishedYear') final  String? publishedYear;
@override@JsonKey(name: 'publishedDate') final  String? publishedDate;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'language') final  String? language;
@override@JsonKey(name: 'explicit') final  bool? explicit;
@override@JsonKey(name: 'abridged') final  bool? abridged;
@override@JsonKey(name: 'isbn') final  String? isbn;
@override@JsonKey(name: 'asin') final  String? asin;
@override@JsonKey(name: 'feedUrl') final  String? feedUrl;
@override@JsonKey(name: 'itunesPageUrl') final  String? itunesPageUrl;
@override@JsonKey(name: 'itunesId') final  String? itunesId;
@override@JsonKey(name: 'releaseDate') final  String? releaseDate;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of UpdateLibraryItemMediaMetadataPatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLibraryItemMediaMetadataPatchCopyWith<_UpdateLibraryItemMediaMetadataPatch> get copyWith => __$UpdateLibraryItemMediaMetadataPatchCopyWithImpl<_UpdateLibraryItemMediaMetadataPatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateLibraryItemMediaMetadataPatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLibraryItemMediaMetadataPatch&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._authors, _authors)&&const DeepCollectionEquality().equals(other._narrators, _narrators)&&const DeepCollectionEquality().equals(other._series, _series)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.publishedYear, publishedYear) || other.publishedYear == publishedYear)&&(identical(other.publishedDate, publishedDate) || other.publishedDate == publishedDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.abridged, abridged) || other.abridged == abridged)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.itunesPageUrl, itunesPageUrl) || other.itunesPageUrl == itunesPageUrl)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,title,subtitle,author,const DeepCollectionEquality().hash(_authors),const DeepCollectionEquality().hash(_narrators),const DeepCollectionEquality().hash(_series),const DeepCollectionEquality().hash(_genres),publisher,publishedYear,publishedDate,description,language,explicit,abridged,isbn,asin,feedUrl,itunesPageUrl,itunesId,releaseDate,type]);

@override
String toString() {
  return 'UpdateLibraryItemMediaMetadataPatch(title: $title, subtitle: $subtitle, author: $author, authors: $authors, narrators: $narrators, series: $series, genres: $genres, publisher: $publisher, publishedYear: $publishedYear, publishedDate: $publishedDate, description: $description, language: $language, explicit: $explicit, abridged: $abridged, isbn: $isbn, asin: $asin, feedUrl: $feedUrl, itunesPageUrl: $itunesPageUrl, itunesId: $itunesId, releaseDate: $releaseDate, type: $type)';
}


}

/// @nodoc
abstract mixin class _$UpdateLibraryItemMediaMetadataPatchCopyWith<$Res> implements $UpdateLibraryItemMediaMetadataPatchCopyWith<$Res> {
  factory _$UpdateLibraryItemMediaMetadataPatchCopyWith(_UpdateLibraryItemMediaMetadataPatch value, $Res Function(_UpdateLibraryItemMediaMetadataPatch) _then) = __$UpdateLibraryItemMediaMetadataPatchCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'subtitle') String? subtitle,@JsonKey(name: 'author') String? author,@JsonKey(name: 'authors') List<Author>? authors,@JsonKey(name: 'narrators') List<String>? narrators,@JsonKey(name: 'series') List<Series>? series,@JsonKey(name: 'genres') List<String>? genres,@JsonKey(name: 'publisher') String? publisher,@JsonKey(name: 'publishedYear') String? publishedYear,@JsonKey(name: 'publishedDate') String? publishedDate,@JsonKey(name: 'description') String? description,@JsonKey(name: 'language') String? language,@JsonKey(name: 'explicit') bool? explicit,@JsonKey(name: 'abridged') bool? abridged,@JsonKey(name: 'isbn') String? isbn,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'itunesPageUrl') String? itunesPageUrl,@JsonKey(name: 'itunesId') String? itunesId,@JsonKey(name: 'releaseDate') String? releaseDate,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$UpdateLibraryItemMediaMetadataPatchCopyWithImpl<$Res>
    implements _$UpdateLibraryItemMediaMetadataPatchCopyWith<$Res> {
  __$UpdateLibraryItemMediaMetadataPatchCopyWithImpl(this._self, this._then);

  final _UpdateLibraryItemMediaMetadataPatch _self;
  final $Res Function(_UpdateLibraryItemMediaMetadataPatch) _then;

/// Create a copy of UpdateLibraryItemMediaMetadataPatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? subtitle = freezed,Object? author = freezed,Object? authors = freezed,Object? narrators = freezed,Object? series = freezed,Object? genres = freezed,Object? publisher = freezed,Object? publishedYear = freezed,Object? publishedDate = freezed,Object? description = freezed,Object? language = freezed,Object? explicit = freezed,Object? abridged = freezed,Object? isbn = freezed,Object? asin = freezed,Object? feedUrl = freezed,Object? itunesPageUrl = freezed,Object? itunesId = freezed,Object? releaseDate = freezed,Object? type = freezed,}) {
  return _then(_UpdateLibraryItemMediaMetadataPatch(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,authors: freezed == authors ? _self._authors : authors // ignore: cast_nullable_to_non_nullable
as List<Author>?,narrators: freezed == narrators ? _self._narrators : narrators // ignore: cast_nullable_to_non_nullable
as List<String>?,series: freezed == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<Series>?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>?,publisher: freezed == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String?,publishedYear: freezed == publishedYear ? _self.publishedYear : publishedYear // ignore: cast_nullable_to_non_nullable
as String?,publishedDate: freezed == publishedDate ? _self.publishedDate : publishedDate // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,abridged: freezed == abridged ? _self.abridged : abridged // ignore: cast_nullable_to_non_nullable
as bool?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesPageUrl: freezed == itunesPageUrl ? _self.itunesPageUrl : itunesPageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
