// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_library_author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchLibraryAuthor {

@JsonKey(name: "id") String get id;@JsonKey(name: "asin") String? get asin;@JsonKey(name: "name") String get name;@JsonKey(name: "description") String? get description;@JsonKey(name: "imagePath") String? get imagePath;@JsonKey(name: "libraryId") String get libraryId;@JsonKey(name: "addedAt") int get addedAt;@JsonKey(name: "updatedAt") int get updatedAt;@JsonKey(name: "numBooks") int get numBooks;
/// Create a copy of SearchLibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLibraryAuthorCopyWith<SearchLibraryAuthor> get copyWith => _$SearchLibraryAuthorCopyWithImpl<SearchLibraryAuthor>(this as SearchLibraryAuthor, _$identity);

  /// Serializes this SearchLibraryAuthor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLibraryAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,asin,name,description,imagePath,libraryId,addedAt,updatedAt,numBooks);

@override
String toString() {
  return 'SearchLibraryAuthor(id: $id, asin: $asin, name: $name, description: $description, imagePath: $imagePath, libraryId: $libraryId, addedAt: $addedAt, updatedAt: $updatedAt, numBooks: $numBooks)';
}


}

/// @nodoc
abstract mixin class $SearchLibraryAuthorCopyWith<$Res>  {
  factory $SearchLibraryAuthorCopyWith(SearchLibraryAuthor value, $Res Function(SearchLibraryAuthor) _then) = _$SearchLibraryAuthorCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "asin") String? asin,@JsonKey(name: "name") String name,@JsonKey(name: "description") String? description,@JsonKey(name: "imagePath") String? imagePath,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int updatedAt,@JsonKey(name: "numBooks") int numBooks
});




}
/// @nodoc
class _$SearchLibraryAuthorCopyWithImpl<$Res>
    implements $SearchLibraryAuthorCopyWith<$Res> {
  _$SearchLibraryAuthorCopyWithImpl(this._self, this._then);

  final SearchLibraryAuthor _self;
  final $Res Function(SearchLibraryAuthor) _then;

/// Create a copy of SearchLibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? asin = freezed,Object? name = null,Object? description = freezed,Object? imagePath = freezed,Object? libraryId = null,Object? addedAt = null,Object? updatedAt = null,Object? numBooks = null,}) {
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
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SearchLibraryAuthor implements SearchLibraryAuthor {
  const _SearchLibraryAuthor({@JsonKey(name: "id") required this.id, @JsonKey(name: "asin") required this.asin, @JsonKey(name: "name") required this.name, @JsonKey(name: "description") required this.description, @JsonKey(name: "imagePath") required this.imagePath, @JsonKey(name: "libraryId") required this.libraryId, @JsonKey(name: "addedAt") required this.addedAt, @JsonKey(name: "updatedAt") required this.updatedAt, @JsonKey(name: "numBooks") required this.numBooks});
  factory _SearchLibraryAuthor.fromJson(Map<String, dynamic> json) => _$SearchLibraryAuthorFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "asin") final  String? asin;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "imagePath") final  String? imagePath;
@override@JsonKey(name: "libraryId") final  String libraryId;
@override@JsonKey(name: "addedAt") final  int addedAt;
@override@JsonKey(name: "updatedAt") final  int updatedAt;
@override@JsonKey(name: "numBooks") final  int numBooks;

/// Create a copy of SearchLibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchLibraryAuthorCopyWith<_SearchLibraryAuthor> get copyWith => __$SearchLibraryAuthorCopyWithImpl<_SearchLibraryAuthor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchLibraryAuthorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchLibraryAuthor&&(identical(other.id, id) || other.id == id)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,asin,name,description,imagePath,libraryId,addedAt,updatedAt,numBooks);

@override
String toString() {
  return 'SearchLibraryAuthor(id: $id, asin: $asin, name: $name, description: $description, imagePath: $imagePath, libraryId: $libraryId, addedAt: $addedAt, updatedAt: $updatedAt, numBooks: $numBooks)';
}


}

/// @nodoc
abstract mixin class _$SearchLibraryAuthorCopyWith<$Res> implements $SearchLibraryAuthorCopyWith<$Res> {
  factory _$SearchLibraryAuthorCopyWith(_SearchLibraryAuthor value, $Res Function(_SearchLibraryAuthor) _then) = __$SearchLibraryAuthorCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "asin") String? asin,@JsonKey(name: "name") String name,@JsonKey(name: "description") String? description,@JsonKey(name: "imagePath") String? imagePath,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "addedAt") int addedAt,@JsonKey(name: "updatedAt") int updatedAt,@JsonKey(name: "numBooks") int numBooks
});




}
/// @nodoc
class __$SearchLibraryAuthorCopyWithImpl<$Res>
    implements _$SearchLibraryAuthorCopyWith<$Res> {
  __$SearchLibraryAuthorCopyWithImpl(this._self, this._then);

  final _SearchLibraryAuthor _self;
  final $Res Function(_SearchLibraryAuthor) _then;

/// Create a copy of SearchLibraryAuthor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? asin = freezed,Object? name = null,Object? description = freezed,Object? imagePath = freezed,Object? libraryId = null,Object? addedAt = null,Object? updatedAt = null,Object? numBooks = null,}) {
  return _then(_SearchLibraryAuthor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int,numBooks: null == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
