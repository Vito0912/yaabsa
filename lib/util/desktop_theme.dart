import 'package:flutter/foundation.dart';
import 'package:gtk/gtk.dart';
import 'package:yaabsa/util/logger.dart';

GtkSettings? _gtkSettings;
Brightness? _lastAppliedBrightness;

void syncDesktopTheme(Brightness brightness) {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.linux) {
    return;
  }

  if (_lastAppliedBrightness == brightness) {
    return;
  }

  try {
    (_gtkSettings ??= GtkSettings()).setProperty(kGtkApplicationPreferDarkTheme, brightness == Brightness.dark);
    _lastAppliedBrightness = brightness;
  } catch (error, stack) {
    logger('Failed to sync the Linux GTK theme: $error\n$stack', tag: 'DesktopTheme', level: InfoLevel.warning);
  }
}
