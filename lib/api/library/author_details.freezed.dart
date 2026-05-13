// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'author_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthorDetails {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'asin') String? get asin;@JsonKey(name: 'name') String get name;@JsonKey(name: 'description') String? get description;@JsonKey(name: 'imagePath') String? get imagePath;@JsonKey(name: 'libraryId') String get libraryId;@JsonKey(name: 'addedAt') int get addedAt;@JsonKey(name: 'updatedAt') int get updatedAt;@JsonKey(name: 'series') List<AuthorSeriesGroup> get series;@JsonKey(name: 'libraryItems') List<LibraryItem> get libraryItems;
/// Create a copy of AuthorDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorDetailsCopyWith<AuthorDetails> get copyWith => _$AuthorDetailsCopyWithImpl<AuthorDetails>(this as AuthorDetails, _$identity);

  /// Serializes this AuthorDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.series, series)&&const DeepCollectionEquality().equals(other.libraryItems, libraryItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,asin,name,description,imagePath,libraryId,addedAt,updatedAt,const DeepCollectionEquality().hash(series),const DeepCollectionEquality().hash(libraryItems));

@override
String toString() {
  return 'AuthorDetails(id: $id, asin: $asin, name: $name, description: $description, imagePath: $imagePath, libraryId: $libraryId, addedAt: $addedAt, updatedAt: $updatedAt, series: $series, libraryItems: $libraryItems)';
}


}

/// @nodoc
abstract mixin class $AuthorDetailsCopyWith<$Res>  {
  factory $AuthorDetailsCopyWith(AuthorDetails value, $Res Function(AuthorDetails) _then) = _$AuthorDetailsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'name') String name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'imagePath') String? imagePath,@JsonKey(name: 'libraryId') String libraryId,@JsonKey(name: 'addedAt') int addedAt,@JsonKey(name: 'updatedAt') int updatedAt,@JsonKey(name: 'series') List<AuthorSeriesGroup> series,@JsonKey(name: 'libraryItems') List<LibraryItem> libraryItems
});




}
/// @nodoc
class _$AuthorDetailsCopyWithImpl<$Res>
    implements $AuthorDetailsCopyWith<$Res> {
  _$AuthorDetailsCopyWithImpl(this._self, this._then);

  final AuthorDetails _self;
  final $Res Function(AuthorDetails) _then;

/// Create a copy of AuthorDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? asin = freezed,Object? name = null,Object? description = freezed,Object? imagePath = freezed,Object? libraryId = null,Object? addedAt = null,Object? updatedAt = null,Object? series = null,Object? libraryItems = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as List<AuthorSeriesGroup>,libraryItems: null == libraryItems ? _self.libraryItems : libraryItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorDetails].
extension AuthorDetailsPatterns on AuthorDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorDetails value)  $default,){
final _that = this;
switch (_that) {
case _AuthorDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorDetails value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'imagePath')  String? imagePath, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'addedAt')  int addedAt, @JsonKey(name: 'updatedAt')  int updatedAt, @JsonKey(name: 'series')  List<AuthorSeriesGroup> series, @JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorDetails() when $default != null:
return $default(_that.id,_that.asin,_that.name,_that.description,_that.imagePath,_that.libraryId,_that.addedAt,_that.updatedAt,_that.series,_that.libraryItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'imagePath')  String? imagePath, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'addedAt')  int addedAt, @JsonKey(name: 'updatedAt')  int updatedAt, @JsonKey(name: 'series')  List<AuthorSeriesGroup> series, @JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems)  $default,) {final _that = this;
switch (_that) {
case _AuthorDetails():
return $default(_that.id,_that.asin,_that.name,_that.description,_that.imagePath,_that.libraryId,_that.addedAt,_that.updatedAt,_that.series,_that.libraryItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'name')  String name, @JsonKey(name: 'description')  String? description, @JsonKey(name: 'imagePath')  String? imagePath, @JsonKey(name: 'libraryId')  String libraryId, @JsonKey(name: 'addedAt')  int addedAt, @JsonKey(name: 'updatedAt')  int updatedAt, @JsonKey(name: 'series')  List<AuthorSeriesGroup> series, @JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems)?  $default,) {final _that = this;
switch (_that) {
case _AuthorDetails() when $default != null:
return $default(_that.id,_that.asin,_that.name,_that.description,_that.imagePath,_that.libraryId,_that.addedAt,_that.updatedAt,_that.series,_that.libraryItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorDetails implements AuthorDetails {
  const _AuthorDetails({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'asin') this.asin, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'description') this.description, @JsonKey(name: 'imagePath') this.imagePath, @JsonKey(name: 'libraryId') required this.libraryId, @JsonKey(name: 'addedAt') required this.addedAt, @JsonKey(name: 'updatedAt') required this.updatedAt, @JsonKey(name: 'series') final  List<AuthorSeriesGroup> series = const <AuthorSeriesGroup>[], @JsonKey(name: 'libraryItems') final  List<LibraryItem> libraryItems = const <LibraryItem>[]}): _series = series,_libraryItems = libraryItems;
  factory _AuthorDetails.fromJson(Map<String, dynamic> json) => _$AuthorDetailsFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'asin') final  String? asin;
@override@JsonKey(name: 'name') final  String name;
@override@JsonKey(name: 'description') final  String? description;
@override@JsonKey(name: 'imagePath') final  String? imagePath;
@override@JsonKey(name: 'libraryId') final  String libraryId;
@override@JsonKey(name: 'addedAt') final  int addedAt;
@override@JsonKey(name: 'updatedAt') final  int updatedAt;
 final  List<AuthorSeriesGroup> _series;
@override@JsonKey(name: 'series') List<AuthorSeriesGroup> get series {
  if (_series is EqualUnmodifiableListView) return _series;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_series);
}

 final  List<LibraryItem> _libraryItems;
