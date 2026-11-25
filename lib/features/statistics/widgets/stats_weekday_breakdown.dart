import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/api/library/stats/days_of_week.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/util/l10n.dart';

class StatsWeekdayBreakdown extends StatelessWidget {
  const StatsWeekdayBreakdown({super.key, required this.dayOfWeek});

  final DaysOfWeek? dayOfWeek;

  @override
  Widget build(BuildContext context) {
    final entries = [
      StatsRankedEntry(
        label: context.l10n.weekdayMonday,
        value: dayOfWeek?.monday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.monday),
      ),
      StatsRankedEntry(
        label: context.l10n.weekdayTuesday,
        value: dayOfWeek?.tuesday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.tuesday),
      ),
      StatsRankedEntry(
        label: context.l10n.weekdayWednesday,
        value: dayOfWeek?.wednesday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.wednesday),
      ),
      StatsRankedEntry(
        label: context.l10n.weekdayThursday,
        value: dayOfWeek?.thursday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.thursday),
      ),
      StatsRankedEntry(
        label: context.l10n.weekdayFriday,
        value: dayOfWeek?.friday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.friday),
      ),
      StatsRankedEntry(
        label: context.l10n.weekdaySaturday,
        value: dayOfWeek?.saturday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.saturday),
      ),
      StatsRankedEntry(
        label: context.l10n.weekdaySunday,
        value: dayOfWeek?.sunday ?? 0,
        trailing: formatListeningSeconds(dayOfWeek?.sunday),
      ),
    ];

    if (entries.every((entry) => entry.value <= 0)) {
      return Text(context.l10n.statsNoWeekdayData, style: Theme.of(context).textTheme.bodyMedium);
    }

    return StatsRankedList(entries: entries, previewCount: 7);
  }
}
