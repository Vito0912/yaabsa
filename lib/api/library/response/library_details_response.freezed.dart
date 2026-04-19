// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryDetailsResponse {

@JsonKey(name: 'filterdata') LibraryFilterData? get filterData;@JsonKey(name: 'issues') int get issues;@JsonKey(name: 'numUserPlaylists') int get numUserPlaylists;@JsonKey(name: 'library') Library? get library;
/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryDetailsResponseCopyWith<LibraryDetailsResponse> get copyWith => _$LibraryDetailsResponseCopyWithImpl<LibraryDetailsResponse>(this as LibraryDetailsResponse, _$identity);

  /// Serializes this LibraryDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryDetailsResponse&&(identical(other.filterData, filterData) || other.filterData == filterData)&&(identical(other.issues, issues) || other.issues == issues)&&(identical(other.numUserPlaylists, numUserPlaylists) || other.numUserPlaylists == numUserPlaylists)&&(identical(other.library, library) || other.library == library));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filterData,issues,numUserPlaylists,library);

@override
String toString() {
  return 'LibraryDetailsResponse(filterData: $filterData, issues: $issues, numUserPlaylists: $numUserPlaylists, library: $library)';
}


}

/// @nodoc
abstract mixin class $LibraryDetailsResponseCopyWith<$Res>  {
  factory $LibraryDetailsResponseCopyWith(LibraryDetailsResponse value, $Res Function(LibraryDetailsResponse) _then) = _$LibraryDetailsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'filterdata') LibraryFilterData? filterData,@JsonKey(name: 'issues') int issues,@JsonKey(name: 'numUserPlaylists') int numUserPlaylists,@JsonKey(name: 'library') Library? library
});


$LibraryFilterDataCopyWith<$Res>? get filterData;$LibraryCopyWith<$Res>? get library;

}
/// @nodoc
class _$LibraryDetailsResponseCopyWithImpl<$Res>
    implements $LibraryDetailsResponseCopyWith<$Res> {
  _$LibraryDetailsResponseCopyWithImpl(this._self, this._then);

  final LibraryDetailsResponse _self;
  final $Res Function(LibraryDetailsResponse) _then;

/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? filterData = freezed,Object? issues = null,Object? numUserPlaylists = null,Object? library = freezed,}) {
  return _then(_self.copyWith(
filterData: freezed == filterData ? _self.filterData : filterData // ignore: cast_nullable_to_non_nullable
as LibraryFilterData?,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as int,numUserPlaylists: null == numUserPlaylists ? _self.numUserPlaylists : numUserPlaylists // ignore: cast_nullable_to_non_nullable
as int,library: freezed == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as Library?,
  ));
}
/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFilterDataCopyWith<$Res>? get filterData {
    if (_self.filterData == null) {
    return null;
  }

  return $LibraryFilterDataCopyWith<$Res>(_self.filterData!, (value) {
    return _then(_self.copyWith(filterData: value));
  });
}/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryCopyWith<$Res>? get library {
    if (_self.library == null) {
    return null;
  }

  return $LibraryCopyWith<$Res>(_self.library!, (value) {
    return _then(_self.copyWith(library: value));
  });
}
}


