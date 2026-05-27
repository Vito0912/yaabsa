// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_rss_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminRssFeedsResponse {

@JsonKey(name: 'feeds') List<AdminRssFeed> get feeds;@JsonKey(name: 'minified') List<AdminRssFeedMinified> get minified;
/// Create a copy of AdminRssFeedsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRssFeedsResponseCopyWith<AdminRssFeedsResponse> get copyWith => _$AdminRssFeedsResponseCopyWithImpl<AdminRssFeedsResponse>(this as AdminRssFeedsResponse, _$identity);

  /// Serializes this AdminRssFeedsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRssFeedsResponse&&const DeepCollectionEquality().equals(other.feeds, feeds)&&const DeepCollectionEquality().equals(other.minified, minified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(feeds),const DeepCollectionEquality().hash(minified));

@override
String toString() {
  return 'AdminRssFeedsResponse(feeds: $feeds, minified: $minified)';
}


}

/// @nodoc
abstract mixin class $AdminRssFeedsResponseCopyWith<$Res>  {
  factory $AdminRssFeedsResponseCopyWith(AdminRssFeedsResponse value, $Res Function(AdminRssFeedsResponse) _then) = _$AdminRssFeedsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'feeds') List<AdminRssFeed> feeds,@JsonKey(name: 'minified') List<AdminRssFeedMinified> minified
});




}
/// @nodoc
class _$AdminRssFeedsResponseCopyWithImpl<$Res>
    implements $AdminRssFeedsResponseCopyWith<$Res> {
  _$AdminRssFeedsResponseCopyWithImpl(this._self, this._then);

  final AdminRssFeedsResponse _self;
  final $Res Function(AdminRssFeedsResponse) _then;

/// Create a copy of AdminRssFeedsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? feeds = null,Object? minified = null,}) {
  return _then(_self.copyWith(
feeds: null == feeds ? _self.feeds : feeds // ignore: cast_nullable_to_non_nullable
as List<AdminRssFeed>,minified: null == minified ? _self.minified : minified // ignore: cast_nullable_to_non_nullable
as List<AdminRssFeedMinified>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRssFeedsResponse].
extension AdminRssFeedsResponsePatterns on AdminRssFeedsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRssFeedsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRssFeedsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRssFeedsResponse value)  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRssFeedsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'feeds')  List<AdminRssFeed> feeds, @JsonKey(name: 'minified')  List<AdminRssFeedMinified> minified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRssFeedsResponse() when $default != null:
return $default(_that.feeds,_that.minified);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'feeds')  List<AdminRssFeed> feeds, @JsonKey(name: 'minified')  List<AdminRssFeedMinified> minified)  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedsResponse():
return $default(_that.feeds,_that.minified);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'feeds')  List<AdminRssFeed> feeds, @JsonKey(name: 'minified')  List<AdminRssFeedMinified> minified)?  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedsResponse() when $default != null:
return $default(_that.feeds,_that.minified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRssFeedsResponse implements AdminRssFeedsResponse {
  const _AdminRssFeedsResponse({@JsonKey(name: 'feeds') final  List<AdminRssFeed> feeds = const <AdminRssFeed>[], @JsonKey(name: 'minified') final  List<AdminRssFeedMinified> minified = const <AdminRssFeedMinified>[]}): _feeds = feeds,_minified = minified;
  factory _AdminRssFeedsResponse.fromJson(Map<String, dynamic> json) => _$AdminRssFeedsResponseFromJson(json);

 final  List<AdminRssFeed> _feeds;
@override@JsonKey(name: 'feeds') List<AdminRssFeed> get feeds {
  if (_feeds is EqualUnmodifiableListView) return _feeds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_feeds);
}

 final  List<AdminRssFeedMinified> _minified;
@override@JsonKey(name: 'minified') List<AdminRssFeedMinified> get minified {
  if (_minified is EqualUnmodifiableListView) return _minified;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_minified);
}


/// Create a copy of AdminRssFeedsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRssFeedsResponseCopyWith<_AdminRssFeedsResponse> get copyWith => __$AdminRssFeedsResponseCopyWithImpl<_AdminRssFeedsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRssFeedsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRssFeedsResponse&&const DeepCollectionEquality().equals(other._feeds, _feeds)&&const DeepCollectionEquality().equals(other._minified, _minified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_feeds),const DeepCollectionEquality().hash(_minified));

@override
String toString() {
  return 'AdminRssFeedsResponse(feeds: $feeds, minified: $minified)';
}


}

/// @nodoc
abstract mixin class _$AdminRssFeedsResponseCopyWith<$Res> implements $AdminRssFeedsResponseCopyWith<$Res> {
  factory _$AdminRssFeedsResponseCopyWith(_AdminRssFeedsResponse value, $Res Function(_AdminRssFeedsResponse) _then) = __$AdminRssFeedsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'feeds') List<AdminRssFeed> feeds,@JsonKey(name: 'minified') List<AdminRssFeedMinified> minified
});




}
/// @nodoc
class __$AdminRssFeedsResponseCopyWithImpl<$Res>
    implements _$AdminRssFeedsResponseCopyWith<$Res> {
  __$AdminRssFeedsResponseCopyWithImpl(this._self, this._then);

  final _AdminRssFeedsResponse _self;
  final $Res Function(_AdminRssFeedsResponse) _then;

/// Create a copy of AdminRssFeedsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? feeds = null,Object? minified = null,}) {
  return _then(_AdminRssFeedsResponse(
feeds: null == feeds ? _self._feeds : feeds // ignore: cast_nullable_to_non_nullable
as List<AdminRssFeed>,minified: null == minified ? _self._minified : minified // ignore: cast_nullable_to_non_nullable
as List<AdminRssFeedMinified>,
  ));
}


}


