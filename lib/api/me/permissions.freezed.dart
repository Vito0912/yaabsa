// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Permissions {

@JsonKey(name: "download") bool get download;@JsonKey(name: "update") bool get update;@JsonKey(name: "delete") bool get delete;@JsonKey(name: "upload") bool get upload;@JsonKey(name: "accessAllLibraries") bool get accessAllLibraries;@JsonKey(name: "accessAllTags") bool get accessAllTags;@JsonKey(name: "accessExplicitContent") bool get accessExplicitContent;
/// Create a copy of Permissions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PermissionsCopyWith<Permissions> get copyWith => _$PermissionsCopyWithImpl<Permissions>(this as Permissions, _$identity);

  /// Serializes this Permissions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Permissions&&(identical(other.download, download) || other.download == download)&&(identical(other.update, update) || other.update == update)&&(identical(other.delete, delete) || other.delete == delete)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.accessAllLibraries, accessAllLibraries) || other.accessAllLibraries == accessAllLibraries)&&(identical(other.accessAllTags, accessAllTags) || other.accessAllTags == accessAllTags)&&(identical(other.accessExplicitContent, accessExplicitContent) || other.accessExplicitContent == accessExplicitContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,download,update,delete,upload,accessAllLibraries,accessAllTags,accessExplicitContent);

@override
String toString() {
  return 'Permissions(download: $download, update: $update, delete: $delete, upload: $upload, accessAllLibraries: $accessAllLibraries, accessAllTags: $accessAllTags, accessExplicitContent: $accessExplicitContent)';
}


}

/// @nodoc
abstract mixin class $PermissionsCopyWith<$Res>  {
  factory $PermissionsCopyWith(Permissions value, $Res Function(Permissions) _then) = _$PermissionsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "download") bool download,@JsonKey(name: "update") bool update,@JsonKey(name: "delete") bool delete,@JsonKey(name: "upload") bool upload,@JsonKey(name: "accessAllLibraries") bool accessAllLibraries,@JsonKey(name: "accessAllTags") bool accessAllTags,@JsonKey(name: "accessExplicitContent") bool accessExplicitContent
});




}
/// @nodoc
class _$PermissionsCopyWithImpl<$Res>
    implements $PermissionsCopyWith<$Res> {
  _$PermissionsCopyWithImpl(this._self, this._then);

  final Permissions _self;
  final $Res Function(Permissions) _then;

/// Create a copy of Permissions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? download = null,Object? update = null,Object? delete = null,Object? upload = null,Object? accessAllLibraries = null,Object? accessAllTags = null,Object? accessExplicitContent = null,}) {
  return _then(_self.copyWith(
download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as bool,update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as bool,delete: null == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as bool,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as bool,accessAllLibraries: null == accessAllLibraries ? _self.accessAllLibraries : accessAllLibraries // ignore: cast_nullable_to_non_nullable
as bool,accessAllTags: null == accessAllTags ? _self.accessAllTags : accessAllTags // ignore: cast_nullable_to_non_nullable
as bool,accessExplicitContent: null == accessExplicitContent ? _self.accessExplicitContent : accessExplicitContent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Permissions implements Permissions {
  const _Permissions({@JsonKey(name: "download") required this.download, @JsonKey(name: "update") required this.update, @JsonKey(name: "delete") required this.delete, @JsonKey(name: "upload") required this.upload, @JsonKey(name: "accessAllLibraries") required this.accessAllLibraries, @JsonKey(name: "accessAllTags") required this.accessAllTags, @JsonKey(name: "accessExplicitContent") required this.accessExplicitContent});
  factory _Permissions.fromJson(Map<String, dynamic> json) => _$PermissionsFromJson(json);

@override@JsonKey(name: "download") final  bool download;
@override@JsonKey(name: "update") final  bool update;
@override@JsonKey(name: "delete") final  bool delete;
@override@JsonKey(name: "upload") final  bool upload;
@override@JsonKey(name: "accessAllLibraries") final  bool accessAllLibraries;
@override@JsonKey(name: "accessAllTags") final  bool accessAllTags;
@override@JsonKey(name: "accessExplicitContent") final  bool accessExplicitContent;

/// Create a copy of Permissions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PermissionsCopyWith<_Permissions> get copyWith => __$PermissionsCopyWithImpl<_Permissions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PermissionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Permissions&&(identical(other.download, download) || other.download == download)&&(identical(other.update, update) || other.update == update)&&(identical(other.delete, delete) || other.delete == delete)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.accessAllLibraries, accessAllLibraries) || other.accessAllLibraries == accessAllLibraries)&&(identical(other.accessAllTags, accessAllTags) || other.accessAllTags == accessAllTags)&&(identical(other.accessExplicitContent, accessExplicitContent) || other.accessExplicitContent == accessExplicitContent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,download,update,delete,upload,accessAllLibraries,accessAllTags,accessExplicitContent);

@override
String toString() {
  return 'Permissions(download: $download, update: $update, delete: $delete, upload: $upload, accessAllLibraries: $accessAllLibraries, accessAllTags: $accessAllTags, accessExplicitContent: $accessExplicitContent)';
}


}

/// @nodoc
abstract mixin class _$PermissionsCopyWith<$Res> implements $PermissionsCopyWith<$Res> {
  factory _$PermissionsCopyWith(_Permissions value, $Res Function(_Permissions) _then) = __$PermissionsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "download") bool download,@JsonKey(name: "update") bool update,@JsonKey(name: "delete") bool delete,@JsonKey(name: "upload") bool upload,@JsonKey(name: "accessAllLibraries") bool accessAllLibraries,@JsonKey(name: "accessAllTags") bool accessAllTags,@JsonKey(name: "accessExplicitContent") bool accessExplicitContent
});




}
/// @nodoc
class __$PermissionsCopyWithImpl<$Res>
    implements _$PermissionsCopyWith<$Res> {
  __$PermissionsCopyWithImpl(this._self, this._then);

  final _Permissions _self;
  final $Res Function(_Permissions) _then;

/// Create a copy of Permissions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? download = null,Object? update = null,Object? delete = null,Object? upload = null,Object? accessAllLibraries = null,Object? accessAllTags = null,Object? accessExplicitContent = null,}) {
  return _then(_Permissions(
download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as bool,update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as bool,delete: null == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as bool,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as bool,accessAllLibraries: null == accessAllLibraries ? _self.accessAllLibraries : accessAllLibraries // ignore: cast_nullable_to_non_nullable
as bool,accessAllTags: null == accessAllTags ? _self.accessAllTags : accessAllTags // ignore: cast_nullable_to_non_nullable
as bool,accessExplicitContent: null == accessExplicitContent ? _self.accessExplicitContent : accessExplicitContent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
