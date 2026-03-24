// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LibraryFolder {

@JsonKey(name: "id") String get id;@JsonKey(name: "fullPath") String get fullPath;@JsonKey(name: "libraryId") String get libraryId;@JsonKey(name: "addedAt") int? get addedAt;
/// Create a copy of LibraryFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryFolderCopyWith<LibraryFolder> get copyWith => _$LibraryFolderCopyWithImpl<LibraryFolder>(this as LibraryFolder, _$identity);

  /// Serializes this LibraryFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullPath,libraryId,addedAt);

@override
String toString() {
  return 'LibraryFolder(id: $id, fullPath: $fullPath, libraryId: $libraryId, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $LibraryFolderCopyWith<$Res>  {
  factory $LibraryFolderCopyWith(LibraryFolder value, $Res Function(LibraryFolder) _then) = _$LibraryFolderCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "fullPath") String fullPath,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "addedAt") int? addedAt
});




}
/// @nodoc
class _$LibraryFolderCopyWithImpl<$Res>
    implements $LibraryFolderCopyWith<$Res> {
  _$LibraryFolderCopyWithImpl(this._self, this._then);

  final LibraryFolder _self;
  final $Res Function(LibraryFolder) _then;

/// Create a copy of LibraryFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullPath = null,Object? libraryId = null,Object? addedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullPath: null == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryFolder].
extension LibraryFolderPatterns on LibraryFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryFolder value)  $default,){
final _that = this;
switch (_that) {
case _LibraryFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryFolder value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "fullPath")  String fullPath, @JsonKey(name: "libraryId")  String libraryId, @JsonKey(name: "addedAt")  int? addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryFolder() when $default != null:
return $default(_that.id,_that.fullPath,_that.libraryId,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "id")  String id, @JsonKey(name: "fullPath")  String fullPath, @JsonKey(name: "libraryId")  String libraryId, @JsonKey(name: "addedAt")  int? addedAt)  $default,) {final _that = this;
switch (_that) {
case _LibraryFolder():
return $default(_that.id,_that.fullPath,_that.libraryId,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "id")  String id, @JsonKey(name: "fullPath")  String fullPath, @JsonKey(name: "libraryId")  String libraryId, @JsonKey(name: "addedAt")  int? addedAt)?  $default,) {final _that = this;
switch (_that) {
case _LibraryFolder() when $default != null:
return $default(_that.id,_that.fullPath,_that.libraryId,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LibraryFolder implements LibraryFolder {
  const _LibraryFolder({@JsonKey(name: "id") required this.id, @JsonKey(name: "fullPath") required this.fullPath, @JsonKey(name: "libraryId") required this.libraryId, @JsonKey(name: "addedAt") this.addedAt});
  factory _LibraryFolder.fromJson(Map<String, dynamic> json) => _$LibraryFolderFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "fullPath") final  String fullPath;
@override@JsonKey(name: "libraryId") final  String libraryId;
@override@JsonKey(name: "addedAt") final  int? addedAt;

/// Create a copy of LibraryFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryFolderCopyWith<_LibraryFolder> get copyWith => __$LibraryFolderCopyWithImpl<_LibraryFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryFolderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.fullPath, fullPath) || other.fullPath == fullPath)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullPath,libraryId,addedAt);

@override
String toString() {
  return 'LibraryFolder(id: $id, fullPath: $fullPath, libraryId: $libraryId, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$LibraryFolderCopyWith<$Res> implements $LibraryFolderCopyWith<$Res> {
  factory _$LibraryFolderCopyWith(_LibraryFolder value, $Res Function(_LibraryFolder) _then) = __$LibraryFolderCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "fullPath") String fullPath,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "addedAt") int? addedAt
});




}
/// @nodoc
class __$LibraryFolderCopyWithImpl<$Res>
    implements _$LibraryFolderCopyWith<$Res> {
  __$LibraryFolderCopyWithImpl(this._self, this._then);

  final _LibraryFolder _self;
  final $Res Function(_LibraryFolder) _then;

/// Create a copy of LibraryFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullPath = null,Object? libraryId = null,Object? addedAt = freezed,}) {
  return _then(_LibraryFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullPath: null == fullPath ? _self.fullPath : fullPath // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
