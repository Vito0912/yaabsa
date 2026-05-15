import 'dart:convert';
import 'dart:io';

import 'package:yaabsa/api/library_items/audio_track.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/library_items/request/play_library_item_request.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/api/session/request/sync_session_request.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/models/internal_media.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/globals.dart';
import 'package:yaabsa/util/handler/player_history_handler.dart';
import 'package:yaabsa/util/local_cover_path.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/player_utils.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'session_provider.g.dart';

enum _StoredSyncReplayAction { synced, retryWithNewSession, keepLocal }

class SessionRepository {
  final Ref ref;
  SessionRepository(this.ref);

  PlaybackSession? _currentSession;
  bool _isLocalSession = true;

  PlaybackSession? get currentSession => _currentSession;

  String? get _activeUserId {
    final currentUserId = ref.read(currentUserProvider).value?.id;
    if (currentUserId != null && currentUserId.isNotEmpty) {
      return currentUserId;
    }

    final apiUserId = ref.read(absApiProvider)?.user?.id;
    if (apiUserId != null && apiUserId.isNotEmpty) {
      return apiUserId;
    }

    return null;
  }

  Uri? _localCoverUriFromPath(String? rawPath) {
    if (rawPath == null) {
      return null;
    }

    final trimmed = rawPath.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parsed = Uri.tryParse(trimmed);
    if (parsed != null && parsed.scheme.isNotEmpty) {
      if (parsed.scheme == 'file' || parsed.scheme == 'content' || parsed.scheme == 'urlbookmark') {
        return parsed;
      }
      return null;
    }

    return Uri.file(trimmed, windows: Platform.isWindows);
  }

  Future<void> closeSession() async {
    final currentSession = _currentSession;
    if (currentSession == null) {
      return;
    }

    if (_isLocalSession) {
      logger('Closed local session', tag: 'SessionRepository');
      _currentSession = null;
      return;
    }

    final ABSApi? api = ref.read(absApiProvider);

    if (api == null) {
      logger('No API available, closing session locally only.', tag: 'SessionRepository', level: InfoLevel.warning);
      _currentSession = null;
      return;
    }

    try {
      await api.getSessionApi().closeOpenSession(currentSession.id);
    } catch (e) {
      logger('Failed to close session: $e', tag: 'SessionRepository', level: InfoLevel.warning);
    }

    _currentSession = null;
  }

  Future<InternalMedia?> openSession(String itemId, {String? episodeId}) async {
    final ABSApi? api = ref.read(absApiProvider);
    final AppDatabase db = ref.read(appDatabaseProvider);
    final String? userId = _activeUserId;

    if (userId == null) {
      logger('No active user available, cannot open session.', tag: 'SessionRepository', level: InfoLevel.warning);
      return null;
    }

    final downloaded = await db.getStoredDownload(itemId, userId, episodeId: episodeId);

    if (itemId == _currentSession?.libraryItemId && episodeId == _currentSession?.episodeId) return null;

    if (downloaded == null) {
      if (api == null) {
        logger('No API available and no local download found.', tag: 'SessionRepository', level: InfoLevel.warning);
        return null;
      }

      PlayLibraryItemRequest playRequest = PlayLibraryItemRequest(
        deviceInfo: await PlayerUtils.getDeviceInfo(),
        forceDirectPlay: false,
        forceTranscode: false,
        supportedMimeTypes: await PlayerUtils.getSupportedMimeTypes(),
        mediaPlayer: '$appName just_audio',
      );

      final PlaybackSession? session = (await api.getLibraryItemApi().playLibraryItem(
        itemId,
        episodeId: episodeId,
        playRequest: playRequest,
      )).data;

      if (session != null) {
        _currentSession = session;
        _isLocalSession = false;
        logger('Session opened successfully: ${session.id}', tag: 'SessionRepository');
      } else {
        logger('Failed to open session for item $itemId', tag: 'SessionRepository', level: InfoLevel.warning);
      }

      if (_currentSession == null) {
        logger(
          'Session is null, cannot create InternalMedia object.',
          tag: 'SessionRepository',
          level: InfoLevel.error,
        );
        return null;
      }
    } else {
      logger('Using local download for item $itemId', tag: 'SessionRepository', level: InfoLevel.debug);
      final randomId = Uuid().v4();
      _currentSession = await createLocalSession(randomId, itemId, userId, DateTime.now(), episodeId: episodeId);
      _isLocalSession = true;
    }

    final hasCoverPath =
        (_currentSession!.coverPath?.isNotEmpty ?? false) || (_currentSession!.libraryItem?.hasCover ?? false);
    final resolvedLocalCoverPath = await resolveDisplayCoverPath(
      downloaded?.coverPath,
      cacheKey: '$userId:$itemId:${episodeId ?? 'item'}',
    );
    final localCoverUri = _localCoverUriFromPath(resolvedLocalCoverPath ?? downloaded?.coverPath);
    final remoteCoverUri = hasCoverPath && api != null
        ? api.getLibraryItemApi().getCoverUri(_currentSession!.libraryItemId)
        : null;
    final metadataNarrators = _currentSession!.mediaMetadata?.bookMetadata?.narrators
        ?.map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);
    final narrator =
        _currentSession!.libraryItem?.narratorString ??
        ((metadataNarrators == null || metadataNarrators.isEmpty) ? null : metadataNarrators.join(', '));

