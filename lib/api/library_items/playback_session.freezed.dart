// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaybackSession {

@JsonKey(name: "id") String get id;@JsonKey(name: "userId") String get userId;@JsonKey(name: "libraryId") String get libraryId;@JsonKey(name: "libraryItemId") String get libraryItemId;@JsonKey(name: "episodeId") String? get episodeId;@JsonKey(name: "mediaType") String? get mediaType;@JsonKey(name: "mediaMetadata") Metadata? get mediaMetadata;@JsonKey(name: "chapters") List<Chapter>? get chapters;@JsonKey(name: "displayTitle") String? get displayTitle;@JsonKey(name: "displayAuthor") String? get displayAuthor;@JsonKey(name: "coverPath") String? get coverPath;@JsonKey(name: "duration") double? get duration;@JsonKey(name: "playMethod") int? get playMethod;@JsonKey(name: "mediaPlayer") String? get mediaPlayer;@JsonKey(name: "deviceInfo") DeviceInfo? get deviceInfo;@JsonKey(name: "serverVersion") String? get serverVersion;@JsonKey(name: "date") String? get date;@JsonKey(name: "dayOfWeek") String? get dayOfWeek;@JsonKey(name: "timeListening") double? get timeListening;@JsonKey(name: "startTime") double? get startTime;@JsonKey(name: "currentTime") double? get currentTime;@JsonKey(name: "startedAt") int? get startedAt;@JsonKey(name: "updatedAt") int? get updatedAt;@JsonKey(name: "audioTracks") List<AudioTrack>? get audioTracks;@JsonKey(name: "libraryItem") LibraryItem? get libraryItem;
/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackSessionCopyWith<PlaybackSession> get copyWith => _$PlaybackSessionCopyWithImpl<PlaybackSession>(this as PlaybackSession, _$identity);

  /// Serializes this PlaybackSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.mediaMetadata, mediaMetadata) || other.mediaMetadata == mediaMetadata)&&const DeepCollectionEquality().equals(other.chapters, chapters)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.displayAuthor, displayAuthor) || other.displayAuthor == displayAuthor)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playMethod, playMethod) || other.playMethod == playMethod)&&(identical(other.mediaPlayer, mediaPlayer) || other.mediaPlayer == mediaPlayer)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.date, date) || other.date == date)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.timeListening, timeListening) || other.timeListening == timeListening)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.audioTracks, audioTracks)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,libraryId,libraryItemId,episodeId,mediaType,mediaMetadata,const DeepCollectionEquality().hash(chapters),displayTitle,displayAuthor,coverPath,duration,playMethod,mediaPlayer,deviceInfo,serverVersion,date,dayOfWeek,timeListening,startTime,currentTime,startedAt,updatedAt,const DeepCollectionEquality().hash(audioTracks),libraryItem]);

@override
String toString() {
  return 'PlaybackSession(id: $id, userId: $userId, libraryId: $libraryId, libraryItemId: $libraryItemId, episodeId: $episodeId, mediaType: $mediaType, mediaMetadata: $mediaMetadata, chapters: $chapters, displayTitle: $displayTitle, displayAuthor: $displayAuthor, coverPath: $coverPath, duration: $duration, playMethod: $playMethod, mediaPlayer: $mediaPlayer, deviceInfo: $deviceInfo, serverVersion: $serverVersion, date: $date, dayOfWeek: $dayOfWeek, timeListening: $timeListening, startTime: $startTime, currentTime: $currentTime, startedAt: $startedAt, updatedAt: $updatedAt, audioTracks: $audioTracks, libraryItem: $libraryItem)';
}


}