/// Adds pattern-matching-related methods to [LibraryDetailsResponse].
extension LibraryDetailsResponsePatterns on LibraryDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _LibraryDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'filterdata')  LibraryFilterData? filterData, @JsonKey(name: 'issues')  int issues, @JsonKey(name: 'numUserPlaylists')  int numUserPlaylists, @JsonKey(name: 'library')  Library? library)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryDetailsResponse() when $default != null:
return $default(_that.filterData,_that.issues,_that.numUserPlaylists,_that.library);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'filterdata')  LibraryFilterData? filterData, @JsonKey(name: 'issues')  int issues, @JsonKey(name: 'numUserPlaylists')  int numUserPlaylists, @JsonKey(name: 'library')  Library? library)  $default,) {final _that = this;
switch (_that) {
case _LibraryDetailsResponse():
return $default(_that.filterData,_that.issues,_that.numUserPlaylists,_that.library);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'filterdata')  LibraryFilterData? filterData, @JsonKey(name: 'issues')  int issues, @JsonKey(name: 'numUserPlaylists')  int numUserPlaylists, @JsonKey(name: 'library')  Library? library)?  $default,) {final _that = this;
switch (_that) {
case _LibraryDetailsResponse() when $default != null:
return $default(_that.filterData,_that.issues,_that.numUserPlaylists,_that.library);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryDetailsResponse implements LibraryDetailsResponse {
  const _LibraryDetailsResponse({@JsonKey(name: 'filterdata') this.filterData, @JsonKey(name: 'issues') this.issues = 0, @JsonKey(name: 'numUserPlaylists') this.numUserPlaylists = 0, @JsonKey(name: 'library') this.library});
  factory _LibraryDetailsResponse.fromJson(Map<String, dynamic> json) => _$LibraryDetailsResponseFromJson(json);

@override@JsonKey(name: 'filterdata') final  LibraryFilterData? filterData;
@override@JsonKey(name: 'issues') final  int issues;
@override@JsonKey(name: 'numUserPlaylists') final  int numUserPlaylists;
@override@JsonKey(name: 'library') final  Library? library;

/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryDetailsResponseCopyWith<_LibraryDetailsResponse> get copyWith => __$LibraryDetailsResponseCopyWithImpl<_LibraryDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryDetailsResponse&&(identical(other.filterData, filterData) || other.filterData == filterData)&&(identical(other.issues, issues) || other.issues == issues)&&(identical(other.numUserPlaylists, numUserPlaylists) || other.numUserPlaylists == numUserPlaylists)&&(identical(other.library, library) || other.library == library));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,filterData,issues,numUserPlaylists,library);

@override
String toString() {
  return 'LibraryDetailsResponse(filterData: $filterData, issues: $issues, numUserPlaylists: $numUserPlaylists, library: $library)';
}


}

/// @nodoc
abstract mixin class _$LibraryDetailsResponseCopyWith<$Res> implements $LibraryDetailsResponseCopyWith<$Res> {
  factory _$LibraryDetailsResponseCopyWith(_LibraryDetailsResponse value, $Res Function(_LibraryDetailsResponse) _then) = __$LibraryDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'filterdata') LibraryFilterData? filterData,@JsonKey(name: 'issues') int issues,@JsonKey(name: 'numUserPlaylists') int numUserPlaylists,@JsonKey(name: 'library') Library? library
});


@override $LibraryFilterDataCopyWith<$Res>? get filterData;@override $LibraryCopyWith<$Res>? get library;

}
/// @nodoc
class __$LibraryDetailsResponseCopyWithImpl<$Res>
    implements _$LibraryDetailsResponseCopyWith<$Res> {
  __$LibraryDetailsResponseCopyWithImpl(this._self, this._then);

  final _LibraryDetailsResponse _self;
  final $Res Function(_LibraryDetailsResponse) _then;

/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? filterData = freezed,Object? issues = null,Object? numUserPlaylists = null,Object? library = freezed,}) {
  return _then(_LibraryDetailsResponse(
filterData: freezed == filterData ? _self.filterData : filterData // ignore: cast_nullable_to_non_nullable
as LibraryFilterData?,issues: null == issues ? _self.issues : issues // ignore: cast_nullable_to_non_nullable
as int,numUserPlaylists: null == numUserPlaylists ? _self.numUserPlaylists : numUserPlaylists // ignore: cast_nullable_to_non_nullable
as int,library: freezed == library ? _self.library : library // ignore: cast_nullable_to_non_nullable
as Library?,
  ));
}

/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryFilterDataCopyWith<$Res>? get filterData {
    if (_self.filterData == null) {
    return null;
  }

  return $LibraryFilterDataCopyWith<$Res>(_self.filterData!, (value) {
    return _then(_self.copyWith(filterData: value));
  });
}/// Create a copy of LibraryDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryCopyWith<$Res>? get library {
    if (_self.library == null) {
    return null;
  }

  return $LibraryCopyWith<$Res>(_self.library!, (value) {
    return _then(_self.copyWith(library: value));
  });
}
}

// dart format on
