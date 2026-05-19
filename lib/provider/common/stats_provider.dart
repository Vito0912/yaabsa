import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
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

const int _advancedSessionsPageSize = 100;

List<String> _weekdayLabels() {
  final locale = Intl.getCurrentLocale();
  return List<String>.generate(7, (index) {
    final day = DateTime.utc(2024, 1, 1 + index);
    return DateFormat.EEEE(locale).format(day);
  }, growable: false);
}

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
  @override
  AdvancedListeningAnalyticsState build() => const AdvancedListeningAnalyticsState();

  Future<void> load() async {
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

    final sessions = <PlaybackSession>[];
    var loadedPages = 0;
    var totalAvailableSessions = 0;
    var page = 0;
    var numPages = 1;

    try {
      while (page < numPages && page < 10000) {
        final pageResponse = await _getListeningSessionsPage(
          api: api,
          userId: currentUser.id,
          page: page,
          itemsPerPage: _advancedSessionsPageSize,
        );

        final pageData = pageResponse.data ?? const ListeningSessionsPage();
        sessions.addAll(pageData.sessions);
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
      final computed = _calculateAdvancedListeningStats(
        sessions: sessions,
        loadedPages: loadedPages,
        totalAvailableSessions: resolvedTotalSessions,
      );

      state = AdvancedListeningAnalyticsState(stats: computed);
    } catch (error) {
      logger('Failed to compute advanced analytics: $error', tag: 'StatsProvider', level: InfoLevel.error);
      state = AdvancedListeningAnalyticsState(stats: previousStats, errorMessage: error.toString());
    }
  }

  void clear() {
    state = const AdvancedListeningAnalyticsState();
  }
}

Future<Response<ListeningSessionsPage>> _getListeningSessionsPage({
  required ABSApi api,
  required String userId,
  required int page,
  required int itemsPerPage,
}) async {
  try {
    return await api.getMeApi().getMeListeningSessions(page: page, itemsPerPage: itemsPerPage);
  } on DioException catch (error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == 404 || statusCode == 405) {
      logger(
        'Fallback to /api/users/:id/listening-sessions for advanced stats pagination.',
        tag: 'StatsProvider',
        level: InfoLevel.warning,
      );
      return api.getMeApi().getUserListeningSessions(userId, page: page, itemsPerPage: itemsPerPage);
    }
    rethrow;
  }
}

