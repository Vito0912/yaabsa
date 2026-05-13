// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_update_library_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchUpdateLibraryItemRequest {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'mediaPayload') UpdateLibraryItemMediaRequest get mediaPayload;
/// Create a copy of BatchUpdateLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchUpdateLibraryItemRequestCopyWith<BatchUpdateLibraryItemRequest> get copyWith => _$BatchUpdateLibraryItemRequestCopyWithImpl<BatchUpdateLibraryItemRequest>(this as BatchUpdateLibraryItemRequest, _$identity);

  /// Serializes this BatchUpdateLibraryItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchUpdateLibraryItemRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaPayload, mediaPayload) || other.mediaPayload == mediaPayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaPayload);

@override
String toString() {
  return 'BatchUpdateLibraryItemRequest(id: $id, mediaPayload: $mediaPayload)';
}


}

/// @nodoc
abstract mixin class $BatchUpdateLibraryItemRequestCopyWith<$Res>  {
  factory $BatchUpdateLibraryItemRequestCopyWith(BatchUpdateLibraryItemRequest value, $Res Function(BatchUpdateLibraryItemRequest) _then) = _$BatchUpdateLibraryItemRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'mediaPayload') UpdateLibraryItemMediaRequest mediaPayload
});


$UpdateLibraryItemMediaRequestCopyWith<$Res> get mediaPayload;

}
/// @nodoc
class _$BatchUpdateLibraryItemRequestCopyWithImpl<$Res>
    implements $BatchUpdateLibraryItemRequestCopyWith<$Res> {
  _$BatchUpdateLibraryItemRequestCopyWithImpl(this._self, this._then);

  final BatchUpdateLibraryItemRequest _self;
  final $Res Function(BatchUpdateLibraryItemRequest) _then;

/// Create a copy of BatchUpdateLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? mediaPayload = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaPayload: null == mediaPayload ? _self.mediaPayload : mediaPayload // ignore: cast_nullable_to_non_nullable
as UpdateLibraryItemMediaRequest,
  ));
}
/// Create a copy of BatchUpdateLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaRequestCopyWith<$Res> get mediaPayload {
  
  return $UpdateLibraryItemMediaRequestCopyWith<$Res>(_self.mediaPayload, (value) {
    return _then(_self.copyWith(mediaPayload: value));
  });
}
}


/// Adds pattern-matching-related methods to [BatchUpdateLibraryItemRequest].
extension BatchUpdateLibraryItemRequestPatterns on BatchUpdateLibraryItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchUpdateLibraryItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchUpdateLibraryItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchUpdateLibraryItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'mediaPayload')  UpdateLibraryItemMediaRequest mediaPayload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemRequest() when $default != null:
return $default(_that.id,_that.mediaPayload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'mediaPayload')  UpdateLibraryItemMediaRequest mediaPayload)  $default,) {final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemRequest():
return $default(_that.id,_that.mediaPayload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'mediaPayload')  UpdateLibraryItemMediaRequest mediaPayload)?  $default,) {final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemRequest() when $default != null:
return $default(_that.id,_that.mediaPayload);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _BatchUpdateLibraryItemRequest implements BatchUpdateLibraryItemRequest {
  const _BatchUpdateLibraryItemRequest({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'mediaPayload') required this.mediaPayload});
  factory _BatchUpdateLibraryItemRequest.fromJson(Map<String, dynamic> json) => _$BatchUpdateLibraryItemRequestFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'mediaPayload') final  UpdateLibraryItemMediaRequest mediaPayload;

/// Create a copy of BatchUpdateLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchUpdateLibraryItemRequestCopyWith<_BatchUpdateLibraryItemRequest> get copyWith => __$BatchUpdateLibraryItemRequestCopyWithImpl<_BatchUpdateLibraryItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchUpdateLibraryItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchUpdateLibraryItemRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.mediaPayload, mediaPayload) || other.mediaPayload == mediaPayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,mediaPayload);

@override
String toString() {
  return 'BatchUpdateLibraryItemRequest(id: $id, mediaPayload: $mediaPayload)';
}


}

/// @nodoc
abstract mixin class _$BatchUpdateLibraryItemRequestCopyWith<$Res> implements $BatchUpdateLibraryItemRequestCopyWith<$Res> {
  factory _$BatchUpdateLibraryItemRequestCopyWith(_BatchUpdateLibraryItemRequest value, $Res Function(_BatchUpdateLibraryItemRequest) _then) = __$BatchUpdateLibraryItemRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'mediaPayload') UpdateLibraryItemMediaRequest mediaPayload
});


@override $UpdateLibraryItemMediaRequestCopyWith<$Res> get mediaPayload;

}
/// @nodoc
class __$BatchUpdateLibraryItemRequestCopyWithImpl<$Res>
    implements _$BatchUpdateLibraryItemRequestCopyWith<$Res> {
  __$BatchUpdateLibraryItemRequestCopyWithImpl(this._self, this._then);

  final _BatchUpdateLibraryItemRequest _self;
  final $Res Function(_BatchUpdateLibraryItemRequest) _then;

/// Create a copy of BatchUpdateLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? mediaPayload = null,}) {
  return _then(_BatchUpdateLibraryItemRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,mediaPayload: null == mediaPayload ? _self.mediaPayload : mediaPayload // ignore: cast_nullable_to_non_nullable
as UpdateLibraryItemMediaRequest,
  ));
}

/// Create a copy of BatchUpdateLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLibraryItemMediaRequestCopyWith<$Res> get mediaPayload {
  
  return $UpdateLibraryItemMediaRequestCopyWith<$Res>(_self.mediaPayload, (value) {
    return _then(_self.copyWith(mediaPayload: value));
  });
}
}

// dart format on
