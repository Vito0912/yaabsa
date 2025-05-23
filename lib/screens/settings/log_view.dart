import 'package:buchshelfly/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LogView extends HookWidget {
  const LogView({super.key});

  String _levelToString(InfoLevel level) {
    switch (level) {
      case InfoLevel.debug:
        return "DEBUG";
      case InfoLevel.info:
        return "INFO";
      case InfoLevel.warning:
        return "WARNING";
      case InfoLevel.error:
        return "ERROR";
    }
  }

  String _formatSingleLogEntry(LogEntry log) {
    final timestampStr = _formatTimestamp(log.timestamp);
    final levelStr = _levelToString(log.level);
    final tagStr = log.tag != null ? "[${log.tag}] " : "";
    return '$timestampStr [$levelStr] $tagStr${log.message}';
  }

  void _copyRawLogs(BuildContext context, List<LogEntry> logs) {
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No logs to copy.')));
      return;
    }
    final rawLogs = logs.map(_formatSingleLogEntry).join('\n');
    Clipboard.setData(ClipboardData(text: rawLogs));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Raw logs copied to clipboard!')));
  }

  void _copyGitHubLogs(BuildContext context, List<LogEntry> logs) {
    final buffer = StringBuffer();
    buffer.writeln('<details>');
    buffer.writeln('<summary>Logs (${logs.length} ${logs.length == 1 ? "entry" : "entries"})</summary>');
    buffer.writeln('');
    buffer.writeln('```text');
    if (logs.isNotEmpty) {
      buffer.write(logs.map(_formatSingleLogEntry).join('\n'));
    }
    buffer.writeln('');
    buffer.writeln('```');
    buffer.writeln('');
    buffer.writeln('</details>');

    Clipboard.setData(ClipboardData(text: buffer.toString()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('GitHub formatted logs copied to clipboard!')));
  }

  void _scrollToTop(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToBottom(ScrollController controller) {
    if (controller.hasClients) {
      controller.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    final streamSnapshot = useStream(appLoggerService.logStream);
    final List<LogEntry> logs = appLoggerService.logHistory;
    final scrollController = useScrollController();
    final autoScrollEnabled = useState(true);

    useEffect(() {
      if (logs.isNotEmpty && scrollController.hasClients && autoScrollEnabled.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
      return null;
    }, [logs.length, autoScrollEnabled.value]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logs'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.copy_outlined, size: 18),
                        label: const Text('Copy Raw'),
                        onPressed: () => _copyRawLogs(context, logs),
                        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.code_outlined, size: 18),
                        label: const Text('Copy GitHub'),
                        onPressed: () => _copyGitHubLogs(context, logs),
                        style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${logs.length} ${logs.length == 1 ? "entry" : "entries"}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            autoScrollEnabled.value
                                ? Theme.of(context).colorScheme.primaryContainer
                                : Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            autoScrollEnabled.value ? Icons.play_arrow : Icons.pause,
                            size: 14,
                            color:
                                autoScrollEnabled.value
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            autoScrollEnabled.value ? 'Auto-scroll ON' : 'Auto-scroll OFF',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color:
                                  autoScrollEnabled.value
                                      ? Theme.of(context).colorScheme.onPrimaryContainer
                                      : Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (logs.isEmpty && streamSnapshot.connectionState == ConnectionState.waiting) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      'Loading logs...',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else if (logs.isEmpty) ...[
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.article_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No logs yet',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Logs will appear here as they are generated',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ListView.builder(
                reverse: true,
                controller: scrollController,
                itemCount: logs.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: _getColorForLevel(log.level).withValues(alpha: 0.03),
                      border: Border.all(color: _getColorForLevel(log.level).withValues(alpha: 0.1), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      dense: true,
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _getColorForLevel(log.level).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(_getIconForLevel(log.level), color: _getColorForLevel(log.level), size: 18),
                      ),
                      title: Text(log.message, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Row(
                          children: [
                            Text(
                              _formatTimestamp(log.timestamp),
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                fontFamily: 'monospace',
                              ),
                            ),
                            if (log.tag != null) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  log.tag!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
      floatingActionButton:
          logs.isNotEmpty
              ? Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.small(
                    heroTag: "scroll_top",
                    onPressed: () => _scrollToTop(scrollController),
                    tooltip: 'Scroll to top',
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: "scroll_bottom",
                    onPressed: () => _scrollToBottom(scrollController),
                    tooltip: 'Scroll to bottom',
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: "auto_scroll",
                    onPressed: () {
                      autoScrollEnabled.value = !autoScrollEnabled.value;
                    },
                    tooltip: autoScrollEnabled.value ? 'Disable auto-scroll' : 'Enable auto-scroll',
                    backgroundColor:
                        autoScrollEnabled.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                    foregroundColor:
                        autoScrollEnabled.value
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onError,
                    child: Icon(autoScrollEnabled.value ? Icons.pause : Icons.play_arrow),
                  ),
                ],
              )
              : null,
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}:${timestamp.second.toString().padLeft(2, '0')}';
  }

  IconData _getIconForLevel(InfoLevel level) {
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

  Color _getColorForLevel(InfoLevel level) {
    switch (level) {
      case InfoLevel.debug:
        return Colors.blueAccent;
      case InfoLevel.info:
        return Colors.green;
      case InfoLevel.warning:
        return Colors.orangeAccent;
      case InfoLevel.error:
        return Colors.redAccent;
    }
  }
}