/// @nodoc
mixin _$AdminRssFeed {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'slug') String? get slug;@JsonKey(name: 'userId') String? get userId;@JsonKey(name: 'entityType') String? get entityType;@JsonKey(name: 'entityId') String? get entityId;@JsonKey(name: 'entityUpdatedAt') int? get entityUpdatedAt;@JsonKey(name: 'coverPath') String? get coverPath;@JsonKey(name: 'meta') AdminRssFeedMeta? get meta;@JsonKey(name: 'serverAddress') String? get serverAddress;@JsonKey(name: 'feedUrl') String? get feedUrl;@JsonKey(name: 'episodes') List<AdminRssFeedEpisode> get episodes;@JsonKey(name: 'createdAt') int? get createdAt;@JsonKey(name: 'updatedAt') int? get updatedAt;
/// Create a copy of AdminRssFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRssFeedCopyWith<AdminRssFeed> get copyWith => _$AdminRssFeedCopyWithImpl<AdminRssFeed>(this as AdminRssFeed, _$identity);

  /// Serializes this AdminRssFeed to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRssFeed&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityUpdatedAt, entityUpdatedAt) || other.entityUpdatedAt == entityUpdatedAt)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.serverAddress, serverAddress) || other.serverAddress == serverAddress)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,userId,entityType,entityId,entityUpdatedAt,coverPath,meta,serverAddress,feedUrl,const DeepCollectionEquality().hash(episodes),createdAt,updatedAt);

@override
String toString() {
  return 'AdminRssFeed(id: $id, slug: $slug, userId: $userId, entityType: $entityType, entityId: $entityId, entityUpdatedAt: $entityUpdatedAt, coverPath: $coverPath, meta: $meta, serverAddress: $serverAddress, feedUrl: $feedUrl, episodes: $episodes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AdminRssFeedCopyWith<$Res>  {
  factory $AdminRssFeedCopyWith(AdminRssFeed value, $Res Function(AdminRssFeed) _then) = _$AdminRssFeedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'entityType') String? entityType,@JsonKey(name: 'entityId') String? entityId,@JsonKey(name: 'entityUpdatedAt') int? entityUpdatedAt,@JsonKey(name: 'coverPath') String? coverPath,@JsonKey(name: 'meta') AdminRssFeedMeta? meta,@JsonKey(name: 'serverAddress') String? serverAddress,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'episodes') List<AdminRssFeedEpisode> episodes,@JsonKey(name: 'createdAt') int? createdAt,@JsonKey(name: 'updatedAt') int? updatedAt
});


$AdminRssFeedMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$AdminRssFeedCopyWithImpl<$Res>
    implements $AdminRssFeedCopyWith<$Res> {
  _$AdminRssFeedCopyWithImpl(this._self, this._then);

  final AdminRssFeed _self;
  final $Res Function(AdminRssFeed) _then;

/// Create a copy of AdminRssFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = freezed,Object? userId = freezed,Object? entityType = freezed,Object? entityId = freezed,Object? entityUpdatedAt = freezed,Object? coverPath = freezed,Object? meta = freezed,Object? serverAddress = freezed,Object? feedUrl = freezed,Object? episodes = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,entityUpdatedAt: freezed == entityUpdatedAt ? _self.entityUpdatedAt : entityUpdatedAt // ignore: cast_nullable_to_non_nullable
as int?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AdminRssFeedMeta?,serverAddress: freezed == serverAddress ? _self.serverAddress : serverAddress // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<AdminRssFeedEpisode>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of AdminRssFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRssFeedMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $AdminRssFeedMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminRssFeed].
extension AdminRssFeedPatterns on AdminRssFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRssFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRssFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRssFeed value)  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRssFeed value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'userId')  String? userId, @JsonKey(name: 'entityType')  String? entityType, @JsonKey(name: 'entityId')  String? entityId, @JsonKey(name: 'entityUpdatedAt')  int? entityUpdatedAt, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'meta')  AdminRssFeedMeta? meta, @JsonKey(name: 'serverAddress')  String? serverAddress, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'episodes')  List<AdminRssFeedEpisode> episodes, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'updatedAt')  int? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRssFeed() when $default != null:
return $default(_that.id,_that.slug,_that.userId,_that.entityType,_that.entityId,_that.entityUpdatedAt,_that.coverPath,_that.meta,_that.serverAddress,_that.feedUrl,_that.episodes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'userId')  String? userId, @JsonKey(name: 'entityType')  String? entityType, @JsonKey(name: 'entityId')  String? entityId, @JsonKey(name: 'entityUpdatedAt')  int? entityUpdatedAt, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'meta')  AdminRssFeedMeta? meta, @JsonKey(name: 'serverAddress')  String? serverAddress, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'episodes')  List<AdminRssFeedEpisode> episodes, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'updatedAt')  int? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeed():
return $default(_that.id,_that.slug,_that.userId,_that.entityType,_that.entityId,_that.entityUpdatedAt,_that.coverPath,_that.meta,_that.serverAddress,_that.feedUrl,_that.episodes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'slug')  String? slug, @JsonKey(name: 'userId')  String? userId, @JsonKey(name: 'entityType')  String? entityType, @JsonKey(name: 'entityId')  String? entityId, @JsonKey(name: 'entityUpdatedAt')  int? entityUpdatedAt, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'meta')  AdminRssFeedMeta? meta, @JsonKey(name: 'serverAddress')  String? serverAddress, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'episodes')  List<AdminRssFeedEpisode> episodes, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'updatedAt')  int? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeed() when $default != null:
return $default(_that.id,_that.slug,_that.userId,_that.entityType,_that.entityId,_that.entityUpdatedAt,_that.coverPath,_that.meta,_that.serverAddress,_that.feedUrl,_that.episodes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRssFeed extends AdminRssFeed {
  const _AdminRssFeed({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'slug') this.slug, @JsonKey(name: 'userId') this.userId, @JsonKey(name: 'entityType') this.entityType, @JsonKey(name: 'entityId') this.entityId, @JsonKey(name: 'entityUpdatedAt') this.entityUpdatedAt, @JsonKey(name: 'coverPath') this.coverPath, @JsonKey(name: 'meta') this.meta, @JsonKey(name: 'serverAddress') this.serverAddress, @JsonKey(name: 'feedUrl') this.feedUrl, @JsonKey(name: 'episodes') final  List<AdminRssFeedEpisode> episodes = const <AdminRssFeedEpisode>[], @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'updatedAt') this.updatedAt}): _episodes = episodes,super._();
  factory _AdminRssFeed.fromJson(Map<String, dynamic> json) => _$AdminRssFeedFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'slug') final  String? slug;
