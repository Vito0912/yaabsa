// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reorder_library_entry_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReorderLibraryEntryRequest {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'newOrder') int get newOrder;
/// Create a copy of ReorderLibraryEntryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReorderLibraryEntryRequestCopyWith<ReorderLibraryEntryRequest> get copyWith => _$ReorderLibraryEntryRequestCopyWithImpl<ReorderLibraryEntryRequest>(this as ReorderLibraryEntryRequest, _$identity);

  /// Serializes this ReorderLibraryEntryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReorderLibraryEntryRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.newOrder, newOrder) || other.newOrder == newOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,newOrder);

@override
String toString() {
  return 'ReorderLibraryEntryRequest(id: $id, newOrder: $newOrder)';
}


}

/// @nodoc
abstract mixin class $ReorderLibraryEntryRequestCopyWith<$Res>  {
  factory $ReorderLibraryEntryRequestCopyWith(ReorderLibraryEntryRequest value, $Res Function(ReorderLibraryEntryRequest) _then) = _$ReorderLibraryEntryRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'newOrder') int newOrder
});




}
/// @nodoc
class _$ReorderLibraryEntryRequestCopyWithImpl<$Res>
    implements $ReorderLibraryEntryRequestCopyWith<$Res> {
  _$ReorderLibraryEntryRequestCopyWithImpl(this._self, this._then);

  final ReorderLibraryEntryRequest _self;
  final $Res Function(ReorderLibraryEntryRequest) _then;

/// Create a copy of ReorderLibraryEntryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? newOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,newOrder: null == newOrder ? _self.newOrder : newOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReorderLibraryEntryRequest].
extension ReorderLibraryEntryRequestPatterns on ReorderLibraryEntryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReorderLibraryEntryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReorderLibraryEntryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReorderLibraryEntryRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReorderLibraryEntryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReorderLibraryEntryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReorderLibraryEntryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'newOrder')  int newOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReorderLibraryEntryRequest() when $default != null:
return $default(_that.id,_that.newOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'newOrder')  int newOrder)  $default,) {final _that = this;
switch (_that) {
case _ReorderLibraryEntryRequest():
return $default(_that.id,_that.newOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'newOrder')  int newOrder)?  $default,) {final _that = this;
switch (_that) {
case _ReorderLibraryEntryRequest() when $default != null:
return $default(_that.id,_that.newOrder);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReorderLibraryEntryRequest implements ReorderLibraryEntryRequest {
  const _ReorderLibraryEntryRequest({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'newOrder') required this.newOrder});
  factory _ReorderLibraryEntryRequest.fromJson(Map<String, dynamic> json) => _$ReorderLibraryEntryRequestFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'newOrder') final  int newOrder;

/// Create a copy of ReorderLibraryEntryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReorderLibraryEntryRequestCopyWith<_ReorderLibraryEntryRequest> get copyWith => __$ReorderLibraryEntryRequestCopyWithImpl<_ReorderLibraryEntryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReorderLibraryEntryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReorderLibraryEntryRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.newOrder, newOrder) || other.newOrder == newOrder));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,newOrder);

@override
String toString() {
  return 'ReorderLibraryEntryRequest(id: $id, newOrder: $newOrder)';
}


}

/// @nodoc
abstract mixin class _$ReorderLibraryEntryRequestCopyWith<$Res> implements $ReorderLibraryEntryRequestCopyWith<$Res> {
  factory _$ReorderLibraryEntryRequestCopyWith(_ReorderLibraryEntryRequest value, $Res Function(_ReorderLibraryEntryRequest) _then) = __$ReorderLibraryEntryRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'newOrder') int newOrder
});




}
/// @nodoc
class __$ReorderLibraryEntryRequestCopyWithImpl<$Res>
    implements _$ReorderLibraryEntryRequestCopyWith<$Res> {
  __$ReorderLibraryEntryRequestCopyWithImpl(this._self, this._then);

  final _ReorderLibraryEntryRequest _self;
  final $Res Function(_ReorderLibraryEntryRequest) _then;

/// Create a copy of ReorderLibraryEntryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? newOrder = null,}) {
  return _then(_ReorderLibraryEntryRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,newOrder: null == newOrder ? _self.newOrder : newOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
