// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItems {

@JsonKey(name: "results") List<LibraryItem> get results;@JsonKey(name: "total") int? get total;@JsonKey(name: "limit") int? get limit;@JsonKey(name: "page") int? get page;@JsonKey(name: "sortBy") String? get sortBy;@JsonKey(name: "sortDesc") bool? get sortDesc;@JsonKey(name: "filterBy") String? get filterBy;@JsonKey(name: "mediaType") MediaType? get mediaType;@JsonKey(name: "minified") bool? get minified;@JsonKey(name: "collapseseries") bool? get collapseseries;@JsonKey(name: "include") String? get include;@JsonKey(name: "offset") int? get offset;
/// Create a copy of LibraryItems
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemsCopyWith<LibraryItems> get copyWith => _$LibraryItemsCopyWithImpl<LibraryItems>(this as LibraryItems, _$identity);

  /// Serializes this LibraryItems to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItems&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortDesc, sortDesc) || other.sortDesc == sortDesc)&&(identical(other.filterBy, filterBy) || other.filterBy == filterBy)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.minified, minified) || other.minified == minified)&&(identical(other.collapseseries, collapseseries) || other.collapseseries == collapseseries)&&(identical(other.include, include) || other.include == include)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),total,limit,page,sortBy,sortDesc,filterBy,mediaType,minified,collapseseries,include,offset);

@override
String toString() {
  return 'LibraryItems(results: $results, total: $total, limit: $limit, page: $page, sortBy: $sortBy, sortDesc: $sortDesc, filterBy: $filterBy, mediaType: $mediaType, minified: $minified, collapseseries: $collapseseries, include: $include, offset: $offset)';
}


}

/// @nodoc
abstract mixin class $LibraryItemsCopyWith<$Res>  {
  factory $LibraryItemsCopyWith(LibraryItems value, $Res Function(LibraryItems) _then) = _$LibraryItemsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "results") List<LibraryItem> results,@JsonKey(name: "total") int? total,@JsonKey(name: "limit") int? limit,@JsonKey(name: "page") int? page,@JsonKey(name: "sortBy") String? sortBy,@JsonKey(name: "sortDesc") bool? sortDesc,@JsonKey(name: "filterBy") String? filterBy,@JsonKey(name: "mediaType") MediaType? mediaType,@JsonKey(name: "minified") bool? minified,@JsonKey(name: "collapseseries") bool? collapseseries,@JsonKey(name: "include") String? include,@JsonKey(name: "offset") int? offset
});




}
/// @nodoc
class _$LibraryItemsCopyWithImpl<$Res>
    implements $LibraryItemsCopyWith<$Res> {
  _$LibraryItemsCopyWithImpl(this._self, this._then);

  final LibraryItems _self;
  final $Res Function(LibraryItems) _then;

/// Create a copy of LibraryItems
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,Object? total = freezed,Object? limit = freezed,Object? page = freezed,Object? sortBy = freezed,Object? sortDesc = freezed,Object? filterBy = freezed,Object? mediaType = freezed,Object? minified = freezed,Object? collapseseries = freezed,Object? include = freezed,Object? offset = freezed,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortDesc: freezed == sortDesc ? _self.sortDesc : sortDesc // ignore: cast_nullable_to_non_nullable
as bool?,filterBy: freezed == filterBy ? _self.filterBy : filterBy // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType?,minified: freezed == minified ? _self.minified : minified // ignore: cast_nullable_to_non_nullable
as bool?,collapseseries: freezed == collapseseries ? _self.collapseseries : collapseseries // ignore: cast_nullable_to_non_nullable
as bool?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryItems implements LibraryItems {
  const _LibraryItems({@JsonKey(name: "results") required final  List<LibraryItem> results, @JsonKey(name: "total") this.total, @JsonKey(name: "limit") this.limit, @JsonKey(name: "page") this.page, @JsonKey(name: "sortBy") this.sortBy, @JsonKey(name: "sortDesc") this.sortDesc, @JsonKey(name: "filterBy") this.filterBy, @JsonKey(name: "mediaType") this.mediaType, @JsonKey(name: "minified") this.minified, @JsonKey(name: "collapseseries") this.collapseseries, @JsonKey(name: "include") this.include, @JsonKey(name: "offset") this.offset}): _results = results;
  factory _LibraryItems.fromJson(Map<String, dynamic> json) => _$LibraryItemsFromJson(json);

 final  List<LibraryItem> _results;
@override@JsonKey(name: "results") List<LibraryItem> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey(name: "total") final  int? total;
@override@JsonKey(name: "limit") final  int? limit;
@override@JsonKey(name: "page") final  int? page;
@override@JsonKey(name: "sortBy") final  String? sortBy;
@override@JsonKey(name: "sortDesc") final  bool? sortDesc;
@override@JsonKey(name: "filterBy") final  String? filterBy;
@override@JsonKey(name: "mediaType") final  MediaType? mediaType;
@override@JsonKey(name: "minified") final  bool? minified;
@override@JsonKey(name: "collapseseries") final  bool? collapseseries;
@override@JsonKey(name: "include") final  String? include;
@override@JsonKey(name: "offset") final  int? offset;

/// Create a copy of LibraryItems
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemsCopyWith<_LibraryItems> get copyWith => __$LibraryItemsCopyWithImpl<_LibraryItems>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItems&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.total, total) || other.total == total)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortDesc, sortDesc) || other.sortDesc == sortDesc)&&(identical(other.filterBy, filterBy) || other.filterBy == filterBy)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.minified, minified) || other.minified == minified)&&(identical(other.collapseseries, collapseseries) || other.collapseseries == collapseseries)&&(identical(other.include, include) || other.include == include)&&(identical(other.offset, offset) || other.offset == offset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),total,limit,page,sortBy,sortDesc,filterBy,mediaType,minified,collapseseries,include,offset);

