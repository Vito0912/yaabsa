part of 'reader.dart';

extension _ReaderBuilders on _ReaderState {
  AppBar _buildAppBar({required bool isEpubMode}) {
    final hasSelection = isEpubMode ? _hasValidEpubSelection : _hasValidPdfSelection;

    return AppBar(
      title: const Text('Ebook Reader'),
      actions: [
        IconButton(
          icon: Icon(Icons.highlight, color: hasSelection ? Colors.yellow : Colors.grey),
          onPressed: () => _showColorPicker(annotationType: AnnotationType.highlight, isEpubMode: isEpubMode),
          tooltip: 'Highlight',
        ),
        IconButton(
          icon: Icon(Icons.format_underlined, color: hasSelection ? Colors.blue : Colors.grey),
          onPressed: () => _showColorPicker(annotationType: AnnotationType.underline, isEpubMode: isEpubMode),
          tooltip: 'Underline',
        ),
        if (!isEpubMode)
          IconButton(
            icon: Icon(Icons.bookmark_add_outlined, color: hasSelection ? Colors.amber : Colors.grey),
            onPressed: () => _showColorPicker(annotationType: AnnotationType.bookmark, isEpubMode: false),
            tooltip: 'Bookmark',
          ),
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: isEpubMode ? _showAnnotationsList : _showPdfAnnotationsList,
          tooltip: 'View Annotations',
        ),
      ],
    );
  }

  Widget _buildEpubReaderBody({required User user, required String authToken, required String? initialCfi}) {
    final EpubSource epubSource = EpubSource.fromUrl(
      _ebookUrl(user),
      headers: {'Authorization': 'Bearer $authToken'},
      isCachedToLocal: false,
    );

    return ReaderEpubView(
      epubController: epubController,
      epubSource: epubSource,
      initialCfi: initialCfi,
      onRelocated: _onEpubRelocated,
      onTextSelected: (text) {
        _readerSetState(() {
          _selectedCfi = text.selectionCfi;
          _selectedText = text.selectedText;
        });
      },
    );
  }

  Widget _buildPdfReaderBody({required User user, required String authToken, required String? initialLocation}) {
    final int initialPage = _parseStoredPdfPage(initialLocation);
    _triggerAutoAnnotationLoadIfNeeded(isEpubMode: false);

    return ReaderPdfView(
      controller: _pdfController,
      documentUrl: _ebookUrl(user),
      authToken: authToken,
      itemId: widget.itemId,
      initialPage: initialPage,
      onPageFocused: (pageNumber) => _syncPdfProgress(pageNumber: pageNumber),
      onTextSelectionChange: _onPdfTextSelectionChange,
      customizeContextMenuItems: _customizePdfContextMenuItems,
      buildPageOverlays: _buildPdfPageOverlays,
      onGeneralTap: _onPdfViewerGeneralTap,
    );
  }
}
