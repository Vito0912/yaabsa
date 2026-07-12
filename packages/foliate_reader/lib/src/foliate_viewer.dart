import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;
import 'models.dart';
import 'book_server.dart';

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
  });

  final Future<void> Function(String url, Map<String, String>? headers, HttpRequest request)? bookFetcher;

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

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    try {
      _server = BookServer(
        bookFile: widget.bookFile,
        bookUrl: widget.bookUrl,
        headers: widget.headers,
        bookFetcher: widget.bookFetcher,
      );
      final port = await _server!.start();
      if (mounted) {
        setState(() {
          _port = port;
          _isLoadingServer = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _serverError = e.toString();
          _isLoadingServer = false;
        });
      }
      widget.onError?.call('Failed to start server: $e');
    }
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
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri('http://127.0.0.1:$_port/reader.html')),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
            transparentBackground: true,
          ),
          contextMenu: ContextMenu(
            settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
            menuItems: [
              ContextMenuItem(
                id: 1,
                title: 'Highlight',
                action: () async {
                  final color = '#FFEB3B';
                  await widget.controller?._webViewController?.evaluateJavascript(
                    source: 'window.FoliateReaderAPI.addAnnotationFromSelection("highlight", "$color", "");',
                  );
                },
              ),
              ContextMenuItem(
                id: 2,
                title: 'Underline',
                action: () async {
                  final color = '#2196F3';
                  await widget.controller?._webViewController?.evaluateJavascript(
                    source: 'window.FoliateReaderAPI.addAnnotationFromSelection("underline", "$color", "");',
                  );
                },
              ),
            ],
          ),
          onWebViewCreated: (controller) {
            widget.controller?._bind(controller);
            _setupHandlers(controller);
          },
          onLoadStop: (controller, url) async {
            final String bookPath;
            if (widget.bookFile != null) {
              bookPath = p.basename(widget.bookFile!.path);
            } else {
              final ext = widget.bookExtension ?? 'epub';
              final dotExt = ext.startsWith('.') ? ext : '.$ext';
              bookPath = 'remote_book$dotExt';
            }
            final bookUrl = 'http://127.0.0.1:$_port/book/$bookPath';
            final initialCfi = widget.initialCfi;
            final initialStyles = widget.initialStyles;
            final jsCode =
                '''
              (function() {
                const callOpen = () => {
                  if (window.FoliateReaderAPI && window.FoliateReaderAPI.openBook) {
                    window.FoliateReaderAPI.openBook(
                      "$bookUrl", 
                      ${initialCfi != null ? '"$initialCfi"' : 'null'}, 
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
                    }
                  }, 15000);
                } else {
                  console.log("FoliateReaderAPI was ready immediately, openBook called.");
                }
              })();
            ''';
            await controller.evaluateJavascript(source: jsCode);
          },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint('[WebView Console] [${consoleMessage.messageLevel}] ${consoleMessage.message}');
          },
          onProgressChanged: (controller, progress) {
            if (!mounted) return;
            setState(() {
              _webViewProgress = progress;
            });
            widget.onProgressChanged?.call(progress);
          },
        ),
        if (!_isBookLoaded)
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
                    _webViewProgress >= 100 ? 'Loading eBook' : 'Downloading eBook ($_webViewProgress%)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _setupHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'onCenterTap',
      callback: (args) {
        if (!mounted) return;
        widget.onCenterTap?.call();
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onBookLoaded',
      callback: (args) {
        if (!mounted) return;
        setState(() {
          _isBookLoaded = true;
        });
        if (args.isNotEmpty && widget.onBookLoaded != null) {
          try {
            final data = Map<String, dynamic>.from(args[0] as Map);
            final metadata = FoliateMetadata.fromJson(Map<String, dynamic>.from(data['metadata'] as Map));
            final tocList = data['toc'] as List;
            final toc = tocList.map((e) => FoliateTOCItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
            final pageListRaw = data['pageList'] as List;
            final pageList = pageListRaw
                .map((e) => FoliateTOCItem.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList();
            final dir = data['dir'] as String? ?? 'ltr';
            final hasMediaOverlays = data['hasMediaOverlays'] as bool? ?? false;
            widget.onBookLoaded!(metadata, toc, pageList, dir, hasMediaOverlays);
          } catch (e) {
            widget.onError?.call('Failed to parse book loaded metadata: $e');
          }
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onMediaOverlayStateChanged',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onMediaOverlayStateChanged != null) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          widget.onMediaOverlayStateChanged!(data['state'] as String? ?? 'stopped');
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onMediaOverlayHighlight',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onMediaOverlayHighlight != null) {
          widget.onMediaOverlayHighlight!(Map<String, dynamic>.from(args[0] as Map));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onMediaOverlayUnhighlight',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onMediaOverlayUnhighlight != null) {
          widget.onMediaOverlayUnhighlight!(Map<String, dynamic>.from(args[0] as Map));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onMediaOverlayError',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onMediaOverlayError != null) {
          widget.onMediaOverlayError!(args[0].toString());
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onRelocate',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onRelocate != null) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          widget.onRelocate!(FoliateLocation.fromJson(data));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onSelectionChanged',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onSelectionChanged != null) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          widget.onSelectionChanged!(FoliateSelection.fromJson(data));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onSelectionCleared',
      callback: (args) {
        if (!mounted) return;
        widget.onSelectionCleared?.call();
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onAnnotationClicked',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onAnnotationClicked != null) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          widget.onAnnotationClicked!(FoliateAnnotation.fromJson(data));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onAnnotationAdded',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onAnnotationAdded != null) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          widget.onAnnotationAdded!(FoliateAnnotation.fromJson(data));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onSearchResults',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onSearchResults != null) {
          final rawResults = args[0] as List;
          final results = rawResults
              .map((e) => FoliateSearchResult.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
          widget.onSearchResults!(results);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onError',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty) {
          widget.onError?.call(args[0].toString());
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'onTtsJumpToSentence',
      callback: (args) {
        if (!mounted) return;
        if (args.isNotEmpty && widget.onTtsJumpToSentence != null) {
          widget.onTtsJumpToSentence!(args[0] as int);
        }
      },
    );
  }
}
