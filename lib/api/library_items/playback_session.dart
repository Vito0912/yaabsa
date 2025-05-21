import 'package:buchshelfly/api/library_items/audio_track.dart';
import 'package:buchshelfly/api/library_items/chapter.dart';
import 'package:buchshelfly/api/library_items/device_info.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/api/library_items/metadata.dart';
import 'package:buchshelfly/api/me/media_item_type.dart';
import 'package:buchshelfly/api/me/media_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'playback_session.freezed.dart';
part 'playback_session.g.dart';

@freezed
abstract class PlaybackSession with _$PlaybackSession {
  const PlaybackSession._();

  const factory PlaybackSession({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "userId") required String userId,
    @JsonKey(name: "libraryId") required String libraryId,
    @JsonKey(name: "libraryItemId") required String libraryItemId,
    @JsonKey(name: "episodeId") String? episodeId,
    @JsonKey(name: "mediaType") String? mediaType,
    @JsonKey(name: "mediaMetadata") Metadata? mediaMetadata,
    @JsonKey(name: "chapters") List<Chapter>? chapters,
    @JsonKey(name: "displayTitle") String? displayTitle,
    @JsonKey(name: "displayAuthor") String? displayAuthor,
    @JsonKey(name: "coverPath") String? coverPath,
    @JsonKey(name: "duration") double? duration,
    @JsonKey(name: "playMethod") int? playMethod,
    @JsonKey(name: "mediaPlayer") String? mediaPlayer,
    @JsonKey(name: "deviceInfo") DeviceInfo? deviceInfo,
    @JsonKey(name: "serverVersion") String? serverVersion,
    @JsonKey(name: "date") String? date,
    @JsonKey(name: "dayOfWeek") String? dayOfWeek,
    @JsonKey(name: "timeListening") double? timeListening,
    @JsonKey(name: "startTime") double? startTime,
    @JsonKey(name: "currentTime") double? currentTime,
    @JsonKey(name: "startedAt") int? startedAt,
    @JsonKey(name: "updatedAt") int? updatedAt,
    @JsonKey(name: "audioTracks") List<AudioTrack>? audioTracks,
    @JsonKey(name: "libraryItem") LibraryItem? libraryItem,
  }) = _PlaybackSession;

  MediaProgress toMediaProgress(MediaProgress? item, String userId, double progress, double currentTime) {
    if (item != null) return item;
    return MediaProgress(
      id: id,
      userId: userId,
      libraryItemId: libraryItemId,
      episodeId: episodeId,
      mediaItemType: mediaType == 'podcast' ? MediaItemType.PODCAST_EPISODE : MediaItemType.BOOK,
      mediaItemId: id,
      duration: duration ?? 0,
      progress: progress,
      currentTime: currentTime,
      isFinished: currentTime >= (duration ?? 0),
      hideFromContinueListening: false,
      ebookProgress: null,
      ebookLocation: null,
      lastUpdate: DateTime.now().millisecondsSinceEpoch,
      startedAt: startedAt ?? DateTime.now().millisecondsSinceEpoch,
      finishedAt: null,
    );
  }

  factory PlaybackSession.fromJson(Map<String, dynamic> json) => _$PlaybackSessionFromJson(json);
}
