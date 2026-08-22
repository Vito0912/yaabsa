// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_download.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmartDownloadPolicy {

 int get targetCount; int? get maxAgeDays; int? get maxStorageBytes; int get deleteAfterHours; String get downloadType; bool get descending;
/// Create a copy of SmartDownloadPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartDownloadPolicyCopyWith<SmartDownloadPolicy> get copyWith => _$SmartDownloadPolicyCopyWithImpl<SmartDownloadPolicy>(this as SmartDownloadPolicy, _$identity);

  /// Serializes this SmartDownloadPolicy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartDownloadPolicy&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.maxAgeDays, maxAgeDays) || other.maxAgeDays == maxAgeDays)&&(identical(other.maxStorageBytes, maxStorageBytes) || other.maxStorageBytes == maxStorageBytes)&&(identical(other.deleteAfterHours, deleteAfterHours) || other.deleteAfterHours == deleteAfterHours)&&(identical(other.downloadType, downloadType) || other.downloadType == downloadType)&&(identical(other.descending, descending) || other.descending == descending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetCount,maxAgeDays,maxStorageBytes,deleteAfterHours,downloadType,descending);

@override
String toString() {
  return 'SmartDownloadPolicy(targetCount: $targetCount, maxAgeDays: $maxAgeDays, maxStorageBytes: $maxStorageBytes, deleteAfterHours: $deleteAfterHours, downloadType: $downloadType, descending: $descending)';
}


}

