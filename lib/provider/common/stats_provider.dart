import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:collection';

import 'package:flutter/foundation.dart' show compute;

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yaabsa/api/library/stats/listening_sessions_page.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/api/library/stats/year_in_review_stats.dart';
import 'package:yaabsa/api/library_items/playback_session.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/models/advanced_listening_analytics_state.dart';
import 'package:yaabsa/models/advanced_loading_progress_info.dart';
import 'package:yaabsa/models/advanced_listening_stats.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/util/logger.dart';

part 'stats_provider.g.dart';
part 'stats_calculation.dart';
part 'stats_session_summary.dart';

const int _advancedSessionsPageSize = 100;

const List<String> _weekdayLabels = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

@riverpod
Future<UserListeningStats> listeningStats(Ref ref) async {
  final api = ref.watch(absApiProvider);
  final currentUser = ref.watch(currentUserProvider).value;

  if (api == null || currentUser == null) {
    return const UserListeningStats();
  }

  try {
    final response = await api.getMeApi().getMeListeningStats();
    return response.data ?? const UserListeningStats();
  } on DioException catch (error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 404 || statusCode == 405) {
      logger(
        'Fallback to /api/users/:id/listening-stats due to unsupported /api/me/listening-stats endpoint.',
        tag: 'StatsProvider',
        level: InfoLevel.warning,
      );
      final fallbackResponse = await api.getMeApi().getListeningStats(currentUser.id);
      return fallbackResponse.data ?? const UserListeningStats();
    }
    rethrow;
  }
}

@riverpod
Future<YearInReviewStats?> yearInReviewStats(Ref ref, int year) async {
  final api = ref.watch(absApiProvider);
  if (api == null) {
    return null;
  }

  try {
    final response = await api.getMeApi().getMeStatsForYear(year);
    return response.data;
  } on DioException catch (error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 403 || statusCode == 404 || statusCode == 405) {
      logger(
        'Fallback to /api/stats/year/:year for year-in-review stats.',
        tag: 'StatsProvider',
        level: InfoLevel.warning,
      );
      final fallbackResponse = await api.getMeApi().getAdminStatsForYear(year);
      return fallbackResponse.data;
    }
    rethrow;
  }
}

@riverpod
Future<ListeningActivityStats> listeningActivityStats(Ref ref) async {
  final stats = await ref.watch(listeningStatsProvider.future);
  final dailyMap = stats.days;
  if (dailyMap == null || dailyMap.isEmpty) {
    return const ListeningActivityStats.empty();
  }

  final dayTotals = <int, double>{};
  for (final entry in dailyMap.entries) {
    final parsedDate = DateTime.tryParse(entry.key);
    if (parsedDate == null) {
      continue;
    }

    dayTotals[dayKeyFromDate(parsedDate)] = _safeListeningTime(entry.value);
  }

  return ListeningActivityStats(dailyListeningSeconds: dayTotals, loadedPages: 1, loadedSessions: dayTotals.length);
}

@Riverpod(keepAlive: true)
class AdvancedListeningAnalytics extends _$AdvancedListeningAnalytics {
  CancelToken? _loadToken;
  int _loadGeneration = 0;

  @override
  AdvancedListeningAnalyticsState build() {
    ref.watch(currentUserProvider.select((user) => user.value?.id));
    ref.onDispose(_cancelLoad);
    ref.onCancel(() {
      _cancelLoad();
      if (ref.mounted && state.isLoading) {
        state = AdvancedListeningAnalyticsState(stats: state.stats);
      }
    });
    return const AdvancedListeningAnalyticsState();
  }

  void _cancelLoad() {
    _loadGeneration++;
    _loadToken?.cancel('Analytics load canceled');
    _loadToken = null;
  }

