// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pinned_shelf_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PinnedShelfEntry {

 String get itemId; String? get episodeId;@JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson) DateTime get pinnedAt;
/// Create a copy of PinnedShelfEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinnedShelfEntryCopyWith<PinnedShelfEntry> get copyWith => _$PinnedShelfEntryCopyWithImpl<PinnedShelfEntry>(this as PinnedShelfEntry, _$identity);

  /// Serializes this PinnedShelfEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinnedShelfEntry&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId,pinnedAt);

@override
String toString() {
  return 'PinnedShelfEntry(itemId: $itemId, episodeId: $episodeId, pinnedAt: $pinnedAt)';
}


}

/// @nodoc
abstract mixin class $PinnedShelfEntryCopyWith<$Res>  {
  factory $PinnedShelfEntryCopyWith(PinnedShelfEntry value, $Res Function(PinnedShelfEntry) _then) = _$PinnedShelfEntryCopyWithImpl;
@useResult
$Res call({
 String itemId, String? episodeId,@JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson) DateTime pinnedAt
});




}
/// @nodoc
class _$PinnedShelfEntryCopyWithImpl<$Res>
    implements $PinnedShelfEntryCopyWith<$Res> {
  _$PinnedShelfEntryCopyWithImpl(this._self, this._then);

  final PinnedShelfEntry _self;
  final $Res Function(PinnedShelfEntry) _then;

/// Create a copy of PinnedShelfEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? episodeId = freezed,Object? pinnedAt = null,}) {
  return _then(PinnedShelfEntry(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,pinnedAt: null == pinnedAt ? _self.pinnedAt : pinnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PinnedShelfEntry].
extension PinnedShelfEntryPatterns on PinnedShelfEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinnedShelfEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinnedShelfEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinnedShelfEntry value)  $default,){
final _that = this;
switch (_that) {
case _PinnedShelfEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinnedShelfEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PinnedShelfEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String? episodeId, @JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson)  DateTime pinnedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinnedShelfEntry() when $default != null:
return $default(_that.itemId,_that.episodeId,_that.pinnedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String? episodeId, @JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson)  DateTime pinnedAt)  $default,) {final _that = this;
switch (_that) {
case _PinnedShelfEntry():
return $default(_that.itemId,_that.episodeId,_that.pinnedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String? episodeId, @JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson)  DateTime pinnedAt)?  $default,) {final _that = this;
switch (_that) {
case _PinnedShelfEntry() when $default != null:
return $default(_that.itemId,_that.episodeId,_that.pinnedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PinnedShelfEntry extends PinnedShelfEntry {
  const _PinnedShelfEntry({required this.itemId, this.episodeId, @JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson) required this.pinnedAt}): super._();
  factory _PinnedShelfEntry.fromJson(Map<String, dynamic> json) => _$PinnedShelfEntryFromJson(json);

@override final  String itemId;
@override final  String? episodeId;
@override@JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson) final  DateTime pinnedAt;

/// Create a copy of PinnedShelfEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinnedShelfEntryCopyWith<_PinnedShelfEntry> get copyWith => __$PinnedShelfEntryCopyWithImpl<_PinnedShelfEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PinnedShelfEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinnedShelfEntry&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.pinnedAt, pinnedAt) || other.pinnedAt == pinnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId,pinnedAt);

@override
String toString() {
  return 'PinnedShelfEntry(itemId: $itemId, episodeId: $episodeId, pinnedAt: $pinnedAt)';
}


}

/// @nodoc
abstract mixin class _$PinnedShelfEntryCopyWith<$Res> implements $PinnedShelfEntryCopyWith<$Res> {
  factory _$PinnedShelfEntryCopyWith(_PinnedShelfEntry value, $Res Function(_PinnedShelfEntry) _then) = __$PinnedShelfEntryCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String? episodeId,@JsonKey(fromJson: _pinnedAtFromJson, toJson: _pinnedAtToJson) DateTime pinnedAt
});




}
/// @nodoc
class __$PinnedShelfEntryCopyWithImpl<$Res>
    implements _$PinnedShelfEntryCopyWith<$Res> {
  __$PinnedShelfEntryCopyWithImpl(this._self, this._then);

  final _PinnedShelfEntry _self;
  final $Res Function(_PinnedShelfEntry) _then;

/// Create a copy of PinnedShelfEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? episodeId = freezed,Object? pinnedAt = null,}) {
  return _then(_PinnedShelfEntry(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,pinnedAt: null == pinnedAt ? _self.pinnedAt : pinnedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
