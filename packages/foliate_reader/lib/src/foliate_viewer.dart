import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;
import 'models.dart';
import 'book_server.dart';
import 'windows_webview_environment.dart';
import 'reader_diagnostics.dart';

part 'foliate_viewer_handlers.dart';

class FoliateViewerController {
  InAppWebViewController? _webViewController;

  void _bind(InAppWebViewController webViewController) {
    _webViewController = webViewController;
  }

  void _unbind() {
    _webViewController = null;
  }

  Future<void> close() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.close();');
  }

  Future<void> next() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.next();');
  }

  Future<void> prev() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.prev();');
  }

  Future<void> goTo(String target) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.goTo(${jsonEncode(target)});');
  }

  Future<void> goToFraction(double fraction) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.goToFraction($fraction);');
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

  Future<void> setFlow(String flow) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.setFlow(${jsonEncode(flow)});');
  }

  Future<void> setMaxColumnCount(int count) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.setMaxColumnCount($count);');
  }

  Future<void> search(String query) async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.search(${jsonEncode(query)});');
  }

  Future<void> clearSearch() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.clearSearch();');
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

  Future<void> highlightCFI(String cfi, [String? color]) async {
    final args = color != null ? '"$cfi", "$color"' : '"$cfi"';
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.highlightCFI($args);');
  }

  Future<void> clearTtsHighlight() async {
    await _webViewController?.evaluateJavascript(source: 'window.FoliateReaderAPI.clearTtsHighlight();');
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

class FoliateViewer extends StatefulWidget {
  final File? bookFile;
  final String? bookUrl;
  final String? bookExtension;
  final Map<String, String>? headers;
  final String? initialCfi;
  final String? initialStyles;
  final String flow;
  final int maxColumnCount;
  final FoliateViewerController? controller;
  final void Function(FoliateLocation)? onRelocate;
  final void Function(
    FoliateMetadata metadata,
    List<FoliateTOCItem> toc,
    List<FoliateTOCItem> pageList,
    String dir,
    bool hasMediaOverlays,
  )?
  onBookLoaded;
  final void Function(FoliateSelection)? onSelectionChanged;
  final void Function()? onSelectionCleared;
  final void Function(FoliateAnnotation)? onAnnotationClicked;
  final void Function(FoliateAnnotation)? onAnnotationAdded;
  final void Function(List<FoliateSearchResult>)? onSearchResults;
  final void Function(String)? onError;
  final VoidCallback? onCenterTap;
  final void Function(int)? onProgressChanged;
  final void Function(int)? onTtsJumpToSentence;
  final void Function(String state)? onMediaOverlayStateChanged;
  final void Function(Map<String, dynamic> detail)? onMediaOverlayHighlight;
  final void Function(Map<String, dynamic> detail)? onMediaOverlayUnhighlight;
  final void Function(String error)? onMediaOverlayError;

  const FoliateViewer({
    super.key,
    this.bookFile,
    this.bookUrl,
    this.bookExtension,
    this.headers,
    this.initialCfi,
    this.initialStyles,
    this.flow = 'paginated',
    this.maxColumnCount = 2,
    this.controller,
    this.onRelocate,
    this.onBookLoaded,
    this.onSelectionChanged,
    this.onSelectionCleared,
    this.onAnnotationClicked,
    this.onAnnotationAdded,
    this.onSearchResults,
    this.onError,
    this.onCenterTap,
    this.onProgressChanged,
    this.onTtsJumpToSentence,
    this.onMediaOverlayStateChanged,
    this.onMediaOverlayHighlight,
    this.onMediaOverlayUnhighlight,
    this.onMediaOverlayError,
    this.bookFetcher,
    this.onDiagnostic,
  });

  final Future<void> Function(String url, Map<String, String>? headers, HttpRequest request)? bookFetcher;
  final void Function(String message, bool isError)? onDiagnostic;

  @override
  State<FoliateViewer> createState() => _FoliateViewerState();
}

class _FoliateViewerState extends State<FoliateViewer> {
  BookServer? _server;
  int? _port;
  bool _isLoadingServer = true;
  String? _serverError;
  int _webViewProgress = 0;
  bool _isBookLoaded = false;
  WebViewEnvironment? _webViewEnvironment;
  Timer? _startupTimer;
  String? _loadError;
  late final ReaderDiagnostics _diagnostics;

  @override
  void initState() {
    super.initState();
    _diagnostics = ReaderDiagnostics((message, isError) {
      widget.onDiagnostic?.call(message, isError);
    });
    _diagnostics.record(
      'Reader source: ${widget.bookFile != null ? 'local file' : 'remote'}, '
      'format: ${widget.bookExtension ?? '(unspecified)'}, '
      'remote endpoint: ${ReaderDiagnostics.url(Uri.tryParse(widget.bookUrl ?? ''))}',
    );
    _startServer();
  }

  Future<void> _startServer() async {
    try {
      if (Platform.isWindows) {
        _diagnostics.enterStage('initializing Windows WebView2 environment');
        final environment = await windowsWebViewEnvironment(onDiagnostic: _diagnostics.record);
        if (!mounted) return;
        _webViewEnvironment = environment;
      }
      _diagnostics.enterStage('binding local reader server');
      _server = BookServer(
        bookFile: widget.bookFile,
        bookUrl: widget.bookUrl,
        headers: widget.headers,
        bookFetcher: widget.bookFetcher,
        onDiagnostic: (message, isError) => _diagnostics.record(message, isError: isError),
      );
      final port = await _server!.start();
      if (!mounted) {
        await _server?.stop();
        return;
      }
      _diagnostics.record('Local reader server listening at http://127.0.0.1:$port/reader.html');
      _diagnostics.enterStage('waiting for WebView creation and reader navigation');
      _startupTimer = Timer(const Duration(seconds: 30), () {
        _reportLoadError('The eBook reader could not start. Please try opening the book again.');
      });
      if (mounted) {
        setState(() {
          _port = port;
          _isLoadingServer = false;
        });
      }
    } catch (e, s) {
      _diagnostics.failure('Failed to initialize the eBook reader', error: e, stackTrace: s);
      if (mounted) {
        setState(() {
          _serverError = e.toString();
          _isLoadingServer = false;
        });
      }
      if (mounted) {
        widget.onError?.call('Failed to initialize the eBook reader: $e');
      }
    }
  }

  void _reportLoadError(String error, {StackTrace? stackTrace}) {
    if (!mounted) return;
    _diagnostics.failure(error, stackTrace: stackTrace);
    _startupTimer?.cancel();
    setState(() {
      _loadError = error;
    });
    widget.onError?.call(error);
  }

  void _markBookLoaded() {
    _diagnostics.enterStage('book loaded');
    setState(() {
      _isBookLoaded = true;
    });
  }

  @override
  void didUpdateWidget(covariant FoliateViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookUrl != widget.bookUrl || oldWidget.bookFile != widget.bookFile) {
      setState(() {
        _isBookLoaded = false;
        _webViewProgress = 0;
      });
      _server?.bookUrl = widget.bookUrl;
      _server?.bookFile = widget.bookFile;
    }
    if (oldWidget.headers != widget.headers) {
      _server?.headers = widget.headers;
    }
    if (oldWidget.flow != widget.flow) {
      widget.controller?.setFlow(widget.flow);
    }
    if (oldWidget.maxColumnCount != widget.maxColumnCount) {
      widget.controller?.setMaxColumnCount(widget.maxColumnCount);
    }
    if (oldWidget.initialStyles != widget.initialStyles && widget.initialStyles != null) {
      widget.controller?.setStyles(widget.initialStyles!);
    }
  }

  @override
  void dispose() {
    _diagnostics.record('Reader disposed');
    _startupTimer?.cancel();
    widget.controller?._unbind();
    _server?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingServer) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_serverError != null) {
      return Center(child: Text('Error: $_serverError'));
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        InAppWebView(
          webViewEnvironment: _webViewEnvironment,
          initialUrlRequest: URLRequest(url: WebUri('http://127.0.0.1:$_port/reader.html')),
          contextMenu: _selectionContextMenu,
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            supportZoom: true,
            builtInZoomControls: true,
            displayZoomControls: false,
            maximumZoomScale: 5,
            minimumZoomScale: 1,
            transparentBackground: true,
          ),
          onWebViewCreated: (controller) {
            _diagnostics.webViewCreated = true;
            _diagnostics.enterStage('WebView created, waiting for reader page');
            widget.controller?._bind(controller);
            _setupHandlers(controller);
          },
          onLoadStart: (controller, url) {
            _diagnostics.navigationStarted = true;
            _diagnostics.enterStage('loading reader page');
            _diagnostics.record('Navigation started: ${ReaderDiagnostics.url(url)}');
          },
          onLoadStop: (controller, url) async {
            _diagnostics.navigationFinished = true;
            _diagnostics.record('Navigation finished: ${ReaderDiagnostics.url(url)}');
            if (!mounted || _loadError != null) return;
            _startupTimer?.cancel();
            _diagnostics.enterStage('initializing FoliateReaderAPI and opening book');
            final String bookPath;
            if (widget.bookFile != null) {
              bookPath = p.basename(widget.bookFile!.path);
            } else {
              final ext = widget.bookExtension ?? 'epub';
              final dotExt = ext.startsWith('.') ? ext : '.$ext';
              bookPath = 'remote_book$dotExt';
            }
            final bookUrl = 'http://127.0.0.1:$_port/book/${Uri.encodeComponent(bookPath)}';
            final initialCfi = widget.initialCfi;
            final initialStyles = widget.initialStyles;
            final jsCode =
                '''
              (function() {
                const callOpen = () => {
                  if (window.FoliateReaderAPI && window.FoliateReaderAPI.openBook) {
                    window.FoliateReaderAPI.openBook(
                      ${jsonEncode(bookUrl)},
                      ${jsonEncode(initialCfi)},
                      "${widget.flow}", 
                      ${widget.maxColumnCount}, 
                      ${initialStyles != null ? jsonEncode(initialStyles) : 'null'}
                    );
                    return true;
                  }
                  return false;
                };
                if (!callOpen()) {
                  console.log("FoliateReaderAPI not ready yet, polling...");
                  const interval = setInterval(() => {
                    if (callOpen()) {
                      console.log("FoliateReaderAPI loaded and openBook called.");
                      clearInterval(interval);
                    }
                  }, 50);
                  setTimeout(() => {
                    clearInterval(interval);
                    if (!window.FoliateReaderAPI || !window.FoliateReaderAPI.openBook) {
                      console.error("FoliateReaderAPI failed to load within timeout.");
                      window.flutter_inappwebview.callHandler('onError', 'The eBook reader failed to initialize.');
                    }
                  }, 15000);
                } else {
                  console.log("FoliateReaderAPI was ready immediately, openBook called.");
                }
              })();
            ''';
            try {
              await controller.evaluateJavascript(source: jsCode);
              _diagnostics.record('Reader initialization JavaScript submitted');
            } catch (error, stackTrace) {
              _reportLoadError('Failed to initialize the eBook reader: $error', stackTrace: stackTrace);
            }
          },
          onReceivedError: (controller, request, error) {
            _diagnostics.record(
              'WebView resource error: url=${ReaderDiagnostics.url(request.url)}, '
              'mainFrame=${request.isForMainFrame}, type=${error.type}, description=${error.description}',
              isError: true,
            );
            if (request.isForMainFrame == true) {
              _reportLoadError('Failed to load the eBook reader: ${error.description}');
            }
          },
          onReceivedHttpError: (controller, request, response) {
            _diagnostics.record(
              'WebView HTTP error: url=${ReaderDiagnostics.url(request.url)}, '
              'mainFrame=${request.isForMainFrame}, status=${response.statusCode}, reason=${response.reasonPhrase}',
              isError: true,
            );
            if (request.isForMainFrame == true) {
              _reportLoadError('Failed to load the eBook reader: HTTP ${response.statusCode}');
            }
          },
          onConsoleMessage: (controller, consoleMessage) {
            _diagnostics.record(
              'WebView console [${consoleMessage.messageLevel}]: ${consoleMessage.message}',
              isError: consoleMessage.messageLevel == ConsoleMessageLevel.ERROR,
            );
          },
          onProgressChanged: (controller, progress) {
            if (!mounted) return;
            if (progress ~/ 25 != _diagnostics.progress ~/ 25) {
              _diagnostics.record('Reader page progress: $progress%');
            }
            _diagnostics.progress = progress;
            setState(() {
              _webViewProgress = progress;
            });
            widget.onProgressChanged?.call(progress);
          },
        ),
        if (_loadError != null)
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(24),
            child: Center(child: Text(_loadError!, textAlign: TextAlign.center)),
          )
        else if (!_isBookLoaded)
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _webViewProgress >= 100 ? null : _webViewProgress / 100.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _webViewProgress >= 100 ? 'Loading eBook' : 'Loading reader ($_webViewProgress%)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
