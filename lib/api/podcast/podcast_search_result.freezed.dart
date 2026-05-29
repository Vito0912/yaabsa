// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_search_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PodcastSearchResult {

@JsonKey(name: 'id', fromJson: jsonStringFromDynamic) String? get id;@JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic) String? get artistId;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'artistName') String? get artistName;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'descriptionPlain') String? get descriptionPlain;@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> get genres;@JsonKey(name: 'cover') String? get cover;@JsonKey(name: 'feedUrl') String? get feedUrl;@JsonKey(name: 'pageUrl') String? get pageUrl;@JsonKey(name: 'releaseDate') String? get releaseDate;@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? get explicit;@JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic) int? get trackCount;@JsonKey(name: 'language') String? get language;@JsonKey(name: 'type') String? get type;
/// Create a copy of PodcastSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastSearchResultCopyWith<PodcastSearchResult> get copyWith => _$PodcastSearchResultCopyWithImpl<PodcastSearchResult>(this as PodcastSearchResult, _$identity);

  /// Serializes this PodcastSearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.pageUrl, pageUrl) || other.pageUrl == pageUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.language, language) || other.language == language)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,artistId,title,artistName,description,descriptionPlain,const DeepCollectionEquality().hash(genres),cover,feedUrl,pageUrl,releaseDate,explicit,trackCount,language,type);

@override
String toString() {
  return 'PodcastSearchResult(id: $id, artistId: $artistId, title: $title, artistName: $artistName, description: $description, descriptionPlain: $descriptionPlain, genres: $genres, cover: $cover, feedUrl: $feedUrl, pageUrl: $pageUrl, releaseDate: $releaseDate, explicit: $explicit, trackCount: $trackCount, language: $language, type: $type)';
}


}

/// @nodoc
abstract mixin class $PodcastSearchResultCopyWith<$Res>  {
  factory $PodcastSearchResultCopyWith(PodcastSearchResult value, $Res Function(PodcastSearchResult) _then) = _$PodcastSearchResultCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id', fromJson: jsonStringFromDynamic) String? id,@JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic) String? artistId,@JsonKey(name: 'title') String? title,@JsonKey(name: 'artistName') String? artistName,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionPlain') String? descriptionPlain,@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> genres,@JsonKey(name: 'cover') String? cover,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'pageUrl') String? pageUrl,@JsonKey(name: 'releaseDate') String? releaseDate,@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? explicit,@JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic) int? trackCount,@JsonKey(name: 'language') String? language,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$PodcastSearchResultCopyWithImpl<$Res>
    implements $PodcastSearchResultCopyWith<$Res> {
  _$PodcastSearchResultCopyWithImpl(this._self, this._then);

  final PodcastSearchResult _self;
  final $Res Function(PodcastSearchResult) _then;

/// Create a copy of PodcastSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? artistId = freezed,Object? title = freezed,Object? artistName = freezed,Object? description = freezed,Object? descriptionPlain = freezed,Object? genres = null,Object? cover = freezed,Object? feedUrl = freezed,Object? pageUrl = freezed,Object? releaseDate = freezed,Object? explicit = freezed,Object? trackCount = freezed,Object? language = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artistName: freezed == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionPlain: freezed == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,pageUrl: freezed == pageUrl ? _self.pageUrl : pageUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,trackCount: freezed == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PodcastSearchResult].
extension PodcastSearchResultPatterns on PodcastSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _PodcastSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', fromJson: jsonStringFromDynamic)  String? id, @JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic)  String? artistId, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'artistName')  String? artistName, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic)  List<String> genres, @JsonKey(name: 'cover')  String? cover, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'pageUrl')  String? pageUrl, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic)  bool? explicit, @JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic)  int? trackCount, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastSearchResult() when $default != null:
return $default(_that.id,_that.artistId,_that.title,_that.artistName,_that.description,_that.descriptionPlain,_that.genres,_that.cover,_that.feedUrl,_that.pageUrl,_that.releaseDate,_that.explicit,_that.trackCount,_that.language,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id', fromJson: jsonStringFromDynamic)  String? id, @JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic)  String? artistId, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'artistName')  String? artistName, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic)  List<String> genres, @JsonKey(name: 'cover')  String? cover, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'pageUrl')  String? pageUrl, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic)  bool? explicit, @JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic)  int? trackCount, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _PodcastSearchResult():
return $default(_that.id,_that.artistId,_that.title,_that.artistName,_that.description,_that.descriptionPlain,_that.genres,_that.cover,_that.feedUrl,_that.pageUrl,_that.releaseDate,_that.explicit,_that.trackCount,_that.language,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id', fromJson: jsonStringFromDynamic)  String? id, @JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic)  String? artistId, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'artistName')  String? artistName, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'descriptionPlain')  String? descriptionPlain, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic)  List<String> genres, @JsonKey(name: 'cover')  String? cover, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'pageUrl')  String? pageUrl, @JsonKey(name: 'releaseDate')  String? releaseDate, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic)  bool? explicit, @JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic)  int? trackCount, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _PodcastSearchResult() when $default != null:
return $default(_that.id,_that.artistId,_that.title,_that.artistName,_that.description,_that.descriptionPlain,_that.genres,_that.cover,_that.feedUrl,_that.pageUrl,_that.releaseDate,_that.explicit,_that.trackCount,_that.language,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastSearchResult implements PodcastSearchResult {
  const _PodcastSearchResult({@JsonKey(name: 'id', fromJson: jsonStringFromDynamic) this.id, @JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic) this.artistId, @JsonKey(name: 'title') this.title, @JsonKey(name: 'artistName') this.artistName, @JsonKey(name: 'description') this.description, @JsonKey(name: 'descriptionPlain') this.descriptionPlain, @JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) final  List<String> genres = const <String>[], @JsonKey(name: 'cover') this.cover, @JsonKey(name: 'feedUrl') this.feedUrl, @JsonKey(name: 'pageUrl') this.pageUrl, @JsonKey(name: 'releaseDate') this.releaseDate, @JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) this.explicit, @JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic) this.trackCount, @JsonKey(name: 'language') this.language, @JsonKey(name: 'type') this.type}): _genres = genres;
  factory _PodcastSearchResult.fromJson(Map<String, dynamic> json) => _$PodcastSearchResultFromJson(json);

@override@JsonKey(name: 'id', fromJson: jsonStringFromDynamic) final  String? id;
@override@JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic) final  String? artistId;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'artistName') final  String? artistName;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'descriptionPlain') final  String? descriptionPlain;
 final  List<String> _genres;
