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

  @override
  Widget build(BuildContext context) {
    final streamSnapshot = useStream(appLoggerService.logStream);
    final List<LogEntry> logs = appLoggerService.logHistory;

    final scrollController = useScrollController();

    useEffect(() {
      if (logs.isNotEmpty && scrollController.hasClients) {
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
    }, [logs.length]);

    return Scaffold(
      appBar: AppBar(title: const Text('Logs')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.copy_outlined),
                  label: const Text('Copy Raw'),
                  onPressed: () => _copyRawLogs(context, logs),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.code_outlined),
                  label: const Text('Copy GitHub'),
                  onPressed: () => _copyGitHubLogs(context, logs),
                ),
              ],
            ),
          ),
          if (logs.isEmpty && streamSnapshot.connectionState == ConnectionState.waiting) ...[
            const Expanded(child: Center(child: CircularProgressIndicator())),
          ] else if (logs.isEmpty) ...[
            const Expanded(child: Center(child: Text('No logs yet.'))),
          ] else ...[
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: _getColorForLevel(log.level).withOpacity(0.05),
                    child: ListTile(
                      leading: Icon(_getIconForLevel(log.level), color: _getColorForLevel(log.level)),
                      title: Text(log.message, style: const TextStyle(fontSize: 14)),
                      subtitle: Text(
                        '${_formatTimestamp(log.timestamp)} ${log.tag != null ? "[${log.tag}]" : ""}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                        ),
                      ),
                      dense: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
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