    final InternalMedia internalMedia = InternalMedia(
      libraryId: _currentSession!.libraryId!,
      itemId: _currentSession!.libraryItemId,
      episodeId: _currentSession!.episodeId,
      sessionId: _currentSession!.id,
      title: _currentSession!.displayTitle ?? _currentSession!.libraryItem!.title,
      subtitle: _currentSession!.episodeId == null ? _currentSession!.libraryItem?.subtitle : null,
      series: _currentSession!.libraryItem?.seriesName,
      seriesPosition: _currentSession!.libraryItem?.seriesPosition,
      author: _currentSession!.libraryItem?.authorString,
      narrator: narrator,
      cover: localCoverUri ?? remoteCoverUri,
      chapters: _currentSession!.chapters?.map((e) => e.toInternalChapter()).toList(),
      tracks: downloaded != null
          ? downloaded.tracks
          : (_currentSession!.audioTracks ?? const <AudioTrack>[])
                .map((e) => e.toInternalTrack(api!.basePathOverride, _currentSession!.id))
                .toList(),
      local: _isLocalSession,
      saf: downloaded?.saf ?? false,
    );

    internalMedia.populateFields();

    return internalMedia;
  }

  Future<bool> syncOpenSession(double currentTime, double timeListened, {required bool canReachServer}) async {
    if (_currentSession == null) {
      logger('No session available', tag: 'SessionRepository', level: InfoLevel.warning);
      return false;
    }

    final MediaProgress? updatedProgress = await ref
        .read(mediaProgressProvider.notifier)
        .updateMediaProgress(_currentSession!.libraryItemId, currentTime, _currentSession!);

    if (_isLocalSession || !canReachServer) {
      logger(
        _isLocalSession
            ? 'Session is local; storing sync locally'
            : 'Server is offline/unreachable by watcher; storing sync locally',
        tag: 'SessionRepository',
        level: InfoLevel.debug,
      );

      return _addLocal(currentTime, timeListened, updatedProgress);
    }

    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      logger('No API available, storing sync locally.', tag: 'SessionRepository', level: InfoLevel.warning);
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

      PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.sync);

      return result;
    } catch (e) {
      logger('Failed to sync open session', tag: 'SessionRepository', level: InfoLevel.warning);
      return _addLocal(currentTime, timeListened, updatedProgress);
    }
  }

  Future<bool> _addLocal(double currentTime, double timeListened, MediaProgress? progress) async {
    final PlaybackSession? currentSession = _currentSession;
    final String? userId = _activeUserId;

    if (currentSession == null || userId == null) {
      logger(
        'Cannot store sync locally because session or user is missing.',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
      return false;
    }

    final double duration = currentSession.duration ?? 0;
    final double normalizedProgress = duration > 0 ? (currentTime / duration).clamp(0.0, 1.0).toDouble() : 0.0;
    final MediaProgress effectiveProgress =
        progress ?? currentSession.toMediaProgress(null, userId, normalizedProgress, currentTime);

    StoredSyncsCompanion sync = StoredSyncsCompanion(
      sessionId: Value(currentSession.id),
      itemId: Value(currentSession.libraryItemId),
      episodeId: Value(currentSession.episodeId),
      userId: Value(userId),
      currentTime: Value(currentTime),
      timeListened: Value(timeListened),
      duration: Value(duration),
      lastUpdated: Value(DateTime.now()),
      sessionLocal: Value(_isLocalSession),
      mediaProgress: Value(jsonEncode(effectiveProgress)),
    );

    await ref.read(appDatabaseProvider).addOrUpdateSync(sync);
    PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.syncOffline);
    logger('Sync stored locally for session ${currentSession.id}', tag: 'SessionRepository', level: InfoLevel.debug);
    return true;
  }

  Future<bool> replayStoredSync(StoredSyncEntry storedSync) async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      logger(
        'No API available, cannot replay stored sync ${storedSync.sessionId}.',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
      return false;
    }

    if (!storedSync.sessionLocal) {
      final replayAction = await _syncStoredOpenSession(api, storedSync);
      if (replayAction == _StoredSyncReplayAction.synced) {
        return true;
      }
      if (replayAction == _StoredSyncReplayAction.keepLocal) {
        return false;
      }
    }

    return _syncStoredAsNewSession(api, storedSync);
  }

  Future<_StoredSyncReplayAction> _syncStoredOpenSession(ABSApi api, StoredSyncEntry storedSync) async {
    try {
      final PlaybackSession? remoteSession = (await api.getSessionApi().getSessionById(storedSync.sessionId)).data;

      final int localUpdatedAt = storedSync.lastUpdated.millisecondsSinceEpoch;
      final int? remoteUpdatedAt = remoteSession?.updatedAt;

      final bool useLocalCurrentTime = remoteUpdatedAt == null || localUpdatedAt > remoteUpdatedAt;
      final double syncedCurrentTime = useLocalCurrentTime
          ? storedSync.currentTime
          : (remoteSession?.currentTime ?? storedSync.currentTime);

      await api.getSessionApi().syncOpenSession(
        storedSync.sessionId,
        request: SyncSessionRequest(
          currentTime: syncedCurrentTime,
          timeListened: storedSync.timeListened,
          duration: storedSync.duration,
        ),
      );

      logger(
        'Replayed stored sync into open session ${storedSync.sessionId}. '
        'currentTime=$syncedCurrentTime, timeListened=${storedSync.timeListened}, '
        'localUpdatedAt=$localUpdatedAt, remoteUpdatedAt=${remoteUpdatedAt ?? 'null'}.',
        tag: 'SessionRepository',
        level: InfoLevel.debug,
      );
      return _StoredSyncReplayAction.synced;
    } on DioException catch (e) {
      if (_isSessionUnavailableSyncError(e)) {
        logger(
          'Open session ${storedSync.sessionId} not available anymore. Will create a new session.',
          tag: 'SessionRepository',
          level: InfoLevel.debug,
        );
        return _StoredSyncReplayAction.retryWithNewSession;
      }

      logger('Failed to replay open session sync: $e', tag: 'SessionRepository', level: InfoLevel.warning);
      return _StoredSyncReplayAction.keepLocal;
    } catch (e) {
      if (_isSessionUnavailableSyncError(e)) {
        logger(
          'Open session ${storedSync.sessionId} not available anymore. Will create a new session.',
          tag: 'SessionRepository',
          level: InfoLevel.debug,
        );
        return _StoredSyncReplayAction.retryWithNewSession;
      }

      logger('Failed to replay open session sync: $e', tag: 'SessionRepository', level: InfoLevel.warning);
      return _StoredSyncReplayAction.keepLocal;
    }
  }

  Future<bool> _syncStoredAsNewSession(ABSApi api, StoredSyncEntry storedSync) async {
    final String newSessionId = const Uuid().v4();

    try {
      final PlaybackSession session = await createLocalSession(
        newSessionId,
        storedSync.itemId,
        storedSync.userId,
        DateTime.fromMillisecondsSinceEpoch(storedSync.lastUpdated.millisecondsSinceEpoch),
        episodeId: storedSync.episodeId,
        initialTimeListening: storedSync.timeListened,
        currentPosition: storedSync.currentTime,
        duration: storedSync.duration,
      );

      await api.getSessionApi().syncLocalSession(session);
      logger(
        'Replayed stored sync ${storedSync.sessionId} as new session $newSessionId.',
        tag: 'SessionRepository',
        level: InfoLevel.debug,
      );

      return true;
    } on DioException catch (e) {
      if (_isMissingLibraryItemSyncError(e)) {
        logger(
          'Keeping stored sync ${storedSync.sessionId} local because item ${storedSync.itemId} was not found on server.',
          tag: 'SessionRepository',
          level: InfoLevel.debug,
        );
        return false;
      }

      logger(
        'Failed to replay stored sync ${storedSync.sessionId} as new session: $e',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
      return false;
    } catch (e) {
      if (_isMissingLibraryItemSyncError(e)) {
        logger(
          'Keeping stored sync ${storedSync.sessionId} local because item ${storedSync.itemId} was not found on server.',
          tag: 'SessionRepository',
          level: InfoLevel.debug,
        );
        return false;
      }

      logger(
        'Failed to replay stored sync ${storedSync.sessionId} as new session: $e',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
      return false;
    }
  }

  bool _isSessionUnavailableSyncError(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 404 || statusCode == 409 || statusCode == 410) {
        return true;
      }
    }

    final message = error.toString().toLowerCase();
    return message.contains('session') && (message.contains('not found') || message.contains('404'));
  }

  bool _isMissingLibraryItemSyncError(Object error) {
    if (error is DioException) {
      return error.response?.statusCode == 404;
    }

    final message = error.toString();
    return message.contains('Failed to fetch library item') && message.contains('status code of 404');
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
    final selectedEpisode = episodeId == null
        ? null
        : libraryItem.media?.podcastMedia?.episodes?.where((episode) => episode.id == episodeId).firstOrNull;

    final selectedEpisodeTrack = selectedEpisode?.audioFile?.toAudioTrack();
    final selectedEpisodeTitle = selectedEpisode?.title;
    final hasSelectedEpisodeTitle = selectedEpisodeTitle != null && selectedEpisodeTitle.trim().isNotEmpty;
    final double? derivedStartTime = initialTimeListening != null && currentPosition != null
        ? (currentPosition - initialTimeListening).clamp(0.0, double.infinity).toDouble()
        : initialTimeListening;

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
      displayTitle: hasSelectedEpisodeTitle ? selectedEpisodeTitle.trim() : libraryItem.title,
      chapters: episodeId == null ? libraryItem.media?.bookMedia?.chapters : null,
      displayAuthor: libraryItem.authorString,
      coverPath: libraryItem.media?.bookMedia?.coverPath ?? libraryItem.media?.podcastMedia?.coverPath,
      duration: duration ?? libraryItem.media?.duration(episodeId: episodeId),
      playMethod: 0,
      deviceInfo: await PlayerUtils.getDeviceInfo(),
      mediaPlayer: '$appName just_audio',
      date: date.toIso8601String(),
      dayOfWeek: date.weekday.toString(),
      timeListening: initialTimeListening,
      startTime: derivedStartTime,
      currentTime: currentPosition,
      updatedAt: date.millisecondsSinceEpoch,
      audioTracks:
          libraryItem.media?.bookMedia?.audioFiles?.map((a) => a.toAudioTrack()).whereType<AudioTrack>().toList() ??
          (selectedEpisodeTrack == null ? const <AudioTrack>[] : <AudioTrack>[selectedEpisodeTrack]),
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