AdvancedListeningStats _calculateAdvancedListeningStats({
  required List<PlaybackSession> sessions,
  required int loadedPages,
  required int totalAvailableSessions,
}) {
  if (sessions.isEmpty) {
    return _emptyAdvancedStats(loadedPages: loadedPages, totalAvailableSessions: totalAvailableSessions);
  }

  final listeningTimes = <double>[];

  final itemAggregates = <String, _ItemAggregate>{};
  final authorAggregates = <String, _EntityAggregate>{};
  final weekdayLabels = _weekdayLabels();

  final weekdayTotals = <String, double>{for (final label in weekdayLabels) label: 0};
  final hourlyTotals = <int, double>{for (var hour = 0; hour < 24; hour++) hour: 0};
  final monthlyTotals = SplayTreeMap<String, double>();

  final sessionDays = <int>{};

  var totalListeningTime = 0.0;
  var totalBookListeningTime = 0.0;
  var totalPodcastListeningTime = 0.0;
  var longestSessionTime = 0.0;

  int? firstSessionAt;
  int? lastSessionAt;

  for (final session in sessions) {
    final sessionListeningTime = _safeListeningTime(session.timeListening);
    listeningTimes.add(sessionListeningTime);
    totalListeningTime += sessionListeningTime;

    if (sessionListeningTime > longestSessionTime) {
      longestSessionTime = sessionListeningTime;
    }

    final mediaType = _resolveMediaType(session);
    if (mediaType == 'book') {
      totalBookListeningTime += sessionListeningTime;
    } else if (mediaType == 'podcast') {
      totalPodcastListeningTime += sessionListeningTime;
    }

    final itemId = (session.libraryItemId).trim().isNotEmpty ? session.libraryItemId : session.id;
    final itemTitle = _resolveItemTitle(session);
    final itemAuthor = _resolveItemAuthor(session);

    final itemAggregate = itemAggregates.putIfAbsent(
      itemId,
      () => _ItemAggregate(id: itemId, title: itemTitle, author: itemAuthor, mediaType: mediaType),
    );
    itemAggregate.totalListeningTime += sessionListeningTime;
    itemAggregate.sessions += 1;
    if (itemAggregate.title == _ItemAggregate.unknownTitle && itemTitle != _ItemAggregate.unknownTitle) {
      itemAggregate.title = itemTitle;
    }
    if (itemAggregate.author == _ItemAggregate.unknownAuthor && itemAuthor != _ItemAggregate.unknownAuthor) {
      itemAggregate.author = itemAuthor;
    }

    final authors = _resolveAuthors(session);
    for (final authorName in authors) {
      final normalized = authorName.trim();
      if (normalized.isEmpty) {
        continue;
      }

      final key = normalized.toLowerCase();
      final authorAggregate = authorAggregates.putIfAbsent(key, () => _EntityAggregate(name: normalized));
      authorAggregate.totalListeningTime += sessionListeningTime;
      authorAggregate.sessions += 1;
    }

    final timestamp = _resolveSessionTimestamp(session);
    if (timestamp == null) {
      continue;
    }

    final millis = timestamp.millisecondsSinceEpoch;
    firstSessionAt = firstSessionAt == null || millis < firstSessionAt ? millis : firstSessionAt;
    lastSessionAt = lastSessionAt == null || millis > lastSessionAt ? millis : lastSessionAt;

    final dayEpoch =
        DateTime.utc(timestamp.year, timestamp.month, timestamp.day).millisecondsSinceEpoch ~/
        Duration.millisecondsPerDay;
    sessionDays.add(dayEpoch);

    final weekdayLabel = weekdayLabels[timestamp.weekday - 1];
    weekdayTotals[weekdayLabel] = (weekdayTotals[weekdayLabel] ?? 0) + sessionListeningTime;

    final hour = timestamp.hour;
    hourlyTotals[hour] = (hourlyTotals[hour] ?? 0) + sessionListeningTime;

    final monthLabel = timestamp.toIso8601String().substring(0, 7);
    monthlyTotals[monthLabel] = (monthlyTotals[monthLabel] ?? 0) + sessionListeningTime;
  }

  final sortedListeningTimes = List<double>.from(listeningTimes)..sort();
  final medianSessionTime = _median(sortedListeningTimes);
  final averageSessionTime = sessions.isEmpty ? 0.0 : totalListeningTime / sessions.length;

  final topItems =
      itemAggregates.values
          .map(
            (aggregate) => AdvancedTopItem(
              id: aggregate.id,
              title: aggregate.title,
              author: aggregate.author,
              mediaType: aggregate.mediaType,
              totalListeningTime: aggregate.totalListeningTime,
              sessions: aggregate.sessions,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) {
          final byTime = b.totalListeningTime.compareTo(a.totalListeningTime);
          if (byTime != 0) {
            return byTime;
          }
          return b.sessions.compareTo(a.sessions);
        });

  final topAuthors =
      authorAggregates.values
          .map(
            (aggregate) => AdvancedTopEntity(
              name: aggregate.name,
              totalListeningTime: aggregate.totalListeningTime,
              sessions: aggregate.sessions,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) {
          final byTime = b.totalListeningTime.compareTo(a.totalListeningTime);
          if (byTime != 0) {
            return byTime;
          }
          return b.sessions.compareTo(a.sessions);
        });

  final weekdayBreakdown = weekdayLabels
      .map((label) => AdvancedTimeBucket(label: label, totalListeningTime: weekdayTotals[label] ?? 0))
      .toList(growable: false);

  final hourlyBreakdown = List<AdvancedTimeBucket>.generate(24, (hour) {
    final label = DateFormat.jm(Intl.getCurrentLocale()).format(DateTime(2024, 1, 1, hour));
    return AdvancedTimeBucket(label: label, totalListeningTime: hourlyTotals[hour] ?? 0);
  });

  final monthlyBreakdown = monthlyTotals.entries
      .map((entry) => AdvancedTimeBucket(label: entry.key, totalListeningTime: entry.value))
      .toList(growable: false);

  final favoriteWeekday = _favoriteWeekday(weekdayTotals);
  final favoriteHour = _favoriteHour(hourlyTotals);

  return AdvancedListeningStats(
    loadedPages: loadedPages,
    totalSessions: sessions.length,
    totalAvailableSessions: totalAvailableSessions,
    totalListeningTime: totalListeningTime,
    totalBookListeningTime: totalBookListeningTime,
    totalPodcastListeningTime: totalPodcastListeningTime,
    averageSessionTime: averageSessionTime,
    medianSessionTime: medianSessionTime,
    longestSessionTime: longestSessionTime,
    uniqueItems: itemAggregates.length,
    uniqueAuthors: authorAggregates.length,
    longestStreakDays: _calculateLongestStreak(sessionDays),
    firstSessionAt: firstSessionAt,
    lastSessionAt: lastSessionAt,
    favoriteWeekday: favoriteWeekday,
    favoriteHour: favoriteHour,
    topItems: topItems.take(10).toList(growable: false),
    topAuthors: topAuthors.take(10).toList(growable: false),
    weekdayBreakdown: weekdayBreakdown,
    hourlyBreakdown: hourlyBreakdown,
    monthlyBreakdown: monthlyBreakdown,
  );
}

