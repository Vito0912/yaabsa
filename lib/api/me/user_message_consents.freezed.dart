// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_message_consents.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserMessageConsents {

@JsonKey(name: 'consents') List<UserMessageConsentEntry> get consents;@JsonKey(name: 'incomingRequests') List<UserMessageIncomingRequest> get incomingRequests;@JsonKey(name: 'blockedUserIds') List<String> get blockedUserIds;
/// Create a copy of UserMessageConsents
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMessageConsentsCopyWith<UserMessageConsents> get copyWith => _$UserMessageConsentsCopyWithImpl<UserMessageConsents>(this as UserMessageConsents, _$identity);

  /// Serializes this UserMessageConsents to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMessageConsents&&const DeepCollectionEquality().equals(other.consents, consents)&&const DeepCollectionEquality().equals(other.incomingRequests, incomingRequests)&&const DeepCollectionEquality().equals(other.blockedUserIds, blockedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(consents),const DeepCollectionEquality().hash(incomingRequests),const DeepCollectionEquality().hash(blockedUserIds));

@override
String toString() {
  return 'UserMessageConsents(consents: $consents, incomingRequests: $incomingRequests, blockedUserIds: $blockedUserIds)';
}


}

/// @nodoc
abstract mixin class $UserMessageConsentsCopyWith<$Res>  {
  factory $UserMessageConsentsCopyWith(UserMessageConsents value, $Res Function(UserMessageConsents) _then) = _$UserMessageConsentsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'consents') List<UserMessageConsentEntry> consents,@JsonKey(name: 'incomingRequests') List<UserMessageIncomingRequest> incomingRequests,@JsonKey(name: 'blockedUserIds') List<String> blockedUserIds
});




}
/// @nodoc
class _$UserMessageConsentsCopyWithImpl<$Res>
    implements $UserMessageConsentsCopyWith<$Res> {
  _$UserMessageConsentsCopyWithImpl(this._self, this._then);

  final UserMessageConsents _self;
  final $Res Function(UserMessageConsents) _then;

/// Create a copy of UserMessageConsents
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consents = null,Object? incomingRequests = null,Object? blockedUserIds = null,}) {
  return _then(_self.copyWith(
consents: null == consents ? _self.consents : consents // ignore: cast_nullable_to_non_nullable
as List<UserMessageConsentEntry>,incomingRequests: null == incomingRequests ? _self.incomingRequests : incomingRequests // ignore: cast_nullable_to_non_nullable
as List<UserMessageIncomingRequest>,blockedUserIds: null == blockedUserIds ? _self.blockedUserIds : blockedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMessageConsents].
extension UserMessageConsentsPatterns on UserMessageConsents {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserMessageConsents value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserMessageConsents() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserMessageConsents value)  $default,){
final _that = this;
switch (_that) {
case _UserMessageConsents():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserMessageConsents value)?  $default,){
final _that = this;
switch (_that) {
case _UserMessageConsents() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'consents')  List<UserMessageConsentEntry> consents, @JsonKey(name: 'incomingRequests')  List<UserMessageIncomingRequest> incomingRequests, @JsonKey(name: 'blockedUserIds')  List<String> blockedUserIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserMessageConsents() when $default != null:
return $default(_that.consents,_that.incomingRequests,_that.blockedUserIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'consents')  List<UserMessageConsentEntry> consents, @JsonKey(name: 'incomingRequests')  List<UserMessageIncomingRequest> incomingRequests, @JsonKey(name: 'blockedUserIds')  List<String> blockedUserIds)  $default,) {final _that = this;
switch (_that) {
case _UserMessageConsents():
return $default(_that.consents,_that.incomingRequests,_that.blockedUserIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'consents')  List<UserMessageConsentEntry> consents, @JsonKey(name: 'incomingRequests')  List<UserMessageIncomingRequest> incomingRequests, @JsonKey(name: 'blockedUserIds')  List<String> blockedUserIds)?  $default,) {final _that = this;
switch (_that) {
case _UserMessageConsents() when $default != null:
return $default(_that.consents,_that.incomingRequests,_that.blockedUserIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserMessageConsents implements UserMessageConsents {
  const _UserMessageConsents({@JsonKey(name: 'consents') final  List<UserMessageConsentEntry> consents = const <UserMessageConsentEntry>[], @JsonKey(name: 'incomingRequests') final  List<UserMessageIncomingRequest> incomingRequests = const <UserMessageIncomingRequest>[], @JsonKey(name: 'blockedUserIds') final  List<String> blockedUserIds = const <String>[]}): _consents = consents,_incomingRequests = incomingRequests,_blockedUserIds = blockedUserIds;
  factory _UserMessageConsents.fromJson(Map<String, dynamic> json) => _$UserMessageConsentsFromJson(json);

 final  List<UserMessageConsentEntry> _consents;
@override@JsonKey(name: 'consents') List<UserMessageConsentEntry> get consents {
  if (_consents is EqualUnmodifiableListView) return _consents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_consents);
}

 final  List<UserMessageIncomingRequest> _incomingRequests;
@override@JsonKey(name: 'incomingRequests') List<UserMessageIncomingRequest> get incomingRequests {
  if (_incomingRequests is EqualUnmodifiableListView) return _incomingRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_incomingRequests);
}

 final  List<String> _blockedUserIds;
@override@JsonKey(name: 'blockedUserIds') List<String> get blockedUserIds {
  if (_blockedUserIds is EqualUnmodifiableListView) return _blockedUserIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blockedUserIds);
}


/// Create a copy of UserMessageConsents
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserMessageConsentsCopyWith<_UserMessageConsents> get copyWith => __$UserMessageConsentsCopyWithImpl<_UserMessageConsents>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserMessageConsentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserMessageConsents&&const DeepCollectionEquality().equals(other._consents, _consents)&&const DeepCollectionEquality().equals(other._incomingRequests, _incomingRequests)&&const DeepCollectionEquality().equals(other._blockedUserIds, _blockedUserIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_consents),const DeepCollectionEquality().hash(_incomingRequests),const DeepCollectionEquality().hash(_blockedUserIds));

