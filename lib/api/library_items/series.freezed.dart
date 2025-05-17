// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Series {

@JsonKey(name: "id") String get id;@JsonKey(name: "name") String get name;@JsonKey(name: "sequence") String? get sequence;@JsonKey(name: "description") String? get description;@JsonKey(name: "addedAt") int? get addedAt;@JsonKey(name: "updatedAt") int? get updatedAt;@JsonKey(name: "nameIgnorePrefix") String? get nameIgnorePrefix;@JsonKey(name: "nameIgnorePrefixSort") String? get nameIgnorePrefixSort;@JsonKey(name: "libraryItemIds") List<String>? get libraryItemIds;@JsonKey(name: "numBooks") int? get numBooks;@JsonKey(name: "books") List<LibraryItem>? get books;@JsonKey(name: "totalDuration") double? get totalDuration;
/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesCopyWith<Series> get copyWith => _$SeriesCopyWithImpl<Series>(this as Series, _$identity);

  /// Serializes this Series to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Series&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.description, description) || other.description == description)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.nameIgnorePrefix, nameIgnorePrefix) || other.nameIgnorePrefix == nameIgnorePrefix)&&(identical(other.nameIgnorePrefixSort, nameIgnorePrefixSort) || other.nameIgnorePrefixSort == nameIgnorePrefixSort)&&const DeepCollectionEquality().equals(other.libraryItemIds, libraryItemIds)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&const DeepCollectionEquality().equals(other.books, books)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sequence,description,addedAt,updatedAt,nameIgnorePrefix,nameIgnorePrefixSort,const DeepCollectionEquality().hash(libraryItemIds),numBooks,const DeepCollectionEquality().hash(books),totalDuration);

@override
String toString() {
  return 'Series(id: $id, name: $name, sequence: $sequence, description: $description, addedAt: $addedAt, updatedAt: $updatedAt, nameIgnorePrefix: $nameIgnorePrefix, nameIgnorePrefixSort: $nameIgnorePrefixSort, libraryItemIds: $libraryItemIds, numBooks: $numBooks, books: $books, totalDuration: $totalDuration)';
}


}

/// @nodoc
abstract mixin class $SeriesCopyWith<$Res>  {
  factory $SeriesCopyWith(Series value, $Res Function(Series) _then) = _$SeriesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String name,@JsonKey(name: "sequence") String? sequence,@JsonKey(name: "description") String? description,@JsonKey(name: "addedAt") int? addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "nameIgnorePrefix") String? nameIgnorePrefix,@JsonKey(name: "nameIgnorePrefixSort") String? nameIgnorePrefixSort,@JsonKey(name: "libraryItemIds") List<String>? libraryItemIds,@JsonKey(name: "numBooks") int? numBooks,@JsonKey(name: "books") List<LibraryItem>? books,@JsonKey(name: "totalDuration") double? totalDuration
});




}
/// @nodoc
class _$SeriesCopyWithImpl<$Res>
    implements $SeriesCopyWith<$Res> {
  _$SeriesCopyWithImpl(this._self, this._then);

  final Series _self;
  final $Res Function(Series) _then;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? sequence = freezed,Object? description = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,Object? nameIgnorePrefix = freezed,Object? nameIgnorePrefixSort = freezed,Object? libraryItemIds = freezed,Object? numBooks = freezed,Object? books = freezed,Object? totalDuration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,nameIgnorePrefix: freezed == nameIgnorePrefix ? _self.nameIgnorePrefix : nameIgnorePrefix // ignore: cast_nullable_to_non_nullable
as String?,nameIgnorePrefixSort: freezed == nameIgnorePrefixSort ? _self.nameIgnorePrefixSort : nameIgnorePrefixSort // ignore: cast_nullable_to_non_nullable
as String?,libraryItemIds: freezed == libraryItemIds ? _self.libraryItemIds : libraryItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,numBooks: freezed == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int?,books: freezed == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Series implements Series {
  const _Series({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "sequence") this.sequence, @JsonKey(name: "description") this.description, @JsonKey(name: "addedAt") this.addedAt, @JsonKey(name: "updatedAt") this.updatedAt, @JsonKey(name: "nameIgnorePrefix") this.nameIgnorePrefix, @JsonKey(name: "nameIgnorePrefixSort") this.nameIgnorePrefixSort, @JsonKey(name: "libraryItemIds") final  List<String>? libraryItemIds, @JsonKey(name: "numBooks") this.numBooks, @JsonKey(name: "books") final  List<LibraryItem>? books, @JsonKey(name: "totalDuration") this.totalDuration}): _libraryItemIds = libraryItemIds,_books = books;
  factory _Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "sequence") final  String? sequence;
