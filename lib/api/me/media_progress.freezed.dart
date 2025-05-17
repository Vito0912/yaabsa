// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaProgress {

@JsonKey(name: "id") String get id;@JsonKey(name: "userId") String get userId;@JsonKey(name: "libraryItemId") String get libraryItemId;@JsonKey(name: "episodeId") String? get episodeId;@JsonKey(name: "mediaItemId") String get mediaItemId;@JsonKey(name: "mediaItemType")@MediaItemTypeConverter() MediaItemType get mediaItemType;@JsonKey(name: "duration") double get duration;@JsonKey(name: "progress") double get progress;@JsonKey(name: "currentTime") double get currentTime;@JsonKey(name: "isFinished") bool get isFinished;@JsonKey(name: "hideFromContinueListening") bool get hideFromContinueListening;@JsonKey(name: "ebookLocation") String? get ebookLocation;@JsonKey(name: "ebookProgress") double? get ebookProgress;@JsonKey(name: "lastUpdate") int? get lastUpdate;@JsonKey(name: "startedAt") int get startedAt;@JsonKey(name: "finishedAt") int? get finishedAt;
/// Create a copy of MediaProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaProgressCopyWith<MediaProgress> get copyWith => _$MediaProgressCopyWithImpl<MediaProgress>(this as MediaProgress, _$identity);

  /// Serializes this MediaProgress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.mediaItemId, mediaItemId) || other.mediaItemId == mediaItemId)&&(identical(other.mediaItemType, mediaItemType) || other.mediaItemType == mediaItemType)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.hideFromContinueListening, hideFromContinueListening) || other.hideFromContinueListening == hideFromContinueListening)&&(identical(other.ebookLocation, ebookLocation) || other.ebookLocation == ebookLocation)&&(identical(other.ebookProgress, ebookProgress) || other.ebookProgress == ebookProgress)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,libraryItemId,episodeId,mediaItemId,mediaItemType,duration,progress,currentTime,isFinished,hideFromContinueListening,ebookLocation,ebookProgress,lastUpdate,startedAt,finishedAt);

