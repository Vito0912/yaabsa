import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<WebViewEnvironment>? _environment;

Future<WebViewEnvironment> windowsWebViewEnvironment({void Function(String)? onDiagnostic}) {
  onDiagnostic?.call(_environment == null ? 'Creating WebView2 environment' : 'Reusing WebView2 environment');
  return _environment ??= _createEnvironment(onDiagnostic).timeout(const Duration(seconds: 30)).catchError((
    Object error,
  ) {
    _environment = null;
    throw error;
  });
}

Future<WebViewEnvironment> _createEnvironment(void Function(String)? onDiagnostic) async {
  onDiagnostic?.call('Checking WebView2 Runtime availability');
  final version = await WebViewEnvironment.getAvailableVersion();
  onDiagnostic?.call('WebView2 Runtime version: ${version ?? '(unavailable)'}');
  if (version == null) {
    throw StateError('Install Microsoft Edge WebView2 Runtime to read eBooks.');
  }

  final supportDirectory = await getApplicationSupportDirectory();
  final dataDirectory = Directory(p.join(supportDirectory.path, 'reader_webview'));
  onDiagnostic?.call('WebView2 data directory: ${dataDirectory.path}');
  await dataDirectory.create(recursive: true);
  onDiagnostic?.call('Creating native WebView2 environment');
  final environment = await WebViewEnvironment.create(
    settings: WebViewEnvironmentSettings(userDataFolder: dataDirectory.path),
  );
  onDiagnostic?.call('WebView2 environment ready: ${environment.id}');
  return environment;
}
