import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_epub_reader/flutter_epub_reader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:yaabsa/api/library_items/library_item.dart';
import 'package:yaabsa/api/me/bookmark.dart';
import 'package:yaabsa/api/me/request/create_bookmark_request.dart';
import 'package:yaabsa/api/me/user.dart';
import 'package:yaabsa/api/routes/abs_api.dart';
import 'package:yaabsa/models/internal_annotation.dart';
import 'package:yaabsa/provider/common/library_item_provider.dart';
import 'package:yaabsa/provider/common/media_progress_provider.dart';
import 'package:yaabsa/provider/core/user_providers.dart';
import 'package:yaabsa/screens/reader/models/pdf_annotation_entry.dart';
import 'package:yaabsa/screens/reader/widgets/reader_color_picker_sheet.dart';
import 'package:yaabsa/screens/reader/widgets/reader_epub_annotations_list_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_epub_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_pdf_annotations_list_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_pdf_view.dart';
import 'package:yaabsa/screens/reader/widgets/reader_thickness_picker_sheet.dart';
import 'package:yaabsa/util/logger.dart';

part 'reader_annotation_actions.dart';
part 'reader_annotation_sync.dart';
part 'reader_builders.dart';
part 'reader_core_helpers.dart';
part 'reader_pdf_helpers.dart';

const List<Color> _kHighlightColors = [
  Colors.yellow,
  Colors.green,
  Colors.blue,
  Colors.pink,
  Colors.orange,
  Colors.purple,
  Colors.transparent,
];

const List<double> _kUnderlineThickness = [1.0, 2.0, 3.0, 4.0, 6.0];

const Duration _kSnackBarDuration = Duration(seconds: 2);

enum _ReaderRenderMode { epub, pdf }

class Reader extends ConsumerStatefulWidget {
  const Reader({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<Reader> createState() => _ReaderState();
}

class _ReaderState extends ConsumerState<Reader> {
  final EpubController epubController = EpubController();
  final PdfViewerController _pdfController = PdfViewerController();

  int? _lastSyncedPdfPageNumber;
  List<PdfPageTextRange> _selectedPdfRanges = const <PdfPageTextRange>[];
  List<PdfAnnotationEntry> _pdfAnnotations = const <PdfAnnotationEntry>[];
  String? _hoveredPdfAnnotationCfi;
  String? _activePdfAnnotationCfi;

  Color _lastHighlightColor = Colors.yellow;
  Color _lastUnderlineColor = Colors.blue;
  double _lastUnderlineThickness = 2.0;
  Color _lastBookmarkColor = Colors.yellow;

  String? _selectedCfi;
  String? _selectedText;
  String? _resolvedEbookLocation;
  int _progressRefreshToken = 0;
  Timer? _annotationsSyncDebounce;
  bool _autoAnnotationLoadStarted = false;
  bool _isApplyingRemoteAnnotations = false;
  bool _annotationSyncInFlight = false;

  void _readerSetState(VoidCallback update) {
    if (!mounted) {
      return;
    }

    setState(update);
  }

  @override
  void initState() {
    super.initState();
    unawaited(_refreshStoredProgress());
  }

  @override
  void didUpdateWidget(covariant Reader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.itemId != widget.itemId) {
      _resetPdfState();
      _clearSelection();
      _resolvedEbookLocation = null;
      _autoAnnotationLoadStarted = false;
      _isApplyingRemoteAnnotations = false;
      _annotationSyncInFlight = false;
      _annotationsSyncDebounce?.cancel();
      unawaited(_refreshStoredProgress());
    }
  }

  @override
  void dispose() {
    _annotationsSyncDebounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final itemAsync = ref.watch(libraryItemProvider(widget.itemId));
    final currentProgress = ref.watch(
      mediaProgressProvider.select((asyncValue) {
        return asyncValue.value?[widget.itemId];
      }),
    );
    final effectiveInitialLocation = _resolvedEbookLocation ?? currentProgress?.ebookLocation;

    final bool isEpubMode = itemAsync.maybeWhen(
      data: (item) => _resolveReaderMode(item) == _ReaderRenderMode.epub,
      orElse: () => true,
    );

    return Scaffold(
      appBar: _buildAppBar(isEpubMode: isEpubMode),
      body: itemAsync.when(
        data: (item) {
          return userAsync.when(
            data: (user) {
              if (user == null) {
                return const Center(child: Text('No authenticated user available.'));
              }

              final authToken = user.preferredAuthToken;
              if (authToken == null || authToken.isEmpty) {
                return const Center(child: Text('Missing authentication token for ebook loading.'));
              }

              final mode = _resolveReaderMode(item);
              if (mode == _ReaderRenderMode.pdf) {
                return _buildPdfReaderBody(user: user, authToken: authToken, initialLocation: effectiveInitialLocation);
              }

              return _buildEpubReaderBody(user: user, authToken: authToken, initialCfi: effectiveInitialLocation);
            },
            error: (error, stackTrace) {
              return Center(child: Text('Failed to load user profile: $error'));
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Failed to load ebook metadata: $error'));
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
