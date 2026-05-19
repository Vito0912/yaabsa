import 'package:flutter/material.dart';
import 'package:yaabsa/models/internal_annotation.dart';
import 'package:yaabsa/screens/reader/models/pdf_annotation_entry.dart';

import 'package:yaabsa/generated/l10n.dart';

class ReaderPdfAnnotationsListView extends StatelessWidget {
  const ReaderPdfAnnotationsListView({super.key, required this.annotations, required this.onRemove, this.onEdit});

  final List<PdfAnnotationEntry> annotations;
  final ValueChanged<PdfAnnotationEntry> onRemove;
  final ValueChanged<PdfAnnotationEntry>? onEdit;

  Color _parseColor(String colorStr) {
    if (colorStr == 'none') {
      return Colors.transparent;
    }
    if (colorStr.startsWith('#') && colorStr.length == 7) {
      final parsed = int.tryParse(colorStr.substring(1), radix: 16);
      if (parsed != null) {
        return Color(0xFF000000 | parsed);
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final highlights = annotations.where((annotation) => annotation.type == AnnotationType.highlight).toList();
    final underlines = annotations.where((annotation) => annotation.type == AnnotationType.underline).toList();
    final bookmarks = annotations.where((annotation) => annotation.type == AnnotationType.bookmark).toList();
    final colorScheme = Theme.of(context).colorScheme;

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
              S.current.screensReaderWidgetsReaderPdfAnnotationsListViewAnnotations,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
            ),
          ),
          if (annotations.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  S.current.screensReaderWidgetsReaderPdfAnnotationsListViewNoAnnotationsFound,
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  if (highlights.isNotEmpty) ...[
                    sectionTitle('Highlights'),
                    ...highlights.map((annotation) {
                      final color = _parseColor(annotation.color);
                      return ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                        ),
                        title: Text(
                          S.current.screensReaderWidgetsReaderPdfAnnotationsListViewPage(annotation.pageNumber),
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          S.current.screensReaderWidgetsReaderPdfAnnotationsListViewRange(
                            annotation.start,
                            annotation.end,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => onRemove(annotation),
                        ),
                      );
                    }),
                  ],
                  if (underlines.isNotEmpty) ...[
                    sectionTitle('Underlines'),
                    ...underlines.map((annotation) {
                      final color = _parseColor(annotation.color);
                      final thickness = annotation.thickness ?? 2.0;
                      return ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: color, width: thickness),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        title: Text(
                          S.current.screensReaderWidgetsReaderPdfAnnotationsListViewPagePx(
                            annotation.pageNumber,
                            thickness.toInt(),
                          ),
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          S.current.screensReaderWidgetsReaderPdfAnnotationsListViewRange(
                            annotation.start,
                            annotation.end,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => onRemove(annotation),
                        ),
                      );
                    }),
                  ],
                  if (bookmarks.isNotEmpty) ...[
                    sectionTitle('Bookmarks'),
                    ...bookmarks.map((annotation) {
                      final color = _parseColor(annotation.color);
                      return ListTile(
                        leading: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: colorScheme.outlineVariant),
                          ),
                        ),
                        title: Text(
                          S.current.screensReaderWidgetsReaderPdfAnnotationsListViewPage(annotation.pageNumber),
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                        subtitle: Text(
                          (annotation.noteText == null || annotation.noteText!.isEmpty)
                              ? 'No note'
                              : annotation.noteText!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (onEdit != null)
                              IconButton(
                                icon: const Icon(Icons.edit_outlined),
                                onPressed: () => onEdit!(annotation),
                                tooltip: S.current.screensReaderWidgetsReaderPdfAnnotationsListViewEditBookmark,
                              ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => onRemove(annotation),
                              tooltip: S.current.screensReaderWidgetsReaderPdfAnnotationsListViewDeleteAnnotation,
                            ),
                          ],
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
