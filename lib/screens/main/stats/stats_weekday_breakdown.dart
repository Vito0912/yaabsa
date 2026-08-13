import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/stats/days_of_week.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class StatsWeekdayBreakdown extends StatelessWidget {
  const StatsWeekdayBreakdown({super.key, required this.dayOfWeek});

  final DaysOfWeek? dayOfWeek;

  @override
  Widget build(BuildContext context) {
    final entries = [
      StatsRankedEntry(
        label: 'Monday',
        value: dayOfWeek?.monday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.monday),
      ),
      StatsRankedEntry(
        label: 'Tuesday',
        value: dayOfWeek?.tuesday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.tuesday),
      ),
      StatsRankedEntry(
        label: 'Wednesday',
        value: dayOfWeek?.wednesday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.wednesday),
      ),
      StatsRankedEntry(
        label: 'Thursday',
        value: dayOfWeek?.thursday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.thursday),
      ),
      StatsRankedEntry(
        label: 'Friday',
        value: dayOfWeek?.friday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.friday),
      ),
      StatsRankedEntry(
        label: 'Saturday',
        value: dayOfWeek?.saturday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.saturday),
      ),
      StatsRankedEntry(
        label: 'Sunday',
        value: dayOfWeek?.sunday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.sunday),
      ),
    ];

    if (entries.every((entry) => entry.value <= 0)) {
      return Text('No weekday listening data available.', style: Theme.of(context).textTheme.bodyMedium);
    }

    return StatsRankedList(entries: entries, previewCount: 7);
  }
}
