// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_library_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayLibraryItemRequest {

@JsonKey(name: "deviceInfo") DeviceInfo get deviceInfo;@JsonKey(name: "forceDirectPlay") bool? get forceDirectPlay;@JsonKey(name: "forceTranscode") bool? get forceTranscode;@JsonKey(name: "supportedMimeTypes") List<String>? get supportedMimeTypes;@JsonKey(name: "mediaPlayer") String get mediaPlayer;
/// Create a copy of PlayLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayLibraryItemRequestCopyWith<PlayLibraryItemRequest> get copyWith => _$PlayLibraryItemRequestCopyWithImpl<PlayLibraryItemRequest>(this as PlayLibraryItemRequest, _$identity);

  /// Serializes this PlayLibraryItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayLibraryItemRequest&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.forceDirectPlay, forceDirectPlay) || other.forceDirectPlay == forceDirectPlay)&&(identical(other.forceTranscode, forceTranscode) || other.forceTranscode == forceTranscode)&&const DeepCollectionEquality().equals(other.supportedMimeTypes, supportedMimeTypes)&&(identical(other.mediaPlayer, mediaPlayer) || other.mediaPlayer == mediaPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceInfo,forceDirectPlay,forceTranscode,const DeepCollectionEquality().hash(supportedMimeTypes),mediaPlayer);

@override
String toString() {
  return 'PlayLibraryItemRequest(deviceInfo: $deviceInfo, forceDirectPlay: $forceDirectPlay, forceTranscode: $forceTranscode, supportedMimeTypes: $supportedMimeTypes, mediaPlayer: $mediaPlayer)';
}


}

/// @nodoc
abstract mixin class $PlayLibraryItemRequestCopyWith<$Res>  {
  factory $PlayLibraryItemRequestCopyWith(PlayLibraryItemRequest value, $Res Function(PlayLibraryItemRequest) _then) = _$PlayLibraryItemRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "deviceInfo") DeviceInfo deviceInfo,@JsonKey(name: "forceDirectPlay") bool? forceDirectPlay,@JsonKey(name: "forceTranscode") bool? forceTranscode,@JsonKey(name: "supportedMimeTypes") List<String>? supportedMimeTypes,@JsonKey(name: "mediaPlayer") String mediaPlayer
});