/// @nodoc
abstract mixin class $SmartDownloadPolicyCopyWith<$Res>  {
  factory $SmartDownloadPolicyCopyWith(SmartDownloadPolicy value, $Res Function(SmartDownloadPolicy) _then) = _$SmartDownloadPolicyCopyWithImpl;
@useResult
$Res call({
 int targetCount, int? maxAgeDays, int? maxStorageBytes, int deleteAfterHours, String downloadType, bool descending
});




}
/// @nodoc
class _$SmartDownloadPolicyCopyWithImpl<$Res>
    implements $SmartDownloadPolicyCopyWith<$Res> {
  _$SmartDownloadPolicyCopyWithImpl(this._self, this._then);

  final SmartDownloadPolicy _self;
  final $Res Function(SmartDownloadPolicy) _then;

/// Create a copy of SmartDownloadPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetCount = null,Object? maxAgeDays = freezed,Object? maxStorageBytes = freezed,Object? deleteAfterHours = null,Object? downloadType = null,Object? descending = null,}) {
  return _then(SmartDownloadPolicy(
targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,maxAgeDays: freezed == maxAgeDays ? _self.maxAgeDays : maxAgeDays // ignore: cast_nullable_to_non_nullable
as int?,maxStorageBytes: freezed == maxStorageBytes ? _self.maxStorageBytes : maxStorageBytes // ignore: cast_nullable_to_non_nullable
as int?,deleteAfterHours: null == deleteAfterHours ? _self.deleteAfterHours : deleteAfterHours // ignore: cast_nullable_to_non_nullable
as int,downloadType: null == downloadType ? _self.downloadType : downloadType // ignore: cast_nullable_to_non_nullable
as String,descending: null == descending ? _self.descending : descending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartDownloadPolicy].
extension SmartDownloadPolicyPatterns on SmartDownloadPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartDownloadPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartDownloadPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartDownloadPolicy value)  $default,){
final _that = this;
switch (_that) {
case _SmartDownloadPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartDownloadPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _SmartDownloadPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int targetCount,  int? maxAgeDays,  int? maxStorageBytes,  int deleteAfterHours,  String downloadType,  bool descending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartDownloadPolicy() when $default != null:
return $default(_that.targetCount,_that.maxAgeDays,_that.maxStorageBytes,_that.deleteAfterHours,_that.downloadType,_that.descending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int targetCount,  int? maxAgeDays,  int? maxStorageBytes,  int deleteAfterHours,  String downloadType,  bool descending)  $default,) {final _that = this;
switch (_that) {
case _SmartDownloadPolicy():
return $default(_that.targetCount,_that.maxAgeDays,_that.maxStorageBytes,_that.deleteAfterHours,_that.downloadType,_that.descending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int targetCount,  int? maxAgeDays,  int? maxStorageBytes,  int deleteAfterHours,  String downloadType,  bool descending)?  $default,) {final _that = this;
switch (_that) {
case _SmartDownloadPolicy() when $default != null:
return $default(_that.targetCount,_that.maxAgeDays,_that.maxStorageBytes,_that.deleteAfterHours,_that.downloadType,_that.descending);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartDownloadPolicy implements SmartDownloadPolicy {
  const _SmartDownloadPolicy({this.targetCount = 3, this.maxAgeDays, this.maxStorageBytes, this.deleteAfterHours = 24, this.downloadType = 'audiobook', this.descending = true});
  factory _SmartDownloadPolicy.fromJson(Map<String, dynamic> json) => _$SmartDownloadPolicyFromJson(json);

@override@JsonKey() final  int targetCount;
@override final  int? maxAgeDays;
@override final  int? maxStorageBytes;
@override@JsonKey() final  int deleteAfterHours;
@override@JsonKey() final  String downloadType;
@override@JsonKey() final  bool descending;

/// Create a copy of SmartDownloadPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartDownloadPolicyCopyWith<_SmartDownloadPolicy> get copyWith => __$SmartDownloadPolicyCopyWithImpl<_SmartDownloadPolicy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartDownloadPolicyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartDownloadPolicy&&(identical(other.targetCount, targetCount) || other.targetCount == targetCount)&&(identical(other.maxAgeDays, maxAgeDays) || other.maxAgeDays == maxAgeDays)&&(identical(other.maxStorageBytes, maxStorageBytes) || other.maxStorageBytes == maxStorageBytes)&&(identical(other.deleteAfterHours, deleteAfterHours) || other.deleteAfterHours == deleteAfterHours)&&(identical(other.downloadType, downloadType) || other.downloadType == downloadType)&&(identical(other.descending, descending) || other.descending == descending));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,targetCount,maxAgeDays,maxStorageBytes,deleteAfterHours,downloadType,descending);

@override
String toString() {
  return 'SmartDownloadPolicy(targetCount: $targetCount, maxAgeDays: $maxAgeDays, maxStorageBytes: $maxStorageBytes, deleteAfterHours: $deleteAfterHours, downloadType: $downloadType, descending: $descending)';
}


}

/// @nodoc
abstract mixin class _$SmartDownloadPolicyCopyWith<$Res> implements $SmartDownloadPolicyCopyWith<$Res> {
  factory _$SmartDownloadPolicyCopyWith(_SmartDownloadPolicy value, $Res Function(_SmartDownloadPolicy) _then) = __$SmartDownloadPolicyCopyWithImpl;
@override @useResult
$Res call({
 int targetCount, int? maxAgeDays, int? maxStorageBytes, int deleteAfterHours, String downloadType, bool descending
});




}
/// @nodoc
class __$SmartDownloadPolicyCopyWithImpl<$Res>
    implements _$SmartDownloadPolicyCopyWith<$Res> {
  __$SmartDownloadPolicyCopyWithImpl(this._self, this._then);

  final _SmartDownloadPolicy _self;
  final $Res Function(_SmartDownloadPolicy) _then;

/// Create a copy of SmartDownloadPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetCount = null,Object? maxAgeDays = freezed,Object? maxStorageBytes = freezed,Object? deleteAfterHours = null,Object? downloadType = null,Object? descending = null,}) {
  return _then(_SmartDownloadPolicy(
targetCount: null == targetCount ? _self.targetCount : targetCount // ignore: cast_nullable_to_non_nullable
as int,maxAgeDays: freezed == maxAgeDays ? _self.maxAgeDays : maxAgeDays // ignore: cast_nullable_to_non_nullable
as int?,maxStorageBytes: freezed == maxStorageBytes ? _self.maxStorageBytes : maxStorageBytes // ignore: cast_nullable_to_non_nullable
as int?,deleteAfterHours: null == deleteAfterHours ? _self.deleteAfterHours : deleteAfterHours // ignore: cast_nullable_to_non_nullable
as int,downloadType: null == downloadType ? _self.downloadType : downloadType // ignore: cast_nullable_to_non_nullable
as String,descending: null == descending ? _self.descending : descending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SmartDownloadProfile {

 String get id; set id(String value); String get userId; set userId(String value); String get name; set name(String value); bool get enabled; set enabled(bool value); SmartDownloadPolicy get policy; set policy(SmartDownloadPolicy value); List<MediaSourceDescriptor> get sources; set sources(List<MediaSourceDescriptor> value);
/// Create a copy of SmartDownloadProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartDownloadProfileCopyWith<SmartDownloadProfile> get copyWith => _$SmartDownloadProfileCopyWithImpl<SmartDownloadProfile>(this as SmartDownloadProfile, _$identity);

  /// Serializes this SmartDownloadProfile to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'SmartDownloadProfile(id: $id, userId: $userId, name: $name, enabled: $enabled, policy: $policy, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $SmartDownloadProfileCopyWith<$Res>  {
  factory $SmartDownloadProfileCopyWith(SmartDownloadProfile value, $Res Function(SmartDownloadProfile) _then) = _$SmartDownloadProfileCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, bool enabled, SmartDownloadPolicy policy, List<MediaSourceDescriptor> sources
});


$SmartDownloadPolicyCopyWith<$Res> get policy;

}
/// @nodoc
class _$SmartDownloadProfileCopyWithImpl<$Res>
    implements $SmartDownloadProfileCopyWith<$Res> {
  _$SmartDownloadProfileCopyWithImpl(this._self, this._then);

  final SmartDownloadProfile _self;
  final $Res Function(SmartDownloadProfile) _then;

/// Create a copy of SmartDownloadProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? enabled = null,Object? policy = null,Object? sources = null,}) {
  return _then(SmartDownloadProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,policy: null == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as SmartDownloadPolicy,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<MediaSourceDescriptor>,
  ));
}
/// Create a copy of SmartDownloadProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SmartDownloadPolicyCopyWith<$Res> get policy {
  
  return $SmartDownloadPolicyCopyWith<$Res>(_self.policy, (value) {
    return _then(_self.copyWith(policy: value));
  });
}
}


/// Adds pattern-matching-related methods to [SmartDownloadProfile].
extension SmartDownloadProfilePatterns on SmartDownloadProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartDownloadProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartDownloadProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartDownloadProfile value)  $default,){
final _that = this;
switch (_that) {
case _SmartDownloadProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartDownloadProfile value)?  $default,){
final _that = this;
switch (_that) {
case _SmartDownloadProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  bool enabled,  SmartDownloadPolicy policy,  List<MediaSourceDescriptor> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartDownloadProfile() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.enabled,_that.policy,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  bool enabled,  SmartDownloadPolicy policy,  List<MediaSourceDescriptor> sources)  $default,) {final _that = this;
switch (_that) {
case _SmartDownloadProfile():
return $default(_that.id,_that.userId,_that.name,_that.enabled,_that.policy,_that.sources);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  bool enabled,  SmartDownloadPolicy policy,  List<MediaSourceDescriptor> sources)?  $default,) {final _that = this;
switch (_that) {
case _SmartDownloadProfile() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.enabled,_that.policy,_that.sources);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartDownloadProfile implements SmartDownloadProfile {
   _SmartDownloadProfile({required this.id, required this.userId, required this.name, this.enabled = true, this.policy = const SmartDownloadPolicy(), this.sources = const <MediaSourceDescriptor>[]});
  factory _SmartDownloadProfile.fromJson(Map<String, dynamic> json) => _$SmartDownloadProfileFromJson(json);

@override  String id;
@override  String userId;
@override  String name;
@override@JsonKey()  bool enabled;
@override@JsonKey()  SmartDownloadPolicy policy;
@override@JsonKey()  List<MediaSourceDescriptor> sources;

/// Create a copy of SmartDownloadProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartDownloadProfileCopyWith<_SmartDownloadProfile> get copyWith => __$SmartDownloadProfileCopyWithImpl<_SmartDownloadProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartDownloadProfileToJson(this, );
}



@override
String toString() {
  return 'SmartDownloadProfile(id: $id, userId: $userId, name: $name, enabled: $enabled, policy: $policy, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$SmartDownloadProfileCopyWith<$Res> implements $SmartDownloadProfileCopyWith<$Res> {
  factory _$SmartDownloadProfileCopyWith(_SmartDownloadProfile value, $Res Function(_SmartDownloadProfile) _then) = __$SmartDownloadProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, bool enabled, SmartDownloadPolicy policy, List<MediaSourceDescriptor> sources
});