@override
String toString() {
  return 'MediaProgress(id: $id, userId: $userId, libraryItemId: $libraryItemId, episodeId: $episodeId, mediaItemId: $mediaItemId, mediaItemType: $mediaItemType, duration: $duration, progress: $progress, currentTime: $currentTime, isFinished: $isFinished, hideFromContinueListening: $hideFromContinueListening, ebookLocation: $ebookLocation, ebookProgress: $ebookProgress, lastUpdate: $lastUpdate, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class $MediaProgressCopyWith<$Res>  {
  factory $MediaProgressCopyWith(MediaProgress value, $Res Function(MediaProgress) _then) = _$MediaProgressCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "userId") String userId,@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "mediaItemId") String mediaItemId,@JsonKey(name: "mediaItemType")@MediaItemTypeConverter() MediaItemType mediaItemType,@JsonKey(name: "duration") double duration,@JsonKey(name: "progress") double progress,@JsonKey(name: "currentTime") double currentTime,@JsonKey(name: "isFinished") bool isFinished,@JsonKey(name: "hideFromContinueListening") bool hideFromContinueListening,@JsonKey(name: "ebookLocation") String? ebookLocation,@JsonKey(name: "ebookProgress") double? ebookProgress,@JsonKey(name: "lastUpdate") int? lastUpdate,@JsonKey(name: "startedAt") int startedAt,@JsonKey(name: "finishedAt") int? finishedAt
});




}
/// @nodoc
class _$MediaProgressCopyWithImpl<$Res>
    implements $MediaProgressCopyWith<$Res> {
  _$MediaProgressCopyWithImpl(this._self, this._then);

  final MediaProgress _self;
  final $Res Function(MediaProgress) _then;

/// Create a copy of MediaProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? libraryItemId = null,Object? episodeId = freezed,Object? mediaItemId = null,Object? mediaItemType = null,Object? duration = null,Object? progress = null,Object? currentTime = null,Object? isFinished = null,Object? hideFromContinueListening = null,Object? ebookLocation = freezed,Object? ebookProgress = freezed,Object? lastUpdate = freezed,Object? startedAt = null,Object? finishedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,mediaItemId: null == mediaItemId ? _self.mediaItemId : mediaItemId // ignore: cast_nullable_to_non_nullable
as String,mediaItemType: null == mediaItemType ? _self.mediaItemType : mediaItemType // ignore: cast_nullable_to_non_nullable
as MediaItemType,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentTime: null == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,hideFromContinueListening: null == hideFromContinueListening ? _self.hideFromContinueListening : hideFromContinueListening // ignore: cast_nullable_to_non_nullable
as bool,ebookLocation: freezed == ebookLocation ? _self.ebookLocation : ebookLocation // ignore: cast_nullable_to_non_nullable
as String?,ebookProgress: freezed == ebookProgress ? _self.ebookProgress : ebookProgress // ignore: cast_nullable_to_non_nullable
as double?,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as int?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _MediaProgress implements MediaProgress {
  const _MediaProgress({@JsonKey(name: "id") required this.id, @JsonKey(name: "userId") required this.userId, @JsonKey(name: "libraryItemId") required this.libraryItemId, @JsonKey(name: "episodeId") required this.episodeId, @JsonKey(name: "mediaItemId") required this.mediaItemId, @JsonKey(name: "mediaItemType")@MediaItemTypeConverter() required this.mediaItemType, @JsonKey(name: "duration") required this.duration, @JsonKey(name: "progress") required this.progress, @JsonKey(name: "currentTime") required this.currentTime, @JsonKey(name: "isFinished") required this.isFinished, @JsonKey(name: "hideFromContinueListening") required this.hideFromContinueListening, @JsonKey(name: "ebookLocation") required this.ebookLocation, @JsonKey(name: "ebookProgress") required this.ebookProgress, @JsonKey(name: "lastUpdate") required this.lastUpdate, @JsonKey(name: "startedAt") required this.startedAt, @JsonKey(name: "finishedAt") required this.finishedAt});
  factory _MediaProgress.fromJson(Map<String, dynamic> json) => _$MediaProgressFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "userId") final  String userId;
@override@JsonKey(name: "libraryItemId") final  String libraryItemId;
@override@JsonKey(name: "episodeId") final  String? episodeId;
@override@JsonKey(name: "mediaItemId") final  String mediaItemId;
@override@JsonKey(name: "mediaItemType")@MediaItemTypeConverter() final  MediaItemType mediaItemType;
@override@JsonKey(name: "duration") final  double duration;
@override@JsonKey(name: "progress") final  double progress;
@override@JsonKey(name: "currentTime") final  double currentTime;
@override@JsonKey(name: "isFinished") final  bool isFinished;
@override@JsonKey(name: "hideFromContinueListening") final  bool hideFromContinueListening;
@override@JsonKey(name: "ebookLocation") final  String? ebookLocation;
@override@JsonKey(name: "ebookProgress") final  double? ebookProgress;
@override@JsonKey(name: "lastUpdate") final  int? lastUpdate;
@override@JsonKey(name: "startedAt") final  int startedAt;
@override@JsonKey(name: "finishedAt") final  int? finishedAt;

/// Create a copy of MediaProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaProgressCopyWith<_MediaProgress> get copyWith => __$MediaProgressCopyWithImpl<_MediaProgress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaProgressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaProgress&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.mediaItemId, mediaItemId) || other.mediaItemId == mediaItemId)&&(identical(other.mediaItemType, mediaItemType) || other.mediaItemType == mediaItemType)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished)&&(identical(other.hideFromContinueListening, hideFromContinueListening) || other.hideFromContinueListening == hideFromContinueListening)&&(identical(other.ebookLocation, ebookLocation) || other.ebookLocation == ebookLocation)&&(identical(other.ebookProgress, ebookProgress) || other.ebookProgress == ebookProgress)&&(identical(other.lastUpdate, lastUpdate) || other.lastUpdate == lastUpdate)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,libraryItemId,episodeId,mediaItemId,mediaItemType,duration,progress,currentTime,isFinished,hideFromContinueListening,ebookLocation,ebookProgress,lastUpdate,startedAt,finishedAt);

@override
String toString() {
  return 'MediaProgress(id: $id, userId: $userId, libraryItemId: $libraryItemId, episodeId: $episodeId, mediaItemId: $mediaItemId, mediaItemType: $mediaItemType, duration: $duration, progress: $progress, currentTime: $currentTime, isFinished: $isFinished, hideFromContinueListening: $hideFromContinueListening, ebookLocation: $ebookLocation, ebookProgress: $ebookProgress, lastUpdate: $lastUpdate, startedAt: $startedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$MediaProgressCopyWith<$Res> implements $MediaProgressCopyWith<$Res> {
  factory _$MediaProgressCopyWith(_MediaProgress value, $Res Function(_MediaProgress) _then) = __$MediaProgressCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "userId") String userId,@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "mediaItemId") String mediaItemId,@JsonKey(name: "mediaItemType")@MediaItemTypeConverter() MediaItemType mediaItemType,@JsonKey(name: "duration") double duration,@JsonKey(name: "progress") double progress,@JsonKey(name: "currentTime") double currentTime,@JsonKey(name: "isFinished") bool isFinished,@JsonKey(name: "hideFromContinueListening") bool hideFromContinueListening,@JsonKey(name: "ebookLocation") String? ebookLocation,@JsonKey(name: "ebookProgress") double? ebookProgress,@JsonKey(name: "lastUpdate") int? lastUpdate,@JsonKey(name: "startedAt") int startedAt,@JsonKey(name: "finishedAt") int? finishedAt
});




}
/// @nodoc
class __$MediaProgressCopyWithImpl<$Res>
    implements _$MediaProgressCopyWith<$Res> {
  __$MediaProgressCopyWithImpl(this._self, this._then);

  final _MediaProgress _self;
  final $Res Function(_MediaProgress) _then;

/// Create a copy of MediaProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? libraryItemId = null,Object? episodeId = freezed,Object? mediaItemId = null,Object? mediaItemType = null,Object? duration = null,Object? progress = null,Object? currentTime = null,Object? isFinished = null,Object? hideFromContinueListening = null,Object? ebookLocation = freezed,Object? ebookProgress = freezed,Object? lastUpdate = freezed,Object? startedAt = null,Object? finishedAt = freezed,}) {
  return _then(_MediaProgress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,mediaItemId: null == mediaItemId ? _self.mediaItemId : mediaItemId // ignore: cast_nullable_to_non_nullable
as String,mediaItemType: null == mediaItemType ? _self.mediaItemType : mediaItemType // ignore: cast_nullable_to_non_nullable
as MediaItemType,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,currentTime: null == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,hideFromContinueListening: null == hideFromContinueListening ? _self.hideFromContinueListening : hideFromContinueListening // ignore: cast_nullable_to_non_nullable
as bool,ebookLocation: freezed == ebookLocation ? _self.ebookLocation : ebookLocation // ignore: cast_nullable_to_non_nullable
as String?,ebookProgress: freezed == ebookProgress ? _self.ebookProgress : ebookProgress // ignore: cast_nullable_to_non_nullable
as double?,lastUpdate: freezed == lastUpdate ? _self.lastUpdate : lastUpdate // ignore: cast_nullable_to_non_nullable
as int?,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
