part of 'reader.dart';

extension _ReaderAnnotationSync on _ReaderState {
  Future<void> _syncAnnotations({required bool isEpubMode, bool showFeedback = true}) async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      if (showFeedback) {
        _showSnackBar('API not available');
      }
      return;
    }

    if (_annotationSyncInFlight) {
      return;
    }

    _annotationSyncInFlight = true;

    try {
      await _fetchLatestBookmarks();

      final List<InternalAnnotation> annotations;
      if (isEpubMode) {
        annotations = _epubAnnotations.map((a) {
          return InternalAnnotation(
            cfi: a.value,
            color: a.color,
            type: a.type == 'underline'
                ? AnnotationType.underline
                : a.type == 'bookmark'
                ? AnnotationType.bookmark
                : AnnotationType.highlight,
            text: a.note,
          );
        }).toList();
      } else {
        annotations = _pdfAnnotations.map((annotation) => annotation.toInternalAnnotation()).toList(growable: false);
      }

      final payload = annotations.map(_annotationToCompactJson).toList(growable: false);

      await api.getMeApi().createBookmark(
        widget.itemId,
        createBookmarkRequest: CreateBookmarkRequest(time: -1, title: jsonEncode(payload)),
      );

      await _fetchLatestBookmarks();
      if (showFeedback) {
        _showSnackBar('Annotations synced');
      }
    } catch (e, s) {
      logger(
        'Failed to sync annotations for ${widget.itemId}: $e\n$s',
        tag: 'ReaderAnnotations',
        level: InfoLevel.error,
      );
      if (showFeedback) {
        _showSnackBar('Failed to sync annotations: $e');
      }
    } finally {
      _annotationSyncInFlight = false;
    }
  }

  Future<bool> _loadAnnotationsFromApi({required bool isEpubMode, bool showFeedback = true}) async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      if (showFeedback) {
        _showSnackBar('API not available');
      }
      return false;
    }

    final List<Bookmark> bookmarks;
    try {
      bookmarks = await _fetchLatestBookmarks();
    } catch (e) {
      if (showFeedback) {
        _showSnackBar('Failed to load annotations from server: $e');
      }
      return false;
    }

    final annotationBookmarks = bookmarks
        .where((bookmark) => bookmark.libraryItemId == widget.itemId && bookmark.time == -1)
        .toList(growable: false);
    if (annotationBookmarks.isEmpty) {
      if (showFeedback) {
        _showSnackBar('No annotations found for this item');
      }
      return true;
    }

    Bookmark bookmark = annotationBookmarks.first;
    for (final candidate in annotationBookmarks.skip(1)) {
      if (candidate.createdAt > bookmark.createdAt) {
        bookmark = candidate;
      }
    }

    final dynamic decodedPayload;
    try {
      decodedPayload = jsonDecode(bookmark.title);
    } catch (e) {
      if (showFeedback) {
        _showSnackBar('Stored annotations are invalid: $e');
      }
      return true;
    }

    if (decodedPayload is! List) {
      if (showFeedback) {
        _showSnackBar('Stored annotations are invalid');
      }
      return true;
    }

    final annotations = <InternalAnnotation>[];
    for (final value in decodedPayload) {
      if (value is! Map) {
        continue;
      }

      try {
        annotations.add(InternalAnnotation.fromJson(Map<String, dynamic>.from(value)));
      } catch (_) {}
    }

    if (annotations.isEmpty) {
      if (showFeedback) {
        _showSnackBar('No valid annotations found for this item');
      }
      return true;
    }

    if (!isEpubMode) {
      final parsedPdfAnnotations = annotations
          .where(_isPdfAnnotation)
          .map(PdfAnnotationEntry.fromInternalAnnotation)
          .whereType<PdfAnnotationEntry>()
          .toList(growable: false);

      _readerSetState(() {
        _pdfAnnotations = parsedPdfAnnotations;
      });

      if (showFeedback) {
        _showSnackBar(
          parsedPdfAnnotations.isEmpty
              ? 'No PDF annotations found for this item'
              : 'Loaded ${parsedPdfAnnotations.length} PDF annotations',
        );
      }

      return true;
    }

    final epubAnnotations = annotations.where((annotation) => !_isPdfAnnotation(annotation)).toList(growable: false);
    if (epubAnnotations.isEmpty) {
      if (showFeedback) {
        _showSnackBar('No EPUB annotations found for this item');
      }
      return true;
    }

    try {
      _isApplyingRemoteAnnotations = true;

      final parsedEpubAnnotations = epubAnnotations.map((a) {
        return FoliateAnnotation(
          value: a.cfi,
          color: a.color ?? 'none',
          type: a.type == AnnotationType.underline
              ? 'underline'
              : a.type == AnnotationType.bookmark
              ? 'bookmark'
              : 'highlight',
          note: a.text,
        );
      }).toList();

      _readerSetState(() {
        _epubAnnotations = parsedEpubAnnotations;
      });

      for (final annotation in parsedEpubAnnotations) {
        await epubController.addAnnotation(annotation);
      }
    } catch (e, s) {
      logger(
        'Failed to apply EPUB annotations for ${widget.itemId}: $e\n$s',
        tag: 'ReaderAnnotations',
        level: InfoLevel.error,
      );
      if (showFeedback) {
        _showSnackBar('Failed to apply EPUB annotations: $e');
      }
      return false;
    } finally {
      _isApplyingRemoteAnnotations = false;
    }

    if (showFeedback) {
      _showSnackBar('Loaded EPUB annotations');
    }

    return true;
  }
}
