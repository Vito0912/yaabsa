// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Library {

@JsonKey(name: "id") String get id;@JsonKey(name: "name") String get name;@JsonKey(name: "displayOrder") int get displayOrder;@JsonKey(name: "icon") String get icon;@JsonKey(name: "mediaType") String get mediaType;@JsonKey(name: "provider") String get provider;@JsonKey(name: "lastScan") int? get lastScan;@JsonKey(name: "lastScanVersion") String? get lastScanVersion;@JsonKey(name: "createdAt") int get createdAt;@JsonKey(name: "lastUpdate") int? get lastUpdate;@JsonKey(name: "settings") LibrarySettings get settings;@JsonKey(name: "folders") List<LibraryFolder>? get folders;
/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryCopyWith<Library> get copyWith => _$LibraryCopyWithImpl<Library>(this as Library, _$identity);

  /// Serializes this Library to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Library&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.lastScan, lastScan) || other.lastScan == lastScan)&&(identical(other.lastScanVersion, lastScanVersion) || other.lastScanVersion == lastScanVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other.folders, folders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,displayOrder,icon,mediaType,provider,lastScan,lastScanVersion,createdAt,lastUpdate,settings,const DeepCollectionEquality().hash(folders));

@override
String toString() {
  return 'Library(id: $id, name: $name, displayOrder: $displayOrder, icon: $icon, mediaType: $mediaType, provider: $provider, lastScan: $lastScan, lastScanVersion: $lastScanVersion, createdAt: $createdAt, lastUpdate: $lastUpdate, settings: $settings, folders: $folders)';
}


}

/// @nodoc
abstract mixin class $LibraryCopyWith<$Res>  {
  factory $LibraryCopyWith(Library value, $Res Function(Library) _then) = _$LibraryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String name,@JsonKey(name: "displayOrder") int displayOrder,@JsonKey(name: "icon") String icon,@JsonKey(name: "mediaType") String mediaType,@JsonKey(name: "provider") String provider,@JsonKey(name: "lastScan") int? lastScan,@JsonKey(name: "lastScanVersion") String? lastScanVersion,@JsonKey(name: "createdAt") int createdAt,@JsonKey(name: "lastUpdate") int? lastUpdate,@JsonKey(name: "settings") LibrarySettings settings,@JsonKey(name: "folders") List<LibraryFolder>? folders
});


$LibrarySettingsCopyWith<$Res> get settings;

}
/// @nodoc
class _$LibraryCopyWithImpl<$Res>
    implements $LibraryCopyWith<$Res> {
  _$LibraryCopyWithImpl(this._self, this._then);

  final Library _self;
  final $Res Function(Library) _then;

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? displayOrder = null,Object? icon = null,Object? mediaType = null,Object? provider = null,Object? lastScan = freezed,Object? lastScanVersion = freezed,Object? createdAt = null,Object? lastUpdate = freezed,Object? settings = null,Object? folders = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,lastScan: freezed == lastScan ? _self.lastScan : lastScan // ignore: cast_nullable_to_non_nullable
as int?,lastScanVersion: freezed == lastScanVersion ? _self.lastScanVersion : lastScanVersion // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as int?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as LibrarySettings,folders: freezed == folders ? _self.folders : folders // ignore: cast_nullable_to_non_nullable
as List<LibraryFolder>?,
  ));
}
/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibrarySettingsCopyWith<$Res> get settings {
  
  return $LibrarySettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _Library implements Library {
  const _Library({@JsonKey(name: "id") required this.id, @JsonKey(name: "name") required this.name, @JsonKey(name: "displayOrder") required this.displayOrder, @JsonKey(name: "icon") required this.icon, @JsonKey(name: "mediaType") required this.mediaType, @JsonKey(name: "provider") required this.provider, @JsonKey(name: "lastScan") this.lastScan, @JsonKey(name: "lastScanVersion") this.lastScanVersion, @JsonKey(name: "createdAt") required this.createdAt, @JsonKey(name: "lastUpdate") this.lastUpdate, @JsonKey(name: "settings") required this.settings, @JsonKey(name: "folders") final  List<LibraryFolder>? folders}): _folders = folders;
  factory _Library.fromJson(Map<String, dynamic> json) => _$LibraryFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "name") final  String name;
@override@JsonKey(name: "displayOrder") final  int displayOrder;
@override@JsonKey(name: "icon") final  String icon;
@override@JsonKey(name: "mediaType") final  String mediaType;
@override@JsonKey(name: "provider") final  String provider;
@override@JsonKey(name: "lastScan") final  int? lastScan;
@override@JsonKey(name: "lastScanVersion") final  String? lastScanVersion;
@override@JsonKey(name: "createdAt") final  int createdAt;
@override@JsonKey(name: "lastUpdate") final  int? lastUpdate;
@override@JsonKey(name: "settings") final  LibrarySettings settings;
 final  List<LibraryFolder>? _folders;
@override@JsonKey(name: "folders") List<LibraryFolder>? get folders {
  final value = _folders;
  if (value == null) return null;
  if (_folders is EqualUnmodifiableListView) return _folders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryCopyWith<_Library> get copyWith => __$LibraryCopyWithImpl<_Library>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LibraryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Library&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.lastScan, lastScan) || other.lastScan == lastScan)&&(identical(other.lastScanVersion, lastScanVersion) || other.lastScanVersion == lastScanVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.settings, settings) || other.settings == settings)&&const DeepCollectionEquality().equals(other._folders, _folders));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,displayOrder,icon,mediaType,provider,lastScan,lastScanVersion,createdAt,lastUpdate,settings,const DeepCollectionEquality().hash(_folders));

