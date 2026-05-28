// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata_term_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MetadataTermUpdateResponse {

@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic) int get numItemsUpdated;@JsonKey(name: 'tagMerged') bool? get tagMerged;@JsonKey(name: 'genreMerged') bool? get genreMerged;
/// Create a copy of MetadataTermUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MetadataTermUpdateResponseCopyWith<MetadataTermUpdateResponse> get copyWith => _$MetadataTermUpdateResponseCopyWithImpl<MetadataTermUpdateResponse>(this as MetadataTermUpdateResponse, _$identity);

  /// Serializes this MetadataTermUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MetadataTermUpdateResponse&&(identical(other.numItemsUpdated, numItemsUpdated) || other.numItemsUpdated == numItemsUpdated)&&(identical(other.tagMerged, tagMerged) || other.tagMerged == tagMerged)&&(identical(other.genreMerged, genreMerged) || other.genreMerged == genreMerged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,numItemsUpdated,tagMerged,genreMerged);

@override
String toString() {
  return 'MetadataTermUpdateResponse(numItemsUpdated: $numItemsUpdated, tagMerged: $tagMerged, genreMerged: $genreMerged)';
}


}

/// @nodoc
abstract mixin class $MetadataTermUpdateResponseCopyWith<$Res>  {
  factory $MetadataTermUpdateResponseCopyWith(MetadataTermUpdateResponse value, $Res Function(MetadataTermUpdateResponse) _then) = _$MetadataTermUpdateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic) int numItemsUpdated,@JsonKey(name: 'tagMerged') bool? tagMerged,@JsonKey(name: 'genreMerged') bool? genreMerged
});




}
/// @nodoc
class _$MetadataTermUpdateResponseCopyWithImpl<$Res>
    implements $MetadataTermUpdateResponseCopyWith<$Res> {
  _$MetadataTermUpdateResponseCopyWithImpl(this._self, this._then);

  final MetadataTermUpdateResponse _self;
  final $Res Function(MetadataTermUpdateResponse) _then;

/// Create a copy of MetadataTermUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? numItemsUpdated = null,Object? tagMerged = freezed,Object? genreMerged = freezed,}) {
  return _then(_self.copyWith(
numItemsUpdated: null == numItemsUpdated ? _self.numItemsUpdated : numItemsUpdated // ignore: cast_nullable_to_non_nullable
as int,tagMerged: freezed == tagMerged ? _self.tagMerged : tagMerged // ignore: cast_nullable_to_non_nullable
as bool?,genreMerged: freezed == genreMerged ? _self.genreMerged : genreMerged // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [MetadataTermUpdateResponse].
extension MetadataTermUpdateResponsePatterns on MetadataTermUpdateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MetadataTermUpdateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MetadataTermUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MetadataTermUpdateResponse value)  $default,){
final _that = this;
switch (_that) {
case _MetadataTermUpdateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MetadataTermUpdateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _MetadataTermUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic)  int numItemsUpdated, @JsonKey(name: 'tagMerged')  bool? tagMerged, @JsonKey(name: 'genreMerged')  bool? genreMerged)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MetadataTermUpdateResponse() when $default != null:
return $default(_that.numItemsUpdated,_that.tagMerged,_that.genreMerged);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic)  int numItemsUpdated, @JsonKey(name: 'tagMerged')  bool? tagMerged, @JsonKey(name: 'genreMerged')  bool? genreMerged)  $default,) {final _that = this;
switch (_that) {
case _MetadataTermUpdateResponse():
return $default(_that.numItemsUpdated,_that.tagMerged,_that.genreMerged);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic)  int numItemsUpdated, @JsonKey(name: 'tagMerged')  bool? tagMerged, @JsonKey(name: 'genreMerged')  bool? genreMerged)?  $default,) {final _that = this;
switch (_that) {
case _MetadataTermUpdateResponse() when $default != null:
return $default(_that.numItemsUpdated,_that.tagMerged,_that.genreMerged);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MetadataTermUpdateResponse implements MetadataTermUpdateResponse {
  const _MetadataTermUpdateResponse({@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic) this.numItemsUpdated = 0, @JsonKey(name: 'tagMerged') this.tagMerged, @JsonKey(name: 'genreMerged') this.genreMerged});
  factory _MetadataTermUpdateResponse.fromJson(Map<String, dynamic> json) => _$MetadataTermUpdateResponseFromJson(json);

@override@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic) final  int numItemsUpdated;
@override@JsonKey(name: 'tagMerged') final  bool? tagMerged;
@override@JsonKey(name: 'genreMerged') final  bool? genreMerged;

/// Create a copy of MetadataTermUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MetadataTermUpdateResponseCopyWith<_MetadataTermUpdateResponse> get copyWith => __$MetadataTermUpdateResponseCopyWithImpl<_MetadataTermUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MetadataTermUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MetadataTermUpdateResponse&&(identical(other.numItemsUpdated, numItemsUpdated) || other.numItemsUpdated == numItemsUpdated)&&(identical(other.tagMerged, tagMerged) || other.tagMerged == tagMerged)&&(identical(other.genreMerged, genreMerged) || other.genreMerged == genreMerged));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,numItemsUpdated,tagMerged,genreMerged);

@override
String toString() {
  return 'MetadataTermUpdateResponse(numItemsUpdated: $numItemsUpdated, tagMerged: $tagMerged, genreMerged: $genreMerged)';
}


}

/// @nodoc
abstract mixin class _$MetadataTermUpdateResponseCopyWith<$Res> implements $MetadataTermUpdateResponseCopyWith<$Res> {
  factory _$MetadataTermUpdateResponseCopyWith(_MetadataTermUpdateResponse value, $Res Function(_MetadataTermUpdateResponse) _then) = __$MetadataTermUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'numItemsUpdated', fromJson: jsonIntRequiredFromDynamic) int numItemsUpdated,@JsonKey(name: 'tagMerged') bool? tagMerged,@JsonKey(name: 'genreMerged') bool? genreMerged
});




}
/// @nodoc
class __$MetadataTermUpdateResponseCopyWithImpl<$Res>
    implements _$MetadataTermUpdateResponseCopyWith<$Res> {
  __$MetadataTermUpdateResponseCopyWithImpl(this._self, this._then);

  final _MetadataTermUpdateResponse _self;
  final $Res Function(_MetadataTermUpdateResponse) _then;

/// Create a copy of MetadataTermUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? numItemsUpdated = null,Object? tagMerged = freezed,Object? genreMerged = freezed,}) {
  return _then(_MetadataTermUpdateResponse(
numItemsUpdated: null == numItemsUpdated ? _self.numItemsUpdated : numItemsUpdated // ignore: cast_nullable_to_non_nullable
as int,tagMerged: freezed == tagMerged ? _self.tagMerged : tagMerged // ignore: cast_nullable_to_non_nullable
as bool?,genreMerged: freezed == genreMerged ? _self.genreMerged : genreMerged // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