@override@JsonKey(name: 'userId') final  String? userId;
@override@JsonKey(name: 'entityType') final  String? entityType;
@override@JsonKey(name: 'entityId') final  String? entityId;
@override@JsonKey(name: 'entityUpdatedAt') final  int? entityUpdatedAt;
@override@JsonKey(name: 'coverPath') final  String? coverPath;
@override@JsonKey(name: 'meta') final  AdminRssFeedMeta? meta;
@override@JsonKey(name: 'serverAddress') final  String? serverAddress;
@override@JsonKey(name: 'feedUrl') final  String? feedUrl;
 final  List<AdminRssFeedEpisode> _episodes;
@override@JsonKey(name: 'episodes') List<AdminRssFeedEpisode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override@JsonKey(name: 'createdAt') final  int? createdAt;
@override@JsonKey(name: 'updatedAt') final  int? updatedAt;

/// Create a copy of AdminRssFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRssFeedCopyWith<_AdminRssFeed> get copyWith => __$AdminRssFeedCopyWithImpl<_AdminRssFeed>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRssFeedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRssFeed&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.entityUpdatedAt, entityUpdatedAt) || other.entityUpdatedAt == entityUpdatedAt)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.serverAddress, serverAddress) || other.serverAddress == serverAddress)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,slug,userId,entityType,entityId,entityUpdatedAt,coverPath,meta,serverAddress,feedUrl,const DeepCollectionEquality().hash(_episodes),createdAt,updatedAt);

@override
String toString() {
  return 'AdminRssFeed(id: $id, slug: $slug, userId: $userId, entityType: $entityType, entityId: $entityId, entityUpdatedAt: $entityUpdatedAt, coverPath: $coverPath, meta: $meta, serverAddress: $serverAddress, feedUrl: $feedUrl, episodes: $episodes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AdminRssFeedCopyWith<$Res> implements $AdminRssFeedCopyWith<$Res> {
  factory _$AdminRssFeedCopyWith(_AdminRssFeed value, $Res Function(_AdminRssFeed) _then) = __$AdminRssFeedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'slug') String? slug,@JsonKey(name: 'userId') String? userId,@JsonKey(name: 'entityType') String? entityType,@JsonKey(name: 'entityId') String? entityId,@JsonKey(name: 'entityUpdatedAt') int? entityUpdatedAt,@JsonKey(name: 'coverPath') String? coverPath,@JsonKey(name: 'meta') AdminRssFeedMeta? meta,@JsonKey(name: 'serverAddress') String? serverAddress,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'episodes') List<AdminRssFeedEpisode> episodes,@JsonKey(name: 'createdAt') int? createdAt,@JsonKey(name: 'updatedAt') int? updatedAt
});


@override $AdminRssFeedMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$AdminRssFeedCopyWithImpl<$Res>
    implements _$AdminRssFeedCopyWith<$Res> {
  __$AdminRssFeedCopyWithImpl(this._self, this._then);

  final _AdminRssFeed _self;
  final $Res Function(_AdminRssFeed) _then;

/// Create a copy of AdminRssFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = freezed,Object? userId = freezed,Object? entityType = freezed,Object? entityId = freezed,Object? entityUpdatedAt = freezed,Object? coverPath = freezed,Object? meta = freezed,Object? serverAddress = freezed,Object? feedUrl = freezed,Object? episodes = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AdminRssFeed(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,entityUpdatedAt: freezed == entityUpdatedAt ? _self.entityUpdatedAt : entityUpdatedAt // ignore: cast_nullable_to_non_nullable
as int?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AdminRssFeedMeta?,serverAddress: freezed == serverAddress ? _self.serverAddress : serverAddress // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<AdminRssFeedEpisode>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of AdminRssFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRssFeedMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $AdminRssFeedMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$AdminRssFeedMinified {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'entityType') String? get entityType;@JsonKey(name: 'entityId') String? get entityId;@JsonKey(name: 'feedUrl') String? get feedUrl;@JsonKey(name: 'meta') AdminRssFeedMeta? get meta;
/// Create a copy of AdminRssFeedMinified
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRssFeedMinifiedCopyWith<AdminRssFeedMinified> get copyWith => _$AdminRssFeedMinifiedCopyWithImpl<AdminRssFeedMinified>(this as AdminRssFeedMinified, _$identity);

  /// Serializes this AdminRssFeedMinified to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRssFeedMinified&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityType,entityId,feedUrl,meta);

@override
String toString() {
  return 'AdminRssFeedMinified(id: $id, entityType: $entityType, entityId: $entityId, feedUrl: $feedUrl, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $AdminRssFeedMinifiedCopyWith<$Res>  {
  factory $AdminRssFeedMinifiedCopyWith(AdminRssFeedMinified value, $Res Function(AdminRssFeedMinified) _then) = _$AdminRssFeedMinifiedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'entityType') String? entityType,@JsonKey(name: 'entityId') String? entityId,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'meta') AdminRssFeedMeta? meta
});


$AdminRssFeedMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$AdminRssFeedMinifiedCopyWithImpl<$Res>
    implements $AdminRssFeedMinifiedCopyWith<$Res> {
  _$AdminRssFeedMinifiedCopyWithImpl(this._self, this._then);

  final AdminRssFeedMinified _self;
  final $Res Function(AdminRssFeedMinified) _then;

/// Create a copy of AdminRssFeedMinified
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entityType = freezed,Object? entityId = freezed,Object? feedUrl = freezed,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AdminRssFeedMeta?,
  ));
}
/// Create a copy of AdminRssFeedMinified
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRssFeedMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $AdminRssFeedMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminRssFeedMinified].
extension AdminRssFeedMinifiedPatterns on AdminRssFeedMinified {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRssFeedMinified value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRssFeedMinified() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRssFeedMinified value)  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedMinified():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRssFeedMinified value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedMinified() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'entityType')  String? entityType, @JsonKey(name: 'entityId')  String? entityId, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'meta')  AdminRssFeedMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRssFeedMinified() when $default != null:
return $default(_that.id,_that.entityType,_that.entityId,_that.feedUrl,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'entityType')  String? entityType, @JsonKey(name: 'entityId')  String? entityId, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'meta')  AdminRssFeedMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedMinified():
return $default(_that.id,_that.entityType,_that.entityId,_that.feedUrl,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'entityType')  String? entityType, @JsonKey(name: 'entityId')  String? entityId, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'meta')  AdminRssFeedMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedMinified() when $default != null:
return $default(_that.id,_that.entityType,_that.entityId,_that.feedUrl,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRssFeedMinified implements AdminRssFeedMinified {
  const _AdminRssFeedMinified({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'entityType') this.entityType, @JsonKey(name: 'entityId') this.entityId, @JsonKey(name: 'feedUrl') this.feedUrl, @JsonKey(name: 'meta') this.meta});
  factory _AdminRssFeedMinified.fromJson(Map<String, dynamic> json) => _$AdminRssFeedMinifiedFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'entityType') final  String? entityType;
@override@JsonKey(name: 'entityId') final  String? entityId;
@override@JsonKey(name: 'feedUrl') final  String? feedUrl;
@override@JsonKey(name: 'meta') final  AdminRssFeedMeta? meta;

/// Create a copy of AdminRssFeedMinified
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRssFeedMinifiedCopyWith<_AdminRssFeedMinified> get copyWith => __$AdminRssFeedMinifiedCopyWithImpl<_AdminRssFeedMinified>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRssFeedMinifiedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRssFeedMinified&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,entityType,entityId,feedUrl,meta);

@override
String toString() {
  return 'AdminRssFeedMinified(id: $id, entityType: $entityType, entityId: $entityId, feedUrl: $feedUrl, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$AdminRssFeedMinifiedCopyWith<$Res> implements $AdminRssFeedMinifiedCopyWith<$Res> {
  factory _$AdminRssFeedMinifiedCopyWith(_AdminRssFeedMinified value, $Res Function(_AdminRssFeedMinified) _then) = __$AdminRssFeedMinifiedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'entityType') String? entityType,@JsonKey(name: 'entityId') String? entityId,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'meta') AdminRssFeedMeta? meta
});


@override $AdminRssFeedMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$AdminRssFeedMinifiedCopyWithImpl<$Res>
    implements _$AdminRssFeedMinifiedCopyWith<$Res> {
  __$AdminRssFeedMinifiedCopyWithImpl(this._self, this._then);

  final _AdminRssFeedMinified _self;
  final $Res Function(_AdminRssFeedMinified) _then;

/// Create a copy of AdminRssFeedMinified
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entityType = freezed,Object? entityId = freezed,Object? feedUrl = freezed,Object? meta = freezed,}) {
  return _then(_AdminRssFeedMinified(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityType: freezed == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String?,entityId: freezed == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as AdminRssFeedMeta?,
  ));
}

/// Create a copy of AdminRssFeedMinified
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRssFeedMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $AdminRssFeedMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$AdminRssFeedMeta {

@JsonKey(name: 'title') String? get title;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'imageUrl') String? get imageUrl;@JsonKey(name: 'feedUrl') String? get feedUrl;@JsonKey(name: 'link') String? get link;@JsonKey(name: 'explicit') bool? get explicit;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'language') String? get language;@JsonKey(name: 'preventIndexing') bool? get preventIndexing;@JsonKey(name: 'ownerName') String? get ownerName;@JsonKey(name: 'ownerEmail') String? get ownerEmail;
/// Create a copy of AdminRssFeedMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRssFeedMetaCopyWith<AdminRssFeedMeta> get copyWith => _$AdminRssFeedMetaCopyWithImpl<AdminRssFeedMeta>(this as AdminRssFeedMeta, _$identity);

  /// Serializes this AdminRssFeedMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRssFeedMeta&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.link, link) || other.link == link)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.type, type) || other.type == type)&&(identical(other.language, language) || other.language == language)&&(identical(other.preventIndexing, preventIndexing) || other.preventIndexing == preventIndexing)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerEmail, ownerEmail) || other.ownerEmail == ownerEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,author,imageUrl,feedUrl,link,explicit,type,language,preventIndexing,ownerName,ownerEmail);

@override
String toString() {
  return 'AdminRssFeedMeta(title: $title, description: $description, author: $author, imageUrl: $imageUrl, feedUrl: $feedUrl, link: $link, explicit: $explicit, type: $type, language: $language, preventIndexing: $preventIndexing, ownerName: $ownerName, ownerEmail: $ownerEmail)';
}


}