@override $SmartDownloadPolicyCopyWith<$Res> get policy;

}
/// @nodoc
class __$SmartDownloadProfileCopyWithImpl<$Res>
    implements _$SmartDownloadProfileCopyWith<$Res> {
  __$SmartDownloadProfileCopyWithImpl(this._self, this._then);

  final _SmartDownloadProfile _self;
  final $Res Function(_SmartDownloadProfile) _then;

/// Create a copy of SmartDownloadProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? enabled = null,Object? policy = null,Object? sources = null,}) {
  return _then(_SmartDownloadProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,policy: null == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as SmartDownloadPolicy,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<MediaSourceDescriptor>,
  ));
}

/// Create a copy of SmartDownloadProfile
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SmartDownloadPolicyCopyWith<$Res> get policy {
  
  return $SmartDownloadPolicyCopyWith<$Res>(_self.policy, (value) {
    return _then(_self.copyWith(policy: value));
  });
}
}


/// @nodoc
mixin _$SmartDownloadClaim {

 String get profileId; PlayableRef get ref; MediaSourceDescriptor get source; String get state; int? get estimatedBytes; int? get completedAt;
/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartDownloadClaimCopyWith<SmartDownloadClaim> get copyWith => _$SmartDownloadClaimCopyWithImpl<SmartDownloadClaim>(this as SmartDownloadClaim, _$identity);

  /// Serializes this SmartDownloadClaim to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartDownloadClaim&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.source, source) || other.source == source)&&(identical(other.state, state) || other.state == state)&&(identical(other.estimatedBytes, estimatedBytes) || other.estimatedBytes == estimatedBytes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileId,ref,source,state,estimatedBytes,completedAt);

@override
String toString() {
  return 'SmartDownloadClaim(profileId: $profileId, ref: $ref, source: $source, state: $state, estimatedBytes: $estimatedBytes, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $SmartDownloadClaimCopyWith<$Res>  {
  factory $SmartDownloadClaimCopyWith(SmartDownloadClaim value, $Res Function(SmartDownloadClaim) _then) = _$SmartDownloadClaimCopyWithImpl;
@useResult
$Res call({
 String profileId, PlayableRef ref, MediaSourceDescriptor source, String state, int? estimatedBytes, int? completedAt
});


$PlayableRefCopyWith<$Res> get ref;$MediaSourceDescriptorCopyWith<$Res> get source;

}
/// @nodoc
class _$SmartDownloadClaimCopyWithImpl<$Res>
    implements $SmartDownloadClaimCopyWith<$Res> {
  _$SmartDownloadClaimCopyWithImpl(this._self, this._then);

  final SmartDownloadClaim _self;
  final $Res Function(SmartDownloadClaim) _then;

/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profileId = null,Object? ref = null,Object? source = null,Object? state = null,Object? estimatedBytes = freezed,Object? completedAt = freezed,}) {
  return _then(SmartDownloadClaim(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PlayableRef,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MediaSourceDescriptor,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,estimatedBytes: freezed == estimatedBytes ? _self.estimatedBytes : estimatedBytes // ignore: cast_nullable_to_non_nullable
as int?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res> get ref {
  
  return $PlayableRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaSourceDescriptorCopyWith<$Res> get source {
  
  return $MediaSourceDescriptorCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}


/// Adds pattern-matching-related methods to [SmartDownloadClaim].
extension SmartDownloadClaimPatterns on SmartDownloadClaim {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartDownloadClaim value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartDownloadClaim() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartDownloadClaim value)  $default,){
final _that = this;
switch (_that) {
case _SmartDownloadClaim():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartDownloadClaim value)?  $default,){
final _that = this;
switch (_that) {
case _SmartDownloadClaim() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String profileId,  PlayableRef ref,  MediaSourceDescriptor source,  String state,  int? estimatedBytes,  int? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartDownloadClaim() when $default != null:
return $default(_that.profileId,_that.ref,_that.source,_that.state,_that.estimatedBytes,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String profileId,  PlayableRef ref,  MediaSourceDescriptor source,  String state,  int? estimatedBytes,  int? completedAt)  $default,) {final _that = this;
switch (_that) {
case _SmartDownloadClaim():
return $default(_that.profileId,_that.ref,_that.source,_that.state,_that.estimatedBytes,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String profileId,  PlayableRef ref,  MediaSourceDescriptor source,  String state,  int? estimatedBytes,  int? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _SmartDownloadClaim() when $default != null:
return $default(_that.profileId,_that.ref,_that.source,_that.state,_that.estimatedBytes,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartDownloadClaim implements SmartDownloadClaim {
  const _SmartDownloadClaim({required this.profileId, required this.ref, required this.source, this.state = 'planned', this.estimatedBytes, this.completedAt});
  factory _SmartDownloadClaim.fromJson(Map<String, dynamic> json) => _$SmartDownloadClaimFromJson(json);

@override final  String profileId;
@override final  PlayableRef ref;
@override final  MediaSourceDescriptor source;
@override@JsonKey() final  String state;
@override final  int? estimatedBytes;
@override final  int? completedAt;

/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartDownloadClaimCopyWith<_SmartDownloadClaim> get copyWith => __$SmartDownloadClaimCopyWithImpl<_SmartDownloadClaim>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartDownloadClaimToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartDownloadClaim&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.source, source) || other.source == source)&&(identical(other.state, state) || other.state == state)&&(identical(other.estimatedBytes, estimatedBytes) || other.estimatedBytes == estimatedBytes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,profileId,ref,source,state,estimatedBytes,completedAt);

@override
String toString() {
  return 'SmartDownloadClaim(profileId: $profileId, ref: $ref, source: $source, state: $state, estimatedBytes: $estimatedBytes, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$SmartDownloadClaimCopyWith<$Res> implements $SmartDownloadClaimCopyWith<$Res> {
  factory _$SmartDownloadClaimCopyWith(_SmartDownloadClaim value, $Res Function(_SmartDownloadClaim) _then) = __$SmartDownloadClaimCopyWithImpl;
@override @useResult
$Res call({
 String profileId, PlayableRef ref, MediaSourceDescriptor source, String state, int? estimatedBytes, int? completedAt
});


@override $PlayableRefCopyWith<$Res> get ref;@override $MediaSourceDescriptorCopyWith<$Res> get source;

}
/// @nodoc
class __$SmartDownloadClaimCopyWithImpl<$Res>
    implements _$SmartDownloadClaimCopyWith<$Res> {
  __$SmartDownloadClaimCopyWithImpl(this._self, this._then);

  final _SmartDownloadClaim _self;
  final $Res Function(_SmartDownloadClaim) _then;

/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profileId = null,Object? ref = null,Object? source = null,Object? state = null,Object? estimatedBytes = freezed,Object? completedAt = freezed,}) {
  return _then(_SmartDownloadClaim(
profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as String,ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PlayableRef,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MediaSourceDescriptor,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,estimatedBytes: freezed == estimatedBytes ? _self.estimatedBytes : estimatedBytes // ignore: cast_nullable_to_non_nullable
as int?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res> get ref {
  
  return $PlayableRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}/// Create a copy of SmartDownloadClaim
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaSourceDescriptorCopyWith<$Res> get source {
  
  return $MediaSourceDescriptorCopyWith<$Res>(_self.source, (value) {
    return _then(_self.copyWith(source: value));
  });
}
}

// dart format on
