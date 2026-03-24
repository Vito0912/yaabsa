// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collapsed_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CollapsedSeries {

@JsonKey(name: "id") String get id;@JsonKey(name: "name") String? get name;@JsonKey(name: "nameIgnorePrefix") String? get nameIgnorePrefix;@JsonKey(name: "sequence") String? get sequence;@JsonKey(name: "numBooks") int? get numBooks;@JsonKey(name: "libraryItemIds") List<String>? get libraryItemIds;
/// Create a copy of CollapsedSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CollapsedSeriesCopyWith<CollapsedSeries> get copyWith => _$CollapsedSeriesCopyWithImpl<CollapsedSeries>(this as CollapsedSeries, _$identity);

  /// Serializes this CollapsedSeries to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CollapsedSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameIgnorePrefix, nameIgnorePrefix) || other.nameIgnorePrefix == nameIgnorePrefix)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&const DeepCollectionEquality().equals(other.libraryItemIds, libraryItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameIgnorePrefix,sequence,numBooks,const DeepCollectionEquality().hash(libraryItemIds));

@override
String toString() {
  return 'CollapsedSeries(id: $id, name: $name, nameIgnorePrefix: $nameIgnorePrefix, sequence: $sequence, numBooks: $numBooks, libraryItemIds: $libraryItemIds)';
}


}

