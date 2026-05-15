// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_match_library_item_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuickMatchLibraryItemResponse {

@JsonKey(name: 'updated') bool get updated;@JsonKey(name: 'libraryItem') LibraryItem? get libraryItem;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'error') String? get error;
/// Create a copy of QuickMatchLibraryItemResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuickMatchLibraryItemResponseCopyWith<QuickMatchLibraryItemResponse> get copyWith => _$QuickMatchLibraryItemResponseCopyWithImpl<QuickMatchLibraryItemResponse>(this as QuickMatchLibraryItemResponse, _$identity);

  /// Serializes this QuickMatchLibraryItemResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuickMatchLibraryItemResponse&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated,libraryItem,message,error);

@override
String toString() {
  return 'QuickMatchLibraryItemResponse(updated: $updated, libraryItem: $libraryItem, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $QuickMatchLibraryItemResponseCopyWith<$Res>  {
  factory $QuickMatchLibraryItemResponseCopyWith(QuickMatchLibraryItemResponse value, $Res Function(QuickMatchLibraryItemResponse) _then) = _$QuickMatchLibraryItemResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'updated') bool updated,@JsonKey(name: 'libraryItem') LibraryItem? libraryItem,@JsonKey(name: 'message') String? message,@JsonKey(name: 'error') String? error
});


$LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class _$QuickMatchLibraryItemResponseCopyWithImpl<$Res>
    implements $QuickMatchLibraryItemResponseCopyWith<$Res> {
  _$QuickMatchLibraryItemResponseCopyWithImpl(this._self, this._then);

  final QuickMatchLibraryItemResponse _self;
  final $Res Function(QuickMatchLibraryItemResponse) _then;

/// Create a copy of QuickMatchLibraryItemResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updated = null,Object? libraryItem = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QuickMatchLibraryItemResponse
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


/// Adds pattern-matching-related methods to [QuickMatchLibraryItemResponse].
extension QuickMatchLibraryItemResponsePatterns on QuickMatchLibraryItemResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuickMatchLibraryItemResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuickMatchLibraryItemResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuickMatchLibraryItemResponse value)  $default,){
final _that = this;
switch (_that) {
case _QuickMatchLibraryItemResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuickMatchLibraryItemResponse value)?  $default,){
final _that = this;
switch (_that) {
case _QuickMatchLibraryItemResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'updated')  bool updated, @JsonKey(name: 'libraryItem')  LibraryItem? libraryItem, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'error')  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuickMatchLibraryItemResponse() when $default != null:
return $default(_that.updated,_that.libraryItem,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'updated')  bool updated, @JsonKey(name: 'libraryItem')  LibraryItem? libraryItem, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'error')  String? error)  $default,) {final _that = this;
switch (_that) {
case _QuickMatchLibraryItemResponse():
return $default(_that.updated,_that.libraryItem,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'updated')  bool updated, @JsonKey(name: 'libraryItem')  LibraryItem? libraryItem, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'error')  String? error)?  $default,) {final _that = this;
switch (_that) {
case _QuickMatchLibraryItemResponse() when $default != null:
return $default(_that.updated,_that.libraryItem,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuickMatchLibraryItemResponse implements QuickMatchLibraryItemResponse {
  const _QuickMatchLibraryItemResponse({@JsonKey(name: 'updated') this.updated = false, @JsonKey(name: 'libraryItem') this.libraryItem, @JsonKey(name: 'message') this.message, @JsonKey(name: 'error') this.error});
  factory _QuickMatchLibraryItemResponse.fromJson(Map<String, dynamic> json) => _$QuickMatchLibraryItemResponseFromJson(json);

@override@JsonKey(name: 'updated') final  bool updated;
@override@JsonKey(name: 'libraryItem') final  LibraryItem? libraryItem;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'error') final  String? error;

/// Create a copy of QuickMatchLibraryItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuickMatchLibraryItemResponseCopyWith<_QuickMatchLibraryItemResponse> get copyWith => __$QuickMatchLibraryItemResponseCopyWithImpl<_QuickMatchLibraryItemResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuickMatchLibraryItemResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuickMatchLibraryItemResponse&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated,libraryItem,message,error);

@override
String toString() {
  return 'QuickMatchLibraryItemResponse(updated: $updated, libraryItem: $libraryItem, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$QuickMatchLibraryItemResponseCopyWith<$Res> implements $QuickMatchLibraryItemResponseCopyWith<$Res> {
  factory _$QuickMatchLibraryItemResponseCopyWith(_QuickMatchLibraryItemResponse value, $Res Function(_QuickMatchLibraryItemResponse) _then) = __$QuickMatchLibraryItemResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'updated') bool updated,@JsonKey(name: 'libraryItem') LibraryItem? libraryItem,@JsonKey(name: 'message') String? message,@JsonKey(name: 'error') String? error
});


@override $LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class __$QuickMatchLibraryItemResponseCopyWithImpl<$Res>
    implements _$QuickMatchLibraryItemResponseCopyWith<$Res> {
  __$QuickMatchLibraryItemResponseCopyWithImpl(this._self, this._then);

  final _QuickMatchLibraryItemResponse _self;
  final $Res Function(_QuickMatchLibraryItemResponse) _then;

/// Create a copy of QuickMatchLibraryItemResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updated = null,Object? libraryItem = freezed,Object? message = freezed,Object? error = freezed,}) {
  return _then(_QuickMatchLibraryItemResponse(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as bool,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QuickMatchLibraryItemResponse
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
