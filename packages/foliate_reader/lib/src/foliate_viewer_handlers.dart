part of 'foliate_viewer.dart';

extension _FoliateViewerHandlers on _FoliateViewerState {
  ContextMenu? get _selectionContextMenu {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return null;
    }

    return ContextMenu(
      menuItems: [
        ContextMenuItem(
          id: 1,
          title: 'Highlight',
          action: () => unawaited(_addAnnotationFromSelection('highlight', '#FFEB3B')),
        ),
        ContextMenuItem(
          id: 2,
          title: 'Underline',
          action: () => unawaited(_addAnnotationFromSelection('underline', '#2196F3')),
        ),
        ContextMenuItem(id: 3, title: 'Copy', action: () => unawaited(_copyWebViewSelection())),
      ],
      settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: true),
    );
  }

  Future<void> _copyWebViewSelection() async {
    final text = await widget.controller?._webViewController?.getSelectedText();
    if (text == null || text.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> _addAnnotationFromSelection(String type, String color) async {
    await widget.controller?._webViewController?.evaluateJavascript(
      source: 'window.FoliateReaderAPI.addAnnotationFromSelection(${jsonEncode(type)}, ${jsonEncode(color)}, "");',
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
        _markBookLoaded();
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
          } catch (e, s) {
            _diagnostics.failure('Failed to parse book loaded metadata', error: e, stackTrace: s);
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
        if (args.isNotEmpty) {
          final data = Map<String, dynamic>.from(args[0] as Map);
          final selection = FoliateSelection.fromJson(data);
          widget.onSelectionChanged?.call(selection);
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
          _reportLoadError(
            args[0].toString(),
            stackTrace: args.length > 1 && args[1] is String && (args[1] as String).isNotEmpty
                ? StackTrace.fromString(args[1] as String)
                : null,
          );
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