AdvancedListeningStats _emptyAdvancedStats({required int loadedPages, required int totalAvailableSessions}) {
  return AdvancedListeningStats(
    loadedPages: loadedPages,
    totalSessions: 0,
    totalAvailableSessions: totalAvailableSessions,
    totalListeningTime: 0,
    totalBookListeningTime: 0,
    totalPodcastListeningTime: 0,
    averageSessionTime: 0,
    medianSessionTime: 0,
    longestSessionTime: 0,
    uniqueItems: 0,
    uniqueAuthors: 0,
    longestStreakDays: 0,
    firstSessionAt: null,
    lastSessionAt: null,
    favoriteWeekday: null,
    favoriteHour: null,
  );
}

String? _favoriteWeekday(Map<String, double> weekdayTotals) {
  String? favorite;
  var best = 0.0;
  for (final entry in weekdayTotals.entries) {
    if (entry.value > best) {
      favorite = entry.key;
      best = entry.value;
    }
  }
  return favorite;
}

int? _favoriteHour(Map<int, double> hourlyTotals) {
  int? favorite;
  var best = 0.0;
  for (final entry in hourlyTotals.entries) {
    if (entry.value > best) {
      favorite = entry.key;
      best = entry.value;
    }
  }
  return favorite;
}

DateTime? _resolveSessionTimestamp(PlaybackSession session) {
  if (session.startedAt != null && session.startedAt! > 0) {
    return DateTime.fromMillisecondsSinceEpoch(session.startedAt!);
  }

  if (session.updatedAt != null && session.updatedAt! > 0) {
    return DateTime.fromMillisecondsSinceEpoch(session.updatedAt!);
  }

  final dateString = session.date;
  if (dateString != null && dateString.isNotEmpty) {
    return DateTime.tryParse(dateString);
  }

  return null;
}

String _resolveMediaType(PlaybackSession session) {
  final mediaType = session.mediaType?.trim().toLowerCase();
  if (mediaType == 'book') {
    return 'book';
  }

  if (mediaType == 'podcast') {
    return 'podcast';
  }

  return session.episodeId == null ? 'book' : 'podcast';
}

