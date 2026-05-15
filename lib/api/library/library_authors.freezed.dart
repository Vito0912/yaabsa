// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_authors.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryAuthors {

@JsonKey(name: 'results') List<LibraryAuthor> get results;@JsonKey(name: 'total') int get total;@JsonKey(name: 'limit') int? get limit;@JsonKey(name: 'page') int? get page;@JsonKey(name: 'sortBy') String? get sortBy;@JsonKey(name: 'sortDesc') bool? get sortDesc;@JsonKey(name: 'filterBy') String? get filterBy;@JsonKey(name: 'minified') bool? get minified;@JsonKey(name: 'include') String? get include;
/// Create a copy of LibraryAuthors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryAuthorsCopyWith<LibraryAuthors> get copyWith => _$LibraryAuthorsCopyWithImpl<LibraryAuthors>(this as LibraryAuthors, _$identity);

  /// Serializes this LibraryAuthors to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryAuthors&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortDesc, sortDesc) || other.sortDesc == sortDesc)&&(identical(other.filterBy, filterBy) || other.filterBy == filterBy)&&(identical(other.minified, minified) || other.minified == minified)&&(identical(other.include, include) || other.include == include));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),total,limit,page,sortBy,sortDesc,filterBy,minified,include);

@override
String toString() {
  return 'LibraryAuthors(results: $results, total: $total, limit: $limit, page: $page, sortBy: $sortBy, sortDesc: $sortDesc, filterBy: $filterBy, minified: $minified, include: $include)';
}


}

