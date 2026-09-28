import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;

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
import 'package:yaabsa/util/audio_handler/player_history_handler.dart';
import 'package:yaabsa/util/local_cover_path.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/player_utils.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'session_provider.g.dart';

enum _StoredSyncReplayAction { synced, retryWithNewSession, keepLocal }

class PlaybackSessionBinding {
  const PlaybackSessionBinding({required this.session, required this.isLocal});

  final PlaybackSession session;
  final bool isLocal;

  String get sessionId => session.id;
  String get itemId => session.libraryItemId;
  String? get episodeId => session.episodeId;
}

class SessionRepository {
  final Ref ref;
  SessionRepository(this.ref);

  PlaybackSession? _currentSession;
  bool _isLocalSession = true;
  final Map<String, PlaybackSession> _localBoundSessionVersions = <String, PlaybackSession>{};

  PlaybackSession? get currentSession => _currentSession;
  PlaybackSessionBinding? get currentSessionBinding {
    final session = _currentSession;
    if (session == null) {
      return null;
    }
    return PlaybackSessionBinding(session: session, isLocal: _isLocalSession);
  }

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

    return Uri.file(trimmed, windows: !kIsWeb && Platform.isWindows);
  }

  bool isCurrentSessionBinding(PlaybackSessionBinding binding) {
    return _currentSession?.id == binding.sessionId;
  }

  bool detachSessionBinding(PlaybackSessionBinding binding) {
    if (_currentSession?.id != binding.sessionId) {
      return false;
    }
    _currentSession = null;
    return true;
  }

  Future<void> closeSessionBinding(PlaybackSessionBinding binding) async {
    if (binding.isLocal) {
      _localBoundSessionVersions.remove(binding.sessionId);
      if (_currentSession?.id == binding.sessionId) {
        logger('Closed bound local session ${binding.sessionId}', tag: 'SessionRepository');
        _currentSession = null;
      }
      return;
    }

    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      logger(
        'No API available, closing bound session ${binding.sessionId} locally only.',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
      if (_currentSession?.id == binding.sessionId) {
        _currentSession = null;
      }
      return;
    }

    try {
      await api.getSessionApi().closeOpenSession(binding.sessionId);
    } catch (e) {
      logger(
        'Failed to close bound session ${binding.sessionId}: $e',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
    }

    if (_currentSession?.id == binding.sessionId) {
      _currentSession = null;
    }
  }

  Future<void> closeSession() async {
    final binding = currentSessionBinding;
    if (binding == null) {
      return;
    }
    await closeSessionBinding(binding);
  }

  Future<InternalMedia?> openSession(
    String itemId, {
    String? episodeId,
    bool forceDirectPlay = false,
    bool forceTranscode = false,
  }) async {
    await ref.read(currentUserProvider.future);

    final ABSApi? api = ref.read(absApiProvider);
    final AppDatabase db = ref.read(appDatabaseProvider);
    final String? userId = _activeUserId;

    if (userId == null) {
      logger('No active user available, cannot open session.', tag: 'SessionRepository', level: InfoLevel.warning);
      return null;
    }

    final downloaded = forceTranscode ? null : await db.getStoredDownload(itemId, userId, episodeId: episodeId);

    if (itemId == _currentSession?.libraryItemId && episodeId == _currentSession?.episodeId) return null;

    if (downloaded == null) {
      if (api == null) {
        logger('No API available and no local download found.', tag: 'SessionRepository', level: InfoLevel.warning);
        return null;
      }

      PlayLibraryItemRequest playRequest = PlayLibraryItemRequest(
        deviceInfo: await PlayerUtils.getDeviceInfo(),
        forceDirectPlay: forceDirectPlay && !forceTranscode,
        forceTranscode: forceTranscode,
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
        final trackTypes = session.audioTracks?.map((track) => track.mimeType).join(', ') ?? 'none';
        final sourceCodecs =
            session.libraryItem?.media?.bookMedia?.audioFiles
                ?.map((audioFile) => '${audioFile.codec ?? 'unknown'}/${audioFile.mimeType ?? 'unknown'}')
                .join(', ') ??
            'unknown';
        logger(
          'Session opened successfully: ${session.id} '
          '(playMethod=${session.playMethod}, mediaPlayer=${session.mediaPlayer}, '
          'trackTypes=$trackTypes, sourceCodecs=$sourceCodecs)',
          tag: 'SessionRepository',
        );
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
      _localBoundSessionVersions[_currentSession!.id] = _currentSession!;
    }

    final hasCoverPath =
        (_currentSession!.coverPath?.isNotEmpty ?? false) || (_currentSession!.libraryItem?.hasCover ?? false);
    final resolvedLocalCoverPath = await resolveDisplayCoverPath(
      downloaded?.coverPath,
      cacheKey: '$userId:$itemId:${episodeId ?? 'item'}',
    );
    final localCoverUri = _localCoverUriFromPath(resolvedLocalCoverPath ?? downloaded?.coverPath);
    final remoteCoverUri = hasCoverPath && api != null
        ? api.getLibraryItemApi().getCoverUri(
            _currentSession!.libraryItemId,
            item: _currentSession!.libraryItem,
            width: playerCoverRequestDimension.toDouble(),
            height: playerCoverRequestDimension.toDouble(),
          )
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

  Future<InternalMedia?> reopenSessionWithTranscode(String itemId, {String? episodeId}) async {
    await closeSession();

    return openSession(itemId, episodeId: episodeId, forceTranscode: true);
  }

  Future<bool> syncOpenSession(double currentTime, double timeListened, {required bool canReachServer}) async {
    final binding = currentSessionBinding;
    if (binding == null) {
      logger('No session available', tag: 'SessionRepository', level: InfoLevel.warning);
      return false;
    }
    return syncSessionBinding(binding, currentTime, timeListened, canReachServer: canReachServer);
  }

  Future<bool> syncSessionBinding(
    PlaybackSessionBinding binding,
    double currentTime,
    double timeListened, {
    required bool canReachServer,
  }) async {
    final currentBoundSession = _currentSession?.id == binding.sessionId ? _currentSession : null;
    final session = binding.isLocal
        ? (currentBoundSession ?? _localBoundSessionVersions[binding.sessionId] ?? binding.session)
        : (currentBoundSession ?? binding.session);

    if (binding.isLocal) {
      final double newTimeListening = (session.timeListening ?? 0.0) + timeListened;
      final updatedSession = session.copyWith(
        currentTime: currentTime,
        timeListening: newTimeListening,
        updatedAt: DateTime.now().millisecondsSinceEpoch,
      );
      _localBoundSessionVersions[binding.sessionId] = updatedSession;
      if (_currentSession?.id == binding.sessionId) {
        _currentSession = updatedSession;
        _isLocalSession = true;
      }

      final MediaProgress? updatedProgress = await ref
          .read(mediaProgressProvider.notifier)
          .updateMediaProgress(updatedSession.libraryItemId, currentTime, updatedSession);

      if (canReachServer) {
        final syncedRemotely = await _syncLocalSessionProgressDirectly(updatedSession);
        if (syncedRemotely) {
          return true;
        }
      }

      logger('Session is local; storing bound sync locally', tag: 'SessionRepository', level: InfoLevel.debug);
      return _addLocal(currentTime, timeListened, updatedProgress, session: updatedSession, sessionLocal: true);
    }

    if (!canReachServer) {
      final MediaProgress? updatedProgress = await ref
          .read(mediaProgressProvider.notifier)
          .updateMediaProgress(session.libraryItemId, currentTime, session);

      logger(
        'Server is offline/unreachable by watcher; storing bound sync locally',
        tag: 'SessionRepository',
        level: InfoLevel.debug,
      );
      return _addLocal(currentTime, timeListened, updatedProgress, session: session, sessionLocal: false);
    }

    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      final MediaProgress? updatedProgress = await ref
          .read(mediaProgressProvider.notifier)
          .updateMediaProgress(session.libraryItemId, currentTime, session);

      logger('No API available, storing bound sync locally.', tag: 'SessionRepository', level: InfoLevel.warning);
      return _addLocal(currentTime, timeListened, updatedProgress, session: session, sessionLocal: false);
    }

    try {
      final result = await api.getSessionApi().syncOpenSession(
        binding.sessionId,
        request: SyncSessionRequest(
          currentTime: currentTime,
          timeListened: timeListened,
          duration: session.duration ?? 0,
        ),
      );

      await ref.read(mediaProgressProvider.notifier).updateMediaProgress(session.libraryItemId, currentTime, session);
      PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.sync);
      return result;
    } catch (e) {
      logger(
        'Failed to sync bound open session ${binding.sessionId}',
        tag: 'SessionRepository',
        level: InfoLevel.warning,
      );
      final MediaProgress? updatedProgress = await ref
          .read(mediaProgressProvider.notifier)
          .updateMediaProgress(session.libraryItemId, currentTime, session);

      return _addLocal(currentTime, timeListened, updatedProgress, session: session, sessionLocal: false);
    }
  }

  Future<bool> _syncLocalSessionProgressDirectly(PlaybackSession currentSession) async {
    final ABSApi? api = ref.read(absApiProvider);

    if (api == null) {
      return false;
    }

    try {
      await api.getSessionApi().syncLocalSession(currentSession);

      PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.localSync);
      return true;
    } catch (e) {
      logger('Failed direct local session sync: $e', tag: 'SessionRepository', level: InfoLevel.warning);
      return false;
    }
  }

  Future<bool> _addLocal(
    double currentTime,
    double timeListened,
    MediaProgress? progress, {
    required PlaybackSession session,
    required bool sessionLocal,
  }) async {
    final String userId = session.userId;

    final double duration = session.duration ?? 0;
    final double normalizedProgress = duration > 0 ? (currentTime / duration).clamp(0.0, 1.0).toDouble() : 0.0;
    final MediaProgress effectiveProgress =
        progress ?? session.toMediaProgress(null, userId, normalizedProgress, currentTime);

    StoredSyncsCompanion sync = StoredSyncsCompanion(
      sessionId: Value(session.id),
      itemId: Value(session.libraryItemId),
      episodeId: Value(session.episodeId),
      userId: Value(userId),
      currentTime: Value(currentTime),
      timeListened: Value(timeListened),
      duration: Value(duration),
      lastUpdated: Value(DateTime.now()),
      sessionLocal: Value(sessionLocal),
      mediaProgress: Value(jsonEncode(effectiveProgress)),
    );

    await ref.read(appDatabaseProvider).addOrUpdateSync(sync);
    PlayerHistoryHandler.addPlayerHistory(PlayerHistoryType.syncOffline);
    logger('Sync stored locally for session ${session.id}', tag: 'SessionRepository', level: InfoLevel.debug);
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
        date: _formatDateString(storedSync.lastUpdated),
        dayOfWeek: _getWeekdayString(storedSync.lastUpdated),
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
    final LibraryItem libraryItem = await ref.read(libraryItemProvider(itemId, episodeId: episodeId).future);
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
      date: _formatDateString(date),
      dayOfWeek: _getWeekdayString(date),
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

String _formatDateString(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

String _getWeekdayString(DateTime date) {
  const List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  return weekdays[date.weekday - 1];
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) {
  return SessionRepository(ref);
}