@override
String toString() {
  return 'UserMessageConsents(consents: $consents, incomingRequests: $incomingRequests, blockedUserIds: $blockedUserIds)';
}


}

/// @nodoc
abstract mixin class _$UserMessageConsentsCopyWith<$Res> implements $UserMessageConsentsCopyWith<$Res> {
  factory _$UserMessageConsentsCopyWith(_UserMessageConsents value, $Res Function(_UserMessageConsents) _then) = __$UserMessageConsentsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'consents') List<UserMessageConsentEntry> consents,@JsonKey(name: 'incomingRequests') List<UserMessageIncomingRequest> incomingRequests,@JsonKey(name: 'blockedUserIds') List<String> blockedUserIds
});




}
/// @nodoc
class __$UserMessageConsentsCopyWithImpl<$Res>
    implements _$UserMessageConsentsCopyWith<$Res> {
  __$UserMessageConsentsCopyWithImpl(this._self, this._then);

  final _UserMessageConsents _self;
  final $Res Function(_UserMessageConsents) _then;

/// Create a copy of UserMessageConsents
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consents = null,Object? incomingRequests = null,Object? blockedUserIds = null,}) {
  return _then(_UserMessageConsents(
consents: null == consents ? _self._consents : consents // ignore: cast_nullable_to_non_nullable
as List<UserMessageConsentEntry>,incomingRequests: null == incomingRequests ? _self._incomingRequests : incomingRequests // ignore: cast_nullable_to_non_nullable
as List<UserMessageIncomingRequest>,blockedUserIds: null == blockedUserIds ? _self._blockedUserIds : blockedUserIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$UserMessageConsentEntry {

@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'username') String? get username;@JsonKey(name: 'otherAccepted') bool get otherAccepted;
/// Create a copy of UserMessageConsentEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMessageConsentEntryCopyWith<UserMessageConsentEntry> get copyWith => _$UserMessageConsentEntryCopyWithImpl<UserMessageConsentEntry>(this as UserMessageConsentEntry, _$identity);

  /// Serializes this UserMessageConsentEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMessageConsentEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.otherAccepted, otherAccepted) || other.otherAccepted == otherAccepted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,otherAccepted);

@override
String toString() {
  return 'UserMessageConsentEntry(userId: $userId, username: $username, otherAccepted: $otherAccepted)';
}


}

/// @nodoc
abstract mixin class $UserMessageConsentEntryCopyWith<$Res>  {
  factory $UserMessageConsentEntryCopyWith(UserMessageConsentEntry value, $Res Function(UserMessageConsentEntry) _then) = _$UserMessageConsentEntryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'username') String? username,@JsonKey(name: 'otherAccepted') bool otherAccepted
});




}
/// @nodoc
class _$UserMessageConsentEntryCopyWithImpl<$Res>
    implements $UserMessageConsentEntryCopyWith<$Res> {
  _$UserMessageConsentEntryCopyWithImpl(this._self, this._then);

  final UserMessageConsentEntry _self;
  final $Res Function(UserMessageConsentEntry) _then;

/// Create a copy of UserMessageConsentEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = freezed,Object? otherAccepted = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,otherAccepted: null == otherAccepted ? _self.otherAccepted : otherAccepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMessageConsentEntry].
extension UserMessageConsentEntryPatterns on UserMessageConsentEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserMessageConsentEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserMessageConsentEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserMessageConsentEntry value)  $default,){
final _that = this;
switch (_that) {
case _UserMessageConsentEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserMessageConsentEntry value)?  $default,){
final _that = this;
switch (_that) {
case _UserMessageConsentEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'username')  String? username, @JsonKey(name: 'otherAccepted')  bool otherAccepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserMessageConsentEntry() when $default != null:
return $default(_that.userId,_that.username,_that.otherAccepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'username')  String? username, @JsonKey(name: 'otherAccepted')  bool otherAccepted)  $default,) {final _that = this;
switch (_that) {
case _UserMessageConsentEntry():
return $default(_that.userId,_that.username,_that.otherAccepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'username')  String? username, @JsonKey(name: 'otherAccepted')  bool otherAccepted)?  $default,) {final _that = this;
switch (_that) {
case _UserMessageConsentEntry() when $default != null:
return $default(_that.userId,_that.username,_that.otherAccepted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserMessageConsentEntry implements UserMessageConsentEntry {
  const _UserMessageConsentEntry({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'username') this.username, @JsonKey(name: 'otherAccepted') this.otherAccepted = false});
  factory _UserMessageConsentEntry.fromJson(Map<String, dynamic> json) => _$UserMessageConsentEntryFromJson(json);

@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'username') final  String? username;
@override@JsonKey(name: 'otherAccepted') final  bool otherAccepted;

/// Create a copy of UserMessageConsentEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserMessageConsentEntryCopyWith<_UserMessageConsentEntry> get copyWith => __$UserMessageConsentEntryCopyWithImpl<_UserMessageConsentEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserMessageConsentEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserMessageConsentEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username)&&(identical(other.otherAccepted, otherAccepted) || other.otherAccepted == otherAccepted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username,otherAccepted);

@override
String toString() {
  return 'UserMessageConsentEntry(userId: $userId, username: $username, otherAccepted: $otherAccepted)';
}


}

/// @nodoc
abstract mixin class _$UserMessageConsentEntryCopyWith<$Res> implements $UserMessageConsentEntryCopyWith<$Res> {
  factory _$UserMessageConsentEntryCopyWith(_UserMessageConsentEntry value, $Res Function(_UserMessageConsentEntry) _then) = __$UserMessageConsentEntryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'username') String? username,@JsonKey(name: 'otherAccepted') bool otherAccepted
});




}
/// @nodoc
class __$UserMessageConsentEntryCopyWithImpl<$Res>
    implements _$UserMessageConsentEntryCopyWith<$Res> {
  __$UserMessageConsentEntryCopyWithImpl(this._self, this._then);

  final _UserMessageConsentEntry _self;
  final $Res Function(_UserMessageConsentEntry) _then;

/// Create a copy of UserMessageConsentEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = freezed,Object? otherAccepted = null,}) {
  return _then(_UserMessageConsentEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,otherAccepted: null == otherAccepted ? _self.otherAccepted : otherAccepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$UserMessageIncomingRequest {

@JsonKey(name: 'userId') String get userId;@JsonKey(name: 'username') String? get username;
/// Create a copy of UserMessageIncomingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserMessageIncomingRequestCopyWith<UserMessageIncomingRequest> get copyWith => _$UserMessageIncomingRequestCopyWithImpl<UserMessageIncomingRequest>(this as UserMessageIncomingRequest, _$identity);

  /// Serializes this UserMessageIncomingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserMessageIncomingRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username);

@override
String toString() {
  return 'UserMessageIncomingRequest(userId: $userId, username: $username)';
}


}

/// @nodoc
abstract mixin class $UserMessageIncomingRequestCopyWith<$Res>  {
  factory $UserMessageIncomingRequestCopyWith(UserMessageIncomingRequest value, $Res Function(UserMessageIncomingRequest) _then) = _$UserMessageIncomingRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'username') String? username
});




}
/// @nodoc
class _$UserMessageIncomingRequestCopyWithImpl<$Res>
    implements $UserMessageIncomingRequestCopyWith<$Res> {
  _$UserMessageIncomingRequestCopyWithImpl(this._self, this._then);

  final UserMessageIncomingRequest _self;
  final $Res Function(UserMessageIncomingRequest) _then;

/// Create a copy of UserMessageIncomingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? username = freezed,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserMessageIncomingRequest].
extension UserMessageIncomingRequestPatterns on UserMessageIncomingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserMessageIncomingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserMessageIncomingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserMessageIncomingRequest value)  $default,){
final _that = this;
switch (_that) {
case _UserMessageIncomingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserMessageIncomingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UserMessageIncomingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'username')  String? username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserMessageIncomingRequest() when $default != null:
return $default(_that.userId,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'username')  String? username)  $default,) {final _that = this;
switch (_that) {
case _UserMessageIncomingRequest():
return $default(_that.userId,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'userId')  String userId, @JsonKey(name: 'username')  String? username)?  $default,) {final _that = this;
switch (_that) {
case _UserMessageIncomingRequest() when $default != null:
return $default(_that.userId,_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserMessageIncomingRequest implements UserMessageIncomingRequest {
  const _UserMessageIncomingRequest({@JsonKey(name: 'userId') required this.userId, @JsonKey(name: 'username') this.username});
  factory _UserMessageIncomingRequest.fromJson(Map<String, dynamic> json) => _$UserMessageIncomingRequestFromJson(json);

@override@JsonKey(name: 'userId') final  String userId;
@override@JsonKey(name: 'username') final  String? username;

/// Create a copy of UserMessageIncomingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserMessageIncomingRequestCopyWith<_UserMessageIncomingRequest> get copyWith => __$UserMessageIncomingRequestCopyWithImpl<_UserMessageIncomingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserMessageIncomingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserMessageIncomingRequest&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,username);

@override
String toString() {
  return 'UserMessageIncomingRequest(userId: $userId, username: $username)';
}


}

/// @nodoc
abstract mixin class _$UserMessageIncomingRequestCopyWith<$Res> implements $UserMessageIncomingRequestCopyWith<$Res> {
  factory _$UserMessageIncomingRequestCopyWith(_UserMessageIncomingRequest value, $Res Function(_UserMessageIncomingRequest) _then) = __$UserMessageIncomingRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'userId') String userId,@JsonKey(name: 'username') String? username
});




}
/// @nodoc
class __$UserMessageIncomingRequestCopyWithImpl<$Res>
    implements _$UserMessageIncomingRequestCopyWith<$Res> {
  __$UserMessageIncomingRequestCopyWithImpl(this._self, this._then);

  final _UserMessageIncomingRequest _self;
  final $Res Function(_UserMessageIncomingRequest) _then;

/// Create a copy of UserMessageIncomingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? username = freezed,}) {
  return _then(_UserMessageIncomingRequest(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