@override@JsonKey(name: 'libraryItems') List<LibraryItem> get libraryItems {
  if (_libraryItems is EqualUnmodifiableListView) return _libraryItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_libraryItems);
}


/// Create a copy of AuthorDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorDetailsCopyWith<_AuthorDetails> get copyWith => __$AuthorDetailsCopyWithImpl<_AuthorDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._series, _series)&&const DeepCollectionEquality().equals(other._libraryItems, _libraryItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,asin,name,description,imagePath,libraryId,addedAt,updatedAt,const DeepCollectionEquality().hash(_series),const DeepCollectionEquality().hash(_libraryItems));

@override
String toString() {
  return 'AuthorDetails(id: $id, asin: $asin, name: $name, description: $description, imagePath: $imagePath, libraryId: $libraryId, addedAt: $addedAt, updatedAt: $updatedAt, series: $series, libraryItems: $libraryItems)';
}


}

/// @nodoc
abstract mixin class _$AuthorDetailsCopyWith<$Res> implements $AuthorDetailsCopyWith<$Res> {
  factory _$AuthorDetailsCopyWith(_AuthorDetails value, $Res Function(_AuthorDetails) _then) = __$AuthorDetailsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'name') String name,@JsonKey(name: 'description') String? description,@JsonKey(name: 'imagePath') String? imagePath,@JsonKey(name: 'libraryId') String libraryId,@JsonKey(name: 'addedAt') int addedAt,@JsonKey(name: 'updatedAt') int updatedAt,@JsonKey(name: 'series') List<AuthorSeriesGroup> series,@JsonKey(name: 'libraryItems') List<LibraryItem> libraryItems
});




}
/// @nodoc
class __$AuthorDetailsCopyWithImpl<$Res>
    implements _$AuthorDetailsCopyWith<$Res> {
  __$AuthorDetailsCopyWithImpl(this._self, this._then);

  final _AuthorDetails _self;
  final $Res Function(_AuthorDetails) _then;

/// Create a copy of AuthorDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? asin = freezed,Object? name = null,Object? description = freezed,Object? imagePath = freezed,Object? libraryId = null,Object? addedAt = null,Object? updatedAt = null,Object? series = null,Object? libraryItems = null,}) {
  return _then(_AuthorDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,series: null == series ? _self._series : series // ignore: cast_nullable_to_non_nullable
as List<AuthorSeriesGroup>,libraryItems: null == libraryItems ? _self._libraryItems : libraryItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}


}


