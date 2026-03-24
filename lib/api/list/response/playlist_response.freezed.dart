// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaylistResponse {

@JsonKey(name: "playlists") List<Playlist> get items;
/// Create a copy of PlaylistResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistResponseCopyWith<PlaylistResponse> get copyWith => _$PlaylistResponseCopyWithImpl<PlaylistResponse>(this as PlaylistResponse, _$identity);

  /// Serializes this PlaylistResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistResponse&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'PlaylistResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class $PlaylistResponseCopyWith<$Res>  {
  factory $PlaylistResponseCopyWith(PlaylistResponse value, $Res Function(PlaylistResponse) _then) = _$PlaylistResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "playlists") List<Playlist> items
});




}
/// @nodoc
class _$PlaylistResponseCopyWithImpl<$Res>
    implements $PlaylistResponseCopyWith<$Res> {
  _$PlaylistResponseCopyWithImpl(this._self, this._then);

  final PlaylistResponse _self;
  final $Res Function(PlaylistResponse) _then;

/// Create a copy of PlaylistResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Playlist>,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaylistResponse].
extension PlaylistResponsePatterns on PlaylistResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaylistResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaylistResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaylistResponse value)  $default,){
final _that = this;
switch (_that) {
case _PlaylistResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaylistResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PlaylistResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "playlists")  List<Playlist> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaylistResponse() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "playlists")  List<Playlist> items)  $default,) {final _that = this;
switch (_that) {
case _PlaylistResponse():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "playlists")  List<Playlist> items)?  $default,) {final _that = this;
switch (_that) {
case _PlaylistResponse() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlaylistResponse implements PlaylistResponse {
  const _PlaylistResponse({@JsonKey(name: "playlists") required final  List<Playlist> items}): _items = items;
  factory _PlaylistResponse.fromJson(Map<String, dynamic> json) => _$PlaylistResponseFromJson(json);

 final  List<Playlist> _items;
@override@JsonKey(name: "playlists") List<Playlist> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of PlaylistResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaylistResponseCopyWith<_PlaylistResponse> get copyWith => __$PlaylistResponseCopyWithImpl<_PlaylistResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaylistResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaylistResponse&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'PlaylistResponse(items: $items)';
}


}

/// @nodoc
abstract mixin class _$PlaylistResponseCopyWith<$Res> implements $PlaylistResponseCopyWith<$Res> {
  factory _$PlaylistResponseCopyWith(_PlaylistResponse value, $Res Function(_PlaylistResponse) _then) = __$PlaylistResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "playlists") List<Playlist> items
});




}
/// @nodoc
class __$PlaylistResponseCopyWithImpl<$Res>
    implements _$PlaylistResponseCopyWith<$Res> {
  __$PlaylistResponseCopyWithImpl(this._self, this._then);

  final _PlaylistResponse _self;
  final $Res Function(_PlaylistResponse) _then;

/// Create a copy of PlaylistResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_PlaylistResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Playlist>,
  ));
}


}

// dart format on
