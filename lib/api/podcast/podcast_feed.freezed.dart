// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PodcastFeedResponse {

@JsonKey(name: 'podcast') PodcastFeed get podcast;
/// Create a copy of PodcastFeedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFeedResponseCopyWith<PodcastFeedResponse> get copyWith => _$PodcastFeedResponseCopyWithImpl<PodcastFeedResponse>(this as PodcastFeedResponse, _$identity);

  /// Serializes this PodcastFeedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFeedResponse&&(identical(other.podcast, podcast) || other.podcast == podcast));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,podcast);

@override
String toString() {
  return 'PodcastFeedResponse(podcast: $podcast)';
}


}

/// @nodoc
abstract mixin class $PodcastFeedResponseCopyWith<$Res>  {
  factory $PodcastFeedResponseCopyWith(PodcastFeedResponse value, $Res Function(PodcastFeedResponse) _then) = _$PodcastFeedResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'podcast') PodcastFeed podcast
});


$PodcastFeedCopyWith<$Res> get podcast;

}
/// @nodoc
class _$PodcastFeedResponseCopyWithImpl<$Res>
    implements $PodcastFeedResponseCopyWith<$Res> {
  _$PodcastFeedResponseCopyWithImpl(this._self, this._then);

  final PodcastFeedResponse _self;
  final $Res Function(PodcastFeedResponse) _then;

/// Create a copy of PodcastFeedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? podcast = null,}) {
  return _then(_self.copyWith(
podcast: null == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as PodcastFeed,
  ));
}
/// Create a copy of PodcastFeedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastFeedCopyWith<$Res> get podcast {
  
  return $PodcastFeedCopyWith<$Res>(_self.podcast, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastFeedResponse].
extension PodcastFeedResponsePatterns on PodcastFeedResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFeedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFeedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFeedResponse value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFeedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'podcast')  PodcastFeed podcast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFeedResponse() when $default != null:
return $default(_that.podcast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'podcast')  PodcastFeed podcast)  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedResponse():
return $default(_that.podcast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'podcast')  PodcastFeed podcast)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedResponse() when $default != null:
return $default(_that.podcast);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastFeedResponse implements PodcastFeedResponse {
  const _PodcastFeedResponse({@JsonKey(name: 'podcast') required this.podcast});
  factory _PodcastFeedResponse.fromJson(Map<String, dynamic> json) => _$PodcastFeedResponseFromJson(json);

@override@JsonKey(name: 'podcast') final  PodcastFeed podcast;

/// Create a copy of PodcastFeedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFeedResponseCopyWith<_PodcastFeedResponse> get copyWith => __$PodcastFeedResponseCopyWithImpl<_PodcastFeedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastFeedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFeedResponse&&(identical(other.podcast, podcast) || other.podcast == podcast));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,podcast);

@override
String toString() {
  return 'PodcastFeedResponse(podcast: $podcast)';
}


}

/// @nodoc
abstract mixin class _$PodcastFeedResponseCopyWith<$Res> implements $PodcastFeedResponseCopyWith<$Res> {
  factory _$PodcastFeedResponseCopyWith(_PodcastFeedResponse value, $Res Function(_PodcastFeedResponse) _then) = __$PodcastFeedResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'podcast') PodcastFeed podcast
});


@override $PodcastFeedCopyWith<$Res> get podcast;

}
/// @nodoc
class __$PodcastFeedResponseCopyWithImpl<$Res>
    implements _$PodcastFeedResponseCopyWith<$Res> {
  __$PodcastFeedResponseCopyWithImpl(this._self, this._then);

  final _PodcastFeedResponse _self;
  final $Res Function(_PodcastFeedResponse) _then;

/// Create a copy of PodcastFeedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? podcast = null,}) {
  return _then(_PodcastFeedResponse(
podcast: null == podcast ? _self.podcast : podcast // ignore: cast_nullable_to_non_nullable
as PodcastFeed,
  ));
}

/// Create a copy of PodcastFeedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastFeedCopyWith<$Res> get podcast {
  
  return $PodcastFeedCopyWith<$Res>(_self.podcast, (value) {
    return _then(_self.copyWith(podcast: value));
  });
}
}


/// @nodoc
mixin _$PodcastFeed {

@JsonKey(name: 'metadata') PodcastFeedMetadata get metadata;@JsonKey(name: 'episodes') List<PodcastFeedEpisode> get episodes;@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? get numEpisodes;
/// Create a copy of PodcastFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFeedCopyWith<PodcastFeed> get copyWith => _$PodcastFeedCopyWithImpl<PodcastFeed>(this as PodcastFeed, _$identity);

  /// Serializes this PodcastFeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFeed&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.numEpisodes, numEpisodes) || other.numEpisodes == numEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(episodes),numEpisodes);

@override
String toString() {
  return 'PodcastFeed(metadata: $metadata, episodes: $episodes, numEpisodes: $numEpisodes)';
}


}