$DeviceInfoCopyWith<$Res> get deviceInfo;

}
/// @nodoc
class _$PlayLibraryItemRequestCopyWithImpl<$Res>
    implements $PlayLibraryItemRequestCopyWith<$Res> {
  _$PlayLibraryItemRequestCopyWithImpl(this._self, this._then);

  final PlayLibraryItemRequest _self;
  final $Res Function(PlayLibraryItemRequest) _then;

/// Create a copy of PlayLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceInfo = null,Object? forceDirectPlay = freezed,Object? forceTranscode = freezed,Object? supportedMimeTypes = freezed,Object? mediaPlayer = null,}) {
  return _then(_self.copyWith(
deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as DeviceInfo,forceDirectPlay: freezed == forceDirectPlay ? _self.forceDirectPlay : forceDirectPlay // ignore: cast_nullable_to_non_nullable
as bool?,forceTranscode: freezed == forceTranscode ? _self.forceTranscode : forceTranscode // ignore: cast_nullable_to_non_nullable
as bool?,supportedMimeTypes: freezed == supportedMimeTypes ? _self.supportedMimeTypes : supportedMimeTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,mediaPlayer: null == mediaPlayer ? _self.mediaPlayer : mediaPlayer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of PlayLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get deviceInfo {
  
  return $DeviceInfoCopyWith<$Res>(_self.deviceInfo, (value) {
    return _then(_self.copyWith(deviceInfo: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _PlayLibraryItemRequest implements PlayLibraryItemRequest {
  const _PlayLibraryItemRequest({@JsonKey(name: "deviceInfo") required this.deviceInfo, @JsonKey(name: "forceDirectPlay") this.forceDirectPlay = false, @JsonKey(name: "forceTranscode") this.forceTranscode = false, @JsonKey(name: "supportedMimeTypes") final  List<String>? supportedMimeTypes = const [], @JsonKey(name: "mediaPlayer") required this.mediaPlayer}): _supportedMimeTypes = supportedMimeTypes;
  factory _PlayLibraryItemRequest.fromJson(Map<String, dynamic> json) => _$PlayLibraryItemRequestFromJson(json);

@override@JsonKey(name: "deviceInfo") final  DeviceInfo deviceInfo;
@override@JsonKey(name: "forceDirectPlay") final  bool? forceDirectPlay;
@override@JsonKey(name: "forceTranscode") final  bool? forceTranscode;
 final  List<String>? _supportedMimeTypes;
@override@JsonKey(name: "supportedMimeTypes") List<String>? get supportedMimeTypes {
  final value = _supportedMimeTypes;
  if (value == null) return null;
  if (_supportedMimeTypes is EqualUnmodifiableListView) return _supportedMimeTypes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "mediaPlayer") final  String mediaPlayer;

/// Create a copy of PlayLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayLibraryItemRequestCopyWith<_PlayLibraryItemRequest> get copyWith => __$PlayLibraryItemRequestCopyWithImpl<_PlayLibraryItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayLibraryItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayLibraryItemRequest&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.forceDirectPlay, forceDirectPlay) || other.forceDirectPlay == forceDirectPlay)&&(identical(other.forceTranscode, forceTranscode) || other.forceTranscode == forceTranscode)&&const DeepCollectionEquality().equals(other._supportedMimeTypes, _supportedMimeTypes)&&(identical(other.mediaPlayer, mediaPlayer) || other.mediaPlayer == mediaPlayer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceInfo,forceDirectPlay,forceTranscode,const DeepCollectionEquality().hash(_supportedMimeTypes),mediaPlayer);

@override
String toString() {
  return 'PlayLibraryItemRequest(deviceInfo: $deviceInfo, forceDirectPlay: $forceDirectPlay, forceTranscode: $forceTranscode, supportedMimeTypes: $supportedMimeTypes, mediaPlayer: $mediaPlayer)';
}


}

/// @nodoc
abstract mixin class _$PlayLibraryItemRequestCopyWith<$Res> implements $PlayLibraryItemRequestCopyWith<$Res> {
  factory _$PlayLibraryItemRequestCopyWith(_PlayLibraryItemRequest value, $Res Function(_PlayLibraryItemRequest) _then) = __$PlayLibraryItemRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "deviceInfo") DeviceInfo deviceInfo,@JsonKey(name: "forceDirectPlay") bool? forceDirectPlay,@JsonKey(name: "forceTranscode") bool? forceTranscode,@JsonKey(name: "supportedMimeTypes") List<String>? supportedMimeTypes,@JsonKey(name: "mediaPlayer") String mediaPlayer
});


@override $DeviceInfoCopyWith<$Res> get deviceInfo;

}
/// @nodoc
class __$PlayLibraryItemRequestCopyWithImpl<$Res>
    implements _$PlayLibraryItemRequestCopyWith<$Res> {
  __$PlayLibraryItemRequestCopyWithImpl(this._self, this._then);

  final _PlayLibraryItemRequest _self;
  final $Res Function(_PlayLibraryItemRequest) _then;

/// Create a copy of PlayLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceInfo = null,Object? forceDirectPlay = freezed,Object? forceTranscode = freezed,Object? supportedMimeTypes = freezed,Object? mediaPlayer = null,}) {
  return _then(_PlayLibraryItemRequest(
deviceInfo: null == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as DeviceInfo,forceDirectPlay: freezed == forceDirectPlay ? _self.forceDirectPlay : forceDirectPlay // ignore: cast_nullable_to_non_nullable
as bool?,forceTranscode: freezed == forceTranscode ? _self.forceTranscode : forceTranscode // ignore: cast_nullable_to_non_nullable
as bool?,supportedMimeTypes: freezed == supportedMimeTypes ? _self._supportedMimeTypes : supportedMimeTypes // ignore: cast_nullable_to_non_nullable
as List<String>?,mediaPlayer: null == mediaPlayer ? _self.mediaPlayer : mediaPlayer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of PlayLibraryItemRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res> get deviceInfo {
  
  return $DeviceInfoCopyWith<$Res>(_self.deviceInfo, (value) {
    return _then(_self.copyWith(deviceInfo: value));
  });
}
}

// dart format on