/// @nodoc
abstract mixin class $PlaybackSessionCopyWith<$Res>  {
  factory $PlaybackSessionCopyWith(PlaybackSession value, $Res Function(PlaybackSession) _then) = _$PlaybackSessionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "userId") String userId,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "mediaType") String? mediaType,@JsonKey(name: "mediaMetadata") Metadata? mediaMetadata,@JsonKey(name: "chapters") List<Chapter>? chapters,@JsonKey(name: "displayTitle") String? displayTitle,@JsonKey(name: "displayAuthor") String? displayAuthor,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "duration") double? duration,@JsonKey(name: "playMethod") int? playMethod,@JsonKey(name: "mediaPlayer") String? mediaPlayer,@JsonKey(name: "deviceInfo") DeviceInfo? deviceInfo,@JsonKey(name: "serverVersion") String? serverVersion,@JsonKey(name: "date") String? date,@JsonKey(name: "dayOfWeek") String? dayOfWeek,@JsonKey(name: "timeListening") double? timeListening,@JsonKey(name: "startTime") double? startTime,@JsonKey(name: "currentTime") double? currentTime,@JsonKey(name: "startedAt") int? startedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "audioTracks") List<AudioTrack>? audioTracks,@JsonKey(name: "libraryItem") LibraryItem? libraryItem
});