/// @nodoc
abstract mixin class $LibraryAuthorsCopyWith<$Res>  {
  factory $LibraryAuthorsCopyWith(LibraryAuthors value, $Res Function(LibraryAuthors) _then) = _$LibraryAuthorsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'results') List<LibraryAuthor> results,@JsonKey(name: 'total') int total,@JsonKey(name: 'limit') int? limit,@JsonKey(name: 'page') int? page,@JsonKey(name: 'sortBy') String? sortBy,@JsonKey(name: 'sortDesc') bool? sortDesc,@JsonKey(name: 'filterBy') String? filterBy,@JsonKey(name: 'minified') bool? minified,@JsonKey(name: 'include') String? include
});




}
/// @nodoc
class _$LibraryAuthorsCopyWithImpl<$Res>
    implements $LibraryAuthorsCopyWith<$Res> {
  _$LibraryAuthorsCopyWithImpl(this._self, this._then);

  final LibraryAuthors _self;
  final $Res Function(LibraryAuthors) _then;

/// Create a copy of LibraryAuthors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,Object? total = null,Object? limit = freezed,Object? page = freezed,Object? sortBy = freezed,Object? sortDesc = freezed,Object? filterBy = freezed,Object? minified = freezed,Object? include = freezed,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<LibraryAuthor>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortDesc: freezed == sortDesc ? _self.sortDesc : sortDesc // ignore: cast_nullable_to_non_nullable
as bool?,filterBy: freezed == filterBy ? _self.filterBy : filterBy // ignore: cast_nullable_to_non_nullable
as String?,minified: freezed == minified ? _self.minified : minified // ignore: cast_nullable_to_non_nullable
as bool?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryAuthors].
extension LibraryAuthorsPatterns on LibraryAuthors {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryAuthors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryAuthors() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryAuthors value)  $default,){
final _that = this;
switch (_that) {
case _LibraryAuthors():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryAuthors value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryAuthors() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'results')  List<LibraryAuthor> results, @JsonKey(name: 'total')  int total, @JsonKey(name: 'limit')  int? limit, @JsonKey(name: 'page')  int? page, @JsonKey(name: 'sortBy')  String? sortBy, @JsonKey(name: 'sortDesc')  bool? sortDesc, @JsonKey(name: 'filterBy')  String? filterBy, @JsonKey(name: 'minified')  bool? minified, @JsonKey(name: 'include')  String? include)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryAuthors() when $default != null:
return $default(_that.results,_that.total,_that.limit,_that.page,_that.sortBy,_that.sortDesc,_that.filterBy,_that.minified,_that.include);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'results')  List<LibraryAuthor> results, @JsonKey(name: 'total')  int total, @JsonKey(name: 'limit')  int? limit, @JsonKey(name: 'page')  int? page, @JsonKey(name: 'sortBy')  String? sortBy, @JsonKey(name: 'sortDesc')  bool? sortDesc, @JsonKey(name: 'filterBy')  String? filterBy, @JsonKey(name: 'minified')  bool? minified, @JsonKey(name: 'include')  String? include)  $default,) {final _that = this;
switch (_that) {
case _LibraryAuthors():
return $default(_that.results,_that.total,_that.limit,_that.page,_that.sortBy,_that.sortDesc,_that.filterBy,_that.minified,_that.include);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'results')  List<LibraryAuthor> results, @JsonKey(name: 'total')  int total, @JsonKey(name: 'limit')  int? limit, @JsonKey(name: 'page')  int? page, @JsonKey(name: 'sortBy')  String? sortBy, @JsonKey(name: 'sortDesc')  bool? sortDesc, @JsonKey(name: 'filterBy')  String? filterBy, @JsonKey(name: 'minified')  bool? minified, @JsonKey(name: 'include')  String? include)?  $default,) {final _that = this;
switch (_that) {
case _LibraryAuthors() when $default != null:
return $default(_that.results,_that.total,_that.limit,_that.page,_that.sortBy,_that.sortDesc,_that.filterBy,_that.minified,_that.include);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryAuthors implements LibraryAuthors {
  const _LibraryAuthors({@JsonKey(name: 'results') final  List<LibraryAuthor> results = const <LibraryAuthor>[], @JsonKey(name: 'total') this.total = 0, @JsonKey(name: 'limit') this.limit, @JsonKey(name: 'page') this.page, @JsonKey(name: 'sortBy') this.sortBy, @JsonKey(name: 'sortDesc') this.sortDesc, @JsonKey(name: 'filterBy') this.filterBy, @JsonKey(name: 'minified') this.minified, @JsonKey(name: 'include') this.include}): _results = results;
  factory _LibraryAuthors.fromJson(Map<String, dynamic> json) => _$LibraryAuthorsFromJson(json);

 final  List<LibraryAuthor> _results;
@override@JsonKey(name: 'results') List<LibraryAuthor> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey(name: 'total') final  int total;
@override@JsonKey(name: 'limit') final  int? limit;
@override@JsonKey(name: 'page') final  int? page;
@override@JsonKey(name: 'sortBy') final  String? sortBy;
@override@JsonKey(name: 'sortDesc') final  bool? sortDesc;
@override@JsonKey(name: 'filterBy') final  String? filterBy;
@override@JsonKey(name: 'minified') final  bool? minified;
@override@JsonKey(name: 'include') final  String? include;

/// Create a copy of LibraryAuthors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryAuthorsCopyWith<_LibraryAuthors> get copyWith => __$LibraryAuthorsCopyWithImpl<_LibraryAuthors>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryAuthorsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryAuthors&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortDesc, sortDesc) || other.sortDesc == sortDesc)&&(identical(other.filterBy, filterBy) || other.filterBy == filterBy)&&(identical(other.minified, minified) || other.minified == minified)&&(identical(other.include, include) || other.include == include));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),total,limit,page,sortBy,sortDesc,filterBy,minified,include);

@override
String toString() {
  return 'LibraryAuthors(results: $results, total: $total, limit: $limit, page: $page, sortBy: $sortBy, sortDesc: $sortDesc, filterBy: $filterBy, minified: $minified, include: $include)';
}


}

/// @nodoc
abstract mixin class _$LibraryAuthorsCopyWith<$Res> implements $LibraryAuthorsCopyWith<$Res> {
  factory _$LibraryAuthorsCopyWith(_LibraryAuthors value, $Res Function(_LibraryAuthors) _then) = __$LibraryAuthorsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'results') List<LibraryAuthor> results,@JsonKey(name: 'total') int total,@JsonKey(name: 'limit') int? limit,@JsonKey(name: 'page') int? page,@JsonKey(name: 'sortBy') String? sortBy,@JsonKey(name: 'sortDesc') bool? sortDesc,@JsonKey(name: 'filterBy') String? filterBy,@JsonKey(name: 'minified') bool? minified,@JsonKey(name: 'include') String? include
});




}
/// @nodoc
class __$LibraryAuthorsCopyWithImpl<$Res>
    implements _$LibraryAuthorsCopyWith<$Res> {
  __$LibraryAuthorsCopyWithImpl(this._self, this._then);

  final _LibraryAuthors _self;
  final $Res Function(_LibraryAuthors) _then;

/// Create a copy of LibraryAuthors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,Object? total = null,Object? limit = freezed,Object? page = freezed,Object? sortBy = freezed,Object? sortDesc = freezed,Object? filterBy = freezed,Object? minified = freezed,Object? include = freezed,}) {
  return _then(_LibraryAuthors(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<LibraryAuthor>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortDesc: freezed == sortDesc ? _self.sortDesc : sortDesc // ignore: cast_nullable_to_non_nullable
as bool?,filterBy: freezed == filterBy ? _self.filterBy : filterBy // ignore: cast_nullable_to_non_nullable
as String?,minified: freezed == minified ? _self.minified : minified // ignore: cast_nullable_to_non_nullable
as bool?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
