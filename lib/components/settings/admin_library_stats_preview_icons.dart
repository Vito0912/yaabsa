import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/api/library/stats/library_stats.dart';
import 'package:yaabsa/features/statistics/widgets/statistics_components.dart';
import 'package:yaabsa/util/item_formatters.dart';
import 'package:yaabsa/util/l10n.dart';

class AdminLibraryStatsPreviewIcons extends StatelessWidget {
  const AdminLibraryStatsPreviewIcons({super.key, required this.stats, required this.isBookLibrary});

  final LibraryStats stats;
  final bool isBookLibrary;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return StatsMetricGrid(
      minimumTileWidth: 150,
      metrics: [
        StatsMetric(
          icon: Icons.library_books_rounded,
          value: _formatCount(stats.totalItems ?? 0, l10n.localeName),
          label: l10n.libraryItems,
          emphasized: true,
        ),
        StatsMetric(
          icon: Icons.schedule_rounded,
          value: _formatRuntimeCompact(stats.totalDuration ?? 0, l10n),
          label: l10n.statsOverallRuntime,
          emphasized: true,
        ),
        if (isBookLibrary)
          StatsMetric(
            icon: Icons.people_alt_rounded,
            value: _formatCount(stats.totalAuthors ?? 0, l10n.localeName),
            label: l10n.fieldAuthors,
          ),
        StatsMetric(
          icon: Icons.sell_rounded,
          value: _formatCount(stats.totalGenres ?? 0, l10n.localeName),
          label: l10n.fieldGenres,
        ),
        StatsMetric(
          icon: Icons.storage_rounded,
          value: formatBytes(stats.totalSize ?? 0, localizations: l10n),
          label: l10n.statsTotalSize,
        ),
        StatsMetric(
          icon: Icons.audio_file_rounded,
          value: _formatCount(stats.numAudioTracks ?? 0, l10n.localeName),
          label: l10n.fieldAudioTracks,
        ),
      ],
    );
  }
}

String _formatRuntimeCompact(double seconds, AppLocalizations l10n) {
  if (seconds <= 0) {
    return l10n.durationCompactHours(0);
  }

  final duration = Duration(seconds: seconds.round());

  if (duration.inDays > 0) {
    return l10n.durationCompactDaysHours(duration.inDays, duration.inHours.remainder(24));
  }
  if (duration.inHours > 0) {
    return l10n.durationCompactHours(duration.inHours);
  }
  if (duration.inMinutes > 0) {
    return l10n.durationCompactMinutes(duration.inMinutes);
  }

  return l10n.durationCompactSeconds(duration.inSeconds);
}

String _formatCount(int value, String localeName) => NumberFormat.decimalPattern(localeName).format(value);
