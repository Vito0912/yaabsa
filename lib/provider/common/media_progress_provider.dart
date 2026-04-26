import 'dart:convert';

import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/me/media_progress.dart';
import 'package:yaabsa/api/routes/me_api.dart';
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
  MeApi _getMeApiOrThrow() {
    final absApi = ref.watch(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or ABS API not available for MediaProgressNotifier.');
    }
    return absApi.getMeApi();
  }

  String _progressKey(String libraryItemId, [String? episodeId]) {
    return mediaProgressKey(libraryItemId, episodeId);
  }

  String _progressKeyFromMediaProgress(MediaProgress progress) {
    return _progressKey(progress.libraryItemId, progress.episodeId);
  }

  Map<String, MediaProgress> _listToMap(List<MediaProgress>? progressList) {
    if (progressList == null || progressList.isEmpty) {
      return {};
    }
    final Map<String, MediaProgress> result = {};
    for (var p in progressList) {
      final key = _progressKeyFromMediaProgress(p);
      if (!result.containsKey(key) || ((p.lastUpdate ?? 0) > (result[key]?.lastUpdate ?? 0))) {
        result[key] = p;
      }
    }
    return result;
  }

  @override
  Future<Map<String, MediaProgress>> build() async {
    try {
      final meApi = _getMeApiOrThrow();
      final userResponse = await meApi.getUser();
      final user = userResponse.data;
      if (user == null) {
        throw Exception('User data is null, cannot fetch media progress.');
      }
      _listToMap(user.mediaProgress);
      state = AsyncData(_listToMap(user.mediaProgress));
      await _loadFromDb();
      return state.asData?.value ?? <String, MediaProgress>{};
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      await _loadFromDb();
      state = AsyncError<Map<String, MediaProgress>>(e, s);
    }
    return state.asData?.value ?? <String, MediaProgress>{};
  }

  Future<void> refreshAllProgress() async {
    state = const AsyncLoading<Map<String, MediaProgress>>();
    try {
      final meApi = _getMeApiOrThrow();
      final userResponse = await meApi.getUser();
      final user = userResponse.data;
      if (user == null) {
        throw Exception('User data is null during refresh all progress.');
      }
      state = AsyncData(_listToMap(user.mediaProgress));
      _loadFromDb();
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      state = AsyncError<Map<String, MediaProgress>>(e, s);
      _loadFromDb();
    }
  }

  Future<void> _loadFromDb() async {
    final db = ref.watch(appDatabaseProvider);
    try {
      final progressList = await db.getAllSyncs();
      final List<MediaProgress> mediaProgressList = progressList
          .map((e) => MediaProgress.fromJson(jsonDecode(e.mediaProgress)))
          .toList();
      final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
      final loadedMap = _listToMap(mediaProgressList);
      final Map<String, MediaProgress> mergedMap = {...currentMap, ...loadedMap};
      state = AsyncData(mergedMap);
    } catch (e, s) {
      logger('Error loading media progress from DB: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      state = AsyncError<Map<String, MediaProgress>>(e, s);
    }
  }

  Future<MediaProgress?> fetchOrRefreshIndividualProgress(String libraryItemId, {String? episodeId}) async {
    try {
      final meApi = _getMeApiOrThrow();
      final response = await meApi.getProgress(libraryItemId, episodeId: episodeId);
      final newProgress = response.data;
      final key = _progressKey(libraryItemId, episodeId);

      if ((newProgress?.lastUpdate ?? 0) < (state.asData?.value[key]?.lastUpdate ?? 0)) {
        logger(
          'Skipping update for $libraryItemId: new progress is older than existing progress.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.debug,
        );
        return state.asData?.value[key];
      }

      if (newProgress != null) {
        final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
        final Map<String, MediaProgress> updatedMap = {...currentMap, key: newProgress};
        state = AsyncData(updatedMap);
        return newProgress;
      } else {
        final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
        final Map<String, MediaProgress> updatedMap = {...currentMap};
        if (updatedMap.remove(key) != null) {
          state = AsyncData(updatedMap);
        }
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
        final Map<String, MediaProgress> updatedMap = {...currentMap};
        final key = _progressKey(libraryItemId, episodeId);
        if (updatedMap.remove(key) != null) {
          state = AsyncData(updatedMap);
        }
        return null;
      } else {
        logger(
          'DioException while fetching individual MediaProgress for $libraryItemId: $e\n${e.stackTrace}',
          tag: 'MediaProgressProvider',
          level: InfoLevel.error,
        );
        return null;
      }
    } catch (e, s) {
      logger(
        'Unexpected error fetching individual media progress for $libraryItemId: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      return null;
    }
  }

  Future<MediaProgress?> updateMediaProgress(String libraryItemId, double currentTime, PlaybackSession session) async {
    try {
      final Map<String, MediaProgress> currentMap = state.asData?.value ?? <String, MediaProgress>{};
      final key = _progressKey(libraryItemId, session.episodeId);

      MediaProgress? updatedProgress = currentMap[key];
      if (updatedProgress == null) {
        updatedProgress = session.toMediaProgress(updatedProgress, '', 0, 0);
        logger(
          'No existing media progress found for $libraryItemId. Creating.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.warning,
        );
      }
      final double duration = updatedProgress.duration <= 0 ? (session.duration ?? 0) : updatedProgress.duration;
      if (duration <= 0) {
        logger(
          'Invalid duration ($duration) for libraryItemId: $libraryItemId. Skipping update.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.error,
        );
        return null;
      }

      final double progress = (currentTime / duration).clamp(0.0, 1.0);

      updatedProgress = updatedProgress.copyWith(
        currentTime: currentTime,
        progress: progress,
        isFinished: progress >= 0.999,
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
      );
      final Map<String, MediaProgress> updatedMap = {...currentMap, key: updatedProgress};
      state = AsyncData(updatedMap);
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

    if ((progress.lastUpdate ?? 0) < (existingProgress?.lastUpdate ?? 0)) {
      logger(
        'Ignoring stale remote progress update for key $key.',
        tag: 'MediaProgressProvider',
        level: InfoLevel.debug,
      );
      return;
    }

    state = AsyncData({...currentMap, key: progress});
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
  }
}