/// @nodoc
abstract mixin class $PodcastFeedCopyWith<$Res>  {
  factory $PodcastFeedCopyWith(PodcastFeed value, $Res Function(PodcastFeed) _then) = _$PodcastFeedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metadata') PodcastFeedMetadata metadata,@JsonKey(name: 'episodes') List<PodcastFeedEpisode> episodes,@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? numEpisodes
});


$PodcastFeedMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$PodcastFeedCopyWithImpl<$Res>
    implements $PodcastFeedCopyWith<$Res> {
  _$PodcastFeedCopyWithImpl(this._self, this._then);

  final PodcastFeed _self;
  final $Res Function(PodcastFeed) _then;

/// Create a copy of PodcastFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = null,Object? episodes = null,Object? numEpisodes = freezed,}) {
  return _then(_self.copyWith(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PodcastFeedMetadata,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<PodcastFeedEpisode>,numEpisodes: freezed == numEpisodes ? _self.numEpisodes : numEpisodes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PodcastFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastFeedMetadataCopyWith<$Res> get metadata {
  
  return $PodcastFeedMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastFeed].
extension PodcastFeedPatterns on PodcastFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFeed value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFeed value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  PodcastFeedMetadata metadata, @JsonKey(name: 'episodes')  List<PodcastFeedEpisode> episodes, @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic)  int? numEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFeed() when $default != null:
return $default(_that.metadata,_that.episodes,_that.numEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  PodcastFeedMetadata metadata, @JsonKey(name: 'episodes')  List<PodcastFeedEpisode> episodes, @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic)  int? numEpisodes)  $default,) {final _that = this;
switch (_that) {
case _PodcastFeed():
return $default(_that.metadata,_that.episodes,_that.numEpisodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metadata')  PodcastFeedMetadata metadata, @JsonKey(name: 'episodes')  List<PodcastFeedEpisode> episodes, @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic)  int? numEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFeed() when $default != null:
return $default(_that.metadata,_that.episodes,_that.numEpisodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastFeed implements PodcastFeed {
  const _PodcastFeed({@JsonKey(name: 'metadata') required this.metadata, @JsonKey(name: 'episodes') final  List<PodcastFeedEpisode> episodes = const <PodcastFeedEpisode>[], @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) this.numEpisodes}): _episodes = episodes;
  factory _PodcastFeed.fromJson(Map<String, dynamic> json) => _$PodcastFeedFromJson(json);

@override@JsonKey(name: 'metadata') final  PodcastFeedMetadata metadata;
 final  List<PodcastFeedEpisode> _episodes;
@override@JsonKey(name: 'episodes') List<PodcastFeedEpisode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) final  int? numEpisodes;

/// Create a copy of PodcastFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFeedCopyWith<_PodcastFeed> get copyWith => __$PodcastFeedCopyWithImpl<_PodcastFeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastFeedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFeed&&(identical(other.metadata, metadata) || other.metadata == metadata)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.numEpisodes, numEpisodes) || other.numEpisodes == numEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,const DeepCollectionEquality().hash(_episodes),numEpisodes);

@override
String toString() {
  return 'PodcastFeed(metadata: $metadata, episodes: $episodes, numEpisodes: $numEpisodes)';
}


}

/// @nodoc
abstract mixin class _$PodcastFeedCopyWith<$Res> implements $PodcastFeedCopyWith<$Res> {
  factory _$PodcastFeedCopyWith(_PodcastFeed value, $Res Function(_PodcastFeed) _then) = __$PodcastFeedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metadata') PodcastFeedMetadata metadata,@JsonKey(name: 'episodes') List<PodcastFeedEpisode> episodes,@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? numEpisodes
});


@override $PodcastFeedMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$PodcastFeedCopyWithImpl<$Res>
    implements _$PodcastFeedCopyWith<$Res> {
  __$PodcastFeedCopyWithImpl(this._self, this._then);

  final _PodcastFeed _self;
  final $Res Function(_PodcastFeed) _then;

/// Create a copy of PodcastFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = null,Object? episodes = null,Object? numEpisodes = freezed,}) {
  return _then(_PodcastFeed(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PodcastFeedMetadata,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<PodcastFeedEpisode>,numEpisodes: freezed == numEpisodes ? _self.numEpisodes : numEpisodes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PodcastFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastFeedMetadataCopyWith<$Res> get metadata {
  
  return $PodcastFeedMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$PodcastFeedMetadata {

@JsonKey(name: 'title') String? get title;@JsonKey(name: 'language') String? get language;@JsonKey(name: 'explicit') String? get explicit;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'pubDate') String? get pubDate;@JsonKey(name: 'link') String? get link;@JsonKey(name: 'image') String? get image;@JsonKey(name: 'categories') List<String> get categories;@JsonKey(name: 'feedUrl') String? get feedUrl;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'descriptionPlain') String? get descriptionPlain;@JsonKey(name: 'type') String? get type;
/// Create a copy of PodcastFeedMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFeedMetadataCopyWith<PodcastFeedMetadata> get copyWith => _$PodcastFeedMetadataCopyWithImpl<PodcastFeedMetadata>(this as PodcastFeedMetadata, _$identity);

  /// Serializes this PodcastFeedMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFeedMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.author, author) || other.author == author)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.link, link) || other.link == link)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,language,explicit,author,pubDate,link,image,const DeepCollectionEquality().hash(categories),feedUrl,description,descriptionPlain,type);

@override
String toString() {
  return 'PodcastFeedMetadata(title: $title, language: $language, explicit: $explicit, author: $author, pubDate: $pubDate, link: $link, image: $image, categories: $categories, feedUrl: $feedUrl, description: $description, descriptionPlain: $descriptionPlain, type: $type)';
}


}

/// @nodoc
abstract mixin class $PodcastFeedMetadataCopyWith<$Res>  {
  factory $PodcastFeedMetadataCopyWith(PodcastFeedMetadata value, $Res Function(PodcastFeedMetadata) _then) = _$PodcastFeedMetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'language') String? language,@JsonKey(name: 'explicit') String? explicit,@JsonKey(name: 'author') String? author,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'link') String? link,@JsonKey(name: 'image') String? image,@JsonKey(name: 'categories') List<String> categories,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionPlain') String? descriptionPlain,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$PodcastFeedMetadataCopyWithImpl<$Res>
    implements $PodcastFeedMetadataCopyWith<$Res> {
  _$PodcastFeedMetadataCopyWithImpl(this._self, this._then);

  final PodcastFeedMetadata _self;
  final $Res Function(PodcastFeedMetadata) _then;

/// Create a copy of PodcastFeedMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? language = freezed,Object? explicit = freezed,Object? author = freezed,Object? pubDate = freezed,Object? link = freezed,Object? image = freezed,Object? categories = null,Object? feedUrl = freezed,Object? description = freezed,Object? descriptionPlain = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionPlain: freezed == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastFeedMetadata].
extension PodcastFeedMetadataPatterns on PodcastFeedMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFeedMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFeedMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFeedMetadata value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFeedMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit')  String? explicit, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'categories')  List<String> categories, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFeedMetadata() when $default != null:
return $default(_that.title,_that.language,_that.explicit,_that.author,_that.pubDate,_that.link,_that.image,_that.categories,_that.feedUrl,_that.description,_that.descriptionPlain,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit')  String? explicit, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'categories')  List<String> categories, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedMetadata():
return $default(_that.title,_that.language,_that.explicit,_that.author,_that.pubDate,_that.link,_that.image,_that.categories,_that.feedUrl,_that.description,_that.descriptionPlain,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit')  String? explicit, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'image')  String? image, @JsonKey(name: 'categories')  List<String> categories, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedMetadata() when $default != null:
return $default(_that.title,_that.language,_that.explicit,_that.author,_that.pubDate,_that.link,_that.image,_that.categories,_that.feedUrl,_that.description,_that.descriptionPlain,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastFeedMetadata implements PodcastFeedMetadata {
  const _PodcastFeedMetadata({@JsonKey(name: 'title') this.title, @JsonKey(name: 'language') this.language, @JsonKey(name: 'explicit') this.explicit, @JsonKey(name: 'author') this.author, @JsonKey(name: 'pubDate') this.pubDate, @JsonKey(name: 'link') this.link, @JsonKey(name: 'image') this.image, @JsonKey(name: 'categories') final  List<String> categories = const <String>[], @JsonKey(name: 'feedUrl') this.feedUrl, @JsonKey(name: 'description') this.description, @JsonKey(name: 'descriptionPlain') this.descriptionPlain, @JsonKey(name: 'type') this.type}): _categories = categories;
  factory _PodcastFeedMetadata.fromJson(Map<String, dynamic> json) => _$PodcastFeedMetadataFromJson(json);

@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'language') final  String? language;
@override@JsonKey(name: 'explicit') final  String? explicit;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'pubDate') final  String? pubDate;
@override@JsonKey(name: 'link') final  String? link;
@override@JsonKey(name: 'image') final  String? image;
 final  List<String> _categories;
@override@JsonKey(name: 'categories') List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

@override@JsonKey(name: 'feedUrl') final  String? feedUrl;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'descriptionPlain') final  String? descriptionPlain;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of PodcastFeedMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFeedMetadataCopyWith<_PodcastFeedMetadata> get copyWith => __$PodcastFeedMetadataCopyWithImpl<_PodcastFeedMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastFeedMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFeedMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.author, author) || other.author == author)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.link, link) || other.link == link)&&(identical(other.image, image) || other.image == image)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,language,explicit,author,pubDate,link,image,const DeepCollectionEquality().hash(_categories),feedUrl,description,descriptionPlain,type);

