import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/widgets/log_entry_tile.dart';
import 'package:yaabsa/util/log_exporter.dart';
import 'package:yaabsa/util/logger.dart';

import 'package:yaabsa/generated/l10n.dart';

class LogView extends HookWidget {
  const LogView({super.key});

  void _copyRawLogs(BuildContext context, List<LogEntry> logs) {
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.current.screensSettingsLogViewNoLogsToCopy)));
      return;
    }

    final rawLogs = formatLogsForExport(logs);
    Clipboard.setData(ClipboardData(text: rawLogs));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsLogViewRawLogsCopiedToClipboard)));
  }

  void _copyGitHubLogs(BuildContext context, List<LogEntry> logs) {
    final buffer = StringBuffer();
    buffer.writeln('<details>');
    buffer.writeln(S.current.settingsLogViewSummaryLogs(logs.length));
    buffer.writeln('');
    buffer.writeln('```text');
    if (logs.isNotEmpty) {
      buffer.write(logs.map(formatLogEntryForExport).join('\n'));
    }
    buffer.writeln('');
    buffer.writeln('```');
    buffer.writeln('');
    buffer.writeln('</details>');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsLogViewGithubFormattedLogsCopiedToClipboard)));
  }

  Future<void> _exportLogs(BuildContext context, List<LogEntry> logs) async {
    if (logs.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsLogViewNoLogsToExport)));
      return;
    }

    try {
      final exportResult = await exportLogsAsLogFile(logs);

      if (!context.mounted) {
        return;
      }

      final destinationDescription = exportResult.usedSaveDialog
          ? S.current.settingsLogViewSelectedLocation
          : S.current.settingsLogViewAppStorageFallbackLocation;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            S.current.screensSettingsLogViewLogsExportedToLogFile(destinationDescription, exportResult.filePath),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          duration: const Duration(seconds: 6),
        ),
      );
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.current.screensSettingsLogViewFailedToExportLogs(error))));
    }
  }

  void _scrollToTop(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    }
  }

  void _scrollToBottom(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildEmptyState(BuildContext context, {required bool isLoading}) {
    final theme = Theme.of(context);
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(height: 10),
            Text(
              S.current.screensSettingsLogViewLoadingLogs,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.article_outlined, size: 44, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
          const SizedBox(height: 10),
          Text(S.current.screensSettingsLogViewNoLogsYet, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            S.current.screensSettingsLogViewLogsWillAppearHereAsThey,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final streamSnapshot = useStream(appLoggerService.logStream);
    final logs = appLoggerService.logHistory;
    final scrollController = useScrollController();
    final autoScrollEnabled = useState(true);
    final isExporting = useState(false);
    final screenSize = MediaQuery.sizeOf(context);
    final horizontalPadding = screenSize.width < 420 ? 8.0 : 12.0;
    final listHeight = (screenSize.height * 0.72).clamp(240.0, 1200.0);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    useEffect(() {
      if (logs.isNotEmpty && scrollController.hasClients && autoScrollEnabled.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            _scrollToBottom(scrollController);
          }
        });
      }
      return null;
    }, [logs.length, autoScrollEnabled.value]);

    return SettingsPageScaffold(
      title: S.current.settingsLogViewTitle,
      maxWidth: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 0),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: () => _copyRawLogs(context, logs),
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        label: Text(S.current.screensSettingsLogViewCopyRaw),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _copyGitHubLogs(context, logs),
                        icon: const Icon(Icons.code_outlined, size: 18),
                        label: Text(S.current.screensSettingsLogViewCopyGitHub),
                      ),
                      OutlinedButton.icon(
                        onPressed: isExporting.value
                            ? null
                            : () async {
                                isExporting.value = true;
                                await _exportLogs(context, logs);
                                if (context.mounted) {
                                  isExporting.value = false;
                                }
                              },
                        icon: isExporting.value
                            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.save_alt_outlined, size: 18),
                        label: Text(
                          isExporting.value
                              ? S.current.settingsLogViewExportingLog
                              : S.current.settingsLogViewExportLog,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHigh,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          S.current.settingsLogViewEntriesCount(logs.length),
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: S.current.screensSettingsLogViewScrollToTop,
                        onPressed: logs.isEmpty ? null : () => _scrollToTop(scrollController),
                        icon: const Icon(Icons.vertical_align_top_rounded),
                      ),
                      IconButton(
                        tooltip: S.current.screensSettingsLogViewScrollToBottom,
                        onPressed: logs.isEmpty ? null : () => _scrollToBottom(scrollController),
                        icon: const Icon(Icons.vertical_align_bottom_rounded),
                      ),
                      const SizedBox(width: 4),
                      Text(S.current.screensSettingsLogViewAutoScroll, style: theme.textTheme.bodySmall),
                      Switch.adaptive(
                        value: autoScrollEnabled.value,
                        onChanged: (value) => autoScrollEnabled.value = value,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(horizontalPadding, 12, horizontalPadding, 0),
          child: Container(
            height: listHeight,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
            ),
            child: logs.isEmpty
                ? _buildEmptyState(context, isLoading: streamSnapshot.connectionState == ConnectionState.waiting)
                : Scrollbar(
                    controller: scrollController,
                    thumbVisibility: true,
                    child: ListView.separated(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: logs.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return LogEntryTile(entry: log);
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