$MetadataCopyWith<$Res>? get mediaMetadata;$DeviceInfoCopyWith<$Res>? get deviceInfo;$LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class _$PlaybackSessionCopyWithImpl<$Res>
    implements $PlaybackSessionCopyWith<$Res> {
  _$PlaybackSessionCopyWithImpl(this._self, this._then);

  final PlaybackSession _self;
  final $Res Function(PlaybackSession) _then;

/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? libraryId = null,Object? libraryItemId = null,Object? episodeId = freezed,Object? mediaType = freezed,Object? mediaMetadata = freezed,Object? chapters = freezed,Object? displayTitle = freezed,Object? displayAuthor = freezed,Object? coverPath = freezed,Object? duration = freezed,Object? playMethod = freezed,Object? mediaPlayer = freezed,Object? deviceInfo = freezed,Object? serverVersion = freezed,Object? date = freezed,Object? dayOfWeek = freezed,Object? timeListening = freezed,Object? startTime = freezed,Object? currentTime = freezed,Object? startedAt = freezed,Object? updatedAt = freezed,Object? audioTracks = freezed,Object? libraryItem = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,mediaMetadata: freezed == mediaMetadata ? _self.mediaMetadata : mediaMetadata // ignore: cast_nullable_to_non_nullable
as Metadata?,chapters: freezed == chapters ? _self.chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,displayAuthor: freezed == displayAuthor ? _self.displayAuthor : displayAuthor // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,playMethod: freezed == playMethod ? _self.playMethod : playMethod // ignore: cast_nullable_to_non_nullable
as int?,mediaPlayer: freezed == mediaPlayer ? _self.mediaPlayer : mediaPlayer // ignore: cast_nullable_to_non_nullable
as String?,deviceInfo: freezed == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as DeviceInfo?,serverVersion: freezed == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,dayOfWeek: freezed == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String?,timeListening: freezed == timeListening ? _self.timeListening : timeListening // ignore: cast_nullable_to_non_nullable
as double?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double?,currentTime: freezed == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,audioTracks: freezed == audioTracks ? _self.audioTracks : audioTracks // ignore: cast_nullable_to_non_nullable
as List<AudioTrack>?,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}
/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get mediaMetadata {
    if (_self.mediaMetadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.mediaMetadata!, (value) {
    return _then(_self.copyWith(mediaMetadata: value));
  });
}/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res>? get deviceInfo {
    if (_self.deviceInfo == null) {
    return null;
  }

  return $DeviceInfoCopyWith<$Res>(_self.deviceInfo!, (value) {
    return _then(_self.copyWith(deviceInfo: value));
  });
}/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get libraryItem {
    if (_self.libraryItem == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.libraryItem!, (value) {
    return _then(_self.copyWith(libraryItem: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _PlaybackSession implements PlaybackSession {
  const _PlaybackSession({@JsonKey(name: "id") required this.id, @JsonKey(name: "userId") required this.userId, @JsonKey(name: "libraryId") required this.libraryId, @JsonKey(name: "libraryItemId") required this.libraryItemId, @JsonKey(name: "episodeId") this.episodeId, @JsonKey(name: "mediaType") this.mediaType, @JsonKey(name: "mediaMetadata") this.mediaMetadata, @JsonKey(name: "chapters") final  List<Chapter>? chapters, @JsonKey(name: "displayTitle") this.displayTitle, @JsonKey(name: "displayAuthor") this.displayAuthor, @JsonKey(name: "coverPath") this.coverPath, @JsonKey(name: "duration") this.duration, @JsonKey(name: "playMethod") this.playMethod, @JsonKey(name: "mediaPlayer") this.mediaPlayer, @JsonKey(name: "deviceInfo") this.deviceInfo, @JsonKey(name: "serverVersion") this.serverVersion, @JsonKey(name: "date") this.date, @JsonKey(name: "dayOfWeek") this.dayOfWeek, @JsonKey(name: "timeListening") this.timeListening, @JsonKey(name: "startTime") this.startTime, @JsonKey(name: "currentTime") this.currentTime, @JsonKey(name: "startedAt") this.startedAt, @JsonKey(name: "updatedAt") this.updatedAt, @JsonKey(name: "audioTracks") final  List<AudioTrack>? audioTracks, @JsonKey(name: "libraryItem") this.libraryItem}): _chapters = chapters,_audioTracks = audioTracks;
  factory _PlaybackSession.fromJson(Map<String, dynamic> json) => _$PlaybackSessionFromJson(json);

@override@JsonKey(name: "id") final  String id;
@override@JsonKey(name: "userId") final  String userId;
@override@JsonKey(name: "libraryId") final  String libraryId;
@override@JsonKey(name: "libraryItemId") final  String libraryItemId;
@override@JsonKey(name: "episodeId") final  String? episodeId;
@override@JsonKey(name: "mediaType") final  String? mediaType;
@override@JsonKey(name: "mediaMetadata") final  Metadata? mediaMetadata;
 final  List<Chapter>? _chapters;
@override@JsonKey(name: "chapters") List<Chapter>? get chapters {
  final value = _chapters;
  if (value == null) return null;
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "displayTitle") final  String? displayTitle;
@override@JsonKey(name: "displayAuthor") final  String? displayAuthor;
@override@JsonKey(name: "coverPath") final  String? coverPath;
@override@JsonKey(name: "duration") final  double? duration;
@override@JsonKey(name: "playMethod") final  int? playMethod;
@override@JsonKey(name: "mediaPlayer") final  String? mediaPlayer;
@override@JsonKey(name: "deviceInfo") final  DeviceInfo? deviceInfo;
@override@JsonKey(name: "serverVersion") final  String? serverVersion;
@override@JsonKey(name: "date") final  String? date;
@override@JsonKey(name: "dayOfWeek") final  String? dayOfWeek;
@override@JsonKey(name: "timeListening") final  double? timeListening;
@override@JsonKey(name: "startTime") final  double? startTime;
@override@JsonKey(name: "currentTime") final  double? currentTime;
@override@JsonKey(name: "startedAt") final  int? startedAt;
@override@JsonKey(name: "updatedAt") final  int? updatedAt;
 final  List<AudioTrack>? _audioTracks;
@override@JsonKey(name: "audioTracks") List<AudioTrack>? get audioTracks {
  final value = _audioTracks;
  if (value == null) return null;
  if (_audioTracks is EqualUnmodifiableListView) return _audioTracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: "libraryItem") final  LibraryItem? libraryItem;

/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackSessionCopyWith<_PlaybackSession> get copyWith => __$PlaybackSessionCopyWithImpl<_PlaybackSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaybackSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackSession&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.libraryId, libraryId) || other.libraryId == libraryId)&&(identical(other.libraryItemId, libraryItemId) || other.libraryItemId == libraryItemId)&&(identical(other.episodeId, episodeId) || other.episodeId == episodeId)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.mediaMetadata, mediaMetadata) || other.mediaMetadata == mediaMetadata)&&const DeepCollectionEquality().equals(other._chapters, _chapters)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.displayAuthor, displayAuthor) || other.displayAuthor == displayAuthor)&&(identical(other.coverPath, coverPath) || other.coverPath == coverPath)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playMethod, playMethod) || other.playMethod == playMethod)&&(identical(other.mediaPlayer, mediaPlayer) || other.mediaPlayer == mediaPlayer)&&(identical(other.deviceInfo, deviceInfo) || other.deviceInfo == deviceInfo)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.date, date) || other.date == date)&&(identical(other.dayOfWeek, dayOfWeek) || other.dayOfWeek == dayOfWeek)&&(identical(other.timeListening, timeListening) || other.timeListening == timeListening)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.currentTime, currentTime) || other.currentTime == currentTime)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._audioTracks, _audioTracks)&&(identical(other.libraryItem, libraryItem) || other.libraryItem == libraryItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,userId,libraryId,libraryItemId,episodeId,mediaType,mediaMetadata,const DeepCollectionEquality().hash(_chapters),displayTitle,displayAuthor,coverPath,duration,playMethod,mediaPlayer,deviceInfo,serverVersion,date,dayOfWeek,timeListening,startTime,currentTime,startedAt,updatedAt,const DeepCollectionEquality().hash(_audioTracks),libraryItem]);

