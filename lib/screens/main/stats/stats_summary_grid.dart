import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/stats/items_listened_to.dart';
import 'package:yaabsa/api/library/stats/user_listening_stats.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class StatsSummaryGrid extends StatelessWidget {
  const StatsSummaryGrid({super.key, required this.stats});

  final UserListeningStats stats;

  @override
  Widget build(BuildContext context) {
    final items = stats.items?.values.toList(growable: false) ?? const <ItemsListenedTo>[];
    final totalTime = stats.totalTime ?? 0;
    var bookListening = 0.0;
    var podcastListening = 0.0;
    var activeDays = 0;

    for (final item in items) {
      final time = item.timeListening ?? 0;
      if (item.mediaMetadata?.podcastMetadata != null) {
        podcastListening += time;
      } else {
        bookListening += time;
      }
    }

    for (final value in stats.days?.values ?? const <double>[]) {
      if (value > 0) activeDays++;
    }

    final listeningStreak = _currentListeningStreak(stats.days);
    final averagePerActiveDay = activeDays > 0 ? totalTime / activeDays : 0.0;

    return StatsMetricGrid(
      minimumTileWidth: 148,
      metrics: [
        StatsMetric(
          icon: Icons.headphones_rounded,
          label: 'Total listening',
          value: formatListeningSeconds(totalTime),
          emphasized: true,
        ),
        StatsMetric(
          icon: Icons.today_rounded,
          label: 'Today',
          value: formatListeningSeconds(stats.today),
          emphasized: true,
        ),
        StatsMetric(icon: Icons.library_books_rounded, label: 'Items listened', value: '${items.length}'),
        StatsMetric(icon: Icons.menu_book_rounded, label: 'Audiobooks', value: formatListeningSeconds(bookListening)),
        StatsMetric(icon: Icons.podcasts_rounded, label: 'Podcasts', value: formatListeningSeconds(podcastListening)),
        StatsMetric(icon: Icons.event_available_rounded, label: 'Active days', value: '$activeDays'),
        StatsMetric(
          icon: Icons.local_fire_department_rounded,
          label: 'Listening streak',
          value: '$listeningStreak days',
        ),
        StatsMetric(
          icon: Icons.av_timer_rounded,
          label: 'Average active day',
          value: formatListeningSeconds(averagePerActiveDay),
        ),
      ],
    );
  }
}

int _currentListeningStreak(Map<String, double>? days, {DateTime? reference}) {
  if (days == null || days.isEmpty) {
    return 0;
  }

  final activeDayKeys = <int>{};
  for (final entry in days.entries) {
    if (entry.value <= 0) {
      continue;
    }

    final parsedDate = DateTime.tryParse(entry.key);
    if (parsedDate != null) {
      activeDayKeys.add(dayKeyFromDate(parsedDate));
    }
  }

  if (activeDayKeys.isEmpty) {
    return 0;
  }

  var streakDay = dayKeyFromDate(reference ?? DateTime.now());
  if (!activeDayKeys.contains(streakDay)) {
    streakDay -= 1;
    if (!activeDayKeys.contains(streakDay)) {
      return 0;
    }
  }

  var streak = 0;
  while (activeDayKeys.contains(streakDay)) {
    streak++;
    streakDay--;
  }

  return streak;
}
