// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_podcast_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePodcastRequest {

@JsonKey(name: 'path') String get path;@JsonKey(name: 'folderId') String get folderId;@JsonKey(name: 'libraryId') String get libraryId;@JsonKey(name: 'media') CreatePodcastMedia get media;
/// Create a copy of CreatePodcastRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePodcastRequestCopyWith<CreatePodcastRequest> get copyWith => _$CreatePodcastRequestCopyWithImpl<CreatePodcastRequest>(this as CreatePodcastRequest, _$identity);

  /// Serializes this CreatePodcastRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePodcastRequest&&(identical(other.path, path) || other.path == path)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.media, media) || other.media == media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,folderId,libraryId,media);

@override
String toString() {
  return 'CreatePodcastRequest(path: $path, folderId: $folderId, libraryId: $libraryId, media: $media)';
}


}

/// @nodoc
abstract mixin class $CreatePodcastRequestCopyWith<$Res>  {
  factory $CreatePodcastRequestCopyWith(CreatePodcastRequest value, $Res Function(CreatePodcastRequest) _then) = _$CreatePodcastRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'folderId') String folderId,@JsonKey(name: 'libraryId') String libraryId,@JsonKey(name: 'media') CreatePodcastMedia media
});


$CreatePodcastMediaCopyWith<$Res> get media;

}
/// @nodoc
class _$CreatePodcastRequestCopyWithImpl<$Res>
    implements $CreatePodcastRequestCopyWith<$Res> {
  _$CreatePodcastRequestCopyWithImpl(this._self, this._then);

  final CreatePodcastRequest _self;
  final $Res Function(CreatePodcastRequest) _then;

/// Create a copy of CreatePodcastRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? folderId = null,Object? libraryId = null,Object? media = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as CreatePodcastMedia,
  ));
}
/// Create a copy of CreatePodcastRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatePodcastMediaCopyWith<$Res> get media {
  
  return $CreatePodcastMediaCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatePodcastRequest].
extension CreatePodcastRequestPatterns on CreatePodcastRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePodcastRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePodcastRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePodcastRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePodcastRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'folderId')  String folderId, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'media')  CreatePodcastMedia media)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePodcastRequest() when $default != null:
return $default(_that.path,_that.folderId,_that.libraryId,_that.media);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'folderId')  String folderId, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'media')  CreatePodcastMedia media)  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastRequest():
return $default(_that.path,_that.folderId,_that.libraryId,_that.media);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'folderId')  String folderId, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'media')  CreatePodcastMedia media)?  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastRequest() when $default != null:
return $default(_that.path,_that.folderId,_that.libraryId,_that.media);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePodcastRequest implements CreatePodcastRequest {
  const _CreatePodcastRequest({@JsonKey(name: 'path') required this.path, @JsonKey(name: 'folderId') required this.folderId, @JsonKey(name: 'libraryId') required this.libraryId, @JsonKey(name: 'media') required this.media});
  factory _CreatePodcastRequest.fromJson(Map<String, dynamic> json) => _$CreatePodcastRequestFromJson(json);

@override@JsonKey(name: 'path') final  String path;
@override@JsonKey(name: 'folderId') final  String folderId;
@override@JsonKey(name: 'libraryId') final  String libraryId;
@override@JsonKey(name: 'media') final  CreatePodcastMedia media;

/// Create a copy of CreatePodcastRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePodcastRequestCopyWith<_CreatePodcastRequest> get copyWith => __$CreatePodcastRequestCopyWithImpl<_CreatePodcastRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePodcastRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePodcastRequest&&(identical(other.path, path) || other.path == path)&&(identical(other.folderId, folderId) || other.folderId == folderId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.media, media) || other.media == media));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,folderId,libraryId,media);

@override
String toString() {
  return 'CreatePodcastRequest(path: $path, folderId: $folderId, libraryId: $libraryId, media: $media)';
}


}