@override
String toString() {
  return 'PodcastFeedMetadata(title: $title, language: $language, explicit: $explicit, author: $author, pubDate: $pubDate, link: $link, image: $image, categories: $categories, feedUrl: $feedUrl, description: $description, descriptionPlain: $descriptionPlain, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PodcastFeedMetadataCopyWith<$Res> implements $PodcastFeedMetadataCopyWith<$Res> {
  factory _$PodcastFeedMetadataCopyWith(_PodcastFeedMetadata value, $Res Function(_PodcastFeedMetadata) _then) = __$PodcastFeedMetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'language') String? language,@JsonKey(name: 'explicit') String? explicit,@JsonKey(name: 'author') String? author,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'link') String? link,@JsonKey(name: 'image') String? image,@JsonKey(name: 'categories') List<String> categories,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionPlain') String? descriptionPlain,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$PodcastFeedMetadataCopyWithImpl<$Res>
    implements _$PodcastFeedMetadataCopyWith<$Res> {
  __$PodcastFeedMetadataCopyWithImpl(this._self, this._then);

  final _PodcastFeedMetadata _self;
  final $Res Function(_PodcastFeedMetadata) _then;

/// Create a copy of PodcastFeedMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? language = freezed,Object? explicit = freezed,Object? author = freezed,Object? pubDate = freezed,Object? link = freezed,Object? image = freezed,Object? categories = null,Object? feedUrl = freezed,Object? description = freezed,Object? descriptionPlain = freezed,Object? type = freezed,}) {
  return _then(_PodcastFeedMetadata(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionPlain: freezed == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PodcastFeedEpisode {

@JsonKey(name: 'title') String? get title;@JsonKey(name: 'subtitle') String? get subtitle;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'descriptionPlain') String? get descriptionPlain;@JsonKey(name: 'pubDate') String? get pubDate;@JsonKey(name: 'episodeType') String? get episodeType;@JsonKey(name: 'season') String? get season;@JsonKey(name: 'episode') String? get episode;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'duration') String? get duration;@JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic) int? get durationSeconds;@JsonKey(name: 'explicit') String? get explicit;@JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic) int? get publishedAt;@JsonKey(name: 'enclosure') PodcastFeedEpisodeEnclosure? get enclosure;@JsonKey(name: 'guid') String? get guid;@JsonKey(name: 'chaptersUrl') String? get chaptersUrl;@JsonKey(name: 'chaptersType') String? get chaptersType;@JsonKey(name: 'chapters') List<PodcastFeedEpisodeChapter> get chapters;
/// Create a copy of PodcastFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFeedEpisodeCopyWith<PodcastFeedEpisode> get copyWith => _$PodcastFeedEpisodeCopyWithImpl<PodcastFeedEpisode>(this as PodcastFeedEpisode, _$identity);

  /// Serializes this PodcastFeedEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFeedEpisode&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.author, author) || other.author == author)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.guid, guid) || other.guid == guid)&&(identical(other.chaptersUrl, chaptersUrl) || other.chaptersUrl == chaptersUrl)&&(identical(other.chaptersType, chaptersType) || other.chaptersType == chaptersType)&&const DeepCollectionEquality().equals(other.chapters, chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle,description,descriptionPlain,pubDate,episodeType,season,episode,author,duration,durationSeconds,explicit,publishedAt,enclosure,guid,chaptersUrl,chaptersType,const DeepCollectionEquality().hash(chapters));

