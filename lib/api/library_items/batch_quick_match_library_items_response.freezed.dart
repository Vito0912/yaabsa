// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_quick_match_library_items_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchQuickMatchLibraryItemsResponse {

@JsonKey(name: 'success') bool get success;@JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic) int get updates;@JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic) int get unmatched;@JsonKey(name: 'message') String? get message;@JsonKey(name: 'error') String? get error;
/// Create a copy of BatchQuickMatchLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchQuickMatchLibraryItemsResponseCopyWith<BatchQuickMatchLibraryItemsResponse> get copyWith => _$BatchQuickMatchLibraryItemsResponseCopyWithImpl<BatchQuickMatchLibraryItemsResponse>(this as BatchQuickMatchLibraryItemsResponse, _$identity);

  /// Serializes this BatchQuickMatchLibraryItemsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchQuickMatchLibraryItemsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.unmatched, unmatched) || other.unmatched == unmatched)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,updates,unmatched,message,error);

@override
String toString() {
  return 'BatchQuickMatchLibraryItemsResponse(success: $success, updates: $updates, unmatched: $unmatched, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class $BatchQuickMatchLibraryItemsResponseCopyWith<$Res>  {
  factory $BatchQuickMatchLibraryItemsResponseCopyWith(BatchQuickMatchLibraryItemsResponse value, $Res Function(BatchQuickMatchLibraryItemsResponse) _then) = _$BatchQuickMatchLibraryItemsResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic) int updates,@JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic) int unmatched,@JsonKey(name: 'message') String? message,@JsonKey(name: 'error') String? error
});




}
/// @nodoc
class _$BatchQuickMatchLibraryItemsResponseCopyWithImpl<$Res>
    implements $BatchQuickMatchLibraryItemsResponseCopyWith<$Res> {
  _$BatchQuickMatchLibraryItemsResponseCopyWithImpl(this._self, this._then);

  final BatchQuickMatchLibraryItemsResponse _self;
  final $Res Function(BatchQuickMatchLibraryItemsResponse) _then;

/// Create a copy of BatchQuickMatchLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? updates = null,Object? unmatched = null,Object? message = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as int,unmatched: null == unmatched ? _self.unmatched : unmatched // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchQuickMatchLibraryItemsResponse].
extension BatchQuickMatchLibraryItemsResponsePatterns on BatchQuickMatchLibraryItemsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchQuickMatchLibraryItemsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchQuickMatchLibraryItemsResponse value)  $default,){
final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchQuickMatchLibraryItemsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic)  int updates, @JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic)  int unmatched, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'error')  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsResponse() when $default != null:
return $default(_that.success,_that.updates,_that.unmatched,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic)  int updates, @JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic)  int unmatched, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'error')  String? error)  $default,) {final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsResponse():
return $default(_that.success,_that.updates,_that.unmatched,_that.message,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'success')  bool success, @JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic)  int updates, @JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic)  int unmatched, @JsonKey(name: 'message')  String? message, @JsonKey(name: 'error')  String? error)?  $default,) {final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsResponse() when $default != null:
return $default(_that.success,_that.updates,_that.unmatched,_that.message,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchQuickMatchLibraryItemsResponse implements BatchQuickMatchLibraryItemsResponse {
  const _BatchQuickMatchLibraryItemsResponse({@JsonKey(name: 'success') this.success = false, @JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic) this.updates = 0, @JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic) this.unmatched = 0, @JsonKey(name: 'message') this.message, @JsonKey(name: 'error') this.error});
  factory _BatchQuickMatchLibraryItemsResponse.fromJson(Map<String, dynamic> json) => _$BatchQuickMatchLibraryItemsResponseFromJson(json);

@override@JsonKey(name: 'success') final  bool success;
@override@JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic) final  int updates;
@override@JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic) final  int unmatched;
@override@JsonKey(name: 'message') final  String? message;
@override@JsonKey(name: 'error') final  String? error;

/// Create a copy of BatchQuickMatchLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchQuickMatchLibraryItemsResponseCopyWith<_BatchQuickMatchLibraryItemsResponse> get copyWith => __$BatchQuickMatchLibraryItemsResponseCopyWithImpl<_BatchQuickMatchLibraryItemsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchQuickMatchLibraryItemsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchQuickMatchLibraryItemsResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.updates, updates) || other.updates == updates)&&(identical(other.unmatched, unmatched) || other.unmatched == unmatched)&&(identical(other.message, message) || other.message == message)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,updates,unmatched,message,error);

@override
String toString() {
  return 'BatchQuickMatchLibraryItemsResponse(success: $success, updates: $updates, unmatched: $unmatched, message: $message, error: $error)';
}


}

/// @nodoc
abstract mixin class _$BatchQuickMatchLibraryItemsResponseCopyWith<$Res> implements $BatchQuickMatchLibraryItemsResponseCopyWith<$Res> {
  factory _$BatchQuickMatchLibraryItemsResponseCopyWith(_BatchQuickMatchLibraryItemsResponse value, $Res Function(_BatchQuickMatchLibraryItemsResponse) _then) = __$BatchQuickMatchLibraryItemsResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'success') bool success,@JsonKey(name: 'updates')@JsonKey(fromJson: jsonIntFromDynamic) int updates,@JsonKey(name: 'unmatched')@JsonKey(fromJson: jsonIntFromDynamic) int unmatched,@JsonKey(name: 'message') String? message,@JsonKey(name: 'error') String? error
});




}
/// @nodoc
class __$BatchQuickMatchLibraryItemsResponseCopyWithImpl<$Res>
    implements _$BatchQuickMatchLibraryItemsResponseCopyWith<$Res> {
  __$BatchQuickMatchLibraryItemsResponseCopyWithImpl(this._self, this._then);

  final _BatchQuickMatchLibraryItemsResponse _self;
  final $Res Function(_BatchQuickMatchLibraryItemsResponse) _then;

/// Create a copy of BatchQuickMatchLibraryItemsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? updates = null,Object? unmatched = null,Object? message = freezed,Object? error = freezed,}) {
  return _then(_BatchQuickMatchLibraryItemsResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,updates: null == updates ? _self.updates : updates // ignore: cast_nullable_to_non_nullable
as int,unmatched: null == unmatched ? _self.unmatched : unmatched // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
