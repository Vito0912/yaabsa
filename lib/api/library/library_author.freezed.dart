// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryAuthor {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'asin') String? get asin;@JsonKey(name: 'name') String get name;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'imagePath') String? get imagePath;@JsonKey(name: 'libraryId') String get libraryId;@JsonKey(name: 'addedAt') int get addedAt;@JsonKey(name: 'updatedAt') int get updatedAt;@JsonKey(name: 'numBooks') int get numBooks;@JsonKey(name: 'lastFirst') String? get lastFirst;
/// Create a copy of LibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryAuthorCopyWith<LibraryAuthor> get copyWith => _$LibraryAuthorCopyWithImpl<LibraryAuthor>(this as LibraryAuthor, _$identity);

  /// Serializes this LibraryAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&(identical(other.lastFirst, lastFirst) || other.lastFirst == lastFirst));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,asin,name,description,imagePath,libraryId,addedAt,updatedAt,numBooks,lastFirst);

@override
String toString() {
  return 'LibraryAuthor(id: $id, asin: $asin, name: $name, description: $description, imagePath: $imagePath, libraryId: $libraryId, addedAt: $addedAt, updatedAt: $updatedAt, numBooks: $numBooks, lastFirst: $lastFirst)';
}


}

/// @nodoc
abstract mixin class $LibraryAuthorCopyWith<$Res>  {
  factory $LibraryAuthorCopyWith(LibraryAuthor value, $Res Function(LibraryAuthor) _then) = _$LibraryAuthorCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'name') String name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'imagePath') String? imagePath,@JsonKey(name: 'libraryId') String libraryId,@JsonKey(name: 'addedAt') int addedAt,@JsonKey(name: 'updatedAt') int updatedAt,@JsonKey(name: 'numBooks') int numBooks,@JsonKey(name: 'lastFirst') String? lastFirst
});




}
/// @nodoc
class _$LibraryAuthorCopyWithImpl<$Res>
    implements $LibraryAuthorCopyWith<$Res> {
  _$LibraryAuthorCopyWithImpl(this._self, this._then);

  final LibraryAuthor _self;
  final $Res Function(LibraryAuthor) _then;

/// Create a copy of LibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? asin = freezed,Object? name = null,Object? description = freezed,Object? imagePath = freezed,Object? libraryId = null,Object? addedAt = null,Object? updatedAt = null,Object? numBooks = null,Object? lastFirst = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,numBooks: null == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int,lastFirst: freezed == lastFirst ? _self.lastFirst : lastFirst // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryAuthor].
extension LibraryAuthorPatterns on LibraryAuthor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryAuthor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryAuthor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryAuthor value)  $default,){
final _that = this;
switch (_that) {
case _LibraryAuthor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryAuthor value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryAuthor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'imagePath')  String? imagePath, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'addedAt')  int addedAt, @JsonKey(name: 'updatedAt')  int updatedAt, @JsonKey(name: 'numBooks')  int numBooks, @JsonKey(name: 'lastFirst')  String? lastFirst)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryAuthor() when $default != null:
return $default(_that.id,_that.asin,_that.name,_that.description,_that.imagePath,_that.libraryId,_that.addedAt,_that.updatedAt,_that.numBooks,_that.lastFirst);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'imagePath')  String? imagePath, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'addedAt')  int addedAt, @JsonKey(name: 'updatedAt')  int updatedAt, @JsonKey(name: 'numBooks')  int numBooks, @JsonKey(name: 'lastFirst')  String? lastFirst)  $default,) {final _that = this;
switch (_that) {
case _LibraryAuthor():
return $default(_that.id,_that.asin,_that.name,_that.description,_that.imagePath,_that.libraryId,_that.addedAt,_that.updatedAt,_that.numBooks,_that.lastFirst);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'imagePath')  String? imagePath, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'addedAt')  int addedAt, @JsonKey(name: 'updatedAt')  int updatedAt, @JsonKey(name: 'numBooks')  int numBooks, @JsonKey(name: 'lastFirst')  String? lastFirst)?  $default,) {final _that = this;
switch (_that) {
case _LibraryAuthor() when $default != null:
return $default(_that.id,_that.asin,_that.name,_that.description,_that.imagePath,_that.libraryId,_that.addedAt,_that.updatedAt,_that.numBooks,_that.lastFirst);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryAuthor implements LibraryAuthor {
  const _LibraryAuthor({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'asin') this.asin, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'description') this.description, @JsonKey(name: 'imagePath') this.imagePath, @JsonKey(name: 'libraryId') required this.libraryId, @JsonKey(name: 'addedAt') required this.addedAt, @JsonKey(name: 'updatedAt') required this.updatedAt, @JsonKey(name: 'numBooks') this.numBooks = 0, @JsonKey(name: 'lastFirst') this.lastFirst});
  factory _LibraryAuthor.fromJson(Map<String, dynamic> json) => _$LibraryAuthorFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'asin') final  String? asin;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'imagePath') final  String? imagePath;
@override@JsonKey(name: 'libraryId') final  String libraryId;
@override@JsonKey(name: 'addedAt') final  int addedAt;
@override@JsonKey(name: 'updatedAt') final  int updatedAt;
@override@JsonKey(name: 'numBooks') final  int numBooks;
@override@JsonKey(name: 'lastFirst') final  String? lastFirst;

/// Create a copy of LibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryAuthorCopyWith<_LibraryAuthor> get copyWith => __$LibraryAuthorCopyWithImpl<_LibraryAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&(identical(other.lastFirst, lastFirst) || other.lastFirst == lastFirst));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,asin,name,description,imagePath,libraryId,addedAt,updatedAt,numBooks,lastFirst);

@override
String toString() {
  return 'LibraryAuthor(id: $id, asin: $asin, name: $name, description: $description, imagePath: $imagePath, libraryId: $libraryId, addedAt: $addedAt, updatedAt: $updatedAt, numBooks: $numBooks, lastFirst: $lastFirst)';
}


}

/// @nodoc
abstract mixin class _$LibraryAuthorCopyWith<$Res> implements $LibraryAuthorCopyWith<$Res> {
  factory _$LibraryAuthorCopyWith(_LibraryAuthor value, $Res Function(_LibraryAuthor) _then) = __$LibraryAuthorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'name') String name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'imagePath') String? imagePath,@JsonKey(name: 'libraryId') String libraryId,@JsonKey(name: 'addedAt') int addedAt,@JsonKey(name: 'updatedAt') int updatedAt,@JsonKey(name: 'numBooks') int numBooks,@JsonKey(name: 'lastFirst') String? lastFirst
});




}
/// @nodoc
class __$LibraryAuthorCopyWithImpl<$Res>
    implements _$LibraryAuthorCopyWith<$Res> {
  __$LibraryAuthorCopyWithImpl(this._self, this._then);

  final _LibraryAuthor _self;
  final $Res Function(_LibraryAuthor) _then;

/// Create a copy of LibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? asin = freezed,Object? name = null,Object? description = freezed,Object? imagePath = freezed,Object? libraryId = null,Object? addedAt = null,Object? updatedAt = null,Object? numBooks = null,Object? lastFirst = freezed,}) {
  return _then(_LibraryAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,numBooks: null == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int,lastFirst: freezed == lastFirst ? _self.lastFirst : lastFirst // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
