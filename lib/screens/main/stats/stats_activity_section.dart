import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yaabsa/models/listening_activity_stats.dart';
import 'package:yaabsa/screens/main/stats/stats_activity_heatmap.dart';
import 'package:yaabsa/screens/main/stats/stats_activity_range_chart.dart';

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
            const SizedBox(height: 16),
            StatsActivityHeatmap(activity: activity, days: 365),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Failed to load listening activity.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 6),
          Text(
            error.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry Activity'),
          ),
        ],
      ),
    );
  }
}