/// @nodoc
abstract mixin class _$CreatePodcastRequestCopyWith<$Res> implements $CreatePodcastRequestCopyWith<$Res> {
  factory _$CreatePodcastRequestCopyWith(_CreatePodcastRequest value, $Res Function(_CreatePodcastRequest) _then) = __$CreatePodcastRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'folderId') String folderId,@JsonKey(name: 'libraryId') String libraryId,@JsonKey(name: 'media') CreatePodcastMedia media
});


@override $CreatePodcastMediaCopyWith<$Res> get media;

}
/// @nodoc
class __$CreatePodcastRequestCopyWithImpl<$Res>
    implements _$CreatePodcastRequestCopyWith<$Res> {
  __$CreatePodcastRequestCopyWithImpl(this._self, this._then);

  final _CreatePodcastRequest _self;
  final $Res Function(_CreatePodcastRequest) _then;

/// Create a copy of CreatePodcastRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? folderId = null,Object? libraryId = null,Object? media = null,}) {
  return _then(_CreatePodcastRequest(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,folderId: null == folderId ? _self.folderId : folderId // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,media: null == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as CreatePodcastMedia,
  ));
}

/// Create a copy of CreatePodcastRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatePodcastMediaCopyWith<$Res> get media {
  
  return $CreatePodcastMediaCopyWith<$Res>(_self.media, (value) {
    return _then(_self.copyWith(media: value));
  });
}
}


/// @nodoc
mixin _$CreatePodcastMedia {

@JsonKey(name: 'metadata') CreatePodcastMetadata get metadata;@JsonKey(name: 'autoDownloadEpisodes') bool get autoDownloadEpisodes;
/// Create a copy of CreatePodcastMedia
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePodcastMediaCopyWith<CreatePodcastMedia> get copyWith => _$CreatePodcastMediaCopyWithImpl<CreatePodcastMedia>(this as CreatePodcastMedia, _$identity);

  /// Serializes this CreatePodcastMedia to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePodcastMedia&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.autoDownloadEpisodes, autoDownloadEpisodes) || other.autoDownloadEpisodes == autoDownloadEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,autoDownloadEpisodes);

@override
String toString() {
  return 'CreatePodcastMedia(metadata: $metadata, autoDownloadEpisodes: $autoDownloadEpisodes)';
}


}

/// @nodoc
abstract mixin class $CreatePodcastMediaCopyWith<$Res>  {
  factory $CreatePodcastMediaCopyWith(CreatePodcastMedia value, $Res Function(CreatePodcastMedia) _then) = _$CreatePodcastMediaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metadata') CreatePodcastMetadata metadata,@JsonKey(name: 'autoDownloadEpisodes') bool autoDownloadEpisodes
});


$CreatePodcastMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$CreatePodcastMediaCopyWithImpl<$Res>
    implements $CreatePodcastMediaCopyWith<$Res> {
  _$CreatePodcastMediaCopyWithImpl(this._self, this._then);

  final CreatePodcastMedia _self;
  final $Res Function(CreatePodcastMedia) _then;

/// Create a copy of CreatePodcastMedia
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = null,Object? autoDownloadEpisodes = null,}) {
  return _then(_self.copyWith(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as CreatePodcastMetadata,autoDownloadEpisodes: null == autoDownloadEpisodes ? _self.autoDownloadEpisodes : autoDownloadEpisodes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of CreatePodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatePodcastMetadataCopyWith<$Res> get metadata {
  
  return $CreatePodcastMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatePodcastMedia].
extension CreatePodcastMediaPatterns on CreatePodcastMedia {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePodcastMedia value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePodcastMedia() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePodcastMedia value)  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastMedia():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePodcastMedia value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastMedia() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  CreatePodcastMetadata metadata, @JsonKey(name: 'autoDownloadEpisodes')  bool autoDownloadEpisodes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePodcastMedia() when $default != null:
return $default(_that.metadata,_that.autoDownloadEpisodes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  CreatePodcastMetadata metadata, @JsonKey(name: 'autoDownloadEpisodes')  bool autoDownloadEpisodes)  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastMedia():
return $default(_that.metadata,_that.autoDownloadEpisodes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metadata')  CreatePodcastMetadata metadata, @JsonKey(name: 'autoDownloadEpisodes')  bool autoDownloadEpisodes)?  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastMedia() when $default != null:
return $default(_that.metadata,_that.autoDownloadEpisodes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePodcastMedia implements CreatePodcastMedia {
  const _CreatePodcastMedia({@JsonKey(name: 'metadata') required this.metadata, @JsonKey(name: 'autoDownloadEpisodes') this.autoDownloadEpisodes = false});
  factory _CreatePodcastMedia.fromJson(Map<String, dynamic> json) => _$CreatePodcastMediaFromJson(json);

@override@JsonKey(name: 'metadata') final  CreatePodcastMetadata metadata;
@override@JsonKey(name: 'autoDownloadEpisodes') final  bool autoDownloadEpisodes;

/// Create a copy of CreatePodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePodcastMediaCopyWith<_CreatePodcastMedia> get copyWith => __$CreatePodcastMediaCopyWithImpl<_CreatePodcastMedia>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePodcastMediaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePodcastMedia&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.autoDownloadEpisodes, autoDownloadEpisodes) || other.autoDownloadEpisodes == autoDownloadEpisodes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,autoDownloadEpisodes);

@override
String toString() {
  return 'CreatePodcastMedia(metadata: $metadata, autoDownloadEpisodes: $autoDownloadEpisodes)';
}


}

/// @nodoc
abstract mixin class _$CreatePodcastMediaCopyWith<$Res> implements $CreatePodcastMediaCopyWith<$Res> {
  factory _$CreatePodcastMediaCopyWith(_CreatePodcastMedia value, $Res Function(_CreatePodcastMedia) _then) = __$CreatePodcastMediaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metadata') CreatePodcastMetadata metadata,@JsonKey(name: 'autoDownloadEpisodes') bool autoDownloadEpisodes
});


@override $CreatePodcastMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$CreatePodcastMediaCopyWithImpl<$Res>
    implements _$CreatePodcastMediaCopyWith<$Res> {
  __$CreatePodcastMediaCopyWithImpl(this._self, this._then);

  final _CreatePodcastMedia _self;
  final $Res Function(_CreatePodcastMedia) _then;

/// Create a copy of CreatePodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = null,Object? autoDownloadEpisodes = null,}) {
  return _then(_CreatePodcastMedia(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as CreatePodcastMetadata,autoDownloadEpisodes: null == autoDownloadEpisodes ? _self.autoDownloadEpisodes : autoDownloadEpisodes // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of CreatePodcastMedia
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CreatePodcastMetadataCopyWith<$Res> get metadata {
  
  return $CreatePodcastMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// @nodoc
mixin _$CreatePodcastMetadata {

@JsonKey(name: 'title') String get title;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'releaseDate') String? get releaseDate;@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> get genres;@JsonKey(name: 'feedUrl') String get feedUrl;@JsonKey(name: 'imageUrl') String? get imageUrl;@JsonKey(name: 'itunesPageUrl') String? get itunesPageUrl;@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? get itunesId;@JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic) String? get itunesArtistId;@JsonKey(name: 'language') String? get language;@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? get explicit;@JsonKey(name: 'type') String? get type;
/// Create a copy of CreatePodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePodcastMetadataCopyWith<CreatePodcastMetadata> get copyWith => _$CreatePodcastMetadataCopyWithImpl<CreatePodcastMetadata>(this as CreatePodcastMetadata, _$identity);

  /// Serializes this CreatePodcastMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePodcastMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.itunesPageUrl, itunesPageUrl) || other.itunesPageUrl == itunesPageUrl)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId)&&(identical(other.itunesArtistId, itunesArtistId) || other.itunesArtistId == itunesArtistId)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,releaseDate,const DeepCollectionEquality().hash(genres),feedUrl,imageUrl,itunesPageUrl,itunesId,itunesArtistId,language,explicit,type);

@override
String toString() {
  return 'CreatePodcastMetadata(title: $title, author: $author, description: $description, releaseDate: $releaseDate, genres: $genres, feedUrl: $feedUrl, imageUrl: $imageUrl, itunesPageUrl: $itunesPageUrl, itunesId: $itunesId, itunesArtistId: $itunesArtistId, language: $language, explicit: $explicit, type: $type)';
}


}

/// @nodoc
abstract mixin class $CreatePodcastMetadataCopyWith<$Res>  {
  factory $CreatePodcastMetadataCopyWith(CreatePodcastMetadata value, $Res Function(CreatePodcastMetadata) _then) = _$CreatePodcastMetadataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'author') String? author,@JsonKey(name: 'description') String? description,@JsonKey(name: 'releaseDate') String? releaseDate,@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> genres,@JsonKey(name: 'feedUrl') String feedUrl,@JsonKey(name: 'imageUrl') String? imageUrl,@JsonKey(name: 'itunesPageUrl') String? itunesPageUrl,@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? itunesId,@JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic) String? itunesArtistId,@JsonKey(name: 'language') String? language,@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? explicit,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$CreatePodcastMetadataCopyWithImpl<$Res>
    implements $CreatePodcastMetadataCopyWith<$Res> {
  _$CreatePodcastMetadataCopyWithImpl(this._self, this._then);

  final CreatePodcastMetadata _self;
  final $Res Function(CreatePodcastMetadata) _then;

/// Create a copy of CreatePodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? author = freezed,Object? description = freezed,Object? releaseDate = freezed,Object? genres = null,Object? feedUrl = null,Object? imageUrl = freezed,Object? itunesPageUrl = freezed,Object? itunesId = freezed,Object? itunesArtistId = freezed,Object? language = freezed,Object? explicit = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,feedUrl: null == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesPageUrl: freezed == itunesPageUrl ? _self.itunesPageUrl : itunesPageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,itunesArtistId: freezed == itunesArtistId ? _self.itunesArtistId : itunesArtistId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreatePodcastMetadata].
extension CreatePodcastMetadataPatterns on CreatePodcastMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePodcastMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePodcastMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePodcastMetadata value)  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePodcastMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic)  List<String> genres, @JsonKey(name: 'feedUrl')  String feedUrl, @JsonKey(name: 'imageUrl')  String? imageUrl, @JsonKey(name: 'itunesPageUrl')  String? itunesPageUrl, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic)  String? itunesId, @JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic)  String? itunesArtistId, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic)  bool? explicit, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePodcastMetadata() when $default != null:
return $default(_that.title,_that.author,_that.description,_that.releaseDate,_that.genres,_that.feedUrl,_that.imageUrl,_that.itunesPageUrl,_that.itunesId,_that.itunesArtistId,_that.language,_that.explicit,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic)  List<String> genres, @JsonKey(name: 'feedUrl')  String feedUrl, @JsonKey(name: 'imageUrl')  String? imageUrl, @JsonKey(name: 'itunesPageUrl')  String? itunesPageUrl, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic)  String? itunesId, @JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic)  String? itunesArtistId, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic)  bool? explicit, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastMetadata():
return $default(_that.title,_that.author,_that.description,_that.releaseDate,_that.genres,_that.feedUrl,_that.imageUrl,_that.itunesPageUrl,_that.itunesId,_that.itunesArtistId,_that.language,_that.explicit,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String title, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic)  List<String> genres, @JsonKey(name: 'feedUrl')  String feedUrl, @JsonKey(name: 'imageUrl')  String? imageUrl, @JsonKey(name: 'itunesPageUrl')  String? itunesPageUrl, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic)  String? itunesId, @JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic)  String? itunesArtistId, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic)  bool? explicit, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastMetadata() when $default != null:
return $default(_that.title,_that.author,_that.description,_that.releaseDate,_that.genres,_that.feedUrl,_that.imageUrl,_that.itunesPageUrl,_that.itunesId,_that.itunesArtistId,_that.language,_that.explicit,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePodcastMetadata implements CreatePodcastMetadata {
  const _CreatePodcastMetadata({@JsonKey(name: 'title') required this.title, @JsonKey(name: 'author') this.author, @JsonKey(name: 'description') this.description, @JsonKey(name: 'releaseDate') this.releaseDate, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) final  List<String> genres = const <String>[], @JsonKey(name: 'feedUrl') required this.feedUrl, @JsonKey(name: 'imageUrl') this.imageUrl, @JsonKey(name: 'itunesPageUrl') this.itunesPageUrl, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) this.itunesId, @JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic) this.itunesArtistId, @JsonKey(name: 'language') this.language, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) this.explicit, @JsonKey(name: 'type') this.type}): _genres = genres;
  factory _CreatePodcastMetadata.fromJson(Map<String, dynamic> json) => _$CreatePodcastMetadataFromJson(json);

