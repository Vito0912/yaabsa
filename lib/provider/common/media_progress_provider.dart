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

@Riverpod(keepAlive: true)
class MediaProgressNotifier extends _$MediaProgressNotifier {
  MeApi _getMeApiOrThrow() {
    final absApi = ref.watch(absApiProvider);
    if (absApi == null) {
      throw Exception('User not authenticated or ABS API not available for MediaProgressNotifier.');
    }
    return absApi.getMeApi();
  }

  Map<String, MediaProgress> _listToMap(List<MediaProgress>? progressList) {
    if (progressList == null || progressList.isEmpty) {
      return {};
    }
    final Map<String, MediaProgress> result = {};
    for (var p in progressList) {
      final key = '${p.libraryItemId}${p.episodeId ?? ''}';
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
      return state.valueOrNull ?? {};
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      await _loadFromDb();
      state = AsyncError<Map<String, MediaProgress>>(e, s).copyWithPrevious(state);
    }
    return state.valueOrNull ?? {};
  }

  Future<void> refreshAllProgress() async {
    state = const AsyncLoading<Map<String, MediaProgress>>().copyWithPrevious(state);
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
      state = AsyncError<Map<String, MediaProgress>>(e, s).copyWithPrevious(state);
      _loadFromDb();
    }
  }

  Future<void> _loadFromDb() async {
    final db = ref.watch(appDatabaseProvider);
    try {
      final progressList = await db.getAllSyncs();
      final List<MediaProgress> mediaProgressList =
          progressList.map((e) => MediaProgress.fromJson(jsonDecode(e.mediaProgress))).toList();
      final currentMap = state.valueOrNull ?? {};
      final loadedMap = _listToMap(mediaProgressList);
      final mergedMap = {...currentMap, ...loadedMap};
      state = AsyncData(mergedMap);
    } catch (e, s) {
      logger('Error loading media progress from DB: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      state = AsyncError<Map<String, MediaProgress>>(e, s).copyWithPrevious(state);
    }
  }

  Future<MediaProgress?> fetchOrRefreshIndividualProgress(String libraryItemId, {String? episodeId}) async {
    try {
      final meApi = _getMeApiOrThrow();
      final response = await meApi.getProgress(libraryItemId, episodeId: episodeId);
      final newProgress = response.data;
      final String key = '$libraryItemId${episodeId ?? ''}';

      if ((newProgress?.lastUpdate ?? 0) < (state.valueOrNull?[key]?.lastUpdate ?? 0)) {
        logger(
          'Skipping update for $libraryItemId: new progress is older than existing progress.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.debug,
        );
        return state.valueOrNull?[key];
      }

      if (newProgress != null) {
        final currentMap = state.valueOrNull ?? {};
        final updatedMap = {...currentMap, key: newProgress};
        state = AsyncData(updatedMap);
        return newProgress;
      } else {
        final currentMap = state.valueOrNull ?? {};
        final updatedMap = {...currentMap};
        if (updatedMap.remove(libraryItemId) != null) {
          state = AsyncData(updatedMap);
        }
        return null;
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        final currentMap = state.valueOrNull ?? {};
        final updatedMap = {...currentMap};
        if (updatedMap.remove(libraryItemId) != null) {
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
    state = const AsyncLoading<Map<String, MediaProgress>>().copyWithPrevious(state);
    try {
      final currentMap = state.valueOrNull ?? {};

      MediaProgress? updatedProgress = currentMap[libraryItemId];
      if (updatedProgress == null) {
        updatedProgress = session.toMediaProgress(updatedProgress, '', 0, 0);
        logger(
          'No existing media progress found for $libraryItemId. Creating.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.warning,
        );
      }
      final double duration = updatedProgress.duration <= 0 ? (session.duration ?? 0) : updatedProgress.duration;
      final double progress = currentTime / duration;

      if (progress < 0 || progress > 1) {
        logger(
          'Invalid progress value: $progress for libraryItemId: $libraryItemId. Skipping update.',
          tag: 'MediaProgressProvider',
          level: InfoLevel.error,
        );
        return null;
      }

      updatedProgress = updatedProgress.copyWith(
        currentTime: currentTime,
        progress: progress,
        lastUpdate: DateTime.now().millisecondsSinceEpoch,
      );
      final updatedMap = {...currentMap, libraryItemId: updatedProgress};
      state = AsyncData(updatedMap);
      return updatedProgress;
    } catch (e, s) {
      logger(
        'Error updating media progress for $libraryItemId: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      state = AsyncError<Map<String, MediaProgress>>(e, s).copyWithPrevious(state);
    }
    return null;
  }
}