@override@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

@override@JsonKey(name: 'cover') final  String? cover;
@override@JsonKey(name: 'feedUrl') final  String? feedUrl;
@override@JsonKey(name: 'pageUrl') final  String? pageUrl;
@override@JsonKey(name: 'releaseDate') final  String? releaseDate;
@override@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) final  bool? explicit;
@override@JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic) final  int? trackCount;
@override@JsonKey(name: 'language') final  String? language;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of PodcastSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastSearchResultCopyWith<_PodcastSearchResult> get copyWith => __$PodcastSearchResultCopyWithImpl<_PodcastSearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastSearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastSearchResult&&(identical(other.id, id) || other.id == id)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.title, title) || other.title == title)&&(identical(other.artistName, artistName) || other.artistName == artistName)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionPlain, descriptionPlain) || other.descriptionPlain == descriptionPlain)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.cover, cover) || other.cover == cover)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.pageUrl, pageUrl) || other.pageUrl == pageUrl)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.trackCount, trackCount) || other.trackCount == trackCount)&&(identical(other.language, language) || other.language == language)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,artistId,title,artistName,description,descriptionPlain,const DeepCollectionEquality().hash(_genres),cover,feedUrl,pageUrl,releaseDate,explicit,trackCount,language,type);

@override
String toString() {
  return 'PodcastSearchResult(id: $id, artistId: $artistId, title: $title, artistName: $artistName, description: $description, descriptionPlain: $descriptionPlain, genres: $genres, cover: $cover, feedUrl: $feedUrl, pageUrl: $pageUrl, releaseDate: $releaseDate, explicit: $explicit, trackCount: $trackCount, language: $language, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PodcastSearchResultCopyWith<$Res> implements $PodcastSearchResultCopyWith<$Res> {
  factory _$PodcastSearchResultCopyWith(_PodcastSearchResult value, $Res Function(_PodcastSearchResult) _then) = __$PodcastSearchResultCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id', fromJson: jsonStringFromDynamic) String? id,@JsonKey(name: 'artistId', fromJson: jsonStringFromDynamic) String? artistId,@JsonKey(name: 'title') String? title,@JsonKey(name: 'artistName') String? artistName,@JsonKey(name: 'description') String? description,@JsonKey(name: 'descriptionPlain') String? descriptionPlain,@JsonKey(name: 'genres', fromJson: jsonStringListFromDynamic) List<String> genres,@JsonKey(name: 'cover') String? cover,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'pageUrl') String? pageUrl,@JsonKey(name: 'releaseDate') String? releaseDate,@JsonKey(name: 'explicit', fromJson: jsonBoolFromDynamic) bool? explicit,@JsonKey(name: 'trackCount', fromJson: jsonIntFromDynamic) int? trackCount,@JsonKey(name: 'language') String? language,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$PodcastSearchResultCopyWithImpl<$Res>
    implements _$PodcastSearchResultCopyWith<$Res> {
  __$PodcastSearchResultCopyWithImpl(this._self, this._then);

  final _PodcastSearchResult _self;
  final $Res Function(_PodcastSearchResult) _then;

/// Create a copy of PodcastSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? artistId = freezed,Object? title = freezed,Object? artistName = freezed,Object? description = freezed,Object? descriptionPlain = freezed,Object? genres = null,Object? cover = freezed,Object? feedUrl = freezed,Object? pageUrl = freezed,Object? releaseDate = freezed,Object? explicit = freezed,Object? trackCount = freezed,Object? language = freezed,Object? type = freezed,}) {
  return _then(_PodcastSearchResult(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artistName: freezed == artistName ? _self.artistName : artistName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionPlain: freezed == descriptionPlain ? _self.descriptionPlain : descriptionPlain // ignore: cast_nullable_to_non_nullable
as String?,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,cover: freezed == cover ? _self.cover : cover // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,pageUrl: freezed == pageUrl ? _self.pageUrl : pageUrl // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,trackCount: freezed == trackCount ? _self.trackCount : trackCount // ignore: cast_nullable_to_non_nullable
as int?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
