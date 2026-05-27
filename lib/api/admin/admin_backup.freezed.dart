// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminBackup {

@JsonKey(name: 'id') String get id;@JsonKey(name: 'key') String? get key;@JsonKey(name: 'backupDirPath') String? get backupDirPath;@JsonKey(name: 'datePretty') String? get datePretty;@JsonKey(name: 'fullPath') String? get fullPath;@JsonKey(name: 'path') String? get path;@JsonKey(name: 'filename') String? get filename;@JsonKey(name: 'fileSize') int? get fileSize;@JsonKey(name: 'createdAt') int? get createdAt;@JsonKey(name: 'serverVersion') String? get serverVersion;
/// Create a copy of AdminBackup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminBackupCopyWith<AdminBackup> get copyWith => _$AdminBackupCopyWithImpl<AdminBackup>(this as AdminBackup, _$identity);

  /// Serializes this AdminBackup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminBackup&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.backupDirPath, backupDirPath) || other.backupDirPath == backupDirPath)&&(identical(other.datePretty, datePretty) || other.datePretty == datePretty)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.path, path) || other.path == path)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,backupDirPath,datePretty,fullPath,path,filename,fileSize,createdAt,serverVersion);

@override
String toString() {
  return 'AdminBackup(id: $id, key: $key, backupDirPath: $backupDirPath, datePretty: $datePretty, fullPath: $fullPath, path: $path, filename: $filename, fileSize: $fileSize, createdAt: $createdAt, serverVersion: $serverVersion)';
}


}

