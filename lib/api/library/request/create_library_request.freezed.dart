// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_library_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateLibraryRequest {

@JsonKey(name: 'name') String get name;@JsonKey(name: 'folders') List<LibraryFolderPayload> get folders;@JsonKey(name: 'provider') String? get provider;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'mediaType') String? get mediaType;@JsonKey(name: 'settings') LibrarySettings? get settings;
/// Create a copy of CreateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateLibraryRequestCopyWith<CreateLibraryRequest> get copyWith => _$CreateLibraryRequestCopyWithImpl<CreateLibraryRequest>(this as CreateLibraryRequest, _$identity);

  /// Serializes this CreateLibraryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateLibraryRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.folders, folders)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(folders),provider,icon,mediaType,settings);

@override
String toString() {
  return 'CreateLibraryRequest(name: $name, folders: $folders, provider: $provider, icon: $icon, mediaType: $mediaType, settings: $settings)';
}


}

/// @nodoc
abstract mixin class $CreateLibraryRequestCopyWith<$Res>  {
  factory $CreateLibraryRequestCopyWith(CreateLibraryRequest value, $Res Function(CreateLibraryRequest) _then) = _$CreateLibraryRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'folders') List<LibraryFolderPayload> folders,@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'mediaType') String? mediaType,@JsonKey(name: 'settings') LibrarySettings? settings
});


$LibrarySettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class _$CreateLibraryRequestCopyWithImpl<$Res>
    implements $CreateLibraryRequestCopyWith<$Res> {
  _$CreateLibraryRequestCopyWithImpl(this._self, this._then);

  final CreateLibraryRequest _self;
  final $Res Function(CreateLibraryRequest) _then;

/// Create a copy of CreateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? folders = null,Object? provider = freezed,Object? icon = freezed,Object? mediaType = freezed,Object? settings = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,folders: null == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<LibraryFolderPayload>,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as LibrarySettings?,
  ));
}
/// Create a copy of CreateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibrarySettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $LibrarySettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreateLibraryRequest].
extension CreateLibraryRequestPatterns on CreateLibraryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateLibraryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateLibraryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateLibraryRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateLibraryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateLibraryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateLibraryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'folders')  List<LibraryFolderPayload> folders, @JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'mediaType')  String? mediaType, @JsonKey(name: 'settings')  LibrarySettings? settings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateLibraryRequest() when $default != null:
return $default(_that.name,_that.folders,_that.provider,_that.icon,_that.mediaType,_that.settings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'folders')  List<LibraryFolderPayload> folders, @JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'mediaType')  String? mediaType, @JsonKey(name: 'settings')  LibrarySettings? settings)  $default,) {final _that = this;
switch (_that) {
case _CreateLibraryRequest():
return $default(_that.name,_that.folders,_that.provider,_that.icon,_that.mediaType,_that.settings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String name, @JsonKey(name: 'folders')  List<LibraryFolderPayload> folders, @JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'mediaType')  String? mediaType, @JsonKey(name: 'settings')  LibrarySettings? settings)?  $default,) {final _that = this;
switch (_that) {
case _CreateLibraryRequest() when $default != null:
return $default(_that.name,_that.folders,_that.provider,_that.icon,_that.mediaType,_that.settings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateLibraryRequest implements CreateLibraryRequest {
  const _CreateLibraryRequest({@JsonKey(name: 'name') required this.name, @JsonKey(name: 'folders') required final  List<LibraryFolderPayload> folders, @JsonKey(name: 'provider') this.provider, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'mediaType') this.mediaType, @JsonKey(name: 'settings') this.settings}): _folders = folders;
  factory _CreateLibraryRequest.fromJson(Map<String, dynamic> json) => _$CreateLibraryRequestFromJson(json);

@override@JsonKey(name: 'name') final  String name;
 final  List<LibraryFolderPayload> _folders;
@override@JsonKey(name: 'folders') List<LibraryFolderPayload> get folders {
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_folders);
}

@override@JsonKey(name: 'provider') final  String? provider;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'mediaType') final  String? mediaType;
@override@JsonKey(name: 'settings') final  LibrarySettings? settings;

/// Create a copy of CreateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateLibraryRequestCopyWith<_CreateLibraryRequest> get copyWith => __$CreateLibraryRequestCopyWithImpl<_CreateLibraryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateLibraryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateLibraryRequest&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._folders, _folders)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.settings, settings) || other.settings == settings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_folders),provider,icon,mediaType,settings);

@override
String toString() {
  return 'CreateLibraryRequest(name: $name, folders: $folders, provider: $provider, icon: $icon, mediaType: $mediaType, settings: $settings)';
}


}

/// @nodoc
abstract mixin class _$CreateLibraryRequestCopyWith<$Res> implements $CreateLibraryRequestCopyWith<$Res> {
  factory _$CreateLibraryRequestCopyWith(_CreateLibraryRequest value, $Res Function(_CreateLibraryRequest) _then) = __$CreateLibraryRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String name,@JsonKey(name: 'folders') List<LibraryFolderPayload> folders,@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'mediaType') String? mediaType,@JsonKey(name: 'settings') LibrarySettings? settings
});


@override $LibrarySettingsCopyWith<$Res>? get settings;

}
/// @nodoc
class __$CreateLibraryRequestCopyWithImpl<$Res>
    implements _$CreateLibraryRequestCopyWith<$Res> {
  __$CreateLibraryRequestCopyWithImpl(this._self, this._then);

  final _CreateLibraryRequest _self;
  final $Res Function(_CreateLibraryRequest) _then;

/// Create a copy of CreateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? folders = null,Object? provider = freezed,Object? icon = freezed,Object? mediaType = freezed,Object? settings = freezed,}) {
  return _then(_CreateLibraryRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,folders: null == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<LibraryFolderPayload>,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as LibrarySettings?,
  ));
}

/// Create a copy of CreateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibrarySettingsCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $LibrarySettingsCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
