import 'dart:convert';

import 'package:buchshelfly/api/library_items/audio_track.dart';
import 'package:buchshelfly/api/library_items/library_item.dart';
import 'package:buchshelfly/api/library_items/playback_session.dart';
import 'package:buchshelfly/api/library_items/request/play_library_item_request.dart';
import 'package:buchshelfly/api/me/media_progress.dart';
import 'package:buchshelfly/api/routes/abs_api.dart';
import 'package:buchshelfly/api/session/request/sync_session_request.dart';
import 'package:buchshelfly/database/app_database.dart';
import 'package:buchshelfly/models/internal_media.dart';
import 'package:buchshelfly/provider/common/library_item_provider.dart';
import 'package:buchshelfly/provider/common/media_progress_provider.dart';
import 'package:buchshelfly/provider/core/server_status_provider.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/globals.dart';
import 'package:buchshelfly/util/logger.dart';
import 'package:buchshelfly/util/player_utils.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_provider.g.dart';

class SessionRepository {
  final Ref ref;
  SessionRepository(this.ref);

  PlaybackSession? _currentSession;
  bool _isLocalSession = true;

  PlaybackSession? get currentSession => _currentSession;

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
      _isLocalSession = false;
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
      libraryId: _currentSession!.libraryId!,
      itemId: _currentSession!.libraryItemId,
      episodeId: _currentSession!.episodeId,
      sessionId: _currentSession!.id,
      title: _currentSession!.displayTitle ?? _currentSession!.libraryItem!.title,
      subtitle: _currentSession!.libraryItem?.subtitle,
      series: _currentSession!.libraryItem?.seriesName,
      seriesPosition: _currentSession!.libraryItem?.seriesPosition,
      author: _currentSession!.libraryItem?.authorString,
      cover: api.getLibraryItemApi().getCoverUri(_currentSession!.libraryItemId),
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

  Future<bool> syncOpenSession(double currentTime, double timeListened) async {
    // TODO: Implement for offline support
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      logger('No API available, cannot sync session.', tag: 'SessionRepository', level: InfoLevel.warning);
      return false;
    }
    if (_currentSession == null) {
      logger('No session available', tag: 'SessionRepository', level: InfoLevel.warning);
      return false;
    }

    final MediaProgress? updatedProgress = await ref
        .read(mediaProgressNotifierProvider.notifier)
        .updateMediaProgress(_currentSession!.libraryItemId, currentTime, _currentSession!);

    if (!(ref.read(serverStatusProvider).value ?? false) || _isLocalSession) {
      logger('No server available or session is local', tag: 'SessionRepository', level: InfoLevel.debug);

      return _addLocal(currentTime, timeListened, updatedProgress);
    }

    try {
      final result = await api.getSessionApi().syncOpenSession(
        _currentSession!.id,
        request: SyncSessionRequest(
          currentTime: currentTime,
          timeListened: timeListened,
          duration: _currentSession!.duration ?? 0,
        ),
      );

      return result;
    } catch (e) {
      logger('Failed to sync open session', tag: 'SessionRepository', level: InfoLevel.warning);
      return _addLocal(currentTime, timeListened, updatedProgress);
    }
  }

  Future<bool> _addLocal(double currentTime, double timeListened, MediaProgress? progress) async {
    StoredSyncsCompanion sync = StoredSyncsCompanion(
      sessionId: Value(_currentSession!.id),
      itemId: Value(_currentSession!.libraryItemId),
      episodeId: Value(_currentSession!.episodeId),
      userId: Value(ref.read(currentUserProvider).value!.id),
      currentTime: Value(currentTime),
      timeListened: Value(timeListened),
      duration: Value(_currentSession!.duration ?? 0),
      lastUpdated: Value(DateTime.now()),
      sessionLocal: Value(_isLocalSession),
      mediaProgress: Value(jsonEncode(progress)),
    );

    await ref.read(appDatabaseProvider).addOrUpdateSync(sync);
    logger('Sync stored locally for session ${_currentSession!.id}', tag: 'SessionRepository', level: InfoLevel.debug);
    return true;
  }

  Future<bool> syncClosedSession(StoredSyncEntry storedSync, {String? sessionId}) async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      logger('No API available, cannot sync session.', tag: 'SessionRepository', level: InfoLevel.warning);
      return false;
    }

    final result = await api.getSessionApi().syncLocalSession(
      PlaybackSession(
        id: sessionId ?? storedSync.sessionId,
        userId: storedSync.userId,
        libraryItemId: storedSync.itemId,
        currentTime: storedSync.currentTime,
        timeListening: storedSync.timeListened,
        episodeId: storedSync.episodeId,
        duration: storedSync.duration,
        updatedAt: storedSync.lastUpdated.millisecondsSinceEpoch,
      ),
    );

    logger(
      'Sync closed session ${storedSync.sessionId} with time listened ${storedSync.timeListened}',
      tag: 'SessionRepository',
      level: InfoLevel.debug,
    );

    return result;
  }

  Future<PlaybackSession> createLocalSession(
    String sessionId,
    String itemId,
    String userId,
    DateTime date, {
    String? episodeId,
    double? initialTimeListening,
    double? currentPosition,
    double? duration,
  }) async {
    final LibraryItem libraryItem = await ref.read(libraryItemProvider(itemId).future);
    final LibraryItem strippedItem = libraryItem.copyWith(
      media: libraryItem.media?.copyWith(
        bookMedia: libraryItem.media?.bookMedia?.copyWith(audioFiles: null, chapters: null),
        podcastMedia: libraryItem.media?.podcastMedia?.copyWith(episodes: null),
      ),
    );

    PlaybackSession session = PlaybackSession(
      id: sessionId,
      userId: userId,
      libraryId: libraryItem.libraryId!,
      libraryItemId: libraryItem.id,
      libraryItem: strippedItem,
      mediaType: libraryItem.mediaType,
      episodeId: episodeId,
      displayTitle: libraryItem.title,
      chapters: libraryItem.media?.bookMedia?.chapters,
      displayAuthor: libraryItem.authorString,
      coverPath: libraryItem.media?.bookMedia?.coverPath,
      duration: duration ?? libraryItem.media?.duration(episodeId: episodeId),
      playMethod: 0,
      deviceInfo: await PlayerUtils.getDeviceInfo(),
      mediaPlayer: '$appName just_audio',
      date: date.toIso8601String(),
      dayOfWeek: date.weekday.toString(),
      timeListening: initialTimeListening,
      startTime: initialTimeListening,
      currentTime: currentPosition,
      updatedAt: date.millisecondsSinceEpoch,
      audioTracks:
          libraryItem.media?.bookMedia?.audioFiles?.map((a) => a.toAudioTrack()).whereType<AudioTrack>().toList() ??
          (libraryItem.media?.podcastMedia?.episodes
                      ?.where((e) => e.id == episodeId)
                      .firstOrNull
                      ?.audioFile
                      ?.toAudioTrack() !=
                  null
              ? [
                libraryItem.media?.podcastMedia?.episodes
                        ?.where((e) => e.id == episodeId)
                        .firstOrNull
                        ?.audioFile
                        ?.toAudioTrack()
                    as AudioTrack,
              ]
              : []),
    );

    return session;
  }

  Future<void> updateMediaProgress(String itemId, MediaProgress progress, {String? episodeId}) async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      logger('No API available, cannot update media progress.', tag: 'SessionRepository', level: InfoLevel.warning);
      return Future.value();
    }

    return api.getMeApi().createUpdateMediaProgress(itemId, progress, episodeId: episodeId);
  }
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(ref);
}
