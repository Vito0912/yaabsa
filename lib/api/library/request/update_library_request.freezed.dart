// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_library_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateLibraryRequest {

@JsonKey(name: 'name') String? get name;@JsonKey(name: 'displayOrder') int? get displayOrder;@JsonKey(name: 'icon') String? get icon;@JsonKey(name: 'mediaType') String? get mediaType;@JsonKey(name: 'provider') String? get provider;@JsonKey(name: 'settings') UpdateLibrarySettingsRequest? get settings;@JsonKey(name: 'folders') List<LibraryFolderPayload>? get folders;
/// Create a copy of UpdateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateLibraryRequestCopyWith<UpdateLibraryRequest> get copyWith => _$UpdateLibraryRequestCopyWithImpl<UpdateLibraryRequest>(this as UpdateLibraryRequest, _$identity);

  /// Serializes this UpdateLibraryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateLibraryRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.folders, folders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,displayOrder,icon,mediaType,provider,settings,const DeepCollectionEquality().hash(folders));

@override
String toString() {
  return 'UpdateLibraryRequest(name: $name, displayOrder: $displayOrder, icon: $icon, mediaType: $mediaType, provider: $provider, settings: $settings, folders: $folders)';
}


}

/// @nodoc
abstract mixin class $UpdateLibraryRequestCopyWith<$Res>  {
  factory $UpdateLibraryRequestCopyWith(UpdateLibraryRequest value, $Res Function(UpdateLibraryRequest) _then) = _$UpdateLibraryRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'displayOrder') int? displayOrder,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'mediaType') String? mediaType,@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'settings') UpdateLibrarySettingsRequest? settings,@JsonKey(name: 'folders') List<LibraryFolderPayload>? folders
});


