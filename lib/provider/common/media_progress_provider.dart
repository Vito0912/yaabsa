import 'dart:async';
import 'dart:convert';

import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_progress_provider.g.dart';

String mediaProgressKey(String libraryItemId, [String? episodeId]) {
  if (episodeId == null || episodeId.isEmpty) {
    return libraryItemId;
  }
  return '$libraryItemId::$episodeId';
}

@Riverpod(keepAlive: true)
class MediaProgressNotifier extends _$MediaProgressNotifier {
  String _progressKey(String libraryItemId, [String? episodeId]) {
    return mediaProgressKey(libraryItemId, episodeId);
  }

  String _progressKeyFromMediaProgress(MediaProgress progress) {
    return _progressKey(progress.libraryItemId, progress.episodeId);
  }

  String? _activeUserId() {
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

  int _lastUpdatedMillis(MediaProgress? progress) {
    return progress?.lastUpdate ?? 0;
  }

  MediaProgress _preferMostRecentProgress(
    MediaProgress existing,
    MediaProgress incoming, {
    bool preferIncomingOnTie = false,
  }) {
    final existingUpdatedAt = _lastUpdatedMillis(existing);
    final incomingUpdatedAt = _lastUpdatedMillis(incoming);

    if (incomingUpdatedAt > existingUpdatedAt) {
      return incoming;
    }
    if (incomingUpdatedAt == existingUpdatedAt && preferIncomingOnTie) {
      return incoming;
    }
    return existing;
  }

  Map<String, MediaProgress> _mergeProgressMaps(
    Map<String, MediaProgress> base,
    Map<String, MediaProgress> incoming, {
    bool preferIncomingOnTie = false,
  }) {
    if (incoming.isEmpty) {
      return <String, MediaProgress>{...base};
    }

    final merged = <String, MediaProgress>{...base};
    for (final entry in incoming.entries) {
      final existing = merged[entry.key];
      if (existing == null) {
        merged[entry.key] = entry.value;
        continue;
      }

      merged[entry.key] = _preferMostRecentProgress(existing, entry.value, preferIncomingOnTie: preferIncomingOnTie);
    }

    return merged;
  }

  Map<String, MediaProgress> _listToMap(List<MediaProgress>? progressList) {
    if (progressList == null || progressList.isEmpty) {
      return {};
    }
    final Map<String, MediaProgress> result = {};
    for (var p in progressList) {
      final key = _progressKeyFromMediaProgress(p);
      if (!result.containsKey(key) || (_lastUpdatedMillis(p) > _lastUpdatedMillis(result[key]))) {
        result[key] = p;
      }
    }
    return result;
  }

  MediaProgress? _decodeProgressJsonOrNull(String rawJson, {required String source}) {
    try {
      final decoded = jsonDecode(rawJson);
      if (decoded is Map<String, dynamic>) {
        return MediaProgress.fromJson(decoded);
      }
      if (decoded is Map) {
        return MediaProgress.fromJson(Map<String, dynamic>.from(decoded));
      }
      throw const FormatException('Stored media progress payload is not a JSON object');
    } catch (e, s) {
      logger(
        'Failed to decode media progress from $source: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.warning,
      );
      return null;
    }
  }

  Future<Map<String, MediaProgress>> _loadLocalProgressMap({String? userId}) async {
    final db = ref.read(appDatabaseProvider);

    final List<StoredSyncEntry> syncEntries = (userId == null || userId.isEmpty)
        ? await db.getAllSyncs()
        : await db.getAllSyncsByUser(userId);

    final Map<String, MediaProgress> syncProgressMap = <String, MediaProgress>{};
    for (final entry in syncEntries) {
      final progress = _decodeProgressJsonOrNull(entry.mediaProgress, source: 'storedSyncs:${entry.sessionId}');
      if (progress == null) {
        continue;
      }

      final key = _progressKeyFromMediaProgress(progress);
      final existing = syncProgressMap[key];
      if (existing == null) {
        syncProgressMap[key] = progress;
      } else {
        syncProgressMap[key] = _preferMostRecentProgress(existing, progress);
      }
    }

    if (userId == null || userId.isEmpty) {
      return syncProgressMap;
    }

    final cachedEntries = await db.getStoredMediaProgressByUser(userId);
    final Map<String, MediaProgress> cachedProgressMap = <String, MediaProgress>{};
    for (final entry in cachedEntries) {
      final progress = _decodeProgressJsonOrNull(
        entry.mediaProgress,
        source: 'storedMediaProgress:${entry.progressId}',
      );
      if (progress == null) {
        continue;
      }

      final key = _progressKeyFromMediaProgress(progress);
      final existing = cachedProgressMap[key];
      if (existing == null) {
        cachedProgressMap[key] = progress;
      } else {
        cachedProgressMap[key] = _preferMostRecentProgress(existing, progress);
      }
    }

    return _mergeProgressMaps(cachedProgressMap, syncProgressMap);
  }

  Future<void> _persistProgress(MediaProgress progress) async {
    final userId = progress.userId.trim();
    if (userId.isEmpty) {
      return;
    }

    final lastUpdate = DateTime.fromMillisecondsSinceEpoch(_lastUpdatedMillis(progress));

    try {
      await ref
          .read(appDatabaseProvider)
          .addOrUpdateStoredMediaProgress(
            userId: userId,
            itemId: progress.libraryItemId,
            episodeId: progress.episodeId,
            lastUpdated: lastUpdate,
            mediaProgress: jsonEncode(progress.toJson()),
          );
    } catch (e, s) {
      logger(
        'Failed to persist media progress for key ${_progressKeyFromMediaProgress(progress)}: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.warning,
      );
    }
  }

  Future<void> _persistProgressList(Iterable<MediaProgress> progressList) async {
    for (final progress in progressList) {
      await _persistProgress(progress);
    }
  }

  Future<void> _deleteCachedProgress({required String userId, required String libraryItemId, String? episodeId}) async {
    try {
      await ref.read(appDatabaseProvider).deleteStoredMediaProgress(userId, libraryItemId, episodeId: episodeId);
    } catch (e, s) {
      logger(
        'Failed to delete cached media progress for ${_progressKey(libraryItemId, episodeId)}: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.warning,
      );
    }
  }

  @override
  Future<Map<String, MediaProgress>> build() async {
    final userId = _activeUserId();
    final localMap = await _loadLocalProgressMap(userId: userId);
    state = AsyncData(localMap);

    ref.listen(absApiProvider, (previous, next) {
      Future.microtask(() => ref.invalidateSelf());
    });

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      logger(
        'ABSApi is not available yet. Skipping remote progress fetch.',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
      return localMap;
    }

    try {
      final meApi = absApi.getMeApi();
      final userResponse = await meApi.getUser();
      final user = userResponse.data;
      if (user == null) {
        throw Exception('User data is null, cannot fetch media progress.');
      }

      final remoteMap = _listToMap(user.mediaProgress);
      final mergedMap = _mergeProgressMaps(localMap, remoteMap);
      state = AsyncData(mergedMap);
      await _persistProgressList(remoteMap.values);
      return mergedMap;
    } catch (e, s) {
      logger(
        'Error fetching remote media progress in build: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      if (localMap.isEmpty) {
        state = AsyncError<Map<String, MediaProgress>>(e, s);
      }
      return localMap;
    }
  }

  Future<void> refreshAllProgress({bool clearBefore = true}) async {
    final previousMap = state.asData?.value ?? <String, MediaProgress>{};
    if (clearBefore) state = const AsyncLoading<Map<String, MediaProgress>>();

    final userId = _activeUserId();
    final localMap = await _loadLocalProgressMap(userId: userId);
    final baseMap = _mergeProgressMaps(previousMap, localMap);

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      logger(
        'ABSApi is not available yet. Skipping remote refresh.',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
      state = AsyncData(baseMap);
      return;
    }

    try {
      final meApi = absApi.getMeApi();
      final userResponse = await meApi.getUser();
      final user = userResponse.data;
      if (user == null) {
        throw Exception('User data is null during refresh all progress.');
      }

      final remoteMap = _listToMap(user.mediaProgress);
      final mergedMap = _mergeProgressMaps(baseMap, remoteMap);
      state = AsyncData(mergedMap);
      await _persistProgressList(remoteMap.values);
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);

      if (baseMap.isEmpty) {
        state = AsyncError<Map<String, MediaProgress>>(e, s);
      } else {
        state = AsyncData(baseMap);
      }
    }
  }