/// @nodoc
abstract mixin class $AdminRssFeedMetaCopyWith<$Res>  {
  factory $AdminRssFeedMetaCopyWith(AdminRssFeedMeta value, $Res Function(AdminRssFeedMeta) _then) = _$AdminRssFeedMetaCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'description') String? description,@JsonKey(name: 'author') String? author,@JsonKey(name: 'imageUrl') String? imageUrl,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'link') String? link,@JsonKey(name: 'explicit') bool? explicit,@JsonKey(name: 'type') String? type,@JsonKey(name: 'language') String? language,@JsonKey(name: 'preventIndexing') bool? preventIndexing,@JsonKey(name: 'ownerName') String? ownerName,@JsonKey(name: 'ownerEmail') String? ownerEmail
});




}
/// @nodoc
class _$AdminRssFeedMetaCopyWithImpl<$Res>
    implements $AdminRssFeedMetaCopyWith<$Res> {
  _$AdminRssFeedMetaCopyWithImpl(this._self, this._then);

  final AdminRssFeedMeta _self;
  final $Res Function(AdminRssFeedMeta) _then;

/// Create a copy of AdminRssFeedMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? author = freezed,Object? imageUrl = freezed,Object? feedUrl = freezed,Object? link = freezed,Object? explicit = freezed,Object? type = freezed,Object? language = freezed,Object? preventIndexing = freezed,Object? ownerName = freezed,Object? ownerEmail = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,preventIndexing: freezed == preventIndexing ? _self.preventIndexing : preventIndexing // ignore: cast_nullable_to_non_nullable
as bool?,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,ownerEmail: freezed == ownerEmail ? _self.ownerEmail : ownerEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRssFeedMeta].
extension AdminRssFeedMetaPatterns on AdminRssFeedMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRssFeedMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRssFeedMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRssFeedMeta value)  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRssFeedMeta value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'imageUrl')  String? imageUrl, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'preventIndexing')  bool? preventIndexing, @JsonKey(name: 'ownerName')  String? ownerName, @JsonKey(name: 'ownerEmail')  String? ownerEmail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRssFeedMeta() when $default != null:
return $default(_that.title,_that.description,_that.author,_that.imageUrl,_that.feedUrl,_that.link,_that.explicit,_that.type,_that.language,_that.preventIndexing,_that.ownerName,_that.ownerEmail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'imageUrl')  String? imageUrl, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'preventIndexing')  bool? preventIndexing, @JsonKey(name: 'ownerName')  String? ownerName, @JsonKey(name: 'ownerEmail')  String? ownerEmail)  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedMeta():
return $default(_that.title,_that.description,_that.author,_that.imageUrl,_that.feedUrl,_that.link,_that.explicit,_that.type,_that.language,_that.preventIndexing,_that.ownerName,_that.ownerEmail);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'title')  String? title, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'imageUrl')  String? imageUrl, @JsonKey(name: 'feedUrl')  String? feedUrl, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'language')  String? language, @JsonKey(name: 'preventIndexing')  bool? preventIndexing, @JsonKey(name: 'ownerName')  String? ownerName, @JsonKey(name: 'ownerEmail')  String? ownerEmail)?  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedMeta() when $default != null:
return $default(_that.title,_that.description,_that.author,_that.imageUrl,_that.feedUrl,_that.link,_that.explicit,_that.type,_that.language,_that.preventIndexing,_that.ownerName,_that.ownerEmail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRssFeedMeta implements AdminRssFeedMeta {
  const _AdminRssFeedMeta({@JsonKey(name: 'title') this.title, @JsonKey(name: 'description') this.description, @JsonKey(name: 'author') this.author, @JsonKey(name: 'imageUrl') this.imageUrl, @JsonKey(name: 'feedUrl') this.feedUrl, @JsonKey(name: 'link') this.link, @JsonKey(name: 'explicit') this.explicit, @JsonKey(name: 'type') this.type, @JsonKey(name: 'language') this.language, @JsonKey(name: 'preventIndexing') this.preventIndexing, @JsonKey(name: 'ownerName') this.ownerName, @JsonKey(name: 'ownerEmail') this.ownerEmail});
  factory _AdminRssFeedMeta.fromJson(Map<String, dynamic> json) => _$AdminRssFeedMetaFromJson(json);

@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'imageUrl') final  String? imageUrl;
@override@JsonKey(name: 'feedUrl') final  String? feedUrl;
@override@JsonKey(name: 'link') final  String? link;
@override@JsonKey(name: 'explicit') final  bool? explicit;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'language') final  String? language;
@override@JsonKey(name: 'preventIndexing') final  bool? preventIndexing;
@override@JsonKey(name: 'ownerName') final  String? ownerName;
@override@JsonKey(name: 'ownerEmail') final  String? ownerEmail;

/// Create a copy of AdminRssFeedMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRssFeedMetaCopyWith<_AdminRssFeedMeta> get copyWith => __$AdminRssFeedMetaCopyWithImpl<_AdminRssFeedMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRssFeedMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRssFeedMeta&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.author, author) || other.author == author)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.feedUrl, feedUrl) || other.feedUrl == feedUrl)&&(identical(other.link, link) || other.link == link)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.type, type) || other.type == type)&&(identical(other.language, language) || other.language == language)&&(identical(other.preventIndexing, preventIndexing) || other.preventIndexing == preventIndexing)&&(identical(other.ownerName, ownerName) || other.ownerName == ownerName)&&(identical(other.ownerEmail, ownerEmail) || other.ownerEmail == ownerEmail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,author,imageUrl,feedUrl,link,explicit,type,language,preventIndexing,ownerName,ownerEmail);

@override
String toString() {
  return 'AdminRssFeedMeta(title: $title, description: $description, author: $author, imageUrl: $imageUrl, feedUrl: $feedUrl, link: $link, explicit: $explicit, type: $type, language: $language, preventIndexing: $preventIndexing, ownerName: $ownerName, ownerEmail: $ownerEmail)';
}


}

