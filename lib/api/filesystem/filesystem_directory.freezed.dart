// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'filesystem_directory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FilesystemDirectory {

@JsonKey(name: 'path') String get path;@JsonKey(name: 'dirname') String get dirname;@JsonKey(name: 'level') int get level;
/// Create a copy of FilesystemDirectory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FilesystemDirectoryCopyWith<FilesystemDirectory> get copyWith => _$FilesystemDirectoryCopyWithImpl<FilesystemDirectory>(this as FilesystemDirectory, _$identity);

  /// Serializes this FilesystemDirectory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FilesystemDirectory&&(identical(other.path, path) || other.path == path)&&(identical(other.dirname, dirname) || other.dirname == dirname)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,dirname,level);

@override
String toString() {
  return 'FilesystemDirectory(path: $path, dirname: $dirname, level: $level)';
}


}

/// @nodoc
abstract mixin class $FilesystemDirectoryCopyWith<$Res>  {
  factory $FilesystemDirectoryCopyWith(FilesystemDirectory value, $Res Function(FilesystemDirectory) _then) = _$FilesystemDirectoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'dirname') String dirname,@JsonKey(name: 'level') int level
});




}
/// @nodoc
class _$FilesystemDirectoryCopyWithImpl<$Res>
    implements $FilesystemDirectoryCopyWith<$Res> {
  _$FilesystemDirectoryCopyWithImpl(this._self, this._then);

  final FilesystemDirectory _self;
  final $Res Function(FilesystemDirectory) _then;

/// Create a copy of FilesystemDirectory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? dirname = null,Object? level = null,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,dirname: null == dirname ? _self.dirname : dirname // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FilesystemDirectory].
extension FilesystemDirectoryPatterns on FilesystemDirectory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FilesystemDirectory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FilesystemDirectory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FilesystemDirectory value)  $default,){
final _that = this;
switch (_that) {
case _FilesystemDirectory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FilesystemDirectory value)?  $default,){
final _that = this;
switch (_that) {
case _FilesystemDirectory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'dirname')  String dirname, @JsonKey(name: 'level')  int level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FilesystemDirectory() when $default != null:
return $default(_that.path,_that.dirname,_that.level);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'dirname')  String dirname, @JsonKey(name: 'level')  int level)  $default,) {final _that = this;
switch (_that) {
case _FilesystemDirectory():
return $default(_that.path,_that.dirname,_that.level);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'path')  String path, @JsonKey(name: 'dirname')  String dirname, @JsonKey(name: 'level')  int level)?  $default,) {final _that = this;
switch (_that) {
case _FilesystemDirectory() when $default != null:
return $default(_that.path,_that.dirname,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FilesystemDirectory implements FilesystemDirectory {
  const _FilesystemDirectory({@JsonKey(name: 'path') required this.path, @JsonKey(name: 'dirname') required this.dirname, @JsonKey(name: 'level') this.level = 0});
  factory _FilesystemDirectory.fromJson(Map<String, dynamic> json) => _$FilesystemDirectoryFromJson(json);

@override@JsonKey(name: 'path') final  String path;
@override@JsonKey(name: 'dirname') final  String dirname;
@override@JsonKey(name: 'level') final  int level;

/// Create a copy of FilesystemDirectory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FilesystemDirectoryCopyWith<_FilesystemDirectory> get copyWith => __$FilesystemDirectoryCopyWithImpl<_FilesystemDirectory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FilesystemDirectoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FilesystemDirectory&&(identical(other.path, path) || other.path == path)&&(identical(other.dirname, dirname) || other.dirname == dirname)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,path,dirname,level);

@override
String toString() {
  return 'FilesystemDirectory(path: $path, dirname: $dirname, level: $level)';
}


}

/// @nodoc
abstract mixin class _$FilesystemDirectoryCopyWith<$Res> implements $FilesystemDirectoryCopyWith<$Res> {
  factory _$FilesystemDirectoryCopyWith(_FilesystemDirectory value, $Res Function(_FilesystemDirectory) _then) = __$FilesystemDirectoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'path') String path,@JsonKey(name: 'dirname') String dirname,@JsonKey(name: 'level') int level
});




}
/// @nodoc
class __$FilesystemDirectoryCopyWithImpl<$Res>
    implements _$FilesystemDirectoryCopyWith<$Res> {
  __$FilesystemDirectoryCopyWithImpl(this._self, this._then);

  final _FilesystemDirectory _self;
  final $Res Function(_FilesystemDirectory) _then;

/// Create a copy of FilesystemDirectory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? dirname = null,Object? level = null,}) {
  return _then(_FilesystemDirectory(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,dirname: null == dirname ? _self.dirname : dirname // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