@override
String toString() {
  return 'PodcastFeedEpisode(title: $title, subtitle: $subtitle, description: $description, descriptionPlain: $descriptionPlain, pubDate: $pubDate, episodeType: $episodeType, season: $season, episode: $episode, author: $author, duration: $duration, durationSeconds: $durationSeconds, explicit: $explicit, publishedAt: $publishedAt, enclosure: $enclosure, guid: $guid, chaptersUrl: $chaptersUrl, chaptersType: $chaptersType, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $PodcastFeedEpisodeCopyWith<$Res>  {
  factory $PodcastFeedEpisodeCopyWith(PodcastFeedEpisode value, $Res Function(PodcastFeedEpisode) _then) = _$PodcastFeedEpisodeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'subtitle') String? subtitle,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionPlain') String? descriptionPlain,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'episodeType') String? episodeType,@JsonKey(name: 'season') String? season,@JsonKey(name: 'episode') String? episode,@JsonKey(name: 'author') String? author,@JsonKey(name: 'duration') String? duration,@JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic) int? durationSeconds,@JsonKey(name: 'explicit') String? explicit,@JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic) int? publishedAt,@JsonKey(name: 'enclosure') PodcastFeedEpisodeEnclosure? enclosure,@JsonKey(name: 'guid') String? guid,@JsonKey(name: 'chaptersUrl') String? chaptersUrl,@JsonKey(name: 'chaptersType') String? chaptersType,@JsonKey(name: 'chapters') List<PodcastFeedEpisodeChapter> chapters
});


