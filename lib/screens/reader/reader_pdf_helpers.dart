part of 'reader.dart';

extension _ReaderPdfHelpers on _ReaderState {
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
  }

  bool _onPdfViewerGeneralTap(
    BuildContext context,
    PdfViewerController controller,
    PdfViewerGeneralTapHandlerDetails details,
  ) {
    _toggleSystemUi();
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

  void _removePdfAnnotation(String cfi) {
    bool didChange = false;
    _readerSetState(() {
      final previousLength = _pdfAnnotations.length;
      _pdfAnnotations = _pdfAnnotations.where((annotation) => annotation.cfi != cfi).toList(growable: false);
      didChange = _pdfAnnotations.length != previousLength;

      if (_hoveredPdfAnnotationCfi == cfi) {
        _hoveredPdfAnnotationCfi = null;
      }
    });

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: false);
    }
  }

  Future<void> _editPdfAnnotation(PdfAnnotationEntry annotation, {String? noteText, String? color}) async {
    bool didChange = false;
    _readerSetState(() {
      final index = _pdfAnnotations.indexWhere((entry) => entry.cfi == annotation.cfi);
      if (index < 0) {
        return;
      }

      final previous = _pdfAnnotations[index];
      final merged = previous.copyWith(
        noteText: noteText != null ? (noteText.trim().isNotEmpty ? noteText.trim() : null) : previous.noteText,
        color: color ?? previous.color,
      );

      if (previous.noteText == merged.noteText && previous.color == merged.color) {
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

  void _showPdfAnnotationEditSheet(PdfAnnotationEntry annotation) {
    final noteController = TextEditingController(text: annotation.noteText ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: noteController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(labelText: 'Note', hintText: 'Add an optional note'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [Colors.yellow, Colors.green, Colors.blue, Colors.pink, Colors.purple].map((c) {
                  final hex = _colorToHex(c);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(bottomSheetContext);
                      unawaited(_editPdfAnnotation(annotation, noteText: noteController.text, color: hex));
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      unawaited(_editPdfAnnotation(annotation, noteText: noteController.text));
                    },
                    child: const Text('Save'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(bottomSheetContext);
                      _removePdfAnnotation(annotation.cfi);
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Delete'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  List<Rect> _annotationRectsInLocalPage(PdfAnnotationEntry annotation, PdfPage page, Rect pageRectInViewer) {
    return annotation.rects
        .map((pdfRect) => pdfRect.toRectInDocument(page: page, pageRect: pageRectInViewer))
        .where((rect) => rect.isFinite && !rect.isEmpty)
        .map((rect) => rect.shift(-pageRectInViewer.topLeft))
        .toList(growable: false);
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
        onTap: () => _showPdfAnnotationEditSheet(annotation),
        child: marker,
      ),
    );

    final noteText = annotation.noteText?.trim();
    if (noteText != null && noteText.isNotEmpty) {
      return Tooltip(
        message: noteText,
        waitDuration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(color: Colors.black.withAlpha(230), borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(color: Colors.white),
        child: interactiveMarker,
      );
    }
    return interactiveMarker;
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
    }

    return overlays;
  }
}
