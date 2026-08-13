// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'podcast_minified.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PodcastMinified {

@JsonKey(name: 'metadata') PodcastMetadata get metadata;@JsonKey(name: 'coverPath') String? get coverPath;@JsonKey(name: 'tags') List<String> get tags;@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? get numEpisodes;@JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic) bool? get autoDownloadEpisodes;@JsonKey(name: 'autoDownloadSchedule') String? get autoDownloadSchedule;@JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic) int? get lastEpisodeCheck;@JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic) int? get maxEpisodesToKeep;@JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic) int? get maxNewEpisodesToDownload;@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? get size;
/// Create a copy of PodcastMinified
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PodcastMinifiedCopyWith<PodcastMinified> get copyWith => _$PodcastMinifiedCopyWithImpl<PodcastMinified>(this as PodcastMinified, _$identity);

  /// Serializes this PodcastMinified to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PodcastMinified&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.numEpisodes, numEpisodes) || other.numEpisodes == numEpisodes)&&(identical(other.autoDownloadEpisodes, autoDownloadEpisodes) || other.autoDownloadEpisodes == autoDownloadEpisodes)&&(identical(other.autoDownloadSchedule, autoDownloadSchedule) || other.autoDownloadSchedule == autoDownloadSchedule)&&(identical(other.lastEpisodeCheck, lastEpisodeCheck) || other.lastEpisodeCheck == lastEpisodeCheck)&&(identical(other.maxEpisodesToKeep, maxEpisodesToKeep) || other.maxEpisodesToKeep == maxEpisodesToKeep)&&(identical(other.maxNewEpisodesToDownload, maxNewEpisodesToDownload) || other.maxNewEpisodesToDownload == maxNewEpisodesToDownload)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,coverPath,const DeepCollectionEquality().hash(tags),numEpisodes,autoDownloadEpisodes,autoDownloadSchedule,lastEpisodeCheck,maxEpisodesToKeep,maxNewEpisodesToDownload,size);

@override
String toString() {
  return 'PodcastMinified(metadata: $metadata, coverPath: $coverPath, tags: $tags, numEpisodes: $numEpisodes, autoDownloadEpisodes: $autoDownloadEpisodes, autoDownloadSchedule: $autoDownloadSchedule, lastEpisodeCheck: $lastEpisodeCheck, maxEpisodesToKeep: $maxEpisodesToKeep, maxNewEpisodesToDownload: $maxNewEpisodesToDownload, size: $size)';
}


}

/// @nodoc
abstract mixin class $PodcastMinifiedCopyWith<$Res>  {
  factory $PodcastMinifiedCopyWith(PodcastMinified value, $Res Function(PodcastMinified) _then) = _$PodcastMinifiedCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'metadata') PodcastMetadata metadata,@JsonKey(name: 'coverPath') String? coverPath,@JsonKey(name: 'tags') List<String> tags,@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? numEpisodes,@JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic) bool? autoDownloadEpisodes,@JsonKey(name: 'autoDownloadSchedule') String? autoDownloadSchedule,@JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic) int? lastEpisodeCheck,@JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic) int? maxEpisodesToKeep,@JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic) int? maxNewEpisodesToDownload,@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? size
});


$PodcastMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class _$PodcastMinifiedCopyWithImpl<$Res>
    implements $PodcastMinifiedCopyWith<$Res> {
  _$PodcastMinifiedCopyWithImpl(this._self, this._then);

  final PodcastMinified _self;
  final $Res Function(PodcastMinified) _then;

/// Create a copy of PodcastMinified
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? metadata = null,Object? coverPath = freezed,Object? tags = null,Object? numEpisodes = freezed,Object? autoDownloadEpisodes = freezed,Object? autoDownloadSchedule = freezed,Object? lastEpisodeCheck = freezed,Object? maxEpisodesToKeep = freezed,Object? maxNewEpisodesToDownload = freezed,Object? size = freezed,}) {
  return _then(PodcastMinified(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PodcastMetadata,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,numEpisodes: freezed == numEpisodes ? _self.numEpisodes : numEpisodes // ignore: cast_nullable_to_non_nullable
as int?,autoDownloadEpisodes: freezed == autoDownloadEpisodes ? _self.autoDownloadEpisodes : autoDownloadEpisodes // ignore: cast_nullable_to_non_nullable
as bool?,autoDownloadSchedule: freezed == autoDownloadSchedule ? _self.autoDownloadSchedule : autoDownloadSchedule // ignore: cast_nullable_to_non_nullable
as String?,lastEpisodeCheck: freezed == lastEpisodeCheck ? _self.lastEpisodeCheck : lastEpisodeCheck // ignore: cast_nullable_to_non_nullable
as int?,maxEpisodesToKeep: freezed == maxEpisodesToKeep ? _self.maxEpisodesToKeep : maxEpisodesToKeep // ignore: cast_nullable_to_non_nullable
as int?,maxNewEpisodesToDownload: freezed == maxNewEpisodesToDownload ? _self.maxNewEpisodesToDownload : maxNewEpisodesToDownload // ignore: cast_nullable_to_non_nullable
as int?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of PodcastMinified
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<$Res> get metadata {
  
  return $PodcastMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}


/// Adds pattern-matching-related methods to [PodcastMinified].
extension PodcastMinifiedPatterns on PodcastMinified {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PodcastMinified value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PodcastMinified() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PodcastMinified value)  $default,){
final _that = this;
switch (_that) {
case _PodcastMinified():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PodcastMinified value)?  $default,){
final _that = this;
switch (_that) {
case _PodcastMinified() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  PodcastMetadata metadata, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'tags')  List<String> tags, @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic)  int? numEpisodes, @JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic)  bool? autoDownloadEpisodes, @JsonKey(name: 'autoDownloadSchedule')  String? autoDownloadSchedule, @JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic)  int? lastEpisodeCheck, @JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic)  int? maxEpisodesToKeep, @JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic)  int? maxNewEpisodesToDownload, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic)  int? size)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PodcastMinified() when $default != null:
return $default(_that.metadata,_that.coverPath,_that.tags,_that.numEpisodes,_that.autoDownloadEpisodes,_that.autoDownloadSchedule,_that.lastEpisodeCheck,_that.maxEpisodesToKeep,_that.maxNewEpisodesToDownload,_that.size);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'metadata')  PodcastMetadata metadata, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'tags')  List<String> tags, @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic)  int? numEpisodes, @JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic)  bool? autoDownloadEpisodes, @JsonKey(name: 'autoDownloadSchedule')  String? autoDownloadSchedule, @JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic)  int? lastEpisodeCheck, @JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic)  int? maxEpisodesToKeep, @JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic)  int? maxNewEpisodesToDownload, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic)  int? size)  $default,) {final _that = this;
switch (_that) {
case _PodcastMinified():
return $default(_that.metadata,_that.coverPath,_that.tags,_that.numEpisodes,_that.autoDownloadEpisodes,_that.autoDownloadSchedule,_that.lastEpisodeCheck,_that.maxEpisodesToKeep,_that.maxNewEpisodesToDownload,_that.size);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'metadata')  PodcastMetadata metadata, @JsonKey(name: 'coverPath')  String? coverPath, @JsonKey(name: 'tags')  List<String> tags, @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic)  int? numEpisodes, @JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic)  bool? autoDownloadEpisodes, @JsonKey(name: 'autoDownloadSchedule')  String? autoDownloadSchedule, @JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic)  int? lastEpisodeCheck, @JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic)  int? maxEpisodesToKeep, @JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic)  int? maxNewEpisodesToDownload, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic)  int? size)?  $default,) {final _that = this;
switch (_that) {
case _PodcastMinified() when $default != null:
return $default(_that.metadata,_that.coverPath,_that.tags,_that.numEpisodes,_that.autoDownloadEpisodes,_that.autoDownloadSchedule,_that.lastEpisodeCheck,_that.maxEpisodesToKeep,_that.maxNewEpisodesToDownload,_that.size);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PodcastMinified implements PodcastMinified {
  const _PodcastMinified({@JsonKey(name: 'metadata') required this.metadata, @JsonKey(name: 'coverPath') this.coverPath, @JsonKey(name: 'tags')  List<String> tags = const <String>[], @JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) this.numEpisodes, @JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic) this.autoDownloadEpisodes, @JsonKey(name: 'autoDownloadSchedule') this.autoDownloadSchedule, @JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic) this.lastEpisodeCheck, @JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic) this.maxEpisodesToKeep, @JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic) this.maxNewEpisodesToDownload, @JsonKey(name: 'size', fromJson: jsonIntFromDynamic) this.size}): _tags = tags;
  factory _PodcastMinified.fromJson(Map<String, dynamic> json) => _$PodcastMinifiedFromJson(json);

@override@JsonKey(name: 'metadata') final  PodcastMetadata metadata;
@override@JsonKey(name: 'coverPath') final  String? coverPath;
 final  List<String> _tags;
@override@JsonKey(name: 'tags') List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) final  int? numEpisodes;
@override@JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic) final  bool? autoDownloadEpisodes;
@override@JsonKey(name: 'autoDownloadSchedule') final  String? autoDownloadSchedule;
@override@JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic) final  int? lastEpisodeCheck;
@override@JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic) final  int? maxEpisodesToKeep;
@override@JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic) final  int? maxNewEpisodesToDownload;
@override@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) final  int? size;

