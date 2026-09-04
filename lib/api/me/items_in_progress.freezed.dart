// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'items_in_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemsInProgress {

@JsonKey(name: 'libraryItems') List<LibraryItem> get libraryItems;
/// Create a copy of ItemsInProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemsInProgressCopyWith<ItemsInProgress> get copyWith => _$ItemsInProgressCopyWithImpl<ItemsInProgress>(this as ItemsInProgress, _$identity);

  /// Serializes this ItemsInProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemsInProgress&&const DeepCollectionEquality().equals(other.libraryItems, libraryItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(libraryItems));

@override
String toString() {
  return 'ItemsInProgress(libraryItems: $libraryItems)';
}


}

/// @nodoc
abstract mixin class $ItemsInProgressCopyWith<$Res>  {
  factory $ItemsInProgressCopyWith(ItemsInProgress value, $Res Function(ItemsInProgress) _then) = _$ItemsInProgressCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'libraryItems') List<LibraryItem> libraryItems
});




}
/// @nodoc
class _$ItemsInProgressCopyWithImpl<$Res>
    implements $ItemsInProgressCopyWith<$Res> {
  _$ItemsInProgressCopyWithImpl(this._self, this._then);

  final ItemsInProgress _self;
  final $Res Function(ItemsInProgress) _then;

/// Create a copy of ItemsInProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItems = null,}) {
  return _then(ItemsInProgress(
libraryItems: null == libraryItems ? _self.libraryItems : libraryItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemsInProgress].
extension ItemsInProgressPatterns on ItemsInProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemsInProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemsInProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemsInProgress value)  $default,){
final _that = this;
switch (_that) {
case _ItemsInProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemsInProgress value)?  $default,){
final _that = this;
switch (_that) {
case _ItemsInProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemsInProgress() when $default != null:
return $default(_that.libraryItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems)  $default,) {final _that = this;
switch (_that) {
case _ItemsInProgress():
return $default(_that.libraryItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems)?  $default,) {final _that = this;
switch (_that) {
case _ItemsInProgress() when $default != null:
return $default(_that.libraryItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ItemsInProgress implements ItemsInProgress {
  const _ItemsInProgress({@JsonKey(name: 'libraryItems')  List<LibraryItem> libraryItems = const <LibraryItem>[]}): _libraryItems = libraryItems;
  factory _ItemsInProgress.fromJson(Map<String, dynamic> json) => _$ItemsInProgressFromJson(json);

 final  List<LibraryItem> _libraryItems;
@override@JsonKey(name: 'libraryItems') List<LibraryItem> get libraryItems {
  if (_libraryItems is EqualUnmodifiableListView) return _libraryItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_libraryItems);
}


/// Create a copy of ItemsInProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemsInProgressCopyWith<_ItemsInProgress> get copyWith => __$ItemsInProgressCopyWithImpl<_ItemsInProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemsInProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemsInProgress&&const DeepCollectionEquality().equals(other._libraryItems, _libraryItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_libraryItems));

@override
String toString() {
  return 'ItemsInProgress(libraryItems: $libraryItems)';
}


}

/// @nodoc
abstract mixin class _$ItemsInProgressCopyWith<$Res> implements $ItemsInProgressCopyWith<$Res> {
  factory _$ItemsInProgressCopyWith(_ItemsInProgress value, $Res Function(_ItemsInProgress) _then) = __$ItemsInProgressCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'libraryItems') List<LibraryItem> libraryItems
});




}
/// @nodoc
class __$ItemsInProgressCopyWithImpl<$Res>
    implements _$ItemsInProgressCopyWith<$Res> {
  __$ItemsInProgressCopyWithImpl(this._self, this._then);

  final _ItemsInProgress _self;
  final $Res Function(_ItemsInProgress) _then;

/// Create a copy of ItemsInProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItems = null,}) {
  return _then(_ItemsInProgress(
libraryItems: null == libraryItems ? _self._libraryItems : libraryItems // ignore: cast_nullable_to_non_nullable
as List<LibraryItem>,
  ));
}


}

// dart format on
