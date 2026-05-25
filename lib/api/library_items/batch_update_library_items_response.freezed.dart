// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_update_library_items_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchUpdateLibraryItemsResponse {

@JsonKey(name: 'success') bool get success;@JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic) int get updates;
/// Create a copy of BatchUpdateLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchUpdateLibraryItemsResponseCopyWith<BatchUpdateLibraryItemsResponse> get copyWith => _$BatchUpdateLibraryItemsResponseCopyWithImpl<BatchUpdateLibraryItemsResponse>(this as BatchUpdateLibraryItemsResponse, _$identity);

  /// Serializes this BatchUpdateLibraryItemsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchUpdateLibraryItemsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.updates, updates) || other.updates == updates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,updates);

@override
String toString() {
  return 'BatchUpdateLibraryItemsResponse(success: $success, updates: $updates)';
}


}

/// @nodoc
abstract mixin class $BatchUpdateLibraryItemsResponseCopyWith<$Res>  {
  factory $BatchUpdateLibraryItemsResponseCopyWith(BatchUpdateLibraryItemsResponse value, $Res Function(BatchUpdateLibraryItemsResponse) _then) = _$BatchUpdateLibraryItemsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic) int updates
});




}
/// @nodoc
class _$BatchUpdateLibraryItemsResponseCopyWithImpl<$Res>
    implements $BatchUpdateLibraryItemsResponseCopyWith<$Res> {
  _$BatchUpdateLibraryItemsResponseCopyWithImpl(this._self, this._then);

  final BatchUpdateLibraryItemsResponse _self;
  final $Res Function(BatchUpdateLibraryItemsResponse) _then;

/// Create a copy of BatchUpdateLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? updates = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchUpdateLibraryItemsResponse].
extension BatchUpdateLibraryItemsResponsePatterns on BatchUpdateLibraryItemsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchUpdateLibraryItemsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchUpdateLibraryItemsResponse value)  $default,){
final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchUpdateLibraryItemsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic)  int updates)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemsResponse() when $default != null:
return $default(_that.success,_that.updates);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic)  int updates)  $default,) {final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemsResponse():
return $default(_that.success,_that.updates);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic)  int updates)?  $default,) {final _that = this;
switch (_that) {
case _BatchUpdateLibraryItemsResponse() when $default != null:
return $default(_that.success,_that.updates);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchUpdateLibraryItemsResponse implements BatchUpdateLibraryItemsResponse {
  const _BatchUpdateLibraryItemsResponse({@JsonKey(name: 'success') this.success = false, @JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic) this.updates = 0});
  factory _BatchUpdateLibraryItemsResponse.fromJson(Map<String, dynamic> json) => _$BatchUpdateLibraryItemsResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool success;
@override@JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic) final  int updates;

/// Create a copy of BatchUpdateLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchUpdateLibraryItemsResponseCopyWith<_BatchUpdateLibraryItemsResponse> get copyWith => __$BatchUpdateLibraryItemsResponseCopyWithImpl<_BatchUpdateLibraryItemsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchUpdateLibraryItemsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchUpdateLibraryItemsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.updates, updates) || other.updates == updates));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,updates);

@override
String toString() {
  return 'BatchUpdateLibraryItemsResponse(success: $success, updates: $updates)';
}


}

/// @nodoc
abstract mixin class _$BatchUpdateLibraryItemsResponseCopyWith<$Res> implements $BatchUpdateLibraryItemsResponseCopyWith<$Res> {
  factory _$BatchUpdateLibraryItemsResponseCopyWith(_BatchUpdateLibraryItemsResponse value, $Res Function(_BatchUpdateLibraryItemsResponse) _then) = __$BatchUpdateLibraryItemsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'updates', fromJson: jsonIntRequiredFromDynamic) int updates
});




}
/// @nodoc
class __$BatchUpdateLibraryItemsResponseCopyWithImpl<$Res>
    implements _$BatchUpdateLibraryItemsResponseCopyWith<$Res> {
  __$BatchUpdateLibraryItemsResponseCopyWithImpl(this._self, this._then);

  final _BatchUpdateLibraryItemsResponse _self;
  final $Res Function(_BatchUpdateLibraryItemsResponse) _then;

/// Create a copy of BatchUpdateLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? updates = null,}) {
  return _then(_BatchUpdateLibraryItemsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
