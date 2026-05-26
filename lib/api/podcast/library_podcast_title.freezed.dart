// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_podcast_title.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryPodcastTitle {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'libraryItemId') String? get libraryItemId;@JsonKey(name: 'title') String get title;@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? get itunesId;
/// Create a copy of LibraryPodcastTitle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryPodcastTitleCopyWith<LibraryPodcastTitle> get copyWith => _$LibraryPodcastTitleCopyWithImpl<LibraryPodcastTitle>(this as LibraryPodcastTitle, _$identity);

  /// Serializes this LibraryPodcastTitle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryPodcastTitle&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryItemId,title,itunesId);

@override
String toString() {
  return 'LibraryPodcastTitle(id: $id, libraryItemId: $libraryItemId, title: $title, itunesId: $itunesId)';
}


}

/// @nodoc
abstract mixin class $LibraryPodcastTitleCopyWith<$Res>  {
  factory $LibraryPodcastTitleCopyWith(LibraryPodcastTitle value, $Res Function(LibraryPodcastTitle) _then) = _$LibraryPodcastTitleCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'libraryItemId') String? libraryItemId,@JsonKey(name: 'title') String title,@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? itunesId
});




}
/// @nodoc
class _$LibraryPodcastTitleCopyWithImpl<$Res>
    implements $LibraryPodcastTitleCopyWith<$Res> {
  _$LibraryPodcastTitleCopyWithImpl(this._self, this._then);

  final LibraryPodcastTitle _self;
  final $Res Function(LibraryPodcastTitle) _then;

/// Create a copy of LibraryPodcastTitle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? libraryItemId = freezed,Object? title = null,Object? itunesId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryPodcastTitle].
extension LibraryPodcastTitlePatterns on LibraryPodcastTitle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryPodcastTitle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryPodcastTitle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryPodcastTitle value)  $default,){
final _that = this;
switch (_that) {
case _LibraryPodcastTitle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryPodcastTitle value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryPodcastTitle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'libraryItemId')  String? libraryItemId, @JsonKey(name: 'title')  String title, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic)  String? itunesId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryPodcastTitle() when $default != null:
return $default(_that.id,_that.libraryItemId,_that.title,_that.itunesId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'libraryItemId')  String? libraryItemId, @JsonKey(name: 'title')  String title, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic)  String? itunesId)  $default,) {final _that = this;
switch (_that) {
case _LibraryPodcastTitle():
return $default(_that.id,_that.libraryItemId,_that.title,_that.itunesId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'libraryItemId')  String? libraryItemId, @JsonKey(name: 'title')  String title, @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic)  String? itunesId)?  $default,) {final _that = this;
switch (_that) {
case _LibraryPodcastTitle() when $default != null:
return $default(_that.id,_that.libraryItemId,_that.title,_that.itunesId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryPodcastTitle implements LibraryPodcastTitle {
  const _LibraryPodcastTitle({@JsonKey(name: 'id') this.id, @JsonKey(name: 'libraryItemId') this.libraryItemId, @JsonKey(name: 'title') this.title = '', @JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) this.itunesId});
  factory _LibraryPodcastTitle.fromJson(Map<String, dynamic> json) => _$LibraryPodcastTitleFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'libraryItemId') final  String? libraryItemId;
@override@JsonKey(name: 'title') final  String title;
@override@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) final  String? itunesId;

/// Create a copy of LibraryPodcastTitle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryPodcastTitleCopyWith<_LibraryPodcastTitle> get copyWith => __$LibraryPodcastTitleCopyWithImpl<_LibraryPodcastTitle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryPodcastTitleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryPodcastTitle&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.title, title) || other.title == title)&&(identical(other.itunesId, itunesId) || other.itunesId == itunesId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryItemId,title,itunesId);

@override
String toString() {
  return 'LibraryPodcastTitle(id: $id, libraryItemId: $libraryItemId, title: $title, itunesId: $itunesId)';
}


}

/// @nodoc
abstract mixin class _$LibraryPodcastTitleCopyWith<$Res> implements $LibraryPodcastTitleCopyWith<$Res> {
  factory _$LibraryPodcastTitleCopyWith(_LibraryPodcastTitle value, $Res Function(_LibraryPodcastTitle) _then) = __$LibraryPodcastTitleCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'libraryItemId') String? libraryItemId,@JsonKey(name: 'title') String title,@JsonKey(name: 'itunesId', fromJson: jsonStringFromDynamic) String? itunesId
});




}
/// @nodoc
class __$LibraryPodcastTitleCopyWithImpl<$Res>
    implements _$LibraryPodcastTitleCopyWith<$Res> {
  __$LibraryPodcastTitleCopyWithImpl(this._self, this._then);

  final _LibraryPodcastTitle _self;
  final $Res Function(_LibraryPodcastTitle) _then;

/// Create a copy of LibraryPodcastTitle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? libraryItemId = freezed,Object? title = null,Object? itunesId = freezed,}) {
  return _then(_LibraryPodcastTitle(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,libraryItemId: freezed == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,itunesId: freezed == itunesId ? _self.itunesId : itunesId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