  Future<void> load() async {
    if (state.isLoading) {
      return;
    }

    final api = ref.read(absApiProvider);
    final currentUser = ref.read(currentUserProvider).value;
    final previousStats = state.stats;

    if (api == null || currentUser == null) {
      state = AdvancedListeningAnalyticsState(
        stats: previousStats,
        errorMessage: 'User not authenticated or API not available.',
      );
      return;
    }

    state = AdvancedListeningAnalyticsState(
      isLoading: true,
      stats: previousStats,
      progress: const AdvancedLoadingProgressInfo(loadedPages: 0, loadedSessions: 0),
    );

    final generation = ++_loadGeneration;
    final cancelToken = CancelToken();
    _loadToken = cancelToken;
    final pages = _ListeningSessionPages(api: api, userId: currentUser.id, cancelToken: cancelToken);
    bool isCurrent() {
      return ref.mounted && generation == _loadGeneration && ref.read(currentUserProvider).value?.id == currentUser.id;
    }

    final sessions = <_AnalyticsSession>[];
    var loadedPages = 0;
    var totalAvailableSessions = 0;
    var page = 0;
    var numPages = 1;

    try {
      while (page < numPages && page < 10000) {
        final pageResponse = await pages.fetch(page: page, itemsPerPage: _advancedSessionsPageSize);
        if (!isCurrent()) {
          return;
        }

        final pageData = pageResponse.data ?? const ListeningSessionsPage();
        sessions.addAll(pageData.sessions.map(_AnalyticsSession.fromSession));
        loadedPages++;

        if (pageData.total != null) {
          totalAvailableSessions = pageData.total!;
        }

        if (pageData.numPages != null && pageData.numPages! > 0) {
          numPages = pageData.numPages!;
        } else if (totalAvailableSessions > 0) {
          numPages = (totalAvailableSessions / _advancedSessionsPageSize).ceil();
        } else {
          final hasMore = pageData.sessions.length == _advancedSessionsPageSize;
          numPages = hasMore ? page + 2 : page + 1;
        }

        state = AdvancedListeningAnalyticsState(
          isLoading: true,
          stats: previousStats,
          progress: AdvancedLoadingProgressInfo(
            loadedPages: loadedPages,
            loadedSessions: sessions.length,
            totalPages: numPages > 0 ? numPages : null,
            totalSessions: totalAvailableSessions > 0 ? totalAvailableSessions : null,
          ),
        );

        page++;
      }

      final resolvedTotalSessions = totalAvailableSessions > 0 ? totalAvailableSessions : sessions.length;
      final computed = await compute(_computeAdvancedStats, (
        sessions: sessions,
        loadedPages: loadedPages,
        totalAvailableSessions: resolvedTotalSessions,
      ));
      if (!isCurrent()) {
        return;
      }

      state = AdvancedListeningAnalyticsState(stats: computed);
    } catch (error) {
      if (!isCurrent() || (error is DioException && CancelToken.isCancel(error))) {
        return;
      }
      logger('Failed to compute advanced analytics: $error', tag: 'StatsProvider', level: InfoLevel.error);
      state = AdvancedListeningAnalyticsState(stats: previousStats, errorMessage: error.toString());
    }
  }

  void clear() {
    _cancelLoad();
    state = const AdvancedListeningAnalyticsState();
  }
}

class _ListeningSessionPages {
  _ListeningSessionPages({required this.api, required this.userId, required this.cancelToken});

  final ABSApi api;
  final String userId;
  final CancelToken cancelToken;
  bool _useUserEndpoint = false;

  Future<Response<ListeningSessionsPage>> fetch({required int page, required int itemsPerPage}) async {
    if (!_useUserEndpoint) {
      try {
        return await api.getMeApi().getMeListeningSessions(
          page: page,
          itemsPerPage: itemsPerPage,
          cancelToken: cancelToken,
        );
      } on DioException catch (error) {
        final statusCode = error.response?.statusCode;
        if (statusCode != 404 && statusCode != 405) {
          rethrow;
        }
        _useUserEndpoint = true;
      }
    }

    return api.getMeApi().getUserListeningSessions(
      userId,
      page: page,
      itemsPerPage: itemsPerPage,
      cancelToken: cancelToken,
    );
  }
}
