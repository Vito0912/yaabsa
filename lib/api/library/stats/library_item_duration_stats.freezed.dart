// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_duration_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItemDurationStats {

@JsonKey(name: "id") String get id;@JsonKey(name: "duration") double get duration;@JsonKey(name: "title") String get title;
/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemDurationStatsCopyWith<LibraryItemDurationStats> get copyWith => _$LibraryItemDurationStatsCopyWithImpl<LibraryItemDurationStats>(this as LibraryItemDurationStats, _$identity);

  /// Serializes this LibraryItemDurationStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemDurationStats&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,duration,title);

@override
String toString() {
  return 'LibraryItemDurationStats(id: $id, duration: $duration, title: $title)';
}


}

/// @nodoc
abstract mixin class $LibraryItemDurationStatsCopyWith<$Res>  {
  factory $LibraryItemDurationStatsCopyWith(LibraryItemDurationStats value, $Res Function(LibraryItemDurationStats) _then) = _$LibraryItemDurationStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "duration") double duration,@JsonKey(name: "title") String title
});




}
/// @nodoc
class _$LibraryItemDurationStatsCopyWithImpl<$Res>
    implements $LibraryItemDurationStatsCopyWith<$Res> {
  _$LibraryItemDurationStatsCopyWithImpl(this._self, this._then);

  final LibraryItemDurationStats _self;
  final $Res Function(LibraryItemDurationStats) _then;

/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? duration = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryItemDurationStats implements LibraryItemDurationStats {
  const _LibraryItemDurationStats({@JsonKey(name: "id") required this.id, @JsonKey(name: "duration") required this.duration, @JsonKey(name: "title") required this.title});
  factory _LibraryItemDurationStats.fromJson(Map<String, dynamic> json) => _$LibraryItemDurationStatsFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "duration") final  double duration;
@override@JsonKey(name: "title") final  String title;

/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemDurationStatsCopyWith<_LibraryItemDurationStats> get copyWith => __$LibraryItemDurationStatsCopyWithImpl<_LibraryItemDurationStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemDurationStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemDurationStats&&(identical(other.id, id) || other.id == id)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,duration,title);

@override
String toString() {
  return 'LibraryItemDurationStats(id: $id, duration: $duration, title: $title)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemDurationStatsCopyWith<$Res> implements $LibraryItemDurationStatsCopyWith<$Res> {
  factory _$LibraryItemDurationStatsCopyWith(_LibraryItemDurationStats value, $Res Function(_LibraryItemDurationStats) _then) = __$LibraryItemDurationStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "duration") double duration,@JsonKey(name: "title") String title
});




}
/// @nodoc
class __$LibraryItemDurationStatsCopyWithImpl<$Res>
    implements _$LibraryItemDurationStatsCopyWith<$Res> {
  __$LibraryItemDurationStatsCopyWithImpl(this._self, this._then);

  final _LibraryItemDurationStats _self;
  final $Res Function(_LibraryItemDurationStats) _then;

/// Create a copy of LibraryItemDurationStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? duration = null,Object? title = null,}) {
  return _then(_LibraryItemDurationStats(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
