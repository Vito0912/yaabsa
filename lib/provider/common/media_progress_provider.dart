import 'package:buchshelfly/api/library_items/playback_session.dart';
import 'package:buchshelfly/api/me/media_progress.dart';
import 'package:buchshelfly/api/routes/me_api.dart';
import 'package:buchshelfly/provider/core/user_providers.dart';
import 'package:buchshelfly/util/logger.dart';
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
    return {for (var p in progressList) p.libraryItemId: p};
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
      return _listToMap(user.mediaProgress);
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      throw Exception('Failed to load initial media progress: $e');
    }
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
    } catch (e, s) {
      logger('Error refreshing all media progress: $e\n$s', tag: 'MediaProgressProvider', level: InfoLevel.error);
      state = AsyncError<Map<String, MediaProgress>>(e, s).copyWithPrevious(state);
    }
  }

  Future<MediaProgress?> fetchOrRefreshIndividualProgress(String libraryItemId) async {
    try {
      final meApi = _getMeApiOrThrow();
      final response = await meApi.getProgress(libraryItemId);
      final newProgress = response.data;

      if (newProgress != null) {
        final currentMap = state.valueOrNull ?? {};
        final updatedMap = {...currentMap, newProgress.libraryItemId: newProgress};
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

  Future<void> updateMediaProgress(String libraryItemId, double currentTime, PlaybackSession session) async {
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
        return;
      }

      updatedProgress = updatedProgress.copyWith(currentTime: currentTime, progress: progress);
      final updatedMap = {...currentMap, libraryItemId: updatedProgress};
      state = AsyncData(updatedMap);
    } catch (e, s) {
      logger(
        'Error updating media progress for $libraryItemId: $e\n$s',
        tag: 'MediaProgressProvider',
        level: InfoLevel.error,
      );
      state = AsyncError<Map<String, MediaProgress>>(e, s).copyWithPrevious(state);
    }
  }
}
