// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmarks_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BookmarksResponse {

@JsonKey(name: 'bookmarks') List<Bookmark> get bookmarks;
/// Create a copy of BookmarksResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookmarksResponseCopyWith<BookmarksResponse> get copyWith => _$BookmarksResponseCopyWithImpl<BookmarksResponse>(this as BookmarksResponse, _$identity);

  /// Serializes this BookmarksResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BookmarksResponse&&const DeepCollectionEquality().equals(other.bookmarks, bookmarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(bookmarks));

@override
String toString() {
  return 'BookmarksResponse(bookmarks: $bookmarks)';
}


}

/// @nodoc
abstract mixin class $BookmarksResponseCopyWith<$Res>  {
  factory $BookmarksResponseCopyWith(BookmarksResponse value, $Res Function(BookmarksResponse) _then) = _$BookmarksResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'bookmarks') List<Bookmark> bookmarks
});




}
/// @nodoc
class _$BookmarksResponseCopyWithImpl<$Res>
    implements $BookmarksResponseCopyWith<$Res> {
  _$BookmarksResponseCopyWithImpl(this._self, this._then);

  final BookmarksResponse _self;
  final $Res Function(BookmarksResponse) _then;

/// Create a copy of BookmarksResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? bookmarks = null,}) {
  return _then(_self.copyWith(
bookmarks: null == bookmarks ? _self.bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<Bookmark>,
  ));
}

}


/// Adds pattern-matching-related methods to [BookmarksResponse].
extension BookmarksResponsePatterns on BookmarksResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BookmarksResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BookmarksResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BookmarksResponse value)  $default,){
final _that = this;
switch (_that) {
case _BookmarksResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BookmarksResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BookmarksResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookmarks')  List<Bookmark> bookmarks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BookmarksResponse() when $default != null:
return $default(_that.bookmarks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'bookmarks')  List<Bookmark> bookmarks)  $default,) {final _that = this;
switch (_that) {
case _BookmarksResponse():
return $default(_that.bookmarks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'bookmarks')  List<Bookmark> bookmarks)?  $default,) {final _that = this;
switch (_that) {
case _BookmarksResponse() when $default != null:
return $default(_that.bookmarks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BookmarksResponse implements BookmarksResponse {
  const _BookmarksResponse({@JsonKey(name: 'bookmarks') final  List<Bookmark> bookmarks = const <Bookmark>[]}): _bookmarks = bookmarks;
  factory _BookmarksResponse.fromJson(Map<String, dynamic> json) => _$BookmarksResponseFromJson(json);

 final  List<Bookmark> _bookmarks;
@override@JsonKey(name: 'bookmarks') List<Bookmark> get bookmarks {
  if (_bookmarks is EqualUnmodifiableListView) return _bookmarks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bookmarks);
}


/// Create a copy of BookmarksResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookmarksResponseCopyWith<_BookmarksResponse> get copyWith => __$BookmarksResponseCopyWithImpl<_BookmarksResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookmarksResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BookmarksResponse&&const DeepCollectionEquality().equals(other._bookmarks, _bookmarks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_bookmarks));

@override
String toString() {
  return 'BookmarksResponse(bookmarks: $bookmarks)';
}


}

/// @nodoc
abstract mixin class _$BookmarksResponseCopyWith<$Res> implements $BookmarksResponseCopyWith<$Res> {
  factory _$BookmarksResponseCopyWith(_BookmarksResponse value, $Res Function(_BookmarksResponse) _then) = __$BookmarksResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'bookmarks') List<Bookmark> bookmarks
});




}
/// @nodoc
class __$BookmarksResponseCopyWithImpl<$Res>
    implements _$BookmarksResponseCopyWith<$Res> {
  __$BookmarksResponseCopyWithImpl(this._self, this._then);

  final _BookmarksResponse _self;
  final $Res Function(_BookmarksResponse) _then;

/// Create a copy of BookmarksResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? bookmarks = null,}) {
  return _then(_BookmarksResponse(
bookmarks: null == bookmarks ? _self._bookmarks : bookmarks // ignore: cast_nullable_to_non_nullable
as List<Bookmark>,
  ));
}


}

// dart format on
