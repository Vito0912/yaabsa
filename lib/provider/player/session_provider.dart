import 'package:buchshelfly/api/library_items/playback_session.dart';
import 'package:buchshelfly/api/library_items/request/play_library_item_request.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/player_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

class SessionRepository {
  final Ref ref;
  SessionRepository(this.ref);

  PlaybackSession? _currentSession;

  Future<void> closeSession() async {
    final ABSApi? api = ref.read(absApiProvider);

    if (api == null) {
      logger('No API available, cannot close session.', tag: 'SessionRepository');
      return;
    }

    if (_currentSession != null) {
      try {
        await api.getSessionApi().closeOpenSession(_currentSession!.id);
      } catch (e) {
        logger('Failed to close session: $e', tag: 'SessionRepository', level: InfoLevel.warning);
      }

      _currentSession = null;
    }
  }

  Future<InternalMedia?> openSession(String itemId) async {
    final ABSApi? api = ref.read(absApiProvider);

    print(api);

    if (api == null) {
      logger('No API available, cannot open session.', tag: 'SessionRepository');
      return null;
    }

    // TODO
    if (itemId == _currentSession?.libraryItemId) return null;

    PlayLibraryItemRequest playRequest = PlayLibraryItemRequest(
      deviceInfo: await PlayerUtils.getDeviceInfo(),
      forceDirectPlay: false,
      forceTranscode: false,
      supportedMimeTypes: await PlayerUtils.getSupportedMimeTypes(),
      mediaPlayer: '$appName just_audio',
    );

    final PlaybackSession? session =
        (await api.getLibraryItemApi().playLibraryItem(itemId, playRequest: playRequest)).data;

    if (session != null) {
      _currentSession = session;
      logger('Session opened successfully: ${session.id}', tag: 'SessionRepository');
    } else {
      logger('Failed to open session for item $itemId', tag: 'SessionRepository', level: InfoLevel.warning);
    }

    if (_currentSession == null) {
      logger('Session is null, cannot create InternalMedia object.', tag: 'SessionRepository', level: InfoLevel.error);
      return null;
    }

    // TODO: Add for offline support

    final InternalMedia internalMedia = InternalMedia(
      libraryId: _currentSession!.libraryId,
      itemId: _currentSession!.libraryItemId,
      episodeId: _currentSession!.episodeId,
      sessionId: _currentSession!.id,
      title: _currentSession!.displayTitle ?? _currentSession!.libraryItem!.title,
      // cover: _currentSession!.coverPath,
      chapters: _currentSession!.chapters?.map((e) => e.toInternalChapter()).toList(),
      tracks:
          _currentSession!.audioTracks!
              .map((e) => e.toInternalTrack(api.basePathOverride, _currentSession!.id))
              .toList(),
      local: false,
      saf: false,
    );
    internalMedia.populateFields();

    return internalMedia;
  }
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(ref);
}
