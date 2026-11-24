import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:yaabsa/ui/previews/marionette_configuration.dart';
import 'package:yaabsa/ui/previews/ui_lab.dart';
import 'package:yaabsa/util/logger.dart';

void main() {
  if (!kDebugMode) {
    throw UnsupportedError('The UI Lab requires a debug build.');
  }

  MarionetteBinding.ensureInitialized(uiLabMarionetteConfiguration);
  logger('UI Lab started', tag: 'UiLab', level: InfoLevel.info);
  runApp(
    const ProviderScope(
      child: MarionetteDeviceConfig(
        child: UiLab(initialScenario: String.fromEnvironment('UI_LAB_SCENARIO', defaultValue: 'Inputs')),
      ),
    ),
  );
}
