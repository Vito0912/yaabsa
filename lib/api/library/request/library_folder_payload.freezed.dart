// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_folder_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryFolderPayload {

@JsonKey(name: 'id') String? get id;@JsonKey(name: 'fullPath') String? get fullPath;@JsonKey(name: 'path') String? get path;@JsonKey(name: 'libraryId') String? get libraryId;@JsonKey(name: 'addedAt') int? get addedAt;
/// Create a copy of LibraryFolderPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryFolderPayloadCopyWith<LibraryFolderPayload> get copyWith => _$LibraryFolderPayloadCopyWithImpl<LibraryFolderPayload>(this as LibraryFolderPayload, _$identity);

  /// Serializes this LibraryFolderPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryFolderPayload&&(identical(other.id, id) || other.id == id)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.path, path) || other.path == path)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullPath,path,libraryId,addedAt);

@override
String toString() {
  return 'LibraryFolderPayload(id: $id, fullPath: $fullPath, path: $path, libraryId: $libraryId, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $LibraryFolderPayloadCopyWith<$Res>  {
  factory $LibraryFolderPayloadCopyWith(LibraryFolderPayload value, $Res Function(LibraryFolderPayload) _then) = _$LibraryFolderPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'fullPath') String? fullPath,@JsonKey(name: 'path') String? path,@JsonKey(name: 'libraryId') String? libraryId,@JsonKey(name: 'addedAt') int? addedAt
});




}
/// @nodoc
class _$LibraryFolderPayloadCopyWithImpl<$Res>
    implements $LibraryFolderPayloadCopyWith<$Res> {
  _$LibraryFolderPayloadCopyWithImpl(this._self, this._then);

  final LibraryFolderPayload _self;
  final $Res Function(LibraryFolderPayload) _then;

/// Create a copy of LibraryFolderPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? fullPath = freezed,Object? path = freezed,Object? libraryId = freezed,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryFolderPayload].
extension LibraryFolderPayloadPatterns on LibraryFolderPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryFolderPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryFolderPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryFolderPayload value)  $default,){
final _that = this;
switch (_that) {
case _LibraryFolderPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryFolderPayload value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryFolderPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'fullPath')  String? fullPath, @JsonKey(name: 'path')  String? path, @JsonKey(name: 'libraryId')  String? libraryId, @JsonKey(name: 'addedAt')  int? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryFolderPayload() when $default != null:
return $default(_that.id,_that.fullPath,_that.path,_that.libraryId,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'fullPath')  String? fullPath, @JsonKey(name: 'path')  String? path, @JsonKey(name: 'libraryId')  String? libraryId, @JsonKey(name: 'addedAt')  int? addedAt)  $default,) {final _that = this;
switch (_that) {
case _LibraryFolderPayload():
return $default(_that.id,_that.fullPath,_that.path,_that.libraryId,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'id')  String? id, @JsonKey(name: 'fullPath')  String? fullPath, @JsonKey(name: 'path')  String? path, @JsonKey(name: 'libraryId')  String? libraryId, @JsonKey(name: 'addedAt')  int? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _LibraryFolderPayload() when $default != null:
return $default(_that.id,_that.fullPath,_that.path,_that.libraryId,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _LibraryFolderPayload implements LibraryFolderPayload {
  const _LibraryFolderPayload({@JsonKey(name: 'id') this.id, @JsonKey(name: 'fullPath') this.fullPath, @JsonKey(name: 'path') this.path, @JsonKey(name: 'libraryId') this.libraryId, @JsonKey(name: 'addedAt') this.addedAt});
  factory _LibraryFolderPayload.fromJson(Map<String, dynamic> json) => _$LibraryFolderPayloadFromJson(json);

@override@JsonKey(name: 'id') final  String? id;
@override@JsonKey(name: 'fullPath') final  String? fullPath;
@override@JsonKey(name: 'path') final  String? path;
@override@JsonKey(name: 'libraryId') final  String? libraryId;
@override@JsonKey(name: 'addedAt') final  int? addedAt;

/// Create a copy of LibraryFolderPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryFolderPayloadCopyWith<_LibraryFolderPayload> get copyWith => __$LibraryFolderPayloadCopyWithImpl<_LibraryFolderPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryFolderPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryFolderPayload&&(identical(other.id, id) || other.id == id)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.path, path) || other.path == path)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullPath,path,libraryId,addedAt);

@override
String toString() {
  return 'LibraryFolderPayload(id: $id, fullPath: $fullPath, path: $path, libraryId: $libraryId, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$LibraryFolderPayloadCopyWith<$Res> implements $LibraryFolderPayloadCopyWith<$Res> {
  factory _$LibraryFolderPayloadCopyWith(_LibraryFolderPayload value, $Res Function(_LibraryFolderPayload) _then) = __$LibraryFolderPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'id') String? id,@JsonKey(name: 'fullPath') String? fullPath,@JsonKey(name: 'path') String? path,@JsonKey(name: 'libraryId') String? libraryId,@JsonKey(name: 'addedAt') int? addedAt
});




}
/// @nodoc
class __$LibraryFolderPayloadCopyWithImpl<$Res>
    implements _$LibraryFolderPayloadCopyWith<$Res> {
  __$LibraryFolderPayloadCopyWithImpl(this._self, this._then);

  final _LibraryFolderPayload _self;
  final $Res Function(_LibraryFolderPayload) _then;

/// Create a copy of LibraryFolderPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? fullPath = freezed,Object? path = freezed,Object? libraryId = freezed,Object? addedAt = freezed,}) {
  return _then(_LibraryFolderPayload(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,fullPath: freezed == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,libraryId: freezed == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
