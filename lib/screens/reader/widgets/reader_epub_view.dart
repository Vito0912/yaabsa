import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:yaabsa/screens/reader/widgets/reader_paged_surface.dart';

class ReaderEpubView extends StatelessWidget {
  const ReaderEpubView({
    super.key,
    required this.epubController,
    required this.epubSource,
    required this.initialCfi,
    required this.onRelocated,
    required this.onTextSelected,
  });

  final EpubController epubController;
  final EpubSource epubSource;
  final String? initialCfi;
  final ValueChanged<EpubLocation> onRelocated;
  final ValueChanged<EpubTextSelection> onTextSelected;

  Future<void> _goToPreviousPage() async {
    epubController.prev();
  }

  Future<void> _goToNextPage() async {
    epubController.next();
  }

  @override
  Widget build(BuildContext context) {
    return ReaderPagedSurface(
      content: EpubViewer(
        epubController: epubController,
        epubSource: epubSource,
        initialCfi: initialCfi,
        displaySettings: EpubDisplaySettings(
          flow: EpubFlow.paginated,
          snap: true,
          spread: EpubSpread.auto,
          useSnapAnimationAndroid: true,
          theme: EpubTheme(themeType: EpubThemeType.dark),
        ),
        onRelocated: onRelocated,
        onTextSelected: onTextSelected,
      ),
      onPreviousPage: _goToPreviousPage,
      onNextPage: _goToNextPage,
      canGoPrevious: true,
      canGoNext: true,
      interceptPointerScrollForPaging: true,
    );
  }
}
