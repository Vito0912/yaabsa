import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_heatmap.dart';
import 'package:yaabsa/features/statistics/widgets/stats_activity_range_chart.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class StatsActivitySection extends StatelessWidget {
  const StatsActivitySection({super.key, required this.activityAsync, required this.onRefresh});

  final AsyncValue<ListeningActivityStats> activityAsync;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return activityAsync.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: (activity) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatsActivityRangeChart(activity: activity),
            const SizedBox(height: 24),
            Text(context.l10n.headingListeningConsistency, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            StatsActivityHeatmap(activity: activity, days: 365),
          ],
        );
      },
      loading: () => const Center(child: YaabsaCircularProgressIndicator()),
      error: (error, _) => StatsMessage(
        title: context.l10n.statsActivityUnavailable,
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