/// @nodoc
abstract mixin class $CollapsedSeriesCopyWith<$Res>  {
  factory $CollapsedSeriesCopyWith(CollapsedSeries value, $Res Function(CollapsedSeries) _then) = _$CollapsedSeriesCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String? name,@JsonKey(name: "nameIgnorePrefix") String? nameIgnorePrefix,@JsonKey(name: "sequence") String? sequence,@JsonKey(name: "numBooks") int? numBooks,@JsonKey(name: "libraryItemIds") List<String>? libraryItemIds
});




}
/// @nodoc
class _$CollapsedSeriesCopyWithImpl<$Res>
    implements $CollapsedSeriesCopyWith<$Res> {
  _$CollapsedSeriesCopyWithImpl(this._self, this._then);

  final CollapsedSeries _self;
  final $Res Function(CollapsedSeries) _then;

/// Create a copy of CollapsedSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? nameIgnorePrefix = freezed,Object? sequence = freezed,Object? numBooks = freezed,Object? libraryItemIds = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nameIgnorePrefix: freezed == nameIgnorePrefix ? _self.nameIgnorePrefix : nameIgnorePrefix // ignore: cast_nullable_to_non_nullable
as String?,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as String?,numBooks: freezed == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int?,libraryItemIds: freezed == libraryItemIds ? _self.libraryItemIds : libraryItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CollapsedSeries].
extension CollapsedSeriesPatterns on CollapsedSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CollapsedSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CollapsedSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CollapsedSeries value)  $default,){
final _that = this;
switch (_that) {
case _CollapsedSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CollapsedSeries value)?  $default,){
final _that = this;
switch (_that) {
case _CollapsedSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "name")  String? name, @JsonKey(name: "nameIgnorePrefix")  String? nameIgnorePrefix, @JsonKey(name: "sequence")  String? sequence, @JsonKey(name: "numBooks")  int? numBooks, @JsonKey(name: "libraryItemIds")  List<String>? libraryItemIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CollapsedSeries() when $default != null:
return $default(_that.id,_that.name,_that.nameIgnorePrefix,_that.sequence,_that.numBooks,_that.libraryItemIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "name")  String? name, @JsonKey(name: "nameIgnorePrefix")  String? nameIgnorePrefix, @JsonKey(name: "sequence")  String? sequence, @JsonKey(name: "numBooks")  int? numBooks, @JsonKey(name: "libraryItemIds")  List<String>? libraryItemIds)  $default,) {final _that = this;
switch (_that) {
case _CollapsedSeries():
return $default(_that.id,_that.name,_that.nameIgnorePrefix,_that.sequence,_that.numBooks,_that.libraryItemIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "name")  String? name, @JsonKey(name: "nameIgnorePrefix")  String? nameIgnorePrefix, @JsonKey(name: "sequence")  String? sequence, @JsonKey(name: "numBooks")  int? numBooks, @JsonKey(name: "libraryItemIds")  List<String>? libraryItemIds)?  $default,) {final _that = this;
switch (_that) {
case _CollapsedSeries() when $default != null:
return $default(_that.id,_that.name,_that.nameIgnorePrefix,_that.sequence,_that.numBooks,_that.libraryItemIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CollapsedSeries implements CollapsedSeries {
  const _CollapsedSeries({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") this.name, @JsonKey(name: "nameIgnorePrefix") this.nameIgnorePrefix, @JsonKey(name: "sequence") this.sequence, @JsonKey(name: "numBooks") this.numBooks, @JsonKey(name: "libraryItemIds") final  List<String>? libraryItemIds}): _libraryItemIds = libraryItemIds;
  factory _CollapsedSeries.fromJson(Map<String, dynamic> json) => _$CollapsedSeriesFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "name") final  String? name;
@override@JsonKey(name: "nameIgnorePrefix") final  String? nameIgnorePrefix;
@override@JsonKey(name: "sequence") final  String? sequence;
@override@JsonKey(name: "numBooks") final  int? numBooks;
 final  List<String>? _libraryItemIds;
@override@JsonKey(name: "libraryItemIds") List<String>? get libraryItemIds {
  final value = _libraryItemIds;
  if (value == null) return null;
  if (_libraryItemIds is EqualUnmodifiableListView) return _libraryItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CollapsedSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CollapsedSeriesCopyWith<_CollapsedSeries> get copyWith => __$CollapsedSeriesCopyWithImpl<_CollapsedSeries>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CollapsedSeriesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CollapsedSeries&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameIgnorePrefix, nameIgnorePrefix) || other.nameIgnorePrefix == nameIgnorePrefix)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.numBooks, numBooks) || other.numBooks == numBooks)&&const DeepCollectionEquality().equals(other._libraryItemIds, _libraryItemIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameIgnorePrefix,sequence,numBooks,const DeepCollectionEquality().hash(_libraryItemIds));

@override
String toString() {
  return 'CollapsedSeries(id: $id, name: $name, nameIgnorePrefix: $nameIgnorePrefix, sequence: $sequence, numBooks: $numBooks, libraryItemIds: $libraryItemIds)';
}


}

/// @nodoc
abstract mixin class _$CollapsedSeriesCopyWith<$Res> implements $CollapsedSeriesCopyWith<$Res> {
  factory _$CollapsedSeriesCopyWith(_CollapsedSeries value, $Res Function(_CollapsedSeries) _then) = __$CollapsedSeriesCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String? name,@JsonKey(name: "nameIgnorePrefix") String? nameIgnorePrefix,@JsonKey(name: "sequence") String? sequence,@JsonKey(name: "numBooks") int? numBooks,@JsonKey(name: "libraryItemIds") List<String>? libraryItemIds
});




}
/// @nodoc
class __$CollapsedSeriesCopyWithImpl<$Res>
    implements _$CollapsedSeriesCopyWith<$Res> {
  __$CollapsedSeriesCopyWithImpl(this._self, this._then);

  final _CollapsedSeries _self;
  final $Res Function(_CollapsedSeries) _then;

/// Create a copy of CollapsedSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? nameIgnorePrefix = freezed,Object? sequence = freezed,Object? numBooks = freezed,Object? libraryItemIds = freezed,}) {
  return _then(_CollapsedSeries(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,nameIgnorePrefix: freezed == nameIgnorePrefix ? _self.nameIgnorePrefix : nameIgnorePrefix // ignore: cast_nullable_to_non_nullable
as String?,sequence: freezed == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as String?,numBooks: freezed == numBooks ? _self.numBooks : numBooks // ignore: cast_nullable_to_non_nullable
as int?,libraryItemIds: freezed == libraryItemIds ? _self._libraryItemIds : libraryItemIds // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
