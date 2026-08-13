// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recent_episodes_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecentEpisodesResponse {

@JsonKey(name: 'episodes') List<Episode> get episodes;@JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic) int get limit;@JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic) int get page;
/// Create a copy of RecentEpisodesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecentEpisodesResponseCopyWith<RecentEpisodesResponse> get copyWith => _$RecentEpisodesResponseCopyWithImpl<RecentEpisodesResponse>(this as RecentEpisodesResponse, _$identity);

  /// Serializes this RecentEpisodesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecentEpisodesResponse&&const DeepCollectionEquality().equals(other.episodes, episodes)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(episodes),limit,page);

@override
String toString() {
  return 'RecentEpisodesResponse(episodes: $episodes, limit: $limit, page: $page)';
}


}

/// @nodoc
abstract mixin class $RecentEpisodesResponseCopyWith<$Res>  {
  factory $RecentEpisodesResponseCopyWith(RecentEpisodesResponse value, $Res Function(RecentEpisodesResponse) _then) = _$RecentEpisodesResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'episodes') List<Episode> episodes,@JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic) int limit,@JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic) int page
});




}
/// @nodoc
class _$RecentEpisodesResponseCopyWithImpl<$Res>
    implements $RecentEpisodesResponseCopyWith<$Res> {
  _$RecentEpisodesResponseCopyWithImpl(this._self, this._then);

  final RecentEpisodesResponse _self;
  final $Res Function(RecentEpisodesResponse) _then;

/// Create a copy of RecentEpisodesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? episodes = null,Object? limit = null,Object? page = null,}) {
  return _then(RecentEpisodesResponse(
episodes: null == episodes ? _self.episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecentEpisodesResponse].
extension RecentEpisodesResponsePatterns on RecentEpisodesResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecentEpisodesResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecentEpisodesResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecentEpisodesResponse value)  $default,){
final _that = this;
switch (_that) {
case _RecentEpisodesResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecentEpisodesResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RecentEpisodesResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'episodes')  List<Episode> episodes, @JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic)  int limit, @JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic)  int page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecentEpisodesResponse() when $default != null:
return $default(_that.episodes,_that.limit,_that.page);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'episodes')  List<Episode> episodes, @JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic)  int limit, @JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic)  int page)  $default,) {final _that = this;
switch (_that) {
case _RecentEpisodesResponse():
return $default(_that.episodes,_that.limit,_that.page);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'episodes')  List<Episode> episodes, @JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic)  int limit, @JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic)  int page)?  $default,) {final _that = this;
switch (_that) {
case _RecentEpisodesResponse() when $default != null:
return $default(_that.episodes,_that.limit,_that.page);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecentEpisodesResponse implements RecentEpisodesResponse {
  const _RecentEpisodesResponse({@JsonKey(name: 'episodes')  List<Episode> episodes = const <Episode>[], @JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic) this.limit = 0, @JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic) this.page = 0}): _episodes = episodes;
  factory _RecentEpisodesResponse.fromJson(Map<String, dynamic> json) => _$RecentEpisodesResponseFromJson(json);

 final  List<Episode> _episodes;
@override@JsonKey(name: 'episodes') List<Episode> get episodes {
  if (_episodes is EqualUnmodifiableListView) return _episodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_episodes);
}

@override@JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic) final  int limit;
@override@JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic) final  int page;

/// Create a copy of RecentEpisodesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecentEpisodesResponseCopyWith<_RecentEpisodesResponse> get copyWith => __$RecentEpisodesResponseCopyWithImpl<_RecentEpisodesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecentEpisodesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecentEpisodesResponse&&const DeepCollectionEquality().equals(other._episodes, _episodes)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_episodes),limit,page);

@override
String toString() {
  return 'RecentEpisodesResponse(episodes: $episodes, limit: $limit, page: $page)';
}


}

/// @nodoc
abstract mixin class _$RecentEpisodesResponseCopyWith<$Res> implements $RecentEpisodesResponseCopyWith<$Res> {
  factory _$RecentEpisodesResponseCopyWith(_RecentEpisodesResponse value, $Res Function(_RecentEpisodesResponse) _then) = __$RecentEpisodesResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'episodes') List<Episode> episodes,@JsonKey(name: 'limit', fromJson: jsonIntRequiredFromDynamic) int limit,@JsonKey(name: 'page', fromJson: jsonIntRequiredFromDynamic) int page
});




}
/// @nodoc
class __$RecentEpisodesResponseCopyWithImpl<$Res>
    implements _$RecentEpisodesResponseCopyWith<$Res> {
  __$RecentEpisodesResponseCopyWithImpl(this._self, this._then);

  final _RecentEpisodesResponse _self;
  final $Res Function(_RecentEpisodesResponse) _then;

/// Create a copy of RecentEpisodesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? episodes = null,Object? limit = null,Object? page = null,}) {
  return _then(_RecentEpisodesResponse(
episodes: null == episodes ? _self._episodes : episodes // ignore: cast_nullable_to_non_nullable
as List<Episode>,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