@override
String toString() {
  return 'PlaybackSession(id: $id, userId: $userId, libraryId: $libraryId, libraryItemId: $libraryItemId, episodeId: $episodeId, mediaType: $mediaType, mediaMetadata: $mediaMetadata, chapters: $chapters, displayTitle: $displayTitle, displayAuthor: $displayAuthor, coverPath: $coverPath, duration: $duration, playMethod: $playMethod, mediaPlayer: $mediaPlayer, deviceInfo: $deviceInfo, serverVersion: $serverVersion, date: $date, dayOfWeek: $dayOfWeek, timeListening: $timeListening, startTime: $startTime, currentTime: $currentTime, startedAt: $startedAt, updatedAt: $updatedAt, audioTracks: $audioTracks, libraryItem: $libraryItem)';
}


}

/// @nodoc
abstract mixin class _$PlaybackSessionCopyWith<$Res> implements $PlaybackSessionCopyWith<$Res> {
  factory _$PlaybackSessionCopyWith(_PlaybackSession value, $Res Function(_PlaybackSession) _then) = __$PlaybackSessionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "id") String id,@JsonKey(name: "userId") String userId,@JsonKey(name: "libraryId") String libraryId,@JsonKey(name: "libraryItemId") String libraryItemId,@JsonKey(name: "episodeId") String? episodeId,@JsonKey(name: "mediaType") String? mediaType,@JsonKey(name: "mediaMetadata") Metadata? mediaMetadata,@JsonKey(name: "chapters") List<Chapter>? chapters,@JsonKey(name: "displayTitle") String? displayTitle,@JsonKey(name: "displayAuthor") String? displayAuthor,@JsonKey(name: "coverPath") String? coverPath,@JsonKey(name: "duration") double? duration,@JsonKey(name: "playMethod") int? playMethod,@JsonKey(name: "mediaPlayer") String? mediaPlayer,@JsonKey(name: "deviceInfo") DeviceInfo? deviceInfo,@JsonKey(name: "serverVersion") String? serverVersion,@JsonKey(name: "date") String? date,@JsonKey(name: "dayOfWeek") String? dayOfWeek,@JsonKey(name: "timeListening") double? timeListening,@JsonKey(name: "startTime") double? startTime,@JsonKey(name: "currentTime") double? currentTime,@JsonKey(name: "startedAt") int? startedAt,@JsonKey(name: "updatedAt") int? updatedAt,@JsonKey(name: "audioTracks") List<AudioTrack>? audioTracks,@JsonKey(name: "libraryItem") LibraryItem? libraryItem
});