  Future<MediaProgress?> fetchOrRefreshIndividualProgress(String libraryItemId, {String? episodeId}) async {
    final key = _progressKey(libraryItemId, episodeId);
    final existingMap = state.asData?.value ?? <String, MediaProgress>{};
    MediaProgress? localProgress = existingMap[key];

    if (localProgress == null) {
      final localMap = await _loadLocalProgressMap(userId: _activeUserId());
      if (localMap.isNotEmpty) {
        final mergedMap = _mergeProgressMaps(existingMap, localMap);
        state = AsyncData(mergedMap);
        localProgress = mergedMap[key];
      }
    }

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      logger(
        'ABSApi is not available yet. Skipping remote individual progress fetch for $libraryItemId.',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
      return localProgress;
    }

    try {
      final meApi = absApi.getMeApi();
      final response = await meApi.getProgress(libraryItemId, episodeId: episodeId);
      final remoteProgress = response.data;

      if (remoteProgress == null) {
        if (localProgress != null) {
          logger(
            'Remote progress was null for $key. Keeping local cached progress.',
            tag: 'MediaProgressProvider',
            level: InfoLevel.debug,
          );
          return localProgress;
        }

        final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
        final Map<String, MediaProgress> updatedMap = {...currentMap};
        if (updatedMap.remove(key) != null) {
          state = AsyncData(updatedMap);
        }

        final userId = _activeUserId();
        if (userId != null && userId.isNotEmpty) {
          await _deleteCachedProgress(userId: userId, libraryItemId: libraryItemId, episodeId: episodeId);
        }

        return null;
      }

      await _persistProgress(remoteProgress);

      late final MediaProgress resolvedProgress;
      if (localProgress == null) {
        resolvedProgress = remoteProgress;
      } else if (localProgress.isFinished != remoteProgress.isFinished) {
        resolvedProgress = remoteProgress;
        logger(
          'Preferring remote progress for $key due to finished-state change '
          '(local=${localProgress.isFinished}, remote=${remoteProgress.isFinished}).',
          tag: 'MediaProgressProvider',
          level: InfoLevel.debug,
        );
      } else {
        resolvedProgress = _preferMostRecentProgress(localProgress, remoteProgress, preferIncomingOnTie: true);
      }

      final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
      final Map<String, MediaProgress> updatedMap = {...currentMap, key: resolvedProgress};
      state = AsyncData(updatedMap);

      if (!identical(resolvedProgress, remoteProgress)) {
        logger(
          'Using local progress for $key because it is newer than remote.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.debug,
        );
      }

      await _persistProgress(resolvedProgress);
      return resolvedProgress;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        if (localProgress != null) {
          logger(
            'Remote progress returned 404 for $key. Keeping local cached progress.',
            tag: 'MediaProgressProvider',
            level: InfoLevel.debug,
          );
          return localProgress;
        }

        final currentMap = state.asData?.value ?? <String, MediaProgress>{};
        final updatedMap = {...currentMap};
        if (updatedMap.remove(key) != null) {
          state = AsyncData(updatedMap);
        }

        final userId = _activeUserId();
        if (userId != null && userId.isNotEmpty) {
          await _deleteCachedProgress(userId: userId, libraryItemId: libraryItemId, episodeId: episodeId);
        }

        return null;
      } else {
        logger(
          'DioException while fetching individual MediaProgress for $libraryItemId: $e\n${e.stackTrace}',
          tag: 'MediaProgressProvider',
          level: InfoLevel.error,
        );
        return localProgress;
      }
    } catch (e, s) {
      logger(
        'Unexpected error fetching individual media progress for $libraryItemId: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      return localProgress;
    }
  }

