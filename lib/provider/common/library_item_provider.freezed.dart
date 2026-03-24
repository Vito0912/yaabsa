// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryItemState {

 List<LibraryItem> get items; int get currentPage; bool get hasNextPage; String? get libraryId; String? get sort; int? get desc; String? get filter; int? get collapseseries; String? get include; Object? get error; StackTrace? get stackTrace; bool get isLoadingNextPage; int get totalItems;
/// Create a copy of LibraryItemState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemStateCopyWith<LibraryItemState> get copyWith => _$LibraryItemStateCopyWithImpl<LibraryItemState>(this as LibraryItemState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemState&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.collapseseries, collapseseries) || other.collapseseries == collapseseries)&&(identical(other.include, include) || other.include == include)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.isLoadingNextPage, isLoadingNextPage) || other.isLoadingNextPage == isLoadingNextPage)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),currentPage,hasNextPage,libraryId,sort,desc,filter,collapseseries,include,const DeepCollectionEquality().hash(error),stackTrace,isLoadingNextPage,totalItems);

@override
String toString() {
  return 'LibraryItemState(items: $items, currentPage: $currentPage, hasNextPage: $hasNextPage, libraryId: $libraryId, sort: $sort, desc: $desc, filter: $filter, collapseseries: $collapseseries, include: $include, error: $error, stackTrace: $stackTrace, isLoadingNextPage: $isLoadingNextPage, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class $LibraryItemStateCopyWith<$Res>  {
  factory $LibraryItemStateCopyWith(LibraryItemState value, $Res Function(LibraryItemState) _then) = _$LibraryItemStateCopyWithImpl;
@useResult
$Res call({
 List<LibraryItem> items, int currentPage, bool hasNextPage, String? libraryId, String? sort, int? desc, String? filter, int? collapseseries, String? include, Object? error, StackTrace? stackTrace, bool isLoadingNextPage, int totalItems
});




}
/// @nodoc
class _$LibraryItemStateCopyWithImpl<$Res>
    implements $LibraryItemStateCopyWith<$Res> {
  _$LibraryItemStateCopyWithImpl(this._self, this._then);

  final LibraryItemState _self;
  final $Res Function(LibraryItemState) _then;

/// Create a copy of LibraryItemState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? currentPage = null,Object? hasNextPage = null,Object? libraryId = freezed,Object? sort = freezed,Object? desc = freezed,Object? filter = freezed,Object? collapseseries = freezed,Object? include = freezed,Object? error = freezed,Object? stackTrace = freezed,Object? isLoadingNextPage = null,Object? totalItems = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as int?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String?,collapseseries: freezed == collapseseries ? _self.collapseseries : collapseseries // ignore: cast_nullable_to_non_nullable
as int?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,isLoadingNextPage: null == isLoadingNextPage ? _self.isLoadingNextPage : isLoadingNextPage // ignore: cast_nullable_to_non_nullable
as bool,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryItemState].
extension LibraryItemStatePatterns on LibraryItemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryItemState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryItemState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryItemState value)  $default,){
final _that = this;
switch (_that) {
case _LibraryItemState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryItemState value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryItemState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LibraryItem> items,  int currentPage,  bool hasNextPage,  String? libraryId,  String? sort,  int? desc,  String? filter,  int? collapseseries,  String? include,  Object? error,  StackTrace? stackTrace,  bool isLoadingNextPage,  int totalItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryItemState() when $default != null:
return $default(_that.items,_that.currentPage,_that.hasNextPage,_that.libraryId,_that.sort,_that.desc,_that.filter,_that.collapseseries,_that.include,_that.error,_that.stackTrace,_that.isLoadingNextPage,_that.totalItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LibraryItem> items,  int currentPage,  bool hasNextPage,  String? libraryId,  String? sort,  int? desc,  String? filter,  int? collapseseries,  String? include,  Object? error,  StackTrace? stackTrace,  bool isLoadingNextPage,  int totalItems)  $default,) {final _that = this;
switch (_that) {
case _LibraryItemState():
return $default(_that.items,_that.currentPage,_that.hasNextPage,_that.libraryId,_that.sort,_that.desc,_that.filter,_that.collapseseries,_that.include,_that.error,_that.stackTrace,_that.isLoadingNextPage,_that.totalItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LibraryItem> items,  int currentPage,  bool hasNextPage,  String? libraryId,  String? sort,  int? desc,  String? filter,  int? collapseseries,  String? include,  Object? error,  StackTrace? stackTrace,  bool isLoadingNextPage,  int totalItems)?  $default,) {final _that = this;
switch (_that) {
case _LibraryItemState() when $default != null:
return $default(_that.items,_that.currentPage,_that.hasNextPage,_that.libraryId,_that.sort,_that.desc,_that.filter,_that.collapseseries,_that.include,_that.error,_that.stackTrace,_that.isLoadingNextPage,_that.totalItems);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryItemState implements LibraryItemState {
  const _LibraryItemState({final  List<LibraryItem> items = const [], required this.currentPage, required this.hasNextPage, this.libraryId, this.sort, this.desc, this.filter, this.collapseseries, this.include, this.error, this.stackTrace, this.isLoadingNextPage = false, this.totalItems = 0}): _items = items;
  

 final  List<LibraryItem> _items;
@override@JsonKey() List<LibraryItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int currentPage;
@override final  bool hasNextPage;
@override final  String? libraryId;
@override final  String? sort;
@override final  int? desc;
@override final  String? filter;
@override final  int? collapseseries;
@override final  String? include;
@override final  Object? error;
@override final  StackTrace? stackTrace;
@override@JsonKey() final  bool isLoadingNextPage;
@override@JsonKey() final  int totalItems;

/// Create a copy of LibraryItemState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemStateCopyWith<_LibraryItemState> get copyWith => __$LibraryItemStateCopyWithImpl<_LibraryItemState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemState&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.desc, desc) || other.desc == desc)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.collapseseries, collapseseries) || other.collapseseries == collapseseries)&&(identical(other.include, include) || other.include == include)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace)&&(identical(other.isLoadingNextPage, isLoadingNextPage) || other.isLoadingNextPage == isLoadingNextPage)&&(identical(other.totalItems, totalItems) || other.totalItems == totalItems));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),currentPage,hasNextPage,libraryId,sort,desc,filter,collapseseries,include,const DeepCollectionEquality().hash(error),stackTrace,isLoadingNextPage,totalItems);

@override
String toString() {
  return 'LibraryItemState(items: $items, currentPage: $currentPage, hasNextPage: $hasNextPage, libraryId: $libraryId, sort: $sort, desc: $desc, filter: $filter, collapseseries: $collapseseries, include: $include, error: $error, stackTrace: $stackTrace, isLoadingNextPage: $isLoadingNextPage, totalItems: $totalItems)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemStateCopyWith<$Res> implements $LibraryItemStateCopyWith<$Res> {
  factory _$LibraryItemStateCopyWith(_LibraryItemState value, $Res Function(_LibraryItemState) _then) = __$LibraryItemStateCopyWithImpl;
@override @useResult
$Res call({
 List<LibraryItem> items, int currentPage, bool hasNextPage, String? libraryId, String? sort, int? desc, String? filter, int? collapseseries, String? include, Object? error, StackTrace? stackTrace, bool isLoadingNextPage, int totalItems
});




}
/// @nodoc
class __$LibraryItemStateCopyWithImpl<$Res>
    implements _$LibraryItemStateCopyWith<$Res> {
  __$LibraryItemStateCopyWithImpl(this._self, this._then);

  final _LibraryItemState _self;
  final $Res Function(_LibraryItemState) _then;

/// Create a copy of LibraryItemState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? currentPage = null,Object? hasNextPage = null,Object? libraryId = freezed,Object? sort = freezed,Object? desc = freezed,Object? filter = freezed,Object? collapseseries = freezed,Object? include = freezed,Object? error = freezed,Object? stackTrace = freezed,Object? isLoadingNextPage = null,Object? totalItems = null,}) {
  return _then(_LibraryItemState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as int?,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as String?,collapseseries: freezed == collapseseries ? _self.collapseseries : collapseseries // ignore: cast_nullable_to_non_nullable
as int?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,isLoadingNextPage: null == isLoadingNextPage ? _self.isLoadingNextPage : isLoadingNextPage // ignore: cast_nullable_to_non_nullable
as bool,totalItems: null == totalItems ? _self.totalItems : totalItems // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