/// @nodoc
abstract mixin class _$AdminRssFeedMetaCopyWith<$Res> implements $AdminRssFeedMetaCopyWith<$Res> {
  factory _$AdminRssFeedMetaCopyWith(_AdminRssFeedMeta value, $Res Function(_AdminRssFeedMeta) _then) = __$AdminRssFeedMetaCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'title') String? title,@JsonKey(name: 'description') String? description,@JsonKey(name: 'author') String? author,@JsonKey(name: 'imageUrl') String? imageUrl,@JsonKey(name: 'feedUrl') String? feedUrl,@JsonKey(name: 'link') String? link,@JsonKey(name: 'explicit') bool? explicit,@JsonKey(name: 'type') String? type,@JsonKey(name: 'language') String? language,@JsonKey(name: 'preventIndexing') bool? preventIndexing,@JsonKey(name: 'ownerName') String? ownerName,@JsonKey(name: 'ownerEmail') String? ownerEmail
});




}
/// @nodoc
class __$AdminRssFeedMetaCopyWithImpl<$Res>
    implements _$AdminRssFeedMetaCopyWith<$Res> {
  __$AdminRssFeedMetaCopyWithImpl(this._self, this._then);

  final _AdminRssFeedMeta _self;
  final $Res Function(_AdminRssFeedMeta) _then;

/// Create a copy of AdminRssFeedMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? author = freezed,Object? imageUrl = freezed,Object? feedUrl = freezed,Object? link = freezed,Object? explicit = freezed,Object? type = freezed,Object? language = freezed,Object? preventIndexing = freezed,Object? ownerName = freezed,Object? ownerEmail = freezed,}) {
  return _then(_AdminRssFeedMeta(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,feedUrl: freezed == feedUrl ? _self.feedUrl : feedUrl // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,language: freezed == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String?,preventIndexing: freezed == preventIndexing ? _self.preventIndexing : preventIndexing // ignore: cast_nullable_to_non_nullable
as bool?,ownerName: freezed == ownerName ? _self.ownerName : ownerName // ignore: cast_nullable_to_non_nullable
as String?,ownerEmail: freezed == ownerEmail ? _self.ownerEmail : ownerEmail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdminRssFeedEpisode {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'enclosure') AdminRssFeedEpisodeEnclosure? get enclosure;@JsonKey(name: 'pubDate') String? get pubDate;@JsonKey(name: 'link') String? get link;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'explicit') bool? get explicit;@JsonKey(name: 'duration') double? get duration;@JsonKey(name: 'season') String? get season;@JsonKey(name: 'episode') String? get episode;@JsonKey(name: 'episodeType') String? get episodeType;@JsonKey(name: 'fullPath') String? get fullPath;
/// Create a copy of AdminRssFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRssFeedEpisodeCopyWith<AdminRssFeedEpisode> get copyWith => _$AdminRssFeedEpisodeCopyWithImpl<AdminRssFeedEpisode>(this as AdminRssFeedEpisode, _$identity);

  /// Serializes this AdminRssFeedEpisode to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRssFeedEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.link, link) || other.link == link)&&(identical(other.author, author) || other.author == author)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,enclosure,pubDate,link,author,explicit,duration,season,episode,episodeType,fullPath);

@override
String toString() {
  return 'AdminRssFeedEpisode(id: $id, title: $title, description: $description, enclosure: $enclosure, pubDate: $pubDate, link: $link, author: $author, explicit: $explicit, duration: $duration, season: $season, episode: $episode, episodeType: $episodeType, fullPath: $fullPath)';
}


}

/// @nodoc
abstract mixin class $AdminRssFeedEpisodeCopyWith<$Res>  {
  factory $AdminRssFeedEpisodeCopyWith(AdminRssFeedEpisode value, $Res Function(AdminRssFeedEpisode) _then) = _$AdminRssFeedEpisodeCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'description') String? description,@JsonKey(name: 'enclosure') AdminRssFeedEpisodeEnclosure? enclosure,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'link') String? link,@JsonKey(name: 'author') String? author,@JsonKey(name: 'explicit') bool? explicit,@JsonKey(name: 'duration') double? duration,@JsonKey(name: 'season') String? season,@JsonKey(name: 'episode') String? episode,@JsonKey(name: 'episodeType') String? episodeType,@JsonKey(name: 'fullPath') String? fullPath
});


