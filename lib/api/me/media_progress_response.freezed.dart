// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_progress_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaProgressResponse {

@JsonKey(name: 'mediaProgress') List<MediaProgress> get mediaProgress;
/// Create a copy of MediaProgressResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaProgressResponseCopyWith<MediaProgressResponse> get copyWith => _$MediaProgressResponseCopyWithImpl<MediaProgressResponse>(this as MediaProgressResponse, _$identity);

  /// Serializes this MediaProgressResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaProgressResponse&&const DeepCollectionEquality().equals(other.mediaProgress, mediaProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mediaProgress));

@override
String toString() {
  return 'MediaProgressResponse(mediaProgress: $mediaProgress)';
}


}

/// @nodoc
abstract mixin class $MediaProgressResponseCopyWith<$Res>  {
  factory $MediaProgressResponseCopyWith(MediaProgressResponse value, $Res Function(MediaProgressResponse) _then) = _$MediaProgressResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'mediaProgress') List<MediaProgress> mediaProgress
});




}
/// @nodoc
class _$MediaProgressResponseCopyWithImpl<$Res>
    implements $MediaProgressResponseCopyWith<$Res> {
  _$MediaProgressResponseCopyWithImpl(this._self, this._then);

  final MediaProgressResponse _self;
  final $Res Function(MediaProgressResponse) _then;

/// Create a copy of MediaProgressResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaProgress = null,}) {
  return _then(MediaProgressResponse(
mediaProgress: null == mediaProgress ? _self.mediaProgress : mediaProgress // ignore: cast_nullable_to_non_nullable
as List<MediaProgress>,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaProgressResponse].
extension MediaProgressResponsePatterns on MediaProgressResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaProgressResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaProgressResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaProgressResponse value)  $default,){
final _that = this;
switch (_that) {
case _MediaProgressResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaProgressResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MediaProgressResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'mediaProgress')  List<MediaProgress> mediaProgress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaProgressResponse() when $default != null:
return $default(_that.mediaProgress);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'mediaProgress')  List<MediaProgress> mediaProgress)  $default,) {final _that = this;
switch (_that) {
case _MediaProgressResponse():
return $default(_that.mediaProgress);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'mediaProgress')  List<MediaProgress> mediaProgress)?  $default,) {final _that = this;
switch (_that) {
case _MediaProgressResponse() when $default != null:
return $default(_that.mediaProgress);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaProgressResponse implements MediaProgressResponse {
  const _MediaProgressResponse({@JsonKey(name: 'mediaProgress')  List<MediaProgress> mediaProgress = const <MediaProgress>[]}): _mediaProgress = mediaProgress;
  factory _MediaProgressResponse.fromJson(Map<String, dynamic> json) => _$MediaProgressResponseFromJson(json);

 final  List<MediaProgress> _mediaProgress;
@override@JsonKey(name: 'mediaProgress') List<MediaProgress> get mediaProgress {
  if (_mediaProgress is EqualUnmodifiableListView) return _mediaProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mediaProgress);
}


/// Create a copy of MediaProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaProgressResponseCopyWith<_MediaProgressResponse> get copyWith => __$MediaProgressResponseCopyWithImpl<_MediaProgressResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaProgressResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaProgressResponse&&const DeepCollectionEquality().equals(other._mediaProgress, _mediaProgress));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mediaProgress));

@override
String toString() {
  return 'MediaProgressResponse(mediaProgress: $mediaProgress)';
}


}

/// @nodoc
abstract mixin class _$MediaProgressResponseCopyWith<$Res> implements $MediaProgressResponseCopyWith<$Res> {
  factory _$MediaProgressResponseCopyWith(_MediaProgressResponse value, $Res Function(_MediaProgressResponse) _then) = __$MediaProgressResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'mediaProgress') List<MediaProgress> mediaProgress
});




}
/// @nodoc
class __$MediaProgressResponseCopyWithImpl<$Res>
    implements _$MediaProgressResponseCopyWith<$Res> {
  __$MediaProgressResponseCopyWithImpl(this._self, this._then);

  final _MediaProgressResponse _self;
  final $Res Function(_MediaProgressResponse) _then;

/// Create a copy of MediaProgressResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaProgress = null,}) {
  return _then(_MediaProgressResponse(
mediaProgress: null == mediaProgress ? _self._mediaProgress : mediaProgress // ignore: cast_nullable_to_non_nullable
as List<MediaProgress>,
  ));
}


}

// dart format on
