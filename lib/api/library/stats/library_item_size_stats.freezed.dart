// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_size_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryItemSizeStats {

@JsonKey(name: "id") String get id;@JsonKey(name: "size") int get size;@JsonKey(name: "title") String get title;
/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemSizeStatsCopyWith<LibraryItemSizeStats> get copyWith => _$LibraryItemSizeStatsCopyWithImpl<LibraryItemSizeStats>(this as LibraryItemSizeStats, _$identity);

  /// Serializes this LibraryItemSizeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemSizeStats&&(identical(other.id, id) || other.id == id)&&(identical(other.size, size) || other.size == size)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,size,title);

@override
String toString() {
  return 'LibraryItemSizeStats(id: $id, size: $size, title: $title)';
}


}

/// @nodoc
abstract mixin class $LibraryItemSizeStatsCopyWith<$Res>  {
  factory $LibraryItemSizeStatsCopyWith(LibraryItemSizeStats value, $Res Function(LibraryItemSizeStats) _then) = _$LibraryItemSizeStatsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "size") int size,@JsonKey(name: "title") String title
});




}
/// @nodoc
class _$LibraryItemSizeStatsCopyWithImpl<$Res>
    implements $LibraryItemSizeStatsCopyWith<$Res> {
  _$LibraryItemSizeStatsCopyWithImpl(this._self, this._then);

  final LibraryItemSizeStats _self;
  final $Res Function(LibraryItemSizeStats) _then;

/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? size = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LibraryItemSizeStats implements LibraryItemSizeStats {
  const _LibraryItemSizeStats({@JsonKey(name: "id") required this.id, @JsonKey(name: "size") required this.size, @JsonKey(name: "title") required this.title});
  factory _LibraryItemSizeStats.fromJson(Map<String, dynamic> json) => _$LibraryItemSizeStatsFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "size") final  int size;
@override@JsonKey(name: "title") final  String title;

/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemSizeStatsCopyWith<_LibraryItemSizeStats> get copyWith => __$LibraryItemSizeStatsCopyWithImpl<_LibraryItemSizeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryItemSizeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemSizeStats&&(identical(other.id, id) || other.id == id)&&(identical(other.size, size) || other.size == size)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,size,title);

@override
String toString() {
  return 'LibraryItemSizeStats(id: $id, size: $size, title: $title)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemSizeStatsCopyWith<$Res> implements $LibraryItemSizeStatsCopyWith<$Res> {
  factory _$LibraryItemSizeStatsCopyWith(_LibraryItemSizeStats value, $Res Function(_LibraryItemSizeStats) _then) = __$LibraryItemSizeStatsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "size") int size,@JsonKey(name: "title") String title
});




}
/// @nodoc
class __$LibraryItemSizeStatsCopyWithImpl<$Res>
    implements _$LibraryItemSizeStatsCopyWith<$Res> {
  __$LibraryItemSizeStatsCopyWithImpl(this._self, this._then);

  final _LibraryItemSizeStats _self;
  final $Res Function(_LibraryItemSizeStats) _then;

/// Create a copy of LibraryItemSizeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? size = null,Object? title = null,}) {
  return _then(_LibraryItemSizeStats(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
