// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_providers.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchProviders {

@JsonKey(name: 'books') List<SearchProviderOption> get books;@JsonKey(name: 'booksCovers') List<SearchProviderOption> get booksCovers;@JsonKey(name: 'podcasts') List<SearchProviderOption> get podcasts;
/// Create a copy of SearchProviders
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchProvidersCopyWith<SearchProviders> get copyWith => _$SearchProvidersCopyWithImpl<SearchProviders>(this as SearchProviders, _$identity);

  /// Serializes this SearchProviders to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchProviders&&const DeepCollectionEquality().equals(other.books, books)&&const DeepCollectionEquality().equals(other.booksCovers, booksCovers)&&const DeepCollectionEquality().equals(other.podcasts, podcasts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(books),const DeepCollectionEquality().hash(booksCovers),const DeepCollectionEquality().hash(podcasts));

@override
String toString() {
  return 'SearchProviders(books: $books, booksCovers: $booksCovers, podcasts: $podcasts)';
}


}

/// @nodoc
abstract mixin class $SearchProvidersCopyWith<$Res>  {
  factory $SearchProvidersCopyWith(SearchProviders value, $Res Function(SearchProviders) _then) = _$SearchProvidersCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'books') List<SearchProviderOption> books,@JsonKey(name: 'booksCovers') List<SearchProviderOption> booksCovers,@JsonKey(name: 'podcasts') List<SearchProviderOption> podcasts
});




}
/// @nodoc
class _$SearchProvidersCopyWithImpl<$Res>
    implements $SearchProvidersCopyWith<$Res> {
  _$SearchProvidersCopyWithImpl(this._self, this._then);

  final SearchProviders _self;
  final $Res Function(SearchProviders) _then;

/// Create a copy of SearchProviders
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? books = null,Object? booksCovers = null,Object? podcasts = null,}) {
  return _then(_self.copyWith(
books: null == books ? _self.books : books // ignore: cast_nullable_to_non_nullable
as List<SearchProviderOption>,booksCovers: null == booksCovers ? _self.booksCovers : booksCovers // ignore: cast_nullable_to_non_nullable
as List<SearchProviderOption>,podcasts: null == podcasts ? _self.podcasts : podcasts // ignore: cast_nullable_to_non_nullable
as List<SearchProviderOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchProviders].
extension SearchProvidersPatterns on SearchProviders {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchProviders value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchProviders() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchProviders value)  $default,){
final _that = this;
switch (_that) {
case _SearchProviders():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchProviders value)?  $default,){
final _that = this;
switch (_that) {
case _SearchProviders() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'books')  List<SearchProviderOption> books, @JsonKey(name: 'booksCovers')  List<SearchProviderOption> booksCovers, @JsonKey(name: 'podcasts')  List<SearchProviderOption> podcasts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchProviders() when $default != null:
return $default(_that.books,_that.booksCovers,_that.podcasts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'books')  List<SearchProviderOption> books, @JsonKey(name: 'booksCovers')  List<SearchProviderOption> booksCovers, @JsonKey(name: 'podcasts')  List<SearchProviderOption> podcasts)  $default,) {final _that = this;
switch (_that) {
case _SearchProviders():
return $default(_that.books,_that.booksCovers,_that.podcasts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'books')  List<SearchProviderOption> books, @JsonKey(name: 'booksCovers')  List<SearchProviderOption> booksCovers, @JsonKey(name: 'podcasts')  List<SearchProviderOption> podcasts)?  $default,) {final _that = this;
switch (_that) {
case _SearchProviders() when $default != null:
return $default(_that.books,_that.booksCovers,_that.podcasts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchProviders implements SearchProviders {
  const _SearchProviders({@JsonKey(name: 'books') final  List<SearchProviderOption> books = const <SearchProviderOption>[], @JsonKey(name: 'booksCovers') final  List<SearchProviderOption> booksCovers = const <SearchProviderOption>[], @JsonKey(name: 'podcasts') final  List<SearchProviderOption> podcasts = const <SearchProviderOption>[]}): _books = books,_booksCovers = booksCovers,_podcasts = podcasts;
  factory _SearchProviders.fromJson(Map<String, dynamic> json) => _$SearchProvidersFromJson(json);

 final  List<SearchProviderOption> _books;
@override@JsonKey(name: 'books') List<SearchProviderOption> get books {
  if (_books is EqualUnmodifiableListView) return _books;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_books);
}

 final  List<SearchProviderOption> _booksCovers;
@override@JsonKey(name: 'booksCovers') List<SearchProviderOption> get booksCovers {
  if (_booksCovers is EqualUnmodifiableListView) return _booksCovers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_booksCovers);
}

 final  List<SearchProviderOption> _podcasts;
@override@JsonKey(name: 'podcasts') List<SearchProviderOption> get podcasts {
  if (_podcasts is EqualUnmodifiableListView) return _podcasts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_podcasts);
}


/// Create a copy of SearchProviders
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchProvidersCopyWith<_SearchProviders> get copyWith => __$SearchProvidersCopyWithImpl<_SearchProviders>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchProvidersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchProviders&&const DeepCollectionEquality().equals(other._books, _books)&&const DeepCollectionEquality().equals(other._booksCovers, _booksCovers)&&const DeepCollectionEquality().equals(other._podcasts, _podcasts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_books),const DeepCollectionEquality().hash(_booksCovers),const DeepCollectionEquality().hash(_podcasts));

@override
String toString() {
  return 'SearchProviders(books: $books, booksCovers: $booksCovers, podcasts: $podcasts)';
}


}

/// @nodoc
abstract mixin class _$SearchProvidersCopyWith<$Res> implements $SearchProvidersCopyWith<$Res> {
  factory _$SearchProvidersCopyWith(_SearchProviders value, $Res Function(_SearchProviders) _then) = __$SearchProvidersCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'books') List<SearchProviderOption> books,@JsonKey(name: 'booksCovers') List<SearchProviderOption> booksCovers,@JsonKey(name: 'podcasts') List<SearchProviderOption> podcasts
});




}
/// @nodoc
class __$SearchProvidersCopyWithImpl<$Res>
    implements _$SearchProvidersCopyWith<$Res> {
  __$SearchProvidersCopyWithImpl(this._self, this._then);

  final _SearchProviders _self;
  final $Res Function(_SearchProviders) _then;

/// Create a copy of SearchProviders
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? books = null,Object? booksCovers = null,Object? podcasts = null,}) {
  return _then(_SearchProviders(
books: null == books ? _self._books : books // ignore: cast_nullable_to_non_nullable
as List<SearchProviderOption>,booksCovers: null == booksCovers ? _self._booksCovers : booksCovers // ignore: cast_nullable_to_non_nullable
as List<SearchProviderOption>,podcasts: null == podcasts ? _self._podcasts : podcasts // ignore: cast_nullable_to_non_nullable
as List<SearchProviderOption>,
  ));
}


}

// dart format on
