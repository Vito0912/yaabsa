// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_user_permissions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminUserPermissions {

@JsonKey(name: 'download') bool get download;@JsonKey(name: 'update') bool get update;@JsonKey(name: 'delete') bool get delete;@JsonKey(name: 'upload') bool get upload;@JsonKey(name: 'createEreader') bool get createEreader;@JsonKey(name: 'accessAllLibraries') bool get accessAllLibraries;@JsonKey(name: 'accessAllTags') bool get accessAllTags;@JsonKey(name: 'accessExplicitContent') bool get accessExplicitContent;@JsonKey(name: 'selectedTagsNotAccessible') bool get selectedTagsNotAccessible;@JsonKey(name: 'librariesAccessible') List<String> get librariesAccessible;@JsonKey(name: 'itemTagsSelected') List<String> get itemTagsSelected;
/// Create a copy of AdminUserPermissions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserPermissionsCopyWith<AdminUserPermissions> get copyWith => _$AdminUserPermissionsCopyWithImpl<AdminUserPermissions>(this as AdminUserPermissions, _$identity);

  /// Serializes this AdminUserPermissions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUserPermissions&&(identical(other.download, download) || other.download == download)&&(identical(other.update, update) || other.update == update)&&(identical(other.delete, delete) || other.delete == delete)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.createEreader, createEreader) || other.createEreader == createEreader)&&(identical(other.accessAllLibraries, accessAllLibraries) || other.accessAllLibraries == accessAllLibraries)&&(identical(other.accessAllTags, accessAllTags) || other.accessAllTags == accessAllTags)&&(identical(other.accessExplicitContent, accessExplicitContent) || other.accessExplicitContent == accessExplicitContent)&&(identical(other.selectedTagsNotAccessible, selectedTagsNotAccessible) || other.selectedTagsNotAccessible == selectedTagsNotAccessible)&&const DeepCollectionEquality().equals(other.librariesAccessible, librariesAccessible)&&const DeepCollectionEquality().equals(other.itemTagsSelected, itemTagsSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,download,update,delete,upload,createEreader,accessAllLibraries,accessAllTags,accessExplicitContent,selectedTagsNotAccessible,const DeepCollectionEquality().hash(librariesAccessible),const DeepCollectionEquality().hash(itemTagsSelected));

@override
String toString() {
  return 'AdminUserPermissions(download: $download, update: $update, delete: $delete, upload: $upload, createEreader: $createEreader, accessAllLibraries: $accessAllLibraries, accessAllTags: $accessAllTags, accessExplicitContent: $accessExplicitContent, selectedTagsNotAccessible: $selectedTagsNotAccessible, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected)';
}


}

