import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/util/item_formatters.dart';

class AdminLibraryStatsPreviewIcons extends StatelessWidget {
  const AdminLibraryStatsPreviewIcons({super.key, required this.stats, required this.isBookLibrary});

  final LibraryStats stats;
  final bool isBookLibrary;

  @override
  Widget build(BuildContext context) {
    final items = <_StatsMetric>[
      _StatsMetric(
        icon: Icons.library_books_outlined,
        value: _formatCount(stats.totalItems ?? 0),
        label: 'Items in Library',
      ),
      _StatsMetric(
        icon: Icons.show_chart_rounded,
        value: _formatRuntimeCompact(stats.totalDuration ?? 0),
        label: 'Overall Runtime',
      ),
      if (isBookLibrary)
        _StatsMetric(
          icon: Icons.person_outline_rounded,
          value: _formatCount(stats.totalAuthors ?? 0),
          label: 'Authors',
        ),
      _StatsMetric(
        icon: Icons.insert_drive_file_outlined,
        value: formatBytes(stats.totalSize ?? 0),
        label: 'Total Size',
      ),
      _StatsMetric(
        icon: Icons.audio_file_outlined,
        value: _formatCount(stats.numAudioTracks ?? 0),
        label: 'Audio Tracks',
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [for (final item in items) SizedBox(width: 180, child: _StatsMetricTile(metric: item))],
    );
  }
}

class _StatsMetric {
  const _StatsMetric({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;
}

class _StatsMetricTile extends StatelessWidget {
  const _StatsMetricTile({required this.metric});

  final _StatsMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(metric.icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    metric.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatRuntimeCompact(double seconds) {
  if (seconds <= 0) {
    return '0h';
  }

  final duration = Duration(seconds: seconds.round());
  if (duration.inDays > 0) {
    return '${duration.inDays}d';
  }

  if (duration.inHours > 0) {
    return '${duration.inHours}h';
  }

  final minutes = duration.inMinutes;
  if (minutes > 0) {
    return '${minutes}m';
  }

  return '${duration.inSeconds}s';
}

String _formatCount(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index++) {
    final remaining = text.length - index;
    buffer.write(text[index]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
