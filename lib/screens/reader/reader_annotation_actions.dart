part of 'reader.dart';

extension _ReaderAnnotationActions on _ReaderState {
  Color _readerSheetColor(BuildContext context) {
    return Theme.of(context).colorScheme.surfaceContainerLow;
  }

  void _showAnnotationsList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _readerSheetColor(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => ReaderEpubAnnotationsListView(epubController: epubController),
    );
  }

  void _showPdfAnnotationsList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _readerSheetColor(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => ReaderPdfAnnotationsListView(
        annotations: _pdfAnnotations,
        onRemove: (annotation) {
          _removePdfAnnotation(annotation.cfi);
        },
        onEdit: _editPdfBookmark,
      ),
    );
  }

  void _showColorPicker({
    required AnnotationType annotationType,
    required bool isEpubMode,
    List<PdfPageTextRange>? selectedPdfRanges,
  }) {
    final hasSelection = isEpubMode
        ? _hasValidEpubSelection
        : (selectedPdfRanges == null ? _hasValidPdfSelection : selectedPdfRanges.isNotEmpty);
    if (!hasSelection) {
      _showSnackBar('Please select some text first');
      return;
    }

    final bool isHighlightLike =
        annotationType == AnnotationType.highlight || annotationType == AnnotationType.bookmark;
    final String title = switch (annotationType) {
      AnnotationType.highlight => 'Select Highlight Color',
      AnnotationType.underline => 'Select Underline Color',
      AnnotationType.bookmark => 'Select Bookmark Color',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: _readerSheetColor(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => ReaderColorPickerSheet(
        title: title,
        colors: isHighlightLike ? _kHighlightColors.sublist(0, _kHighlightColors.length - 1) : _kHighlightColors,
        onColorSelected: (color) {
          Navigator.pop(context);
          if (annotationType == AnnotationType.highlight) {
            if (isEpubMode) {
              _toggleHighlight(_selectedCfi!, color);
            } else {
              _togglePdfHighlight(color);
            }
            return;
          }

          if (annotationType == AnnotationType.underline) {
            _showThicknessPicker(color: color, isEpubMode: isEpubMode);
            return;
          }

          if (isEpubMode) {
            _showSnackBar('Bookmark notes are currently available in PDF mode only.');
            return;
          }

          _createPdfBookmarkFromSelection(color: color, selectedRanges: selectedPdfRanges);
        },
      ),
    );
  }

  void _showThicknessPicker({required Color color, required bool isEpubMode}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _readerSheetColor(context),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => ReaderThicknessPickerSheet(
        color: color,
        thicknesses: _kUnderlineThickness,
        onThicknessSelected: (thickness) {
          Navigator.pop(context);
          if (isEpubMode) {
            _toggleUnderline(_selectedCfi!, color, thickness);
          } else {
            _togglePdfUnderline(color, thickness);
          }
        },
      ),
    );
  }

  Future<void> _toggleHighlight(String cfi, Color color) async {
    bool didChange = false;
    try {
      final highlights = await epubController.getHighlights();
      final existingHighlight = highlights.where((h) => h.cfi == cfi).firstOrNull;

      if (existingHighlight != null) {
        epubController.removeHighlight(cfi);
        didChange = true;
      } else {
        epubController.addHighlight(EpubHighlight(cfi: cfi, text: '', color: _colorToHex(color), opacity: 0.5));
        didChange = true;
      }
    } catch (e) {
      _showSnackBar('Error toggling highlight: $e');
    }

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: true);
    }

    _clearSelection();
  }

  Future<void> _toggleUnderline(String cfi, Color color, double thickness) async {
    bool didChange = false;
    try {
      final underlines = await epubController.getUnderlines();
      final existingUnderline = underlines.where((u) => u.cfi == cfi).firstOrNull;

      if (existingUnderline != null) {
        epubController.removeUnderline(cfi);
        didChange = true;
      } else {
        epubController.addUnderline(
          EpubUnderline(
            cfi: cfi,
            text: '',
            color: _colorToHex(color, allowNone: true),
            opacity: 1.0,
            thickness: thickness,
          ),
        );
        didChange = true;
      }
    } catch (e) {
      _showSnackBar('Error toggling underline: $e');
    }

    if (didChange) {
      _scheduleAutoAnnotationSync(isEpubMode: true);
    }

    _clearSelection();
  }

  void _clearSelection() {
    _readerSetState(() {
      _selectedCfi = null;
      _selectedText = null;
    });
  }
}