$PodcastFeedEpisodeEnclosureCopyWith<$Res>? get enclosure;

}
/// @nodoc
class _$PodcastFeedEpisodeCopyWithImpl<$Res>
    implements $PodcastFeedEpisodeCopyWith<$Res> {
  _$PodcastFeedEpisodeCopyWithImpl(this._self, this._then);

  final PodcastFeedEpisode _self;
  final $Res Function(PodcastFeedEpisode) _then;

/// Create a copy of PodcastFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? subtitle = freezed,Object? description = freezed,Object? descriptionPlain = freezed,Object? pubDate = freezed,Object? episodeType = freezed,Object? season = freezed,Object? episode = freezed,Object? author = freezed,Object? duration = freezed,Object? durationSeconds = freezed,Object? explicit = freezed,Object? publishedAt = freezed,Object? enclosure = freezed,Object? guid = freezed,Object? chaptersUrl = freezed,Object? chaptersType = freezed,Object? chapters = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionPlain: freezed == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as int?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as PodcastFeedEpisodeEnclosure?,guid: freezed == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String?,chaptersUrl: freezed == chaptersUrl ? _self.chaptersUrl : chaptersUrl // ignore: cast_nullable_to_non_nullable
as String?,chaptersType: freezed == chaptersType ? _self.chaptersType : chaptersType // ignore: cast_nullable_to_non_nullable
as String?,chapters: null == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<PodcastFeedEpisodeChapter>,
  ));
}
/// Create a copy of PodcastFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastFeedEpisodeEnclosureCopyWith<$Res>? get enclosure {
    if (_self.enclosure == null) {
    return null;
  }

  return $PodcastFeedEpisodeEnclosureCopyWith<$Res>(_self.enclosure!, (value) {
    return _then(_self.copyWith(enclosure: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastFeedEpisode].
extension PodcastFeedEpisodePatterns on PodcastFeedEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFeedEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFeedEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFeedEpisode value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFeedEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'subtitle')  String? subtitle, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'episodeType')  String? episodeType, @JsonKey(name: 'season')  String? season, @JsonKey(name: 'episode')  String? episode, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'duration')  String? duration, @JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic)  int? durationSeconds, @JsonKey(name: 'explicit')  String? explicit, @JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic)  int? publishedAt, @JsonKey(name: 'enclosure')  PodcastFeedEpisodeEnclosure? enclosure, @JsonKey(name: 'guid')  String? guid, @JsonKey(name: 'chaptersUrl')  String? chaptersUrl, @JsonKey(name: 'chaptersType')  String? chaptersType, @JsonKey(name: 'chapters')  List<PodcastFeedEpisodeChapter> chapters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFeedEpisode() when $default != null:
return $default(_that.title,_that.subtitle,_that.description,_that.descriptionPlain,_that.pubDate,_that.episodeType,_that.season,_that.episode,_that.author,_that.duration,_that.durationSeconds,_that.explicit,_that.publishedAt,_that.enclosure,_that.guid,_that.chaptersUrl,_that.chaptersType,_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'subtitle')  String? subtitle, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'episodeType')  String? episodeType, @JsonKey(name: 'season')  String? season, @JsonKey(name: 'episode')  String? episode, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'duration')  String? duration, @JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic)  int? durationSeconds, @JsonKey(name: 'explicit')  String? explicit, @JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic)  int? publishedAt, @JsonKey(name: 'enclosure')  PodcastFeedEpisodeEnclosure? enclosure, @JsonKey(name: 'guid')  String? guid, @JsonKey(name: 'chaptersUrl')  String? chaptersUrl, @JsonKey(name: 'chaptersType')  String? chaptersType, @JsonKey(name: 'chapters')  List<PodcastFeedEpisodeChapter> chapters)  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedEpisode():
return $default(_that.title,_that.subtitle,_that.description,_that.descriptionPlain,_that.pubDate,_that.episodeType,_that.season,_that.episode,_that.author,_that.duration,_that.durationSeconds,_that.explicit,_that.publishedAt,_that.enclosure,_that.guid,_that.chaptersUrl,_that.chaptersType,_that.chapters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'subtitle')  String? subtitle, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'episodeType')  String? episodeType, @JsonKey(name: 'season')  String? season, @JsonKey(name: 'episode')  String? episode, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'duration')  String? duration, @JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic)  int? durationSeconds, @JsonKey(name: 'explicit')  String? explicit, @JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic)  int? publishedAt, @JsonKey(name: 'enclosure')  PodcastFeedEpisodeEnclosure? enclosure, @JsonKey(name: 'guid')  String? guid, @JsonKey(name: 'chaptersUrl')  String? chaptersUrl, @JsonKey(name: 'chaptersType')  String? chaptersType, @JsonKey(name: 'chapters')  List<PodcastFeedEpisodeChapter> chapters)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedEpisode() when $default != null:
return $default(_that.title,_that.subtitle,_that.description,_that.descriptionPlain,_that.pubDate,_that.episodeType,_that.season,_that.episode,_that.author,_that.duration,_that.durationSeconds,_that.explicit,_that.publishedAt,_that.enclosure,_that.guid,_that.chaptersUrl,_that.chaptersType,_that.chapters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastFeedEpisode implements PodcastFeedEpisode {
  const _PodcastFeedEpisode({@JsonKey(name: 'title') this.title, @JsonKey(name: 'subtitle') this.subtitle, @JsonKey(name: 'description') this.description, @JsonKey(name: 'descriptionPlain') this.descriptionPlain, @JsonKey(name: 'pubDate') this.pubDate, @JsonKey(name: 'episodeType') this.episodeType, @JsonKey(name: 'season') this.season, @JsonKey(name: 'episode') this.episode, @JsonKey(name: 'author') this.author, @JsonKey(name: 'duration') this.duration, @JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic) this.durationSeconds, @JsonKey(name: 'explicit') this.explicit, @JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic) this.publishedAt, @JsonKey(name: 'enclosure') this.enclosure, @JsonKey(name: 'guid') this.guid, @JsonKey(name: 'chaptersUrl') this.chaptersUrl, @JsonKey(name: 'chaptersType') this.chaptersType, @JsonKey(name: 'chapters') final  List<PodcastFeedEpisodeChapter> chapters = const <PodcastFeedEpisodeChapter>[]}): _chapters = chapters;
  factory _PodcastFeedEpisode.fromJson(Map<String, dynamic> json) => _$PodcastFeedEpisodeFromJson(json);

