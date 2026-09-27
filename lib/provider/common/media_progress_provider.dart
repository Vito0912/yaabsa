import 'dart:async';
import 'dart:convert';

import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/me/media_item_type.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/database/app_database.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/util/server_version.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'media_progress_provider.g.dart';

String mediaProgressKey(String libraryItemId, [String? episodeId]) {
  if (episodeId == null || episodeId.isEmpty) {
    return libraryItemId;
  }
  return '$libraryItemId::$episodeId';
}

@riverpod
MediaProgress? mediaProgressByKey(Ref ref, String key) {
  ref.read(mediaProgressProvider);
  return ref.read(mediaProgressStoreProvider).progressByKey[key];
}

@riverpod
List<MediaProgress> mediaProgressForLibraryItem(Ref ref, String libraryItemId) {
  ref.read(mediaProgressProvider);
  return List<MediaProgress>.unmodifiable(
    ref.read(mediaProgressStoreProvider).progressByLibraryItemId[libraryItemId]?.values ?? const <MediaProgress>[],
  );
}

class MediaProgressStore {
  Map<String, MediaProgress> progressByKey = <String, MediaProgress>{};
  Map<String, Map<String, MediaProgress>> progressByLibraryItemId = <String, Map<String, MediaProgress>>{};
  bool isInitialized = false;
}

@Riverpod(keepAlive: true)
MediaProgressStore mediaProgressStore(Ref ref) {
  return MediaProgressStore();
}

@Riverpod(keepAlive: true)
class MediaProgressRevision extends _$MediaProgressRevision {
  @override
  int build() => 0;

  void advance() {
    state++;
  }
}

@Riverpod(keepAlive: true)
class MediaProgressNotifier extends _$MediaProgressNotifier {
  MediaProgressStore get _store => ref.read(mediaProgressStoreProvider);

  Map<String, MediaProgress> get _progressByKey => _store.progressByKey;

  set _progressByKey(Map<String, MediaProgress> value) {
    _store.progressByKey = value;
  }

  Map<String, Map<String, MediaProgress>> get _progressByLibraryItemId => _store.progressByLibraryItemId;

  set _progressByLibraryItemId(Map<String, Map<String, MediaProgress>> value) {
    _store.progressByLibraryItemId = value;
  }

  bool get isInitialized => _store.isInitialized;

  int get progressCount => _progressByKey.length;

  Map<String, MediaProgress> get snapshot => Map<String, MediaProgress>.unmodifiable(_progressByKey);

  MediaProgress? progressForKey(String key) => _progressByKey[key];

  List<MediaProgress> progressForLibraryItem(String libraryItemId) {
    return List<MediaProgress>.unmodifiable(_progressByLibraryItemId[libraryItemId]?.values ?? const <MediaProgress>[]);
  }

  bool _isMeaningfulGlobalChange(MediaProgress? previous, MediaProgress? next) {
    if (previous == null || next == null) {
      return previous != next;
    }
    return previous.isFinished != next.isFinished ||
        previous.hideFromContinueListening != next.hideFromContinueListening ||
        (previous.progress - next.progress).abs() >= 0.01;
  }

  void _notifyChangedKeys(Iterable<String> keys, {required bool notifyGlobalListeners}) {
    final changedKeys = keys.toSet();
    if (changedKeys.isEmpty) {
      return;
    }

    final changedLibraryItemIds = <String>{};
    for (final key in changedKeys) {
      ref.invalidate(mediaProgressByKeyProvider(key));
      final progress = _progressByKey[key];
      final separatorIndex = key.indexOf('::');
      final libraryItemId = progress?.libraryItemId ?? (separatorIndex < 0 ? key : key.substring(0, separatorIndex));
      changedLibraryItemIds.add(libraryItemId);
    }
    for (final libraryItemId in changedLibraryItemIds) {
      ref.invalidate(mediaProgressForLibraryItemProvider(libraryItemId));
    }
    if (notifyGlobalListeners) {
      ref.read(mediaProgressRevisionProvider.notifier).advance();
    }
  }

