import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';

class StatsActivityTotalsCard extends StatelessWidget {
  const StatsActivityTotalsCard({super.key, required this.activityAsync, required this.onRefresh});

  final AsyncValue<ListeningActivityStats> activityAsync;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return activityAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (activity) => StatsMetricGrid(
        minimumTileWidth: 138,
        maximumColumns: 3,
        metrics: [
          StatsMetric(
            icon: Icons.date_range_rounded,
            label: 'Last 7 days',
            value: formatListeningSeconds(activity.totalForLastDays(7)),
          ),
          StatsMetric(
            icon: Icons.calendar_view_month_rounded,
            label: 'Last 30 days',
            value: formatListeningSeconds(activity.totalForLastDays(30)),
          ),
          StatsMetric(
            icon: Icons.calendar_today_rounded,
            label: 'Last 365 days',
            value: formatListeningSeconds(activity.totalForLastDays(365)),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry activity totals'),
        ),
      ),
    );
  }
}
