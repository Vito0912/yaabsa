// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SeriesItems {

@JsonKey(name: "results") List<Series> get results;@JsonKey(name: "total") int get total;@JsonKey(name: "page") int get page;@JsonKey(name: "limit") int? get limit;@JsonKey(name: "sortBy") String? get sortBy;@JsonKey(name: "sortDesc") bool? get sortDesc;@JsonKey(name: "filterBy") String? get filterBy;
/// Create a copy of SeriesItems
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesItemsCopyWith<SeriesItems> get copyWith => _$SeriesItemsCopyWithImpl<SeriesItems>(this as SeriesItems, _$identity);

  /// Serializes this SeriesItems to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeriesItems&&const DeepCollectionEquality().equals(other.results, results)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortDesc, sortDesc) || other.sortDesc == sortDesc)&&(identical(other.filterBy, filterBy) || other.filterBy == filterBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(results),total,page,limit,sortBy,sortDesc,filterBy);

@override
String toString() {
  return 'SeriesItems(results: $results, total: $total, page: $page, limit: $limit, sortBy: $sortBy, sortDesc: $sortDesc, filterBy: $filterBy)';
}


}

/// @nodoc
abstract mixin class $SeriesItemsCopyWith<$Res>  {
  factory $SeriesItemsCopyWith(SeriesItems value, $Res Function(SeriesItems) _then) = _$SeriesItemsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "results") List<Series> results,@JsonKey(name: "total") int total,@JsonKey(name: "page") int page,@JsonKey(name: "limit") int? limit,@JsonKey(name: "sortBy") String? sortBy,@JsonKey(name: "sortDesc") bool? sortDesc,@JsonKey(name: "filterBy") String? filterBy
});




}
/// @nodoc
class _$SeriesItemsCopyWithImpl<$Res>
    implements $SeriesItemsCopyWith<$Res> {
  _$SeriesItemsCopyWithImpl(this._self, this._then);

  final SeriesItems _self;
  final $Res Function(SeriesItems) _then;

/// Create a copy of SeriesItems
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? results = null,Object? total = null,Object? page = null,Object? limit = freezed,Object? sortBy = freezed,Object? sortDesc = freezed,Object? filterBy = freezed,}) {
  return _then(_self.copyWith(
results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<Series>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortDesc: freezed == sortDesc ? _self.sortDesc : sortDesc // ignore: cast_nullable_to_non_nullable
as bool?,filterBy: freezed == filterBy ? _self.filterBy : filterBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _SeriesItems implements SeriesItems {
  const _SeriesItems({@JsonKey(name: "results") required final  List<Series> results, @JsonKey(name: "total") required this.total, @JsonKey(name: "page") required this.page, @JsonKey(name: "limit") this.limit, @JsonKey(name: "sortBy") this.sortBy, @JsonKey(name: "sortDesc") this.sortDesc, @JsonKey(name: "filterBy") this.filterBy}): _results = results;
  factory _SeriesItems.fromJson(Map<String, dynamic> json) => _$SeriesItemsFromJson(json);

 final  List<Series> _results;
@override@JsonKey(name: "results") List<Series> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

@override@JsonKey(name: "total") final  int total;
@override@JsonKey(name: "page") final  int page;
@override@JsonKey(name: "limit") final  int? limit;
@override@JsonKey(name: "sortBy") final  String? sortBy;
@override@JsonKey(name: "sortDesc") final  bool? sortDesc;
@override@JsonKey(name: "filterBy") final  String? filterBy;

/// Create a copy of SeriesItems
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesItemsCopyWith<_SeriesItems> get copyWith => __$SeriesItemsCopyWithImpl<_SeriesItems>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeriesItemsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeriesItems&&const DeepCollectionEquality().equals(other._results, _results)&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortDesc, sortDesc) || other.sortDesc == sortDesc)&&(identical(other.filterBy, filterBy) || other.filterBy == filterBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_results),total,page,limit,sortBy,sortDesc,filterBy);

@override
String toString() {
  return 'SeriesItems(results: $results, total: $total, page: $page, limit: $limit, sortBy: $sortBy, sortDesc: $sortDesc, filterBy: $filterBy)';
}


}

/// @nodoc
abstract mixin class _$SeriesItemsCopyWith<$Res> implements $SeriesItemsCopyWith<$Res> {
  factory _$SeriesItemsCopyWith(_SeriesItems value, $Res Function(_SeriesItems) _then) = __$SeriesItemsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "results") List<Series> results,@JsonKey(name: "total") int total,@JsonKey(name: "page") int page,@JsonKey(name: "limit") int? limit,@JsonKey(name: "sortBy") String? sortBy,@JsonKey(name: "sortDesc") bool? sortDesc,@JsonKey(name: "filterBy") String? filterBy
});




}
/// @nodoc
class __$SeriesItemsCopyWithImpl<$Res>
    implements _$SeriesItemsCopyWith<$Res> {
  __$SeriesItemsCopyWithImpl(this._self, this._then);

  final _SeriesItems _self;
  final $Res Function(_SeriesItems) _then;

/// Create a copy of SeriesItems
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? results = null,Object? total = null,Object? page = null,Object? limit = freezed,Object? sortBy = freezed,Object? sortDesc = freezed,Object? filterBy = freezed,}) {
  return _then(_SeriesItems(
results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<Series>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: freezed == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortDesc: freezed == sortDesc ? _self.sortDesc : sortDesc // ignore: cast_nullable_to_non_nullable
as bool?,filterBy: freezed == filterBy ? _self.filterBy : filterBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
