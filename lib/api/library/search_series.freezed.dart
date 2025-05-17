// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchSeries {

@JsonKey(name: "series") Series get series;@JsonKey(name: "books") List<LibraryItem> get books;
/// Create a copy of SearchSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSeriesCopyWith<SearchSeries> get copyWith => _$SearchSeriesCopyWithImpl<SearchSeries>(this as SearchSeries, _$identity);

  /// Serializes this SearchSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSeries&&(identical(other.series, series) || other.series == series)&&const DeepCollectionEquality().equals(other.books, books));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,series,const DeepCollectionEquality().hash(books));

@override
String toString() {
  return 'SearchSeries(series: $series, books: $books)';
}


}

/// @nodoc
abstract mixin class $SearchSeriesCopyWith<$Res>  {
  factory $SearchSeriesCopyWith(SearchSeries value, $Res Function(SearchSeries) _then) = _$SearchSeriesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "series") Series series,@JsonKey(name: "books") List<LibraryItem> books
});


$SeriesCopyWith<$Res> get series;

}
/// @nodoc
class _$SearchSeriesCopyWithImpl<$Res>
    implements $SearchSeriesCopyWith<$Res> {
  _$SearchSeriesCopyWithImpl(this._self, this._then);

  final SearchSeries _self;
  final $Res Function(SearchSeries) _then;

/// Create a copy of SearchSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? series = null,Object? books = null,}) {
  return _then(_self.copyWith(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as Series,books: null == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}
/// Create a copy of SearchSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeriesCopyWith<$Res> get series {
  
  return $SeriesCopyWith<$Res>(_self.series, (value) {
    return _then(_self.copyWith(series: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SearchSeries implements SearchSeries {
  const _SearchSeries({@JsonKey(name: "series") required this.series, @JsonKey(name: "books") required final  List<LibraryItem> books}): _books = books;
  factory _SearchSeries.fromJson(Map<String, dynamic> json) => _$SearchSeriesFromJson(json);

@override@JsonKey(name: "series") final  Series series;
 final  List<LibraryItem> _books;
@override@JsonKey(name: "books") List<LibraryItem> get books {
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_books);
}


/// Create a copy of SearchSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchSeriesCopyWith<_SearchSeries> get copyWith => __$SearchSeriesCopyWithImpl<_SearchSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchSeries&&(identical(other.series, series) || other.series == series)&&const DeepCollectionEquality().equals(other._books, _books));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,series,const DeepCollectionEquality().hash(_books));

@override
String toString() {
  return 'SearchSeries(series: $series, books: $books)';
}


}

/// @nodoc
abstract mixin class _$SearchSeriesCopyWith<$Res> implements $SearchSeriesCopyWith<$Res> {
  factory _$SearchSeriesCopyWith(_SearchSeries value, $Res Function(_SearchSeries) _then) = __$SearchSeriesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "series") Series series,@JsonKey(name: "books") List<LibraryItem> books
});


@override $SeriesCopyWith<$Res> get series;

}
/// @nodoc
class __$SearchSeriesCopyWithImpl<$Res>
    implements _$SearchSeriesCopyWith<$Res> {
  __$SearchSeriesCopyWithImpl(this._self, this._then);

  final _SearchSeries _self;
  final $Res Function(_SearchSeries) _then;

/// Create a copy of SearchSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? series = null,Object? books = null,}) {
  return _then(_SearchSeries(
series: null == series ? _self.series : series // ignore: cast_nullable_to_non_nullable
as Series,books: null == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}

/// Create a copy of SearchSeries
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeriesCopyWith<$Res> get series {
  
  return $SeriesCopyWith<$Res>(_self.series, (value) {
    return _then(_self.copyWith(series: value));
  });
}
}

// dart format on
