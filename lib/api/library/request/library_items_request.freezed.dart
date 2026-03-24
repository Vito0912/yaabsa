// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_items_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItemsRequest {

@JsonKey(name: "limit") int get limit;@JsonKey(name: "page") int get page;@JsonKey(name: "sort") String? get sort;@JsonKey(name: "desc") int? get desc;@JsonKey(name: "filter") String? get filter;@JsonKey(name: "collapseseries") int? get collapseseries;@JsonKey(name: "include") String? get include;
/// Create a copy of LibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemsRequestCopyWith<LibraryItemsRequest> get copyWith => _$LibraryItemsRequestCopyWithImpl<LibraryItemsRequest>(this as LibraryItemsRequest, _$identity);

  /// Serializes this LibraryItemsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemsRequest&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.collapseseries, collapseseries) || other.collapseseries == collapseseries)&&(identical(other.include, include) || other.include == include));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,page,sort,desc,filter,collapseseries,include);

@override
String toString() {
  return 'LibraryItemsRequest(limit: $limit, page: $page, sort: $sort, desc: $desc, filter: $filter, collapseseries: $collapseseries, include: $include)';
}


}

/// @nodoc
abstract mixin class $LibraryItemsRequestCopyWith<$Res>  {
  factory $LibraryItemsRequestCopyWith(LibraryItemsRequest value, $Res Function(LibraryItemsRequest) _then) = _$LibraryItemsRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "limit") int limit,@JsonKey(name: "page") int page,@JsonKey(name: "sort") String? sort,@JsonKey(name: "desc") int? desc,@JsonKey(name: "filter") String? filter,@JsonKey(name: "collapseseries") int? collapseseries,@JsonKey(name: "include") String? include
});




}
/// @nodoc
class _$LibraryItemsRequestCopyWithImpl<$Res>
    implements $LibraryItemsRequestCopyWith<$Res> {
  _$LibraryItemsRequestCopyWithImpl(this._self, this._then);

  final LibraryItemsRequest _self;
  final $Res Function(LibraryItemsRequest) _then;

/// Create a copy of LibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? limit = null,Object? page = null,Object? sort = freezed,Object? desc = freezed,Object? filter = freezed,Object? collapseseries = freezed,Object? include = freezed,}) {
  return _then(_self.copyWith(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as int?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String?,collapseseries: freezed == collapseseries ? _self.collapseseries : collapseseries // ignore: cast_nullable_to_non_nullable
as int?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryItemsRequest].
extension LibraryItemsRequestPatterns on LibraryItemsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryItemsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryItemsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryItemsRequest value)  $default,){
final _that = this;
switch (_that) {
case _LibraryItemsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryItemsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryItemsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "limit")  int limit, @JsonKey(name: "page")  int page, @JsonKey(name: "sort")  String? sort, @JsonKey(name: "desc")  int? desc, @JsonKey(name: "filter")  String? filter, @JsonKey(name: "collapseseries")  int? collapseseries, @JsonKey(name: "include")  String? include)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryItemsRequest() when $default != null:
return $default(_that.limit,_that.page,_that.sort,_that.desc,_that.filter,_that.collapseseries,_that.include);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "limit")  int limit, @JsonKey(name: "page")  int page, @JsonKey(name: "sort")  String? sort, @JsonKey(name: "desc")  int? desc, @JsonKey(name: "filter")  String? filter, @JsonKey(name: "collapseseries")  int? collapseseries, @JsonKey(name: "include")  String? include)  $default,) {final _that = this;
switch (_that) {
case _LibraryItemsRequest():
return $default(_that.limit,_that.page,_that.sort,_that.desc,_that.filter,_that.collapseseries,_that.include);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "limit")  int limit, @JsonKey(name: "page")  int page, @JsonKey(name: "sort")  String? sort, @JsonKey(name: "desc")  int? desc, @JsonKey(name: "filter")  String? filter, @JsonKey(name: "collapseseries")  int? collapseseries, @JsonKey(name: "include")  String? include)?  $default,) {final _that = this;
switch (_that) {
case _LibraryItemsRequest() when $default != null:
return $default(_that.limit,_that.page,_that.sort,_that.desc,_that.filter,_that.collapseseries,_that.include);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryItemsRequest implements LibraryItemsRequest {
  const _LibraryItemsRequest({@JsonKey(name: "limit") required this.limit, @JsonKey(name: "page") required this.page, @JsonKey(name: "sort") this.sort, @JsonKey(name: "desc") this.desc, @JsonKey(name: "filter") this.filter, @JsonKey(name: "collapseseries") this.collapseseries, @JsonKey(name: "include") this.include});
  factory _LibraryItemsRequest.fromJson(Map<String, dynamic> json) => _$LibraryItemsRequestFromJson(json);

@override@JsonKey(name: "limit") final  int limit;
@override@JsonKey(name: "page") final  int page;
@override@JsonKey(name: "sort") final  String? sort;
@override@JsonKey(name: "desc") final  int? desc;
@override@JsonKey(name: "filter") final  String? filter;
@override@JsonKey(name: "collapseseries") final  int? collapseseries;
@override@JsonKey(name: "include") final  String? include;

/// Create a copy of LibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemsRequestCopyWith<_LibraryItemsRequest> get copyWith => __$LibraryItemsRequestCopyWithImpl<_LibraryItemsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemsRequest&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.page, page) || other.page == page)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.collapseseries, collapseseries) || other.collapseseries == collapseseries)&&(identical(other.include, include) || other.include == include));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,limit,page,sort,desc,filter,collapseseries,include);

@override
String toString() {
  return 'LibraryItemsRequest(limit: $limit, page: $page, sort: $sort, desc: $desc, filter: $filter, collapseseries: $collapseseries, include: $include)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemsRequestCopyWith<$Res> implements $LibraryItemsRequestCopyWith<$Res> {
  factory _$LibraryItemsRequestCopyWith(_LibraryItemsRequest value, $Res Function(_LibraryItemsRequest) _then) = __$LibraryItemsRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "limit") int limit,@JsonKey(name: "page") int page,@JsonKey(name: "sort") String? sort,@JsonKey(name: "desc") int? desc,@JsonKey(name: "filter") String? filter,@JsonKey(name: "collapseseries") int? collapseseries,@JsonKey(name: "include") String? include
});




}
/// @nodoc
class __$LibraryItemsRequestCopyWithImpl<$Res>
    implements _$LibraryItemsRequestCopyWith<$Res> {
  __$LibraryItemsRequestCopyWithImpl(this._self, this._then);

  final _LibraryItemsRequest _self;
  final $Res Function(_LibraryItemsRequest) _then;

/// Create a copy of LibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? limit = null,Object? page = null,Object? sort = freezed,Object? desc = freezed,Object? filter = freezed,Object? collapseseries = freezed,Object? include = freezed,}) {
  return _then(_LibraryItemsRequest(
limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as int?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String?,collapseseries: freezed == collapseseries ? _self.collapseseries : collapseseries // ignore: cast_nullable_to_non_nullable
as int?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
