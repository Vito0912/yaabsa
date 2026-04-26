import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:yaabsa/screens/reader/widgets/reader_annotation_tile.dart';

class ReaderEpubAnnotationsListView extends StatefulWidget {
  const ReaderEpubAnnotationsListView({super.key, required this.epubController});

  final EpubController epubController;

  @override
  State<ReaderEpubAnnotationsListView> createState() => _ReaderEpubAnnotationsListViewState();
}

class _ReaderEpubAnnotationsListViewState extends State<ReaderEpubAnnotationsListView> {
  List<EpubHighlight> highlights = [];
  List<EpubUnderline> underlines = [];
  List<EpubBookmark> bookmarks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnnotations();
  }

  Future<void> _loadAnnotations() async {
    try {
      final highlightsList = await widget.epubController.getHighlights();
      final underlinesList = await widget.epubController.getUnderlines();
      final bookmarksList = await widget.epubController.getBookmarks();

      if (!mounted) {
        return;
      }

      setState(() {
        highlights = highlightsList;
        underlines = underlinesList;
        bookmarks = bookmarksList;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _removeHighlight(String cfi) async {
    try {
      widget.epubController.removeHighlight(cfi);
      setState(() {
        highlights.removeWhere((h) => h.cfi == cfi);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Highlight removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing highlight: $e')));
    }
  }

  Future<void> _removeUnderline(String cfi) async {
    try {
      widget.epubController.removeUnderline(cfi);
      setState(() {
        underlines.removeWhere((u) => u.cfi == cfi);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Underline removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing underline: $e')));
    }
  }

  Future<void> _removeBookmark(String cfi) async {
    try {
      await widget.epubController.removeBookmark(cfi: cfi);
      setState(() {
        bookmarks.removeWhere((bookmark) => bookmark.cfi == cfi);
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bookmark removed')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error removing bookmark: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoading) {
      return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    }

    final hasAnnotations = highlights.isNotEmpty || underlines.isNotEmpty || bookmarks.isNotEmpty;

    Widget sectionTitle(String title) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Annotations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
          ),
          if (!hasAnnotations)
            Expanded(
              child: Center(
                child: Text('No annotations found', style: TextStyle(color: colorScheme.onSurfaceVariant)),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  if (highlights.isNotEmpty) ...[
                    sectionTitle('Highlights'),
                    ...highlights.map(
                      (highlight) => ReaderAnnotationTile(
                        type: 'Highlight',
                        cfi: highlight.cfi,
                        color: highlight.color,
                        onRemove: () => _removeHighlight(highlight.cfi),
                      ),
                    ),
                  ],
                  if (underlines.isNotEmpty) ...[
                    sectionTitle('Underlines'),
                    ...underlines.map(
                      (underline) => ReaderAnnotationTile(
                        type: 'Underline',
                        cfi: underline.cfi,
                        color: underline.color,
                        thickness: underline.thickness,
                        onRemove: () => _removeUnderline(underline.cfi),
                      ),
                    ),
                  ],
                  if (bookmarks.isNotEmpty) ...[
                    sectionTitle('Bookmarks'),
                    ...bookmarks.map((bookmark) {
                      final title = bookmark.title.trim();
                      return ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: Text(
                          title.isEmpty ? 'Untitled bookmark' : title,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          'CFI: ${bookmark.cfi.length > 30 ? '${bookmark.cfi.substring(0, 30)}...' : bookmark.cfi}',
                          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeBookmark(bookmark.cfi),
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
