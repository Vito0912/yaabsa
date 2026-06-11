part of 'reader.dart';

extension _ReaderCoreHelpers on _ReaderState {
  Future<void> _refreshStoredProgress() async {
    final requestToken = ++_progressRefreshToken;
    final progress = await ref.read(mediaProgressProvider.notifier).fetchOrRefreshIndividualProgress(widget.itemId);
    if (!mounted || requestToken != _progressRefreshToken) {
      return;
    }

    final refreshedLocation = progress?.ebookLocation;
    if (_resolvedEbookLocation == refreshedLocation) {
      return;
    }

    _readerSetState(() {
      _resolvedEbookLocation = refreshedLocation;
    });
  }

  void _resetPdfState() {
    _lastSyncedPdfPageNumber = null;
    _pdfAnnotations = const <PdfAnnotationEntry>[];
    _hoveredPdfAnnotationCfi = null;
  }

  String _ebookUrl(User user) {
    return '${user.server!.url}/api/items/${widget.itemId}/ebook';
  }

  String _normalizeEbookFormat(String? format) {
    return format?.trim().toLowerCase() ?? '';
  }

  _ReaderRenderMode _resolveReaderMode(LibraryItem item) {
    final bookMedia = item.media?.bookMedia;
    final candidates = <String?>[
      bookMedia?.ebookFile?.ebookFormat,
      bookMedia?.ebookFormat,
      bookMedia?.ebookFile?.metadata.ext,
    ];

    for (final candidate in candidates) {
      final normalized = _normalizeEbookFormat(candidate);
      if (normalized.isEmpty) {
        continue;
      }

      if (normalized == 'pdf') {
        return _ReaderRenderMode.pdf;
      }
      if (normalized == 'epub') {
        return _ReaderRenderMode.epub;
      }
    }

    return _ReaderRenderMode.epub;
  }

  int _parseStoredPdfPage(String? ebookLocation) {
    if (ebookLocation == null || ebookLocation.trim().isEmpty) {
      return 1;
    }

    final page = int.tryParse(ebookLocation.trim());
    if (page == null || page < 1) {
      return 1;
    }

    return page;
  }

  String _colorToHex(Color color, {bool allowNone = false}) {
    if (allowNone && color == Colors.transparent) return 'none';
    final argb = color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase();
    return '#${argb.substring(2)}';
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: _kSnackBarDuration));
  }

  bool _isPdfAnnotation(InternalAnnotation annotation) {
    return isPdfAnnotationCfi(annotation.cfi);
  }

  Color _parseStoredColor(String? color, {required Color fallback}) {
    if (color == null || color.isEmpty) {
      return fallback;
    }
    if (color == 'none') {
      return Colors.transparent;
    }
    if (!color.startsWith('#') || color.length != 7) {
      return fallback;
    }

    final parsed = int.tryParse(color.substring(1), radix: 16);
    if (parsed == null) {
      return fallback;
    }

    return Color(0xFF000000 | parsed);
  }

  Color _applyOpacity(Color color, double opacity) {
    final alpha = (opacity.clamp(0.0, 1.0) * 255).round();
    return color.withAlpha(alpha);
  }

  Map<String, dynamic> _annotationToCompactJson(InternalAnnotation annotation) {
    final compact = Map<String, dynamic>.from(annotation.toJson());
    compact.removeWhere((key, value) {
      if (value == null) {
        return true;
      }

      return key == 'text' && value is String && value.trim().isEmpty;
    });
    return compact;
  }

  Future<List<Bookmark>> _fetchLatestBookmarks() async {
    final ABSApi? api = ref.read(absApiProvider);
    if (api == null) {
      throw Exception('API not available');
    }

    final userResponse = await api.getMeApi().getUser();
    return userResponse.data?.bookmarks ?? const <Bookmark>[];
  }

  void _scheduleAutoAnnotationSync({required bool isEpubMode}) {
    if (_isApplyingRemoteAnnotations) {
      return;
    }

    _annotationsSyncDebounce?.cancel();
    _annotationsSyncDebounce = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      unawaited(_syncAnnotations(isEpubMode: isEpubMode, showFeedback: false));
    });
  }

  void _triggerAutoAnnotationLoadIfNeeded({required bool isEpubMode}) {
    if (_autoAnnotationLoadStarted) {
      return;
    }

    _autoAnnotationLoadStarted = true;
    unawaited(() async {
      final loaded = await _loadAnnotationsFromApi(isEpubMode: isEpubMode, showFeedback: false);
      if (!loaded && mounted && isEpubMode) {
        _autoAnnotationLoadStarted = false;
      }
    }());
  }

  Future<void> _syncEpubProgress({required String location, required double progress}) async {
    if (!mounted) return;
    if (location.trim().isEmpty) {
      return;
    }

    ref
        .read(mediaProgressProvider.notifier)
        .applyLocalEbookProgressUpdate(libraryItemId: widget.itemId, ebookLocation: location, ebookProgress: progress);

    _throttleProgressSync(location: location, progress: progress);
  }

  Future<void> _syncPdfProgress({required int pageNumber}) async {
    if (!mounted) return;
    if (pageNumber < 1 || _lastSyncedPdfPageNumber == pageNumber) {
      return;
    }

    if (!_pdfController.isReady) {
      return;
    }

    final pageCount = _pdfController.pageCount;
    final progress = pageCount <= 0 ? 0.0 : (pageNumber / pageCount).clamp(0.0, 1.0).toDouble();
    _lastSyncedPdfPageNumber = pageNumber;

    _readerSetState(() {
      _currentPdfPage = pageNumber;
    });

    ref
        .read(mediaProgressProvider.notifier)
        .applyLocalEbookProgressUpdate(
          libraryItemId: widget.itemId,
          ebookLocation: '$pageNumber',
          ebookProgress: progress,
        );

    _throttleProgressSync(location: '$pageNumber', progress: progress);

    if (_waitingForTtsPageLoad) {
      _waitingForTtsPageLoad = false;
      if (mounted && _isTtsPlaying) {
        unawaited(_startTts(isEpubMode: false));
      }
    }
  }

  void _onEpubRelocated(FoliateLocation location) {
    if (!mounted) return;
    final currentLocation = location.cfi;
    if (currentLocation == null || _lastSyncedEpubCfi == currentLocation) {
      return;
    }

    _lastSyncedEpubCfi = currentLocation;

    _readerSetState(() {
      _currentEpubLocation = location;
    });

    _triggerAutoAnnotationLoadIfNeeded(isEpubMode: true);
    unawaited(_syncEpubProgress(location: currentLocation, progress: location.fraction));

    if (_waitingForTtsPageLoad) {
      _waitingForTtsPageLoad = false;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted && _isTtsPlaying) {
          unawaited(_startTts(isEpubMode: true));
        }
      });
    }

    logger(
      'Epub relocated: $currentLocation, progress: ${location.fraction}',
      level: InfoLevel.debug,
      tag: 'EpubReader',
    );
  }
}