String _resolveItemTitle(PlaybackSession session) {
  final displayTitle = session.displayTitle?.trim();
  if (displayTitle != null && displayTitle.isNotEmpty) {
    return displayTitle;
  }

  final metadata = session.mediaMetadata;
  final bookTitle = metadata?.bookMetadata?.title.trim();
  if (bookTitle != null && bookTitle.isNotEmpty) {
    return bookTitle;
  }

  final podcastTitle = metadata?.podcastMetadata?.title?.trim();
  if (podcastTitle != null && podcastTitle.isNotEmpty) {
    return podcastTitle;
  }

  return _ItemAggregate.unknownTitle;
}

String _resolveItemAuthor(PlaybackSession session) {
  final displayAuthor = session.displayAuthor?.trim();
  if (displayAuthor != null && displayAuthor.isNotEmpty) {
    return displayAuthor;
  }

  final metadata = session.mediaMetadata;
  final bookAuthors = metadata?.bookMetadata?.authors;
  if (bookAuthors != null && bookAuthors.isNotEmpty) {
    final joined = bookAuthors.map((author) => author.name.trim()).where((name) => name.isNotEmpty).join(', ');
    if (joined.isNotEmpty) {
      return joined;
    }
  }

  final podcastAuthor = metadata?.podcastMetadata?.author?.trim();
  if (podcastAuthor != null && podcastAuthor.isNotEmpty) {
    return podcastAuthor;
  }

  return _ItemAggregate.unknownAuthor;
}

List<String> _resolveAuthors(PlaybackSession session) {
  final metadata = session.mediaMetadata;

  final authors = <String>[];

  final bookAuthors = metadata?.bookMetadata?.authors;
  if (bookAuthors != null) {
    for (final author in bookAuthors) {
      final name = author.name.trim();
      if (name.isNotEmpty) {
        authors.add(name);
      }
    }
  }

  final podcastAuthor = metadata?.podcastMetadata?.author?.trim();
  if (podcastAuthor != null && podcastAuthor.isNotEmpty) {
    authors.add(podcastAuthor);
  }

  if (authors.isNotEmpty) {
    return authors;
  }

  final displayAuthor = session.displayAuthor?.trim();
  if (displayAuthor != null && displayAuthor.isNotEmpty) {
    return displayAuthor.split(',').map((entry) => entry.trim()).where((entry) => entry.isNotEmpty).toList();
  }

  return const <String>[];
}

int _calculateLongestStreak(Set<int> dayEpochs) {
  if (dayEpochs.isEmpty) {
    return 0;
  }

  final sortedDays = dayEpochs.toList()..sort();

  var longest = 1;
  var current = 1;

  for (var i = 1; i < sortedDays.length; i++) {
    if (sortedDays[i] == sortedDays[i - 1] + 1) {
      current += 1;
      if (current > longest) {
        longest = current;
      }
    } else {
      current = 1;
    }
  }

  return longest;
}

double _safeListeningTime(double? value) {
  if (value == null || value.isNaN || value.isInfinite || value < 0) {
    return 0;
  }
  return value;
}

double _median(List<double> sortedValues) {
  if (sortedValues.isEmpty) {
    return 0;
  }

  final middle = sortedValues.length ~/ 2;
  if (sortedValues.length.isOdd) {
    return sortedValues[middle];
  }

  return (sortedValues[middle - 1] + sortedValues[middle]) / 2;
}

class _ItemAggregate {
  static const String unknownTitle = 'Unknown Item';
  static const String unknownAuthor = 'Unknown Author';

  _ItemAggregate({required this.id, required this.title, required this.author, required this.mediaType});

  final String id;
  String title;
  String author;
  final String mediaType;
  double totalListeningTime = 0;
  int sessions = 0;
}

class _EntityAggregate {
  _EntityAggregate({required this.name});

  final String name;
  double totalListeningTime = 0;
  int sessions = 0;
}
