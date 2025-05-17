// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'items_listened_to.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemsListenedTo {

@JsonKey(name: "id") String? get id;@JsonKey(name: "timeListening") double? get timeListening;@JsonKey(name: "mediaMetadata") Metadata? get mediaMetadata;
/// Create a copy of ItemsListenedTo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemsListenedToCopyWith<ItemsListenedTo> get copyWith => _$ItemsListenedToCopyWithImpl<ItemsListenedTo>(this as ItemsListenedTo, _$identity);

  /// Serializes this ItemsListenedTo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemsListenedTo&&(identical(other.id, id) || other.id == id)&&(identical(other.timeListening, timeListening) || other.timeListening == timeListening)&&(identical(other.mediaMetadata, mediaMetadata) || other.mediaMetadata == mediaMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timeListening,mediaMetadata);

@override
String toString() {
  return 'ItemsListenedTo(id: $id, timeListening: $timeListening, mediaMetadata: $mediaMetadata)';
}


}

/// @nodoc
abstract mixin class $ItemsListenedToCopyWith<$Res>  {
  factory $ItemsListenedToCopyWith(ItemsListenedTo value, $Res Function(ItemsListenedTo) _then) = _$ItemsListenedToCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String? id,@JsonKey(name: "timeListening") double? timeListening,@JsonKey(name: "mediaMetadata") Metadata? mediaMetadata
});


$MetadataCopyWith<$Res>? get mediaMetadata;

}
/// @nodoc
class _$ItemsListenedToCopyWithImpl<$Res>
    implements $ItemsListenedToCopyWith<$Res> {
  _$ItemsListenedToCopyWithImpl(this._self, this._then);

  final ItemsListenedTo _self;
  final $Res Function(ItemsListenedTo) _then;

/// Create a copy of ItemsListenedTo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? timeListening = freezed,Object? mediaMetadata = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,timeListening: freezed == timeListening ? _self.timeListening : timeListening // ignore: cast_nullable_to_non_nullable
as double?,mediaMetadata: freezed == mediaMetadata ? _self.mediaMetadata : mediaMetadata // ignore: cast_nullable_to_non_nullable
as Metadata?,
  ));
}
/// Create a copy of ItemsListenedTo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get mediaMetadata {
    if (_self.mediaMetadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.mediaMetadata!, (value) {
    return _then(_self.copyWith(mediaMetadata: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ItemsListenedTo implements ItemsListenedTo {
  const _ItemsListenedTo({@JsonKey(name: "id") this.id, @JsonKey(name: "timeListening") this.timeListening, @JsonKey(name: "mediaMetadata") this.mediaMetadata});
  factory _ItemsListenedTo.fromJson(Map<String, dynamic> json) => _$ItemsListenedToFromJson(json);

@override@JsonKey(name: "id") final  String? id;
@override@JsonKey(name: "timeListening") final  double? timeListening;
@override@JsonKey(name: "mediaMetadata") final  Metadata? mediaMetadata;

/// Create a copy of ItemsListenedTo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemsListenedToCopyWith<_ItemsListenedTo> get copyWith => __$ItemsListenedToCopyWithImpl<_ItemsListenedTo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ItemsListenedToToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemsListenedTo&&(identical(other.id, id) || other.id == id)&&(identical(other.timeListening, timeListening) || other.timeListening == timeListening)&&(identical(other.mediaMetadata, mediaMetadata) || other.mediaMetadata == mediaMetadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timeListening,mediaMetadata);

@override
String toString() {
  return 'ItemsListenedTo(id: $id, timeListening: $timeListening, mediaMetadata: $mediaMetadata)';
}


}

/// @nodoc
abstract mixin class _$ItemsListenedToCopyWith<$Res> implements $ItemsListenedToCopyWith<$Res> {
  factory _$ItemsListenedToCopyWith(_ItemsListenedTo value, $Res Function(_ItemsListenedTo) _then) = __$ItemsListenedToCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String? id,@JsonKey(name: "timeListening") double? timeListening,@JsonKey(name: "mediaMetadata") Metadata? mediaMetadata
});


@override $MetadataCopyWith<$Res>? get mediaMetadata;

}
/// @nodoc
class __$ItemsListenedToCopyWithImpl<$Res>
    implements _$ItemsListenedToCopyWith<$Res> {
  __$ItemsListenedToCopyWithImpl(this._self, this._then);

  final _ItemsListenedTo _self;
  final $Res Function(_ItemsListenedTo) _then;

/// Create a copy of ItemsListenedTo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? timeListening = freezed,Object? mediaMetadata = freezed,}) {
  return _then(_ItemsListenedTo(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,timeListening: freezed == timeListening ? _self.timeListening : timeListening // ignore: cast_nullable_to_non_nullable
as double?,mediaMetadata: freezed == mediaMetadata ? _self.mediaMetadata : mediaMetadata // ignore: cast_nullable_to_non_nullable
as Metadata?,
  ));
}

/// Create a copy of ItemsListenedTo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get mediaMetadata {
    if (_self.mediaMetadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.mediaMetadata!, (value) {
    return _then(_self.copyWith(mediaMetadata: value));
  });
}
}

// dart format on
