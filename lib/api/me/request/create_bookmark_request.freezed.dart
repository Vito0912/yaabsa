// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_bookmark_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateBookmarkRequest {

@JsonKey(name: "time") int get time;@JsonKey(name: "title") String get title;
/// Create a copy of CreateBookmarkRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateBookmarkRequestCopyWith<CreateBookmarkRequest> get copyWith => _$CreateBookmarkRequestCopyWithImpl<CreateBookmarkRequest>(this as CreateBookmarkRequest, _$identity);

  /// Serializes this CreateBookmarkRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateBookmarkRequest&&(identical(other.time, time) || other.time == time)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,title);

@override
String toString() {
  return 'CreateBookmarkRequest(time: $time, title: $title)';
}


}

/// @nodoc
abstract mixin class $CreateBookmarkRequestCopyWith<$Res>  {
  factory $CreateBookmarkRequestCopyWith(CreateBookmarkRequest value, $Res Function(CreateBookmarkRequest) _then) = _$CreateBookmarkRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "time") int time,@JsonKey(name: "title") String title
});




}
/// @nodoc
class _$CreateBookmarkRequestCopyWithImpl<$Res>
    implements $CreateBookmarkRequestCopyWith<$Res> {
  _$CreateBookmarkRequestCopyWithImpl(this._self, this._then);

  final CreateBookmarkRequest _self;
  final $Res Function(CreateBookmarkRequest) _then;

/// Create a copy of CreateBookmarkRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? title = null,}) {
  return _then(_self.copyWith(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CreateBookmarkRequest implements CreateBookmarkRequest {
  const _CreateBookmarkRequest({@JsonKey(name: "time") required this.time, @JsonKey(name: "title") required this.title});
  factory _CreateBookmarkRequest.fromJson(Map<String, dynamic> json) => _$CreateBookmarkRequestFromJson(json);

@override@JsonKey(name: "time") final  int time;
@override@JsonKey(name: "title") final  String title;

/// Create a copy of CreateBookmarkRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateBookmarkRequestCopyWith<_CreateBookmarkRequest> get copyWith => __$CreateBookmarkRequestCopyWithImpl<_CreateBookmarkRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateBookmarkRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateBookmarkRequest&&(identical(other.time, time) || other.time == time)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,time,title);

@override
String toString() {
  return 'CreateBookmarkRequest(time: $time, title: $title)';
}


}

/// @nodoc
abstract mixin class _$CreateBookmarkRequestCopyWith<$Res> implements $CreateBookmarkRequestCopyWith<$Res> {
  factory _$CreateBookmarkRequestCopyWith(_CreateBookmarkRequest value, $Res Function(_CreateBookmarkRequest) _then) = __$CreateBookmarkRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "time") int time,@JsonKey(name: "title") String title
});




}
/// @nodoc
class __$CreateBookmarkRequestCopyWithImpl<$Res>
    implements _$CreateBookmarkRequestCopyWith<$Res> {
  __$CreateBookmarkRequestCopyWithImpl(this._self, this._then);

  final _CreateBookmarkRequest _self;
  final $Res Function(_CreateBookmarkRequest) _then;

/// Create a copy of CreateBookmarkRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? title = null,}) {
  return _then(_CreateBookmarkRequest(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
