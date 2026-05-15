// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'batch_quick_match_library_items_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatchQuickMatchLibraryItemsRequest {

@JsonKey(name: 'libraryItemIds') List<String> get libraryItemIds;@JsonKey(name: 'options') QuickMatchLibraryItemOptions get options;
/// Create a copy of BatchQuickMatchLibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchQuickMatchLibraryItemsRequestCopyWith<BatchQuickMatchLibraryItemsRequest> get copyWith => _$BatchQuickMatchLibraryItemsRequestCopyWithImpl<BatchQuickMatchLibraryItemsRequest>(this as BatchQuickMatchLibraryItemsRequest, _$identity);

  /// Serializes this BatchQuickMatchLibraryItemsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchQuickMatchLibraryItemsRequest&&const DeepCollectionEquality().equals(other.libraryItemIds, libraryItemIds)&&(identical(other.options, options) || other.options == options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(libraryItemIds),options);

@override
String toString() {
  return 'BatchQuickMatchLibraryItemsRequest(libraryItemIds: $libraryItemIds, options: $options)';
}


}

/// @nodoc
abstract mixin class $BatchQuickMatchLibraryItemsRequestCopyWith<$Res>  {
  factory $BatchQuickMatchLibraryItemsRequestCopyWith(BatchQuickMatchLibraryItemsRequest value, $Res Function(BatchQuickMatchLibraryItemsRequest) _then) = _$BatchQuickMatchLibraryItemsRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'libraryItemIds') List<String> libraryItemIds,@JsonKey(name: 'options') QuickMatchLibraryItemOptions options
});


$QuickMatchLibraryItemOptionsCopyWith<$Res> get options;

}
/// @nodoc
class _$BatchQuickMatchLibraryItemsRequestCopyWithImpl<$Res>
    implements $BatchQuickMatchLibraryItemsRequestCopyWith<$Res> {
  _$BatchQuickMatchLibraryItemsRequestCopyWithImpl(this._self, this._then);

  final BatchQuickMatchLibraryItemsRequest _self;
  final $Res Function(BatchQuickMatchLibraryItemsRequest) _then;

/// Create a copy of BatchQuickMatchLibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraryItemIds = null,Object? options = null,}) {
  return _then(_self.copyWith(
libraryItemIds: null == libraryItemIds ? _self.libraryItemIds : libraryItemIds // ignore: cast_nullable_to_non_nullable
as List<String>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as QuickMatchLibraryItemOptions,
  ));
}
/// Create a copy of BatchQuickMatchLibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickMatchLibraryItemOptionsCopyWith<$Res> get options {
  
  return $QuickMatchLibraryItemOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}


/// Adds pattern-matching-related methods to [BatchQuickMatchLibraryItemsRequest].
extension BatchQuickMatchLibraryItemsRequestPatterns on BatchQuickMatchLibraryItemsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchQuickMatchLibraryItemsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchQuickMatchLibraryItemsRequest value)  $default,){
final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchQuickMatchLibraryItemsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItemIds')  List<String> libraryItemIds, @JsonKey(name: 'options')  QuickMatchLibraryItemOptions options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsRequest() when $default != null:
return $default(_that.libraryItemIds,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'libraryItemIds')  List<String> libraryItemIds, @JsonKey(name: 'options')  QuickMatchLibraryItemOptions options)  $default,) {final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsRequest():
return $default(_that.libraryItemIds,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'libraryItemIds')  List<String> libraryItemIds, @JsonKey(name: 'options')  QuickMatchLibraryItemOptions options)?  $default,) {final _that = this;
switch (_that) {
case _BatchQuickMatchLibraryItemsRequest() when $default != null:
return $default(_that.libraryItemIds,_that.options);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class _BatchQuickMatchLibraryItemsRequest implements BatchQuickMatchLibraryItemsRequest {
  const _BatchQuickMatchLibraryItemsRequest({@JsonKey(name: 'libraryItemIds') required final  List<String> libraryItemIds, @JsonKey(name: 'options') required this.options}): _libraryItemIds = libraryItemIds;
  factory _BatchQuickMatchLibraryItemsRequest.fromJson(Map<String, dynamic> json) => _$BatchQuickMatchLibraryItemsRequestFromJson(json);

 final  List<String> _libraryItemIds;
@override@JsonKey(name: 'libraryItemIds') List<String> get libraryItemIds {
  if (_libraryItemIds is EqualUnmodifiableListView) return _libraryItemIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_libraryItemIds);
}

@override@JsonKey(name: 'options') final  QuickMatchLibraryItemOptions options;

/// Create a copy of BatchQuickMatchLibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchQuickMatchLibraryItemsRequestCopyWith<_BatchQuickMatchLibraryItemsRequest> get copyWith => __$BatchQuickMatchLibraryItemsRequestCopyWithImpl<_BatchQuickMatchLibraryItemsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchQuickMatchLibraryItemsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchQuickMatchLibraryItemsRequest&&const DeepCollectionEquality().equals(other._libraryItemIds, _libraryItemIds)&&(identical(other.options, options) || other.options == options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_libraryItemIds),options);

@override
String toString() {
  return 'BatchQuickMatchLibraryItemsRequest(libraryItemIds: $libraryItemIds, options: $options)';
}


}

/// @nodoc
abstract mixin class _$BatchQuickMatchLibraryItemsRequestCopyWith<$Res> implements $BatchQuickMatchLibraryItemsRequestCopyWith<$Res> {
  factory _$BatchQuickMatchLibraryItemsRequestCopyWith(_BatchQuickMatchLibraryItemsRequest value, $Res Function(_BatchQuickMatchLibraryItemsRequest) _then) = __$BatchQuickMatchLibraryItemsRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'libraryItemIds') List<String> libraryItemIds,@JsonKey(name: 'options') QuickMatchLibraryItemOptions options
});


@override $QuickMatchLibraryItemOptionsCopyWith<$Res> get options;

}
/// @nodoc
class __$BatchQuickMatchLibraryItemsRequestCopyWithImpl<$Res>
    implements _$BatchQuickMatchLibraryItemsRequestCopyWith<$Res> {
  __$BatchQuickMatchLibraryItemsRequestCopyWithImpl(this._self, this._then);

  final _BatchQuickMatchLibraryItemsRequest _self;
  final $Res Function(_BatchQuickMatchLibraryItemsRequest) _then;

/// Create a copy of BatchQuickMatchLibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraryItemIds = null,Object? options = null,}) {
  return _then(_BatchQuickMatchLibraryItemsRequest(
libraryItemIds: null == libraryItemIds ? _self._libraryItemIds : libraryItemIds // ignore: cast_nullable_to_non_nullable
as List<String>,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as QuickMatchLibraryItemOptions,
  ));
}

/// Create a copy of BatchQuickMatchLibraryItemsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuickMatchLibraryItemOptionsCopyWith<$Res> get options {
  
  return $QuickMatchLibraryItemOptionsCopyWith<$Res>(_self.options, (value) {
    return _then(_self.copyWith(options: value));
  });
}
}

// dart format on