@override
String toString() {
  return 'Library(id: $id, name: $name, displayOrder: $displayOrder, icon: $icon, mediaType: $mediaType, provider: $provider, lastScan: $lastScan, lastScanVersion: $lastScanVersion, createdAt: $createdAt, lastUpdate: $lastUpdate, settings: $settings, folders: $folders)';
}


}

/// @nodoc
abstract mixin class _$LibraryCopyWith<$Res> implements $LibraryCopyWith<$Res> {
  factory _$LibraryCopyWith(_Library value, $Res Function(_Library) _then) = __$LibraryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "name") String name,@JsonKey(name: "displayOrder") int displayOrder,@JsonKey(name: "icon") String icon,@JsonKey(name: "mediaType") String mediaType,@JsonKey(name: "provider") String provider,@JsonKey(name: "lastScan") int? lastScan,@JsonKey(name: "lastScanVersion") String? lastScanVersion,@JsonKey(name: "createdAt") int createdAt,@JsonKey(name: "lastUpdate") int? lastUpdate,@JsonKey(name: "settings") LibrarySettings settings,@JsonKey(name: "folders") List<LibraryFolder>? folders
});


@override $LibrarySettingsCopyWith<$Res> get settings;

}
/// @nodoc
class __$LibraryCopyWithImpl<$Res>
    implements _$LibraryCopyWith<$Res> {
  __$LibraryCopyWithImpl(this._self, this._then);

  final _Library _self;
  final $Res Function(_Library) _then;

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? displayOrder = null,Object? icon = null,Object? mediaType = null,Object? provider = null,Object? lastScan = freezed,Object? lastScanVersion = freezed,Object? createdAt = null,Object? lastUpdate = freezed,Object? settings = null,Object? folders = freezed,}) {
  return _then(_Library(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,lastScan: freezed == lastScan ? _self.lastScan : lastScan // ignore: cast_nullable_to_non_nullable
as int?,lastScanVersion: freezed == lastScanVersion ? _self.lastScanVersion : lastScanVersion // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as int,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as int?,settings: null == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as LibrarySettings,folders: freezed == folders ? _self._folders : folders // ignore: cast_nullable_to_non_nullable
as List<LibraryFolder>?,
  ));
}

/// Create a copy of Library
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibrarySettingsCopyWith<$Res> get settings {
  
  return $LibrarySettingsCopyWith<$Res>(_self.settings, (value) {
    return _then(_self.copyWith(settings: value));
  });
}
}

// dart format on
