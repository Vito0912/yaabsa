// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryResponse {

@JsonKey(name: "libraries") List<Library> get libraries;
/// Create a copy of LibraryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryResponseCopyWith<LibraryResponse> get copyWith => _$LibraryResponseCopyWithImpl<LibraryResponse>(this as LibraryResponse, _$identity);

  /// Serializes this LibraryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryResponse&&const DeepCollectionEquality().equals(other.libraries, libraries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(libraries));

@override
String toString() {
  return 'LibraryResponse(libraries: $libraries)';
}


}

/// @nodoc
abstract mixin class $LibraryResponseCopyWith<$Res>  {
  factory $LibraryResponseCopyWith(LibraryResponse value, $Res Function(LibraryResponse) _then) = _$LibraryResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "libraries") List<Library> libraries
});




}
/// @nodoc
class _$LibraryResponseCopyWithImpl<$Res>
    implements $LibraryResponseCopyWith<$Res> {
  _$LibraryResponseCopyWithImpl(this._self, this._then);

  final LibraryResponse _self;
  final $Res Function(LibraryResponse) _then;

/// Create a copy of LibraryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? libraries = null,}) {
  return _then(_self.copyWith(
libraries: null == libraries ? _self.libraries : libraries // ignore: cast_nullable_to_non_nullable
as List<Library>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryResponse implements LibraryResponse {
  const _LibraryResponse({@JsonKey(name: "libraries") required final  List<Library> libraries}): _libraries = libraries;
  factory _LibraryResponse.fromJson(Map<String, dynamic> json) => _$LibraryResponseFromJson(json);

 final  List<Library> _libraries;
@override@JsonKey(name: "libraries") List<Library> get libraries {
  if (_libraries is EqualUnmodifiableListView) return _libraries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_libraries);
}


/// Create a copy of LibraryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryResponseCopyWith<_LibraryResponse> get copyWith => __$LibraryResponseCopyWithImpl<_LibraryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryResponse&&const DeepCollectionEquality().equals(other._libraries, _libraries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_libraries));

@override
String toString() {
  return 'LibraryResponse(libraries: $libraries)';
}


}

/// @nodoc
abstract mixin class _$LibraryResponseCopyWith<$Res> implements $LibraryResponseCopyWith<$Res> {
  factory _$LibraryResponseCopyWith(_LibraryResponse value, $Res Function(_LibraryResponse) _then) = __$LibraryResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "libraries") List<Library> libraries
});




}
/// @nodoc
class __$LibraryResponseCopyWithImpl<$Res>
    implements _$LibraryResponseCopyWith<$Res> {
  __$LibraryResponseCopyWithImpl(this._self, this._then);

  final _LibraryResponse _self;
  final $Res Function(_LibraryResponse) _then;

/// Create a copy of LibraryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? libraries = null,}) {
  return _then(_LibraryResponse(
libraries: null == libraries ? _self._libraries : libraries // ignore: cast_nullable_to_non_nullable
as List<Library>,
  ));
}


}

// dart format on
