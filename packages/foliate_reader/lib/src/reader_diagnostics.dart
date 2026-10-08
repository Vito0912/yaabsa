import 'dart:collection';
import 'dart:io';

class ReaderDiagnostics {
  ReaderDiagnostics(this.onMessage);

  final void Function(String message, bool isError) onMessage;
  final Stopwatch _elapsed = Stopwatch()..start();
  final ListQueue<String> _events = ListQueue<String>();
  String stage = 'initializing';
  bool webViewCreated = false;
  bool navigationStarted = false;
  bool navigationFinished = false;
  int progress = 0;

  void record(String message, {bool isError = false}) {
    final entry = '+${_elapsed.elapsedMilliseconds}ms $message';
    if (_events.length == 40) _events.removeFirst();
    _events.addLast(entry);
    onMessage(entry, isError);
  }

  void enterStage(String value) {
    stage = value;
    record('Stage: $value');
  }

  void failure(String message, {Object? error, StackTrace? stackTrace}) {
    onMessage(
      '$message\n'
      'Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}\n'
      'Stage: $stage, elapsed: ${_elapsed.elapsedMilliseconds}ms\n'
      'WebView created: $webViewCreated, navigation started: $navigationStarted, '
      'navigation finished: $navigationFinished, progress: $progress%\n'
      '${error != null ? 'Cause: $error\n' : ''}'
      '${stackTrace != null ? 'Stack trace:\n$stackTrace\n' : ''}'
      'Recent reader events:\n${_events.join('\n')}',
      true,
    );
  }

  static String url(Uri? uri) {
    if (uri == null) return '(none)';
    return uri.replace(userInfo: '', query: '', fragment: '').toString();
  }
}
