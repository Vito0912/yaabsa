import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yaabsa/util/logger.dart';

class LogEntryTile extends StatelessWidget {
  const LogEntryTile({super.key, required this.entry});

  final LogEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorForLevel(theme.colorScheme, entry.level);

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.22), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(8)),
              child: Icon(_iconForLevel(entry.level), size: 18, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.message, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _MetaChip(label: _formatTimestamp(context, entry.timestamp)),
                      _MetaChip(label: entry.level.name.toUpperCase()),
                      if (entry.tag != null && entry.tag!.trim().isNotEmpty) _MetaChip(label: entry.tag!.trim()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(BuildContext context, DateTime timestamp) {
    return DateFormat.yMd(Localizations.localeOf(context).toString()).add_Hms().format(timestamp);
  }

  IconData _iconForLevel(InfoLevel level) {
    switch (level) {
      case InfoLevel.debug:
        return Icons.bug_report_outlined;
      case InfoLevel.info:
        return Icons.info_outline;
      case InfoLevel.warning:
        return Icons.warning_amber_outlined;
      case InfoLevel.error:
        return Icons.error_outline;
    }
  }

  Color _colorForLevel(ColorScheme colorScheme, InfoLevel level) {
    switch (level) {
      case InfoLevel.debug:
        return colorScheme.secondary;
      case InfoLevel.info:
        return colorScheme.primary;
      case InfoLevel.warning:
        return const Color(0xFFB26A00);
      case InfoLevel.error:
        return colorScheme.error;
    }
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
    );
  }
}
