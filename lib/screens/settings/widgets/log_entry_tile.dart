import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:yaabsa/util/l10n.dart';
import 'package:yaabsa/util/log_exporter.dart';
import 'package:yaabsa/util/logger.dart';

class LogEntryTile extends StatelessWidget {
  const LogEntryTile({super.key, required this.entry});

  final LogEntry entry;

  void _copyEntry(BuildContext context) {
    final formatted = formatLogEntryForExport(entry);
    Clipboard.setData(ClipboardData(text: formatted));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.statusCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final levelColor = _colorForLevel(theme, entry.level);
    final trimmedTag = entry.tag?.trim();
    final hasTag = trimmedTag != null && trimmedTag.isNotEmpty;

    return InkWell(
      onTap: () {
        _copyEntry(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 3,
                decoration: BoxDecoration(color: levelColor, borderRadius: BorderRadius.circular(999)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatTime(entry.timestamp),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFamily: 'monospace',
                            fontFeatures: const [FontFeature.tabularFigures()],
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _shortLevelLabel(entry.level),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w700,
                            color: levelColor,
                          ),
                        ),
                        if (hasTag) ...[
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              trimmedTag,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontFamily: 'monospace',
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.message,
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour.toString().padLeft(2, '0');
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final second = timestamp.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String _shortLevelLabel(InfoLevel level) {
    switch (level) {
      case InfoLevel.debug:
        return 'DBG';
      case InfoLevel.info:
        return 'INFO';
      case InfoLevel.warning:
        return 'WARN';
      case InfoLevel.error:
        return 'ERR';
    }
  }

  Color _colorForLevel(ThemeData theme, InfoLevel level) {
    final colorScheme = theme.colorScheme;
    switch (level) {
      case InfoLevel.debug:
        return colorScheme.secondary;
      case InfoLevel.info:
        return colorScheme.primary;
      case InfoLevel.warning:
        return theme.brightness == Brightness.dark ? const Color(0xFFFFB74D) : const Color(0xFFB26A00);
      case InfoLevel.error:
        return colorScheme.error;
    }
  }
}