@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'subtitle') final  String? subtitle;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'descriptionPlain') final  String? descriptionPlain;
@override@JsonKey(name: 'pubDate') final  String? pubDate;
@override@JsonKey(name: 'episodeType') final  String? episodeType;
@override@JsonKey(name: 'season') final  String? season;
@override@JsonKey(name: 'episode') final  String? episode;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'duration') final  String? duration;
@override@JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic) final  int? durationSeconds;
@override@JsonKey(name: 'explicit') final  String? explicit;
@override@JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic) final  int? publishedAt;
@override@JsonKey(name: 'enclosure') final  PodcastFeedEpisodeEnclosure? enclosure;
@override@JsonKey(name: 'guid') final  String? guid;
@override@JsonKey(name: 'chaptersUrl') final  String? chaptersUrl;
@override@JsonKey(name: 'chaptersType') final  String? chaptersType;
 final  List<PodcastFeedEpisodeChapter> _chapters;
@override@JsonKey(name: 'chapters') List<PodcastFeedEpisodeChapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of PodcastFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFeedEpisodeCopyWith<_PodcastFeedEpisode> get copyWith => __$PodcastFeedEpisodeCopyWithImpl<_PodcastFeedEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastFeedEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFeedEpisode&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.author, author) || other.author == author)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.guid, guid) || other.guid == guid)&&(identical(other.chaptersUrl, chaptersUrl) || other.chaptersUrl == chaptersUrl)&&(identical(other.chaptersType, chaptersType) || other.chaptersType == chaptersType)&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,subtitle,description,descriptionPlain,pubDate,episodeType,season,episode,author,duration,durationSeconds,explicit,publishedAt,enclosure,guid,chaptersUrl,chaptersType,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'PodcastFeedEpisode(title: $title, subtitle: $subtitle, description: $description, descriptionPlain: $descriptionPlain, pubDate: $pubDate, episodeType: $episodeType, season: $season, episode: $episode, author: $author, duration: $duration, durationSeconds: $durationSeconds, explicit: $explicit, publishedAt: $publishedAt, enclosure: $enclosure, guid: $guid, chaptersUrl: $chaptersUrl, chaptersType: $chaptersType, chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class _$PodcastFeedEpisodeCopyWith<$Res> implements $PodcastFeedEpisodeCopyWith<$Res> {
  factory _$PodcastFeedEpisodeCopyWith(_PodcastFeedEpisode value, $Res Function(_PodcastFeedEpisode) _then) = __$PodcastFeedEpisodeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'subtitle') String? subtitle,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionPlain') String? descriptionPlain,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'episodeType') String? episodeType,@JsonKey(name: 'season') String? season,@JsonKey(name: 'episode') String? episode,@JsonKey(name: 'author') String? author,@JsonKey(name: 'duration') String? duration,@JsonKey(name: 'durationSeconds', fromJson: jsonIntFromDynamic) int? durationSeconds,@JsonKey(name: 'explicit') String? explicit,@JsonKey(name: 'publishedAt', fromJson: jsonIntFromDynamic) int? publishedAt,@JsonKey(name: 'enclosure') PodcastFeedEpisodeEnclosure? enclosure,@JsonKey(name: 'guid') String? guid,@JsonKey(name: 'chaptersUrl') String? chaptersUrl,@JsonKey(name: 'chaptersType') String? chaptersType,@JsonKey(name: 'chapters') List<PodcastFeedEpisodeChapter> chapters
});


