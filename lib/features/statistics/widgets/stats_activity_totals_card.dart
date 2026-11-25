import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_formatters.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

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
            label: context.l10n.statsLastDays(7),
            value: formatListeningSeconds(activity.totalForLastDays(7, reference: referenceDate)),
          ),
          StatsMetric(
            icon: Icons.calendar_view_month_rounded,
            label: context.l10n.statsLastDays(30),
            value: formatListeningSeconds(activity.totalForLastDays(30, reference: referenceDate)),
          ),
          StatsMetric(
            icon: Icons.calendar_today_rounded,
            label: context.l10n.statsLastDays(365),
            value: formatListeningSeconds(activity.totalForLastDays(365, reference: referenceDate)),
          ),
        ],
      ),
      loading: () => const Center(child: YaabsaCircularProgressIndicator()),
      error: (error, _) => StatsMessage(
        title: context.l10n.statsListeningUnavailable,
        message: error.toString(),
        messageMaxLines: 2,
        icon: Icons.cloud_off_rounded,
        action: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.l10n.actionRetry),
        ),
      ),
    );
  }
}