@override
String toString() {
  return 'LibraryItems(results: $results, total: $total, limit: $limit, page: $page, sortBy: $sortBy, sortDesc: $sortDesc, filterBy: $filterBy, mediaType: $mediaType, minified: $minified, collapseseries: $collapseseries, include: $include, offset: $offset)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemsCopyWith<$Res> implements $LibraryItemsCopyWith<$Res> {
  factory _$LibraryItemsCopyWith(_LibraryItems value, $Res Function(_LibraryItems) _then) = __$LibraryItemsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "results") List<LibraryItem> results,@JsonKey(name: "total") int? total,@JsonKey(name: "limit") int? limit,@JsonKey(name: "page") int? page,@JsonKey(name: "sortBy") String? sortBy,@JsonKey(name: "sortDesc") bool? sortDesc,@JsonKey(name: "filterBy") String? filterBy,@JsonKey(name: "mediaType") MediaType? mediaType,@JsonKey(name: "minified") bool? minified,@JsonKey(name: "collapseseries") bool? collapseseries,@JsonKey(name: "include") String? include,@JsonKey(name: "offset") int? offset
});




}
/// @nodoc
class __$LibraryItemsCopyWithImpl<$Res>
    implements _$LibraryItemsCopyWith<$Res> {
  __$LibraryItemsCopyWithImpl(this._self, this._then);

  final _LibraryItems _self;
  final $Res Function(_LibraryItems) _then;

/// Create a copy of LibraryItems
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,Object? total = freezed,Object? limit = freezed,Object? page = freezed,Object? sortBy = freezed,Object? sortDesc = freezed,Object? filterBy = freezed,Object? mediaType = freezed,Object? minified = freezed,Object? collapseseries = freezed,Object? include = freezed,Object? offset = freezed,}) {
  return _then(_LibraryItems(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortDesc: freezed == sortDesc ? _self.sortDesc : sortDesc // ignore: cast_nullable_to_non_nullable
as bool?,filterBy: freezed == filterBy ? _self.filterBy : filterBy // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType?,minified: freezed == minified ? _self.minified : minified // ignore: cast_nullable_to_non_nullable
as bool?,collapseseries: freezed == collapseseries ? _self.collapseseries : collapseseries // ignore: cast_nullable_to_non_nullable
as bool?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
