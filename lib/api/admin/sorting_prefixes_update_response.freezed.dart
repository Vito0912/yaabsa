// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sorting_prefixes_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SortingPrefixesUpdateResponse {

@JsonKey(name: 'rowsUpdated') int get rowsUpdated;@JsonKey(name: 'serverSettings') ServerSettings get serverSettings;
/// Create a copy of SortingPrefixesUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SortingPrefixesUpdateResponseCopyWith<SortingPrefixesUpdateResponse> get copyWith => _$SortingPrefixesUpdateResponseCopyWithImpl<SortingPrefixesUpdateResponse>(this as SortingPrefixesUpdateResponse, _$identity);

  /// Serializes this SortingPrefixesUpdateResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SortingPrefixesUpdateResponse&&(identical(other.rowsUpdated, rowsUpdated) || other.rowsUpdated == rowsUpdated)&&(identical(other.serverSettings, serverSettings) || other.serverSettings == serverSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rowsUpdated,serverSettings);

@override
String toString() {
  return 'SortingPrefixesUpdateResponse(rowsUpdated: $rowsUpdated, serverSettings: $serverSettings)';
}


}

/// @nodoc
abstract mixin class $SortingPrefixesUpdateResponseCopyWith<$Res>  {
  factory $SortingPrefixesUpdateResponseCopyWith(SortingPrefixesUpdateResponse value, $Res Function(SortingPrefixesUpdateResponse) _then) = _$SortingPrefixesUpdateResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'rowsUpdated') int rowsUpdated,@JsonKey(name: 'serverSettings') ServerSettings serverSettings
});


$ServerSettingsCopyWith<$Res> get serverSettings;

}
/// @nodoc
class _$SortingPrefixesUpdateResponseCopyWithImpl<$Res>
    implements $SortingPrefixesUpdateResponseCopyWith<$Res> {
  _$SortingPrefixesUpdateResponseCopyWithImpl(this._self, this._then);

  final SortingPrefixesUpdateResponse _self;
  final $Res Function(SortingPrefixesUpdateResponse) _then;

/// Create a copy of SortingPrefixesUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rowsUpdated = null,Object? serverSettings = null,}) {
  return _then(_self.copyWith(
rowsUpdated: null == rowsUpdated ? _self.rowsUpdated : rowsUpdated // ignore: cast_nullable_to_non_nullable
as int,serverSettings: null == serverSettings ? _self.serverSettings : serverSettings // ignore: cast_nullable_to_non_nullable
as ServerSettings,
  ));
}
/// Create a copy of SortingPrefixesUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res> get serverSettings {
  
  return $ServerSettingsCopyWith<$Res>(_self.serverSettings, (value) {
    return _then(_self.copyWith(serverSettings: value));
  });
}
}


/// Adds pattern-matching-related methods to [SortingPrefixesUpdateResponse].
extension SortingPrefixesUpdateResponsePatterns on SortingPrefixesUpdateResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SortingPrefixesUpdateResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SortingPrefixesUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SortingPrefixesUpdateResponse value)  $default,){
final _that = this;
switch (_that) {
case _SortingPrefixesUpdateResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SortingPrefixesUpdateResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SortingPrefixesUpdateResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'rowsUpdated')  int rowsUpdated, @JsonKey(name: 'serverSettings')  ServerSettings serverSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SortingPrefixesUpdateResponse() when $default != null:
return $default(_that.rowsUpdated,_that.serverSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'rowsUpdated')  int rowsUpdated, @JsonKey(name: 'serverSettings')  ServerSettings serverSettings)  $default,) {final _that = this;
switch (_that) {
case _SortingPrefixesUpdateResponse():
return $default(_that.rowsUpdated,_that.serverSettings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'rowsUpdated')  int rowsUpdated, @JsonKey(name: 'serverSettings')  ServerSettings serverSettings)?  $default,) {final _that = this;
switch (_that) {
case _SortingPrefixesUpdateResponse() when $default != null:
return $default(_that.rowsUpdated,_that.serverSettings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SortingPrefixesUpdateResponse implements SortingPrefixesUpdateResponse {
  const _SortingPrefixesUpdateResponse({@JsonKey(name: 'rowsUpdated') required this.rowsUpdated, @JsonKey(name: 'serverSettings') required this.serverSettings});
  factory _SortingPrefixesUpdateResponse.fromJson(Map<String, dynamic> json) => _$SortingPrefixesUpdateResponseFromJson(json);

@override@JsonKey(name: 'rowsUpdated') final  int rowsUpdated;
@override@JsonKey(name: 'serverSettings') final  ServerSettings serverSettings;

/// Create a copy of SortingPrefixesUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SortingPrefixesUpdateResponseCopyWith<_SortingPrefixesUpdateResponse> get copyWith => __$SortingPrefixesUpdateResponseCopyWithImpl<_SortingPrefixesUpdateResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SortingPrefixesUpdateResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SortingPrefixesUpdateResponse&&(identical(other.rowsUpdated, rowsUpdated) || other.rowsUpdated == rowsUpdated)&&(identical(other.serverSettings, serverSettings) || other.serverSettings == serverSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rowsUpdated,serverSettings);

@override
String toString() {
  return 'SortingPrefixesUpdateResponse(rowsUpdated: $rowsUpdated, serverSettings: $serverSettings)';
}


}

/// @nodoc
abstract mixin class _$SortingPrefixesUpdateResponseCopyWith<$Res> implements $SortingPrefixesUpdateResponseCopyWith<$Res> {
  factory _$SortingPrefixesUpdateResponseCopyWith(_SortingPrefixesUpdateResponse value, $Res Function(_SortingPrefixesUpdateResponse) _then) = __$SortingPrefixesUpdateResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'rowsUpdated') int rowsUpdated,@JsonKey(name: 'serverSettings') ServerSettings serverSettings
});


@override $ServerSettingsCopyWith<$Res> get serverSettings;

}
/// @nodoc
class __$SortingPrefixesUpdateResponseCopyWithImpl<$Res>
    implements _$SortingPrefixesUpdateResponseCopyWith<$Res> {
  __$SortingPrefixesUpdateResponseCopyWithImpl(this._self, this._then);

  final _SortingPrefixesUpdateResponse _self;
  final $Res Function(_SortingPrefixesUpdateResponse) _then;

/// Create a copy of SortingPrefixesUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rowsUpdated = null,Object? serverSettings = null,}) {
  return _then(_SortingPrefixesUpdateResponse(
rowsUpdated: null == rowsUpdated ? _self.rowsUpdated : rowsUpdated // ignore: cast_nullable_to_non_nullable
as int,serverSettings: null == serverSettings ? _self.serverSettings : serverSettings // ignore: cast_nullable_to_non_nullable
as ServerSettings,
  ));
}

/// Create a copy of SortingPrefixesUpdateResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSettingsCopyWith<$Res> get serverSettings {
  
  return $ServerSettingsCopyWith<$Res>(_self.serverSettings, (value) {
    return _then(_self.copyWith(serverSettings: value));
  });
}
}

// dart format on
