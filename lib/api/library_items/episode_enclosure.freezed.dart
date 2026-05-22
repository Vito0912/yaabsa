// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'episode_enclosure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EpisodeEnclosure {

@JsonKey(name: 'url') String? get url;@JsonKey(name: 'type') String? get type;@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? get length;
/// Create a copy of EpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EpisodeEnclosureCopyWith<EpisodeEnclosure> get copyWith => _$EpisodeEnclosureCopyWithImpl<EpisodeEnclosure>(this as EpisodeEnclosure, _$identity);

  /// Serializes this EpisodeEnclosure to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EpisodeEnclosure&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.length, length) || other.length == length));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,type,length);

@override
String toString() {
  return 'EpisodeEnclosure(url: $url, type: $type, length: $length)';
}


}

/// @nodoc
abstract mixin class $EpisodeEnclosureCopyWith<$Res>  {
  factory $EpisodeEnclosureCopyWith(EpisodeEnclosure value, $Res Function(EpisodeEnclosure) _then) = _$EpisodeEnclosureCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'type') String? type,@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? length
});




}
/// @nodoc
class _$EpisodeEnclosureCopyWithImpl<$Res>
    implements $EpisodeEnclosureCopyWith<$Res> {
  _$EpisodeEnclosureCopyWithImpl(this._self, this._then);

  final EpisodeEnclosure _self;
  final $Res Function(EpisodeEnclosure) _then;

/// Create a copy of EpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = freezed,Object? type = freezed,Object? length = freezed,}) {
  return _then(_self.copyWith(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EpisodeEnclosure].
extension EpisodeEnclosurePatterns on EpisodeEnclosure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EpisodeEnclosure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EpisodeEnclosure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EpisodeEnclosure value)  $default,){
final _that = this;
switch (_that) {
case _EpisodeEnclosure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EpisodeEnclosure value)?  $default,){
final _that = this;
switch (_that) {
case _EpisodeEnclosure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic)  int? length)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EpisodeEnclosure() when $default != null:
return $default(_that.url,_that.type,_that.length);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic)  int? length)  $default,) {final _that = this;
switch (_that) {
case _EpisodeEnclosure():
return $default(_that.url,_that.type,_that.length);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'url')  String? url, @JsonKey(name: 'type')  String? type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic)  int? length)?  $default,) {final _that = this;
switch (_that) {
case _EpisodeEnclosure() when $default != null:
return $default(_that.url,_that.type,_that.length);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EpisodeEnclosure implements EpisodeEnclosure {
  const _EpisodeEnclosure({@JsonKey(name: 'url') this.url, @JsonKey(name: 'type') this.type, @JsonKey(name: 'length', fromJson: jsonIntFromDynamic) this.length});
  factory _EpisodeEnclosure.fromJson(Map<String, dynamic> json) => _$EpisodeEnclosureFromJson(json);

@override@JsonKey(name: 'url') final  String? url;
@override@JsonKey(name: 'type') final  String? type;
@override@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) final  int? length;

/// Create a copy of EpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EpisodeEnclosureCopyWith<_EpisodeEnclosure> get copyWith => __$EpisodeEnclosureCopyWithImpl<_EpisodeEnclosure>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EpisodeEnclosureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EpisodeEnclosure&&(identical(other.url, url) || other.url == url)&&(identical(other.type, type) || other.type == type)&&(identical(other.length, length) || other.length == length));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,type,length);

@override
String toString() {
  return 'EpisodeEnclosure(url: $url, type: $type, length: $length)';
}


}

/// @nodoc
abstract mixin class _$EpisodeEnclosureCopyWith<$Res> implements $EpisodeEnclosureCopyWith<$Res> {
  factory _$EpisodeEnclosureCopyWith(_EpisodeEnclosure value, $Res Function(_EpisodeEnclosure) _then) = __$EpisodeEnclosureCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'url') String? url,@JsonKey(name: 'type') String? type,@JsonKey(name: 'length', fromJson: jsonIntFromDynamic) int? length
});




}
/// @nodoc
class __$EpisodeEnclosureCopyWithImpl<$Res>
    implements _$EpisodeEnclosureCopyWith<$Res> {
  __$EpisodeEnclosureCopyWithImpl(this._self, this._then);

  final _EpisodeEnclosure _self;
  final $Res Function(_EpisodeEnclosure) _then;

/// Create a copy of EpisodeEnclosure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = freezed,Object? type = freezed,Object? length = freezed,}) {
  return _then(_EpisodeEnclosure(
url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,length: freezed == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
