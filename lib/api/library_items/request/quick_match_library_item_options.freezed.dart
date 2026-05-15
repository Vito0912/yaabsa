// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_match_library_item_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuickMatchLibraryItemOptions {

@JsonKey(name: 'provider') String? get provider;@JsonKey(name: 'title') String? get title;@JsonKey(name: 'author') String? get author;@JsonKey(name: 'isbn') String? get isbn;@JsonKey(name: 'asin') String? get asin;@JsonKey(name: 'overrideCover') bool get overrideCover;@JsonKey(name: 'overrideDetails') bool get overrideDetails;
/// Create a copy of QuickMatchLibraryItemOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickMatchLibraryItemOptionsCopyWith<QuickMatchLibraryItemOptions> get copyWith => _$QuickMatchLibraryItemOptionsCopyWithImpl<QuickMatchLibraryItemOptions>(this as QuickMatchLibraryItemOptions, _$identity);

  /// Serializes this QuickMatchLibraryItemOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickMatchLibraryItemOptions&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.overrideCover, overrideCover) || other.overrideCover == overrideCover)&&(identical(other.overrideDetails, overrideDetails) || other.overrideDetails == overrideDetails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,title,author,isbn,asin,overrideCover,overrideDetails);

@override
String toString() {
  return 'QuickMatchLibraryItemOptions(provider: $provider, title: $title, author: $author, isbn: $isbn, asin: $asin, overrideCover: $overrideCover, overrideDetails: $overrideDetails)';
}


}

