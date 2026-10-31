import 'package:yaabsa/api/library_items/audio_track.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/library_items/request/play_library_item_request.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/util/cast/cast_backend.dart';
import 'package:yaabsa/util/globals.dart' show appName;
import 'package:yaabsa/util/player_utils.dart';
import 'package:yaabsa/util/logger.dart';

Future<CastMedia> resolveCastMedia({
  required InternalMedia media,
  required int trackIndex,
  required Duration position,
  required bool autoPlay,
  required ABSApi? api,
  required Map<String, String> headers,
  required List<String> supportedMimeTypes,
  required String castDeviceId,
  PlaybackSession? serverSession,
  bool forceTranscode = false,
}) async {
  if (trackIndex < 0 || trackIndex >= media.tracks.length) {
    throw StateError('Unable to determine the current track');
  }

  final track = media.tracks[trackIndex];
  final sessionMatches = serverSession?.libraryItemId == media.itemId && serverSession?.episodeId == media.episodeId;
  if (!forceTranscode && api != null && serverSession != null && sessionMatches) {
    final selected = _selectTrack(serverSession, media, trackIndex, position);
    if (selected != null && _supportsMimeType(selected.mimeType, supportedMimeTypes)) {
      return _sessionMedia(
        session: serverSession,
        selected: selected,
        media: media,
        trackIndex: trackIndex,
        position: position,
        autoPlay: autoPlay,
        api: api,
        headers: headers,
      );
    }
  }

  final uri = Uri.tryParse(track.url ?? '');
  if (!forceTranscode && uri != null && isCastHttpUri(uri) && _supportsMimeType(track.mimeType, supportedMimeTypes)) {
    return CastMedia(
      contentId: media.id,
      uri: uri,
      mimeType: track.mimeType.isEmpty ? 'audio/mpeg' : track.mimeType,
      title: media.title,
      subtitle: media.author ?? media.subtitle,
      cover: media.cover != null && isCastHttpUri(media.cover!) ? media.cover : null,
      duration: Duration(milliseconds: (track.duration * 1000).round()),
      position: position - media.startDurationForTrack(trackIndex),
      trackOffset: media.startDurationForTrack(trackIndex),
      autoPlay: autoPlay,
      headers: headers,
    );
  }

  if (api == null) {
    throw StateError('Casting this item requires an active server connection');
  }

  final deviceInfo = await PlayerUtils.getDeviceInfo();
  final request = PlayLibraryItemRequest(
    deviceInfo: deviceInfo.copyWith(deviceId: '${deviceInfo.deviceId ?? appName}:cast:$castDeviceId'),
    forceDirectPlay: false,
    forceTranscode: forceTranscode || !_supportsMimeType(track.mimeType, supportedMimeTypes),
    supportedMimeTypes: supportedMimeTypes,
    mediaPlayer: '$appName cast',
  );
  final session = (await api.getLibraryItemApi().playLibraryItem(
    media.itemId,
    episodeId: media.episodeId,
    playRequest: request,
  )).data;
  if (session == null) {
    throw StateError('Unable to prepare a server stream for this item');
  }

  var released = false;
  Future<void> release() async {
    if (released) {
      return;
    }

    released = true;
    try {
      await api.getSessionApi().closeOpenSession(session.id).timeout(const Duration(seconds: 8));
    } catch (error) {
      logger('Unable to close cast stream: $error', tag: 'Casting', level: InfoLevel.warning);
    }
  }

  try {
    final selected = _selectTrack(session, media, trackIndex, position);
    if (selected == null) {
      throw StateError('The server did not provide a playable track');
    }

    return _sessionMedia(
      session: session,
      selected: selected,
      media: media,
      trackIndex: trackIndex,
      position: position,
      autoPlay: autoPlay,
      api: api,
      headers: headers,
      release: release,
    );
  } catch (_) {
    await release();
    rethrow;
  }
}

AudioTrack? _selectTrack(PlaybackSession session, InternalMedia media, int trackIndex, Duration position) {
  final tracks = session.audioTracks ?? [];
  final selected = tracks.where((candidate) {
    return position.inMilliseconds >= (candidate.startOffset * 1000).round() &&
        position.inMilliseconds < ((candidate.startOffset + candidate.duration) * 1000).round();
  }).firstOrNull;

  return selected ??
      tracks.where((candidate) => candidate.index == media.tracks[trackIndex].index).firstOrNull ??
      tracks.elementAtOrNull(trackIndex);
}

CastMedia _sessionMedia({
  required PlaybackSession session,
  required AudioTrack selected,
  required InternalMedia media,
  required int trackIndex,
  required Duration position,
  required bool autoPlay,
  required ABSApi api,
  required Map<String, String> headers,
  Future<void> Function()? release,
}) {
  final uri = Uri.tryParse(
    selected.toInternalTrack(api.basePathOverride, session.id, localIndex: trackIndex).url ?? '',
  );
  if (uri == null || !isCastHttpUri(uri)) {
    throw StateError('The server did not provide a playable URL');
  }

  final offset = Duration(milliseconds: (selected.startOffset * 1000).round());
  final relativePosition = position - offset;
  return CastMedia(
    contentId: media.id,
    uri: uri,
    mimeType: selected.mimeType.isEmpty ? 'audio/mpeg' : selected.mimeType,
    title: media.title,
    subtitle: media.author ?? media.subtitle,
    cover: api.getLibraryItemApi().getCoverUri(media.itemId),
    duration: Duration(milliseconds: (selected.duration * 1000).round()),
    position: relativePosition < Duration.zero ? Duration.zero : relativePosition,
    trackOffset: offset,
    autoPlay: autoPlay,
    headers: headers,
    release: release,
    isTranscoded: session.playMethod == 2,
  );
}

bool _supportsMimeType(String mimeType, List<String> supportedMimeTypes) {
  final normalized = mimeType.split(';').first.trim().toLowerCase();
  return supportedMimeTypes.any((supported) {
    final candidate = supported.split(';').first.trim().toLowerCase();
    return candidate == normalized ||
        candidate == '*/*' ||
        candidate == '*' ||
        (candidate == 'audio/*' && normalized.startsWith('audio/'));
  });
}

bool isCastHttpUri(Uri uri) {
  return (uri.scheme == 'http' || uri.scheme == 'https') && uri.host.isNotEmpty;
}
