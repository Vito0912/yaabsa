import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      data: (activity) {
        final total7 = activity.totalForLastDays(7);
        final total30 = activity.totalForLastDays(30);
        final total365 = activity.totalForLastDays(365);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Listening Time Totals', style: Theme.of(context).textTheme.titleMedium),
            ),
            Row(
              children: [
                Expanded(
                  child: _TotalTile(label: 'Last 7d', value: formatListeningSeconds(total7)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TotalTile(label: 'Last 30d', value: formatListeningSeconds(total30)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TotalTile(label: 'Last 365d', value: formatListeningSeconds(total365)),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          onPressed: onRefresh,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Retry totals'),
        ),
      ),
    );
  }
}

class _TotalTile extends StatelessWidget {
  const _TotalTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.clip,
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Text(value, maxLines: 3, softWrap: true, overflow: TextOverflow.clip, style: theme.textTheme.titleSmall),
          ],
        ),
      ),
    );
  }
}