@override $PodcastFeedEpisodeEnclosureCopyWith<$Res>? get enclosure;

}
/// @nodoc
class __$PodcastFeedEpisodeCopyWithImpl<$Res>
    implements _$PodcastFeedEpisodeCopyWith<$Res> {
  __$PodcastFeedEpisodeCopyWithImpl(this._self, this._then);

  final _PodcastFeedEpisode _self;
  final $Res Function(_PodcastFeedEpisode) _then;

/// Create a copy of PodcastFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? subtitle = freezed,Object? description = freezed,Object? descriptionPlain = freezed,Object? pubDate = freezed,Object? episodeType = freezed,Object? season = freezed,Object? episode = freezed,Object? author = freezed,Object? duration = freezed,Object? durationSeconds = freezed,Object? explicit = freezed,Object? publishedAt = freezed,Object? enclosure = freezed,Object? guid = freezed,Object? chaptersUrl = freezed,Object? chaptersType = freezed,Object? chapters = null,}) {
  return _then(_PodcastFeedEpisode(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionPlain: freezed == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as String?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as int?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as PodcastFeedEpisodeEnclosure?,guid: freezed == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String?,chaptersUrl: freezed == chaptersUrl ? _self.chaptersUrl : chaptersUrl // ignore: cast_nullable_to_non_nullable
as String?,chaptersType: freezed == chaptersType ? _self.chaptersType : chaptersType // ignore: cast_nullable_to_non_nullable
as String?,chapters: null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<PodcastFeedEpisodeChapter>,
  ));
}

/// Create a copy of PodcastFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastFeedEpisodeEnclosureCopyWith<$Res>? get enclosure {
    if (_self.enclosure == null) {
    return null;
  }

  return $PodcastFeedEpisodeEnclosureCopyWith<$Res>(_self.enclosure!, (value) {
    return _then(_self.copyWith(enclosure: value));
  });
}
}


/// @nodoc
mixin _$PodcastFeedEpisodeEnclosure {

@JsonKey(name: 'url') String? get url;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? get length;
/// Create a copy of PodcastFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFeedEpisodeEnclosureCopyWith<PodcastFeedEpisodeEnclosure> get copyWith => _$PodcastFeedEpisodeEnclosureCopyWithImpl<PodcastFeedEpisodeEnclosure>(this as PodcastFeedEpisodeEnclosure, _$identity);

  /// Serializes this PodcastFeedEpisodeEnclosure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFeedEpisodeEnclosure&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.length, length) || other.length == length));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,type,length);

@override
String toString() {
  return 'PodcastFeedEpisodeEnclosure(url: $url, type: $type, length: $length)';
}


}

/// @nodoc
abstract mixin class $PodcastFeedEpisodeEnclosureCopyWith<$Res>  {
  factory $PodcastFeedEpisodeEnclosureCopyWith(PodcastFeedEpisodeEnclosure value, $Res Function(PodcastFeedEpisodeEnclosure) _then) = _$PodcastFeedEpisodeEnclosureCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'type') String? type,@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? length
});




}
/// @nodoc
class _$PodcastFeedEpisodeEnclosureCopyWithImpl<$Res>
    implements $PodcastFeedEpisodeEnclosureCopyWith<$Res> {
  _$PodcastFeedEpisodeEnclosureCopyWithImpl(this._self, this._then);

  final PodcastFeedEpisodeEnclosure _self;
  final $Res Function(PodcastFeedEpisodeEnclosure) _then;

/// Create a copy of PodcastFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? type = freezed,Object? length = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastFeedEpisodeEnclosure].
extension PodcastFeedEpisodeEnclosurePatterns on PodcastFeedEpisodeEnclosure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFeedEpisodeEnclosure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFeedEpisodeEnclosure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFeedEpisodeEnclosure value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedEpisodeEnclosure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFeedEpisodeEnclosure value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedEpisodeEnclosure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic)  int? length)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFeedEpisodeEnclosure() when $default != null:
return $default(_that.url,_that.type,_that.length);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic)  int? length)  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedEpisodeEnclosure():
return $default(_that.url,_that.type,_that.length);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic)  int? length)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedEpisodeEnclosure() when $default != null:
return $default(_that.url,_that.type,_that.length);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastFeedEpisodeEnclosure implements PodcastFeedEpisodeEnclosure {
  const _PodcastFeedEpisodeEnclosure({@JsonKey(name: 'url') this.url, @JsonKey(name: 'type') this.type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic) this.length});
  factory _PodcastFeedEpisodeEnclosure.fromJson(Map<String, dynamic> json) => _$PodcastFeedEpisodeEnclosureFromJson(json);

@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) final  int? length;

/// Create a copy of PodcastFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFeedEpisodeEnclosureCopyWith<_PodcastFeedEpisodeEnclosure> get copyWith => __$PodcastFeedEpisodeEnclosureCopyWithImpl<_PodcastFeedEpisodeEnclosure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastFeedEpisodeEnclosureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFeedEpisodeEnclosure&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.length, length) || other.length == length));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,type,length);

@override
String toString() {
  return 'PodcastFeedEpisodeEnclosure(url: $url, type: $type, length: $length)';
}


}

