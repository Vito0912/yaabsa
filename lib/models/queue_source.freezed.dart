// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayableRef {

 String get itemId; String? get episodeId;
/// Create a copy of PlayableRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<PlayableRef> get copyWith => _$PlayableRefCopyWithImpl<PlayableRef>(this as PlayableRef, _$identity);

  /// Serializes this PlayableRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayableRef&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId);

@override
String toString() {
  return 'PlayableRef(itemId: $itemId, episodeId: $episodeId)';
}


}

/// @nodoc
abstract mixin class $PlayableRefCopyWith<$Res>  {
  factory $PlayableRefCopyWith(PlayableRef value, $Res Function(PlayableRef) _then) = _$PlayableRefCopyWithImpl;
@useResult
$Res call({
 String itemId, String? episodeId
});




}
/// @nodoc
class _$PlayableRefCopyWithImpl<$Res>
    implements $PlayableRefCopyWith<$Res> {
  _$PlayableRefCopyWithImpl(this._self, this._then);

  final PlayableRef _self;
  final $Res Function(PlayableRef) _then;

/// Create a copy of PlayableRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? episodeId = freezed,}) {
  return _then(PlayableRef(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayableRef].
extension PlayableRefPatterns on PlayableRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayableRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayableRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayableRef value)  $default,){
final _that = this;
switch (_that) {
case _PlayableRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayableRef value)?  $default,){
final _that = this;
switch (_that) {
case _PlayableRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String? episodeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayableRef() when $default != null:
return $default(_that.itemId,_that.episodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String? episodeId)  $default,) {final _that = this;
switch (_that) {
case _PlayableRef():
return $default(_that.itemId,_that.episodeId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String? episodeId)?  $default,) {final _that = this;
switch (_that) {
case _PlayableRef() when $default != null:
return $default(_that.itemId,_that.episodeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayableRef implements PlayableRef {
  const _PlayableRef({required this.itemId, this.episodeId});
  factory _PlayableRef.fromJson(Map<String, dynamic> json) => _$PlayableRefFromJson(json);

@override final  String itemId;
@override final  String? episodeId;

/// Create a copy of PlayableRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayableRefCopyWith<_PlayableRef> get copyWith => __$PlayableRefCopyWithImpl<_PlayableRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayableRefToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayableRef&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,itemId,episodeId);

@override
String toString() {
  return 'PlayableRef(itemId: $itemId, episodeId: $episodeId)';
}


}

/// @nodoc
abstract mixin class _$PlayableRefCopyWith<$Res> implements $PlayableRefCopyWith<$Res> {
  factory _$PlayableRefCopyWith(_PlayableRef value, $Res Function(_PlayableRef) _then) = __$PlayableRefCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String? episodeId
});




}
/// @nodoc
class __$PlayableRefCopyWithImpl<$Res>
    implements _$PlayableRefCopyWith<$Res> {
  __$PlayableRefCopyWithImpl(this._self, this._then);

  final _PlayableRef _self;
  final $Res Function(_PlayableRef) _then;

/// Create a copy of PlayableRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? episodeId = freezed,}) {
  return _then(_PlayableRef(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MediaSourceDescriptor {

 MediaSourceType get type; String get sourceId; String get libraryId; String? get displayName; bool get descending; int? get revision;
/// Create a copy of MediaSourceDescriptor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaSourceDescriptorCopyWith<MediaSourceDescriptor> get copyWith => _$MediaSourceDescriptorCopyWithImpl<MediaSourceDescriptor>(this as MediaSourceDescriptor, _$identity);

  /// Serializes this MediaSourceDescriptor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaSourceDescriptor&&(identical(other.type, type) || other.type == type)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.descending, descending) || other.descending == descending)&&(identical(other.revision, revision) || other.revision == revision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,sourceId,libraryId,displayName,descending,revision);

@override
String toString() {
  return 'MediaSourceDescriptor(type: $type, sourceId: $sourceId, libraryId: $libraryId, displayName: $displayName, descending: $descending, revision: $revision)';
}


}

/// @nodoc
abstract mixin class $MediaSourceDescriptorCopyWith<$Res>  {
  factory $MediaSourceDescriptorCopyWith(MediaSourceDescriptor value, $Res Function(MediaSourceDescriptor) _then) = _$MediaSourceDescriptorCopyWithImpl;
@useResult
$Res call({
 MediaSourceType type, String sourceId, String libraryId, String? displayName, bool descending, int? revision
});




}
/// @nodoc
class _$MediaSourceDescriptorCopyWithImpl<$Res>
    implements $MediaSourceDescriptorCopyWith<$Res> {
  _$MediaSourceDescriptorCopyWithImpl(this._self, this._then);

  final MediaSourceDescriptor _self;
  final $Res Function(MediaSourceDescriptor) _then;

/// Create a copy of MediaSourceDescriptor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? sourceId = null,Object? libraryId = null,Object? displayName = freezed,Object? descending = null,Object? revision = freezed,}) {
  return _then(MediaSourceDescriptor(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MediaSourceType,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,descending: null == descending ? _self.descending : descending // ignore: cast_nullable_to_non_nullable
as bool,revision: freezed == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaSourceDescriptor].
extension MediaSourceDescriptorPatterns on MediaSourceDescriptor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaSourceDescriptor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaSourceDescriptor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaSourceDescriptor value)  $default,){
final _that = this;
switch (_that) {
case _MediaSourceDescriptor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaSourceDescriptor value)?  $default,){
final _that = this;
switch (_that) {
case _MediaSourceDescriptor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MediaSourceType type,  String sourceId,  String libraryId,  String? displayName,  bool descending,  int? revision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaSourceDescriptor() when $default != null:
return $default(_that.type,_that.sourceId,_that.libraryId,_that.displayName,_that.descending,_that.revision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MediaSourceType type,  String sourceId,  String libraryId,  String? displayName,  bool descending,  int? revision)  $default,) {final _that = this;
switch (_that) {
case _MediaSourceDescriptor():
return $default(_that.type,_that.sourceId,_that.libraryId,_that.displayName,_that.descending,_that.revision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MediaSourceType type,  String sourceId,  String libraryId,  String? displayName,  bool descending,  int? revision)?  $default,) {final _that = this;
switch (_that) {
case _MediaSourceDescriptor() when $default != null:
return $default(_that.type,_that.sourceId,_that.libraryId,_that.displayName,_that.descending,_that.revision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaSourceDescriptor implements MediaSourceDescriptor {
  const _MediaSourceDescriptor({required this.type, required this.sourceId, required this.libraryId, this.displayName, this.descending = false, this.revision});
  factory _MediaSourceDescriptor.fromJson(Map<String, dynamic> json) => _$MediaSourceDescriptorFromJson(json);

@override final  MediaSourceType type;
@override final  String sourceId;
@override final  String libraryId;
@override final  String? displayName;
@override@JsonKey() final  bool descending;
@override final  int? revision;

/// Create a copy of MediaSourceDescriptor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaSourceDescriptorCopyWith<_MediaSourceDescriptor> get copyWith => __$MediaSourceDescriptorCopyWithImpl<_MediaSourceDescriptor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaSourceDescriptorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaSourceDescriptor&&(identical(other.type, type) || other.type == type)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.descending, descending) || other.descending == descending)&&(identical(other.revision, revision) || other.revision == revision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,sourceId,libraryId,displayName,descending,revision);

@override
String toString() {
  return 'MediaSourceDescriptor(type: $type, sourceId: $sourceId, libraryId: $libraryId, displayName: $displayName, descending: $descending, revision: $revision)';
}


}

/// @nodoc
abstract mixin class _$MediaSourceDescriptorCopyWith<$Res> implements $MediaSourceDescriptorCopyWith<$Res> {
  factory _$MediaSourceDescriptorCopyWith(_MediaSourceDescriptor value, $Res Function(_MediaSourceDescriptor) _then) = __$MediaSourceDescriptorCopyWithImpl;
@override @useResult
$Res call({
 MediaSourceType type, String sourceId, String libraryId, String? displayName, bool descending, int? revision
});




}
/// @nodoc
class __$MediaSourceDescriptorCopyWithImpl<$Res>
    implements _$MediaSourceDescriptorCopyWith<$Res> {
  __$MediaSourceDescriptorCopyWithImpl(this._self, this._then);

  final _MediaSourceDescriptor _self;
  final $Res Function(_MediaSourceDescriptor) _then;

/// Create a copy of MediaSourceDescriptor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? sourceId = null,Object? libraryId = null,Object? displayName = freezed,Object? descending = null,Object? revision = freezed,}) {
  return _then(_MediaSourceDescriptor(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MediaSourceType,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,descending: null == descending ? _self.descending : descending // ignore: cast_nullable_to_non_nullable
as bool,revision: freezed == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QueueCandidate {

 PlayableRef get ref; String? get title; String? get subtitle; String? get author; int? get order; int? get addedAt; int? get publishedAt; int? get estimatedBytes; bool get isFinished;
/// Create a copy of QueueCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueCandidateCopyWith<QueueCandidate> get copyWith => _$QueueCandidateCopyWithImpl<QueueCandidate>(this as QueueCandidate, _$identity);

  /// Serializes this QueueCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueCandidate&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.author, author) || other.author == author)&&(identical(other.order, order) || other.order == order)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.estimatedBytes, estimatedBytes) || other.estimatedBytes == estimatedBytes)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref,title,subtitle,author,order,addedAt,publishedAt,estimatedBytes,isFinished);

@override
String toString() {
  return 'QueueCandidate(ref: $ref, title: $title, subtitle: $subtitle, author: $author, order: $order, addedAt: $addedAt, publishedAt: $publishedAt, estimatedBytes: $estimatedBytes, isFinished: $isFinished)';
}


}

/// @nodoc
abstract mixin class $QueueCandidateCopyWith<$Res>  {
  factory $QueueCandidateCopyWith(QueueCandidate value, $Res Function(QueueCandidate) _then) = _$QueueCandidateCopyWithImpl;
@useResult
$Res call({
 PlayableRef ref, String? title, String? subtitle, String? author, int? order, int? addedAt, int? publishedAt, int? estimatedBytes, bool isFinished
});


$PlayableRefCopyWith<$Res> get ref;

}
/// @nodoc
class _$QueueCandidateCopyWithImpl<$Res>
    implements $QueueCandidateCopyWith<$Res> {
  _$QueueCandidateCopyWithImpl(this._self, this._then);

  final QueueCandidate _self;
  final $Res Function(QueueCandidate) _then;

/// Create a copy of QueueCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? title = freezed,Object? subtitle = freezed,Object? author = freezed,Object? order = freezed,Object? addedAt = freezed,Object? publishedAt = freezed,Object? estimatedBytes = freezed,Object? isFinished = null,}) {
  return _then(QueueCandidate(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PlayableRef,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as int?,estimatedBytes: freezed == estimatedBytes ? _self.estimatedBytes : estimatedBytes // ignore: cast_nullable_to_non_nullable
as int?,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of QueueCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res> get ref {
  
  return $PlayableRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueCandidate].
extension QueueCandidatePatterns on QueueCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueCandidate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueCandidate value)  $default,){
final _that = this;
switch (_that) {
case _QueueCandidate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _QueueCandidate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayableRef ref,  String? title,  String? subtitle,  String? author,  int? order,  int? addedAt,  int? publishedAt,  int? estimatedBytes,  bool isFinished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueCandidate() when $default != null:
return $default(_that.ref,_that.title,_that.subtitle,_that.author,_that.order,_that.addedAt,_that.publishedAt,_that.estimatedBytes,_that.isFinished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayableRef ref,  String? title,  String? subtitle,  String? author,  int? order,  int? addedAt,  int? publishedAt,  int? estimatedBytes,  bool isFinished)  $default,) {final _that = this;
switch (_that) {
case _QueueCandidate():
return $default(_that.ref,_that.title,_that.subtitle,_that.author,_that.order,_that.addedAt,_that.publishedAt,_that.estimatedBytes,_that.isFinished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayableRef ref,  String? title,  String? subtitle,  String? author,  int? order,  int? addedAt,  int? publishedAt,  int? estimatedBytes,  bool isFinished)?  $default,) {final _that = this;
switch (_that) {
case _QueueCandidate() when $default != null:
return $default(_that.ref,_that.title,_that.subtitle,_that.author,_that.order,_that.addedAt,_that.publishedAt,_that.estimatedBytes,_that.isFinished);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueCandidate implements QueueCandidate {
  const _QueueCandidate({required this.ref, this.title, this.subtitle, this.author, this.order, this.addedAt, this.publishedAt, this.estimatedBytes, this.isFinished = false});
  factory _QueueCandidate.fromJson(Map<String, dynamic> json) => _$QueueCandidateFromJson(json);

@override final  PlayableRef ref;
@override final  String? title;
@override final  String? subtitle;
@override final  String? author;
@override final  int? order;
@override final  int? addedAt;
@override final  int? publishedAt;
@override final  int? estimatedBytes;
@override@JsonKey() final  bool isFinished;

/// Create a copy of QueueCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueCandidateCopyWith<_QueueCandidate> get copyWith => __$QueueCandidateCopyWithImpl<_QueueCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueCandidate&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.author, author) || other.author == author)&&(identical(other.order, order) || other.order == order)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.estimatedBytes, estimatedBytes) || other.estimatedBytes == estimatedBytes)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref,title,subtitle,author,order,addedAt,publishedAt,estimatedBytes,isFinished);

@override
String toString() {
  return 'QueueCandidate(ref: $ref, title: $title, subtitle: $subtitle, author: $author, order: $order, addedAt: $addedAt, publishedAt: $publishedAt, estimatedBytes: $estimatedBytes, isFinished: $isFinished)';
}


}

/// @nodoc
abstract mixin class _$QueueCandidateCopyWith<$Res> implements $QueueCandidateCopyWith<$Res> {
  factory _$QueueCandidateCopyWith(_QueueCandidate value, $Res Function(_QueueCandidate) _then) = __$QueueCandidateCopyWithImpl;
@override @useResult
$Res call({
 PlayableRef ref, String? title, String? subtitle, String? author, int? order, int? addedAt, int? publishedAt, int? estimatedBytes, bool isFinished
});


@override $PlayableRefCopyWith<$Res> get ref;

}
/// @nodoc
class __$QueueCandidateCopyWithImpl<$Res>
    implements _$QueueCandidateCopyWith<$Res> {
  __$QueueCandidateCopyWithImpl(this._self, this._then);

  final _QueueCandidate _self;
  final $Res Function(_QueueCandidate) _then;

/// Create a copy of QueueCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? title = freezed,Object? subtitle = freezed,Object? author = freezed,Object? order = freezed,Object? addedAt = freezed,Object? publishedAt = freezed,Object? estimatedBytes = freezed,Object? isFinished = null,}) {
  return _then(_QueueCandidate(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PlayableRef,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int?,addedAt: freezed == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as int?,publishedAt: freezed == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as int?,estimatedBytes: freezed == estimatedBytes ? _self.estimatedBytes : estimatedBytes // ignore: cast_nullable_to_non_nullable
as int?,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of QueueCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res> get ref {
  
  return $PlayableRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}
}


/// @nodoc
mixin _$CandidatePage {

 List<QueueCandidate> get candidates; set candidates(List<QueueCandidate> value); int? get total; set total(int? value); int? get page; set page(int? value); int? get pageSize; set pageSize(int? value); String? get nextCursor; set nextCursor(String? value); int? get revision; set revision(int? value);
/// Create a copy of CandidatePage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CandidatePageCopyWith<CandidatePage> get copyWith => _$CandidatePageCopyWithImpl<CandidatePage>(this as CandidatePage, _$identity);

  /// Serializes this CandidatePage to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'CandidatePage(candidates: $candidates, total: $total, page: $page, pageSize: $pageSize, nextCursor: $nextCursor, revision: $revision)';
}


}

/// @nodoc
abstract mixin class $CandidatePageCopyWith<$Res>  {
  factory $CandidatePageCopyWith(CandidatePage value, $Res Function(CandidatePage) _then) = _$CandidatePageCopyWithImpl;
@useResult
$Res call({
 List<QueueCandidate> candidates, int? total, int? page, int? pageSize, String? nextCursor, int? revision
});




}
/// @nodoc
class _$CandidatePageCopyWithImpl<$Res>
    implements $CandidatePageCopyWith<$Res> {
  _$CandidatePageCopyWithImpl(this._self, this._then);

  final CandidatePage _self;
  final $Res Function(CandidatePage) _then;

/// Create a copy of CandidatePage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? candidates = null,Object? total = freezed,Object? page = freezed,Object? pageSize = freezed,Object? nextCursor = freezed,Object? revision = freezed,}) {
  return _then(CandidatePage(
candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<QueueCandidate>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,pageSize: freezed == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int?,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,revision: freezed == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CandidatePage].
extension CandidatePagePatterns on CandidatePage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CandidatePage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CandidatePage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CandidatePage value)  $default,){
final _that = this;
switch (_that) {
case _CandidatePage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CandidatePage value)?  $default,){
final _that = this;
switch (_that) {
case _CandidatePage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<QueueCandidate> candidates,  int? total,  int? page,  int? pageSize,  String? nextCursor,  int? revision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CandidatePage() when $default != null:
return $default(_that.candidates,_that.total,_that.page,_that.pageSize,_that.nextCursor,_that.revision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<QueueCandidate> candidates,  int? total,  int? page,  int? pageSize,  String? nextCursor,  int? revision)  $default,) {final _that = this;
switch (_that) {
case _CandidatePage():
return $default(_that.candidates,_that.total,_that.page,_that.pageSize,_that.nextCursor,_that.revision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<QueueCandidate> candidates,  int? total,  int? page,  int? pageSize,  String? nextCursor,  int? revision)?  $default,) {final _that = this;
switch (_that) {
case _CandidatePage() when $default != null:
return $default(_that.candidates,_that.total,_that.page,_that.pageSize,_that.nextCursor,_that.revision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CandidatePage implements CandidatePage {
   _CandidatePage({this.candidates = const <QueueCandidate>[], this.total, this.page, this.pageSize, this.nextCursor, this.revision});
  factory _CandidatePage.fromJson(Map<String, dynamic> json) => _$CandidatePageFromJson(json);

@override@JsonKey()  List<QueueCandidate> candidates;
@override  int? total;
@override  int? page;
@override  int? pageSize;
@override  String? nextCursor;
@override  int? revision;

/// Create a copy of CandidatePage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CandidatePageCopyWith<_CandidatePage> get copyWith => __$CandidatePageCopyWithImpl<_CandidatePage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CandidatePageToJson(this, );
}



@override
String toString() {
  return 'CandidatePage(candidates: $candidates, total: $total, page: $page, pageSize: $pageSize, nextCursor: $nextCursor, revision: $revision)';
}


}

/// @nodoc
abstract mixin class _$CandidatePageCopyWith<$Res> implements $CandidatePageCopyWith<$Res> {
  factory _$CandidatePageCopyWith(_CandidatePage value, $Res Function(_CandidatePage) _then) = __$CandidatePageCopyWithImpl;
@override @useResult
$Res call({
 List<QueueCandidate> candidates, int? total, int? page, int? pageSize, String? nextCursor, int? revision
});




}
/// @nodoc
class __$CandidatePageCopyWithImpl<$Res>
    implements _$CandidatePageCopyWith<$Res> {
  __$CandidatePageCopyWithImpl(this._self, this._then);

  final _CandidatePage _self;
  final $Res Function(_CandidatePage) _then;

/// Create a copy of CandidatePage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? candidates = null,Object? total = freezed,Object? page = freezed,Object? pageSize = freezed,Object? nextCursor = freezed,Object? revision = freezed,}) {
  return _then(_CandidatePage(
candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<QueueCandidate>,total: freezed == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int?,page: freezed == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int?,pageSize: freezed == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int?,nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,revision: freezed == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$QueueIntentEntry {

 PlayableRef get ref; String? get title; String? get subtitle; String? get author;
/// Create a copy of QueueIntentEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueIntentEntryCopyWith<QueueIntentEntry> get copyWith => _$QueueIntentEntryCopyWithImpl<QueueIntentEntry>(this as QueueIntentEntry, _$identity);

  /// Serializes this QueueIntentEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueIntentEntry&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref,title,subtitle,author);

@override
String toString() {
  return 'QueueIntentEntry(ref: $ref, title: $title, subtitle: $subtitle, author: $author)';
}


}

/// @nodoc
abstract mixin class $QueueIntentEntryCopyWith<$Res>  {
  factory $QueueIntentEntryCopyWith(QueueIntentEntry value, $Res Function(QueueIntentEntry) _then) = _$QueueIntentEntryCopyWithImpl;
@useResult
$Res call({
 PlayableRef ref, String? title, String? subtitle, String? author
});


$PlayableRefCopyWith<$Res> get ref;

}
/// @nodoc
class _$QueueIntentEntryCopyWithImpl<$Res>
    implements $QueueIntentEntryCopyWith<$Res> {
  _$QueueIntentEntryCopyWithImpl(this._self, this._then);

  final QueueIntentEntry _self;
  final $Res Function(QueueIntentEntry) _then;

/// Create a copy of QueueIntentEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = null,Object? title = freezed,Object? subtitle = freezed,Object? author = freezed,}) {
  return _then(QueueIntentEntry(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PlayableRef,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of QueueIntentEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res> get ref {
  
  return $PlayableRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueIntentEntry].
extension QueueIntentEntryPatterns on QueueIntentEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueIntentEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueIntentEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueIntentEntry value)  $default,){
final _that = this;
switch (_that) {
case _QueueIntentEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueIntentEntry value)?  $default,){
final _that = this;
switch (_that) {
case _QueueIntentEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlayableRef ref,  String? title,  String? subtitle,  String? author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueIntentEntry() when $default != null:
return $default(_that.ref,_that.title,_that.subtitle,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlayableRef ref,  String? title,  String? subtitle,  String? author)  $default,) {final _that = this;
switch (_that) {
case _QueueIntentEntry():
return $default(_that.ref,_that.title,_that.subtitle,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlayableRef ref,  String? title,  String? subtitle,  String? author)?  $default,) {final _that = this;
switch (_that) {
case _QueueIntentEntry() when $default != null:
return $default(_that.ref,_that.title,_that.subtitle,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueIntentEntry implements QueueIntentEntry {
  const _QueueIntentEntry({required this.ref, this.title, this.subtitle, this.author});
  factory _QueueIntentEntry.fromJson(Map<String, dynamic> json) => _$QueueIntentEntryFromJson(json);

@override final  PlayableRef ref;
@override final  String? title;
@override final  String? subtitle;
@override final  String? author;

/// Create a copy of QueueIntentEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueIntentEntryCopyWith<_QueueIntentEntry> get copyWith => __$QueueIntentEntryCopyWithImpl<_QueueIntentEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueIntentEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueIntentEntry&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ref,title,subtitle,author);

@override
String toString() {
  return 'QueueIntentEntry(ref: $ref, title: $title, subtitle: $subtitle, author: $author)';
}


}

/// @nodoc
abstract mixin class _$QueueIntentEntryCopyWith<$Res> implements $QueueIntentEntryCopyWith<$Res> {
  factory _$QueueIntentEntryCopyWith(_QueueIntentEntry value, $Res Function(_QueueIntentEntry) _then) = __$QueueIntentEntryCopyWithImpl;
@override @useResult
$Res call({
 PlayableRef ref, String? title, String? subtitle, String? author
});


@override $PlayableRefCopyWith<$Res> get ref;

}
/// @nodoc
class __$QueueIntentEntryCopyWithImpl<$Res>
    implements _$QueueIntentEntryCopyWith<$Res> {
  __$QueueIntentEntryCopyWithImpl(this._self, this._then);

  final _QueueIntentEntry _self;
  final $Res Function(_QueueIntentEntry) _then;

/// Create a copy of QueueIntentEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = null,Object? title = freezed,Object? subtitle = freezed,Object? author = freezed,}) {
  return _then(_QueueIntentEntry(
ref: null == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as PlayableRef,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,subtitle: freezed == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String?,author: freezed == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of QueueIntentEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res> get ref {
  
  return $PlayableRefCopyWith<$Res>(_self.ref, (value) {
    return _then(_self.copyWith(ref: value));
  });
}
}


/// @nodoc
mixin _$QueueIntentSnapshot {

 int get version; set version(int value); List<QueueIntentEntry> get manualEntries; set manualEntries(List<QueueIntentEntry> value); MediaSourceDescriptor? get source; set source(MediaSourceDescriptor? value); PlayableRef? get anchor; set anchor(PlayableRef? value); List<PlayableRef> get suppressed; set suppressed(List<PlayableRef> value); int? get sourceRevision; set sourceRevision(int? value);
/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueIntentSnapshotCopyWith<QueueIntentSnapshot> get copyWith => _$QueueIntentSnapshotCopyWithImpl<QueueIntentSnapshot>(this as QueueIntentSnapshot, _$identity);

  /// Serializes this QueueIntentSnapshot to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'QueueIntentSnapshot(version: $version, manualEntries: $manualEntries, source: $source, anchor: $anchor, suppressed: $suppressed, sourceRevision: $sourceRevision)';
}


}

/// @nodoc
abstract mixin class $QueueIntentSnapshotCopyWith<$Res>  {
  factory $QueueIntentSnapshotCopyWith(QueueIntentSnapshot value, $Res Function(QueueIntentSnapshot) _then) = _$QueueIntentSnapshotCopyWithImpl;
@useResult
$Res call({
 int version, List<QueueIntentEntry> manualEntries, MediaSourceDescriptor? source, PlayableRef? anchor, List<PlayableRef> suppressed, int? sourceRevision
});


$MediaSourceDescriptorCopyWith<$Res>? get source;$PlayableRefCopyWith<$Res>? get anchor;

}
/// @nodoc
class _$QueueIntentSnapshotCopyWithImpl<$Res>
    implements $QueueIntentSnapshotCopyWith<$Res> {
  _$QueueIntentSnapshotCopyWithImpl(this._self, this._then);

  final QueueIntentSnapshot _self;
  final $Res Function(QueueIntentSnapshot) _then;

/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? manualEntries = null,Object? source = freezed,Object? anchor = freezed,Object? suppressed = null,Object? sourceRevision = freezed,}) {
  return _then(QueueIntentSnapshot(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,manualEntries: null == manualEntries ? _self.manualEntries : manualEntries // ignore: cast_nullable_to_non_nullable
as List<QueueIntentEntry>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MediaSourceDescriptor?,anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as PlayableRef?,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as List<PlayableRef>,sourceRevision: freezed == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaSourceDescriptorCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $MediaSourceDescriptorCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $PlayableRefCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueIntentSnapshot].
extension QueueIntentSnapshotPatterns on QueueIntentSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueIntentSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueIntentSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueIntentSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _QueueIntentSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueIntentSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _QueueIntentSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<QueueIntentEntry> manualEntries,  MediaSourceDescriptor? source,  PlayableRef? anchor,  List<PlayableRef> suppressed,  int? sourceRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueIntentSnapshot() when $default != null:
return $default(_that.version,_that.manualEntries,_that.source,_that.anchor,_that.suppressed,_that.sourceRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<QueueIntentEntry> manualEntries,  MediaSourceDescriptor? source,  PlayableRef? anchor,  List<PlayableRef> suppressed,  int? sourceRevision)  $default,) {final _that = this;
switch (_that) {
case _QueueIntentSnapshot():
return $default(_that.version,_that.manualEntries,_that.source,_that.anchor,_that.suppressed,_that.sourceRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<QueueIntentEntry> manualEntries,  MediaSourceDescriptor? source,  PlayableRef? anchor,  List<PlayableRef> suppressed,  int? sourceRevision)?  $default,) {final _that = this;
switch (_that) {
case _QueueIntentSnapshot() when $default != null:
return $default(_that.version,_that.manualEntries,_that.source,_that.anchor,_that.suppressed,_that.sourceRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QueueIntentSnapshot implements QueueIntentSnapshot {
   _QueueIntentSnapshot({this.version = 1, this.manualEntries = const <QueueIntentEntry>[], this.source, this.anchor, this.suppressed = const <PlayableRef>[], this.sourceRevision});
  factory _QueueIntentSnapshot.fromJson(Map<String, dynamic> json) => _$QueueIntentSnapshotFromJson(json);

@override@JsonKey()  int version;
@override@JsonKey()  List<QueueIntentEntry> manualEntries;
@override  MediaSourceDescriptor? source;
@override  PlayableRef? anchor;
@override@JsonKey()  List<PlayableRef> suppressed;
@override  int? sourceRevision;

/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueIntentSnapshotCopyWith<_QueueIntentSnapshot> get copyWith => __$QueueIntentSnapshotCopyWithImpl<_QueueIntentSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QueueIntentSnapshotToJson(this, );
}



@override
String toString() {
  return 'QueueIntentSnapshot(version: $version, manualEntries: $manualEntries, source: $source, anchor: $anchor, suppressed: $suppressed, sourceRevision: $sourceRevision)';
}


}

/// @nodoc
abstract mixin class _$QueueIntentSnapshotCopyWith<$Res> implements $QueueIntentSnapshotCopyWith<$Res> {
  factory _$QueueIntentSnapshotCopyWith(_QueueIntentSnapshot value, $Res Function(_QueueIntentSnapshot) _then) = __$QueueIntentSnapshotCopyWithImpl;
@override @useResult
$Res call({
 int version, List<QueueIntentEntry> manualEntries, MediaSourceDescriptor? source, PlayableRef? anchor, List<PlayableRef> suppressed, int? sourceRevision
});


@override $MediaSourceDescriptorCopyWith<$Res>? get source;@override $PlayableRefCopyWith<$Res>? get anchor;

}
/// @nodoc
class __$QueueIntentSnapshotCopyWithImpl<$Res>
    implements _$QueueIntentSnapshotCopyWith<$Res> {
  __$QueueIntentSnapshotCopyWithImpl(this._self, this._then);

  final _QueueIntentSnapshot _self;
  final $Res Function(_QueueIntentSnapshot) _then;

/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? manualEntries = null,Object? source = freezed,Object? anchor = freezed,Object? suppressed = null,Object? sourceRevision = freezed,}) {
  return _then(_QueueIntentSnapshot(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,manualEntries: null == manualEntries ? _self.manualEntries : manualEntries // ignore: cast_nullable_to_non_nullable
as List<QueueIntentEntry>,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as MediaSourceDescriptor?,anchor: freezed == anchor ? _self.anchor : anchor // ignore: cast_nullable_to_non_nullable
as PlayableRef?,suppressed: null == suppressed ? _self.suppressed : suppressed // ignore: cast_nullable_to_non_nullable
as List<PlayableRef>,sourceRevision: freezed == sourceRevision ? _self.sourceRevision : sourceRevision // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MediaSourceDescriptorCopyWith<$Res>? get source {
    if (_self.source == null) {
    return null;
  }

  return $MediaSourceDescriptorCopyWith<$Res>(_self.source!, (value) {
    return _then(_self.copyWith(source: value));
  });
}/// Create a copy of QueueIntentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayableRefCopyWith<$Res>? get anchor {
    if (_self.anchor == null) {
    return null;
  }

  return $PlayableRefCopyWith<$Res>(_self.anchor!, (value) {
    return _then(_self.copyWith(anchor: value));
  });
}
}

// dart format on
