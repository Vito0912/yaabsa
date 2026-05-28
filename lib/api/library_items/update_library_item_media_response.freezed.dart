// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_library_item_media_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateLibraryItemMediaResponse {

@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic) bool get updated;@JsonKey(name: 'libraryItem') LibraryItem? get libraryItem;
/// Create a copy of UpdateLibraryItemMediaResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaResponseCopyWith<UpdateLibraryItemMediaResponse> get copyWith => _$UpdateLibraryItemMediaResponseCopyWithImpl<UpdateLibraryItemMediaResponse>(this as UpdateLibraryItemMediaResponse, _$identity);

  /// Serializes this UpdateLibraryItemMediaResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLibraryItemMediaResponse&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated,libraryItem);

@override
String toString() {
  return 'UpdateLibraryItemMediaResponse(updated: $updated, libraryItem: $libraryItem)';
}


}

/// @nodoc
abstract mixin class $UpdateLibraryItemMediaResponseCopyWith<$Res>  {
  factory $UpdateLibraryItemMediaResponseCopyWith(UpdateLibraryItemMediaResponse value, $Res Function(UpdateLibraryItemMediaResponse) _then) = _$UpdateLibraryItemMediaResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic) bool updated,@JsonKey(name: 'libraryItem') LibraryItem? libraryItem
});


$LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class _$UpdateLibraryItemMediaResponseCopyWithImpl<$Res>
    implements $UpdateLibraryItemMediaResponseCopyWith<$Res> {
  _$UpdateLibraryItemMediaResponseCopyWithImpl(this._self, this._then);

  final UpdateLibraryItemMediaResponse _self;
  final $Res Function(UpdateLibraryItemMediaResponse) _then;

/// Create a copy of UpdateLibraryItemMediaResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updated = null,Object? libraryItem = freezed,}) {
  return _then(_self.copyWith(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}
/// Create a copy of UpdateLibraryItemMediaResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get libraryItem {
    if (_self.libraryItem == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.libraryItem!, (value) {
    return _then(_self.copyWith(libraryItem: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateLibraryItemMediaResponse].
extension UpdateLibraryItemMediaResponsePatterns on UpdateLibraryItemMediaResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateLibraryItemMediaResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateLibraryItemMediaResponse value)  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateLibraryItemMediaResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic)  bool updated, @JsonKey(name: 'libraryItem')  LibraryItem? libraryItem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaResponse() when $default != null:
return $default(_that.updated,_that.libraryItem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic)  bool updated, @JsonKey(name: 'libraryItem')  LibraryItem? libraryItem)  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaResponse():
return $default(_that.updated,_that.libraryItem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic)  bool updated, @JsonKey(name: 'libraryItem')  LibraryItem? libraryItem)?  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryItemMediaResponse() when $default != null:
return $default(_that.updated,_that.libraryItem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateLibraryItemMediaResponse implements UpdateLibraryItemMediaResponse {
  const _UpdateLibraryItemMediaResponse({@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic) this.updated = false, @JsonKey(name: 'libraryItem') this.libraryItem});
  factory _UpdateLibraryItemMediaResponse.fromJson(Map<String, dynamic> json) => _$UpdateLibraryItemMediaResponseFromJson(json);

@override@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic) final  bool updated;
@override@JsonKey(name: 'libraryItem') final  LibraryItem? libraryItem;

/// Create a copy of UpdateLibraryItemMediaResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLibraryItemMediaResponseCopyWith<_UpdateLibraryItemMediaResponse> get copyWith => __$UpdateLibraryItemMediaResponseCopyWithImpl<_UpdateLibraryItemMediaResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateLibraryItemMediaResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLibraryItemMediaResponse&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated,libraryItem);

@override
String toString() {
  return 'UpdateLibraryItemMediaResponse(updated: $updated, libraryItem: $libraryItem)';
}


}

/// @nodoc
abstract mixin class _$UpdateLibraryItemMediaResponseCopyWith<$Res> implements $UpdateLibraryItemMediaResponseCopyWith<$Res> {
  factory _$UpdateLibraryItemMediaResponseCopyWith(_UpdateLibraryItemMediaResponse value, $Res Function(_UpdateLibraryItemMediaResponse) _then) = __$UpdateLibraryItemMediaResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'updated', fromJson: jsonBoolRequiredFromDynamic) bool updated,@JsonKey(name: 'libraryItem') LibraryItem? libraryItem
});


@override $LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class __$UpdateLibraryItemMediaResponseCopyWithImpl<$Res>
    implements _$UpdateLibraryItemMediaResponseCopyWith<$Res> {
  __$UpdateLibraryItemMediaResponseCopyWithImpl(this._self, this._then);

  final _UpdateLibraryItemMediaResponse _self;
  final $Res Function(_UpdateLibraryItemMediaResponse) _then;

/// Create a copy of UpdateLibraryItemMediaResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updated = null,Object? libraryItem = freezed,}) {
  return _then(_UpdateLibraryItemMediaResponse(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}

/// Create a copy of UpdateLibraryItemMediaResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get libraryItem {
    if (_self.libraryItem == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.libraryItem!, (value) {
    return _then(_self.copyWith(libraryItem: value));
  });
}
}

// dart format on