/// @nodoc
abstract mixin class _$PodcastFeedEpisodeEnclosureCopyWith<$Res> implements $PodcastFeedEpisodeEnclosureCopyWith<$Res> {
  factory _$PodcastFeedEpisodeEnclosureCopyWith(_PodcastFeedEpisodeEnclosure value, $Res Function(_PodcastFeedEpisodeEnclosure) _then) = __$PodcastFeedEpisodeEnclosureCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'type') String? type,@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? length
});




}
/// @nodoc
class __$PodcastFeedEpisodeEnclosureCopyWithImpl<$Res>
    implements _$PodcastFeedEpisodeEnclosureCopyWith<$Res> {
  __$PodcastFeedEpisodeEnclosureCopyWithImpl(this._self, this._then);

  final _PodcastFeedEpisodeEnclosure _self;
  final $Res Function(_PodcastFeedEpisodeEnclosure) _then;

/// Create a copy of PodcastFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? type = freezed,Object? length = freezed,}) {
  return _then(_PodcastFeedEpisodeEnclosure(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PodcastFeedEpisodeChapter {

@JsonKey(name: 'title') String? get title;@JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic) double? get start;
/// Create a copy of PodcastFeedEpisodeChapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastFeedEpisodeChapterCopyWith<PodcastFeedEpisodeChapter> get copyWith => _$PodcastFeedEpisodeChapterCopyWithImpl<PodcastFeedEpisodeChapter>(this as PodcastFeedEpisodeChapter, _$identity);

  /// Serializes this PodcastFeedEpisodeChapter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastFeedEpisodeChapter&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,start);

@override
String toString() {
  return 'PodcastFeedEpisodeChapter(title: $title, start: $start)';
}


}

/// @nodoc
abstract mixin class $PodcastFeedEpisodeChapterCopyWith<$Res>  {
  factory $PodcastFeedEpisodeChapterCopyWith(PodcastFeedEpisodeChapter value, $Res Function(PodcastFeedEpisodeChapter) _then) = _$PodcastFeedEpisodeChapterCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic) double? start
});




}
/// @nodoc
class _$PodcastFeedEpisodeChapterCopyWithImpl<$Res>
    implements $PodcastFeedEpisodeChapterCopyWith<$Res> {
  _$PodcastFeedEpisodeChapterCopyWithImpl(this._self, this._then);

  final PodcastFeedEpisodeChapter _self;
  final $Res Function(PodcastFeedEpisodeChapter) _then;

/// Create a copy of PodcastFeedEpisodeChapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? start = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastFeedEpisodeChapter].
extension PodcastFeedEpisodeChapterPatterns on PodcastFeedEpisodeChapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastFeedEpisodeChapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastFeedEpisodeChapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastFeedEpisodeChapter value)  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedEpisodeChapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastFeedEpisodeChapter value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastFeedEpisodeChapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic)  double? start)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastFeedEpisodeChapter() when $default != null:
return $default(_that.title,_that.start);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic)  double? start)  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedEpisodeChapter():
return $default(_that.title,_that.start);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic)  double? start)?  $default,) {final _that = this;
switch (_that) {
case _PodcastFeedEpisodeChapter() when $default != null:
return $default(_that.title,_that.start);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastFeedEpisodeChapter implements PodcastFeedEpisodeChapter {
  const _PodcastFeedEpisodeChapter({@JsonKey(name: 'title') this.title, @JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic) this.start});
  factory _PodcastFeedEpisodeChapter.fromJson(Map<String, dynamic> json) => _$PodcastFeedEpisodeChapterFromJson(json);

@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic) final  double? start;

/// Create a copy of PodcastFeedEpisodeChapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastFeedEpisodeChapterCopyWith<_PodcastFeedEpisodeChapter> get copyWith => __$PodcastFeedEpisodeChapterCopyWithImpl<_PodcastFeedEpisodeChapter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastFeedEpisodeChapterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastFeedEpisodeChapter&&(identical(other.title, title) || other.title == title)&&(identical(other.start, start) || other.start == start));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,start);

@override
String toString() {
  return 'PodcastFeedEpisodeChapter(title: $title, start: $start)';
}


}

/// @nodoc
abstract mixin class _$PodcastFeedEpisodeChapterCopyWith<$Res> implements $PodcastFeedEpisodeChapterCopyWith<$Res> {
  factory _$PodcastFeedEpisodeChapterCopyWith(_PodcastFeedEpisodeChapter value, $Res Function(_PodcastFeedEpisodeChapter) _then) = __$PodcastFeedEpisodeChapterCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'start', fromJson: jsonDoubleFromDynamic) double? start
});




}
/// @nodoc
class __$PodcastFeedEpisodeChapterCopyWithImpl<$Res>
    implements _$PodcastFeedEpisodeChapterCopyWith<$Res> {
  __$PodcastFeedEpisodeChapterCopyWithImpl(this._self, this._then);

  final _PodcastFeedEpisodeChapter _self;
  final $Res Function(_PodcastFeedEpisodeChapter) _then;

/// Create a copy of PodcastFeedEpisodeChapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? start = freezed,}) {
  return _then(_PodcastFeedEpisodeChapter(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
