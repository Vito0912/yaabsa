import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';

class StatsActivityTotalsCard extends StatelessWidget {
  const StatsActivityTotalsCard({super.key, required this.activityAsync, required this.onRefresh, this.referenceDate});

  final AsyncValue<ListeningActivityStats> activityAsync;
  final VoidCallback onRefresh;
  final DateTime? referenceDate;

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
            value: formatListeningSeconds(activity.totalForLastDays(7, reference: referenceDate)),
          ),
          StatsMetric(
            icon: Icons.calendar_view_month_rounded,
            label: 'Last 30 days',
            value: formatListeningSeconds(activity.totalForLastDays(30, reference: referenceDate)),
          ),
          StatsMetric(
            icon: Icons.calendar_today_rounded,
            label: 'Last 365 days',
            value: formatListeningSeconds(activity.totalForLastDays(365, reference: referenceDate)),
          ),
        ],
      ),
      loading: () => const Center(child: YaabsaCircularProgressIndicator()),
      error: (error, _) => StatsMessage(
        title: 'Listening totals unavailable',
        message: error.toString(),
        messageMaxLines: 2,
        icon: Icons.cloud_off_rounded,
        action: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry activity totals'),
        ),
      ),
    );
  }
}