@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'releaseDate') final  String? releaseDate;
 final  List<String> _genres;
@override@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey(name: 'feedUrl') final  String feedUrl;
@override@JsonKey(name: 'imageUrl') final  String? imageUrl;
@override@JsonKey(name: 'itunesPageUrl') final  String? itunesPageUrl;
@override@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) final  String? itunesId;
@override@JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic) final  String? itunesArtistId;
@override@JsonKey(name: 'language') final  String? language;
@override@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) final  bool? explicit;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of CreatePodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePodcastMetadataCopyWith<_CreatePodcastMetadata> get copyWith => __$CreatePodcastMetadataCopyWithImpl<_CreatePodcastMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePodcastMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePodcastMetadata&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.description, description) || other.description == description)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.itunesPageUrl, itunesPageUrl) || other.itunesPageUrl == itunesPageUrl)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId)&&(identical(other.itunesArtistId, itunesArtistId) || other.itunesArtistId == itunesArtistId)&&(identical(other.language, language) || other.language == language)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,author,description,releaseDate,const DeepCollectionEquality().hash(_genres),feedUrl,imageUrl,itunesPageUrl,itunesId,itunesArtistId,language,explicit,type);

@override
String toString() {
  return 'CreatePodcastMetadata(title: $title, author: $author, description: $description, releaseDate: $releaseDate, genres: $genres, feedUrl: $feedUrl, imageUrl: $imageUrl, itunesPageUrl: $itunesPageUrl, itunesId: $itunesId, itunesArtistId: $itunesArtistId, language: $language, explicit: $explicit, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CreatePodcastMetadataCopyWith<$Res> implements $CreatePodcastMetadataCopyWith<$Res> {
  factory _$CreatePodcastMetadataCopyWith(_CreatePodcastMetadata value, $Res Function(_CreatePodcastMetadata) _then) = __$CreatePodcastMetadataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String title,@JsonKey(name: 'author') String? author,@JsonKey(name: 'description') String? description,@JsonKey(name: 'releaseDate') String? releaseDate,@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> genres,@JsonKey(name: 'feedUrl') String feedUrl,@JsonKey(name: 'imageUrl') String? imageUrl,@JsonKey(name: 'itunesPageUrl') String? itunesPageUrl,@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? itunesId,@JsonKey(name: 'itunesArtistId', fromJson: jsonStringFromDynamic) String? itunesArtistId,@JsonKey(name: 'language') String? language,@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? explicit,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$CreatePodcastMetadataCopyWithImpl<$Res>
    implements _$CreatePodcastMetadataCopyWith<$Res> {
  __$CreatePodcastMetadataCopyWithImpl(this._self, this._then);

  final _CreatePodcastMetadata _self;
  final $Res Function(_CreatePodcastMetadata) _then;

/// Create a copy of CreatePodcastMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? author = freezed,Object? description = freezed,Object? releaseDate = freezed,Object? genres = null,Object? feedUrl = null,Object? imageUrl = freezed,Object? itunesPageUrl = freezed,Object? itunesId = freezed,Object? itunesArtistId = freezed,Object? language = freezed,Object? explicit = freezed,Object? type = freezed,}) {
  return _then(_CreatePodcastMetadata(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,feedUrl: null == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesPageUrl: freezed == itunesPageUrl ? _self.itunesPageUrl : itunesPageUrl // ignore: cast_nullable_to_non_nullable
as String?,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,itunesArtistId: freezed == itunesArtistId ? _self.itunesArtistId : itunesArtistId // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
