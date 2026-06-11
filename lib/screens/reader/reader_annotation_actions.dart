part of 'reader.dart';

extension _ReaderAnnotationActions on _ReaderState {
  Future<void> _removeEpubAnnotation(FoliateAnnotation annotation) async {
    try {
      await epubController.deleteAnnotation(annotation);
      _readerSetState(() {
        _epubAnnotations.removeWhere((a) => a.value == annotation.value && a.type == annotation.type);
      });
      _scheduleAutoAnnotationSync(isEpubMode: true);
    } catch (e) {
      _showSnackBar('Error removing annotation: $e');
    }
  }

  Future<void> _editEpubAnnotation(FoliateAnnotation annotation, {String? noteText, String? color}) async {
    try {
      final updated = FoliateAnnotation(
        value: annotation.value,
        color: color ?? annotation.color,
        type: annotation.type,
        note: noteText ?? annotation.note,
      );
      await epubController.deleteAnnotation(annotation);
      await epubController.addAnnotation(updated);
      _readerSetState(() {
        final idx = _epubAnnotations.indexWhere((a) => a.value == annotation.value && a.type == annotation.type);
        if (idx >= 0) {
          _epubAnnotations[idx] = updated;
        }
      });
      _scheduleAutoAnnotationSync(isEpubMode: true);
    } catch (e) {
      _showSnackBar('Error editing annotation: $e');
    }
  }
}