@override $MetadataCopyWith<$Res>? get mediaMetadata;@override $DeviceInfoCopyWith<$Res>? get deviceInfo;@override $LibraryItemCopyWith<$Res>? get libraryItem;

}
/// @nodoc
class __$PlaybackSessionCopyWithImpl<$Res>
    implements _$PlaybackSessionCopyWith<$Res> {
  __$PlaybackSessionCopyWithImpl(this._self, this._then);

  final _PlaybackSession _self;
  final $Res Function(_PlaybackSession) _then;

/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? libraryId = null,Object? libraryItemId = null,Object? episodeId = freezed,Object? mediaType = freezed,Object? mediaMetadata = freezed,Object? chapters = freezed,Object? displayTitle = freezed,Object? displayAuthor = freezed,Object? coverPath = freezed,Object? duration = freezed,Object? playMethod = freezed,Object? mediaPlayer = freezed,Object? deviceInfo = freezed,Object? serverVersion = freezed,Object? date = freezed,Object? dayOfWeek = freezed,Object? timeListening = freezed,Object? startTime = freezed,Object? currentTime = freezed,Object? startedAt = freezed,Object? updatedAt = freezed,Object? audioTracks = freezed,Object? libraryItem = freezed,}) {
  return _then(_PlaybackSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,libraryId: null == libraryId ? _self.libraryId : libraryId // ignore: cast_nullable_to_non_nullable
as String,libraryItemId: null == libraryItemId ? _self.libraryItemId : libraryItemId // ignore: cast_nullable_to_non_nullable
as String,episodeId: freezed == episodeId ? _self.episodeId : episodeId // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,mediaMetadata: freezed == mediaMetadata ? _self.mediaMetadata : mediaMetadata // ignore: cast_nullable_to_non_nullable
as Metadata?,chapters: freezed == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,displayAuthor: freezed == displayAuthor ? _self.displayAuthor : displayAuthor // ignore: cast_nullable_to_non_nullable
as String?,coverPath: freezed == coverPath ? _self.coverPath : coverPath // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double?,playMethod: freezed == playMethod ? _self.playMethod : playMethod // ignore: cast_nullable_to_non_nullable
as int?,mediaPlayer: freezed == mediaPlayer ? _self.mediaPlayer : mediaPlayer // ignore: cast_nullable_to_non_nullable
as String?,deviceInfo: freezed == deviceInfo ? _self.deviceInfo : deviceInfo // ignore: cast_nullable_to_non_nullable
as DeviceInfo?,serverVersion: freezed == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,dayOfWeek: freezed == dayOfWeek ? _self.dayOfWeek : dayOfWeek // ignore: cast_nullable_to_non_nullable
as String?,timeListening: freezed == timeListening ? _self.timeListening : timeListening // ignore: cast_nullable_to_non_nullable
as double?,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as double?,currentTime: freezed == currentTime ? _self.currentTime : currentTime // ignore: cast_nullable_to_non_nullable
as double?,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as int?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as int?,audioTracks: freezed == audioTracks ? _self._audioTracks : audioTracks // ignore: cast_nullable_to_non_nullable
as List<AudioTrack>?,libraryItem: freezed == libraryItem ? _self.libraryItem : libraryItem // ignore: cast_nullable_to_non_nullable
as LibraryItem?,
  ));
}

/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MetadataCopyWith<$Res>? get mediaMetadata {
    if (_self.mediaMetadata == null) {
    return null;
  }

  return $MetadataCopyWith<$Res>(_self.mediaMetadata!, (value) {
    return _then(_self.copyWith(mediaMetadata: value));
  });
}/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceInfoCopyWith<$Res>? get deviceInfo {
    if (_self.deviceInfo == null) {
    return null;
  }

  return $DeviceInfoCopyWith<$Res>(_self.deviceInfo!, (value) {
    return _then(_self.copyWith(deviceInfo: value));
  });
}/// Create a copy of PlaybackSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LibraryItemCopyWith<$Res>? get libraryItem {
    if (_self.libraryItem == null) {
    return null;
  }

  return $LibraryItemCopyWith<$Res>(_self.libraryItem!, (value) {
    return _then(_self.copyWith(libraryItem: value));
  });
}
}

// dart format on
