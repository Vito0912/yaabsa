part of 'foliate_viewer.dart';

class FoliateViewerController {
  InAppWebViewController? _webViewController;
  String? _narrationExportPath;

  void _bind(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }

  void _unbind() {
    _webViewController = null;
    _narrationExportPath = null;
  }

  Future<dynamic> _evaluateAsync(String expression) async {
    final result = await _webViewController?.callAsyncJavaScript(functionBody: 'return await $expression;');

    if (result?.error != null) {
      throw StateError(result!.error!);
    }

    return result?.value;
  }

  Future<void> close() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.close();');
  }

  Future<void> next() async {
    await _evaluateAsync('window.FoliateReaderAPI.next()');
  }

  Future<void> prev() async {
    await _evaluateAsync('window.FoliateReaderAPI.prev()');
  }

  Future<void> goTo(String target) async {
    await _evaluateAsync('window.FoliateReaderAPI.goTo(${jsonEncode(target)})');
  }

  Future<void> goToFraction(double fraction) async {
    await _evaluateAsync('window.FoliateReaderAPI.goToFraction($fraction)');
  }

  Future<dynamic> addAnnotation(FoliateAnnotation annotation) async {
    return await _webViewController?.evaluateJavascript(
      source: 'window.FoliateReaderAPI.addAnnotation(${jsonEncode(annotation.toJson())});',
    );
  }

  Future<void> deleteAnnotation(FoliateAnnotation annotation) async {
    await _webViewController?.evaluateJavascript(
      source: 'window.FoliateReaderAPI.deleteAnnotation(${jsonEncode(annotation.toJson())});',
    );
  }

  Future<void> setStyles(String css) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.setStyles(${jsonEncode(css)});');
  }

  Future<void> setPageGeometry({required double margin, required double width, double? verticalMargin}) async {
    await _webViewController?.evaluateJavascript(
      source: 'window.FoliateReaderAPI.setPageGeometry($margin, $width, ${verticalMargin ?? margin});',
    );
  }

  Future<void> setFlow(String flow) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.setFlow(${jsonEncode(flow)});');
  }

  Future<void> setMaxColumnCount(int count) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.setMaxColumnCount($count);');
  }

  Future<void> search(String query) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.search(${jsonEncode(query)});');
  }

  Future<List<FoliateSearchResult>> searchBook(String query, {int maxResults = 300}) async {
    final result = await _evaluateAsync('window.FoliateReaderAPI.search(${jsonEncode(query)}, $maxResults, false)');

    if (result is! List) {
      return const [];
    }

    return result.map((entry) => FoliateSearchResult.fromJson(Map<String, dynamic>.from(entry as Map))).toList();
  }

  Future<void> clearSearch() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.clearSearch();');
  }

  Future<void> highlightSearchResult(String cfi) async {
    await _webViewController?.evaluateJavascript(
      source: 'window.FoliateReaderAPI.highlightSearchResult(${jsonEncode(cfi)});',
    );
  }

  Future<void> deselect() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.deselect();');
  }

  Future<String?> getCurrentSectionText() async {
    final res = await _webViewController?.evaluateJavascript(
      source: 'window.FoliateReaderAPI.getCurrentSectionText();',
    );

    return res as String?;
  }

  Future<List<Map<String, String>>> getTtsSentences() async {
    final res = await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.getTtsSentences();');

    if (res is List) {
      return res.map((e) => Map<String, String>.from(e as Map)).toList();
    }

    return const [];
  }

  Future<List<Map<String, String>>> prepareSpeech() async {
    final result = await _evaluateAsync('window.FoliateReaderAPI.prepareSpeech()');

    if (result is! List) {
      return const [];
    }

    return result.map((entry) => Map<String, String>.from(entry as Map)).toList();
  }

  Future<void> setSpeechActive(bool active) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.setSpeechActive($active);');
  }

  Future<List<Map<String, dynamic>>> prepareMediaOverlay() async {
    final result = await _evaluateAsync(
      'window.FoliateReaderAPI.prepareMediaOverlay(${jsonEncode(_narrationExportPath)})',
    );

    if (result is! List) {
      return const [];
    }

    return result.map((entry) => Map<String, dynamic>.from(entry as Map)).toList();
  }

  Future<void> highlightNarrationTarget(String target) async {
    await _evaluateAsync('window.FoliateReaderAPI.highlightNarrationTarget(${jsonEncode(target)})');
  }

  Future<bool> nextTtsSection() async {
    final result = await _evaluateAsync('window.FoliateReaderAPI.nextTtsSection()');

    return result == true;
  }

  Future<void> highlightCFI(String cfi, [String? color]) async {
    final args = color != null ? '${jsonEncode(cfi)}, ${jsonEncode(color)}' : jsonEncode(cfi);

    await _evaluateAsync('window.FoliateReaderAPI.highlightCFI($args)');
  }

  Future<void> clearTtsHighlight() async {
    await _evaluateAsync('window.FoliateReaderAPI.clearTtsHighlight()');
  }

  Future<void> startMediaOverlay() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.startMediaOverlay();');
  }

  Future<void> pauseMediaOverlay() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.pauseMediaOverlay();');
  }

  Future<void> resumeMediaOverlay() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.resumeMediaOverlay();');
  }

  Future<void> stopMediaOverlay() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.stopMediaOverlay();');
  }
}
