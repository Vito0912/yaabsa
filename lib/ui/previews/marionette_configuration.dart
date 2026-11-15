import 'dart:async';

import 'package:flutter/widgets.dart' show Element;
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:yaabsa/ui/components/inputs/expressive_dropdown.dart';
import 'package:yaabsa/util/log_exporter.dart';
import 'package:yaabsa/util/logger.dart';

final uiLabMarionetteConfiguration = MarionetteConfiguration(
  isInteractiveElement: _isInteractiveUiLabControl,
  extractText: _extractUiLabControlText,
  logCollector: _UiLabLogCollector(),
);

class _UiLabLogCollector implements LogCollector {
  StreamSubscription<LogEntry>? _subscription;

  @override
  void start(void Function(String log) onLog) {
    _subscription = appLoggerService.logStream.listen((entry) {
      onLog(formatLogEntryForExport(entry));
    });
  }

  @override
  void dispose() {
    final subscription = _subscription;
    _subscription = null;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }
  }
}

bool _isInteractiveUiLabControl(Element element) {
  return switch (element.widget) {
    YaabsaExpressiveDropdownField<dynamic>() => true,
    YaabsaDropdownField<dynamic>() => true,
    _ => false,
  };
}

String? _extractUiLabControlText(Element element) {
  return switch (element.widget) {
    YaabsaExpressiveDropdownField<dynamic>(:final decoration) => decoration?.labelText,
    YaabsaDropdownField<dynamic>(:final label) => label,
    _ => null,
  };
}
