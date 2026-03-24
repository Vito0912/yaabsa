// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'author_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthorStats {

@JsonKey(name: "id") String get id;@JsonKey(name: "name") String get name;@JsonKey(name: "count") int get count;
/// Create a copy of AuthorStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorStatsCopyWith<AuthorStats> get copyWith => _$AuthorStatsCopyWithImpl<AuthorStats>(this as AuthorStats, _$identity);

  /// Serializes this AuthorStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorStats&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,count);

@override
String toString() {
  return 'AuthorStats(id: $id, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class $AuthorStatsCopyWith<$Res>  {
  factory $AuthorStatsCopyWith(AuthorStats value, $Res Function(AuthorStats) _then) = _$AuthorStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String name,@JsonKey(name: "count") int count
});




}
/// @nodoc
class _$AuthorStatsCopyWithImpl<$Res>
    implements $AuthorStatsCopyWith<$Res> {
  _$AuthorStatsCopyWithImpl(this._self, this._then);

  final AuthorStats _self;
  final $Res Function(AuthorStats) _then;

/// Create a copy of AuthorStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? count = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorStats].
extension AuthorStatsPatterns on AuthorStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorStats value)  $default,){
final _that = this;
switch (_that) {
case _AuthorStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorStats value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "name")  String name, @JsonKey(name: "count")  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorStats() when $default != null:
return $default(_that.id,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "name")  String name, @JsonKey(name: "count")  int count)  $default,) {final _that = this;
switch (_that) {
case _AuthorStats():
return $default(_that.id,_that.name,_that.count);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "name")  String name, @JsonKey(name: "count")  int count)?  $default,) {final _that = this;
switch (_that) {
case _AuthorStats() when $default != null:
return $default(_that.id,_that.name,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorStats implements AuthorStats {
  const _AuthorStats({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "count") required this.count});
  factory _AuthorStats.fromJson(Map<String, dynamic> json) => _$AuthorStatsFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "count") final  int count;

/// Create a copy of AuthorStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorStatsCopyWith<_AuthorStats> get copyWith => __$AuthorStatsCopyWithImpl<_AuthorStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorStats&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,count);

@override
String toString() {
  return 'AuthorStats(id: $id, name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class _$AuthorStatsCopyWith<$Res> implements $AuthorStatsCopyWith<$Res> {
  factory _$AuthorStatsCopyWith(_AuthorStats value, $Res Function(_AuthorStats) _then) = __$AuthorStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String name,@JsonKey(name: "count") int count
});




}
/// @nodoc
class __$AuthorStatsCopyWithImpl<$Res>
    implements _$AuthorStatsCopyWith<$Res> {
  __$AuthorStatsCopyWithImpl(this._self, this._then);

  final _AuthorStats _self;
  final $Res Function(_AuthorStats) _then;

/// Create a copy of AuthorStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? count = null,}) {
  return _then(_AuthorStats(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