@override@JsonKey(name: "description") final  String? description;
@override@JsonKey(name: "addedAt") final  int? addedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;
@override@JsonKey(name: "nameIgnorePrefix") final  String? nameIgnorePrefix;
@override@JsonKey(name: "nameIgnorePrefixSort") final  String? nameIgnorePrefixSort;
 final  List<String>? _libraryItemIds;
@override@JsonKey(name: "libraryItemIds") List<String>? get libraryItemIds {
  final value = _libraryItemIds;
  if (value == null) return null;
  if (_libraryItemIds is EqualUnmodifiableListView) return _libraryItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "numBooks") final  int? numBooks;
 final  List<LibraryItem>? _books;
@override@JsonKey(name: "books") List<LibraryItem>? get books {
  final value = _books;
  if (value == null) return null;
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "totalDuration") final  double? totalDuration;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesCopyWith<_Series> get copyWith => __$SeriesCopyWithImpl<_Series>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Series&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.description, description) || other.description == description)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.nameIgnorePrefix, nameIgnorePrefix) || other.nameIgnorePrefix == nameIgnorePrefix)&&(identical(other.nameIgnorePrefixSort, nameIgnorePrefixSort) || other.nameIgnorePrefixSort == nameIgnorePrefixSort)&&const DeepCollectionEquality().equals(other._libraryItemIds, _libraryItemIds)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&const DeepCollectionEquality().equals(other._books, _books)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,sequence,description,addedAt,updatedAt,nameIgnorePrefix,nameIgnorePrefixSort,const DeepCollectionEquality().hash(_libraryItemIds),numBooks,const DeepCollectionEquality().hash(_books),totalDuration);

@override
String toString() {
  return 'Series(id: $id, name: $name, sequence: $sequence, description: $description, addedAt: $addedAt, updatedAt: $updatedAt, nameIgnorePrefix: $nameIgnorePrefix, nameIgnorePrefixSort: $nameIgnorePrefixSort, libraryItemIds: $libraryItemIds, numBooks: $numBooks, books: $books, totalDuration: $totalDuration)';
}


}

/// @nodoc
abstract mixin class _$SeriesCopyWith<$Res> implements $SeriesCopyWith<$Res> {
  factory _$SeriesCopyWith(_Series value, $Res Function(_Series) _then) = __$SeriesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String name,@JsonKey(name: "sequence") String? sequence,@JsonKey(name: "description") String? description,@JsonKey(name: "addedAt") int? addedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "nameIgnorePrefix") String? nameIgnorePrefix,@JsonKey(name: "nameIgnorePrefixSort") String? nameIgnorePrefixSort,@JsonKey(name: "libraryItemIds") List<String>? libraryItemIds,@JsonKey(name: "numBooks") int? numBooks,@JsonKey(name: "books") List<LibraryItem>? books,@JsonKey(name: "totalDuration") double? totalDuration
});




}
/// @nodoc
class __$SeriesCopyWithImpl<$Res>
    implements _$SeriesCopyWith<$Res> {
  __$SeriesCopyWithImpl(this._self, this._then);

  final _Series _self;
  final $Res Function(_Series) _then;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? sequence = freezed,Object? description = freezed,Object? addedAt = freezed,Object? updatedAt = freezed,Object? nameIgnorePrefix = freezed,Object? nameIgnorePrefixSort = freezed,Object? libraryItemIds = freezed,Object? numBooks = freezed,Object? books = freezed,Object? totalDuration = freezed,}) {
  return _then(_Series(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,nameIgnorePrefix: freezed == nameIgnorePrefix ? _self.nameIgnorePrefix : nameIgnorePrefix // ignore: cast_nullable_to_non_nullable
as String?,nameIgnorePrefixSort: freezed == nameIgnorePrefixSort ? _self.nameIgnorePrefixSort : nameIgnorePrefixSort // ignore: cast_nullable_to_non_nullable
as String?,libraryItemIds: freezed == libraryItemIds ? _self._libraryItemIds : libraryItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,numBooks: freezed == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int?,books: freezed == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
