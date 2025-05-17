// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Collection {

@JsonKey(name: "id") String get id;@JsonKey(name: "libraryId") String get libraryId;@JsonKey(name: "userId") String? get userId;@JsonKey(name: "name") String get name;@JsonKey(name: "description") String? get description;@JsonKey(name: "coverPath") String? get coverPath;@JsonKey(name: "books") List<LibraryItem>? get items;@JsonKey(name: "lastUpdate") int get lastUpdate;@JsonKey(name: "createdAt") int get createdAt;
/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollectionCopyWith<Collection> get copyWith => _$CollectionCopyWithImpl<Collection>(this as Collection, _$identity);

  /// Serializes this Collection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Collection&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryId,userId,name,description,coverPath,const DeepCollectionEquality().hash(items),lastUpdate,createdAt);

@override
String toString() {
  return 'Collection(id: $id, libraryId: $libraryId, userId: $userId, name: $name, description: $description, coverPath: $coverPath, items: $items, lastUpdate: $lastUpdate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CollectionCopyWith<$Res>  {
  factory $CollectionCopyWith(Collection value, $Res Function(Collection) _then) = _$CollectionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "userId") String? userId,@JsonKey(name: "name") String name,@JsonKey(name: "description") String? description,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "books") List<LibraryItem>? items,@JsonKey(name: "lastUpdate") int lastUpdate,@JsonKey(name: "createdAt") int createdAt
});




}
/// @nodoc
class _$CollectionCopyWithImpl<$Res>
    implements $CollectionCopyWith<$Res> {
  _$CollectionCopyWithImpl(this._self, this._then);

  final Collection _self;
  final $Res Function(Collection) _then;

/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? libraryId = null,Object? userId = freezed,Object? name = null,Object? description = freezed,Object? coverPath = freezed,Object? items = freezed,Object? lastUpdate = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>?,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Collection implements Collection {
  const _Collection({@JsonKey(name: "id") required this.id, @JsonKey(name: "libraryId") required this.libraryId, @JsonKey(name: "userId") this.userId, @JsonKey(name: "name") required this.name, @JsonKey(name: "description") this.description, @JsonKey(name: "coverPath") this.coverPath, @JsonKey(name: "books") final  List<LibraryItem>? items, @JsonKey(name: "lastUpdate") required this.lastUpdate, @JsonKey(name: "createdAt") required this.createdAt}): _items = items;
  factory _Collection.fromJson(Map<String, dynamic> json) => _$CollectionFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "libraryId") final  String libraryId;
@override@JsonKey(name: "userId") final  String? userId;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "coverPath") final  String? coverPath;
 final  List<LibraryItem>? _items;
@override@JsonKey(name: "books") List<LibraryItem>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "lastUpdate") final  int lastUpdate;
@override@JsonKey(name: "createdAt") final  int createdAt;

/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollectionCopyWith<_Collection> get copyWith => __$CollectionCopyWithImpl<_Collection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Collection&&(identical(other.id, id) || other.id == id)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,libraryId,userId,name,description,coverPath,const DeepCollectionEquality().hash(_items),lastUpdate,createdAt);

@override
String toString() {
  return 'Collection(id: $id, libraryId: $libraryId, userId: $userId, name: $name, description: $description, coverPath: $coverPath, items: $items, lastUpdate: $lastUpdate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CollectionCopyWith<$Res> implements $CollectionCopyWith<$Res> {
  factory _$CollectionCopyWith(_Collection value, $Res Function(_Collection) _then) = __$CollectionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "userId") String? userId,@JsonKey(name: "name") String name,@JsonKey(name: "description") String? description,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "books") List<LibraryItem>? items,@JsonKey(name: "lastUpdate") int lastUpdate,@JsonKey(name: "createdAt") int createdAt
});




}
/// @nodoc
class __$CollectionCopyWithImpl<$Res>
    implements _$CollectionCopyWith<$Res> {
  __$CollectionCopyWithImpl(this._self, this._then);

  final _Collection _self;
  final $Res Function(_Collection) _then;

/// Create a copy of Collection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? libraryId = null,Object? userId = freezed,Object? name = null,Object? description = freezed,Object? coverPath = freezed,Object? items = freezed,Object? lastUpdate = null,Object? createdAt = null,}) {
  return _then(_Collection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>?,lastUpdate: null == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
