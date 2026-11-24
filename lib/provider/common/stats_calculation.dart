part of 'stats_provider.dart';

AdvancedListeningStats _computeAdvancedStats(
  ({List<_AnalyticsSession> sessions, int loadedPages, int totalAvailableSessions}) input,
) {
  return _calculateAdvancedListeningStats(
    sessions: input.sessions,
    loadedPages: input.loadedPages,
    totalAvailableSessions: input.totalAvailableSessions,
  );
}

AdvancedListeningStats _calculateAdvancedListeningStats({
  required List<_AnalyticsSession> sessions,
  required int loadedPages,
  required int totalAvailableSessions,
}) {
  if (sessions.isEmpty) {
    return _emptyAdvancedStats(loadedPages: loadedPages, totalAvailableSessions: totalAvailableSessions);
  }

  final listeningTimes = <double>[];

  final itemAggregates = <String, _ItemAggregate>{};
  final authorAggregates = <String, _EntityAggregate>{};

  final weekdayTotals = <String, double>{for (final label in _weekdayLabels) label: 0};
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
    final sessionListeningTime = session.listeningTime;
    listeningTimes.add(sessionListeningTime);
    totalListeningTime += sessionListeningTime;

    if (sessionListeningTime > longestSessionTime) {
      longestSessionTime = sessionListeningTime;
    }

    final mediaType = session.mediaType;
    if (mediaType == 'book') {
      totalBookListeningTime += sessionListeningTime;
    } else if (mediaType == 'podcast') {
      totalPodcastListeningTime += sessionListeningTime;
    }

    final itemId = session.itemId;
    final itemTitle = session.title;
    final itemAuthor = session.author;

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

    final authors = session.authors;
    for (final author in authors) {
      final normalized = author.name.trim();
      if (normalized.isEmpty) {
        continue;
      }

      final authorId = author.id?.trim();
      final key = authorId == null || authorId.isEmpty ? normalized.toLowerCase() : authorId;
      final authorAggregate = authorAggregates.putIfAbsent(key, () => _EntityAggregate(id: authorId, name: normalized));
      authorAggregate.totalListeningTime += sessionListeningTime;
      authorAggregate.sessions += 1;
    }

    final timestamp = session.timestamp;
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

    final weekdayLabel = _weekdayLabels[timestamp.weekday - 1];
    weekdayTotals[weekdayLabel] = (weekdayTotals[weekdayLabel] ?? 0) + sessionListeningTime;

    final hour = timestamp.hour;
    hourlyTotals[hour] = (hourlyTotals[hour] ?? 0) + sessionListeningTime;

    final monthLabel = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}';
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
              id: aggregate.id,
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

  final weekdayBreakdown = _weekdayLabels
      .map((label) => AdvancedTimeBucket(label: label, totalListeningTime: weekdayTotals[label] ?? 0))
      .toList(growable: false);

  final hourlyBreakdown = List<AdvancedTimeBucket>.generate(24, (hour) {
    final label = '${hour.toString().padLeft(2, '0')}:00';
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
  _EntityAggregate({required this.name, this.id});

  final String? id;
  final String name;
  double totalListeningTime = 0;
  int sessions = 0;
}

class _ResolvedAuthor {
  const _ResolvedAuthor({required this.name, this.id});

  final String? id;
  final String name;
}
