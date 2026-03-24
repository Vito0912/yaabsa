// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaylistItem {

@JsonKey(name: "libraryItemId") String get itemId;@JsonKey(name: "episodeId") String? get episodeId;@JsonKey(name: "episode") Episode? get episode;@JsonKey(name: "libraryItem") LibraryItem? get libraryItem;
/// Create a copy of PlaylistItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistItemCopyWith<PlaylistItem> get copyWith => _$PlaylistItemCopyWithImpl<PlaylistItem>(this as PlaylistItem, _$identity);

  /// Serializes this PlaylistItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId,episode,libraryItem);

@override
String toString() {
  return 'PlaylistItem(itemId: $itemId, episodeId: $episodeId, episode: $episode, libraryItem: $libraryItem)';
}


}

/// @nodoc
abstract mixin class $PlaylistItemCopyWith<$Res>  {
  factory $PlaylistItemCopyWith(PlaylistItem value, $Res Function(PlaylistItem) _then) = _$PlaylistItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraryItemId") String itemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "libraryItem") LibraryItem? libraryItem
});


$EpisodeCopyWith<$Res>? get episode;$LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class _$PlaylistItemCopyWithImpl<$Res>
    implements $PlaylistItemCopyWith<$Res> {
  _$PlaylistItemCopyWithImpl(this._self, this._then);

  final PlaylistItem _self;
  final $Res Function(PlaylistItem) _then;

/// Create a copy of PlaylistItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? episodeId = freezed,Object? episode = freezed,Object? libraryItem = freezed,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}
/// Create a copy of PlaylistItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}/// Create a copy of PlaylistItem
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


/// Adds pattern-matching-related methods to [PlaylistItem].
extension PlaylistItemPatterns on PlaylistItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaylistItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaylistItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaylistItem value)  $default,){
final _that = this;
switch (_that) {
case _PlaylistItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaylistItem value)?  $default,){
final _that = this;
switch (_that) {
case _PlaylistItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "libraryItemId")  String itemId, @JsonKey(name: "episodeId")  String? episodeId, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "libraryItem")  LibraryItem? libraryItem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaylistItem() when $default != null:
return $default(_that.itemId,_that.episodeId,_that.episode,_that.libraryItem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "libraryItemId")  String itemId, @JsonKey(name: "episodeId")  String? episodeId, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "libraryItem")  LibraryItem? libraryItem)  $default,) {final _that = this;
switch (_that) {
case _PlaylistItem():
return $default(_that.itemId,_that.episodeId,_that.episode,_that.libraryItem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "libraryItemId")  String itemId, @JsonKey(name: "episodeId")  String? episodeId, @JsonKey(name: "episode")  Episode? episode, @JsonKey(name: "libraryItem")  LibraryItem? libraryItem)?  $default,) {final _that = this;
switch (_that) {
case _PlaylistItem() when $default != null:
return $default(_that.itemId,_that.episodeId,_that.episode,_that.libraryItem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaylistItem implements PlaylistItem {
  const _PlaylistItem({@JsonKey(name: "libraryItemId") required this.itemId, @JsonKey(name: "episodeId") this.episodeId, @JsonKey(name: "episode") this.episode, @JsonKey(name: "libraryItem") this.libraryItem});
  factory _PlaylistItem.fromJson(Map<String, dynamic> json) => _$PlaylistItemFromJson(json);

@override@JsonKey(name: "libraryItemId") final  String itemId;
@override@JsonKey(name: "episodeId") final  String? episodeId;
@override@JsonKey(name: "episode") final  Episode? episode;
@override@JsonKey(name: "libraryItem") final  LibraryItem? libraryItem;

/// Create a copy of PlaylistItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaylistItemCopyWith<_PlaylistItem> get copyWith => __$PlaylistItemCopyWithImpl<_PlaylistItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaylistItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaylistItem&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.episode, episode) || other.episode == episode)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId,episode,libraryItem);

@override
String toString() {
  return 'PlaylistItem(itemId: $itemId, episodeId: $episodeId, episode: $episode, libraryItem: $libraryItem)';
}


}

/// @nodoc
abstract mixin class _$PlaylistItemCopyWith<$Res> implements $PlaylistItemCopyWith<$Res> {
  factory _$PlaylistItemCopyWith(_PlaylistItem value, $Res Function(_PlaylistItem) _then) = __$PlaylistItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraryItemId") String itemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "episode") Episode? episode,@JsonKey(name: "libraryItem") LibraryItem? libraryItem
});


@override $EpisodeCopyWith<$Res>? get episode;@override $LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class __$PlaylistItemCopyWithImpl<$Res>
    implements _$PlaylistItemCopyWith<$Res> {
  __$PlaylistItemCopyWithImpl(this._self, this._then);

  final _PlaylistItem _self;
  final $Res Function(_PlaylistItem) _then;

/// Create a copy of PlaylistItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? episodeId = freezed,Object? episode = freezed,Object? libraryItem = freezed,}) {
  return _then(_PlaylistItem(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as Episode?,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}

/// Create a copy of PlaylistItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EpisodeCopyWith<$Res>? get episode {
    if (_self.episode == null) {
    return null;
  }

  return $EpisodeCopyWith<$Res>(_self.episode!, (value) {
    return _then(_self.copyWith(episode: value));
  });
}/// Create a copy of PlaylistItem
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

// dart format on