  Future<MediaProgress?> updateMediaProgress(String libraryItemId, double currentTime, PlaybackSession session) async {
    try {
      final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
      final key = _progressKey(libraryItemId, session.episodeId);

      MediaProgress? updatedProgress = currentMap[key];

      final String effectiveUserId = (updatedProgress?.userId.isNotEmpty ?? false)
          ? updatedProgress!.userId
          : (_activeUserId() ?? session.userId);

      if (updatedProgress == null) {
        updatedProgress = session.toMediaProgress(null, effectiveUserId, 0, 0);
        logger(
          'No existing media progress found for $libraryItemId. Creating.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.warning,
        );
      }
      final double duration = updatedProgress.duration <= 0 ? (session.duration ?? 0) : updatedProgress.duration;
      if (duration <= 0) {
        if (updatedProgress.mediaItemType == MediaItemType.BOOK) {
          var nextLastUpdate = DateTime.now().millisecondsSinceEpoch;
          final previousLastUpdate = updatedProgress.lastUpdate;
          if (previousLastUpdate != null && previousLastUpdate >= nextLastUpdate) {
            nextLastUpdate = previousLastUpdate + 1;
          }
          updatedProgress = updatedProgress.copyWith(
            userId: effectiveUserId,
            currentTime: currentTime,
            lastUpdate: nextLastUpdate,
          );
          state = AsyncData({...currentMap, key: updatedProgress});
          unawaited(_persistProgress(updatedProgress));
          return updatedProgress;
        }

        logger(
          'Invalid duration ($duration) for libraryItemId: $libraryItemId. Skipping update.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.error,
        );
        return null;
      }

      final double progress = (currentTime / duration).clamp(0.0, 1.0);

      var nextLastUpdate = DateTime.now().millisecondsSinceEpoch;
      final previousLastUpdate = updatedProgress.lastUpdate;
      if (previousLastUpdate != null && previousLastUpdate >= nextLastUpdate) {
        nextLastUpdate = previousLastUpdate + 1;
      }

      updatedProgress = updatedProgress.copyWith(
        userId: effectiveUserId,
        currentTime: currentTime,
        progress: progress,
        isFinished: progress >= 0.999,
        lastUpdate: nextLastUpdate,
      );

      final Map<String, MediaProgress> updatedMap = {...currentMap, key: updatedProgress};
      state = AsyncData(updatedMap);
      await _persistProgress(updatedProgress);
      return updatedProgress;
    } catch (e, s) {
      logger(
        'Error updating media progress for $libraryItemId: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      state = AsyncError<Map<String, MediaProgress>>(e, s);
    }
    return null;
  }

  void applyRemoteProgressUpdate(MediaProgress progress) {
    final key = _progressKeyFromMediaProgress(progress);
    final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
    final existingProgress = currentMap[key];

    final incomingLastUpdated = _lastUpdatedMillis(progress);
    final existingLastUpdated = _lastUpdatedMillis(existingProgress);
    final finishedStateChanged = existingProgress != null && progress.isFinished != existingProgress.isFinished;

    if (incomingLastUpdated < existingLastUpdated && !finishedStateChanged) {
      logger(
        'Ignoring stale remote progress update for key $key '
        '(incoming=$incomingLastUpdated, existing=$existingLastUpdated).',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );

      unawaited(_persistProgress(progress));
      return;
    }

    if (incomingLastUpdated < existingLastUpdated && finishedStateChanged) {
      logger(
        'Accepting older remote progress update for key $key due to finished-state change '
        '(incomingFinished=${progress.isFinished}, existingFinished=${existingProgress.isFinished}).',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
    }

    state = AsyncData({...currentMap, key: progress});
    unawaited(_persistProgress(progress));
  }

  void applyLocalEbookProgressUpdate({
    required String libraryItemId,
    required String ebookLocation,
    required double ebookProgress,
    String? episodeId,
  }) {
    final key = _progressKey(libraryItemId, episodeId);
    final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
    final existingProgress = currentMap[key];
    if (existingProgress == null) {
      return;
    }

    var nextLastUpdate = DateTime.now().millisecondsSinceEpoch;
    final previousLastUpdate = existingProgress.lastUpdate;
    if (previousLastUpdate != null && previousLastUpdate >= nextLastUpdate) {
      nextLastUpdate = previousLastUpdate + 1;
    }

    final updatedProgress = existingProgress.copyWith(
      ebookLocation: ebookLocation,
      ebookProgress: ebookProgress,
      lastUpdate: nextLastUpdate,
    );

    state = AsyncData({...currentMap, key: updatedProgress});
    unawaited(_persistProgress(updatedProgress));
  }

  List<MediaProgress> getAllProgressForLibraryItem(String libraryItemId) {
    final currentMap = state.asData?.value ?? <String, MediaProgress>{};
    return currentMap.values.where((progress) => progress.libraryItemId == libraryItemId).toList(growable: false);
  }
}
