import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:yaabsa/screens/settings/settings_page_scaffold.dart';
import 'package:yaabsa/screens/settings/widgets/local_log_settings_section.dart';
import 'package:yaabsa/screens/settings/widgets/log_entry_tile.dart';
import 'package:yaabsa/util/log_exporter.dart';
import 'package:yaabsa/util/logger.dart';
import 'package:yaabsa/ui/components/feedback/progress_indicators.dart';
import 'package:yaabsa/util/l10n.dart';

class LogView extends HookWidget {
  const LogView({super.key});

  void _copyRawLogs(BuildContext context, List<LogEntry> logs) {
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.statusNoLogsAvailable)));
      return;
    }

    final rawLogs = formatLogsForExport(logs);
    Clipboard.setData(ClipboardData(text: rawLogs));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.statusLogsCopied)));
  }

  void _copyGitHubLogs(BuildContext context, List<LogEntry> logs) {
    final buffer = StringBuffer();
    buffer.writeln('<details>');
    buffer.writeln('<summary>${context.l10n.logExportSummary(logs.length)}</summary>');
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.statusLogsCopied)));
  }

  Future<void> _exportLogs(BuildContext context, List<LogEntry> logs) async {
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(context.l10n.statusNoLogsAvailable)));
      return;
    }

    try {
      final exportResult = await exportLogsAsLogFile(logs);

      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.l10n.statusLogsExportedToPath(exportResult.filePath),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.errorOperationFailed(context.l10n.operationExportLogs, error.toString()))),
      );
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
            const SizedBox(width: 28, height: 28, child: YaabsaCircularProgressIndicator(strokeWidth: 2.5)),
            const SizedBox(height: 10),
            Text(
              context.l10n.statusLoading,
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
          Text(context.l10n.statusNoLogsAvailable, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            context.l10n.messageLogsAppearHere,
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
      title: context.l10n.settingsCategoryLogs,
      maxWidth: double.infinity,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const LocalLogSettingsSection(),
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
                        label: Text(context.l10n.actionCopyRaw),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _copyGitHubLogs(context, logs),
                        icon: const Icon(Icons.code_outlined, size: 18),
                        label: Text(context.l10n.actionCopyMarkdown),
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
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: YaabsaCircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.save_alt_outlined, size: 18),
                        label: Text(isExporting.value ? context.l10n.statusExporting : context.l10n.actionExportLogs),
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
                        child: Text(context.l10n.logEntryCount(logs.length), style: theme.textTheme.labelMedium),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: context.l10n.actionScrollToTop,
                        onPressed: logs.isEmpty ? null : () => _scrollToTop(scrollController),
                        icon: const Icon(Icons.vertical_align_top_rounded),
                      ),
                      IconButton(
                        tooltip: context.l10n.actionScrollToBottom,
                        onPressed: logs.isEmpty ? null : () => _scrollToBottom(scrollController),
                        icon: const Icon(Icons.vertical_align_bottom_rounded),
                      ),
                      const SizedBox(width: 4),
                      Text(context.l10n.settingLogAutoScroll, style: theme.textTheme.bodySmall),
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
