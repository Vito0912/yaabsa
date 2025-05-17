// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItemRequest {

@JsonKey(name: "id") String get id;@JsonKey(name: "expanded") int? get expanded;@JsonKey(name: "include") String? get include;@JsonKey(name: "episode") String? get episode;
/// Create a copy of LibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemRequestCopyWith<LibraryItemRequest> get copyWith => _$LibraryItemRequestCopyWithImpl<LibraryItemRequest>(this as LibraryItemRequest, _$identity);

  /// Serializes this LibraryItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.expanded, expanded) || other.expanded == expanded)&&(identical(other.include, include) || other.include == include)&&(identical(other.episode, episode) || other.episode == episode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expanded,include,episode);

@override
String toString() {
  return 'LibraryItemRequest(id: $id, expanded: $expanded, include: $include, episode: $episode)';
}


}

/// @nodoc
abstract mixin class $LibraryItemRequestCopyWith<$Res>  {
  factory $LibraryItemRequestCopyWith(LibraryItemRequest value, $Res Function(LibraryItemRequest) _then) = _$LibraryItemRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "expanded") int? expanded,@JsonKey(name: "include") String? include,@JsonKey(name: "episode") String? episode
});




}
/// @nodoc
class _$LibraryItemRequestCopyWithImpl<$Res>
    implements $LibraryItemRequestCopyWith<$Res> {
  _$LibraryItemRequestCopyWithImpl(this._self, this._then);

  final LibraryItemRequest _self;
  final $Res Function(LibraryItemRequest) _then;

/// Create a copy of LibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? expanded = freezed,Object? include = freezed,Object? episode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expanded: freezed == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as int?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryItemRequest implements LibraryItemRequest {
  const _LibraryItemRequest({@JsonKey(name: "id") required this.id, @JsonKey(name: "expanded") this.expanded, @JsonKey(name: "include") this.include, @JsonKey(name: "episode") this.episode});
  factory _LibraryItemRequest.fromJson(Map<String, dynamic> json) => _$LibraryItemRequestFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "expanded") final  int? expanded;
@override@JsonKey(name: "include") final  String? include;
@override@JsonKey(name: "episode") final  String? episode;

/// Create a copy of LibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemRequestCopyWith<_LibraryItemRequest> get copyWith => __$LibraryItemRequestCopyWithImpl<_LibraryItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.expanded, expanded) || other.expanded == expanded)&&(identical(other.include, include) || other.include == include)&&(identical(other.episode, episode) || other.episode == episode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,expanded,include,episode);

@override
String toString() {
  return 'LibraryItemRequest(id: $id, expanded: $expanded, include: $include, episode: $episode)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemRequestCopyWith<$Res> implements $LibraryItemRequestCopyWith<$Res> {
  factory _$LibraryItemRequestCopyWith(_LibraryItemRequest value, $Res Function(_LibraryItemRequest) _then) = __$LibraryItemRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "expanded") int? expanded,@JsonKey(name: "include") String? include,@JsonKey(name: "episode") String? episode
});




}
/// @nodoc
class __$LibraryItemRequestCopyWithImpl<$Res>
    implements _$LibraryItemRequestCopyWith<$Res> {
  __$LibraryItemRequestCopyWithImpl(this._self, this._then);

  final _LibraryItemRequest _self;
  final $Res Function(_LibraryItemRequest) _then;

/// Create a copy of LibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? expanded = freezed,Object? include = freezed,Object? episode = freezed,}) {
  return _then(_LibraryItemRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,expanded: freezed == expanded ? _self.expanded : expanded // ignore: cast_nullable_to_non_nullable
as int?,include: freezed == include ? _self.include : include // ignore: cast_nullable_to_non_nullable
as String?,episode: freezed == episode ? _self.episode : episode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
