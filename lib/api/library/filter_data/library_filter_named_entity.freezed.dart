// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_filter_named_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryFilterNamedEntity {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;
/// Create a copy of LibraryFilterNamedEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryFilterNamedEntityCopyWith<LibraryFilterNamedEntity> get copyWith => _$LibraryFilterNamedEntityCopyWithImpl<LibraryFilterNamedEntity>(this as LibraryFilterNamedEntity, _$identity);

  /// Serializes this LibraryFilterNamedEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryFilterNamedEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'LibraryFilterNamedEntity(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $LibraryFilterNamedEntityCopyWith<$Res>  {
  factory $LibraryFilterNamedEntityCopyWith(LibraryFilterNamedEntity value, $Res Function(LibraryFilterNamedEntity) _then) = _$LibraryFilterNamedEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name
});




}
/// @nodoc
class _$LibraryFilterNamedEntityCopyWithImpl<$Res>
    implements $LibraryFilterNamedEntityCopyWith<$Res> {
  _$LibraryFilterNamedEntityCopyWithImpl(this._self, this._then);

  final LibraryFilterNamedEntity _self;
  final $Res Function(LibraryFilterNamedEntity) _then;

/// Create a copy of LibraryFilterNamedEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryFilterNamedEntity].
extension LibraryFilterNamedEntityPatterns on LibraryFilterNamedEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryFilterNamedEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryFilterNamedEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryFilterNamedEntity value)  $default,){
final _that = this;
switch (_that) {
case _LibraryFilterNamedEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryFilterNamedEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryFilterNamedEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryFilterNamedEntity() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name)  $default,) {final _that = this;
switch (_that) {
case _LibraryFilterNamedEntity():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name)?  $default,) {final _that = this;
switch (_that) {
case _LibraryFilterNamedEntity() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryFilterNamedEntity implements LibraryFilterNamedEntity {
  const _LibraryFilterNamedEntity({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name});
  factory _LibraryFilterNamedEntity.fromJson(Map<String, dynamic> json) => _$LibraryFilterNamedEntityFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;

/// Create a copy of LibraryFilterNamedEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryFilterNamedEntityCopyWith<_LibraryFilterNamedEntity> get copyWith => __$LibraryFilterNamedEntityCopyWithImpl<_LibraryFilterNamedEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryFilterNamedEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryFilterNamedEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'LibraryFilterNamedEntity(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$LibraryFilterNamedEntityCopyWith<$Res> implements $LibraryFilterNamedEntityCopyWith<$Res> {
  factory _$LibraryFilterNamedEntityCopyWith(_LibraryFilterNamedEntity value, $Res Function(_LibraryFilterNamedEntity) _then) = __$LibraryFilterNamedEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name
});




}
/// @nodoc
class __$LibraryFilterNamedEntityCopyWithImpl<$Res>
    implements _$LibraryFilterNamedEntityCopyWith<$Res> {
  __$LibraryFilterNamedEntityCopyWithImpl(this._self, this._then);

  final _LibraryFilterNamedEntity _self;
  final $Res Function(_LibraryFilterNamedEntity) _then;

/// Create a copy of LibraryFilterNamedEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_LibraryFilterNamedEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
