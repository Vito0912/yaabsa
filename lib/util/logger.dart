import 'package:flutter/foundation.dart';

enum InfoLevel { debug, info, warning, error }

logger(String message, {String? tag, InfoLevel level = InfoLevel.info}) {
  final now = DateTime.now();
  final formattedDate = '${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}:${now.second}';
  final fallbackMessage = '[$formattedDate] [${level.name.toUpperCase()}] [${tag ?? 'FALLBACK'}] $message';
  if (kDebugMode) {
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