/// @nodoc
abstract mixin class $QuickMatchLibraryItemOptionsCopyWith<$Res>  {
  factory $QuickMatchLibraryItemOptionsCopyWith(QuickMatchLibraryItemOptions value, $Res Function(QuickMatchLibraryItemOptions) _then) = _$QuickMatchLibraryItemOptionsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'title') String? title,@JsonKey(name: 'author') String? author,@JsonKey(name: 'isbn') String? isbn,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'overrideCover') bool overrideCover,@JsonKey(name: 'overrideDetails') bool overrideDetails
});




}
/// @nodoc
class _$QuickMatchLibraryItemOptionsCopyWithImpl<$Res>
    implements $QuickMatchLibraryItemOptionsCopyWith<$Res> {
  _$QuickMatchLibraryItemOptionsCopyWithImpl(this._self, this._then);

  final QuickMatchLibraryItemOptions _self;
  final $Res Function(QuickMatchLibraryItemOptions) _then;

/// Create a copy of QuickMatchLibraryItemOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = freezed,Object? title = freezed,Object? author = freezed,Object? isbn = freezed,Object? asin = freezed,Object? overrideCover = null,Object? overrideDetails = null,}) {
  return _then(_self.copyWith(
provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,overrideCover: null == overrideCover ? _self.overrideCover : overrideCover // ignore: cast_nullable_to_non_nullable
as bool,overrideDetails: null == overrideDetails ? _self.overrideDetails : overrideDetails // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [QuickMatchLibraryItemOptions].
extension QuickMatchLibraryItemOptionsPatterns on QuickMatchLibraryItemOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickMatchLibraryItemOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickMatchLibraryItemOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickMatchLibraryItemOptions value)  $default,){
final _that = this;
switch (_that) {
case _QuickMatchLibraryItemOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickMatchLibraryItemOptions value)?  $default,){
final _that = this;
switch (_that) {
case _QuickMatchLibraryItemOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'isbn')  String? isbn, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'overrideCover')  bool overrideCover, @JsonKey(name: 'overrideDetails')  bool overrideDetails)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickMatchLibraryItemOptions() when $default != null:
return $default(_that.provider,_that.title,_that.author,_that.isbn,_that.asin,_that.overrideCover,_that.overrideDetails);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'isbn')  String? isbn, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'overrideCover')  bool overrideCover, @JsonKey(name: 'overrideDetails')  bool overrideDetails)  $default,) {final _that = this;
switch (_that) {
case _QuickMatchLibraryItemOptions():
return $default(_that.provider,_that.title,_that.author,_that.isbn,_that.asin,_that.overrideCover,_that.overrideDetails);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'title')  String? title, @JsonKey(name: 'author')  String? author, @JsonKey(name: 'isbn')  String? isbn, @JsonKey(name: 'asin')  String? asin, @JsonKey(name: 'overrideCover')  bool overrideCover, @JsonKey(name: 'overrideDetails')  bool overrideDetails)?  $default,) {final _that = this;
switch (_that) {
case _QuickMatchLibraryItemOptions() when $default != null:
return $default(_that.provider,_that.title,_that.author,_that.isbn,_that.asin,_that.overrideCover,_that.overrideDetails);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _QuickMatchLibraryItemOptions implements QuickMatchLibraryItemOptions {
  const _QuickMatchLibraryItemOptions({@JsonKey(name: 'provider') this.provider, @JsonKey(name: 'title') this.title, @JsonKey(name: 'author') this.author, @JsonKey(name: 'isbn') this.isbn, @JsonKey(name: 'asin') this.asin, @JsonKey(name: 'overrideCover') this.overrideCover = true, @JsonKey(name: 'overrideDetails') this.overrideDetails = true});
  factory _QuickMatchLibraryItemOptions.fromJson(Map<String, dynamic> json) => _$QuickMatchLibraryItemOptionsFromJson(json);

@override@JsonKey(name: 'provider') final  String? provider;
@override@JsonKey(name: 'title') final  String? title;
@override@JsonKey(name: 'author') final  String? author;
@override@JsonKey(name: 'isbn') final  String? isbn;
@override@JsonKey(name: 'asin') final  String? asin;
@override@JsonKey(name: 'overrideCover') final  bool overrideCover;
@override@JsonKey(name: 'overrideDetails') final  bool overrideDetails;

/// Create a copy of QuickMatchLibraryItemOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickMatchLibraryItemOptionsCopyWith<_QuickMatchLibraryItemOptions> get copyWith => __$QuickMatchLibraryItemOptionsCopyWithImpl<_QuickMatchLibraryItemOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickMatchLibraryItemOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickMatchLibraryItemOptions&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.title, title) || other.title == title)&&(identical(other.author, author) || other.author == author)&&(identical(other.isbn, isbn) || other.isbn == isbn)&&(identical(other.asin, asin) || other.asin == asin)&&(identical(other.overrideCover, overrideCover) || other.overrideCover == overrideCover)&&(identical(other.overrideDetails, overrideDetails) || other.overrideDetails == overrideDetails));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,title,author,isbn,asin,overrideCover,overrideDetails);

@override
String toString() {
  return 'QuickMatchLibraryItemOptions(provider: $provider, title: $title, author: $author, isbn: $isbn, asin: $asin, overrideCover: $overrideCover, overrideDetails: $overrideDetails)';
}


}

/// @nodoc
abstract mixin class _$QuickMatchLibraryItemOptionsCopyWith<$Res> implements $QuickMatchLibraryItemOptionsCopyWith<$Res> {
  factory _$QuickMatchLibraryItemOptionsCopyWith(_QuickMatchLibraryItemOptions value, $Res Function(_QuickMatchLibraryItemOptions) _then) = __$QuickMatchLibraryItemOptionsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'title') String? title,@JsonKey(name: 'author') String? author,@JsonKey(name: 'isbn') String? isbn,@JsonKey(name: 'asin') String? asin,@JsonKey(name: 'overrideCover') bool overrideCover,@JsonKey(name: 'overrideDetails') bool overrideDetails
});




}
/// @nodoc
class __$QuickMatchLibraryItemOptionsCopyWithImpl<$Res>
    implements _$QuickMatchLibraryItemOptionsCopyWith<$Res> {
  __$QuickMatchLibraryItemOptionsCopyWithImpl(this._self, this._then);

  final _QuickMatchLibraryItemOptions _self;
  final $Res Function(_QuickMatchLibraryItemOptions) _then;

/// Create a copy of QuickMatchLibraryItemOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = freezed,Object? title = freezed,Object? author = freezed,Object? isbn = freezed,Object? asin = freezed,Object? overrideCover = null,Object? overrideDetails = null,}) {
  return _then(_QuickMatchLibraryItemOptions(
provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,isbn: freezed == isbn ? _self.isbn : isbn // ignore: cast_nullable_to_non_nullable
as String?,asin: freezed == asin ? _self.asin : asin // ignore: cast_nullable_to_non_nullable
as String?,overrideCover: null == overrideCover ? _self.overrideCover : overrideCover // ignore: cast_nullable_to_non_nullable
as bool,overrideDetails: null == overrideDetails ? _self.overrideDetails : overrideDetails // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
