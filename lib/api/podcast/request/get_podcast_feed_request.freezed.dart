// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_podcast_feed_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetPodcastFeedRequest {

@JsonKey(name: 'rssFeed') String get rssFeed;
/// Create a copy of GetPodcastFeedRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GetPodcastFeedRequestCopyWith<GetPodcastFeedRequest> get copyWith => _$GetPodcastFeedRequestCopyWithImpl<GetPodcastFeedRequest>(this as GetPodcastFeedRequest, _$identity);

  /// Serializes this GetPodcastFeedRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GetPodcastFeedRequest&&(identical(other.rssFeed, rssFeed) || other.rssFeed == rssFeed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rssFeed);

@override
String toString() {
  return 'GetPodcastFeedRequest(rssFeed: $rssFeed)';
}


}

/// @nodoc
abstract mixin class $GetPodcastFeedRequestCopyWith<$Res>  {
  factory $GetPodcastFeedRequestCopyWith(GetPodcastFeedRequest value, $Res Function(GetPodcastFeedRequest) _then) = _$GetPodcastFeedRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'rssFeed') String rssFeed
});




}
/// @nodoc
class _$GetPodcastFeedRequestCopyWithImpl<$Res>
    implements $GetPodcastFeedRequestCopyWith<$Res> {
  _$GetPodcastFeedRequestCopyWithImpl(this._self, this._then);

  final GetPodcastFeedRequest _self;
  final $Res Function(GetPodcastFeedRequest) _then;

/// Create a copy of GetPodcastFeedRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rssFeed = null,}) {
  return _then(_self.copyWith(
rssFeed: null == rssFeed ? _self.rssFeed : rssFeed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GetPodcastFeedRequest].
extension GetPodcastFeedRequestPatterns on GetPodcastFeedRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GetPodcastFeedRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GetPodcastFeedRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GetPodcastFeedRequest value)  $default,){
final _that = this;
switch (_that) {
case _GetPodcastFeedRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GetPodcastFeedRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GetPodcastFeedRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'rssFeed')  String rssFeed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GetPodcastFeedRequest() when $default != null:
return $default(_that.rssFeed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'rssFeed')  String rssFeed)  $default,) {final _that = this;
switch (_that) {
case _GetPodcastFeedRequest():
return $default(_that.rssFeed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'rssFeed')  String rssFeed)?  $default,) {final _that = this;
switch (_that) {
case _GetPodcastFeedRequest() when $default != null:
return $default(_that.rssFeed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GetPodcastFeedRequest implements GetPodcastFeedRequest {
  const _GetPodcastFeedRequest({@JsonKey(name: 'rssFeed') required this.rssFeed});
  factory _GetPodcastFeedRequest.fromJson(Map<String, dynamic> json) => _$GetPodcastFeedRequestFromJson(json);

@override@JsonKey(name: 'rssFeed') final  String rssFeed;

/// Create a copy of GetPodcastFeedRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GetPodcastFeedRequestCopyWith<_GetPodcastFeedRequest> get copyWith => __$GetPodcastFeedRequestCopyWithImpl<_GetPodcastFeedRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GetPodcastFeedRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GetPodcastFeedRequest&&(identical(other.rssFeed, rssFeed) || other.rssFeed == rssFeed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rssFeed);

@override
String toString() {
  return 'GetPodcastFeedRequest(rssFeed: $rssFeed)';
}


}

/// @nodoc
abstract mixin class _$GetPodcastFeedRequestCopyWith<$Res> implements $GetPodcastFeedRequestCopyWith<$Res> {
  factory _$GetPodcastFeedRequestCopyWith(_GetPodcastFeedRequest value, $Res Function(_GetPodcastFeedRequest) _then) = __$GetPodcastFeedRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'rssFeed') String rssFeed
});




}
/// @nodoc
class __$GetPodcastFeedRequestCopyWithImpl<$Res>
    implements _$GetPodcastFeedRequestCopyWith<$Res> {
  __$GetPodcastFeedRequestCopyWithImpl(this._self, this._then);

  final _GetPodcastFeedRequest _self;
  final $Res Function(_GetPodcastFeedRequest) _then;

/// Create a copy of GetPodcastFeedRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rssFeed = null,}) {
  return _then(_GetPodcastFeedRequest(
rssFeed: null == rssFeed ? _self.rssFeed : rssFeed // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