$AdminRssFeedEpisodeEnclosureCopyWith<$Res>? get enclosure;

}
/// @nodoc
class _$AdminRssFeedEpisodeCopyWithImpl<$Res>
    implements $AdminRssFeedEpisodeCopyWith<$Res> {
  _$AdminRssFeedEpisodeCopyWithImpl(this._self, this._then);

  final AdminRssFeedEpisode _self;
  final $Res Function(AdminRssFeedEpisode) _then;

/// Create a copy of AdminRssFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? enclosure = freezed,Object? pubDate = freezed,Object? link = freezed,Object? author = freezed,Object? explicit = freezed,Object? duration = freezed,Object? season = freezed,Object? episode = freezed,Object? episodeType = freezed,Object? fullPath = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as AdminRssFeedEpisodeEnclosure?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdminRssFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRssFeedEpisodeEnclosureCopyWith<$Res>? get enclosure {
    if (_self.enclosure == null) {
    return null;
  }

  return $AdminRssFeedEpisodeEnclosureCopyWith<$Res>(_self.enclosure!, (value) {
    return _then(_self.copyWith(enclosure: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminRssFeedEpisode].
extension AdminRssFeedEpisodePatterns on AdminRssFeedEpisode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRssFeedEpisode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRssFeedEpisode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRssFeedEpisode value)  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedEpisode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRssFeedEpisode value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedEpisode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'enclosure')  AdminRssFeedEpisodeEnclosure? enclosure, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'duration')  double? duration, @JsonKey(name: 'season')  String? season, @JsonKey(name: 'episode')  String? episode, @JsonKey(name: 'episodeType')  String? episodeType, @JsonKey(name: 'fullPath')  String? fullPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRssFeedEpisode() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.enclosure,_that.pubDate,_that.link,_that.author,_that.explicit,_that.duration,_that.season,_that.episode,_that.episodeType,_that.fullPath);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'enclosure')  AdminRssFeedEpisodeEnclosure? enclosure, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'duration')  double? duration, @JsonKey(name: 'season')  String? season, @JsonKey(name: 'episode')  String? episode, @JsonKey(name: 'episodeType')  String? episodeType, @JsonKey(name: 'fullPath')  String? fullPath)  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedEpisode():
return $default(_that.id,_that.title,_that.description,_that.enclosure,_that.pubDate,_that.link,_that.author,_that.explicit,_that.duration,_that.season,_that.episode,_that.episodeType,_that.fullPath);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'enclosure')  AdminRssFeedEpisodeEnclosure? enclosure, @JsonKey(name: 'pubDate')  String? pubDate, @JsonKey(name: 'link')  String? link, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'explicit')  bool? explicit, @JsonKey(name: 'duration')  double? duration, @JsonKey(name: 'season')  String? season, @JsonKey(name: 'episode')  String? episode, @JsonKey(name: 'episodeType')  String? episodeType, @JsonKey(name: 'fullPath')  String? fullPath)?  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedEpisode() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.enclosure,_that.pubDate,_that.link,_that.author,_that.explicit,_that.duration,_that.season,_that.episode,_that.episodeType,_that.fullPath);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRssFeedEpisode implements AdminRssFeedEpisode {
  const _AdminRssFeedEpisode({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'title') this.title, @JsonKey(name: 'description') this.description, @JsonKey(name: 'enclosure') this.enclosure, @JsonKey(name: 'pubDate') this.pubDate, @JsonKey(name: 'link') this.link, @JsonKey(name: 'author') this.author, @JsonKey(name: 'explicit') this.explicit, @JsonKey(name: 'duration') this.duration, @JsonKey(name: 'season') this.season, @JsonKey(name: 'episode') this.episode, @JsonKey(name: 'episodeType') this.episodeType, @JsonKey(name: 'fullPath') this.fullPath});
  factory _AdminRssFeedEpisode.fromJson(Map<String, dynamic> json) => _$AdminRssFeedEpisodeFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'enclosure') final  AdminRssFeedEpisodeEnclosure? enclosure;
@override@JsonKey(name: 'pubDate') final  String? pubDate;
@override@JsonKey(name: 'link') final  String? link;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'explicit') final  bool? explicit;
@override@JsonKey(name: 'duration') final  double? duration;
@override@JsonKey(name: 'season') final  String? season;
@override@JsonKey(name: 'episode') final  String? episode;
@override@JsonKey(name: 'episodeType') final  String? episodeType;
@override@JsonKey(name: 'fullPath') final  String? fullPath;

/// Create a copy of AdminRssFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRssFeedEpisodeCopyWith<_AdminRssFeedEpisode> get copyWith => __$AdminRssFeedEpisodeCopyWithImpl<_AdminRssFeedEpisode>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRssFeedEpisodeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRssFeedEpisode&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.pubDate, pubDate) || other.pubDate == pubDate)&&(identical(other.link, link) || other.link == link)&&(identical(other.author, author) || other.author == author)&&(identical(other.explicit, explicit) || other.explicit == explicit)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.season, season) || other.season == season)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.episodeType, episodeType) || other.episodeType == episodeType)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,enclosure,pubDate,link,author,explicit,duration,season,episode,episodeType,fullPath);

@override
String toString() {
  return 'AdminRssFeedEpisode(id: $id, title: $title, description: $description, enclosure: $enclosure, pubDate: $pubDate, link: $link, author: $author, explicit: $explicit, duration: $duration, season: $season, episode: $episode, episodeType: $episodeType, fullPath: $fullPath)';
}


}

/// @nodoc
abstract mixin class _$AdminRssFeedEpisodeCopyWith<$Res> implements $AdminRssFeedEpisodeCopyWith<$Res> {
  factory _$AdminRssFeedEpisodeCopyWith(_AdminRssFeedEpisode value, $Res Function(_AdminRssFeedEpisode) _then) = __$AdminRssFeedEpisodeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'title') String? title,@JsonKey(name: 'description') String? description,@JsonKey(name: 'enclosure') AdminRssFeedEpisodeEnclosure? enclosure,@JsonKey(name: 'pubDate') String? pubDate,@JsonKey(name: 'link') String? link,@JsonKey(name: 'author') String? author,@JsonKey(name: 'explicit') bool? explicit,@JsonKey(name: 'duration') double? duration,@JsonKey(name: 'season') String? season,@JsonKey(name: 'episode') String? episode,@JsonKey(name: 'episodeType') String? episodeType,@JsonKey(name: 'fullPath') String? fullPath
});