/// @nodoc
mixin _$AuthorSeriesGroup {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'name') String get name;@JsonKey(name: 'items') List<LibraryItem> get items;
/// Create a copy of AuthorSeriesGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorSeriesGroupCopyWith<AuthorSeriesGroup> get copyWith => _$AuthorSeriesGroupCopyWithImpl<AuthorSeriesGroup>(this as AuthorSeriesGroup, _$identity);

  /// Serializes this AuthorSeriesGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorSeriesGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'AuthorSeriesGroup(id: $id, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class $AuthorSeriesGroupCopyWith<$Res>  {
  factory $AuthorSeriesGroupCopyWith(AuthorSeriesGroup value, $Res Function(AuthorSeriesGroup) _then) = _$AuthorSeriesGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'items') List<LibraryItem> items
});




}
/// @nodoc
class _$AuthorSeriesGroupCopyWithImpl<$Res>
    implements $AuthorSeriesGroupCopyWith<$Res> {
  _$AuthorSeriesGroupCopyWithImpl(this._self, this._then);

  final AuthorSeriesGroup _self;
  final $Res Function(AuthorSeriesGroup) _then;

/// Create a copy of AuthorSeriesGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorSeriesGroup].
extension AuthorSeriesGroupPatterns on AuthorSeriesGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorSeriesGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorSeriesGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorSeriesGroup value)  $default,){
final _that = this;
switch (_that) {
case _AuthorSeriesGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorSeriesGroup value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorSeriesGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'items')  List<LibraryItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorSeriesGroup() when $default != null:
return $default(_that.id,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'items')  List<LibraryItem> items)  $default,) {final _that = this;
switch (_that) {
case _AuthorSeriesGroup():
return $default(_that.id,_that.name,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'name')  String name, @JsonKey(name: 'items')  List<LibraryItem> items)?  $default,) {final _that = this;
switch (_that) {
case _AuthorSeriesGroup() when $default != null:
return $default(_that.id,_that.name,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorSeriesGroup implements AuthorSeriesGroup {
  const _AuthorSeriesGroup({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'name') required this.name, @JsonKey(name: 'items') final  List<LibraryItem> items = const <LibraryItem>[]}): _items = items;
  factory _AuthorSeriesGroup.fromJson(Map<String, dynamic> json) => _$AuthorSeriesGroupFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'name') final  String name;
 final  List<LibraryItem> _items;
@override@JsonKey(name: 'items') List<LibraryItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of AuthorSeriesGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorSeriesGroupCopyWith<_AuthorSeriesGroup> get copyWith => __$AuthorSeriesGroupCopyWithImpl<_AuthorSeriesGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorSeriesGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorSeriesGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'AuthorSeriesGroup(id: $id, name: $name, items: $items)';
}


}

/// @nodoc
abstract mixin class _$AuthorSeriesGroupCopyWith<$Res> implements $AuthorSeriesGroupCopyWith<$Res> {
  factory _$AuthorSeriesGroupCopyWith(_AuthorSeriesGroup value, $Res Function(_AuthorSeriesGroup) _then) = __$AuthorSeriesGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'name') String name,@JsonKey(name: 'items') List<LibraryItem> items
});




}
/// @nodoc
class __$AuthorSeriesGroupCopyWithImpl<$Res>
    implements _$AuthorSeriesGroupCopyWith<$Res> {
  __$AuthorSeriesGroupCopyWithImpl(this._self, this._then);

  final _AuthorSeriesGroup _self;
  final $Res Function(_AuthorSeriesGroup) _then;

/// Create a copy of AuthorSeriesGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? items = null,}) {
  return _then(_AuthorSeriesGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}


}

// dart format on
