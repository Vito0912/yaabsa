import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:yaabsa/util/app_paths.dart';
import 'package:yaabsa/util/logger.dart';

class LogExportResult {
  const LogExportResult({required this.filePath, required this.usedSaveDialog});

  final String filePath;
  final bool usedSaveDialog;
}

final RegExp _sensitiveUrlPattern = RegExp(r'(?:(?:https?|wss?)://)[^\s\]\)>,]+', caseSensitive: false);

String redactSensitiveUrls(String value) {
  return value.replaceAll(_sensitiveUrlPattern, '[REDACTED_URL]');
}

String formatLogEntryForExport(LogEntry log) {
  final timestamp = _formatTimestamp(log.timestamp);
  final level = _levelToExportString(log.level);
  final tag = log.tag != null ? '[${log.tag}] ' : '';
  final redactedMessage = redactSensitiveUrls(log.message);
  return '$timestamp [$level] $tag$redactedMessage';
}

String formatLogsForExport(List<LogEntry> logs) {
  if (logs.isEmpty) {
    return '';
  }
  return logs.map(formatLogEntryForExport).join('\n');
}

Future<LogExportResult> exportLogsAsLogFile(List<LogEntry> logs) async {
  final now = DateTime.now();
  final suggestedName = _buildLogFileName(now);
  final logText = formatLogsForExport(logs);
  final logBytes = Uint8List.fromList(utf8.encode(logText));

  String? selectedPath;
  try {
    selectedPath = await FilePicker.saveFile(
      dialogTitle: 'Export logs',
      fileName: suggestedName,
      type: FileType.custom,
      allowedExtensions: const ['log'],
      bytes: logBytes,
    );
  } catch (_) {
    selectedPath = null;
  }

  final hasSelectedPath = selectedPath != null && selectedPath.trim().isNotEmpty;
  if (hasSelectedPath) {
    return LogExportResult(filePath: selectedPath.trim(), usedSaveDialog: true);
  }

  final outputPath = await _buildFallbackPath(suggestedName);

  final outputFile = File(outputPath);
  await outputFile.parent.create(recursive: true);
  await outputFile.writeAsString(logText, flush: true);

  return LogExportResult(filePath: outputFile.path, usedSaveDialog: false);
}

Future<String> _buildFallbackPath(String fileName) async {
  final configDirectory = await resolveDefaultConfigDirectory();
  final exportDirectory = Directory(p.join(configDirectory.path, 'logs', 'exports'));
  return p.join(exportDirectory.path, fileName);
}

String _buildLogFileName(DateTime timestamp) {
  final digitsOnly = timestamp.toIso8601String().replaceAll(RegExp(r'[^0-9]'), '');
  final date = digitsOnly.substring(0, 8);
  final time = digitsOnly.substring(8, 14);
  return 'yaabsa_logs_${date}_$time.log';
}

String _levelToExportString(InfoLevel level) {
  switch (level) {
    case InfoLevel.debug:
      return 'DEBUG';
    case InfoLevel.info:
      return 'INFO';
    case InfoLevel.warning:
      return 'WARNING';
    case InfoLevel.error:
      return 'ERROR';
  }
}

String _formatTimestamp(DateTime timestamp) {
  return DateFormat.yMd(Intl.getCurrentLocale()).add_Hms().format(timestamp);
}
