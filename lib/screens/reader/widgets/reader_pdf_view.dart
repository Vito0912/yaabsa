import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:yaabsa/screens/reader/widgets/reader_paged_surface.dart';

class ReaderPdfView extends StatefulWidget {
  const ReaderPdfView({
    super.key,
    required this.controller,
    required this.documentUrl,
    required this.requestHeaders,
    this.pdfFile,
    required this.itemId,
    required this.initialPage,
    required this.onPageFocused,
    required this.onTextSelectionChange,
    required this.customizeContextMenuItems,
    required this.buildPageOverlays,
    required this.onGeneralTap,
    required this.onDocumentReady,
    this.onOutlineLoaded,
  });

  final File? pdfFile;

  final PdfViewerController controller;
  final String documentUrl;
  final Map<String, String> requestHeaders;
  final String itemId;
  final int initialPage;
  final ValueChanged<int> onPageFocused;
  final ValueChanged<PdfTextSelection> onTextSelectionChange;
  final void Function(PdfViewerContextMenuBuilderParams, List<ContextMenuButtonItem>) customizeContextMenuItems;
  final PdfPageOverlaysBuilder buildPageOverlays;
  final PdfViewerGeneralTapHandler onGeneralTap;
  final ValueChanged<PdfDocument> onDocumentReady;
  final ValueChanged<List<PdfOutlineNode>?>? onOutlineLoaded;

  @override
  State<ReaderPdfView> createState() => _ReaderPdfViewState();
}

class _ReaderPdfViewState extends State<ReaderPdfView> {
  bool _isSnappingPage = false;
  int? _lastSnappedPage;

  Future<void> _snapToPage(int pageNumber) async {
    if (_isSnappingPage || !widget.controller.isReady || _lastSnappedPage == pageNumber) {
      return;
    }

    _isSnappingPage = true;
    try {
      await widget.controller.goToPage(pageNumber: pageNumber, anchor: PdfPageAnchor.all, duration: Duration.zero);
      _lastSnappedPage = pageNumber;
    } finally {
      _isSnappingPage = false;
    }
  }

  Future<void> _goToPreviousPage() async {
    if (!widget.controller.isReady) {
      return;
    }

    final currentPage = widget.controller.pageNumber;
    if (currentPage == null || currentPage <= 1) {
      return;
    }

    await widget.controller.goToPage(pageNumber: currentPage - 1, anchor: PdfPageAnchor.all);
  }

  Future<void> _goToNextPage() async {
    if (!widget.controller.isReady) {
      return;
    }

    final currentPage = widget.controller.pageNumber;
    final pageCount = widget.controller.pageCount;
    if (currentPage == null || pageCount <= 0 || currentPage >= pageCount) {
      return;
    }

    await widget.controller.goToPage(pageNumber: currentPage + 1, anchor: PdfPageAnchor.all);
  }

  @override
  Widget build(BuildContext context) {
    final isViewerReady = widget.controller.isReady;
    final currentPage = isViewerReady ? widget.controller.pageNumber : null;
    final pageCount = isViewerReady ? widget.controller.pageCount : 0;

    final params = PdfViewerParams(
      backgroundColor: Colors.black,
      pageAnchor: PdfPageAnchor.all,
      pageAnchorEnd: PdfPageAnchor.all,
      // TODO: Check the use of smart
      sizeDelegateProvider: PdfViewerSizeDelegateProviderLegacy(
        calculateInitialZoom: (document, controller, fitZoom, coverZoom) => fitZoom,
      ),
      scrollByMouseWheel: 0.0,
      onViewerReady: (document, controller) async {
        if (!mounted) {
          return;
        }

        setState(() {});
        widget.onDocumentReady(document);
        final page = controller.pageNumber ?? widget.initialPage;
        widget.onPageFocused(page);
        unawaited(_snapToPage(page));

        try {
          final outline = await document.loadOutline();
          widget.onOutlineLoaded?.call(outline);
        } catch (_) {}
      },
      onPageChanged: (pageNumber) {
        if (pageNumber == null || !mounted) {
          return;
        }

        setState(() {});
        widget.onPageFocused(pageNumber);
        unawaited(_snapToPage(pageNumber));
      },
      textSelectionParams: PdfTextSelectionParams(enabled: true, onTextSelectionChange: widget.onTextSelectionChange),
      customizeContextMenuItems: widget.customizeContextMenuItems,
      pageOverlaysBuilder: widget.buildPageOverlays,
      onGeneralTap: widget.onGeneralTap,
      loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
        final double? value;
        final String text;
        if (totalBytes != null && totalBytes > 0) {
          value = bytesDownloaded / totalBytes;
          text = 'Loading PDF... ${(value * 100).toStringAsFixed(0)}%';
        } else {
          value = null;
          text = 'Loading PDF...';
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(value: value, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(text, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        );
      },
    );

    final pdfFile = widget.pdfFile;
    final pdfContent = pdfFile != null
        ? PdfViewer.file(
            pdfFile.path,
            key: ValueKey<String>('pdf-file-${widget.itemId}'),
            controller: widget.controller,
            initialPageNumber: widget.initialPage,
            params: params,
          )
        : PdfViewer.uri(
            Uri.parse(widget.documentUrl),
            key: ValueKey<String>('pdf-${widget.itemId}'),
            headers: widget.requestHeaders,
            controller: widget.controller,
            initialPageNumber: widget.initialPage,
            params: params,
          );

    return ReaderPagedSurface(
      content: pdfContent,
      onPreviousPage: _goToPreviousPage,
      onNextPage: _goToNextPage,
      canGoPrevious: isViewerReady && (currentPage ?? 1) > 1,
      canGoNext: isViewerReady && pageCount > 0 && currentPage != null && currentPage < pageCount,
      interceptPointerScrollForPaging: true,
    );
  }
}
