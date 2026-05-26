// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_podcast_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePodcastResponse {

@JsonKey(name: 'libraryItem') LibraryItem? get libraryItem;@JsonKey(name: 'item') LibraryItem? get item;
/// Create a copy of CreatePodcastResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePodcastResponseCopyWith<CreatePodcastResponse> get copyWith => _$CreatePodcastResponseCopyWithImpl<CreatePodcastResponse>(this as CreatePodcastResponse, _$identity);

  /// Serializes this CreatePodcastResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePodcastResponse&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem)&&(identical(other.item, item) || other.item == item));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItem,item);

@override
String toString() {
  return 'CreatePodcastResponse(libraryItem: $libraryItem, item: $item)';
}


}

/// @nodoc
abstract mixin class $CreatePodcastResponseCopyWith<$Res>  {
  factory $CreatePodcastResponseCopyWith(CreatePodcastResponse value, $Res Function(CreatePodcastResponse) _then) = _$CreatePodcastResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'libraryItem') LibraryItem? libraryItem,@JsonKey(name: 'item') LibraryItem? item
});


$LibraryItemCopyWith<$Res>? get libraryItem;$LibraryItemCopyWith<$Res>? get item;

}
/// @nodoc
class _$CreatePodcastResponseCopyWithImpl<$Res>
    implements $CreatePodcastResponseCopyWith<$Res> {
  _$CreatePodcastResponseCopyWithImpl(this._self, this._then);

  final CreatePodcastResponse _self;
  final $Res Function(CreatePodcastResponse) _then;

/// Create a copy of CreatePodcastResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItem = freezed,Object? item = freezed,}) {
  return _then(_self.copyWith(
libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}
/// Create a copy of CreatePodcastResponse
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
}/// Create a copy of CreatePodcastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatePodcastResponse].
extension CreatePodcastResponsePatterns on CreatePodcastResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePodcastResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePodcastResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePodcastResponse value)  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePodcastResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePodcastResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItem')  LibraryItem? libraryItem, @JsonKey(name: 'item')  LibraryItem? item)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePodcastResponse() when $default != null:
return $default(_that.libraryItem,_that.item);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItem')  LibraryItem? libraryItem, @JsonKey(name: 'item')  LibraryItem? item)  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastResponse():
return $default(_that.libraryItem,_that.item);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'libraryItem')  LibraryItem? libraryItem, @JsonKey(name: 'item')  LibraryItem? item)?  $default,) {final _that = this;
switch (_that) {
case _CreatePodcastResponse() when $default != null:
return $default(_that.libraryItem,_that.item);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreatePodcastResponse extends CreatePodcastResponse {
  const _CreatePodcastResponse({@JsonKey(name: 'libraryItem') this.libraryItem, @JsonKey(name: 'item') this.item}): super._();
  factory _CreatePodcastResponse.fromJson(Map<String, dynamic> json) => _$CreatePodcastResponseFromJson(json);

@override@JsonKey(name: 'libraryItem') final  LibraryItem? libraryItem;
@override@JsonKey(name: 'item') final  LibraryItem? item;

/// Create a copy of CreatePodcastResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePodcastResponseCopyWith<_CreatePodcastResponse> get copyWith => __$CreatePodcastResponseCopyWithImpl<_CreatePodcastResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreatePodcastResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePodcastResponse&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem)&&(identical(other.item, item) || other.item == item));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,libraryItem,item);

@override
String toString() {
  return 'CreatePodcastResponse(libraryItem: $libraryItem, item: $item)';
}


}

/// @nodoc
abstract mixin class _$CreatePodcastResponseCopyWith<$Res> implements $CreatePodcastResponseCopyWith<$Res> {
  factory _$CreatePodcastResponseCopyWith(_CreatePodcastResponse value, $Res Function(_CreatePodcastResponse) _then) = __$CreatePodcastResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'libraryItem') LibraryItem? libraryItem,@JsonKey(name: 'item') LibraryItem? item
});


@override $LibraryItemCopyWith<$Res>? get libraryItem;@override $LibraryItemCopyWith<$Res>? get item;

}
/// @nodoc
class __$CreatePodcastResponseCopyWithImpl<$Res>
    implements _$CreatePodcastResponseCopyWith<$Res> {
  __$CreatePodcastResponseCopyWithImpl(this._self, this._then);

  final _CreatePodcastResponse _self;
  final $Res Function(_CreatePodcastResponse) _then;

/// Create a copy of CreatePodcastResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItem = freezed,Object? item = freezed,}) {
  return _then(_CreatePodcastResponse(
libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}

/// Create a copy of CreatePodcastResponse
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
}/// Create a copy of CreatePodcastResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get item {
    if (_self.item == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.item!, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
