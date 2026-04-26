part of 'reader.dart';

extension _ReaderPdfHelpers on _ReaderState {
  Future<void> _clearPdfSelectionInViewer() async {
    if (!_pdfController.isReady) {
      return;
    }

    try {
      await _pdfController.textSelectionDelegate.clearTextSelection();
    } catch (_) {}
  }

  void _clearPdfSelection() {
    if (!mounted) {
      return;
    }

    _readerSetState(() {
      _selectedPdfRanges = const <PdfPageTextRange>[];
    });
  }

  Future<void> _onPdfTextSelectionChange(PdfTextSelection textSelection) async {
    if (!textSelection.hasSelectedText) {
      _clearPdfSelection();
      return;
    }

    final ranges = await textSelection.getSelectedTextRanges();

    if (!mounted) {
      return;
    }

    _readerSetState(() {
      _selectedPdfRanges = ranges;
    });
  }

  Future<bool> _togglePdfAnnotationsFromRanges({
    required List<PdfPageTextRange> ranges,
    required AnnotationType type,
    required Color color,
    required double opacity,
    String? noteText,
    double? thickness,
    bool toggleIfExisting = true,
  }) async {
    final nonEmptyRanges = ranges.where((range) => range.start < range.end).toList();
    if (nonEmptyRanges.isEmpty) {
      _showSnackBar('Please select some text first');
      return false;
    }

    final colorValue = _colorToHex(color, allowNone: true);
    final entries = nonEmptyRanges
        .map(
          (range) => PdfAnnotationEntry.fromRange(
            type: type,
            range: range,
            color: colorValue,
            opacity: opacity,
            noteText: noteText,
            thickness: thickness,
          ),
        )
        .toList(growable: false);

    final existingIds = _pdfAnnotations.map((entry) => entry.cfi).toSet();
    final allAlreadyPresent = entries.every((entry) => existingIds.contains(entry.cfi));

    if (!mounted) {
      return false;
    }

    bool didChange = false;
    _readerSetState(() {
      if (toggleIfExisting && allAlreadyPresent) {
        final removeIds = entries.map((entry) => entry.cfi).toSet();
        final previousLength = _pdfAnnotations.length;
        _pdfAnnotations = _pdfAnnotations.where((entry) => !removeIds.contains(entry.cfi)).toList(growable: false);
        didChange = _pdfAnnotations.length != previousLength;
        if (didChange && _activePdfAnnotationCfi != null && removeIds.contains(_activePdfAnnotationCfi)) {
          _activePdfAnnotationCfi = null;
        }
        if (didChange && _hoveredPdfAnnotationCfi != null && removeIds.contains(_hoveredPdfAnnotationCfi)) {
          _hoveredPdfAnnotationCfi = null;
        }
        return;
      }

      final updated = List<PdfAnnotationEntry>.from(_pdfAnnotations);
      for (final entry in entries) {
        final index = updated.indexWhere((candidate) => candidate.cfi == entry.cfi);
        if (index >= 0) {
          if (updated[index] != entry) {
            updated[index] = entry;
            didChange = true;
          }
        } else {
          updated.add(entry);
          didChange = true;
        }
      }
      _pdfAnnotations = updated;
    });

    return didChange;
  }

