import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foliate_reader/foliate_reader.dart';
import 'package:yaabsa/screens/reader/widgets/reader_paged_surface.dart';

class ReaderEpubView extends StatelessWidget {
  const ReaderEpubView({
    super.key,
    required this.controller,
    required this.bookUrl,
    this.bookFile,
    this.bookExtension,
    required this.headers,
    required this.initialCfi,
    this.initialStyles,
    required this.flow,
    required this.maxColumnCount,
    required this.onRelocated,
    required this.onBookLoaded,
    required this.onSelectionChanged,
    required this.onSelectionCleared,
    required this.onAnnotationClicked,
    required this.onAnnotationAdded,
    required this.onError,
    required this.onCenterTap,
    this.onTtsJumpToSentence,
    this.onMediaOverlayStateChanged,
    this.onMediaOverlayHighlight,
    this.onMediaOverlayUnhighlight,
    this.onMediaOverlayError,
    this.bookFetcher,
  });

  final Future<void> Function(String url, Map<String, String>? headers, HttpRequest request)? bookFetcher;

  final FoliateViewerController controller;
  final String bookUrl;
  final File? bookFile;
  final String? bookExtension;
  final Map<String, String>? headers;
  final String? initialCfi;
  final String? initialStyles;
  final String flow;
  final int maxColumnCount;
  final ValueChanged<FoliateLocation> onRelocated;
  final void Function(
    FoliateMetadata metadata,
    List<FoliateTOCItem> toc,
    List<FoliateTOCItem> pageList,
    String dir,
    bool hasMediaOverlays,
  )
  onBookLoaded;
  final ValueChanged<FoliateSelection> onSelectionChanged;
  final VoidCallback onSelectionCleared;
  final ValueChanged<FoliateAnnotation> onAnnotationClicked;
  final ValueChanged<FoliateAnnotation> onAnnotationAdded;
  final ValueChanged<String> onError;
  final VoidCallback onCenterTap;
  final ValueChanged<int>? onTtsJumpToSentence;
  final void Function(String state)? onMediaOverlayStateChanged;
  final void Function(Map<String, dynamic> detail)? onMediaOverlayHighlight;
  final void Function(Map<String, dynamic> detail)? onMediaOverlayUnhighlight;
  final void Function(String error)? onMediaOverlayError;

  Future<void> _goToPreviousPage() async {
    await controller.prev();
  }

  Future<void> _goToNextPage() async {
    await controller.next();
  }

  @override
  Widget build(BuildContext context) {
    return ReaderPagedSurface(
      content: FoliateViewer(
        controller: controller,
        bookUrl: bookUrl,
        bookFile: bookFile,
        bookExtension: bookExtension,
        headers: headers,
        initialCfi: initialCfi,
        initialStyles: initialStyles,
        flow: flow,
        maxColumnCount: maxColumnCount,
        onRelocate: onRelocated,
        onBookLoaded: onBookLoaded,
        onSelectionChanged: onSelectionChanged,
        onSelectionCleared: onSelectionCleared,
        onAnnotationClicked: onAnnotationClicked,
        onAnnotationAdded: onAnnotationAdded,
        onError: onError,
        onCenterTap: onCenterTap,
        onTtsJumpToSentence: onTtsJumpToSentence,
        onMediaOverlayStateChanged: onMediaOverlayStateChanged,
        onMediaOverlayHighlight: onMediaOverlayHighlight,
        onMediaOverlayUnhighlight: onMediaOverlayUnhighlight,
        onMediaOverlayError: onMediaOverlayError,
        bookFetcher: bookFetcher,
      ),
      onPreviousPage: _goToPreviousPage,
      onNextPage: _goToNextPage,
      canGoPrevious: true,
      canGoNext: true,
      interceptPointerScrollForPaging: true,
    );
  }
}