/// Create a copy of PodcastMinified
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PodcastMinifiedCopyWith<_PodcastMinified> get copyWith => __$PodcastMinifiedCopyWithImpl<_PodcastMinified>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PodcastMinifiedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PodcastMinified&&(identical(other.metadata, metadata) || other.metadata == metadata)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.numEpisodes, numEpisodes) || other.numEpisodes == numEpisodes)&&(identical(other.autoDownloadEpisodes, autoDownloadEpisodes) || other.autoDownloadEpisodes == autoDownloadEpisodes)&&(identical(other.autoDownloadSchedule, autoDownloadSchedule) || other.autoDownloadSchedule == autoDownloadSchedule)&&(identical(other.lastEpisodeCheck, lastEpisodeCheck) || other.lastEpisodeCheck == lastEpisodeCheck)&&(identical(other.maxEpisodesToKeep, maxEpisodesToKeep) || other.maxEpisodesToKeep == maxEpisodesToKeep)&&(identical(other.maxNewEpisodesToDownload, maxNewEpisodesToDownload) || other.maxNewEpisodesToDownload == maxNewEpisodesToDownload)&&(identical(other.size, size) || other.size == size));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,metadata,coverPath,const DeepCollectionEquality().hash(_tags),numEpisodes,autoDownloadEpisodes,autoDownloadSchedule,lastEpisodeCheck,maxEpisodesToKeep,maxNewEpisodesToDownload,size);

@override
String toString() {
  return 'PodcastMinified(metadata: $metadata, coverPath: $coverPath, tags: $tags, numEpisodes: $numEpisodes, autoDownloadEpisodes: $autoDownloadEpisodes, autoDownloadSchedule: $autoDownloadSchedule, lastEpisodeCheck: $lastEpisodeCheck, maxEpisodesToKeep: $maxEpisodesToKeep, maxNewEpisodesToDownload: $maxNewEpisodesToDownload, size: $size)';
}


}

/// @nodoc
abstract mixin class _$PodcastMinifiedCopyWith<$Res> implements $PodcastMinifiedCopyWith<$Res> {
  factory _$PodcastMinifiedCopyWith(_PodcastMinified value, $Res Function(_PodcastMinified) _then) = __$PodcastMinifiedCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'metadata') PodcastMetadata metadata,@JsonKey(name: 'coverPath') String? coverPath,@JsonKey(name: 'tags') List<String> tags,@JsonKey(name: 'numEpisodes', fromJson: jsonIntFromDynamic) int? numEpisodes,@JsonKey(name: 'autoDownloadEpisodes', fromJson: jsonBoolFromDynamic) bool? autoDownloadEpisodes,@JsonKey(name: 'autoDownloadSchedule') String? autoDownloadSchedule,@JsonKey(name: 'lastEpisodeCheck', fromJson: jsonIntFromDynamic) int? lastEpisodeCheck,@JsonKey(name: 'maxEpisodesToKeep', fromJson: jsonIntFromDynamic) int? maxEpisodesToKeep,@JsonKey(name: 'maxNewEpisodesToDownload', fromJson: jsonIntFromDynamic) int? maxNewEpisodesToDownload,@JsonKey(name: 'size', fromJson: jsonIntFromDynamic) int? size
});


@override $PodcastMetadataCopyWith<$Res> get metadata;

}
/// @nodoc
class __$PodcastMinifiedCopyWithImpl<$Res>
    implements _$PodcastMinifiedCopyWith<$Res> {
  __$PodcastMinifiedCopyWithImpl(this._self, this._then);

  final _PodcastMinified _self;
  final $Res Function(_PodcastMinified) _then;

/// Create a copy of PodcastMinified
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? metadata = null,Object? coverPath = freezed,Object? tags = null,Object? numEpisodes = freezed,Object? autoDownloadEpisodes = freezed,Object? autoDownloadSchedule = freezed,Object? lastEpisodeCheck = freezed,Object? maxEpisodesToKeep = freezed,Object? maxNewEpisodesToDownload = freezed,Object? size = freezed,}) {
  return _then(_PodcastMinified(
metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as PodcastMetadata,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,numEpisodes: freezed == numEpisodes ? _self.numEpisodes : numEpisodes // ignore: cast_nullable_to_non_nullable
as int?,autoDownloadEpisodes: freezed == autoDownloadEpisodes ? _self.autoDownloadEpisodes : autoDownloadEpisodes // ignore: cast_nullable_to_non_nullable
as bool?,autoDownloadSchedule: freezed == autoDownloadSchedule ? _self.autoDownloadSchedule : autoDownloadSchedule // ignore: cast_nullable_to_non_nullable
as String?,lastEpisodeCheck: freezed == lastEpisodeCheck ? _self.lastEpisodeCheck : lastEpisodeCheck // ignore: cast_nullable_to_non_nullable
as int?,maxEpisodesToKeep: freezed == maxEpisodesToKeep ? _self.maxEpisodesToKeep : maxEpisodesToKeep // ignore: cast_nullable_to_non_nullable
as int?,maxNewEpisodesToDownload: freezed == maxNewEpisodesToDownload ? _self.maxNewEpisodesToDownload : maxNewEpisodesToDownload // ignore: cast_nullable_to_non_nullable
as int?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of PodcastMinified
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PodcastMetadataCopyWith<$Res> get metadata {
  
  return $PodcastMetadataCopyWith<$Res>(_self.metadata, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