@override $AdminRssFeedEpisodeEnclosureCopyWith<$Res>? get enclosure;

}
/// @nodoc
class __$AdminRssFeedEpisodeCopyWithImpl<$Res>
    implements _$AdminRssFeedEpisodeCopyWith<$Res> {
  __$AdminRssFeedEpisodeCopyWithImpl(this._self, this._then);

  final _AdminRssFeedEpisode _self;
  final $Res Function(_AdminRssFeedEpisode) _then;

/// Create a copy of AdminRssFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? description = freezed,Object? enclosure = freezed,Object? pubDate = freezed,Object? link = freezed,Object? author = freezed,Object? explicit = freezed,Object? duration = freezed,Object? season = freezed,Object? episode = freezed,Object? episodeType = freezed,Object? fullPath = freezed,}) {
  return _then(_AdminRssFeedEpisode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as AdminRssFeedEpisodeEnclosure?,pubDate: freezed == pubDate ? _self.pubDate : pubDate // ignore: cast_nullable_to_non_nullable
as String?,link: freezed == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,explicit: freezed == explicit ? _self.explicit : explicit // ignore: cast_nullable_to_non_nullable
as bool?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,episodeType: freezed == episodeType ? _self.episodeType : episodeType // ignore: cast_nullable_to_non_nullable
as String?,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdminRssFeedEpisode
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminRssFeedEpisodeEnclosureCopyWith<$Res>? get enclosure {
    if (_self.enclosure == null) {
    return null;
  }

  return $AdminRssFeedEpisodeEnclosureCopyWith<$Res>(_self.enclosure!, (value) {
    return _then(_self.copyWith(enclosure: value));
  });
}
}


/// @nodoc
mixin _$AdminRssFeedEpisodeEnclosure {

@JsonKey(name: 'url') String? get url;@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? get size;@JsonKey(name: 'type') String? get type;
/// Create a copy of AdminRssFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminRssFeedEpisodeEnclosureCopyWith<AdminRssFeedEpisodeEnclosure> get copyWith => _$AdminRssFeedEpisodeEnclosureCopyWithImpl<AdminRssFeedEpisodeEnclosure>(this as AdminRssFeedEpisodeEnclosure, _$identity);

  /// Serializes this AdminRssFeedEpisodeEnclosure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminRssFeedEpisodeEnclosure&&(identical(other.url, url) || other.url == url)&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,size,type);

@override
String toString() {
  return 'AdminRssFeedEpisodeEnclosure(url: $url, size: $size, type: $type)';
}


}

/// @nodoc
abstract mixin class $AdminRssFeedEpisodeEnclosureCopyWith<$Res>  {
  factory $AdminRssFeedEpisodeEnclosureCopyWith(AdminRssFeedEpisodeEnclosure value, $Res Function(AdminRssFeedEpisodeEnclosure) _then) = _$AdminRssFeedEpisodeEnclosureCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? size,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class _$AdminRssFeedEpisodeEnclosureCopyWithImpl<$Res>
    implements $AdminRssFeedEpisodeEnclosureCopyWith<$Res> {
  _$AdminRssFeedEpisodeEnclosureCopyWithImpl(this._self, this._then);

  final AdminRssFeedEpisodeEnclosure _self;
  final $Res Function(AdminRssFeedEpisodeEnclosure) _then;

/// Create a copy of AdminRssFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? size = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminRssFeedEpisodeEnclosure].
extension AdminRssFeedEpisodeEnclosurePatterns on AdminRssFeedEpisodeEnclosure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminRssFeedEpisodeEnclosure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminRssFeedEpisodeEnclosure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminRssFeedEpisodeEnclosure value)  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedEpisodeEnclosure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminRssFeedEpisodeEnclosure value)?  $default,){
final _that = this;
switch (_that) {
case _AdminRssFeedEpisodeEnclosure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic)  int? size, @JsonKey(name: 'type')  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminRssFeedEpisodeEnclosure() when $default != null:
return $default(_that.url,_that.size,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic)  int? size, @JsonKey(name: 'type')  String? type)  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedEpisodeEnclosure():
return $default(_that.url,_that.size,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic)  int? size, @JsonKey(name: 'type')  String? type)?  $default,) {final _that = this;
switch (_that) {
case _AdminRssFeedEpisodeEnclosure() when $default != null:
return $default(_that.url,_that.size,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminRssFeedEpisodeEnclosure implements AdminRssFeedEpisodeEnclosure {
  const _AdminRssFeedEpisodeEnclosure({@JsonKey(name: 'url') this.url, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic) this.size, @JsonKey(name: 'type') this.type});
  factory _AdminRssFeedEpisodeEnclosure.fromJson(Map<String, dynamic> json) => _$AdminRssFeedEpisodeEnclosureFromJson(json);

@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) final  int? size;
@override@JsonKey(name: 'type') final  String? type;

/// Create a copy of AdminRssFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminRssFeedEpisodeEnclosureCopyWith<_AdminRssFeedEpisodeEnclosure> get copyWith => __$AdminRssFeedEpisodeEnclosureCopyWithImpl<_AdminRssFeedEpisodeEnclosure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminRssFeedEpisodeEnclosureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminRssFeedEpisodeEnclosure&&(identical(other.url, url) || other.url == url)&&(identical(other.size, size) || other.size == size)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,size,type);

@override
String toString() {
  return 'AdminRssFeedEpisodeEnclosure(url: $url, size: $size, type: $type)';
}


}

/// @nodoc
abstract mixin class _$AdminRssFeedEpisodeEnclosureCopyWith<$Res> implements $AdminRssFeedEpisodeEnclosureCopyWith<$Res> {
  factory _$AdminRssFeedEpisodeEnclosureCopyWith(_AdminRssFeedEpisodeEnclosure value, $Res Function(_AdminRssFeedEpisodeEnclosure) _then) = __$AdminRssFeedEpisodeEnclosureCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? size,@JsonKey(name: 'type') String? type
});




}
/// @nodoc
class __$AdminRssFeedEpisodeEnclosureCopyWithImpl<$Res>
    implements _$AdminRssFeedEpisodeEnclosureCopyWith<$Res> {
  __$AdminRssFeedEpisodeEnclosureCopyWithImpl(this._self, this._then);

  final _AdminRssFeedEpisodeEnclosure _self;
  final $Res Function(_AdminRssFeedEpisodeEnclosure) _then;

/// Create a copy of AdminRssFeedEpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? size = freezed,Object? type = freezed,}) {
  return _then(_AdminRssFeedEpisodeEnclosure(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