  void _replaceProgressMap(Map<String, MediaProgress> next) {
    final changedKeys = <String>{};
    var notifyGlobalListeners = false;
    for (final key in _progressByKey.keys) {
      if (!next.containsKey(key)) {
        changedKeys.add(key);
        notifyGlobalListeners = true;
      }
    }
    for (final entry in next.entries) {
      if (_progressByKey[entry.key] != entry.value) {
        changedKeys.add(entry.key);
        notifyGlobalListeners =
            notifyGlobalListeners || _isMeaningfulGlobalChange(_progressByKey[entry.key], entry.value);
      }
    }

    _progressByKey = Map<String, MediaProgress>.of(next);
    _progressByLibraryItemId = <String, Map<String, MediaProgress>>{};
    for (final entry in _progressByKey.entries) {
      _progressByLibraryItemId.putIfAbsent(entry.value.libraryItemId, () => <String, MediaProgress>{})[entry.key] =
          entry.value;
    }
    _notifyChangedKeys(changedKeys, notifyGlobalListeners: notifyGlobalListeners);
  }

  void _setProgress(String key, MediaProgress progress) {
    final existing = _progressByKey[key];
    if (existing == progress) {
      return;
    }
    if (existing != null && existing.libraryItemId != progress.libraryItemId) {
      final previousItemProgress = _progressByLibraryItemId[existing.libraryItemId];
      previousItemProgress?.remove(key);
      if (previousItemProgress?.isEmpty ?? false) {
        _progressByLibraryItemId.remove(existing.libraryItemId);
      }
    }
    _progressByKey[key] = progress;
    _progressByLibraryItemId.putIfAbsent(progress.libraryItemId, () => <String, MediaProgress>{})[key] = progress;
    _notifyChangedKeys(<String>[key], notifyGlobalListeners: _isMeaningfulGlobalChange(existing, progress));
  }

  bool _removeProgress(String key) {
    final removed = _progressByKey.remove(key);
    if (removed == null) {
      return false;
    }
    final itemProgress = _progressByLibraryItemId[removed.libraryItemId];
    itemProgress?.remove(key);
    if (itemProgress?.isEmpty ?? false) {
      _progressByLibraryItemId.remove(removed.libraryItemId);
    }
    _notifyChangedKeys(<String>[key], notifyGlobalListeners: true);
    return true;
  }

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
      if (!ref.mounted) {
        return;
      }
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

  Future<List<MediaProgress>> _fetchAllRemoteProgress(ABSApi absApi) async {
    final meApi = absApi.getMeApi();

    if (!serverSupportsMediaProgressAndBookmarkRoutes(ref.read(serverVersionProvider))) {
      return (await meApi.getUser()).data?.mediaProgress ?? const <MediaProgress>[];
    }

    final response = await meApi.getAllMediaProgress();
    final progressResponse = response.data;
    if (progressResponse == null) {
      throw Exception('Media progress response is null.');
    }
    return progressResponse.mediaProgress;
  }

  @override
  Future<void> build() async {
    _store.isInitialized = false;
    _replaceProgressMap(const <String, MediaProgress>{});

    ref.listen(absApiProvider, (previous, next) {
      Future.microtask(() => ref.invalidateSelf());
    });

    final userId = _activeUserId();
    final localMap = await _loadLocalProgressMap(userId: userId);
    if (!ref.mounted) {
      return;
    }
    _replaceProgressMap(_mergeProgressMaps(localMap, _progressByKey));
    _store.isInitialized = true;

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      logger(
        'ABSApi is not available yet. Skipping remote progress fetch.',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
      return;
    }

    try {
      final remoteProgress = await _fetchAllRemoteProgress(absApi);
      if (!ref.mounted) {
        return;
      }
      final remoteMap = _listToMap(remoteProgress);
      final mergedMap = _mergeProgressMaps(_progressByKey, remoteMap);
      _replaceProgressMap(mergedMap);
      await _persistProgressList(remoteMap.values);
    } catch (e, s) {
      logger(
        'Error fetching remote media progress in build: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      if (localMap.isEmpty) {
        _store.isInitialized = false;
        rethrow;
      }
    }
  }