  Future<void> _togglePdfHighlight(Color color) async {
    _lastHighlightColor = color;

    final didChange = await _togglePdfAnnotationsFromRanges(
      ranges: _selectedPdfRanges,
      type: AnnotationType.highlight,
      color: color,
      opacity: 0.35,
    );
    await _clearPdfSelectionInViewer();
    _clearPdfSelection();

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  Future<void> _togglePdfUnderline(Color color, double thickness) async {
    _lastUnderlineColor = color;
    _lastUnderlineThickness = thickness;

    final didChange = await _togglePdfAnnotationsFromRanges(
      ranges: _selectedPdfRanges,
      type: AnnotationType.underline,
      color: color,
      opacity: 1.0,
      thickness: thickness,
    );
    await _clearPdfSelectionInViewer();
    _clearPdfSelection();

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  Future<void> _createPdfBookmarkFromSelection({required Color color, List<PdfPageTextRange>? selectedRanges}) async {
    final ranges = selectedRanges ?? _selectedPdfRanges;
    if (ranges.isEmpty) {
      _showSnackBar('Please select some text first');
      return;
    }

    _lastBookmarkColor = color;

    final noteText = await _promptPdfBookmarkText(title: 'Bookmark note');
    if (noteText == null) {
      return;
    }

    final didChange = await _togglePdfAnnotationsFromRanges(
      ranges: ranges,
      type: AnnotationType.bookmark,
      color: color,
      opacity: 0.28,
      noteText: noteText,
      toggleIfExisting: false,
    );

    await _clearPdfSelectionInViewer();
    _clearPdfSelection();

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  Future<String?> _promptPdfBookmarkText({String? initialText, String title = 'Bookmark note'}) async {
    final controller = TextEditingController(text: initialText ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final theme = Theme.of(dialogContext);

        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: Text(title),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            minLines: 1,
            decoration: const InputDecoration(labelText: 'Text', hintText: 'Add an optional note'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(null);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();
    return result;
  }

  Future<void> _addPdfBookmarkFromDelegate({required PdfTextSelectionDelegate delegate}) async {
    final ranges = await delegate.getSelectedTextRanges();

    await delegate.clearTextSelection();
    _clearPdfSelection();

    if (!mounted) {
      return;
    }

    await _createPdfBookmarkFromSelection(color: _lastBookmarkColor, selectedRanges: ranges);
  }

  Future<void> _applyPdfAnnotationFromDelegate({
    required PdfTextSelectionDelegate delegate,
    required AnnotationType type,
    required Color color,
    required double opacity,
    double? thickness,
  }) async {
    final ranges = await delegate.getSelectedTextRanges();

    final didChange = await _togglePdfAnnotationsFromRanges(
      ranges: ranges,
      type: type,
      color: color,
      opacity: opacity,
      thickness: thickness,
    );

    await delegate.clearTextSelection();
    _clearPdfSelection();

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  void _customizePdfContextMenuItems(PdfViewerContextMenuBuilderParams params, List<ContextMenuButtonItem> items) {
    if (!params.isTextSelectionEnabled) {
      return;
    }

    items.add(
      ContextMenuButtonItem(
        label: 'Highlight',
        onPressed: () {
          params.dismissContextMenu();
          _applyPdfAnnotationFromDelegate(
            delegate: params.textSelectionDelegate,
            type: AnnotationType.highlight,
            color: _lastHighlightColor,
            opacity: 0.35,
          );
        },
      ),
    );

    items.add(
      ContextMenuButtonItem(
        label: 'Underline',
        onPressed: () {
          params.dismissContextMenu();
          _applyPdfAnnotationFromDelegate(
            delegate: params.textSelectionDelegate,
            type: AnnotationType.underline,
            color: _lastUnderlineColor,
            opacity: 1.0,
            thickness: _lastUnderlineThickness,
          );
        },
      ),
    );

    items.add(
      ContextMenuButtonItem(
        label: 'Bookmark',
        onPressed: () {
          params.dismissContextMenu();
          _addPdfBookmarkFromDelegate(delegate: params.textSelectionDelegate);
        },
      ),
    );
  }

  bool _onPdfViewerGeneralTap(
    BuildContext context,
    PdfViewerController controller,
    PdfViewerGeneralTapHandlerDetails details,
  ) {
    if (_activePdfAnnotationCfi == null) {
      return false;
    }

    _readerSetState(() {
      _activePdfAnnotationCfi = null;
    });
    return false;
  }

  void _setHoveredPdfAnnotation(String? cfi) {
    if (_hoveredPdfAnnotationCfi == cfi) {
      return;
    }

    _readerSetState(() {
      _hoveredPdfAnnotationCfi = cfi;
    });
  }

  void _toggleActivePdfAnnotation(String cfi) {
    _readerSetState(() {
      _activePdfAnnotationCfi = _activePdfAnnotationCfi == cfi ? null : cfi;
    });
  }

  void _removePdfAnnotation(String cfi) {
    bool didChange = false;
    _readerSetState(() {
      final previousLength = _pdfAnnotations.length;
      _pdfAnnotations = _pdfAnnotations.where((annotation) => annotation.cfi != cfi).toList(growable: false);
      didChange = _pdfAnnotations.length != previousLength;

      if (_activePdfAnnotationCfi == cfi) {
        _activePdfAnnotationCfi = null;
      }
      if (_hoveredPdfAnnotationCfi == cfi) {
        _hoveredPdfAnnotationCfi = null;
      }
    });

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  Future<void> _editPdfBookmark(PdfAnnotationEntry annotation) async {
    if (annotation.type != AnnotationType.bookmark) {
      return;
    }

    final updatedText = await _promptPdfBookmarkText(initialText: annotation.noteText, title: 'Edit bookmark');
    if (updatedText == null) {
      return;
    }

    bool didChange = false;
    _readerSetState(() {
      final index = _pdfAnnotations.indexWhere((entry) => entry.cfi == annotation.cfi);
      if (index < 0) {
        return;
      }

      final normalizedText = updatedText.trim();
      final previous = _pdfAnnotations[index];
      final merged = previous.copyWith(noteText: normalizedText.isEmpty ? null : normalizedText);
      if (previous.noteText == merged.noteText) {
        return;
      }

      final updatedList = List<PdfAnnotationEntry>.from(_pdfAnnotations);
      updatedList[index] = merged;
      _pdfAnnotations = updatedList;
      didChange = true;
    });

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  List<Rect> _annotationRectsInLocalPage(PdfAnnotationEntry annotation, PdfPage page, Rect pageRectInViewer) {
    return annotation.rects
        .map((pdfRect) => pdfRect.toRectInDocument(page: page, pageRect: pageRectInViewer))
        .where((rect) => rect.isFinite && !rect.isEmpty)
        .map((rect) => rect.shift(-pageRectInViewer.topLeft))
        .toList(growable: false);
  }

  Rect _annotationBounds(List<Rect> rects) {
    Rect bounds = rects.first;
    for (final rect in rects.skip(1)) {
      bounds = bounds.expandToInclude(rect);
    }

    return bounds;
  }

  Widget _buildPdfAnnotationMarker({required PdfAnnotationEntry annotation, required bool isHovered}) {
    final fallback = switch (annotation.type) {
      AnnotationType.highlight => Colors.yellow,
      AnnotationType.underline => Colors.blue,
      AnnotationType.bookmark => Colors.yellow,
    };
    final baseColor = _parseStoredColor(annotation.color, fallback: fallback);

    final Widget marker = switch (annotation.type) {
      AnnotationType.highlight => DecoratedBox(
        decoration: BoxDecoration(
          color: _applyOpacity(baseColor, (annotation.opacity + (isHovered ? 0.22 : 0.0)).clamp(0.0, 1.0).toDouble()),
        ),
      ),
      AnnotationType.bookmark => DecoratedBox(
        decoration: BoxDecoration(
          color: _applyOpacity(baseColor, (annotation.opacity + (isHovered ? 0.25 : 0.0)).clamp(0.0, 1.0).toDouble()),
        ),
      ),
      AnnotationType.underline => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: (annotation.thickness ?? 2.0) + (isHovered ? 1.2 : 0.0),
          color: _applyOpacity(baseColor, 0.98),
        ),
      ),
    };

    final interactiveMarker = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHoveredPdfAnnotation(annotation.cfi),
      onExit: (_) => _setHoveredPdfAnnotation(null),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => _toggleActivePdfAnnotation(annotation.cfi),
        child: marker,
      ),
    );

    if (annotation.type != AnnotationType.bookmark) {
      return interactiveMarker;
    }

    final noteText = annotation.noteText?.trim();
    return Tooltip(
      message: (noteText == null || noteText.isEmpty) ? 'Bookmark' : noteText,
      waitDuration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(color: Colors.black.withAlpha(230), borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(color: Colors.white),
      child: interactiveMarker,
    );
  }

  Widget _buildPdfAnnotationActions({
    required BuildContext context,
    required PdfAnnotationEntry annotation,
    required Rect annotationBounds,
    required Size pageSize,
  }) {
    final showEdit = annotation.type == AnnotationType.bookmark;
    final toolbarWidth = showEdit ? 72.0 : 40.0;
    const toolbarHeight = 34.0;
    const horizontalPadding = 4.0;
    const verticalPadding = 4.0;

    final maxLeft = (pageSize.width - toolbarWidth - horizontalPadding).clamp(horizontalPadding, double.infinity);
    final maxTop = (pageSize.height - toolbarHeight - verticalPadding).clamp(verticalPadding, double.infinity);
    final left = (annotationBounds.right - toolbarWidth).clamp(horizontalPadding, maxLeft).toDouble();
    final top = (annotationBounds.top - toolbarHeight - 6).clamp(verticalPadding, maxTop).toDouble();

    return Positioned(
      left: left,
      top: top,
      child: Material(
        color: Colors.transparent,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(212),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
          ),
          child: TooltipTheme(
            data: const TooltipThemeData(
              decoration: BoxDecoration(color: Color(0xEE000000), borderRadius: BorderRadius.all(Radius.circular(8))),
              textStyle: TextStyle(color: Colors.white),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showEdit)
                  IconButton(
                    tooltip: 'Edit bookmark',
                    iconSize: 18,
                    color: Colors.white,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => _editPdfBookmark(annotation),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                IconButton(
                  tooltip: 'Delete annotation',
                  iconSize: 18,
                  color: Colors.white,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _removePdfAnnotation(annotation.cfi),
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPdfPageOverlays(BuildContext context, Rect pageRectInViewer, PdfPage page) {
    final overlays = <Widget>[];
    final annotationsForPage = _pdfAnnotations.where((annotation) => annotation.pageNumber == page.pageNumber);

    for (final annotation in annotationsForPage) {
      final localRects = _annotationRectsInLocalPage(annotation, page, pageRectInViewer);
      if (localRects.isEmpty) {
        continue;
      }

      final isHovered = _hoveredPdfAnnotationCfi == annotation.cfi;
      final isActive = _activePdfAnnotationCfi == annotation.cfi;

      for (int index = 0; index < localRects.length; index++) {
        final localRect = localRects[index];
        overlays.add(
          Positioned(
            key: ValueKey<String>('${annotation.cfi}-$index'),
            left: localRect.left,
            top: localRect.top,
            width: localRect.width,
            height: localRect.height,
            child: _buildPdfAnnotationMarker(annotation: annotation, isHovered: isHovered),
          ),
        );
      }

      if (!isActive) {
        continue;
      }

      overlays.add(
        _buildPdfAnnotationActions(
          context: context,
          annotation: annotation,
          annotationBounds: _annotationBounds(localRects),
          pageSize: pageRectInViewer.size,
        ),
      );
    }

    return overlays;
  }
}
