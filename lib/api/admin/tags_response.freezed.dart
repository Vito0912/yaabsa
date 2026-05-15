// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tags_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TagsResponse {

@JsonKey(name: 'tags', fromJson: _stringListFromJson) List<String> get tags;
/// Create a copy of TagsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagsResponseCopyWith<TagsResponse> get copyWith => _$TagsResponseCopyWithImpl<TagsResponse>(this as TagsResponse, _$identity);

  /// Serializes this TagsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagsResponse&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'TagsResponse(tags: $tags)';
}


}

/// @nodoc
abstract mixin class $TagsResponseCopyWith<$Res>  {
  factory $TagsResponseCopyWith(TagsResponse value, $Res Function(TagsResponse) _then) = _$TagsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'tags', fromJson: _stringListFromJson) List<String> tags
});




}
/// @nodoc
class _$TagsResponseCopyWithImpl<$Res>
    implements $TagsResponseCopyWith<$Res> {
  _$TagsResponseCopyWithImpl(this._self, this._then);

  final TagsResponse _self;
  final $Res Function(TagsResponse) _then;

/// Create a copy of TagsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tags = null,}) {
  return _then(_self.copyWith(
tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TagsResponse].
extension TagsResponsePatterns on TagsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagsResponse value)  $default,){
final _that = this;
switch (_that) {
case _TagsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TagsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'tags', fromJson: _stringListFromJson)  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagsResponse() when $default != null:
return $default(_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'tags', fromJson: _stringListFromJson)  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _TagsResponse():
return $default(_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'tags', fromJson: _stringListFromJson)  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _TagsResponse() when $default != null:
return $default(_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TagsResponse implements TagsResponse {
  const _TagsResponse({@JsonKey(name: 'tags', fromJson: _stringListFromJson) final  List<String> tags = const <String>[]}): _tags = tags;
  factory _TagsResponse.fromJson(Map<String, dynamic> json) => _$TagsResponseFromJson(json);

 final  List<String> _tags;
@override@JsonKey(name: 'tags', fromJson: _stringListFromJson) List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of TagsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagsResponseCopyWith<_TagsResponse> get copyWith => __$TagsResponseCopyWithImpl<_TagsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagsResponse&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'TagsResponse(tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$TagsResponseCopyWith<$Res> implements $TagsResponseCopyWith<$Res> {
  factory _$TagsResponseCopyWith(_TagsResponse value, $Res Function(_TagsResponse) _then) = __$TagsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'tags', fromJson: _stringListFromJson) List<String> tags
});




}
/// @nodoc
class __$TagsResponseCopyWithImpl<$Res>
    implements _$TagsResponseCopyWith<$Res> {
  __$TagsResponseCopyWithImpl(this._self, this._then);

  final _TagsResponse _self;
  final $Res Function(_TagsResponse) _then;

/// Create a copy of TagsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tags = null,}) {
  return _then(_TagsResponse(
tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