  Future<void> refreshAllProgress({bool clearBefore = true}) async {
    final previousMap = Map<String, MediaProgress>.of(_progressByKey);
    if (clearBefore) {
      _replaceProgressMap(const <String, MediaProgress>{});
    }

    final userId = _activeUserId();
    final localMap = await _loadLocalProgressMap(userId: userId);
    if (!ref.mounted) {
      return;
    }
    final baseMap = _mergeProgressMaps(previousMap, localMap);

    final absApi = ref.read(absApiProvider);
    if (absApi == null) {
      logger(
        'ABSApi is not available yet. Skipping remote refresh.',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
      _replaceProgressMap(_mergeProgressMaps(baseMap, _progressByKey));
      return;
    }

    try {
      final remoteProgress = await _fetchAllRemoteProgress(absApi);
      if (!ref.mounted) {
        return;
      }
      final remoteMap = _listToMap(remoteProgress);
      final mergedMap = _mergeProgressMaps(_progressByKey, remoteMap);
      _replaceProgressMap(mergedMap);
      await _persistProgressList(remoteMap.values);
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);

      if (!ref.mounted) {
        return;
      }
      _replaceProgressMap(_mergeProgressMaps(baseMap, _progressByKey));
    }
  }

  Future<MediaProgress?> fetchOrRefreshIndividualProgress(
    String libraryItemId, {
    String? episodeId,
    String? userId,
  }) async {
    final key = _progressKey(libraryItemId, episodeId);
    final existingMap = _progressByKey;
    MediaProgress? localProgress = existingMap[key];
    final effectiveUserId = userId ?? _activeUserId();

    if (localProgress == null) {
      final localMap = await _loadLocalProgressMap(userId: effectiveUserId);
      if (!ref.mounted) {
        return localProgress;
      }
      if (localMap.isNotEmpty) {
        final mergedMap = _mergeProgressMaps(existingMap, localMap);
        _replaceProgressMap(mergedMap);
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
      if (!ref.mounted) {
        return localProgress;
      }
      localProgress = _progressByKey[key] ?? localProgress;
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

        _removeProgress(key);

        if (effectiveUserId != null && effectiveUserId.isNotEmpty) {
          await _deleteCachedProgress(userId: effectiveUserId, libraryItemId: libraryItemId, episodeId: episodeId);
        }

        return null;
      }

      await _persistProgress(remoteProgress);
      if (!ref.mounted) {
        return localProgress;
      }

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

      _setProgress(key, resolvedProgress);

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

        _removeProgress(key);

        if (effectiveUserId != null && effectiveUserId.isNotEmpty) {
          await _deleteCachedProgress(userId: effectiveUserId, libraryItemId: libraryItemId, episodeId: episodeId);
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
      final key = _progressKey(libraryItemId, session.episodeId);

      MediaProgress? updatedProgress = _progressByKey[key];

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
          _setProgress(key, updatedProgress);
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

      final isFinished = progress >= 0.999;
      updatedProgress = updatedProgress.copyWith(
        userId: effectiveUserId,
        currentTime: currentTime,
        progress: progress,
        isFinished: isFinished,
        finishedAt: isFinished
            ? (updatedProgress.isFinished ? updatedProgress.finishedAt ?? nextLastUpdate : nextLastUpdate)
            : null,
        lastUpdate: nextLastUpdate,
      );

      _setProgress(key, updatedProgress);
      await _persistProgress(updatedProgress);
      return updatedProgress;
    } catch (e, s) {
      logger(
        'Error updating media progress for $libraryItemId: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
    }
    return null;
  }

  void applyRemoteProgressUpdate(MediaProgress progress) {
    final key = _progressKeyFromMediaProgress(progress);
    final existingProgress = _progressByKey[key];

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

    _setProgress(key, progress);
    unawaited(_persistProgress(progress));
  }

  void applyLocalEbookProgressUpdate({
    required String libraryItemId,
    required String ebookLocation,
    required double ebookProgress,
    String? episodeId,
  }) {
    final key = _progressKey(libraryItemId, episodeId);
    final existingProgress = _progressByKey[key];
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

    _setProgress(key, updatedProgress);
    unawaited(_persistProgress(updatedProgress));
  }

  List<MediaProgress> getAllProgressForLibraryItem(String libraryItemId) {
    return progressForLibraryItem(libraryItemId);
  }
}
