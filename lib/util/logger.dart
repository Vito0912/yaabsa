import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logger.freezed.dart';

enum InfoLevel {
  debug,
  info,
  warning,
  error;

  static InfoLevel fromSettingValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return InfoLevel.warning;
    }

    final normalized = value.trim().toLowerCase();

    for (final level in InfoLevel.values) {
      if (level.name == normalized) {
        return level;
      }
    }

    if (normalized.startsWith('infolevel.')) {
      final suffix = normalized.split('.').last;
      for (final level in InfoLevel.values) {
        if (level.name == suffix) {
          return level;
        }
      }
    }

    for (final level in InfoLevel.values) {
      if (level.toString().toLowerCase() == normalized) {
        return level;
      }
    }

    return InfoLevel.warning;
  }

  int get priority {
    switch (this) {
      case InfoLevel.debug:
        return 0;
      case InfoLevel.info:
        return 1;
      case InfoLevel.warning:
        return 2;
      case InfoLevel.error:
        return 3;
    }
  }
}

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
  InfoLevel _minimumLevel = InfoLevel.warning;

  Stream<LogEntry> get logStream => _logController.stream;

  List<LogEntry> get logHistory => _logHistory.toList();

  InfoLevel get minimumLevel => _minimumLevel;

  void setMinimumLevel(InfoLevel level) {
    final resolvedLevel = kDebugMode ? InfoLevel.debug : level;
    if (_minimumLevel == resolvedLevel) {
      return;
    }
    _minimumLevel = resolvedLevel;
  }

  bool shouldLog(InfoLevel level) {
    if (kDebugMode) {
      return true;
    }
    return level.priority >= _minimumLevel.priority;
  }

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

const String _releaseConsoleLoggingEnvKey = 'YAABSA_RELEASE_CONSOLE_LOG';

bool _isTruthyEnvValue(String? value) {
  if (value == null) {
    return false;
  }

  switch (value.trim().toLowerCase()) {
    case '1':
    case 'true':
    case 'yes':
    case 'on':
      return true;
    default:
      return false;
  }
}

final bool _isReleaseConsoleLoggingEnabled = _isTruthyEnvValue(Platform.environment[_releaseConsoleLoggingEnvKey]);

bool get _shouldPrintToConsole => kDebugMode || _isReleaseConsoleLoggingEnabled;

void logger(String message, {String? tag, InfoLevel level = InfoLevel.info}) {
  if (!appLoggerService.shouldLog(level)) {
    return;
  }

  final now = DateTime.now();

  final logEntry = LogEntry(timestamp: now, message: message, level: level, tag: tag);

  appLoggerService._addLogEntry(logEntry);

  if (_shouldPrintToConsole) {
    final formattedDate = DateFormat.yMd(Intl.getCurrentLocale()).add_Hms().format(now);
    final fallbackMessage = '[$formattedDate] [${level.name.toUpperCase()}] [${tag ?? 'FALLBACK'}] $message';

    switch (level) {
      case InfoLevel.debug:
        debugPrint('\x1B[34m$fallbackMessage\x1B[0m');
        break;
      case InfoLevel.info:
        debugPrint('\x1B[32m$fallbackMessage\x1B[0m');
        break;
      case InfoLevel.warning:
        debugPrint('\x1B[33m$fallbackMessage\x1B[0m');
        break;
      case InfoLevel.error:
        debugPrint('\x1B[31m$fallbackMessage\x1B[0m');
        break;
    }
  }
}
