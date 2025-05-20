import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logger.freezed.dart';

enum InfoLevel { debug, info, warning, error }

@freezed
abstract class LogEntry with _$LogEntry {
  const factory LogEntry({
    required DateTime timestamp,
    required String message,
    required InfoLevel level,
    String? tag,
  }) = _LogEntry;
}

class AppLoggerService {
  static const int _maxLogEntries = 1000;
  final _logController = StreamController<LogEntry>.broadcast();
  final ListQueue<LogEntry> _logHistory = ListQueue<LogEntry>(_maxLogEntries);

  Stream<LogEntry> get logStream => _logController.stream;

  List<LogEntry> get logHistory => _logHistory.toList();

  void _addLogEntry(LogEntry entry) {
    if (_logHistory.length >= _maxLogEntries && _logHistory.isNotEmpty) {
      _logHistory.removeFirst();
    }
    _logHistory.addLast(entry);
    _logController.add(entry);
  }

  void dispose() {
    _logController.close();
  }
}

final appLoggerService = AppLoggerService();

logger(String message, {String? tag, InfoLevel level = InfoLevel.info}) {
  final now = DateTime.now();

  final logEntry = LogEntry(timestamp: now, message: message, level: level, tag: tag);

  appLoggerService._addLogEntry(logEntry);

  if (kDebugMode) {
    final formattedDate =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    final fallbackMessage = '[$formattedDate] [${level.name.toUpperCase()}] [${tag ?? 'FALLBACK'}] $message';

    switch (level) {
      case InfoLevel.debug:
        print('\x1B[34m$fallbackMessage\x1B[0m');
        break;
      case InfoLevel.info:
        print('\x1B[32m$fallbackMessage\x1B[0m');
        break;
      case InfoLevel.warning:
        print('\x1B[33m$fallbackMessage\x1B[0m');
        break;
      case InfoLevel.error:
        print('\x1B[31m$fallbackMessage\x1B[0m');
        break;
    }
  }
}