$UpdateLibrarySettingsRequestCopyWith<$Res>? get settings;

}
/// @nodoc
class _$UpdateLibraryRequestCopyWithImpl<$Res>
    implements $UpdateLibraryRequestCopyWith<$Res> {
  _$UpdateLibraryRequestCopyWithImpl(this._self, this._then);

  final UpdateLibraryRequest _self;
  final $Res Function(UpdateLibraryRequest) _then;

/// Create a copy of UpdateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? displayOrder = freezed,Object? icon = freezed,Object? mediaType = freezed,Object? provider = freezed,Object? settings = freezed,Object? folders = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UpdateLibrarySettingsRequest?,folders: freezed == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<LibraryFolderPayload>?,
  ));
}
/// Create a copy of UpdateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLibrarySettingsRequestCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $UpdateLibrarySettingsRequestCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// Adds pattern-matching-related methods to [UpdateLibraryRequest].
extension UpdateLibraryRequestPatterns on UpdateLibraryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateLibraryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateLibraryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateLibraryRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateLibraryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateLibraryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'displayOrder')  int? displayOrder, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'mediaType')  String? mediaType, @JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'settings')  UpdateLibrarySettingsRequest? settings, @JsonKey(name: 'folders')  List<LibraryFolderPayload>? folders)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateLibraryRequest() when $default != null:
return $default(_that.name,_that.displayOrder,_that.icon,_that.mediaType,_that.provider,_that.settings,_that.folders);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'displayOrder')  int? displayOrder, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'mediaType')  String? mediaType, @JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'settings')  UpdateLibrarySettingsRequest? settings, @JsonKey(name: 'folders')  List<LibraryFolderPayload>? folders)  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryRequest():
return $default(_that.name,_that.displayOrder,_that.icon,_that.mediaType,_that.provider,_that.settings,_that.folders);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'name')  String? name, @JsonKey(name: 'displayOrder')  int? displayOrder, @JsonKey(name: 'icon')  String? icon, @JsonKey(name: 'mediaType')  String? mediaType, @JsonKey(name: 'provider')  String? provider, @JsonKey(name: 'settings')  UpdateLibrarySettingsRequest? settings, @JsonKey(name: 'folders')  List<LibraryFolderPayload>? folders)?  $default,) {final _that = this;
switch (_that) {
case _UpdateLibraryRequest() when $default != null:
return $default(_that.name,_that.displayOrder,_that.icon,_that.mediaType,_that.provider,_that.settings,_that.folders);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _UpdateLibraryRequest implements UpdateLibraryRequest {
  const _UpdateLibraryRequest({@JsonKey(name: 'name') this.name, @JsonKey(name: 'displayOrder') this.displayOrder, @JsonKey(name: 'icon') this.icon, @JsonKey(name: 'mediaType') this.mediaType, @JsonKey(name: 'provider') this.provider, @JsonKey(name: 'settings') this.settings, @JsonKey(name: 'folders') final  List<LibraryFolderPayload>? folders}): _folders = folders;
  factory _UpdateLibraryRequest.fromJson(Map<String, dynamic> json) => _$UpdateLibraryRequestFromJson(json);

@override@JsonKey(name: 'name') final  String? name;
@override@JsonKey(name: 'displayOrder') final  int? displayOrder;
@override@JsonKey(name: 'icon') final  String? icon;
@override@JsonKey(name: 'mediaType') final  String? mediaType;
@override@JsonKey(name: 'provider') final  String? provider;
@override@JsonKey(name: 'settings') final  UpdateLibrarySettingsRequest? settings;
 final  List<LibraryFolderPayload>? _folders;
@override@JsonKey(name: 'folders') List<LibraryFolderPayload>? get folders {
  final value = _folders;
  if (value == null) return null;
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of UpdateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateLibraryRequestCopyWith<_UpdateLibraryRequest> get copyWith => __$UpdateLibraryRequestCopyWithImpl<_UpdateLibraryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateLibraryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateLibraryRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other._folders, _folders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,displayOrder,icon,mediaType,provider,settings,const DeepCollectionEquality().hash(_folders));

@override
String toString() {
  return 'UpdateLibraryRequest(name: $name, displayOrder: $displayOrder, icon: $icon, mediaType: $mediaType, provider: $provider, settings: $settings, folders: $folders)';
}


}

/// @nodoc
abstract mixin class _$UpdateLibraryRequestCopyWith<$Res> implements $UpdateLibraryRequestCopyWith<$Res> {
  factory _$UpdateLibraryRequestCopyWith(_UpdateLibraryRequest value, $Res Function(_UpdateLibraryRequest) _then) = __$UpdateLibraryRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'name') String? name,@JsonKey(name: 'displayOrder') int? displayOrder,@JsonKey(name: 'icon') String? icon,@JsonKey(name: 'mediaType') String? mediaType,@JsonKey(name: 'provider') String? provider,@JsonKey(name: 'settings') UpdateLibrarySettingsRequest? settings,@JsonKey(name: 'folders') List<LibraryFolderPayload>? folders
});


@override $UpdateLibrarySettingsRequestCopyWith<$Res>? get settings;

}
/// @nodoc
class __$UpdateLibraryRequestCopyWithImpl<$Res>
    implements _$UpdateLibraryRequestCopyWith<$Res> {
  __$UpdateLibraryRequestCopyWithImpl(this._self, this._then);

  final _UpdateLibraryRequest _self;
  final $Res Function(_UpdateLibraryRequest) _then;

/// Create a copy of UpdateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? displayOrder = freezed,Object? icon = freezed,Object? mediaType = freezed,Object? provider = freezed,Object? settings = freezed,Object? folders = freezed,}) {
  return _then(_UpdateLibraryRequest(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: freezed == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int?,icon: freezed == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as UpdateLibrarySettingsRequest?,folders: freezed == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<LibraryFolderPayload>?,
  ));
}

/// Create a copy of UpdateLibraryRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UpdateLibrarySettingsRequestCopyWith<$Res>? get settings {
    if (_self.settings == null) {
    return null;
  }

  return $UpdateLibrarySettingsRequestCopyWith<$Res>(_self.settings!, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