/// @nodoc
abstract mixin class $AdminUserPermissionsCopyWith<$Res>  {
  factory $AdminUserPermissionsCopyWith(AdminUserPermissions value, $Res Function(AdminUserPermissions) _then) = _$AdminUserPermissionsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'download') bool download,@JsonKey(name: 'update') bool update,@JsonKey(name: 'delete') bool delete,@JsonKey(name: 'upload') bool upload,@JsonKey(name: 'createEreader') bool createEreader,@JsonKey(name: 'accessAllLibraries') bool accessAllLibraries,@JsonKey(name: 'accessAllTags') bool accessAllTags,@JsonKey(name: 'accessExplicitContent') bool accessExplicitContent,@JsonKey(name: 'selectedTagsNotAccessible') bool selectedTagsNotAccessible,@JsonKey(name: 'librariesAccessible') List<String> librariesAccessible,@JsonKey(name: 'itemTagsSelected') List<String> itemTagsSelected
});




}
/// @nodoc
class _$AdminUserPermissionsCopyWithImpl<$Res>
    implements $AdminUserPermissionsCopyWith<$Res> {
  _$AdminUserPermissionsCopyWithImpl(this._self, this._then);

  final AdminUserPermissions _self;
  final $Res Function(AdminUserPermissions) _then;

/// Create a copy of AdminUserPermissions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? download = null,Object? update = null,Object? delete = null,Object? upload = null,Object? createEreader = null,Object? accessAllLibraries = null,Object? accessAllTags = null,Object? accessExplicitContent = null,Object? selectedTagsNotAccessible = null,Object? librariesAccessible = null,Object? itemTagsSelected = null,}) {
  return _then(_self.copyWith(
download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as bool,update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as bool,delete: null == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as bool,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as bool,createEreader: null == createEreader ? _self.createEreader : createEreader // ignore: cast_nullable_to_non_nullable
as bool,accessAllLibraries: null == accessAllLibraries ? _self.accessAllLibraries : accessAllLibraries // ignore: cast_nullable_to_non_nullable
as bool,accessAllTags: null == accessAllTags ? _self.accessAllTags : accessAllTags // ignore: cast_nullable_to_non_nullable
as bool,accessExplicitContent: null == accessExplicitContent ? _self.accessExplicitContent : accessExplicitContent // ignore: cast_nullable_to_non_nullable
as bool,selectedTagsNotAccessible: null == selectedTagsNotAccessible ? _self.selectedTagsNotAccessible : selectedTagsNotAccessible // ignore: cast_nullable_to_non_nullable
as bool,librariesAccessible: null == librariesAccessible ? _self.librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>,itemTagsSelected: null == itemTagsSelected ? _self.itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUserPermissions].
extension AdminUserPermissionsPatterns on AdminUserPermissions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUserPermissions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUserPermissions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUserPermissions value)  $default,){
final _that = this;
switch (_that) {
case _AdminUserPermissions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUserPermissions value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUserPermissions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'download')  bool download, @JsonKey(name: 'update')  bool update, @JsonKey(name: 'delete')  bool delete, @JsonKey(name: 'upload')  bool upload, @JsonKey(name: 'createEreader')  bool createEreader, @JsonKey(name: 'accessAllLibraries')  bool accessAllLibraries, @JsonKey(name: 'accessAllTags')  bool accessAllTags, @JsonKey(name: 'accessExplicitContent')  bool accessExplicitContent, @JsonKey(name: 'selectedTagsNotAccessible')  bool selectedTagsNotAccessible, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUserPermissions() when $default != null:
return $default(_that.download,_that.update,_that.delete,_that.upload,_that.createEreader,_that.accessAllLibraries,_that.accessAllTags,_that.accessExplicitContent,_that.selectedTagsNotAccessible,_that.librariesAccessible,_that.itemTagsSelected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'download')  bool download, @JsonKey(name: 'update')  bool update, @JsonKey(name: 'delete')  bool delete, @JsonKey(name: 'upload')  bool upload, @JsonKey(name: 'createEreader')  bool createEreader, @JsonKey(name: 'accessAllLibraries')  bool accessAllLibraries, @JsonKey(name: 'accessAllTags')  bool accessAllTags, @JsonKey(name: 'accessExplicitContent')  bool accessExplicitContent, @JsonKey(name: 'selectedTagsNotAccessible')  bool selectedTagsNotAccessible, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)  $default,) {final _that = this;
switch (_that) {
case _AdminUserPermissions():
return $default(_that.download,_that.update,_that.delete,_that.upload,_that.createEreader,_that.accessAllLibraries,_that.accessAllTags,_that.accessExplicitContent,_that.selectedTagsNotAccessible,_that.librariesAccessible,_that.itemTagsSelected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'download')  bool download, @JsonKey(name: 'update')  bool update, @JsonKey(name: 'delete')  bool delete, @JsonKey(name: 'upload')  bool upload, @JsonKey(name: 'createEreader')  bool createEreader, @JsonKey(name: 'accessAllLibraries')  bool accessAllLibraries, @JsonKey(name: 'accessAllTags')  bool accessAllTags, @JsonKey(name: 'accessExplicitContent')  bool accessExplicitContent, @JsonKey(name: 'selectedTagsNotAccessible')  bool selectedTagsNotAccessible, @JsonKey(name: 'librariesAccessible')  List<String> librariesAccessible, @JsonKey(name: 'itemTagsSelected')  List<String> itemTagsSelected)?  $default,) {final _that = this;
switch (_that) {
case _AdminUserPermissions() when $default != null:
return $default(_that.download,_that.update,_that.delete,_that.upload,_that.createEreader,_that.accessAllLibraries,_that.accessAllTags,_that.accessExplicitContent,_that.selectedTagsNotAccessible,_that.librariesAccessible,_that.itemTagsSelected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUserPermissions implements AdminUserPermissions {
  const _AdminUserPermissions({@JsonKey(name: 'download') this.download = true, @JsonKey(name: 'update') this.update = false, @JsonKey(name: 'delete') this.delete = false, @JsonKey(name: 'upload') this.upload = false, @JsonKey(name: 'createEreader') this.createEreader = false, @JsonKey(name: 'accessAllLibraries') this.accessAllLibraries = true, @JsonKey(name: 'accessAllTags') this.accessAllTags = true, @JsonKey(name: 'accessExplicitContent') this.accessExplicitContent = false, @JsonKey(name: 'selectedTagsNotAccessible') this.selectedTagsNotAccessible = false, @JsonKey(name: 'librariesAccessible') final  List<String> librariesAccessible = const <String>[], @JsonKey(name: 'itemTagsSelected') final  List<String> itemTagsSelected = const <String>[]}): _librariesAccessible = librariesAccessible,_itemTagsSelected = itemTagsSelected;
  factory _AdminUserPermissions.fromJson(Map<String, dynamic> json) => _$AdminUserPermissionsFromJson(json);

@override@JsonKey(name: 'download') final  bool download;
@override@JsonKey(name: 'update') final  bool update;
@override@JsonKey(name: 'delete') final  bool delete;
@override@JsonKey(name: 'upload') final  bool upload;
@override@JsonKey(name: 'createEreader') final  bool createEreader;
@override@JsonKey(name: 'accessAllLibraries') final  bool accessAllLibraries;
@override@JsonKey(name: 'accessAllTags') final  bool accessAllTags;
@override@JsonKey(name: 'accessExplicitContent') final  bool accessExplicitContent;
@override@JsonKey(name: 'selectedTagsNotAccessible') final  bool selectedTagsNotAccessible;
 final  List<String> _librariesAccessible;
@override@JsonKey(name: 'librariesAccessible') List<String> get librariesAccessible {
  if (_librariesAccessible is EqualUnmodifiableListView) return _librariesAccessible;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_librariesAccessible);
}

 final  List<String> _itemTagsSelected;
@override@JsonKey(name: 'itemTagsSelected') List<String> get itemTagsSelected {
  if (_itemTagsSelected is EqualUnmodifiableListView) return _itemTagsSelected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemTagsSelected);
}


/// Create a copy of AdminUserPermissions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserPermissionsCopyWith<_AdminUserPermissions> get copyWith => __$AdminUserPermissionsCopyWithImpl<_AdminUserPermissions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserPermissionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUserPermissions&&(identical(other.download, download) || other.download == download)&&(identical(other.update, update) || other.update == update)&&(identical(other.delete, delete) || other.delete == delete)&&(identical(other.upload, upload) || other.upload == upload)&&(identical(other.createEreader, createEreader) || other.createEreader == createEreader)&&(identical(other.accessAllLibraries, accessAllLibraries) || other.accessAllLibraries == accessAllLibraries)&&(identical(other.accessAllTags, accessAllTags) || other.accessAllTags == accessAllTags)&&(identical(other.accessExplicitContent, accessExplicitContent) || other.accessExplicitContent == accessExplicitContent)&&(identical(other.selectedTagsNotAccessible, selectedTagsNotAccessible) || other.selectedTagsNotAccessible == selectedTagsNotAccessible)&&const DeepCollectionEquality().equals(other._librariesAccessible, _librariesAccessible)&&const DeepCollectionEquality().equals(other._itemTagsSelected, _itemTagsSelected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,download,update,delete,upload,createEreader,accessAllLibraries,accessAllTags,accessExplicitContent,selectedTagsNotAccessible,const DeepCollectionEquality().hash(_librariesAccessible),const DeepCollectionEquality().hash(_itemTagsSelected));

@override
String toString() {
  return 'AdminUserPermissions(download: $download, update: $update, delete: $delete, upload: $upload, createEreader: $createEreader, accessAllLibraries: $accessAllLibraries, accessAllTags: $accessAllTags, accessExplicitContent: $accessExplicitContent, selectedTagsNotAccessible: $selectedTagsNotAccessible, librariesAccessible: $librariesAccessible, itemTagsSelected: $itemTagsSelected)';
}


}

/// @nodoc
abstract mixin class _$AdminUserPermissionsCopyWith<$Res> implements $AdminUserPermissionsCopyWith<$Res> {
  factory _$AdminUserPermissionsCopyWith(_AdminUserPermissions value, $Res Function(_AdminUserPermissions) _then) = __$AdminUserPermissionsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'download') bool download,@JsonKey(name: 'update') bool update,@JsonKey(name: 'delete') bool delete,@JsonKey(name: 'upload') bool upload,@JsonKey(name: 'createEreader') bool createEreader,@JsonKey(name: 'accessAllLibraries') bool accessAllLibraries,@JsonKey(name: 'accessAllTags') bool accessAllTags,@JsonKey(name: 'accessExplicitContent') bool accessExplicitContent,@JsonKey(name: 'selectedTagsNotAccessible') bool selectedTagsNotAccessible,@JsonKey(name: 'librariesAccessible') List<String> librariesAccessible,@JsonKey(name: 'itemTagsSelected') List<String> itemTagsSelected
});




}
/// @nodoc
class __$AdminUserPermissionsCopyWithImpl<$Res>
    implements _$AdminUserPermissionsCopyWith<$Res> {
  __$AdminUserPermissionsCopyWithImpl(this._self, this._then);

  final _AdminUserPermissions _self;
  final $Res Function(_AdminUserPermissions) _then;

/// Create a copy of AdminUserPermissions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? download = null,Object? update = null,Object? delete = null,Object? upload = null,Object? createEreader = null,Object? accessAllLibraries = null,Object? accessAllTags = null,Object? accessExplicitContent = null,Object? selectedTagsNotAccessible = null,Object? librariesAccessible = null,Object? itemTagsSelected = null,}) {
  return _then(_AdminUserPermissions(
download: null == download ? _self.download : download // ignore: cast_nullable_to_non_nullable
as bool,update: null == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as bool,delete: null == delete ? _self.delete : delete // ignore: cast_nullable_to_non_nullable
as bool,upload: null == upload ? _self.upload : upload // ignore: cast_nullable_to_non_nullable
as bool,createEreader: null == createEreader ? _self.createEreader : createEreader // ignore: cast_nullable_to_non_nullable
as bool,accessAllLibraries: null == accessAllLibraries ? _self.accessAllLibraries : accessAllLibraries // ignore: cast_nullable_to_non_nullable
as bool,accessAllTags: null == accessAllTags ? _self.accessAllTags : accessAllTags // ignore: cast_nullable_to_non_nullable
as bool,accessExplicitContent: null == accessExplicitContent ? _self.accessExplicitContent : accessExplicitContent // ignore: cast_nullable_to_non_nullable
as bool,selectedTagsNotAccessible: null == selectedTagsNotAccessible ? _self.selectedTagsNotAccessible : selectedTagsNotAccessible // ignore: cast_nullable_to_non_nullable
as bool,librariesAccessible: null == librariesAccessible ? _self._librariesAccessible : librariesAccessible // ignore: cast_nullable_to_non_nullable
as List<String>,itemTagsSelected: null == itemTagsSelected ? _self._itemTagsSelected : itemTagsSelected // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