/// @nodoc
abstract mixin class $AdminBackupCopyWith<$Res>  {
  factory $AdminBackupCopyWith(AdminBackup value, $Res Function(AdminBackup) _then) = _$AdminBackupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'key') String? key,@JsonKey(name: 'backupDirPath') String? backupDirPath,@JsonKey(name: 'datePretty') String? datePretty,@JsonKey(name: 'fullPath') String? fullPath,@JsonKey(name: 'path') String? path,@JsonKey(name: 'filename') String? filename,@JsonKey(name: 'fileSize') int? fileSize,@JsonKey(name: 'createdAt') int? createdAt,@JsonKey(name: 'serverVersion') String? serverVersion
});




}
/// @nodoc
class _$AdminBackupCopyWithImpl<$Res>
    implements $AdminBackupCopyWith<$Res> {
  _$AdminBackupCopyWithImpl(this._self, this._then);

  final AdminBackup _self;
  final $Res Function(AdminBackup) _then;

/// Create a copy of AdminBackup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = freezed,Object? backupDirPath = freezed,Object? datePretty = freezed,Object? fullPath = freezed,Object? path = freezed,Object? filename = freezed,Object? fileSize = freezed,Object? createdAt = freezed,Object? serverVersion = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,backupDirPath: freezed == backupDirPath ? _self.backupDirPath : backupDirPath // ignore: cast_nullable_to_non_nullable
as String?,datePretty: freezed == datePretty ? _self.datePretty : datePretty // ignore: cast_nullable_to_non_nullable
as String?,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,serverVersion: freezed == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminBackup].
extension AdminBackupPatterns on AdminBackup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminBackup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminBackup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminBackup value)  $default,){
final _that = this;
switch (_that) {
case _AdminBackup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminBackup value)?  $default,){
final _that = this;
switch (_that) {
case _AdminBackup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'key')  String? key, @JsonKey(name: 'backupDirPath')  String? backupDirPath, @JsonKey(name: 'datePretty')  String? datePretty, @JsonKey(name: 'fullPath')  String? fullPath, @JsonKey(name: 'path')  String? path, @JsonKey(name: 'filename')  String? filename, @JsonKey(name: 'fileSize')  int? fileSize, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'serverVersion')  String? serverVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminBackup() when $default != null:
return $default(_that.id,_that.key,_that.backupDirPath,_that.datePretty,_that.fullPath,_that.path,_that.filename,_that.fileSize,_that.createdAt,_that.serverVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'key')  String? key, @JsonKey(name: 'backupDirPath')  String? backupDirPath, @JsonKey(name: 'datePretty')  String? datePretty, @JsonKey(name: 'fullPath')  String? fullPath, @JsonKey(name: 'path')  String? path, @JsonKey(name: 'filename')  String? filename, @JsonKey(name: 'fileSize')  int? fileSize, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'serverVersion')  String? serverVersion)  $default,) {final _that = this;
switch (_that) {
case _AdminBackup():
return $default(_that.id,_that.key,_that.backupDirPath,_that.datePretty,_that.fullPath,_that.path,_that.filename,_that.fileSize,_that.createdAt,_that.serverVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String id, @JsonKey(name: 'key')  String? key, @JsonKey(name: 'backupDirPath')  String? backupDirPath, @JsonKey(name: 'datePretty')  String? datePretty, @JsonKey(name: 'fullPath')  String? fullPath, @JsonKey(name: 'path')  String? path, @JsonKey(name: 'filename')  String? filename, @JsonKey(name: 'fileSize')  int? fileSize, @JsonKey(name: 'createdAt')  int? createdAt, @JsonKey(name: 'serverVersion')  String? serverVersion)?  $default,) {final _that = this;
switch (_that) {
case _AdminBackup() when $default != null:
return $default(_that.id,_that.key,_that.backupDirPath,_that.datePretty,_that.fullPath,_that.path,_that.filename,_that.fileSize,_that.createdAt,_that.serverVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminBackup extends AdminBackup {
  const _AdminBackup({@JsonKey(name: 'id') required this.id, @JsonKey(name: 'key') this.key, @JsonKey(name: 'backupDirPath') this.backupDirPath, @JsonKey(name: 'datePretty') this.datePretty, @JsonKey(name: 'fullPath') this.fullPath, @JsonKey(name: 'path') this.path, @JsonKey(name: 'filename') this.filename, @JsonKey(name: 'fileSize') this.fileSize, @JsonKey(name: 'createdAt') this.createdAt, @JsonKey(name: 'serverVersion') this.serverVersion}): super._();
  factory _AdminBackup.fromJson(Map<String, dynamic> json) => _$AdminBackupFromJson(json);

@override@JsonKey(name: 'id') final  String id;
@override@JsonKey(name: 'key') final  String? key;
@override@JsonKey(name: 'backupDirPath') final  String? backupDirPath;
@override@JsonKey(name: 'datePretty') final  String? datePretty;
@override@JsonKey(name: 'fullPath') final  String? fullPath;
@override@JsonKey(name: 'path') final  String? path;
@override@JsonKey(name: 'filename') final  String? filename;
@override@JsonKey(name: 'fileSize') final  int? fileSize;
@override@JsonKey(name: 'createdAt') final  int? createdAt;
@override@JsonKey(name: 'serverVersion') final  String? serverVersion;

/// Create a copy of AdminBackup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminBackupCopyWith<_AdminBackup> get copyWith => __$AdminBackupCopyWithImpl<_AdminBackup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminBackupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminBackup&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.backupDirPath, backupDirPath) || other.backupDirPath == backupDirPath)&&(identical(other.datePretty, datePretty) || other.datePretty == datePretty)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.path, path) || other.path == path)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,backupDirPath,datePretty,fullPath,path,filename,fileSize,createdAt,serverVersion);

@override
String toString() {
  return 'AdminBackup(id: $id, key: $key, backupDirPath: $backupDirPath, datePretty: $datePretty, fullPath: $fullPath, path: $path, filename: $filename, fileSize: $fileSize, createdAt: $createdAt, serverVersion: $serverVersion)';
}


}

/// @nodoc
abstract mixin class _$AdminBackupCopyWith<$Res> implements $AdminBackupCopyWith<$Res> {
  factory _$AdminBackupCopyWith(_AdminBackup value, $Res Function(_AdminBackup) _then) = __$AdminBackupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String id,@JsonKey(name: 'key') String? key,@JsonKey(name: 'backupDirPath') String? backupDirPath,@JsonKey(name: 'datePretty') String? datePretty,@JsonKey(name: 'fullPath') String? fullPath,@JsonKey(name: 'path') String? path,@JsonKey(name: 'filename') String? filename,@JsonKey(name: 'fileSize') int? fileSize,@JsonKey(name: 'createdAt') int? createdAt,@JsonKey(name: 'serverVersion') String? serverVersion
});




}
/// @nodoc
class __$AdminBackupCopyWithImpl<$Res>
    implements _$AdminBackupCopyWith<$Res> {
  __$AdminBackupCopyWithImpl(this._self, this._then);

  final _AdminBackup _self;
  final $Res Function(_AdminBackup) _then;

/// Create a copy of AdminBackup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = freezed,Object? backupDirPath = freezed,Object? datePretty = freezed,Object? fullPath = freezed,Object? path = freezed,Object? filename = freezed,Object? fileSize = freezed,Object? createdAt = freezed,Object? serverVersion = freezed,}) {
  return _then(_AdminBackup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: freezed == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String?,backupDirPath: freezed == backupDirPath ? _self.backupDirPath : backupDirPath // ignore: cast_nullable_to_non_nullable
as String?,datePretty: freezed == datePretty ? _self.datePretty : datePretty // ignore: cast_nullable_to_non_nullable
as String?,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,filename: freezed == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String?,fileSize: freezed == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int?,serverVersion: freezed == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
