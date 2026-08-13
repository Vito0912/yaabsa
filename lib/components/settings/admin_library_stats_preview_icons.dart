import 'package:flutter/material.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/components/stats/stats_components.dart';
import 'package:yaabsa/util/item_formatters.dart';

class AdminLibraryStatsPreviewIcons extends StatelessWidget {
  const AdminLibraryStatsPreviewIcons({super.key, required this.stats, required this.isBookLibrary});

  final LibraryStats stats;
  final bool isBookLibrary;

  @override
  Widget build(BuildContext context) {
    return StatsMetricGrid(
      minimumTileWidth: 150,
      metrics: [
        StatsMetric(
          icon: Icons.library_books_rounded,
          value: _formatCount(stats.totalItems ?? 0),
          label: 'Items in library',
          emphasized: true,
        ),
        StatsMetric(
          icon: Icons.schedule_rounded,
          value: _formatRuntimeCompact(stats.totalDuration ?? 0),
          label: 'Overall runtime',
          emphasized: true,
        ),
        if (isBookLibrary)
          StatsMetric(icon: Icons.people_alt_rounded, value: _formatCount(stats.totalAuthors ?? 0), label: 'Authors'),
        StatsMetric(icon: Icons.sell_rounded, value: _formatCount(stats.totalGenres ?? 0), label: 'Genres'),
        StatsMetric(icon: Icons.storage_rounded, value: formatBytes(stats.totalSize ?? 0), label: 'Total size'),
        StatsMetric(
          icon: Icons.audio_file_rounded,
          value: _formatCount(stats.numAudioTracks ?? 0),
          label: 'Audio tracks',
        ),
      ],
    );
  }
}

String _formatRuntimeCompact(double seconds) {
  if (seconds <= 0) return '0h';
  final duration = Duration(seconds: seconds.round());
  if (duration.inDays > 0) return '${duration.inDays}d ${duration.inHours.remainder(24)}h';
  if (duration.inHours > 0) return '${duration.inHours}h';
  if (duration.inMinutes > 0) return '${duration.inMinutes}m';
  return '${duration.inSeconds}s';
}

String _formatCount(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < text.length; index++) {
    final remaining = text.length - index;
    buffer.write(text[index]);
    if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
