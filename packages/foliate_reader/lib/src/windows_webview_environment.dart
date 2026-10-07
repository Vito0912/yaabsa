import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<WebViewEnvironment>? _environment;

Future<WebViewEnvironment> windowsWebViewEnvironment() {
  return _environment ??= _createEnvironment().timeout(const Duration(seconds: 30)).catchError((Object error) {
    _environment = null;
    throw error;
  });
}

Future<WebViewEnvironment> _createEnvironment() async {
  final version = await WebViewEnvironment.getAvailableVersion();
  if (version == null) {
    throw StateError('Install Microsoft Edge WebView2 Runtime to read eBooks.');
  }

  final supportDirectory = await getApplicationSupportDirectory();
  final dataDirectory = Directory(p.join(supportDirectory.path, 'reader_webview'));
  await dataDirectory.create(recursive: true);
  return WebViewEnvironment.create(settings: WebViewEnvironmentSettings(userDataFolder: dataDirectory.path));
}
